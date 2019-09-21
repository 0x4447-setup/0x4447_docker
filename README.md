# 0x4447_docker
The default Docker setup for the whole company.

## Getting started with docker

https://docs.docker.com/get-started/

## Building this container

``` sh
docker build --build-arg "user=$USER" -t 0x4447/development:latest .
```

## Mounting your working directory to a subdirectory in your container's home folder:

``` sh
docker run -it -h my_docker_env --mount src="$(pwd)",target="/home/$USER/workdir/",type=bind 0x4447/development:latest
```

## Mounting other directories

``` sh
docker run -it -h my_docker_env --mount src=/path/to/some/directory,target="/home/$USER/workdir/",type=bind 0x4447/development:latest
```

## Examples screenshot

![Example](/images/Screen_Shot_2019-09-20_at_10.28.03_PM.png)
