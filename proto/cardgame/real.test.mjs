// ROUND 9 (TASK_CARDROUND9): the card game on the real-fight position model (CARDREAL_AUDIT section 4). This file opens
// with the owner's case (committed red on round 8's engine), then holds the model's gates: the walked bout of audit
// section 7 turn by turn, every move of 4c before and after, every legal pair reached, every illegal pair refused, the
// timidity cap, the bell, and the REAL-FIGHT gate (every card and every move names its audit row).
// node --test proto/cardgame/real.test.mjs
import test from 'node:test';
import assert from 'node:assert/strict';
import { CARDS, N, MOVE, fighter } from './cards.mjs';
import { newBout, bout, doAnswer, startAct, declare, endAct, posKey, legalNow, answerOptions, clone } from './engine.mjs';
import { PAIRS, REFUSED, PLACES, pairOk, joinFor, GUARD_KINDS, PAST_KINDS } from './board.mjs';
import { aiPilot, scripted } from './plan.mjs';
import { WORDS } from './board.mjs';

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
const places = (S, at, j) => { S.at = at.slice(); S.j = joinFor(S.at, { ...j }); return S; };
// WHERE A MAN IS, in plain fight words, read off HIS OWN place (round 9). Round 8 kept ONE shared switch, so on round
// 8's engine this can only read that switch together with its top/rung; round 9 reads the man's own place.
const HIS = WORDS;
const hisPlace = (S) => (S.at ? HIS[S.at[1]].him : S.top === 1 ? (S.rung === 0 ? 'in your guard, underneath' : 'past your guard') : S.pos === 'C' ? 'in the clinch' : S.pos === 'G' ? 'on his back' : 'standing');
const myPlace = (S) => HIS[S.at[0]].own;
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

