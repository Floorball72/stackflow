-- Schema-Ergaenzung fuer Login-Verknuepfung
-- Im Supabase SQL Editor ausfuehren

-- user_id Spalte zu players hinzufuegen
alter table players add column if not exists user_id uuid references auth.users(id) on delete set null;

-- Index fuer schnelle Suche
create index if not exists players_user_id_idx on players(user_id);

-- Fertig!
