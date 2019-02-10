# Docker container with Rtorrent and Flood webui

![flood](https://user-images.githubusercontent.com/13349072/52536251-d9ce9d00-2d79-11e9-956f-b3de68bc7562.png)
**Be aware this image was made for my own use.**

## Main features

- Based on Alpine Linux.
- Provides by default a solid configuration.
- [Flood](https://github.com/jfurrow/flood), a modern web UI for rTorrent with a Node.js backend and React frontend.

## Environment variables

- **UID** : user id (default : 991)
- **GID** : group id (defaut : 991)
- **FLOOD_SECRET** : flood secret key (defaut : storm) (CHANGE IT)
- **FLOOD_BASE_URI** : context path (base_URI) (default : /)

See docker-compose.yml for example.

## Note

Run this container with tty mode enabled. In your `docker-compose.yml`, add `tty: true`.

**If you don't do this, rtorrent will use 100% of CPU**.

## Ports

- **50000** tcp, rtorrent
- **7000**  udp, rtorrent
- **3000**  tcp, flood web ui

## Volumes

- **/data** : your downloaded torrents, session files, symlinks...
- **/flood-db** : Flood databases.

## Filebot support

Dear Linux user, root,

FileBot currently only officially supports Windows 10 and macOS because these platforms make it easy to sell FileBot via their respective app stores. Unfortunately, selling software on Ubuntu, Debian, Red Hat, SUSE, Synology NAS, QNAP NAS, etc is not as easy and not really worth the effort considering the small number of users willing to support the project. This Patreon is an experiment to see how many users are willing to financially contribute towards freely available donation-supported new releases on these platforms.

Please support FileBot for Linux with a pledge of $1 per release on Patreon:

=> https://www.patreon.com/filebot

If every other Linux user were to pledge a small amount of money to the FileBot project, then you could easily fund the project ten times over. Please financially support the software you use and rely on, be it FileBot or any other tool. It's just polite, and it helps the ecosystem.

Thank you,
The FileBot Team
