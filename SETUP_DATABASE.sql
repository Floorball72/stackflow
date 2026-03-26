-- ============================================================
-- UHC Jonschwil Vipers — VOLLSTÄNDIGES RESET & SETUP
-- ⚠️  Löscht ALLES und erstellt von Grund auf neu
-- Im Supabase SQL Editor ausführen
-- ============================================================

-- ── 1. Alles löschen ──────────────────────────────────────
drop table if exists inventar_ausleihen     cascade;
drop table if exists inventar               cascade;
drop table if exists sponsor_leistungen     cascade;
drop table if exists sponsoren              cascade;
drop table if exists anwesenheit            cascade;
drop table if exists news                   cascade;
drop table if exists mitgliedsausweise      cascade;
drop table if exists videoanalysen          cascade;
drop table if exists trainingseinheiten     cascade;
drop table if exists scorer                 cascade;
drop table if exists social_posts           cascade;
drop table if exists finanzen               cascade;
drop table if exists events                 cascade;
drop table if exists games                  cascade;
drop table if exists players                cascade;
drop table if exists teams                  cascade;
drop table if exists user_profiles          cascade;

-- ── 2. Teams ──────────────────────────────────────────────
create table teams (
  id              uuid primary key default gen_random_uuid(),
  name            text not null,
  liga            text,
  saison          text default '2024/25',
  trainingszeiten text,
  trainingsort    text,
  aktiv           boolean default true,
  created_at      timestamptz default now()
);

-- ── 3. User-Profile (verknüpft mit Supabase Auth) ─────────
create table user_profiles (
  id              uuid primary key references auth.users(id) on delete cascade,
  vorname         text not null,
  nachname        text not null,
  email           text,
  telefon         text,
  geburtsdatum    date,
  adresse         text,
  foto_url        text,
  rolle           text default 'spieler'
                    check (rolle in ('admin','trainer','spieler','eltern')),
  team_ids        uuid[],       -- Teams denen dieser User zugewiesen ist
  kind_ids        uuid[],       -- Für Eltern: Player-IDs der Kinder
  aktiv           boolean default true,
  mitglied_seit   date default current_date,
  mitglied_bis    date,
  notizen         text,
  created_at      timestamptz default now()
);

-- ── 4. Spieler ────────────────────────────────────────────
create table players (
  id              uuid primary key default gen_random_uuid(),
  team_id         uuid references teams(id) on delete cascade,
  user_id         uuid references auth.users(id) on delete set null,  -- Login-Verknüpfung
  vorname         text not null,
  nachname        text not null,
  nummer          integer,
  position        text,
  email           text,
  telefon         text,
  geburtsdatum    date,
  aktiv           boolean default true,
  created_at      timestamptz default now()
);

-- ── 5. Spiele ─────────────────────────────────────────────
create table games (
  id              uuid primary key default gen_random_uuid(),
  team_id         uuid references teams(id) on delete cascade,
  gegner          text not null,
  datum           date not null,
  anstoss         time not null default '17:00',
  heimspiel       boolean default true,
  liga            text,
  ort             text,
  resultat_heim   integer,
  resultat_gast   integer,
  kamera          boolean default false,
  notizen         text,
  swiss_uh_id     text,         -- ID aus Swiss Unihockey API
  google_cal_id   text,
  created_at      timestamptz default now()
);

-- ── 6. Events ─────────────────────────────────────────────
create table events (
  id              uuid primary key default gen_random_uuid(),
  titel           text not null,
  beschreibung    text,
  datum           date not null,
  uhrzeit         time,
  end_datum       date,
  end_uhrzeit     time,
  ort             text,
  typ             text default 'event'
                    check (typ in ('event','cup','turnier','gv','training')),
  team_ids        uuid[],       -- Welche Teams betroffen (null = alle)
  todos           jsonb default '[]'::jsonb,
  google_cal_id   text,
  created_at      timestamptz default now()
);

-- ── 7. Social Media Posts ─────────────────────────────────
create table social_posts (
  id              uuid primary key default gen_random_uuid(),
  typ             text not null
                    check (typ in ('vorschau','resultat','event','info')),
  woche_datum     date not null,
  geplant_fuer    timestamptz not null,
  status          text default 'geplant'
                    check (status in ('geplant','erledigt','uebersprungen')),
  canva_link      text,
  text_entwurf    text,
  plattformen     text[] default array['instagram','facebook'],
  google_cal_id   text,
  created_at      timestamptz default now()
);

