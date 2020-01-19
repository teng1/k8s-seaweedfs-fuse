FROM alpine:latest
ENV COLUMNS=200
RUN apk add --no-cache --update libtool curl bash tar net-tools fuse fakeroot
RUN mkdir -p /seaweedfs /data/store-01 /seaweedfs/mydir
RUN wget -P /tmp https://github.com/$(curl -s -L https://github.com/chrislusf/seaweedfs/releases/latest | egrep -o 'chrislusf/seaweedfs/releases/download/.*/linux_amd64.tar.gz') && \
    tar -C /seaweedfs/ -xzvf /tmp/linux_amd64.tar.gz

# VOLUME /data
COPY filer.toml /seaweedfs/filer.toml
COPY entrypoint.sh /seaweedfs/entrypoint.sh
COPY start.sh /seaweedfs/start.sh

# Allow others in fuse config
COPY fuse.conf /etc/fuse.conf

RUN chmod +x /seaweedfs/start.sh /seaweedfs/entrypoint.sh  /seaweedfs/weed 
RUN chown -R 1000:1000 /seaweedfs /data

RUN adduser seaweedfs --uid=1000 --disabled-password --home=/seaweedfs --no-create-home

# volume server gprc port
EXPOSE 18080
# volume server http port
EXPOSE 8080
# filer server gprc port
EXPOSE 18888
# filer server http port
EXPOSE 8888
# master server shared gprc port
EXPOSE 19333
# master server shared http port
EXPOSE 9333
# s3 server http port
EXPOSE 8333
USER 1000
WORKDIR /seaweedfs/
ENTRYPOINT ["/seaweedfs/start.sh"]
