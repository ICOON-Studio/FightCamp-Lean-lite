// CARDSCOPE5 sizing, second tool (tune.mjs takes the first improvement on one seed and so fits that seed's noise).
// Each round: a batch of candidates (one number +-1, or one card swapped for another in a style deck) is screened in
// parallel child processes on the screening seeds; the best three are measured again on the validation seeds and the
// best of those is kept only if it is better THERE. Sizing seeds only (300000 + 1000003 * s).
// node tune2.mjs rounds=60 per=40 s=21,22,23 vper=150 v=31,32,33,34 batch=30 procs=6 in=sized.json out=tuned_o.json
import fs from 'node:fs';
import { spawn } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import { CARDS, N, STYLES, OWN, fighter, size } from './cards.mjs';
import { bout } from './engine.mjs';
import { aiPilot, resetFit } from './plan.mjs';
const ME = fileURLToPath(import.meta.url), OUT = new URL('./out/', import.meta.url);
const get = (k) => { const q = k.split('.'); return q[0] === 'own' ? OWN[q[1]][q[2]] : q[1] ? CARDS[q[0]][q[1]] : N[k]; };
const set = (k, v) => { size(k, v); resetFit(); };
const PAIRS = []; for (let i = 0; i < STYLES.length; i++) for (let j = i + 1; j < STYLES.length; j++) PAIRS.push([STYLES[i], STYLES[j]]);
const ZERO = () => ({ n: 0, w: 0, ko: 0, lead: 0, tap: 0, pin: 0, cards: 0, early: 0, dec: 0, ground: 0, holdOn: 0, holdDone: 0, vis3: 0 });
if (process.argv[2] === 'child') {
  const job = JSON.parse(process.argv[3]), AI = aiPilot(), res = {};
  for (const [k, v] of Object.entries(job.set)) set(k, v);
  for (const pi of job.pairs) {
    const [a, b] = PAIRS[pi], t = ZERO();
    for (const s of job.seeds) for (let i = 0; i < job.per; i++) for (const sw of [0, 1]) {
      const r = bout(fighter(sw ? b : a), fighter(sw ? a : b), [AI, AI], 300000 + 1000003 * s + 7919 * (pi * 1000 + i) + sw), st = r.st;
      t.w += (r.win === 0) !== !!sw; t.n++; t[r.how]++; t.early += r.early; t.dec += st.dec[0]; t.ground += !!(st.vis & 8); t.holdOn += st.holdOn; t.holdDone += st.holdDone; t.vis3 += [1, 2, 4, 8].filter((x) => st.vis & x).length >= 3;
    }
    res[pi] = t;
  }
  console.log(JSON.stringify(res)); process.exit(0);
}
const kv = Object.fromEntries(process.argv.slice(2).map((a) => a.split('=')));
const rounds = +(kv.rounds || 40), per = +(kv.per || 40), seeds = (kv.s || '21,22,23').split(',').map(Number), vper = +(kv.vper || 150), vseeds = (kv.v || '31,32,33,34').split(',').map(Number), B = +(kv.batch || 30), procs = +(kv.procs || 6);
const cur = kv.in ? JSON.parse(fs.readFileSync(kv.in, 'utf8')) : {};
for (const [k, v] of Object.entries(cur)) set(k, v);
// the dials and their sane ranges: as tune.mjs (real-sport points pinned, a dearer card never the weaker one)
const D = [['hp', 24, 40], ['block', 4, 6], ['pullW', 1, 3], ['upW', 1, 3], ['standW', 0, 2], ['catchPts', 0, 3], ['comboDmg', 2, 8], ['comboPts', 0, 3], ['counter', 1, 4], ['headlockPts', 0, 2], ['tiein', 1, 4], ['dmgPer', 3, 8], ['stallMax', 1, 3]];
for (const [id, c] of Object.entries(CARDS)) {
  if (c.st === 'core') continue;
  D.push([id + '.w', 1, c.k === 'ans' ? 2 : 3]);
  if (c.k === 'strike') D.push([id + '.dmg', 1, 8]);
  if (c.k === 'strike' || c.k === 'shot' || c.k === 'adv') D.push([id + '.pts', 0, c.k === 'shot' ? 6 : 3]);
  if (c.k === 'shot' && c.dmg !== undefined) D.push([id + '.dmg', 0, 5]);
  if (c.k === 'shot' && !c.sweep) D.push([id + '.to', 0, 3]);
  if (c.k === 'hold') { D.push([id + '.count', 1, 3]); if (c.hk === 'sub') D.push([id + '.brk', 3, 6]); if (c.tick) D.push([id + '.tick', 1, 2]); if (c.hpts) D.push([id + '.hpts', 2, 6]); }
}
const FIXED = new Set(['grip.w', 'frontkick.pts', 'roundhouse.pts', 'headkick.pts', 'revpunch.pts', 'double.pts', 'single.pts', 'sweep.pts', 'jab.w', 'block.w', 'jab.pts', 'bodyhook.pts', 'legkick.pts', 'lowkick.pts', 'lowkick.w']);
const RANGE = { 'cross.w': [1, 2], 'hook.w': [1, 2], 'sthrow.w': [1, 2], 'trip.w': [1, 2], 'kneebar.w': [1, 2], 'double.w': [2, 3], 'single.w': [1, 2], 'hipthrow.w': [1, 2], 'triangle.w': [1, 2], 'hook.pts': [0, 1], 'cross.pts': [0, 1], 'upper.pts': [0, 1], 'overhand.pts': [0, 1], 'gnp.pts': [0, 1], 'frontkick.dmg': [1, 3], 'roundhouse.dmg': [3, 5], 'headkick.dmg': [5, 8], 'legkick.dmg': [1, 3], 'revpunch.dmg': [3, 5], 'trip.pts': [1, 2], 'footsweep.pts': [1, 2], 'hipthrow.pts': [2, 4], 'shoulderthrow.pts': [4, 6], 'slam.pts': [3, 4], 'sthrow.pts': [3, 4], 'pass.pts': [2, 3], 'ride.pts': [0, 1], 'jab.dmg': [2, 3], 'cross.dmg': [4, 6], 'hook.dmg': [4, 6], 'upper.dmg': [6, 8], 'headkick.w': [2, 3], 'upper.w': [2, 3], 'gnp.dmg': [3, 6], 'onetwo.pts': [0, 2], 'knee.pts': [0, 2], 'kbhook.dmg': [3, 6], 'onetwo.dmg': [4, 6], 'slip.w': [1, 3], 'tiein.w': [1, 3], 'catchkick.w': [1, 3] };
const DL = D.filter(([k]) => !FIXED.has(k)).map(([k, lo, hi]) => (RANGE[k] ? [k, ...RANGE[k]] : [k, lo, hi]));
for (const [k, lo, hi] of DL) { const v = get(k); if (v < lo) { set(k, lo); cur[k] = lo; } if (v > hi) { set(k, hi); cur[k] = hi; } }
const styleOf = (k) => (k.startsWith('own.') ? k.split('.')[1] : k.includes('.') ? CARDS[k.split('.')[0]].st : null);
function run(job) { return new Promise((ok, bad) => { const c = spawn(process.execPath, [ME, 'child', JSON.stringify(job)]); let o = '', e = ''; c.stdout.on('data', (d) => (o += d)); c.stderr.on('data', (d) => (e += d)); c.on('close', (rc) => (rc ? bad(new Error(e)) : ok(JSON.parse(o)))); }); }
async function pool(jobs) { const res = Array(jobs.length); let nx = 0; await Promise.all(Array.from({ length: procs }, async () => { while (nx < jobs.length) { const i = nx++; res[i] = await run(jobs[i]); } })); return res; }
function score(cache) {
  const win = {}, t = ZERO(); for (const s of STYLES) win[s] = {};
  PAIRS.forEach(([a, b], pi) => { const r = cache[pi]; for (const k in t) t[k] += r[k]; win[a][b] = r.w / r.n; win[b][a] = 1 - win[a][b]; });
  const out = (x, lo, hi) => Math.max(0, lo - x, x - hi) * 100;
  let L = 0, worst = 0; const bad = [];
  for (const [a, b] of PAIRS) { const o = out(win[a][b], 0.46, 0.54); L += o ** 2; worst = Math.max(worst, Math.abs(win[a][b] - 0.5)); if (Math.abs(win[a][b] - 0.5) > 0.045) bad.push([a, b, Math.abs(win[a][b] - 0.5)]); }
  const avg = {}; for (const s of STYLES) { avg[s] = STYLES.filter((x) => x !== s).reduce((q, x) => q + win[s][x], 0) / (STYLES.length - 1); L += 4 * out(avg[s], 0.485, 0.515) ** 2; }
  const n = t.n, hold = (t.tap + t.pin) / n, fin = t.holdDone / Math.max(1, t.holdOn), hEnd = (t.tap + t.pin) / Math.max(1, t.ground);
  L += 3 * (out(t.ko / n, 0.19, 1) ** 2 + out(t.lead / n, 0.19, 1) ** 2 + out(hold, 0.19, 1) ** 2 + out(t.early / n, 0.46, 0.64) ** 2 + out(hEnd, 0.18, 0.27) ** 2) + 12 * out(fin, 0.25, 0.7) ** 2 + 400 * out(t.dec / n / 100, 0.25, 0.42) ** 2 + out(t.vis3 / n, 0.9, 1) ** 2;
  const line = `L ${L.toFixed(0)} worst ${(100 * worst).toFixed(0)} avg ${STYLES.map((s) => (100 * avg[s]).toFixed(0)).join('/')} ko ${(100 * t.ko / n).toFixed(0)} lead ${(100 * t.lead / n).toFixed(0)} hold ${(100 * hold).toFixed(0)} early ${(100 * t.early / n).toFixed(0)} dec ${(t.dec / n).toFixed(1)} fin ${(100 * fin).toFixed(0)} hEnd ${(100 * hEnd).toFixed(0)}`;
  return { L, win, bad: bad.sort((x, y) => y[2] - x[2]), line };
}
let a = 4242 + 7717 * +(kv.r || 0); const rnd = () => { a = (a * 1103515245 + 12345) & 0x7fffffff; return a / 0x7fffffff; };
const all = PAIRS.map((_, i) => i), chunks = Array.from({ length: 7 }, (_, c) => all.filter((i) => i % 7 === c));
const full = async (pr, sd) => Object.assign({}, ...(await pool(chunks.map((pairs) => ({ set: cur, pairs, per: pr, seeds: sd })))));
let cacheS = await full(per, seeds), cacheV = await full(vper, vseeds);
let best = score(cacheV); console.log('start', best.line, '| screen', score(cacheS).L.toFixed(0));
const tried = new Map(), pick = (arr) => arr[Math.floor(rnd() * arr.length)];
for (let rd = 1; rd <= rounds; rd++) {
  const cands = []; let globals = 0, guard = 0;
  while (cands.length < B && guard++ < 6000) {
    const focus = best.bad.length && rnd() < 0.8 ? best.bad[Math.floor(rnd() * rnd() * best.bad.length)].slice(0, 2) : null;
    let c;
    if (rnd() < 0.25) { // a deck swap: one copy of a for one copy of b, inside one style (1 to 3 copies of a card)
      const st = focus ? pick(focus) : pick(STYLES), ids = Object.keys(OWN[st]), x = pick(ids.filter((i) => OWN[st][i] > 1)), y = pick(ids.filter((i) => OWN[st][i] < 3 && i !== x));
      if (!x || !y) continue;
      c = { key: `${st}: ${x} -> ${y}`, sets: { [`own.${st}.${x}`]: OWN[st][x] - 1, [`own.${st}.${y}`]: OWN[st][y] + 1 }, st };
    } else {
      let poolD = DL.filter(([k]) => k.includes('.'));
      if (rnd() < 0.08 && globals < 2) poolD = DL.filter(([k]) => !k.includes('.')); else if (focus) poolD = poolD.filter(([k]) => focus.includes(styleOf(k)));
      const [k, lo, hi] = pick(poolD), old = get(k), v = old + (rnd() < 0.5 ? -1 : 1);
      if (v < lo || v > hi) continue;
      c = { key: `${k} ${old}->${v}`, sets: { [k]: v }, st: styleOf(k) }; if (!c.st) globals++;
    }
    if (cands.some((q) => q.key === c.key) || (tried.get(c.key) || 0) > rd - 10) continue;
    c.pairs = c.st ? all.filter((i) => PAIRS[i].includes(c.st)) : all; cands.push(c); tried.set(c.key, rd);
  }
  const res = await pool(cands.map((c) => ({ set: { ...cur, ...c.sets }, pairs: c.pairs, per, seeds })));
  const baseS = score(cacheS).L, top = cands.map((c, i) => ({ c, fresh: res[i], L: score({ ...cacheS, ...res[i] }).L })).filter((t) => t.L < baseS).sort((x, y) => x.L - y.L).slice(0, 3);
  const val = await pool(top.map((t) => ({ set: { ...cur, ...t.c.sets }, pairs: t.c.pairs, per: vper, seeds: vseeds })));
  let win = null; top.forEach((t, i) => { const s = score({ ...cacheV, ...val[i] }); if (s.L < best.L - 2 && (!win || s.L < win.s.L)) win = { t, s, v: val[i] }; });
  if (win) { best = win.s; cacheV = { ...cacheV, ...win.v }; cacheS = { ...cacheS, ...win.t.fresh }; for (const [k, v] of Object.entries(win.t.c.sets)) { cur[k] = v; set(k, v); } tried.clear(); console.log(`rd ${rd} ${win.t.c.key}`, best.line); fs.writeFileSync(new URL(kv.out || 'tuned2.json', OUT), JSON.stringify(cur)); }
  else console.log(`rd ${rd} - (${top.length} screened better)`);
}
console.log('end', best.line); console.log(JSON.stringify(cur));
for (const s of STYLES) console.log(s.padEnd(10), STYLES.map((x) => (s === x ? '  -' : (100 * best.win[s][x]).toFixed(0).padStart(3))).join(' '));
