#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  #pragma Unused args
		  
		  Const SampleUserName = "Sample User"
		  Const SamplePassword = "correct horse battery staple"
		  Const UseSQLite = true
		  
		  #if UseSQLite
		    Dim Tester As New SQLiteUserStorage
		    Tester.DatabaseFile = GetFolderItem("Users.sqlite")
		    Dim IsNew As Boolean = Not Tester.DatabaseFile.Exists
		    If Not Tester.CreateDatabaseFile Then
		      Print("Unable to create database")
		      Return 0
		    End If
		    If IsNew Then
		      Tester.CreateTables()
		    End If
		  #else
		    Dim Tester As New ValidationTester
		  #endif
		  
		  Dim Iterations As UInteger = 1000
		  Dim Algorithm As Xojo.Crypto.HashAlgorithms = Xojo.Crypto.HashAlgorithms.SHA512
		  Dim Tokens() As AuthenticationKit.Token
		  Dim User As AuthenticationKit.User
		  Dim EditableUser As AuthenticationKit.MutableUser
		  Dim Generator As AuthenticationKit.TwoFactorProfile
		  
		  // First test is to create a user, set the password, and save it.
		  EditableUser = New MutableSampleUser(Self.CreateUUID)
		  EditableUser.LoginKey = SampleUserName
		  Tokens = EditableUser.SetPassword(SamplePassword, Iterations, Algorithm)
		  If Not Tester.Save(EditableUser, Tokens) Then
		    Print("Unable to save user")
		    Return 0
		  End If
		  
		  // Next we retrieve the user
		  User = Tester.LookupUser(SampleUserName)
		  If User = Nil Then
		    Print("Unable to find user")
		    Return 0
		  End If
		  
		  // Validate that the wrong password will not work
		  If Tester.ValidatePassword(User, CType(SamplePassword, Text).Uppercase, Generator) Then
		    Print("Incorrect password successfully validated")
		    Return 0
		  End If
		  
		  // Validate that the correct password will work
		  If Not Tester.ValidatePassword(User, SamplePassword, Generator) Then
		    Print("Unable to validate user password")
		    Return 0
		  End If
		  
		  // Since two factor authentication was not enabled, Generator should be nil
		  If Generator <> Nil Then
		    Print("Generator returned when not expected")
		    Return 0
		  End If
		  
		  // Make sure we can insert a bunch of bogus records
		  If Not Tester.AddBogusTokens(100, AuthenticationKit.ByteCount(User.Algorithm)) Then
		    Print("Unable to add a batch of bogus tokens")
		    Return 0
		  End If
		  
		  // Now we're going to edit the user and enable two factor authentication. Because
		  // Generator is nil, SetPassword will create a new generator for us.
		  EditableUser = New MutableSampleUser(User)
		  Tokens = EditableUser.SetPassword(SamplePassword, Iterations, Algorithm, Generator)
		  If Generator = Nil Then
		    Print("Generator not provided when requested")
		    Return 0
		  End If
		  
		  // Save the changes
		  If Not Tester.Save(EditableUser, Tokens) Then
		    Print("Unable to save user")
		    Return 0
		  End If
		  
		  // Output the provisioning uri so this can be confirmed
		  Print(Generator.ProvisioningURI(SampleUserName, "Test Validator"))
		  
		  // Make sure we can still locate the user after an update
		  User = Tester.LookupUser(SampleUserName)
		  If User = Nil Then
		    Print("Unable to find user")
		    Return 0
		  End If
		  
		  // Validate the password again...
		  If Not Tester.ValidatePassword(User, SamplePassword, Generator) Then
		    Print("Unable to validate user password")
		    Return 0
		  End If
		  
		  // ... which is required to provide a generator, since two factor is enabled.
		  If Generator = Nil Then
		    Print("No generator returned when expected")
		    Return 0
		  End If
		  
		  // Now the tester needs to use an official authenticator (such as Google Authenticator) to
		  // generate a code and input it.
		  Print("Please generate a code. Don't worry, you have time.")
		  Dim UserInput As String = Input
		  Dim Code As UInteger = Val(UserInput)
		  
		  // Make sure the code provided by the third party authenticator is correct
		  If Not Generator.Verify(Code) Then
		    Print("Code did not match")
		    Return 0
		  End If
		  
		  Print("All tests passed successfully")
		  
		End Function
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Function CreateUUID() As String
		  Dim RandomBytes As MemoryBlock = Crypto.GenerateRandomBytes(16)
		  RandomBytes.LittleEndian = False
		  
		  Dim Value As Byte = RandomBytes.UInt8Value(6)
		  Value = Value And CType(&b00001111, UInt8)
		  Value = Value Or CType(&b01000000, UInt8)
		  RandomBytes.UInt8Value(6) = Value
		  
		  Value = RandomBytes.UInt8Value(8)
		  Value = Value And CType(&b00111111, UInt8)
		  Value = Value Or CType(&b10000000, UInt8)
		  RandomBytes.UInt8Value(8) = Value
		  
		  Dim UUID As String = EncodeHex(RandomBytes.StringValue(0, RandomBytes.Size))
		  UUID = LeftB(UUID, 8) + "-" + MidB(UUID, 9, 4) + "-" + MidB(UUID, 13, 4) + "-" + MidB(UUID, 17, 4) + "-" + RightB(UUID, 12)
		  Return UUID
		End Function
	#tag EndMethod


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
