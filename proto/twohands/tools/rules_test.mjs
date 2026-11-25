// RING SWITCHES: the rules, tested on the page's own code (rules.mjs reads switch.html). One beat each: two plans in,
// what must come out. S551's NOT GREEN list had "no tests for the rules".
//   node proto/twohands/tools/rules_test.mjs        exit 0 = all pass
import assert from 'node:assert/strict';
import { load } from './rules.mjs';

const R = load(7), { N, ACT, plan0, man, resolve, endBeat, cost } = R;
const ring = (range = 2) => ({ f: [man(N.hp), man(N.hp)], range });
const plan = (o = {}) => ({ ...plan0(), ...o });
const find = (ev, k, t, id) => ev.find((e) => e.k === k && e.t === t && (!id || e.id === id));
let n = 0;
const test = (name, fn) => { try { fn(); n++; } catch (e) { console.log(`RULES_TEST FAIL ${name}: ${e.message}`); process.exitCode = 1; } };

test('the lead hand held high blocks a jab; held low it does not', () => {
  let S = ring(3), ev = resolve(S, [plan({ lead: 'jab' }), plan({ hl: 'high' })]);
  assert.ok(find(ev, 0, 'block', 'jab')); assert.equal(S.f[1].hp, N.hp);
  S = ring(3); ev = resolve(S, [plan({ lead: 'jab' }), plan({ hl: 'low' })]);
  assert.ok(find(ev, 0, 'hit', 'jab')); assert.equal(S.f[1].hp, N.hp - ACT.jab.d);
});
test('the rear hand high blocks a hook, low blocks an uppercut', () => {
  let S = ring(2), ev = resolve(S, [plan({ lead: 'hook' }), plan({ hr: 'high' })]);
  assert.ok(find(ev, 0, 'block', 'hook'));
  S = ring(1); ev = resolve(S, [plan({ rear: 'rup' }), plan({ hr: 'high' })]);
  assert.ok(find(ev, 0, 'hit', 'rup'), 'an uppercut goes under a high rear hand');
  S = ring(1); ev = resolve(S, [plan({ rear: 'rup' }), plan({ hr: 'low' })]);
  assert.ok(find(ev, 0, 'block', 'rup'));
});
test('the lead hand low blocks a body punch', () => {
  const S = ring(2), ev = resolve(S, [plan({ rear: 'rbody' }), plan({ hl: 'low' })]);
  assert.ok(find(ev, 0, 'block', 'rbody'));
});
test('a hand that punches does not block', () => {
  const S = ring(3), ev = resolve(S, [plan({ lead: 'jab' }), plan({ lead: 'jab' })]);
  assert.ok(find(ev, 0, 'hit', 'jab')); assert.ok(find(ev, 1, 'hit', 'jab'));
});
test('a punch only reaches at its ranges', () => {
  let S = ring(3), ev = resolve(S, [plan({ rear: 'cross' }), plan()]);
  assert.ok(find(ev, 0, 'miss', 'cross'), 'a cross falls short at Long');
  S = ring(1); ev = resolve(S, [plan({ lead: 'jab' }), plan({ hl: 'low' })]);
  assert.ok(find(ev, 0, 'miss', 'jab'), 'a jab is smothered Inside');
});
test('the fast punch lands first and a big one that lands stops his slower punch', () => {
  const S = ring(2), ev = resolve(S, [plan({ rear: 'cross' }), plan({ rear: 'over', hl: 'low' })]);
  assert.ok(find(ev, 0, 'hit', 'cross')); const o = find(ev, 1, 'flat', 'over');
  assert.ok(o && /never thrown/.test(o.o)); assert.equal(S.f[0].hp, N.hp);
});
test('a feint draws his hands: the rear punch behind it cannot be covered', () => {
  const S = ring(2), ev = resolve(S, [plan({ lead: 'feint', rear: 'cross' }), plan({ hl: 'high', hr: 'high' })]);
  assert.ok(find(ev, 0, 'hit', 'cross'));
});
test('a blocked or missed punch makes his later punch that beat a counter', () => {
  const S = ring(2), ev = resolve(S, [plan({ lead: 'jab' }), plan({ hl: 'high', rear: 'cross' })]);
  assert.ok(find(ev, 0, 'block', 'jab')); const c = find(ev, 1, 'hit', 'cross');
  assert.ok(c); assert.equal(c.dmg, ACT.cross.d + N.counter);
});
test('a body punch that lands shortens his stamina bar', () => {
  const S = ring(2); resolve(S, [plan({ lead: 'lbody' }), plan()]);
  assert.equal(S.f[1].cap, N.st - 1);
});
test('a big punch that is blocked wears the guard; a jab does not', () => {
  let S = ring(2); resolve(S, [plan({ rear: 'cross' }), plan()]); assert.equal(S.f[1].g, N.guard - 1);
  S = ring(3); resolve(S, [plan({ lead: 'jab' }), plan()]); assert.equal(S.f[1].g, N.guard);
});
test('a clinch: no punch lands, the range is Mid, and not twice running', () => {
  const S = ring(1); let ev = resolve(S, [plan({ clinch: true }), plan({ rear: 'rup' })]);
  assert.ok(find(ev, 0, 'clinch')); assert.equal(S.f[0].hp, N.hp); assert.equal(S.range, 2);
  endBeat(S); ev = resolve(S, [plan({ clinch: true }), plan()]);
  assert.ok(!find(ev, 0, 'clinch'), 'the referee will not allow two running');
});
test('a push Inside shoves him back to Mid and breaks a clinch', () => {
  let S = ring(1); resolve(S, [plan({ lead: 'push' }), plan()]); assert.equal(S.range, 2);
  S = ring(1); const ev = resolve(S, [plan({ lead: 'push' }), plan({ clinch: true })]);
  assert.ok(!find(ev, 1, 'clinch'));
});
test('backing off at Long gives ground; a step in wins it back', () => {
  const S = ring(3); resolve(S, [plan({ feet: 'back' }), plan()]); assert.equal(S.f[0].ropes, 1); assert.equal(S.range, 3);
  endBeat(S); resolve(S, [plan({ feet: 'in' }), plan()]); assert.equal(S.f[0].ropes, 0); assert.equal(S.range, 2);
});
test('S554: a jab that lands keeps him out - he cannot step in on the next beat, and does not pay for the step', () => {
  const S = ring(3); let ev = resolve(S, [plan({ lead: 'jab' }), plan({ hl: 'low' })]);
  assert.ok(find(ev, 0, 'hit', 'jab')); assert.equal(S.f[1].kept, 1); endBeat(S);
  const st = S.f[1].st; ev = resolve(S, [plan(), plan({ feet: 'in' })]);
  assert.equal(S.range, 3, 'he stays at Long'); assert.equal(S.f[1].st, st, 'the step was not paid for'); assert.equal(S.f[1].kept, 0);
  endBeat(S); resolve(S, [plan(), plan({ feet: 'in' })]); assert.equal(S.range, 2, 'one beat only');
});
test('S554: a jab that is blocked keeps nobody out', () => {
  const S = ring(3); resolve(S, [plan({ lead: 'jab' }), plan({ hl: 'high' })]); assert.equal(S.f[1].kept, 0);
  endBeat(S); resolve(S, [plan(), plan({ feet: 'in' })]); assert.equal(S.range, 2);
});
test('a plan costs what its switches say, and holding both hands gives stamina back', () => {
  assert.equal(cost(plan({ lead: 'jab', rear: 'cross', feet: 'in' })), ACT.jab.st + ACT.cross.st + 1);
  const S = ring(3); S.f[0].st = 3; resolve(S, [plan(), plan()]); endBeat(S); assert.equal(S.f[0].st, 3 + N.rec + 2 * N.hold);
});
test('health at 0 is a knockdown event on the punch that did it', () => {
  const S = ring(2); S.f[1].hp = 2; const ev = resolve(S, [plan({ rear: 'cross' }), plan({ hl: 'low' })]);
  assert.ok(find(ev, 0, 'hit', 'cross').down);
});
console.log(`RULES_TEST ${n} passed${process.exitCode ? ' - FAILURES above' : ''}`);