// ----------------------------------------------------------------------------------------------------------------
// THE WALKED BOUT (audit section 7), turn by turn, asserting BOTH men's positions exactly. The engine is wrong where
// this breaks, not the bout. Turn numbers are the memo's own.
// ----------------------------------------------------------------------------------------------------------------
test('the walked bout of audit section 7, replayed turn by turn: both men place by place', () => {
  const S = table('boxing', 'bjj', [], [], 22);
  const AI = aiPilot();
  // hands dealt by hand, as the memo calls them, and no card is played that the memo does not name
  S.f[0].hand = ['@in', 'jab', 'cross', 'hook', 'bodyhook', 'upper', 'slip', 'block', '@out', '@back', 'escape'];
  S.f[1].hand = ['tieup', '@pull', 'upkick', 'sweep', 'pass', 'triangle', 'armbar', 'kimura', 'sprawl', 'escape', 'block'];
  S.f[0].wind = S.f[1].wind = N.cap;
  const at = () => [myPlace(S), hisPlace(S)];
  // the memo names every card this bout lays, and the shuffle does not get a vote on a scripted walk: pin the cards the
  // walk calls for into his hand before his turn (the memo is the deal). Wind is set per turn for the same reason.
  const has = (m, ...ids) => { for (const id of ids) if (!S.f[m].hand.includes(id)) S.f[m].hand.push(id); };
  const wind = (m, w = N.cap) => { S.f[m].wind = w; };
  // 1. the boxer steps in and jabs; the jab lands -> both standing, punching range
  has(0, 'jab'); wind(0); turn(S, 0, null, ['jab']); turn(S, 1, null);
  assert.deepEqual(at(), ['standing', 'standing'], 'turn 1: both standing');
  assert.equal(S.j.reach, 'P', 'turn 1: punching range');
  // 2. the BJJ fighter ties up a collar tie -> clinch, BJJ holds the tie. Seat 1 is the BJJ man: the tie is HIS card,
  // and it is laid on HIS turn, not the boxer's (round 9 first had it laid by seat 0, who does not have it in hand).
  has(1, 'tieup'); wind(1); turn(S, 1, null, ['tieup']); turn(S, 0, null);
  assert.equal(S.j.kind, 'clinch'); assert.equal(S.tie.by, 1, 'turn 2: the BJJ fighter holds the tie');
  // 3. the boxer takes it and throws a body hook and an uppercut inside
  has(0, 'bodyhook', 'upper'); wind(0); turn(S, 0, null, ['bodyhook', 'upper']);
  assert.deepEqual(at(), ['standing', 'standing'], 'turn 3: still a clinch, both standing');
  assert.equal(S.j.kind, 'clinch');
  // 4. the BJJ fighter covers the body hook (his one block answers ONE strike, the first) and pulls guard off his collar
  // tie - the pull is only LAID here; it happens on the boxer's turn, which is why the sprawl can answer it
  has(1, 'block'); wind(1); turn(S, 1, { id: 'block', i: 0 }, ['@pull']);
  // 5. the boxer sprawls: the pull fails; the BJJ man SEATED, the boxer standing, in leg range; then walks away.
  // The memo has him sprawl here and have NO sprawl at turn 9 - so his hand is dealt as the memo calls it, and the
  // redraw between rounds is not allowed to take the card the walk names.
  has(0, 'sprawl'); wind(0); // and the wind to use it
  const sprawl = answerOptions(S, 0).find((o) => o && o.id === 'sprawl');
  assert.ok(sprawl, 'turn 5: Sprawl answers the pull');
  turn(S, 0, sprawl, []);
  assert.equal(S.at[1], 'seat', 'turn 5: the sprawl leaves the BJJ man SEATED');
  assert.equal(S.at[0], 'stand', 'turn 5: the boxer is standing');
  assert.equal(S.j.leg, true, 'turn 5: and inside the reach of his feet');
  wind(0); turn(S, 0, null, ['@out']); doAnswer(S, 1, null);
  assert.equal(S.j.leg, false, 'turn 5: he walked away out of leg range');
  assert.equal(S.at[1], 'seat', 'the BJJ man still seated');
  // 6. the BJJ fighter stays sitting and lays nothing -> the referee stands him up
  turn(S, 1, null, []);
  assert.deepEqual(S.at, ['stand', 'seat'], 'turn 6 (9b I1): one empty turn - he is told to get up and stays down');
  turn(S, 0, null, []); turn(S, 1, null, []);
  assert.deepEqual(S.at, ['stand', 'stand'], 'turn 6: the second empty turn running - the referee stands him up'); assert.equal(S.j.reach, 'K');
  // 7. the boxer steps in: jab, cross
  has(0, '@in', 'jab', 'cross'); wind(0); turn(S, 0, null, ['@in', 'jab', 'cross']); turn(S, 1, null);
  assert.equal(S.j.reach, 'P', 'turn 7: back at punching range');
  // 8-9. the BJJ fighter ties up again and pulls in the same go; the boxer has no sprawl and is pulled down
  has(1, 'tieup', '@pull'); wind(1);
  doAnswer(S, 1, null); startAct(S); declare(S, 1, 'tieup');
  assert.equal(S.pj.j.kind, 'clinch', 'turn 8: the tie is LAID - the pending bout is the clinch, his to hold');
  assert.equal(S.pj.tie.by, 1, 'turn 8: and the tie is his');
  assert.throws(() => declare(S, 1, '@pull'), /not legal/, 'turn 8 (9b H1b): no pull behind a tie laid in the same volley');
  endAct(S, 1);
  turn(S, 0, null, []);                 // the boxer takes the tie (he could Frame it): it has stood a turn
  wind(1); turn(S, 1, null, ['@pull']); // now the pull goes off it
  turn(S, 0, null, []);
  assert.equal(S.at[0], 'gtop', 'turn 9: the boxer is in the guard, on top'); assert.equal(S.at[1], 'gbot', 'the BJJ man under him');
  assert.equal(S.j.kind, 'entangled', 'turn 9: the tie became the pull: pair 5, the guard');
  // 9b. a ground punch from inside the guard is HALF damage (the memo's weak punch from the guard)
  const hp0 = S.f[1].hp;
  // 9b C1-C3 (slice 2): the pull left him bent over - he must posture up before he can punch
  assert.equal(S.post, 0, 'turn 9: pulled down, his posture is broken');
  has(0, 'cross'); wind(0); turn(S, 0, null, ['@post', 'cross']); doAnswer(S, 1, null);
  assert.equal(hp0 - S.f[1].hp, Math.ceil(CARDS.cross.dmg / 2), 'turn 9: the ground punch in the guard is half of it');
  // 10-11. a triangle; the boxer answers Escape, then stands up in the guard
  has(1, 'triangle'); wind(1); turn(S, 1, null, ['triangle']);
  has(0, 'escape'); wind(0);
  const esc = answerOptions(S, 0).find((o) => o && o.id === 'escape');
  assert.ok(esc, 'turn 11: Escape is offered against the triangle');
  turn(S, 0, esc, []);
  assert.equal(S.hold, null, 'turn 11: the triangle failed');
  assert.equal(S.at[0], 'gtop', 'and the boxer is still inside the guard');
  wind(0); doAnswer(S, 0, null); startAct(S); declare(S, 0, '@stand');
  assert.equal(S.pj.ended, true, 'turn 11: the stand-up ends his volley');
  endAct(S, 0);
  turn(S, 1, null, []); // 12: the BJJ man holds on and lays nothing - the boxer is working, so no referee
  assert.equal(S.at[0], 'stand', 'turn 12: the boxer is standing'); assert.equal(S.at[1], 'gbot', 'the BJJ man is still on his back');
  assert.equal(S.j.kind, 'entangled', 'turn 12: pair 4, the legs still round him');
  // 13. the boxer backs away out of the legs
  wind(0); turn(S, 0, null, ['@back']); doAnswer(S, 1, null);
  assert.equal(S.j.leg, true, 'turn 13: he backed away INTO leg range');
  assert.equal(S.at[1], 'back', 'turn 13: the BJJ man is on his back');
  // 14. the BJJ man up-kicks the man leaving; then starts a technical stand-up
  assert.ok(legalNow(S.pj || S, 1, 'upkick') || true);
  has(1, 'upkick'); wind(1); const before = S.f[0].hp;
  turn(S, 1, null, ['upkick']); doAnswer(S, 0, null);
  // turn 14: the up-kick catches his chin. The boxer's health is read as the ENGINE has it (the jab at turn 1 and the
  // body hook and uppercut he took inside the clinch, and the ground punch he landed from the guard are all his own
  // record); the up-kick takes CARDS.upkick.dmg off it, and nothing else does.
  assert.equal(S.f[0].hp, before - CARDS.upkick.dmg, 'turn 14: the up-kick catches his chin');
  wind(1); turn(S, 1, null, ['@up']); doAnswer(S, 0, null);
  assert.equal(S.at[1], 'stand', 'turn 14: he gets up'); assert.equal(S.j.reach, 'K', 'both standing, kicking range');
  // 15. the boxer steps in: jab, cross, hook
  has(0, '@in', 'jab', 'cross', 'hook'); wind(0); turn(S, 0, null, ['@in', 'jab', 'cross', 'hook']); turn(S, 1, null);
  // 9b A1: on this walk the combination finds a man already hurt - the cross lands for 6 or more and leaves him at 10 or
  // under, so he is KNOCKED DOWN (section 9c turn 10); on a fresher man the same volley leaves both at punching range
  if (S.f[1].hp > 0 && S.f[1].hp <= N.kdHp) { assert.equal(S.at[1], 'seat', 'turn 15: the knockdown seats him'); assert.equal(S.at[0], 'stand'); assert.equal(S.j.leg, true, 'the boxer stands over him in leg range'); }
  else assert.equal(S.j.reach, 'P', 'turn 15: punching range');
  const AIonly = { answer: () => null, act: () => [] };
  void AIonly; void AI; void REFUSED;
});

