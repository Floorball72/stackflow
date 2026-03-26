// config.js — Multi-Verein Konfiguration
// ============================================================
// Der SUPABASE_ANON_KEY ist der öffentliche Schlüssel —
// für Frontend-Einsatz vorgesehen. Niemals service_role Keys hier!
// ============================================================

const APP_CONFIG = {
  SUPABASE_URL:      'https://kpskzbqrfvihxfynwvpv.supabase.co',
  SUPABASE_ANON_KEY: 'sb_publishable_eyDYEuo2aQKLLWX_0c8n-g_AttYd0La',
  APP_URL:           'https://vipers-app.vercel.app',
  SWISS_UH_API_KEY:  '',  // nach API-Key-Erhalt eintragen

  // ── Vereine ──────────────────────────────────────────────
  // Hier neue Vereine hinzufügen. club_id ist der DB-Schlüssel.
  CLUBS: [
    {
      club_id:      'uhc-jonschwil',
      name:         'UHC Jonschwil Vipers',
      short:        'Vipers',
      swiss_uh_id:  692,
      primaryColor: '#d4f04a',
      gcal_id:      '5320809ae59397fe852db643253723db16d2292d8b38179e85d35af082623f8e@group.calendar.google.com',
    },
    {
      club_id:      'united-toggenburg',
      name:         'United Toggenburg',
      short:        'United TG',
      swiss_uh_id:  771,
      primaryColor: '#5bbfff',
      gcal_id:      '',  // Google Calendar ID nach Erstellung eintragen
    },
  ],

  // Aktiver Verein: aus localStorage lesen oder erster Verein
  get ACTIVE_CLUB() {
    const stored = localStorage.getItem('vipers_active_club');
    return this.CLUBS.find(c => c.club_id === stored) || this.CLUBS[0];
  },
};
