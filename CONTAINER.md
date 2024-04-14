
# Docker Containers

Docker conatiners are running instance of an Image. Below is the command with different options to run a container

To run a container we need to pull image if it is not present on local machine. Either you can pull image or the docker run command will fetch the image and will run it

```
docker run --name web nginx

Here run is a docker command, nginx is image name and --name option is use to give a name to container

**Output**
    Unable to find image 'nginx:latest' locally
    latest: Pulling from library/nginx
    26070551e657: Pull complete 
    5745264e68a8: Pull complete 
    6f07c61775e7: Pull complete 
    c4f29c7c07f7: Pull complete 
    5a639d96fbc1: Pull complete 
    3ba04a51efe1: Pull complete 
    716495aa6d18: Pull complete 
    Digest: sha256:9ff236ed47fe39cf1f0acf349d0e5137f8b8a6fd0b46e5117a401010e56222e1
    Status: Downloaded newer image for nginx:latest
```
#### Removing a container
```
docker stop web
docker rm web

# To remove a running container directly
docker rm -f web

# Here web is the container name, we can also use conatiner id instead of name.
```

#### Running container with detach option
```
docker run --name web -d nginx

# This will return the container id and will run the container process in background.
```

#### Running container in interactive mode
```
docker run --name myos -it ubuntu

# Here 
-i option: This stands for "interactive" mode. 

-t option: This stands for "pseudo-TTY" or "pseudo-terminal. A pseudo-TTY is a terminal-like interface that allows you to interact with the container's shell or commands as if you were using a regular terminal 
```

#### How to get into the container


```
docker run --name web -d nginx

docker exec -it web /bin/bash
```

We can also use attach command to check the terminal process. The attach command is used to attach your terminal to a running container.

It allows you to view the output of the main process running in the container and to interact with it if it's an interactive process (like a shell session).

```
docker attach myos

# Press Cntrl-C to disconnect and close process and Cntrl-P or Cntrl-Q to disconnect only.
```

