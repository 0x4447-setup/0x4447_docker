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

RUN unzip packer_*.zip

FROM debian:9.11-slim as final

ENV DEBIAN_FRONTEND noninteractive

# hadolint ignore=DL3008
RUN apt-get update &&\
        apt-get -y install \
            --no-install-recommends \
            curl \
            awscli \
            zsh \
            git && \
        rm -rf /var/lib/apt/lists/*

ARG user=david

RUN useradd -s /usr/bin/zsh "$user"

COPY --from=base ["packer", "/usr/local/bin/"]
COPY [".zshrc", "/home/$user/.zshrc"]

RUN chown -R "$user:$user" "/home/$user/" && \
        ln -s /usr/bin/python3 /usr/bin/python

USER "$user"

RUN curl -so- /tmp/nvm-install.sh "https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh" | zsh

RUN echo "zstyle :compinstall filename \'$HOME/.zshrc\'" >> "$HOME/.zshrc"

WORKDIR /home/$user

ENTRYPOINT ["/usr/bin/zsh"]
