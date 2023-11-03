FROM yabbo/ubuntu-desktop:v1 
USER root

ENV HOME /home/kasm-default-profile
#ENV HOME /home/kasm-user
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########


#RUN commands 
RUN apt update
RUN apt upgrade -y






######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000
