// Round 3 checks: Part A defects (referee, stool, film odds, landed/defence,
// shape table, breathe, knockdown protection) and Part B depth (tell scarcity,
// table, predict, combinations, new cards, wind, range, camp, amateur bout,
// opponent camp, house rules, corner offers).
import R from './rules.js';

let passed = 0, failed = 0;
function check(name, fn) {
  try { fn(); passed++; console.log('PASS  ' + name); }
  catch (e) { failed++; console.log('FAIL  ' + name + '\n      ' + e.message); }
}
function ok(v, msg) { if (!v) throw new Error(msg || 'expected true'); }
function eq(a, b, msg) { if (a !== b) throw new Error((msg || 'equals') + ' (get ' + JSON.stringify(a) + ', want ' + JSON.stringify(b) + ')'); }
function near(a, b, tol, msg) { if (Math.abs(a - b) > tol) throw new Error((msg || 'near') + ' (get ' + a + ', want ' + b + ' +-' + tol + ')'); }
const W = new Set(['W', 'w']);

function readyGame(seed, playerId, foeId) {
  const g = R.createGame({ seed, playerBoxerId: playerId, opponentBoxerId: foeId });
  while (g.phase === 'camp') { const d = R.aiCampPick(g); R.pickCampCard(g, d, R.aiCampRemove(g, d)); }
  return g;
}
function bout(seed, playerId, foeId) {
  const game = readyGame(seed, playerId, foeId);
  const fight = R.startFight(game);
  return { game, fight };
}
/* round 3b: the no-repeat rule makes "first affordable card" illegal sometimes;
   the helper now picks the first card the rules actually allow. */
function legalCard(fight) {
  const side = fight.player;
  const ok = side.hand.filter((id) => (fight.ropes ? id !== 'step_back' : true)
    && !(id === 'catch_breath' && side.catchUsed)
    && !R.repeatsNonPunch(side, id));
  return ok.length ? ok[0] : R.chooseAiCard(fight, 'player');
}
// play out the round with the opponent's card forced, so the fight state is ours
function toCorner(game, fight) {
  let guard = 0;
  while (fight.phase === 'fight' && guard++ < 20) {
    const foe = fight.opponent.hand.indexOf('jab') >= 0 ? 'jab' : fight.opponent.hand[0];
    R.playExchange(game, legalCard(fight), 'react', foe);
  }
  return fight;
}
function hand(fight, ids) {
  fight.player.hand = ids.slice();
  return fight;
}

/* ============================== Part A ================================== */

check('A/D4 referee: two clinches cost the holder 2 wind, the third costs a point', () => {
  const { game, fight } = bout(401, 'ada', 'mara');
  hand(fight, ['clinch', 'clinch', 'clinch', 'clinch', 'jab']);
  fight.opponent.hand = ['jab', 'jab', 'jab', 'jab', 'jab'];
  const before = fight.player.stamina;
  R.playExchange(game, 'clinch', 'react', 'jab');
  const afterOne = fight.player.stamina;
  R.playExchange(game, 'clinch', 'react', 'jab');
  const afterTwo = fight.player.stamina;
  ok(afterOne < before, 'a clinch costs wind like any card');
  ok(afterTwo <= afterOne - 2, 'the second clinch in a row costs 2 wind on top (holder pays)');
  eq(fight.player.clinchStreak, 2, 'the streak is counted on the holder');
  R.playExchange(game, 'clinch', 'react', 'jab');
  eq(fight.player.round.deductions, 1, 'the third clinch costs the holder a point');
  eq(fight.opponent.round.deductions, 0, 'the opponent is not deducted');
});

