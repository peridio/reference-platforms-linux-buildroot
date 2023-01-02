# Configure location of the CA key/cert
export CA_KEY=/root/ca.key
export CA_CERT=/root/ca.crt

# Set up device identity
export DEVICE_ID=$(uuidgen | tr "[:upper:]" "[:lower:]")
export DEVICE_DIR=/root/${DEVICE_ID}
mkdir -p ${DEVICE_DIR}

export GNUTLS_PIN=12345678
export GNUTLS_SO_PIN=12345678

# Initialize the HSM
#p11tool "pkcs11:model=OP-TEE%20TA" --label "identity" --initialize
p11tool "pkcs11:manufacturer=Intel" --label "identity" --initialize

# Create a token slot for the device identity
p11tool "pkcs11:token=identity" --initialize-pin

# Generate a ECDSA Keypair
p11tool "pkcs11:token=identity" --label "device" --generate-privkey="ECDSA" --bits=256

touch ${DEVICE_DIR}/database

# Create an end device openssl config
# Generate a CA config
cat <<EOF > ${DEVICE_DIR}/openssl.cnf
[ ca ]
default_ca=default_ca

[ default_ca ]
database = ${DEVICE_DIR}/database
new_certs_dir = ${DEVICE_DIR}
default_md=SHA256
policy=default_policy
rand_serial=yes
unique_subject=no
email_in_dn=no
default_days=0
prompt = no

[ default_policy ]
countryName            = optional
stateOrProvinceName    = optional
organizationName       = optional
organizationalUnitName = optional
commonName             = supplied

[ req ]
prompt = no
req_extensions = req_ext
ca_extensions = ca_ext
distinguished_name = req_distinguished_name

[req_distinguished_name]
# empty.

[req_ext]
extendedKeyUsage=clientAuth
keyUsage=critical,digitalSignature
subjectKeyIdentifier=hash

[ca_ext]
authorityKeyIdentifier=keyid:always
extendedKeyUsage=clientAuth
keyUsage=critical,digitalSignature
subjectKeyIdentifier=hash
EOF

# Generate a CSR from the token key
# NOTE: /usr/share/p11-kit/modules should only contain modules for hardware that is expected to exist
openssl req \
-config ${DEVICE_DIR}/openssl.cnf \
-extensions req_ext \
-engine pkcs11 \
-key "pkcs11:token=identity;object=device;type=private;pin-value=${GNUTLS_SO_PIN}" \
-keyform engine \
-new \
-out ${DEVICE_DIR}/${DEVICE_ID}.csr \
-subj "/CN=${DEVICE_ID}"

openssl ca \
-batch \
-cert $CA_CERT \
-config ${DEVICE_DIR}/openssl.cnf -in "${DEVICE_DIR}/${DEVICE_ID}.csr" \
-extensions ca_ext \
-enddate 20240101000000Z \
-in ${DEVICE_DIR}/${DEVICE_ID}.csr \
-keyfile $CA_KEY \
-out "${DEVICE_DIR}/device-cert.pem" \
-startdate 20220101000000Z

# Load the certificate object into the HSM
p11tool "pkcs11:token=identity" --load-certificate="${DEVICE_DIR}/device-cert.pem" --write --label="device"
