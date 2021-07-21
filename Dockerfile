# Bare amazon linux 2
FROM amazonlinux:2 as base

RUN yum clean

# Update package lists
RUN yum update -y

# Default packer version
ARG PACKER_VERSION=1.5.6

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
        make

# Change working directory to /tmp
WORKDIR /tmp

# Get Archives
RUN curl -sO "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip"
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
            python3

# User Argument
ARG user=admin

# Create User
RUN useradd -s /bin/bash "$user"

# Ensrue User can sudo
RUN echo "$user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Copy compiled binaries from base
COPY --from=base ["/tmp/packer", "/usr/local/bin/"]
COPY --from=base ["/usr/bin/nano", "/usr/bin/nano"]

# Copy ./.bashrc into container
COPY [".bashrc", "/home/$user/.bashrc"]

# Ensure that user owns their won home directory
RUN chown -R "$user:$user" "/home/$user/"

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

# Change Working directory to home directory
WORKDIR /home/$user

# Set the entrypoint to bash
ENTRYPOINT ["/bin/bash"]
