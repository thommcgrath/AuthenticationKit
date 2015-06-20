# AuthenticationKit.TwoFactorProfile

This is the class responsible for creating and validating [time-based one-time passwords](https://en.wikipedia.org/wiki/Time-based_One-time_Password_Algorithm) (TOTPs).

Be aware that the most popular authenticator, Google Authenticator, does not respect most changes to the default properties. Google Authenticator will still read a provisioning uri with non-default values, but will not generate matching codes. For this reason, it is recommended that all properties be left at their default values.

## Constructors

<pre><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">Secret <span style="color: #0000FF;">As</span> Xojo.Core.MemoryBlock</span></pre>
The unencoded secret shared between the server and the user.

## Methods

<pre id="method.generatecode"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Function</span> GenerateCode () <span style="color: #0000FF;">As</span> UInteger</span></pre>
Generate a password for the current time.

<pre><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Function</span> GenerateCode (AtTime <span style="color: #0000FF;">As</span> Xojo.Core.Date) <span style="color: #0000FF;">As</span> UInteger</span></pre>
Generate a password for the time provided by `AtTime`.

<pre id="method.provisioninguri"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Function</span> ProvisioningURI (Label <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Text</span>, Issuer <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Text</span> = <span style="color: #6600FE;">&quot;&quot;</span>) <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Text</span></span></pre>
Create a [provisioning uri](https://github.com/google/google-authenticator/wiki/Key-Uri-Format) that can be consumed by an authenticator. This is commonly encoded into a QR code that can be read by a device's camera.

`Label` is usually the account name to be associated with the profile. `Issuer` is the website or company issuing the profile. Although the `Issuer` is not required, it is strongly recommended.

<pre id="method.secret"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Function</span> Secret () <span style="color: #0000FF;">As</span> Xojo.Core.MemoryBlock</span></pre>
The unencoded secret key used to generate unique codes.

<pre id="method.verifycode"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Function</span> VerifyCode (Code <span style="color: #0000FF;">As</span> UInteger) <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Boolean</span></span></pre>
Verify that `Code` is valid for the current time. Also checks both the previous code and next code to help alleviate clock synchronization and other user timing issues.

## Properties

<pre id="property.digest"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">Digest <span style="color: #0000FF;">As</span> Xojo.Crypto.HashAlgorithms</span></pre>
The hash algorithm that should be used. Valid values are SHA-1, SHA-256, and SHA-512. Other values will trigger a Xojo.Core.InvalidArgumentException. Default is SHA-1. *Google Authenticator ignores this value and uses SHA-1 instead.*

<pre id="property.digits"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">Digits <span style="color: #0000FF;">As</span> UInteger</span></pre>
The number of digits of the generated passwords. Valid values are 6 and 8. Other values will trigger a Xojo.Core.InvalidArgumentException. Default is 6. *Google Authenticator ignores this value and uses 6 instead.*

<pre id="property.period"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">Period <span style="color: #0000FF;">As</span> Xojo.Core.DateInterval</span></pre>
The number of seconds each password should be valid for. Default is 30. *Google Authenticator ignores this value and uses 30 instead.*