// CARDSCOPE4 greybox rules. node --test proto/cardscope4/
import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import { CARDS, N, STYLES, OWN, CHEAP, fighter, deckLegal } from './cards.mjs';
import { newBout, bout, doAnswer, startAct, declare, endAct, legalNow, answerOptions, posKey } from './engine.mjs';
import { aiPilot, impatient, scripted, escapeOdds } from './plan.mjs';

// a bout with both hands set by hand and full wind; seat 0 = a, seat 1 = b
function table(a, b, ha, hb) {
  const S = newBout(fighter(a), fighter(b), 7);
  S.f[0].hand = ha.slice(); S.f[1].hand = hb.slice(); S.f[0].wind = S.f[1].wind = N.cap;
  return S;
}
// one turn for m: answer what was thrown at him, then lay his own volley
function turn(S, m, ans, seq = []) {
  S.f[m].wind = N.cap;
  doAnswer(S, m, ans);
  if (S.over || S.hold) return S;
  startAct(S); for (const id of seq) declare(S, m, id); endAct(S, m);
  return S;
}

test('every style deck and every cheap deck is a legal 15', () => {
  assert.equal(STYLES.length, 6);
  for (const s of STYLES) { const F = fighter(s); assert.equal(F.deck.length, 15, s); assert.ok(deckLegal(F.deck), s); for (const id in OWN[s]) assert.equal(CARDS[id].st, s, id); }
  for (const k in CHEAP) assert.ok(deckLegal(CHEAP[k].deck), k);
});

test('the strip: a card is playable only at its range; a step is laid like a card and moves the bout', () => {
  const S = table('boxing', 'judo', ['cross', 'hook'], []);
  doAnswer(S, 0, null); startAct(S);
  assert.equal(S.pos, 'K');
  assert.throws(() => declare(S, 0, 'cross'), /not legal/);
  declare(S, 0, '@in'); declare(S, 0, 'cross'); endAct(S, 0);
  assert.equal(S.pos, 'K', 'nothing moves until his turn');
  turn(S, 1, null);
  assert.equal(S.pos, 'P'); assert.equal(S.f[1].hp, N.hp - CARDS.cross.dmg);
});

test('the jab steps in from KICK by itself', () => {
  const S = table('boxing', 'judo', ['jab', 'cross'], []);
  turn(S, 0, null, ['jab', 'cross']); turn(S, 1, null);
  assert.equal(S.pos, 'P'); assert.equal(S.f[1].hp, N.hp - CARDS.jab.dmg - CARDS.cross.dmg - N.chain);
});

test('one answer: a block takes its number off one strike, the rest land', () => {
  const S = table('boxing', 'boxing', ['jab', 'cross'], ['block']);
  S.pos = 'P';
  turn(S, 0, null, ['jab', 'cross']);
  const opts = answerOptions(S, 1);
  assert.ok(opts.some((o) => o && o.id === 'block' && o.i === 1));
  turn(S, 1, { id: 'block', i: 1 });
  assert.equal(S.f[1].hp, N.hp - CARDS.jab.dmg - Math.max(0, CARDS.cross.dmg + N.chain - N.block));
});

test('a sprawl stuffs a takedown; a throw behind a grip that stood a turn cannot be answered', () => {
  let S = table('wrestling', 'boxing', ['double'], ['sprawl']);
  S.pos = 'P';
  turn(S, 0, null, ['double']); turn(S, 1, { id: 'sprawl', i: 0 });
  assert.equal(S.pos, 'P'); assert.equal(S.f[0].pts, 0);
  S = table('judo', 'boxing', ['grip', 'hipthrow'], ['sprawl']);
  S.pos = 'P';
  turn(S, 0, null, ['grip']); turn(S, 1, null);
  assert.equal(S.pos, 'C'); assert.ok(S.grip && S.grip.by === 0);
  turn(S, 0, null, ['hipthrow']);
  assert.ok(!answerOptions(S, 1).some((o) => o && o.id === 'sprawl'), 'the clean throw shows no sprawl option');
  turn(S, 1, null);
  assert.equal(S.pos, 'G'); assert.equal(S.top, 0); assert.equal(S.f[0].pts, CARDS.hipthrow.pts + CARDS.hipthrow.gripPts);
});

test('the hold is a countdown: it runs out = the tap; Escape ends it; Make room stops one tick, once', () => {
  const mk = (hb) => { const S = table('bjj', 'boxing', ['armbar'], hb); S.pos = 'G'; S.top = 0; S.rung = 2; CARDS.armbar.count = 2; turn(S, 0, null, ['armbar']); return S; };
  let S = mk([]);
  turn(S, 1, null); assert.ok(S.hold && S.hold.count === 2, 'the hold goes on at his turn');
  turn(S, 0, null); turn(S, 1, null); assert.equal(S.hold.count, 1);
  turn(S, 0, null); turn(S, 1, null); assert.deepEqual(S.over, { win: 0, how: 'tap' });
  S = mk(['escape']);
  turn(S, 1, null); turn(S, 0, null);
  assert.ok(escapeOdds(S) > 0);
  turn(S, 1, { id: 'escape', i: -1 }); assert.equal(S.hold, null); assert.equal(S.over, null);
  S = mk([]);
  turn(S, 1, null); turn(S, 0, null);
  turn(S, 1, { id: '@room', i: -1 }); assert.equal(S.hold.count, 2, 'the tick is stopped');
  turn(S, 0, null);
  assert.ok(!answerOptions(S, 1).some((o) => o && o.id === '@room'), 'only once a hold');
});

