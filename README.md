# Docker Swarm

Initializing swarm cluster

```
docker swarm init --advertise-addr <MANAGER-IP>

Output
    Swarm initialized: current node (xl0q412t4guvcf8x8zxku3ski) is now a manager.

    To add a worker to this swarm, run the following command:

        docker swarm join --token SWMTKN-1-0jw36959mxl29jiexm3di6x8p2mr44g8owbrpmetl1vqkwvwp6-ea916l6zfrjzzy451f83xu2ba 192.168.0.28:2377

    To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

Get join token for manager and worker
```
docker swarm join-token worker
docker swarm join-token manager
```

Get list of all nodes in the cluster
```
docker node ls
```

Create Service
```
docker service create --name web -p 8080:80 nginx


# With more than one 1 instance
docker service create --name web -p 8080:80 --replicas=2 nginx


# Global service
docker service create --name web -p 8080:80 --mode global nginx
```

List all running service
```
docker service web ls
```

List all tasks running for a service
```
docker service ps web
```

Scale In/Out replicas
```
docker service update web --replicas=2

OR 

docker service scale web=2
```


## Swarm Draining

To mark a node as unavaiable, we can use below command
```
# Run/scale a nginx service with 2 or more replicas, so that one of the container is started on the node which you want to drain out.

docker service create --name web -p 8080:80 --replicas=2 nginx

OR if existing

docker service update web --replicas=2


docker node update --availability drain worker1

You can see that the container on worker1 is deleted and restarted on another node.
```

## Stacks

Similar to docker compose in non swarm mode, we have stack in swarm mode. Same compose yaml file can work for docker compose command and for stack command. 

```
docker stack deploy -c compose.yaml myapp
```

some other commands

```
Command	                    Description
docker stack config	        Outputs the final config file, after doing merges and interpolations
docker stack deploy	        Deploy a new stack or update an existing stack
docker stack ls	            List stacks
docker stack ps	            List the tasks in the stack
docker stack rm	            Remove one or more stacks
docker stack services	    List the services in the stack
```










