// KICKBOX1 (S559): the kickboxing rules of kick.html, one beat each, on the page's own code (rules.mjs reads kick.html).
//   node proto/twohands/tools/kick_test.mjs
import assert from 'node:assert/strict';
import { load } from './rules.mjs';

const R = load(1, 'kick.html', null, false);
const p = (o) => ({ ...R.plan0(), ...o });
const beat = (a, b, range = 2, f = [{}, {}]) => { const S = { range, f: [Object.assign(R.man(18), f[0]), Object.assign(R.man(18), f[1])] }; const ev = R.resolve(S, [p(a), p(b)]); return { S, ev, said: ev.map((e) => `${e.k}:${e.t}:${e.a || ''}:${e.o || ''}`).join(' | ') }; };
let n = 0; const t = (name, fn) => { fn(); n++; console.log('ok', name); };

t('a low kick lands on a planted leg and marks it', () => { const { S, said } = beat({ feet: 'low' }, {}); assert.equal(S.f[1].hp, 16, said); assert.equal(S.f[1].legs, 1, said); });
t('a check stops the low kick and the kicker takes the damage', () => { const { S, said } = beat({ feet: 'low' }, { feet: 'check' }); assert.equal(S.f[1].hp, 18, said); assert.equal(S.f[0].hp, 18 - R.N.checkHurt, said); assert.equal(S.f[1].legs, 0, said); });
t('a lead hand held low catches a body kick and the kicker loses the rest of the beat', () => { const { S, said } = beat({ feet: 'bodyk', rear: 'cross', ord: ['feet', 'rear'] }, { hl: 'low' }); assert.match(said, /CAUGHT/); assert.equal(S.f[1].hp, 18, said); });
t('a landed teep pushes him one place back', () => { const { S, said } = beat({ feet: 'teep' }, {}); assert.equal(S.range, 3, said); assert.equal(S.f[1].hp, 17, said); });
t('the rear hand held high blocks the head kick', () => { const { S, said } = beat({ feet: 'headk' }, {}); assert.equal(S.f[1].hp, 18, said); assert.match(said, /block:Head kick/); });
t('a rear-leg kick drops the rear hand in its moment: his overhand lands', () => { const { S, said } = beat({ feet: 'low' }, { rear: 'over' }); assert.equal(S.f[0].hp, 14, said); assert.match(said, /rear hand dropped/); });
t('a kick is jammed Inside', () => { const { S, said } = beat({ feet: 'low' }, {}, 1); assert.equal(S.f[1].hp, 18, said); assert.match(said, /smothered/); });
t('a kick takes the feet switch: no step that beat, and the range holds', () => { const { S } = beat({ feet: 'bodyk' }, { hl: 'high' }, 3); assert.equal(S.range, 3); });
t('a check is held all beat, not thrown in a moment', () => { assert.deepEqual(R.ordOf(p({ feet: 'check', lead: 'jab' })), ['lead']); });
t('a limping man cannot back off', () => { const S = { range: 2, f: [Object.assign(R.man(18), { legs: R.N.limp }), R.man(18)] }; assert.ok(!R.plansFor(S, 0).some((c) => c.feet === 'back')); assert.ok(R.plansFor({ range: 2, f: [R.man(18), R.man(18)] }, 0).some((c) => c.feet === 'back')); });
t('the boxer (noKick) has no kick and no check', () => { const S = { range: 2, f: [Object.assign(R.man(18), { noKick: 1 }), R.man(18)] }; const feet = new Set(R.plansFor(S, 0).map((c) => c.feet)); assert.deepEqual([...feet].sort(), ['back', 'hold', 'in']); });
t('the boxing rules still hold: a cross at Mid lands on a lead hand held low', () => { const { S, said } = beat({ rear: 'cross' }, { hl: 'low' }); assert.equal(S.f[1].hp, 15, said); });
console.log(`KICK_TEST ${n} passed`);
