#!/bin/env sh
#constants
OPVPN_SRV_NAME="deb-server"
DIR="/etc/openvpn/easy-rsa"
source ${DIR}/vars
${DIR}/clean-all
${DIR}/build-ca
${DIR}/build-key-server ${OPVPN_SRV_NAME}
${DIR}/build-dh
cp ${DIR}/keys/{${OPVPN_SRV_NAME}.crt,ca.crt,dh1024} /etc/openvpn
# Create Client Certificates
# OpenVPN Server Configuration
