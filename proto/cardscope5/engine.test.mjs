// CARDSCOPE5 greybox rules. node --test proto/cardscope5/engine.test.mjs
import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import { CARDS, N, STYLES, OWN, CHEAP, fighter, deckLegal } from './cards.mjs';
import { newBout, bout, doAnswer, startAct, declare, endAct, legalNow, answerOptions, posKey, cost } from './engine.mjs';
import { aiPilot, impatient, scripted, outlook } from './plan.mjs';

// a bout with both hands set by hand and full wind; seat 0 = a, seat 1 = b
function table(a, b, ha, hb, x) {
  const S = newBout(fighter(a, x), fighter(b), 7);
  S.f[0].hand = ha.slice(); S.f[1].hand = hb.slice(); S.f[0].wind = S.f[1].wind = N.cap;
  return S;
}
// one turn for m: answer what was thrown at him, then lay his own volley (wind = what he has for it; default full)
function turn(S, m, ans, seq = [], wind = N.cap) {
  S.f[m].wind = wind;
  doAnswer(S, m, ans);
  if (S.over || S.hold) return S;
  startAct(S); for (const id of seq) declare(S, m, id); endAct(S, m);
  return S;
}
const can = (S, m, id) => { startAct(S); const ok = legalNow(S.pj, m, id); S.pj = null; return ok; };

test('every style deck and every cheap deck is a legal 15', () => {
  assert.equal(STYLES.length, 7);
  for (const s of STYLES) { const F = fighter(s); assert.equal(F.deck.length, 15, s); assert.ok(deckLegal(F.deck), s); for (const id in OWN[s]) assert.equal(CARDS[id].st, s, id); }
  for (const k in CHEAP) assert.ok(deckLegal(CHEAP[k].deck), k);
});

test('the strip: a card is playable only at its range; a step is laid like a card, costs wind and moves the bout', () => {
  const S = table('boxing', 'judo', ['cross', 'hook'], []);
  doAnswer(S, 0, null); startAct(S);
  assert.throws(() => declare(S, 0, 'cross'), /not legal/);
  declare(S, 0, '@in'); declare(S, 0, 'cross'); endAct(S, 0);
  assert.equal(S.f[0].wind, N.cap - N.stepW - CARDS.cross.w);
  assert.equal(S.pos, 'K', 'nothing moves until his turn');
  turn(S, 1, null);
  assert.equal(S.pos, 'P'); assert.equal(S.f[1].hp, N.hp - CARDS.cross.dmg);
});

test('one answer: a block takes its number off one strike, the rest land', () => {
  const S = table('boxing', 'boxing', ['jab', 'cross'], ['block']);
  S.pos = 'P';
  turn(S, 0, null, ['jab', 'cross']);
  assert.ok(answerOptions(S, 1).some((o) => o && o.id === 'block' && o.i === 1));
  turn(S, 1, { id: 'block', i: 1 });
  assert.equal(S.f[1].hp, N.hp - CARDS.jab.dmg - Math.max(0, CARDS.cross.dmg - N.block));
});

test('boxing, combinations: the jab steps in; a punch behind a punch costs 1 less; off, it does not', () => {
  const spent = (x) => { const S = table('boxing', 'judo', ['jab', 'cross', 'hook'], [], x); S.pos = 'P'; turn(S, 0, null, ['jab', 'cross', 'hook']); return N.cap - S.f[0].wind; };
  const full = CARDS.jab.w + CARDS.cross.w + CARDS.hook.w;
  assert.equal(spent({}), full - 2);
  assert.equal(spent({ mech: false }), full);
  const dmg = (ans) => { const S = table('boxing', 'judo', ['jab', 'cross', 'hook'], []); turn(S, 0, null, ['jab', 'cross', 'hook']); turn(S, 1, ans); return N.hp - S.f[1].hp; };
  const raw = CARDS.jab.dmg + CARDS.cross.dmg + CARDS.hook.dmg;
  assert.equal(dmg(null), raw + N.comboDmg, 'from KICK: the jab steps in and the three land in order');
  assert.ok(dmg({ id: '@cover', i: 1 }) < raw, 'a stopped punch breaks the combination');
});

