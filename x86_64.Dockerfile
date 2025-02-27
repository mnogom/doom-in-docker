FROM debian:12.6-slim
LABEL authors="konstantin freidlin"

SHELL [ "/bin/bash", "-c" ]
ENV DOOMVADOOMWADDIR="/root/DOOM/linuxdoom-1.10/linux/doom1.wad"

# install dependencies
RUN apt update; apt upgrade && \
    apt install -y make gcc libx11-dev libxtst-dev libxext-dev git xvfb fluxbox x11vnc

# setup fluxbox
COPY fluxbox.conf.d /root/.fluxbox

# build DOOM
COPY ./DOOM /root/DOOM
COPY doom.conf.d/DOOM-lunkums.patch /root/DOOM/DOOM-lunkums.patch
RUN pushd /root/DOOM && \
    git apply DOOM-lunkums.patch && \
    popd && \
    pushd /root/DOOM/linuxdoom-1.10 && \
    make && \
    popd
#    pushd /root/DOOM/sndserv && \
#    make && \
#    cp linux/sndserver /root/DOOM/linuxdoom-1.10/linux/ && \
#    popd
COPY doom.conf.d/doom1.wad /root/DOOM/linuxdoom-1.10/linux/doom1.wad
WORKDIR /root/DOOM/linuxdoom-1.10/linux

COPY entrypoints/run-doom.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
