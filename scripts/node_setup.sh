#!/bin/env sh
sudo yum update -y && sudo yum upgrade -y

sudo setenforce permissive
sudo sed -i 's/^SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config
# installation
sudo yum install -y https://releases.hashicorp.com/vagrant/2.2.4/vagrant_2.2.4_x86_64.rpm
# installation of libvirt-vagrant dependencies
sudo yum install -y qemu libvirt libvirt-devel ruby-devel gcc qemu-kvm rsync git
# installing the libvirt-vagrant plugin
vagrant plugin install vagrant-libvirt vagrant-parallels
# configuration
#start and enable libvirt daemon (libvirtd)

sudo systemctl start libvirtd.service
sudo systemctl enable libvirtd.service
# adding your user to libvirt group
sudo usermod -aG libvirt $USER

# download needed vagrant boxes
mkdir test && cd test
cat <<EOF > Vagrantfile
Vagrant.configure("2") do |config|
  config.vm.box = "debian/jessie64"
end
EOF
vagrant up
cat <<EOF > Vagrantfile
Vagrant.configure("2") do |config|
  config.vm.box = "centos/8"
end
EOF
vagrant up

cat <<EOF > Vagrantfile
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
end
EOF
vagrant up
