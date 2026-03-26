// config.js — UHC Jonschwil Vipers
// ============================================================
// EINZIGE STELLE für Konfiguration. Alle anderen Files lesen
// nur von hier. Nie Passwörter oder private Keys hier eintragen!
//
// Der SUPABASE_KEY ist der öffentliche "anon key" von Supabase —
// er ist für den Frontend-Einsatz vorgesehen und darf hier stehen.
// Private Keys (service_role) gehören NIEMALS in Frontend-Code.
// ============================================================

const APP_CONFIG = {
  SUPABASE_URL: 'https://kpskzbqrfvihxfynwvpv.supabase.co',
  SUPABASE_ANON_KEY: 'sb_publishable_eyDYEuo2aQKLLWX_0c8n-g_AttYd0La',

  // Swiss Unihockey API (nach Erhalt des Keys hier eintragen)
  SWISS_UH_API_KEY: '',
  SWISS_UH_CLUB_ID: 692,

  // Google Calendar ID (Kalender "UHC Jonschwil Vipers")
  GCAL_VIPERS_ID: '5320809ae59397fe852db643253723db16d2292d8b38179e85d35af082623f8e@group.calendar.google.com',

  // App-URL (nach Deployment anpassen)
  APP_URL: 'https://vipers-app.vercel.app',
};
