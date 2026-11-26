// KDHEAL1 (S563): does a knockdown heal too much? The same bout loop as `balance.mjs play who=mix opp=mirror`
// (the solved mix against itself), with each bout written down: health after round 1, who won, which round a
// stoppage came in, and every beat where a man is on 1-2 health and whether he threw with both hands - the
// "walk into a punch at 1 health" pull (ALLPLAY2 Ziva item 1, Arena item 10). balance.mjs play stays the report
// and the bars; this adds the three numbers it does not give: the comeback share (PUNCHCHANCE1's bar), the share
// of bouts a knockdown stops in the last round, and the both-hands share on 1-2 health. With the same seed, jobs
// and n the bouts are the play run's bouts (checked: the bars' stoppages, knockdowns and ranges match exactly).
//   node proto/twohands/tools/probe_kd_heal.mjs [tweak=<f>] [table=<f>] [n=84] [jobs=7] [seed=1] [json=<f>]
// Prints the 9 bars (balance.mjs bars) and the KDHEAL lines. A man is on 1-2 health when his plan is chosen
// (health is never below 1 at a beat's start: a knockdown puts him back on his get-up health).
import fs from 'node:fs';
import { fileURLToPath } from 'node:url';
import { Worker, isMainThread, parentPort, workerData } from 'node:worker_threads';
import { loadTweaked, readTweak, bars } from './balance.mjs';

const drawAt = (mix, rnd) => { let x = rnd(), i = 0; while (i < mix.length - 1 && (x -= mix[i]) > 0) i++; return i; };
function bouts(R, n) { const { N, ACT, man, resolve, endBeat } = R, rnd = R.rnd;
  if (!R.OPPS[3]) R.OPPS.push({ n: 'mirror', hp: N.hp, read: 0, like: [], lean: 0 }); R.setOpp(3);
  const o = { n, w: 0, draw: 0, ko: 0, lost: 0, beats: 0, clinch: 0, rng: [0, 0, 0, 0], use: [{}, {}], pun: [{}, {}], np: [[0, 0, 0], [0, 0, 0]], dmg: [0, 0], first: {}, ordered: 0, kd: [0, 0], lvl: [0, 0, 0], recs: [], low: { beats: 0, two: 0 } };
  const note = (k, c) => { const u = o.use[k], add = (x) => { u[x] = (u[x] || 0) + 1; }; if (c.clinch) return add('clinch'); add(c.lead || 'lead held ' + c.hl); add(c.rear || 'rear held ' + c.hr); add(c.feet === 'hold' ? 'feet hold' : c.feet === 'in' ? 'step in' : c.feet === 'back' ? 'back off' : c.feet);
    o.np[k][(c.lead && ACT[c.lead].d ? 1 : 0) + (c.rear ? 1 : 0)]++; if (k === 0 && c.ord && c.ord.length > 1) { o.ordered++; o.first[c.ord[0]] = (o.first[c.ord[0]] || 0) + 1; } };
  for (let b = 0; b < n; b++) { const S = { f: [man(N.hp), man(N.hp)], range: 3 }; let done = false; const t = [0, 0], rec = { r1: null, rds: 0, win: -1, stop: 0, kdRounds: [] };
    for (let r = 0; r < N.rounds && !done; r++) { rec.rds = r + 1; S.range = 3; for (const m of S.f) { m.pts = 0; m.st = m.cap; m.g = N.guard; m.ropes = 0; m.held = 0; m.kept = 0; m.gave = 0; }
      for (let i = 0; i < N.beats && !done; i++) { S.t = N.beats - i; const z = R.solveBeat(S, S.t, { iters: 400 }), mine = z.A[drawAt(z.p, rnd)], his = z.B[drawAt(z.q, rnd)], plan = [mine, his];
        for (const k of [0, 1]) if (S.f[k].hp <= 2) { o.low.beats++; const c = plan[k]; if ((c.lead && ACT[c.lead].d ? 1 : 0) + (c.rear ? 1 : 0) === 2) o.low.two++; }
        note(0, mine); note(1, his); const hp = [S.f[0].hp, S.f[1].hp], ev = resolve(S, [{ ...mine }, { ...his }]); endBeat(S); o.beats++; o.rng[S.range]++; o.dmg[0] += hp[1] - S.f[1].hp; o.dmg[1] += hp[0] - S.f[0].hp;
        for (const e of ev) { if (e.t === 'clinch') o.clinch++; if (e.id && (e.t === 'hit' || e.t === 'block' || e.t === 'miss')) { const q = o.pun[e.k][e.id] = o.pun[e.k][e.id] || { hit: 0, block: 0, miss: 0 }; q[e.t]++; } }
        for (const k of [0, 1]) if (S.f[k].hp <= 0) { rec.kdRounds.push(r + 1); S.f[k].kd++; o.kd[k]++; S.f[1 - k].pts += 3; if (S.f[k].kd > N.kd.length) { rec.stop = r + 1; if (k === 1) { o.w++; o.ko++; rec.win = 0; } else { o.lost++; rec.win = 1; } done = true; break; } S.f[k].hp = N.kd[S.f[k].kd - 1]; } }
      if (r === 0) rec.r1 = [S.f[0].hp, S.f[1].hp];
      if (!done) { const [x, y] = S.f, lvl = x.pts === y.pts, g = lvl && N.even ? Math.sign((y.gave || 0) - (x.gave || 0)) : 0;
        o.lvl[0]++; if (lvl) o.lvl[1]++; if (g) o.lvl[2]++; t[0] += x.pts > y.pts || (lvl && g >= 0) ? 10 : 9; t[1] += y.pts > x.pts || (lvl && g <= 0) ? 10 : 9; } }
    if (!done) { if (t[0] > t[1]) { o.w++; rec.win = 0; } else if (t[0] === t[1]) o.draw++; else rec.win = 1; }
    o.recs.push(rec); }
  return o; }
