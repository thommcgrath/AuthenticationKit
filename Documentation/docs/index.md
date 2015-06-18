# The ZAZ Authentication Kit

Authentication Kit is a module which makes it easy to implement Security Through Obesity password storage and TOTP Two Factor Authentication.

Simply add an interface to an existing (or new) user storage system, add a few columns to the database if necessary, and start working. Authentication Kit can even added Two Factor Authentication to existing Security Through Obesity implementations.

## Requirements

Authentication Kit requires the PBKDF2 hashing added to the new Xojo Framework in Xojo 2015 Release 2. All projects can compile and use the framework.

## Installation

Download the Authentication Kit project, open the `Authentication Kit.xojo_binary_project` file, then copy the `AuthenticationKit` module into your project.

## Getting Started

The class responsible for validating login credentials must implement the [AuthenticationKit.Validator](AuthenticationKit.Validator.md) interface. This is usually a database connection, but could be anything except a module, as modules cannot implement interfaces.

Once implemented, users are described by an [AuthenticationKit.User](AuthenticationKit.User.md) or [AuthenticationKit.MutableUser](AuthenticationKit.MutableUser.md) object.

The code below creates an AuthenticationKit.MutableUser with user id 1, then sets the login key and password. An array of [AuthenticationKit.Token](AuthenticationKit.Token.md) objects is returned when setting the password. One random token in the array is the correct one, the rest are bogus filler noise. All must be saved to the validator.

<pre><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Dim</span> EditableUser <span style="color: #0000FF;">As</span> AuthenticationKit.MutableUser = <span style="color: #0000FF;">New</span> AuthenticationKit.MutableUser(<span style="color: #336698;">1</span>)
EditableUser.LoginKey = <span style="color: #6600FE;">&quot;JoeUser&quot;</span>
<span style="color: #0000FF;">Dim</span> Tokens() <span style="color: #0000FF;">As</span> AuthenticationKit.Token = EditableUser.SetPassword(<span style="color: #6600FE;">&quot;ThisIsTheCorrectPassword&quot;</span>, <span style="color: #336698;">1000</span>, Xojo.Crypto.HashAlgorithms.SHA512)
<span style="color: #0000FF;">If</span> <span style="color: #0000FF;">Not</span> Validator.Save(EditableUser, Tokens) <span style="color: #0000FF;">Then</span>
  MsgBox(<span style="color: #6600FE;">&quot;Unable to save user&quot;</span>)
  <span style="color: #0000FF;">Return</span>
<span style="color: #0000FF;">End</span> <span style="color: #0000FF;">If</span></span></pre>

Once a user has been saved, the password can be validated. The first step is to lookup the user. No password validation is done on lookup, which allows password resets to happen if necessary.

When validating the password, a reference to a [AuthenticationKit.SecondFactorGenerator](AuthenticationKit.SecondFactorGenerator.md) must be provided ByRef. If the password matches, the ValidatePassword method returns true, and the Generator reference *may* be set to a value. If nil, the user has not enabled two factor authentication. If not nil, two factor authentication is enabled and the user should be required to provide a code to continue. This can also be determined using the AuthenticationKit.User.TwoFactorEnabled method.

<pre><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #800000;">// Lookup the user based on the username</span>
<span style="color: #0000FF;">Dim</span> User <span style="color: #0000FF;">As</span> AuthenticationKit.User = Validator.LookupUser(<span style="color: #6600FE;">&quot;JoeUser&quot;</span>)
<span style="color: #0000FF;">If</span> User = <span style="color: #0000FF;">Nil</span> <span style="color: #0000FF;">Then</span>
  MsgBox(<span style="color: #6600FE;">&quot;Unable to find user&quot;</span>)
  <span style="color: #0000FF;">Return</span>
<span style="color: #0000FF;">End</span> <span style="color: #0000FF;">If</span>

<span style="color: #800000;">// Validate the password, passing in the ByRef Generator. If a generator is</span>
<span style="color: #800000;">// returned, then two factor authentication is enabled.</span>
<span style="color: #0000FF;">Dim</span> Generator <span style="color: #0000FF;">As</span> AuthenticationKit.SecondFactorGenerator
<span style="color: #0000FF;">If</span> <span style="color: #0000FF;">Not</span> Validator.ValidatePassword(User, <span style="color: #6600FE;">&quot;ThisIsTheCorrectPassword&quot;</span>, Generator) <span style="color: #0000FF;">Then</span>
  MsgBox(<span style="color: #6600FE;">&quot;Incorrect password&quot;</span>)
  <span style="color: #0000FF;">Return</span>
<span style="color: #0000FF;">End</span> <span style="color: #0000FF;">If</span>

<span style="color: #0000FF;">If</span> Generator &lt;&gt; <span style="color: #0000FF;">Nil</span> <span style="color: #0000FF;">Then</span>
  <span style="color: #800000;">// Two factor authentication enabled</span>
  <span style="color: #0000FF;">Dim</span> Code <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Integer</span> = SomeMethodToAskUserForCode()
  <span style="color: #0000FF;">If</span> <span style="color: #0000FF;">Not</span> Generator.Verify(Code) <span style="color: #0000FF;">Then</span>
    MsgBox(<span style="color: #6600FE;">&quot;Code did not match&quot;</span>)
    <span style="color: #0000FF;">Return</span>
  <span style="color: #0000FF;">End</span> <span style="color: #0000FF;">If</span>
<span style="color: #0000FF;">End</span> <span style="color: #0000FF;">If</span></span></pre>

## Next Steps

With the basic workflow understood, the next step is to implement the [AuthenticationKit.Validator](AuthenticationKit.Validator.md) interface.