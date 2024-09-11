# nginx-proxy-qbittorrent-filebrowser

Ez a Docker Compose fájl egy egyszerű konfigurációt kínál a Nginx Proxy Manager, qBittorrent és FileBrowser szolgáltatásokhoz. Ezek a szolgáltatások konténereken belül futnak, és a Docker Compose alkalmazás segítségével könnyen telepíthetők és konfigurálhatók. Mivel a qBittorrent nem tartalmaz beépített fileszerver funkciót, a FileBrowser segítségével könnyen elérhetővé válnak a qBittorrent által letöltött fájlok webes felületen keresztül. Így a felhasználók egyszerűen böngészhetik és tölthetik le a qBittorrent által kezelt tartalmakat, és további kényelmes és távoli hozzáférést biztosíthatnak a letöltött fájlokhoz.

## Előkövetelmények

- [Docker](https://docs.docker.com/engine/install/)
- [Docker Compose](https://docs.docker.com/compose/)

## Telepítés

1. Klónozd le a GitHub repót:

    ```bash
    git clone git@github.com:baloghszilveszter/nginx-proxy-qbittorrent-filebrowser.git
    cd nginx-proxy-qbittorrent-filebrowser
    ```

2. Hozd létre a munkakönyvtárakat:
   
    > [!WARNING]
    > Igény szerint módosítsd a downloads mappa útvonalát!

    ```bash
    mkdir -p /opt/nginx/data /opt/nginx/letsencrypt /opt/qbittorrent/qconfig /opt/filebrowser /mnt/data/downloads
    ```

3. Hozd létre a filemanager config fájlt:
    ```bash
    echo '{
        "port": 8081,
        "baseURL": "",
        "address": "",
        "log": "stdout",
        "database": "/database/filebrowser.db",
        "root": "/srv"
        }' > /opt/filebrowser/settings.json
    ```

4. Indítsd el a szolgáltatásokat:
    ```bash
    docker compose up -d 
    ```