# 17 — PostgreSQL with `psql`

Docs: [PostgreSQL](https://www.postgresql.org/docs/current/) · [psql](https://www.postgresql.org/docs/current/app-psql.html)

Practice against a disposable Postgres 16 container seeded with `people`, `cells`, and `measurements` (same theme as the playground CSV/JSON files).

## Goals

Start a local database, connect with `psql`, explore schemas, run SQL, import/export CSV, and dump/restore.

## Setup

Needs Docker (Desktop or Engine). On WSL2, enable Docker Desktop → Settings → Resources → WSL Integration for this distro. New to Docker? Do [exercise 18](18-docker.md) first.

```bash
./scripts/postgres.sh up
./scripts/postgres.sh url
# postgresql://shelltut:shelltut@127.0.0.1:54329/shelltut
```

Connect (pick one):

```bash
# A) psql inside the container (no local client install)
./scripts/postgres.sh psql

# B) local psql if installed
psql "postgresql://shelltut:shelltut@127.0.0.1:54329/shelltut"
```

Optional nicer client: `pgcli` with the same URL.

Reset seed data anytime:

```bash
./scripts/postgres.sh reset
```

Stop when finished (volume kept unless you `reset`):

```bash
./scripts/postgres.sh down
```

## Drills — connect & meta commands

Inside `psql`:

1. Connection sanity:

```sql
SELECT current_database(), current_user, version();
```

2. Learn the backslash toolkit:

| Command | Purpose |
|---------|---------|
| `\conninfo` | how you are connected |
| `\dt` | list tables |
| `\d cells` | describe table |
| `\d+ people` | describe with extras |
| `\di` | list indexes |
| `\x auto` | expanded/vertical rows when wide |
| `\timing on` | show query time |
| `\q` | quit |

3. List tables and describe `measurements`.

## Drills — SQL queries

1. Basic selects:

```sql
SELECT * FROM people ORDER BY score DESC LIMIT 5;
SELECT id, chemistry, status FROM cells WHERE status = 'ok';
```

2. Aggregations:

```sql
SELECT role, count(*) AS n, round(avg(score), 1) AS avg_score
FROM people
GROUP BY role
ORDER BY n DESC;
```

3. Join cells to owners:

```sql
SELECT c.id, c.chemistry, c.status, p.name AS owner
FROM cells c
JOIN people p ON p.id = c.owner_id
ORDER BY c.id;
```

4. Latest measurement per cell:

```sql
SELECT DISTINCT ON (cell_id)
  cell_id, recorded_at, voltage_v, current_a
FROM measurements
ORDER BY cell_id, recorded_at DESC;
```

5. Write a filter that returns only failed cells with their last voltage.

## Drills — change data (then reset)

1. Insert a measurement:

```sql
INSERT INTO measurements (cell_id, voltage_v, current_a)
VALUES ('cell-001', 3.650, 1.420)
RETURNING *;
```

2. Update and delete carefully:

```sql
UPDATE cells SET cycles = cycles + 1 WHERE id = 'cell-002' RETURNING id, cycles;
DELETE FROM measurements WHERE cell_id = 'cell-003' RETURNING id;
```

3. Transactions — try, then undo:

```sql
BEGIN;
UPDATE people SET score = 100 WHERE id = 1;
SELECT id, name, score FROM people WHERE id = 1;
ROLLBACK;
SELECT id, name, score FROM people WHERE id = 1;
```

4. Restore the seed when you want a clean slate: exit psql and run `./scripts/postgres.sh reset`.

## Drills — CSV import / export

Use the playground CSV and `\copy` (client-side; works well from container if we pipe, or from local `psql`).

From the **host** with local `psql` (files on your machine):

```bash
psql "postgresql://shelltut:shelltut@127.0.0.1:54329/shelltut" <<'SQL'
CREATE TEMP TABLE people_csv (
  id int, name text, role text, city text, score int
);
\copy people_csv FROM 'playground/data/people.csv' CSV HEADER
SELECT role, count(*) FROM people_csv GROUP BY role ORDER BY 2 DESC;
SQL
```

From **container psql**, export a query to stdout CSV:

```bash
./scripts/postgres.sh psql -c "\copy (SELECT id, chemistry, status FROM cells ORDER BY id) TO STDOUT WITH CSV HEADER" \
  > playground/scratch/cells-export.csv
cat playground/scratch/cells-export.csv
```

## Drills — dump & restore

1. Logical dump of the schema + data:

```bash
docker exec shelltut-postgres pg_dump -U shelltut -d shelltut \
  > playground/scratch/shelltut.dump.sql
head -n 40 playground/scratch/shelltut.dump.sql
```

2. After a reset, reload that dump (optional practice):

```bash
./scripts/postgres.sh reset
# wait until ready, then:
docker exec -i shelltut-postgres psql -U shelltut -d shelltut \
  < playground/scratch/shelltut.dump.sql
```

## Stretch

- Explain a plan: `EXPLAIN ANALYZE SELECT * FROM measurements WHERE cell_id = 'cell-001';`
- Create a view `ok_cells` and `SELECT` from it
- Add a `CHECK` or unique constraint and watch an insert fail
- Try `pgcli` against the same URL
- Pair with [API testing](16-api-testing.md): run a tiny local API that reads from this DB later
- GUI option when you want one: DBeaver / TablePlus / pgAdmin using host `127.0.0.1`, port `54329`, user/password/db `shelltut`

## Check yourself

With `./scripts/postgres.sh up`, you can `\dt`, join `cells` to `people`, insert one measurement in a transaction you roll back, and export CSV with `\copy`.