test('a held fighter with no Escape left in his deck is read from the open discard pile', () => {
  const S = table('bjj', 'boxing', ['armbar'], []);
  S.pos = 'G'; S.top = 0; S.rung = 2; S.f[1].disc = ['escape'];
  turn(S, 0, null, ['armbar']); turn(S, 1, null);
  assert.equal(escapeOdds(S), 0);
});

test('a points lead ends the bout early', () => {
  const S = table('judo', 'boxing', ['shoulderthrow'], []);
  S.pos = 'C'; S.grip = { by: 0, pass: S.pass - 1 }; S.f[0].pts = N.lead - CARDS.shoulderthrow.pts;
  turn(S, 0, null, ['shoulderthrow']); turn(S, 1, null);
  assert.deepEqual(S.over, { win: 0, how: 'lead' });
});

test('own mechanics: the karate blitz goes in from KICK and the volley ends back at KICK; switched off it cannot', () => {
  const S = table('karate', 'boxing', ['revpunch'], []);
  turn(S, 0, null, ['revpunch']); turn(S, 1, null);
  assert.equal(S.pos, 'K'); assert.equal(S.f[1].hp, N.hp - CARDS.revpunch.dmg);
  const T = newBout(fighter('karate', { mech: false }), fighter('boxing'), 7);
  assert.equal(legalNow(T, 0, 'revpunch'), false);
  T.pos = 'P'; assert.equal(legalNow(T, 0, 'roundhouse'), false, 'kicks need kicking range');
});

test('own mechanics: jab, cross, hook clean in order is the combination; a stopped punch breaks it', () => {
  const dmg = (ans) => { const S = table('boxing', 'judo', ['jab', 'cross', 'hook'], []); S.pos = 'P'; turn(S, 0, null, ['jab', 'cross', 'hook']); turn(S, 1, ans); return N.hp - S.f[1].hp; };
  const raw = CARDS.jab.dmg + CARDS.cross.dmg + CARDS.hook.dmg + 2 * N.chain;
  assert.equal(dmg(null), raw + N.comboDmg);
  assert.ok(dmg({ id: '@cover', i: 1 }) < raw);
});

test('own mechanics: the wrestler reads the tie-up (he punched: the double leg is clean)', () => {
  const S = table('wrestling', 'boxing', ['tieup', 'double'], ['jab', 'sprawl']);
  S.pos = 'P';
  turn(S, 0, null, ['tieup']); turn(S, 1, null, ['jab']);
  assert.equal(S.tie.struck, true);
  turn(S, 0, null, ['double']);
  assert.ok(!answerOptions(S, 1).some((o) => o && o.id === 'sprawl'));
});

test('own mechanics: an escaped BJJ hold makes the next hold free; a sambo throw makes the leg lock free', () => {
  let S = table('bjj', 'boxing', ['armbar', 'kimura'], ['escape']);
  S.pos = 'G'; S.top = 0; S.rung = 2;
  turn(S, 0, null, ['armbar']); turn(S, 1, null); turn(S, 0, null); turn(S, 1, { id: 'escape', i: -1 });
  assert.equal(S.f[0].chain, 1);
  S = table('sambo', 'boxing', ['sthrow', 'kneebar'], []);
  S.pos = 'C';
  turn(S, 0, null, ['sthrow']); turn(S, 1, null);
  assert.equal(S.pos, 'G'); assert.equal(S.f[0].free, 1);
  const w = S.f[0].wind; doAnswer(S, 0, null); startAct(S); declare(S, 0, 'kneebar');
  assert.equal(S.f[0].wind, w, 'the lock after the throw costs nothing');
});

test('the referee stands up a ground phase with no attack for two turns', () => {
  const S = table('wrestling', 'boxing', [], []);
  S.pos = 'G'; S.top = 0; S.rung = 1;
  for (let i = 0; i < N.stallMax; i++) { turn(S, 0, null); turn(S, 1, null); }
  assert.equal(S.pos, 'K');
});

test('same seed, same bout; every pairing ends with a winner; the three pilots fly every deck', () => {
  const AI = aiPilot();
  const a = bout(fighter('judo'), fighter('karate'), [AI, AI], 99), b = bout(fighter('judo'), fighter('karate'), [AI, AI], 99);
  assert.equal(a.win, b.win); assert.equal(a.how, b.how); assert.deepEqual(a.st.dec, b.st.dec);
  for (const s of STYLES) for (const t of STYLES) if (s !== t) {
    for (const p of [AI, impatient(), scripted(s)]) { const r = bout(fighter(s), fighter(t), [p, AI], 11); assert.ok(r.win === 0 || r.win === 1); assert.ok(['ko', 'lead', 'tap', 'pin', 'cards'].includes(r.how)); assert.ok(posKey(r.S, 0)); }
  }
});

test('no script over 500 lines', () => {
  for (const f of fs.readdirSync(new URL('.', import.meta.url))) if (f.endsWith('.mjs')) assert.ok(fs.readFileSync(new URL(f, import.meta.url), 'utf8').split('\n').length <= 500, f);
});