check('A/D4 referee: the point comes off the offender’s own card, not the opponent’s', () => {
  const seed = 402;
  const { game, fight } = bout(seed, 'ada', 'mara');
  hand(fight, ['clinch', 'clinch', 'clinch', 'jab', 'jab']);
  fight.opponent.hand = ['jab', 'jab', 'jab', 'jab', 'jab'];
  toCorner(game, fight);
  const round = fight.rounds[0];
  eq(round.referee.playerDeductions, 1, 'the player was deducted');
  eq(round.referee.opponentDeductions, 0, 'the opponent was not');
  // round 1: the judge rng is untouched before this scoring, so the raw card is repeatable
  const expected = R.scoreRound({ judgeRng: R.makeRng(R.hashSeed(seed, 'judges')) }, round.player, round.opponent);
  round.scores.forEach((score, i) => {
    eq(score[0], Math.max(7, expected[i][0] - 1), 'judge ' + i + ' takes the point off the offender');
    eq(score[1], expected[i][1], 'judge ' + i + ' leaves the opponent’s card alone');
  });
});

check('A/D5 stool: the picker pays, the opponent draws the extra card', () => {
  const { game, fight } = bout(411, 'ada', 'mara');
  fight.player.body = 60;
  toCorner(game, fight);
  eq(fight.phase, 'corner', 'the round ended');
  ok(fight.corner.includes('stool'), 'the stool is offered to a body-damaged boxer');
  const before = { player: fight.player.stamina, foe: fight.opponent.stamina, foeHand: fight.opponent.hand.length };
  fight.foeCornerPick = 'ice_eye';
  R.pickCorner(game, 'stool');
  ok(fight.player.stamina > before.player, 'the picker gets the rest (+10 wind, +8 between rounds)');
  ok(fight.opponent.stamina <= before.foe + 8, 'the opponent never gets the stool’s rest (at most the +8 recovery)');
  eq(fight.opponent.hand.length, before.foeHand + 1, 'the opponent draws one extra card (and no more than one)');
  eq(fight.player.mods.takenFirst, 0.2, 'the picker carries the 20% first-exchange cost');
});

check('A/D5 stool: the picker’s first exchange really is 20% heavier', () => {
  const a = bout(412, 'ada', 'mara'), b = bout(412, 'ada', 'mara');
  [a, b].forEach((x) => hand(x.fight, ['jab', 'jab', 'jab', 'jab', 'jab']));
  a.fight.player.mods.takenFirst = 0.2;
  const foeA = a.fight.opponent.hand.indexOf('jab') >= 0 ? 'jab' : a.fight.opponent.hand[0];
  const foeB = b.fight.opponent.hand.indexOf('jab') >= 0 ? 'jab' : b.fight.opponent.hand[0];
  eq(foeA, foeB, 'both fights see the same opponent card');
  const ea = R.playExchange(a.game, 'jab', 'react', foeA);
  const eb = R.playExchange(b.game, 'jab', 'react', foeB);
  eq(ea.player.dealt, eb.player.dealt, 'the picker’s own damage is untouched');
  if (eb.opponent.dealt > 0) near(ea.opponent.dealt, eb.opponent.dealt * 1.2, 0.001, 'what the picker takes is 20% heavier');
});

