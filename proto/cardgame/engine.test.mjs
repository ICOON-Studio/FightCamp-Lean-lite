// CARDSCOPE5 greybox rules. node --test proto/cardscope5/engine.test.mjs
import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import { CARDS, N, STYLES, OWN, CHEAP, fighter, deckLegal } from './cards.mjs';
import { newBout, bout, doAnswer, startAct, declare, endAct, legalNow, answerOptions, posKey, placeKey, cost, canPay } from './engine.mjs';
import { joinFor } from './board.mjs';
import { aiPilot, impatient, scripted, outlook } from './plan.mjs';
import { freshCareer, RUNGS, TRAINING, train, resultCareer, measureTraining, assertCareer, takesTitle, rivalFighter, rivalPilot, simulateLadder, trainingState, CUT_AT_LOSSES, TITLE_SHOT } from './career.mjs';

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
// ROUND 9: each man has his OWN place and the pair is a separate thing (board.mjs), so round 8's one shared switch
// (S.pos / S.top / S.rung / S.grip) is gone. These put the two men where a test wants them, by the audit's own pairs.
const places = (S, at, j) => { S.at = at.slice(); S.j = joinFor(S.at, { ...j }); return S; };
const stand = (S, reach = 'K') => places(S, ['stand', 'stand'], { kind: 'apart', reach });       // pair 1
const clinch = (S, by = 0) => places(S, ['stand', 'stand'], { kind: 'clinch', by });             // pair 2
const down = (S, m = 1) => places(S, m === 1 ? ['stand', 'seat'] : ['seat', 'stand'], { kind: 'apart', leg: true }); // pair 3
const guard = (S, top = 0, g = 'closed') => places(S, top === 0 ? ['gtop', 'gbot'] : ['gbot', 'gtop'], { kind: 'entangled', g }); // pair 5
const pasted = (S, top = 'side') => places(S, ['past', 'pin'], { kind: 'entangled', top });      // pair 6, seat 0 on top
const where = (S, m = 0) => placeKey(S, m); // the card-facing key of a man's own place (K P C gt gb past pin over down)

test('every style deck and every cheap deck is a legal 15', () => {
  assert.deepEqual(STYLES, ['boxing', 'bjj']);
  for (const s of STYLES) { const F = fighter(s); assert.equal(F.deck.length, 15, s); assert.ok(deckLegal(F.deck), s); for (const id in OWN[s]) assert.equal(CARDS[id].st, s, id); }
  for (const k in CHEAP) assert.ok(deckLegal(CHEAP[k].deck), k);
});

test('each man has his own place: a card works only where the man who lays it is, a step moves only him, and a card resolves on the other man\'s turn', () => {
  const S = table('boxing', 'judo', ['cross', 'hook'], []);
  stand(S);
  doAnswer(S, 0, null); startAct(S);
  assert.throws(() => declare(S, 0, 'cross'), /not legal/);
  // ROUND 9: while a volley is only LAID the bout itself is untouched - the pending read (S.pj) is what the page
  // previews. It resolves when the turn closes, and then on the other man's turn.
  declare(S, 0, '@in'); declare(S, 0, 'cross');
  assert.equal(S.j.reach, 'K', 'the bout itself is untouched while the volley is only laid');
  assert.equal(S.pj.j.reach, 'P', 'the step in is LAID: the pending volley is at punching range');
  assert.equal(S.f[1].hp, N.hp, 'and nothing has landed yet');
  endAct(S, 0);
  assert.equal(S.f[0].wind, N.cap - N.stepW - CARDS.cross.w, 'the step and the cross are paid when they are LAID');
  assert.equal(S.j.reach, 'K', 'and nothing has resolved yet: the bout is where it was');
  turn(S, 1, null);
  assert.equal(S.j.reach, 'P', 'the step in took him to punching range on his turn');
  assert.deepEqual(S.at, ['stand', 'stand'], 'a step in moves nobody down');
  assert.equal(S.f[1].hp, N.hp - CARDS.cross.dmg, 'and the cross landed behind it');
});

test('one answer: a block takes its number off one strike, the rest land', () => {
  const S = table('boxing', 'boxing', ['jab', 'cross'], ['block']);
  stand(S, 'P');
  turn(S, 0, null, ['jab', 'cross']);
  assert.ok(answerOptions(S, 1).some((o) => o && o.id === 'block' && o.i === 1));
  turn(S, 1, { id: 'block', i: 1 });
  assert.equal(S.f[1].hp, N.hp - CARDS.jab.dmg - Math.max(0, CARDS.cross.dmg - N.block), 'the block took its number off the cross only');
});

