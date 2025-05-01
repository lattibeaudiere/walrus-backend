#!/bin/bash
# Ensure example.txt exists
echo "This is an example blob" > /app/example.txt

# Create config directory
mkdir -p /root/.config/walrus

# Initialize Walrus config
echo "{
  "contexts": {
    "mainnet": {
      "env": "mainnet",
      "sui_rpc": "https://fullnode.mainnet.sui.io:443"
    }
  },
  "active_context": "mainnet"
}" > /root/.config/walrus/config.json

# Generate a Sui wallet
echo "Generating Sui wallet..."
walrus generate-sui-wallet

# Try to store the blob
echo "Attempting to store a blob..."
walrus store --epochs 1 /app/example.txt || echo "Failed to store blob"

# Start Flask app
exec python3 /app/app.py
