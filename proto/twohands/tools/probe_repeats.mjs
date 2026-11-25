// DOES A MAN PLAY THE IDENTICAL BEAT THREE TIMES RUNNING, AND WHY? (S557, Ziva's playtest: "the Slugger played the
// identical beat three times running ... the memory of one beat is worth more than any read of the man".)
// The page's opponent chooses a beat one of three ways: he READS a habit of yours and answers it, he plays a PLAIN beat of
// his style, or he plays the solved MIX. This tags each beat with the way it was chosen (a source patch, the page is not
// touched) and counts, against a player who repeats one plan (Ziva's bout 7) and one who answers his last beat:
// how often his beat is the same as his last one, by the way it was chosen, and how the bouts end.
//   node proto/twohands/tools/probe_repeats.mjs [n=40] [vary=1]     vary=1: when he reads a habit he takes any answer within 0.5 health of the best
import { loadTweaked } from './balance.mjs';

const arg = (k, d) => { const a = process.argv.find((x) => x.startsWith(k + '=')); return a ? a.split('=')[1] : d; }, n = Number(arg('n', 40)), vary = arg('vary', '0') === '1';
const src = [
  ['return best; }\n  // HIS SKILL', "return { ...best, via: 'read' }; }\n  // HIS SKILL"],
  ['return pickOne(own.length ? own : all); }', "return { ...pickOne(own.length ? own : all), via: 'plain' }; }"],
  ['const r = solveBeat(S, t, { lean1: lean, iters: 400 }); return r.B[drawFrom(r.q)]; }', "const r = solveBeat(S, t, { lean1: lean, iters: 400 }); return { ...r.B[drawFrom(r.q)], via: 'mix' }; }"],
];
if (vary) src.unshift(['for (const c of plansFor(S, 1)) { const v = -worth(S, guess, c, t) + lean(c) + rnd() * 0.3; if (v > bv) { bv = v; best = c; } }',
  'const sc = plansFor(S, 1).map((c) => [c, -worth(S, guess, c, t) + lean(c)]), top = Math.max(...sc.map((x) => x[1])), near = sc.filter((x) => x[1] >= top - 0.5); best = near[Math.floor(rnd() * near.length)][0];']);
const key = (p) => (p.clinch ? 'clinch' : [p.lead || 'h' + p.hl, p.rear || 'h' + p.hr, p.feet, (p.ord || []).join('>')].join('|')), hands = (p) => (p.clinch ? 'clinch' : [p.lead || 'h' + p.hl, p.rear || 'h' + p.hr].join('|')), pc = (x, y) => (y ? (100 * x / y).toFixed(0) + '%' : '-');

for (const who of ['repeats one plan (lead hook, rear hand high)', 'answers his last beat']) for (const opp of [0, 1, 2]) {
  const o = { w: 0, l: 0, d: 0, stopped: 0, beats: 0, by: {}, same: {}, run3: 0, bouts3: 0, h3: 0, hb3: 0 };
  for (let b = 0; b < n; b++) { const R = loadTweaked(1000 + b * 7 + opp, { src }), { N, plan0, man, cost, resolve, endBeat } = R; R.setOpp(opp);
    const S = { f: [man(N.hp), man(R.opp().hp)], range: 3 }, t = [0, 0]; let done = false, prev = '', run = 1, had3 = false, prevH = '', runH = 1, hadH = false;
    const sensible = () => { const he = S.f[1], g0 = he.last || plan0(), guess = cost(g0) <= he.st ? g0 : { ...plan0(), hl: g0.hl, hr: g0.hr }; let best = plan0(), bv = -1e9;
      for (const c of R.plansFor(S, 0)) { if (c.clinch) continue; const T = { range: S.range, f: S.f.map((m) => ({ ...m, hist: [] })) }; resolve(T, [{ ...c }, { ...guess, clinch: false }]);
        const v = (he.hp - T.f[1].hp) - (S.f[0].hp - T.f[0].hp) + 0.25 * T.f[0].st + R.rnd() * 0.5; if (v > bv) { bv = v; best = c; } } return best; };
    for (let r = 0; r < N.rounds && !done; r++) { S.range = 3; for (const m of S.f) { m.pts = 0; m.st = m.cap; m.g = N.guard; m.ropes = 0; m.held = 0; m.kept = 0; m.gave = 0; }
      for (let i = 0; i < N.beats && !done; i++) { S.t = N.beats - i; const spam = { ...plan0(), lead: 'hook', hr: 'high', ord: ['lead'] }, mine = who[0] === 'r' ? (cost(spam) <= S.f[0].st ? spam : plan0()) : sensible(), his = R.ai(S) || plan0(), k = key(his);
        o.beats++; o.by[his.via] = (o.by[his.via] || 0) + 1; if (k === prev) { o.same[his.via] = (o.same[his.via] || 0) + 1; run++; if (run === 3) { o.run3++; had3 = true; } } else run = 1; prev = k; if (hands(his) === prevH) { runH++; if (runH === 3) { o.h3++; hadH = true; } } else runH = 1; prevH = hands(his);
        resolve(S, [{ ...mine }, { ...his }]); endBeat(S);
        for (const j of [0, 1]) if (S.f[j].hp <= 0) { S.f[j].kd++; S.f[1 - j].pts += 3; if (S.f[j].kd > N.kd.length) { if (j === 1) o.w++; else { o.l++; o.stopped++; } done = true; break; } S.f[j].hp = N.kd[S.f[j].kd - 1]; } }
      if (!done) { const { sc } = R.judge(S.f[0], S.f[1]); t[0] += sc[0]; t[1] += sc[1]; } }
    if (!done) { if (t[0] > t[1]) o.w++; else if (t[0] < t[1]) o.l++; else o.d++; } if (had3) o.bouts3++; if (hadH) o.hb3++; }
  const R0 = loadTweaked(1, { src });
  console.log(`REPEATS${vary ? ' vary' : ''} | the player ${who} v ${R0.OPPS[opp].n}: wins ${pc(o.w, n)}, loses ${pc(o.l, n)} (stopped ${pc(o.stopped, n)}) | his beats chosen by: ${['read', 'plain', 'mix'].map((v) => `${v} ${pc(o.by[v] || 0, o.beats)}`).join(', ')} | the same beat as his last: ${['read', 'plain', 'mix'].map((v) => `${v} ${pc(o.same[v] || 0, o.by[v] || 0)}`).join(', ')} | the same beat three times running: ${(o.run3 / n).toFixed(1)} a bout, in ${pc(o.bouts3, n)} of bouts | the same two HANDS three times running (feet and order aside): ${(o.h3 / n).toFixed(1)} a bout, in ${pc(o.hb3, n)} of bouts`);
}
