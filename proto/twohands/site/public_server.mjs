// PUBLIC SERVER (S567, owner: "make it public with render so he doesnt need tailscale"). One Node process, no package to
// install, for a public host (Render web service): a tester signs in with the PERSONAL CODE the owner gave him, agrees to
// the confidentiality notice once, and then gets the game and the match server (site/match_server.mjs, /api/*) at the
// same address. Nothing of the game - not a page, not a picture - is served before the code and the notice.
//   node site/public_server.mjs      env: PORT (10000 on Render), GATE_SECRET (signs the cookie; REQUIRED on a public host),
//                                         GAME_ROOT (the pages folder: default the folder above site/), GATE_DATA (lists; default site/data)
// Testers are site/testers.json: [{ "label": "brother", "hash": "<sha256 of salt + code>", "owner": false }], made by
// tools/make_site.py (the codes themselves are never in a repo). The owner's code opens /owner/log.
// A free Render disk is wiped at every deploy and restart: each sign-in, agreement and page opened is ALSO printed as one
// JSON line (Render's log keeps it), and the agreement is carried in the signed cookie so nobody is asked twice.
import http from 'node:http';
import fs from 'node:fs';
import path from 'node:path';
import crypto from 'node:crypto';
import { matchHandle } from './match_server.mjs';

