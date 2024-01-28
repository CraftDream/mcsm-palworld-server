#!/bin/bash

if [ ! -f /workspace/PalServer.sh ]; then
    cp -r /workspace_mirror/* /workspace/
    chown -R steam:steam /workspace
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

palstart &
killpid="$!"

sleep 15
rcon-cli

wait $killpid
