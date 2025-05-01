FROM ubuntu:22.04

RUN apt-get update && apt-get install -y wget ca-certificates tar

# Download and extract the Walrus CLI from the .tgz release
RUN wget https://github.com/MystenLabs/walrus/releases/download/mainnet-v1.22.1/walrus-mainnet-v1.22.1-ubuntu-x86_64.tgz -O /tmp/walrus.tgz && \
    tar -xzf /tmp/walrus.tgz -C /usr/local/bin && \
    chmod +x /usr/local/bin/walrus

CMD ["sleep", "infinity"]