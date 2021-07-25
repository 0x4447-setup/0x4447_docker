# 🐳 Docker

This is the default Docker setup for the whole company. Regardless of what operating system you are using, with this Docker file we have a consistent plane field to work from.

## How to install Docker

Follow this instructions to install Docker for your operating system.

- [MacOS](https://docs.docker.com/docker-for-mac/install/)
- [Windows](https://docs.docker.com/docker-for-windows/install/)
- Linux:
  - [CentOS](https://docs.docker.com/install/linux/docker-ce/centos/)
  - [Debian](https://docs.docker.com/install/linux/docker-ce/debian/)
  - [Fedora](https://docs.docker.com/install/linux/docker-ce/fedora/)
  - [Ubuntu](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

## Building the container

### *nix

```sh
docker build --no-cache --build-arg "user=$USER" -t al2:latest .
```

### Windows

Run the following command in Windows PowerShell:

```powershell
docker build --no-cache --build-arg "user=$env:USERNAME" -t 0x4447:latest .
```

- **Note:** `$env:USERNAME` is a powershell specific variable.

## Image access

How to run the container.

### *nix

Running the image in interactive mode.

```sh
docker run -it -h docker 0x4447:latest
docker run -it -h docker al2:latest
```

Running the image in interactive mode + mounting your active working directory.

```sh
docker run -it -h docker --mount src="$(pwd)",target="/home/$USER/workdir/",type=bind 0x4447:latest
docker run -it -h docker --mount src="$(pwd)",target="/home/$USER/workdir/",type=bind al2:latest
```

Running image in interactive mode + mounting a fixed directory.

```sh
docker run -it -h docker --mount src=/path/to/folder,target="/home/$USER/workdir/",type=bind 0x4447:latest
```

### Windows

Run the following command in Windows PowerShell:

``` powershell
docker run -it -h docker --mount src="$((Get-Location).Path -replace "\\", '/')",target="/home/$env:USERNAME/workdir/",type=bind 0x4447:latest
```

- **Note:** `$((Get-Location).Path -replace "\\", '/')` is a powershell specific command string.
- **Note:** `$env:USERNAME` is a powershell specific variable.

## Setting the timezone in the container

This can be done by setting the `$TZ` Environment variable:

``` sh
docker run -it -e TZ=Europe/Amsterdam 0x4447:latest
```

## Run the image with a shortcut

By adding the above command to your shell you'll be able to just type `vm_docker` to get in to your container and work, without having to remember the long command.

***nix**

### Bash

Add the following to your `.bash_profile` or `.bashrc` in your `$HOME` directory.

```sh
vm_docker(){
    docker run -it -h docker --mount src=/Users/"$USER"/Documents/GitHub,target="/home/$USER/workdir/",type=bind 0x4447:latest
    docker run -it -h docker --mount src=/Users/"$USER"/Documents/GitHub,target="/home/$USER/workdir/",type=bind al2:latest
}
```

### Zsh

Add the following to your `.zshrc` in your `$HOME` directory:

```sh
vm_docker(){
    docker run -it -h docker --mount src="$(pwd)",target="/home/$USER/workdir/",type=bind 0x4447:latest
}
```

### Windows

#### Powershell

Add the following to your PowerShell `$PROFILE`:

``` powershell
function vm_docker {
    docker run -it -h docker --mount src="$((Get-Location).Path -replace "\\", '/')",target="/home/$env:USERNAME/workdir/",type=bind 0x4447:latest
}
```

  **Note:** `function function_name {}` is a powershell specific command string.
  **Note:** `$((Get-Location).Path -replace "\\", '/')` is a powershell specific command string.
  **Note:** `$env:USERNAME` is a powershell specific variable.

## Docker container cleanup

You can remove exited docker containers with the following command

``` sh
docker rm $(docker ps -aq --filter status=exited)
```

## Docker image cleanup

You can remove all the images with the following command

``` sh
  docker rmi $(docker images -q)
```

## The End

If you enjoyed this project, please consider giving it a 🌟. And check out our [0x4447 GitHub account](https://github.com/0x4447), where you'll find additional resources you might find useful or interesting.

## Sponsor 🎊

This project is brought to you by 0x4447 LLC, a software company specializing in building custom solutions on top of AWS. Follow this link to learn more: https://0x4447.com. Alternatively, send an email to [hello@0x4447.email](mailto:hello@0x4447.email?Subject=Hello%20From%20Repo&Body=Hi%2C%0A%0AMy%20name%20is%20NAME%2C%20and%20I%27d%20like%20to%20get%20in%20touch%20with%20someone%20at%200x4447.%0A%0AI%27d%20like%20to%20discuss%20the%20following%20topics%3A%0A%0A-%20LIST_OF_TOPICS_TO_DISCUSS%0A%0ASome%20useful%20information%3A%0A%0A-%20My%20full%20name%20is%3A%20FIRST_NAME%20LAST_NAME%0A-%20My%20time%20zone%20is%3A%20TIME_ZONE%0A-%20My%20working%20hours%20are%20from%3A%20TIME%20till%20TIME%0A-%20My%20company%20name%20is%3A%20COMPANY%20NAME%0A-%20My%20company%20website%20is%3A%20https%3A%2F%2F%0A%0ABest%20regards.).
