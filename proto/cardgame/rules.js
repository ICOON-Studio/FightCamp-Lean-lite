/* ============================================================================
   FightCamp card game - prototype rules (boxing only)
   A PURE module: no DOM, no I/O, no Date, no Math.random, no shared state.
   Pass a seed and the same bout plays out the same way, exchange by exchange.

   Shape of a bout
     CAMP   4 weeks, each week pick 1 of 3 training cards. They add cards to your
            fight deck (or raise a stat a little). The camp shapes the deck.
     SCOUT  before the bell you see the opponent's style and 1-2 of their habits.
     FIGHT  3 rounds x 6 exchanges. Both corners play one card face down, then
            reveal. Punches hurt, defence stops punches, footwork changes range.
     CORNER between rounds pick 1 of 3 corner cards; each one costs something.

   Everything here is data: CARDS, MATRIX_ROWS, HABITS, STYLES, CAMP_CARDS,
   CORNER_CARDS, BOXERS. A new martial art is new card data (see README).

   Loads as a classic <script> (window.FightCampRules) so index.html opens by
   double-click, and as a CommonJS module in Node for rules.test.mjs and
   balance.mjs. See README, "Why the page does not use an ES module import".
   ========================================================================== */
(function (root, factory) {
  var data = typeof module === 'object' && module.exports ? require('./rules-data.js') : root.FightCampData;
  var exchange = typeof module === 'object' && module.exports ? require('./rules-exchange.js') : root.FightCampExchange;
  var ai = typeof module === 'object' && module.exports ? require('./rules-ai.js') : root.FightCampAI;
  var api = factory(data, ai, exchange);
  if (typeof module === 'object' && module.exports) module.exports = api;
  if (typeof window !== 'undefined') window.FightCampRules = api;
})(typeof globalThis !== 'undefined' ? globalThis : this, function (DATA, AiModule, ExchangeModule) {
'use strict';

/* --- seeded RNG (mulberry32) --------------------------------------------- */
function makeRng(seed) {
  var s = (seed >>> 0) || 0x9e3779b9;
  var rng = {
    next: function () {
      s = (s + 0x6d2b79f5) >>> 0;
      var t = s;
      t = Math.imul(t ^ (t >>> 15), t | 1);
      t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
      return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
    },
    int: function (n) { return Math.floor(rng.next() * n); },
    chance: function (p) { return rng.next() < p; },
    shuffle: function (arr) {
      for (var i = arr.length - 1; i > 0; i--) { var j = rng.int(i + 1); var t = arr[i]; arr[i] = arr[j]; arr[j] = t; }
      return arr;
    }
  };
  return rng;
}
function hashSeed() {
  var h = 0x811c9dc5;
  for (var a = 0; a < arguments.length; a++) {
    var s = String(arguments[a]);
    for (var i = 0; i < s.length; i++) { h ^= s.charCodeAt(i); h = Math.imul(h, 16777619); }
    h = Math.imul(h ^ 0x9e3779b9, 0x85ebca6b) >>> 0;
  }
  return h >>> 0;
}
function clamp(v, lo, hi) { return v < lo ? lo : v > hi ? hi : v; }

/* --- boxing card data ----------------------------------------------------- */
var KIND_LABEL = DATA.KIND_LABEL;
var CARD_ORDER = DATA.CARD_ORDER;
var CARDS = DATA.CARDS;
var MATRIX_COLS = DATA.MATRIX_COLS;
var MATRIX_ROWS = DATA.MATRIX_ROWS;
var FLIP = DATA.FLIP;
var CODE_FACTOR = DATA.CODE_FACTOR;
var RESOLUTION = DATA.RESOLUTION;
var STYLES = DATA.STYLES;
var HABITS = DATA.HABITS;
var CAMP_CARDS = DATA.CAMP_CARDS;
var CORNER_CARDS = DATA.CORNER_CARDS;
var BOXERS = DATA.BOXERS;
var JUDGES = DATA.JUDGES;
var SITUATION_RULES = DATA.SITUATION_RULES;
var CAMP_PREF = DATA.CAMP_PREF;

/* --- small helpers -------------------------------------------------------- */
function boxerById(id) { for (var i = 0; i < BOXERS.length; i++) if (BOXERS[i].id === id) return BOXERS[i]; return null; }
function cardById(id) { for (var i = 0; i < CAMP_CARDS.length; i++) if (CAMP_CARDS[i].id === id) return CAMP_CARDS[i]; return null; }
function cornerById(id) { for (var i = 0; i < CORNER_CARDS.length; i++) if (CORNER_CARDS[i].id === id) return CORNER_CARDS[i]; return null; }
function maxStamina(stats) { return Math.round(62 + stats.stamina * 0.42); }
function cardCost(side, cardId) {
  var cost = CARDS[cardId].cost * (1.12 - side.stats.stamina / 320);
  if (cardId === 'block' && side.mods && side.mods.block_discount) cost -= side.mods.block_discount;
  return Math.max(1, Math.round(cost));
}
function isHurt(side) { return side.head >= 40 || side.stamina <= 0; }
function totalDamage(side) { return side.head + side.body; }
function otherKey(key) { return key === 'player' ? 'opponent' : 'player'; }
var AI = AiModule({ STYLES: STYLES, CARDS: CARDS, HABITS: HABITS, CARD_ORDER: CARD_ORDER,
  CODE_FACTOR: CODE_FACTOR, RESOLUTION: RESOLUTION, SITUATION_RULES: SITUATION_RULES,
  isHurt: isHurt, totalDamage: totalDamage, otherKey: otherKey, makeRng: makeRng, hashSeed: hashSeed,
  clamp: clamp, cardCost: cardCost });
var contextOf = AI.contextOf, whenMatches = AI.whenMatches, habitChanceInHand = AI.habitChanceInHand;
var scoutingPrediction = AI.scoutingPrediction, predictedCard = AI.predictedCard, expectedSwing = AI.expectedSwing;
var habitCard = AI.habitCard, chooseAiCard = AI.chooseAiCard;
var Exchange = ExchangeModule({ CARDS: CARDS, CODE_FACTOR: CODE_FACTOR, FLIP: FLIP, RESOLUTION: RESOLUTION,
  makeRng: makeRng, hashSeed: hashSeed, clamp: clamp, cardCost: cardCost, chooseAiCard: chooseAiCard, predictedCard: predictedCard,
  refreshTell: refreshTell, refill: refill, isHurt: isHurt,
  checkStoppage: function (f) { return checkStoppage(f); },
  finishEarly: function (f, stop) { return finishEarly(f, stop); },
  endRound: function (g) { return endRound(g); } });
var rangeAfter = Exchange.rangeAfter;
var knockdownChance = Exchange.knockdownChance;
var resolutionAt = Exchange.resolutionAt;
var playExchange = Exchange.playExchange;

/* --- game: camp, then the scouting file ---------------------------------- */
function campOffers(seed) {
  var out = [];
  for (var w = 0; w < 4; w++) {
    var rng = makeRng(hashSeed(seed, 'camp', w));
    var pool = rng.shuffle(CAMP_CARDS.map(function (c) { return c.id; }));
    out.push(pool.slice(0, 3));
  }
  return out;
}
function createGame(opts) {
  opts = opts || {};
  var seed = (opts.seed === undefined ? 1 : opts.seed) >>> 0;
  var playerBoxerId = opts.playerBoxerId || 'ada';
  var opponentBoxerId = opts.opponentBoxerId;
  var player = boxerById(playerBoxerId);
  if (!player) throw new Error('unknown player boxer');
  if (!opponentBoxerId) {
    var pool = BOXERS.filter(function (b) { return b.id !== playerBoxerId && b.pronoun === player.pronoun; });
    opponentBoxerId = pool[hashSeed(seed, 'foe') % pool.length].id;
  }
  var opponent = boxerById(opponentBoxerId);
  if (!opponent || opponent.id === playerBoxerId) throw new Error('choose a different opponent');
  if (opponent.pronoun !== player.pronoun) throw new Error('boxing bouts must be between same-sex boxers');
  return {
    seed: seed, phase: 'camp', week: 0,
    playerBoxerId: playerBoxerId, opponentBoxerId: opponentBoxerId,
    offers: campOffers(seed), picks: [],
    mods: { stat: {}, add: {}, scout: 0 },
    scouting: null, fight: null
  };
}
function statLine(boxer, mods) {
  var out = {};
  for (var k in boxer.stats) out[k] = clamp(boxer.stats[k] + ((mods && mods.stat && mods.stat[k]) || 0), 1, 99);
  return out;
}
function pickCampCard(game, cardId) {
  if (game.phase !== 'camp') throw new Error('camp is over');
  if (game.offers[game.week].indexOf(cardId) < 0) throw new Error('not in this week\'s offer: ' + cardId);
  var card = cardById(cardId);
  for (var k in (card.stat || {})) game.mods.stat[k] = (game.mods.stat[k] || 0) + card.stat[k];
  for (var d in (card.add || {})) game.mods.add[d] = (game.mods.add[d] || 0) + card.add[d];
  if (card.scout) game.mods.scout += card.scout;
  game.picks.push(cardId);
  game.week += 1;
  if (game.week >= 4) { game.phase = 'scout'; game.scouting = scoutReport(game); }
  return game;
}
function scoutReport(game) {
  var foe = boxerById(game.opponentBoxerId);
  var rng = makeRng(hashSeed(game.seed, 'scout', foe.id));
  var n = clamp(rng.int(3) + game.mods.scout, 0, foe.habits.length);
  var seen = rng.shuffle(foe.habits.slice()).slice(0, n);
  return {
    boxerId: foe.id, name: foe.name, style: foe.style, styleName: STYLES[foe.style].name,
    stats: statLine(foe), blurb: foe.blurb,
    known: seen.map(function (id) { return { id: id, text: HABITS[id].text }; }),
    fleeting: foe.habits.length - n,
    summary: n === 0 ? 'Nothing on film. You fight cold.' :
      n === 1 ? 'One thing on film, and you have to judge it.' : 'Two things on film. Enough to build a plan.'
  };
}

/* --- sides and the fight ------------------------------------------------- */
function makeSide(boxer, statMods, addMods) {
  var stats = statLine(boxer, { stat: statMods || {} });
  var deck = boxer.deck.slice();
  for (var k in (addMods || {})) for (var i = 0; i < addMods[k]; i++) deck.push(k);
  /* Each habit's signature is drilled twice into the deck, not merely hoped for. */
  boxer.habits.forEach(function (habitId) {
    var signature = HABITS[habitId].play;
    while (deck.filter(function (id) { return id === signature; }).length < 3) deck.push(signature);
  });
  return {
    boxerId: boxer.id, name: boxer.name, pronoun: boxer.pronoun, poss: boxer.poss,
    style: boxer.style, styleName: STYLES[boxer.style].name, stats: stats, deck: deck,
    draw: [], hand: [], discard: [],
    maxStamina: maxStamina(stats), stamina: maxStamina(stats),
    head: 0, body: 0, knockdowns: 0,
    totals: { thrown: 0, landed: 0, damage: 0 },
    round: { thrown: 0, landed: 0, damage: 0, kd: 0, deductions: 0 },
    lastCard: null, lastTookClean: false, lastLandedClean: false, combo: false, opening: false, clinchStreak: 0,
    mods: {}, habits: boxer.habits.slice()
  };
}
function refill(side, rng, target) {
  while (side.hand.length < target) {
    if (!side.draw.length) {
      if (!side.discard.length) break;
      side.draw = rng.shuffle(side.discard.splice(0, side.discard.length));
    }
    side.hand.push(side.draw.pop());
  }
}
function tellLabel(id) {
  var card = CARDS[id];
  if (card.tags.indexOf('straight') >= 0) return 'loading a straight';
  if (card.tags.indexOf('hook') >= 0) return 'loading a looping shot';
  if (card.tags.indexOf('uppercut') >= 0) return 'loading an uppercut';
  if (id === 'clinch') return 'looking to tie up';
  if (id === 'step_back' || id === 'pivot_out') return 'looking to move out';
  return 'setting a ' + card.say;
}
function refreshTell(fight) {
  fight.foePlan = chooseAiCard(fight, 'opponent');
  var known = fight.scouting.known.length;
  var accuracy = known >= 2 ? 0.85 : known === 1 ? 0.70 : 0.55;
  var rng = makeRng(hashSeed(fight.seed, 'tell', fight.round, fight.exchange));
  var shown = rng.chance(accuracy) ? fight.foePlan : CARD_ORDER.filter(function (id) { return id !== fight.foePlan; })[rng.int(CARD_ORDER.length - 1)];
  fight.tell = { text: tellLabel(shown), card: shown, accuracy: accuracy };
}
function startFight(game) {
  if (game.phase !== 'scout') throw new Error('camp first');
  var rng = makeRng(hashSeed(game.seed, 'fight'));
  var fight = {
    seed: game.seed, phase: 'fight', round: 1, exchange: 0, range: 'mid',
    rng: rng, shuffleRng: makeRng(hashSeed(game.seed, 'shuffle')),
    hitRng: makeRng(hashSeed(game.seed, 'hits')), knockdownRng: makeRng(hashSeed(game.seed, 'knockdowns')),
    judgeRng: makeRng(hashSeed(game.seed, 'judges')),
    player: makeSide(boxerById(game.playerBoxerId), game.mods.stat, game.mods.add),
    opponent: makeSide(boxerById(game.opponentBoxerId)),
    rounds: [], events: [], corner: null, result: null,
    scouting: game.scouting
  };
  fight.player.draw = fight.shuffleRng.shuffle(fight.player.deck.slice());
  fight.opponent.draw = fight.shuffleRng.shuffle(fight.opponent.deck.slice());
  refill(fight.player, fight.shuffleRng, 5);
  refill(fight.opponent, fight.shuffleRng, 5);
  refreshTell(fight);
  game.fight = fight;
  game.phase = 'fight';
  return fight;
}
function isOver(fight) { return fight.result !== null; }
function legalCards(fight, key) {
  var side = fight[key || 'player'], out = [];
  for (var i = 0; i < side.hand.length; i++) {
    var cost = cardCost(side, side.hand[i]);
    out.push({ id: side.hand[i], card: CARDS[side.hand[i]], cost: cost, affordable: side.stamina >= cost });
  }
  return out;
}

/* --- the AI -------------------------------------------------------------- */
function aiCampPick(game) {
  var prefs = CAMP_PREF[boxerById(game.playerBoxerId).style] || [];
  var offer = game.offers[game.week];
  for (var i = 0; i < prefs.length; i++) if (offer.indexOf(prefs[i]) >= 0) return prefs[i];
  return offer[0];
}
function aiCornerPick(game, key) {
  key = key || 'player';
  var fight = game.fight, side = fight[key];
  var offer = key === 'player' ? fight.corner : fight.foeCorner;
  function has(id) { return offer.indexOf(id) >= 0; }
  if (side.head >= 30 && has('ice_eye')) return 'ice_eye';
  if (side.stamina < side.maxStamina * 0.45 && has('breathe')) return 'breathe';
  if (key === 'player' && fight.scouting.known.length < fight.opponent.habits.length && has('study')) return 'study';
  if (has('gloves_high')) return 'gloves_high';
  if (has('change_plan')) return 'change_plan';
  return offer[0];
}
function applyCorner(fight, side, card, key) {
  if (card.healHead) side.head = Math.max(0, side.head - card.healHead);
  if (card.healBody) side.body = Math.max(0, side.body - card.healBody);
  if (card.stamina) side.stamina = clamp(side.stamina + card.stamina, 0, side.maxStamina);
  if (card.mod) for (var k in card.mod) {
    if (k === 'foe_first' && key !== 'player') side.mods.firstExchange = card.mod[k];
    else side.mods[k] = card.mod[k];
  }
  if (card.draw) refill(side, fight.shuffleRng, side.hand.length + card.draw);
  if (card.scout && key === 'player' && fight.scouting.known.length < fight.opponent.habits.length) revealHabit(fight);
}

/* --- one exchange -------------------------------------------------------- */
function checkStoppage(fight) {
  var sides = [['player', fight.player], ['opponent', fight.opponent]];
  for (var i = 0; i < sides.length; i++) {
    var side = sides[i][1];
    if (side.knockdowns >= 3) return { who: sides[i][0], why: 'three knockdowns' };
    if (side.head >= 53) return { who: sides[i][0], why: 'the damage is too much' };
    if (side.stamina <= 0 && side.head >= 32) return { who: sides[i][0], why: 'hurt and out of wind' };
  }
  return null;
}

/* --- rounds, the corner, the result -------------------------------------- */
function judgeRound(meStats, foeStats, av, bv) {
  if (Math.abs(av - bv) < 0.35) return [10, 10];
  var meWon = av > bv;
  var hi = meWon ? meStats : foeStats, lo = meWon ? foeStats : meStats;
  var big = hi.kd > 0 ||
    (lo.damage > 0 && hi.damage / lo.damage >= 2.2 && hi.landed >= lo.landed * 1.5) ||
    (lo.damage === 0 && hi.damage >= 12);
  return meWon ? [10, big ? 8 : 9] : [big ? 8 : 9, 10];
}
function scoreRound(fight, meStats, foeStats) {
  var out = [];
  for (var j = 0; j < JUDGES.length; j++) {
    var judge = JUDGES[j];
    var jitter = 1 + (fight.judgeRng.next() - 0.5) * judge.noise * 2;
    var av = (judge.landed * meStats.landed + judge.damage * meStats.damage + judge.aggression * meStats.thrown * 0.15) * jitter;
    var bv = (judge.landed * foeStats.landed + judge.damage * foeStats.damage + judge.aggression * foeStats.thrown * 0.15) / (jitter || 1);
    out.push(judgeRound(meStats, foeStats, av, bv));
  }
  return out;
}
function cornerOffer(fight, key) {
  var ids = makeRng(hashSeed(fight.seed, 'corner', fight.round, key))
    .shuffle(CORNER_CARDS.map(function (c) { return c.id; })).slice(0, 3);
  if ((key === 'opponent' || fight.scouting.known.length >= fight.opponent.habits.length) && ids.indexOf('study') >= 0) {
    ids[ids.indexOf('study')] = CORNER_CARDS.map(function (c) { return c.id; })
      .find(function (id) { return id !== 'study' && ids.indexOf(id) < 0; });
  }
  return ids;
}
function endRound(game) {
  var fight = game.fight;
  fight.rounds.push({
    round: fight.round,
    player: { thrown: fight.player.round.thrown, landed: fight.player.round.landed, damage: fight.player.round.damage, kd: fight.player.round.kd },
    opponent: { thrown: fight.opponent.round.thrown, landed: fight.opponent.round.landed, damage: fight.opponent.round.damage, kd: fight.opponent.round.kd },
    scores: scoreRound(fight, fight.player.round, fight.opponent.round),
    referee: { playerDeductions: fight.player.round.deductions, opponentDeductions: fight.opponent.round.deductions }
  });
  var recorded = fight.rounds[fight.rounds.length - 1];
  recorded.scores.forEach(function (score) {
    score[0] = Math.max(7, score[0] - recorded.referee.opponentDeductions);
    score[1] = Math.max(7, score[1] - recorded.referee.playerDeductions);
  });
  if (fight.round >= 3) { decision(fight); return; }
  fight.phase = 'corner';
  fight.corner = cornerOffer(fight, 'player');
  fight.foeCorner = cornerOffer(fight, 'opponent');
  fight.foeCornerPick = aiCornerPick(game, 'opponent');
  [fight.player, fight.opponent].forEach(function (side) {
    side.mods = {}; side.round = { thrown: 0, landed: 0, damage: 0, kd: 0, deductions: 0 }; side.clinchStreak = 0; side.opening = false;
  });
  fight.exchange = 0;
}
function revealHabit(fight) {
  var foe = boxerById(fight.opponent.boxerId);
  var known = fight.scouting.known.map(function (k) { return k.id; });
  for (var i = 0; i < foe.habits.length; i++) {
    if (known.indexOf(foe.habits[i]) < 0) {
      fight.scouting.known.push({ id: foe.habits[i], text: HABITS[foe.habits[i]].text });
      fight.scouting.fleeting = Math.max(0, fight.scouting.fleeting - 1);
      return true;
    }
  }
  return false;
}
function pickCorner(game, cardId) {
  var fight = game.fight;
  if (fight.phase !== 'corner') throw new Error('no corner now');
  if (fight.corner.indexOf(cardId) < 0) throw new Error('not offered: ' + cardId);
  var card = cornerById(cardId);
  applyCorner(fight, fight.player, card, 'player');
  var foeCardId = fight.foeCornerPick || aiCornerPick(game, 'opponent');
  applyCorner(fight, fight.opponent, cornerById(foeCardId), 'opponent');
  fight.cornerUsed = { player: cardId, opponent: foeCardId };
  [fight.player, fight.opponent].forEach(function (side) {
    side.stamina = clamp(side.stamina + 14 + Math.round(side.stats.stamina * 0.12), 0, side.maxStamina);
    side.body = Math.max(0, side.body - 6);
    refill(side, fight.shuffleRng, 5);
    side.lastTookClean = false; side.lastLandedClean = false; side.lastCard = null;
  });
  fight.corner = null;
  fight.round += 1;
  fight.exchange = 0;
  fight.phase = 'fight';
  fight.range = 'mid';
  refreshTell(fight);
  return game;
}
function finishEarly(fight, stop) {
  fight.result = {
    winner: stop.who === 'player' ? 'opponent' : 'player',
    method: 'stoppage', why: stop.why, round: fight.round, loser: stop.who,
    text: (stop.who === 'player' ? 'Your boxer is stopped' : 'The opponent is stopped') +
      ' in round ' + fight.round + ' (' + stop.why + ').',
    scorecards: null, margin: null
  };
  fight.phase = 'over';
  return fight.result;
}
function decision(fight) {
  var totals = JUDGES.map(function (j, i) {
    var me = 0, foe = 0;
    fight.rounds.forEach(function (r) { me += r.scores[i][0]; foe += r.scores[i][1]; });
    return { judge: j.name, player: me, opponent: foe };
  });
  var meCards = totals.filter(function (t) { return t.player > t.opponent; }).length;
  var foeCards = totals.filter(function (t) { return t.opponent > t.player; }).length;
  var winner = meCards > foeCards ? 'player' : foeCards > meCards ? 'opponent' : 'draw';
  var line = totals.map(function (t) { return t.player + '-' + t.opponent; }).join(', ');
  fight.result = {
    winner: winner, method: 'decision', round: 3, scorecards: totals, margin: Math.abs(meCards - foeCards),
    text: (winner === 'player' ? 'Your boxer wins on points.' : winner === 'opponent' ?
      'The opponent wins on points.' : 'A draw.') + ' (' + line + ' on the three cards.)'
  };
  fight.phase = 'over';
  return fight.result;
}

/* --- a whole AI-vs-AI bout, used by balance.mjs -------------------------- */
/* A camp run for a boxer the player is not controlling, so a harness can have
   both corners prepared and measure style against style, not camp against camp. */
function campModsFor(boxerId, seed) {
  var g = createGame({ seed: hashSeed(seed, 'foeCamp', boxerId), playerBoxerId: boxerId });
  while (g.phase === 'camp') pickCampCard(g, aiCampPick(g));
  return g.mods;
}
function applyCampTo(side, mods) {
  var k;
  for (k in mods.stat) side.stats[k] = clamp(side.stats[k] + mods.stat[k], 1, 99);
  var was = side.maxStamina;
  side.maxStamina = maxStamina(side.stats);
  side.stamina = clamp(side.stamina + (side.maxStamina - was), 0, side.maxStamina);
  for (k in mods.add) {
    for (var i = 0; i < mods.add[k]; i++) { side.deck.push(k); side.draw.push(k); }
  }
}
function simulateAiBout(opts) {
  var game = createGame(opts);
  while (game.phase === 'camp') pickCampCard(game, aiCampPick(game));
  var fight = startFight(game);
  if (opts.opponentCamp) applyCampTo(fight.opponent, campModsFor(game.opponentBoxerId, game.seed));
  while (!isOver(fight)) {
    if (fight.phase === 'corner') { pickCorner(game, aiCornerPick(game)); continue; }
    var card = chooseAiCard(fight, 'player');
    if (!card) throw new Error('no legal card for ' + fight.player.name);
    playExchange(game, card);
  }
  return { game: game, fight: fight };
}

return {
  makeRng: makeRng, hashSeed: hashSeed, clamp: clamp,
  KIND_LABEL: KIND_LABEL, CARD_ORDER: CARD_ORDER, CARDS: CARDS,
  MATRIX_COLS: MATRIX_COLS, MATRIX_ROWS: MATRIX_ROWS, FLIP: FLIP, RESOLUTION: RESOLUTION,
  CODE_FACTOR: CODE_FACTOR, STYLES: STYLES, HABITS: HABITS, CAMP_CARDS: CAMP_CARDS,
  CORNER_CARDS: CORNER_CARDS, BOXERS: BOXERS, JUDGES: JUDGES,
  createGame: createGame, campOffers: campOffers, pickCampCard: pickCampCard,
  scoutReport: scoutReport, startFight: startFight, legalCards: legalCards,
  cardCost: cardCost, playExchange: playExchange, pickCorner: pickCorner,
  chooseAiCard: chooseAiCard, contextOf: contextOf, habitCard: habitCard, scoutingPrediction: scoutingPrediction, predictedCard: predictedCard, refreshTell: refreshTell,
  habitChanceInHand: habitChanceInHand, aiCampPick: aiCampPick,
  aiCornerPick: aiCornerPick, isOver: isOver, judgeRound: judgeRound,
  campModsFor: campModsFor, applyCampTo: applyCampTo,
  scoreRound: scoreRound, simulateAiBout: simulateAiBout, boxerById: boxerById,
  checkStoppage: checkStoppage, rangeAfter: rangeAfter, resolutionAt: resolutionAt, expectedSwing: expectedSwing,
  maxStamina: maxStamina, isHurt: isHurt, knock: knockdownChance
};
});
