#tag Class
Protected Class Token
	#tag Method, Flags = &h0
		Sub Constructor(ByteCount As UInteger)
		  Self.Hash = Xojo.Crypto.GenerateRandomBytes(ByteCount)
		  Self.Salt = Xojo.Crypto.GenerateRandomBytes(ByteCount)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Hash As Xojo.Core.MemoryBlock, Salt As Xojo.Core.MemoryBlock)
		  Self.Hash = Hash
		  Self.Salt = Salt
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Hash As Xojo.Core.MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h0
		Salt As Xojo.Core.MemoryBlock
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