check('A/D2 film odds: the unseen pool makes the printed chance climb, and the change is shown', () => {
  const side = (discard) => ({
    deck: ['jab', 'jab', 'cross', 'cross', 'lead_hook', 'lead_hook', 'body_hook', 'uppercut',
      'slip', 'slip', 'block', 'roll', 'clinch', 'step_back', 'pivot_out', 'cut_off'],
    discard: discard.slice()
  });
  const clean = ['cross', 'lead_hook', 'body_hook', 'uppercut', 'slip', 'block', 'roll'];
  const bell = R.habitChanceInHand(side([]), 'jab', 5);
  const later = R.habitChanceInHand(side(clean), 'jab', 5);
  const evenLater = R.habitChanceInHand(side(clean.concat(['clinch', 'step_back'])), 'jab', 5);
  ok(bell > 0.4 && bell < 0.75, 'at the bell the film says about six in ten (' + bell.toFixed(2) + ')');
  ok(later > bell + 0.15, 'as his discards pile up the chance climbs (' + later.toFixed(2) + ')');
  ok(evenLater > later, 'and it keeps climbing while the copies are unseen (' + evenLater.toFixed(2) + ')');
  ok(evenLater >= 0.85, 'by late in round 2 it is a real read (' + evenLater.toFixed(2) + ')');
  ok(R.habitChanceInHand(side(['jab', 'jab']), 'jab', 5) === 0, 'once both copies are discarded it is dead');

  // in a bout, the page is given both numbers so the change can be shown
  let moved = 0, fixed = 0, total = 0;
  for (let i = 0; i < 60; i++) {
    const { game, fight } = bout(500 + i, 'ada', 'mara');
    fight.scouting.known = [{ id: 'jab_to_open', text: 'The opponent opens every round with the jab.' }];
    const first = R.scoutingPrediction(fight)[0];
    if (!first) continue;
    toCorner(game, fight);
    let guard = 0;
    while (fight.phase === 'fight' && fight.exchange < 4 && guard++ < 8) {
      R.playExchange(game, legalCard(fight), 'react', fight.opponent.hand[0]);
    }
    const read = R.scoutingPrediction(fight)[0];
    if (!read) continue;
    total++;
    if (read.chance !== first.chance) moved++;
    if (read.chanceAtBell === first.chanceAtBell) fixed++;
  }
  ok(total > 20, 'the file was readable during the bouts');
  ok(moved / total > 0.4, 'the live number moves during the fight (' + moved + ' of ' + total + ')');
  eq(fixed, total, 'the bell number next to it stays put, so the change is visible');
});

check('A/D3 landed: a defence that takes no damage is a defensive win, not a punch landed', () => {
  const { game, fight } = bout(601, 'ada', 'mara');
  hand(fight, ['slip', 'slip', 'slip', 'slip', 'slip']);
  fight.opponent.hand = ['jab', 'jab', 'jab', 'jab', 'jab'];
  const before = { landed: fight.player.totals.landed, def: fight.player.totals.defence || 0 };
  const ev = R.playExchange(game, 'slip', 'react', 'jab');
  eq(ev.player.code, 'W', 'the slip wins the exchange');
  eq(ev.player.dealt, 0, 'it deals no damage');
  eq(fight.player.totals.landed, before.landed, 'no punch is counted as landed');
  eq(fight.player.totals.defence, before.def + 1, 'it is counted as a clean defence');
  ok(fight.player.totals.defencePoints > 0, 'the counter data pays defensive points');
  const round = fight.player.round;
  ok(round.defence >= 1 && round.defencePoints > 0, 'the round keeps defence and damage apart');
});

check('A/D3 judging: punches score on damage, defence on clean wins', () => {
  const rng = () => R.makeRng(R.hashSeed(700, 'judges'));
  const punches = { landed: 8, damage: 30, thrown: 20, kd: 0, defence: 0, defencePoints: 0 };
  const defence = { landed: 0, damage: 0, thrown: 6, kd: 0, defence: 8, defencePoints: 20 };
  const a = R.scoreRound({ judgeRng: rng() }, punches, defence);
  const b = R.scoreRound({ judgeRng: rng() }, defence, punches);
  ok(a.some((s) => s[0] > s[1]), 'punches that land and hurt win the round');
  ok(b.every((s) => s[1] >= s[0]), 'a zero-punch, all-defence round never wins on the cards');
  let landed = 0, thrown = 0;
  for (let i = 0; i < 20; i++) {
    const { game, fight } = bout(710 + i, 'ada', 'mara');
    while (!R.isOver(fight)) {
      if (fight.phase === 'corner') { R.pickCorner(game, R.aiCornerPick(game)); continue; }
      R.playExchange(game, legalCard(fight), 'react', fight.opponent.hand[0]);
    }
    landed += fight.player.totals.landed; thrown += fight.player.totals.thrown;
  }
  ok(landed < thrown, 'landed events are punches only (' + landed + ' of ' + thrown + ' thrown)');
});

