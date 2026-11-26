// PROGP3 (S560) - ATTRIBUTES ON THE FIGHT BOARD: how much does each one decide? (probe P3 of ops/research/DESIGN_PROGRESSION1.md 3d).
// Today the page (order.html) gives both men one shared N: health 18, stamina bar 8, stamina back 1 a beat, guard 6 - nothing
// per man exists. This probe tries PER-MAN values WITHOUT touching the page: rules.mjs loads the page's rules through a patch
// (a text replacement at load time) so each man carries his own hp, stamina bar, recovery and guard as fields on the man,
// falling back to N - then plays whole bouts of the solved mix against itself (balance.mjs `play who=mix opp=mirror` style:
// both men draw from the beat's solveBeat), with man A and man B given DIFFERENT sets. The bouts loop is balance.mjs's mirror
// loop, read to the letter, with only the two men's creation and the per-round guard reset changed; equal sets must therefore
// replay balance's mirror bout for bout (probe_attributes_test.mjs holds that).
//   node proto/twohands/tools/probe_attributes.mjs a=hp:20,st:8,rec:1,guard:6 b=hp:16,st:8,rec:1,guard:6 n=84 jobs=2 seed=1 [json=<f>]
// `rec:1+` = one more stamina back on every second beat of a round (beats 2, 4 and 6 - DESIGN_PROGRESSION1 3d).
// THE LOOK-AHEAD: vtable.json was built for equal men. It is used AS IT IS here - an approximation for unequal men: a 9-stamina
// man is read as 8 in the table, and the every-second-beat recovery is invisible to the one-beat look-ahead.
// Output: wins / draws / stoppages for A, knockdowns each, the usual per-switch use for each man, the two switches whose use
// moved most between A and B, and the stoppages bar (10-40%) flagged if the pair lands outside it.
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';
import { Worker, isMainThread, parentPort, workerData } from 'node:worker_threads';
import { load } from './rules.mjs';

const here = path.dirname(fileURLToPath(import.meta.url));
export const PAGE = 'order.html';

// ---- THE PATCH. Two text replacements on the page's rules (read through rules.mjs, the file itself is never edited):
// man(hp) -> man(hp, o): the o fields are the man's own attributes; endBeat: stamina back from the man's own rec (+1 more
// when he is a recPlus man and the beat is the 2nd, 4th or 6th of the round), guard regen capped at his own guard.
const MAN_SRC = 'const man = (hp) => ({ hp, max: hp, st: N.st, cap: N.st, g: N.guard, pts: 0, kd: 0, ropes: 0, held: 0, kept: 0, last: null });';
const MAN_REP = 'const man = (hp, o) => { o = o || {}; return { hp, max: hp, st: o.st ?? N.st, cap: o.st ?? N.st, g: o.guard ?? N.guard, guard: o.guard, rec: o.rec, recPlus: !!o.recPlus, pts: 0, kd: 0, ropes: 0, held: 0, kept: 0, last: null }; };';
const END_SRC = 'function endBeat(S) { for (const m of S.f) { const l = m.last || {}, home = l.clinch ? 0 : (l.lead ? 0 : 1) + (l.rear ? 0 : 1); m.st = Math.min(m.cap, m.st + N.rec + N.hold * home); m.g = Math.min(N.guard, m.g + N.grec); if (m.held) m.held--; } }';
const END_REP = 'function endBeat(S) { for (const m of S.f) { const l = m.last || {}, home = l.clinch ? 0 : (l.lead ? 0 : 1) + (l.rear ? 0 : 1); m.st = Math.min(m.cap, m.st + (m.rec ?? N.rec) + N.hold * home + (m.recPlus && S.bt && S.bt % 2 === 0 ? 1 : 0)); m.g = Math.min(m.guard ?? N.guard, m.g + N.grec); if (m.held) m.held--; } }';
export const PATTERNS = [[MAN_SRC, MAN_REP], [END_SRC, END_REP]];
export const applyPatch = (s) => { for (const [f, r] of PATTERNS) { if (!s.includes(f)) throw new Error('probe_attributes: not on the page: ' + f.slice(0, 60)); s = s.replace(f, r); } return s; };