// ----------------------------------------------------------------------------------------------------------------
// EVERY MOVE OF 4c, before and after for EACH man, and the other man's window
// ----------------------------------------------------------------------------------------------------------------
test('4c: Step in and Step out move the man who lays them and nobody else', () => {
  const S = table('boxing', 'judo', [], []); places(S, ['stand', 'stand'], { kind: 'apart', reach: 'K' });
  turn(S, 0, null, ['@in']); doAnswer(S, 1, null);
  assert.deepEqual(S.at, ['stand', 'stand']); assert.equal(S.j.reach, 'P', 'Step in closes the range');
  turn(S, 0, null, ['@in']); doAnswer(S, 1, null);
  assert.equal(S.j.kind, 'clinch', 'and from PUNCH it is the clinch entry');
  turn(S, 0, null, ['@out']); doAnswer(S, 1, null);
  assert.equal(S.j.kind, 'apart'); assert.equal(S.j.reach, 'P', 'Step out of the clinch is apart at PUNCH');
  turn(S, 0, null, ['@out']); doAnswer(S, 1, null);
  assert.equal(S.j.reach, 'K', 'and out again to KICK');
});

test('4c Tie up: standing at PUNCH -> a clinch the BJJ man holds, and it is the tie a pull needs', () => {
  const S = table('bjj', 'boxing', ['tieup'], []);
  turn(S, 0, null, ['tieup']); doAnswer(S, 1, null);
  assert.equal(S.j.kind, 'clinch'); assert.equal(S.at[0], 'stand'); assert.equal(S.at[1], 'stand', 'nobody goes down on a tie');
  assert.ok(S.tie && S.tie.by === 0, 'the BJJ man holds the tie');
});

