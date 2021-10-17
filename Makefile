.PHONY: clean

setup:
	vagrant up

clean:
	vagrant destroy -f

admin1:
	vagrant up admin1

admin2:
	vagrant up admin2

syslog1:
	vagrant up syslog1

syslog2:
	vagrant up syslog2

mon:
	vagrant up mon

gfs1:
	vagrant up gfs1
gfs2:
	vagrant up gfs2
gfs3:
	vagrant up gfs3

bridge:
	./net_configs.sh --bridge

