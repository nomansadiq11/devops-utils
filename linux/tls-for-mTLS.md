# How to Generate TLS Certificate for mTLS

## Usecase

There is a requirement to enable `mTLS` between two APIs. Let's say there is API A and API B that want to communicate with each other using mTLS.

## Option 1

Use your own CA only if API B will trust that CA in their mTLS gateway. Without that server-side trust step, this will still fail.

## Solution

### Step 1: Create your CA

```bash
openssl genrsa -out ca.key 4096

openssl req -x509 -new -nodes \
  -key ca.key \
  -sha256 \
  -days 3650 \
  -out ca.crt \
  -subj "/C=AE/ST=Dubai/L=Dubai/O=company/OU=Integration/CN=company-client-ca"
```

This gives you:

- ca.key: your CA private key
- ca.crt: your CA certificate
- Do not share ca.key with anyone.

### Step 2: Create a client OpenSSL config

Create a file named client.cnf with this content:

```conf
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn
req_extensions = req_ext

[ dn ]
C = AE
ST = Dubai
L = Dubai
O = Company
OU = Integration
CN = company-client

[ req_ext ]
basicConstraints = CA:FALSE
keyUsage = critical, digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth
subjectAltName = @alt_names
subjectKeyIdentifier = hash

[ alt_names ]
DNS.1 = company-client
```

Your earlier certificate already had clientAuth, so this keeps that part correct.

### Step 3: Generate the client key and CSR

```bash
openssl genrsa -out client.key 2048

openssl req -new \
  -key client.key \
  -out client.csr \
  -config client.cnf
```

This gives you:

- client.key
- client.csr

### Step 4: Sign the client certificate with your CA

```bash
openssl x509 -req \
  -in client.csr \
  -CA ca.crt \
  -CAkey ca.key \
  -CAcreateserial \
  -out client.crt \
  -days 365 \
  -sha256 \
  -extfile client.cnf \
  -extensions req_ext
```

Now your client certificate is not self-signed anymore. It is signed by your CA.

### Step 5: Validate the result locally

Check issuer and subject:

```bash
openssl x509 -in client.crt -noout -issuer -subject
```

Expected result:

- issuer should be CN=company-client-ca
- subject should be CN=company-client

Check EKU:

```bash
openssl x509 -in client.crt -noout -text | grep -A5 "Extended Key Usage"
```

Expected result:

- TLS Web Client Authentication

Check key and cert match:

```bash
openssl x509 -noout -modulus -in client.crt | openssl md5
openssl rsa  -noout -modulus -in client.key | openssl md5
```

Both hashes must match.

Check certificate chains to your CA:

```bash
openssl verify -CAfile ca.crt client.crt
```

Expected result:

client.crt: OK

### Step 6: Give the API team the correct artifact

Send them only:

- ca.crt

Tell them:

- This is the CA certificate that issued our client certificate.
- Please import this CA into the mTLS truststore for api-A.company.ae.
- If you also require certificate identity allowlisting, use our client certificate subject or fingerprint.

If they require fingerprint or subject, give them:

```bash
openssl x509 -in client.crt -noout -fingerprint -sha256 -subject -issuer
```

### Step 7: Call the API

Once they confirm the CA is trusted:

```bash
curl -v \
  --cert client.crt \
  --key client.key \
  https://api-A.company.ae/v1/oauth/generate
```

If they expect the client chain in one file, use:

```bash
cat client.crt ca.crt > client-fullchain.crt

curl -v \
  --cert client-fullchain.crt \
  --key client.key \
  https://api-A.company.ae/v1/oauth/generate
```

## Option 2

API B will sign your CA certificate only if you will trust that CA in your mTLS gateway. Without that server-side trust step, this will still fail.
