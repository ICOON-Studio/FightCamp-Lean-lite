// LONG2 (S565, probe) - THE LONG COUNT. A counting COPY of balance.mjs's bout loop (the same calls in the same order,
// the same worker seeds: seed * 100 + i, ceil(n / jobs) bouts a worker), so with the same n / seed / jobs / tweak / table
// it plays THE SAME bouts as `balance.mjs play` and only counts more. Nothing here changes a rule: the page's resolve is
// read through rules.mjs (balance.mjs's loadTweaked), each beat's events are read after the beat.
// What it counts, for the beats that START at Long (docs/LONG2_RESULT.md, ops/research/TASK_LONG2.md):
//   - beats a bout at Long, the share with no punch thrown by either man;
//   - the cross thrown FROM Long (the moment it is thrown starts at Long): landed on a man stepping in that moment,
//     blocked, fell short (he did not come), and the counters he landed off that miss;
//   - the jabs thrown from Long: landed, landed on a man stepping in that moment;
//   - the step in from Long: lead held high / low / throwing, got in unhit or hit (by what);
//   - points and health taken by punches thrown from Long, by punch; rounds won by the man whose Long points beat his
//     opponent's whole round; the lazy plan (the same man throwing a cross from Long two Long beats running).
//   node proto/twohands/tools/probe_long2.mjs [who=mix] [opp=mirror] [n=84] [tweak=<f>] [table=<vt>] [seed=1] [jobs=2] [json=<out>]
import fs from 'node:fs';
import { fileURLToPath, pathToFileURL } from 'node:url';
import { Worker, isMainThread, parentPort, workerData } from 'node:worker_threads';
import { loadTweaked, readTweak } from './balance.mjs';

const PUN = ['jab', 'bjab', 'hook', 'lup', 'lbody', 'cross', 'over', 'rup', 'rbody'];
const zeroBy = () => Object.fromEntries(PUN.map((id) => [id, 0]));
const outcome = () => ({ thrown: 0, hit: 0, hitStep: 0, block: 0, blockStep: 0, short: 0, other: 0, dmg: 0, pts: 0, dmgStep: 0, ptsStep: 0 });

function blank() {
  return { n: 0, w: 0, draw: 0, ko: 0, lost: 0, kd: [0, 0], beats: 0, rng: [0, 0, 0, 0], use: { jab: 0, bjab: 0, cross: 0, rbody: 0, stepIn: 0, leadHigh: 0 },
    longBeats: 0, longNoPunch: 0, longNothing: 0,
    cross: outcome(), rbody: outcome(), jab: outcome(), bjab: outcome(),
    shortCounters: { n: 0, dmg: 0, pts: 0, beatsWithShort: 0, beatsCountered: 0 },
    step: { tries: 0, high: 0, low: 0, throwing: 0, clean: 0, hitNow: 0, hitLater: 0, both: 0, cleanBy: { high: 0, low: 0, throwing: 0 }, by: zeroBy() },
    fromLong: { dmg: zeroBy(), pts: zeroBy() },
    rounds: { scored: 0, decided: 0, longWins: 0, level: 0 },
    lazy: { cross: { second: 0, hit: 0, block: 0, short: 0, other: 0 }, rear: { second: 0, hit: 0, block: 0, short: 0, other: 0 } } };
}

