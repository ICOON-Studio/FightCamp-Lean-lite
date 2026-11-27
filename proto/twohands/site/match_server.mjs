// MATCH SERVER (S567, owner: "can you make like a server so all agents can connect and play and dd the option in the game too ?").
// One small HTTP server: players (agents or people on the game page) join by name, are paired, and fight a bout of
// Puncher's chance on the page's OWN rules (tools/rules.mjs reads order.html). Each beat both seal a plan without seeing the
// other's; when both are in, the beat is played and both read the result. No account, no password: a name and the token it
// gets back. It listens on 127.0.0.1 only (a tunnel such as Tailscale serve decides who else can reach it).
//   node proto/twohands/site/match_server.mjs            env: MATCH_PORT (8796), MATCH_DATA (site/data), BEAT_LIMIT_S (600)
//   GET  /api/help                       the rules and this API, as text
//   POST /api/join   {name}              -> {token, name}
//   POST /api/find   {token[, vs]}       -> {match} when paired, else {waiting: true}   (vs: only that player's name)
//   GET  /api/state?token=..[&match=..]  -> the bout as that player sees it (never the other's sealed beat)
//   POST /api/plan   {token, lead, rear, feet, order | clinch: true}   lead / rear: a punch name or id, or high / low
//   POST /api/leave  {token}             leave the queue or give up the bout
//   GET  /api/lobby                      who waits, the bouts, the table (win 3, draw 1)
import http from 'node:http';
import fs from 'node:fs';
import path from 'node:path';
import crypto from 'node:crypto';
import { load } from '../tools/rules.mjs';

const here = path.dirname(new URL(import.meta.url).pathname.replace(/^\/([A-Za-z]:)/, '$1'));
const PORT = Number(process.env.MATCH_PORT || 8796), DATA = path.resolve(process.env.MATCH_DATA || path.join(here, 'data')), LIMIT = Number(process.env.BEAT_LIMIT_S || 600) * 1000;
fs.mkdirSync(DATA, { recursive: true }); const RESULTS = path.join(DATA, 'matches.jsonl');
const R0 = load(1), { N, ACT, FEET, RNG } = R0;
const players = new Map(), matches = new Map(); let queue = [], nextId = 1;
const results = fs.existsSync(RESULTS) ? fs.readFileSync(RESULTS, 'utf8').split('\n').filter(Boolean).map((l) => JSON.parse(l)) : [];
const norm = (x) => String(x || '').toLowerCase().replace(/[^a-z]/g, '');
const pick = (x, h) => { const n = norm(x); if (!n || n === 'high' || n === 'low') return n || 'high'; const hit = Object.keys(ACT).filter((id) => ACT[id].h === h && [id, ACT[id].n, ACT[id].n.replace(/^(lead|rear) /i, ''), (h ? 'rear' : 'lead') + ACT[id].n].some((w) => norm(w) === n)); return hit.length === 1 ? hit[0] : String(x); };
const words = (h) => Object.keys(ACT).filter((id) => ACT[id].h === h).join(', ') + ', high, low';
function makePlan(R, a) { const m = R.plan0(); if (a.clinch) { m.clinch = true; return m; } const L = pick(a.lead, 0), H = pick(a.rear, 1);
  if (L === 'high' || L === 'low') m.hl = L; else m.lead = L; if (H === 'high' || H === 'low') m.hr = H; else m.rear = H; m.feet = norm(a.feet) || 'hold';
  const acts = [...(m.feet !== 'hold' ? ['feet'] : []), ...(m.lead ? ['lead'] : []), ...(m.rear ? ['rear'] : [])], want = String(a.order || '').split(',').map((x) => x.trim()).filter((x) => acts.includes(x)); m.ord = [...want, ...acts.filter((x) => !want.includes(x))]; return m; }
function refuse(M, k, m, R) { const me = M.F[k];
  return m.clinch ? (M.range > 1 ? 'the clinch works Inside only' : me.held ? 'the referee will not allow a clinch yet' : me.st < 1 ? 'no stamina' : '')
    : (m.lead && (!ACT[m.lead] || ACT[m.lead].h !== 0)) ? `lead=${m.lead} is not a lead-hand move. LEAD: ${words(0)}` : (m.rear && (!ACT[m.rear] || ACT[m.rear].h !== 1)) ? `rear=${m.rear} is not a rear-hand move. REAR: ${words(1)}`
    : !FEET[m.feet] ? `feet=${m.feet}: in, hold or back` : R.cost(m) > me.st ? `that costs ${R.cost(m)} stamina, you have ${me.st}` : m.feet === 'back' && me.ropes >= 2 ? 'you are on the ropes: no backing off until you step in' : m.feet === 'in' && me.kept ? 'kept out: no step in this beat' : ''; }
