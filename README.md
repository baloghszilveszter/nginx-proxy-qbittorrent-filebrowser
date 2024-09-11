# nginx-proxy-qbittorrent-filebrowser

Ez a git repo egy egyszerű konfigurációt kínál a Nginx Proxy Manager, qBittorrent és FileBrowser szolgáltatásokhoz. Ezek a szolgáltatások konténereken belül futnak, és a Docker Compose alkalmazás segítségével könnyen telepíthetők és konfigurálhatók. Mivel a qBittorrent nem tartalmaz beépített fileszerver funkciót, a FileBrowser segítségével könnyen elérhetővé válnak a qBittorrent által letöltött fájlok webes felületen keresztül. Így a felhasználók egyszerűen böngészhetik és tölthetik le a qBittorrent által kezelt tartalmakat, és további kényelmes és távoli hozzáférést biztosíthatnak a letöltött fájlokhoz.

## Előkövetelmények

- [Docker](https://docs.docker.com/engine/install/)
- [Docker Compose](https://docs.docker.com/compose/)

## Telepítés

1. Klónozd le a GitHub repót:

    ```bash
    git clone git@github.com:baloghszilveszter/nginx-proxy-qbittorrent-filebrowser.git
    cd nginx-proxy-qbittorrent-filebrowser
    ```

2. Futtatsd az install script-et:
   
    ```bash
    ./install.sh
    ```

3. Indítsd el a szolgáltatásokat:

    ```bash
    docker compose up -d 
    ```

4. Igény szerint állítsd be az nginx-proxy-manager felületén az elérésket.

    ```bash
    http://<your-server-ip>:81
    ```

    > **Figyelem**: Fontos, hogy az első bejelentkezés után változtasd meg ezeket az adatokat a biztonság érdekében.

    Az alapértelmezett bejelentkezési adatok:
    Felhasználónév: admin@example.com
    Jelszó: changeme

5. qBittorrent alapértelmezett bejelentkezési adatok:
   
    > **Figyelem**: Fontos, hogy az első bejelentkezés után változtasd meg ezeket az adatokat a biztonság érdekében.

    Felhasználónév: admin
    Jelszó kinyeréséhez futtatsd az alabbi parancsot:
    ```bash
    docker logs qbittorrent  2>&1 | grep "temporary password"
    ```

6. Filebrowser alapértelmezett bejelentkezési adatok:

    > **Figyelem**: Fontos, hogy az első bejelentkezés után változtasd meg ezeket az adatokat a biztonság érdekében.

    Felhasznaálónév: admin
    Jelszó: admin
