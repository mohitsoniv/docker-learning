# Docker Registry 

A Docker registry is a storage and distribution system for named Docker images. The same image might have multiple different versions, identified by their tags.

A Docker registry is organized into Docker repositories , where a repository holds all the versions of a specific image. The registry allows Docker users to pull images locally, as well as push new images to the registry (given adequate access permissions when applicable).


DockerHub is a hosted registry solution by Docker Inc., available for managing docker images.

To use DockerHub registry, we will need to subscribe for it. Once subscription, we can login into registry using below command
```
 docker login

 # By default it will take docker hub registry - registry.hub.docker.com
 ```

 Tag image in the format <Registry-URL/<username>/<image-name>:<tag>
 ```
 docker image tag nginx vcjain/nginx

 # Here vcjain is the username and it will pick the default registry as docker hub
 ```
 Push the image to registry
 ```
 docker push vcjain/nginx
 ```

## Self Hosted Regsitry

We can host our own registry as well.

Create a docker container registry
```
docker run -d -p 5000:5000 --name registry registry:latest
```

Create a new tag for any image and push it to local registry

```
# Pull the image if doesn't exists
docker pull nginx

# Add a Tag for local registry 
docker image tag nginx localhost:5000/nginx:v1

# Check the image tags
docker images

# Push the Image to registry
docker push localhost:5000/nginx:v1
```

To view the repositories stored in your local Docker registry.

```
curl -X GET http://localhost:5000/v2/_catalog
```
To list all tags for a repository

```
curl http://localhost:5000/v2/<repository_name>/tags/list

Example : curl http://localhost:5000/v2/nginx/tags/list
```


When we want to push images from a remote docker host then we will need to configure SSL connection for registry. It is recommended for production deployment. For develoment, we can configure registry to work without SSL as well. 

Edit the Docker daemon configuration file (daemon.json). This file is typically located at /etc/docker/daemon.json. In case it is not present then you can add it with same name
```
sudo nano /etc/docker/daemon.json
```

Add or modify the "insecure-registries" option in the daemon.json file to include the URL of your Docker registry using HTTP
```
{
    "insecure-registries": ["<IP ADDRESS>:5000"]
}
```

Restart Docker engine
```
sudo systemctl restart docker
```
! **Follow above steps for the Docker Host from where you will push you the image**

After restart ensure that registry container is up and running
```
docker ps
docker start registry
```
