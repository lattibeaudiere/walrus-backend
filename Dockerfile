FROM ubuntu:22.04

RUN apt-get update && apt-get install -y wget ca-certificates tar python3 python3-pip curl

# Download and extract the Walrus CLI from the .tgz release
RUN wget https://github.com/MystenLabs/walrus/releases/download/mainnet-v1.22.1/walrus-mainnet-v1.22.1-ubuntu-x86_64.tgz -O /tmp/walrus.tgz && \
    tar -xzf /tmp/walrus.tgz -C /usr/local/bin && \
    chmod +x /usr/local/bin/walrus

COPY requirements.txt .
RUN pip3 install -r requirements.txt

COPY app.py .

RUN echo "This is an example blob" > example.txt
RUN apt-get update && apt-get install -y curl -y
RUN mkdir -p /root/.sui && \
    curl https://raw.githubusercontent.com/MystenLabs/walrus-docs/main/docs/client_config.yaml -o /root/.sui/client_config.yaml && \
    touch /root/.sui/sui.keystore
RUN cat /root/.sui/client_config.yaml
RUN walrus --version && \
    walrus --config /root/.sui/client_config.yaml --help
ENV XDG_CONFIG_HOME=/root/.sui
RUN blob_id=$(walrus store --epochs 1 example.txt --config /root/.sui/client_config.yaml | cut -d' ' -f1)

CMD ["python3", "app.py"]