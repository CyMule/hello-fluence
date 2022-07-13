# Hello-Fluence

Hello world in three steps.

## Requirements
Docker

## Steps
Download and navigate to this repo
```
git clone git@github.com:CyMule/hello-fluence.git
cd /hello-fluence
```

Start the fluence node and get a terminal inside it. This will build the fluence node container and give you a shell into it while setting the PRIV_KEY, PUB_KEY, and PEER_ID environment variables for you. These variables are parsed from the node when it starts.
```
./run.sh
```
At this point you will have a bash shell inside the docker container (which is also running the fluence node). This container has all the tools you need for fluence development. You can execute your first command on the fluence network by running the hello.sh script
```
cd ./hello-fluence/greeting
./hello.sh
```
Try changing the `/greeting/main.rs` file so that the functions prints "Bye, Fluence". You can make the change inside the container or on your local system. Either will work because the `greeting` directory is mounted inside the container. After making the change rerun the `hello.sh` script.