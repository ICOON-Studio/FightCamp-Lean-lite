// node --test proto/boxcards/boxcards3.test.mjs - the defence is laid, not asked
import test from 'node:test';
import assert from 'node:assert/strict';
import { newBout, exchange, lines, legalLine, bout, N } from './rules3.mjs';
import { PILOTS } from './bot3.mjs';
const table = (a, d) => { const S = newBout(1); S.f[0].hand = [...a]; S.f[1].hand = [...d]; return S; };
const kinds = (ev) => ev.map((e) => e.t).join(',');

test('a punch that meets nothing lands, with no question asked', () => {
  const S = table(['jab', 'cross'], ['block']); assert.equal(kinds(exchange(S, 0, ['jab', 'cross'], [null, null])), 'clean,clean'); assert.equal(S.f[1].daze, 4); });
test('a block laid against a body hook is wasted and paid for', () => {
  const S = table(['body'], ['block']); assert.equal(kinds(exchange(S, 0, ['body'], [{ id: 'block' }])), 'wasted,body'); assert.equal(S.f[1].wind, N.cap - 1); assert.deepEqual(S.f[1].hand, []); });
test('a feint draws out the answer laid against it', () => {
  const S = table(['feint', 'cross'], ['slip', 'hook']); const ev = exchange(S, 0, ['feint', 'cross'], [{ id: 'slip', with: 'hook' }, null]);
  assert.equal(kinds(ev), 'feint,drawn,clean'); assert.deepEqual(S.f[1].hand, ['hook']); assert.equal(S.f[1].wind, N.cap - 1); });
test('a slip and counter stops the volley; his unreached answer and the unthrown card come back free', () => {
  const S = table(['cross', 'hook'], ['slip', 'jab', 'block']); const ev = exchange(S, 0, ['cross', 'hook'], [{ id: 'slip', with: 'jab' }, { id: 'block' }]);
  assert.equal(kinds(ev), 'slipped,counter,clean,kept'); assert.deepEqual(S.f[1].hand, ['block']); assert.deepEqual(S.f[0].hand, ['hook']); assert.equal(S.f[0].daze, 1); });
test('a jab is never countered: the slip works, the counter stays in hand', () => {
  const S = table(['jab'], ['slip', 'cross']); assert.equal(kinds(exchange(S, 0, ['jab'], [{ id: 'slip', with: 'cross' }])), 'slipped'); assert.deepEqual(S.f[1].hand, ['cross']); assert.equal(S.f[1].wind, N.cap - 1); });
test('a line must be paid for and come from the hand; no clinch on the first card, one step back a line', () => {
  const S = table(['jab'], ['clinch', 'step', 'step', 'block']);
  assert.equal(legalLine(S, 1, [{ id: 'clinch' }, null], 2), false); assert.equal(legalLine(S, 1, [{ id: 'step' }, { id: 'step' }], 2), false);
  assert.equal(legalLine(S, 1, [{ id: 'slip' }], 1), false); assert.equal(legalLine(S, 1, [{ id: 'block' }, { id: 'clinch' }], 2), true);
  assert.ok(lines(S, 1, 2).every((l) => legalLine(S, 1, l, 2))); assert.deepEqual(lines(S, 1, 2)[0], [null, null]); });
test('the same seed plays the same bout, and a man who never defends loses to the reader', () => {
  const a = bout([PILOTS.reader(), PILOTS.reader()], 11), b = bout([PILOTS.reader(), PILOTS.reader()], 11); assert.deepEqual([a.win, a.how, a.t], [b.win, b.how, b.t]);
  let w = 0; for (let s = 1; s <= 20; s++) if (bout([PILOTS.taker(), PILOTS.reader()], s, { first: s % 2 }).win === 0) w++; assert.ok(w <= 4, 'taker won ' + w); });
