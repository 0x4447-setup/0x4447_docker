# multistage build so that the final container is smaller
FROM debian:9.11-slim as base

# Ensure that apt does not try to prompt for user input
ENV DEBIAN_FRONTEND noninteractive

# Update package lists
RUN apt-get update

# Install required packages
# hadolint ignore=DL3008,DL3015
RUN apt-get install -y \
        curl \
        unzip \
        xz-utils \
        gcc \
        libncursesw5-dev \
        build-essential

# Change working directory to /tmp
WORKDIR /tmp

# Get Archives
RUN curl -sO "https://releases.hashicorp.com/packer/1.4.3/packer_1.4.3_linux_amd64.zip"
RUN curl -so nano.tar.xz "https://www.nano-editor.org/dist/v4/nano-4.4.tar.xz"

# Unzip Archives
RUN unzip packer_*.zip

# Compile nano v4
# hadolint ignore=DL3003
RUN tar -xvf nano.tar.xz && \
        cd nano-* && \
        ./configure \
            --prefix=/usr     \
            --sysconfdir=/etc \
            --enable-utf8     \
            --docdir=/usr/share/doc/nano-4.4 \
            --disable-dependency-tracking && \
        make && \
        make install && \
        install -v -m644 doc/nano.html doc/sample.nanorc /usr/share/doc/nano-4.4

# Get a clean image for the final container
FROM debian:9.11-slim as final

# Ensure that apt does not try to prompt for user input
ENV DEBIAN_FRONTEND noninteractive

# Install required packages
# hadolint ignore=DL3008
RUN apt-get update && \
        apt-get -y install \
        --no-install-recommends \
            curl \
            awscli \
            zsh \
            sudo \
            git \
            ca-certificates && \
        rm -rf /var/lib/apt/lists/*

# User Argument
ARG user=admin

# Create User
RUN useradd -s /usr/bin/zsh "$user"

# Ensrue User can sudo
RUN echo "$user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Copy compiled binaries from base
COPY --from=base ["/tmp/packer", "/usr/local/bin/"]
COPY --from=base ["/usr/bin/nano", "/usr/bin/nano"]

# Copy ./.zshrc into container
COPY [".zshrc", "/home/$user/.zshrc"]

# Ensure that user owns their won home directory
RUN chown -R "$user:$user" "/home/$user/" && \
        ln -s /usr/bin/python3 /usr/bin/python

# Switch to User
USER "$user"

# Run nvm install
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -so- "https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh" | zsh

ENV NVM_DIR "/home/$user/.nvm"
ENV NODE_VERSION v12

# hadolint ignore=SC1090
RUN source "$HOME/.nvm/nvm.sh" && \
        nvm install "$NODE_VERSION" && \
        nvm alias default "$NODE_VERSION" && \
        nvm use default && \
        npm install -g @0x4447/grapes

ENV NODE_PATH "$NVM_DIR/$NODE_VERSION/lib/node_modules"
ENV PATH      "$NVM_DIR/$NODE_VERSION/bin:$PATH"

RUN echo "zstyle :compinstall filename \'$HOME/.zshrc\'" >> "$HOME/.zshrc"

# Change Working directory to home directory
WORKDIR /home/$user

# Set the entrypoint to zsh
ENTRYPOINT ["/usr/bin/zsh"]
