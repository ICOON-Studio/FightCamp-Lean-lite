// PUNCHER'S CHANCE - THE TEST-LINK GATE (S565, TASK_TESTLINK1). Owner: "how can i get my brother a link to test the game ?",
// "make it public but ask for email (maybe nda proof ) when someone sign ins and you keep a log of who uses the link ?",
// "or can you do it via tailscale ?" -> "Tailscale".
// One small server in front of the game's pages. It never serves a file to someone it cannot name.
//   WHO IS ASKING: Tailscale tells us (`tailscale serve` adds Tailscale-User-Login to every request it forwards).
//   THE NOTICE:    the first time (and again when notice.txt changes) a tester sees the confidentiality notice and
//                  clicks "I agree"; the click is kept: who, when, which notice, a hash of its exact words.
//   THE LOG:       every page a tester opens is kept: who, when, which page, which game version.
//   THE OWNER:     /owner/log shows both lists (only for the owner's login).
// No package to install: Node's own modules. It listens on this PC only (127.0.0.1); Tailscale is the way in.
//   node proto/twohands/site/server.js        env: PORT (8798), GAME_ROOT (the pages folder), GATE_DATA (where the
//   two lists are kept - NOT in git), OWNER_LOGIN (the owner's Tailscale login)
'use strict';
const http = require('node:http'), fs = require('node:fs'), path = require('node:path'), crypto = require('node:crypto');

const PORT = Number(process.env.PORT || 8798);
const ROOT = path.resolve(process.env.GAME_ROOT || path.join(__dirname, '..'));
const DATA = path.resolve(process.env.GATE_DATA || path.join(__dirname, 'data'));
const OWNER = String(process.env.OWNER_LOGIN || '').trim().toLowerCase();
const NOTICE_FILE = path.join(__dirname, 'notice.txt');
fs.mkdirSync(DATA, { recursive: true });

