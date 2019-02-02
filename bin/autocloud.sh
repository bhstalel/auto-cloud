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
ch=`echo -e "$bold [$green choice$reset $bold]$ $reset "`
pressenter=`echo -e "$bold [PRESS ENTER TO CONTINUE] $reset"`
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
echo -e "$bold |  + plugins plug1,plug2,..  |  $blue[run plug1,plug2,..]$reset"
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
echo -e "$bold |  + Ownpad                  |"
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
# [       TEST PLUGINS         ]
TESTPLUGINS(){
echo "Testing this plugin: $1"
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
	if [ "$1" != "plugins" ]; then
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