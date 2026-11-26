/* LONG2: do the three tweak files do what their notes say? One beat each, read from the page's own resolve.
   node ops/research/s558_balance/long2_check.mjs */
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { loadTweaked, readTweak } from '../../../proto/twohands/tools/balance.mjs';
const here = path.dirname(fileURLToPath(import.meta.url));
let bad = 0, n = 0; const ok = (name, cond, got) => { n++; console.log((cond ? 'PASS ' : 'FAIL ') + name + ' | ' + got); if (!cond) bad++; };
function beat(tw, a, b, range = 3) { const R = loadTweaked(1, tw ? readTweak(path.join(here, tw)) : null, null), { plan0, man, N, resolve } = R;
  const S = { range, f: [man(N.hp), man(N.hp)] }, ev = resolve(S, [{ ...plan0(), ...a }, { ...plan0(), ...b }]);
  return { range: S.range, st: [S.f[0].st, S.f[1].st], hp: [S.f[0].hp, S.f[1].hp], pts: [S.f[0].pts, S.f[1].pts], words: ev.map((e) => `${e.a}: ${e.o}`).join(' || ') }; }
const cross = { rear: 'cross' }, jab = { lead: 'jab' }, bjab = { lead: 'bjab' }, inLow = { feet: 'in', hl: 'low' }, inHigh = { feet: 'in', hl: 'high' }, stand = { hl: 'low' };
let r;
r = beat(null, cross, inLow); ok('page today: a cross thrown at Long lands on a man stepping in that moment, 3 health 2 points', r.range === 2 && r.hp[1] === 15 && r.pts[0] === 2, JSON.stringify(r));
r = beat(null, cross, stand); ok('page today: a cross at a man who did not come falls short', r.hp[1] === 18 && /falls short/.test(r.words), JSON.stringify(r));
r = beat(null, jab, inLow); ok('page today: a jab on a man stepping in scores 1 point', r.hp[1] === 17 && r.pts[0] === 1, JSON.stringify(r));
r = beat('long2_k1.json', cross, inLow); ok('K1: he walks onto the cross - a counter, 4 health', r.hp[1] === 14 && r.pts[0] === 2 && /walked onto it/.test(r.words), JSON.stringify(r));
r = beat('long2_k1.json', cross, inHigh); ok('K1: he steps in behind a high lead - the cross is blocked', r.hp[1] === 18 && /blocked/.test(r.words), JSON.stringify(r));
r = beat('long2_k1.json', cross, stand); ok('K1: he did not come - the cross falls short, nothing more', r.hp[1] === 18 && /falls short/.test(r.words), JSON.stringify(r));
r = beat('long2_k1.json', cross, inLow, 2); ok('K1: from Mid a cross on a stepping man is no counter (3 health)', r.hp[1] === 15, JSON.stringify(r));
r = beat('long2_k1.json', jab, inLow); ok('K1: a jab that meets him stepping in scores 2 points, still 1 health', r.hp[1] === 17 && r.pts[0] === 2 && r.range === 2, JSON.stringify(r));
r = beat('long2_k1.json', bjab, inHigh); ok('K1: the body jab under his high lead scores 2 points', r.hp[1] === 17 && r.pts[0] === 2, JSON.stringify(r));
r = beat('long2_k1.json', jab, stand); ok('K1: a jab on a man standing still scores 1 point', r.pts[0] === 1, JSON.stringify(r));
r = beat('long2_k1.json', jab, inLow, 2); ok('K1: from Mid a jab on a stepping man is smothered or 1 point, never 2', r.pts[0] !== 2, JSON.stringify(r));
r = beat('long2_k2.json', cross, inLow); ok('K2: the cross half - 4 health', r.hp[1] === 14, JSON.stringify(r));
r = beat('long2_k2.json', jab, inLow); ok('K2: the jab scores 1 point as today', r.pts[0] === 1, JSON.stringify(r));
r = beat('long2_k3.json', cross, inLow); ok('K3: the cross as today - 3 health', r.hp[1] === 15, JSON.stringify(r));
r = beat('long2_k3.json', jab, inLow); ok('K3: the jab half - 2 points', r.pts[0] === 2, JSON.stringify(r));
console.log(bad ? `LONG2_CHECK FAIL ${bad}` : `LONG2_CHECK ${n} passed`); process.exitCode = bad ? 1 : 0;
