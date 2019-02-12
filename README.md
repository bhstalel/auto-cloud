# Install:
* Nextcloud
* ONLYOFFICE 
* COLLABORA
* TALK
* DRAW
---------
# Youtube tutos:
* [Youtube-link](https://www.youtube.com/playlist?list=PLNpnO_Q_GAdQ27rB530Nq7u_ZLRFBNtHQ)
---------
# ISSUES
* Still working on {webserv=apache2}
* Still working on Collabora [missing manual installation]
------------------
# Variables:
* ncdbuer : nextcloud_username
* ncdbpass: nextcloud_userpass
* ncdm    : nextcloud_domain
* oodm    : onlyoffice_domain
* codm    : collabora_domain
* drdm    : draw_domain
* state   : state [ o=official , l=lan ]
* email   : email@ for letsencrypt
* dbtype  : SQL database [ p=postgresql , m=mysql ]
* webserv : webserver [ a=apache2 , n=nginx ]

--------
# How to use it
* Set a variable    : ``` bash autocloud.sh set variable value ```
* Show running vars : ``` bash autocloud.sh config ```
* Reset all vars    : ``` bash autocloud.sh init ```
* Install nextcloud : ``` bash autocloud.sh run nc|nextcloud ```
* Install ONLYOFFICE: ``` bash autocloud.sh run oo|onlyoffice ```
* Install Collabora : ``` bash autocloud.sh run co|collabora ```
* Install Draw      : ``` bash autocloud.sh run dr|draw ```
* Install Talk      : ``` bash autocloud.sh run t|talk ```
---------
# Some explaination
* If you have a domain with DNS record you can set state to "o"
* All apps will be integrated automatically with nextcloud
* email will be asked for only if state=o
