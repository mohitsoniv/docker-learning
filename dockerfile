FROM ubuntu

# Using CMD only. if we run without any arugument then it will print Hello... and if we run it argument then it will
#replace complete command, we will also need to pass commmand and statement both from aurgument
#CMD echo "Hello from CMD in shell form"
#CMD ["echo", "Hello from CMD in executable form"]


# Using Shell format. In this any argument passed in docker run command, it will be ignored.
#ENTRYPOINT echo "Hello from ENTRYPOINT in shell form"

# Using Shell format. In this any argument passed in docker run command will be apended.
#ENTRYPOINT ["echo", "Hello from ENTRYPOINT in executable form"]

# EntryPoint is specified in shell format hence eveything specify in CMD or from argument will be ignored.
#ENTRYPOINT echo
#CMD echo "Hello from CMD in shell form"

# Standard way to use ENTRYPOINT and CMD both, with ENTRYPOINT specify the command in executable format and 
# CMD specify the argument
ENTRYPOINT ["echo"]
CMD "Hello from CMD in shell form"