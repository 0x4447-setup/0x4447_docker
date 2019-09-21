FROM debian:9.11-slim as base

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update

# hadolint ignore=DL3008
RUN apt-get install -y \
        --no-install-recommends \
        curl \
        ca-certificates

RUN curl -sO "https://raw.githubusercontent.com/davidgatti/my-development-setup/master/02_Configurations/04_Zsh_instead_of_Bash/zshrc"

FROM base as final

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update &&\
        apt-get -y install \
            --no-install-recommends \
            zsh \
            git && \
        rm -rf /var/lib/apt/lists/*

ARG user=david

RUN useradd -s /usr/bin/zsh "$user"

COPY --from=base ["zshrc", "/home/$user/.zshrc"]

RUN chown -R "$user:$user" "/home/$user/"

USER "$user"

RUN echo "zstyle :compinstall filename \'$HOME/.zshrc\'" >> "$HOME/.zshrc"

WORKDIR /home/$user

ENTRYPOINT ["/usr/bin/zsh"]