test('boxing, inside work: the short punches land in the CLINCH; off, they need PUNCH range', () => {
  const S = table('boxing', 'judo', ['hook', 'cross'], []); S.pos = 'C';
  assert.equal(can(S, 0, 'hook'), true); assert.equal(can(S, 0, 'cross'), false, 'the straight punches need room');
  const T = table('boxing', 'judo', ['hook'], [], { mech: false }); T.pos = 'C'; assert.equal(can(T, 0, 'hook'), false);
});

test('kickboxing, hands and feet: a punch behind a kick steps in and is 1 cheaper, the knee behind a punch takes the CLINCH; a stopped kick leaves the punch short; a low kick makes his steps dearer', () => {
  const S = table('kickboxing', 'boxing', ['bodykick', 'onetwo', 'knee', 'lowkick'], []);
  turn(S, 0, null, ['bodykick', 'onetwo', 'knee']);
  assert.equal(N.cap - S.f[0].wind, CARDS.bodykick.w + Math.max(0, CARDS.onetwo.w - 1) + Math.max(0, CARDS.knee.w - 1));
  turn(S, 1, null); assert.equal(S.pos, 'C'); assert.equal(S.f[1].hp, N.hp - CARDS.bodykick.dmg - CARDS.onetwo.dmg - CARDS.knee.dmg);
  const R = table('kickboxing', 'kickboxing', ['bodykick', 'onetwo'], ['check']);
  turn(R, 0, null, ['bodykick', 'onetwo']); turn(R, 1, { id: 'check', i: 0 });
  assert.equal(R.pos, 'K'); assert.equal(R.f[1].hp, N.hp, 'the kick was checked, so the punch behind it never got in');
  const L = table('kickboxing', 'boxing', ['lowkick'], []); L.pos = 'P';
  turn(L, 0, null, ['lowkick']); doAnswer(L, 1, null); assert.deepEqual(cost(L, 1, '@out'), [N.stepW + 1, 'y']);
  const T = table('kickboxing', 'boxing', ['bodykick', 'onetwo'], [], { mech: false });
  doAnswer(T, 0, null); startAct(T); declare(T, 0, 'bodykick'); assert.throws(() => declare(T, 0, 'onetwo'), /not legal/);
  const C = table('kickboxing', 'boxing', ['knee', 'kbhook'], []); C.pos = 'C';
  assert.equal(can(C, 0, 'kbhook'), false, 'a hook needs PUNCH range');
  turn(C, 0, null, ['knee', 'kbhook']); turn(C, 1, null);
  assert.equal(C.pos, 'P', 'the punch behind the knee pushes off to PUNCH range'); assert.equal(C.f[1].hp, N.hp - CARDS.knee.dmg - CARDS.kbhook.dmg);
  assert.ok(fighter('kickboxing').deck.every((id) => !['shot', 'hold', 'adv', 'setup'].includes(CARDS[id].k)), 'no takedowns, no ground');
});

test('karate, in-and-out: the punch blitzes in from KICK and is back out, a kick from PUNCH springs out, both 1 cheaper; the volley ends at KICK', () => {
  const S = table('karate', 'boxing', ['revpunch', 'roundhouse'], []);
  turn(S, 0, null, ['revpunch', 'roundhouse']);
  assert.equal(N.cap - S.f[0].wind, Math.max(1, CARDS.revpunch.w - 1) + CARDS.roundhouse.w, 'the blitz is 1 cheaper; he is back at KICK for the kick');
  assert.equal(S.pj, null); turn(S, 1, null);
  assert.equal(S.pos, 'K'); assert.equal(S.f[1].hp, N.hp - CARDS.revpunch.dmg - CARDS.roundhouse.dmg);
  const T = table('karate', 'boxing', ['revpunch', 'roundhouse'], [], { mech: false });
  assert.equal(can(T, 0, 'revpunch'), false);
  T.pos = 'P'; assert.equal(can(T, 0, 'roundhouse'), false, 'without it kicks need kicking range');
});

