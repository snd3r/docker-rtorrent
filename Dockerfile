FROM alpine:3.8

ARG FLOOD_VER=master
ARG BUILD_CORES

ENV UID=991 GID=991 \
    UID=65534 \
    GID=65534 \
    SCGI_PATH=/tmp/rtorrent.sock \
    PORT_RANGE=50000-50000 \
    DHT_MODE=auto \
    DHT_PORT=7000 \
    PROTO_PEX=yes \
    PROTO_UDP=yes \
    FLOOD_SECRET=storm \
    FLOOD_WEBROOT='/' \
    FLOOD_PORT=3000 \
    PKG_CONFIG_PATH=/usr/local/lib/pkgconfig \
    CHROMAPRINT_VER=1.4.3 \
    FILEBOT_VER=4.7.9 \
    FILEBOT_RENAME_METHOD="symlink" \
    FILEBOT_RENAME_MOVIES="{n} ({y})" \
    FILEBOT_RENAME_SERIES="{n}/Season {s.pad(2)}/{s00e00} - {t}" \
    FILEBOT_RENAME_ANIMES="{n}/{e.pad(3)} - {t}" \
    FILEBOT_RENAME_MUSICS="{n}/{fn}"

RUN apk add -U openjdk8-jre java-jna-native binutils wget \
    && mkdir /filebot \
    && cd /filebot \
    && wget http://downloads.sourceforge.net/project/filebot/filebot/FileBot_${FILEBOT_VER}/FileBot_${FILEBOT_VER}-portable.tar.xz -O /filebot/filebot.tar.xz \
    && tar xJf filebot.tar.xz \
    && ln -sf /usr/lib/libzen.so.0.0.0 /filebot/lib/x86_64/libzen.so \
    && ln -sf /usr/lib/libmediainfo.so.0.0.0 /filebot/lib/x86_64/libmediainfo.so \
    && wget https://github.com/acoustid/chromaprint/releases/download/v${CHROMAPRINT_VER}/chromaprint-fpcalc-${CHROMAPRINT_VER}-linux-x86_64.tar.gz \
    && tar xvf chromaprint-fpcalc-${CHROMAPRINT_VER}-linux-x86_64.tar.gz \
    && mv chromaprint-fpcalc-${CHROMAPRINT_VER}-linux-x86_64/fpcalc /usr/local/bin \
    && strip -s /usr/local/bin/fpcalc \
    && apk del binutils wget \
    && rm -rf /var/cache/apk/* /tmp/* /filebot/FileBot_${FILEBOT_VER}-portable.tar.xz /filebot/chromaprint-fpcalc-${CHROMAPRINT_VER}-linux-x86_64.tar.gz /filebot/chromaprint-fpcalc-${CHROMAPRINT_VER}-linux-x86_64

RUN apk -U upgrade \
 && apk add -t build-dependencies --no-cache \
    build-base \
    python \
    tar \
    wget \
    xz \
 && apk add --no-cache \
    ca-certificates \
    curl \
    findutils \
    gzip \
    mediainfo \
    mktorrent \
    nodejs \
    nodejs-npm \
    rtorrent \
    su-exec \
    supervisor \
    tini \
    xmlrpc-c \
    zip \
    zlib \
 && mkdir /srv/flood && cd /srv/flood && wget -qO- https://github.com/jfurrow/flood/archive/${FLOOD_VER}.tar.gz | tar xz --strip 1 \
 && npm install && npm cache clean --force \
 && apk del build-dependencies \
 && rm -rf /var/cache/apk/* /tmp/*

COPY rootfs /

RUN chmod +x /usr/local/bin/startup \
    && cd /srv/flood/ \
    && npm run build \
    && npm prune --production

VOLUME /data /flood-db

EXPOSE 3000 49184 49184/udp

LABEL description="BitTorrent client with WebUI front-end" \
      maintainer="https://github.com/snd3r"

ENTRYPOINT ["/usr/local/bin/startup"]
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]