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
            nano \
            procps \
            openssl \
            mc

# Install additional EPEL repository for xrdp and chromium packages
RUN amazon-linux-extras install epel

# Define XFCE4 for all users
RUN bash -c 'echo PREFERRED=/usr/bin/xfce4-session > /etc/sysconfig/desktop'

# Install xrdp, wrapper and helpers packages
RUN yum install -y tigervnc-server \
                   xrdp \
                   xorgxrdp \
                   xfce4-session \
                   xfdesktop \
                   xorg-x11-server-common \
                   xorg-x11-drv-fbdev \
                   xorg-x11-drv-vesa \
                   dbus \
                   xorg-x11-xinit-session \
                   supervisor \
                   xterm \
                   upower \
                   vulkan \
                   liberation-fonts \
                   wget \
                   xdg-utils \
                   bzip2

# D-Bus env to have path to unix socket for child apps
ENV DBUS_SESSION_BUS_ADDRESS="unix:path=/run/dbus/system_bus_socket"

# Make XFCE4 default X-client
RUN echo "xfce4-session" > /etc/skel/.Xclients

# Permit to start X-server without console authentication
COPY conf/xrdp.conf /etc/supervisord.d/xrdp.ini
COPY conf/xrdp-sesman.conf /etc/supervisord.d/xrdp-sesman.ini
COPY conf/supervisord.conf /etc/

# Install chromium browser
RUN yum install -y chromium

# Generate machineID for D-Bus subsystem
RUN dbus-uuidgen > /etc/machine-id

# Copy xorg.conf from RDP forder to common space
RUN cp /etc/X11/xrdp/xorg.conf /etc/X11/

# User Argument
ARG user=admin

# Create user and generate random password for
RUN RPASS=`/usr/bin/openssl rand -base64 6` && useradd -s /bin/zsh -g wheel -p $(openssl passwd -1 "$RPASS") "$user" && echo "$user:$RPASS" > "/home/$user/.rdp_credentials"

# Ensrue User can sudo
RUN echo "$user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Ensure that user owns their won home directory
RUN chown -R "$user:wheel" "/home/$user/"

# Copy github_check script to container
COPY bin/check_commit_add.sh /usr/bin/check_commit_add.sh
RUN chmod +x /usr/bin/check_commit_add.sh
RUN ln -s /usr/bin/check_commit_add.sh /usr/bin/check_commit_add
COPY bin/check_commit.sh /usr/bin/check_commit.sh
RUN chmod +x /usr/bin/check_commit.sh
RUN ln -s /usr/bin/check_commit.sh /usr/bin/check_commit

# Copy X-server wrapper script to container
COPY system/wrapper_script.sh /usr/bin/wrapper_script.sh
RUN chmod +x /usr/bin/wrapper_script.sh

# Copy .zshrc to container
COPY .zshrc "/home/$user/"

# Make desktop icons and basic panel configuration
RUN mkdir -p /home/$user/Desktop
COPY Desktop/Chrome.desktop /home/$user/Desktop/Chrome.desktop
RUN cp /usr/share/applications/xterm.desktop /home/$user/Desktop/xterm.desktop
RUN chmod -R +x /home/$user/Desktop
RUN mkdir -p /home/$user/.config/xfce4
ADD panel /home/$user/.config/xfce4/panel
ADD xfconf /home/$user/.config/xfce4/xfconf
ADD autostart /home/$user/.config/autostart
RUN sed -i "s/USER_ID/$user/g" /home/$user/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
RUN chown -R "$user:wheel" /home/$user

# Switch to User
USER "$user"

# Run nvm install
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -so- "https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh" | zsh

ENV NVM_DIR "/home/$user/.nvm"

# Set which verion of NodeJS should be installed.
ENV NODE_VERSION v14

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

# Set the entrypoint to zsh
ENTRYPOINT ["/bin/zsh"]

# Expose RDP port
EXPOSE 3389

# Run supervisord with xrdp
ENTRYPOINT ["/usr/bin/wrapper_script.sh"]