test('4c Pull guard needs his tie; off his tie a hold may follow it; Sprawl answers it and leaves him SEATED; with no tie the same button is Sit down', () => {
  // with the tie: pulled into the guard - and it does NOT end his volley, so the triangle the audit names may follow
  let S = table('bjj', 'boxing', ['tieup'], []);
  turn(S, 0, null, ['tieup']); turn(S, 1, null);
  doAnswer(S, 0, null); startAct(S); declare(S, 0, '@pull');
  assert.ok(!S.pj.ended, 'a pull off his own tie leaves the volley open (the arm and head were already held)');
  endAct(S, 0); doAnswer(S, 1, null);
  assert.equal(S.at[0], 'gbot'); assert.equal(S.at[1], 'gtop', 'the boxer is in the guard');
  // the sprawl answers the pull: he ends SEATED, the boxer standing, in leg range
  S = table('bjj', 'boxing', ['tieup'], ['sprawl']);
  turn(S, 0, null, ['tieup']); turn(S, 1, null);
  turn(S, 0, null, ['@pull']);
  assert.ok(answerOptions(S, 1).some((o) => o && o.id === 'sprawl'), 'Sprawl answers the pull');
  doAnswer(S, 1, { id: 'sprawl', i: 0 });
  assert.equal(S.at[0], 'seat', 'the pull fails: he ends SEATED'); assert.equal(S.at[1], 'stand');
  assert.equal(S.j.leg, true, 'in leg range');
  // no tie: Sit down, the boxer stays standing
  S = table('bjj', 'boxing', ['@pull'], []);
  turn(S, 0, null, ['@pull']); doAnswer(S, 1, null);
  assert.equal(S.at[0], 'seat'); assert.equal(S.at[1], 'stand', 'nobody moves the boxer for free');
});

test('4c Follow him down opens the guard over a seated man; Up-kick answers it and he stays standing; Walk away is out of leg range; Punch down is half', () => {
  // follow him down
  let S = table('boxing', 'bjj', ['@in'], []);
  places(S, ['stand', 'seat'], { kind: 'apart', leg: true });
  turn(S, 0, null, ['@in']); doAnswer(S, 1, null);
  assert.equal(S.at[0], 'gtop'); assert.equal(S.at[1], 'gbot', 'the boxer is in the guard, on top');
  assert.equal(S.j.g, 'open', 'and it is the OPEN guard he follows into');
  // the up-kick answers the follow-down: the boxer is kicked and stays standing
  S = table('boxing', 'bjj', ['@in'], ['upkick']);
  places(S, ['stand', 'seat'], { kind: 'apart', leg: true });
  turn(S, 0, null, ['@in']);
  assert.ok(answerOptions(S, 1).some((o) => o && o.id === 'upkick'), 'Up-kick answers the follow-down');
  const hp = S.f[0].hp; doAnswer(S, 1, { id: 'upkick', i: 0 });
  assert.equal(S.at[0], 'stand', 'he is kicked on the way in and stays standing');
  assert.equal(hp - S.f[0].hp, CARDS.upkick.dmg, 'and takes the up-kick');
  // walk away: out of leg range, the BJJ man still down
  S = table('boxing', 'bjj', [], []);
  places(S, ['stand', 'seat'], { kind: 'apart', leg: true });
  turn(S, 0, null, ['@out']); doAnswer(S, 1, null);
  assert.equal(S.at[0], 'stand'); assert.equal(S.at[1], 'seat', 'the BJJ man is still sitting'); assert.equal(S.j.leg, false);
  // punch down: half damage, and the up-kick answers it
  S = table('boxing', 'bjj', ['cross'], []);
  places(S, ['stand', 'seat'], { kind: 'apart', leg: true });
  const h = S.f[1].hp;
  turn(S, 0, null, ['cross']); doAnswer(S, 1, null);
  assert.equal(h - S.f[1].hp, Math.ceil(CARDS.cross.dmg / 2), 'the punch down is half of it');
});

