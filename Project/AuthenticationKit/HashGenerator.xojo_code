#tag Class
Private Class HashGenerator
	#tag Method, Flags = &h0
		Function Generate() As AuthenticationKit.Token()
		  Dim ByteCount As UInteger = AuthenticationKit.ByteCount(Self.Algorithm)
		  Dim PassBytes As Xojo.Core.MemoryBlock = Xojo.Core.TextEncoding.UTF32BigEndian.ConvertTextToData(Self.Password)
		  
		  Self.PasswordSalt = Xojo.Crypto.GenerateRandomBytes(ByteCount)
		  Dim Salt2 As Xojo.Core.MemoryBlock = Xojo.Crypto.GenerateRandomBytes(ByteCount)
		  
		  Dim Hash1 As Xojo.Core.MemoryBlock = AuthenticationKit.PBKDF2(PasswordSalt, PassBytes, Self.Iterations, ByteCount, Self.Algorithm)
		  Self.ValidationHash = AuthenticationKit.PBKDF2(Salt2, PassBytes, Self.Iterations, ByteCount, Self.Algorithm)
		  
		  Dim Tokens() As AuthenticationKit.Token
		  Tokens.Append(New AuthenticationKit.Token(Hash1, Salt2))
		  Dim BogusCount As UInteger = Xojo.Math.RandomInt(4, 12)
		  For I As Integer = 1 To BogusCount
		    Tokens.Append(New AuthenticationKit.Token(ByteCount))
		  Next
		  
		  If Self.TwoFactorEnabled Then
		    If Self.TwoFactorProfile = Nil Then
		      Self.TwoFactorProfile = New AuthenticationKit.TwoFactorProfile(Xojo.Crypto.GenerateRandomBytes(ByteCount))
		    End If
		    
		    Dim Secret As Xojo.Core.MemoryBlock = Self.TwoFactorProfile.Secret
		    Self.SecondFactorSalt = Xojo.Crypto.GenerateRandomBytes(ByteCount)
		    Dim SecretHash As Xojo.Core.MemoryBlock = AuthenticationKit.PBKDF2(Self.SecondFactorSalt, PassBytes, Self.Iterations, ByteCount, Self.Algorithm)
		    Dim Token As New AuthenticationKit.Token(SecretHash, Secret)
		    Tokens.Append(Token)
		  Else
		    Self.TwoFactorProfile = Nil
		    Self.SecondFactorSalt = Nil
		  End If
		  
		  Tokens.Shuffle()
		  
		  Return Tokens
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Algorithm As xojo.Crypto.HashAlgorithms
	#tag EndProperty

	#tag Property, Flags = &h0
		Iterations As UInteger
	#tag EndProperty

	#tag Property, Flags = &h0
		Password As Text
	#tag EndProperty

	#tag Property, Flags = &h0
		PasswordSalt As Xojo.Core.MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h0
		SecondFactorSalt As Xojo.Core.MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h0
		TwoFactorEnabled As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		TwoFactorProfile As AuthenticationKit.TwoFactorProfile
	#tag EndProperty

	#tag Property, Flags = &h0
		ValidationHash As Xojo.Core.MemoryBlock
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Algorithm"
			Group="Behavior"
			Type="xojo.Crypto.HashAlgorithms"
			EditorType="Enum"
			#tag EnumValues
				"0 - MD5"
				"1 - SHA1"
				"2 - SHA256"
				"3 - SHA512"
			#tag EndEnumValues
		#tag EndViewProperty
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
			Name="Password"
			Group="Behavior"
			Type="Text"
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
		#tag ViewProperty
			Name="TwoFactorEnabled"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
