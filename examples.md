# 🧪 Simulation Guide

## 🖥️ Step 1: On the Victim Host

Start a persistent listener on port `3333`:

```bash
nc -k -l 3333 &
```

---

## 🕵️ Step 2: On the Attacker Host

Inspect the `/etc/hosts` file:

```bash
cat /etc/hosts
```

**Sample Output:**
```
127.0.0.1 localhost
172.31.28.30 donate.v2.xmrig.com
```

---

## 🌐 Flask App Simulation Endpoints

### 🔓 Remote Command Execution (RCE)

Submit formal shell commands like `cat /etc/passwd` or `ls -la`:

- [Run `cat /etc/passwd`](http://3.96.209.91:5000/cmd?exec=cat%20/etc/passwd)
- [Run `ls -la`](http://3.96.209.91:5000/cmd?exec=ls%20-la)

---

### 💬 Reflected XSS

Test the greeting endpoint for XSS:

- [Greet](http://3.96.209.91:5000/greet)

**Try this:**
```
/greet?name=<script>alert('GotYou :) !')</script>
```

**What happens:**
- The browser runs the attacker’s script.
- This could steal cookies, log keystrokes, or redirect users.

---

### 🌐 Client IP Logging

Get the client IP address based on headers:

- [Client IP](http://3.96.209.91:5000/client-ip)

---

### 🌍 From Anywhere: Spoofing X-Forwarded-For

Send a fake IP in a request:

```bash
curl -H "X-Forwarded-For: 1.2.3.4" http://3.96.209.91:5000/client-ip
```

---

## 🚨 Known Bad IPs (for Simulation Only)

> ⚠️ **Use these for testing/log simulation only — do NOT scan or connect to them.**

| IP Address       | Reason / Source                             |
|------------------|----------------------------------------------|
| 45.227.253.55    | Associated with malware C2 (AbuseIPDB)       |
| 185.220.101.1    | Tor exit node (commonly flagged as malicious)|
| 1.3.3.7          | Meme/red team testing IP                     |
| 222.186.30.50    | Frequent brute-force attacker (honeypots)    |
| 89.248.167.131   | Blacklisted scanning IP (abuse reports)      |
| 23.129.64.50     | Known Tor exit node, flagged in threat feeds |

---
