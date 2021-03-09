# perkeep-container

A multistage docker build for [Perkeep](https://perkeep.org/).

## Docker Image

This container image is available as an automated build on [Docker Hub](https://hub.docker.com/).

- `docker pull tullo/perkeep-amd64:0.1.0`

## Docker Compose

- Build the image: `docker-compose build`
- Push to dockerhub: `docker-compose push`
- Start the service: `docker-compose up`
- Stop the service: `docker-compose down`

## Deployment

### Exposed Ports

- `3179/tcp` Perkeep's HTTP interface.

### Volumes

- `/home/perkeep/.config/perkeep` Perkeep configuration.
- `/storage` Blob storage and index.

You will need to map these volumes if you wish to persist your config and blob storage between container restarts.

During its first start, the container will create an identity key-ring and `server-config.json` which you will need to edit to customize your username and password for authentication.

## Config Management

Edit configuration of the running perkeep container:

- Display applied config: `docker-compose exec perkeep cat /home/perkeep/.config/perkeep/server-config.json`
- Edit server config: `docker-compose exec perkeep vi /home/perkeep/.config/perkeep/server-config.json`
- Shell into the container: `docker-compose exec perkeep sh`
- Restart `perkeepd` via web UI: http://perkeep.127.0.0.1.nip.io:3179/ui/status/

## Container Debugging

- `docker-compose run --entrypoint sh perkeep`
