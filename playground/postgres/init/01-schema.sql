-- Seed schema for shelltut PostgreSQL drills.
-- Loaded automatically on first container start (empty data volume).

CREATE TABLE people (
  id          integer PRIMARY KEY,
  name        text NOT NULL,
  role        text NOT NULL,
  city        text NOT NULL,
  score       integer NOT NULL CHECK (score BETWEEN 0 AND 100)
);

CREATE TABLE cells (
  id            text PRIMARY KEY,
  chemistry     text NOT NULL,
  capacity_mah  integer NOT NULL,
  cycles        integer NOT NULL DEFAULT 0,
  status        text NOT NULL CHECK (status IN ('ok', 'failed', 'idle')),
  owner_id      integer REFERENCES people (id)
);

CREATE TABLE measurements (
  id          bigserial PRIMARY KEY,
  cell_id     text NOT NULL REFERENCES cells (id),
  recorded_at timestamptz NOT NULL DEFAULT now(),
  voltage_v   numeric(6, 3) NOT NULL,
  current_a   numeric(6, 3) NOT NULL
);

INSERT INTO people (id, name, role, city, score) VALUES
  (1, 'Ada Lovelace', 'engineer', 'London', 98),
  (2, 'Grace Hopper', 'engineer', 'New York', 95),
  (3, 'Alan Turing', 'researcher', 'Manchester', 99),
  (4, 'Katherine Johnson', 'analyst', 'West Virginia', 97),
  (5, 'Donald Knuth', 'researcher', 'Wisconsin', 94),
  (6, 'Barbara Liskov', 'engineer', 'Los Angeles', 96),
  (7, 'Linus Torvalds', 'engineer', 'Helsinki', 93),
  (8, 'Margaret Hamilton', 'engineer', 'Cambridge', 98),
  (9, 'Tim Berners-Lee', 'researcher', 'London', 91),
  (10, 'Radia Perlman', 'engineer', 'Portsmouth', 92);

INSERT INTO cells (id, chemistry, capacity_mah, cycles, status, owner_id) VALUES
  ('cell-001', 'NMC811', 3200, 120, 'ok', 1),
  ('cell-002', 'LFP', 2800, 240, 'ok', 2),
  ('cell-003', 'NMC811', 3150, 45, 'failed', 3),
  ('cell-004', 'NCA', 3500, 180, 'ok', 6);

INSERT INTO measurements (cell_id, recorded_at, voltage_v, current_a) VALUES
  ('cell-001', '2026-08-01 09:00:00+00', 3.720, 1.500),
  ('cell-001', '2026-08-01 10:00:00+00', 3.680, 1.480),
  ('cell-002', '2026-08-01 09:00:00+00', 3.310, 0.900),
  ('cell-002', '2026-08-01 11:00:00+00', 3.290, 0.880),
  ('cell-003', '2026-08-01 09:30:00+00', 2.950, 0.100),
  ('cell-004', '2026-08-01 09:00:00+00', 3.850, 1.200),
  ('cell-004', '2026-08-01 12:00:00+00', 3.820, 1.150);

CREATE INDEX measurements_cell_id_idx ON measurements (cell_id);
CREATE INDEX cells_status_idx ON cells (status);
