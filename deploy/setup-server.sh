#!/bin/bash
# Ersteinrichtung von epswx auf dem Hetzner-Server.
# Muss als root ausgeführt werden.
set -e

APP_DIR=/apps/epswx
REPO_URL=https://github.com/wetterheidi/epswx.git
NGINX_CONF=/etc/nginx/sites-available/epswx.wetterheidi.de
DOMAIN=epswx.wetterheidi.de

echo "==> Repo klonen oder aktualisieren..."
if [ -d "$APP_DIR/.git" ]; then
    git -C "$APP_DIR" pull
else
    git clone "$REPO_URL" "$APP_DIR"
fi

echo "==> Berechtigungen setzen..."
chown -R www-data:www-data "$APP_DIR"

echo "==> nginx-Konfiguration einspielen..."
cp "$APP_DIR/deploy/nginx-epswx.conf" "$NGINX_CONF"
ln -sf "$NGINX_CONF" /etc/nginx/sites-enabled/

echo "==> SSL-Zertifikat holen (certbot)..."
certbot --nginx -d "$DOMAIN"

echo "==> nginx testen und neu laden..."
nginx -t && systemctl reload nginx

echo ""
echo "Fertig! Die App ist erreichbar unter: https://$DOMAIN"
echo "Login: Benutzer aus /etc/nginx/.htpasswd-wetterheidi"
