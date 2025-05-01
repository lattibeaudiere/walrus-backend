FROM ubuntu:22.04

RUN apt-get update && apt-get install -y wget ca-certificates

# Download from GitHub releases (update the link as needed)
RUN wget https://github.com/MystenLabs/walrus/releases/download/mainnet-v1.22.1/walrus-mainnet-v1.22.1-ubuntu-x86_64 -O /usr/local/bin/walrus && \
    chmod +x /usr/local/bin/walrus

CMD ["sleep", "infinity"]