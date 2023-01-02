PRODUCT_NAME=$1

# Generate a CA config
cat <<EOF > ${PRODUCT_NAME}.cnf
[req]
prompt = no
distinguished_name = dn
x509_extensions = ext

[dn]
CN = ${PRODUCT_NAME}

[ext]
basicConstraints=critical,CA:TRUE,pathlen:1
extendedKeyUsage=serverAuth,clientAuth
keyUsage=critical,digitalSignature,keyCertSign,cRLSign
subjectKeyIdentifier=hash
EOF

# Generate a CA Key
openssl ecparam \
  -genkey \
  -name prime256v1 \
  -out "${PRODUCT_NAME}-ca-key.pem"

# Generate a CA Cert
openssl req -new -x509 -days 3650 \
-key "${PRODUCT_NAME}-ca-key.pem" \
-config "${PRODUCT_NAME}.cnf" \
-out "${PRODUCT_NAME}-ca-cert.pem"