test('judo, the grip: no throw without it; laid in the same volley it can be stopped; stood a turn the throw cannot', () => {
  let S = table('judo', 'boxing', ['hipthrow', 'grip'], ['sprawl']);
  S.pos = 'C';
  assert.equal(can(S, 0, 'hipthrow'), false);
  turn(S, 0, null, ['grip', 'hipthrow']);
  turn(S, 1, { id: 'sprawl', i: 0 });
  assert.equal(S.pos, 'C', 'the grip is broken and the throw misses'); assert.equal(S.f[0].pts, 0);
  S = table('judo', 'boxing', ['grip', 'hipthrow'], ['sprawl']);
  S.pos = 'P';
  turn(S, 0, null, ['grip']); turn(S, 1, null);
  assert.equal(S.pos, 'C'); assert.ok(S.grip && S.grip.by === 0);
  turn(S, 0, null, ['hipthrow']);
  assert.ok(!answerOptions(S, 1).some((o) => o && o.id === 'sprawl'), 'no sprawl against the throw behind a standing grip');
  turn(S, 1, null);
  assert.equal(S.pos, 'G'); assert.equal(S.top, 0); assert.equal(S.f[0].pts, CARDS.hipthrow.pts);
  const T = table('judo', 'boxing', ['hipthrow'], [], { mech: false }); T.pos = 'C';
  assert.equal(can(T, 0, 'hipthrow'), true);
});

test('judo, the grip owns his posture: a gripped wrestler cannot shoot', () => {
  const S = table('judo', 'wrestling', ['grip'], ['double']); S.pos = 'P';
  turn(S, 0, null, ['grip']); doAnswer(S, 1, null);
  assert.equal(S.pos, 'C'); assert.equal(can(S, 1, 'double'), false);
});

test('wrestling, chain wrestling and the ride: the shot travels from KICK; stuffed, he is tied up and the next shot cannot be stopped; the man under him gets up one rung at a time', () => {
  const S = table('wrestling', 'boxing', ['double', 'single'], ['sprawl', 'sprawl']);
  assert.equal(S.pos, 'K');
  turn(S, 0, null, ['double']); turn(S, 1, { id: 'sprawl', i: 0 });
  assert.equal(S.pos, 'C'); assert.ok(S.tie && S.tie.by === 0);
  turn(S, 0, null, ['single']);
  assert.ok(!answerOptions(S, 1).some((o) => o && o.id === 'sprawl'));
  turn(S, 1, null); assert.equal(S.pos, 'G'); assert.equal(S.top, 0);
  const T = table('wrestling', 'boxing', ['double'], [], { mech: false });
  assert.equal(can(T, 0, 'double'), false, 'without it a takedown needs the CLINCH');
  // the ride: under a wrestler Get up wins back one rung; under anybody else two
  const R = table('boxing', 'wrestling', [], []); R.pos = 'G'; R.top = 1; R.rung = 1; turn(R, 0, null, ['@up']); doAnswer(R, 1, null);
  assert.equal(R.pos, 'G'); assert.equal(R.rung, 0, 'still down, in his guard');
  const Q = table('boxing', 'judo', [], []); Q.pos = 'G'; Q.top = 1; Q.rung = 1; turn(Q, 0, null, ['@up']); doAnswer(Q, 1, null);
  assert.equal(Q.pos, 'P');
});

