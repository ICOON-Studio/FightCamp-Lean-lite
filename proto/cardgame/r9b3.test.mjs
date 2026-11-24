// ROUND 9b SLICE 3 (S549, CARDREAL_AUDIT section 9a rows F1, I3, I4, I5): one test per row, committed red before the build.
// G (the body-lock trip) is NOT in this slice. node --test proto/cardgame/r9b3.test.mjs
import test from 'node:test';
import assert from 'node:assert/strict';
import { N, MOVE, fighter } from './cards.mjs';
import { newBout, doAnswer, startAct, declare, endAct, legalNow, answerOptions } from './engine.mjs';
import { joinFor } from './board.mjs';

function table(a, b, ha, hb, seed = 7) {
  const S = newBout(fighter(a), fighter(b), seed);
  S.f[0].hand = ha.slice(); S.f[1].hand = hb.slice(); S.f[0].wind = S.f[1].wind = N.cap;
  return S;
}
function turn(S, m, ans, seq = [], wind = N.cap) {
  S.f[m].wind = wind;
  const o = typeof ans === 'string' ? answerOptions(S, m).find((x) => x && x.id === ans) : ans;
  if (typeof ans === 'string') assert.ok(o, `${ans} is offered as an answer here`);
  doAnswer(S, m, o || null);
  if (S.over || S.hold) return S;
  startAct(S);
  for (const id of seq) declare(S, m, id);
  endAct(S, m);
  return S;
}
const places = (S, at, j) => { S.at = at.slice(); S.j = joinFor(S.at, { ...j }); return S; };
const BOX = ['jab', 'cross', 'hook', 'escape', 'block'], BJJ = ['tieup', 'triangle', 'armbar', 'sweep', 'kimura'];

test('9b F1: the jiu-jitsu fighter punches from on top - 1 wind, no card, 2 damage - past the guard only', () => {
  N.topOn = 1; // built and switched OFF in cards.mjs (measured: boxing 36-39%); the test switches the rule on
  const S = places(table('bjj', 'boxing', BJJ, BOX), ['past', 'pin'], { top: 'side' });
  doAnswer(S, 0, null); startAct(S);
  assert.equal(legalNow(S.pj, 0, '@gnp'), true, 'from side control he may punch');
  const w = S.f[0].wind;
  declare(S, 0, '@gnp'); declare(S, 0, '@gnp'); endAct(S, 0);
  assert.equal(S.f[0].wind, w - 2 * N.topW, 'each costs its wind and no card');
  doAnswer(S, 1, null);
  assert.equal(S.f[1].hp, N.hp - 2 * N.topDmg, 'both land');
  assert.ok(MOVE['@gnp'].real, 'the move names its row');
  const G = places(table('bjj', 'boxing', BJJ, BOX), ['gtop', 'gbot'], { g: 'closed' });
  doAnswer(G, 0, null); startAct(G);
  assert.equal(legalNow(G.pj, 0, '@gnp'), false, 'not from inside the guard');
  const B = places(table('boxing', 'bjj', BOX, BJJ), ['past', 'pin'], { top: 'side' });
  doAnswer(B, 0, null); startAct(B);
  assert.equal(legalNow(B.pj, 0, '@gnp'), false, 'the boxer has his own punches: this rule is the jiu-jitsu fighter\'s');
  N.topOn = 0;
});

test('9b F1: Cover up takes the sting out of it; the Escape card recovers guard as he punches', () => {
  N.topOn = 1;
  const S = places(table('bjj', 'boxing', BJJ, BOX), ['past', 'pin'], { top: 'side' });
  turn(S, 0, null, ['@gnp']);
  turn(S, 1, '@cover', []);
  assert.equal(S.f[1].hp, N.hp - Math.max(0, N.topDmg - N.cover), 'covered');
  const T = places(table('bjj', 'boxing', BJJ, BOX), ['past', 'pin'], { top: 'side' });
  turn(T, 0, null, ['@gnp']);
  turn(T, 1, 'escape', []);
  assert.equal(T.f[1].hp, N.hp, 'the punch did not land');
  assert.deepEqual(T.at, ['gtop', 'gbot'], 'he has a guard again');
  N.topOn = 0;
});

test('9b I3: a pull is an attempt - the man seated by a FAILED pull is not charged with timidity when he is stood up', () => {
  const S = table('boxing', 'bjj', ['sprawl', 'jab', 'cross', 'hook', 'block'], BJJ);
  S.j = { kind: 'clinch', by: 1 }; S.tie = { by: 1, mode: 'tie', pass: S.pass - 1, stood: true };
  turn(S, 1, null, ['@pull']);
  turn(S, 0, 'sprawl', ['@out']);       // the pull fails: he is seated; the boxer walks away
  assert.equal(S.at[1], 'seat', 'the failed pull left him seated');
  turn(S, 1, null, []); turn(S, 0, null, []); turn(S, 1, null, []);   // two empty turns: stood up
  assert.deepEqual(S.at, ['stand', 'stand'], 'the referee stood him up');
  assert.equal(S.timid[1], 0, 'he tried: no timidity count');
  const T = table('boxing', 'bjj', BOX, BJJ);
  T.j = { kind: 'apart', reach: 'P' };
  turn(T, 1, null, ['@pull']);          // no tie: this is a Sit down
  turn(T, 0, null, ['@out']);
  turn(T, 1, null, []); turn(T, 0, null, []); turn(T, 1, null, []);
  assert.deepEqual(T.at, ['stand', 'stand']);
  assert.equal(T.timid[1], 1, 'a sit with no tie still counts');
});

test('9b I4: a clinch held through a whole exchange with nothing laid by either man is broken', () => {
  const S = table('boxing', 'bjj', BOX, BJJ);
  S.j = { kind: 'clinch', by: 1 }; S.tie = { by: 1, mode: 'tie', pass: S.pass, stood: false };
  turn(S, 0, null, []);
  assert.equal(S.j.kind, 'clinch', 'one empty turn: still tied up');
  turn(S, 1, null, []);
  assert.equal(S.j.kind, 'apart', 'both turns empty: the referee breaks it'); assert.equal(S.j.reach, 'P', 'at punching range');
  assert.equal(S.tie, null, 'no tie');
});

test('9b I5: nobody working with a man STANDING in the guard - the legs are opened: he stands over a man on his back', () => {
  const S = places(table('boxing', 'bjj', BOX, BJJ), ['stand', 'gbot'], { g: 'open' });
  for (let i = 0; i < 2 * N.stallMax; i++) turn(S, i % 2, null, []);
  assert.deepEqual(S.at, ['stand', 'back'], 'not both stood up at kicking range: he must still pass the feet to leave');
  assert.equal(S.j.kind, 'apart'); assert.equal(S.j.leg, true, 'inside the reach of his feet');
});
