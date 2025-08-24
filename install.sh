#!/bin/bash

set -e

# 1. Download the WASM zip
echo "Downloading wasm.zip..."
curl -L -o wasm.zip https://github.com/radmanplays/classic-0.0.11a/releases/download/b15345d/wasm.zip

# 2. Unzip it into a folder named 'wasm'
echo "Unzipping wasm.zip..."
unzip -o wasm.zip -d wasm

# 3. Install dependencies (Python3 is preinstalled in Codespaces)
echo "Installing requirements..."
sudo apt-get update && sudo apt-get install -y unzip

# 4. Clean up
rm wasm.zip

# 5. Success
echo "Setup complete! To start the server, run:"
echo "cd wasm && python3 -m http.server 8080"