test('boxing, combinations: the jab steps in; a punch behind a punch costs 1 less; off, it does not', () => {
  // ROUND 9: a man's mechanic is a flag on the FIGHTER (table's x goes to fighter(a, x)), and `mech: false` must be
  // passed for the off case - the round-8 helper forgot it on the first boxer, so "off" was measured with it on.
  const spent = (x) => { const S = table('boxing', 'judo', ['jab', 'cross', 'hook'], [], x); stand(S, 'P'); turn(S, 0, null, ['jab', 'cross', 'hook']); return N.cap - S.f[0].wind; };
  const full = CARDS.jab.w + CARDS.cross.w + CARDS.hook.w;
  assert.equal(spent({}), full - 2);
  assert.equal(spent({ mech: false }), full);
  const dmg = (ans) => { const S = table('boxing', 'judo', ['jab', 'cross', 'hook'], []); turn(S, 0, null, ['jab', 'cross', 'hook']); turn(S, 1, ans); return N.hp - S.f[1].hp; };
  const raw = CARDS.jab.dmg + CARDS.cross.dmg + CARDS.hook.dmg;
  assert.equal(dmg(null), raw + N.comboDmg, 'from KICK: the jab steps in and the three land in order');
  assert.ok(dmg({ id: '@cover', i: 1 }) < raw, 'a stopped punch breaks the combination');
});

test('boxing, inside work: the short punches land in the CLINCH; off, they need PUNCH range', () => {
  const S = table('boxing', 'judo', ['hook', 'cross'], []); clinch(S);
  assert.equal(can(S, 0, 'hook'), true); assert.equal(can(S, 0, 'cross'), false, 'the straight punches need room');
  const T = table('boxing', 'judo', ['hook'], [], { mech: false }); clinch(T); assert.equal(can(T, 0, 'hook'), false);
});

test('kickboxing, hands and feet: a punch behind a kick steps in and is 1 cheaper, the knee behind a punch takes the CLINCH; a stopped kick leaves the punch short; a low kick makes his steps dearer', () => {
  const S = table('kickboxing', 'boxing', ['bodykick', 'onetwo', 'knee', 'lowkick'], []);
  turn(S, 0, null, ['bodykick', 'onetwo', 'knee']);
  assert.equal(N.cap - S.f[0].wind, CARDS.bodykick.w + Math.max(0, CARDS.onetwo.w - 1) + Math.max(0, CARDS.knee.w - 1));
  turn(S, 1, null); assert.equal(where(S, 0), 'C', 'the knee behind the punch carried him into the CLINCH'); assert.equal(S.f[1].hp, N.hp - CARDS.bodykick.dmg - CARDS.onetwo.dmg - CARDS.knee.dmg);
  const R = table('kickboxing', 'kickboxing', ['bodykick', 'onetwo'], ['check']);
  turn(R, 0, null, ['bodykick', 'onetwo']); turn(R, 1, { id: 'check', i: 0 });
  assert.equal(where(R, 0), 'K'); assert.equal(R.f[1].hp, N.hp, 'the kick was checked, so the punch behind it never got in');
  const L = table('kickboxing', 'boxing', ['lowkick'], []); stand(L, 'P');
  turn(L, 0, null, ['lowkick']); doAnswer(L, 1, null); assert.deepEqual(cost(L, 1, '@out'), [N.stepW + 1, 'y']);
  const T = table('kickboxing', 'boxing', ['bodykick', 'onetwo'], [], { mech: false });
  doAnswer(T, 0, null); startAct(T); declare(T, 0, 'bodykick'); assert.throws(() => declare(T, 0, 'onetwo'), /not legal/);
  const C = table('kickboxing', 'boxing', ['knee', 'kbhook'], []); clinch(C);
  assert.equal(can(C, 0, 'kbhook'), false, 'a hook needs PUNCH range');
  turn(C, 0, null, ['knee', 'kbhook']); turn(C, 1, null);
  assert.equal(where(C, 0), 'P', 'the punch behind the knee pushes off to PUNCH range'); assert.equal(C.f[1].hp, N.hp - CARDS.knee.dmg - CARDS.kbhook.dmg);
  assert.ok(fighter('kickboxing').deck.every((id) => !['shot', 'hold', 'adv', 'setup'].includes(CARDS[id].k)), 'no takedowns, no ground');
});

test('karate, in-and-out: the punch blitzes in from KICK and is back out, a kick from PUNCH springs out, both 1 cheaper; the volley ends at KICK', () => {
  const S = table('karate', 'boxing', ['revpunch', 'roundhouse'], []);
  turn(S, 0, null, ['revpunch', 'roundhouse']);
  assert.equal(N.cap - S.f[0].wind, Math.max(1, CARDS.revpunch.w - 1) + CARDS.roundhouse.w, 'the blitz is 1 cheaper; he is back at KICK for the kick');
  assert.equal(S.pj, null); turn(S, 1, null);
  assert.equal(where(S, 0), 'K'); assert.equal(S.f[1].hp, N.hp - CARDS.revpunch.dmg - CARDS.roundhouse.dmg);
  const T = table('karate', 'boxing', ['revpunch', 'roundhouse'], [], { mech: false });
  assert.equal(can(T, 0, 'revpunch'), false);
  stand(T, 'P'); assert.equal(can(T, 0, 'roundhouse'), false, 'without it kicks need kicking range');
});

