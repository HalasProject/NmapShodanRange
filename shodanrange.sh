!/bin/bash
api= PUT YOUR API TOKEN HERE
target=$1
echo -n "you want to analyze for the whole range / 24? [Y/n]: "
read response
if [[ $response == "n" ]]; then
        echo "im here"
        nmap -sn -Pn -n --script shodan-api --script-args shodan-api.target=$target,shodan-api.apikey=$api
        exit
fi

baseip=`echo $target | cut -d"." -f1-3`

for ((i=0;i<255;i++));do
        ip=$baseip"."$i
        echo "Scan start for $baseip.$i"
        
        result="$(nmap -sn -Pn -n --script shodan-api --script-args shodan-api.target=$ip,shodan-api.apikey=$api)"
        
        if echo $result | grep "|_shodan-api: Shodan done: 1 hosts up" ;then
                echo "${result}"
        else
                echo "Not find in the database"
        fi
        for ((x = 0; x < 20; x++)); do
                printf %s -
        done
done