// one beat's events read: S0 = the range before the beat, eff = the two plans as resolve played them
function countBeat(R, C, r0beat, eff, ev, rd) {
  const { ACT, ordOf, RNG } = R, NAME = Object.fromEntries(Object.entries(RNG).map(([k, v]) => [v, Number(k)]));
  const ord = eff.map((p) => (p.clinch ? [] : ordOf(p)));
  // the range at the start of each moment and at its punches (after the feet and a push)
  const start = [], atPunch = []; let r = r0beat;
  for (let m = 0; m < 3; m++) { start[m] = r;
    for (const e of ev) if (e.m === m && e.t === 'range') { const to = / to (Inside|Mid|Long)$/.exec(e.a || ''); if (to) r = NAME[to[1]]; }
    for (const e of ev) if (e.m === m && e.t === 'flat' && /^pushes off/.test(e.a || '') && /back at Mid/.test(e.o || '')) r = 2;
    atPunch[m] = r; }
  const stepsIn = (k, m) => ord[k][m] === 'feet' && eff[k].feet === 'in';
  const punches = (p) => !p.clinch && ((p.lead && ACT[p.lead].d) || (p.rear && ACT[p.rear].d));
  const crossFromLong = [null, null];   // what the man's cross / body cross thrown from Long did this beat
  if (r0beat === 3) { C.longBeats++; if (!punches(eff[0]) && !punches(eff[1])) { C.longNoPunch++; if (eff.every((p) => !p.lead && p.feet !== 'in' && p.feet !== 'back')) C.longNothing++; } }
  // punches thrown from Long
  let sawShort = [false, false], countered = false;
  ev.forEach((e, idx) => {
    if (!e.id || !ACT[e.id] || !ACT[e.id].d || e.k < 0 || e.m == null) return;
    const k = e.k, v = 1 - k, m = e.m;
    if (start[m] !== 3) return;
    const walked = atPunch[m] === 2 && stepsIn(v, m) || (atPunch[m] === 1 && stepsIn(v, m));
    if (e.t === 'hit') { C.fromLong.dmg[e.id] += e.dmg; C.fromLong.pts[e.id] += e.pts; rd.longPts[k] += e.pts; }
    const q = C[e.id === 'cross' ? 'cross' : e.id === 'rbody' ? 'rbody' : e.id === 'jab' ? 'jab' : e.id === 'bjab' ? 'bjab' : null];
    if (q) { q.thrown++;
      if (e.t === 'hit') { q.hit++; q.dmg += e.dmg; q.pts += e.pts; if (walked) { q.hitStep++; q.dmgStep += e.dmg; q.ptsStep += e.pts; } }
      else if (e.t === 'block') { q.block++; if (walked) q.blockStep++; }
      else if (e.t === 'miss' && /falls short/.test(e.o || '')) q.short++;
      else q.other++; }
    if (e.id === 'cross' || e.id === 'rbody') { crossFromLong[k] = { id: e.id, t: e.t === 'miss' && /falls short/.test(e.o || '') ? 'short' : e.t === 'hit' ? 'hit' : e.t === 'block' ? 'block' : 'other' };
      if (crossFromLong[k].t === 'short' && !sawShort[k]) { sawShort[k] = true; C.shortCounters.beatsWithShort++;
        const cs = ev.slice(idx + 1).filter((x) => x.k === v && x.t === 'hit' && / as a counter/.test(x.o || '') && !/walked onto/.test(x.o || ''));
        if (cs.length) { C.shortCounters.beatsCountered++; for (const x of cs) { C.shortCounters.n++; C.shortCounters.dmg += x.dmg; C.shortCounters.pts += x.pts; } countered = true; } } }
  });
  // the step in from Long
  for (const k of [0, 1]) for (let m = 0; m < 3; m++) { if (start[m] !== 3 || !stepsIn(k, m)) continue;
    const p = eff[k], how = p.lead && ACT[p.lead] ? 'throwing' : p.hl === 'high' ? 'high' : 'low';
    C.step.tries++; C.step[how]++; if (stepsIn(1 - k, m)) C.step.both++;
    const hits = ev.filter((e) => e.t === 'hit' && e.k === 1 - k && e.m != null && e.m >= m);
    if (!hits.length) { C.step.clean++; C.step.cleanBy[how]++; }
    else { if (hits.some((e) => e.m === m)) C.step.hitNow++; else C.step.hitLater++; C.step.by[hits[0].id]++; } }
  return crossFromLong;
}

