// Round 4 (second critic, code-checked): the shield combination, wind on
// combinations, the called forecast, the clinch penalty, the ropes ladder, the
// two chairs, judges with tastes, and the corner instructions.
// Every check here is new in this round; nothing earlier was removed or loosened.
import R from './rules.js';

let passed = 0, failed = 0;
function check(name, fn) {
  try { fn(); passed++; console.log('PASS  ' + name); }
  catch (e) { failed++; console.log('FAIL  ' + name + '\n      ' + e.message); }
}
function ok(v, msg) { if (!v) throw new Error(msg || 'expected true'); }
function eq(a, b, msg) { if (a !== b) throw new Error((msg || 'equals') + ' (get ' + JSON.stringify(a) + ', want ' + JSON.stringify(b) + ')'); }

function bout(seed, me = 'ada', foe = 'mara') {
  const game = R.createGame({ seed, playerBoxerId: me, opponentBoxerId: foe });
  while (game.phase === 'camp') { const d = R.aiCampPick(game); R.pickCampCard(game, d, R.aiCampRemove(game, d)); }
  return { game, fight: R.startFight(game) };
}
/* a fresh bout at mid range with both hands fixed */
function fixed(seed, mine, his, range = 'mid') {
  const b = bout(seed);
  b.fight.range = range;
  b.fight.player.hand = mine.slice();
  b.fight.opponent.hand = his.slice();
  return b;
}
function toCorner(game, fight) {
  for (let i = 0; i < 6 && fight.phase === 'fight'; i++) R.playExchange(game, R.chooseAiCard(fight, 'player'));
  if (fight.phase !== 'corner') throw new Error('expected the corner');
}
/* first seed for which `fn` returns something */
function find(from, fn) {
  for (let seed = from; seed < from + 400; seed++) { const out = fn(seed); if (out) return out; }
  throw new Error('no seed in ' + from + '..' + (from + 400) + ' builds the fixture');
}

/* ------------------------------------------------- 1. the shield combination -- */

check('R4 combo: he answers the worst card of the combination, not the first', () => {
  const alone = fixed(4001, ['slip', 'jab', 'cross', 'block', 'roll'], ['jab', 'jab', 'jab', 'jab', 'jab']);
  const one = R.playExchange(alone.game, 'slip', 'react', 'jab');
  eq(one.opponent.code, 'X', 'a slip alone counters the jab');
  eq(one.opponent.dealt, 0, 'and takes nothing');
  const shield = fixed(4001, ['slip', 'jab', 'cross', 'block', 'roll'], ['jab', 'jab', 'jab', 'jab', 'jab']);
  const two = R.playExchange(shield.game, ['slip', 'jab'], 'react', 'jab');
  eq(two.opponent.code, 't', 'behind the slip the jab trades with his jab: he answers that one');
  ok(R.CODE_FACTOR[two.opponent.code] > R.CODE_FACTOR[one.opponent.code], 'the slip in front no longer shields the punch behind it');
  ok(two.text.includes('trade') && !two.text.includes('beats'), 'and the line is written from the card he answered: ' + two.text);
});

check('R4 combo: a card that loses ends the combination', () => {
  const { game } = fixed(4002, ['jab', 'cross', 'lead_hook', 'block', 'roll'], ['cross', 'cross', 'cross', 'cross', 'cross']);
  eq(R.resolutionAt('jab', 'cross', 'mid'), 'l', 'the jab loses to the cross at mid');
  const ev = R.playExchange(game, ['jab', 'cross', 'lead_hook'], 'react', 'cross');
  eq(ev.comboHits.length, 3, 'three cards were committed');
  eq(ev.comboHits[1].verdict, 'never leaves', 'the cross behind the beaten jab never leaves');
  eq(ev.comboHits[1].dealt + ev.comboHits[2].dealt, 0, 'and nothing behind it lands');
  const win = fixed(4003, ['cross', 'jab', 'lead_hook', 'block', 'roll'], ['jab', 'jab', 'jab', 'jab', 'jab']);
  const ev2 = R.playExchange(win.game, ['cross', 'jab'], 'react', 'jab');
  ok(ev2.comboHits[1].verdict !== 'never leaves', 'behind a winning card the next one is thrown');
});

