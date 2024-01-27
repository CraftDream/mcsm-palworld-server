FROM cm2network/steamcmd:root
LABEL maintainer="thijs@loef.dev"

RUN apt-get update && apt-get install -y --no-install-recommends \
    xdg-user-dirs=0.17-2 \
    procps=2:3.3.17-5 \
    wget=1.21-1+deb11u1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN wget -q https://github.com/itzg/rcon-cli/releases/download/1.6.4/rcon-cli_1.6.4_linux_amd64.tar.gz -O - | tar -xz && \
    mv rcon-cli /usr/bin/rcon-cli

ENV PORT= \
    PUID=1000 \
    PGID=1000 \
    PLAYERS= \
    MULTITHREADING=false \
    COMMUNITY=false \
    PUBLIC_IP= \
    PUBLIC_PORT= \
    SERVER_PASSWORD= \
    SERVER_NAME= \
    ADMIN_PASSWORD= \
    UPDATE_ON_BOOT=true \
    RCON_ENABLED=true \
    RCON_PORT=25575 \
    QUERY_PORT=27015 \
    TZ=UTC

COPY ./scripts/* /home/steam/server/
RUN chmod +x /home/steam/server/init.sh /home/steam/server/start.sh /home/steam/server/backup.sh /home/steam/server/setup.sh && \
    mv /home/steam/server/backup.sh /usr/local/bin/backup

RUN mkdir -p /workspace /workspace_mirror

RUN mv /home/steam/server/backup.sh /usr/local/bin/palbackup
RUN mv /home/steam/server/start.sh /usr/local/bin/palstart
RUN mv /home/steam/server/init.sh /usr/local/bin/palinit
RUN mv /home/steam/server/setup.sh /usr/local/bin/palsetup

RUN palsetup

RUN curl -L https://github.com/VeroFess/PalWorld-Server-Unoffical-Fix/releases/download/1.3.0-Update-3/PalServer-Linux-Test-Patch-Update-3 -o /tmp/PalServer-Linux-Test
RUN mv -f /tmp/PalServer-Linux-Test /workspace/Pal/Binaries/Linux/PalServer-Linux-Test
RUN chmod +x /workspace/Pal/Binaries/Linux/PalServer-Linux-Test

RUN cp -r /workspace/* /workspace_mirror/
RUN rm -rf /workspace/*
RUN chown -R root:root /workspace_mirror

HEALTHCHECK --start-period=5m \
    CMD pgrep "PalServer-Linux" > /dev/null || exit 1

EXPOSE ${PORT} ${RCON_PORT}
WORKDIR /workspace
