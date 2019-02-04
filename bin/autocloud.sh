#!/bin/bash

# +============================+

bold="\e[1m"
underline="\e[4m"
reset="\e[0m"
red="\e[31m"
green="\e[32m"
blue="\e[34m"
yellow="\e[33m"

# +============================+

READY=()
ch=`echo -e "$bold [$green choice$reset $bold]$ $reset "`
pressenter=`echo -e "$bold [PRESS ENTER TO CONTINUE] $reset"`
regex="^[a-z0-9!#\$%&'*+/=?^_\`{|}~-]+(\.[a-z0-9!#$%&'*+/=?^_\`{|}~-]+)*@([a-z0-9]([a-z0-9-]*[a-z0-9])?\.)+[a-z0-9]([a-z0-9-]*[a-z0-9])?\$"

# +============================+

ncdbuser=`cat ../group_vars/all.yaml | sed -n -e 's/^.*nextcloud_username: //p'`
ncdbpass=`cat ../group_vars/all.yaml | sed -n -e 's/^.*nextcloud_userpass: //p'`
ncdm=`cat ../group_vars/all.yaml | sed -n -e 's/^.*nextcloud_domain: //p'`
webserv=`cat ../group_vars/all.yaml | sed -n -e 's/^.*webserver: //p'`
dbtype=`cat ../group_vars/all.yaml | sed -n -e 's/^.*dbtype: //p'`
state=`cat ../group_vars/all.yaml | sed -n -e 's/^.*state: //p'`
email=`cat ../group_vars/all.yaml | sed -n -e 's/^.*email: //p'`
oodm=`cat ../group_vars/all.yaml | sed -n -e 's/^.*onlyoffice_domain: //p'`
drdm=`cat ../group_vars/all.yaml | sed -n -e 's/^.*draw_domain: //p'`

# +============================+

# +============================+
# [       HELP FONCTION        ]
HELPMENU(){
echo
echo -e "$bold +==========# ARGS #==========+ "
echo -e "$bold |                            |"
echo -e "$bold |  + help                    |  $blue[show this menu]$reset"
echo -e "$bold |                            |" 
echo -e "$bold |  + list                    |  $blue[list plugins]$reset"
echo -e "$bold |                            |"
echo -e "$bold |  + init                    |  $blue[reset variables]$reset"
echo -e "$bold |                            |"
echo -e "$bold |  + config                  |  $blue[show variables]$reset"
echo -e "$bold |                            |"
echo -e "$bold |  + run plug1,plug2,..      |  $blue[run plug1,plug2,..]$reset"
echo -e "$bold |                            |"
echo -e "$bold |  + set var value           |  $blue[edit var's value]$reset"
echo -e "$bold |                            |"
echo -e "$bold +==========# VARS #==========+ "
echo -e "$bold |                            |"
echo -e "$bold |  + state                   | $blue [l=local,o=official]$reset"
echo -e "$bold |                            |"
echo -e "$bold |  + ncdbuser                | $blue [nextcloud_username]$reset"
echo -e "$bold |                            |"
echo -e "$bold |  + ncdbpass                | $blue [nextcloud_userpass]$reset"
echo -e "$bold |                            |"
echo -e "$bold |  + ncdm                    | $blue [nextcloud_domain]$reset"
echo -e "$bold |                            |"
echo -e "$bold |  + oodm                    | $blue [onlyoffice_domain]$reset"
echo -e "$bold |                            |"
echo -e "$bold |  + codm                    | $blue [collabora_domain]$reset"
echo -e "$bold |                            |"
echo -e "$bold |  + drdm                    | $blue [draw_domain]$reset"
echo -e "$bold |                            |"
echo -e "$bold |  + email                   | $blue [email]$reset"
echo -e "$bold |                            |"
echo -e "$bold |  + webserver               | $blue [a=apache,n=nginx]$reset"
echo -e "$bold |                            |"
echo -e "$bold |  + dbtype                  | $blue [m=mysql,p=postgresql]$reset"
echo -e "$bold |                            |"
echo -e "$bold +============================+"
echo -e "$reset"
}

