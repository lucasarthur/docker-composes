FROM ubuntu:22.04 as base

ARG MONGO=mongodb-linux-x86_64-ubuntu2204-6.0.5
ARG MONGOSH=mongosh-1.8.0-linux-x64-openssl3

ARG MONGO_URL=https://fastdl.mongodb.org/linux/${MONGO}.tgz
ARG MONGOSH_URL=https://downloads.mongodb.com/compass/${MONGOSH}.tgz

# update & upgrade
RUN apt-get update && \
    apt-get upgrade -y

# install curl & openSSL
RUN apt-get install -y curl openssl

# downloads mongo & mongosh
RUN curl -OL ${MONGO_URL} && \
    curl -OL ${MONGOSH_URL}

# extract them
RUN tar -zxvf ${MONGO}.tgz && \
    tar -zxvf ${MONGOSH}.tgz

# move binaries
RUN mv ./${MONGO}/bin/* /usr/local/bin/ && \
    mv ./${MONGOSH}/bin/* /usr/local/bin/

# remove all the useless stuff
RUN rm -rf ./${MONGO} && rm ./${MONGO}.tgz && \
    rm -rf ./${MONGOSH} && rm ./${MONGOSH}.tgz

# copy script files
COPY ./init-dbs.sh ./init-replica.sh ./entry-point.sh /

# and give 'em some power
RUN chmod +x /init-dbs.sh && \
    chmod +x /init-replica.sh && \
    chmod +x /entry-point.sh

# data directories
ARG DB1_DATA_DIR=/var/lib/mongo1
ARG DB2_DATA_DIR=/var/lib/mongo2
ARG DB3_DATA_DIR=/var/lib/mongo3

# log directories
ARG DB1_LOG_DIR=/var/log/mongodb1
ARG DB2_LOG_DIR=/var/log/mongodb2
ARG DB3_LOG_DIR=/var/log/mongodb3

# db ports
ARG DB1_PORT=27017
ARG DB1_PORT=27018
ARG DB1_PORT=27019

# dirs and permissions, all that bla, bla, bla
RUN mkdir -p ${DB1_DATA_DIR} && \
    mkdir -p ${DB1_LOG_DIR} && \
    mkdir -p ${DB2_DATA_DIR} && \
    mkdir -p ${DB2_LOG_DIR} && \
    mkdir -p ${DB3_DATA_DIR} && \
    mkdir -p ${DB3_LOG_DIR} && \
    chown `whoami` ${DB1_DATA_DIR} && \
    chown `whoami` ${DB1_LOG_DIR} && \
    chown `whoami` ${DB2_DATA_DIR} && \
    chown `whoami` ${DB2_LOG_DIR} && \
    chown `whoami` ${DB3_DATA_DIR} && \
    chown `whoami` ${DB3_LOG_DIR}

EXPOSE ${DB1_PORT}
EXPOSE ${DB2_PORT}
EXPOSE ${DB3_PORT}

ENTRYPOINT [ "bash", "entry-point.sh" ]