check('R4 combo: the second card costs 2 wind more and the third 4 more', () => {
  const cards = ['jab', 'cross', 'lead_hook'];
  const cost = (n) => {
    const { game, fight } = fixed(4004, ['jab', 'cross', 'lead_hook', 'block', 'roll'], ['block', 'block', 'block', 'block', 'block']);
    const sum = cards.slice(0, n).reduce((t, id) => t + R.costNow(fight.player, fight, 'player', id), 0);
    const before = fight.player.stamina;
    R.playExchange(game, n === 1 ? cards[0] : cards.slice(0, n), 'react', 'block');
    /* body damage and the block refund do not apply: his block deals nothing */
    return { spent: before - fight.player.stamina, sum };
  };
  const one = cost(1), two = cost(2), three = cost(3);
  eq(one.spent, one.sum, 'one card costs its price');
  eq(two.spent, two.sum + 2, 'two cards cost the sum plus 2');
  eq(three.spent, three.sum + 6, 'three cards cost the sum plus 6');
});

check('R4 combo: no wind, no combination; a gassed punch does under half', () => {
  const { game, fight } = fixed(4005, ['jab', 'cross', 'lead_hook', 'block', 'roll'], ['block', 'block', 'block', 'block', 'block']);
  fight.player.stamina = 0;
  let threw = false;
  try { R.playExchange(game, ['jab', 'cross'], 'react', 'block'); } catch (e) { threw = true; }
  ok(threw, 'a boxer at 0 wind cannot throw a combination');
  const dealt = (wind) => {
    let total = 0;
    for (let i = 0; i < 300; i++) {
      const b = fixed(4100 + i, ['cross', 'cross', 'cross', 'cross', 'cross'], ['catch_breath', 'feint', 'feint', 'feint', 'feint']);
      if (wind !== null) b.fight.player.stamina = wind;
      total += R.playExchange(b.game, 'cross', 'react', 'catch_breath').player.dealt;
    }
    return total;
  };
  const fresh = dealt(null), gassed = dealt(1);
  ok(gassed < fresh * 0.5, 'gassed crosses do under half the work (' + gassed.toFixed(0) + ' v ' + fresh.toFixed(0) + ')');
  ok(gassed > 0, 'but they still land now and then');
});

/* ------------------------------------------------------ 2. the called forecast -- */

check('R4 predict: calling the card right is a clean win', () => {
  const { game } = fixed(4010, ['cross', 'jab', 'slip', 'block', 'roll'], ['jab', 'jab', 'jab', 'jab', 'jab']);
  const ev = R.playExchange(game, 'cross', 'predict', 'jab', 'jab');
  eq(ev.forecast, 'jab', 'the forecast is the card the player called');
  eq(ev.correctRead, true, 'the card was called right');
  eq(ev.player.code, 'W', 'a clean win'); eq(ev.opponent.code, 'X', 'and he lands nothing');
});

check('R4 predict: calling the shape right is one step better, wrong gives him the step', () => {
  const right = fixed(4011, ['cross', 'jab', 'slip', 'block', 'roll'], ['jab', 'jab', 'jab', 'jab', 'jab']);
  eq(R.resolutionAt('cross', 'jab', 'mid'), 'w', 'cross v jab at mid is a win');
  const ev = R.playExchange(right.game, 'cross', 'predict', 'jab', 'straight');
  eq(ev.shapeRead, true, 'the shape was called right'); eq(ev.correctRead, false, 'the card was not named');
  eq(ev.player.code, 'W', 'a win becomes a clean win');
  const trade = fixed(4012, ['jab', 'cross', 'slip', 'block', 'roll'], ['jab', 'jab', 'jab', 'jab', 'jab']);
  eq(R.playExchange(trade.game, 'jab', 'predict', 'jab', 'straight').player.code, 'w', 'a trade becomes a win');
  const wrong = fixed(4013, ['cross', 'jab', 'slip', 'block', 'roll'], ['jab', 'jab', 'jab', 'jab', 'jab']);
  const bad = R.playExchange(wrong.game, 'cross', 'predict', 'jab', 'looping');
  eq(bad.shapeRead, false, 'the shape was called wrong');
  eq(bad.opponent.code, 't', 'his losing jab becomes a trade');
  const guard = fixed(4015, ['feint', 'jab', 'slip', 'cross', 'roll'], ['block', 'block', 'block', 'block', 'block']);
  const one = R.playExchange(guard.game, 'feint', 'predict', 'block', 'guard');
  eq(one.forecast, 'block', 'a shape only one card has is that card'); eq(one.correctRead, true, 'so the call is a card read');
  let threw = false;
  try { R.playExchange(fixed(4014, ['jab'], ['jab']).game, 'jab', 'predict', 'jab', 'a hunch'); } catch (e) { threw = true; }
  ok(threw, 'a call must be a card or a shape');
});

