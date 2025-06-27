# EICAR Test File in Docker

Reference: [EICAR Test File - Wikipedia](https://en.wikipedia.org/wiki/EICAR_test_file)

---

## Create a Docker Container with the EICAR Test File

Run the following command to create an Alpine container and generate the EICAR test file inside it:

```
sudo docker run -dit --name eicar-test alpine /bin/sh -c 'echo "X5O!P%@AP[4\\PZX54(P^)7CC)7}\$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!\$H+H*" > /tmp/eicar.txt && sleep 600'

```
sudo docker exec -it eicar-test cat /tmp/eicar.txt
```

```
sudo docker exec -it eicar-test md5sum /tmp/eicar.txt
```

