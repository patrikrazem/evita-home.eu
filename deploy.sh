#!/usr/bin/env bash
set -euo pipefail

SERVER="deployer@hetzner.razem.si"
REMOTE_DIR="/opt/evita-home.eu"

echo "→ Ensuring remote directory exists"
ssh "$SERVER" "mkdir -p $REMOTE_DIR"

echo "→ Syncing files"
rsync -az --delete \
  --exclude='.git' \
  --exclude='.gitignore' \
  --exclude='.claude' \
  --exclude='.DS_Store' \
  --exclude='deploy.sh' \
  . "$SERVER:$REMOTE_DIR"

echo "→ Making files readable by nginx"
ssh "$SERVER" "chmod -R a+rX $REMOTE_DIR"

echo "→ Updating nginx configuration"
ssh "$SERVER" "sudo ln -sf $REMOTE_DIR/nginx.conf /etc/nginx/sites-enabled/evita-home.eu && sudo nginx -t && sudo systemctl reload nginx"

echo "✓ Done — site running at https://evita-home.eu"
