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
docker build --no-cache --build-arg "user=$USER" -t 0x4447:latest .
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
```

Running the image in interactive mode + mounting your active working directory.

```sh
docker run -it -h docker --mount src="$(pwd)",target="/home/$USER/workdir/",type=bind 0x4447:latest
```

Running image in interactive mode + mounting a fixed directory.

```sh
docker run -it -h docker --mount src=/path/to/folder,target="/home/$USER/workdir/",type=bind 0x4447:latest
```

Running the image in interactive mode + RDP listening on port 15050/tcp (remote desktop available on rdp://localhost:15050/)

```sh
docker run -p 15050:3389 -it -h docker 0x4447:latest
```

- **Note:** RDP access details will be available in `~/.rdp_credentials` file in form `<username>:<password>`

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

## Docker cleanup

### Remove stoped container

You can remove exited docker containers with the following command

```sh
docker rm $(docker ps -aq --filter status=exited)
```

### Remove unused Images

```sh
docker image prune -f
```

## Docker image cleanup

You can remove all the images with the following command

``` sh
  docker rmi $(docker images -q)
```