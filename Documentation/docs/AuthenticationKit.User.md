# AuthenticationKit.User

A class which is used to describe user login details must implement the AuthenticationKit.User interface. This interface only provides access to details, but does not allow editing of details. An editable user class should implement [AuthenticationKit.MutableUser](AuthenticationKit.MutableUser.md) instead.

## Interface Methods

<pre id="method.algorithm"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Function</span> Algorithm () <span style="color: #0000FF;">As</span> Xojo.Crypto.HashAlgorithms</span></pre>
Return the hash algorithm used. Only SHA-1, SHA-256, and SHA-512 algorithms are acceptable values.

<pre id="method.iterations"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Function</span> Iterations () <span style="color: #0000FF;">As</span> UInteger</span></pre>
Return the number of PBKDF2 repeats used to generate hashes.

<pre id="method.loginkey"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Function</span> LoginKey () <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Text</span></span></pre>
Return the user's login key. It is recommended that the login key not the user's email address or visible to other users at all. An ideal user class will have a login key which is private, and a user name which is public. However, this is by no means a requirement. The returned value should be what the user uses to sign in with.

<pre id="method.passwordsalt"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Function</span> PasswordSalt () <span style="color: #0000FF;">As</span> Xojo.Core.MemoryBlock</span></pre>
Return a `Xojo.Core.MemoryBlock` of the bytes used as the password's salt.

<pre id="method.secondfactorsalt"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Function</span> SecondFactorSalt () <span style="color: #0000FF;">As</span> Xojo.Core.MemoryBlock</span></pre>
Return a `Xojo.Core.MemoryBlock` of the bytes used as the two factor authentication token's salt.

<pre id="method.twofactorenabled"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Function</span> TwoFactorEnabled () <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Boolean</span></span></pre>
Return `True` if two factor authentication is enabled.

<pre id="method.userid"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Function</span> UserID () <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Auto</span></span></pre>
Return a unique identifier for the user. This may be a uuid, an integer id, the user's username.... whatever immutable value is used to uniquely identify a user.

<pre id="method.validationhash"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Function</span> ValidationHash () <span style="color: #0000FF;">As</span> Xojo.Core.MemoryBlock</span></pre>
Return the validation hash provided to the AuthenticationKit.MutableUser.SetSecurityDetails method.

## See Also

[AuthenticationKit.MutableUser](AuthenticationKit.MutableUser.md)