# +============================+
# [ Show available plugins     ]
SHOWPLUGINS(){
echo
echo -e "$bold +=========# PLUGS #==========+"
echo -e "$bold |                            |"
echo -e "$bold |  + nextcloud               |"
echo -e "$bold |                            |"
echo -e "$bold |  + onlyoffice              |"
echo -e "$bold |                            |"
echo -e "$bold |  + collabora               |"
echo -e "$bold |                            |"
echo -e "$bold |  + Talk                    |"
echo -e "$bold |                            |"
echo -e "$bold |  + Draw                    |"
echo -e "$bold |                            |"
echo -e "$bold +============================+$reset"
echo
}

# +============================+
# [ Initialise all variables   ]
INITFILE(){
newline="state:"
sed -i '/state.*/c\'"$newline" ../group_vars/all.yaml
newline="nextcloud_username:"
sed -i '/nextcloud_username.*/c\'"$newline" ../group_vars/all.yaml
newline="nextcloud_userpass:"
sed -i '/nextcloud_userpass.*/c\'"$newline" ../group_vars/all.yaml
newline="nextcloud_domain:"
sed -i '/nextcloud_domain.*/c\'"$newline" ../group_vars/all.yaml
newline="onlyoffice_domain:"
sed -i '/onlyoffice_domain.*/c\'"$newline" ../group_vars/all.yaml
newline="collabora_domain:"
sed -i '/collabora_domain.*/c\'"$newline" ../group_vars/all.yaml
newline="webserver:"
sed -i '/webserver.*/c\'"$newline" ../group_vars/all.yaml
newline="email:"
sed -i '/email.*/c\'"$newline" ../group_vars/all.yaml
newline="dbtype:"
sed -i '/dbtype.*/c\'"$newline" ../group_vars/all.yaml
newline="draw_domain:"
sed -i '/draw_domain.*/c\'"$newline" ../group_vars/all.yaml
}


# +============================+
# [       Show variables       ]
SHOWCONF(){
echo
echo -e "$bold +=========# VARS #=======+=========# VALUES #=======+ $reset"
echo -e "$bold |                        |"
state=`cat ../group_vars/all.yaml | sed -n -e 's/^.*state: //p'`
if [ -z "$state" ]; then
	echo -e "$bold | + state                :         $red[NOT SET]$reset"
else
	echo -e "$bold | + state                :         $blue$state$reset"
fi
echo -e "$bold |                        |"
ncdbuser=`cat ../group_vars/all.yaml | sed -n -e 's/^.*nextcloud_username: //p'`
if [ -z "$ncdbuser" ]; then
	echo -e "$bold | + nextcloud_username   :         $red[NOT SET]$reset"
else
	echo -e "$bold | + nextcloud_username   :         $blue$ncdbuser$reset"
fi

echo -e "$bold |                        |"
ncdbpass=`cat ../group_vars/all.yaml | sed -n -e 's/^.*nextcloud_userpass: //p'`
if [ -z "$ncdbpass" ]; then
	echo -e "$bold | + nextcloud_userpass   :         $red[NOT SET]$reset"
else
	echo -e "$bold | + nextcloud_userpass   :         $blue$ncdbpass$reset"
fi

echo -e "$bold |                        |"
ncdm=`cat ../group_vars/all.yaml | sed -n -e 's/^.*nextcloud_domain: //p'`
if [ -z "$ncdm" ]; then
	echo -e "$bold | + nextcloud_domain     :         $red[NOT SET]$reset"
else
	echo -e "$bold | + nextcloud_domain     :         $blue$ncdm$reset"
fi

echo -e "$bold |                        |"
oodm=`cat ../group_vars/all.yaml | sed -n -e 's/^.*onlyoffice_domain: //p'`
if [ -z "$oodm" ]; then
	echo -e "$bold | + onlyoffice_domain    :         $red[NOT SET]$reset"
else
	echo -e "$bold | + onlyoffice_domain    :         $blue$oodm$reset"
fi

echo -e "$bold |                        |"
codm=`cat ../group_vars/all.yaml | sed -n -e 's/^.*collabora_domain: //p'`
if [ -z "$codm" ]; then
	echo -e "$bold | + collabora_domain     :         $red[NOT SET]$reset"
else
	echo -e "$bold | + collabora_domain     :         $blue$codm$reset"
fi

echo -e "$bold |                        |"
drdm=`cat ../group_vars/all.yaml | sed -n -e 's/^.*draw_domain: //p'`
if [ -z "$codm" ]; then
	echo -e "$bold | + draw_domain          :         $red[NOT SET]$reset"
else
	echo -e "$bold | + draw_domain          :         $blue$drdm$reset"
fi

echo -e "$bold |                        |"
email=`cat ../group_vars/all.yaml | sed -n -e 's/^.*email: //p'`
if [ -z "$email" ]; then
	echo -e "$bold | + email                :         $red[NOT SET]$reset"
else
	echo -e "$bold | + email                :         $blue$email$reset"
fi

echo -e "$bold |                        |"
webserv=`cat ../group_vars/all.yaml | sed -n -e 's/^.*webserver: //p'`
if [ -z "$webserv" ]; then
	echo -e "$bold | + webserver            :         $red[NOT SET]$reset"
else
	echo -e "$bold | + webserver            :         $blue$webserv$reset"
fi

echo -e "$bold |                        |"
dbtype=`cat ../group_vars/all.yaml | sed -n -e 's/^.*dbtype: //p'`
if [ -z "$dbtype" ]; then
	echo -e "$bold | + dbtype               :         $red[NOT SET]$reset $reset"
else
	echo -e "$bold | + dbtype               :         $blue$dbtype$reset"
fi
echo -e "$bold |                        |"
echo -e "$bold +========================+==========================+ $reset"
echo

}


