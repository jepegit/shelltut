# PostgreSQL / psql cheatsheet

## shelltut practice DB

```bash
./scripts/postgres.sh up
./scripts/postgres.sh psql
./scripts/postgres.sh reset
./scripts/postgres.sh down
```

URL: `postgresql://shelltut:shelltut@127.0.0.1:54329/shelltut`

## Connect

```bash
psql "$DATABASE_URL"
psql -h 127.0.0.1 -p 54329 -U shelltut -d shelltut
# password: shelltut
```

## psql meta commands

| Command | Purpose |
|---------|---------|
| `\conninfo` | connection info |
| `\l` | list databases |
| `\c dbname` | connect to database |
| `\dt` | list tables |
| `\d table` | describe table |
| `\di` | list indexes |
| `\dn` | list schemas |
| `\df` | list functions |
| `\x auto` | expanded display |
| `\timing` | toggle timing |
| `\e` | edit current query in `$EDITOR` |
| `\i file.sql` | run SQL file |
| `\q` | quit |

## SQL you will use constantly

```sql
SELECT ... FROM ... WHERE ... ORDER BY ... LIMIT ...;
INSERT INTO t (cols) VALUES (...) RETURNING *;
UPDATE t SET col = val WHERE ... RETURNING *;
DELETE FROM t WHERE ... RETURNING *;
BEGIN; ... COMMIT;   -- or ROLLBACK;
EXPLAIN ANALYZE SELECT ...;
```

## CSV

```sql
-- client-side (path on the machine running psql)
\copy table_name FROM 'file.csv' CSV HEADER
\copy (SELECT ...) TO 'file.csv' CSV HEADER
```

`COPY` (no backslash) is server-side and needs file access inside the Postgres host/container.

## Dump / restore

```bash
pg_dump -U USER -d DB > dump.sql
psql -U USER -d DB < dump.sql
pg_dump -Fc -U USER -d DB > dump.dump
pg_restore -U USER -d DB dump.dump
```

## URL shape

```text
postgresql://USER:PASSWORD@HOST:PORT/DBNAME
```
