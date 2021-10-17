#!/bin/env sh
# Variables
DATA_FILE="./ip-mac-dhcp.conf"
BR_NET="br0"
BR_NET_CONF="br0.xml"

PR_NET="esinet"
PR_NET_CONF="esinet.xml"
PR_NET_SUBNET="192.168.2.0"
PR_NET_NETMASK="255.255.255.0"
PR_NET_BRIDGE="virbr2"
setup_color(){
    # Only use color if connected to a terminal
    if [ -t 1 ]; then
	RED=$(printf '\033[0;31m')
	GREEN=$(printf '\033[0;32m')
	YELLOW=$(printf '\033[0;33m')
	BLUE=$(printf '\033[0;34m')
	PURPLE=$(printf '\033[0;35m')
	CYAN=$(printf '\033[0;36m')
	BOLD=$(printf '\033[1m')
	RESET=$(printf '\033[0m')
    else
	RED=''
	GREEN=''
	YELLOW=''
	BLUE=''
	PURPLE=''
	CYAN=''
	BOLD=''
	RESET=''
    fi
}

setup_bridge_net_conf(){
    cat <<EOF > ./${BR_NET_CONF}
  <network>
      <name>${BR_NET}</name>
      <forward mode="bridge" />
      <bridge name="$BR_NET" />
  </network>
EOF
    virsh net-define ${BR_NET_CONF}
    virsh net-start ${BR_NET}
    virsh net-autostart ${BR_NET} 
}

setup_private_net_conf(){
    cat <<EOF > ./${PR_NET_CONF}
<network>
  <name>${PR_NET}</name>
  <uuid>2f73b304-0632-2f9d-9159-edd8b752f514</uuid>
  <forward mode='nat'/>
  <bridge name="${PR_NET_BRIDGE}" stp='on' delay='0'/>
  <mac address='52:54:00:17:14:3e'/>
  <domain name="${PR_NET}"/>
  <ip address="${PR_NET_SUBNET}" netmask="${PR_NET_NETMASK}"></ip>
</network>
EOF

    virsh net-define ${PR_NET_CONF}
    virsh net-start ${PR_NET}
    virsh net-autostart ${PR_NET} 
}

setup_ip_dhcp_res(){
    while read line
    do
        MAC=$(echo $line | cut -d"," -f1)
        IP=$(echo $line | cut -d"," -f2)

        echo "${GREEN}SETUP${RESET} $MAC:$IP"

        virsh net-update $PR_NET add-last ip-dhcp-host \
              "<host mac=$MAC ip=$IP/>" \
              --live --config --parent-index 0
    done < $DATA_FILE
}
clean_ip_dhcp_res(){
while read line
do
    MAC=$(echo $line | cut -d"," -f1)
    IP=$(echo $line | cut -d"," -f2)

    echo "${RED}CLEAN${RESET} $MAC:$IP"

    virsh net-update $PR_NET delete ip-dhcp-host \
          "<host mac=$MAC ip=$IP/>" \
          --live --config --parent-index 0
    done < $DATA_FILE
}
clean_net(){
    virsh net-destroy $1
    virsh net-undefine $1
}

restart_network(){
    virsh net-destroy $PR_NET &&\
        virsh net-start $PR_NET

}
generate_hash(){
    cat /dev/urandom \
        | tr -dc "[:alnum:]" \
        | tr -s A-Z a-z \
        | head -c $1
}
generate_uuid(){
    generate_hash 8
}
help(){
    cat <<EOF
NAME
    net_config: a script for setting up gryphon's different types of network configuraions

SYNOPSIS: 
    net_config [OPTION...]

OPTIONS:
    -s | --setup    : Setup the DHCP IP's reservations for the network configuration
    -c | --clean    : Undo the setup option, clean DHCP IP's reservations for the network configuration
    -b | --bridge   : Setup a bridge network configuration
    -p | --private  : Setup a private network configuration

CONFIGURATION FILES:
"ip-mac-dhcp.conf" : - The script uses a configuration file that holds the ip reservation, 
                        in this file you specify the mac address of the interface
                        and the correspended ip address you want
                     - Of course the IP address must be in the same pool that you specified 
                        while create the network configuration
                        EXAMPLE: "0E:51:ED:6E:00:02","192.168.2.2"
EOF
}

setup_color
echo $net_uuid
case "$1" in
    -s | --setup) setup_ip_dhcp_res && restart_network ;;
    -c | --clean) clean_ip_dhcp_res && restart_network ;;
    -b | --bridge) setup_bridge_net_conf ;;
    -p | --private) setup_private_net_conf ;;
    -H | --hash) generate_hash $2 ;;
    -d | --delete) clean_net $2;;
    * ) help ;;
esac
