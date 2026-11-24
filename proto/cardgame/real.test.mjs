// ROUND 9 (TASK_CARDROUND9): the card game on the real-fight position model (CARDREAL_AUDIT section 4). This file opens
// with the owner's case (committed red on round 8's engine), then holds the model's gates: the walked bout of audit
// section 7 turn by turn, every move of 4c before and after, every legal pair reached, every illegal pair refused, the
// timidity cap, the bell. node --test proto/cardgame/real.test.mjs
import test from 'node:test';
import assert from 'node:assert/strict';
import { CARDS, N, fighter } from './cards.mjs';
import { newBout, doAnswer, startAct, declare, endAct, posKey } from './engine.mjs';

// both hands set by hand and full wind; seat 0 = a, seat 1 = b
function table(a, b, ha, hb, seed = 7) {
  const S = newBout(fighter(a), fighter(b), seed);
  S.f[0].hand = ha.slice(); S.f[1].hand = hb.slice(); S.f[0].wind = S.f[1].wind = N.cap;
  return S;
}
// one turn for m: answer what was thrown at him, then lay his own volley (a move that ends the volley stops it)
function turn(S, m, ans, seq = [], wind = N.cap) {
  S.f[m].wind = wind;
  doAnswer(S, m, ans);
  if (S.over || S.hold) return S;
  startAct(S);
  for (const id of seq) declare(S, m, id);
  endAct(S, m);
  return S;
}
// WHERE A MAN IS, in plain fight words, read off the state. Round 8 keeps ONE shared switch, so on round 8's engine
// this can only read that switch; round 9 keeps each man's own place and the same words are read from it.
const HIS = { stand: 'standing', seat: 'sitting on the floor', back: 'on his back', knee: 'on his knees', gtop: 'in your guard, on top', gbot: 'in your guard, underneath', past: 'past your guard', pin: 'pinned under you' };
const hisPlace = (S) => (S.at ? HIS[S.at[1]] : S.top === 1 ? (S.rung === 0 ? 'in your guard, underneath' : 'past your guard') : S.pos === 'C' ? 'in the clinch' : S.pos === 'G' ? 'on his back' : 'standing');
const theBoxerIsInHisGuard = (S) => {
  S.at = ['gtop', 'gbot']; S.j = { kind: 'entangled', g: 'closed' }; // round 9: each man's own place
  S.pos = 'G'; S.top = 0; S.rung = 0; // round 8's ONE shared switch, so the same case can be laid on both engines
  return S;
};

test("the owner's case, S543: the boxer stands up out of the jiu-jitsu fighter's guard - the jiu-jitsu man is STILL ON HIS BACK, and no jab or cross can be laid at him in that volley", () => {
  const S = theBoxerIsInHisGuard(table('boxing', 'bjj', ['@stand', 'jab', 'cross'], []));
  doAnswer(S, 0, null); startAct(S);
  declare(S, 0, '@stand');
  assert.equal(hisPlace(S.pj), 'in your guard, underneath', 'the jiu-jitsu man is still on his back when the boxer stands up out of his guard');
  assert.throws(() => declare(S, 0, 'jab'), /not legal/, 'no jab can be laid at a man on his back');
  assert.throws(() => declare(S, 0, 'cross'), /not legal/, 'no cross either');
});