// ---- THE SETS. a=hp:20,st:8,rec:1,guard:6 - a missing key is today's value; rec:1+ = rec 1 plus one more every second beat.
const TODAY = { hp: 18, st: 8, rec: 1, guard: 6 };
export function setOf(str = '') { const o = { ...TODAY, recPlus: false, src: String(str) };
  for (const pair of String(str).split(',')) { if (!pair.trim()) continue; const [k, v] = pair.split(':');
    if (!['hp', 'st', 'rec', 'guard'].includes(k)) throw new Error(`probe_attributes: unknown switch in a set: ${k} (${str})`);
    const m = /^(\d+)(\+)?$/.exec(v || ''); if (!m) throw new Error(`probe_attributes: ${k} is not a number: ${v} (${str})`);
    o[k] = Number(m[1]); if (m[2]) o.recPlus = true; }
  if (!(o.hp >= 1)) throw new Error(`probe_attributes: hp must be at least 1 (${str})`);
  return o; }
export const descOf = (o) => `hp ${o.hp}, stamina bar ${o.st}, recovery ${o.rec}${o.recPlus ? ' + one more every second beat' : ''}, guard ${o.guard}`;

const drawAt = (mix, rnd) => { let x = rnd(), i = 0; while (i < mix.length - 1 && (x -= mix[i]) > 0) i++; return i; };   // as balance.mjs
const nameOf = (R, a) => (R.ACT[a] ? R.ACT[a].n : R.FEET && R.FEET[a] ? R.FEET[a].n : a);   // as balance.mjs

// ---- WHOLE BOUTS: the solved mix against itself (who=mix, opp=mirror in balance.mjs). balance.mjs's loop, with the two
// men created from the two sets and the per-round guard reset reading the man's own guard. S.bt = the beat in the round
// (1-6), so endBeat can give a recPlus man his extra stamina back on the even beats.
export function bouts(R, n, a, b) { const { N, ACT, resolve, endBeat } = R, rnd = R.rnd;
  const o = { n, w: 0, draw: 0, ko: 0, lost: 0, beats: 0, clinch: 0, rng: [0, 0, 0, 0], use: [{}, {}], pun: [{}, {}], np: [[0, 0, 0], [0, 0, 0]], dmg: [0, 0], first: {}, ordered: 0, kd: [0, 0], lvl: [0, 0, 0] };
  const note = (k, c) => { const u = o.use[k], add = (x) => { u[x] = (u[x] || 0) + 1; }; if (c.clinch) return add('clinch'); add(c.lead || 'lead held ' + c.hl); add(c.rear || 'rear held ' + c.hr); add(c.feet === 'hold' ? 'feet hold' : c.feet === 'in' ? 'step in' : c.feet === 'back' ? 'back off' : c.feet);
    o.np[k][(c.lead && ACT[c.lead].d ? 1 : 0) + (c.rear ? 1 : 0)]++; if (k === 0 && c.ord && c.ord.length > 1) { o.ordered++; o.first[c.ord[0]] = (o.first[c.ord[0]] || 0) + 1; } };
  for (let bt = 0; bt < n; bt++) { const S = { f: [R.man(a.hp, a), R.man(b.hp, b)], range: 3 }; let done = false; const t = [0, 0];
    for (let r = 0; r < N.rounds && !done; r++) { S.range = 3; for (const m of S.f) { m.pts = 0; m.st = m.cap; m.g = m.guard ?? N.guard; m.ropes = 0; m.held = 0; m.kept = 0; m.gave = 0; }
      for (let i = 0; i < N.beats && !done; i++) { S.t = N.beats - i; S.bt = i + 1;
        const z = R.solveBeat(S, S.t, { iters: 400 }); const mine = z.A[drawAt(z.p, rnd)], his = z.B[drawAt(z.q, rnd)];
        note(0, mine); note(1, his); const hp = [S.f[0].hp, S.f[1].hp], ev = resolve(S, [{ ...mine }, { ...his }]); endBeat(S); o.beats++; o.rng[S.range]++; o.dmg[0] += hp[1] - S.f[1].hp; o.dmg[1] += hp[0] - S.f[0].hp;
        for (const e of ev) { if (e.t === 'clinch') o.clinch++; if (e.id && (e.t === 'hit' || e.t === 'block' || e.t === 'miss')) { const q = o.pun[e.k][e.id] = o.pun[e.k][e.id] || { hit: 0, block: 0, miss: 0 }; q[e.t]++; } }
        for (const k of [0, 1]) if (S.f[k].hp <= 0) { S.f[k].kd++; o.kd[k]++; S.f[1 - k].pts += 3; if (S.f[k].kd > N.kd.length) { if (k === 1) { o.w++; o.ko++; } else o.lost++; done = true; break; } S.f[k].hp = N.kd[S.f[k].kd - 1]; } }
      if (!done) { const [x, y] = S.f, lvl = x.pts === y.pts, g = lvl && N.even ? Math.sign((y.gave || 0) - (x.gave || 0)) : 0;
        o.lvl[0]++; if (lvl) o.lvl[1]++; if (g) o.lvl[2]++; t[0] += x.pts > y.pts || (lvl && g >= 0) ? 10 : 9; t[1] += y.pts > x.pts || (lvl && g <= 0) ? 10 : 9; } }
    if (!done) { if (t[0] > t[1]) o.w++; else if (t[0] === t[1]) o.draw++; } }
  return o; }