test('bjj, the guard: Pull guard is his own step, and he attacks from underneath at once; nobody else can', () => {
  const S = table('bjj', 'boxing', ['triangle'], []);
  S.pos = 'P';
  turn(S, 0, null, ['@pull', 'triangle']); turn(S, 1, null);
  assert.equal(S.pos, 'G'); assert.equal(S.top, 1); assert.ok(S.hold && S.hold.by === 0);
  const T = table('bjj', 'boxing', ['triangle'], [], { mech: false }); T.pos = 'P';
  assert.equal(can(T, 0, '@pull'), false);
  T.pos = 'G'; T.top = 1; T.rung = 0; assert.equal(can(T, 0, 'triangle'), false);
  const U = table('boxing', 'bjj', [], []); U.pos = 'P'; assert.equal(can(U, 0, '@pull'), false);
});

test('sambo, throw-to-lock: the throw goes from PUNCH and the lock goes on in the volley of the throw; for a judo man the hold waits a turn', () => {
  const S = table('sambo', 'boxing', ['sthrow', 'kneebar'], []);
  S.pos = 'C';
  turn(S, 0, null, ['sthrow', 'kneebar']); turn(S, 1, null);
  assert.equal(S.pos, 'G'); assert.ok(S.hold && S.hold.by === 0 && S.hold.kind === 'sub');
  const T = table('judo', 'boxing', ['hipthrow', 'pin'], []);
  T.pos = 'C'; T.grip = { by: 0, pass: -1 };
  doAnswer(T, 0, null); startAct(T); declare(T, 0, 'hipthrow');
  assert.throws(() => declare(T, 0, 'pin'), /not legal/);
  const U = table('sambo', 'boxing', ['sthrow', 'kneebar'], [], { mech: false }); U.pos = 'C';
  doAnswer(U, 0, null); startAct(U); declare(U, 0, 'sthrow');
  assert.throws(() => declare(U, 0, 'kneebar'), /not legal/);
  const Y = table('sambo', 'boxing', ['overhand', 'sthrow'], ['sprawl']); Y.pos = 'P';
  turn(Y, 0, null, ['overhand', 'sthrow']);
  assert.ok(!answerOptions(Y, 1).some((o) => o && o.id === 'sprawl'), 'the throw behind his punch cannot be sprawled');
  const Z = table('sambo', 'boxing', ['sthrow'], ['sprawl']); Z.pos = 'P'; turn(Z, 0, null, ['sthrow']);
  assert.ok(answerOptions(Z, 1).some((o) => o && o.id === 'sprawl'), 'a bare throw can');
  const V = table('sambo', 'boxing', ['sthrow'], []); V.pos = 'P'; assert.equal(can(V, 0, 'sthrow'), true, 'his throw goes from PUNCH');
  const X = table('sambo', 'boxing', ['sthrow'], [], { mech: false }); X.pos = 'P'; assert.equal(can(X, 0, 'sthrow'), false);
  // his leg locks go on from any place on the ground, also the guard and underneath; without the mechanic they need a settled top position
  for (const [top, rung, on, off] of [[0, 0, true, false], [1, 2, true, false], [0, 2, true, true]]) {
    const G = table('sambo', 'boxing', ['kneebar'], []); G.pos = 'G'; G.top = top; G.rung = rung; assert.equal(can(G, 0, 'kneebar'), on);
    const H = table('sambo', 'boxing', ['kneebar'], [], { mech: false }); H.pos = 'G'; H.top = top; H.rung = rung; assert.equal(can(H, 0, 'kneebar'), off);
  }
});

