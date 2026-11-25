// S554: does "a landed jab keeps him out" give the jab a job? The sensible bot of probe_rules.mjs looks one beat ahead,
// so it cannot value a rule that pays on the NEXT beat. This plays a fixed OUT-BOXER (jab at Long, jab and cross at Mid
// while backing off, push off Inside) against each opponent with the rule on and off, same seed.
//   node proto/twohands/tools/probe_jab_keep.mjs [n=600] [seed=1]
import { load } from './rules.mjs';
const arg = (k, d) => { const a = process.argv.find((x) => x.startsWith(k + '=')); return a ? Number(a.split('=')[1]) : d; };
const n = arg('n', 600), seed = arg('seed', 1);
function run(keep, policy) { const R = load(seed), { N, plan0, man, cost, resolve, endBeat, ai, OPPS } = R; N.keep = keep; const out = [];
  for (let oi = 0; oi < OPPS.length; oi++) { R.setOpp(oi); let w = 0, long = 0, beats = 0, kept = 0, hit = 0, got = 0;
    for (let b = 0; b < n; b++) { const S = { f: [man(N.hp), man(R.opp().hp)], range: 3 }; let done = false; const t = [0, 0];
      for (let r = 0; r < N.rounds && !done; r++) { S.range = 3; for (const m of S.f) { m.pts = 0; m.st = m.cap; m.g = N.guard; m.ropes = 0; m.held = 0; m.kept = 0; }
        for (let i = 0; i < N.beats && !done; i++) { let mine = policy(S, R); if (cost(mine) > S.f[0].st) mine = { ...plan0(), hl: mine.hl, hr: mine.hr };
          const h0 = [S.f[0].hp, S.f[1].hp]; const ev = resolve(S, [mine, ai(S)]); endBeat(S); beats++; if (S.range === 3) long++; kept += S.f[1].kept; hit += h0[1] - S.f[1].hp; got += h0[0] - S.f[0].hp;
          for (const k of [0, 1]) if (S.f[k].hp <= 0) { S.f[k].kd++; S.f[1 - k].pts += 3; if (S.f[k].kd > N.kd.length) { if (k === 1) w++; done = true; break; } S.f[k].hp = N.kd[S.f[k].kd - 1]; } }
        if (!done) { const [x, y] = S.f; t[0] += x.pts >= y.pts ? 10 : 9; t[1] += y.pts >= x.pts ? 10 : 9; } }
      if (!done && t[0] > t[1]) w++; }
    out.push({ w: w / n, long: long / beats, kept: kept / n, hit: hit / n, got: got / n }); }
  return out; }
const outbox = (S, R) => { const me = S.f[0], p = R.plan0(); if (S.range === 3) { p.lead = 'jab'; } else if (S.range === 2) { p.lead = 'jab'; if (me.st >= 5) p.rear = 'cross'; if (me.ropes < 2) p.feet = 'back'; } else { p.lead = 'push'; if (me.ropes < 2) p.feet = 'back'; } return p; };
const walker = (S, R) => { const me = S.f[0], p = R.plan0(); if (S.range === 3) { p.feet = 'in'; } else if (S.range === 2) { p.rear = 'over'; p.lead = me.st >= 6 ? 'hook' : null; } else { p.rear = 'rup'; p.lead = me.st >= 6 ? 'hook' : null; } return p; };
const pc = (x) => (100 * x).toFixed(0).padStart(3) + '%';
for (const [name, pol] of [['OUT-BOXER (jab and move)', outbox], ['WALKER (step in, big punches)', walker]]) for (const keep of [0, 1]) { const r = run(keep, pol);
  console.log(`${name.padEnd(30)} rule ${keep ? 'ON ' : 'off'}: wins ${r.map((x) => pc(x.w)).join(' ')} | beats at Long ${r.map((x) => pc(x.long)).join(' ')} | beats he was kept out, a bout ${r.map((x) => x.kept.toFixed(1)).join(' ')} | health taken off him ${r.map((x) => x.hit.toFixed(1)).join(' ')}, off you ${r.map((x) => x.got.toFixed(1)).join(' ')}`); }
