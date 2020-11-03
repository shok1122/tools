#!/bin/bash

PATH_LINUX_SGX_DRIVER="$1"
PATH_LINUX_SGX="$2"

PATH_INSTALL="/lib/modules/"$(uname -r)"/kernel/drivers/intel/sgx"

# 01.
if [ -f $PATH_INSTALL/isgx.ko ]; then
    echo "Found: $PATH_INSTALL/isgx.ko"
    exit 0
else
    sudo mkdir -p $PATH_INSTALL
fi

# 02. install linux header
sudo apt install linux-headers-$(uname -r)

# 03. make sgx driver
(
    cd $PATH_LINUX_SGX_DRIVER
    make clean
    make
    if [ ! -f isgx.ko ]; then
        echo "not found: isgx.ko"
        exit 1
    fi
    sudo cp isgx.ko $PATH_INSTALL
    sudo cat /etc/modules | grep -Fxq isgx || echo isgx >> /etc/modules
    sudo /sbin/depmod
    sudo /sbin/modprobe isgx
)

# 03. check
modinfo isgx