function newMatch(ta, tb) { const id = 'm' + nextId++, M = { id, tokens: [ta, tb], names: [players.get(ta).name, players.get(tb).name], seed: Math.floor(Math.random() * 1e6), n: 0, round: 1, beat: 0, range: 3, cards: [], over: '', F: [R0.man(N.hp), R0.man(N.hp)], sealed: [null, null], last: null, seen: [], since: Date.now(), log: [] };
  matches.set(id, M); players.get(ta).match = id; players.get(tb).match = id; return M; }
function play(M) { const R = load(M.seed * 1000 + M.n), nm = M.names, plans = M.sealed, T = { f: M.F, range: M.range, t: N.beats - M.beat }, lines = [], say = (s) => lines.push(s);
  const named = (s) => String(s).replace(/\byou\b/gi, nm[0]).replace(/\bhe\b/gi, nm[1]).replace(/\byour\b/gi, nm[0] + "'s").replace(/\bhis\b/gi, nm[1] + "'s").replace(/\bhim\b/gi, nm[1]);
  say(`--- round ${M.round}, beat ${M.beat + 1}, at ${RNG[M.range]}`); say(`${nm[0]}: ${R.planWords(plans[0])}`); say(`${nm[1]}: ${R.planWords(plans[1])}`);
  const at = { round: M.round, beat: M.beat, range: M.range }, ev = R.resolve(T, [{ ...plans[0] }, { ...plans[1] }]); R.endBeat(T); M.range = T.range; M.n++; M.seen = [...M.seen, plans].slice(-3); M.sealed = [null, null]; M.since = Date.now();
  for (const e of ev) say(`  ${e.m != null ? `moment ${e.m + 1} ` : ''}${e.k === 0 ? nm[0] : e.k === 1 ? nm[1] : ''}: ${named(e.a || e.t)}${e.o ? ' - ' + named(e.o) : ''}`);
  for (const k of [0, 1]) if (M.F[k].hp <= 0 && !M.over) { M.F[k].kd++; M.F[1 - k].pts += 3; if (M.F[k].kd > N.kd.length) { M.over = `${nm[1 - k]} WINS - the referee stops it`; M.winner = 1 - k; } else { M.F[k].hp = N.kd[M.F[k].kd - 1]; say(`  ${nm[k]} GOES DOWN and gets up on ${M.F[k].hp} health.`); } }
  M.beat++;
  if (!M.over && M.beat >= N.beats) { const [x, y] = M.F, { sc, onGround } = R.judge(x, y); M.cards.push(sc); say(`BELL. The judges give the round ${nm[0]} ${sc[0]} - ${sc[1]} ${nm[1]}${onGround ? ' (level on points: it goes to the man who backed off less)' : ''}.`);
    if (M.round >= N.rounds) { const t = [0, 1].map((k) => M.cards.reduce((s, c) => s + c[k], 0)); M.winner = t[0] === t[1] ? -1 : t[0] > t[1] ? 0 : 1; M.over = M.winner < 0 ? `A DRAW ${t[0]}-${t[1]}` : `${nm[M.winner]} WINS on the cards ${Math.max(...t)}-${Math.min(...t)}`; }
    else { M.round++; M.beat = 0; M.range = 3; for (const m of M.F) { m.pts = 0; m.st = m.cap; m.g = N.guard; m.ropes = 0; m.held = 0; m.kept = 0; m.gave = 0; } } }
  if (M.over) { say(M.over); finish(M); }
  M.last = { at, plans, lines }; M.log.push(...lines); }