test('judo, the grip: no throw without it; laid in the same volley it can be stopped; a grip that STOOD a turn makes the answer 1 wind dearer, never impossible', () => {
  // ROUND 9 (audit 2d, WRONG fixed): round 8 made the throw behind a stood grip UNANSWERABLE. Now the sprawl still
  // answers it, at 1 wind more; the throw still has to have a grip to be laid at all.
  let S = table('judo', 'boxing', ['hipthrow', 'grip'], ['sprawl']);
  clinch(S);
  assert.equal(can(S, 0, 'hipthrow'), false);
  turn(S, 0, null, ['grip', 'hipthrow']);
  turn(S, 1, { id: 'sprawl', i: 0 });
  assert.equal(where(S, 0), 'C', 'the grip is broken and the throw misses'); assert.equal(S.f[0].pts, 0);
  S = table('judo', 'boxing', ['grip', 'hipthrow'], ['sprawl']);
  stand(S, 'P');
  turn(S, 0, null, ['grip']); turn(S, 1, null);
  assert.equal(where(S, 0), 'C'); assert.ok(S.tie && S.tie.by === 0 && S.tie.mode === 'grip');
  turn(S, 0, null, ['hipthrow']);
  // the answer is still there - and dearer by the surcharge, because the tie stood a turn
  const opt = answerOptions(S, 1).find((o) => o && o.id === 'sprawl');
  assert.ok(opt, 'the sprawl still answers the throw behind a standing grip');
  assert.equal(cost(S, 1, 'sprawl', S.inc[opt.i])[0], CARDS.sprawl.w + N.surcharge, 'a stood grip makes the answer 1 wind dearer');
  turn(S, 1, opt); // the sprawl stops the throw: the answer exists, it is only dearer
  assert.deepEqual(S.at, ['stand', 'stand'], 'the throw was stopped: nobody lands anywhere');
  assert.equal(S.f[0].pts, 0, 'and no points');
  // and with no answer laid the same stood-grip throw lands at SIDE CONTROL, to 2 (audit 2c: not the back)
  const L = table('judo', 'boxing', ['grip', 'hipthrow'], []);
  stand(L, 'P'); turn(L, 0, null, ['grip']); turn(L, 1, null); turn(L, 0, null, ['hipthrow']); turn(L, 1, null);
  assert.equal(L.at[0], 'past'); assert.equal(L.at[1], 'pin');
  assert.equal(L.j.top, 'side'); assert.equal(L.f[0].pts, CARDS.hipthrow.pts);
  // the grip is the judo man's OWN mechanic: without it he throws off the clinch like anybody else (round 8's reading)
  const T = table('judo', 'boxing', ['hipthrow'], [], { mech: false }); clinch(T);
  assert.equal(can(T, 0, 'hipthrow'), true, 'without the mechanic there is no grip requirement - the mechanic IS the grip');
});

test('judo, the grip owns his posture: a gripped wrestler cannot shoot', () => {
  const S = table('judo', 'wrestling', ['grip'], ['double']); stand(S, 'P');
  turn(S, 0, null, ['grip']); doAnswer(S, 1, null);
  assert.equal(where(S, 0), 'C'); assert.equal(can(S, 1, 'double'), false);
});

test('wrestling, chain wrestling: the shot travels from KICK, the chain rides a stuffed shot, and NO takedown is unanswerable (the stood tie makes the answer dearer)', () => {
  // ROUND 9 (audit 2d, WRONG fixed): round 8 ruled that a stuffed shot leaves the CLINCH with the tie, and the next shot
  // then cannot be sprawled at all. The tie stands - but the answer is only 1 wind dearer, never gone.
  const S = table('wrestling', 'boxing', ['double', 'single'], ['sprawl', 'sprawl']);
  assert.equal(where(S, 0), 'K');
  turn(S, 0, null, ['double']); turn(S, 1, { id: 'sprawl', i: 0 });
  assert.equal(where(S, 0), 'C'); assert.ok(S.tie && S.tie.by === 0, 'the stuffed shot leaves the wrestler in the clinch with the tie');
  turn(S, 0, null, ['single']);
  const opt = answerOptions(S, 1).find((o) => o && o.id === 'sprawl');
  assert.ok(opt, 'the second shot can still be sprawled');
  assert.equal(cost(S, 1, 'sprawl', S.inc[opt.i])[0], CARDS.sprawl.w + N.surcharge, 'and it costs the surcharge for the stood tie');
  turn(S, 1, null); assert.equal(S.at[0], 'gtop'); assert.equal(S.at[1], 'gbot', 'the second shot lands in the guard');
  const T = table('wrestling', 'boxing', ['double'], [], { mech: false });
  assert.equal(can(T, 0, 'double'), false, 'without his mechanic a wrestler needs the CLINCH first');
  // GET UP IS OPEN SPACE ONLY (audit 4c): a man inside a guard has no Get up - the way off the floor from a guard is
  // Break free, which STAYS on the ground with the holder one layer back. Round 8 let the man under a wrestler climb one
  // rung at a time with Get up; in the new model the guard's own exit is the ground one.
  const R = table('boxing', 'wrestling', [], []); places(R, ['gbot', 'gtop'], { kind: 'entangled', g: 'closed' });
  assert.equal(can(R, 0, '@up'), false, 'no Get up out of a guard: Get up is the open-space rise');
  const Q = table('boxing', 'judo', [], []); down(Q, 0); // the boxer seated, the judo man standing over him: open space
  assert.equal(can(Q, 0, '@up'), true, 'and out in the open a seated man may rise');
  turn(Q, 0, null, ['@up']); doAnswer(Q, 1, null);
  assert.equal(Q.at[0], 'stand', 'Get up puts him on his feet');
  assert.equal(Q.pj, null);
});

