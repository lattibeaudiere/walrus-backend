FROM ubuntu:22.04

RUN apt-get update && apt-get install -y wget ca-certificates tar python3 python3-pip curl yamllint

# Download and install latest Walrus CLI
RUN curl -sSf https://docs.wal.app/setup/walrus-install.sh | sh -s -- -f && \
    cp $HOME/.local/bin/walrus /usr/local/bin/ && \
    chmod +x /usr/local/bin/walrus

COPY requirements.txt .
RUN pip3 install -r requirements.txt

# Copy application code and entrypoint
COPY . /app
WORKDIR /app
COPY entrypoint.sh .
RUN chmod +x /app/entrypoint.sh

# Set environment variable
ENV XDG_CONFIG_HOME=/root/.sui

# Create configuration
RUN mkdir -p /root/.sui && \
    echo "---\nenv: devnet\nactive_address: \"0x0\"\naccounts:\n  - address: \"0x0\"\n    key: \"\"\nclient_configs:\n  - alias: devnet\n    rpc: \"https://fullnode.devnet.sui.io:443\"\n    faucet: \"https://faucet.devnet.sui.io/gas\"" > /tmp/client_config.yaml && \
    cp /tmp/client_config.yaml /root/.sui/client_config.yaml

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