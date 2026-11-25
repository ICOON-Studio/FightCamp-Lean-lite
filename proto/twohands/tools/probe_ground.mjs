// DO THE OPPONENTS GIVE GROUND TOO CHEAPLY? (S557; S556 NOT GREEN: "the look-ahead does not know the ground rule".
// Ziva's playtest: "the AI does not play for it, and he handed me tiebreaks repeatedly" - bout 2 round 2 went to the
// player on ground.) Since S556 a round level on points goes to the man who backed off less. The opponents' look-ahead
// values ground only as the ropes behind a man (W.ropes); a back off that is later won back costs it nothing.
// The measuring player answers the man's last beat and NEVER backs off, so every level round in which the other man
// backed off once is his. Counted: how often the man backs off, how many rounds are level, who gets them, the bouts.
//   node proto/twohands/tools/probe_ground.mjs [n=40] [tweak=<f.json>] [table=<vtable.json>]
import { loadTweaked, readTweak } from './balance.mjs';

const arg = (k, d) => { const a = process.argv.find((x) => x.startsWith(k + '=')); return a ? a.split('=').slice(1).join('=') : d; }, n = Number(arg('n', 40)), tweak = readTweak(arg('tweak', '')), table = arg('table', '') || undefined;
const pc = (x, y) => (y ? (100 * x / y).toFixed(0) + '%' : '-');
for (const opp of [0, 1, 2]) { const o = { w: 0, l: 0, d: 0, rounds: 0, lvl: 0, lvlMine: 0, lvlHis: 0, backs: 0, beats: 0 };
  for (let b = 0; b < n; b++) { const R = loadTweaked(2000 + b * 5 + opp, tweak, table), { N, plan0, man, cost, resolve, endBeat } = R; R.setOpp(opp);
    const S = { f: [man(N.hp), man(R.opp().hp)], range: 3 }, t = [0, 0]; let done = false;
    const mine = () => { const he = S.f[1], g0 = he.last || plan0(), guess = cost(g0) <= he.st ? g0 : { ...plan0(), hl: g0.hl, hr: g0.hr }; let best = plan0(), bv = -1e9;
      for (const c of R.plansFor(S, 0)) { if (c.clinch || c.feet === 'back') continue; const T = { range: S.range, f: S.f.map((m) => ({ ...m, hist: [] })) }; resolve(T, [{ ...c }, { ...guess, clinch: false }]);
        const v = (he.hp - T.f[1].hp) - (S.f[0].hp - T.f[0].hp) + 0.25 * T.f[0].st + R.rnd() * 0.5; if (v > bv) { bv = v; best = c; } } return best; };
    for (let r = 0; r < N.rounds && !done; r++) { S.range = 3; for (const m of S.f) { m.pts = 0; m.st = m.cap; m.g = N.guard; m.ropes = 0; m.held = 0; m.kept = 0; m.gave = 0; }
      for (let i = 0; i < N.beats && !done; i++) { S.t = N.beats - i; const a = mine(), his = R.ai(S) || plan0(); o.beats++; if (!his.clinch && his.feet === 'back') o.backs++;
        resolve(S, [{ ...a }, { ...his }]); endBeat(S);
        for (const j of [0, 1]) if (S.f[j].hp <= 0) { S.f[j].kd++; S.f[1 - j].pts += 3; if (S.f[j].kd > N.kd.length) { if (j === 1) o.w++; else o.l++; done = true; break; } S.f[j].hp = N.kd[S.f[j].kd - 1]; } }
      if (!done) { const [x, y] = S.f, { sc, w } = R.judge(x, y); o.rounds++; if (x.pts === y.pts) { o.lvl++; if (w === 0) o.lvlMine++; else if (w === 1) o.lvlHis++; } t[0] += sc[0]; t[1] += sc[1]; } }
    if (!done) { if (t[0] > t[1]) o.w++; else if (t[0] < t[1]) o.l++; else o.d++; } }
  console.log(`GROUND v ${loadTweaked(1, tweak, table).OPPS[opp].n}: the player who never backs off wins ${pc(o.w, n)}, loses ${pc(o.l, n)}, draws ${pc(o.d, n)} | he backs off in ${pc(o.backs, o.beats)} of beats | rounds level on points ${pc(o.lvl, o.rounds)}: ${pc(o.lvlMine, o.lvl)} of them to the player, ${pc(o.lvlHis, o.lvl)} to him (${o.lvl} rounds)`); }
