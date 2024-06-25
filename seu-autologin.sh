#!/bin/bash
#本机IP地址 无需填写
IP=
#一卡通号
ID=''
#密码
password=''
#读取json中值
function get_json_value() {
  local json=$1
  local key=$2

  if [[ -z "$3" ]]; then
    local num=1
  else
    local num=$3
  fi

  local value=$(curl -k -s https://w.seu.edu.cn/drcom/chkstatus?callback=dr1003 | sed 's/dr1003(//' | sed 's/)//' | jq '.v46ip' | sed 's/"//g')

  #echo ${value}
  IP=${value}
  echo $(date "+%Y-%m-%d %H:%M:%S") "IP:" ${IP} | logger --tag seu-login
}

function login_wlan() {
  #get 报文
  RESULT=$(curl -k -s https://w.seu.edu.cn/drcom/chkstatus?callback=dr1003)
  echo $RESULT
  #得到本机IP
  get_json_value $RESULT v46ip
  #echo $IP
  url="https://w.seu.edu.cn:801/eportal/?c=Portal&a=login&callback=dr1003&login_method=1&user_account=%2C0%2C$ID&user_password=$password&wlan_user_ip=$IP"
  login=$(curl "$url")
  #$login
  echo $(date "+%Y-%m-%d %H:%M:%S") "Result: " ${login} | logger --tag seu-login}

# 定义检查函数
check_wifi() {
  nmcli -p connection | grep SEU-WLAN | cut -b 1-8
}

echo $(date "+%Y-%m-%d %H:%M:%S") "[Begin] 自动登录服务启动" | logger --tag seu-login

# 循环检查，直到找到SEU-WLAN
while true; do
  result=$(check_wifi)
  if [[ -n "$result" ]]; then
    echo $(date "+%Y-%m-%d %H:%M:%S") "[WLAN] SEU-WLAN found!" | logger --tag seu-login
    sleep 10s
    break
  else
    echo $(date "+%Y-%m-%d %H:%M:%S") "[WLAN] SEU-WLAN not found, retrying in 5 seconds..." | logger --tag seu-login
    sleep 5s
  fi
done

while true; do
  if ping -c 1 -w 10 baidu.com >/dev/null; then
    echo $(date "+%Y-%m-%d %H:%M:%S") "[Success] 网络可正常访问" | logger --tag seu-login
    sleep 40m
  else
    echo $(date "+%Y-%m-%d %H:%M:%S") "[Trial] 无网络，正在尝试登入校园网..." | logger --tag seu-login
    login_wlan
    sleep 10s
  fi
done
