// ROUND 9b SLICE 2 (S549, CARDREAL_AUDIT section 9a rows C, D, E and B4): one test per row, committed red before the build.
// C posture in the guard, D a punch from inside the guard gives up an arm, E standing in the guard (full punches, the
// guard opens, Hold the legs). node --test proto/cardgame/r9b2.test.mjs
import test from 'node:test';
import assert from 'node:assert/strict';
import { N, MOVE, CARDS, fighter } from './cards.mjs';
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
const offered = (S, m, id) => answerOptions(S, m).some((x) => x && x.id === id);
const BOX = ['jab', 'cross', 'hook', 'upper', 'block'], BJJ = ['tieup', 'triangle', 'armbar', 'sweep', 'kimura'];
// the boxer (seat 0) in the jiu-jitsu man's closed guard, on top
const inGuard = (g = 'closed') => places(table('boxing', 'bjj', BOX, BJJ), ['gtop', 'gbot'], { g });

test('9b C1: a pull leaves the man on top with his posture BROKEN; following him down leaves it UP', () => {
  const S = table('boxing', 'bjj', BOX, BJJ);
  S.j = { kind: 'clinch', by: 1 }; S.tie = { by: 1, mode: 'tie', pass: S.pass - 1, stood: true };
  turn(S, 1, null, ['@pull']);
  doAnswer(S, 0, null);
  assert.deepEqual(S.at, ['gtop', 'gbot'], 'pulled into the guard');
  assert.equal(S.post, 0, 'the pulled man is bent over: posture broken');
  const T = places(table('boxing', 'bjj', BOX, BJJ), ['stand', 'back'], { kind: 'apart', leg: true });
  turn(T, 0, null, ['@in']);
  doAnswer(T, 1, null);
  assert.deepEqual(T.at, ['gtop', 'gbot'], 'he followed him down');
  assert.notEqual(T.post, 0, 'he came down on his own terms: posture up');
});

test('9b C3: with his posture broken a punch from inside the guard is not legal', () => {
  const S = inGuard(); S.post = 0;
  doAnswer(S, 0, null); startAct(S);
  assert.equal(legalNow(S.pj, 0, 'cross'), false, 'bent over in the guard he cannot punch');
  assert.throws(() => declare(S, 0, 'cross'), /not legal/);
  const T = inGuard();
  doAnswer(T, 0, null); startAct(T);
  assert.equal(legalNow(T.pj, 0, 'cross'), true, 'with posture he punches');
});

test('9b C2: Posture up - 1 wind, no card - and the punch goes behind it in the same volley', () => {
  const S = inGuard(); S.post = 0;
  doAnswer(S, 0, null); startAct(S);
  assert.equal(legalNow(S.pj, 0, '@post'), true, 'broken: he may posture up');
  const w = S.f[0].wind;
  declare(S, 0, '@post');
  assert.equal(S.f[0].wind, w - N.postW, 'it costs its wind and no card');
  assert.equal(legalNow(S.pj, 0, 'cross'), true, 'and now the punch is legal behind it');
  declare(S, 0, 'cross'); endAct(S, 0);
  doAnswer(S, 1, null);
  assert.notEqual(S.post, 0, 'posture is up');
  assert.ok(S.f[1].hp < N.hp, 'the punch landed');
  assert.ok(MOVE['@post'].real, 'the move names its row');
  const U = inGuard();
  doAnswer(U, 0, null); startAct(U);
  assert.equal(legalNow(U.pj, 0, '@post'), false, 'with posture up there is nothing to posture');
});

test('9b C2: he gives an arm to post - the Triangle or the Armbar may answer Posture up', () => {
  for (const hold of ['triangle', 'armbar']) {
    const S = inGuard(); S.post = 0;
    turn(S, 0, null, ['@post']);
    turn(S, 1, hold, []);
    assert.ok(S.hold && S.hold.by === 1 && S.hold.card === hold, `${hold} is on as he posts`);
  }
});

test('9b C5: breaking a hold leaves the SAME kind of guard as before it (the half guard stays the half guard)', () => {
  const S = inGuard('half');
  turn(S, 1, null, ['kimura']);
  doAnswer(S, 0, null);
  assert.ok(S.hold && S.hold.by === 1, 'the kimura is on from the half guard');
  S.f[0].wind = 99;
  doAnswer(S, 1, null);
  doAnswer(S, 0, answerOptions(S, 0).find((x) => x && x.id === '@break'));
  assert.equal(S.hold, null, 'broken');
  assert.deepEqual(S.at, ['gtop', 'gbot']);
  assert.equal(S.j.g, 'half', 'still the half guard, not a closed one');
});

