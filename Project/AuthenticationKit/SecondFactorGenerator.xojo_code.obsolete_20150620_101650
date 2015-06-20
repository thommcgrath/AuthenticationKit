#tag Class
Protected Class SecondFactorGenerator
	#tag Method, Flags = &h21
		Private Shared Function Base32Encode(Source As Xojo.Core.MemoryBlock) As Text
		  If UBound(Alphabet) = -1 Then
		    Alphabet = Array("a", "b", "c", "d", "e", "f", "g",_
		    "h", "i", "j", "k", "l", "m", "n",_
		    "o", "p", "q", "r", "s", "t", "u",_
		    "v", "w", "x", "y", "z", "2", "3",_
		    "4", "5", "6", "7")
		  End If
		  
		  Dim Skip As Integer
		  Dim Bits As Byte
		  Dim Offset As Integer
		  Dim Chars() As Text
		  
		  While Offset < Source.Size
		    Dim Value As Byte = Source.UInt8Value(Offset)
		    If Skip < 0 Then
		      Bits = Bits Or CType(Value / (2 ^ (Skip * -1)), UInteger)
		    Else
		      Bits = CType(Value * (2 ^ Skip), UInteger) And 248
		    End If
		    
		    If Skip > 3 Then
		      Skip = Skip - 8
		      Offset = Offset + 1
		      Continue
		    End If
		    
		    If Skip < 4 Then
		      Chars.Append(Alphabet(Bits / 8))
		      Skip = Skip + 5
		    End If
		  Wend
		  
		  If Skip < 0 Then
		    Chars.Append(Alphabet(Bits / 8))
		  End If
		  
		  Dim Output As Text = Text.Join(Chars, "")
		  Return Output.Uppercase
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Secret As Xojo.Core.MemoryBlock)
		  Self.mSecret = New Xojo.Core.MemoryBlock(Secret)
		  Self.Digits = 6
		  Self.Digest = Xojo.Crypto.HashAlgorithms.SHA1
		  Self.Period = New Xojo.Core.DateInterval
		  Self.Period.Seconds = 30
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Generate() As UInteger
		  Return Self.Generate(Xojo.Core.Date.Now)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Generate(AtTime As Xojo.Core.Date) As UInteger
		  Dim Timestamp As UInt32 = Xojo.Math.Floor(AtTime.SecondsFrom1970 / Self.Period.Seconds)
		  Dim TimeChars() As UInt8
		  While Timestamp <> 0
		    TimeChars.Append(Timestamp And &hFF)
		    Timestamp = Timestamp / (2 ^ 8)
		  Wend
		  Dim Time As New Xojo.Core.MutableMemoryBlock(8)
		  For I As Integer = 0 To UBound(TimeChars)
		    Time.UInt8Value(Time.Size - (1 + I)) = TimeChars(I)
		  Next
		  
		  Dim Hash As Xojo.Core.MemoryBlock = Xojo.Crypto.HMAC(Self.mSecret, Time, Self.Digest)
		  Hash.LittleEndian = False
		  
		  Dim Offset As UInt8 = Hash.UInt8Value(Hash.Size - 1) And &hF
		  Dim Code As UInt32 = Hash.UInt32Value(Offset) And &h7FFFFFFF
		  Return Code Mod (10 ^ Self.Digits)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProvisioningURI(Label As Text, Issuer As Text = "") As Text
		  Dim URI As Text = "otpauth://totp/" + Self.URLEncode(If(Issuer <> "", Issuer + ":" + Label, Label))
		  
		  URI = URI + "?secret=" + Self.Base32Encode(Self.mSecret)
		  
		  If Issuer <> "" Then
		    URI = URI + "&issuer=" + Self.URLEncode(Issuer)
		  End If
		  
		  If Self.Digits <> 6 Then
		    URI = URI + "&digits=" + Self.Digits.ToText(Xojo.Core.Locale.Raw, "0")
		  End If
		  
		  Select Case Self.Digest
		  Case Xojo.Crypto.HashAlgorithms.MD5
		    Raise New Xojo.Core.UnsupportedOperationException
		  Case Xojo.Crypto.HashAlgorithms.SHA1
		    // Do nothing
		  Case Xojo.Crypto.HashAlgorithms.SHA256
		    URI = URI + "&algorithm=SHA256"
		  Case Xojo.Crypto.HashAlgorithms.SHA512
		    URI = URI + "&algorithm=SHA512"
		  End Select
		  
		  If Self.Period.Seconds <> 30 Then
		    URI = URI + "&period=" + Self.Period.Seconds.ToText(Xojo.Core.Locale.Raw, "0")
		  End If
		  
		  Return URI
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Secret() As Xojo.Core.MemoryBlock
		  Return New Xojo.Core.MemoryBlock(Self.mSecret)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function URLEncode(Source As Text) As Text
		  Dim Bytes As Xojo.Core.MemoryBlock = Xojo.Core.TextEncoding.UTF8.ConvertTextToData(Source)
		  Dim Chars() As Text
		  For I As Integer = 0 To Bytes.Size - 1
		    Dim Code As UInt8 = Bytes.UInt8Value(I)
		    Select Case Code
		    Case 48 To 57, 65 To 90, 97 To 122
		      Chars.Append(Text.FromUnicodeCodepoint(Code))
		    Else
		      Chars.Append("%" + Code.ToHex(2))
		    End Select
		  Next
		  Return Text.Join(Chars, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Verify(Code As UInteger) As Boolean
		  Dim Now As Xojo.Core.Date = Xojo.Core.Date.Now
		  Dim Past As Xojo.Core.Date = Now - Self.Period
		  Dim Future As Xojo.Core.Date = Now + Self.Period
		  Return Code = Self.Generate(Now) Or Code = Self.Generate(Past) Or Code = Self.Generate(Future)
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private Shared Alphabet() As Text
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mDigest
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Select Case Value
			  Case Xojo.Crypto.HashAlgorithms.SHA1, Xojo.Crypto.HashAlgorithms.SHA256, Xojo.Crypto.HashAlgorithms.SHA512
			    Self.mDigest = Value
			  Else
			    Raise New Xojo.Core.InvalidArgumentException
			  End Select
			End Set
		#tag EndSetter
		Digest As Xojo.Crypto.HashAlgorithms
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mDigits
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If Value = 6 Or Value = 8 Then
			    Self.mDigits = Value
			  Else
			    Raise New Xojo.Core.InvalidArgumentException
			  End If
			End Set
		#tag EndSetter
		Digits As UInteger
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mDigest As Xojo.Crypto.HashAlgorithms
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDigits As UInteger
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSecret As Xojo.Core.MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h0
		Period As Xojo.Core.DateInterval
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Digest"
			Group="Behavior"
			Type="Xojo.Crypto.HashAlgorithms"
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
