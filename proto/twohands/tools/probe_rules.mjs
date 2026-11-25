// RING SWITCHES: how the rules play, measured on the page's own rules (rules.mjs). A sensible player (he answers what
// the man did last beat, trying every plan he can pay for), the same man off 1 beat in 4, and random switches, against
// each of the three opponents; what the sensible player throws; how a bout ends.
//   node proto/twohands/tools/probe_rules.mjs [n=400] [seed=1]
import { load } from './rules.mjs';
const arg = (k, d) => { const a = process.argv.find((x) => x.startsWith(k + '=')); return a ? Number(a.split('=')[1]) : d; };
const n = arg('n', 400), seed = arg('seed', 1);
const R = load(seed), { N, ACT, LO, RO, plan0, man, cost, resolve, endBeat, ai, OPPS } = R, rnd = R.rnd;
const pickOne = (a) => a[Math.floor(rnd() * a.length)];
const NOORDER = process.argv.includes('noorder');   // the same player, but he never chooses an order (feet, lead, rear every time)

function human(S, eps) { const me = S.f[0], he = S.f[1], g0 = he.last || plan0(), guess = cost(g0) <= he.st ? g0 : { ...plan0(), hl: g0.hl, hr: g0.hr }; let best = plan0(), bv = -1e9; const all = [];
  for (const lo of LO) for (const ro of RO) for (const feet of ['in', 'hold', 'back']) {
    const c0 = { ...lo, ...ro, feet, clinch: false, ord: [] }; if (cost(c0) > me.st || (feet === 'back' && me.ropes >= 2) || (R.legal && !R.legal(S, 0, c0))) continue;
    for (const ord of (NOORDER ? [R.ordOf(c0)] : R.perms(R.ordOf(c0)))) { const c = { ...c0, ord }; all.push(c);   // S555: the order of actions is his choice too
      const T = { range: S.range, f: S.f.map((m) => ({ ...m, hist: [] })) }; resolve(T, [{ ...c }, { ...guess, clinch: false }]);
      const v = (he.hp - T.f[1].hp) - (me.hp - T.f[0].hp) + 0.25 * T.f[0].st + rnd() * 0.5; if (v > bv) { bv = v; best = c; } } }
  return rnd() < eps && all.length ? pickOne(all) : best; }

function bouts(eps, count) { const o = { w: 0, ko: 0, lostKo: 0, beats: 0, use: {}, plans: 0, ev: {}, rangeBeats: [0, 0, 0, 0] };
  for (let b = 0; b < count; b++) { const S = { f: [man(N.hp), man(R.opp().hp)], range: 3 }; let done = false; const t = [0, 0];
    for (let r = 0; r < N.rounds && !done; r++) { S.range = 3; for (const m of S.f) { m.pts = 0; m.st = m.cap; m.g = N.guard; m.ropes = 0; m.held = 0; m.kept = 0; }
      for (let i = 0; i < N.beats && !done; i++) { const mine = human(S, eps); o.plans++; if (mine.ord && mine.ord.length > 1) { o.ordered = (o.ordered || 0) + 1; const kx = mine.ord.join('>'); o.ords = o.ords || {}; o.ords[kx] = (o.ords[kx] || 0) + 1; } for (const x of [mine.lead, mine.rear, mine.feet !== 'hold' && mine.feet, mine.clinch && 'clinch']) if (x) o.use[x] = (o.use[x] || 0) + 1;
        const ev = resolve(S, [mine, ai(S)]); endBeat(S); o.beats++; o.rangeBeats[S.range]++;
        for (const e of ev) { const key = (e.k === 0 ? 'you ' : e.k === 1 ? 'he ' : '') + e.t + (e.note ? ' ' + e.note : ''); o.ev[key] = (o.ev[key] || 0) + 1; }
        for (const k of [0, 1]) if (S.f[k].hp <= 0) { S.f[k].kd++; S.f[1 - k].pts += 3; if (S.f[k].kd > N.kd.length) { if (k === 1) o.w++; else o.lostKo++; o.ko++; done = true; break; } S.f[k].hp = N.kd[S.f[k].kd - 1]; } }
      if (!done) { const [x, y] = S.f; t[0] += x.pts >= y.pts ? 10 : 9; t[1] += y.pts >= x.pts ? 10 : 9; } }
    if (!done && t[0] > t[1]) o.w++; }
  return o; }

const pc = (x) => (100 * x).toFixed(0).padStart(3) + '%';
console.log(`PROBE_RULES n=${n} a man, seed ${seed}; opponents: ${OPPS.map((o) => o.n).join(', ')}`);
for (const [eps, name] of [[0, 'sensible player      '], [0.25, 'sensible, 1 in 4 off '], [1, 'random switches      ']]) {
  const r = OPPS.map((_, i) => { R.setOpp(i); return bouts(eps, n); });
  console.log(name, 'wins', r.map((x) => pc(x.w / n)).join(' '), '| stopped him', r.map((x) => pc((x.ko - x.lostKo) / n)).join(' '), '| stopped', r.map((x) => pc(x.lostKo / n)).join(' '), '| beats', r.map((x) => (x.beats / n).toFixed(1)).join(' '));
  if (eps === 0.25) { for (let i = 0; i < 3; i++) { const x = r[i]; console.log(`   v ${OPPS[i].n}: a beat he uses`, Object.entries(x.use).sort((a, b) => b[1] - a[1]).map(([k, v]) => `${k} ${pc(v / x.plans).trim()}`).join(', '));
      console.log(`      his order, of the beats with two or more actions:`, Object.entries(x.ords || {}).sort((a, b) => b[1] - a[1]).map(([k, v]) => `${k} ${pc(v / x.ordered).trim()}`).join(', '));
      console.log(`      beats at Inside/Mid/Long ${[1, 2, 3].map((q) => pc(x.rangeBeats[q] / x.beats).trim()).join(' / ')}; events a bout:`, Object.entries(x.ev).sort((a, b) => b[1] - a[1]).map(([k, v]) => `${k} ${(v / n).toFixed(1)}`).join(', ')); } } }
