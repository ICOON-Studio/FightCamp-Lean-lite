// AIEMPTY1 (S564): his empty beats. A counting copy of balance.mjs's bout loop (play who=<mix|sensible|random> opp=<0|1|2|mirror>):
// the same seeds (worker i plays seed * 100 + i), the same bouts, the same report - plus, for every plan each man plays,
// whether it is EMPTY (a plan that can never do anything with that part) and, for his plans, which branch of the page's
// ai() picked it (habit read / solved mix / plain beat). Modelled on probe_punch_chance.mjs.
//   E1 a push off ordered AFTER his back off in the same plan (the back off takes him out of Inside first; push is Inside only)
//   E2 a feint with no punch of his after it in the plan's order
//   E3 a step in at Inside with no ground given (ropes 0)
//   E4 a back off at Long with no punch after it in the plan
// The branch is read by tagging the plan ai() returns (three src patches that only set a field on the returned plan:
// no number, no rule and no random draw changes - the report must equal balance.mjs's on the same seed and tweak).
//   node proto/twohands/tools/probe_empty.mjs [who=mix] [opp=0] [n=84] [seed=1] [jobs=2] [tweak=<f>] [table=<f>] [json=<f>]
import fs from 'node:fs';
import { fileURLToPath } from 'node:url';
import { Worker, isMainThread, parentPort, workerData } from 'node:worker_threads';
import { loadTweaked, readTweak, report, bars } from './balance.mjs';

// the branch tags (applied after the tweak's own src pairs, so a tweak that keeps these lines is still tagged)
export const TAGS = [
  ['if (best) best.readOf = { ...habit };', 'if (best) { best.readOf = { ...habit }; best.br = \'read\'; }'],
  ['return pickOne(own.length ? own : all); }', '{ const z = pickOne(own.length ? own : all); if (z) z.br = own.length ? \'plain\' : \'plainAll\'; return z; } }'],
  ['const r = solveBeat(S, t, { lean1: lean, iters: 400 }); return r.B[drawFrom(r.q)]; }', '{ const r = solveBeat(S, t, { lean1: lean, iters: 400 }), z = r.B[drawFrom(r.q)]; if (z) z.br = \'mix\'; return z; } }'],
];
export const KINDS = ['E1', 'E2', 'E3', 'E4'];
// the empty kinds of man k's plan c in state S (before the beat is resolved)
export function emptyKinds(R, S, k, c) { const out = []; if (!c || c.clinch) return out; const me = S.f[k], ord = R.ordOf(c), at = (sl) => ord.indexOf(sl);
  const punchAfter = (i) => ['lead', 'rear'].some((sl) => c[sl] && R.ACT[c[sl]].d && at(sl) > i);
  if (c.lead === 'push' && c.feet === 'back' && at('feet') < at('lead')) out.push('E1');
  if (c.lead === 'feint' && !punchAfter(at('lead'))) out.push('E2');
  if (c.feet === 'in' && S.range === 1 && !(me.ropes > 0)) out.push('E3');
  if (c.feet === 'back' && S.range === 3 && !punchAfter(at('feet'))) out.push('E4');
  return out; }

