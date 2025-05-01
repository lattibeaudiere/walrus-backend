#!/bin/bash
# Ensure example.txt exists
echo "This is an example blob" > /app/example.txt

# Create a proper Sui config directory
mkdir -p /root/.sui/sui_config

# Initialize a basic Sui wallet config
echo "---
active_address: null
active_env: devnet
envs:
  devnet:
    rpc: "https://fullnode.devnet.sui.io:443"
    ws: ~
" > /root/.sui/sui_config/client.yaml

# Try to store the blob
echo "Attempting to store a blob..."
walrus store --epochs 1 /app/example.txt || echo "Failed to store blob"

# Start Flask app
exec python3 /app/app.py