check('R4 predict: a right shape keeps the cover, a wrong one gives it up', () => {
  const taken = (call) => {
    let total = 0;
    for (let i = 0; i < 200; i++) {
      const b = fixed(4200 + i, ['jab', 'jab', 'jab', 'jab', 'jab'], ['jab', 'jab', 'jab', 'jab', 'jab']);
      total += R.playExchange(b.game, 'jab', call ? 'predict' : 'react', 'jab', call).opponent.dealt;
    }
    return total;
  };
  const react = taken(null), right = taken('straight'), wrong = taken('looping');
  ok(right < react, 'the right shape takes less than reacting (' + right.toFixed(0) + ' v ' + react.toFixed(0) + ')');
  ok(wrong > react, 'the wrong shape takes more (' + wrong.toFixed(0) + ' v ' + react.toFixed(0) + ')');
});

/* ------------------------------------------------------ 3. the clinch penalty -- */

check('R4 clinch: the smother is still there at his next punch and is spent by it', () => {
  const { game, fight } = fixed(4020, ['clinch', 'block', 'block', 'jab', 'cross'], ['block', 'cross', 'cross', 'cross', 'cross']);
  const ev = R.playExchange(game, 'clinch', 'react', 'block');
  eq(ev.player.code, 'w', 'the clinch wins');
  eq(fight.opponent.smother, -0.15, 'his next punch carries the 15% penalty into the next exchange');
  fight.player.hand = ['block', 'block', 'block', 'block', 'block']; fight.opponent.hand = ['cross', 'cross', 'cross', 'cross', 'cross'];
  R.playExchange(game, 'block', 'react', 'cross');
  eq(fight.opponent.smother, 0, 'and the punch spends it');
});

check('R4 clinch: his punch after a won clinch lands less often', () => {
  const rate = (smothered) => {
    let hits = 0;
    for (let i = 0; i < 500; i++) {
      const b = fixed(4300 + i, ['clinch', 'jab', 'jab', 'jab', 'jab'], ['block', 'cross', 'cross', 'cross', 'cross']);
      R.playExchange(b.game, smothered ? 'clinch' : 'jab', 'react', 'block');
      b.fight.range = 'mid';
      b.fight.player.hand = ['jab', 'jab', 'jab', 'jab', 'jab']; b.fight.opponent.hand = ['cross', 'cross', 'cross', 'cross', 'cross'];
      if (R.playExchange(b.game, 'jab', 'react', 'cross').opponent.hit) hits++;
    }
    return hits / 500;
  };
  const free = rate(false), held = rate(true);
  ok(free - held > 0.07, 'the smothered cross lands clearly less often (' + held.toFixed(2) + ' v ' + free.toFixed(2) + ')');
});

/* ----------------------------------------------------------- 4. the ropes ---- */

check('R4 ropes: one won cut off, then a won punch inside, puts him on the ropes', () => {
  const b = find(4400, (seed) => {
    const x = fixed(seed, ['cut_off', 'cross', 'jab', 'body_hook', 'slip'], ['block', 'feint', 'feint', 'feint', 'pivot_out']);
    const ev = R.playExchange(x.game, 'cut_off', 'react', 'block');
    if (!(ev.player.hit && ev.player.code === 'w')) return null;
    eq(x.fight.pressBy, 'player', 'a won cut off makes you the man pressing');
    eq(x.fight.range, 'inside', 'and the fight moves inside');
    ok(!x.fight.ropes, 'one cut off at mid is not the ropes yet');
    x.fight.player.hand = ['cross', 'jab', 'body_hook', 'slip', 'block']; x.fight.opponent.hand = ['feint', 'feint', 'pivot_out', 'step_back', 'jab'];
    const ev2 = R.playExchange(x.game, 'cross', 'react', 'feint');
    return ev2.player.hit && ev2.player.code === 'w' ? x : null;
  });
  ok(b.fight.ropes, 'a won punch inside while pressing = the ropes');
  eq(b.fight.ropesWho, 'opponent', 'he is the one on them');
  eq(b.fight.range, 'ropes', 'the range reads ropes');
  ok(!R.legalNow(b.fight.opponent, b.fight, 'opponent', 'step_back'), 'he cannot step back');
  eq(R.costNow(b.fight.player, b.fight, 'player', 'body_hook'), R.cardCost(b.fight.player, 'body_hook'), 'inside work reaches on the ropes at no extra wind');
  ok(R.contextOf(b.fight, 'opponent').onRopes && R.contextOf(b.fight, 'player').foeOnRopes, 'both corners know who is on the ropes');
});