test('bjj, the guard: Pull guard needs his tie (without one it is Sit down); off his tie a HOLD follows in the same volley; nobody else can pull', () => {
  // ROUND 9 (audit 4c, the MISSING-LINK row): "a pull straight into a triangle needs an arm and the head already held -
  // only behind a pull made from a tie." So a pull off his OWN tie does NOT end his volley and the triangle follows in
  // the same volley; with no tie the same button is a sit, and a sit is his whole turn. Round 9 first read `ends: 1`
  // off the card for both, which made the very triangle the audit names impossible to lay.
  const S = table('bjj', 'boxing', ['triangle', 'tieup'], []);
  stand(S, 'P');
  assert.equal(can(S, 0, '@pull'), true, 'the button is legal with no tie - it is the SIT DOWN');
  turn(S, 0, null, ['tieup']); turn(S, 1, null);
  assert.equal(where(S, 0), 'C'); assert.ok(S.tie && S.tie.by === 0, 'Tie up is the clinch entry a pull needs (M9)');
  // the pull off his own tie does not end the volley: laid through declare by hand so the state can be read first.
  // The triangle has to be IN HAND on the turn he pulls, not on the turn he tied (the tie's turn discards what it lays).
  S.f[0].hand.push('triangle');
  doAnswer(S, 0, null); startAct(S); declare(S, 0, '@pull');
  assert.ok(!S.pj.ended, 'a pull off his own tie leaves the volley open (audit 4c, the MISSING-LINK row)');
  assert.equal(S.pj.at[0], 'gbot', 'the pull put him on his back');
  assert.ok(S.f[0].hand.includes('triangle'), 'the triangle is in hand: ' + S.f[0].hand.join(','));
  assert.ok(canPay(S.f[0], cost(S, 0, 'triangle')), 'and he can pay for it: wind ' + S.f[0].wind);
  declare(S, 0, 'triangle');
  assert.ok(S.pj.hold && S.pj.hold.by === 0, 'the triangle follows the pull in the SAME volley: the arm was already held');
  endAct(S, 0);
  doAnswer(S, 1, null);
  assert.equal(S.at[0], 'gbot'); assert.equal(S.at[1], 'gtop', 'he pulled the boxer into his guard');
  assert.ok(S.hold && S.hold.by === 0, 'and the triangle came with him');
  // WITH NO TIE the same button is a sit, and a sit IS his whole turn
  const SIT = table('bjj', 'boxing', ['@pull', 'triangle'], []);
  stand(SIT, 'P');
  doAnswer(SIT, 0, null); startAct(SIT); declare(SIT, 0, '@pull');
  assert.equal(SIT.pj.ended, true, 'no tie: it is only a sit, and it ends his volley');
  assert.throws(() => declare(SIT, 0, 'triangle'), /not legal/, 'nothing more may be laid after a bare sit');
  const T = table('bjj', 'boxing', ['triangle'], [], { mech: false }); clinch(T);
  assert.equal(can(T, 0, '@pull'), false, 'without his mechanic it is not a pull');
  places(T, ['gtop', 'gbot'], { kind: 'entangled', g: 'closed' });
  assert.equal(can(T, 0, 'triangle'), false, 'and he cannot work from underneath either');
  const U = table('boxing', 'bjj', [], []); stand(U, 'P'); assert.equal(can(U, 0, '@pull'), false, 'a boxer cannot pull guard');
  // SIT DOWN with no tie: he sits, the boxer stays STANDING (nobody is moved for free)
  const V = table('bjj', 'boxing', [], []); stand(V, 'P');
  turn(V, 0, null, ['@pull']); doAnswer(V, 1, null);
  assert.equal(V.at[0], 'seat', 'he sits down'); assert.equal(V.at[1], 'stand', 'the boxer stays standing');
});

