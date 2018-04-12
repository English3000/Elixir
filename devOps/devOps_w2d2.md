## DNS & SSL (security)
> encryption

> certificate signing -- [LetsEncrypt.org](https://letsencrypt.org/getting-started/)

(last 3 days will be light)

### Domain Name Service
hierarchical server structure responsible for mapping a string URL to an IP address (fields: name, type, IP address)

A (alias--maps name to IP address) & CNAME (maps a name to another name) = most common

13 root servers (IANA)
* [a-m].root-servers.net

`$ nslookup` lets you make DNS requests

`nslookup -type=NS DOMAIN.NAME`

AWS has interface for nslookup called Route 53

[DNS](https://dnsmadeeasy.com/support/what-is-dns/) recurser checks...
* <> root nameserver (responds w/ a nameserver IP)
* <> org nameserver (" ")
* <> wikipedia.org nameserver

right to modify DNS

AWS charges $12/yr for a domain name ($39/yr for .io)


A - address

CNAME - canonical name

MX - mail exchanger

NS - name server

TXT - text records

### [Symmetric Cryptography](https://docs.google.com/presentation/d/1H0jTULaWIQY4mUGGxN5uZJDhKTi_B7-54g6TuwWJXYE/edit#slide=id.g3737cde20a_0_72)

hashing plain text to look random

symmetric means both parties can read the text

asymmetric
* means *key 1 != key 2* (keys are for decryption)
* incl's a private key & a public key
* when decryption is not just the mathematical reverse of encryption
* sender can't decrypt their own message--only the receiver

key = how an input is mapped to an output value

polyalphabetic cipher (2nd time a letter appears, maps to diff. cipher value) = transposition

reverse order/shift mapping (substitution) enough times creates random-esque sequence

Use asymmetric cryptography 'til have a key that both parties can use symmetrically

one key (public or private) always encrypts & 1 always decrypts

13 * 23 = 299 (fast to calculate)

2 prime factors of 299 (takes longer to figure out)

> trapdoor function

eliptic curve cryptography = ECC

RSA chooses 2 prime #s (number that is the factor of 2 big prime #s)--*shows steps in slides*

quantum computers can break RSA

Diffie-Hellman Key Exchange

client:
A = random
p = random
g = random

p & g >> server:
B = random

a = g^A % p
b = g^B % p

can exchange a & b

k = b^A % p = a^B % p

give public & private keys to AWS Certificate Manager; ELB does TSL handshake math (Diffie-Hellman)

SSL has "web of trust" model (chain of signing CA's; root CA's = list decided by browser co's)

### Secure Sockets Layer

"SSL certificates create an encrypted connection"

"SSL certificates have a key pair: a public and a private key. These keys work together to establish an encrypted connection. The certificate also contains what is called the 'subject,' which is the identity of the certificate/website owner."

"To get a certificate, you must create a Certificate Signing Request (CSR) on your server. This process creates a private key and public key on your server. The CSR data file that you send to the SSL Certificate issuer (called a Certificate Authority or CA) contains the public key. The CA uses the CSR data file to create a data structure to match your private key without compromising the key itself."

"Once you receive the SSL certificate, you install it on your server. You also install an intermediate certificate that establishes the credibility of your SSL Certificate by tying it to your CA’s root certificate."

"Browsers come with a pre-installed list of trusted CAs, known as the Trusted Root CA store. In order to be added to the Trusted Root CA store and thus become a Certificate Authority, a company must comply with and be audited against security and authentication standards established by the browsers."

"An SSL Certificate issued by a CA to an organization and its domain/website verifies that a trusted third party has authenticated that organization’s identity. Since the browser trusts the CA, the browser now trusts that organization’s identity too."

**The Protocol**

"SSL is a security protocol. Protocols describe how algorithms should be used. In this case, the SSL protocol determines variables of the encryption for both the link and the data being transmitted."

"three keys are used to set up the SSL connection: the public, private, and session keys. Anything encrypted with the public key can only be decrypted with the private key, and vice versa."

"Because encrypting and decrypting with private and public key takes a lot of processing power, they are only used during the SSL Handshake to create a symmetric session key. After the secure connection is made, the session key is used to encrypt all transmitted data."

1.  Browser connects to a web server (website) secured with SSL (https). Browser requests that the server identify itself.

2.  Server sends a copy of its SSL Certificate, including the server’s public key.

3.  Browser checks the certificate root against a list of trusted CAs and that the certificate is unexpired, unrevoked, and that its common name is valid for the website that it is connecting to. If the browser trusts the certificate, it creates, encrypts, and sends back a symmetric session key using the server’s public key.

4.  Server decrypts the symmetric session key using its private key and sends back an acknowledgement encrypted with the session key to start the encrypted session.

5.  Server and Browser now encrypt all transmitted data with the session key.
