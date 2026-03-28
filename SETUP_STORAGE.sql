-- ============================================================
-- STACKFLOW — Storage Setup
-- ============================================================
-- Bucket "stackflow" für alle Uploads erstellen
-- (Bilder, PDFs, Videos, Logos)
-- ============================================================

-- Bucket erstellen (falls nicht bereits vorhanden)
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'stackflow',
  'stackflow',
  true,
  524288000,
  array[
    'image/jpeg','image/jpg','image/png','image/webp','image/svg+xml',
    'application/pdf',
    'video/mp4','video/quicktime','video/webm','video/x-msvideo'
  ]
)
on conflict (id) do update set
  public = true,
  file_size_limit = 524288000;

-- ============================================================
-- Storage Policies werden im Supabase Dashboard erstellt:
--
-- Storage → stackflow Bucket → Policies → New Policy
--
-- Policy 1 — Lesen (SELECT):
--   Name: "Public read"
--   Allowed operations: SELECT
--   Target roles: (leer lassen = alle)
--   Policy: true
--
-- Policy 2 — Hochladen (INSERT):
--   Name: "Public upload"  
--   Allowed operations: INSERT
--   Target roles: (leer lassen = alle)
--   Policy: true
--
-- Policy 3 — Löschen (DELETE):
--   Name: "Public delete"
--   Allowed operations: DELETE
--   Target roles: (leer lassen = alle)
--   Policy: true
--
-- ODER: Einfach "Give users access to only their own top level folder"
--       auswählen und dann auf "All" setzen.
-- ============================================================

select 'Bucket "stackflow" erstellt' as status;