-- ── 8. Scorer / Spielerstatistiken ────────────────────────
create table scorer (
  id              uuid primary key default gen_random_uuid(),
  player_id       uuid references players(id) on delete cascade,
  game_id         uuid references games(id) on delete cascade,
  tore            integer default 0,
  assists         integer default 0,
  strafminuten    integer default 0,
  saison          text default '2024/25',
  created_at      timestamptz default now(),
  unique(player_id, game_id)
);

-- ── 9. Anwesenheit ────────────────────────────────────────
create table anwesenheit (
  id              uuid primary key default gen_random_uuid(),
  player_id       uuid references players(id) on delete cascade,
  team_id         uuid references teams(id) on delete cascade,
  game_id         uuid references games(id) on delete set null,
  event_id        uuid references events(id) on delete set null,
  training_datum  date,
  typ             text default 'training'
                    check (typ in ('training','spiel','event')),
  status          text default 'offen'
                    check (status in ('anwesend','abwesend','entschuldigt','offen')),
  notiz           text,
  created_at      timestamptz default now(),
  unique(player_id, training_datum, typ, coalesce(game_id::text, event_id::text, 'none'))
);

-- ── 10. Newsfeed ──────────────────────────────────────────
create table news (
  id              uuid primary key default gen_random_uuid(),
  titel           text not null,
  inhalt          text,
  typ             text default 'info'
                    check (typ in ('info','wichtig','training','spiel','event')),
  -- Zielgruppe: array von team_ids ODER spezielle Werte 'alle','admin','trainer','spieler','eltern'
  zielgruppe      text[] default array['alle'],
  team_ids        uuid[],       -- Spezifische Teams (null = alle Teams)
  gepinnt         boolean default false,
  bild_url        text,
  erstellt_von    uuid references auth.users(id) on delete set null,
  erstellt_am     timestamptz default now(),
  created_at      timestamptz default now()
);

-- ── 11. Finanzen ──────────────────────────────────────────
create table finanzen (
  id              uuid primary key default gen_random_uuid(),
  game_id         uuid references games(id) on delete set null,
  event_id        uuid references events(id) on delete set null,
  typ             text not null check (typ in ('einnahme','ausgabe')),
  betrag          numeric(10,2) not null,
  kategorie       text,
  beschreibung    text,
  beleg_url       text,
  datum           date not null,
  erstellt_von    uuid references auth.users(id) on delete set null,
  created_at      timestamptz default now()
);

-- ── 12. Sponsoren ─────────────────────────────────────────
create table sponsoren (
  id              uuid primary key default gen_random_uuid(),
  firmenname      text not null,
  kontaktperson   text,
  email           text,
  telefon         text,
  website         text,
  logo_url        text,
  kategorie       text,         -- Hauptsponsor | Partner | Gönner
  betrag_jahr     numeric(10,2),
  vertrag_start   date,
  vertrag_ende    date,
  status          text default 'aktiv'
                    check (status in ('aktiv','inaktiv','verhandlung')),
  notizen         text,
  created_at      timestamptz default now()
);

create table sponsor_leistungen (
  id              uuid primary key default gen_random_uuid(),
  sponsor_id      uuid references sponsoren(id) on delete cascade,
  beschreibung    text not null,
  typ             text,         -- Logo | Trikot | Banner | Social-Post
  erledigt        boolean default false,
  faellig_am      date,
  created_at      timestamptz default now()
);

-- ── 13. Inventar ──────────────────────────────────────────
create table inventar (
  id              uuid primary key default gen_random_uuid(),
  name            text not null,
  kategorie       text,
  anzahl_total    integer default 1,
  anzahl_verfuegbar integer default 1,
  zustand         text default 'gut'
                    check (zustand in ('neu','gut','gebraucht','defekt')),
  lagerort        text,
  anschaffungsdatum date,
  anschaffungspreis numeric(10,2),
  notizen         text,
  created_at      timestamptz default now()
);

create table inventar_ausleihen (
  id              uuid primary key default gen_random_uuid(),
  inventar_id     uuid references inventar(id) on delete cascade,
  player_id       uuid references players(id) on delete set null,
  ausgegeben_am   date default current_date,
  zurueck_bis     date,
  zurueckgegeben_am date,
  notizen         text,
  created_at      timestamptz default now()
);

