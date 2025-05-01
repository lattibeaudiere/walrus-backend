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
    echo -e "system_object: 0x98ebc47370603fe81d9e15491b2f1443d619d1dab720d586e429ed233e1255c1\nstaking_object: 0x20266a17b4f1a216727f3eef5772f8d486a9e3b5e319af80a5b75809c035561d" > /root/.sui/client_config.yaml && \
    touch /root/.sui/sui.keystore
RUN cat /root/.sui/client_config.yaml
RUN walrus --version && \
    walrus --config /root/.sui/client_config.yaml --help
ENV XDG_CONFIG_HOME=/root/.sui
RUN blob_id=$(walrus store --epochs 1 example.txt --config /root/.sui/client_config.yaml | cut -d' ' -f1)

CMD ["python3", "app.py"]