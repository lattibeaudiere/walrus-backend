#!/bin/bash
# Ensure example.txt exists
echo "This is an example blob" > /app/example.txt

# Generate wallet if keystore doesn't exist
if [ ! -f /root/.sui/sui.keystore ]; then
    walrus generate-sui-wallet --config /root/.sui/client_config.yaml
fi

# Store and tag the example blob
blob_id=$(walrus store --epochs 1 /app/example.txt --config /root/.sui/client_config.yaml | cut -d' ' -f1)
walrus tag $blob_id origins --config /root/.sui/client_config.yaml

# Start Flask app
exec python3 /app/app.py
