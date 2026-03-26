// nav.js — UHC Jonschwil Vipers Navigation
// Eingebunden von allen Seiten via <script src="nav.js"></script>

const NAV_ITEMS = [
  { section: 'Übersicht' },
  { label: 'Dashboard',        href: 'dashboard.html',    icon: '<rect x="2" y="2" width="5" height="5" rx="1" stroke="currentColor" stroke-width="1.3"/><rect x="9" y="2" width="5" height="5" rx="1" stroke="currentColor" stroke-width="1.3"/><rect x="2" y="9" width="5" height="5" rx="1" stroke="currentColor" stroke-width="1.3"/><rect x="9" y="9" width="5" height="5" rx="1" stroke="currentColor" stroke-width="1.3"/>', id: 'dashboard' },
  { label: 'Kalender',         href: 'kalender.html',     icon: '<rect x="2" y="3" width="12" height="11" rx="1.5" stroke="currentColor" stroke-width="1.3"/><line x1="5" y1="1.5" x2="5" y2="4.5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/><line x1="11" y1="1.5" x2="11" y2="4.5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/><line x1="2" y1="7" x2="14" y2="7" stroke="currentColor" stroke-width="1.3"/>', id: 'kalender' },
  { label: 'Newsfeed',         href: 'news.html',         icon: '<path d="M2 3h12v2H2zM2 7h9v2H2zM2 11h6v2H2z" fill="currentColor" opacity=".8"/>', id: 'news' },

  { section: 'Spielbetrieb' },
  { label: 'Social Media',     href: 'index.html',        icon: '<path d="M2 12L5 7L8 10L11 5L14 9" stroke="currentColor" stroke-width="1.3" stroke-linecap="round" stroke-linejoin="round"/>', id: 'social' },
  { label: 'Spielplan',        href: 'spielplan.html',    icon: '<circle cx="8" cy="8" r="5.5" stroke="currentColor" stroke-width="1.3"/><path d="M8 5.5V8L10 9.5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/>', id: 'spielplan' },
  { label: 'Scorer',           href: 'scorer.html',       icon: '<path d="M4 12V6M8 12V4M12 12V8" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/>', id: 'scorer' },
  { label: 'Kameraplanung',    href: 'kamera.html',       icon: '<rect x="1" y="5" width="10" height="8" rx="1" stroke="currentColor" stroke-width="1.3"/><path d="M11 7.5l4-2v7l-4-2" stroke="currentColor" stroke-width="1.3" stroke-linecap="round" stroke-linejoin="round"/>', id: 'kamera' },

  { section: 'Team & Training' },
  { label: 'Training & Video', href: 'training.html',     icon: '<rect x="2" y="3" width="12" height="9" rx="1" stroke="currentColor" stroke-width="1.3"/><path d="M7 6.5L10.5 8.5L7 10.5V6.5Z" fill="currentColor"/>', id: 'training' },
  { label: 'Anwesenheit',      href: 'anwesenheit.html',  icon: '<rect x="2" y="2" width="12" height="12" rx="1.5" stroke="currentColor" stroke-width="1.3"/><path d="M5 8l2 2 4-3" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>', id: 'anwesenheit' },
  { label: 'Events',           href: 'events.html',       icon: '<rect x="2" y="2" width="12" height="12" rx="1.5" stroke="currentColor" stroke-width="1.3"/><path d="M5 8H11M5 5.5H11M5 10.5H8.5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/>', id: 'events' },

  { section: 'Finanzen & Verein' },
  { label: 'Finanzen',         href: 'finanzen.html',     icon: '<path d="M2 12V4l6-2 6 2v8l-6 2-6-2Z" stroke="currentColor" stroke-width="1.3"/><path d="M8 6v4M6 8h4" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/>', id: 'finanzen' },
  { label: 'Sponsoring',       href: 'sponsoring.html',   icon: '<path d="M8 2l1.5 3 3.5.5-2.5 2.5.5 3.5L8 10l-3 1.5.5-3.5L3 5.5l3.5-.5L8 2Z" stroke="currentColor" stroke-width="1.3" stroke-linejoin="round"/>', id: 'sponsoring' },
  { label: 'Inventar',         href: 'inventar.html',     icon: '<rect x="2" y="3" width="12" height="11" rx="1" stroke="currentColor" stroke-width="1.3"/><path d="M5 7h6M5 10h4" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/>', id: 'inventar' },

  { section: 'Mitglieder' },
  { label: 'Mitglieder & Rollen', href: 'mitglieder.html', icon: '<circle cx="6" cy="5" r="2.5" stroke="currentColor" stroke-width="1.3"/><circle cx="11" cy="5" r="2" stroke="currentColor" stroke-width="1.3"/><path d="M1.5 13c0-2.2 2-4 4.5-4s4.5 1.8 4.5 4" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/><path d="M11 9c1.8.3 3 1.6 3 3.5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/>', id: 'mitglieder' },
];

