#!/bin/bash
# Aktualisierung von epswx (nach git push).
# Muss als root ausgeführt werden.
set -e

APP_DIR=/apps/epswx

echo "==> Repo aktualisieren..."
git -C "$APP_DIR" pull

echo "==> Berechtigungen setzen..."
chown -R www-data:www-data "$APP_DIR"

echo "==> Fertig."
