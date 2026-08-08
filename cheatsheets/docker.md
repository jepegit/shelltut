# Docker cheatsheet

Docs: [docs.docker.com](https://docs.docker.com/)

## Daemon sanity

```bash
docker version
docker info
docker compose version
```

## Containers

```bash
docker run --rm image [cmd]           # run + remove on exit
docker run -d --name NAME -p H:C image
docker run -it image sh               # interactive shell
docker ps / docker ps -a
docker logs -f NAME
docker exec -it NAME sh
docker stop NAME / docker start NAME
docker rm NAME / docker rm -f NAME
```

`-p 8088:8080` = host port `8088` → container port `8080`.

## Images

```bash
docker pull image:tag
docker images / docker image ls
docker build -t name:tag .
docker history name:tag
docker rmi name:tag
```

## Compose

```bash
docker compose -f file.yaml up -d --build
docker compose -f file.yaml ps
docker compose -f file.yaml logs -f
docker compose -f file.yaml down        # keep named volumes
docker compose -f file.yaml down -v     # also delete volumes
```

## Volumes & mounts

```bash
docker volume create NAME
docker volume ls
docker volume rm NAME
docker run --rm -v NAME:/data image …
docker run --rm -v "$PWD/dir:/data:ro" image …
```

## Cleanup

```bash
docker container prune -f
docker image prune -f
docker system df
# destructive — unused images too:
# docker system prune -a
```

## shelltut helpers

```bash
./scripts/postgres.sh up|down|reset|psql|status
docker compose -f playground/docker/compose.yaml up -d --build
```
