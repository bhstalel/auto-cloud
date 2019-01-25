#!/bin/bash

## Instaling needs

# Checking ansible
if hash ansible 2>/dev/null; then
        echo "[+] Ansible is here "
else
        echo "[-] We need to install ansible !"
        echo "[+] Installing ... "
        sleep 1
        sudo apt install software-properties-common
        sudo apt-add-repository ppa:ansible/ansible
        sudo apt-get update
        sudo apt install ansible
        echo "[+] ansible is installed."
        echo
fi
ansible-playbook install.yaml
