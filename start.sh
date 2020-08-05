#!/bin/sh

CACHE_DIR=spotifyd

mkdir -p $CACHE_DIR

PA_SOCKET="$(LC_ALL=C pactl info | grep 'Server String' | cut -f 3 -d' ')

docker run -d \
    --env PULSE_SERVER=unix:/tmp/pulseaudio.socket \
    --env PULSE_COOKIE=/tmp/pulseaudio.cookie \
    --volume $PA_SOCKET:/tmp/pulseaudio.socket \
    --volume $PWD/pulseaudio.client.conf:/etc/pulse/client.conf \
    --volume $PWD/$CACHE_DIR:/spotifyd \
    --volume $PWD/spotifyd.conf:/etc/spotifyd/spotifyd.conf \
    --user $(id -u):$(id -g) \
    --net host \
    --name spotifyd-pulseaudio
    spotifyd-pulseaudio