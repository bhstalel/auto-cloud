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

: <<'END_COMMENT'
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
END_COMMENT



add(){
showoptions
echo -e "$bold  ---- $reset"
echo -e " $red$bold back"
echo -e "  exit $reset"
echo
read -p "$ch" plugin


	# NEXTCLOUD ADD
	if [ $plugin = "nextcloud" ]; then
			clear
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

			if [ $prog = "o" ]; then
				echo "    - o-nc-n" >> ../playbook.yaml
				PLUGINS+=('OFFICIALNEXTCLOUDNGINX')
			else
				echo "    - l-nc-n" >> ../playbook.yaml
				PLUGINS+=('LOCALNEXTCLOUDNGINX')
			fi

			echo

	fi # END NEXTCLOUD ADD

	if [ $plugin = "back" ]; then
		showinput
	fi
	if [ $plugin = "exit" ]; then
		echo -e "$green$bold contact: bhstalel@gmail.com $reset"
		exit 1
	fi

	# ADD ONLYOFFICE
	if [ $plugin = "onlyoffice" ]; then

		echo
		echo -e -n "$bold - onlyoffice domain: $reset"
		read oodomain
		newline="onlyoffice_domain: $oodomain"
       	sed -i '/onlyoffice_domain:.*/c\'"$newline" ../group_vars/all.yaml
		if [ $prog = "l" ]; then
			echo "    - l-oo-n" >> ../playbook.yaml
			PLUGINS+=('LOCALONLYFOFFICENGINX')
		else
			echo -e -n "$bold - email address: $reset"
			read ooemail
			newline="email: $ooemail"
			sed -i '/email:.*/c\'"$newline" ../group_vars/all.yaml
			echo "    - o-oo-n" >> ../playbook.yaml
			PLUGINS+=('OFFICIALONLYOFFICENGINX')
		fi
	fi # END ADD ONLYOFFICE
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
				if [ $pl = "OFFICIALNEXTCLOUDNGINX" ]; then
					sed -i '/o-nc-n/d' ./../playbook.yaml
				fi
				if [ $pl = "LOCALNEXTCLOUDNGINX" ]; then
                    sed -i '/l-nc-n/d' ./../playbook.yaml
                fi
				if [ $pl = "LOCALONLYOFFICENGINX" ]; then
					sed -i '/l-oo-n/d' ./../playbook.yaml
				fi
				if [ $pl = "OFFICIALONLYOFFICENGINX" ]; then
					sed -i '/o-oo-n/d' ./../playbook.yaml
				fi
				if [ $pl = "OFFICIALCOLLABORA" ]; then
					sed -i '/o-c/d' ./../playbook.yaml
				fi
				if [ $pl = "LOCALCOLLABORA" ]; then
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

# Installing Onlyoffice with Nextcloud on same host with NGINX
nco_together(){
	newline="onlyoffice_with_nextcloud: 1"
	sed -i '/onlyoffice_with_nextcloud:.*/c\'"$newline" ../group_vars/all.yaml
	clear
	echo
	echo -e "$bold # ONLYOFFICE will be installed with NEXTCLOUD $reset"
	read -p "pressenter" x
	ansible-playbook ../playbook.yaml
	echo "$bold$green # ONLYOFFICE installed and integrated perfectly."
	echo
}

nco_not_together(){
	newline="onlyoffice_with_nextcloud: 0"
	sed -i '/onlyoffice_with_nextcloud:.*/c\'"$newline" ../group_vars/all.yaml
	echo
	clear
	echo
	echo -e "$bold # ONLYOFFICE will be installed separatly $reset"
	read -p "pressenter" x
	ansible-playbook ../playbook.yaml
	echo
	clear
	echo
	echo "$bold$green # ONLYOFFICE installed perfectly "
	echo " # If you want to integrate it with nextcloud: "
	echo " # Make sure to: "
	echo "   copy auto-cloud/other/config.php to [other-host]/var/www/nextcloud/config/ of you nextcloud installation "
	echo
}

run(){
if [ ${#PLUGINS[@]} -eq 0 ]; then
	echo
	echo -e "$red$bold [!] No plugin specified. $reset"
	echo
	showinput
elif [ ${#PLUGINS[@]} -eq 1 ]; then

	#Checking for only ONLYOFFICE;
	if [[  " ${PLUGINS[1]} " = " ${LOCALONLYFOFFICENGINX} " ]]; then
		if [[ ! " ${PLUGINS[1]} " = " ${OFFICIALONLYFOFFICENGINX} " ]]; then
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
		else
			if [[ " ${PLUGINS[1]} " =~ " ${LOCALNEXTCLOUDNGINX} " ]]; then
				if [[ " ${PLUGINS[1]} " =~ " ${OFFICIALNEXTCLOUDNGINX} " ]]; then
					echo -e "$bold [Only nextcloud selected] $reset"
					read -p "$pressenter" enter
					ansible-playbook ../playbook.yaml
				else
					echo -e "$bold Installing other then Nextcloud or ONLYOFFICE $reset"
					echo
				fi
			fi
		fi
	fi

else
	echo " MORE THEN 1 plugin "
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
echo -e " | # --list   : to list plugins "
echo -e " | # --local  : for local installation "
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
	# IF MORE THEN ONE ARGUMENT
	if [ $# -gt 1 ]; then

		# IF 2 ARGUMENTS
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

		# IF 3 ARGUMENTS
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

	# 1 ARGUMENT
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