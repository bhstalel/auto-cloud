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
echo -e "$green$bold [ Available arguments ] $reset"
echo -e "$bold # help "
echo -e "$bold # list "
echo -e "$bold # init "
echo -e "$bold # config "
echo -e "$bold # plugins plug1,plug2,..       [FOR OFFICIAL DOMAIN   ]"
echo -e "$bold # local plugins plug1,plug2,.. [FOR LOCAL INSTALLATION]"
echo -e "$bold # set var value "
echo -e "$bold +===+"
echo -e "$bold   vars: "
echo -e "$bold         - ncdbuser "
echo -e "$bold         - ncdbpass "
echo -e "$bold         - ncdm "
echo -e "$bold         - oodm "
echo -e "$bold         - codm "
echo -e "$bold         - email "
echo -e "$bold         - webserver "
echo -e "$bold         - dbtype"
echo -e "$bold +===+"
echo -e "$reset"
}

# +============================+
# [ Show available plugins     ]
SHOWPLUGINS(){
file="../group_vars/plugins"
echo
echo -e "$green$bold [ Available plugins ] $reset"
while IFS= read line
do
	echo -e "$bold # $line $reset"
done <"$file"
echo
}

# +============================+
# [ Initialise all variables   ]
INITFILE(){
echo
echo -e "$bold [#] Done initialising $reset"
echo
}


# +============================+
# [       Show variables       ]
SHOWCONF(){
echo
echo -e "$green$bold [ Variables ] $reset"

ncdbuser=`cat ../group_vars/all.yaml | sed -n -e 's/^.*nextcloud_username: //p'`
if [ -z "$ncdbuser" ]; then
	echo -e "$bold # nextcloud_username: $red[NOT SET]$reset"
else
	echo -e "$bold # nextcloud_username: $blue$ncdbuser$reset"
fi

ncdbpass=`cat ../group_vars/all.yaml | sed -n -e 's/^.*nextcloud_userpass: //p'`
if [ -z "$ncdbpass" ]; then
	echo -e "$bold # nextcloud_userpass: $red[NOT SET]$reset"
else
	echo -e "$bold # nextcloud_userpass: $blue$ncdbpass$reset"
fi

ncdm=`cat ../group_vars/all.yaml | sed -n -e 's/^.*nextcloud_domain: //p'`
if [ -z "$ncdm" ]; then
	echo -e "$bold # nextcloud_domain: $red[NOT SET]$reset"
else
	echo -e "$bold # nextcloud_domain: $blue$ncdm$reset"
fi

oodm=`cat ../group_vars/all.yaml | sed -n -e 's/^.*onlyoffice_domain: //p'`
if [ -z "$oodm" ]; then
	echo -e "$bold # onlyoffice_domain: $red[NOT SET]$reset"
else
	echo -e "$bold # onlyoffice_domain: $blue$oodm$reset"
fi

codm=`cat ../group_vars/all.yaml | sed -n -e 's/^.*collabora_domain: //p'`
if [ -z "$codm" ]; then
	echo -e "$bold # collabora_domain: $red[NOT SET]$reset"
else
	echo -e "$bold # collabora_domain: $blue$codm$reset"
fi

email=`cat ../group_vars/all.yaml | sed -n -e 's/^.*email: //p'`
if [ -z "$email" ]; then
	echo -e "$bold # email: $red[NOT SET]$reset"
else
	echo -e "$bold # email: $blue$email$reset"
fi

echo -e "$bold # webserver:  $red[NOT SET]$reset"
echo -e "$bold # dbtype:     $red[NOT SET]$reset $reset"
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
# [ Set: nextcloud_username    ]
SETNCDBUSER(){
echo "nextcloud_username: $1"
}

# +============================+
# [ Set: nextcloud_userpass    ]
SETNCDBPASS(){
echo "nextcloud_userpass: $1"
}

# +============================+
# [ Set: nextcloud_domain      ]
SETNCDM(){
echo "nextcloud_domain: $1"
}

# +============================+
# [ Set: onlyoffice_domain     ]
SETOODM(){
echo "onlyoffice_domain: $1"
}

# +============================+
# [ Set: collabora_domain      ]
SETCODM(){
echo "collabora_domain: $1"
}

# +============================+
# [ Set: webserver             ]
SETWEBSERV(){
echo "webserver: $1"
}

# +============================+
# [ Set: email                 ]
SETEMAIL(){
echo "email: $1"
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
			"ncdbuser") SETNCDBUSER "$3";;
			"ncdbpass") SETNCDBPASS "$3";;
			"ncdm") SETNCDM "$3";;
			"oodm") SETOODM "$3";;
			"codm") SETCODM "$3";;
			"email") SETEMAIL "$3";;
			"webserv") SETWEBSERV "$3";;
			*) ARGERROR;;
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