const merge = (a, b) => { if (!a) return b; for (const k in b) { if (k === 'recs') { a.recs.push(...b.recs); continue; } if (k === 'low') { a.low.beats += b.low.beats; a.low.two += b.low.two; continue; } if (typeof b[k] === 'number') a[k] = (a[k] || 0) + b[k]; else if (Array.isArray(b[k]) && typeof b[k][0] === 'number') b[k].forEach((x, i) => { a[k][i] += x; }); else if (Array.isArray(b[k])) b[k].forEach((x, i) => { a[k][i] = merge(a[k][i], x); }); else a[k] = merge(a[k] || {}, b[k]); } return a; };
if (!isMainThread && workerData && workerData.kdProbe) { const { tweak, table, n, seed } = workerData; parentPort.postMessage(bouts(loadTweaked(seed, tweak, table || undefined), n)); }

export function kdheal(o, R) { const pc = (x) => (100 * x).toFixed(0) + '%', L = []; let behind = 0, won = 0, drew = 0, gap = 0, gapWon = 0, last = 0, stops = 0;
  for (const r of o.recs) { if (r.stop) stops++; if (r.stop === R.N.rounds) last++;
    if (r.r1 && r.rds > 1) { const g = r.r1[0] - r.r1[1]; if (g !== 0) { gap++; if (r.win === (g < 0 ? 0 : 1)) gapWon++; }
      if (Math.abs(g) >= 4) { behind++; const k = g < 0 ? 0 : 1; if (r.win === k) won++; else if (r.win === -1) drew++; } } }
  const two = (o.np[0][2] + o.np[1][2]) / (2 * o.beats);
  L.push(`  ${won / Math.max(behind, 1) >= 0.15 && won / Math.max(behind, 1) <= 0.3 ? 'PASS' : 'FAIL'} the comeback (the man 4+ health behind after round 1 wins 15-30%, PUNCHCHANCE1's bar): ${pc(won / Math.max(behind, 1))} - ${won} of ${behind} bouts (${drew} drawn; ${pc(behind / o.n)} of bouts had that gap)`);
  L.push(`    any health gap after round 1: ${pc(gapWon / Math.max(gap, 1))} - ${gapWon} of ${gap} bouts`);
  L.push(`  stopped by a knockdown in the last round (round ${R.N.rounds}): ${pc(last / o.n)} of bouts (stoppages ${pc(stops / o.n)}, before the last round ${pc((stops - last) / o.n)})`);
  L.push(`  beats a man is on 1-2 health: ${o.low.beats} (${pc(o.low.beats / (2 * o.beats))} of a man's beats); both hands thrown in ${pc(o.low.two / Math.max(o.low.beats, 1))} of them - all beats, both men: ${pc(two)}`);
  return 'KDHEAL\n' + L.join('\n'); }

const main = isMainThread && process.argv[1] && fileURLToPath(import.meta.url).toLowerCase() === fs.realpathSync(process.argv[1]).toLowerCase();
if (main) { const arg = (k, d) => { const a = process.argv.find((x) => x.startsWith(k + '=')); return a ? a.split('=').slice(1).join('=') : d; };
  const tweak = readTweak(arg('tweak', '')), table = arg('table', ''), n = Number(arg('n', 84)), jobs = Number(arg('jobs', 7)), seed = Number(arg('seed', 1)), each = Math.ceil(n / jobs), self = fileURLToPath(import.meta.url), t0 = Date.now();
  const got = await Promise.all(Array.from({ length: jobs }, (_, i) => new Promise((ok, bad) => { const w = new Worker(self, { workerData: { kdProbe: 1, tweak, table: table || undefined, n: each, seed: seed * 100 + i } }); w.once('message', ok); w.once('error', bad); })));
  const o = got.reduce(merge, null), R = loadTweaked(1, tweak, table || undefined);
  console.log(`PROBE ${arg('tweak', 'the page (no tweak)')}${table ? ' table=' + table : ''}: ${o.n} bouts, ${((Date.now() - t0) / 1000).toFixed(0)} s`);
  console.log(bars(R, o)); console.log(kdheal(o, R));
  if (arg('json', '')) fs.writeFileSync(arg('json', ''), JSON.stringify(o)); }
