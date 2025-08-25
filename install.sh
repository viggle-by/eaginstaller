#!/bin/bash

set -e

# --- 0. Auto-elevate with sudo if not root ---
if [ "$EUID" -ne 0 ]; then
  echo "🔐 Elevating with sudo..."
  exec sudo "$0" "$@"
fi

# --- 1. Install required packages ---
echo "[1/5] Installing dependencies (unzip + nginx)..."
apt-get update && apt-get install -y unzip nginx curl

# --- 2. Download the wasm.zip ---
echo "[2/5] Downloading wasm.zip..."
curl -L -o /tmp/wasm.zip https://github.com/radmanplays/classic-0.0.11a/releases/download/b15345d/wasm.zip

# --- 3. Unzip to /var/www/html ---
echo "[3/5] Unzipping to /var/www/html..."
rm -rf /var/www/html/*
unzip -o /tmp/wasm.zip -d /var/www/html
rm /tmp/wasm.zip

# --- 4. Configure NGINX to serve on port 8080 ---
echo "[4/5] Configuring nginx to listen on port 8080..."
cat > /etc/nginx/sites-available/default <<EOF
server {
    listen 8080 default_server;
    listen [::]:8080 default_server;

    root /var/www/html;
    index index.html;

    server_name _;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

# --- 5. Restart nginx ---
echo "[5/5] Restarting nginx..."
systemctl restart nginx

echo "✅ Setup complete! Access Eaglercraft at http://localhost:8080 (or Codespaces preview)."
