-- Fix: inventory_loans Tabelle korrigieren
-- Falls die Tabelle noch "inventar_id" hat statt "inventory_id"

alter table inventory_loans rename column inventar_id to inventory_id;

-- Falls die Spalte gar nicht existiert, neu erstellen:
-- alter table inventory_loans add column if not exists inventory_id uuid references inventory(id) on delete cascade;

select 'inventory_loans.inventory_id gefixt' as status;
