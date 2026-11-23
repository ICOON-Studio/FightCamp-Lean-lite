// CARDSCOPE5 greybox rules. node --test proto/cardscope5/engine.test.mjs
import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import { CARDS, N, STYLES, OWN, CHEAP, fighter, deckLegal } from './cards.mjs';
import { newBout, bout, doAnswer, startAct, declare, endAct, legalNow, answerOptions, posKey, cost } from './engine.mjs';
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

test('every style deck and every cheap deck is a legal 15', () => {
  assert.deepEqual(STYLES, ['boxing', 'bjj']);
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
  const guard = box.deck.find((id) => id.startsWith('block+')); assert.equal(CARDS[guard].guard, N.block + 1);
  const grappler = freshCareer('bjj'); grappler.energy = 6; train(grappler, TRAINING.bjj.find((x) => x.id === 'triangle'), () => 1);
  const triangle = grappler.deck.find((id) => id.startsWith('triangle+')); assert.equal(CARDS[triangle].count, Math.max(1, CARDS.triangle.count - 1));
});

test('the utility gives each training option a niche on the declared tactical spread (the shape L2 was written on)', () => {
  // the four tactical states the utility was written on, kept as a unit test of its shape. The L2 BAR is measured on
  // the ladder's own states (the next test), which is what round 6b asked for.
  const spread = (style) => Array.from({ length: 10 }, (_, i) => {
    const phase = i % 4;
    if (style === 'boxing') return phase === 0 ? { pos: 'K', share: { K: 1 } } : phase === 1 ? { pos: 'P', share: { P: 1 } } : phase === 2 ? { pos: 'B', share: { B: 1 }, held: true } : { pos: 'K', share: { K: 1 }, struck: true };
    return phase === 0 ? { pos: 'B', share: { B: 1 } } : phase === 1 ? { pos: 'T', share: { T: 1 } } : phase === 2 ? { pos: 'B', share: { B: 1 }, behind: true } : { pos: 'B', share: { B: 1 }, held: true };
  });
  for (const style of STYLES) { const m = measureTraining(style, spread(style)); assert.equal(m.pass, true, JSON.stringify(m)); }
});

test('L2 measures the ladder\'s own training states: ten of them, read off bouts, never hand-made', () => {
  for (const style of STYLES) {
    const m = measureTraining(style);
    assert.equal(m.states, 10, style);
    for (const s of m.samples) {
      assert.ok(s.pos && 'KPC TB'.includes(s.pos), style + ' ' + JSON.stringify(s));
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
