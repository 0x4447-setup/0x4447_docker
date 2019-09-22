# 🐳 Docker

This is the default Docker setup for the whole company. Regardless of what operating system you are using, with this Docker file we can have a consistent plane field to work from.

# Getting started with docker

Instruction how to install and configure Docker on different systems: https://docs.docker.com/get-started/.

# Building this container

``` sh
docker build --build-arg "user=$USER" -t 0x4447:latest .
```

# Image access

### Running image in interactive mode

```sh
docker run -it -h docker 0x4447:latest
```

### Running image in interactive mode + Mounting your active working directory to a subdirectory in your container's home folder

``` sh
docker run -it -h docker --mount src="$(pwd)",target="/home/$USER/workdir/",type=bind 0x4447:latest
```

### Running image in interactive mode + Mounting a fixed directory to a subdirectory in your container's home folder

``` sh
docker run -it -h docker --mount src=/path/to/folder,target="/home/$USER/workdir/",type=bind 0x4447:latest
```

# Adding Docker Run in shell

By adding the above command to your shell you'll be able to just type `docker_vm` to get in to your container and work, without having to remember this long command.

## Linux

### Bash

```sh

```

### Zsh

```sh

```

## MacOS

### Bash

```sh

```

### Zsh

```sh

```

## Windows

# The End

If you enjoyed this project, please consider giving it a 🌟. And check out our [0x4447 GitHub account](https://github.com/0x4447), where you'll find additional resources you might find useful or interesting.

## Sponsor 🎊

This project is brought to you by 0x4447 LLC, a software company specializing in building custom solutions on top of AWS. Follow this link to learn more: https://0x4447.com. Alternatively, send an email to [hello@0x4447.email](mailto:hello@0x4447.email?Subject=Hello%20From%20Repo&Body=Hi%2C%0A%0AMy%20name%20is%20NAME%2C%20and%20I%27d%20like%20to%20get%20in%20touch%20with%20someone%20at%200x4447.%0A%0AI%27d%20like%20to%20discuss%20the%20following%20topics%3A%0A%0A-%20LIST_OF_TOPICS_TO_DISCUSS%0A%0ASome%20useful%20information%3A%0A%0A-%20My%20full%20name%20is%3A%20FIRST_NAME%20LAST_NAME%0A-%20My%20time%20zone%20is%3A%20TIME_ZONE%0A-%20My%20working%20hours%20are%20from%3A%20TIME%20till%20TIME%0A-%20My%20company%20name%20is%3A%20COMPANY%20NAME%0A-%20My%20company%20website%20is%3A%20https%3A%2F%2F%0A%0ABest%20regards.).