test('the hold: wind comes back slower while held; the price goes up 1 a turn; break free the turn you can pay; else the count ends it', () => {
  const mk = (w) => { const S = table('bjj', 'boxing', ['armbar'], []); S.pos = 'G'; S.top = 0; S.rung = 2; CARDS.armbar.count = 2; CARDS.armbar.brk = 5; turn(S, 0, null, ['armbar']); turn(S, 1, null, [], w); return S; };
  let S = mk(0);
  assert.ok(S.hold && S.hold.count === 2); assert.equal(outlook(S).fin, 1, 'wind 0 + 2 is under 5, then 4 is under 6');
  S.f[1].wind = 0; S.f[1].hand = []; doAnswer(S, 0, null); doAnswer(S, 1, null);
  assert.equal(S.hold.count, 1); assert.equal(S.hold.brk, 5 + N.tighten, 'the hold tightens');
  doAnswer(S, 0, null); doAnswer(S, 1, null);
  assert.deepEqual(S.over, { win: 0, how: 'tap' });
  S = mk(4);
  assert.equal(outlook(S).fin, 0, 'wind 4 + 2 pays 5 on the next turn');
  doAnswer(S, 0, null);
  S.f[1].hand = []; S.f[1].wind = Math.min(N.cap, 4 + N.heldBack); // bout() gives the held wind at the top of his turn
  assert.ok(answerOptions(S, 1).some((o) => o && o.id === '@break'));
  assert.deepEqual(cost(S, 1, '@break'), [5, '']);
  doAnswer(S, 1, { id: '@break', i: -1 });
  assert.equal(S.hold, null); assert.equal(S.pos, 'C'); assert.equal(S.f[1].wind, Math.min(N.cap, 4 + N.heldBack) - 5);
});

test('a pin scores at the top of every turn it is on, also the turn he escapes, and its last points at the end; only the Escape card gets out', () => {
  const mk = () => { const S = table('judo', 'boxing', ['pin'], []); S.pos = 'G'; S.top = 0; S.rung = 2; CARDS.pin.count = 2; CARDS.pin.brk = 4; turn(S, 0, null, ['pin']); turn(S, 1, null, [], 0); return S; };
  let S = mk();
  doAnswer(S, 0, null); S.f[1].wind = 0; doAnswer(S, 1, null);
  assert.equal(S.f[0].pts, CARDS.pin.tick);
  doAnswer(S, 0, null); S.f[1].wind = 0; doAnswer(S, 1, null);
  assert.equal(S.f[0].pts, 2 * CARDS.pin.tick + CARDS.pin.hpts); assert.equal(S.pos, 'C', 'a pin that ran out leaves them where an escape does: on their feet in the CLINCH');
  S = mk();
  doAnswer(S, 0, null); S.f[1].wind = N.cap; S.f[1].hand = [];
  assert.ok(!answerOptions(S, 1).some((o) => o && o.id === '@break'), 'a pin has no price: wind does not buy the way out');
  assert.equal(outlook(S).fin, 1, 'so with full wind the outlook is still the full pin');
  S.f[1].hand = ['escape']; doAnswer(S, 1, { id: 'escape', i: -1 });
  assert.equal(S.hold, null); assert.equal(S.pos, 'C'); assert.equal(S.f[0].pts, CARDS.pin.tick, 'the points of the turn he got out are kept');
});

test('the pilot in a hold follows the printed rule: Escape if he holds it, else break free the first turn he can pay', () => {
  const AI = aiPilot();
  for (const [hand, wind, want] of [[['escape'], 6, 'escape'], [[], 6, '@break'], [[], 1, null]]) {
    const S = table('bjj', 'boxing', ['triangle'], []); S.pos = 'G'; S.top = 1; S.rung = 0; CARDS.triangle.count = 3; CARDS.triangle.brk = 5;
    turn(S, 0, null, ['triangle']); turn(S, 1, null, [], 0); doAnswer(S, 0, null);
    S.f[1].hand = hand; S.f[1].wind = wind;
    const opts = answerOptions(S, 1), a = opts.length > 1 ? AI.answer(S, 1, opts) : null;
    assert.equal(a && a.id, want);
  }
});

test('a points lead ends the bout early', () => {
  const S = table('judo', 'boxing', ['shoulderthrow'], []);
  S.pos = 'C'; S.grip = { by: 0, pass: S.pass - 1 }; S.f[0].pts = N.lead - CARDS.shoulderthrow.pts;
  turn(S, 0, null, ['shoulderthrow']); turn(S, 1, null);
  assert.deepEqual(S.over, { win: 0, how: 'lead' });
});

test('the referee stands up a ground phase with no attack', () => {
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