const drawAt = (mix, rnd) => { let x = rnd(), i = 0; while (i < mix.length - 1 && (x -= mix[i]) > 0) i++; return i; };
// balance.mjs bouts(), line for line, with the count added (marked EMPTY)
function bouts(R, who, opp, n) { const { N, ACT, plan0, man, cost, resolve, endBeat } = R, rnd = R.rnd, mirror = opp === 'mirror';
  if (mirror) { if (!R.OPPS[3]) R.OPPS.push({ n: 'mirror', hp: N.hp, read: 0, like: [], lean: 0 }); R.setOpp(3); } else R.setOpp(opp);
  const o = { n, w: 0, draw: 0, ko: 0, lost: 0, beats: 0, clinch: 0, rng: [0, 0, 0, 0], use: [{}, {}], pun: [{}, {}], np: [[0, 0, 0], [0, 0, 0]], dmg: [0, 0], first: {}, ordered: 0, kd: [0, 0], lvl: [0, 0, 0] };
  const E = { mine: {}, his: {}, br: {}, hisAny: {}, mineAny: 0, at: {} };   // EMPTY: mine[kind], his[branch][kind], br[branch] = his beats from it, hisAny[branch], at[kind][range]
  const sensible = (S) => { const me = S.f[0], he = S.f[1], g0 = he.last || plan0(), guess = cost(g0) <= he.st ? g0 : { ...plan0(), hl: g0.hl, hr: g0.hr }; let best = plan0(), bv = -1e9;
    for (const c of R.plansFor(S, 0)) { if (c.clinch) continue; const T = { range: S.range, f: S.f.map((m) => ({ ...m, hist: [] })) }; resolve(T, [{ ...c }, { ...guess, clinch: false }]);
      const v = (he.hp - T.f[1].hp) - (me.hp - T.f[0].hp) + 0.25 * T.f[0].st + rnd() * 0.5; if (v > bv) { bv = v; best = c; } }
    return best; };
  const note = (k, c) => { const u = o.use[k], add = (x) => { u[x] = (u[x] || 0) + 1; }; if (c.clinch) return add('clinch'); add(c.lead || 'lead held ' + c.hl); add(c.rear || 'rear held ' + c.hr); add(c.feet === 'hold' ? 'feet hold' : c.feet === 'in' ? 'step in' : c.feet === 'back' ? 'back off' : c.feet);
    o.np[k][(c.lead && ACT[c.lead].d ? 1 : 0) + (c.rear ? 1 : 0)]++; if (k === 0 && c.ord && c.ord.length > 1) { o.ordered++; o.first[c.ord[0]] = (o.first[c.ord[0]] || 0) + 1; } };
  const count = (S, mine, his) => { const em = emptyKinds(R, S, 0, mine), eh = emptyKinds(R, S, 1, his), br = mirror ? 'mirror' : his.br || 'untagged';   // EMPTY
    for (const x of em) E.mine[x] = (E.mine[x] || 0) + 1; if (em.length) E.mineAny++;
    E.br[br] = (E.br[br] || 0) + 1; E.his[br] = E.his[br] || {}; for (const x of eh) { E.his[br][x] = (E.his[br][x] || 0) + 1; E.at[x] = E.at[x] || [0, 0, 0, 0]; E.at[x][S.range]++; } if (eh.length) E.hisAny[br] = (E.hisAny[br] || 0) + 1; };
  for (let b = 0; b < n; b++) { const S = { f: [man(N.hp), man(R.opp().hp)], range: 3 }; let done = false; const t = [0, 0];
    for (let r = 0; r < N.rounds && !done; r++) { S.range = 3; for (const m of S.f) { m.pts = 0; m.st = m.cap; m.g = N.guard; m.ropes = 0; m.held = 0; m.kept = 0; m.gave = 0; }
      for (let i = 0; i < N.beats && !done; i++) { S.t = N.beats - i; let mine, his;
        if (who === 'mix') { const z = R.solveBeat(S, S.t, { iters: 400 }); mine = z.A[drawAt(z.p, rnd)]; his = mirror ? z.B[drawAt(z.q, rnd)] : null; }
        else if (who === 'random') { const A = R.plansFor(S, 0); mine = A[Math.floor(rnd() * A.length)]; } else mine = sensible(S);
        if (!his) his = R.ai(S);
        count(S, mine, his);   // EMPTY: read on the state the plans were chosen in
        note(0, mine); note(1, his); const hp = [S.f[0].hp, S.f[1].hp], ev = resolve(S, [{ ...mine }, { ...his }]); endBeat(S); o.beats++; o.rng[S.range]++; o.dmg[0] += hp[1] - S.f[1].hp; o.dmg[1] += hp[0] - S.f[0].hp;
        for (const e of ev) { if (e.t === 'clinch') o.clinch++; if (e.id && (e.t === 'hit' || e.t === 'block' || e.t === 'miss')) { const q = o.pun[e.k][e.id] = o.pun[e.k][e.id] || { hit: 0, block: 0, miss: 0 }; q[e.t]++; } }
        for (const k of [0, 1]) if (S.f[k].hp <= 0) { S.f[k].kd++; o.kd[k]++; S.f[1 - k].pts += 3; if (S.f[k].kd > N.kd.length) { if (k === 1) { o.w++; o.ko++; } else o.lost++; done = true; break; } S.f[k].hp = N.kd[S.f[k].kd - 1]; } }
      if (!done) { const [x, y] = S.f, lvl = x.pts === y.pts, g = lvl && N.even ? Math.sign((y.gave || 0) - (x.gave || 0)) : 0;
        o.lvl[0]++; if (lvl) o.lvl[1]++; if (g) o.lvl[2]++; t[0] += x.pts > y.pts || (lvl && g >= 0) ? 10 : 9; t[1] += y.pts > x.pts || (lvl && g <= 0) ? 10 : 9; } }
    if (!done) { if (t[0] > t[1]) o.w++; else if (t[0] === t[1]) o.draw++; } }
  o.empty = E; return o; }
