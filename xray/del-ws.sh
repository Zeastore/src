#!/bin/bash
# =========================================
# Quick Setup | Script Setup Manager
# Edition : Stable Edition V1.0
# Auther  : Adit Ardiansyah
# (C) Copyright 2022
# =========================================

# // Root Checking
if [ "${EUID}" -ne 0 ]; then
		echo -e "${EROR} Please Run This Script As Root User !"
		exit 1
fi

# // Exporting Language to UTF-8
export LC_ALL='en_US.UTF-8' > /dev/null
export LANG='en_US.UTF-8' > /dev/null
export LANGUAGE='en_US.UTF-8' > /dev/null
export LC_CTYPE='en_US.utf8' > /dev/null

# // Export Color & Information
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export LIGHT='\033[0;37m'
export NC='\033[0m'

# // Export Banner Status Information
export EROR="[${RED} ERROR ${NC}]"
export INFO="[${YELLOW} INFO ${NC}]"
export OKEY="[${GREEN} OKEY ${NC}]"
export PENDING="[${YELLOW} PENDING ${NC}]"
export SEND="[${YELLOW} SEND ${NC}]"
export RECEIVE="[${YELLOW} RECEIVE ${NC}]"

# // Export Align
export BOLD="\e[1m"
export WARNING="${RED}\e[5m"
export UNDERLINE="\e[4m"
clear
NUMBER_OF_CLIENTS=$(grep -c -E "^#vm " "/etc/xray/config.json")
	if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
		#echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
       # echo -e "\\E[0;41;36m       Delete Vmess Account        \E[0m"
       # echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
        echo "-----------------------------------------";
        echo "--------=[ Delete Vmess Account ]=-------";
        echo "-----------------------------------------";
		echo ""
		echo "You have no existing clients!"
		echo ""
		echo "-----------------------------------------";
		read -n 1 -s -r -p "Press any key to back on menu"
        vmess-menu
	fi

	clear
	#echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    #echo -e "\\E[0;41;36m       Delete Vmess Account        \E[0m"
    #echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo "-----------------------------------------";
    echo "--------=[ Delete Vmess Account ]=-------";
    echo "-----------------------------------------";
    echo "  User       Expired  " 
	echo "-----------------------------------------";
	grep -E "^#vm " "/etc/xray/config.json" | cut -d ' ' -f 2-3 | column -t | sort | uniq
    echo ""
    echo "-----------------------------------------";
	read -rp "Input Username : " user
    if [ -z $user ]; then
    vmess-menu
    else
    exp=$(grep -wE "^#vm $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
    sed -i "/^#vm $user $exp/,/^},{/d" /etc/xray/config.json
    systemctl restart xray > /dev/null 2>&1
    clear
    #echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    #echo " V2RAY Account Deleted Successfully"
    #echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo "-----------------------------------------";
    echo "-------=[ Deleted Successfully ]=--------";
    echo "-----------------------------------------";
    echo " Client Name : $user"
    echo " Expired On  : $exp"
    echo "-----------------------------------------";
    echo ""
    read -n 1 -s -r -p "Press any key to back on menu"
    
    vmess-menu
    fi
