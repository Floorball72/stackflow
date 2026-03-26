-- UHC Jonschwil Vipers -- Schema Updates
-- Im Supabase SQL Editor ausfuehren

-- todos Spalte zu events hinzufuegen (JSONB Array)
alter table events add column if not exists todos jsonb default '[]'::jsonb;

-- kamera Spalte zu games hinzufuegen
alter table games add column if not exists kamera boolean default false;

-- social_posts Tabelle sicherstellen (war schon im Original-Setup)
-- Falls noch nicht vorhanden:
create table if not exists social_posts (
  id uuid primary key default gen_random_uuid(),
  typ text not null check (typ in ('vorschau', 'resultat', 'event', 'info')),
  woche_datum date not null,
  geplant_fuer timestamptz not null,
  status text default 'geplant' check (status in ('geplant', 'erledigt', 'uebersprungen')),
  canva_link text,
  text_entwurf text,
  plattformen text[] default array['instagram', 'facebook'],
  google_cal_id text,
  created_at timestamptz default now()
);

-- RLS
alter table social_posts enable row level security;
create policy if not exists "Anon -- Alles" on social_posts for all using (true);

-- Fertig!
