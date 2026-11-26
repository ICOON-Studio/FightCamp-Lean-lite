// IS THE CLINCH A HABIT THAT WINS? (S558, the all-agents playtest.) Antigravity went 3-0 on one loop: from Mid "step in,
// feint, cross (or overhand)", and on the next beat, Inside, "clinch" (+2 stamina, no punch lands, back to Mid) - 14
// clinches in 51 beats, none shoved off by the Slugger. Dola clinched 11 times in 54 beats. Ziva lost ten stamina to HIS
// clinches. The balance bars only see the solved mix (1.2 to 1.5 clinches a bout).
// Two fixed players against each of the three men: the LOOP as Antigravity played it, and the same man who never clinches
// (Inside he throws the lead hook behind a high rear hand). If the loop wins clearly more, the clinch pays too well.
// FEINTFIX2 (S567): a third bot, "feint cross" - the same loop shape with the cross in the overhand's place (the league's
// "feint then cross ... nothing answers it except backing off"), and who=<list> to run a subset. Without who= the run is
// the old two bots, unchanged.
//   node proto/twohands/tools/probe_clinch.mjs [n=60] [tweak=<f.json>] [table=<vtable.json>] [who=loop|no clinch|feint cross]
import { loadTweaked, readTweak } from './balance.mjs';

const arg = (k, d) => { const a = process.argv.find((x) => x.startsWith(k + '=')); return a ? a.split('=').slice(1).join('=') : d; }, n = Number(arg('n', 60)), tweak = readTweak(arg('tweak', '')), table = arg('table', '') || undefined;
const pc = (x, y) => (y ? (100 * x / y).toFixed(0) + '%' : '-');
const WHOS = arg('who', '').split(',').map((s) => s.trim()).filter(Boolean);
for (const who of (WHOS.length ? WHOS : ['loop', 'no clinch'])) for (const opp of [0, 1, 2]) { const o = { w: 0, l: 0, d: 0, tries: 0, tied: 0, his: 0, beats: 0 };
  for (let b = 0; b < n; b++) { const R = loadTweaked(3000 + b * 7 + opp, tweak, table), { N, plan0, man, cost, resolve, endBeat } = R; R.setOpp(opp);
    const S = { f: [man(N.hp), man(R.opp().hp)], range: 3 }, t = [0, 0]; let done = false;
    const pay = (p) => (cost(p) <= S.f[0].st ? p : null);
    const mine = () => { const me = S.f[0], P = (o2) => ({ ...plan0(), ...o2 });
      if (S.range === 1) { if (who !== 'no clinch' && !me.held && me.st >= 1) return P({ clinch: true }); return pay(P({ lead: 'hook', hr: 'high', ord: ['lead'] })) || P({}); }
      const step = S.range === 3 || !me.kept ? (me.kept ? 'hold' : 'in') : 'hold', ord = step === 'in' ? ['feet', 'lead', 'rear'] : ['lead', 'rear'];
      const rear = (id) => pay(P({ feet: step, lead: 'feint', rear: id, ord }));   /* FEINTFIX2: 'feint cross' lives on the cross, never falls back to the overhand */
      return (who === 'feint cross' ? rear('cross') : rear('over') || rear('cross')) || pay(P({ lead: 'hook', hr: 'high', ord: ['lead'] })) || P({}); };
    for (let r = 0; r < N.rounds && !done; r++) { S.range = 3; for (const m of S.f) { m.pts = 0; m.st = m.cap; m.g = N.guard; m.ropes = 0; m.held = 0; m.kept = 0; m.gave = 0; }
      for (let i = 0; i < N.beats && !done; i++) { S.t = N.beats - i; const a = mine(), his = R.ai(S) || plan0(); o.beats++; if (a.clinch) o.tries++; if (his.clinch) o.his++;
        const ev = resolve(S, [{ ...a }, { ...his }]); endBeat(S); if (a.clinch && ev.some((e) => e.k === 0 && e.t === 'clinch')) o.tied++;
        for (const j of [0, 1]) if (S.f[j].hp <= 0) { S.f[j].kd++; S.f[1 - j].pts += 3; if (S.f[j].kd > N.kd.length) { if (j === 1) o.w++; else o.l++; done = true; break; } S.f[j].hp = N.kd[S.f[j].kd - 1]; } }
      if (!done) { const { sc } = R.judge(S.f[0], S.f[1]); t[0] += sc[0]; t[1] += sc[1]; } }
    if (!done) { if (t[0] > t[1]) o.w++; else if (t[0] < t[1]) o.l++; else o.d++; } }
  console.log(`CLINCH ${who} v ${loadTweaked(1, tweak, table).OPPS[opp].n}: wins ${pc(o.w, n)}, loses ${pc(o.l, n)}, draws ${pc(o.d, n)} | his clinches a bout ${(o.his / n).toFixed(1)}${who !== 'no clinch' ? ` | my clinches a bout ${(o.tries / n).toFixed(1)}, ${pc(o.tied, o.tries)} of them tie him up` : ''}`); }
