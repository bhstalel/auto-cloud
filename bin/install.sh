#!/bin/bash
#########
bold="\e[1m"
underline="\e[4m"
reset="\e[0m"
red="\e[31m"
green="\e[32m"
blue="\e[34m"
yellow="\e[33m"
##########
## Instaling needs

# Checking ansible
if hash ansible 2>/dev/null; then
        echo -e "$green$bold [+] Ansible is here $reset"
else
        echo -e "$yellow$bold [-] We need to install ansible ! $reset"
        echo -e "$bold [+] Installing ... $reset"
        sleep 1
        sudo apt install software-properties-common
        sudo apt-add-repository ppa:ansible/ansible
        sudo apt-get update
        sudo apt install ansible
        echo -e "$green$bold [+] ansible is installed. $reset"
        echo
fi
ansible-playbook install.yaml
clear
echo -e "$green$bold [+] Installation complete , you can run : bash main.sh --help $reset"
