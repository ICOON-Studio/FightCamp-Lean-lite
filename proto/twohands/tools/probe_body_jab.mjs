// S554 PROBE (nothing on the page): would a BODY JAB give Long range a guess? At Long only the jab reaches and one hold
// stops it (the lead hand high), so a man walks in behind it for free. A body jab reaches Long too and is stopped by the
// lead hand LOW: the same hand cannot stop both. Here the rules are the page's own (rules.mjs) with one punch added in
// memory, the opponents throw it in place of some of their jabs (more often at a lead hand they last saw held high), and
// the sensible player may throw it too.
//   node proto/twohands/tools/probe_body_jab.mjs [n=400] [seed=1]
import { load } from './rules.mjs';
const arg = (k, d) => { const a = process.argv.find((x) => x.startsWith(k + '=')); return a ? Number(a.split('=')[1]) : d; };
const n = arg('n', 400), seed = arg('seed', 1);

function run(withBody, keep) { const R = load(seed), { N, ACT, LO, plan0, man, cost, resolve, endBeat, OPPS } = R, rnd = R.rnd; N.keep = keep;
  if (withBody) { ACT.bjab = { n: 'Body jab', h: 0, st: 1, d: 1, sp: 1, reach: [2, 3], line: 'body', keep: 1, pic: 'jab' }; LO.push({ lead: 'bjab', hl: 'high' }); }
  const ai = (S) => { const p = R.ai(S); if (!withBody || p.lead !== 'jab') return p; const l = S.f[0].last || plan0(), q = l.lead ? 0.35 : l.hl === 'high' ? 0.6 : 0.15; return rnd() < q ? { ...p, lead: 'bjab' } : p; };
  const human = (S) => { const me = S.f[0], he = S.f[1], g0 = he.last || plan0(), guess = cost(g0) <= he.st ? g0 : { ...plan0(), hl: g0.hl, hr: g0.hr }; let best = plan0(), bv = -1e9;
    for (const lo of LO) for (const ro of R.RO) for (const feet of ['in', 'hold', 'back']) { const c = { ...lo, ...ro, feet, clinch: false }; if (cost(c) > me.st || (feet === 'back' && me.ropes >= 2) || (feet === 'in' && me.kept)) continue;
      const T = { range: S.range, f: S.f.map((m) => ({ ...m, hist: [] })) }; resolve(T, [c, { ...guess, clinch: false }]);
      const v = (he.hp - T.f[1].hp) - (me.hp - T.f[0].hp) + 0.25 * T.f[0].st + rnd() * 0.5; if (v > bv) { bv = v; best = c; } }
    return best; };
  const out = [];
  for (let oi = 0; oi < OPPS.length; oi++) { R.setOpp(oi); let w = 0, long = 0, beats = 0, kept = 0, jabs = 0, plans = 0, stops = 0;
    for (let b = 0; b < n; b++) { const S = { f: [man(N.hp), man(R.opp().hp)], range: 3 }; let done = false; const t = [0, 0];
      for (let r = 0; r < N.rounds && !done; r++) { S.range = 3; for (const m of S.f) { m.pts = 0; m.st = m.cap; m.g = N.guard; m.ropes = 0; m.held = 0; m.kept = 0; }
        for (let i = 0; i < N.beats && !done; i++) { const mine = human(S); plans++; if (mine.lead === 'jab' || mine.lead === 'bjab') jabs++;
          resolve(S, [mine, ai(S)]); endBeat(S); beats++; if (S.range === 3) long++; kept += S.f[0].kept;
          for (const k of [0, 1]) if (S.f[k].hp <= 0) { S.f[k].kd++; S.f[1 - k].pts += 3; if (S.f[k].kd > N.kd.length) { if (k === 1) w++; stops++; done = true; break; } S.f[k].hp = N.kd[S.f[k].kd - 1]; } }
        if (!done) { const [x, y] = S.f; t[0] += x.pts >= y.pts ? 10 : 9; t[1] += y.pts >= x.pts ? 10 : 9; } }
      if (!done && t[0] > t[1]) w++; }
    out.push({ w: w / n, long: long / beats, kept: kept / n, jabs: jabs / plans, stops: stops / n }); }
  return out; }
const pc = (x) => (100 * x).toFixed(0).padStart(3) + '%';
console.log(`PROBE_BODY_JAB n=${n} seed ${seed}: the sensible player against the Jabber, the Slugger, the Body Snatcher`);
for (const [name, wb, keep] of [['today (jab keeps out)        ', 0, 1], ['+ a body jab that reaches Long', 1, 1], ['body jab, no keep-out rule    ', 1, 0]]) { const r = run(wb, keep);
  console.log(`${name}: he wins ${r.map((x) => pc(x.w)).join(' ')} | beats at Long ${r.map((x) => pc(x.long)).join(' ')} | beats HE is kept out, a bout ${r.map((x) => x.kept.toFixed(1)).join(' ')} | he throws a jab in ${r.map((x) => pc(x.jabs)).join(' ')} of beats | stoppages ${r.map((x) => pc(x.stops)).join(' ')}`); }
