#tag Module
Protected Module AuthenticationKit
	#tag Method, Flags = &h0
		Function AddBogusTokens(Extends Validator As AuthenticationKit.Validator, NumRecords As UInteger, ByteCount As UInteger) As Boolean
		  Dim Tokens() As AuthenticationKit.Token
		  For I As Integer = 1 To NumRecords
		    Tokens.Append(New AuthenticationKit.Token(ByteCount))
		  Next
		  Return Validator.Save(Tokens)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ByteCount(Algorithm As Xojo.Crypto.HashAlgorithms) As UInteger
		  Dim Hash As Xojo.Core.MemoryBlock = Xojo.Crypto.Hash(New Xojo.Core.MemoryBlock(1), Algorithm)
		  Return Hash.Size
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = (not TargetHasGUI and not TargetWeb and not TargetIOS) or  (TargetWeb) or  (TargetHasGUI)
		Private Function ConvertMemoryBlock(InData As Global.MemoryBlock) As Xojo.Core.MemoryBlock
		  Dim OutData As New Xojo.Core.MutableMemoryBlock(InData.Size)
		  OutData.LittleEndian = InData.LittleEndian
		  
		  For I As Integer = 0 To OutData.Size - 1
		    OutData.UInt8Value(I) = InData.UInt8Value(I)
		  Next
		  
		  Return OutData
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = (not TargetHasGUI and not TargetWeb and not TargetIOS) or  (TargetWeb) or  (TargetHasGUI)
		Private Function ConvertMemoryBlock(InData As Xojo.Core.MemoryBlock) As Global.MemoryBlock
		  Dim OutData As New Global.MemoryBlock(InData.Size)
		  OutData.LittleEndian = InData.LittleEndian
		  
		  For I As Integer = 0 To OutData.Size - 1
		    OutData.UInt8Value(I) = InData.UInt8Value(I)
		  Next
		  
		  Return OutData
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function PBKDF2(Salt As Xojo.Core.MemoryBlock, Data As Xojo.Core.MemoryBlock, Iterations As UInt32, DesiredHashLength As UInteger, HashAlgorithm As Xojo.Crypto.HashAlgorithms) As Xojo.Core.MemoryBlock
		  // This method exists solely to work around <feedback://showreport?report_id=44857>
		  
		  #if TargetWin32
		    Dim ClassicSalt As Global.MemoryBlock = AuthenticationKit.ConvertMemoryBlock(Salt)
		    Dim ClassicData As Global.MemoryBlock = AuthenticationKit.ConvertMemoryBlock(Data)
		    Dim ClassicAlgorithm As Crypto.Algorithm
		    Select Case HashAlgorithm
		    Case Xojo.Crypto.HashAlgorithms.MD5
		      ClassicAlgorithm = Crypto.Algorithm.MD5
		    Case Xojo.Crypto.HashAlgorithms.SHA1
		      ClassicAlgorithm = Crypto.Algorithm.SHA1
		    Case Xojo.Crypto.HashAlgorithms.SHA256
		      ClassicAlgorithm = Crypto.Algorithm.SHA256
		    Case Xojo.Crypto.HashAlgorithms.SHA512
		      ClassicAlgorithm = Crypto.Algorithm.SHA512
		    End Select
		    
		    Dim ClassicHash As Global.MemoryBlock = Crypto.PBKDF2(ClassicSalt, ClassicData, Iterations, DesiredHashLength, ClassicAlgorithm)
		    Return AuthenticationKit.ConvertMemoryBlock(ClassicHash)
		  #else
		    Return Xojo.Crypto.PBKDF2(Salt, Data, Iterations, DesiredHashLength, HashAlgorithm)
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Save(Extends Validator As AuthenticationKit.Validator, Tokens() As AuthenticationKit.Token) As Boolean
		  Dim Users() As AuthenticationKit.User
		  Return Validator.Save(Users, Tokens)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Save(Extends Validator As AuthenticationKit.Validator, User As AuthenticationKit.User, Tokens() As AuthenticationKit.Token) As Boolean
		  Dim Users(0) As AuthenticationKit.User
		  Users(0) = User
		  Return Validator.Save(Users, Tokens)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SetPassword(Extends User As AuthenticationKit.MutableUser, Password As Text, Iterations As UInteger, Algorithm As Xojo.Crypto.HashAlgorithms) As AuthenticationKit.Token()
		  // Sets password and removes two factor authentication
		  
		  Dim Hasher As New AuthenticationKit.HashGenerator
		  Hasher.Password = Password
		  Hasher.Iterations = Iterations
		  Hasher.Algorithm = Algorithm
		  Hasher.TwoFactorEnabled = False
		  
		  Dim Tokens() As AuthenticationKit.Token = Hasher.Generate()
		  User.SetSecurityDetails(Hasher.Iterations, Hasher.Algorithm, Hasher.ValidationHash, Hasher.PasswordSalt, Hasher.SecondFactorSalt)
		  
		  Return Tokens
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SetPassword(Extends User As AuthenticationKit.MutableUser, Password As Text, Iterations As UInteger, Algorithm As Xojo.Crypto.HashAlgorithms, ByRef Generator As AuthenticationKit.TwoFactorProfile) As AuthenticationKit.Token()
		  // Sets password and enables two factor authentication. A nil generator will
		  // create a new generator, a non-nil generator will use that generator.
		  
		  Dim Hasher As New AuthenticationKit.HashGenerator
		  Hasher.Password = Password
		  Hasher.Iterations = Iterations
		  Hasher.Algorithm = Algorithm
		  Hasher.TwoFactorEnabled = True
		  Hasher.TwoFactorProfile = Generator
		  
		  Dim Tokens() As AuthenticationKit.Token = Hasher.Generate()
		  User.SetSecurityDetails(Hasher.Iterations, Hasher.Algorithm, Hasher.ValidationHash, Hasher.PasswordSalt, Hasher.SecondFactorSalt)
		  Generator = Hasher.TwoFactorProfile
		  
		  Return Tokens
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ValidatePassword(Extends Validator As AuthenticationKit.Validator, User As AuthenticationKit.User, Password As Text, ByRef Generator As AuthenticationKit.TwoFactorProfile) As Boolean
		  Generator = Nil
		  
		  Dim PassBytes As Xojo.Core.MemoryBlock = Xojo.Core.TextEncoding.UTF32BigEndian.ConvertTextToData(Password)
		  Dim ByteCount As UInteger = AuthenticationKit.ByteCount(User.Algorithm)
		  
		  Dim ComputedHash As Xojo.Core.MemoryBlock = AuthenticationKit.PBKDF2(User.PasswordSalt, PassBytes, User.Iterations, ByteCount, User.Algorithm)
		  Dim ValidationSalt As Xojo.Core.MemoryBlock = Validator.LookupSalt(ComputedHash)
		  If ValidationSalt = Nil Then
		    Return False
		  End If
		  
		  Dim ValidationHash As Xojo.Core.MemoryBlock = AuthenticationKit.PBKDF2(ValidationSalt, PassBytes, User.Iterations, ByteCount, User.Algorithm)
		  If ValidationHash <> User.ValidationHash Then
		    Return False
		  End If
		  
		  If Not User.TwoFactorEnabled Then
		    Return True
		  End If
		  
		  Dim SecretHash As Xojo.Core.MemoryBlock = AuthenticationKit.PBKDF2(User.SecondFactorSalt, PassBytes, User.Iterations, ByteCount, User.Algorithm)
		  Dim StoredSecret As Xojo.Core.MemoryBlock = Validator.LookupSalt(SecretHash)
		  If StoredSecret = Nil Then
		    Return False
		  End If
		  
		  Generator = New AuthenticationKit.TwoFactorProfile(StoredSecret)
		  Return True
		End Function
	#tag EndMethod


	#tag Note, Name = Documentation
		
		Documentation can be found at http://docs.thezaz.com/authenticationkit/1.0.0
	#tag EndNote

	#tag Note, Name = Version
		
		1.0.1
	#tag EndNote


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
End Module
#tag EndModule
