#!/usr/bin/env bash
# Local SSH/rsync practice lab (Dockerized sshd on port 2222).
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
lab_dir="$root/playground/ssh"
key_dir="$lab_dir/keys"
private_key="$key_dir/shelltut_ed25519"
public_key="$private_key.pub"
authorized_keys="$lab_dir/authorized_keys"
export COMPOSE_PROJECT_NAME="${COMPOSE_PROJECT_NAME:-shelltutssh}"

ssh_host='127.0.0.1'
ssh_port='2222'
ssh_user='shelltut'

die() { echo "$*" >&2; exit 1; }

need_docker() {
  command -v docker >/dev/null 2>&1 || die "docker not found"
  docker info >/dev/null 2>&1 || die "docker daemon not reachable"
}

compose() {
  if docker compose version >/dev/null 2>&1; then
    docker compose -f "$lab_dir/docker-compose.yml" "$@"
  elif command -v docker-compose >/dev/null 2>&1; then
    docker-compose -f "$lab_dir/docker-compose.yml" "$@"
  else
    die "docker compose not available"
  fi
}

ensure_keys() {
  mkdir -p "$key_dir"
  if [[ ! -f "$private_key" ]]; then
    ssh-keygen -t ed25519 -N "" -f "$private_key" -C "shelltut-ssh-lab"
    echo "Created lab key: $private_key"
  fi
  cp "$public_key" "$authorized_keys"
  chmod 600 "$private_key" "$authorized_keys"
  chmod 644 "$public_key"
}

ssh_opts=(
  -i "$private_key"
  -p "$ssh_port"
  -o IdentitiesOnly=yes
  -o StrictHostKeyChecking=accept-new
  -o UserKnownHostsFile="$lab_dir/known_hosts"
)

usage() {
  cat <<EOF
Usage: $(basename "$0") <command>

Commands:
  up        Create lab key (if needed) and start sshd on port ${ssh_port}
  down      Stop the lab container
  reset     Recreate container and wipe /data volume
  status    Show compose status
  ssh       SSH into the lab (extra args passed through)
  info      Print connection details

Example:
  $(basename "$0") up
  $(basename "$0") ssh
  rsync -av -e "\$( $(basename "$0") rsync-e )" ./playground/notes.txt ${ssh_user}@${ssh_host}:/data/incoming/
EOF
}

print_info() {
  cat <<EOF
Host:     ${ssh_user}@${ssh_host}
Port:     ${ssh_port}
Key:      ${private_key}
SSH:      ssh -i ${private_key} -p ${ssh_port} ${ssh_user}@${ssh_host}
Config:   see playground/ssh/ssh_config.example
EOF
}

cmd="${1:-}"
case "$cmd" in
  up)
    need_docker
    ensure_keys
    compose up -d --build
    for _ in $(seq 1 40); do
      if compose exec -T ssh pgrep sshd >/dev/null 2>&1; then
        break
      fi
      sleep 0.5
    done
    print_info
    ;;
  down)
    need_docker
    compose down
    ;;
  reset)
    need_docker
    ensure_keys
    compose down -v
    compose up -d --build
    print_info
    ;;
  status)
    need_docker
    compose ps
    ;;
  info)
    ensure_keys
    print_info
    ;;
  ssh)
    need_docker
    shift || true
    exec ssh "${ssh_opts[@]}" "${ssh_user}@${ssh_host}" "$@"
    ;;
  rsync-e)
    # Print an -e argument suitable for: rsync -e "$(./scripts/ssh-lab.sh rsync-e)" …
    ensure_keys
    echo "ssh -i ${private_key} -p ${ssh_port} -o IdentitiesOnly=yes -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=${lab_dir}/known_hosts"
    ;;
  ""|-h|--help|help)
    usage
    ;;
  *)
    usage
    die "unknown command: $cmd"
    ;;
esac
