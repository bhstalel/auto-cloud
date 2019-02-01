#!/bin/bash


# +============================+
# [       HELP FONCTION        ]
HELPMENU(){
echo "Help menu"
}

# +============================+
# [ Show available plugins     ]
SHOWPLUGINS(){
echo "Available plugins"
}

# +============================+
# [ Initialise all variables   ]
INITFILE(){
echo "variables are initialized"
}


# +============================+
# [       Show variables       ]
SHOWCONF(){
echo "Running variables"
}

# +============================+
# [       TEST PLUGINS         ]
TESTPLUGINS(){
echo "Testing this plugin: $1"
}


# +============================+
# [         ARG ERROR          ]
ARGERROR(){
echo "Error argument see help"
}

# +============================+
# [       NO ARG ERROR         ]
NOARGERROR(){
echo "No argument !!! see help"
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