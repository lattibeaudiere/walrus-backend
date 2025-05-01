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
COPY sui_config /root/.sui/sui_config
ENV XDG_CONFIG_HOME=/root/.sui
RUN walrus store --epochs 1 example.txt --config $XDG_CONFIG_HOME/sui_config/client.yaml && \
    walrus tag $(walrus store --epochs 1 example.txt --config $XDG_CONFIG_HOME/sui_config/client.yaml | cut -d' ' -f1) origins

CMD ["python3", "app.py"]