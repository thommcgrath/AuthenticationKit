# AuthenticationKit.Validator

This interface must be implemented by the storage system, which is usually a database connection.

## Interface Methods

<pre id="method.lookupsalt"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Function</span> LookupSalt (Hash <span style="color: #0000FF;">As</span> Xojo.Core.MemoryBlock) <span style="color: #0000FF;">As</span> Xojo.Core.MemoryBlock</span></pre>
The implementor should find the salt from the passwords table matching the provided `Hash`. Return `Nil` if `Hash` cannot be found.

<pre id="method.lookupuser"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Function</span> LookupUser (LoginKey <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Text</span>) <span style="color: #0000FF;">As</span> AuthenticationKit.User</span></pre>
The implementor should lookup the user details for the given `LoginKey` and return an [AuthenticationKit.User](AuthenticationKit.User.md) object. Return `Nil` if `LoginKey` cannot be found.

<pre id="method.save"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Function</span> Save (Users() <span style="color: #0000FF;">As</span> AuthenticationKit.User, Tokens() <span style="color: #0000FF;">As</span> AuthenticationKit.Token) <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Boolean</span></span></pre>
The implementor should save all the provided `Users` and `Tokens`. Return `True` if everything saved correctly.

## Extension Methods

These methods are supplied by the `AuthenticationKit` module automatically to all implementors of the interface.

<pre id="method.addbogustokens"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Function</span> AddBogusTokens (<span style="color: #0000FF;">Extends</span> Validator <span style="color: #0000FF;">As</span> AuthenticationKit.Validator, NumRecords <span style="color: #0000FF;">As</span> UInteger, ByteCount <span style="color: #0000FF;">As</span> UInteger) <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Boolean</span></span></pre>
Add `NumRecords` bogus records consisting of `ByteCount` bytes. This is useful for seeding a validator with excess records which match no user.

<pre><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Function</span> Save (<span style="color: #0000FF;">Extends</span> Validator <span style="color: #0000FF;">As</span> AuthenticationKit.Validator, Tokens() <span style="color: #0000FF;">As</span> AuthenticationKit.Token) <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Boolean</span></span></pre>
An alias of the `Save` method which accepts only an array of `Tokens`.

<pre><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Function</span> Save (<span style="color: #0000FF;">Extends</span> Validator <span style="color: #0000FF;">As</span> AuthenticationKit.Validator, User <span style="color: #0000FF;">As</span> AuthenticationKit.User, Tokens() <span style="color: #0000FF;">As</span> AuthenticationKit.Token) <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Boolean</span></span></pre>
An alias of the `Save` method which accepts a single `User` and an array of `Tokens`.

<pre id="validatepassword"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Function</span> ValidatePassword (<span style="color: #0000FF;">Extends</span> Validator <span style="color: #0000FF;">As</span> AuthenticationKit.Validator, User <span style="color: #0000FF;">As</span> AuthenticationKit.User, Password <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Text</span>, <span style="color: #0000FF;">ByRef</span> Generator <span style="color: #0000FF;">As</span> AuthenticationKit.TwoFactorProfile) <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Boolean</span></span></pre>
Test `Password` against `User`. Returns `True` if the password matches. `Generator` is a `ByRef` reference to a [AuthenticationKit.TwoFactorProfile](AuthenticationKit.TwoFactorProfile.md) that will be set to valid instance if the user has two factor authentication enabled, or set to nil if not enabled.

## See Also

[AuthenticationKit.Token](AuthenticationKit.Token.md), [AuthenticationKit.TwoFactorProfile](AuthenticationKit.TwoFactorProfile.md)