-- ── 14. Training & Video ──────────────────────────────────
create table trainingseinheiten (
  id              uuid primary key default gen_random_uuid(),
  team_id         uuid references teams(id) on delete cascade,
  titel           text not null,
  beschreibung    text,
  kategorie       text,
  video_url       text,
  datum           date,
  dauer_min       integer,
  trainer         text,
  created_at      timestamptz default now()
);

create table videoanalysen (
  id              uuid primary key default gen_random_uuid(),
  game_id         uuid references games(id) on delete set null,
  titel           text not null,
  video_url       text,
  notizen         text,
  tags            text[],
  sichtbar_fuer   text[] default array['trainer','admin'],
  erstellt_von    uuid references auth.users(id) on delete set null,
  created_at      timestamptz default now()
);

-- ── 15. Mitgliedsausweise ─────────────────────────────────
create table mitgliedsausweise (
  id              uuid primary key default gen_random_uuid(),
  user_id         uuid references auth.users(id) on delete cascade,
  ausgestellt     date default current_date,
  gueltig_bis     date,
  aktiv           boolean default true,
  created_at      timestamptz default now()
);

-- ── Indexes für Performance ────────────────────────────────
create index if not exists games_team_id_idx      on games(team_id);
create index if not exists games_datum_idx         on games(datum);
create index if not exists players_team_id_idx     on players(team_id);
create index if not exists players_user_id_idx     on players(user_id);
create index if not exists scorer_player_id_idx    on scorer(player_id);
create index if not exists anwesenheit_player_idx  on anwesenheit(player_id);
create index if not exists anwesenheit_datum_idx   on anwesenheit(training_datum);
create index if not exists news_erstellt_am_idx    on news(erstellt_am desc);

-- ── Row Level Security ────────────────────────────────────
alter table teams               enable row level security;
alter table user_profiles       enable row level security;
alter table players             enable row level security;
alter table games               enable row level security;
alter table events              enable row level security;
alter table social_posts        enable row level security;
alter table scorer              enable row level security;
alter table anwesenheit         enable row level security;
alter table news                enable row level security;
alter table finanzen            enable row level security;
alter table sponsoren           enable row level security;
alter table sponsor_leistungen  enable row level security;
alter table inventar            enable row level security;
alter table inventar_ausleihen  enable row level security;
alter table trainingseinheiten  enable row level security;
alter table videoanalysen       enable row level security;
alter table mitgliedsausweise   enable row level security;

-- ── RLS Policies ─────────────────────────────────────────
-- Öffentliche Daten (Spielplan, Teams) → jeder kann lesen
create policy "public_read_teams"   on teams   for select using (true);
create policy "public_read_games"   on games   for select using (true);
create policy "public_read_events"  on events  for select using (true);
create policy "public_read_players" on players for select using (true);

-- Eingeloggte User: Lesen
create policy "auth_read_news"      on news           for select using (auth.role() = 'authenticated');
create policy "auth_read_scorer"    on scorer         for select using (auth.role() = 'authenticated');
create policy "auth_read_anw"       on anwesenheit    for select using (auth.role() = 'authenticated');
create policy "auth_read_training"  on trainingseinheiten for select using (auth.role() = 'authenticated');
create policy "auth_read_video"     on videoanalysen  for select using (auth.role() = 'authenticated');
create policy "auth_read_inventar"  on inventar       for select using (auth.role() = 'authenticated');
create policy "auth_read_posts"     on social_posts   for select using (auth.role() = 'authenticated');

-- User-Profile: nur eigenes Profil lesen/schreiben
create policy "own_profile_read"   on user_profiles for select using (auth.uid() = id);
create policy "own_profile_write"  on user_profiles for update using (auth.uid() = id);
create policy "own_profile_insert" on user_profiles for insert with check (auth.uid() = id);

-- Finanzen + Sponsoren: nur eingeloggte User (Admin-Check per App-Logik)
create policy "auth_finanzen"    on finanzen           for all using (auth.role() = 'authenticated');
create policy "auth_sponsoren"   on sponsoren          for all using (auth.role() = 'authenticated');
create policy "auth_spon_leist"  on sponsor_leistungen for all using (auth.role() = 'authenticated');
create policy "auth_inventar_w"  on inventar           for all using (auth.role() = 'authenticated');
create policy "auth_inv_ausl"    on inventar_ausleihen for all using (auth.role() = 'authenticated');

