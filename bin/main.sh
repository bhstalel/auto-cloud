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
pressenter=`echo -e "$bold [PRESS ENTER TO CONTINUE] $reset"`

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
echo " | nextcloud   [OK]| "
echo " | onlyoffice  [OK]| "
echo " | collabora   [OK]| "
echo " | draw        [OK]| "
echo " | ownpad      [NO]| "
echo " | talk        [OK]| "
echo -e " +=================+ $reset"
echo
}


generatessl(){
echo
echo -e "$yellow$bold [NOTE]: You'r installing nextcloud locally, "
echo -e "         so we need to generate a self-signed certificate. $reset"
echo
echo -e "$bold ----- $reset"
echo -e "$bold 1: continue "
echo -e " 2: back "
echo -e " 3: exit "
echo
read -p "$ch" n
if [ $n -eq 1 ]; then
	openssl genrsa -out ../ssl/nextcloud.key
	openssl req -new -key ../ssl/nextcloud.key -out ../ssl/d.req -subj "/C=TN/ST=Example/L=Example/O=Global Security/OU=IT Department/CN=domain.com"
	openssl x509 -req -days 365 -in ../ssl/d.req -signkey ../ssl/nextcloud.key -out ../ssl/nextcloud.crt
	echo
	echo -e " $green$bold [SSLCertificate] Generated in auto-cloud/ssl/ $reset"
	echo
elif [ $n -eq 2 ]; then
	add
elif [ $n -eq 3 ]; then
	exit 1
else
	echo -e "$red$bold Wrong choice, back $reset"
	add
fi
}

generateonlyofficessl(){
echo
echo -e "$yellow$bold [NOTE]: You'r installing ONLYOFFICE locally, "
echo -e "         so we need to generate a self-signed certificate. $reset"
echo
echo -e "$bold ----- $reset"
echo -e "$bold 1: continue "
echo -e " 2: back "
echo -e " 3: exit "
echo
read -p "$ch" n
if [ $n -eq 1 ]; then
	openssl genrsa -out ../ssl/onlyoffice.key
	openssl req -new -key ../ssl/onlyoffice.key -out ../ssl/o.req -subj "/C=TN/ST=Example/L=Example/O=Global Security/OU=IT Department/CN=domain.com"
	openssl x509 -req -days 365 -in ../ssl/o.req -signkey ../ssl/onlyoffice.key -out ../ssl/onlyoffice.crt
	echo
	echo -e " $green$bold [SSLCertificate] Generated in auto-cloud/ssl/onlyoffice.{key&&crt} $reset"
	echo
elif [ $n -eq 2 ]; then
        showinput
elif [ $n -eq 3 ]; then
        exit
else
        echo -e "$red$bold Wrong choice, back $reset"
        showinput
fi
}

# Check for existing NEXTCLOUD plugin
checknc(){
#if [ -d "/var/www/nextcloud" ]; then
	#echo -e "$red$bold [!] Nexcloud is already exist in: /var/www/nextcloud , remove it first $reset"
#	return 1
#fi
for each in "${PLUGINS[@]}"
do
	if [ $each = "OFFICIAL-NEXTCLOUD-APACHE" ] || [ $each = "OFFICIAL-NEXTCLOUD-NGINX" ] || [ $each = "LOCAL-NEXTCLOUD-APACHE" ] || [ $each = "LOCAL-NEXTCLOUD-NGINX" ]; then
		return 1
	fi
done
return 0
}

# Check for existing ONLYOFFICE plugin
checkoo(){
for each in "${PLUGINS[@]}"
do
	if [ $each = "OFFICIAL-ONLYOFFICE-NGINX" ] || [ $each = "OFFICIAL-ONLYOFFICE-APACHE" ] || [ $each = "LOCAL-ONLYOFFICE-NGINX" ] || [ $each = "LOCAL-ONLYOFFICE-APACHE" ]; then
		return 0
	fi
return 1
done
}

