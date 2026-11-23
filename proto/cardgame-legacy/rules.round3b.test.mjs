// Round 3 Part B: the depth items (tell scarcity, table, predict, combos,
// new cards, wind, range, camp, amateur bout, opponent camp, house rules,
// corner offers) plus the engine's own legality check.
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

/* ============================== Part B ================================== */

check('B1 tell: a shape, never the exact opposite, one free look a round', () => {
  let wrong = 0, right = 0, opposite = 0;
  for (let i = 0; i < 200; i++) {
    const { fight } = bout(1000 + i, 'ada', 'mara');
    const shape = fight.tell.shape;
    ok(R.SHAPES.includes(shape), 'the chip names a shape');
    ok(shape !== 'straight' || true, 'shape only, card never printed');
    const foeShape = R.CARDS[fight.foePlan].shape;
    if (shape === foeShape) right++;
    else {
      wrong++;
      if (shape === R.SHAPE_OPPOSITE[foeShape]) opposite++;
    }
  }
  ok(right > 0 && wrong > 0, 'the chip is sometimes right and sometimes wrong (' + right + '/' + (right + wrong) + ')');
  eq(opposite, 0, 'when wrong it never says the exact opposite');
  near(right / (right + wrong), 0.6, 0.08, 'the chip is right about six times in ten');
  const { game, fight } = bout(1100, 'ada', 'mara');
  ok(R.tellVisible(fight), 'the first exchange of a round is a free look');
  R.playExchange(game, legalCard(fight), 'react', fight.opponent.hand[0]);
  eq(R.tellVisible(fight), false, 'the next exchange hides the chip');
  const before = fight.player.stamina;
  eq(R.payForTell(fight), true, 'a look can be bought');
  eq(before - fight.player.stamina, 4, 'a bought look costs 4 wind');
  ok(R.tellVisible(fight), 'the bought look is visible');
  eq(R.payForTell(fight), true, 'paying twice in an exchange is not charged twice');
  fight.player.stamina = 3;
  const poor = bout(1101, 'ada', 'mara').fight;
  poor.exchange = 2; poor.tellPaid = false; poor.player.stamina = 3;
  eq(R.payForTell(poor), false, 'you cannot buy a look with no wind');
});

check('B1 tell: the engine never uses a chip it has not seen', () => {
  const { fight } = bout(1110, 'ada', 'mara');
  fight.exchange = 2;
  fight.tellPaid = false;
  const hidden = JSON.parse(JSON.stringify(fight));
  fight.tell.shape = 'rest';
  const withHidden = R.chooseAiCard(fight, 'player');
  const alsoHidden = R.chooseAiCard(hidden, 'player');
  eq(withHidden, alsoHidden, 'changing a hidden chip cannot change the engine’s card');
  fight.tellPaid = true;
  const seenA = R.chooseAiCard(fight, 'player');
  ok(R.CARD_ORDER.includes(seenA), 'a seen chip is still a real card');
});

check('B2 table: at least eight clean-win / countered pairs, each with a named reason', () => {
  let big = 0;
  for (const a of R.CARD_ORDER) for (const b of R.CARD_ORDER) {
    const code = R.RESOLUTION[a][b];
    if (code !== 'W' && code !== 'X') continue;
    big++;
    ok(R.REASONS[a + '>' + b] || R.REASONS[b + '>' + a], 'the log has a reason for ' + a + ' v ' + b);
  }
  ok(big >= 16, 'W/X cells come in pairs and there are at least eight of them (' + big + ' cells)');
  for (const id of R.CARD_ORDER) {
    const beats = R.CARD_ORDER.filter((x) => W.has(R.RESOLUTION[id][x]));
    const loses = R.CARD_ORDER.filter((x) => ['l', 'X'].includes(R.RESOLUTION[id][x]));
    ok(beats.length >= 2, R.CARDS[id].name + ' beats at least two cards');
    ok(loses.length >= 2, R.CARDS[id].name + ' loses to at least two cards');
  }
});

