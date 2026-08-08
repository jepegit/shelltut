# 16 — Testing APIs with curl, httpie, and jq

Related: [jq](10-jq.md) · [gh api](14-gh.md)

Typical terminal stack for poking at HTTP APIs: **curl** (everywhere) or **httpie**/`xh` (nicer UX), plus **jq** to inspect and assert JSON.

These drills use public sandboxes. They need network access.

| Service | Base URL | Notes |
|---------|----------|--------|
| httpbin | `https://httpbin.org` | Echoes methods, headers, body |
| JSONPlaceholder | `https://jsonplaceholder.typicode.com` | Fake REST resources |

## Goals

Send GET/POST requests, set headers, read status codes, shape JSON with jq, and write a tiny smoke-check script.

## Setup

```bash
curl --version | head -n 1
jq --version
command -v http || command -v xh || echo "optional: install httpie or xh"
```

Install options if you want the nicer client:

```bash
# httpie → `http` / `https`
pipx install httpie
# or: brew install httpie

# xh → httpie-like, often faster
# brew install xh
```

Work from the repo root. Sample POST body: `playground/data/api-payload.json`.

## Drills — curl GET

1. Fetch a resource and pretty-print with jq:

```bash
curl -sS https://jsonplaceholder.typicode.com/todos/1 | jq .
```

`-sS` = silent progress, but still show errors.

2. Show response headers and body separately:

```bash
curl -sS -D playground/scratch/headers.txt \
  -o playground/scratch/todo.json \
  https://jsonplaceholder.typicode.com/todos/1
cat playground/scratch/headers.txt
jq . playground/scratch/todo.json
```

3. Print only the HTTP status code:

```bash
curl -sS -o /dev/null -w '%{http_code}\n' \
  https://jsonplaceholder.typicode.com/todos/1
```

4. Follow redirects explicitly when you need to (APIs vary):

```bash
curl -sS -L -o /dev/null -w '%{url_effective} %{http_code}\n' \
  https://httpbin.org/redirect/1
```

5. Send a custom header:

```bash
curl -sS -H 'Accept: application/json' \
  -H 'X-Training: shelltut' \
  https://httpbin.org/headers | jq '.headers["X-Training"]'
```

## Drills — curl POST / PUT / DELETE

1. POST JSON from a file:

```bash
curl -sS -X POST https://jsonplaceholder.typicode.com/posts \
  -H 'Content-Type: application/json' \
  --data @playground/data/api-payload.json | jq .
```

2. Same idea with httpbin so you can see what the server received:

```bash
curl -sS -X POST https://httpbin.org/post \
  -H 'Content-Type: application/json' \
  --data @playground/data/api-payload.json | jq '{status: .json, headers: .headers["Content-Type"]}'
```

3. Query params and form fields:

```bash
curl -sS 'https://httpbin.org/get?q=battery&limit=2' | jq '.args'
curl -sS -X POST https://httpbin.org/post \
  -d 'name=ada&role=engineer' | jq .form
```

4. Auth header pattern (do not put real secrets in the repo):

```bash
# example shape only — fake token
curl -sS https://httpbin.org/bearer \
  -H 'Authorization: Bearer training-token' | jq .
```

## Drills — assert with jq

Treat jq as your lightweight test assertions.

1. Check fields on a todo:

```bash
curl -sS https://jsonplaceholder.typicode.com/todos/1 \
  | jq 'select(.id == 1 and .userId == 1) | {id, title, completed}'
```

2. Fail the pipeline if a condition is wrong (exit via shell):

```bash
completed="$(curl -sS https://jsonplaceholder.typicode.com/todos/1 | jq -r '.completed')"
test "$completed" = "false" && echo "ok: completed is false"
```

3. Count items and filter:

```bash
curl -sS https://jsonplaceholder.typicode.com/users \
  | jq 'map({id, name, city: .address.city}) | .[:3]'

curl -sS https://jsonplaceholder.typicode.com/posts \
  | jq '[.[] | select(.userId == 1)] | length'
```

4. Write a smoke check into `playground/scratch/api-smoke.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

base='https://jsonplaceholder.typicode.com'
code="$(curl -sS -o /tmp/shelltut-todo.json -w '%{http_code}' "$base/todos/1")"
test "$code" = "200"
jq -e '.id == 1 and (.title | type == "string")' /tmp/shelltut-todo.json >/dev/null
echo "smoke ok"
```

```bash
chmod +x playground/scratch/api-smoke.sh
./playground/scratch/api-smoke.sh
```

`jq -e` exits non-zero when the result is `false` or `null` — handy for asserts.

## Drills — httpie (or xh)

If `http` (httpie) or `xh` is installed, redo a few calls the ergonomic way:

```bash
# httpie
http GET https://jsonplaceholder.typicode.com/todos/1
http GET https://httpbin.org/get q==battery limit==2
http POST https://httpbin.org/post < playground/data/api-payload.json
http POST https://httpbin.org/post X-Training:shelltut title=hello completed:=false

# xh (similar)
xh GET https://jsonplaceholder.typicode.com/todos/1
xh POST https://httpbin.org/post < playground/data/api-payload.json
```

Notes:

- httpie: `==` query param, `:=` non-string JSON, `:` header, body fields as `key=value`
- Pipe to jq the same way: `http -b GET … | jq .` (`-b` body only)

## Stretch

- Timing: `curl -sS -o /dev/null -w 'time_total=%{time_total}\n' URL`
- Verbose debug once: `curl -v …` (look at request/response headers)
- Parallel smoke: hit `/todos/1`, `/todos/2`, `/users/1` and require all `200`
- Use `gh api` on a GitHub route you already know from [exercise 14](14-gh.md), then jq the JSON
- Against a local API: start anything on localhost and point curl at `http://127.0.0.1:PORT/...`
- OpenAPI: if you have a spec, try [Schemathesis](https://schemathesis.readthedocs.io/) or Postman/Bruno later — CLI smoke checks still start with curl + jq

## Check yourself

You can POST `playground/data/api-payload.json`, get JSON back, assert one field with `jq -e`, and print the HTTP status code with curl’s `-w`.