function bouts(R, who, opp, n) { const { N, ACT, plan0, man, cost, resolve, endBeat } = R, rnd = R.rnd, mirror = opp === 'mirror';
  if (mirror) { if (!R.OPPS[3]) R.OPPS.push({ n: 'mirror', hp: N.hp, read: 0, like: [], lean: 0 }); R.setOpp(3); } else R.setOpp(opp);
  const C = blank(); C.n = n;
  const sensible = (S) => { const me = S.f[0], he = S.f[1], g0 = he.last || plan0(), guess = cost(g0) <= he.st ? g0 : { ...plan0(), hl: g0.hl, hr: g0.hr }; let best = plan0(), bv = -1e9;
    for (const c of R.plansFor(S, 0)) { if (c.clinch) continue; const T = { range: S.range, f: S.f.map((m) => ({ ...m, hist: [] })) }; resolve(T, [{ ...c }, { ...guess, clinch: false }]);
      const v = (he.hp - T.f[1].hp) - (me.hp - T.f[0].hp) + 0.25 * T.f[0].st + rnd() * 0.5; if (v > bv) { bv = v; best = c; } }
    return best; };
  const useOf = (c) => { if (c.clinch) return; if (c.lead === 'jab') C.use.jab++; if (c.lead === 'bjab') C.use.bjab++; if (c.rear === 'cross') C.use.cross++; if (c.rear === 'rbody') C.use.rbody++; if (c.feet === 'in') C.use.stepIn++; if (!c.lead && c.hl === 'high') C.use.leadHigh++; };
  for (let b = 0; b < n; b++) { const S = { f: [man(N.hp), man(R.opp().hp)], range: 3 }; let done = false; const t = [0, 0];
    for (let r = 0; r < N.rounds && !done; r++) { S.range = 3; for (const m of S.f) { m.pts = 0; m.st = m.cap; m.g = N.guard; m.ropes = 0; m.held = 0; m.kept = 0; m.gave = 0; }
      const rd = { longPts: [0, 0] }; let prev = [null, null];
      for (let i = 0; i < N.beats && !done; i++) { S.t = N.beats - i; let mine, his;
        if (who === 'mix') { const z = R.solveBeat(S, S.t, { iters: 400 }); mine = z.A[drawAt(z.p, rnd)]; his = mirror ? z.B[drawAt(z.q, rnd)] : null; }
        else if (who === 'random') { const A = R.plansFor(S, 0); mine = A[Math.floor(rnd() * A.length)]; } else mine = sensible(S);
        if (!his) his = R.ai(S);
        useOf(mine); useOf(his);
        const r0 = S.range, eff = [mine, his].map((p, k) => (S.f[k].kept && p.feet === 'in' ? { ...p, feet: 'hold' } : { ...p }));
        const ev = resolve(S, [{ ...mine }, { ...his }]); endBeat(S); C.beats++; C.rng[S.range]++;
        const cf = countBeat(R, C, r0, eff, ev, rd);
        // the lazy plan: the same man, a cross from Long in two Long beats running
        for (const k of [0, 1]) { const now = r0 === 3 ? cf[k] : null;
          if (now && prev[k]) { const L = C.lazy.rear; L.second++; L[now.t]++; if (now.id === 'cross' && prev[k].id === 'cross') { C.lazy.cross.second++; C.lazy.cross[now.t]++; } }
          prev[k] = now; }
        for (const k of [0, 1]) if (S.f[k].hp <= 0) { S.f[k].kd++; C.kd[k]++; S.f[1 - k].pts += 3; if (S.f[k].kd > N.kd.length) { if (k === 1) { C.w++; C.ko++; } else C.lost++; done = true; break; } S.f[k].hp = N.kd[S.f[k].kd - 1]; } }
      if (!done) { const [x, y] = S.f, lvl = x.pts === y.pts, g = lvl && N.even ? Math.sign((y.gave || 0) - (x.gave || 0)) : 0;
        C.rounds.scored++; if (lvl) C.rounds.level++; else { C.rounds.decided++; const wk = x.pts > y.pts ? 0 : 1; if (rd.longPts[wk] > S.f[1 - wk].pts) C.rounds.longWins++; }
        t[0] += x.pts > y.pts || (lvl && g >= 0) ? 10 : 9; t[1] += y.pts > x.pts || (lvl && g <= 0) ? 10 : 9; } }
    if (!done) { if (t[0] > t[1]) C.w++; else if (t[0] === t[1]) C.draw++; } }
  return C; }