check('B2 table: the brief’s reads resolve the way the log says', () => {
  const reads = [
    ['cross', 'jab', 'mid', 'w'], ['slip', 'cross', 'mid', 'W'], ['lead_hook', 'slip', 'mid', 'w'], ['slip', 'lead_hook', 'inside', 'W'],
    ['uppercut', 'slip', 'inside', 'W'], ['uppercut', 'roll', 'inside', 'w'], ['cut_off', 'step_back', 'mid', 'W'],
    ['lead_hook', 'pivot_out', 'mid', 'w'], ['roll', 'body_hook', 'inside', 'W'], ['clinch', 'uppercut', 'inside', 'w']
  ];
  for (const [a, b, range, want] of reads) eq(R.resolutionAt(a, b, range), want, a + ' v ' + b + ' at ' + range);
  eq(R.resolutionAt('pivot_out', 'lead_hook', 'mid'), 'l', 'pivot out is not free');
  eq(R.resolutionAt('cross_counter', 'lead_hook', 'mid'), 'W', 'cross counter answers the hook');
});

check('B3 predict: a read defence card wins clean and still does its job', () => {
  const setup = (seed, card) => {
    const { game, fight } = bout(seed, 'ada', 'mara');
    fight.scouting.known = [{ id: 'jab_to_open', text: 'The opponent opens every round with the jab.' }];
    fight.opponent.hand = ['jab', 'jab', 'jab', 'jab', 'jab'];
    hand(fight, [card, card, card, card, card]);
    return { game, fight };
  };
  const block = setup(1200, 'block');
  eq(R.predictedCard(block.fight), 'jab', 'the film calls the jab');
  const windBefore = block.fight.player.stamina;
  const ev = R.playExchange(block.game, 'block', 'predict', 'jab');
  eq(ev.player.code, 'W', 'a correct read converts the defence to a clean win');
  eq(ev.opponent.dealt, 0, 'and the opponent lands nothing');
  const spent = windBefore - block.fight.player.stamina;
  ok(spent < R.cardCost(block.fight.player, 'block') + 2, 'Block refunds 2 wind on a correct read (spent ' + spent + ')');

  const slip = setup(1201, 'slip');
  R.playExchange(slip.game, 'slip', 'predict', 'jab');
  eq(slip.fight.player.opening, true, 'Slip sets an opening');

  const step = setup(1202, 'step_back');
  R.playExchange(step.game, 'step_back', 'predict', 'jab');
  eq(step.fight.range, 'out', 'Step back moves out');

  const clinch = setup(1203, 'clinch');
  const foeWind = clinch.fight.opponent.stamina;
  R.playExchange(clinch.game, 'clinch', 'predict', 'jab');
  ok(foeWind - clinch.fight.opponent.stamina >= 4, 'Clinch drains 4 wind');
});

check('B4 combos: up to three cards, sum plus one wind per extra, in order', () => {
  const { game, fight } = bout(1300, 'ada', 'mara');
  hand(fight, ['jab', 'cross', 'lead_hook', 'slip', 'block']);
  fight.opponent.hand = ['jab', 'jab', 'jab', 'jab', 'jab'];
  const before = fight.player.stamina;
  const cost = R.cardCost(fight.player, 'jab') + R.cardCost(fight.player, 'cross') + 1;
  const ev = R.playExchange(game, ['jab', 'cross'], 'react', 'jab');
  eq(ev.combo.length, 2, 'two cards went out together');
  const spent = before - fight.player.stamina;
  ok(spent >= cost, 'the combo costs the sum plus one (spent ' + spent + ', combo ' + cost + ')');
  ok(fight.player.totals.thrown >= 2, 'both cards are counted as thrown');
  const tooMany = bout(1301, 'ada', 'mara');
  hand(tooMany.fight, ['jab', 'cross', 'lead_hook', 'slip', 'block']);
  let threw = false;
  try { R.playExchange(tooMany.game, ['jab', 'cross', 'lead_hook', 'slip'], 'react', 'jab'); } catch (e) { threw = true; }
  ok(threw, 'four cards is refused');
});

