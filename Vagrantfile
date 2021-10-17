require "yaml"
servers = YAML.load_file('servers.yml')
#
# VARIABLES
#
CDROM = "/home/zakaria/dox/zkext/isos/CentOS-8.3.2011-x86_64-dvd1.iso"
MGN = "192.168.2.0/24"
BR_NET = "br0"
#
# CONFIGURATION
#
Vagrant.configure("2") do |config|
  #------------------------------------
  # GLOBAL CONFIGURATION
  #------------------------------------
  # increase the boot_timeout because we will provision a lot of vms
  config.vm.boot_timeout = 600
  # SYNCED FOLDERS
  # disable the default vagrant folder
  config.vm.synced_folder '.', '/vagrant', disabled: true
  #------------------------------------
  # PER NODE CONFIGURATION
  #------------------------------------
  servers.each do |servers|
    config.vm.define servers["name"] do |server|

      server.vm.box = servers["box"]
      #----------
      # NETWORK 
      #----------
      if servers["add_int"] == "true"
        ints = servers["ints"]
        ints.each do |int|
          if int["type"] == "private_network"
            server.vm.network int["type"], ip: int["ip"], mac: int["mac"]
          else
            server.vm.network :public_network,
                              :dev => BR_NET,
                              :mode => "bridge",
                              :type => "bridge",
                              :mac => int["mac"],
                              :ip => int["ip"]
          end
        end
      end # end network
      # SSH CONFIG
      #server.vm.network :forwarded_port, guest: 22, host: 10122, id: "ssh"
      # HOSTNAME
      server.vm.hostname = servers["hostname"]
      server.vm.provider :libvirt do |libvirt|
        # libvirt.storage_pool_path = servers["pool"]
        libvirt.storage_pool_name = servers["pool"]
        libvirt.cpus = servers["cpus"]
        libvirt.memory = servers["memory"]
        libvirt.management_network_mac = servers["mnm"]
        libvirt.management_network_address = MGN
        libvirt.management_network_name = "esinet"
        #----------
        # STORAGE
        #----------
        libvirt.storage :file, :device => :cdrom, :path => CDROM
        # adding extra disks
        if servers["add_disks"] == "true"
          drives = servers["disks"]
          drives.each do |disk|
            libvirt.storage :file, :size => disk
          end

        end # end storage
      end # end libvirt

      # PROVISIONING
      if servers["prov"] == "ansible"
        server.vm.provision "ansible" do |ansible|
          ansible.playbook = servers["prov_file"]
        end 
      else
        server.vm.provision :shell, path: servers["prov_file"] 
      end # end provision
      
    end # end server
  end # end servers
end
