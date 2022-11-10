#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################

source /var/lib/scrz-prem/ipvps.conf
if [[ "$IP" = "" ]]; then
domain=$(cat /etc/xray/domain)
else
domain=$IP
fi
clear
#echo -e "\033[0;34m━━━━━━━━━━━━━━━\033[0m"
#echo -e "\\E[0;41;36m  Add Vmess    \E[0m"
#echo -e "\033[0;34m━━━━━━━━━━━━━━━\033[0m"
echo "-----------------------------------------";
echo "---------=[ Add Vmess Account ]=---------";
echo "-----------------------------------------";
read -rp "Bug: " -e bug
read -rp "User: " -e user
geo="$(cat ~/log-install.txt | grep -w "Vmess TLS" | cut -d: -f2|sed 's/ //g')"
gabut="$(cat ~/log-install.txt | grep -w "Vmess None TLS" | cut -d: -f2|sed 's/ //g')"
egrep -w "^#vm $user" /etc/xray/config.json >/dev/null
if [ $? -eq 0 ]; then
echo -e "Username Sudah Ada"
exit 0
fi
uuid=$(cat /proc/sys/kernel/random/uuid)
read -p "Expired (days): " masaaktif
tgl=$(date -d "$masaaktif days" +"%d")
bln=$(date -d "$masaaktif days" +"%b")
thn=$(date -d "$masaaktif days" +"%Y")
expe="$tgl $bln, $thn"
tgl2=$(date +"%d")
bln2=$(date +"%b")
thn2=$(date +"%Y")
tnggl="$tgl2 $bln2, $thn2"
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#vmess$/a\#vm '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /etc/xray/config.json
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#vmessgrpc$/a\#vm '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /etc/xray/config.json
tls=`cat<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${bug}",
      "port": "443",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/vmess",
      "type": "none",
      "host": "${domain}",
      "tls": "tls"
}
EOF`
none=`cat<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${bug}",
      "port": "80",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/vmess",
      "type": "none",
      "host": "${domain}",
      "tls": "none"
}
EOF`
grpc=`cat<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "443",
      "id": "${uuid}",
      "aid": "0",
      "net": "grpc",
      "path": "vmess-grpc",
      "type": "none",
      "host": "",
      "tls": "tls"
}
EOF`
cat > /etc/geovpn/webserver/vmess-$user.txt <<-END
_______________________________
Thank You For Using Our Services
 Xray/Vmess Account
System Support:Debian 10 / Ubuntu 18.04/20.04
telegram: https://t.me/sampiiiiu
_______________________________
      Format Vmess WS (CDN)
_______________________________

- name: Vmess-$user-WS (CDN)
  type: vmess
  server: ${domain}
  port: 443
  uuid: ${uuid}
  alterId: 0
  cipher: auto
  udp: true
  tls: true
  skip-cert-verify: true
  servername: ${domain}
  network: ws
  ws-opts:
    path: /vmess
    headers:
      Host: ${domain}
_______________________________
Format Vmess WS (CDN) Non TLS
_______________________________

- name: Vmess-$user-WS (CDN) Non TLS
  type: vmess
  server: ${domain}
  port: 80
  uuid: ${uuid}
  alterId: 0
  cipher: auto
  udp: true
  tls: false
  skip-cert-verify: false
  servername: ${domain}
  network: ws
  ws-opts:
    path: /vmess
    headers:
      Host: ${domain}
_______________________________
     Format Vmess gRPC (SNI)
_______________________________

- name: Vmess-$user-gRPC (SNI)
  server: ${domain}
  port: 443
  type: vmess
  uuid: ${uuid}
  alterId: 0
  cipher: auto
  network: grpc
  tls: true
  servername: ${domain}
  skip-cert-verify: true
  grpc-opts:
    grpc-service-name: vmess-grpc

_______________________________
    Link Vmess Account
_______________________________
Link TLS : vmess://$(echo $tls | base64 -w 0)
_______________________________
Link none TLS : vmess://$(echo $none | base64 -w 0)
_______________________________
Link GRPC : vmess://$(echo $grpc | base64 -w 0)
_______________________________