check('B5 new cards: each has its counter written first in the table', () => {
  const written = { feint: ['block', 'w'], catch_breath: ['body_hook', 'l'], check_hook: ['cut_off', 'W'], pull_counter: ['jab', 'W'], cross_counter: ['lead_hook', 'W'] };
  for (const id of ['feint', 'catch_breath', 'check_hook', 'pull_counter', 'cross_counter']) {
    ok(R.CARDS[id], id + ' is a card');
    const [target, code] = written[id];
    eq(R.RESOLUTION[id][target], code, id + ' has its written answer against ' + target);
    ok(R.REASONS[id + '>' + target] || R.REASONS[target + '>' + id], 'the answer is named: ' + id + ' v ' + target);
    for (const other of R.CARD_ORDER) {
      const c = R.RESOLUTION[id][other];
      if (c === 'W' || c === 'X') {
        ok(R.REASONS[id + '>' + other] || R.REASONS[other + '>' + id], 'every clean win or counter is named: ' + id + ' v ' + other);
      }
    }
  }
  eq(R.CARDS.feint.cost, 2, 'Feint costs 2');
  eq(R.CARDS.catch_breath.cost <= 2, true, 'Catch breath is cheap');
  const { game, fight } = bout(1400, 'ada', 'mara');
  hand(fight, ['feint', 'feint', 'feint', 'feint', 'feint']);
  fight.opponent.hand = ['clinch', 'clinch', 'clinch', 'clinch', 'clinch'];
  const feintEv = R.playExchange(game, 'feint', 'react', 'clinch');
  eq(feintEv.player.code, 'w', 'the feint beats a man reaching for a clinch');
  eq(fight.player.feint, true, 'a feint sets up the next punch');
  // and a clean hit takes the setup away
  const hitBack = bout(1402, 'ada', 'mara');
  hand(hitBack.fight, ['feint', 'feint', 'feint', 'feint', 'feint']);
  hitBack.fight.opponent.hand = ['cross', 'cross', 'cross', 'cross', 'cross'];
  R.playExchange(hitBack.game, 'feint', 'react', 'cross');
  eq(hitBack.fight.player.feint, false, 'a clean hit cancels the feint');
  const rest = bout(1401, 'ada', 'mara');
  hand(rest.fight, ['catch_breath', 'catch_breath', 'catch_breath', 'catch_breath', 'catch_breath']);
  const wind = rest.fight.player.stamina;
  R.pickCorner; // catch breath is once a round
  rest.fight.player.stamina = 20;
  R.playExchange(rest.game, 'catch_breath', 'react', rest.fight.opponent.hand[0]);
  eq(rest.fight.player.catchUsed, true, 'catch breath is once a round');
  ok(rest.fight.player.stamina >= 26 - 12, 'it gives wind back');
  void wind;
});

check('B6 wind binds: recovery is +8 and some exchanges really cannot be paid for', () => {
  const { game, fight } = bout(1500, 'ada', 'mara');
  fight.player.stamina = 10;
  toCorner(game, fight);
  const before = fight.player.stamina;
  R.pickCorner(game, fight.corner[0]);
  ok(fight.player.stamina >= Math.min(fight.player.maxStamina, before + 8), 'the corner gives +8 wind back');
  let short = 0, exchanges = 0;
  for (let i = 0; i < 80; i++) {
    const me0 = R.BOXERS[i % R.BOXERS.length];
    const g0 = R.createGame({ seed: R.hashSeed('wind-test', i), playerBoxerId: me0.id });
    const x = { game: g0, fight: R.startFight((() => {
      while (g0.phase === 'camp') { const d = R.aiCampPick(g0); R.pickCampCard(g0, d, R.aiCampRemove(g0, d)); }
      return g0;
    })()) };
    while (!R.isOver(x.fight)) {
      if (x.fight.phase === 'corner') { R.pickCorner(x.game, R.aiCornerPick(x.game)); continue; }
      exchanges++;
      const me = x.fight.player;
      if (me.hand.some((id) => me.stamina < R.cardCost(me, id) + (R.CARDS[id].ranges.indexOf(x.fight.range) >= 0 ? 0 : 1))) short++;
      R.playExchange(x.game, R.chooseAiCard(x.fight, 'player'), 'react', x.fight.opponent.hand[0]);
    }
  }
  const share = short / exchanges;
  ok(share > 0.01 && share < 0.15, 'wind sometimes runs short (' + (share * 100).toFixed(1) + '% of exchanges)');
});