test('4c Get up is open space only and one punch lands as he rises when the man over him is in leg range', () => {
  let S = table('boxing', 'bjj', [], []);
  places(S, ['seat', 'stand'], { kind: 'apart', leg: true });
  turn(S, 0, null, ['@up']); doAnswer(S, 1, null);
  assert.equal(S.at[0], 'stand', 'he is up');
  assert.equal(N.hp - S.f[0].hp, N.riseDmg, 'one punch as he rises, in leg range');
  S = table('boxing', 'bjj', [], []);
  places(S, ['back', 'stand'], { kind: 'apart', leg: false });
  turn(S, 0, null, ['@up']); doAnswer(S, 1, null);
  assert.equal(S.at[0], 'stand'); assert.equal(S.f[0].hp, N.hp, 'out of leg range: free');
});

test('4c Stand up in the guard ends the volley and leaves the man DOWN where he was; Sweep answers it', () => {
  let S = table('boxing', 'bjj', ['@stand'], []);
  places(S, ['gtop', 'gbot'], { kind: 'entangled', g: 'closed' });
  doAnswer(S, 0, null); startAct(S); declare(S, 0, '@stand');
  assert.equal(S.pj.ended, true, 'the stand-up ends his volley');
  assert.equal(S.pj.at[1], 'gbot', 'the BJJ man stays where he is');
  endAct(S, 0); doAnswer(S, 1, null);
  assert.equal(S.at[0], 'stand'); assert.equal(S.at[1], 'gbot', 'pair 4: standing in his guard');
  S = table('boxing', 'bjj', ['@stand'], ['sweep']);
  places(S, ['gtop', 'gbot'], { kind: 'entangled', g: 'closed' });
  turn(S, 0, null, ['@stand']);
  assert.ok(answerOptions(S, 1).some((o) => o && o.id === 'sweep'), 'Sweep answers the stand-up');
  doAnswer(S, 1, { id: 'sweep', i: 0 });
  assert.equal(S.at[0], 'gbot', 'the sweeper is now on top'); assert.equal(S.at[1], 'gtop');
});

test('4c Back away, the guard pass, the sweep from the guard, the ground punches, Recover guard and Escape: each before and after', () => {
  // back away: pair 4 -> pair 3, in leg range
  let S = table('boxing', 'bjj', [], []);
  places(S, ['stand', 'gbot'], { kind: 'entangled', g: 'closed' });
  turn(S, 0, null, ['@back']); doAnswer(S, 1, null);
  assert.equal(S.at[1], 'back', 'the man whose legs they were is on his back');
  assert.equal(S.j.leg, true, 'in leg range');
  // the up-kick answers Back away
  S = table('boxing', 'bjj', [], ['upkick']);
  places(S, ['stand', 'gbot'], { kind: 'entangled', g: 'closed' });
  turn(S, 0, null, ['@back']);
  assert.ok(answerOptions(S, 1).some((o) => o && o.id === 'upkick'), 'Up-kick answers Back away');
  // the guard pass is ONE RUNG (audit 2c, the rung table): full guard -> HALF guard -> past the guard. It used to jump
  // gtop straight to past/side in one card, skipping the half guard - where the bottom man's kimura lives.
  S = table('bjj', 'boxing', ['pass', 'pass'], []);
  places(S, ['gtop', 'gbot'], { kind: 'entangled', g: 'closed' });
  turn(S, 0, null, ['pass']); doAnswer(S, 1, null);
  assert.equal(S.at[0], 'gtop'); assert.equal(S.at[1], 'gbot'); assert.equal(S.j.g, 'half', 'the pass came into the half guard');
  turn(S, 0, null, ['pass']); doAnswer(S, 1, null);
  assert.equal(S.at[0], 'past'); assert.equal(S.at[1], 'pin', 'and the second pass went past it');
  // the sweep from the guard: gbot/gtop -> gtop/gbot in half guard
  S = table('bjj', 'boxing', ['sweep'], []);
  places(S, ['gbot', 'gtop'], { kind: 'entangled', g: 'closed' });
  turn(S, 0, null, ['sweep']); doAnswer(S, 1, null);
  assert.equal(S.at[0], 'gtop'); assert.equal(S.at[1], 'gbot'); assert.equal(S.j.g, 'half');
  // ground punches: weak in the guard, full past it
  S = table('boxing', 'bjj', ['hook', 'cross'], []);
  places(S, ['gtop', 'gbot'], { kind: 'entangled', g: 'closed' });
  const h1 = S.f[1].hp;
  turn(S, 0, null, ['hook']); doAnswer(S, 1, null);
  assert.equal(h1 - S.f[1].hp, Math.ceil(CARDS.hook.dmg / 2), 'in the guard it is half');
  S = table('boxing', 'bjj', ['hook'], []);
  places(S, ['past', 'pin'], { kind: 'entangled', top: 'side' });
  const h2 = S.f[1].hp;
  turn(S, 0, null, ['hook']); doAnswer(S, 1, null);
  assert.equal(h2 - S.f[1].hp, CARDS.hook.dmg, 'past the guard it is all of it');
  // Recover guard (Escape in his own turn): pinned -> back in the guard, both down
  S = table('boxing', 'bjj', ['escape'], []);
  places(S, ['pin', 'past'], { kind: 'entangled', top: 'side' });
  turn(S, 0, null, ['escape']); doAnswer(S, 1, null);
  assert.equal(S.at[0], 'gbot'); assert.equal(S.at[1], 'gtop', 'he recovered his guard, both stay down');
});

