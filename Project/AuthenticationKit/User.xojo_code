#tag Interface
Protected Interface User
	#tag Method, Flags = &h0
		Function Algorithm() As Xojo.Crypto.HashAlgorithms
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Iterations() As UInteger
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LoginKey() As Text
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PasswordSalt() As Xojo.Core.MemoryBlock
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SecondFactorSalt() As Xojo.Core.MemoryBlock
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TwoFactorEnabled() As Boolean
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function UserID() As Auto
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ValidationHash() As Xojo.Core.MemoryBlock
		  
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
End Interface
#tag EndInterface
