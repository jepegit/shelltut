# 18 — Docker

Docs: [docs.docker.com](https://docs.docker.com/) · [Compose](https://docs.docker.com/compose/)

Docker packages an app and its dependencies into an **image**, then runs it as a **container**. This exercise uses:

- official images (`hello-world`, `nginx`, `postgres`)
- a tiny local app under `playground/docker/`
- the Postgres stack from [exercise 17](17-postgresql.md) via Compose

If you are new to Docker, do this **before** the PostgreSQL drills.

## Goals

Check the daemon, run/stop containers, view logs, map ports, work with volumes, build an image, and use Compose.

## Setup

Install Docker Desktop or Engine. On WSL2: Docker Desktop → Settings → Resources → **WSL Integration** → enable this distro.

```bash
docker version
docker info >/dev/null && echo "daemon ok"
docker compose version
```

## Drills — run & inspect

1. Smoke test:

```bash
docker run --rm hello-world
```

`--rm` deletes the container when it exits.

2. Run a short-lived shell in Alpine:

```bash
docker run --rm -it alpine:3.20 sh
# inside: uname -a; cat /etc/os-release; exit
```

3. Run nginx in the background with a host port:

```bash
docker run -d --name shelltut-nginx -p 8089:80 nginx:alpine
docker ps
curl -sS -o /dev/null -w '%{http_code}\n' http://127.0.0.1:8089/
docker logs --tail 20 shelltut-nginx
docker stop shelltut-nginx
docker rm shelltut-nginx
```

4. Inspect vs exec:

```bash
docker run -d --name shelltut-nginx -p 8089:80 nginx:alpine
docker inspect shelltut-nginx --format '{{.State.Status}} {{.NetworkSettings.IPAddress}}'
docker exec -it shelltut-nginx sh -c 'hostname; ls /usr/share/nginx/html'
docker rm -f shelltut-nginx
```

`exec` runs a command **inside a running container**; `run` creates a new one.

## Drills — images & cleanup

1. List and pull:

```bash
docker images
docker pull alpine:3.20
docker image ls alpine
```

2. See what eats space, then prune only dangling leftovers (safe-ish):

```bash
docker system df
docker container prune -f
docker image prune -f
```

Avoid `docker system prune -a` until you know you want unused images deleted.

## Drills — build the local demo

From the repo root:

```bash
cd playground/docker
docker build -t shelltut-web:local .
docker run --rm -d --name shelltut-web -p 8088:8080 shelltut-web:local
curl -sS http://127.0.0.1:8088/ | head
docker logs shelltut-web
docker rm -f shelltut-web
cd ../..
```

Read `playground/docker/Dockerfile` and note: base image → copy files → `EXPOSE` → `CMD`.

## Drills — Compose

1. Start the demo with Compose:

```bash
docker compose -f playground/docker/compose.yaml up -d --build
docker compose -f playground/docker/compose.yaml ps
curl -sS -o /dev/null -w '%{http_code}\n' http://127.0.0.1:8088/
docker compose -f playground/docker/compose.yaml logs --tail 20
docker compose -f playground/docker/compose.yaml down
```

2. Use the project helper for Postgres (Compose under the hood):

```bash
./scripts/postgres.sh up
./scripts/postgres.sh status
docker ps --filter name=shelltut-postgres
docker volume ls | rg shelltut || docker volume ls | grep shelltut
./scripts/postgres.sh down
```

3. Open `playground/postgres/docker-compose.yml` and map each key to a concept:

| Key | Meaning |
|-----|---------|
| `image` | what to run |
| `ports` | `host:container` publish |
| `environment` | env vars inside container |
| `volumes` | persist data / mount init SQL |
| `healthcheck` | readiness probe |

## Drills — volumes & bind mounts

1. Named volume (survives container delete):

```bash
docker volume create shelltut-vol
docker run --rm -v shelltut-vol:/data alpine:3.20 sh -c 'echo banana > /data/note.txt'
docker run --rm -v shelltut-vol:/data alpine:3.20 cat /data/note.txt
docker volume rm shelltut-vol
```

2. Bind mount a host file/dir (live edit from host):

```bash
docker run --rm -v "$(pwd)/playground/notes.txt:/data/notes.txt:ro" alpine:3.20 cat /data/notes.txt
```

Postgres seed SQL uses a bind mount of `playground/postgres/init` into `/docker-entrypoint-initdb.d`.

## Stretch

- `docker history shelltut-web:local` — see image layers
- Multi-stage builds (for smaller production images)
- Networks: `docker network create shelltut-net` and attach two containers by name
- Resource limits: `docker run --memory=128m --cpus=0.5 …`
- Pair with [API testing](16-api-testing.md): `curl` the demo on `:8088`
- Pair with [PostgreSQL](17-postgresql.md): exec/`psql` into `shelltut-postgres`

## Check yourself

You can `docker run` nginx on a published port, `docker build` + run `shelltut-web:local`, and bring the demo Compose file up/down without leaving stray containers (`docker ps -a` looks clean).
