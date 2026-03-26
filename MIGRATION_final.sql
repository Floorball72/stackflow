-- Migration: spielkategorie zu games, manuelle Scorer-Einträge
alter table games add column if not exists spielkategorie text default 'saison'
  check (spielkategorie in ('saison','cup','friendly'));