test('sambo, throw-to-lock: the throw goes from PUNCH right behind his own punch and is ALWAYS answerable; the lock goes on in the volley of the throw; for a judo man the hold waits a turn', () => {
  // ROUND 9 (audit 2c MISSING-LINK + 2d): round 8 let the sambo throw be laid from the CLINCH and made it UNANSWERABLE
  // behind his own punch. Now the grab belongs to his own punch: PUNCH only, right behind it - and the sprawl still
  // answers it, at the surcharge the stood contact adds.
  const S = table('sambo', 'boxing', ['overhand', 'sthrow', 'kneebar'], []);
  stand(S, 'P');
  turn(S, 0, null, ['overhand', 'sthrow', 'kneebar']); turn(S, 1, null);
  assert.equal(S.at[0], 'gtop'); assert.equal(S.at[1], 'gbot', 'the throw lands him in the guard');
  assert.ok(S.hold && S.hold.by === 0 && S.hold.kind === 'sub', 'and the lock goes on in the volley of the throw');
  // a judo man cannot lay his hold in the same volley as the throw: the position has to settle a turn first
  const T = table('judo', 'boxing', ['grip', 'hipthrow', 'pin'], []);
  clinch(T); startAct(T); declare(T, 0, 'grip'); declare(T, 0, 'hipthrow');
  assert.throws(() => declare(T, 0, 'pin'), /not legal/);
  // without his mechanic the sambo throw is not his at all, and neither are his leg locks
  const U = table('sambo', 'boxing', ['overhand', 'sthrow', 'kneebar'], [], { mech: false });
  stand(U, 'P'); startAct(U); declare(U, 0, 'overhand');
  assert.throws(() => declare(U, 0, 'sthrow'), /not legal/);
  // the throw behind his own punch IS answerable - round 8 made it clean (2d: no takedown is unanswerable)
  const Y = table('sambo', 'boxing', ['overhand', 'sthrow'], ['sprawl']);
  stand(Y, 'P'); turn(Y, 0, null, ['overhand', 'sthrow']);
  assert.ok(answerOptions(Y, 1).some((o) => o && o.id === 'sprawl'), 'the throw behind his punch can be sprawled');
  // and a bare throw with no punch in front of it cannot be laid at all (the grab is the punch)
  const Z = table('sambo', 'boxing', ['sthrow'], ['sprawl']);
  stand(Z, 'P'); assert.equal(can(Z, 0, 'sthrow'), false, 'a bare throw from PUNCH with no punch in front is not a sambo entry');
  // his leg locks go on from any place on the ground, also the guard and underneath; without the mechanic they need the top
  // without the mechanic the leg lock needs a SETTLED TOP position: on top in the guard or past it, never from underneath
  for (const [top, g, on, off] of [['gtop', 'closed', true, true], ['gbot', 'closed', true, false], ['past', 'side', true, true]]) {
    const G = table('sambo', 'boxing', ['kneebar'], []); places(G, top === 'gbot' ? ['gbot', 'gtop'] : top === 'past' ? ['past', 'pin'] : ['gtop', 'gbot'], { kind: 'entangled', g: top === 'past' ? 'side' : g });
    assert.equal(can(G, 0, 'kneebar'), on, 'sambo ' + top);
    const H = table('sambo', 'boxing', ['kneebar'], [], { mech: false }); places(H, top === 'gbot' ? ['gbot', 'gtop'] : top === 'past' ? ['past', 'pin'] : ['gtop', 'gbot'], { kind: 'entangled', g: top === 'past' ? 'side' : g });
    assert.equal(can(H, 0, 'kneebar'), off, 'no mechanic ' + top);
  }
});

test('the hold: wind comes back slower while held; the price goes up 1 a turn; break free the turn you can pay; else the count ends it - and Break free STAYS ON THE GROUND, the holder one layer back', () => {
  const mk = (w) => { const S = table('bjj', 'boxing', ['armbar'], []); pasted(S); CARDS.armbar.count = 2; CARDS.armbar.brk = 5; turn(S, 0, null, ['armbar']); turn(S, 1, null, [], w); return S; };
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
  // ROUND 9 (audit 2a/2b, WRONG fixed): round 8 stood both men up into the CLINCH. Now nobody gets up: the man who was
  // PAST THE GUARD goes one layer back to the guard, the man pinned under him is STILL UNDER HIM.
  assert.equal(S.hold, null);
  assert.equal(S.at[0], 'gtop'); assert.equal(S.at[1], 'gbot', 'both stay down');
  assert.equal(S.j.kind, 'entangled');
  assert.equal(S.f[1].wind, Math.min(N.cap, 4 + N.heldBack) - 5);
});

