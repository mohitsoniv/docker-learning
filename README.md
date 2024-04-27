# Docker Swarm

Initializing swarm cluster

```
sudo docker swarm init --advertise-addr <MANAGER-IP>

Output
    Swarm initialized: current node (xl0q412t4guvcf8x8zxku3ski) is now a manager.

    To add a worker to this swarm, run the following command:

        docker swarm join --token SWMTKN-1-0jw36959mxl29jiexm3di6x8p2mr44g8owbrpmetl1vqkwvwp6-ea916l6zfrjzzy451f83xu2ba 192.168.0.28:2377

    To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

Get join token for manager and worker
```
sudo docker swarm join-token worker
sudo docker swarm join-token manager
```

Get list of all nodes in the cluster
```
sudo docker node ls
```

Give name to Node
```
sudo docker node update --label-add nodename=<new-name> <node-id>
```

Create Service
```
sudo docker service create --name web -p 8080:80 nginx


# With more than one 1 instance
sudo docker service create --name web -p 8080:80 --replicas=2 nginx


# Global service
sudo docker service create --name web -p 8080:80 --mode global nginx
```

List all running service
```
sudo docker service ls
```

List all tasks running for a service
```
sudo docker service ps web
```

Scale In/Out replicas
```
sudo docker service update web --replicas=2

OR 

sudo docker service scale web=2
```
Rollback last changes. It will only rollback the last change.

```
sudo docker service rollback web
```

## Swarm Draining

To mark a node as unavaiable, we can use below command. 

Run/scale a nginx service with 2 or more replicas, so that one of the container is started on the node which you want to drain out.
```
# 

sudo docker service create --name web -p 8080:80 --replicas=2 nginx

OR if existing

sudo docker service update web --replicas=2


sudo docker node update --availability drain <NodeID>

You can see that the container on specified node is deleted and restarted on another node.
```
Mark Node availability
```
sudo docker node update --availability active  <node-id>
```

## Stacks

Similar to docker compose in non swarm mode, we have stack in swarm mode. Same compose yaml file can work for docker compose command and for stack command. 

```
sudo docker stack deploy -c compose.yaml myapp
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

## Locking a Swarm Cluster
To secure your cluster we can lock our swarm cluster so that only authorize person with unlock key can perform operations

we can provide option to lock cluster at the time of cluster creation

```
sudo docker swarm init --autolock --advertise-addr <MANAGER-IP>

Output - It will print a unlock key, which should be copy paste for future reference

        docker swarm join \
        --token SWMTKN-1-0j52ln6hxjpxk2wgk917abcnxywj3xed0y8vi1e5m9t3uttrtu-7bnxvvlz2mrcpfonjuztmtts9 \
        172.31.46.109:2377
    
        To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
        
        To unlock a swarm manager after it restarts, run the `docker swarm unlock`
        command and provide the following key:
    
         SWMKEY-1-WuYH/IX284+lRcXuoVf38viIDK3HJEKY13MIHX+tTt8
```

### Unlock a Cluster

```
sudo docker swarm unlock
```

### Disable/Enable autolock in existing cluster
```
sudo docker swarm update --autolock=true
Output:
    Swarm updated.
    To unlock a swarm manager after it restarts, run the `docker swarm unlock` command and provide the following key:

        SWMKEY-1-ve8x/te7WQ03FkIAgoGxAKEdnh04sowvtVsxQ3HkG5I

    Please remember to store this key in a password manager, since without it you will not be able to restart the manager.

sudo docker swarm update --autolock=false
```
When you restart docker service, it will auto lock and you will need to unlock it first to execute commands
```
sudo systemctl restart docker

# Perform some opeartion
sudo docker service ls

Output : Error response from daemon: Swarm is encrypted and needs to be unlocked before it can be used. Use "docker swarm unlock" to unlock it.

# Unlock cluster
sudo docker swarm unlock
```

### Get unlock key
```
sudo docker swarm unlock-key
```

### Rotate your unlock key
```
sudo docker swarm unlock-key --rotate

# When you rotate the unlock key, keep a record of the old key around for a few minutes, so that if a manager goes down before it gets the new key, it may still be unlocked with the old one.
```

## Placement & Constraints
Many times, we face a scenario, where we want to restrict our services to run on some specific node only. This constraints because of some OS, compliance and any other dependencies. 

We will need to apply some labels on the Node. We can put constraints and preference based on node labels.

```
sudo docker node update --label-add web=true <node-id>
```
Deploying Service with constraints
```
sudo docker service create --name web -p 8080:80 --replicas=2 --constraint  node.labels.web==true nginx
```
If you specify multiple placement constraints, the service only deploys onto nodes where they are all met. It works on AND.









