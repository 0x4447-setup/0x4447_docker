FROM debian:9.11-slim as base

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update

# hadolint ignore=DL3008
RUN apt-get install -y \
        --no-install-recommends \
        curl \
        unzip \
        ca-certificates

RUN curl -sO "https://releases.hashicorp.com/packer/1.4.3/packer_1.4.3_linux_amd64.zip"
RUN curl -so nano.tar.xz "https://www.nano-editor.org/dist/v4/nano-4.4.tar.xz"

RUN unzip packer_*.zip

FROM debian:9.11-slim as final

ENV DEBIAN_FRONTEND noninteractive

# hadolint ignore=DL3008
RUN apt-get update &&\
        apt-get -y install \
            curl \
            awscli \
            zsh \
            sudo \
            xz-utils \
            gcc \
            libncursesw5-dev \
            build-essential \
            git && \
        rm -rf /var/lib/apt/lists/*

ARG user

RUN useradd -s /usr/bin/zsh "$user"

RUN echo "$user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

COPY --from=base ["packer", "/usr/local/bin/"]
COPY --from=base ["nano.tar.xz", "/tmp/"]

COPY [".zshrc", "/home/$user/.zshrc"]

RUN chown -R "$user:$user" "/home/$user/" && \
        ln -s /usr/bin/python3 /usr/bin/python

WORKDIR /tmp

# Install nano v4
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

USER "$user"

RUN curl -so- /tmp/nvm-install.sh "https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh" | zsh

RUN echo "zstyle :compinstall filename \'$HOME/.zshrc\'" >> "$HOME/.zshrc"

WORKDIR /home/$user

ENTRYPOINT ["/usr/bin/zsh"]
