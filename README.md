# docker-learning

In a Dockerfile, both ENTRYPOINT and CMD are instructions that define what command should be run when a container is started from the image. They serve slightly different purposes:

CMD and ENTRYPOINT are two Dockerfile instructions that together define the command that runs when your container starts. You must use these instructions in your Dockerfiles so that users can easily interact with your images. Because CMD and ENTRYPOINT work in tandem, they can often be confusing to understand. 

There are 2 forms in which we can specify commands, Shell and Exec form.

*Shell command form*: As the name suggests, a shell form of instructions initiate processes that run within the shell. To execute this, invoke /bin/sh -c <command>.

*Executable command form*: Unlike the shell command type, an instruction written in executable form directly runs the executable binaries, without going through shell validation and processing.

ENTRYPOINT:
    The ENTRYPOINT instruction allows you to configure a container to run a specific executable, along with its arguments, when the container starts.
    It's typically used to set the default executable for the container, which cannot be overridden at runtime.
    

CMD:
    The CMD instruction provides default arguments for the ENTRYPOINT or sets an executable if no ENTRYPOINT is specified.
    It's used to specify the default command to be executed when the container starts, but it can be overridden by providing a command and its arguments when running the container with docker run.


To check different behaviour of ENTRYPOINT and CMD, please play around the dockerfile by uncommenting CMD and ENTRYPOINT lines one at a time and creating new image out of it.

Below commands can be used to create image and run a container from the image

Build Image

```
docker build -t myos .
```

Run a container
```
docker run --name myos --rm myos <argument>
```
