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

	if [ $input = "show" ]; then
		showoptions
		read -p " [auto-cloud]: " input
	elif [ $input = "add" ]; then
		add
		read -p " [auto-cloud]: " input
	elif [ $input = "reset" ]; then
		reset
		read -p " [auto-cloud]: " input
	elif [ $input = "run" ]; then
		ansible-playbook ../playbook.yaml
		read -p " [auto-cloud]: " input
	elif [ $input = "help" ]; then
		help
		read -p " [auto-cloud]: " input
	elif [ $input = "exit" ]; then
		exit
	else
		echo " [!] See 'help' "
		read -p " [auto-cloud]: " input
	fi

done

}

main $@
