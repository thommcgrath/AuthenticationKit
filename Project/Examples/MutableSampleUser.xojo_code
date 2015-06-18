#tag Class
Protected Class MutableSampleUser
Inherits SampleUser
Implements AuthenticationKit.MutableUser
	#tag Method, Flags = &h0
		Sub Constructor(UserID As Auto)
		  Self.mUserID = UserID
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Edited() As Boolean
		  Return Self.mEdited
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LoginKey(Assigns Value As Text)
		  If Self.mLoginKey.Compare(Value, Text.CompareCaseSensitive) <> 0 Then
		    Self.mLoginKey = Value
		    Self.mEdited = True
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetSecurityDetails(Iterations As UInteger, Algorithm As Xojo.Crypto.HashAlgorithms, ValidationHash As Xojo.Core.MemoryBlock, PasswordSalt As Xojo.Core.MemoryBlock, SecondFactorSalt As Xojo.Core.MemoryBlock)
		  // Part of the AuthenticationKit.MutableUser interface.
		  
		  Self.mIterationCount = Iterations
		  Self.mHashAlgorithm = Algorithm
		  Self.mHash = ValidationHash
		  Self.mSalt = PasswordSalt
		  Self.mSecretSalt = SecondFactorSalt
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Untitled()
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h1
		Protected mEdited As Boolean
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