const TYPES = { '.html': 'text/html; charset=utf-8', '.js': 'text/javascript; charset=utf-8', '.json': 'application/json', '.css': 'text/css', '.webp': 'image/webp', '.png': 'image/png', '.jpg': 'image/jpeg', '.jpeg': 'image/jpeg', '.svg': 'image/svg+xml', '.ico': 'image/x-icon', '.mp3': 'audio/mpeg', '.ogg': 'audio/ogg', '.wav': 'audio/wav', '.woff2': 'font/woff2' };
const HIDDEN = [/^tools\//i, /^site\//i, /(^|\/)\./, /^(switch|index)\.html$/i];   // our tools, this gate, dot files, the two retired pages
const esc = (s) => String(s).replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
const now = () => new Date().toISOString();
const add = (file, row) => fs.appendFileSync(path.join(DATA, file), JSON.stringify(row) + '\n');
const rows = (file) => { try { return fs.readFileSync(path.join(DATA, file), 'utf8').split('\n').filter(Boolean).map((l) => JSON.parse(l)); } catch (e) { return []; } };

function notice() { const text = fs.readFileSync(NOTICE_FILE, 'utf8').replace(/\r\n/g, '\n').trim();
  return { text, version: (text.match(/^Notice version:\s*(\S+)/m) || [0, '1'])[1], hash: crypto.createHash('sha256').update(text).digest('hex').slice(0, 16) }; }
function gameVersion() { try { return (fs.readFileSync(path.join(ROOT, 'version.js'), 'utf8').match(/v:\s*'([^']+)'/) || [0, '?'])[1]; } catch (e) { return '?'; } }
const agreed = (login, n) => (OWNER && login === OWNER) || rows('agreed.jsonl').some((r) => r.login === login && r.hash === n.hash);   /* the owner does not sign his own notice */

const SHELL = (title, body) => `<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>${esc(title)}</title><style>
:root{--bg:#171210;--fg:#f3ece1;--muted:#9a9184;--gold:#e3ab45;--line:#3a3029}html,body{margin:0}body{background:var(--bg);color:var(--fg);font:1.05rem/1.5 "Segoe UI",system-ui,sans-serif}
main{max-width:46rem;margin:0 auto;padding:2rem 1.2rem 3rem}h1{font-size:1.4rem;letter-spacing:.12em;text-transform:uppercase;color:var(--gold);margin:0 0 1rem}
pre{white-space:pre-wrap;font:inherit;border:1px solid var(--line);border-radius:.6rem;padding:1rem 1.2rem;background:#1f1814}p.m{color:var(--muted);font-size:.92rem}
button{font:inherit;font-weight:700;padding:.7rem 1.6rem;border-radius:.6rem;border:0;background:var(--gold);color:#1a1410;cursor:pointer}
table{border-collapse:collapse;width:100%;font-size:.92rem;margin:.4rem 0 1.6rem}td,th{border-bottom:1px solid var(--line);padding:.3rem .5rem;text-align:left}th{color:var(--muted);font-weight:400}a{color:var(--gold)}
</style></head><body><main>${body}</main></body></html>`;
function send(res, code, type, body, extra) { res.writeHead(code, { 'Content-Type': type, 'Cache-Control': 'no-store', 'X-Robots-Tag': 'noindex, nofollow', ...(extra || {}) }); res.end(body); }
const page = (res, code, title, body) => send(res, code, 'text/html; charset=utf-8', SHELL(title, body));

function ownerLog(res, url) { const A = rows('agreed.jsonl').reverse(), V = rows('visits.jsonl').reverse();
  if (url.searchParams.get('csv')) { const which = url.searchParams.get('csv') === 'agreed' ? A : V, keys = which[0] ? Object.keys(which[0]) : [];
    return send(res, 200, 'text/csv; charset=utf-8', [keys.join(','), ...which.map((r) => keys.map((k) => '"' + String(r[k] ?? '').replace(/"/g, '""') + '"').join(','))].join('\n')); }
  const last = {}; for (const v of V) if (!last[v.login]) last[v.login] = v;
  const t = (head, list) => `<table><tr>${head.map((h) => `<th>${h}</th>`).join('')}</tr>${list.join('') || `<tr><td colspan="${head.length}">nothing yet</td></tr>`}</table>`;
  page(res, 200, "Puncher's chance - who played", `<h1>Puncher's chance - who played</h1>
<p class="m">The game is on version ${esc(gameVersion())}. Times are UTC. <a href="?csv=visits">visits.csv</a> - <a href="?csv=agreed">agreed.csv</a></p>
<h2>Testers</h2>${t(['Who', 'Last seen', 'Last page', 'Version then', 'Pages opened'], Object.values(last).map((v) => `<tr><td>${esc(v.login)}</td><td>${esc(v.time)}</td><td>${esc(v.page)}</td><td>${esc(v.version)}</td><td>${V.filter((x) => x.login === v.login).length}</td></tr>`))}
<h2>Agreed to the notice</h2>${t(['Who', 'Name', 'When', 'Notice version', 'Words (hash)'], A.map((r) => `<tr><td>${esc(r.login)}</td><td>${esc(r.name || '')}</td><td>${esc(r.time)}</td><td>${esc(r.version)}</td><td>${esc(r.hash)}</td></tr>`))}
<h2>Every page opened (newest 300)</h2>${t(['When', 'Who', 'Page', 'Version'], V.slice(0, 300).map((v) => `<tr><td>${esc(v.time)}</td><td>${esc(v.login)}</td><td>${esc(v.page)}</td><td>${esc(v.version)}</td></tr>`))}`); }

const server = http.createServer((req, res) => { try {
  const url = new URL(req.url, 'http://x'), login = String(req.headers['tailscale-user-login'] || '').trim().toLowerCase(), name = String(req.headers['tailscale-user-name'] || '');
  if (!login) return page(res, 403, "Puncher's chance", `<h1>Puncher's chance</h1><p>This test is open by invitation. Open it through the Tailscale address you were sent, signed in to Tailscale.</p>`);
  let rel; try { rel = decodeURIComponent(url.pathname).replace(/^\/+/, ''); } catch (e) { return send(res, 400, 'text/plain', 'bad address'); }
  const n = notice();
  if (rel === '_agree' && req.method === 'POST') { let body = ''; req.on('data', (c) => { body += c; if (body.length > 2000) req.destroy(); });
    return req.on('end', () => { const f = new URLSearchParams(body);
      if (f.get('hash') === n.hash && !agreed(login, n)) add('agreed.jsonl', { time: now(), login, name, version: n.version, hash: n.hash });
      send(res, 303, 'text/plain', 'ok', { Location: '/order.html' }); }); }
  if (rel === 'owner/log') return OWNER && login === OWNER ? ownerLog(res, url) : page(res, 403, "Puncher's chance", '<h1>Not yours</h1><p>This page is for the owner.</p>');
  if (rel === '') return send(res, 302, 'text/plain', 'ok', { Location: '/order.html' });
  /* S567 (owner: "Yes, open it"): the match server (match_server.mjs, this PC only) is reached THROUGH the gate, at the same address - a signed-in tester who agreed to the notice may call /api/*; nobody else can, and no second port is opened */
  if (rel.startsWith('api/')) { if (!agreed(login, n)) return send(res, 403, 'application/json', JSON.stringify({ error: 'agree to the notice first: open the game page' }));
    const up = http.request({ host: '127.0.0.1', port: Number(process.env.MATCH_PORT || 8796), path: url.pathname + url.search, method: req.method, headers: { 'content-type': req.headers['content-type'] || 'application/json' } }, (r) => { res.writeHead(r.statusCode || 502, { 'Content-Type': r.headers['content-type'] || 'application/json', 'Cache-Control': 'no-store', 'X-Robots-Tag': 'noindex, nofollow' }); r.pipe(res); });
    up.on('error', () => send(res, 502, 'application/json', JSON.stringify({ error: 'the match server is not running' }))); return req.pipe(up); }
  const file = path.resolve(ROOT, rel), ext = path.extname(file).toLowerCase(), inside = file.startsWith(ROOT + path.sep);
  if (!inside || !TYPES[ext] || HIDDEN.some((h) => h.test(rel.replace(/\\/g, '/'))) || !fs.existsSync(file) || !fs.statSync(file).isFile()) return page(res, 404, "Puncher's chance", '<h1>Not here</h1><p><a href="/order.html">To the ring</a></p>');
  if (!agreed(login, n)) {   // nothing of the game - not a page, not a picture - before the notice is agreed
    if (ext !== '.html') return send(res, 403, 'text/plain', 'agree to the notice first');
    return page(res, 200, "Puncher's chance - before you play", `<h1>Puncher's chance - before you play</h1><p>You are signed in as <b>${esc(login)}</b>.</p><pre>${esc(n.text)}</pre>
<form method="post" action="/_agree"><input type="hidden" name="hash" value="${n.hash}"><button>I agree</button></form>
<p class="m">Kept when you agree and when you play: your Tailscale login, the time, which pages you open and which version of the game. Nothing else.</p>`); }
  if (ext === '.html') add('visits.jsonl', { time: now(), login, page: rel, version: gameVersion() });
  send(res, 200, TYPES[ext], fs.readFileSync(file), ext === '.webp' || ext === '.png' ? { 'Cache-Control': 'private, max-age=600' } : null);
} catch (e) { console.error(now(), 'ERROR', e && e.stack || e); try { send(res, 500, 'text/plain', 'error'); } catch (e2) {} } });

server.listen(PORT, '127.0.0.1', () => console.log(`GATE up on 127.0.0.1:${PORT} - pages ${ROOT} - lists ${DATA} - owner ${OWNER ? 'set' : 'NOT SET (no /owner/log)'} - notice v${notice().version} - game v${gameVersion()}`));