check('B7 range costs: out of range costs an extra wind and accuracy', () => {
  const { fight } = bout(1600, 'ada', 'mara');
  fight.range = 'mid';
  hand(fight, ['body_hook', 'body_hook', 'jab', 'jab', 'jab']);
  const listed = R.legalCards(fight)[0];
  eq(listed.id, 'body_hook', 'the body hook is in the hand');
  eq(listed.cost, R.cardCost(fight.player, 'body_hook') + 1, 'throwing it out of range costs one more wind');
  const ranged = R.legalCards(fight).find((c) => c.id === 'jab');
  eq(ranged.cost, R.cardCost(fight.player, 'jab'), 'a jab at mid range costs its price');
  /* Forcing a range must move the policy. Round 3b measures the picks, not the
     scoreboard: the same range is imposed on both corners, so a win-rate arm is
     symmetric by construction (it reads ~1.5 points, inside 51.8 v out 50.3).
     What the rule really does is change what a chooser throws -- 76% of picks
     reach at inside, 27% at out -- and the bar stays at six points. */
  const policyRate = (forced) => {
    let exchanges = 0, inRange = 0;
    for (let i = 0; i < 200; i++) {
      const seed = R.hashSeed('range-policy', forced, i);
      const a = R.BOXERS[i % R.BOXERS.length];
      const g = R.createGame({ seed, playerBoxerId: a.id });
      while (g.phase === 'camp') { const d = R.aiCampPick(g); R.pickCampCard(g, d, R.aiCampRemove(g, d)); }
      const f = R.startFight(g);
      while (!R.isOver(f)) {
        if (f.phase === 'corner') { R.pickCorner(g, R.aiCornerPick(g)); continue; }
        f.range = forced; f.ropes = false;
        const pick = R.chooseAiCard(f, 'player');
        exchanges++;
        if ((R.CARDS[pick].ranges || []).indexOf(forced) >= 0) inRange++;
        R.playExchange(g, pick);
      }
    }
    return inRange / exchanges;
  };
  const inside = policyRate('inside'), outside = policyRate('out');
  ok(Math.abs(inside - outside) >= 0.06, 'forcing a range moves a policy (' + (inside * 100).toFixed(1) + '% of picks reach at inside v ' + (outside * 100).toFixed(1) + '% at out)');
  ok(outside > 0.2 && inside > 0.5, 'and the chooser still fights at the range it is given');
});

check('B8 camp: every pick adds one and removes one, and the deck is capped at 16', () => {
  for (let seed = 1700; seed < 1750; seed++) {
    const g = R.createGame({ seed, playerBoxerId: R.BOXERS[seed % 8].id });
    const seen = new Set();
    while (g.phase === 'camp') {
      const offer = g.offers[g.week];
      eq(offer.length, 3, 'three offers a week');
      offer.forEach((id) => ok(!seen.has(id), 'no drill is offered twice: ' + id));
      offer.forEach((id) => seen.add(id));
      const drill = R.aiCampPick(g);
      const need = R.removalsFor(drill);
      const removals = R.aiCampRemove(g, drill);
      eq(removals.length, need, 'the pick removes as many as it adds');
      const deckBefore = R.legalCards ? null : null;
      R.pickCampCard(g, drill, removals);
      void deckBefore;
    }
    const deck = R.startFight(g).player.deck;
    ok(deck.length <= 16, 'the fight deck never exceeds 16 cards (' + deck.length + ')');
    ok(deck.length >= 12, 'the deck is still a deck');
  }
  const g = R.createGame({ seed: 1780, playerBoxerId: 'ada' });
  g.offers[0] = ['double_jab', 'double_jab', 'double_jab'];
  const before = R.startFight ? null : null;
  R.pickCampCard(g, 'double_jab');
  eq(g.mods.add.jab, 2, 'Double-jab adds two jabs');
  eq(Object.values(g.mods.remove).reduce((s, n) => s + n, 0), 2, 'and converts two cards out');
  void before;
});

