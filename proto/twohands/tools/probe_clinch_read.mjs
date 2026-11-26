// IS THE CLINCH A HABIT THAT WINS? (S558, the all-agents playtest.) - CLINCHFIX3 read-count copy of probe_clinch.mjs.
// IDENTICAL to probe_clinch.mjs except it counts when the opponent's habit read fires on a beat (his plan carries
// readOf, order.html S563) and prints it a bout, so the mechanism behind a loop change can be reported with a number.
//   node proto/twohands/tools/probe_clinch_read.mjs [n=60] [tweak=<f.json>] [table=<vtable.json>]
import { loadTweaked, readTweak } from './balance.mjs';

const arg = (k, d) => { const a = process.argv.find((x) => x.startsWith(k + '=')); return a ? a.split('=').slice(1).join('=') : d; }, n = Number(arg('n', 60)), tweak = readTweak(arg('tweak', '')), table = arg('table', '') || undefined;
const pc = (x, y) => (y ? (100 * x / y).toFixed(0) + '%' : '-');
for (const who of ['loop', 'no clinch']) for (const opp of [0, 1, 2]) { const o = { w: 0, l: 0, d: 0, tries: 0, tied: 0, his: 0, beats: 0, reads: 0 };
  for (let b = 0; b < n; b++) { const R = loadTweaked(3000 + b * 7 + opp, tweak, table), { N, plan0, man, cost, resolve, endBeat } = R; R.setOpp(opp);
    const S = { f: [man(N.hp), man(R.opp().hp)], range: 3 }, t = [0, 0]; let done = false;
    const pay = (p) => (cost(p) <= S.f[0].st ? p : null);
    const mine = () => { const me = S.f[0], P = (o2) => ({ ...plan0(), ...o2 });
      if (S.range === 1) { if (who === 'loop' && !me.held && me.st >= 1) return P({ clinch: true }); return pay(P({ lead: 'hook', hr: 'high', ord: ['lead'] })) || P({}); }
      const step = S.range === 3 || !me.kept ? (me.kept ? 'hold' : 'in') : 'hold', ord = step === 'in' ? ['feet', 'lead', 'rear'] : ['lead', 'rear'];
      return pay(P({ feet: step, lead: 'feint', rear: 'over', ord })) || pay(P({ feet: step, lead: 'feint', rear: 'cross', ord })) || pay(P({ lead: 'hook', hr: 'high', ord: ['lead'] })) || P({}); };
    for (let r = 0; r < N.rounds && !done; r++) { S.range = 3; for (const m of S.f) { m.pts = 0; m.st = m.cap; m.g = N.guard; m.ropes = 0; m.held = 0; m.kept = 0; m.gave = 0; }
      for (let i = 0; i < N.beats && !done; i++) { S.t = N.beats - i; const a = mine(), his = R.ai(S) || plan0(); if (his.readOf) o.reads++; o.beats++; if (a.clinch) o.tries++; if (his.clinch) o.his++;
        const ev = resolve(S, [{ ...a }, { ...his }]); endBeat(S); if (a.clinch && ev.some((e) => e.k === 0 && e.t === 'clinch')) o.tied++;
        for (const j of [0, 1]) if (S.f[j].hp <= 0) { S.f[j].kd++; S.f[1 - j].pts += 3; if (S.f[j].kd > N.kd.length) { if (j === 1) o.w++; else o.l++; done = true; break; } S.f[j].hp = N.kd[S.f[j].kd - 1]; } }
      if (!done) { const { sc } = R.judge(S.f[0], S.f[1]); t[0] += sc[0]; t[1] += sc[1]; } }
    if (!done) { if (t[0] > t[1]) o.w++; else if (t[0] < t[1]) o.l++; else o.d++; } }
  console.log(`CLINCH ${who} v ${loadTweaked(1, tweak, table).OPPS[opp].n}: wins ${pc(o.w, n)}, loses ${pc(o.l, n)}, draws ${pc(o.d, n)} | his clinches a bout ${(o.his / n).toFixed(1)}${who === 'loop' ? ` | my clinches a bout ${(o.tries / n).toFixed(1)}, ${pc(o.tied, o.tries)} of them tie him up` : ''} | his habit read fired ${(o.reads / n).toFixed(1)} a bout`); }
