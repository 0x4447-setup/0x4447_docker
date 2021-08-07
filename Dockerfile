# Bare amazon linux 2
FROM amazonlinux:2 as base

# Update package lists
RUN yum update -y

# Install required packages
# hadolint ignore=DL3008,DL3015
RUN yum install -y \
        curl \
        unzip \
        xz \
        gcc \
        ncurses-devel \
        build-essential \
        tar \
        groff \
        make \
        nano

# Change working directory to /tmp
WORKDIR /tmp

# Get a clean image for the final container
FROM amazonlinux:2 as final

# Install required packages
# hadolint ignore=DL3008
RUN yum update -y && \
        yum install -y \
            curl \
            awscli \
            sudo \
            zsh \
            git \
            ca-certificates \
            tar \
            nano

# User Argument
ARG user=admin

# Create User
RUN useradd -s /bin/bash "$user"

# Ensrue User can sudo
RUN echo "$user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Ensure that user owns their won home directory
RUN chown -R "$user:$user" "/home/$user/"

# Copy .zshrc to container
COPY .zshrc "/home/$user/"

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

#RUN echo "zstyle :compinstall filename \'$HOME/.zshrc\'" >> "$HOME/.zshrc"

# Change Working directory to home directory
WORKDIR /home/$user

# Set the entrypoint to bash
ENTRYPOINT ["/bin/zsh"]
