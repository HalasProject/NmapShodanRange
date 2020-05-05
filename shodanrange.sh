#!/bin/bash
echo -e "
   ▄▄▄▄▄    ▄  █ ████▄ ██▄   ██      ▄   ▄█▄    ▄█ ██▄   █▄▄▄▄ 
  █     ▀▄ █   █ █   █ █  █  █ █      █  █▀ ▀▄  ██ █  █  █  ▄▀ 
▄  ▀▀▀▀▄   ██▀▀█ █   █ █   █ █▄▄█ ██   █ █   ▀  ██ █   █ █▀▀▌  
 ▀▄▄▄▄▀    █   █ ▀████ █  █  █  █ █ █  █ █▄  ▄▀ ▐█ █  █  █  █  
              █        ███▀     █ █  █ █ ▀███▀   ▐ ███▀    █   
             ▀                 █  █   ██                  ▀    
                              ▀                                
				SALAH BENTAYEB V1.0		
---------------------------------------------------------------
"

api=

echo "Testing API Key ..."
if [[ -z "$api" ]];then
	echo
	echo -e "Please add API KEY for Shodan !"
	exit
fi

#Color
green='\033[0;32m'
red='\033[0;31m'
NC='\033[0m'

#Testing API 
test="$(nmap -sn -Pn -n --script shodan-api --script-args shodan-api.target=8.8.8.8,shodan-api.apikey=$api)"
if echo $test | grep "Error: Your ShodanAPI key"; then
	echo -e "${red}Your shodanAPI Key is invalide !{NC}"
	exit
fi

target=$1
echo -n "you want to analyze for the whole range / 24? [Y/n]: "
read response

if [[ $response == "n" ]]; then
	echo "im here"
	nmap -sn -Pn -n --script shodan-api --script-args shodan-api.target=$target,shodan-api.apikey=$api
	exit
fi

baseip=`echo $target | cut -d"." -f1-3`

founded=""
for ((i=1;i<255;i++));do
	ip=$baseip"."$i
	echo "Scan start for $baseip.$i"
	
	result="$(nmap -sn -Pn -n --script shodan-api --script-args shodan-api.target=$ip,shodan-api.apikey=$api)"

        if echo $result | grep "|_shodan-api: Shodan done: 1 hosts up" ;then
		$founded="{$founded} \n ${result}"
		echo -e "${green}[${ip}] IP found in database of Shodan${NC}"
		echo -e "${result}"
	else
		echo -e "${red}[${ip}] IP Not found in the database of Shodan${NC}"
	fi
	for ((x = 0; x < 30; x++)); do
 		printf %s -
	done
	echo
	
done
echo "$founded" > shodancidr.txt