const merge = (a, b) => { if (!a) return b; for (const k in b) { if (typeof b[k] === 'number') a[k] = (a[k] || 0) + b[k]; else if (Array.isArray(b[k]) && typeof b[k][0] === 'number') b[k].forEach((x, i) => { a[k][i] += x; }); else if (Array.isArray(b[k])) b[k].forEach((x, i) => { a[k][i] = merge(a[k][i], x); }); else a[k] = merge(a[k] || {}, b[k]); } return a; };   // as balance.mjs

if (!isMainThread && workerData && workerData.attrProbe) { const { n, seed, a, b } = workerData; parentPort.postMessage(bouts(load(seed, PAGE, applyPatch), n, a, b)); }
export async function play(n, opts = {}) { const jobs = opts.jobs || 2, self = fileURLToPath(import.meta.url), each = Math.ceil(n / jobs);
  const got = await Promise.all(Array.from({ length: jobs }, (_, i) => new Promise((ok, bad) => { const w = new Worker(self, { workerData: { attrProbe: 1, n: each, seed: (opts.seed || 1) * 100 + i, a: opts.a || setOf(), b: opts.b || setOf() } }); w.once('message', ok); w.once('error', bad); })));
  return got.reduce(merge, null); }

// ---- THE REPORT of one pairing (the usual balance.mjs lines, named A and B instead of you and he).
export function report(R, a, b, o, secs) { const pc = (x) => (100 * x).toFixed(0) + '%', tot = (q) => q.hit + q.block + q.miss, nb = Math.max(1, o.beats), decided = Math.max(0, o.n - o.draw);
  const L = [`PROBE_ATTRIBUTES a=${a.src} b=${b.src} n=${o.n} seed-manifest: jobs split by seed*100+i (page ${PAGE} through rules.mjs with the per-man patch; the page file is not edited)`];
  L.push(`A [${descOf(a)}]  v  B [${descOf(b)}]: A wins ${pc(o.w / Math.max(decided, 1))} of decided (${o.w} of ${decided}), draws ${pc(o.draw / o.n)} of all; stoppages: A stops B ${pc(o.ko / o.n)}, B stops A ${pc(o.lost / o.n)}; knockdowns a bout (suffered): A ${(o.kd[0] / o.n).toFixed(1)} / B ${(o.kd[1] / o.n).toFixed(1)}; health dealt a bout: A ${(o.dmg[0] / o.n).toFixed(1)} / B ${(o.dmg[1] / o.n).toFixed(1)}; beats at Inside / Mid / Long ${[1, 2, 3].map((r) => pc(o.rng[r] / nb)).join(' / ')}; clinches a bout ${(o.clinch / o.n).toFixed(1)}`);
  for (const [k, tag] of [[0, 'A'], [1, 'B']]) { const u = o.use[k], np = o.np[k];
    L.push(`  ${tag} a beat: ` + Object.keys(u).sort((x, y) => u[y] - u[x]).map((x) => `${nameOf(R, x)} ${pc(u[x] / nb)}`).join(', ') + ` | punches in a plan: none ${pc(np[0] / nb)}, one ${pc(np[1] / nb)}, two ${pc(np[2] / nb)}`);
    L.push(`  ${tag} punches (thrown a bout: lands / blocked / misses): ` + Object.keys(o.pun[k]).sort((x, y) => tot(o.pun[k][y]) - tot(o.pun[k][x])).map((id) => { const q = o.pun[k][id]; return `${R.ACT[id].n} ${(tot(q) / o.n).toFixed(1)}: ${pc(q.hit / tot(q))} / ${pc(q.block / tot(q))} / ${pc(q.miss / tot(q))}`; }).join(', ')); }
  const gap = {}; for (const s of new Set([...Object.keys(o.use[0]), ...Object.keys(o.use[1])])) gap[s] = (o.use[0][s] || 0) / nb - (o.use[1][s] || 0) / nb;
  L.push(`  how the two men fought differently, the switches whose use moved most (A share - B share): ` + Object.keys(gap).sort((x, y) => Math.abs(gap[y]) - Math.abs(gap[x])).slice(0, 2).map((s) => `${nameOf(R, s)} ${gap[s] >= 0 ? '+' : ''}${(100 * gap[s]).toFixed(0)}% (A ${pc((o.use[0][s] || 0) / nb)} / B ${pc((o.use[1][s] || 0) / nb)})`).join(', '));
  const stop = (o.ko + o.lost) / o.n;
  L.push(`  stoppages ${pc(stop)} of all bouts (bar 10-40%): ${stop >= 0.1 && stop <= 0.4 ? 'inside the bar' : 'FLAG: outside the bar'}`);
  L.push(`  NOTE: the look-ahead table vtable.json was built for equal men - used as it is here: an approximation for unequal men (a 9-stamina man is read as 8 in it; the every-second-beat recovery is invisible to the one-beat look-ahead).`);
  if (secs != null) L.push(`  (${o.n} bouts, ${secs} s)`);
  return L.join('\n'); }

const isMain = isMainThread && import.meta.url === pathToFileURL(process.argv[1] || '').href;
if (isMain) { const arg = (k, d) => { const x = process.argv.find((y) => y.startsWith(k + '=')); return x ? x.split('=').slice(1).join('=') : d; };
  const a = setOf(arg('a', 'hp:18,st:8,rec:1,guard:6')), b = setOf(arg('b', 'hp:18,st:8,rec:1,guard:6')), n = Number(arg('n', 24)), jobs = Number(arg('jobs', 2)), seed = Number(arg('seed', 1));
  if (!(n > 0)) throw new Error('probe_attributes: n must be at least 1'); if (!(jobs >= 1)) throw new Error('probe_attributes: jobs must be at least 1');
  const R = load(1, PAGE, applyPatch), t0 = Date.now(), o = await play(n, { a, b, jobs, seed });
  console.log(report(R, a, b, o, ((Date.now() - t0) / 1000).toFixed(0)));
  if (arg('json', '')) fs.writeFileSync(arg('json', ''), JSON.stringify(o)); }
