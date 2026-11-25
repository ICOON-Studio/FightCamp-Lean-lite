// RING SWITCHES: the rules, tested on the page's own code (rules.mjs reads order.html, the version with the order of actions). One beat each: two plans in,
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
test('S555: EVERY back off gives ground, at any range; a step in wins it back; on the ropes no back off is offered', () => {
  const S = ring(2); resolve(S, [plan({ feet: 'back' }), plan()]); assert.equal(S.f[0].ropes, 1); assert.equal(S.range, 3);
  endBeat(S); resolve(S, [plan({ feet: 'back' }), plan()]); assert.equal(S.f[0].ropes, 2); assert.ok(!R.plansFor(S, 0).some((c) => c.feet === 'back'));
  endBeat(S); resolve(S, [plan({ feet: 'in' }), plan()]); assert.equal(S.f[0].ropes, 0); assert.equal(S.range, 2);
});
test('S555: a step in beats a back off in the same moment - he closes anyway, and the man backing off still gives ground', () => {
  let S = ring(3), ev = resolve(S, [plan({ feet: 'in' }), plan({ feet: 'back' })]); assert.equal(S.range, 2); assert.equal(S.f[1].ropes, 1);
  S = ring(2); ev = resolve(S, [plan({ feet: 'in', lead: 'hook', ord: ['feet', 'lead'] }), plan({ feet: 'back', hr: 'low' })]);
  assert.equal(S.range, 1); assert.ok(find(ev, 0, 'hit', 'hook'), 'the hook behind the step lands: backing off in the same moment did not get him out');
  S = ring(3); ev = resolve(S, [plan({ feet: 'in', lead: 'hook', ord: ['feet', 'lead'] }), plan({ feet: 'back', hr: 'low', lead: 'jab', ord: ['lead', 'feet'] })]);
  assert.ok(find(ev, 0, 'miss', 'hook'), 'backing off a moment AFTER the step does: the hook falls short');
});
test('S555: the clinch is Inside only and gives 2 stamina', () => {
  let S = ring(2), ev = resolve(S, [plan({ clinch: true }), plan()]); assert.ok(!find(ev, 0, 'clinch'), 'no clinch from Mid');
  S = ring(1); S.f[0].st = 3; ev = resolve(S, [plan({ clinch: true }), plan()]); assert.ok(find(ev, 0, 'clinch')); assert.equal(S.f[0].st, 3 - 1 + 2);
});
test('S555: the cross and the body cross reach Mid and Inside; the lead uppercut is the short cheap one; the lead hook is as fast as the jab', () => {
  let S = ring(1), ev = resolve(S, [plan({ rear: 'cross' }), plan({ hl: 'low' })]); assert.ok(find(ev, 0, 'hit', 'cross'));
  S = ring(1); ev = resolve(S, [plan({ rear: 'rbody' }), plan({ hl: 'high' })]); assert.ok(find(ev, 0, 'hit', 'rbody'));
  assert.deepEqual([ACT.lup.st, ACT.lup.d, ACT.lup.sp], [2, 3, 2]); assert.equal(ACT.hook.sp, ACT.jab.sp);
  S = ring(2); ev = resolve(S, [plan({ lead: 'hook' }), plan({ rear: 'cross', hr: 'low', hl: 'low' })]);
  assert.ok(find(ev, 0, 'hit', 'hook')); assert.ok(/never thrown/.test(find(ev, 1, 'flat', 'cross').o), 'the fast hook lands first and stops his cross');
});
test('S555: a jab that lands no longer keeps him out (the S554 trial is off: it made 75% of beats Long)', () => {
  const S = ring(3); const ev = resolve(S, [plan({ lead: 'jab' }), plan({ hl: 'low' })]);
  assert.ok(find(ev, 0, 'hit', 'jab')); assert.equal(S.f[1].kept, 0); endBeat(S);
  resolve(S, [plan(), plan({ feet: 'in' })]); assert.equal(S.range, 2, 'he steps in on the next beat');
});
test('a plan costs what its switches say, and holding both hands gives stamina back', () => {
  assert.equal(cost(plan({ lead: 'jab', rear: 'cross', feet: 'in' })), ACT.jab.st + ACT.cross.st + 1);
  const S = ring(3); S.f[0].st = 3; resolve(S, [plan(), plan()]); endBeat(S); assert.equal(S.f[0].st, 3 + N.rec + 2 * N.hold);
});
test('health at 0 is a knockdown event on the punch that did it', () => {
  const S = ring(2); S.f[1].hp = 2; const ev = resolve(S, [plan({ rear: 'cross' }), plan({ hl: 'low' })]);
  assert.ok(find(ev, 0, 'hit', 'cross').down);
});
// ---- S555: THE ORDER OF ACTIONS (the owner: "i want version with the order of actions"; "why his jab is blocked when i picked lead hook ?")
test('S555: a hand is out of its guard only in the moment it acts - a lead hook thrown second still blocks his jab in moment 1', () => {
  const S = ring(2), ev = resolve(S, [plan({ rear: 'rbody', lead: 'hook', ord: ['rear', 'lead'] }), plan({ lead: 'jab', rear: 'cross', ord: ['lead', 'rear'] })]);
  const b = find(ev, 1, 'block', 'jab'); assert.ok(b && b.m === 0, 'his jab is blocked in moment 1');
  assert.match(b.o, /your lead hand was still up \(its Lead hook comes in moment 2\)/, 'and the line says why: ' + b.o);
  assert.match(find(ev, 1, 'flat', 'cross').o, /never thrown/, 'in moment 2 the fast lead hook lands first and stops his cross (the hook is as fast as the jab since the balance pass)');
  const S2 = ring(2), ev2 = resolve(S2, [plan({ rear: 'rbody', lead: 'lbody', ord: ['rear', 'lead'] }), plan({ lead: 'jab', rear: 'cross', ord: ['lead', 'rear'] })]);
  const c = find(ev2, 1, 'hit', 'cross'); assert.ok(c && c.m === 1, 'a body hook is no faster than his cross: in moment 2 the cross finds the lead hand out');
  assert.match(c.o, /your lead hand was out, throwing its Body hook/);
});
test('S555: the same two punches in the other order - the hook goes first, so his jab finds the lead hand out', () => {
  const S = ring(2), ev = resolve(S, [plan({ rear: 'rbody', lead: 'hook', ord: ['lead', 'rear'] }), plan({ lead: 'jab', rear: 'cross', ord: ['lead', 'rear'] })]);
  assert.ok(find(ev, 1, 'hit', 'jab'), 'his jab lands in moment 1'); const b = find(ev, 1, 'block', 'cross');
  assert.ok(b && /your lead hand was back up \(its Lead hook was moment 1\)/.test(b.o), 'his cross meets the lead hand back up: ' + (b && b.o));
});
test('S555: feet take a moment - step in and THEN hook reaches from Long, hook and then step falls short', () => {
  let S = ring(3), ev = resolve(S, [plan({ feet: 'in', lead: 'hook', ord: ['feet', 'lead'] }), plan({ hr: 'low' })]);
  assert.ok(find(ev, 0, 'hit', 'hook'), 'in first, the hook lands at Mid');
  S = ring(3); ev = resolve(S, [plan({ feet: 'in', lead: 'hook', ord: ['lead', 'feet'] }), plan({ hr: 'low' })]);
  assert.ok(find(ev, 0, 'miss', 'hook'), 'the hook first falls short at Long'); assert.equal(S.range, 2);
});
test('S555: a feint draws his hands for the NEXT moment only', () => {
  let S = ring(2), ev = resolve(S, [plan({ lead: 'feint', rear: 'cross', ord: ['lead', 'rear'] }), plan()]);
  assert.ok(find(ev, 0, 'hit', 'cross'), 'feint, then the cross: it cannot be covered');
  S = ring(2); ev = resolve(S, [plan({ lead: 'feint', rear: 'cross', ord: ['rear', 'lead'] }), plan()]);
  assert.ok(find(ev, 0, 'block', 'cross'), 'the cross before the feint is blocked');
});
test('S555: a plan without an order is thrown feet, lead hand, rear hand', () => {
  assert.deepEqual(R.ordOf(plan({ rear: 'cross', lead: 'jab', feet: 'in' })), ['feet', 'lead', 'rear']);
  assert.deepEqual(R.ordOf(plan({ rear: 'cross', lead: 'jab', feet: 'in', ord: ['rear'] })), ['rear', 'feet', 'lead']);
});
// ---- S555: THE BEAT AS A GUESSING GAME (the owner: "vs the jabber you win very easy , all your rear hands land easy , need better balance")
test('S555: every plan a man is offered he can pay for; none backs off on the ropes, steps in when kept out, or clinches from Long', () => {
  const S = ring(3); S.f[0].st = 3; S.f[0].ropes = 2; S.f[0].kept = 1; const A = R.plansFor(S, 0);
  assert.ok(A.length > 10); for (const c of A) { assert.ok(cost(c) <= 3, 'too dear: ' + R.planWords(c)); assert.notEqual(c.feet, 'back'); assert.notEqual(c.feet, 'in'); assert.ok(!c.clinch); }
  const B = R.plansFor(ring(1), 1); assert.ok(B.some((c) => c.clinch), 'a clinch is offered Inside'); assert.ok(!R.plansFor(ring(2), 1).some((c) => c.clinch), 'and not at Mid'); assert.ok(B.some((c) => c.ord.join() === 'rear,lead,feet'), 'every order is offered');
});
test('S555: the solved mix of a beat between equal men is worth 0 to either and nobody can improve on it', () => {
  for (const range of [1, 2, 3]) { const z = R.solveBeat(ring(range), 3, { iters: 800 });
    assert.ok(Math.abs(z.v) < 0.1, `${range}: worth ${z.v}`); assert.ok(z.exploit < 0.15, `${range}: a man could still gain ${z.exploit}`);
    assert.ok(Math.abs(z.p.reduce((x, y) => x + y, 0) - 1) < 1e-6); assert.ok(Math.max(...z.p) < 0.9, `${range}: no single plan is the answer`); }
});
test('S555: a man with more stamina is better off, and the mix says so', () => {
  const S = ring(2); S.f[1].st = 3; assert.ok(R.solveBeat(S, 4, { iters: 500 }).v > 0.2);
});
test('S555: the machine pays for what it throws, in every state, and no line of his is always open', () => {
  for (let oi = 0; oi < 3; oi++) { R.setOpp(oi); const seen = { hl: {}, hr: {} };
    for (let i = 0; i < 12; i++) { const S = ring(1 + (i % 3)); S.t = 6 - (i % 6); S.f[1].st = 2 + (i % 7); const c = R.ai(S); assert.ok(c && cost(c) <= S.f[1].st, R.opp().n + ' cannot pay for ' + R.planWords(c));
      if (!c.clinch) { seen.hl[c.lead ? 'out' : c.hl] = 1; seen.hr[c.rear ? 'out' : c.hr] = 1; } }
    assert.ok(Object.keys(seen.hl).length >= 2 && Object.keys(seen.hr).length >= 2, R.opp().n + ' holds his hands one way only: ' + JSON.stringify(seen)); }
});
test('S555: he answers a habit - the same plan twice and (when he reads it) he takes the best plan against it', () => {
  R.setOpp(0); const S = ring(2); S.t = 4; const habit = plan({ rear: 'cross', ord: ['rear'] }); S.f[0].hist = [habit, habit]; let blocked = 0;
  for (let i = 0; i < 20; i++) { const c = R.ai(S), T = ring(2); const ev = resolve(T, [{ ...habit }, { ...c }]); if (!find(ev, 0, 'hit', 'cross')) blocked++; }
  assert.ok(blocked >= 12, `the habitual cross was stopped or made to miss ${blocked} of 20 times (the Jabber reads 3 in 4)`);
});
test('S555: his skill - at 0 every beat is a plain beat of his style (one of his own switches in it), and he can pay for it', () => {
  for (let oi = 0; oi < 3; oi++) { R.setOpp(oi); const was = R.opp().skill; R.opp().skill = 0;
    for (let i = 0; i < 10; i++) { const S = ring(2); S.t = 3; const c = R.ai(S); assert.ok(cost(c) <= S.f[1].st); assert.ok([c.lead, c.rear, c.feet].some((x) => R.opp().like.includes(x)), R.opp().n + ': ' + R.planWords(c)); }
    R.opp().skill = was; assert.ok(was > 0.3 && was <= 1, R.opp().n + ' has a skill'); }
});
test('S555: a push says what it is and why it did nothing; his plain beats never shove at nothing (owner: "what pushes means ? how is done ?")', () => {
  let S = ring(2), ev = resolve(S, [plan(), plan({ lead: 'push' })]); const miss = ev.find((e) => e.k === 1 && /^pushes/.test(e.a));
  assert.match(miss.o, /a shove at nothing: it only works chest to chest, and you were not Inside/);
  S = ring(1); ev = resolve(S, [plan({ lead: 'push' }), plan()]); assert.match(ev.find((e) => e.k === 0 && /^pushes/.test(e.a)).o, /a shove with the lead glove on his chest: he is back at Mid/); assert.equal(S.range, 2);
  for (let oi = 0; oi < 3; oi++) { R.setOpp(oi); const was = R.opp().skill; R.opp().skill = 0;
    for (let i = 0; i < 25; i++) { const T = ring(2 + (i % 2)); T.t = 3; assert.notEqual(R.ai(T).lead, 'push', R.opp().n + ' shoves at nothing on a plain beat'); }
    R.opp().skill = was; }
});
console.log(`RULES_TEST ${n} passed${process.exitCode ? ' - FAILURES above' : ''}`);