test('a pin scores at the top of every turn it is on, also the turn he escapes, and its last points at the end; only the Escape card gets out', () => {
  const mk = () => { const S = table('judo', 'boxing', ['pin'], []); pasted(S, 'side'); CARDS.pin.count = 2; CARDS.pin.brk = 4; turn(S, 0, null, ['pin']); turn(S, 1, null, [], 0); return S; };
  let S = mk();
  doAnswer(S, 0, null); S.f[1].wind = 0; doAnswer(S, 1, null);
  assert.equal(S.f[0].pts, CARDS.pin.tick);
  doAnswer(S, 0, null); S.f[1].wind = 0; doAnswer(S, 1, null);
  assert.equal(S.f[0].pts, 2 * CARDS.pin.tick + CARDS.pin.hpts);
  // ROUND 9 (audit 2d, WRONG fixed): round 8 ended a run-out pin in the CLINCH. Now the points stand and the REFEREE
  // STANDS BOTH MEN UP, apart at KICK.
  assert.deepEqual(S.at, ['stand', 'stand']); assert.deepEqual(S.j, { kind: 'apart', reach: 'K' });
  S = mk();
  doAnswer(S, 0, null); S.f[1].wind = N.cap; S.f[1].hand = [];
  assert.ok(!answerOptions(S, 1).some((o) => o && o.id === '@break'), 'a pin has no price: wind does not buy the way out');
  assert.equal(outlook(S).fin, 1, 'so with full wind the outlook is still the full pin');
  S.f[1].hand = ['escape']; doAnswer(S, 1, { id: 'escape', i: -1 });
  // Escape RECOVERS THE GUARD (audit 4c): both stay down, the man past the guard is back IN the guard - the boxer (seat 1)
  // is underneath in his own guard, the judo man on top in it
  assert.equal(S.hold, null);
  assert.equal(S.at[1], 'gbot', 'he recovered his guard: underneath in it'); assert.equal(S.at[0], 'gtop', 'the judo man is on top in it');
  assert.equal(S.f[0].pts, CARDS.pin.tick, 'the points of the turn he got out are kept');
});

test('the pilot in a hold follows the printed rule: Escape if he holds it, else break free the first turn he can pay', () => {
  const AI = aiPilot();
  for (const [hand, wind, want] of [[['escape'], 6, 'escape'], [[], 6, '@break'], [[], 1, null]]) {
    const S = table('bjj', 'boxing', ['triangle'], []); guard(S, 1, 'closed'); CARDS.triangle.count = 3; CARDS.triangle.brk = 5;
    turn(S, 0, null, ['triangle']); turn(S, 1, null, [], 0); doAnswer(S, 0, null);
    S.f[1].hand = hand; S.f[1].wind = wind;
    const opts = answerOptions(S, 1), a = opts.length > 1 ? AI.answer(S, 1, opts) : null;
    assert.equal(a && a.id, want);
  }
});

test('a points lead ends the bout early', () => {
  // ROUND 9: the lead ending STAYS (the owner's call, audit 2d). The throw is the judo man's own: clinch, grip, throw.
  const S = table('judo', 'boxing', ['grip', 'shoulderthrow'], []);
  clinch(S); S.f[0].pts = N.lead - CARDS.shoulderthrow.pts;
  turn(S, 0, null, ['grip', 'shoulderthrow']);
  turn(S, 1, null);
  assert.deepEqual(S.over, { win: 0, how: 'lead' });
});

test('the referee stands up a ground phase with no attack', () => {
  // ROUND 9 (audit 4d rule 6): one full exchange (both turns) with no strike and no attack and the referee stands both
  // men up, apart at KICK. Holding a place is not work. The clock is TWO turns, so the exchange is N.stallMax pairs.
  const S = table('wrestling', 'boxing', [], []);
  guard(S, 0, 'closed');
  for (let i = 0; i < N.stallMax; i++) { turn(S, 0, null); turn(S, 1, null); }
  assert.deepEqual(S.at, ['stand', 'stand'], 'both men are stood up');
  assert.deepEqual(S.j, { kind: 'apart', reach: 'K' }, 'apart at kicking range');
});

test('same seed, same bout; every pairing ends with a winner; the three pilots fly every deck', () => {
  const AI = aiPilot();
  const a = bout(fighter('judo'), fighter('karate'), [AI, AI], 99), b = bout(fighter('judo'), fighter('karate'), [AI, AI], 99);
  assert.equal(a.win, b.win); assert.equal(a.how, b.how); assert.deepEqual(a.st.dec, b.st.dec);
  for (const s of STYLES) for (const t of STYLES) if (s !== t) {
    for (const p of [AI, impatient(), scripted(s)]) { const r = bout(fighter(s), fighter(t), [p, AI], 11); assert.ok(r.win === 0 || r.win === 1); assert.ok(['ko', 'tko', 'lead', 'tap', 'pin', 'cards'].includes(r.how)); assert.ok(posKey(r.S, 0)); }
  }
});