function finish(M) { const r = { id: M.id, names: M.names, over: M.over, winner: M.winner, kd: [M.F[1].kd, M.F[0].kd], cards: M.cards, ended: new Date().toISOString() }; results.push(r); fs.appendFileSync(RESULTS, JSON.stringify(r) + '\n'); fs.writeFileSync(path.join(DATA, `match_${Date.now()}_${M.names.join('_v_').replace(/[^\w]/g, '')}.log.txt`), M.log.join('\n') + '\n'); for (const t of M.tokens) { const p = players.get(t); if (p && p.match === M.id) { p.match = null; p.lastMatch = M.id; } } }   /* a finished bout stays readable: /api/state falls back to the player's last bout */
// a player who does not seal inside the limit holds both hands, so nobody waits for ever
function tick(M) { if (M.over || Date.now() - M.since < LIMIT) return; if (!M.sealed[0] && !M.sealed[1]) { M.over = 'ABANDONED - neither player sealed a beat in time'; M.winner = -1; return finish(M); } const R = load(1); for (const k of [0, 1]) if (!M.sealed[k]) { M.sealed[k] = R.plan0(); M.log.push(`  (${M.names[k]} sealed nothing in time: both hands held)`); } play(M); }
function view(M, k) { const pub = (f) => ({ health: f.hp, healthMax: f.max, stamina: f.st, staminaCap: f.cap, guard: f.g, points: f.pts, downs: f.kd, groundGiven: Math.min(2, f.ropes), onTheRopes: f.ropes >= 2, noClinchYet: !!f.held, keptOut: !!f.kept }), raw = (f) => ({ hp: f.hp, max: f.max, st: f.st, cap: f.cap, g: f.g, pts: f.pts, kd: f.kd, ropes: f.ropes, held: f.held, kept: f.kept, gave: f.gave || 0 });
  return { match: M.id, you: M.names[k], him: M.names[1 - k], n: M.n, round: M.round, rounds: N.rounds, beat: M.beat + 1, beats: N.beats, range: M.range, rangeName: RNG[M.range], over: M.over, yourTurn: !M.over && !M.sealed[k], youSealed: !!M.sealed[k], heSealed: !!M.sealed[1 - k],
    cards: M.cards.map((c) => [c[k], c[1 - k]]), me: pub(M.F[k]), he: pub(M.F[1 - k]), raw: [raw(M.F[k]), raw(M.F[1 - k])], hisLastBeats: M.seen.map((p) => R0.planWords(p[1 - k])).reverse(),
    lastBeat: M.last ? { at: M.last.at, yourPlan: M.last.plans[k], hisPlan: M.last.plans[1 - k], lines: M.last.lines } : null, secondsLeft: M.over ? 0 : Math.max(0, Math.round((LIMIT - (Date.now() - M.since)) / 1000)) }; }
function table() { const T = {}; for (const r of results) for (const k of [0, 1]) { const t = T[r.names[k]] = T[r.names[k]] || { name: r.names[k], played: 0, won: 0, drawn: 0, lost: 0, knockdowns: 0, points: 0 }; t.played++; t.knockdowns += r.kd[k] || 0; if (r.winner < 0) { t.drawn++; t.points++; } else if (r.winner === k) { t.won++; t.points += 3; } else t.lost++; }
  return Object.values(T).sort((a, b) => b.points - a.points || b.won - a.won || b.knockdowns - a.knockdowns); }
const HELP = () => `PUNCHER'S CHANCE - MATCH SERVER\nJoin with a name, find an opponent, then each beat send ONE plan; the other player does the same without seeing yours.\n\n  POST /api/join  {"name": "Ziva"}                      -> {"token": "...", "name": "Ziva"}\n  POST /api/find  {"token": "..."}                      -> {"match": "m1"} or {"waiting": true}  (ask again every few seconds; add "vs": "John" to wait for one player)\n  GET  /api/state?token=...                             -> the bout as you see it; "yourTurn" says when to send a plan\n  POST /api/plan  {"token": "...", "lead": "jab", "rear": "high", "feet": "in", "order": "feet,lead"}   or   {"token": "...", "clinch": true}\n  GET  /api/lobby                                       -> who waits, the bouts, the table\nA refused plan costs nothing: read "error" and send another. A beat not sealed in ${LIMIT / 1000} s is played as both hands held.\nLEAD hand: ${words(0)}.   REAR hand: ${words(1)}.   FEET: in, hold, back.\n\nTHE RULES\nHealth ${N.hp}, stamina ${N.st} (+${N.rec} a beat, +${N.hold} for each hand held), ${N.rounds} rounds of ${N.beats} beats. Down at 0 health: up on ${N.kd.join(' then ')}; the next time it is over.\n` + Object.keys(ACT).map((id) => { const a = ACT[id]; return `  ${id}: ${a.n}, ${a.st} stamina${a.d ? `, ${a.d} health, reaches ${a.reach.map((r) => RNG[r]).join(' and ')}, line: ${a.line}${a.body ? ', shortens his stamina bar' : ''}` : `. ${a.t || ''}`}`; }).join('\n') +
  `\nA HELD hand blocks one line: lead high = straight head punches, lead low = body punches, rear high = hooks and the overhand, rear low = uppercuts. A punching hand is out of its guard only in the moment it punches, and is held HIGH in the other moments.\n` + Object.keys(FEET).map((id) => `  feet=${id}: ${FEET[id].n}, ${FEET[id].st} stamina. ${FEET[id].t}`).join('\n') +
  `\nclinch: Inside only, 1 stamina, no punch lands, +2 stamina, the referee breaks you at Mid; not twice running.\nORDER: up to three moments; your first action meets his first. In one moment the faster punch lands first; a big one (3 health or more) that lands stops his slower punch. A punch of his that misses or is blocked makes your later punches counters (+1).\nPOINTS: 2 for a big punch landed, 1 for a small one, 3 for a knockdown; more points takes the round 10-9. The third knockdown ends the bout.\n`;
