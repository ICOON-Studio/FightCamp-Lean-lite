/* ============================================================================
   FightCamp card game - prototype rules (boxing only)
   A PURE module: no DOM, no I/O, no Date, no Math.random, no shared state.
   Pass a seed and the same bout plays out the same way, exchange by exchange.
   ========================================================================== */
(function (root, factory) {
  var data = typeof module === 'object' && module.exports ? require('./rules-data.js') : root.FightCampData;
  var exchange = typeof module === 'object' && module.exports ? require('./rules-exchange.js') : root.FightCampExchange;
  var ai = typeof module === 'object' && module.exports ? require('./rules-ai.js') : root.FightCampAI;
  var tell = typeof module === 'object' && module.exports ? require('./rules-tell.js') : root.FightCampTell;
  var judge = typeof module === 'object' && module.exports ? require('./rules-judge.js') : root.FightCampJudge;
  var camp = typeof module === 'object' && module.exports ? require('./rules-camp.js') : root.FightCampCamp;
  var api = factory(data, ai, exchange, tell, judge, camp);
  if (typeof module === 'object' && module.exports) module.exports = api;
  if (typeof window !== 'undefined') window.FightCampRules = api;
})(typeof globalThis !== 'undefined' ? globalThis : this, function (DATA, AiModule, ExchangeModule, TellModule, JudgeModule, CampModule) {
'use strict';
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
var REASONS = DATA.REASONS;
var Camp = CampModule({ CARDS: CARDS, CAMP_CARDS: CAMP_CARDS, CAMP_PREF: CAMP_PREF, DRILL_VALUE: DATA.DRILL_VALUE,
  makeRng: makeRng, hashSeed: hashSeed, boxerById: boxerById, cardById: cardById });
var campOffers = Camp.campOffers, deckWithMods = Camp.deckWithMods, removalsFor = Camp.removalsFor;
var aiCampPick = Camp.aiCampPick, aiCampRemove = Camp.aiCampRemove;
/* A camp week ends in the scouting file, which needs the roster: keep that step here. */
function pickCampCard(game, cardId, removeIds) {
  Camp.pickCampCard(game, cardId, removeIds);
  if (game.phase === 'camp' && game.week >= 4) { game.phase = 'scout'; game.scouting = scoutReport(game); }
  return game;
}
function boxerById(id) { for (var i = 0; i < BOXERS.length; i++) if (BOXERS[i].id === id) return BOXERS[i]; return null; }
function cardById(id) { for (var i = 0; i < CAMP_CARDS.length; i++) if (CAMP_CARDS[i].id === id) return CAMP_CARDS[i]; return null; }
function cornerById(id) { for (var i = 0; i < CORNER_CARDS.length; i++) if (CORNER_CARDS[i].id === id) return CORNER_CARDS[i]; return null; }
function maxStamina(stats) { return Math.round(86 + stats.stamina * 0.5); }
function cardCost(side, cardId) {
  var cost = CARDS[cardId].cost * (1.26 - side.stats.stamina / 400);
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
var habitCard = AI.habitCard, chooseAiCard = AI.chooseAiCard, chooseStyleCard = AI.chooseStyleCard;
var Tell = TellModule({ CARDS: CARDS, SHAPES: DATA.SHAPES, SHAPE_LABEL: DATA.SHAPE_LABEL, SHAPE_OPPOSITE: DATA.SHAPE_OPPOSITE, makeRng: makeRng, hashSeed: hashSeed, chooseAiCard: chooseAiCard });
var tellLabel = Tell.tellLabel, refreshTell = Tell.refreshTell, payForTell = Tell.payForTell, tellVisible = Tell.tellVisible;
var Judge = JudgeModule({ JUDGES: JUDGES });
var judgeRound = Judge.judgeRound, scoreRound = Judge.scoreRound, decision = Judge.decision;
var Exchange = ExchangeModule({ CARDS: CARDS, CODE_FACTOR: CODE_FACTOR, FLIP: FLIP, RESOLUTION: RESOLUTION, REASONS: REASONS,
  makeRng: makeRng, hashSeed: hashSeed, clamp: clamp, cardCost: cardCost, chooseAiCard: chooseAiCard, predictedCard: predictedCard,
  refreshTell: refreshTell, refill: refill, isHurt: isHurt,
  checkStoppage: function (f) { return checkStoppage(f); },
  finishEarly: function (f, stop) { return finishEarly(f, stop); },
  endRound: function (g) { return endRound(g); } });
var rangeAfter = Exchange.rangeAfter;
var exchangeLine = Exchange.exchangeLine, exchangeReason = Exchange.reasonFor;
var legalNow = Exchange.legalNow, costNow = Exchange.costNow, repeatsNonPunch = Exchange.repeatsNonPunch;
var knockdownChance = Exchange.knockdownChance;
var resolutionAt = Exchange.resolutionAt;
var playExchange = Exchange.playExchange;
function createGame(opts) {
  opts = opts || {};
  var seed = (opts.seed === undefined ? 1 : opts.seed) >>> 0;
  var playerBoxerId = opts.playerBoxerId || 'ada';
  var opponentBoxerId = opts.opponentBoxerId;
  var player = boxerById(playerBoxerId);
  if (!player) throw new Error('unknown player boxer');
  if (!opponentBoxerId) {
    var pool = BOXERS.filter(function (b) { return b.id !== playerBoxerId && b.pronoun === player.pronoun && b.club !== player.club && b.id !== opts.lastOpponentId; });
    if (!pool.length) pool = BOXERS.filter(function (b) { return b.id !== playerBoxerId && b.pronoun === player.pronoun && b.club !== player.club; });
    opponentBoxerId = pool[hashSeed(seed, 'foe') % pool.length].id;
  }
  var opponent = boxerById(opponentBoxerId);
  if (!opponent || opponent.id === playerBoxerId) throw new Error('choose a different opponent');
  if (opponent.pronoun !== player.pronoun) throw new Error('boxing bouts must be between same-sex boxers');
  if (opponent.club === player.club) throw new Error('opponents come from other clubs');
  return {
    seed: seed, phase: 'camp', week: 0,
    playerBoxerId: playerBoxerId, opponentBoxerId: opponentBoxerId,
    offers: campOffers(seed), picks: [],
    mods: { stat: {}, add: {}, remove: {}, scout: 0 },
    scouting: null, fight: null
  };
}
function statLine(boxer, mods) {
  var out = {};
  for (var k in boxer.stats) out[k] = clamp(boxer.stats[k] + ((mods && mods.stat && mods.stat[k]) || 0), 1, 99);
  return out;
}
function opponentCamp(boxerId, seed) {
  var g = createGame({ seed: hashSeed(seed, 'foeCamp', boxerId), playerBoxerId: boxerId });
  g._foeCamp = true;
  while (g.phase === 'camp') pickCampCard(g, aiCampPick(g), aiCampRemove(g, aiCampPick(g)));
  return { mods: g.mods, picks: g.picks.slice() };
}
function scoutReport(game) {
  var foe = boxerById(game.opponentBoxerId);
  var rng = makeRng(hashSeed(game.seed, 'scout', foe.id));
  var n = clamp(rng.int(3) + game.mods.scout, 0, foe.habits.length);
  var seen = rng.shuffle(foe.habits.slice()).slice(0, n);
  var camp = game._foeCamp ? { mods: { stat: {}, add: {}, remove: {} }, picks: [] } : opponentCamp(foe.id, game.seed);
  return {
    boxerId: foe.id, name: foe.name, style: foe.style, styleName: STYLES[foe.style].name,
    stats: statLine(foe, camp.mods), blurb: foe.blurb, club: foe.club,
    camp: camp.picks.map(function (id) { var c = cardById(id); return c ? c.name : id; }),
    known: seen.map(function (id) { return { id: id, text: HABITS[id].text }; }),
    fleeting: foe.habits.length - n,
    summary: n === 0 ? 'Nothing on film. You fight cold.' :
      n === 1 ? 'One thing on film, and you have to judge it.' : 'Two things on film. Enough to build a plan.'
  };
}
function makeSide(boxer, statMods, addMods, removeMods) {
  var stats = statLine(boxer, { stat: statMods || {} });
  var deck = boxer.deck.slice();
  for (var k in (addMods || {})) for (var i = 0; i < addMods[k]; i++) deck.push(k);
  for (var r in (removeMods || {})) for (var j = 0; j < removeMods[r]; j++) {
    var idx = deck.indexOf(r); if (idx >= 0) deck.splice(idx, 1);
  }
  boxer.habits.forEach(function (habitId) {
    var signature = HABITS[habitId].play;
    while (deck.filter(function (id) { return id === signature; }).length < 3) deck.push(signature);
  });
  while (deck.length > 16) {
    var sigs = boxer.habits.map(function (h) { return HABITS[h].play; });
    function val(id) { var c = CARDS[id]; return (c.dmg ? c.dmg.head + c.dmg.body : 0) + (c.counter ? (c.counter.head + c.counter.body) * 0.5 : 0); }
    var idx = -1, best = Infinity;
    for (var i = 0; i < deck.length; i++) {
      if (sigs.indexOf(deck[i]) >= 0 && deck.filter(function (x) { return x === deck[i]; }).length <= 3) continue;
      if (val(deck[i]) < best) { best = val(deck[i]); idx = i; }
    }
    if (idx < 0) idx = deck.length - 1;
    deck.splice(idx, 1);
  }
  return {
    boxerId: boxer.id, name: boxer.name, pronoun: boxer.pronoun, poss: boxer.poss, club: boxer.club,
    style: boxer.style, styleName: STYLES[boxer.style].name, stats: stats, deck: deck,
    draw: [], hand: [], discard: [],
    maxStamina: maxStamina(stats), stamina: maxStamina(stats),
    head: 0, body: 0, knockdowns: 0,
    totals: { thrown: 0, landed: 0, damage: 0, defence: 0, defencePoints: 0 },
    round: { thrown: 0, landed: 0, damage: 0, kd: 0, deductions: 0, defence: 0, defencePoints: 0 },
    lastCard: null, lastTookClean: false, lastLandedClean: false, combo: false, opening: false, feint: false, clinchStreak: 0, catchUsed: false,
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
function startFight(game) {
  if (game.phase !== 'scout') throw new Error('camp first');
  var rng = makeRng(hashSeed(game.seed, 'fight'));
  var foeMods = opponentCamp(game.opponentBoxerId, game.seed).mods;
  var fight = {
    seed: game.seed, phase: 'fight', round: 1, exchange: 0, range: 'mid', ropes: false, cutOffStreak: 0, cutOffBy: null, trap: null, reactGuard: 0.9,
    rng: rng, shuffleRng: makeRng(hashSeed(game.seed, 'shuffle')),
    hitRng: makeRng(hashSeed(game.seed, 'hits')), knockdownRng: makeRng(hashSeed(game.seed, 'knockdowns')),
    judgeRng: makeRng(hashSeed(game.seed, 'judges')),
    player: makeSide(boxerById(game.playerBoxerId), game.mods.stat, game.mods.add, game.mods.remove),
    opponent: makeSide(boxerById(game.opponentBoxerId), foeMods.stat, foeMods.add, foeMods.remove),
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
  key = key || 'player';
  var side = fight[key], out = [];
  for (var i = 0; i < side.hand.length; i++) {
    var id = side.hand[i];
    var cost = costNow(side, fight, key, id);
    var legal = legalNow(side, fight, key, id);
    out.push({ id: id, card: CARDS[id], cost: cost, affordable: side.stamina >= cost && legal, legal: legal });
  }
  return out;
}
function aiCornerPick(game, key) {
  key = key || 'player';
  var fight = game.fight, side = fight[key];
  var offer = key === 'player' ? fight.corner : fight.foeCorner;
  function has(id) { return offer.indexOf(id) >= 0; }
  var scores = {};
  offer.forEach(function (id) { scores[id] = 0; });
  if (has('ice_eye')) scores.ice_eye = side.head >= 30 ? 5 : side.head >= 15 ? 2 : 0.5;
  if (has('breathe')) scores.breathe = side.stamina < side.maxStamina * 0.45 ? 5 : side.stamina < side.maxStamina * 0.7 ? 2 : 0.5;
  if (has('gloves_high')) {
    var blocks = side.deck.filter(function (id) { return id === 'block'; }).length;
    scores.gloves_high = blocks >= 2 ? 3 : 1;
  }
  /* Two extra looks cost six wind, so only a corner that can afford it wants them. */
  if (has('change_plan')) scores.change_plan = side.stamina >= 10 && side.hand.length <= 3 ? 2.2 : 0.3;
  if (has('stool')) scores.stool = side.body >= 25 ? 4 : side.stamina < side.maxStamina * 0.5 ? 2.5 : 0.8;
  if (has('study')) scores.study = key === 'player' && fight.scouting.known.length < fight.opponent.habits.length ? 3 : 0.2;
  var best = offer[0], bestScore = -Infinity;
  offer.forEach(function (id) { if (scores[id] > bestScore) { bestScore = scores[id]; best = id; } });
  return best;
}
function applyCorner(fight, side, card, key) {
  if (card.healHead) side.head = Math.max(0, side.head - card.healHead);
  if (card.healBody) side.body = Math.max(0, side.body - card.healBody);
  if (card.stamina) side.stamina = clamp(side.stamina + card.stamina, 0, side.maxStamina);
  if (card.mod) for (var k in card.mod) side.mods[k] = card.mod[k];
  if (card.draw) refill(side, fight.shuffleRng, side.hand.length + card.draw);
  if (card.foeDraw) {
    var other = fight[otherKey(key)];
    refill(other, fight.shuffleRng, other.hand.length + card.foeDraw);
  }
  if (card.scout && key === 'player' && fight.scouting.known.length < fight.opponent.habits.length) revealHabit(fight);
}
function checkStoppage(fight) {
  var sides = [['player', fight.player], ['opponent', fight.opponent]];
  for (var i = 0; i < sides.length; i++) {
    var side = sides[i][1];
    if (side.knockdowns >= 3) return { who: sides[i][0], why: 'three knockdowns' };
    if (side.head >= 78) return { who: sides[i][0], why: 'the damage is too much' };
    if (side.stamina <= 0 && side.head >= 58) return { who: sides[i][0], why: 'hurt and out of wind' };
  }
  return null;
}
function cornerOffer(fight, key) {
  var side = fight[key];
  var ids = [];
  function want(id) { if (ids.indexOf(id) < 0 && ids.length < 3) ids.push(id); }
  if (side.head >= 30) want('ice_eye');
  if (side.stamina < side.maxStamina * 0.5) want('breathe');
  if (side.body >= 25) want('stool');
  var pool = makeRng(hashSeed(fight.seed, 'corner', fight.round, key)).shuffle(CORNER_CARDS.map(function (c) { return c.id; }));
  pool.forEach(function (id) { want(id); });
  ids = ids.slice(0, 3);
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
    player: { thrown: fight.player.round.thrown, landed: fight.player.round.landed, damage: fight.player.round.damage, kd: fight.player.round.kd, defence: fight.player.round.defence, defencePoints: fight.player.round.defencePoints },
    opponent: { thrown: fight.opponent.round.thrown, landed: fight.opponent.round.landed, damage: fight.opponent.round.damage, kd: fight.opponent.round.kd, defence: fight.opponent.round.defence, defencePoints: fight.opponent.round.defencePoints },
    scores: scoreRound(fight, fight.player.round, fight.opponent.round),
    referee: { playerDeductions: fight.player.round.deductions, opponentDeductions: fight.opponent.round.deductions }
  });
  var recorded = fight.rounds[fight.rounds.length - 1];
  recorded.scores.forEach(function (score) {
    score[0] = Math.max(7, score[0] - recorded.referee.playerDeductions);
    score[1] = Math.max(7, score[1] - recorded.referee.opponentDeductions);
  });
  if (fight.round >= 3) { decision(fight); return; }
  fight.phase = 'corner';
  fight.corner = cornerOffer(fight, 'player');
  fight.foeCorner = cornerOffer(fight, 'opponent');
  fight.foeCornerPick = aiCornerPick(game, 'opponent');
  [fight.player, fight.opponent].forEach(function (side) {
    side.mods = {}; side.round = { thrown: 0, landed: 0, damage: 0, kd: 0, deductions: 0, defence: 0, defencePoints: 0 }; side.clinchStreak = 0; side.opening = false; side.feint = false; side.catchUsed = false;
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
    side.stamina = clamp(side.stamina + 8, 0, side.maxStamina);
    side.body = Math.max(0, side.body - 6);
    refill(side, fight.shuffleRng, 5);
    side.lastTookClean = false; side.lastLandedClean = false; side.lastCard = null;
  });
  /* Change the plan is a real corner: two extra looks cost six wind each. */
  if (cardId === 'change_plan') fight.player.stamina = Math.max(0, fight.player.stamina - 6);
  if (foeCardId === 'change_plan') fight.opponent.stamina = Math.max(0, fight.opponent.stamina - 6);
  fight.corner = null;
  fight.round += 1;
  fight.exchange = 0;
  fight.phase = 'fight';
  fight.range = 'mid';
  fight.ropes = false;
  fight.cutOffStreak = 0;
  fight.cutOffBy = null;
  fight.trap = null;
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
function campModsFor(boxerId, seed) {
  return opponentCamp(boxerId, seed).mods;
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
  for (k in (mods.remove || {})) {
    for (var j = 0; j < mods.remove[k]; j++) {
      var di = side.deck.indexOf(k); if (di >= 0) side.deck.splice(di, 1);
      var wi = side.draw.indexOf(k); if (wi >= 0) side.draw.splice(wi, 1);
    }
  }
}
function simulateAiBout(opts) {
  var game = createGame(opts);
  while (game.phase === 'camp') pickCampCard(game, aiCampPick(game), aiCampRemove(game, aiCampPick(game)));
  var fight = startFight(game);
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
  SHAPES: DATA.SHAPES, SHAPE_MATRIX: DATA.SHAPE_MATRIX, EXCEPTIONS: DATA.EXCEPTIONS, REASONS: DATA.REASONS,
  SHAPE_OPPOSITE: DATA.SHAPE_OPPOSITE, SHAPE_LABEL: DATA.SHAPE_LABEL,
  createGame: createGame, campOffers: campOffers, pickCampCard: pickCampCard,
  scoutReport: scoutReport, startFight: startFight, legalCards: legalCards,
  cardCost: cardCost, playExchange: playExchange, pickCorner: pickCorner,
  chooseAiCard: chooseAiCard, chooseStyleCard: chooseStyleCard, contextOf: contextOf, habitCard: habitCard, scoutingPrediction: scoutingPrediction, predictedCard: predictedCard, refreshTell: refreshTell, payForTell: payForTell, tellVisible: tellVisible,
  habitChanceInHand: habitChanceInHand, aiCampPick: aiCampPick, aiCampRemove: aiCampRemove, removalsFor: removalsFor,
  aiCornerPick: aiCornerPick, isOver: isOver, judgeRound: judgeRound,
  campModsFor: campModsFor, opponentCamp: opponentCamp, applyCampTo: applyCampTo,
  scoreRound: scoreRound, simulateAiBout: simulateAiBout, boxerById: boxerById,
  checkStoppage: checkStoppage, rangeAfter: rangeAfter, resolutionAt: resolutionAt, expectedSwing: expectedSwing,
  legalNow: legalNow, costNow: costNow, repeatsNonPunch: repeatsNonPunch,
  exchangeLine: exchangeLine, exchangeReason: exchangeReason,
  maxStamina: maxStamina, isHurt: isHurt, knock: knockdownChance, tellLabel: tellLabel };
});