test('career ladder advances on wins, drops one rung on a loss, and rank stays visible', () => {
  const c = freshCareer('boxing');
  assert.equal(RUNGS.length, 7); assert.equal(c.rank, 100);
  resultCareer(c, true); assert.equal(c.rung, 1); assert.ok(c.rank < 100);
  resultCareer(c, false); assert.equal(c.rung, 0); assert.ok(c.rank > 1); assert.equal(assertCareer(c), true);
});

test('training has four priced options; success adds or upgrades one card and failure never decays stats', () => {
  for (const style of STYLES) {
    const c = freshCareer(style), opts = TRAINING[style]; assert.equal(opts.length, 4);
    for (const option of opts) { assert.ok(option.cost > 0); assert.ok(option.fail >= 0 && option.fail <= 1); }
    const start = c.deck.length; const result = train(c, opts[0], () => 1); assert.ok(result.ok); assert.ok(['add', 'upgrade'].includes(result.kind));
    assert.ok(c.deck.length >= start); c.energy = 6; const second = train(c, opts[0], () => 1); assert.ok(second.ok); assert.ok(c.deck.some((id) => id.includes('+')));
    c.energy = 6; const before = c.deck.length; const failed = train(c, opts[1], () => 0); assert.equal(failed.failed, true); assert.equal(c.deck.length, before); assert.equal(Object.hasOwn(c, 'stats'), false);
  }
});

test('trained card copies carry the visible upgrade into engine data', () => {
  const box = freshCareer('boxing'); box.energy = 6; train(box, TRAINING.boxing.find((x) => x.id === 'block'), () => 1);
  const guardCard = box.deck.find((id) => id.startsWith('block+')); assert.equal(CARDS[guardCard].guard, N.block + 1);
  const grappler = freshCareer('bjj'); grappler.energy = 6; train(grappler, TRAINING.bjj.find((x) => x.id === 'triangle'), () => 1);
  const triangle = grappler.deck.find((id) => id.startsWith('triangle+')); assert.equal(CARDS[triangle].count, Math.max(1, CARDS.triangle.count - 1));
});

test('the utility gives each training option a niche on the declared tactical spread (the shape L2 was written on)', () => {
  // the four tactical states the utility was written on, kept as a unit test of its shape. The L2 BAR is measured on
  // the ladder's own states (the next test), which is what round 6b asked for.
  // ROUND 9: the places are read off the new model - K kick range, P punch range, C the clinch, G the guard, T past the
  // guard, B on the floor apart. The round-8 spread called the guard 'B' and past-the-guard 'T'; the shape is the same,
  // the place names are the model's own.
  // ROUND 9: the spread is the model's own places now - the standing ranges a fight starts in and the ground places it
  // can reach, and the states the audit names as the reason for each option: a bout he was HIT in (the guard drill), a
  // bout he was HELD in (the escape), a bout he was BEHIND in with a guard to attack from (the triangle).
  const spread = (style) => Array.from({ length: 10 }, (_, i) => {
    const phase = i % 5;
    if (style === 'boxing') return phase === 0 ? { pos: 'K', share: { K: 1 } } : phase === 1 ? { pos: 'P', share: { P: 1 } } : phase === 2 ? { pos: 'C', share: { C: 1 } } : phase === 3 ? { pos: 'P', share: { P: 1 }, held: true } : { pos: 'P', share: { P: 1 }, struck: true };
    return phase === 0 ? { pos: 'G', share: { G: 1 } } : phase === 1 ? { pos: 'T', share: { T: 1 } } : phase === 2 ? { pos: 'G', share: { G: 1 }, behind: true } : phase === 3 ? { pos: 'K', share: { K: 1 } } : { pos: 'G', share: { G: 1 }, held: true };
  });
  for (const style of STYLES) { const m = measureTraining(style, spread(style)); assert.equal(m.pass, true, JSON.stringify(m)); }
});

test('L2 measures the ladder\'s own training states: ten of them, read off bouts, never hand-made', () => {
  for (const style of STYLES) {
    const m = measureTraining(style);
    assert.equal(m.states, 10, style);
    for (const s of m.samples) {
      // ROUND 9: the state's own place is one of the standing ranges or one of the ground places, read off the bout
      assert.ok(s.pos && ['K', 'P', 'C', 'G', 'T', 'B'].includes(s.pos), style + ' ' + JSON.stringify(s));
      assert.ok(s.share && Object.values(s.share).some((v) => v > 0), 'a share read off a bout');
      const total = Object.values(s.share).reduce((a, b) => a + b, 0);
      assert.ok(Math.abs(total - 1) < 1e-9, 'the share sums to one');
    }
    for (const o of m.options) assert.ok(o.right >= 0 && o.right <= 10, o.id);
    assert.equal(m.pass, m.options.every((o) => o.right >= 1 && o.right <= 6), 'the verdict is the bar, whatever it says');
  }
});

