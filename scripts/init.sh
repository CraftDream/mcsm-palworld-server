#!/bin/bash

if [[ ! "${PUID}" -eq 0 ]] && [[ ! "${PGID}" -eq 0 ]]; then
    printf "\e[0;32m*****执行用户组命令*****\e[0m\n"
    usermod -o -u "${PUID}" steam
    groupmod -o -g "${PGID}" steam
else
    printf "\033[31m不支持以root运行, 请修复你的 PUID 和 PGID!\n"
    exit 1
fi

mkdir -p /workspace/backups
chown -R steam:steam /workspace

if [ "${UPDATE_ON_BOOT}" = true ]; then
    printf "\e[0;32m*****开始安装/更新*****\e[0m\n"
    su steam -c '/home/steam/steamcmd/steamcmd.sh +force_install_dir "/workspace" +login anonymous +app_update 2394010 validate +quit'
fi

term_handler() {
    if [ "${RCON_ENABLED}" = true ]; then
        rcon-cli save
        rcon-cli shutdown 1
    else # Does not save
        kill -SIGTERM "$(pidof PalServer-Linux-Test)"
    fi
    tail --pid=$killpid -f 2>/dev/null
}

trap 'term_handler' SIGTERM