END
vmess_base641=$( base64 -w 0 <<< $vmess_json1)
vmess_base642=$( base64 -w 0 <<< $vmess_json2)
vmess_base643=$( base64 -w 0 <<< $vmess_json3)
vmesslink1="vmess://$(echo $tls | base64 -w 0)"
vmesslink2="vmess://$(echo $none | base64 -w 0)"
vmesslink3="vmess://$(echo $grpc | base64 -w 0)"
systemctl restart xray
CHATID="1467883032"
KEY="5148827275:AAFoxFbohLAuGxMSnZnLthazOfD2kdfCdF0"
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
TEXT="<code>-----------------------</code>
<code>  XRAY/VMESS</code>
<code>-----------------------</code>
<code>Remarks        : ${user}
CITY           : $CITY
ISP            : $ISP
Domain         : ${domain}
Port TLS       : 443
Port none TLS  : 80
Port GRPC      : 443
id             : ${uuid}
alterId        : 0
Security       : auto
network        : ws or grpc
path           : /vmess
serviceName    : vmess-grpc</code>
<code>-----------------------</code>
<code> VMESS WS TLS</code>
<code>-----------------------</code>
<code>${vmesslink1}</code>
<code>-----------------------</code>
<code> VMESS WS NO TLS</code>
<code>-----------------------</code>
<code>${vmesslink2}</code>
<code>-----------------------</code>
<code>  VMESS GRPC</code>
<code>-----------------------</code>
<code>${vmesslink3}</code>
<code>-----------------------</code>
Aktif Selama   : $masaaktif Hari
Dibuat Pada    : $tnggl
Berakhir Pada  : $expe
<code>-----------------------</code>
"

curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
clear
echo -e "" | tee -a /etc/log-create-user.log
echo -e "" | tee -a /etc/log-create-user.log
echo -e "-------------XRAY/VMESS-------------" | tee -a /etc/log-create-user.log
echo -e "Remarks        : ${user}" | tee -a /etc/log-create-user.log
echo -e "Domain         : ${domain}" | tee -a /etc/log-create-user.log
echo -e "port TLS       : ${geo}" | tee -a /etc/log-create-user.log
echo -e "port none TLS  : ${gabut}" | tee -a /etc/log-create-user.log
echo -e "id             : ${uuid}" | tee -a /etc/log-create-user.log
echo -e "alterId        : 0" | tee -a /etc/log-create-user.log
echo -e "Security       : auto" | tee -a /etc/log-create-user.log
echo -e "network        : ws" | tee -a /etc/log-create-user.log
echo -e "path           : /vmess" | tee -a /etc/log-create-user.log
echo -e "----------------------------------" | tee -a /etc/log-create-user.log
echo -e "link TLS       : ${vmesslink1}" | tee -a /etc/log-create-user.log
echo -e "----------------------------------" | tee -a /etc/log-create-user.log
echo -e "link none TLS  : ${vmesslink2}" | tee -a /etc/log-create-user.log
echo -e "----------------------------------" | tee -a /etc/log-create-user.log
echo -e "link  GRPC  : ${vmesslink3}" | tee -a /etc/log-create-user.log
echo -e "----------------------------------" | tee -a /etc/log-create-user.log
echo -e "OpenClash : http://${domain}:85/vmess-$user.txt" | tee -a /etc/log-create-user.log
echo -e "----------------------------------" | tee -a /etc/log-create-user.log
echo -e "Aktif Selama   : $masaaktif Hari" | tee -a /etc/log-create-user.log
echo -e "Dibuat Pada    : $tnggl" | tee -a /etc/log-create-user.log
echo -e "Berakhir Pada  : $expe" | tee -a /etc/log-create-user.log
echo -e "" | tee -a /etc/log-create-user.log
echo -e "" | tee -a /etc/log-create-user.log
read -n 1 -s -r -p "Press any key to back on menu"
vmess-menu
