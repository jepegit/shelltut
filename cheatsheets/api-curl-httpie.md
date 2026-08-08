# API testing: curl · httpie · jq

## curl essentials

```bash
curl -sS URL                          # body only, show errors
curl -sS -D - -o /dev/null URL        # headers to stdout
curl -sS -o body.json -w '%{http_code}\n' URL
curl -sS -L URL                       # follow redirects
curl -sS -X POST URL \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer TOKEN' \
  --data @payload.json
curl -sS -G URL --data-urlencode 'q=battery'
curl -v URL                           # debug once
```

Useful `-w` tokens: `%{http_code}`, `%{url_effective}`, `%{time_total}`.

## httpie / xh

```bash
http GET URL
http GET URL q==value limit==10       # query params
http POST URL < payload.json          # raw JSON body
http POST URL title=hello completed:=false   # JSON fields
http POST URL X-Training:shelltut     # headers
http -b GET URL | jq .                # body only → jq
xh GET URL                            # xh is similar
```

## jq asserts

```bash
curl -sS URL | jq .
curl -sS URL | jq -e '.id == 1' >/dev/null    # exit 1 if false/null
curl -sS URL | jq -r '.status'
curl -sS URL | jq '[.[] | select(.userId == 1)] | length'
```

## Tiny smoke pattern

```bash
set -euo pipefail
code="$(curl -sS -o /tmp/body.json -w '%{http_code}' "$URL")"
test "$code" = "200"
jq -e '.expected_field != null' /tmp/body.json >/dev/null
```

## Sandboxes

| URL | Use |
|-----|-----|
| `https://httpbin.org/...` | Echo methods/headers/body |
| `https://jsonplaceholder.typicode.com/...` | Fake todos/users/posts |

## GUI cousins (when CLI is not enough)

Postman, Insomnia, Bruno, VS Code REST Client / Thunder Client — use the same ideas: method, URL, headers, body, env vars, then assert status + JSON paths.