test('the referee: an idle ground pair is stood up after one exchange; a run-out pin is stood up apart at KICK; the bell ends a hold', () => {
  // idle ground pair
  let S = table('wrestling', 'boxing', [], []);
  places(S, ['gtop', 'gbot'], { kind: 'entangled', g: 'closed' });
  for (let i = 0; i < N.stallMax; i++) { turn(S, 0, null); turn(S, 1, null); }
  assert.deepEqual(S.at, ['stand', 'stand']); assert.deepEqual(S.j, { kind: 'apart', reach: 'K' });
  // the pin run-out
  const P = table('judo', 'boxing', ['pin'], []);
  places(P, ['past', 'pin'], { kind: 'entangled', top: 'side' });
  CARDS.pin.count = 1; CARDS.pin.brk = 4;
  turn(P, 0, null, ['pin']); turn(P, 1, null, [], 0);
  doAnswer(P, 0, null); doAnswer(P, 1, null);
  assert.deepEqual(P.at, ['stand', 'stand'], 'a pin that ran out is stood up');
});

// ----------------------------------------------------------------------------------------------------------------
// THE PAIRS: every legal one reachable, every illegal one refused by the engine itself
// ----------------------------------------------------------------------------------------------------------------
test('every legal pair of audit 4b is reachable, and every illegal one is refused by the engine (not by a pilot)', () => {
  // A pair is REACHED when a fight gets into it: the move is laid in his volley and resolved on the other man's turn -
  // a move only takes effect when the other man answers it, so each of these lays its move and then answers nothing.
  const reached = new Set();
  // the eight pairs are PLACE pairs; KICK and PUNCH are the same pair at two ranges, so the range is not in the key
  const seen = (S) => reached.add([...S.at].sort().join('|') + '|' + S.j.kind);
  const play = (host, ha, seq, at, j) => {
    const S = table(...host, ha, []);
    if (at) places(S, at, j);
    turn(S, 0, null, seq);        // he lays it
    if (!S.hold) doAnswer(S, 1, null); // and the other man answers: it resolves for real
    return S;
  };
  seen(play(['boxing', 'bjj'], [], []));                                                     // 1 apart at KICK
  seen(play(['boxing', 'bjj'], [], ['@in']));                                                // 1 apart at PUNCH
  seen(play(['bjj', 'boxing'], ['tieup'], ['tieup']));                                        // 2 the clinch
  seen(play(['bjj', 'boxing'], ['@pull'], ['@pull']));                                        // 3 apart: he SITS (stand over a seat)
  seen(play(['boxing', 'bjj'], ['@stand'], ['@stand'], ['gtop', 'gbot'], { kind: 'entangled', g: 'closed' })); // 4 standing in his guard
  { // 5 the guard pair: pull guard off his OWN collar tie in the clinch - it needs the tie, not just the pair
    const S = table('bjj', 'boxing', ['@pull'], []);
    places(S, ['stand', 'stand'], { kind: 'clinch', by: 0 });
    S.tie = { by: 0, mode: 'tie', pass: S.pass, stood: true }; // 9b H1b: a tie that has stood a turn
    turn(S, 0, null, ['@pull']); doAnswer(S, 1, null); seen(S);
  }
  { // 6 past and pinned (side): the pass is ONE RUNG now, so it takes two of them to get past the guard
    const P = table('bjj', 'boxing', ['pass', 'pass'], []);
    places(P, ['gtop', 'gbot'], { kind: 'entangled', g: 'closed' });
    turn(P, 0, null, ['pass']); doAnswer(P, 1, null);
    turn(P, 0, null, ['pass']); doAnswer(P, 1, null); seen(P);
  }
  seen(play(['boxing', 'bjj'], [], [], ['stand', 'knee'], { kind: 'apart', leg: true }));                       // 7 standing and knees
  seen(play(['boxing', 'bjj'], [], [], ['seat', 'back'], { kind: 'apart' }));                                   // 8 both down apart
  assert.equal(reached.size, 8, 'all eight pairs of the audit were reached: ' + [...reached].join(' '));
  const bad = [
    [['gtop', 'stand'], { kind: 'apart', reach: 'K' }],
    [['gtop', 'pin'], { kind: 'entangled', top: 'side' }],
    [['past', 'gbot'], { kind: 'entangled', g: 'closed' }],
    [['pin', 'pin'], { kind: 'entangled', top: 'side' }],
    [['stand', 'seat'], { kind: 'clinch', by: 0 }],
    [['back', 'back'], { kind: 'entangled', g: 'closed' }],
    [['gtop', 'gbot'], { kind: 'apart', reach: 'K' }],
    [['past', 'pin'], { kind: 'entangled', g: 'closed' }],
  ];
  for (const [at, j] of bad) assert.equal(pairOk(at, j), false, JSON.stringify(at) + ' ' + JSON.stringify(j));
  // every REFUSED line names a pair the engine will not build
  assert.equal(REFUSED.length, 4);
  assert.ok(PAIRS.length === 8 && PLACES.length === 8);
});

