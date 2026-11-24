#!/usr/bin/env bash
set -euo pipefail
container=$(docker run -d -p 127.0.0.1::5000 "$1")
trap 'docker rm -f "$container" >/dev/null' EXIT
endpoint=$(docker port "$container" 5000/tcp)
payload=''
for attempt in {1..15}; do
  if payload=$(curl --fail --silent --max-time 2 "http://$endpoint/health"); then
    break
  fi
  if [[ "$(docker inspect -f '{{.State.Running}}' "$container")" != true ]]; then
    break
  fi
  sleep 1
done
if [[ -z "$payload" ]]; then
  docker logs "$container"
  exit 1
fi
printf '%s\n' "$payload"
python3 -c 'import json,sys; assert json.load(sys.stdin) == {"status": "ok"}' <<< "$payload"
docker exec "$container" id