const here = path.dirname(new URL(import.meta.url).pathname.replace(/^\/([A-Za-z]:)/, '$1'));
const PORT = Number(process.env.PORT || 8790), ROOT = path.resolve(process.env.GAME_ROOT || path.join(here, '..')), DATA = path.resolve(process.env.GATE_DATA || path.join(here, 'data'));
const SECRET = process.env.GATE_SECRET || ''; if (!SECRET && process.env.RENDER) { console.error('GATE_SECRET is not set: refusing to start on a public host'); process.exit(1); }
const KEY = SECRET || crypto.randomBytes(24).toString('hex'), SALT = 'punchers-chance-test';
fs.mkdirSync(DATA, { recursive: true });
const TESTERS = JSON.parse(fs.readFileSync(path.join(here, 'testers.json'), 'utf8'));
const TYPES = { '.html': 'text/html; charset=utf-8', '.js': 'text/javascript; charset=utf-8', '.json': 'application/json', '.webp': 'image/webp', '.png': 'image/png', '.ogg': 'audio/ogg', '.css': 'text/css; charset=utf-8', '.txt': 'text/plain; charset=utf-8' };
const HIDDEN = [/^tools\//i, /^site\//i, /(^|\/)\./, /^(switch|index|body)\.html$/i, /\.import$/i, /^(render\.yaml|package\.json|README\.md)$/i];
const esc = (s) => String(s).replace(/[&<>"]/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c])), now = () => new Date().toISOString();
const sha = (s) => crypto.createHash('sha256').update(s).digest('hex'), sign = (s) => crypto.createHmac('sha256', KEY).update(s).digest('hex').slice(0, 32);
const notice = () => { const text = fs.readFileSync(path.join(here, 'notice.txt'), 'utf8').replace(/\r\n/g, '\n').trim(); return { text, version: (text.match(/version\s+(\d+)/i) || [0, '1'])[1], hash: sha(text).slice(0, 16) }; };
const gameVersion = () => { try { return (fs.readFileSync(path.join(ROOT, 'version.js'), 'utf8').match(/v:\s*'([^']+)'/) || [0, '?'])[1]; } catch (e) { return '?'; } };
const rows = (file) => { try { return fs.readFileSync(path.join(DATA, file), 'utf8').split('\n').filter(Boolean).map((l) => JSON.parse(l)); } catch (e) { return []; } };
const add = (file, row) => { console.log('GATE ' + file.replace('.jsonl', '') + ' ' + JSON.stringify(row)); try { fs.appendFileSync(path.join(DATA, file), JSON.stringify(row) + '\n'); } catch (e) { /* the log line above is the record */ } };
// the cookie: label | email | agreed notice hash | expiry | signature
const mint = (o) => { const body = Buffer.from(JSON.stringify(o)).toString('base64url'); return body + '.' + sign(body); };
const read = (req) => { const m = /(?:^|;\s*)pc=([^;]+)/.exec(req.headers.cookie || ''); if (!m) return null; const [body, sig] = m[1].split('.'); if (!body || sig !== sign(body)) return null; try { const o = JSON.parse(Buffer.from(body, 'base64url').toString('utf8')); return o.exp > Date.now() && TESTERS.some((t) => t.label === o.label) ? o : null; } catch (e) { return null; } };
const cookie = (o) => `pc=${mint(o)}; Path=/; HttpOnly; SameSite=Lax; Max-Age=${30 * 86400}${process.env.RENDER ? '; Secure' : ''}`;
const SHELL = (title, body) => `<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="robots" content="noindex,nofollow"><title>${esc(title)}</title><style>
:root{--bg:#171210;--fg:#f3ece1;--muted:#9a9184;--gold:#e3ab45;--line:#3a3029}html,body{margin:0}body{background:var(--bg);color:var(--fg);font:1.05rem/1.5 "Segoe UI",system-ui,sans-serif}
main{max-width:46rem;margin:0 auto;padding:2rem 1.2rem 3rem}h1{font-size:1.4rem;letter-spacing:.12em;text-transform:uppercase;color:var(--gold);margin:0 0 1rem}
pre{white-space:pre-wrap;font:inherit;border:1px solid var(--line);border-radius:.6rem;padding:1rem 1.2rem;background:#1f1814}p.m{color:var(--muted);font-size:.92rem}p.bad{color:#ff9d95}
label{display:block;margin:.8rem 0 .2rem;color:var(--muted);font-size:.9rem}input{font:inherit;width:100%;box-sizing:border-box;padding:.55rem .7rem;border-radius:.5rem;border:1px solid var(--line);background:#1f1814;color:var(--fg)}
button{font:inherit;font-weight:700;margin-top:1.1rem;padding:.7rem 1.6rem;border-radius:.6rem;border:0;background:var(--gold);color:#1a1410;cursor:pointer}
table{border-collapse:collapse;width:100%;font-size:.92rem;margin:.4rem 0 1.6rem}td,th{border-bottom:1px solid var(--line);padding:.3rem .5rem;text-align:left}th{color:var(--muted);font-weight:400}a{color:var(--gold)}
</style></head><body><main>${body}</main></body></html>`;
function send(res, code, type, body, extra) { res.writeHead(code, { 'Content-Type': type, 'Cache-Control': 'no-store', 'X-Robots-Tag': 'noindex, nofollow', ...(extra || {}) }); res.end(body); }
const page = (res, code, title, body, extra) => send(res, code, 'text/html; charset=utf-8', SHELL(title, body), extra);
const form = (req) => new Promise((ok) => { let s = ''; req.on('data', (c) => { s += c; if (s.length > 4000) req.destroy(); }); req.on('end', () => ok(new URLSearchParams(s))); });
const signIn = (res, msg) => page(res, msg ? 401 : 200, "Puncher's chance - sign in", `<h1>Puncher's chance</h1><p>This test is open by invitation. Type the code you were given.</p>${msg ? `<p class="bad">${esc(msg)}</p>` : ''}
<form method="post" action="/_signin"><label>Your email</label><input name="email" type="email" required maxlength="120" autocomplete="email"><label>Your code</label><input name="code" required maxlength="40" autocomplete="off"><button>Sign in</button></form>
<p class="m">Kept when you sign in and when you play: the email you type, which code was used, the time, which pages you open and which version of the game. Nothing else.</p>`);
const tries = new Map();   // a wrong code slows that address down: 5 a minute
function ownerLog(res, url) { const A = rows('agreed.jsonl').reverse(), V = rows('visits.jsonl').reverse(), S = rows('signins.jsonl').reverse();
  if (url.searchParams.get('csv')) { const which = url.searchParams.get('csv') === 'agreed' ? A : url.searchParams.get('csv') === 'signins' ? S : V, keys = which[0] ? Object.keys(which[0]) : [];
    return send(res, 200, 'text/csv; charset=utf-8', [keys.join(','), ...which.map((r) => keys.map((k) => '"' + String(r[k] ?? '').replace(/"/g, '""') + '"').join(','))].join('\n')); }
  const t = (head, list) => `<table><tr>${head.map((h) => `<th>${h}</th>`).join('')}</tr>${list.join('') || `<tr><td colspan="${head.length}">nothing yet</td></tr>`}</table>`;
  page(res, 200, "Puncher's chance - who played", `<h1>Puncher's chance - who played</h1>
<p class="m">The game is on version ${esc(gameVersion())}. Times are UTC. This list starts again whenever the host restarts the service; the host's own log keeps every line. <a href="?csv=visits">visits.csv</a> - <a href="?csv=agreed">agreed.csv</a> - <a href="?csv=signins">signins.csv</a></p>
<h2>Signed in</h2>${t(['When', 'Code', 'Email typed'], S.slice(0, 100).map((r) => `<tr><td>${esc(r.time)}</td><td>${esc(r.label)}</td><td>${esc(r.email)}</td></tr>`))}
<h2>Agreed to the notice</h2>${t(['When', 'Code', 'Email typed', 'Notice version'], A.map((r) => `<tr><td>${esc(r.time)}</td><td>${esc(r.label)}</td><td>${esc(r.email)}</td><td>${esc(r.version)}</td></tr>`))}
<h2>Every page opened (newest 300)</h2>${t(['When', 'Code', 'Page', 'Version'], V.slice(0, 300).map((v) => `<tr><td>${esc(v.time)}</td><td>${esc(v.label)}</td><td>${esc(v.page)}</td><td>${esc(v.version)}</td></tr>`))}`); }

http.createServer(async (req, res) => { try {
  const url = new URL(req.url, 'http://x'); let rel; try { rel = decodeURIComponent(url.pathname).replace(/^\/+/, ''); } catch (e) { return send(res, 400, 'text/plain', 'bad address'); }
  if (rel === 'healthz') return send(res, 200, 'text/plain', 'ok');
  const n = notice(), ip = String(req.headers['x-forwarded-for'] || req.socket.remoteAddress || '').split(',')[0].trim();
  if (rel === '_signin' && req.method === 'POST') { const t = tries.get(ip) || { n: 0, at: Date.now() }; if (Date.now() - t.at > 60000) { t.n = 0; t.at = Date.now(); } t.n++; tries.set(ip, t); if (t.n > 5) return signIn(res, 'Too many tries. Wait a minute.');
    const f = await form(req), email = String(f.get('email') || '').trim().toLowerCase().slice(0, 120), code = String(f.get('code') || '').trim().toUpperCase().replace(/[^A-Z0-9]/g, ''), who = TESTERS.find((x) => x.hash === sha(SALT + code));
    if (!who || !/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(email)) return signIn(res, 'That code or email is not right.');
    add('signins.jsonl', { time: now(), label: who.label, email }); return send(res, 303, 'text/plain', 'ok', { Location: '/online.html', 'Set-Cookie': cookie({ label: who.label, email, agreed: '', exp: Date.now() + 30 * 86400000 }) }); }
  const me = read(req);
  if (!me) return rel.startsWith('api/') ? send(res, 401, 'application/json', JSON.stringify({ error: 'sign in first: open the game page' })) : signIn(res, '');
  if (rel === '_agree' && req.method === 'POST') { const f = await form(req); if (f.get('hash') !== n.hash) return send(res, 303, 'text/plain', 'ok', { Location: '/online.html' });
    add('agreed.jsonl', { time: now(), label: me.label, email: me.email, version: n.version, hash: n.hash }); return send(res, 303, 'text/plain', 'ok', { Location: '/online.html', 'Set-Cookie': cookie({ ...me, agreed: n.hash }) }); }
  if (rel === '_signout') return send(res, 303, 'text/plain', 'ok', { Location: '/', 'Set-Cookie': 'pc=; Path=/; Max-Age=0' });
  const okd = me.agreed === n.hash;
  if (rel.startsWith('api/')) return okd ? matchHandle(req, res) : send(res, 403, 'application/json', JSON.stringify({ error: 'agree to the notice first: open the game page' }));
  if (rel === 'owner/log') return (TESTERS.find((t) => t.label === me.label) || {}).owner ? ownerLog(res, url) : page(res, 403, "Puncher's chance", '<h1>Not yours</h1><p>This page is for the owner.</p>');
  if (rel === '') return send(res, 302, 'text/plain', 'ok', { Location: '/online.html' });
  const file = path.resolve(ROOT, rel), ext = path.extname(file).toLowerCase(), inside = file.startsWith(ROOT + path.sep);
  if (!inside || !TYPES[ext] || HIDDEN.some((h) => h.test(rel.replace(/\\/g, '/'))) || !fs.existsSync(file) || !fs.statSync(file).isFile()) return page(res, 404, "Puncher's chance", '<h1>Not here</h1><p><a href="/online.html">To the ring</a></p>');
  if (!okd) { if (ext !== '.html') return send(res, 403, 'text/plain', 'agree to the notice first');
    return page(res, 200, "Puncher's chance - before you play", `<h1>Puncher's chance - before you play</h1><p>You are signed in as <b>${esc(me.email)}</b>.</p><pre>${esc(n.text)}</pre>
<form method="post" action="/_agree"><input type="hidden" name="hash" value="${n.hash}"><button>I agree</button></form>`); }
  if (ext === '.html') add('visits.jsonl', { time: now(), label: me.label, email: me.email, page: rel, version: gameVersion() });
  send(res, 200, TYPES[ext], fs.readFileSync(file), ext === '.webp' || ext === '.png' || ext === '.ogg' ? { 'Cache-Control': 'private, max-age=3600' } : null);
} catch (e) { console.error(now(), 'ERROR', e && e.stack || e); try { send(res, 500, 'text/plain', 'error'); } catch (e2) { /* the socket is gone */ } } })
  .listen(PORT, process.env.RENDER ? '0.0.0.0' : '127.0.0.1', () => console.log(`PUBLIC SERVER up on ${PORT} - pages ${ROOT} - ${TESTERS.length} testers - notice v${notice().version} - game v${gameVersion()}${SECRET ? '' : ' - NO GATE_SECRET: cookies end at restart'}`));
