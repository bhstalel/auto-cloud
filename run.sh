#!/bin/bash


clear
sleep 1
echo "+-------------------------------+"
echo "|                               |"
echo "|  Nextcloud Auto-Installation  |"
echo "|      bhstalel@gmail.com       |"
echo "|                               |"
echo "+-------------------------------+"
echo
read -p "[+] Nginx(1), Apache2(2): " choice
read -p "[+] Nextcloud username: " username
read -p "[+] Username password: " userpass
read -p "[+] Nextcloud domain: " ncdomain
read -p "[+] PHP version: " php_version

echo "[!] Generating config file .."
sleep 1
touch group_vars/all.yaml
echo "nextcloud_username: "$username"" > group_vars/all.yaml
echo "nextcloud_userpass: "$userpass"" >> group_vars/all.yaml
echo "nextcloud_domain: "$ncdomain"" >> group_vars/all.yaml
echo "php_version: "$php_version"" >> group_vars/all.yaml
echo

#####################################
# Selecting the SSLCertificate option
#####################################
read -p "[+] Self-signed-SSLCertificate(1), CA-SSLCertificate(2): " sslchoice

if [ $sslchoice -eq 1 ]; then
read -p "|__:Hit ENTER to generate:___|" enter0
echo "[+] Generating auto-signed SSL certificate .."
sleep 2
openssl genrsa -out nextcloud.key
openssl req -new -key nextcloud.key -out d.req -subj "/C=TN/ST=Sousse/L=Sousse/O=Global Security/OU=IT Department/CN=chifco.com"
openssl x509 -req -days 365 -in d.req -signkey nextcloud.key -out nextcloud.crt

else
echo "[-] Coming Soon "
echo
fi

if [ $choice -eq 1 ]; then
	echo "---" > playbook.yaml
	echo "- hosts: localhost" >> playbook.yaml
	echo "  roles:" >> playbook.yaml
	echo "    - nextcloud-nginx" >> playbook.yaml
	clear
	echo "[+] SSLCertificate files generated. "
	echo "[+] Running Nextcloud-Nginx ..."
	read -p "|___:Hit ENTER to continue:___|" enter
	sleep 2
	ansible-playbook playbook.yaml
else
	echo "[!] Coming Soon [APACHE2]..."
fi
