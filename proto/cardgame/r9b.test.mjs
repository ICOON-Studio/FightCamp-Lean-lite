// ROUND 9b (TASK_CARDROUND9B, CARDREAL_AUDIT section 9): one test per changed row, each committed red before its build.
// Slice 1 (S548): H1 Frame, H1b the tie must stand, H3 recover guard, I1 "get up" before the stand-up, A1 the knockdown,
// A2 the stoppage, B1 Keep your base, B2 Escape a hold as it is laid, B3 the Up-kick with no card.
// node --test proto/cardgame/r9b.test.mjs
import test from 'node:test';
import assert from 'node:assert/strict';
import { N, MOVE, fighter } from './cards.mjs';
import { newBout, doAnswer, startAct, declare, endAct, legalNow, answerOptions, posKey } from './engine.mjs';
import { joinFor } from './board.mjs';

function table(a, b, ha, hb, seed = 7) {
  const S = newBout(fighter(a), fighter(b), seed);
  S.f[0].hand = ha.slice(); S.f[1].hand = hb.slice(); S.f[0].wind = S.f[1].wind = N.cap;
  return S;
}
// one turn for m: answer what was thrown at him (an id is looked up in his options), then lay his own volley
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
const BOX = ['jab', 'cross', 'hook', 'upper', 'block'], BJJ = ['tieup', 'triangle', 'armbar', 'sweep', 'pass'];

test('9b H1: Frame - 1 wind, no card - answers a Tie up: the tie fails and both stay where they were', () => {
  const S = table('boxing', 'bjj', BOX, BJJ);
  S.j = { kind: 'apart', reach: 'P' };
  turn(S, 1, null, ['tieup']);
  const w = N.cap;
  turn(S, 0, '@frame', [], w);
  assert.equal(S.j.kind, 'apart', 'no clinch'); assert.equal(S.j.reach, 'P', 'still at punching range');
  assert.equal(S.tie, null, 'no tie');
  assert.equal(S.f[0].wind, w - N.frameW, 'the frame cost its wind and no card');
  assert.ok(MOVE['@frame'].real, 'the move names its row');
});

test('9b H1b: the tie must stand through one of his turns - no tie-and-pull in one volley', () => {
  const S = table('boxing', 'bjj', BOX, BJJ);
  S.j = { kind: 'apart', reach: 'P' };
  S.f[1].wind = N.cap; doAnswer(S, 1, null); startAct(S);
  declare(S, 1, 'tieup');
  assert.equal(legalNow(S.pj, 1, '@pull'), false, 'the tie he just laid has not stood: no pull behind it');
  assert.throws(() => declare(S, 1, '@pull'), /not legal/);
  endAct(S, 1);
  turn(S, 0, null, []);                      // the boxer takes the tie; it has now stood a turn
  S.f[1].wind = N.cap; doAnswer(S, 1, null); startAct(S);
  assert.equal(legalNow(S.pj, 1, '@pull'), true, 'a turn later the pull goes off the stood tie');
});

test('9b H3: recover guard by where he was pinned - from mount to HALF guard, from side control to the guard', () => {
  for (const [top, g] of [['mount', 'half'], ['side', 'closed']]) {
    const S = table('bjj', 'boxing', BJJ, ['escape', 'jab', 'cross', 'hook', 'block']);
    places(S, ['past', 'pin'], { top });
    turn(S, 1, null, ['escape']);
    doAnswer(S, 0, null);
    assert.deepEqual(S.at, ['gtop', 'gbot'], `from ${top}: he has a guard again`);
    assert.equal(S.j.g, g, `from ${top} the guard he recovers is ${g}`);
  }
});

test('9b I1: the grounded man hears "get up" after ONE empty turn and is stood up after the SECOND', () => {
  const S = table('boxing', 'bjj', BOX, BJJ);
  places(S, ['stand', 'seat'], { kind: 'apart', leg: false });
  turn(S, 1, null, []);
  assert.deepEqual(S.at, ['stand', 'seat'], 'one empty turn: he is still down');
  assert.ok(S.st.warn.some((w) => w.m === 1 && w.kind === 'get up'), 'the referee told him to get up');
  assert.equal(S.timid[1], 0, 'being told is not yet a stand-up');
  turn(S, 0, null, []);
  turn(S, 1, null, []);
  assert.deepEqual(S.at, ['stand', 'stand'], 'the second empty turn running: stood up');
  assert.equal(S.timid[1], 1, 'and that stand-up counts');
});

test('9b A1: the knockdown - a standing punch that lands for 6 or more and leaves him at 10 or under seats him', () => {
  const S = table('boxing', 'bjj', BOX, BJJ);
  S.j = { kind: 'apart', reach: 'P' }; S.f[1].hp = N.kdHp + 5;
  turn(S, 0, null, ['upper']);
  doAnswer(S, 1, null);
  assert.ok(S.f[1].hp > 0 && S.f[1].hp <= N.kdHp, 'the uppercut left him hurt, not out');
  assert.deepEqual(S.at, ['stand', 'seat'], 'he is down, the puncher on his feet');
  assert.equal(posKey(S, 0), 'over'); assert.equal(S.j.leg, true, 'the puncher stands inside the reach of his feet');
  const T = table('boxing', 'bjj', BOX, BJJ);
  T.j = { kind: 'apart', reach: 'P' };
  turn(T, 0, null, ['upper']); doAnswer(T, 1, null);
  assert.deepEqual(T.at, ['stand', 'stand'], 'the same punch on a fresh man is not a knockdown');
});

