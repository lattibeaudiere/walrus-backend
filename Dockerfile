FROM ubuntu:22.04

RUN apt-get update && apt-get install -y wget ca-certificates tar python3 python3-pip curl

# Download and extract the Walrus CLI from the .tgz release
RUN wget https://github.com/MystenLabs/walrus/releases/download/mainnet-v1.22.1/walrus-mainnet-v1.22.1-ubuntu-x86_64.tgz -O /tmp/walrus.tgz && \
    tar -xzf /tmp/walrus.tgz -C /usr/local/bin && \
    chmod +x /usr/local/bin/walrus

COPY requirements.txt .
RUN pip3 install -r requirements.txt

# Copy application code and entrypoint
COPY app.py .
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

# Set environment variable
ENV XDG_CONFIG_HOME=/root/.sui

# Create configuration
RUN mkdir -p /root/.sui && \
    echo -e "---\nenv: devnet\nactive_address: \"0x0\"\naccounts:\n  - address: \"0x0\"\n    key: \"\"\nclient_configs:\n  - alias: devnet\n    rpc: \"https://fullnode.devnet.sui.io:443\"\n    faucet: \"https://faucet.devnet.sui.io/gas\"" > /root/.sui/client_config.yaml

# Verify configuration
RUN cat /root/.sui/client_config.yaml && \
    yamllint /root/.sui/client_config.yaml

# Debug Walrus CLI
RUN walrus --version && \
    walrus --config /root/.sui/client_config.yaml --help

# Expose port
EXPOSE 8080

# Set entrypoint
ENTRYPOINT ["/app/entrypoint.sh"]