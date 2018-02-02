FROM debian:jessie

ENV DB4VERSION "db-4.8.30.NC"

RUN DB4DIR="/usr/local/db4" \
    DB4FILE=$DB4VERSION".tar.gz" \
    DB4URL="http://download.oracle.com/berkeley-db/"$DB4FILE \
    DB4HASH=12edc0df75bf9abd7f82f821795bcee50f42cb2e5f76a6a281b85732798364ef \
    && set -xe \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends \
        g++ \
        make \
        libdb4.8 \
        libdb++-dev \
        autoconf \
        libtool \
        wget \
    && rm -rf /var/lib/apt/lists/* \
    && wget $DB4URL \
    && echo "$DB4HASH $DB4FILE" | sha256sum -c - \
    && tar -xzvf $DB4FILE \
    && cd $DB4VERSION"/build_unix/" \
    && ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=$DB4DIR \
    && mkdir -p $DB4DIR \
    && make install \
    && cd ../../ \
    && rm $DB4FILE \
    && rm -rf $DB4VERSION \
    && export BDB_INCLUDE_PATH="$DB4DIR/include" \
    && export BDB_LIB_PATH="$DB4DIR/lib" \
    && ln -s $DB4DIR/libdb-4.8.so /usr/lib/libdb-4.8.so
