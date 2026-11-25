// HEADMOVE1 (S559): the head moves of head.html, one beat each, on the page's own code (rules.mjs reads head.html).
//   node proto/twohands/tools/head_test.mjs
import assert from 'node:assert/strict';
import { load } from './rules.mjs';

const R = load(1, 'head.html', null, false);
const p = (o) => ({ ...R.plan0(), ...o });
const beat = (a, b, range = 2) => { const S = { range, f: [R.man(18), R.man(18)] }; const ev = R.resolve(S, [p(a), p(b)]); return { S, ev, said: ev.map((e) => `${e.k}:${e.t}:${e.a || ''}:${e.o || ''}`).join(' | ') }; };
let n = 0; const t = (name, fn) => { fn(); n++; console.log('ok', name); };

t('a slip makes his cross miss in that moment', () => { const { S, said } = beat({ feet: 'slip' }, { rear: 'cross', hr: 'high' }); assert.equal(S.f[0].hp, 18, said); assert.match(said, /slipped/); });
t('a slip does not stop his hook', () => { const { S, said } = beat({ feet: 'slip', hr: 'low' }, { lead: 'hook' }); assert.equal(S.f[0].hp, 15, said); });
t('a roll goes under his hook', () => { const { S, said } = beat({ feet: 'roll', hr: 'low' }, { lead: 'hook' }); assert.equal(S.f[0].hp, 18, said); assert.match(said, /rolled under/); });
t('a roll into his uppercut in the same moment costs one more', () => { const { S, said } = beat({ feet: 'roll', hr: 'high' }, { rear: 'rup' }, 1); assert.equal(S.f[0].hp, 18 - 4 - 1, said); });
t('a lean back takes him out of reach of the cross at Mid', () => { const { S, said } = beat({ feet: 'pull', hl: 'low' }, { rear: 'cross' }); assert.equal(S.f[0].hp, 18, said); assert.match(said, /leaned back/); });
t('a lean back fails when he closes the range in that moment', () => { const { S } = beat({ feet: 'pull', hl: 'low', hr: 'low' }, { feet: 'in', lead: 'hook', ord: ['feet', 'lead'] }, 2); assert.ok(S.f[0].hp < 18); });
t('a lean back does nothing Inside', () => { const { S, said } = beat({ feet: 'pull', hl: 'low' }, { rear: 'cross' }, 1); assert.equal(S.f[0].hp, 15, said); });
t('a slip in closes the range and slips the jab', () => { const { S, said } = beat({ feet: 'slipin', hl: 'low' }, { lead: 'jab' }, 3); assert.equal(S.range, 2, said); assert.equal(S.f[0].hp, 18, said); });
t('his punch made to miss makes my later punch a counter', () => { const { S, said } = beat({ feet: 'slip', rear: 'cross', ord: ['feet', 'rear'], hl: 'low' }, { rear: 'cross', hl: 'low', ord: ['rear'] }); assert.equal(S.f[1].hp, 18 - 3 - R.N.counter, said); });
t('body punches are not slipped', () => { const { S, said } = beat({ feet: 'slip', hl: 'high' }, { rear: 'rbody' }); assert.equal(S.f[0].hp, 16, said); });
t('the boxing rules still hold: a cross at Mid lands on a lead hand held low', () => { const { S, said } = beat({ rear: 'cross' }, { hl: 'low' }); assert.equal(S.f[1].hp, 15, said); });
console.log(`HEAD_TEST ${n} passed`);
