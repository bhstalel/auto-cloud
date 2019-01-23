#!/bin/bash


clear
sleep 1
echo "Nextcloud Auto-Installation"
echo
read -p "[+] Nginx(1) / Apache2(2): " choice
read -p "[+] Nextcloud username: " username
read -p "[+] Username password: " userpass
read -p "[+] Nextcloud domain: " ncdomain
read -p "[+] Letsencrypt email: " email
read -p "[+] PHP version: " php_version

echo "[!] Generating config file .."
sleep 1
touch group_vars/all.yaml
echo "nextcloud_username: "$username"" > group_vars/all.yaml
echo "nextcloud_userpass: "$userpass"" >> group_vars/all.yaml
echo "nextcloud_domain: "$ncdomain"" >> group_vars/all.yaml
echo "letsencrypt_email: "$email"" >> group_vars/all.yaml
echo "php_version: "$php_version"" >> group_vars/all.yaml

echo "[+] Done."
echo "[+] Generating auto-signed SSL certificate .."
sleep 2
openssl genrsa -out nextcloud.key
openssl req -new -key nextcloud.key -out d.req -subj "/C=TN/ST=Sousse/L=Sousse/O=Global Security/OU=IT Department/CN=chifco.com"
openssl x509 -req -days 365 -in d.req -signkey nextcloud.key -out nextcloud.crt
echo "[!] SSL certificate generated."
echo "[+] Running the script ... "
sleep 2
ansible-playbook playbook.yaml
