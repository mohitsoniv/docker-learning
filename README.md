# docker-learning

The ONBUILD instruction in a Dockerfile is used to add triggers to the build process. When you include an ONBUILD instruction 
in your Dockerfile, the specified commands are not executed during the current build, but they become triggers for the builds 
that are based on this image. These triggers are executed when the image is used as the base for another image.

Here, we have 2 files, which is the base file and application dockerfile which use dockerfile-base image as base.

Create a base Image
```
docker build onbuild-test .
```

Create application image
```
docker build myapp .
```

Run the container
```
docker run --name myapp -p 8000:8000 myapp
```
