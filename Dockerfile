FROM ubuntu:22.04

RUN apt-get update && apt-get install -y wget ca-certificates tar python3 python3-pip

# Download and extract the Walrus CLI from the .tgz release
RUN wget https://github.com/MystenLabs/walrus/releases/download/mainnet-v1.22.1/walrus-mainnet-v1.22.1-ubuntu-x86_64.tgz -O /tmp/walrus.tgz && \
    tar -xzf /tmp/walrus.tgz -C /usr/local/bin && \
    chmod +x /usr/local/bin/walrus

COPY requirements.txt .
RUN pip3 install -r requirements.txt

COPY app.py .

RUN echo "This is an example blob" > example.txt
RUN mkdir -p /root/.sui && \
    echo -e "keystore:\n  File: /root/.sui/sui.keystore\ndefault_context: devnet\nconfigs:\n  - alias: devnet\n    rpc: \"https://fullnode.devnet.sui.io:443\"\n    faucet: \"https://faucet.devnet.sui.io/gas\"\n    environment: devnet\nactive_config: devnet\nactive_address: \"0x0\"" > /root/.sui/client_config.yaml && \
    touch /root/.sui/sui.keystore
RUN cat /root/.sui/client_config.yaml
RUN walrus --version && \
    walrus --config /root/.sui/client_config.yaml --help
ENV XDG_CONFIG_HOME=/root/.sui
RUN blob_id=$(walrus store --epochs 1 example.txt --config /root/.sui/client_config.yaml | cut -d' ' -f1)

CMD ["python3", "app.py"]