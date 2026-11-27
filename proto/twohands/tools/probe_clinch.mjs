// IS THE CLINCH A HABIT THAT WINS? (S558, the all-agents playtest.) Antigravity went 3-0 on one loop: from Mid "step in,
// feint, cross (or overhand)", and on the next beat, Inside, "clinch" (+2 stamina, no punch lands, back to Mid) - 14
// clinches in 51 beats, none shoved off by the Slugger. Dola clinched 11 times in 54 beats. Ziva lost ten stamina to HIS
// clinches. The balance bars only see the solved mix (1.2 to 1.5 clinches a bout).
// Two fixed players against each of the three men: the LOOP as Antigravity played it, and the same man who never clinches
// (Inside he throws the lead hook behind a high rear hand). If the loop wins clearly more, the clinch pays too well.
// FEINTFIX2 (S567): a third bot, "feint cross" - the same loop shape with the cross in the overhand's place (the league's
// "feint then cross ... nothing answers it except backing off"), and who=<comma list> to run a subset. Without who= the
// run is the old two bots, unchanged. The pairings now run on worker threads (each bout's seed is fixed by its index, so
// the lines are the same either way); jobs= picks the workers, default 2.
//   node proto/twohands/tools/probe_clinch.mjs [n=60] [tweak=<f.json>] [table=<vtable.json>] [who=loop,no clinch,feint cross] [jobs=2]
import { Worker, isMainThread, parentPort, workerData } from 'node:worker_threads';
import { fileURLToPath } from 'node:url';
import { loadTweaked, readTweak } from './balance.mjs';

const arg = (k, d) => { const a = process.argv.find((x) => x.startsWith(k + '=')); return a ? a.split('=').slice(1).join('=') : d; };
const pc = (x, y) => (y ? (100 * x / y).toFixed(0) + '%' : '-');

// one pairing: who (the fixed player) against one of the three men, n bouts, every bout seeded 3000 + b * 7 + opp
function pairing(who, opp, n, tweak, table) {
  const o = { w: 0, l: 0, d: 0, tries: 0, tied: 0, his: 0, beats: 0 };
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
  return { who, opp, o }; }

if (!isMainThread && workerData && workerData.clinchPair) { const { n, tweak, table, chunk } = workerData; parentPort.postMessage(chunk.map(([who, opp]) => pairing(who, opp, n, tweak, table))); }

const isMain = isMainThread && process.argv[1] && /probe_clinch\.mjs$/.test(process.argv[1]);
if (isMain) {
  const n = Number(arg('n', 60)), tweak = readTweak(arg('tweak', '')), table = arg('table', '') || undefined, jobs = Number(arg('jobs', 2));
  const WHOS = arg('who', '').split(',').map((s) => s.trim()).filter(Boolean);
  const pairs = []; for (const who of (WHOS.length ? WHOS : ['loop', 'no clinch'])) for (const opp of [0, 1, 2]) pairs.push([who, opp]);
  const parts = Array.from({ length: Math.max(1, Math.min(jobs, pairs.length)) }, () => []); pairs.forEach((p, i) => parts[i % parts.length].push(p));
  const self = fileURLToPath(import.meta.url);
  const got = await Promise.all(parts.map((chunk) => new Promise((ok, bad) => {
    const w = new Worker(self, { workerData: { clinchPair: 1, n, tweak, table, chunk } });
    w.once('message', (msgs) => ok(msgs)); w.once('error', bad);
  })));
  /* the workers each return their chunk of [who, opp, o] results; print them in the original pairing order */
  const byKey = new Map(); for (const msgs of got) for (const m of msgs) byKey.set(m.who + '|' + m.opp, m);
  const names = {}; for (const [, opp] of pairs) if (names[opp] == null) names[opp] = loadTweaked(1, tweak, table).OPPS[opp].n;
  for (const [who, opp] of pairs) { const { o } = byKey.get(who + '|' + opp);
    console.log(`CLINCH ${who} v ${names[opp]}: wins ${pc(o.w, n)}, loses ${pc(o.l, n)}, draws ${pc(o.d, n)} | his clinches a bout ${(o.his / n).toFixed(1)}${who !== 'no clinch' ? ` | my clinches a bout ${(o.tries / n).toFixed(1)}, ${pc(o.tied, o.tries)} of them tie him up` : ''}`); }
}
