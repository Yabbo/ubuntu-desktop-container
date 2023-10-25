FROM kasmweb/ubuntu-jammy-desktop:1.14.0 
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########


#RUN commands 
RUN apt update
RUN apt upgrade -y
RUN apt -y install openvpn
RUN apt -y install unzip

# Change Background to sth cool
COPY assets/mr-robot-wallpaper.png  /usr/share/extra/backgrounds/bg_default.png

# Install mm tool (MixMode CLI tool)
COPY assets/mixmode-api-client.zip /home/kasm-user/mixmode-api-client.zip
RUN unzip /home/kasm-user/mixmode-api-client.zip -d /
RUN apt install python3
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN cp /tmp/mm-client-files/mm.sh /usr/local/bin/mm

# Install kubectl 
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN chmod +x kubectl
RUN mv kubectl /usr/local/bin/.

# Install AWS CLI 
RUN apt -y install awscli

# Install Starship
RUN wget https://starship.rs/install.sh
RUN chmod +x install.sh
RUN ./install.sh -y

# Add Starship to bashrc
RUN echo 'eval "$(starship init bash)"' >> .bashrc
RUN echo 'eval "$(starship init bash)"' >> /home/kasm-user/.bashrc
RUN chown kasm-user:kasm-user /home/kasm-user/.bashrc


# Add Starship Theme
COPY config/starship.toml .config/starship.toml
COPY config/starship.toml /home/kasm-user/.config/starship.toml
RUN chown kasm-user:kasm-user /home/kasm-user/.config/starship.toml


# Install Hack Nerd Font
RUN wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip
RUN unzip Hack.zip -d /usr/local/share/fonts

# Install Terminator
RUN apt -y install terminator

# Set up Nerd font in Terminator
RUN mkdir .config/terminator
COPY config/terminator.toml .config/terminator/config

RUN mkdir /home/kasm-user/.config/terminator
COPY config/terminator.toml /home/kasm-user/.config/terminator/config
RUN chown -R kasm-user:kasm-user /home/kasm-user/.config/*

# Install XFCE Dark Theme
RUN apt install numix-gtk-theme

# Clean up 
Run rm Hack.zip
Run rm install.sh

# Add kasm-user to sudoers with no password
RUN echo "kasm-user ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers

# Set kasm-user default shell to bash
RUN chsh -s /bin/bash kasm-user


######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000
