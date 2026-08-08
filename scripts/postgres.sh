#!/usr/bin/env bash
# Manage the shelltut practice Postgres container.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
compose_dir="$root/playground/postgres"
export COMPOSE_PROJECT_NAME="${COMPOSE_PROJECT_NAME:-shelltut}"

url='postgresql://shelltut:shelltut@127.0.0.1:54329/shelltut'

die() { echo "$*" >&2; exit 1; }

need_docker() {
  command -v docker >/dev/null 2>&1 || die "docker not found. Install Docker Desktop/Engine and enable WSL integration if needed."
  docker info >/dev/null 2>&1 || die "docker is installed but not reachable. Is the daemon running?"
}

compose() {
  if docker compose version >/dev/null 2>&1; then
    docker compose -f "$compose_dir/docker-compose.yml" "$@"
  elif command -v docker-compose >/dev/null 2>&1; then
    docker-compose -f "$compose_dir/docker-compose.yml" "$@"
  else
    die "docker compose not available"
  fi
}

usage() {
  cat <<EOF
Usage: $(basename "$0") <command>

Commands:
  up        Start Postgres (first start loads seed SQL)
  down      Stop and remove the container (keeps volume)
  reset     Wipe volume and recreate with fresh seed data
  status    Show compose status
  url       Print the connection URL
  psql      Open psql in the container (no local client needed)
  wait      Block until Postgres accepts connections

Connection URL:
  $url
EOF
}

cmd="${1:-}"
case "$cmd" in
  up)
    need_docker
    compose up -d
    "$0" wait
    echo "Postgres ready: $url"
    ;;
  down)
    need_docker
    compose down
    ;;
  reset)
    need_docker
    compose down -v
    compose up -d
    "$0" wait
    echo "Postgres reset and ready: $url"
    ;;
  status)
    need_docker
    compose ps
    ;;
  url)
    echo "$url"
    ;;
  wait)
    need_docker
    for _ in $(seq 1 60); do
      if compose exec -T db pg_isready -U shelltut -d shelltut >/dev/null 2>&1; then
        exit 0
      fi
      sleep 1
    done
    die "timed out waiting for Postgres"
    ;;
  psql)
    need_docker
    shift || true
    compose exec -e PAGER=cat db psql -U shelltut -d shelltut "$@"
    ;;
  ""|-h|--help|help)
    usage
    ;;
  *)
    usage
    die "unknown command: $cmd"
    ;;
esac