test('9b D1: a punch from inside the guard gives up an arm - the Armbar or the Triangle answers the punch itself', () => {
  for (const hold of ['armbar', 'triangle']) {
    const S = inGuard();
    turn(S, 0, null, ['cross']);
    turn(S, 1, hold, []);
    assert.equal(S.f[1].hp, N.hp, `${hold}: the punch did not land`);
    assert.ok(S.hold && S.hold.by === 1 && S.hold.card === hold, `${hold} is on, on the punching arm`);
  }
  const T = table('boxing', 'bjj', BOX, BJJ);
  T.j = { kind: 'apart', reach: 'P' };
  turn(T, 0, null, ['cross']);
  doAnswer(T, 1, null);
  assert.equal(offered(T, 1, 'armbar'), false, 'on the feet a punch is not an arm to take');
});

test('9b E1: a punch down from STANDING IN THE GUARD lands in full; over a seated man it stays half', () => {
  const S = places(table('boxing', 'bjj', BOX, BJJ), ['stand', 'gbot'], { g: 'closed' });
  turn(S, 0, null, ['cross']);
  doAnswer(S, 1, null);
  assert.equal(S.f[1].hp, N.hp - CARDS.cross.dmg, 'standing in his guard: the whole cross');
  const T = places(table('boxing', 'bjj', BOX, BJJ), ['stand', 'seat'], { kind: 'apart', leg: true });
  T.f[1].hp = 20; // not a knockdown case: he is already down
  turn(T, 0, null, ['cross']);
  doAnswer(T, 1, null);
  assert.equal(T.f[1].hp, 20 - Math.ceil(CARDS.cross.dmg / 2), 'over a seated man: half, as before');
});

test('9b E1: the man underneath answers the punch down with a Sweep (he is swept as he punches) or the Armbar', () => {
  const S = places(table('boxing', 'bjj', BOX, BJJ), ['stand', 'gbot'], { g: 'closed' });
  turn(S, 0, null, ['cross']);
  turn(S, 1, 'sweep', []);
  assert.equal(S.f[1].hp, N.hp, 'the punch did not land');
  assert.deepEqual(S.at, ['gbot', 'gtop'], 'swept: the jiu-jitsu man comes up on top');
  const T = places(table('boxing', 'bjj', BOX, BJJ), ['stand', 'gbot'], { g: 'closed' });
  turn(T, 0, null, ['cross']);
  turn(T, 1, 'armbar', []);
  assert.equal(T.f[1].hp, N.hp, 'the punch did not land');
  assert.ok(T.hold && T.hold.by === 1 && T.hold.card === 'armbar', 'the armbar is on the punching arm');
  assert.deepEqual(T.at, ['gtop', 'gbot'], 'he is pulled back down into the guard');
  assert.equal(T.post, 0, 'bent over: posture broken');
});

test('9b E2: standing up in a CLOSED guard opens it', () => {
  const S = inGuard();
  turn(S, 0, null, ['@stand']);
  doAnswer(S, 1, null);
  assert.deepEqual(S.at, ['stand', 'gbot'], 'he stands in the guard');
  assert.equal(S.j.g, 'open', 'and the guard is open');
});

test('9b B4 + E3: Hold the legs - 2 wind, no card - keeps the guard closed, and he cannot back away that turn', () => {
  const S = inGuard();
  turn(S, 0, null, ['@stand']);
  const w = N.cap;
  turn(S, 1, '@hold', [], w);
  assert.equal(S.f[1].wind, w - N.holdW, 'it costs its wind and no card');
  assert.deepEqual(S.at, ['stand', 'gbot'], 'he stands');
  assert.equal(S.j.g, 'closed', 'but the legs stay locked round him');
  doAnswer(S, 0, null); startAct(S);
  assert.equal(legalNow(S.pj, 0, '@back'), false, 'legs held: no backing away this turn');
  assert.equal(legalNow(S.pj, 0, 'cross'), true, 'he may punch down');
  declare(S, 0, 'cross'); endAct(S, 0);  // (a turn with nothing laid by either man brings the referee)
  assert.equal(S.j.g, 'open', 'the hold lasts his one turn: then the guard opens');
  assert.ok(MOVE['@hold'].real, 'the move names its row');
});

test('9b B4: Hold the legs answers Back away too (it fails), at most 2 turns running - then he is out', () => {
  const S = inGuard();
  turn(S, 0, null, ['@stand']);
  turn(S, 1, '@hold', []);            // 1st hold
  turn(S, 0, null, ['cross']);        // stuck a turn: he punches down; the guard opens
  turn(S, 1, null, []);
  turn(S, 0, null, ['@back']);
  turn(S, 1, '@hold', []);            // 2nd hold running: the back-away fails
  assert.deepEqual(S.at, ['stand', 'gbot'], 'still standing in the guard');
  assert.equal(S.j.g, 'closed', 'the legs are locked again');
  turn(S, 0, null, ['hook']);
  S.gnp = [0, 0];                     // (two turns of punches on a man who lays nothing back is the stoppage, A2: its own test)
  turn(S, 1, null, []);
  turn(S, 0, null, ['@back']);
  assert.equal(offered(S, 1, '@hold'), false, 'a third hold running is not offered: the cap of the loop');
  doAnswer(S, 1, null);
  assert.deepEqual(S.at, ['stand', 'back'], 'he is out of the legs');
});
