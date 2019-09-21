FROM debian:9.11-slim as base

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y curl

RUN curl -sO "https://raw.githubusercontent.com/davidgatti/my-development-setup/master/02_Configurations/04_Zsh_instead_of_Bash/zshrc"

FROM base as final

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get -y install \
        zsh \
        git

ARG user=david

RUN useradd -s /usr/bin/zsh "$user"

COPY --from=base ["zshrc", "/home/$user/.zshrc"]

RUN chown -R "$user:$user" "/home/$user/"

USER "$user"

RUN echo "zstyle :compinstall filename \'$HOME/.zshrc\'" >> "$HOME/.zshrc"

WORKDIR "/home/$user"

ENTRYPOINT ["/usr/bin/zsh"]
