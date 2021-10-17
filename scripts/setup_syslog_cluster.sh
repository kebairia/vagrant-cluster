echo "Setting password for user `hacluster`"
echo esiedge | passwd --stdin hacluster

echo "Authenticate the nodes"
pcs host auth syslog1 syslog2 -u hacluster -p esiedge

echo "Setup the cluster `"{{ cluster_name }}"`"
pcs cluster setup syslog_cluster syslog1 syslog2 --force

echo "Start and enable the cluster"
pcs cluster start --all
pcs cluster enable --all

echo "Create the virtual ip "
pcs resource create syslog_virtual_ip IPaddr2 ip=192.168.3.20 cidr_netmask=32 op monitor interval=5s

echo "Disable stonith"
pcs property set stonith-enabled=false