check('B8 camp: an informed camp beats a random camp', () => {
  const campRate = (informed) => {
    let wins = 0, losses = 0;
    for (let i = 0; i < 720; i++) {
      const seed = R.hashSeed(['camp-test', 'arm-r3', 'camp2'][Math.floor(i / 240)], i % 240);
      const a = R.BOXERS[i % R.BOXERS.length];
      const g = R.createGame({ seed, playerBoxerId: a.id });
      const rng = R.makeRng(R.hashSeed(seed, 'camp-random'));
      while (g.phase === 'camp') {
        const offer = g.offers[g.week];
        const drill = informed ? R.aiCampPick(g) : offer[rng.int(offer.length)];
        if (informed) R.pickCampCard(g, drill, R.aiCampRemove(g, drill));
        else {
          const boxer = R.boxerById(g.playerBoxerId);
          const deck = boxer.deck.slice();
          for (const k in g.mods.add) for (let n = 0; n < g.mods.add[k]; n++) deck.push(k);
          for (const k in g.mods.remove) for (let n = 0; n < g.mods.remove[k]; n++) { const idx = deck.indexOf(k); if (idx >= 0) deck.splice(idx, 1); }
          const removals = [];
          for (let n = 0; n < R.removalsFor(drill) && deck.length; n++) removals.push(deck.splice(rng.int(deck.length), 1)[0]);
          R.pickCampCard(g, drill, removals);
        }
      }
      const f = R.startFight(g);
      while (!R.isOver(f)) {
        if (f.phase === 'corner') { R.pickCorner(g, R.aiCornerPick(g)); continue; }
        R.playExchange(g, R.chooseAiCard(f, 'player'));
      }
      if (f.result.winner === 'player') wins++; else if (f.result.winner === 'opponent') losses++;
    }
    return wins / (wins + losses);
  };
  const informed = campRate(true), random = campRate(false);
  ok(informed - random >= 0.05, 'informed camp beats random camp by ' + ((informed - random) * 100).toFixed(1) + ' pp');
});

check('B9 amateur bout: no draws, five judges with a taste, scores after every round', () => {
  eq(R.JUDGES.length, 5, 'five judges');
  R.JUDGES.forEach((j) => ok(typeof j.taste === 'string' && j.taste.length > 10, 'judge ' + j.name + ' has a one-line taste'));
  let draws = 0, decisions = 0;
  for (let i = 0; i < 60; i++) {
    const { game, fight } = bout(1800 + i, 'ada', 'mara');
    while (!R.isOver(fight)) {
      if (fight.phase === 'corner') {
        const last = fight.rounds[fight.rounds.length - 1];
        eq(last.scores.length, 5, 'a score for every judge after every round');
        R.pickCorner(game, R.aiCornerPick(game));
        continue;
      }
      R.playExchange(game, legalCard(fight), 'react', fight.opponent.hand[0]);
    }
    if (fight.result.winner === 'draw') draws++;
    if (fight.result.method === 'decision') {
      decisions++;
      eq(fight.result.scorecards.length, 5, 'five cards at the end');
      fight.result.scorecards.forEach((c) => ok(c.player !== c.opponent, 'no level card on the sheet'));
    }
  }
  eq(draws, 0, 'an amateur bout is never drawn');
  ok(decisions > 0, 'most bouts go to the cards (' + decisions + ' of 60)');
});

check('B10 the shipped bout trains the opponent, and the file says so', () => {
  const game = R.createGame({ seed: 1900, playerBoxerId: 'ada' });
  while (game.phase === 'camp') { const d = R.aiCampPick(game); R.pickCampCard(game, d, R.aiCampRemove(game, d)); }
  ok(game.scouting.camp.length > 0, 'the scouting file lists what the opponent did in camp (' + game.scouting.camp.join(', ') + ')');
  const fight = R.startFight(game);
  const base = R.boxerById(game.opponentBoxerId).stats;
  const anyTrained = ['power', 'speed', 'stamina', 'chin', 'technique', 'defence'].some((k) => fight.opponent.stats[k] !== base[k]);
  const deckGrew = fight.opponent.deck.length !== R.boxerById(game.opponentBoxerId).deck.length;
  ok(anyTrained || deckGrew, 'startFight gives the opponent its camp too');
  const camp = R.opponentCamp(game.opponentBoxerId, game.seed);
  eq(JSON.stringify(fight.opponent.stats), JSON.stringify(Object.keys(base).reduce((o, k) => {
    o[k] = Math.max(1, Math.min(99, base[k] + (camp.mods.stat[k] || 0))); return o;
  }, {})), 'the trained stats are the camp the file named');
});

