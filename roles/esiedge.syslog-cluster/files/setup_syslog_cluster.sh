echo "Setting password for user `hacluster`"
echo esiedge | passwd --stdin hacluster
echo "Authenticate the nodes"
pcs host auth syslog1 syslog2 -u hacluster -p esiedge
# pcs host auth "{{ pcs nodes }}" -u "{{ pcs_user }}" -p "{{ pcs_pass }}"
# echo "Setup the cluster `"{{ cluster_name }}"`"
# pcs cluster setup "{{ cluster_name }}"
# echo "Start and enable the cluster"
# pcs cluster start --all
# pcs cluster enable --all
# echo "Create the virtual ip `"{{ cluster_vip }}", "{{ cluster_netmask }}"`"
# pcs resource create sysip IPaddr2 ip="{{ cluster_vip }}" cidr_netmask="{{ cluster_netmask }}"
# echo "Disable stonith"
# pcs property set stonith-enabled=false

