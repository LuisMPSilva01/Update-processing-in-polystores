# Use the official PostgreSQL 14.10 image as base
FROM library/postgres:14.10

#### Installation of required libraries ####

#RUN apt update && apt install -y gcc make git pkg-config wget libssl-dev libmongoc-dev \
#    libbson-dev postgresql-server-dev-14 python3-pip python3-dev build-essential autogen cmake

##########################################
##### Installation of MongoDB wrapper ####
WORKDIR /
# Set your desired packages
ARG BUILD_PKGS="git build-essential make autogen wget cmake pkg-config libzstd-dev libssl-dev"
ARG RUNTIME_PKGS="postgresql-server-dev-14 libmongoc-dev"
RUN apt-get update && apt-get install -y ${BUILD_PKGS} ${RUNTIME_PKGS} &&\
    mkdir -p /fdwLibs/mongoc /fdwLibs/jsonc &&\
    chmod 777 /fdwLibs/mongoc &&\
    chmod 777 /fdwLibs/jsonc
ENV MONGOC_INSTALL_DIR=/fdwLibs/mongoc
ENV JSONC_INSTALL_DIR=/fdwLibs/jsonc
RUN git clone https://github.com/EnterpriseDB/mongo_fdw.git /mongo_fdw &&\
    cd /mongo_fdw && ./autogen.sh
ENV LD_LIBRARY_PATH=/fdwLibs/mongoc/lib64:/tmp/ldLib
ENV PKG_CONFIG_PATH=/mongo_fdw/mongo-c-driver/src/libmongoc/src:/mongo_fdw/mongo-c-driver/src/libbson/src
ENV PATH=/usr/lib/postgresql/14/bin/:$PATH
RUN cd /mongo_fdw && make USE_PGXS=1 &&\
    make USE_PGXS=1 install &&\
    apt-get purge -y ${BUILD_PKGS}  &&\
    rm -rf /var/lib/apt/lists/*

##########################################
#####       Installation of PLSH      ####
WORKDIR /
RUN BUILD_PKGS="git build-essential make" &&\
    RUNTIME_PKGS="postgresql-server-dev-14" &&\
    apt-get update && apt-get install -y ${BUILD_PKGS} ${RUNTIME_PKGS} &&\
    git clone https://github.com/petere/plsh &&\
    cd plsh make && make install &&\
    rm -rf /plsh &&\
    apt-get purge -y ${BUILD_PKGS} &&\
    rm -rf /var/lib/apt/lists/*

# Start PostgreSQL service as default command
CMD [ "postgres" ]