# +============================+
# [        TEST DOMAIN         ]
TESTDOMAIN(){
	while ! ping -c1 $1 &>/dev/null 
	do 
		return 1
	done
		return 0
}


# +============================+
# [        TEST EMAIL          ]
TESTEMAIL(){
	if [[ "$email" =~ "$regex" ]]; then
		return 0
	fi
	return 1
}

# +============================+
# [         RUN TALK           ]
RUNTALK(){
	if [ -z "$ncdm" ]; then
		echo
		echo -e "$bold [#] Please set [ncdm] for Talk $reset"
		echo
		return 1
	else
		if [ -z "$state" ]; then
			echo
			echo -e "$bold [#] Please set [state]$reset"
			echo
			return 1
		else
			if ! TESTDOMAIN "$ncdm"; then
				echo
				echo -e "$bold [#] Cannot ping [$ncdm] $reset"
				echo
				return 1
			else
				echo "    - t-nc" >> ../playbook.yaml
				return 0
			fi
		fi
	fi
}

# +============================+
# [       RUN NEXTCLOUD        ]
RUNNCWITHVARS(){
	if [ "$state" = "o" ]; then
		if ! TESTDOMAIN "$ncdm"; then
			echo
			echo -e "$bold [#] Cannot ping [$ncdm] $reset"
			echo
			return 1
		else
			if TESTEMAIL "$email"; then
				echo
				echo -e "$bold [#] Email [$email] invalid $reset"
				echo
				return 1
			fi
		fi
	fi
	return 0
}


# +============================+
# [       RUN ONLYOFFICE       ]
RUNOOWITHVARS(){
	if [ "$state" = "o" ]; then
		if ! TESTDOMAIN "$oodm"; then
			echo
			echo -e "$bold [#] Cannot ping [$oodm] $reset"
			echo
			return 1
		else
			if TESTEMAIL "$email"; then
				echo
				echo -e "$bold [#] Email [$email] invalid $reset"
				echo
				return 1
			else
				return 0
			fi
		fi
	fi
	return 0
}


