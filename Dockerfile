FROM rust:stretch as build

ARG BRANCH=master

WORKDIR /usr/src/spotifyd

RUN apt-get -yqq update && \
    apt-get install --no-install-recommends -yqq libasound2-dev libssl-dev libpulse-dev libdbus-1-dev && \
    git clone --depth=1 --branch=${BRANCH} https://github.com/Spotifyd/spotifyd.git .

RUN cargo build --release --no-default-features --features pulseaudio_backend

FROM debian:stretch-slim as release

CMD ["/usr/bin/spotifyd", "--no-daemon"]

RUN apt-get -yqq update && \
    apt-get install -yqq --no-install-recommends libasound2 libssl1.1 libpulse0  libdbus-1-3 && \
    rm -rf /var/lib/apt/lists/* && \
    groupadd -g 1000 spotifyd && \
    useradd --no-log-init -u 1000 -g spotifyd -G audio spotifyd

COPY --from=build /usr/src/spotifyd/target/release/spotifyd /usr/bin/

USER spotifyd
