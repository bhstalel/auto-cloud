#!/bin/bash

##


menu(){

echo
echo " #  Available cmds #   "
echo " +=================+ "
echo " | show            | "
echo " | add             | "
echo " | reset           | "
echo " | run             | "
echo " | help            | "
echo " | exit            | "
echo " +=================+ "
echo

}

help(){
menu
}

prog=""


showoptions(){
echo
echo " #     Plugins     #   "
echo " +=================+ "
echo " | nextcloud       | "
echo " | onlyoffice      | "
echo " | collabora       | "
echo " | draw            | "
echo " | ownpad          | "
echo " +=================+ "
echo
}


generatessl(){
echo
echo " [NOTE]: You'r installing nextcloud locally, "
echo "         so we need to generate a self-signed certificate."
echo
read -p " + HIT ENTER TO GENERATE + " n
openssl genrsa -out ../ssl/nextcloud.key
openssl req -new -key ../ssl/nextcloud.key -out ../ssl/d.req -subj "/C=TN/ST=Sousse/L=Sousse/O=Global Security/OU=IT Department/CN=chifco.com"
openssl x509 -req -days 365 -in ../ssl/d.req -signkey ../ssl/nextcloud.key -out ../ssl/nextcloud.crt
echo
echo " [SSLCertificate] Generated in auto-cloud/ssl/ "
echo
}

add(){
showoptions
read -p " [plugin]: " plugin
	if [ $plugin = "nextcloud" ]; then
		echo
		echo " [NEXTCLOUD] chosen."
		read -p " [ APACHE2(1) , NGINX(2) ]: " web
		if [ $web -eq 1 ]; then
			if [ $prog = "o" ]; then
				echo "    - o-nc-a" >> ../playbook.yaml
			else
				echo "    - l-nc-a" >> ../playbook.yaml
			fi
		else
			if [ $prog = "o" ]; then
				echo "    - o-nc-n" >> ../playbook.yaml
			else
				echo "    - l-nc-n" >> ../playbook.yaml
				generatessl
			fi
		fi
		echo
	fi
}

reset(){
echo
echo "---" > ../playbook.yaml
echo "- hosts: localhost" >> ../playbook.yaml
echo "  roles:" >> ../playbook.yaml
echo " [+] Done resting ."
echo
}

main(){

if [ $# -eq 0 ]; then
	prog="o"
else
	if [ $# -gt 1 ]; then
		echo " [-] Invalid number of arguments "
		exit
	fi
	if [ $# -eq 1 ]; then
		if [ $1 = "-l" ]; then
			prog="l"
		else
			echo " [-] Invalid argument "
			exit
		fi
	fi
fi

echo "---" > ../playbook.yaml
echo "- hosts: localhost" >> ../playbook.yaml
echo "  roles:" >> ../playbook.yaml

read -p " [auto-cloud]: " input
while [ -z $input ] || [ $input != "exit" ];
do
	case $input in
		"show")
			showoptions
			read -p " [auto-cloud]: " input;;
		"add")
			add
			read -p " [auto-cloud]: " input;;
		"reset")
			reset
			read -p " [auto-cloud]: " input;;
		"run")
			ansible-playbook ../playbook.yaml
			read -p " [auto-cloud]: " input;;
		"help")
			help
			read -p " [auto-cloud]: " input;;
		"clear")
			clear
			read -p " [auto-cloud]: " input;;
		"exit")
			exit;;
		*)
			read -p " [auto-cloud]: " input;;
	esac

done

}

main $@
