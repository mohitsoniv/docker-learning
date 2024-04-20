# Docker Logs

To get logs from a container or service, we can run command
```
sudo docker logs <conatiner-name>
```

To check current logging drive 
```
sudo docker info --format '{{.LoggingDriver}}'
```

To modify a logging driver
```
sudo /etc/docker/daemon.json
```

Update below content and save file
```
{
    "log-driver": "syslog"
}
```
Restart docker
``` 
sudo systemctl restart docker

sudo docker info --format '{{.LoggingDriver}}'
```

To set a log driver for a conatiner we can use --log-driver option
```
sudo docker run -d --name web --log-driver=json-file --log-opt mode=non-blocking nginx

sudo docker inspect web

# Output

    "HostConfig": {
        "Binds": null,
        "ContainerIDFile": "",
        "LogConfig": {
            "Type": "json-file",
            "Config": {
                "mode": "non-blocking"
            }
        },
```

If your application is producing json logs the you will be able to see logs in json with logs command

```
docker build -t json-logs .
```

Create a container 
```
docker run -d --name my-container json-logs
```

Check Logs
```
docker logs json-logs

# Ouput
    {"message": "This is a warning message", "user_id": 456}
    {"message": "This is an error message", "user_id": 789}
```