# +============================+
# [       RUN COLLABORA        ]
RUNCOWITHVARS(){
	if [ "$state" = "o" ]; then
		if ! TESTDOMAIN "$codm"; then
			echo
			echo -e "$bold [#] Cannot ping [$codm] $reset"
			echo
			return 1
		else
			if TESTEMAIL "$email"; then
				echo
				echo -e "$bold [#] Email [$email] invalid $reset"
				echo
				return 1
			fi
		fi
	fi
	return 0
}

# +============================+
# [       RUN COLLABORA        ]
RUNDRWITHVARS(){
	if [ "$state" = "o" ]; then
		if ! TESTDOMAIN "$drdm"; then
			echo
			echo -e "$bold [#] Cannot ping [$drdm] $reset"
			echo
			return 1
		else
			if TESTEMAIL "$email"; then
				echo
				echo -e "$bold [#] Email [$email] invalid $reset"
				echo
				return 1
			fi
		fi
	fi
	return 0
}


# +============================+
# [       RUN COLLABORA        ]
RUNCOLLABORA(){
	if [ -z "$codm" ]; then
		echo
		echo -e "$bold [#] Please set [codm] for collabora $reset"
		echo
		return 1
	else
		if [ -z "$webserv" ]; then
			echo
			echo -e "$bold [#] Please set [webserv] for collabora $reset"
			echo
			return 1
		else
			if [ "$state" = "o" ]; then
				if [ -z "$email" ]; then
					echo
					echo -e "$bold [#] Please set [email] for collabora $reset"
					echo
					return 1
				else
					if ! RUNCOWITHVARS; then
						return 1
					else
						echo "    - collabora" >> ../playbook.yaml
						return 0
					fi
				fi
			else
				if ! RUNCOWITHVARS; then
					return 1
				else
					echo "    - collabora" >> ../playbook.yaml
					return 0
				fi
			fi
		fi
	fi
}


# +============================+
# [       RUN ONLYOFFICE       ]
RUNONLYOFFICE(){
	# +==================================================+
	# | Testing: oodm , email , webserv , state , dbtype |
	# +==================================================+
	if [ -z "$oodm" ]; then
		echo
		echo -e "$bold [#] Please set [oodm] for onlyoffice $reset"
		echo
		return 1
	else
		if [ -z "$webserv" ]; then
			echo
			echo -e "$bold [#] Please set [webserv] for onlyoffice $reset"
			echo
			return 1
		else
			if [ -z "$dbtype" ]; then
				echo
				echo -e "$bold [#] Please set [dbtype] for onlyoffice $reset"
				echo
				return 1
			else
				if [ -z "$state" ]; then
					echo
					echo -e "$bold [#] Please set [state] for onlyoffice $reset"
					echo
					return 1
				else
					if [ "$state" = "o" ]; then
						if [ -z "$email" ]; then
							echo
							echo -e "$bold [#] Please set [email] for onlyoffice $reset"
							echo
							return 1
						else
							if ! RUNOOWITHVARS; then
								return 1
							else
								echo "    - onlyoffice" >> ../playbook.yaml
								return 0
							fi
						fi
					else
						if ! RUNOOWITHVARS; then
							return 1
						else
							echo "    - onlyoffice" >> ../playbook.yaml
							return 0
						fi
					fi
				fi
			fi
		fi
	fi
}


# +============================+
# [         RUN DRAW           ]
RUNDRAW(){
	if [ -z "$drdm" ]; then
		echo
		echo -e "$bold [#] Please set [drdm] for draw $reset"
		echo
		return 1
	else
		if [ -z "$state" ]; then
			echo
			echo -e "$bold [#] Please set [state] for draw $reset"
			echo
			return 1
		else
			if [ "$state" = "o" ]; then		
				if [ -z "$email" ]; then
					echo
					echo -e "$bold [#] Please set [email] for draw $reset"
					echo
					return 1
				else
					if ! RUNDRWITHVARS; then
						return 1
					else
					echo "    - draw" >> ../playbook.yaml
					return 0
				fi
			fi
			else
				if ! RUNDRWITHVARS; then
					return 1
				else
					echo "    - draw" >> ../playbook.yaml
					return 0
				fi
			fi
		fi

	fi
}