// balance.mjs merge, deep over the EMPTY counts too
const merge = (a, b) => { if (!a) return b; for (const k in b) { if (typeof b[k] === 'number') a[k] = (a[k] || 0) + b[k]; else if (Array.isArray(b[k]) && typeof b[k][0] === 'number') { a[k] = a[k] || []; b[k].forEach((x, i) => { a[k][i] = (a[k][i] || 0) + x; }); } else if (Array.isArray(b[k])) b[k].forEach((x, i) => { a[k][i] = merge(a[k][i], x); }); else a[k] = merge(a[k] || {}, b[k]); } return a; };
const tagged = (tweak) => ({ ...(tweak || {}), src: [...((tweak && tweak.src) || []), ...TAGS] });
if (!isMainThread && workerData && workerData.emptyProbe) { const { tweak, table, who, opp, n, seed } = workerData; parentPort.postMessage(bouts(loadTweaked(seed, tagged(tweak), table), who, opp, n)); }

export function emptyReport(o) { const E = o.empty, nb = o.beats, per = (x) => (100 * (x || 0) / nb).toFixed(1), pc = (x) => (100 * x).toFixed(0) + '%', L = [];
  const brs = Object.keys(E.br).sort(), tot = (x) => brs.reduce((s, b) => s + ((E.his[b] || {})[x] || 0), 0), any = brs.reduce((s, b) => s + (E.hisAny[b] || 0), 0);
  L.push(`EMPTY his beats ${nb}: ` + brs.map((b) => `${b} ${E.br[b]} (${pc(E.br[b] / nb)})`).join(', '));
  L.push(`  his empty beats per 100 of his beats: ${KINDS.map((x) => `${x} ${per(tot(x))}`).join(', ')}, any ${per(any)}  (counts ${KINDS.map((x) => `${x} ${tot(x)}`).join(', ')}, any ${any})`);
  for (const b of brs) { const h = E.his[b] || {}; L.push(`  from ${b} (${E.br[b]} beats): per 100 of ALL his beats ${KINDS.map((x) => `${x} ${per(h[x])}`).join(', ')}, any ${per(E.hisAny[b])}; per 100 of this branch's beats any ${(100 * (E.hisAny[b] || 0) / E.br[b]).toFixed(1)}  (counts ${KINDS.map((x) => `${x} ${h[x] || 0}`).join(', ')})`); }
  L.push(`  his empty kinds by range at the plan (Inside / Mid / Long): ${KINDS.filter((x) => E.at[x]).map((x) => `${x} ${E.at[x].slice(1).join(' / ')}`).join(', ') || 'none'}`);
  L.push(`  your (the player-bot's) empty beats per 100 beats: ${KINDS.map((x) => `${x} ${per(E.mine[x])}`).join(', ')}, any ${per(E.mineAny)}`);
  return L.join('\n'); }

const main = isMainThread && process.argv[1] && fileURLToPath(import.meta.url).toLowerCase() === fs.realpathSync(process.argv[1]).toLowerCase();
if (main) { const arg = (k, d) => { const a = process.argv.find((x) => x.startsWith(k + '=')); return a ? a.split('=').slice(1).join('=') : d; };
  const tweak = readTweak(arg('tweak', '')), table = arg('table', '') || undefined, who = arg('who', 'mix'), op = arg('opp', '0'), opp = op === 'mirror' ? op : Number(op);
  const n = Number(arg('n', 84)), jobs = Number(arg('jobs', 2)), seed = Number(arg('seed', 1)), each = Math.ceil(n / jobs), self = fileURLToPath(import.meta.url), t0 = Date.now();
  const got = await Promise.all(Array.from({ length: jobs }, (_, i) => new Promise((ok, bad) => { const w = new Worker(self, { workerData: { emptyProbe: 1, tweak, table, who, opp, n: each, seed: seed * 100 + i } }); w.once('message', ok); w.once('error', bad); })));
  const o = got.reduce(merge, null), R = loadTweaked(1, tweak, table);
  console.log(`PROBE_EMPTY ${arg('tweak', 'the page (no tweak)')} who=${who} opp=${op} n=${n} seed=${seed} jobs=${jobs}`);
  console.log(report(R, who, opp, o) + `\n  (${o.n} bouts, ${((Date.now() - t0) / 1000).toFixed(0)} s)`); if (who === 'mix' && opp === 'mirror') console.log(bars(R, o));
  console.log(emptyReport(o));
  if (arg('json', '')) fs.writeFileSync(arg('json', ''), JSON.stringify(o)); }
