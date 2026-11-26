// PUNCHCHANCE1 (S560): the comeback count. The solved mix against itself (as balance.mjs play who=mix opp=mirror, the same
// bout loop), with each bout written down: health after round 1, who won, and the puncher's chance - open, used, landed.
//   node proto/twohands/tools/probe_punch_chance.mjs [tweak=<f>] [n=84] [jobs=7] [seed=1] [json=<f>]
// Prints the 9 bars (balance.mjs bars) and the comeback bar: the man 4+ health behind after round 1 wins 15-30%.
import fs from 'node:fs';
import { fileURLToPath } from 'node:url';
import { Worker, isMainThread, parentPort, workerData } from 'node:worker_threads';
import { loadTweaked, readTweak, bars } from './balance.mjs';

const drawAt = (mix, rnd) => { let x = rnd(), i = 0; while (i < mix.length - 1 && (x -= mix[i]) > 0) i++; return i; };
function bouts(R, n) { const { N, ACT, man, resolve, endBeat } = R, rnd = R.rnd;
  if (!R.OPPS[3]) R.OPPS.push({ n: 'mirror', hp: N.hp, read: 0, like: [], lean: 0 }); R.setOpp(3);
  const o = { n, w: 0, draw: 0, ko: 0, lost: 0, beats: 0, clinch: 0, rng: [0, 0, 0, 0], use: [{}, {}], pun: [{}, {}], np: [[0, 0, 0], [0, 0, 0]], dmg: [0, 0], first: {}, ordered: 0, kd: [0, 0], lvl: [0, 0, 0], recs: [] };
  const note = (k, c) => { const u = o.use[k], add = (x) => { u[x] = (u[x] || 0) + 1; }; if (c.clinch) return add('clinch'); add(c.lead || 'lead held ' + c.hl); add(c.rear || 'rear held ' + c.hr); add(c.feet === 'hold' ? 'feet hold' : c.feet === 'in' ? 'step in' : c.feet === 'back' ? 'back off' : c.feet);
    o.np[k][(c.lead && ACT[c.lead].d ? 1 : 0) + (c.rear ? 1 : 0)]++; if (k === 0 && c.ord && c.ord.length > 1) { o.ordered++; o.first[c.ord[0]] = (o.first[c.ord[0]] || 0) + 1; } };
  for (let b = 0; b < n; b++) { const S = { f: [man(N.hp), man(N.hp)], range: 3 }; let done = false; const t = [0, 0], rec = { r1: null, win: -1, stop: 0, kd: [0, 0], pcKd: [0, 0], rounds: [] };
    for (let r = 0; r < N.rounds && !done; r++) { S.range = 3; for (const m of S.f) { m.pts = 0; m.st = m.cap; m.g = N.guard; m.ropes = 0; m.held = 0; m.kept = 0; m.gave = 0; }
      const rr = { open: [0, 0], used: [0, 0], landed: [0, 0], missed: [0, 0], beats: 0 }; rec.rounds.push(rr);
      for (let i = 0; i < N.beats && !done; i++) { S.t = N.beats - i; const z = R.solveBeat(S, S.t, { iters: 400 }), mine = z.A[drawAt(z.p, rnd)], his = z.B[drawAt(z.q, rnd)]; rr.beats++;
        if (z.A.some((c) => c.pch)) rr.open[0]++; if (z.B.some((c) => c.pch)) rr.open[1]++; if (mine.pch) rr.used[0]++; if (his.pch) rr.used[1]++;
        note(0, mine); note(1, his); const hp = [S.f[0].hp, S.f[1].hp], ev = resolve(S, [{ ...mine }, { ...his }]); endBeat(S); o.beats++; o.rng[S.range]++; o.dmg[0] += hp[1] - S.f[1].hp; o.dmg[1] += hp[0] - S.f[0].hp;
        for (const e of ev) { if (e.t === 'clinch') o.clinch++; if (e.id && (e.t === 'hit' || e.t === 'block' || e.t === 'miss')) { const q = o.pun[e.k][e.id] = o.pun[e.k][e.id] || { hit: 0, block: 0, miss: 0 }; q[e.t]++; }
          if (e.t === 'hit' && /ALL IN/.test(e.o || '')) { rr.landed[e.k]++; rec.pcKd[e.k]++; } if (e.t === 'flat' && /^all in and/.test(e.a || '')) rr.missed[e.k]++; }
        for (const k of [0, 1]) if (S.f[k].hp <= 0) { S.f[k].kd++; o.kd[k]++; rec.kd[k]++; S.f[1 - k].pts += 3; if (S.f[k].kd > N.kd.length) { if (k === 1) { o.w++; o.ko++; rec.win = 0; } else { o.lost++; rec.win = 1; } rec.stop = 1; done = true; break; } S.f[k].hp = N.kd[S.f[k].kd - 1]; } }
      if (r === 0) rec.r1 = [S.f[0].hp, S.f[1].hp];
      if (!done) { const [x, y] = S.f, lvl = x.pts === y.pts, g = lvl && N.even ? Math.sign((y.gave || 0) - (x.gave || 0)) : 0;
        o.lvl[0]++; if (lvl) o.lvl[1]++; if (g) o.lvl[2]++; t[0] += x.pts > y.pts || (lvl && g >= 0) ? 10 : 9; t[1] += y.pts > x.pts || (lvl && g <= 0) ? 10 : 9; } }
    if (!done) { if (t[0] > t[1]) { o.w++; rec.win = 0; } else if (t[0] === t[1]) o.draw++; else rec.win = 1; }
    o.recs.push(rec); }
  return o; }
