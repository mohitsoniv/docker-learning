# Docker Networks

A computer network is a group of computers connected with each other to communicate. Similarly a docker network, a containers are connected with each other to communicate and collaborate. These containers can run on same Docker Host or they may run on different docker host running on remote machine. 

In Docker Networking is implemented using Drivers. Following drivers are supported by Docker for connectivity.


1. Bridge
2. Host
3. Overlay
4. Macvlan
5. Ipvlan
6. None


## Basic commands
List all networks 
```
docker network ls
```

### How to check IP Address of a container
```
docker inspect <container-name>

# Example
docker run --name web --rm -d nginx
docker inspect web

# Using format option
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' web
```

## Bridge Networks

This is a default network in Docker. Docker creates a default netwrok with name bridge and every container created without any explicit network secified will be created in brdige network.

### Create a user define bridge network

```
docker network create --driver=bridge my-net

docker network ls

# Here you can omit --driver option, it will take bridge by default
```

### Run a container on user define network
```

```