# Build the Go binaries.
FROM golang:1.17.3-alpine3.13 as build_stage
ENV CGO_ENABLED='1'
ENV GO111MODULE='on'

RUN apk add --no-cache git
RUN git clone https://github.com/tullo/b2.git perkeep-b2
RUN git clone https://github.com/tullo/perkeep.git perkeep.org
WORKDIR /go/perkeep.org
RUN go run make.go -static=true -v

# Production image
FROM alpine:3.20.0
RUN apk --no-cache add ca-certificates libjpeg-turbo-utils jq tzdata && \
    cp /usr/share/zoneinfo/Europe/Copenhagen /etc/localtime && \
    echo "Europe/Copenhagen" >  /etc/timezone && \
    apk del tzdata
RUN addgroup -g 3000 -S perkeep && adduser -u 100000 -S perkeep -G perkeep --disabled-password && \
    mkdir /perkeep && chown perkeep:perkeep /perkeep
RUN mkdir -p /home/perkeep/.config/perkeep && chown perkeep: /home/perkeep/.config/perkeep
RUN mkdir /storage && chown perkeep: /storage
COPY --from=build_stage /go/bin/* /usr/local/bin/
EXPOSE 3179
USER 100000
VOLUME ["/home/perkeep/.config/perkeep", "/storage" ]
WORKDIR /perkeep
COPY --chown=perkeep:perkeep docker-entrypoint.sh .
ENTRYPOINT ["/perkeep/docker-entrypoint.sh"]