const merge = (a, b) => { if (!a) return b; for (const k in b) { if (k === 'recs') { a.recs.push(...b.recs); continue; } if (typeof b[k] === 'number') a[k] = (a[k] || 0) + b[k]; else if (Array.isArray(b[k]) && typeof b[k][0] === 'number') b[k].forEach((x, i) => { a[k][i] += x; }); else if (Array.isArray(b[k])) b[k].forEach((x, i) => { a[k][i] = merge(a[k][i], x); }); else a[k] = merge(a[k] || {}, b[k]); } return a; };
if (!isMainThread && workerData && workerData.pcProbe) { const { tweak, n, seed } = workerData; parentPort.postMessage(bouts(loadTweaked(seed, tweak, undefined), n)); }

export function comeback(o) { const pc = (x) => (100 * x).toFixed(0) + '%', L = []; let behind = 0, won = 0, drew = 0, rounds = 0, both = 0, openB = 0, usedB = 0, landed = 0, missed = 0, used = 0;
  for (const r of o.recs) { if (r.r1) { const gap = r.r1[0] - r.r1[1]; if (Math.abs(gap) >= 4 && r.rounds.length > 1) { behind++; const k = gap < 0 ? 0 : 1; if (r.win === k) won++; else if (r.win === -1) drew++; } }
    for (const q of r.rounds) { rounds++; if (q.open[0] && q.open[1]) both++; openB += q.open[0] + q.open[1]; usedB += q.used[0] + q.used[1]; landed += q.landed[0] + q.landed[1]; missed += q.missed[0] + q.missed[1]; } }
  used = usedB; const share = won / Math.max(behind, 1);
  L.push(`  ${share >= 0.15 && share <= 0.3 ? 'PASS' : 'FAIL'} the comeback (the man 4+ health behind after round 1 wins 15-30%): ${pc(share)} - ${won} of ${behind} bouts (${drew} drawn; ${pc(behind / o.n)} of bouts had that gap)`);
  if (openB) { L.push(`  ${usedB / openB <= 1 / 3 ? 'PASS' : 'FAIL'} not a must when open (used in at most 1 open beat in 3): ${pc(usedB / openB)} (${usedB} of ${openB} open beats)`);
    L.push(`  ${usedB / (2 * o.beats) <= 0.1 ? 'PASS' : 'FAIL'} rare (in at most 10% of a man's beats): ${pc(usedB / (2 * o.beats))}`);
    L.push(`  ${both / Math.max(rounds, 1) <= 0.2 ? 'PASS' : 'FAIL'} the loop (open for both men in one round, at most 1 round in 5): ${pc(both / Math.max(rounds, 1))} (${both} of ${rounds} rounds)`);
    L.push(`  used ${(used / o.n).toFixed(2)} a bout: lands ${pc(landed / Math.max(used, 1))}, missed or blocked ${pc(missed / Math.max(used, 1))}, the rest beaten to the punch or not thrown`); }
  return 'COMEBACK\n' + L.join('\n'); }

const main = isMainThread && process.argv[1] && fileURLToPath(import.meta.url).toLowerCase() === fs.realpathSync(process.argv[1]).toLowerCase();
if (main) { const arg = (k, d) => { const a = process.argv.find((x) => x.startsWith(k + '=')); return a ? a.split('=').slice(1).join('=') : d; };
  const tweak = readTweak(arg('tweak', '')), n = Number(arg('n', 84)), jobs = Number(arg('jobs', 7)), seed = Number(arg('seed', 1)), each = Math.ceil(n / jobs), self = fileURLToPath(import.meta.url), t0 = Date.now();
  const got = await Promise.all(Array.from({ length: jobs }, (_, i) => new Promise((ok, bad) => { const w = new Worker(self, { workerData: { pcProbe: 1, tweak, n: each, seed: seed * 100 + i } }); w.once('message', ok); w.once('error', bad); })));
  const o = got.reduce(merge, null), R = loadTweaked(1, tweak, undefined);
  console.log(`PROBE ${arg('tweak', 'the page (no switch)')}: ${o.n} bouts, ${((Date.now() - t0) / 1000).toFixed(0)} s`); console.log(bars(R, o)); console.log(comeback(o));
  if (arg('json', '')) fs.writeFileSync(arg('json', ''), JSON.stringify(o)); }