# +============================+
# [       RUN NEXTCLOUD        ]
RUNNEXTCLOUD(){
	# +================================================================+
	# | Testing: ncdbuser , ncdbpass , ncdm , webserv , state , dhtype |
	# +================================================================+
	if [ -z "$ncdbuser" ]; then
		echo
		echo -e "$bold [#] Please set [ncdbuser] for nextcloud $reset"
		echo
		return 1
	else
		if [ -z "$ncdbpass" ]; then
			echo
			echo -e "$bold [#] Please set [ncdbpass] for nextcloud $reset"
			echo
			return 1
		else
			if [ -z "$ncdm" ]; then
				echo
				echo -e "$bold [#] Please set [ncdm] for nextcloud $reset"
				echo
				return 1
			else
				if [ -z "$webserv" ]; then
					echo
					echo -e "$bold [#] Please set [webserv] for nextcloud $reset"
					echo
					return 1
				else
					if [ -z "$dbtype" ]; then
						echo
						echo -e "$bold [#] Please set [dhtype] for nextcloud $reset"
						echo
						return 1
					else
						if [ -z "$state" ]; then
							echo
							echo -e "$bold [#] Please set [state] for nextcloud $reset"
							echo
							return 1
						else
							if [ "$state" = "o" ]; then		
								if [ -z "$email" ]; then
									echo
									echo -e "$bold [#] Please set [email] for nextcloud $reset"
									echo
									return 1
								else
									if ! RUNNCWITHVARS; then
										return 1
									else
										echo "    - nextcloud" >> ../playbook.yaml
										return 0
									fi
								fi
							else
								if ! RUNNCWITHVARS; then
									return 1
								else
									echo "    - nextcloud" >> ../playbook.yaml
									return 0
								fi
							fi
						fi
					fi
				fi
			fi
		fi
	fi
}


# +============================+
# [       TEST PLUGINS         ]
TESTPLUGINS(){
char=","
if [[ "$1" == *","* ]]; then
	echo "There is ,"
	echo "$1" | awk -F"${char}" '{print NF}'
else
	case "$1" in
		"nc"|"nextcloud") 
			if RUNNEXTCLOUD; then
				ansible-playbook ../playbook.yaml
			fi
		;;
		"oo"|"onlyoffice") 
			if RUNONLYOFFICE; then
				ansible-playbook ../playbook.yaml
			fi
		;;
		"co"|"collabora") 
		if RUNCOLLABORA; then
			ansible-playbook ../playbook.yaml
		fi
		;;
		"t"|"talk") 
		if RUNTALK; then
			ansible-playbook ../playbook.yaml
		fi
		;;
		"dr"|"draw") 
		if RUNDRAW; then
			ansible-playbook ../playbook.yaml
		fi
		;;
		"ow"|"ownpad") echo "Testing and running ownpad" ;;
		*) PLUGERR ;;
	esac
fi

}


# +============================+
# [         ARG ERROR          ]
ARGERROR(){
echo
echo -e "$bold [!] Error some where "
echo -e " [#] See: bash autocloud.sh help $reset"
echo
}


# +============================+
# [         ARG ERROR          ]
PLUGERR(){
echo
echo -e "$bold [#] Plugin not found $reset"
echo
}

# +============================+
# [       NO ARG ERROR         ]
NOARGERROR(){
echo
echo -e "$bold [!] You have to specify arguments "
echo -e " [#] See: bash autocloud.sh help $reset"
echo
}

# +============================+
# [      VAR NOT FOUND         ]
VARNOTFOUND(){
echo
echo -e "$bold ["$1"] Not found $reset"
echo
}

# +============================+
# [ Set: state [local/official ] 
SETSTATE(){
newline="state: $1"
sed -i '/state.*/c\'"$newline" ../group_vars/all.yaml
}

