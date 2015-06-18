#tag Interface
Protected Interface MutableUser
Implements User
	#tag Method, Flags = &h0
		Sub LoginKey(Assigns Value As Text)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetSecurityDetails(Iterations As UInteger, Algorithm As Xojo.Crypto.HashAlgorithms, ValidationHash As Xojo.Core.MemoryBlock, PasswordSalt As Xojo.Core.MemoryBlock, SecondFactorSalt As Xojo.Core.MemoryBlock)
		  
		End Sub
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
End Interface
#tag EndInterface