# Check for collabora
collabora(){
for each in "${PLUGINS[@]}"
do
        if [ $each = "OFFICIAL-COLLABORA" ] || [ $each = "LOCAL-COLLABORA" ]; then
                return 1
        fi
return 0
done
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
			echo -e "$bold [NEXTCLOUD] chosen.$reset"
			echo
			echo -e "$yellow$bold              NOTE   "
			echo -e " You need to input some informations: "
			echo -e " # nextcloud domain "
			echo -e " # db username "
			echo -e " # db password "
			echo -e " ------ $reset"
			echo -e "$bold 1: continue "
			echo -e " 2: back "
			echo
			read -p "$ch" info
			if [ $info -eq 1 ]; then
				echo -e -n "$bold - nextcloud domain: $reset"
				read ncdomain
				newline="nextcloud_domain: $ncdomain"
                        	sed -i '/nextcloud_domain.*/c\'"$newline" ../group_vars/all.yaml
				echo -e -n "$bold - db username: $reset"
                                read dbusername
                                newline="nextcloud_username: $dbusername"
                                sed -i '/nextcloud_username.*/c\'"$newline" ../group_vars/all.yaml
				echo -e -n "$bold - db password: $reset"
                                read dbpassword
                                newline="nextcloud_userpass: $dbpassword"
                                sed -i '/nextcloud_userpass.*/c\'"$newline" ../group_vars/all.yaml
			else
				showinput
			fi
			echo
			echo -e "$bold [!] Setting up the webserver $reset"
			echo
			echo -e "$bold 1: Apache "
			echo -e " 2: Nginx $reset"
			echo
			echo -e "$bold ---- $reset"
			echo -e "$red$bold 3: back "
			echo -e " 4: exit $reset"
			read -p "$ch" web
			if [ $web -eq 1 ]; then
				if [ $prog = "o" ]; then
						echo "    - o-nc-a" >> ../playbook.yaml
						PLUGINS+=('OFFICIAL-NEXTCLOUD-APACHE')
				else
						echo "    - l-nc-a" >> ../playbook.yaml
						PLUGINS+=('LOCAL-NEXTCLOUD-APACHE')
				fi
			elif [ $web -eq 2 ]; then
				if [ $prog = "o" ]; then
						echo "    - o-nc-n" >> ../playbook.yaml
						PLUGINS+=('OFFICIAL-NEXTCLOUD-NGINX')
				else
						echo "    - l-nc-n" >> ../playbook.yaml
						PLUGINS+=('LOCAL-NEXTCLOUD-NGINX')
						generatessl
				fi
			elif [ $web -eq 3 ]; then
				showinput
			elif [ $web -eq 4 ]; then
				exit 1
			else
				echo -e "$red$bold Wrong choice, back $reset"
				showinput
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
		exit 1
	fi
	if [ $plugin = "onlyoffice" ]; then
		if checkoo; then
			if collabora; then
				echo -e -n "$bold - onlyoffice domain: $reset"
				read oodomain
				newline="onlyoffice_domain: $oodomain"
       		         	sed -i '/onlyoffice_domain:.*/c\'"$newline" ../group_vars/all.yaml
				if [ $prog = "l" ]; then
					echo "    - l-oo-n" >> ../playbook.yaml
					PLUGINS+=('LOCAL-ONLYFOFFICE-NGINX')
					generateonlyofficessl
				else
					echo -e -n "$bold - email address: $reset"
					read ooemail
					newline="email: $ooemail"
					sed -i '/email:.*/c\'"$newline" ../group_vars/all.yaml
					echo "    - o-oo-n" >> ../playbook.yaml
					PLUGINS+=('OFFICIAL-ONLYOFFICE-NGINX')
				fi
			else
				echo
                                echo -e "$red$bold [-] Cannot install onlyoffice with collabora. $reset"
                                echo
			fi
		else
						echo
                        echo -e "$red$bold [!] There is ONLYOFFICE plugin exists "
                        echo -e "     Remove it or continue; $reset"
                        echo
		fi
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
	echo -e "$bold [+] Chosen plugins: $reset"
	for i in "${PLUGINS[@]}"
	do
		echo -e "$bold  - $i $reset"
	done
	#printf '%s\n' "  => ${PLUGINS[@]}"
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
        echo -e "$bold [+] Available plugins: $reset"
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
				if [ $pl = "LOCAL-ONLYOFFICE-NGINX" ]; then
					sed -i '/l-oo-n/d' ./../playbook.yaml
				fi
				if [ $pl = "OFFICIAL-ONLYOFFICE-NGINX" ]; then
					sed -i '/o-oo-n/d' ./../playbook.yaml
				fi
				if [ $pl = "OFFICIAL-COLLABORA" ]; then
					sed -i '/o-c/d' ./../playbook.yaml
				fi
				if [ $pl = "LOCAL-COLLABORA" ]; then
					sed -i '/l-c/d' ./../playbook.yaml
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

# Installing Onlyoffice with Nextcloud on same host
nco_together(){
	clear
	echo 
	echo -e "$bold # You have to specify other ports "
	echo -e -n " # HTTP port: "
	read httpport
	echo -e -n " # HTTPS port: "
	read httpsport
	newline="port_http: $httpport"
	sed -i '/port_http:.*/c\'"$newline" ../group_vars/all.yaml
	newline="port_https: $httpsport"
	sed -i '/port_https:.*/c\'"$newline" ../group_vars/all.yaml
	echo 
	ansible-playbook ../playbook.yaml
}


nco_not_together(){
	echo
	echo -e "$bold [coming] ONLYOFFICE on # host $reset"
}

run(){
if [ ${#PLUGINS[@]} -eq 0 ]; then
	echo
	echo -e "$red$bold [!] No plugin specified. $reset"
	echo
	showinput
elif [ ${#PLUGINS[@]} -eq 1 ]; then
	#Checking for only ONLYOFFICE;
	if checkoo; then
		if checknc; then
			echo -e "$bold Installing other then Nextcloud or ONLYOFFICE $reset"
			echo
		else
			echo -e "$bold [Only nextcloud selected] $reset"
			read -p "$pressenter" enter
			ansible-playbook ../playbook.yaml
		fi
	else
		clear
		echo
		echo -e "$bold # You'r about to install just ONLYOFFICE ; "
		echo -e " # If you want to integrate it with NEXTCLOUD, please specify "
		echo -e " # and you will be asked to choose a 2 port numbers for HTTP & HTTPS access, "
		echo -e " # because they can't work with same 80 & 443 ports in same machine ; "
		echo -e " ----- $reset";
		echo
		read -p " [HIT ENTER TO CONTINUE] " e
		echo -e "$bold 1: Nextcloud and onlyoffice on same host  $reset"
		echo -e "$bold 2: Onlyoffice in a different host "
		echo -e "$bold ------ $reset"
		echo -e "$red$bold 3: back "
		echo -e " 4: exit $reset"
		echo
		read -p "$ch" choice
		if [ $choice -eq 1 ]; then
			nco_together
		elif [ $choice -eq 2 ]; then
			nco_not_together
		elif [ $choice -eq 3 ]; then
			showinput
		else
			exit 1
		fi
		echo
		ansible-playbook ../playbook.yaml
	fi
fi
}

showinput(){
echo
echo -e "$bold [*] Type help for available commands $reset"
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
			run
			#ansible-playbook ../playbook.yaml
			read -p "$cmd" input;;
		"help")
			help
			read -p "$cmd" input;;
		"clear")
			clear
			read -p "$cmd" input;;
		"exit")
			exit 1;;
		*)
			read -p "$cmd" input;;
	esac

done

}


testplugins(){

echo "testing plugins"
echo
echo -e "$bold Passed plugins: $1 $reset"
echo
return 0
}

startwithplugins(){
echo
echo -e "$bold Starting with plugins: $1 $reset"
echo
exit
}

helpmenu(){
echo
echo -e "$blue$bold +"
echo -e " | [ARGUMENTS]:  "
echo -e " | "
echo -e " | # --local : for local installation "
echo -e " | # --plugin : "
echo -e " | 	> to specify plugins from arguments like: "
echo -e " | 	# --plugin nextcloud,onlyoffice  "
echo -e " | 	# --plugin nextcloud,collabora "
echo -e " | "
echo -e " | [NOTE]:"
echo -e " | "
echo -e " | 	You can specify: "
echo -e " | 	# --local --plugin together "
echo -e " |	# --plugin lonely for official domain "
echo -e " |	# --local lonely and specify with menu "
echo -e " |	# no arguments: choose with menu to official domain"
echo -e " + $reset"
exit
}


listplugins(){
file="../group_vars/plugins"
echo
echo -e "$green$bold [ Available plugins ] $reset"
while IFS= read line
do
	echo -e "$bold # $line $reset"
done <"$file"
echo
}


main(){

dir=`pwd`
acdir="$(dirname "$dir")"
newline="autocloud_dir: $acdir"
sed -i '/autocloud_dir:.*/c\'"$newline" ../group_vars/all.yaml

if [ $# -eq 0 ]; then
	clear
	prog="o"
	echo 
	echo -e "$yellow$bold +-------------------------------------------------+"
	echo -e " |                                                 |"
	echo -e " |                     NOTE                        |"
	echo -e " | You did not specify arguments that means every  |"
	echo -e " | installation will be official for a registered  |"
	echo -e " | DNS domain, if you want a local installation    |"
	echo -e " | or other options see : --help arguemnt.         |"
	echo -e " |                                                 |"
	echo -e " +-------------------------------------------------+ $reset"
else
	if [ $# -gt 1 ]; then
		if [ $# -eq 2 ]; then
			if [ $1 = "--plugin" ]; then
				if testplugins $2; then
					startwithplugins $2
				else
					echo -e "$red$bold [!] Wrong plugins : see --help $reset"
					exit 1
				fi
			fi #End of if plugin
			if [ $1 = "--local" ]; then
				echo -e "$red$bold [!] Wrong arguments : see --help $reset"
				exit 1
			fi
		elif [ $# -eq 3 ]; then
			if [ $1 = "--local" ] && [ $2 = "--plugin" ]; then
				if testplugins $3; then
					startwithplugins $3
				else
					echo -e "$red$bold [!] Wrong plugins : see --help $reset"
					exit 1
				fi
			else
				echo -e "$red$bold [!] Wrong arguments : see --help $reset"
				exit 1
			fi
		else
			echo -e "$red$bold [-] Invalid number of arguments : see --help $reset"
			exit 1
		fi
	fi
	if [ $# -eq 1 ]; then
		if [ $1 = "--local" ]; then
			prog="l"
			clear
			echo
			echo -e "$yellow$bold [ # local option specified;  "
			echo -e " [ # all installation will be local; "
			echo -e " [ # restart with --help for more details ; $reset"
			echo
		elif [ $1 = "--help" ]; then
			helpmenu
		elif [ $1 = "--list" ]; then
			listplugins
			exit 1
		else
			echo -e "$red$bold [-] Invalid argument : see --help $reset"
			exit 1
		fi
	fi
fi

echo "---" > ../playbook.yaml
echo "- hosts: localhost" >> ../playbook.yaml
echo "  roles:" >> ../playbook.yaml

showinput
}

main $@
