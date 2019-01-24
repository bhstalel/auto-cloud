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
cmd=`echo -e "$bold [$green auto-cloud$reset $bold]$ $reset "`
ch=`echo -e "$bold [$green choice$reset $bold]$ $reset "`

menu(){

echo
echo -e "$blue$bold #  Available cmds #"
echo " +=================+ "
echo " | show            | "
echo " | add             | "
echo " | remove          | "
echo " | reset           | "
echo " | ready           | "
echo " | run             | "
echo " | help            | "
echo " | exit            | "
echo -e " +=================+ $reset"
echo

}

help(){
menu
}

prog=""
PLUGINS=()

showoptions(){
echo
echo -e " $blue$bold#     Plugins     #   "
echo " +=================+ "
echo " | nextcloud       | "
echo " | onlyoffice      | "
echo " | collabora       | "
echo " | draw            | "
echo " | ownpad          | "
echo -e " +=================+ $reset"
echo
}


generatessl(){
echo
echo -e "$yellow$bold [NOTE]: You'r installing nextcloud locally, "
echo "         so we need to generate a self-signed certificate.$reset"
echo
read -p " + HIT ENTER TO GENERATE + " n
openssl genrsa -out ../ssl/nextcloud.key
openssl req -new -key ../ssl/nextcloud.key -out ../ssl/d.req -subj "/C=TN/ST=Sousse/L=Sousse/O=Global Security/OU=IT Department/CN=chifco.com"
openssl x509 -req -days 365 -in ../ssl/d.req -signkey ../ssl/nextcloud.key -out ../ssl/nextcloud.crt
echo
echo -e " $green$bold [SSLCertificate] Generated in auto-cloud/ssl/ $reset"
echo
}


# Check for existing NEXTCLOUD plugin
checknc(){
for each in "${PLUGINS[@]}"
do
	if [ $each = "OFFICIAL-NEXTCLOUD-APACHE" ] || [ $each = "OFFICIAL-NEXTCLOUD-NGINX" ] || [ $each = "LOCAL-NEXTCLOUD-APACHE" ] || [ $each = "LOCAL-NEXTCLOUD-NGINX" ]; then
		return 1
	fi
done
return 0
}

add(){
showoptions
echo -e "$bold  ---- $reset"
echo -e " $red$bold back"
echo -e "  exit $reset"
echo
read -p "$ch" plugin
	if [ $plugin = "nextcloud" ]; then
		if checknc; then
			echo
			echo -e "$green$bold [NEXTCLOUD] chosen.$reset"
			echo -e "$bold 1: Apache "
			echo -e " 2: Nginx $reset"
			read -p "$ch" web
			if [ $web -eq 1 ]; then
				if [ $prog = "o" ]; then
						echo "    - o-nc-a" >> ../playbook.yaml
						PLUGINS+=('OFFICIAL-NEXTCLOUD-APACHE')
				else
						echo "    - l-nc-a" >> ../playbook.yaml
						PLUGINS+=('LOCAL-NEXTCLOUD-APACHE')
				fi
			else
				if [ $prog = "o" ]; then
						echo "    - o-nc-n" >> ../playbook.yaml
						PLUGINS+=('OFFICIAL-NEXTCLOUD-NGINX')
				else
						echo "    - l-nc-n" >> ../playbook.yaml
						PLUGINS+=('LOCAL-NEXTCLOUD-NGINX')
						generatessl
				fi
			fi
			echo
		else
			echo
                        echo -e "$red$bold [!] There is NEXTCLOUD plugin exists "
                        echo -e "     Remove it or continue; $reset"
                        echo
		fi
	fi
	if [ $plugin = "back" ]; then
		showinput
	fi
	if [ $plugin = "exit" ]; then
		echo -e "$green$bold contact: bhstalel@gmail.com $reset"
		exit
	fi
}

reset(){
PLUGINS=()
echo
echo "---" > ../playbook.yaml
echo "- hosts: localhost" >> ../playbook.yaml
echo "  roles:" >> ../playbook.yaml
echo -e "$bold [+] Done reseting .$reset"
echo
}

# Printing chosen plugins
ready(){
if [ ${#PLUGINS[@]} -eq 0 ]; then
	echo
	echo -e "$bold [-] No ready plugins $reset"
	echo
else
	echo
	echo -e "$yellow$bold [+] Chosen plugins: $reset"
	printf '%s\n' "  => ${PLUGINS[@]}"
	echo
fi

}

# Remove plugin
remove(){
if [ ${#PLUGINS[@]} -eq 0 ]; then
        echo
        echo -e "$bold [-] Plugins already clean $reset"
        echo
else
        echo
        echo " [+] Available plugins: "
        printf '%s\n' "  => ${PLUGINS[@]}"
        echo
	read -p "$ch" pl
	for target in "${pl[@]}"; do
		for i in "${!PLUGINS[@]}"; do
			if [[ ${PLUGINS[i]} = $pl ]]; then
				if [ $pl = "OFFICIAL-NEXTCLOUD-NGINX" ]; then
					sed -i '/o-nc-n/d' ./../playbook.yaml
				fi

				if [ $pl = "OFFICIAL-NEXTCLOUD-APACHE" ]; then
                                        sed -i '/o-nc-a/d' ./../playbook.yaml
                                fi

				if [ $pl = "LOCAL-NEXTCLOUD-NGINX" ]; then
                                        sed -i '/l-nc-n/d' ./../playbook.yaml
                                fi

				if [ $pl = "LOCAL-NEXTCLOUD-APACHE" ]; then
                                        sed -i '/l-nc-a/d' ./../playbook.yaml
                                fi
				unset 'PLUGINS[i]'
				echo
				echo -e "$bold [+] $pl removed $reset"
				echo
			fi
		done
	done
fi
}


showinput(){
read -p "$cmd" input
while [ -z $input ] || [ $input != "exit" ];
do
	case $input in
		"show")
			showoptions
			read -p "$cmd" input;;
		"add")
			add
			read -p "$cmd" input;;
		"remove")
			remove
			read -p "$cmd" input;;
		"ready")
			ready
			read -p "$cmd" input;;
		"reset")
			reset
			read -p "$cmd" input;;
		"run")
			ansible-playbook ../playbook.yaml
			read -p "$cmd" input;;
		"help")
			help
			read -p "$cmd" input;;
		"clear")
			clear
			read -p "$cmd" input;;
		"exit")
			exit;;
		*)
			read -p "$cmd" input;;
	esac

done

}


main(){

if [ $# -eq 0 ]; then
	prog="o"
else
	if [ $# -gt 1 ]; then
		echo -e "$red$bold [-] Invalid number of arguments $reset"
		exit
	fi
	if [ $# -eq 1 ]; then
		if [ $1 = "-l" ]; then
			prog="l"
		else
			echo -e "$red$bold [-] Invalid argument $reset"
			exit
		fi
	fi
fi

echo "---" > ../playbook.yaml
echo "- hosts: localhost" >> ../playbook.yaml
echo "  roles:" >> ../playbook.yaml

showinput
}

main $@
