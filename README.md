# 0x4447_docker
The default Docker setup for the whole company.

## Building this container

``` sh
docker build --build-arg user=my_username -t 0x4447/development:latest .
```

## Mounting your working directory to a subdirectory in your container's home folder:

``` sh
docker run -it --mount src="$(pwd)",target=/home/my_username/workdir/,type=bind 0x4447/development:latest
```

## Examples screenshot

![Example](/images/Screen_Shot_2019-09-20_at_10.28.03_PM.png)