const send = (res, code, body, type = 'application/json') => { res.writeHead(code, { 'Content-Type': type + '; charset=utf-8', 'Access-Control-Allow-Origin': '*', 'Access-Control-Allow-Headers': 'content-type', 'Cache-Control': 'no-store' }); res.end(type === 'application/json' ? JSON.stringify(body) : body); };
const body = (req) => new Promise((ok) => { let s = ''; req.on('data', (d) => { s += d; if (s.length > 20000) req.destroy(); }); req.on('end', () => { try { ok(JSON.parse(s || '{}')); } catch { ok(null); } }); });
http.createServer(async (req, res) => { const u = new URL(req.url, 'http://x'), q = Object.fromEntries(u.searchParams);
  if (req.method === 'OPTIONS') return send(res, 204, '', 'text/plain');
  if (u.pathname === '/api/help') return send(res, 200, HELP(), 'text/plain');
  if (u.pathname === '/api/lobby') { for (const M of matches.values()) tick(M); return send(res, 200, { waiting: queue.map((t) => players.get(t).name), bouts: [...matches.values()].map((M) => ({ match: M.id, names: M.names, round: M.round, beat: M.beat + 1, over: M.over })), table: table() }); }
  const b = req.method === 'POST' ? await body(req) : q; if (!b) return send(res, 400, { error: 'the body is not JSON' });
  if (u.pathname === '/api/join') { const name = String(b.name || '').replace(/[^\w .-]/g, '').trim().slice(0, 24); if (!name) return send(res, 400, { error: 'give a name (letters, digits, space, . - _)' });
    if ([...players.values()].some((p) => p.name.toLowerCase() === name.toLowerCase() && Date.now() - p.seen < 15 * 60000)) return send(res, 409, { error: `the name ${name} is in use: pick another` }); const token = crypto.randomBytes(12).toString('hex'); players.set(token, { name, match: null, seen: Date.now() }); return send(res, 200, { token, name }); }
  const P = players.get(b.token); if (!P) return send(res, 401, { error: 'unknown token: POST /api/join first' }); P.seen = Date.now();
  const M = matches.get(b.match || P.match || (/\/api\/(state)$/.test(u.pathname) ? P.lastMatch : '')) || null; if (M) tick(M);
  if (u.pathname === '/api/find') { if (P.match && matches.get(P.match) && !matches.get(P.match).over) return send(res, 200, { match: P.match }); queue = queue.filter((t) => players.has(t) && Date.now() - players.get(t).seen < 60000);
    const want = norm(b.vs), other = queue.find((t) => t !== b.token && (!want || norm(players.get(t).name) === want) && (!players.get(t).vs || players.get(t).vs === norm(P.name))); P.vs = want;
    if (other) { queue = queue.filter((t) => t !== other && t !== b.token); return send(res, 200, { match: newMatch(other, b.token).id }); } if (!queue.includes(b.token)) queue.push(b.token); return send(res, 200, { waiting: true, queue: queue.map((t) => players.get(t).name) }); }
  if (u.pathname === '/api/leave') { queue = queue.filter((t) => t !== b.token); if (M && !M.over && M.tokens.includes(b.token)) { const k = M.tokens.indexOf(b.token); M.winner = 1 - k; M.over = `${M.names[1 - k]} WINS - ${M.names[k]} left the bout`; M.log.push(M.over); finish(M); } return send(res, 200, { ok: true }); }
  if (!M || !M.tokens.includes(b.token)) return send(res, 404, { error: 'you are in no bout: POST /api/find' }); const k = M.tokens.indexOf(b.token);
  if (u.pathname === '/api/state') return send(res, 200, view(M, k));
  if (u.pathname === '/api/plan') { if (M.over) return send(res, 200, { ok: false, error: 'the bout is over: ' + M.over }); if (M.sealed[k]) return send(res, 200, { ok: false, error: 'your beat is already sealed' });
    const R = load(1), m = b.plan && typeof b.plan === 'object' ? { ...R.plan0(), ...b.plan } : makePlan(R, b), bad = refuse(M, k, m, R); if (bad) return send(res, 200, { ok: false, error: bad });
    M.sealed[k] = m; const both = !!M.sealed[1 - k]; if (both) play(M); return send(res, 200, { ok: true, sealed: R0.planWords(m), resolved: both, state: view(M, k) }); }
  send(res, 404, { error: 'no such call: GET /api/help' }); }).listen(PORT, '127.0.0.1', () => console.log(`MATCH SERVER up on 127.0.0.1:${PORT} - results ${RESULTS} - ${results.length} bouts on file`));