test('9b A2: punches landing on a man who is down for 2 turns with nothing laid back - the referee stops it', () => {
  const S = table('boxing', 'bjj', ['cross', 'cross', 'hook', 'jab', 'block'], BJJ);
  places(S, ['stand', 'seat'], { kind: 'apart', leg: true });
  turn(S, 0, null, ['cross']);
  turn(S, 1, null, []);                      // he lays nothing back (the referee says "get up")
  assert.equal(S.over, null, 'one turn of punches is not a stoppage');
  turn(S, 0, null, ['cross']);
  doAnswer(S, 1, null);
  assert.ok(S.over && S.over.win === 0 && S.over.how === 'tko', 'the second turn of landed punches ends it');
  const T = table('boxing', 'bjj', ['cross', 'cross', 'hook', 'jab', 'block'], BJJ);
  places(T, ['stand', 'seat'], { kind: 'apart', leg: true });
  turn(T, 0, null, ['cross']);
  turn(T, 1, null, ['@kick']);               // he fights back off his back
  turn(T, 0, null, ['cross']);
  doAnswer(T, 1, null);
  assert.equal(T.over, null, 'laying something back resets the count');
});

test('9b B1: Keep your base - 2 wind, no card - stops a pull (the tie is gone, the puller seated) and a sweep', (t) => {
  assert.equal(N.baseSweep, 0, 'the SWEEP half is OFF in the game since S548: measured at 99.5% boxing (69.3% in its weaker shape)'); N.baseSweep = 1; t.after(() => { N.baseSweep = 0; });
  const S = table('boxing', 'bjj', BOX, BJJ);
  S.j = { kind: 'apart', reach: 'P' };
  turn(S, 1, null, ['tieup']); turn(S, 0, null, []); turn(S, 1, null, ['@pull']);
  turn(S, 0, '@base', [], N.baseW + N.surcharge); // a tie that stood makes the answer 1 wind dearer (audit 2d)
  assert.deepEqual(S.at, ['stand', 'seat'], 'the pull failed: he sits, the boxer stands');
  assert.equal(S.tie, null, 'a failed pull drops the tie (H2)');
  assert.equal(S.f[0].wind, 0, 'it cost its wind and no card');
  const T = table('boxing', 'bjj', BOX, BJJ);
  places(T, ['gtop', 'gbot'], { g: 'closed' });
  turn(T, 1, null, ['sweep']); turn(T, 0, '@base', []);
  assert.deepEqual(T.at, ['gtop', 'gbot'], 'the sweep is stopped: he is still on top in the guard');
});

test('9b B2: Escape a hold - 2 wind, no card - stops a hold as it is laid; the holder stays where he is', (t) => {
  assert.equal(N.escOn, 0, 'OFF in the game since S548: the bot stops laying holds'); N.escOn = 1; t.after(() => { N.escOn = 0; });
  const S = table('bjj', 'boxing', ['kimura', 'triangle', 'armbar', 'sweep', 'pass'], ['jab', 'cross', 'hook', 'block', 'slip']);
  places(S, ['past', 'pin'], { top: 'side' });
  turn(S, 0, null, ['kimura']);
  turn(S, 1, '@escape', [], N.escW);
  assert.equal(S.hold, null, 'no hold runs');
  assert.deepEqual(S.at, ['past', 'pin'], 'the holder is NOT a layer back: that is the Escape card');
  assert.equal(S.j.top, 'side'); assert.equal(S.f[1].wind, 0);
});

test('9b B3: the Up-kick with no card - 2 wind, from the floor at a standing man in leg range, and as he walks away', () => {
  const S = table('boxing', 'bjj', BOX, ['triangle', 'armbar', 'sweep', 'pass', 'kimura']);
  places(S, ['stand', 'seat'], { kind: 'apart', leg: true });
  const hp = S.f[0].hp;
  turn(S, 1, null, ['@kick']); doAnswer(S, 0, null);
  assert.equal(S.f[0].hp, hp - N.kickDmg, 'the kick lands for its 2');
  const T = table('boxing', 'bjj', BOX, ['triangle', 'armbar', 'sweep', 'pass', 'kimura']);
  places(T, ['stand', 'seat'], { kind: 'apart', leg: true });
  const hp2 = T.f[0].hp;
  turn(T, 0, null, ['@out']);                // the boxer walks away
  turn(T, 1, '@kick', []);
  assert.equal(T.f[0].hp, hp2 - N.kickDmg, 'kicked as he leaves, with no card in hand');
  assert.equal(legalNow(table('boxing', 'bjj', BOX, BJJ), 1, '@kick'), false, 'never from standing');
});

// S548, the owner's call on B1 ("Weaker version, measured"): Keep your base is there only for a man who threw NO punch in
// his last turn - a boxer who has just let a combination go is on his front foot and cannot also sit back on his hips.
// So the boxer chooses each turn: punch, or keep his balance for the pull he sees coming.
test('9b B1w: Keep your base is offered only to a man who threw no punch in his last turn', (t) => {
  const was = N.baseOn; N.baseOn = 1; t.after(() => { N.baseOn = was; });
  const go = (boxerVolley) => {
    const S = table('boxing', 'bjj', BOX, BJJ);
    S.j = { kind: 'apart', reach: 'P' };
    turn(S, 1, null, ['tieup']); turn(S, 0, null, boxerVolley); turn(S, 1, null, ['@pull']);
    S.f[0].wind = N.cap;
    return answerOptions(S, 0).some((o) => o && o.id === '@base');
  };
  assert.equal(go([]), true, 'he threw nothing: his hips are under him, he may keep his base');
  assert.equal(go(['hook']), false, 'he threw a hook inside the clinch: no base to keep, the pull takes him down');
});