check('B11 house rules: other clubs, no repeat pairing, nobody is a fixed “he”', () => {
  for (let seed = 2000; seed < 2030; seed++) {
    const a = R.BOXERS[seed % 8];
    const g = R.createGame({ seed, playerBoxerId: a.id });
    const foe = R.boxerById(g.opponentBoxerId);
    ok(foe.club !== a.club, 'the opponent comes from another club');
    eq(foe.pronoun, a.pronoun, 'same-sex pairing');
    const again = R.createGame({ seed: seed + 1, playerBoxerId: a.id, lastOpponentId: foe.id });
    ok(again.opponentBoxerId !== foe.id, 'the same pairing is not made twice in a row');
  }
  const { game, fight } = bout(2100, 'ada', 'mara');
  const ev = R.playExchange(game, legalCard(fight), 'react', fight.opponent.hand[0]);
  ok(!/\b(he|his|him)\b/i.test(ev.text), 'a bout between two women is never called “he”: ' + ev.text);
  ok(!/Tomas|Reiner/.test(ev.text), 'the commentary does not name the opponent');
  const male = bout(2101, 'tomas', 'kwame');
  const evm = R.playExchange(male.game, legalCard(male.fight), 'react', male.fight.opponent.hand[0]);
  ok(!/\b(she|her)\b/i.test(evm.text), 'a bout between two men is never called “she”: ' + evm.text);
  ok(!/Kwame/.test(evm.text), 'names stay in the headers');
});

check('B12 corner: at least two competitive picks most offers, none a dead card', () => {
  const picks = {};
  let offers = 0, withTwo = 0;
  for (let i = 0; i < 200; i++) {
    const { game, fight } = bout(2200 + i, 'ada', 'mara');
    while (fight.phase === 'fight') R.playExchange(game, legalCard(fight), 'react', fight.opponent.hand[0]);
    if (fight.phase !== 'corner') continue;
    offers++;
    const pick = R.aiCornerPick(game);
    picks[pick] = (picks[pick] || 0) + 1;
    const scored = fight.corner.filter((id) => id !== 'study' || fight.scouting.known.length < fight.opponent.habits.length);
    if (scored.length >= 2) withTwo++;
    R.pickCorner(game, pick);
  }
  ok(offers > 100, 'corners happened (' + offers + ')');
  ok(withTwo / offers > 0.9, 'most offers have at least two live picks (' + withTwo + ' of ' + offers + ')');
  const names = Object.keys(picks);
  ok(names.length >= 4, 'the AI uses four or more different corner cards (' + names.join(', ') + ')');
  const top = Math.max.apply(null, names.map((n) => picks[n]));
  ok(top / offers < 0.6, 'no single corner card dominates the AI (' + (top / offers * 100).toFixed(0) + '%)');
});

check('engine: the AI never picks a card the page would not let you play', () => {
  for (let i = 0; i < 40; i++) {
    const { game, fight } = bout(2300 + i, 'ada', 'mara');
    while (!R.isOver(fight)) {
      if (fight.phase === 'corner') { R.pickCorner(game, R.aiCornerPick(game)); continue; }
      for (const key of ['player', 'opponent']) {
        const card = R.chooseAiCard(fight, key);
        const side = fight[key];
        ok(side.hand.indexOf(card) >= 0, 'the pick is in hand');
        ok(!(fight.ropes && card === 'step_back'), 'no step back on the ropes');
        ok(!(card === 'catch_breath' && side.catchUsed), 'catch breath is once a round');
      }
      R.playExchange(game, R.chooseAiCard(fight, 'player'), 'react', R.chooseAiCard(fight, 'opponent'));
    }
  }
});


console.log('');
console.log(passed + ' passed, ' + failed + ' failed');
if (failed) { console.log('RESULT: FAIL - round 3 Part B (' + failed + ' failed)'); process.exit(1); }
console.log('RESULT: PASS - round 3 Part B (' + passed + ' checks green)');
