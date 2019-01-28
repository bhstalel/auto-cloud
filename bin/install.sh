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
ch=`echo -e "$bold [$green choice$reset $bold]$ $reset "`
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

echo -e "$blue$bold [ Installation continue with: "
echo -e "       # letsencrypt "
echo -e "       # python-certbot-nginx "
echo -e "       # python-certbot-apache "
echo -e "                                ] $reset"
echo -e "$bold 1: continue "
echo -e " 2: exit $reset"
echo
read -p "$ch" choice

if [ $choice -eq 1 ]; then
        ansible-playbook install.yaml
        clear
        echo -e "$green$bold [+] Installation complete , you can run : bash main.sh --help $reset"
else
        clear
        echo -e "$green$bold [+] Installation complete , you can run : bash main.sh --help $reset"
fi