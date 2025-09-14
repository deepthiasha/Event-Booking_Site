#!/bin/bash
set -euo pipefail

WEB_ROOT="/var/www/html"
APP_DIR="/var/www/react-app"

mkdir -p "$WEB_ROOT" "$APP_DIR"


rsync -av --delete "$APP_DIR"/ "$WEB_ROOT"/


DEFAULT_SITE="/etc/nginx/sites-available/default"
if ! grep -q 'try_files $uri /index.html;' "$DEFAULT_SITE"; then
  sudo sed -i 's|location / {|location / {\n\t\ttry_files $uri /index.html;|' "$DEFAULT_SITE" || true
fi

sudo systemctl reload nginx
echo "Deployment completed successfully."