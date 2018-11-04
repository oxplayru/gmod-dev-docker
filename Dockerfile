FROM ubuntu:18.04
ENTRYPOINT ["/usr/bin/script", "-c"]

MAINTAINER Alex Mantis "bamttup@gmail.com"

# ------------
# Prepare Gmod
# ------------

RUN dpkg --add-architecture i386 && apt-get update && DEBIAN_FRONTEND=noninteractive && apt-get -y install wget lib32gcc1 libstdc++6 libstdc++6:i386 lib32tinfo5
RUN mkdir /steamcmd
WORKDIR /steamcmd
RUN wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz
RUN tar -xvzf steamcmd_linux.tar.gz
RUN mkdir /gmod-base
RUN /steamcmd/steamcmd.sh +login anonymous +force_install_dir /gmod-base +app_update 4020 validate +quit

# ---------------
# Setup Container
# ---------------

EXPOSE 27015/udp

ENV PORT="27015"
ENV MAXPLAYERS="16"
ENV G_HOSTNAME="Gmod"
ENV GAMEMODE="sandbox"
ENV MAP="gm_construct"

#Little hack for 'docker exec'
ENV TERM=xterm 
ENV LD_LIBRARY_PATH=".:/gmod-base/bin:$LD_LIBRARY_PATH"

CMD ["/gmod-base/srcds_linux -game garrysmod -norestart ${ARGS} -port ${PORT} +maxplayers ${MAXPLAYERS} +hostname ${G_HOSTNAME} +gamemode ${GAMEMODE}  +map ${MAP}"]
