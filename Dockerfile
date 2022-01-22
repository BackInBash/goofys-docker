FROM alpine as build-stage

RUN apk add -u wget curl ca-certificates
RUN wget https://github.com/kahing/goofys/releases/download/$(curl -L -s -H 'Accept: application/json' https://github.com/kahing/goofys/releases/latest | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')/goofys

FROM alpine 

# add syslog-ng (syslog required by Goofys)
RUN apk add -u fuse syslog-ng ca-certificates
COPY syslog-ng.conf /etc/syslog-ng/syslog-ng.conf

# Copy binary
COPY --from=build-stage goofys /usr/bin/goofys
COPY run.sh /root/run.sh

ENTRYPOINT [ "/root/run.sh" ]
