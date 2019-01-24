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

# checking letsencrypt
if hash letsencrpt 2>/dev/null; then
                echo "[+] letsencrypt is here "
else
                echo "[!] Need to install letsencrypt !"
                echo "[+] Installing ..."
                sudo apt install letsencrypt -y
                echo "[+] letsencrypt is installed."
fi


# checking python-certbot-nginx
if hash python-certbot-nginx 2>/dev/null; then
                echo "[+] python-certbot-nginx is here "
else
                echo "[!] Need to install python-certbot-nginx !"
                echo "[+] Installing ..."
                sudo add-apt-repository ppa:certbot/certbot
                sudo apt-get update
                sudo apt-get install python-certbot-nginx
                echo "[+] python-certbot-nginx is installed."
fi


# checking python-certbot-apache
if hash python-certbot-apache 2>/dev/null; then
                echo "[+] python-certbot-apache is here "
else
                echo "[!] Need to install python-certbot-apache !"
                echo "[+] Installing ..."
                sudo apt-get install python-certbot-apache
                echo "[+] python-certbot-apache is installed."
fi

