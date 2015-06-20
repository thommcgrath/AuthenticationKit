# AuthenticationKit.Token

This class represents a hash and salt pair that may belong to a user's password, or may be false data.

## Constructors

<pre><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">ByteCount <span style="color: #0000FF;">As</span> UInteger</span></pre>
Create a false token.

<pre><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">Hash <span style="color: #0000FF;">As</span> Xojo.Core.MemoryBlock, Salt <span style="color: #0000FF;">As</span> Xojo.Core.MemoryBlock</span></pre>
Create a token with the provided unencoded hash and salt.

## Properties

<pre id="property.hash"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">Hash <span style="color: #0000FF;">As</span> Xojo.Core.MemoryBlock</span></pre>
The unencoded hash bytes.

<pre id="property.salt"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">Salt <span style="color: #0000FF;">As</span> Xojo.Core.MemoryBlock</span></pre>
The unencoded salt bytes.