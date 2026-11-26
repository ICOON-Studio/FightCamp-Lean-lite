// WAIT_TEST (S565): wait.html - the step that comes a moment later (MOMENTGAP1 B). The rules are read from the built page.
//   node proto/twohands/tools/wait_test.mjs
import fs from 'node:fs';
import path from 'node:path';
import assert from 'node:assert/strict';
import { fileURLToPath } from 'node:url';
import { load } from './rules.mjs';

const here = path.dirname(fileURLToPath(import.meta.url));
const R = load(1, 'wait.html'), R0 = load(1, 'order.html'), { plan0, man, N, resolve, plansFor, cost } = R;
let n = 0; const t = (name, f) => { f(); n++; console.log('ok ' + name); };
const ring = (range = 3) => ({ range, f: [man(N.hp), man(N.hp)] });
const beat = (Rx, a, b, range = 3) => { const S = ring(range), ev = Rx.resolve(S, [{ ...Rx.plan0(), ...a }, { ...Rx.plan0(), ...b }]); return { S, ev, words: ev.map((e) => `${e.m ?? ''} ${e.a}: ${e.o}`).join(' || ') }; };

t('the plan list offers a wait only right before a last step, in three moments or fewer', () => {
  const plans = plansFor(ring(2), 0), w = plans.filter((p) => (p.ord || []).includes('wait'));
  assert.ok(w.length > 0, 'no plan with a wait');
  for (const p of w) { const at = p.ord.indexOf('wait'); assert.equal(p.ord[at + 1], 'feet', JSON.stringify(p.ord)); assert.equal(at + 2, p.ord.length, JSON.stringify(p.ord)); assert.ok(p.ord.length <= 3); assert.equal(p.ord.filter((s) => s === 'wait').length, 1); }
  assert.ok(w.some((p) => p.ord.length === 2) && w.some((p) => p.ord.length === 3));
  assert.ok(!R0.plansFor(ring(2), 0).some((p) => (p.ord || []).includes('wait')), 'order.html must not know the wait'); });

t('a wait is free and both hands stay home in it', () => {
  assert.equal(cost({ ...plan0(), feet: 'in', ord: ['wait', 'feet'] }), cost({ ...plan0(), feet: 'in', ord: ['feet'] }));
  const { S, words } = beat(R, { feet: 'in', hl: 'high', ord: ['wait', 'feet'] }, { lead: 'jab', ord: ['lead'] });
  assert.match(words, /blocked/, words); assert.equal(S.range, 2); });

t('the step in moment 3: his moment-2 body cross finds you where you stood', () => {
  const his = { lead: 'jab', rear: 'rbody', ord: ['lead', 'rear'] };
  const early = beat(R, { lead: 'bjab', feet: 'in', ord: ['lead', 'feet'] }, his), late = beat(R, { lead: 'bjab', feet: 'in', ord: ['lead', 'wait', 'feet'] }, his);
  assert.match(early.words, /Body cross: lands/, early.words); assert.equal(early.S.f[0].hp, N.hp - 1 - 2, early.words);   /* his jab, then the body cross as you step into it */
  assert.match(late.words, /Body cross: falls short at Long/, late.words); assert.equal(late.S.f[0].hp, N.hp - 1, late.words);
  assert.equal(late.S.range, 2, 'you still get in, a moment later'); assert.equal(early.S.f[0].st, late.S.f[0].st, 'the wait costs nothing'); });

t('the wait moves the step exactly one moment, and a late step can walk onto his next punch', () => {
  const his = { lead: 'jab', rear: 'rbody', ord: ['lead', 'rear'] }, r = beat(R, { feet: 'in', hl: 'high', ord: ['wait', 'feet'] }, his);
  assert.equal(r.ev.find((e) => e.t === 'range').m, 1, 'wait, then the step: moment 2'); assert.match(r.words, /Jab: blocked/, r.words);
  assert.match(r.words, /Body cross: lands/, r.words); assert.equal(r.S.f[0].hp, N.hp - 2, r.words);   /* you arrive at Mid in the moment his body cross comes */
  assert.equal(beat(R, { lead: 'bjab', feet: 'in', ord: ['lead', 'wait', 'feet'] }, his).ev.find((e) => e.t === 'range').m, 2, 'jab, wait, then the step: moment 3'); });

t('the page keeps only a legal wait in your order (fixWait)', () => {
  const html = fs.readFileSync(path.join(here, '..', 'wait.html'), 'utf8'), src = ['const waitCan', 'const fixWait'].map((k) => html.split('\n').find((l) => l.startsWith(k))).join('\n');
  const { waitCan, fixWait } = new Function(src + '\nreturn { waitCan, fixWait };')();
  assert.deepEqual(fixWait(['lead', 'wait', 'feet']), ['lead', 'wait', 'feet']);
  assert.deepEqual(fixWait(['wait', 'lead', 'feet']), ['lead', 'wait', 'feet'], 'a dragged wait goes back before the step');
  assert.deepEqual(fixWait(['feet', 'wait', 'lead']), ['feet', 'lead'], 'the step dragged first: the wait goes');
  assert.deepEqual(fixWait(['lead', 'rear', 'wait', 'feet']), ['lead', 'rear', 'feet'], 'three actions: no room for a wait');
  assert.deepEqual(fixWait(['wait', 'lead']), ['lead'], 'no step: no wait');
  assert.ok(waitCan(['feet']) && waitCan(['rear', 'feet']) && !waitCan(['feet', 'rear']) && !waitCan([]) && !waitCan(['lead', 'rear', 'feet'])); });

console.log(`WAIT_TEST ${n} passed`);
