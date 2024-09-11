#!/bin/bash

# Kérdések feltevése a felhasználónak
read -p "Add meg a felhasználói azonosítót (PUID) [alapértelmezett: 1000]: " PUID
PUID=${PUID:-1000}

read -p "Add meg a csoport azonosítót (PGID) [alapértelmezett: 1000]: " PGID
PGID=${PGID:-1000}

read -p "Add meg az időzónát (TZ) [alapértelmezett: Europe/Budapest]: " TZ
TZ=${TZ:-"Europe/Budapest"}

# Nginx konfiguráció
read -p "Add meg az nginx IP címét [alapértelmezett: 172.20.0.10]: " NGINX_IP
NGINX_IP=${NGINX_IP:-"172.20.0.10"}

read -p "Add meg az nginx adat volume útvonalát [alapértelmezett: /opt/nginx/data]: " NGINX_DATA_VOLUME
NGINX_DATA_VOLUME=${NGINX_DATA_VOLUME:-"/opt/nginx/data"}

read -p "Add meg az nginx Let's Encrypt volume útvonalát [alapértelmezett: /opt/nginx/letsencrypt]: " NGINX_LETSENCRYPT_VOLUME
NGINX_LETSENCRYPT_VOLUME=${NGINX_LETSENCRYPT_VOLUME:-"/opt/nginx/letsencrypt"}

# qBittorrent konfiguráció
read -p "Add meg a qBittorrent IP címét [alapértelmezett: 172.20.0.20]: " QBITTORRENT_IP
QBITTORRENT_IP=${QBITTORRENT_IP:-"172.20.0.20"}

read -p "Add meg a qBittorrent konfigurációs volume útvonalát [alapértelmezett: /opt/qbittorrent/qconfig]: " QBITTORRENT_CONFIG_VOLUME
QBITTORRENT_CONFIG_VOLUME=${QBITTORRENT_CONFIG_VOLUME:-"/opt/qbittorrent/qconfig"}

read -p "Add meg a qBittorrent letöltési volume útvonalát [alapértelmezett: /mnt/data/downloads]: " QBITTORRENT_DOWNLOADS_VOLUME
QBITTORRENT_DOWNLOADS_VOLUME=${QBITTORRENT_DOWNLOADS_VOLUME:-"/mnt/data/downloads"}

# Filebrowser konfiguráció
read -p "Add meg a Filebrowser IP címét [alapértelmezett: 172.20.0.30]: " FILEBROWSER_IP
FILEBROWSER_IP=${FILEBROWSER_IP:-"172.20.0.30"}

read -p "Add meg a Filebrowser adat volume útvonalát [alapértelmezett: /mnt/data/downloads]: " FILEBROWSER_DATA_VOLUME
FILEBROWSER_DATA_VOLUME=${FILEBROWSER_DATA_VOLUME:-"/mnt/data/downloads"}

read -p "Add meg a Filebrowser adatbázis volume útvonalát [alapértelmezett: /opt/filebrowser/database.db]: " FILEBROWSER_DB_VOLUME
FILEBROWSER_DB_VOLUME=${FILEBROWSER_DB_VOLUME:-"/opt/filebrowser/database.db"}

read -p "Add meg a Filebrowser beállítások volume útvonalát [alapértelmezett: /opt/filebrowser/.filebrowser.json]: " FILEBROWSER_CONFIG_VOLUME
FILEBROWSER_CONFIG_VOLUME=${FILEBROWSER_CONFIG_VOLUME:-"/opt/filebrowser/.filebrowser.json"}

# Hálózati konfiguráció
read -p "Add meg a hálózati alhálózatot (subnet) [alapértelmezett: 172.20.0.0/16]: " SUBNET
SUBNET=${SUBNET:-"172.20.0.0/16"}

# Ellenőrizni, hogy létezik-e a Filebrowser konfigurációs mappa
FILEBROWSER_DIR=$(dirname "$FILEBROWSER_CONFIG_VOLUME")
if [ ! -d "$FILEBROWSER_DIR" ]; then
  echo "Létrehozom a Filebrowser konfigurációs könyvtárat: $FILEBROWSER_DIR"
  mkdir -p "$FILEBROWSER_DIR"
fi

# .filebrowser.json fájl generálása
cat <<EOF > "$FILEBROWSER_CONFIG_VOLUME"
{
  "port": 8081,
  "baseURL": "",
  "address": "",
  "log": "stdout",
  "database": "$FILEBROWSER_DB_VOLUME",
  "root": "$FILEBROWSER_DATA_VOLUME"
}
EOF

echo ".filebrowser.json fájl legenerálva a következő helyre: $FILEBROWSER_CONFIG_VOLUME"

# Docker Compose fájl generálása
cat <<EOF > docker-compose.yml
services:
  nginx:
    image: jc21/nginx-proxy-manager:2.11.3
    container_name: nginx
    restart: unless-stopped
    environment:
      - PUID=$PUID  # Felhasználói azonosító
      - PGID=$PGID  # Csoport azonosító
      - TZ=$TZ  # Időzóna
    ports:
      - 80:80
      - 81:81
      - 443:443
    volumes:
      - $NGINX_DATA_VOLUME:/data  # nginx konfigurációs mappa
      - $NGINX_LETSENCRYPT_VOLUME:/etc/letsencrypt  # Let's Encrypt fájlok
    networks:
      torrent_network:
        ipv4_address: $NGINX_IP

  qbittorrent:
    image: linuxserver/qbittorrent:4.6.6
    container_name: qbittorrent
    restart: unless-stopped
    environment:
      - PUID=$PUID  # Felhasználói azonosító
      - PGID=$PGID  # Csoport azonosító
      - TZ=$TZ  # Időzóna
    volumes:
      - $QBITTORRENT_CONFIG_VOLUME:/config  # qBittorrent konfigurációs mappa
      - $QBITTORRENT_DOWNLOADS_VOLUME:/downloads  # Letöltések mappája
    ports:
      - 127.0.0.1:8080:8080
      - 50000:50000
    networks:
      torrent_network:
        ipv4_address: $QBITTORRENT_IP

  filebrowser:
    image: filebrowser/filebrowser:v2.30.0
    container_name: filebrowser
    restart: unless-stopped
    environment:
      - PUID=$PUID  # Felhasználói azonosító
      - PGID=$PGID  # Csoport azonosító
      - TZ=$TZ  # Időzóna
    volumes:
      - $FILEBROWSER_DATA_VOLUME:/srv
      - $FILEBROWSER_DB_VOLUME:/database.db
      - $FILEBROWSER_CONFIG_VOLUME:/.filebrowser.json
    ports:
      - 127.0.0.1:8081:8081
    networks:
      torrent_network:
        ipv4_address: $FILEBROWSER_IP

networks:
  torrent_network:
    driver: bridge
    ipam:
      config:
        - subnet: $SUBNET

EOF

echo "Docker Compose fájl legenerálva: docker-compose.yml"