check('R4 ropes: a cut off that catches him stepping back walls him in at once; the pivot gets him off', () => {
  const b = find(4500, (seed) => {
    const x = fixed(seed, ['cut_off', 'body_hook', 'jab', 'slip', 'block'], ['step_back', 'pivot_out', 'jab', 'jab', 'jab']);
    const ev = R.playExchange(x.game, 'cut_off', 'react', 'step_back');
    return ev.player.hit && ev.player.code === 'W' ? x : null;
  });
  ok(b.fight.ropes && b.fight.ropesWho === 'opponent', 'a clean cut off v step back = the ropes');
  const out = find(4600, (seed) => {
    const x = fixed(seed, ['cut_off', 'body_hook', 'jab', 'slip', 'block'], ['step_back', 'pivot_out', 'jab', 'jab', 'jab']);
    const ev = R.playExchange(x.game, 'cut_off', 'react', 'step_back');
    if (!(ev.player.hit && ev.player.code === 'W')) return null;
    x.fight.player.hand = ['body_hook', 'jab', 'slip', 'block', 'roll']; x.fight.opponent.hand = ['pivot_out', 'jab', 'jab', 'jab', 'jab'];
    const ev2 = R.playExchange(x.game, 'body_hook', 'react', 'pivot_out');
    return ev2.opponent.hit && ev2.opponent.code === 'w' ? x : null;
  });
  ok(!out.fight.ropes, 'a won pivot takes him off the ropes');
  eq(out.fight.range, 'mid', 'back to the middle of the ring');
  eq(out.fight.pressBy, null, 'and the pressure has to be built again');
});

check('R4 ropes: the engine may cut the ring off twice running', () => {
  const { fight } = bout(4030, 'mara', 'ada');
  fight.range = 'mid';
  fight.player.hand = ['cut_off', 'slip', 'block', 'jab', 'roll'];
  fight.player.lastCard = 'cut_off';
  eq(R.chooseStyleCard(fight, 'player'), 'cut_off', 'a pressure fighter is allowed the second cut off (the ladder needs it)');
  fight.player.hand = ['slip', 'block', 'jab', 'roll', 'feint']; fight.player.lastCard = 'slip';
  ok(['slip', 'block', 'roll', 'feint'].indexOf(R.chooseStyleCard(fight, 'player')) < 0, 'other non-punch cards still cannot repeat');
});

/* ------------------------------------------------------- 5. the two chairs ---- */

check('R4 chairs: his feint is spent by his punch, and a clean landed shot is recorded', () => {
  const { game, fight } = fixed(4040, ['block', 'block', 'jab', 'cross', 'slip'], ['feint', 'jab', 'jab', 'jab', 'jab']);
  R.playExchange(game, 'jab', 'react', 'feint');
  eq(fight.opponent.feint, true, 'his feint is live');
  fight.player.hand = ['block', 'block', 'block', 'block', 'block']; fight.opponent.hand = ['jab', 'jab', 'jab', 'jab', 'jab'];
  R.playExchange(game, 'block', 'react', 'jab');
  eq(fight.opponent.feint, false, 'and his punch spends it, as yours does');
  let seen = 0;
  for (let seed = 4700; seed < 4760; seed++) {
    const b = fixed(seed, ['cross', 'cross', 'cross', 'cross', 'cross'], ['catch_breath', 'catch_breath', 'catch_breath', 'catch_breath', 'catch_breath']);
    const ev = R.playExchange(b.game, 'cross', 'react', 'catch_breath');
    eq(b.fight.player.lastLandedClean, ev.player.head >= 5, 'lastLandedClean follows the head damage you landed');
    eq(b.fight.opponent.lastTookClean, ev.player.head >= 5, 'and matches what he took');
    if (b.fight.player.lastLandedClean) seen++;
  }
  ok(seen > 10, 'a clean landed shot is recorded (it was never set before round 4): ' + seen + ' of 60');
});

/* ------------------------------------------------- 6. judges and the corner --- */

