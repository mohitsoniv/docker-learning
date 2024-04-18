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
docker run --name web --rm --network my-net -d nginx

docker inspect web

Output
"Networks": {
    "my-net": {
        "IPAMConfig": null,
        "Links": null,
        "Aliases": [
            "187cdc762aa6"
        ],
        "NetworkID": "efc86b0c4013db45a3067ba9b296fd1334765b4f2583c882c363e6191b21539b",
        "EndpointID": "0287cc4aa9f88f52430c14d29fe38ca9e5a0298926cd32b2afbd417a0f7c9840",
        "Gateway": "172.20.0.1",
        "IPAddress": "172.20.0.2",
```



### Connect a running container to a user define network
```
docker network connect my-net web
docker network connect my-net1 web

docker inspect
```

### Disconnect a container from user define network
```
docker network diconnect my-net1 web

docker inspect web
```
## Host Network
In Host network, the docker will not create a isolated network, instead will use Host machine network itself. The container's created in the network will have ip address of host only.

We can not create a Host network, but we can connect with a Host network
```
docker run --name web1 --rm --network host -it alpine
    
docker inspect

# the ip address that will be assign is from host netwoek space only.
```

## Overlay Network

An overlay network in Docker is a type of network that allows containers running on different Docker hosts to communicate with each other as if they were on the same host or network. This is particularly useful in distributed systems or container orchestration platforms like Docker Swarm or Kubernetes.

To create a overlay network 
```
docker network create -d overlay  my-overlay-net 

# Options
--attachable - optional and enables a standalone containers to connect with the network

--opt encrypted - optional and enable encryption for data transmitted over overlay network
```

Before you start, you must ensure that participating nodes can communicate over the network. The following table lists ports that need to be open to each host participating in an overlay network:

Ports	Description
- 2377/tcp	The default Swarm control plane port, is configurable with docker swarm join --listen-addr
- 4789/udp	The default overlay traffic port, configurable with docker swarm init --data-path-addr
- 7946/tcp, 7946/udp	Used for communication among nodes, not configurable



## Macvlan Network