test('no script over 500 lines', () => {
  for (const f of fs.readdirSync(new URL('.', import.meta.url))) if (/\.(mjs|js)$/.test(f)) assert.ok(fs.readFileSync(new URL(f, import.meta.url), 'utf8').split('\n').length <= 500, f);
});

test('the page module graph links: a broken import fails here, not in the owner\'s browser', async () => {
  const { install } = await import('./uidom.mjs');
  install(); // a stand-in document, so the page can be imported at all
  const ui = await import('./ui.js');
  assert.equal(typeof ui.reset, 'function'); assert.ok(ui.state, 'the page keeps its career on the table');
});

test('the title is won at the TITLE SHOT, and the defences are defences', () => {
  assert.equal(RUNGS[TITLE_SHOT], 'Title shot');
  for (const [rung, won, want] of [[TITLE_SHOT, true, true], [TITLE_SHOT, false, false], [TITLE_SHOT - 1, true, false], [TITLE_SHOT + 1, true, false], [RUNGS.length - 1, true, false]]) {
    const c = freshCareer('boxing'); c.rung = rung;
    assert.equal(takesTitle(c, won), want, `${RUNGS[rung]} ${won ? 'won' : 'lost'}`);
  }
  // and the ladder counts a career as a title only when it wins the title shot
  const l1 = simulateLadder(12, 700000000, 60);
  for (const r of l1.results) assert.ok(r.title || r.cut, 'every career ends in a title or the cut');
  assert.equal(l1.titleWins, l1.results.filter((r) => r.title).length);
});

test('rivals by rung: the other art at every rung (round 8: the first bout is against it), a club novice diluted, from Area up better cards, a title defence is upgraded', () => {
  const c = freshCareer('boxing');
  const decks = RUNGS.map((_, rung) => rivalFighter(c, rung));
  for (const [i, F] of decks.entries()) { assert.equal(F.deck.length, 15, 'rung ' + i); assert.ok(F.deck.every((id) => CARDS[id]), 'rung ' + i); assert.equal(F.style, 'bjj', 'rung ' + i + ': the other art at every rung, the club novice too (plan section 3: the first bout is against the other art)'); }
  assert.notDeepEqual(decks[0].deck, decks[1].deck, 'the club novice is not the area fighter');
  assert.ok(!decks[0].deck.some((id) => id.includes('+')), 'a novice has no upgraded cards');
  for (const rung of [3, 4, 5, 6]) assert.ok(decks[rung].deck.some((id) => id.includes('+')), 'rung ' + rung + ' has upgraded cards');
  assert.ok(decks[6].deck.filter((id) => id.includes('+')).length >= decks[3].deck.filter((id) => id.includes('+')).length, 'the defences are not easier than the title shot');
  // the exception is the first bout only: once a bout is fought, a club novice is the player's own art again
  const c2 = freshCareer('boxing'); c2.bouts = 1;
  assert.equal(rivalFighter(c2, 0).style, 'boxing', 'a later club bout is against the player\'s own art');
  assert.equal(rivalPilot(0, c2).name, 'impatient', 'and his corner plays the dearest card it can');
});

test('a training upgrade is one card in, one card out: a second upgrade never grows the deck', () => {
  for (const style of STYLES) {
    const c = freshCareer(style), n = c.deck.length, opt = TRAINING[style][0], copies = (d) => d.filter((id) => id === opt.id || id.startsWith(opt.id + '+')).length, had = copies(c.deck);
    c.energy = 6; assert.equal(train(c, opt, () => 1).kind, 'upgrade');
    assert.equal(c.deck.length, n, style);
    c.energy = 6; assert.equal(train(c, opt, () => 1).kind, 'upgrade');
    assert.equal(c.deck.length, n, style + ': the second upgrade replaced the copy');
    assert.ok(c.deck.some((id) => id === `${opt.id}+2`), 'the copy carries both upgrades');
    assert.equal(copies(c.deck), had, 'still the same number of that card');
    assert.equal(assertCareer(c), true);
  }
});

test('every training state is read off a bout the ladder fought', () => {
  const l1 = simulateLadder(4, 710000000, 20, 'boxing');
  assert.ok(l1.states.length > 0);
  for (const s of l1.states) { assert.ok(s.pos, JSON.stringify(s)); assert.ok(s.share); assert.ok(Object.values(s.share).reduce((a, b) => a + b, 0) > 0.99); }
  const r = { st: { log: [[{ pos: 'P', kinds: ['strike'], at: ['P'] }], [{ pos: 'K', kinds: ['strike'], at: ['K'] }]] }, S: { f: [{ pts: 0 }, { pts: 2 }] } };
  assert.deepEqual(trainingState(r, 0), { pos: 'P', share: { P: 1 }, range: 'P', ground: false, struck: true, held: false, behind: true });
});