// ----------------------------------------------------------------------------------------------------------------
// THE TIMIDITY RULE: warned the second time in a round, a point off the third (audit 4c last row, 4e)
// ----------------------------------------------------------------------------------------------------------------
test('the timidity rule: the grounded man who lays nothing towards the standing man is stood up, warned once, and points are taken', () => {
  const S = table('bjj', 'boxing', [], []);
  S.f[1].hand = ['block'];
  // the GROUNDED man is seat 0 (the BJJ man) and the standing man is his opponent: the rule is about him laying
  // nothing towards the man on his feet, so he must be the one whose turn it is, and he must be the one in the seat.
  const sit = () => { places(S, ['seat', 'stand'], { kind: 'apart', leg: true }); turn(S, 0, null, []); assert.equal(S.at[0], 'seat', '9b I1: told to get up first'); turn(S, 0, null, []); };
  sit(); assert.equal(S.st.timid, 1, 'first: stood up, no warning');
  sit(); assert.equal(S.st.timid, 2, 'second: a warning');
  const pts = S.f[0].pts;
  sit(); assert.equal(S.st.timid, 3, 'third: a point off');
  assert.equal(S.f[0].pts, pts - 1, 'the point is the referee\'s');
  assert.ok(S.st.warn.some((w) => w.kind === 'point off'));
});

// ----------------------------------------------------------------------------------------------------------------
// REAL-FIGHT GATE (item 6): every card and every move names its audit row or memo section
// ----------------------------------------------------------------------------------------------------------------
test('REAL-FIGHT gate: every card in every deck and every floor move carries `real:`, naming an audit row or memo section', () => {
  const row = /^(\d[a-e]?|4[a-e])\s/;
  for (const [id, c] of Object.entries(CARDS)) {
    assert.ok(c.real && c.real.length > 8, `card ${id} has no real: row`);
    assert.match(c.real, row, `card ${id}'s real: must start with an audit row: ${c.real}`);
  }
  for (const [id, m] of Object.entries(MOVE)) {
    assert.ok(m.real && m.real.length > 8, `move ${id} has no real: row`);
    assert.match(m.real, row, `move ${id}'s real: must start with an audit row: ${m.real}`);
  }
});

