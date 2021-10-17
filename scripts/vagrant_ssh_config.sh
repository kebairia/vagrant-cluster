#!/bin/env sh
# this script helps you to access to your vagrant virtual machine
# from anypoint you are in
# the classic way to access vagrant's virtual machine folder to gain ssh access

mkdir -p ~/.ssh/vagrant.d/ && \
    echo "Include vagrant.d/sshconfig" >> ~/.ssh/config

vagrant ssh-config > ~/.ssh/vagrant.d/sshconfig
