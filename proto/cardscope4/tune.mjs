// CARDSCOPE4 sizing: a coordinate search over numbers against the round 4 bars (sizing seeds only, 300000 and up).
// node tune.mjs iters=300 per=50 [in=out/tuned.json]   writes out/tuned.json (name=value pairs for probe.mjs)
import fs from 'node:fs';
import { CARDS, N, STYLES, fighter } from './cards.mjs';
import { bout } from './engine.mjs';
import { aiPilot } from './plan.mjs';
const kv = Object.fromEntries(process.argv.slice(2).map((a) => a.split('=')));
const iters = +(kv.iters || 200), per = +(kv.per || 50), AI = aiPilot();
const OUT = new URL('./out/', import.meta.url); fs.mkdirSync(OUT, { recursive: true });
const get = (k) => (k.includes('.') ? CARDS[k.split('.')[0]][k.split('.')[1]] : N[k]);
const set = (k, v) => { if (k.includes('.')) CARDS[k.split('.')[0]][k.split('.')[1]] = v; else N[k] = v; };
const cur = {};
if (kv.in) for (const [k, v] of Object.entries(JSON.parse(fs.readFileSync(kv.in, 'utf8')))) { set(k, v); cur[k] = v; }
// the dials: [name, min, max]
const D = [['hp', 24, 40], ['lead', 6, 10], ['stepW', 0, 1], ['cover', 1, 3], ['block', 3, 6], ['roomW', 1, 3], ['sq0', 1, 3], ['upW', 1, 3], ['standW', 0, 2], ['catchPts', 0, 3], ['comboDmg', 2, 8], ['comboPts', 0, 3], ['counter', 1, 4], ['headlockPts', 0, 2], ['tiein', 1, 4], ['dmgPer', 3, 8], ['chain', 0, 2], ['stallMax', 1, 3]];
for (const [id, c] of Object.entries(CARDS)) {
  if (c.st === 'core') continue;
  D.push([id + '.w', id === 'pull' ? 0 : 1, 3]);
  if (c.k === 'strike') D.push([id + '.dmg', 1, 8]);
  if (c.k === 'strike' || c.k === 'shot' || c.k === 'adv') D.push([id + '.pts', 0, c.k === 'shot' ? 6 : 3]);
  if (c.k === 'shot' && c.dmg !== undefined) D.push([id + '.dmg', 0, 5]);
  if (c.k === 'hold') { D.push([id + '.count', 1, 3]); if (c.hpts) D.push([id + '.hpts', 2, 6]); }
}
// sane ranges: the real sports' points stay (WKF 1 / 2 / 3, a takedown 2), a dearer card is never the weaker one
const FIXED = new Set(['tieup.w', 'grip.w', 'chain', 'pull.w', 'frontkick.pts', 'roundhouse.pts', 'headkick.pts', 'revpunch.pts', 'double.pts', 'single.pts', 'sweep.pts', 'jab.w', 'block.w', 'jab.pts', 'bodyhook.pts', 'legkick.pts']);
const RANGE = { 'cross.w': [1, 2], 'hook.w': [1, 2], 'sthrow.w': [1, 2], 'trip.w': [1, 2], 'kneebar.w': [1, 2], 'double.w': [2, 3], 'single.w': [1, 2], 'hipthrow.w': [1, 2], 'triangle.w': [1, 2], 'hook.pts': [0, 1], 'cross.pts': [0, 1], 'upper.pts': [0, 1], 'overhand.pts': [0, 1], 'gnp.pts': [0, 1], 'frontkick.dmg': [1, 3], 'roundhouse.dmg': [3, 5], 'headkick.dmg': [5, 8], 'legkick.dmg': [1, 3], 'revpunch.dmg': [3, 5], 'trip.pts': [1, 2], 'footsweep.pts': [1, 2], 'hipthrow.pts': [2, 4], 'shoulderthrow.pts': [4, 6], 'slam.pts': [3, 4], 'sthrow.pts': [3, 4], 'pass.pts': [2, 3], 'ride.pts': [0, 1], block: [4, 6], cover: [2, 2], 'jab.dmg': [2, 3], 'cross.dmg': [4, 6], 'hook.dmg': [4, 6], 'upper.dmg': [6, 8], 'headkick.w': [2, 3], 'upper.w': [2, 3], 'gnp.dmg': [3, 6], 'evade.w': [1, 2], 'headlock.w': [1, 2] };
for (let i = D.length - 1; i >= 0; i--) { const k = D[i][0]; if (FIXED.has(k)) D.splice(i, 1); else if (RANGE[k]) { D[i][1] = RANGE[k][0]; D[i][2] = RANGE[k][1]; if (get(k) < RANGE[k][0]) { set(k, RANGE[k][0]); cur[k] = RANGE[k][0]; } if (get(k) > RANGE[k][1]) { set(k, RANGE[k][1]); cur[k] = RANGE[k][1]; } } }
for (const k of ['slip', 'evade', 'tiein', 'headlock', 'catchkick']) D.push([k + '.w', 1, 2]);
const PAIRS = []; for (let i = 0; i < 6; i++) for (let j = i + 1; j < 6; j++) PAIRS.push([STYLES[i], STYLES[j]]);
const cache = new Map();
function pairRun(pi, seed) {
  const [a, b] = PAIRS[pi], t = { n: 0, w: 0, ko: 0, lead: 0, tap: 0, pin: 0, cards: 0, early: 0, dec: 0, ground: 0, holdOn: 0, holdDone: 0, vis3: 0 };
  for (let i = 0; i < per; i++) for (const sw of [0, 1]) {
    const r = bout(fighter(sw ? b : a), fighter(sw ? a : b), [AI, AI], seed + 7919 * (pi * 1000 + i) + sw), st = r.st;
    t.w += (r.win === 0) !== !!sw; t.n++; t[r.how]++; t.early += r.early; t.dec += st.dec[0]; t.ground += !!(st.vis & 8); t.holdOn += st.holdOn; t.holdDone += st.holdDone; t.vis3 += [1, 2, 4, 8].filter((x) => st.vis & x).length >= 3;
  }
  return t;
}
// only = a style: re-measure just its five pairings (a changed card touches nothing else); the rest comes from the cache
function measure(seed, only, commit = true) {
  const win = {}, t = { n: 0, ko: 0, lead: 0, tap: 0, pin: 0, cards: 0, early: 0, dec: 0, ground: 0, holdOn: 0, holdDone: 0, vis3: 0 }, fresh = new Map();
  for (const s of STYLES) win[s] = {};
  PAIRS.forEach(([a, b], pi) => {
    const r = cache.has(pi) && only && a !== only && b !== only ? cache.get(pi) : pairRun(pi, seed); fresh.set(pi, r);
    for (const k in t) t[k] += r[k];
    win[a][b] = r.w / r.n; win[b][a] = 1 - win[a][b];
  });
  const out = (x, lo, hi) => Math.max(0, lo - x, x - hi) * 100;
  let L = 0, worst = 0;
  for (const [a, b] of PAIRS) { L += out(win[a][b], 0.46, 0.54) ** 2; worst = Math.max(worst, Math.abs(win[a][b] - 0.5)); }
  const avg = {}; for (const s of STYLES) { avg[s] = STYLES.filter((x) => x !== s).reduce((q, x) => q + win[s][x], 0) / 5; L += 4 * out(avg[s], 0.485, 0.515) ** 2; }
  const n = t.n, hold = (t.tap + t.pin) / n, fin = t.holdDone / Math.max(1, t.holdOn), hEnd = (t.tap + t.pin) / Math.max(1, t.ground);
  L += 3 * (out(t.ko / n, 0.2, 1) ** 2 + out(t.lead / n, 0.2, 1) ** 2 + out(hold, 0.2, 1) ** 2 + out(t.early / n, 0.46, 0.64) ** 2 + out(hEnd, 0.18, 0.27) ** 2) + 3 * out(fin, 0.3, 0.7) ** 2 + 400 * out(t.dec / n / 100, 0.25, 0.42) ** 2 + out(t.vis3 / n, 0.9, 1) ** 2;
  return { L, win, avg, worst, ko: t.ko / n, lead: t.lead / n, hold, early: t.early / n, dec: t.dec / n, fin, hEnd, vis3: t.vis3 / n, fresh };
}
const keep = (m) => { for (const [k, v] of m.fresh) cache.set(k, v); };
const line = (m) => `L ${m.L.toFixed(0)} worst ${(100 * m.worst).toFixed(0)} avg ${STYLES.map((s) => (100 * m.avg[s]).toFixed(0)).join('/')} ko ${(100 * m.ko).toFixed(0)} lead ${(100 * m.lead).toFixed(0)} hold ${(100 * m.hold).toFixed(0)} early ${(100 * m.early).toFixed(0)} dec ${m.dec.toFixed(1)} fin ${(100 * m.fin).toFixed(0)} hEnd ${(100 * m.hEnd).toFixed(0)}`;
let a = 12345; const rnd = () => { a = (a * 1103515245 + 12345) & 0x7fffffff; return a / 0x7fffffff; };
N.lead = 8; delete cur.lead;
const seed = 300000 + 1000003 * +(kv.s || 0); let best = measure(seed); keep(best); console.log('start', line(best));
const G = D.filter(([n]) => !n.includes('.') && n !== 'lead'), CD = D.filter(([n]) => n.includes('.'));
for (let it = 1; it <= iters; it++) {
  let pool = CD;
  if (rnd() < 0.12) pool = G;
  else if (rnd() < 0.7) { const bad = PAIRS.filter(([x, y]) => Math.abs(best.win[x][y] - 0.5) > 0.06), [wa, wb] = bad.length ? bad[Math.floor(rnd() * bad.length)] : PAIRS[Math.floor(rnd() * 15)]; pool = CD.filter(([n]) => [wa, wb].includes(CARDS[n.split('.')[0]].st)); }
  const [k, lo, hi] = pool[Math.floor(rnd() * pool.length)], old = get(k), v = old + (rnd() < 0.5 ? -1 : 1);
  if (v < lo || v > hi) continue;
  set(k, v); const m = measure(seed, k.includes('.') ? CARDS[k.split('.')[0]].st : null);
  if (m.L < best.L - 1) { best = m; keep(m); cur[k] = v; console.log(`it ${it} ${k} ${old}->${v}`, line(m)); fs.writeFileSync(new URL('tuned.json', OUT), JSON.stringify(cur)); } else set(k, old);
}
console.log('end', line(best)); console.log(JSON.stringify(cur));
for (const s of STYLES) console.log(s.padEnd(10), STYLES.map((x) => (s === x ? '  -' : (100 * best.win[s][x]).toFixed(0).padStart(3))).join(' '));
