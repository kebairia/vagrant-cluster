#!/bin/env sh
POOL_PATH="the path"
virsh pool-define-as esiedge $POOL_PATH
virsh pool-autostart rhpol_virsh    # Start on boot
virsh pool-start rhpol_virsh        # Start now