# +============================+
# [ Set: nextcloud_username    ]
SETNCDBUSER(){
newline="nextcloud_username: $1"
sed -i '/nextcloud_username.*/c\'"$newline" ../group_vars/all.yaml
}

# +============================+
# [ Set: nextcloud_userpass    ]
SETNCDBPASS(){
newline="nextcloud_userpass: $1"
sed -i '/nextcloud_userpass.*/c\'"$newline" ../group_vars/all.yaml
}

# +============================+
# [ Set: nextcloud_domain      ]
SETNCDM(){
	newline="nextcloud_domain: $1"
	sed -i '/nextcloud_domain.*/c\'"$newline" ../group_vars/all.yaml
}

# +============================+
# [ Set: onlyoffice_domain     ]
SETOODM(){
newline="onlyoffice_domain: $1"
sed -i '/onlyoffice_domain.*/c\'"$newline" ../group_vars/all.yaml
}

# +============================+
# [ Set: collabora_domain      ]
SETCODM(){
newline="collabora_domain: $1"
sed -i '/collabora_domain.*/c\'"$newline" ../group_vars/all.yaml
}

# +============================+
# [ Set: draw_domain           ]
SETCODM(){
newline="draw_domain: $1"
sed -i '/draw_domain.*/c\'"$newline" ../group_vars/all.yaml
}

# +============================+
# [ Set: webserver             ]
SETWEBSERV(){
newline="webserver: $1"
sed -i '/webserver.*/c\'"$newline" ../group_vars/all.yaml
}

# +============================+
# [ Set: email                 ]
SETEMAIL(){
newline="email: $1"
sed -i '/email.*/c\'"$newline" ../group_vars/all.yaml
}

# +============================+
# [ Set: dbtype                ]
SETDBTYPE(){
newline="dbtype: $1"
sed -i '/dbtype.*/c\'"$newline" ../group_vars/all.yaml
}


# +============================+
# [       MAIN FONCTION        ]
main(){


# +============================+
# [   SETTING UP THE PWD       ]
dir=`pwd`
acdir="$(dirname "$dir")"
newline="autocloud_dir: $acdir"
sed -i '/autocloud_dir:.*/c\'"$newline" ../group_vars/all.yaml
# +============================+


# +============================+ 
# [  INITIALISING THE PLAYBOOK ]
echo "---" > ../playbook.yaml
echo "- hosts: localhost" >> ../playbook.yaml
echo "  roles:" >> ../playbook.yaml
# +============================+ 


# +=============================+
# [  CONTROLLING THE ARGUMENTS  ]
if [ $# -eq 0 ]; then
	NOARGERROR
elif [ $# -eq 1 ]; then
	case "$1" in 
		"help") HELPMENU;;
		"list") SHOWPLUGINS;;
		"init") INITFILE;;
		"config") SHOWCONF;;
		*) ARGERROR;;
	esac
elif [ $# -eq 2 ]; then
	if [ "$1" != "run" ]; then
		ARGERROR
	else
		TESTPLUGINS "$2"
	fi
elif [ $# -eq 3 ]; then
	if [ "$1" = "local" ]; then
		if [ "$2" = "plugins" ]; then
			TESTPLUGINS "$3"
		else
			ARGERROR
		fi
	elif [ "$1" = "set" ]; then
		case "$2" in 
			"state") SETSTATE "$3";;
			"ncdbuser") SETNCDBUSER "$3";;
			"ncdbpass") SETNCDBPASS "$3";;
			"ncdm") SETNCDM "$3";;
			"oodm") SETOODM "$3";;
			"codm") SETCODM "$3";;
			"email") SETEMAIL "$3";;
			"webserv") SETWEBSERV "$3";;
			"dbtype") SETDBTYPE "$3";;
			*) VARNOTFOUND "$2" ;;
		esac
	else
		ARGERROR
	fi
else
	ARGERROR
fi
# +============================+

}

main $@