FROM ubuntu:22.04

RUN apt-get update && apt-get install -y wget ca-certificates && \
    wget https://bin.wal.app/walrus-mainnet-latest-ubuntu-x86_64 -O /usr/local/bin/walrus && \
    chmod +x /usr/local/bin/walrus

CMD ["sleep", "infinity"]
