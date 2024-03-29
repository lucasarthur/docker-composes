# syntax=docker/dockerfile:1
FROM --platform=$TARGETPLATFORM ubuntu:22.04 AS builder
ARG TARGETPLATFORM

RUN apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates curl \
  && case "$TARGETPLATFORM" in \
    "linux/amd64") \
      curl https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu2204-6.0.6.tgz -o mongodb.tgz \
      && curl https://downloads.mongodb.com/compass/mongosh-1.9.1-linux-x64.tgz -o mongosh.tgz \
      ;; \
    "linux/arm64") \
      curl https://fastdl.mongodb.org/linux/mongodb-linux-aarch64-ubuntu2204-6.0.6.tgz -o mongodb.tgz \
      && curl https://downloads.mongodb.com/compass/mongosh-1.9.1-linux-arm64.tgz -o mongosh.tgz \
      ;; \
    *) echo "Unsupported platform: $TARGETPLATFORM" && exit 1 ;; \
  esac \
  && tar -xzf mongodb.tgz \
  && tar -xzf mongosh.tgz \
  && rm -rf mongodb.tgz mongosh.tgz \
  && mv mongodb-*/bin/mongod mongosh-*/bin/mongosh /usr/local/bin/ \
  && rm -rf mongodb-* mongosh-* \
  && apt-get purge -y --auto-remove ca-certificates curl \
  && rm -rf /var/lib/apt/lists/*

FROM ubuntu:22.04

RUN apt-get update \
  && apt-get install -y --no-install-recommends curl wait-for-it \
  && rm -rf /var/lib/apt/lists/* \
  && groupadd -r mongo && useradd -r -g mongo -d /home/mongo -m mongo

COPY --from=builder /usr/local/bin/mongod /usr/local/bin/mongosh /usr/local/bin/
COPY init-dbs.sh init-replica.sh entry-point.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init-dbs.sh /usr/local/bin/init-replica.sh /usr/local/bin/entry-point.sh

RUN mkdir -p /var/lib/mongo1 /var/log/mongo1 /var/lib/mongo2 /var/log/mongo2 /var/lib/mongo3 /var/log/mongo3 \
  && chown -R mongo:mongo /var/lib/mongo1 /var/log/mongo1 /var/lib/mongo2 /var/log/mongo2 /var/lib/mongo3 /var/log/mongo3

EXPOSE 27017
EXPOSE 27018
EXPOSE 27019

USER mongo
ENTRYPOINT [ "bash", "/usr/local/bin/entry-point.sh" ]
