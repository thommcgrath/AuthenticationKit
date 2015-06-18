#tag Interface
Protected Interface Validator
	#tag Method, Flags = &h0
		Function LookupSalt(Hash As Xojo.Core.MemoryBlock) As Xojo.Core.MemoryBlock
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LookupUser(LoginKey As Text) As AuthenticationKit.User
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Save(Users() As AuthenticationKit.User, Tokens() As AuthenticationKit.Token) As Boolean
		  
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
