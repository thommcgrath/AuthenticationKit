#tag Class
Protected Class ValidationTester
Implements AuthenticationKit.Validator
	#tag Method, Flags = &h0
		Sub Constructor()
		  Self.Users = New Xojo.Core.Dictionary
		  Self.Salts = New Xojo.Core.Dictionary
		End Sub
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

	#tag Method, Flags = &h0
		Function LookupSalt(Hash As Xojo.Core.MemoryBlock) As Xojo.Core.MemoryBlock
		  // Part of the AuthenticationKit.Validator interface.
		  
		  Dim TextHash As Text = Self.EncodeHex(Hash)
		  If Self.Salts.HasKey(TextHash) Then
		    Return Self.Salts.Value(TextHash)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LookupUser(LoginKey As Text) As AuthenticationKit.User
		  // Part of the AuthenticationKit.Validator interface.
		  
		  If Self.Users.HasKey(LoginKey) Then
		    Return Self.Users.Value(LoginKey)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Save(Users() As AuthenticationKit.User, Tokens() As AuthenticationKit.Token) As Boolean
		  // Part of the AuthenticationKit.Validator interface.
		  
		  For Each User As AuthenticationKit.User In Users
		    Self.Users.Value(User.LoginKey) = New SampleUser(User)
		  Next
		  For Each Token As AuthenticationKit.Token In Tokens
		    Self.Salts.Value(Self.EncodeHex(Token.Hash)) = Token.Salt
		  Next
		  Return True
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private Salts As Xojo.Core.Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Users As Xojo.Core.Dictionary
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
