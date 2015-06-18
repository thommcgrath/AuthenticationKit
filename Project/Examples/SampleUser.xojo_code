#tag Class
Protected Class SampleUser
Implements AuthenticationKit.User
	#tag Method, Flags = &h0
		Function Algorithm() As Xojo.Crypto.HashAlgorithms
		  Return Self.mHashAlgorithm
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Source As AuthenticationKit.User)
		  Self.mHash = New Xojo.Core.MemoryBlock(Source.ValidationHash)
		  Self.mHashAlgorithm = Source.Algorithm
		  Self.mIterationCount = Source.Iterations
		  Self.mLoginKey = Source.LoginKey
		  Self.mSalt = New Xojo.Core.MemoryBlock(Source.PasswordSalt)
		  Self.mUserID = Source.UserID
		  
		  If Source.SecondFactorSalt <> Nil Then
		    Self.mSecretSalt = New Xojo.Core.MemoryBlock(Source.SecondFactorSalt)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(UserID As Auto, LoginKey As Text, Iterations As UInteger, Algorithm As Xojo.Crypto.HashAlgorithms, Salt As Xojo.Core.MemoryBlock, Hash As Xojo.Core.MemoryBlock, Secret As Xojo.Core.MemoryBlock)
		  Self.mUserID = UserID
		  Self.mLoginKey = LoginKey
		  Self.mIterationCount = Iterations
		  Self.mHashAlgorithm = Algorithm
		  Self.mSalt = New Xojo.Core.MemoryBlock(Salt)
		  Self.mHash = New Xojo.Core.MemoryBlock(Hash)
		  If Secret <> Nil Then
		    Self.mSecretSalt = New Xojo.Core.MemoryBlock(Secret)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Edited() As Boolean
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Iterations() As UInteger
		  Return Self.mIterationCount
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LoginKey() As Text
		  Return Self.mLoginKey
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PasswordSalt() As Xojo.Core.MemoryBlock
		  Return Self.mSalt
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SecondFactorSalt() As Xojo.Core.MemoryBlock
		  Return Self.mSecretSalt
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TwoFactorEnabled() As Boolean
		  Return Self.mSecretSalt <> Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function UserID() As Auto
		  Return Self.mUserID
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ValidationHash() As Xojo.Core.MemoryBlock
		  Return Self.mHash
		End Function
	#tag EndMethod


	#tag Property, Flags = &h1
		Protected mHash As Xojo.Core.MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mHashAlgorithm As Xojo.Crypto.HashAlgorithms
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mIterationCount As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mLoginKey As Text
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mSalt As Xojo.Core.MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mSecretSalt As Xojo.Core.MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mUserID As Auto
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