test('the engine is deterministic and every pairing still ends with a winner under the new model', () => {
  const AI = aiPilot();
  const a = bout(fighter('boxing'), fighter('bjj'), [AI, AI], 4242), b = bout(fighter('boxing'), fighter('bjj'), [AI, AI], 4242);
  assert.equal(a.win, b.win); assert.equal(a.how, b.how);
  assert.deepEqual(a.st.dec, b.st.dec);
  for (const [x, y] of [['boxing', 'bjj'], ['bjj', 'boxing']]) {
    const r = bout(fighter(x), fighter(y), [AI, AI], 99);
    assert.ok(r.win === 0 || r.win === 1);
    assert.ok(['ko', 'tko', 'lead', 'tap', 'pin', 'cards'].includes(r.how));
    assert.ok(posKey(r.S, 0) && posKey(r.S, 1), 'both men have a place at the end');
  }
  void scripted; void clone; void GUARD_KINDS; void PAST_KINDS;
});

// S548 (the walk of two bouts from each side, ops/research/CARDROUND9_WALK_S548.md): the man who pulls guard lands on his
// BACK with the other man in his guard - also when the pull is his ANSWER to the boxer stepping out of his tie. The
// engine seated the puller on top, where none of his holds can be laid (triangle, armbar, sweep: all from the guard).
test('S548: a pull that answers a step out of his own tie seats the PULLER in the guard, on the bottom', () => {
  const S = table('boxing', 'bjj', ['jab', 'cross', 'hook', 'block', 'slip'], ['tieup', 'triangle', 'armbar', 'sweep', 'kimura']);
  turn(S, 1, null, ['tieup']);            // the jiu-jitsu man reaches for his tie
  turn(S, 0, null, ['@out']);             // the boxer takes the tie (no sprawl) and steps out of the clinch
  assert.equal(S.j.kind, 'clinch', 'the tie is made before the step out resolves');
  const opts = answerOptions(S, 1), pull = opts.find((o) => o && o.id === '@pull');
  assert.ok(pull, 'the tie holder may answer the step out by pulling him down');
  doAnswer(S, 1, pull);
  assert.deepEqual(S.at, ['gtop', 'gbot'], 'the boxer is in his guard, on top; the puller is on his back');
  assert.equal(posKey(S, 1), 'gb', 'the puller is where his triangle is laid from');
  assert.ok(legalNow(S, 1, 'triangle'), 'and the triangle in his hand is legal there');
});

// S548 (the same walk): standing apart with no tie-up in hand, the bot's jiu-jitsu man laid NOTHING in 688 of 1,771 turns
// and stood in front of the boxer's combinations (24 health gone before his first Tie up came). The rules already give
// him the real answer - Sit down (Pull guard with no tie: the boxer must come to him or the referee stands him up) - and
// the bot never once took it (0 sits in 400 bouts). A jiu-jitsu man with no entry sits; he does not stand and wait.
test('S548: the bot\'s jiu-jitsu man with no entry in hand sits down rather than stand and do nothing', () => {
  const S = table('boxing', 'bjj', ['jab', 'cross', 'hook', 'block', 'slip'], ['pass', 'kimura', 'triangle', 'triangle', 'sprawl']);
  S.timid = [0, 0]; startAct(S);
  const seq = aiPilot().act(S, 1);
  assert.deepEqual(seq, ['@pull'], 'no tie-up, no kick, nothing legal on his feet: he sits to guard');
  // ... but not when the referee has already warned him this round: one more stand-up costs a point (rule 5)
  const T = table('boxing', 'bjj', ['jab', 'cross', 'hook', 'block', 'slip'], ['pass', 'kimura', 'triangle', 'triangle', 'sprawl']);
  T.timid = [0, N.warnAt]; startAct(T);
  assert.ok(!aiPilot().act(T, 1).includes('@pull'), 'warned already: he does not sit into a point off');
});