const drawAt = (mix, rnd) => { let x = rnd(), i = 0; while (i < mix.length - 1 && (x -= mix[i]) > 0) i++; return i; };
const merge = (a, b) => { if (!a) return b; for (const k in b) { if (typeof b[k] === 'number') a[k] = (a[k] || 0) + b[k]; else if (Array.isArray(b[k]) && typeof b[k][0] === 'number') b[k].forEach((x, i) => { a[k][i] += x; }); else a[k] = merge(a[k] || {}, b[k]); } return a; };
if (!isMainThread && workerData && workerData.long2) { const { tweak, table, who, opp, n, seed } = workerData; parentPort.postMessage(bouts(loadTweaked(seed, tweak, table), who, opp, n)); }
export async function count(who, opp, n, o = {}) { const jobs = o.jobs || 7, self = fileURLToPath(import.meta.url), each = Math.ceil(n / jobs);
  const got = await Promise.all(Array.from({ length: jobs }, (_, i) => new Promise((ok, bad) => { const w = new Worker(self, { workerData: { long2: 1, tweak: o.tweak || null, table: o.table, who, opp, n: each, seed: (o.seed || 1) * 100 + i } }); w.once('message', ok); w.once('error', bad); })));
  return got.reduce(merge, null); }

export function longReport(C) { const pc = (x) => (Number.isFinite(x) ? (100 * x).toFixed(0) + '%' : '-'), a = (x) => (x / C.n).toFixed(2), L = [], LB = C.longBeats, MB = 2 * LB;
  const NM = { jab: 'Jab', bjab: 'Body jab', hook: 'Lead hook', lup: 'Lead uppercut', lbody: 'Body hook', cross: 'Cross', over: 'Overhand', rup: 'Rear uppercut', rbody: 'Body cross' };
  const stop = (C.ko + C.lost) / C.n;
  L.push(`SAME BOUTS CHECK (compare with balance.mjs play): ${C.n} bouts, wins ${pc(C.w / C.n)}, draws ${pc(C.draw / C.n)}, stoppages ${pc(stop)}, knockdowns a bout ${((C.kd[0] + C.kd[1]) / C.n).toFixed(1)}, beats ${C.beats}, Inside / Mid / Long ${[1, 2, 3].map((r) => pc(C.rng[r] / C.beats)).join(' / ')} (range at the END of a beat, as balance counts it)`);
  L.push(`USE (a man a beat): Jab ${pc(C.use.jab / (2 * C.beats))}, Body jab ${pc(C.use.bjab / (2 * C.beats))}, Cross ${pc(C.use.cross / (2 * C.beats))}, Body cross ${pc(C.use.rbody / (2 * C.beats))}, step in ${pc(C.use.stepIn / (2 * C.beats))}, lead held high ${pc(C.use.leadHigh / (2 * C.beats))}`);
  L.push(`LONG BEATS (the beat STARTS at Long): ${a(LB)} a bout = ${pc(LB / C.beats)} of beats; no punch thrown by either man ${pc(C.longNoPunch / LB)}; nothing at all (no punch, feint, push or step) ${pc(C.longNothing / LB)}`);
  for (const [id, nm] of [['cross', 'CROSS'], ['rbody', 'BODY CROSS']]) { const q = C[id];
    L.push(`${nm} FROM LONG: thrown ${a(q.thrown)} a bout = ${pc(q.thrown / MB)} of a man's Long beats; landed ${pc(q.hit / q.thrown)} (on a man stepping in that moment ${pc(q.hitStep / q.thrown)}, ${a(q.dmgStep)} health ${a(q.ptsStep)} points a bout); blocked ${pc(q.block / q.thrown)} (of them on a man stepping in ${pc(q.blockStep / Math.max(q.block, 1))}); fell short (he did not come) ${pc(q.short / q.thrown)}; other ${pc(q.other / q.thrown)}`); }
  const X = { thrown: C.cross.thrown + C.rbody.thrown, hit: C.cross.hit + C.rbody.hit };
  L.push(`REAR HAND AT LONG (cross + body cross): thrown in ${pc(X.thrown / MB)} of a man's Long beats, landing ${pc(X.hit / X.thrown)}  [bar 5-15%, 30-65%]`);
  const s = C.shortCounters; L.push(`OFF THE SHORT CROSS: ${a(s.beatsWithShort)} a bout; he counters in ${pc(s.beatsCountered / Math.max(s.beatsWithShort, 1))} of them: ${a(s.n)} counters a bout, ${a(s.dmg)} health, ${a(s.pts)} points`);
  for (const [id, nm] of [['jab', 'JAB'], ['bjab', 'BODY JAB']]) { const q = C[id];
    L.push(`${nm} FROM LONG: thrown ${a(q.thrown)} a bout = ${pc(q.thrown / MB)} of a man's Long beats; landed ${pc(q.hit / q.thrown)}; on a man stepping in ${pc(q.hitStep / q.thrown)} (${a(q.hitStep)} a bout, ${a(q.ptsStep)} points); blocked ${pc(q.block / q.thrown)}`); }
  const st = C.step; L.push(`STEP IN FROM LONG: ${a(st.tries)} a bout (both at once ${pc(st.both / Math.max(st.tries, 1))}); lead held high ${pc(st.high / st.tries)}, low ${pc(st.low / st.tries)}, throwing ${pc(st.throwing / st.tries)}; got in unhit ${pc(st.clean / st.tries)} (behind a high lead ${pc(st.cleanBy.high / Math.max(st.high, 1))}, low ${pc(st.cleanBy.low / Math.max(st.low, 1))}, throwing ${pc(st.cleanBy.throwing / Math.max(st.throwing, 1))}); hit in the step's moment ${pc(st.hitNow / st.tries)}, later in the beat ${pc(st.hitLater / st.tries)}; hit by ${PUN.filter((id) => st.by[id]).sort((x, y) => st.by[y] - st.by[x]).map((id) => `${NM[id]} ${pc(st.by[id] / (st.hitNow + st.hitLater))}`).join(', ')}  [bar 60%+ unhit]`);
  const tp = PUN.reduce((z, id) => z + C.fromLong.pts[id], 0), td = PUN.reduce((z, id) => z + C.fromLong.dmg[id], 0);
  L.push(`FROM LONG A BOUT: ${a(tp)} points, ${a(td)} health; by punch (points / health): ${PUN.filter((id) => C.fromLong.pts[id] || C.fromLong.dmg[id]).map((id) => `${NM[id]} ${a(C.fromLong.pts[id])} / ${a(C.fromLong.dmg[id])}`).join(', ')}`);
  L.push(`ROUNDS: ${C.rounds.scored} scored, level on points ${pc(C.rounds.level / C.rounds.scored)}; won on points by the man whose points from Long beat his opponent's whole round: ${C.rounds.longWins} = ${pc(C.rounds.longWins / Math.max(C.rounds.decided, 1))} of decided rounds`);
  const lz = C.lazy; L.push(`LAZY PLAN: a second cross from Long in a row (same man, two Long beats running) in ${pc(lz.cross.second / LB)} of Long beats, landing ${pc(lz.cross.hit / lz.cross.second)} / blocked ${pc(lz.cross.block / lz.cross.second)} / short ${pc(lz.cross.short / lz.cross.second)}; any rear cross (head or body) ${pc(lz.rear.second / LB)}, landing ${pc(lz.rear.hit / lz.rear.second)}, short ${pc(lz.rear.short / lz.rear.second)}  [bar under 40% landing]`);
  return L.join('\n'); }

const isMain = isMainThread && import.meta.url === pathToFileURL(process.argv[1] || '').href;
if (isMain) { const arg = (k, d) => { const x = process.argv.find((y) => y.startsWith(k + '=')); return x ? x.split('=').slice(1).join('=') : d; };
  const tweak = readTweak(arg('tweak', '')), table = arg('table', '') || undefined, n = Number(arg('n', 84)), jobs = Number(arg('jobs', 2)), seed = Number(arg('seed', 1)), who = arg('who', 'mix'), op = arg('opp', 'mirror');
  const t0 = Date.now(), C = await count(who, op === 'mirror' ? op : Number(op), n, { tweak, table, jobs, seed });
  console.log(`LONG2_COUNT who=${who} opp=${op} n=${n} seed=${seed} jobs=${jobs} tweak=${arg('tweak', 'none')} table=${table || 'the page\'s'}`);
  console.log(longReport(C)); console.log(`  (${C.n} bouts, ${((Date.now() - t0) / 1000).toFixed(0)} s)`);
  if (arg('json', '')) fs.writeFileSync(arg('json', ''), JSON.stringify(C)); }