check('R4 judges: more punches against harder punches splits the panel', () => {
  const busy = { landed: 10, damage: 22, thrown: 16, kd: 0, defence: 0, defencePoints: 0 };
  const heavy = { landed: 5, damage: 31, thrown: 7, kd: 0, defence: 0, defencePoints: 0 };
  let split = 0;
  for (let seed = 0; seed < 40; seed++) {
    const cards = R.scoreRound({ judgeRng: R.makeRng(R.hashSeed(seed, 'judges')) }, busy, heavy);
    const forBusy = cards.filter((s) => s[0] > s[1]).length, forHeavy = cards.filter((s) => s[1] > s[0]).length;
    if (forBusy >= 1 && forHeavy >= 1) split++;
  }
  ok(split >= 36, 'the panel splits on a volume v damage round (' + split + ' of 40)');
  const cards = R.scoreRound({ judgeRng: R.makeRng(7) }, busy, heavy);
  ok(cards[0][0] > cards[0][1], 'the judge who counts punches gives it to the busier boxer');
  ok(cards[1][1] > cards[1][0], 'the judge who scores damage gives it to the harder puncher');
});

check('R4 corner: go to the body and box and move change the next round', () => {
  const body = bout(4050);
  toCorner(body.game, body.fight);
  body.fight.corner = ['go_body']; body.fight.foeCornerPick = 'ice_eye';
  R.pickCorner(body.game, 'go_body');
  eq(body.fight.player.mods.bodyPunch, 0.25, 'body punches +25% next round');
  eq(body.fight.player.mods.headPunch, -0.15, 'head punches -15% next round');
  const dealt = (instructed) => {
    let head = 0, bodyDmg = 0;
    for (let i = 0; i < 200; i++) {
      const b = fixed(4800 + i, ['body_hook', 'body_hook', 'cross', 'cross', 'cross'], ['catch_breath', 'feint', 'feint', 'feint', 'feint']);
      if (instructed) { b.fight.player.mods.bodyPunch = 0.25; b.fight.player.mods.headPunch = -0.15; }
      bodyDmg += R.playExchange(b.game, 'body_hook', 'react', 'catch_breath').player.body;
      b.fight.player.hand = ['cross', 'cross', 'cross', 'cross', 'cross']; b.fight.opponent.hand = ['feint', 'feint', 'feint', 'feint', 'feint'];
      b.fight.range = 'mid';
      head += R.playExchange(b.game, 'cross', 'react', 'feint').player.head;
    }
    return { head, bodyDmg };
  };
  const plain = dealt(false), told = dealt(true);
  ok(told.bodyDmg > plain.bodyDmg * 1.15, 'the body work is heavier (' + told.bodyDmg.toFixed(0) + ' v ' + plain.bodyDmg.toFixed(0) + ')');
  ok(told.head < plain.head * 0.95, 'the head work is lighter (' + told.head.toFixed(0) + ' v ' + plain.head.toFixed(0) + ')');

  const box = bout(4051);
  toCorner(box.game, box.fight);
  box.fight.corner = ['box_move']; box.fight.foeCornerPick = 'ice_eye';
  R.pickCorner(box.game, 'box_move');
  eq(box.fight.range, 'out', 'the round opens at range');
  eq(R.cardCost(box.fight.player, 'step_back'), 1, 'Step back costs 1 wind this round');
  ok(R.cardCost(box.fight.opponent, 'step_back') > 1, 'only for the corner that asked');
});

check('R4 corner: change the plan costs its six wind once; catch breath gives ten', () => {
  const { game, fight } = bout(4052);
  toCorner(game, fight);
  fight.corner = ['change_plan']; fight.foeCornerPick = 'ice_eye';
  fight.player.stamina = 40;
  R.pickCorner(game, 'change_plan');
  eq(fight.player.stamina, 40 - 6 + 8, 'six for the plan, eight back from the minute on the stool');
  const rest = fixed(4053, ['catch_breath', 'jab', 'jab', 'jab', 'jab'], ['catch_breath', 'feint', 'feint', 'feint', 'feint']);
  rest.fight.player.stamina = 30;
  const price = R.costNow(rest.fight.player, rest.fight, 'player', 'catch_breath');
  R.playExchange(rest.game, 'catch_breath', 'react', 'catch_breath');
  /* two men resting: the referee's stalemate wind (1) comes off as well */
  eq(rest.fight.player.stamina, 30 - price + 10 - 1, 'catch breath puts ten wind back');
});

if (failed) { console.log('\n' + passed + ' passed, ' + failed + ' failed'); process.exit(1); }
console.log('RESULT: PASS - round 4 (' + passed + ' checks green)');
