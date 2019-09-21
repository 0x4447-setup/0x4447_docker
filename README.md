# 0x4447_docker
The default Docker setup for the whole company.

## Getting started with docker

https://docs.docker.com/get-started/

## Building this container

``` sh
docker build --build-arg "user=$USER" -t 0x4447:latest .
```

## Mounting your working directory to a subdirectory in your container's home folder:

``` sh
docker run -it -h docker --mount src="$(pwd)",target="/home/$USER/workdir/",type=bind 0x4447:latest
```

## Mounting other directories

``` sh
docker run -it -h docker --mount src=/Users/davidgatti/Documents/GitHub,target="/home/$USER/Documents/",type=bind 0x4447:latest
```

## Examples screenshot

![Example](/images/Screen_Shot_2019-09-20_at_10.28.03_PM.png)