check('A/D8 shape: the table is built from shapes, with the named overrides on top', () => {
  for (const a of R.CARD_ORDER) for (const b of R.CARD_ORDER) {
    const key = a + '>' + b, rev = b + '>' + a;
    const named = R.EXCEPTIONS[key] || (R.EXCEPTIONS[rev] ? R.FLIP[R.EXCEPTIONS[rev]] : null);
    const shaped = R.SHAPE_MATRIX[R.CARDS[a].shape][R.CARDS[b].shape];
    eq(R.RESOLUTION[a][b], named || shaped, 'cell ' + key + ' comes from a named rule or the shape rule');
    eq(R.RESOLUTION[b][a], R.FLIP[R.RESOLUTION[a][b]], 'cell ' + key + ' is anti-symmetric');
  }
  for (const shape of R.SHAPES) {
    const row = R.SHAPE_MATRIX[shape];
    const beats = Object.keys(row).filter((s) => W.has(row[s])).length;
    const loses = Object.keys(row).filter((s) => ['l', 'X'].includes(row[s])).length;
    ok(beats >= 1, 'shape ' + shape + ' beats at least one shape');
    ok(beats < R.SHAPES.length - 1, 'no shape beats everything');
  }
});

check('A/D8 defensive data is read: counters only pay when you win and take nothing', () => {
  /* round 3b gives each seat its own hit stream, so the block's own accuracy
     roll can miss on any single seed. The check walks a handful of seeds and
     demands that a clean defensive win is actually worth points. */
  let paid = false, last = '';
  for (let seed = 810; seed < 872 && !paid; seed++) {
    const { game, fight } = bout(seed, 'ada', 'mara');
    hand(fight, ['block', 'block', 'block', 'block', 'block']);
    fight.opponent.hand = ['jab', 'jab', 'jab', 'jab', 'jab'];
    const points = fight.player.totals.defencePoints || 0;
    const ev = R.playExchange(game, 'block', 'react', 'jab');
    last = ev.text;
    paid = fight.player.totals.defencePoints > points;
  }
  ok(paid, 'the printed counter block is data the engine uses: ' + last);
});

check('A/breathe: the light first exchange belongs to the exchange after the corner', () => {
  const { game, fight } = bout(820, 'ada', 'mara');
  eq(fight.player.mods.firstExchange, undefined, 'nothing is light at the opening bell');
  fight.player.stamina = 20;
  toCorner(game, fight);
  ok(fight.corner.includes('breathe'), 'breathe is offered to a tired boxer');
  R.pickCorner(game, 'breathe');
  eq(fight.player.mods.firstExchange, -0.35, 'the corner sets the light first exchange');
  eq(fight.exchange, 0, 'the next exchange is the first of the round');
  const ev1 = R.playExchange(game, legalCard(fight), 'react', fight.opponent.hand[0]);
  eq(fight.player.mods.firstExchange, undefined, 'it is spent on that one exchange');
  R.playExchange(game, legalCard(fight), 'react', fight.opponent.hand[0]);
  eq(fight.player.mods.firstExchange, undefined, 'the second exchange of the round is a normal one');
});

check('A/knockdown protection: the opening exchange of a fresh bout cannot drop a man', () => {
  let openingDrops = 0, otherDrops = 0;
  for (let i = 0; i < 80; i++) {
    const { game, fight } = bout(900 + i, 'mara', 'ines');
    while (!R.isOver(fight)) {
      if (fight.phase === 'corner') { R.pickCorner(game, R.aiCornerPick(game)); continue; }
      const ev = R.playExchange(game, R.chooseAiCard(fight, 'player'), 'react', fight.opponent.hand[0]);
      if (ev.round === 1 && ev.exchange === 0) openingDrops += ev.knockdowns.length;
      else otherDrops += ev.knockdowns.length;
    }
  }
  eq(openingDrops, 0, 'no knockdown on the opening exchange');
  ok(otherDrops > 0, 'later exchanges can still put a man down (' + otherDrops + ')');
});


console.log('');
console.log(passed + ' passed, ' + failed + ' failed');
if (failed) { console.log('RESULT: FAIL - round 3 Part A (' + failed + ' failed)'); process.exit(1); }
console.log('RESULT: PASS - round 3 Part A (' + passed + ' checks green)');
