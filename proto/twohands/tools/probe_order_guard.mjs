// S555 PROBE (nothing on the page): WHEN DOES A PUNCHING HAND GUARD? The owner, on the order page: "why his jab is blocked
// when i picked lead hook ?" - today a hand is out of its guard only in the moment it acts, so a hand that punches second
// still blocks in moment 1, for free, and the punch behind it is a counter. Four rules, on the page's own code (rules.mjs,
// the one guard line swapped): the sensible player (he answers the man's last beat, trying every plan AND every order)
// and the same player who never chooses an order, against the three opponents (who play by the same rule).
//   today  : out only in its own moment
//   loaded : out from the bell until it has thrown, back up after (a hand you mean to throw is not a guard yet)
//   spent  : up until it throws, out for the rest of the beat (a thrown hand does not get back in time)
//   never  : a hand with an action does not guard at all this beat (the version without order)
//   node proto/twohands/tools/probe_order_guard.mjs [n=300] [seed=1]
import { load } from './rules.mjs';
const arg = (k, d) => { const a = process.argv.find((x) => x.startsWith(k + '=')); return a ? Number(a.split('=')[1]) : d; };
const n = arg('n', 300), seed = arg('seed', 1);
const LINE = "if (act[k] !== 'lead') c[COVER[P[k].hl][0]] = 1; if (act[k] !== 'rear') c[COVER[P[k].hr][1]] = 1;";
const up = { today: (h) => `act[k] !== '${h}'`, loaded: (h) => `(!P[k].ord.includes('${h}') || P[k].ord.indexOf('${h}') < i)`,
  spent: (h) => `(!P[k].ord.includes('${h}') || P[k].ord.indexOf('${h}') > i)`, never: (h) => `!P[k].ord.includes('${h}')` };
const patch = (rule) => (src) => { if (!src.includes(LINE)) throw new Error('the guard line moved'); return src.replace(LINE, `if (${up[rule]('lead')}) c[COVER[P[k].hl][0]] = 1; if (${up[rule]('rear')}) c[COVER[P[k].hr][1]] = 1;`); };

function run(rule, noOrder) { const R = load(seed, 'order.html', patch(rule)), { N, LO, RO, plan0, man, cost, resolve, endBeat, ai, OPPS } = R, rnd = R.rnd, out = [];
  const human = (S) => { const me = S.f[0], he = S.f[1], g0 = he.last || plan0(), guess = cost(g0) <= he.st ? g0 : { ...plan0(), hl: g0.hl, hr: g0.hr }; let best = plan0(), bv = -1e9;
    for (const lo of LO) for (const ro of RO) for (const feet of ['in', 'hold', 'back']) { const c0 = { ...lo, ...ro, feet, clinch: false, ord: [] }; if (cost(c0) > me.st || (feet === 'back' && me.ropes >= 2)) continue;
      for (const ord of (noOrder ? [R.ordOf(c0)] : R.perms(R.ordOf(c0)))) { const c = { ...c0, ord }, T = { range: S.range, f: S.f.map((m) => ({ ...m, hist: [] })) }; resolve(T, [{ ...c }, { ...guess, clinch: false }]);
        const v = (he.hp - T.f[1].hp) - (me.hp - T.f[0].hp) + 0.25 * T.f[0].st + rnd() * 0.5; if (v > bv) { bv = v; best = c; } } }
    return best; };
  for (let oi = 0; oi < OPPS.length; oi++) { R.setOpp(oi); const o = { w: 0, ko: 0, lost: 0, two: 0, plans: 0, hold: 0, ev: {} };
    for (let b = 0; b < n; b++) { const S = { f: [man(N.hp), man(R.opp().hp)], range: 3 }; let done = false; const t = [0, 0];
      for (let r = 0; r < N.rounds && !done; r++) { S.range = 3; for (const m of S.f) { m.pts = 0; m.st = m.cap; m.g = N.guard; m.ropes = 0; m.held = 0; m.kept = 0; }
        for (let i = 0; i < N.beats && !done; i++) { const mine = human(S); o.plans++; if (mine.lead && mine.rear) o.two++; if (!mine.lead && !mine.rear) o.hold++;
          const ev = resolve(S, [mine, ai(S)]); endBeat(S); for (const e of ev) if (e.k >= 0) { const key = (e.k ? 'he ' : 'you ') + e.t; o.ev[key] = (o.ev[key] || 0) + 1; }
          for (const k of [0, 1]) if (S.f[k].hp <= 0) { S.f[k].kd++; S.f[1 - k].pts += 3; if (S.f[k].kd > N.kd.length) { if (k === 1) { o.w++; o.ko++; } else o.lost++; done = true; break; } S.f[k].hp = N.kd[S.f[k].kd - 1]; } }
        if (!done) { const [x, y] = S.f; t[0] += x.pts >= y.pts ? 10 : 9; t[1] += y.pts >= x.pts ? 10 : 9; } }
      if (!done && t[0] > t[1]) o.w++; }
    out.push(o); }
  return out; }
const pc = (x) => (100 * x).toFixed(0).padStart(3) + '%', per = (o, k) => ((o.ev[k] || 0) / n).toFixed(1).padStart(4);
console.log(`PROBE_ORDER_GUARD n=${n} seed ${seed}: the sensible player v the Jabber, the Slugger, the Body Snatcher`);
for (const rule of Object.keys(up)) { const a = run(rule, false), b = run(rule, true);
  console.log(`${rule.padEnd(7)}: wins ${a.map((x) => pc(x.w / n)).join(' ')} | with no order chosen ${b.map((x) => pc(x.w / n)).join(' ')} | he stops him ${a.map((x) => pc(x.ko / n)).join(' ')} | is stopped ${a.map((x) => pc(x.lost / n)).join(' ')}`);
  console.log(`         both hands thrown in ${a.map((x) => pc(x.two / x.plans)).join(' ')} of beats, no punch in ${a.map((x) => pc(x.hold / x.plans)).join(' ')} | a bout: his punches blocked ${a.map((x) => per(x, 'he block')).join(' ')}, landed ${a.map((x) => per(x, 'he hit')).join(' ')}; yours blocked ${a.map((x) => per(x, 'you block')).join(' ')}, landed ${a.map((x) => per(x, 'you hit')).join(' ')}`); }