function renderNav(activeId) {
  const currentPage = window.location.pathname.split('/').pop() || 'dashboard.html';

  // Aktuellen User aus localStorage lesen (wird nach Login gesetzt)
  const user = JSON.parse(localStorage.getItem('vipers_user') || 'null');
  const rolle = user?.rolle || 'admin';

  // Seiten die nur Admins sehen
  const adminOnly = ['finanzen', 'sponsoring', 'mitglieder', 'inventar'];
  // Seiten die Trainer + Admin sehen
  const trainerPlus = ['kamera', 'anwesenheit', 'training'];
  // Eltern sehen nur wenige Seiten
  const elternOnly = ['dashboard', 'kalender', 'news', 'spielplan', 'events'];

  let html = `
  <aside class="sidebar">
    <div class="logo">
      <div class="logo-mark">
        <svg width="18" height="18" viewBox="0 0 18 18" fill="none">
          <path d="M9 2L16 6V12L9 16L2 12V6L9 2Z" fill="#0c0d0f"/>
          <path d="M6 9L8.5 11.5L12.5 7" stroke="#0c0d0f" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      </div>
      <div>
        <div class="logo-name">UHC Jonschwil</div>
        <div class="logo-sub">VIPERS</div>
      </div>
    </div>
    <nav class="nav">`;

  NAV_ITEMS.forEach(item => {
    if (item.section) {
      // Sektions-Header nur zeigen wenn relevante Items folgen
      html += `<div class="nav-sec">${item.section}</div>`;
      return;
    }

    // Rechte-Check
    if (rolle === 'eltern' && !elternOnly.includes(item.id)) return;
    if (rolle === 'spieler' && adminOnly.includes(item.id)) return;
    if (rolle === 'spieler' && trainerPlus.includes(item.id)) return;
    if (rolle === 'trainer' && adminOnly.includes(item.id)) return;

    const isActive = activeId ? item.id === activeId : currentPage === item.href;
    html += `
      <a class="nav-item${isActive ? ' active' : ''}" href="${item.href}">
        <svg viewBox="0 0 16 16" fill="none">${item.icon}</svg>
        ${item.label}
      </a>`;
  });

  // User-Footer
  const roleColors = {admin:'var(--accent)',trainer:'var(--purple)',spieler:'var(--blue)',eltern:'var(--green)'};
  const roleLabels = {admin:'Admin',trainer:'Trainer',spieler:'Spieler',eltern:'Eltern'};

  html += `</nav>
    <div style="padding:0 8px 12px">
      ${user ? `
      <div style="background:var(--bg3);border-radius:8px;border:1px solid var(--border);padding:10px 12px;margin-bottom:8px">
        <div style="display:flex;align-items:center;gap:8px">
          <div style="width:28px;height:28px;border-radius:50%;background:${roleColors[rolle]}22;display:flex;align-items:center;justify-content:center;font-size:11px;font-weight:700;color:${roleColors[rolle]};flex-shrink:0">${(user.vorname||'?')[0]}${(user.nachname||'?')[0]}</div>
          <div style="flex:1;min-width:0">
            <div style="font-size:12px;font-weight:500;color:var(--text);white-space:nowrap;overflow:hidden;text-overflow:ellipsis">${user.vorname} ${user.nachname}</div>
            <div style="font-size:10px;color:${roleColors[rolle]};font-weight:600;text-transform:uppercase;letter-spacing:.06em">${roleLabels[rolle]}</div>
          </div>
        </div>
        <button onclick="logout()" style="width:100%;margin-top:8px;background:transparent;border:1px solid var(--border2);border-radius:6px;padding:5px;font-size:11px;color:var(--text3);cursor:pointer;font-family:'DM Sans',sans-serif;transition:all .12s" onmouseover="this.style.color='var(--text)'" onmouseout="this.style.color='var(--text3)'">Abmelden</button>
      </div>` : `
      <a href="login.html" style="display:block;text-align:center;background:rgba(212,240,74,.1);border:1px solid rgba(212,240,74,.3);border-radius:8px;padding:9px;font-size:12px;color:var(--accent);font-weight:500;text-decoration:none;transition:all .12s">Anmelden</a>`}
      <div style="background:var(--bg3);border-radius:8px;border:1px solid var(--border);padding:8px 12px">
        <div style="display:flex;align-items:center;margin-bottom:4px">
          <span style="width:6px;height:6px;border-radius:50%;background:var(--green);margin-right:6px;box-shadow:0 0 6px var(--green)"></span>
          <span style="font-size:11px;color:var(--text2)">Google Calendar</span>
        </div>
        <div style="display:flex;align-items:center;margin-bottom:4px">
          <span style="width:6px;height:6px;border-radius:50%;background:var(--green);margin-right:6px;box-shadow:0 0 6px var(--green)"></span>
          <span style="font-size:11px;color:var(--text2)">Supabase DB</span>
        </div>
        <div style="display:flex;align-items:center">
          <span style="width:6px;height:6px;border-radius:50%;background:var(--amber);margin-right:6px"></span>
          <span style="font-size:11px;color:var(--text2)">Swiss UH API <span style="color:var(--amber);font-size:10px">(ausstehend)</span></span>
        </div>
      </div>
    </div>
  </aside>`;

  document.getElementById('nav-placeholder').outerHTML = html;

  // Redirect zu Login wenn nicht eingeloggt (ausser Login-Seite)
  if (!user && !window.location.pathname.includes('login.html')) {
    // Soft redirect – nur warnen, nicht hard redirect (für Dev-Modus)
    console.info('Nicht eingeloggt – in Produktion: redirect zu login.html');
  }
}

function logout() {
  localStorage.removeItem('vipers_user');
  window.location.href = 'login.html';
}
