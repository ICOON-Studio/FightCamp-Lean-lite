/* LONG1: do the three tweak files do what their notes say? One beat each, read from the page's own resolve.
   node ops/research/s558_balance/long1_check.mjs */
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { loadTweaked, readTweak } from '../../../proto/twohands/tools/balance.mjs';
const here = path.dirname(fileURLToPath(import.meta.url));
let bad = 0; const ok = (name, cond, got) => { console.log((cond ? 'PASS ' : 'FAIL ') + name + ' | ' + got); if (!cond) bad++; };
function beat(tw, a, b, range = 3) { const R = loadTweaked(1, tw ? readTweak(path.join(here, tw)) : null, null), { plan0, man, N, resolve } = R;
  const S = { range, f: [man(N.hp), man(N.hp)] }, ev = resolve(S, [{ ...plan0(), ...a }, { ...plan0(), ...b }]);
  return { range: S.range, st: [S.f[0].st, S.f[1].st], hp: [S.f[0].hp, S.f[1].hp], words: ev.map((e) => `${e.a}: ${e.o}`).join(' || ') }; }
const jab = { lead: 'jab' }, bjab = { lead: 'bjab' }, inLow = { feet: 'in', hl: 'low' }, inHigh = { feet: 'in', hl: 'high' }, fence = { hl: 'high' }, low = { hl: 'low' };
let r;
r = beat(null, jab, inLow); ok('page today: a jab lands on a man stepping in, he is at Mid', r.range === 2 && r.hp[1] === 17, JSON.stringify(r));
r = beat('long1_l1.json', jab, inLow); ok('L1: the jab lands as he steps in from Long - still at Long, he paid the step', r.range === 3 && r.hp[1] === 17 && r.st[1] === 7 && /stops him/.test(r.words), JSON.stringify(r));
r = beat('long1_l1.json', jab, inHigh); ok('L1: he steps in behind a high lead - the jab is blocked, he is at Mid', r.range === 2 && r.hp[1] === 18, JSON.stringify(r));
r = beat('long1_l1.json', bjab, inHigh); ok('L1: the body jab lands on him but does not stop him', r.range === 2 && r.hp[1] === 17, JSON.stringify(r));
r = beat('long1_l1.json', { lead: 'jab', feet: 'hold', ord: ['lead'] }, { feet: 'in', hl: 'low', rear: 'cross', ord: ['rear', 'feet'] }); ok('L1: his step is his second action, the jab his first moment - no stop (not the same moment)', r.range === 2, JSON.stringify(r));
r = beat('long1_l1.json', jab, inLow, 2); ok('L1: from Mid a landed jab stops nobody', r.range === 1, JSON.stringify(r));
r = beat(null, fence, inLow); ok('page today: a step in from Long costs 1', r.range === 2 && r.st[1] === 7, JSON.stringify(r));
r = beat('long1_l2.json', fence, inLow); ok('L2: a lead held high at Long - his step in costs 2', r.range === 2 && r.st[1] === 6, JSON.stringify(r));
r = beat('long1_l2.json', low, inLow); ok('L2: a lead held low is no fence', r.st[1] === 7, JSON.stringify(r));
r = beat('long1_l2.json', jab, inHigh); ok('L2: a lead that jabs is no fence', r.st[1] === 7, JSON.stringify(r));
r = beat('long1_l2.json', fence, inLow, 2); ok('L2: no fence at Mid', r.st[1] === 7 && r.range === 1, JSON.stringify(r));
r = beat('long1_l3.json', jab, inLow); ok('L3: the stopping jab works', r.range === 3 && r.st[1] === 7, JSON.stringify(r));
r = beat('long1_l3.json', fence, inLow); ok('L3: the fence works', r.range === 2 && r.st[1] === 6, JSON.stringify(r));
console.log(bad ? `LONG1_CHECK FAIL ${bad}` : 'LONG1_CHECK 13 passed'); process.exitCode = bad ? 1 : 0;