-- Schreib-Zugriff (insert/update/delete) für eingeloggte User
create policy "auth_write_games"   on games           for all using (auth.role() = 'authenticated');
create policy "auth_write_events"  on events          for all using (auth.role() = 'authenticated');
create policy "auth_write_teams"   on teams           for insert with check (auth.role() = 'authenticated');
create policy "auth_write_teams2"  on teams           for update using (auth.role() = 'authenticated');
create policy "auth_write_players" on players         for all using (auth.role() = 'authenticated');
create policy "auth_write_scorer"  on scorer          for all using (auth.role() = 'authenticated');
create policy "auth_write_anw"     on anwesenheit     for all using (auth.role() = 'authenticated');
create policy "auth_write_news"    on news            for all using (auth.role() = 'authenticated');
create policy "auth_write_posts"   on social_posts    for all using (auth.role() = 'authenticated');
create policy "auth_write_train"   on trainingseinheiten for all using (auth.role() = 'authenticated');
create policy "auth_write_video"   on videoanalysen   for all using (auth.role() = 'authenticated');
create policy "auth_write_ausw"    on mitgliedsausweise for all using (auth.role() = 'authenticated');

-- ── Demo-Daten ────────────────────────────────────────────
insert into teams (name, liga, trainingszeiten, trainingsort) values
  ('UHC Jonschwil Vipers 1. Liga',  '1. Liga Gruppe 3', 'Di + Do 20:00–21:30', 'Sporthalle Jonschwil'),
  ('UHC Jonschwil Vipers 2. Liga',  '2. Liga',          'Mo + Mi 19:30–21:00', 'Sporthalle Jonschwil'),
  ('UHC Jonschwil Junioren U18',    'Junioren A',       'Sa 10:00–11:30',      'Sporthalle Jonschwil'),
  ('UHC Jonschwil Junioren U15',    'Junioren B',       'Sa 08:30–10:00',      'Sporthalle Jonschwil'),
  ('UHC Jonschwil Junioren U13',    'Junioren C',       'Fr 17:00–18:30',      'Sporthalle Jonschwil'),
  ('UHC Jonschwil Junioren U11',    'Junioren D',       'Fr 15:30–17:00',      'Sporthalle Jonschwil');

-- Demo-Spiele (aktuelle Saison)
insert into games (team_id, gegner, datum, anstoss, heimspiel, liga) values
  ((select id from teams where name like '%1. Liga%' limit 1), 'Zug United',   '2025-04-05', '17:00', true,  '1. Liga'),
  ((select id from teams where name like '%1. Liga%' limit 1), 'Chur-Araschgen','2025-04-12', '15:30', false, '1. Liga'),
  ((select id from teams where name like '%2. Liga%' limit 1), 'Wil-Flawil',   '2025-04-05', '19:30', true,  '2. Liga'),
  ((select id from teams where name like '%U18%'     limit 1), 'UHV Grabs',    '2025-04-06', '10:00', false, 'Junioren A'),
  ((select id from teams where name like '%U15%'     limit 1), 'Bütschwil',    '2025-04-06', '11:30', true,  'Junioren B');

-- Demo-Resultate letzte Woche
insert into games (team_id, gegner, datum, anstoss, heimspiel, liga, resultat_heim, resultat_gast) values
  ((select id from teams where name like '%1. Liga%' limit 1), 'Luzern United', '2025-03-29', '17:00', true,  '1. Liga', 8, 4),
  ((select id from teams where name like '%2. Liga%' limit 1), 'SG Wil',        '2025-03-29', '19:30', false, '2. Liga', 5, 7),
  ((select id from teams where name like '%U18%'     limit 1), 'Bronschhofen',  '2025-03-30', '10:00', true,  'Junioren A', 6, 3);

-- Demo-News
insert into news (titel, inhalt, typ, zielgruppe, gepinnt) values
  ('Willkommen auf der Vipers Vereinsplattform!',
   'Alle Infos zu Spielen, Training und Vereinsleben findest du hier.',
   'info', array['alle'], true),
  ('Training diese Woche findet statt',
   'Das Training am Dienstag und Donnerstag findet wie geplant statt.',
   'training', array['spieler','trainer'], false);

-- ============================================================
-- Setup abgeschlossen!
-- Tabellen: teams, user_profiles, players, games, events,
--   social_posts, scorer, anwesenheit, news, finanzen,
--   sponsoren, sponsor_leistungen, inventar, inventar_ausleihen,
--   trainingseinheiten, videoanalysen, mitgliedsausweise
-- ============================================================
