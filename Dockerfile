# Build the Go binaries.
FROM golang:1.16.0-alpine3.13 as build_stage
ENV CGO_ENABLED='1'
ENV GO111MODULE='on'

RUN apk add --no-cache git
RUN git clone https://github.com/perkeep/perkeep.git perkeep.org
WORKDIR /go/perkeep.org
RUN go run make.go -static=true -v

# Production image
FROM alpine:3.13.2
RUN apk --no-cache add ca-certificates libjpeg-turbo-utils jq
RUN addgroup -g 3000 -S perkeep && adduser -u 100000 -S perkeep -G perkeep --disabled-password \
    && mkdir -p /perkeep && chown perkeep:perkeep /perkeep
RUN mkdir /config && chown perkeep: /config
RUN mkdir /storage && chown perkeep: /storage
COPY --from=build_stage /go/bin/* /usr/local/bin/
EXPOSE 3179
USER 100000
VOLUME /config
VOLUME /storage
WORKDIR /perkeep
COPY --chown=perkeep:perkeep docker-entrypoint.sh .
ENTRYPOINT ["/perkeep/docker-entrypoint.sh"]
