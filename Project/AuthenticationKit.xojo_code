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
		Function SetPassword(Extends User As AuthenticationKit.MutableUser, Password As Text, Iterations As UInteger, Algorithm As Xojo.Crypto.HashAlgorithms, ByRef Generator As AuthenticationKit.SecondFactorGenerator) As AuthenticationKit.Token()
		  // Sets password and enables two factor authentication. A nil generator will
		  // create a new generator, a non-nil generator will use that generator.
		  
		  Dim Hasher As New AuthenticationKit.HashGenerator
		  Hasher.Password = Password
		  Hasher.Iterations = Iterations
		  Hasher.Algorithm = Algorithm
		  Hasher.TwoFactorEnabled = True
		  Hasher.SecondFactorGenerator = Generator
		  
		  Dim Tokens() As AuthenticationKit.Token = Hasher.Generate()
		  User.SetSecurityDetails(Hasher.Iterations, Hasher.Algorithm, Hasher.ValidationHash, Hasher.PasswordSalt, Hasher.SecondFactorSalt)
		  Generator = Hasher.SecondFactorGenerator
		  
		  Return Tokens
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ValidatePassword(Extends Validator As AuthenticationKit.Validator, User As AuthenticationKit.User, Password As Text, ByRef Generator As AuthenticationKit.SecondFactorGenerator) As Boolean
		  Generator = Nil
		  
		  Dim PassBytes As Xojo.Core.MemoryBlock = Xojo.Core.TextEncoding.UTF32BigEndian.ConvertTextToData(Password)
		  Dim ByteCount As UInteger = AuthenticationKit.ByteCount(User.Algorithm)
		  
		  Dim ComputedHash As Xojo.Core.MemoryBlock = Xojo.Crypto.PBKDF2(User.PasswordSalt, PassBytes, User.Iterations, ByteCount, User.Algorithm)
		  Dim ValidationSalt As Xojo.Core.MemoryBlock = Validator.LookupSalt(ComputedHash)
		  If ValidationSalt = Nil Then
		    Return False
		  End If
		  
		  Dim ValidationHash As Xojo.Core.MemoryBlock = Xojo.Crypto.PBKDF2(ValidationSalt, PassBytes, User.Iterations, ByteCount, User.Algorithm)
		  If ValidationHash <> User.ValidationHash Then
		    Return False
		  End If
		  
		  If Not User.TwoFactorEnabled Then
		    Return True
		  End If
		  
		  Dim SecretHash As Xojo.Core.MemoryBlock = Xojo.Crypto.PBKDF2(User.SecondFactorSalt, PassBytes, User.Iterations, ByteCount, User.Algorithm)
		  Dim StoredSecret As Xojo.Core.MemoryBlock = Validator.LookupSalt(SecretHash)
		  If StoredSecret = Nil Then
		    Return False
		  End If
		  
		  Generator = New AuthenticationKit.SecondFactorGenerator(StoredSecret)
		  Return True
		End Function
	#tag EndMethod


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
