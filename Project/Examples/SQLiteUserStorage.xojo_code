#tag Class
Protected Class SQLiteUserStorage
Inherits SQLiteDatabase
Implements AuthenticationKit.Validator
	#tag CompatibilityFlags = ( not TargetHasGUI and not TargetWeb and not TargetIOS ) or ( TargetWeb ) or ( TargetHasGUI )
	#tag Method, Flags = &h0
		Sub CreateTables()
		  Self.SQLExecute("CREATE TABLE " + Self.EscapeIdentifier(Self.UserTableName) + " (UserID TEXT PRIMARY KEY, LoginKey TEXT NOT NULL, Iterations INTEGER NOT NULL DEFAULT 1000, Algorithm TEXT NOT NULL DEFAULT 'SHA512', Salt1 TEXT NOT NULL, Hash2 TEXT NOT NULL, Secret TEXT);")
		  Self.SQLExecute("CREATE UNIQUE INDEX " + Self.EscapeIdentifier(Self.UserTableName + "_LoginKey_IDX") + " ON " + Self.EscapeIdentifier(Self.UserTableName) + "(LoginKey);")
		  
		  Self.SQLExecute("CREATE TABLE " + Self.EscapeIdentifier(Self.PasswordTableName) + " (RowID INTEGER NOT NULL PRIMARY KEY, Hash1 TEXT NOT NULL, Salt2 TEXT NOT NULL);")
		  Self.SQLExecute("CREATE INDEX " + Self.EscapeIdentifier(Self.PasswordTableName + "_Hash1_IDX") + " ON " + Self.EscapeIdentifier(Self.PasswordTableName) + "(Hash1);")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function DecodeHex(Source As Text) As Xojo.Core.MemoryBlock
		  Dim Pieces() As Text = Source.Split()
		  Dim Bytes() As Byte
		  For I As Integer = 0 To UBound(Pieces) - 1 Step 2
		    Bytes.Append(UInt8.FromHex(Pieces(I) + Pieces(I + 1)))
		  Next
		  Return New Xojo.Core.MemoryBlock(Bytes)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function EncodeHex(Source As Xojo.Core.MemoryBlock) As Text
		  Dim Pieces() As Text
		  For I As Integer = 0 To Source.Size - 1
		    Dim Value As UInt8 = Source.UInt8Value(I)
		    Pieces.Append(Value.ToHex(2))
		  Next
		  Return Text.Join(Pieces, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function EscapeIdentifier(Identifier As String) As String
		  Return """" + ReplaceAll(Identifier, """", """""") + """"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LookupSalt(Hash As Xojo.Core.MemoryBlock) As Xojo.Core.MemoryBlock
		  // Part of the AuthenticationKit.Validator interface.
		  
		  Dim HashString As String = Self.EncodeHex(Hash)
		  Dim Statement As SQLitePreparedStatement = Self.Prepare("SELECT Salt2 FROM " + Self.EscapeIdentifier(Self.PasswordTableName) + " WHERE Hash1 = ?;")
		  Statement.BindType(0, SQLitePreparedStatement.SQLITE_TEXT)
		  Dim RS As RecordSet = Statement.SQLSelect(HashString)
		  If RS = Nil Or RS.RecordCount <> 1 Then
		    Return Nil
		  End If
		  
		  Dim SaltString As String = RS.Field("Salt2").StringValue
		  Return Self.DecodeHex(SaltString.ToText)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LookupUser(LoginKey As Text) As AuthenticationKit.User
		  // Part of the AuthenticationKit.Validator interface.
		  
		  Dim Statement As SQLitePreparedStatement = Self.Prepare("SELECT UserID, Iterations, Algorithm, Salt1, Hash2, Secret FROM " + Self.EscapeIdentifier(Self.UserTableName) + " WHERE LOWER(LoginKey) = ?;")
		  Statement.BindType(0, SQLitePreparedStatement.SQLITE_TEXT)
		  
		  Dim RS As RecordSet = Statement.SQLSelect(Lowercase(LoginKey))
		  If RS = Nil Or RS.RecordCount <> 1 Then
		    Return Nil
		  End If
		  
		  Dim Algorithm As Xojo.Crypto.HashAlgorithms
		  Select Case RS.Field("Algorithm").StringValue
		  Case "MD5"
		    Algorithm = Xojo.Crypto.HashAlgorithms.MD5
		  Case "SHA1"
		    Algorithm = Xojo.Crypto.HashAlgorithms.SHA1
		  Case "SHA256"
		    Algorithm = Xojo.Crypto.HashAlgorithms.SHA256
		  Case "SHA512"
		    Algorithm = Xojo.Crypto.HashAlgorithms.SHA512
		  End Select
		  
		  Dim UserID As String = RS.Field("UserID").StringValue
		  Dim Iterations As Integer = RS.Field("Iterations").IntegerValue
		  Dim Salt1 As Xojo.Core.MemoryBlock = Self.DecodeHex(RS.Field("Salt1").StringValue.ToText)
		  Dim Hash2 As Xojo.Core.MemoryBlock = Self.DecodeHex(RS.Field("Hash2").StringValue.ToText)
		  Dim Secret As Xojo.Core.MemoryBlock
		  If RS.Field("Secret").StringValue <> "" Then
		    Secret = Self.DecodeHex(RS.Field("Secret").StringValue.ToText)
		  End If
		  
		  Return New MutableSampleUser(UserID, LoginKey, Iterations, Algorithm, Salt1, Hash2, Secret)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Save(Users() As AuthenticationKit.User, Tokens() As AuthenticationKit.Token) As Boolean
		  // Part of the AuthenticationKit.Validator interface.
		  
		  Self.SQLExecute("BEGIN TRANSACTION;")
		  If Self.Error Then
		    Return False
		  End If
		  
		  Dim UserInsert As SQLitePreparedStatement = Self.Prepare("INSERT OR REPLACE INTO " + Self.EscapeIdentifier(Self.UserTableName) + " (UserID, LoginKey, Iterations, Algorithm, Salt1, Hash2, Secret) VALUES (?, ?, ?, ?, ?, ?, ?);")
		  If Self.Error Then
		    Self.SQLExecute("ROLLBACK TRANSACTION;")
		    Return False
		  End If
		  UserInsert.BindType(0, SQLitePreparedStatement.SQLITE_TEXT)
		  UserInsert.BindType(1, SQLitePreparedStatement.SQLITE_TEXT)
		  UserInsert.BindType(2, SQLitePreparedStatement.SQLITE_INTEGER)
		  UserInsert.BindType(3, SQLitePreparedStatement.SQLITE_TEXT)
		  UserInsert.BindType(4, SQLitePreparedStatement.SQLITE_TEXT)
		  UserInsert.BindType(5, SQLitePreparedStatement.SQLITE_TEXT)
		  UserInsert.BindType(6, SQLitePreparedStatement.SQLITE_TEXT)
		  
		  Dim UserLookup As SQLitePreparedStatement = Self.Prepare("SELECT UserID FROM " + Self.EscapeIdentifier(Self.UserTableName) + " WHERE LOWER(LoginKey) = ?;")
		  If Self.Error Then
		    Self.SQLExecute("ROLLBACK TRANSACTION;")
		    Return False
		  End If
		  UserLookup.BindType(0, SQLitePreparedStatement.SQLITE_TEXT)
		  
		  For Each User As AuthenticationKit.User In Users
		    // Make sure the login key is unique
		    Dim UserID As String = User.UserID
		    Dim LoginKey As String = User.LoginKey
		    Dim RS As RecordSet = UserLookup.SQLSelect(Lowercase(LoginKey))
		    If RS = Nil Then
		      Return False
		    End If
		    If RS.RecordCount = 1 Then
		      Dim StoredUserID As String = RS.Field("UserID").StringValue
		      If StoredUserID <> UserID Then
		        // Already taken
		        Return False
		      End If
		    End If
		    
		    Dim Iterations As Integer = User.Iterations
		    Dim Algorithm As String
		    Select Case User.Algorithm
		    Case Xojo.Crypto.HashAlgorithms.MD5
		      Algorithm = "MD5"
		    Case Xojo.Crypto.HashAlgorithms.SHA1
		      Algorithm = "SHA1"
		    Case Xojo.Crypto.HashAlgorithms.SHA256
		      Algorithm = "SHA256"
		    Case Xojo.Crypto.HashAlgorithms.SHA512
		      Algorithm = "SHA512"
		    End Select
		    Dim Salt1 As String = Self.EncodeHex(User.PasswordSalt)
		    Dim Hash2 As String = Self.EncodeHex(User.ValidationHash)
		    Dim SecretSalt As String
		    If User.TwoFactorEnabled Then
		      SecretSalt = Self.EncodeHex(User.SecondFactorSalt)
		    End If
		    
		    UserInsert.SQLExecute(UserID, LoginKey, Iterations, Algorithm, Salt1, Hash2, SecretSalt)
		    If Self.Error Then
		      Self.SQLExecute("ROLLBACK TRANSACTION;")
		      Return False
		    End If
		  Next
		  
		  Dim TokenInsert As SQLitePreparedStatement = Self.Prepare("INSERT INTO " + Self.EscapeIdentifier(Self.PasswordTableName) + " (Hash1, Salt2) VALUES (?, ?);")
		  If Self.Error Then
		    Self.SQLExecute("ROLLBACK TRANSACTION;")
		    Return False
		  End If
		  TokenInsert.BindType(0, SQLitePreparedStatement.SQLITE_TEXT)
		  TokenInsert.BindType(1, SQLitePreparedStatement.SQLITE_TEXT)
		  For Each Token As AuthenticationKit.Token In Tokens
		    Dim Hash1 As String = Self.EncodeHex(Token.Hash)
		    Dim Salt2 As String = Self.EncodeHex(Token.Salt)
		    TokenInsert.SQLExecute(Hash1, Salt2)
		    If Self.Error Then
		      Self.SQLExecute("ROLLBACK TRANSACTION;")
		      Return False
		    End If
		  Next
		  
		  Self.SQLExecute("COMMIT TRANSACTION;")
		  If Self.Error Then
		    Self.SQLExecute("ROLLBACK TRANSACTION;")
		    Return False
		  End If
		  
		  Return True
		End Function
	#tag EndMethod


	#tag Constant, Name = PasswordTableName, Type = String, Dynamic = False, Default = \"Passwords", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = UserTableName, Type = String, Dynamic = False, Default = \"Users", Scope = Protected
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="DatabaseFile"
			Visible=true
			Type="FolderItem"
			EditorType="FolderItem"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DebugMode"
			Visible=true
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="EncryptionKey"
			Visible=true
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LoadExtensions"
			Visible=true
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MultiUser"
			Visible=true
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ShortColumnNames"
			Visible=true
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ThreadYieldInterval"
			Visible=true
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Timeout"
			Visible=true
			Type="Double"
			EditorType="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
