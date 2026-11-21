/* Public-information tactical chooser and scouting estimates. */
(function (root, factory) {
  if (typeof module === 'object' && module.exports) module.exports = factory;
  if (typeof window !== 'undefined') window.FightCampAI = factory;
})(typeof globalThis !== 'undefined' ? globalThis : this, function (d) {
'use strict';
var STYLES = d.STYLES;
var CARDS = d.CARDS;
var HABITS = d.HABITS;
var CARD_ORDER = d.CARD_ORDER;
var CODE_FACTOR = d.CODE_FACTOR;
var RESOLUTION = d.RESOLUTION;
var SITUATION_RULES = d.SITUATION_RULES;
var isHurt = d.isHurt;
var totalDamage = d.totalDamage;
var otherKey = d.otherKey;
var makeRng = d.makeRng;
var hashSeed = d.hashSeed;
var clamp = d.clamp;
var cardCost = d.cardCost;
function contextOf(fight, key) {
  var me = fight[key], foe = fight[otherKey(key)];
  var lastOpp = foe.lastCard ? CARDS[foe.lastCard] : null;
  return {
    exchange: fight.exchange, round: fight.round, range: fight.range, inFightRange: fight.range,
    lastSelfCard: me.lastCard, lastOppCard: foe.lastCard,
    lastOppStraight: !!(lastOpp && lastOpp.tags.indexOf('straight') >= 0),
    lastOppHook: !!(lastOpp && lastOpp.tags.indexOf('hook') >= 0),
    lastTookClean: me.lastTookClean, lastLandedClean: me.lastLandedClean,
    selfHurt: isHurt(me), foeHurt: isHurt(foe),
    selfLowStamina: me.stamina < me.maxStamina * 0.5,
    foeLowStamina: foe.stamina < foe.maxStamina * 0.5,
    selfAhead: me.totals.damage > foe.totals.damage + 6,
    gassed: me.stamina < 5, combo: !!me.combo
  };
}
function whenMatches(when, ctx) {
  for (var k in when) { if (ctx[k] !== when[k]) return false; }
  return true;
}
function habitChanceInHand(side, cardId, handSize) {
  var copies = side.deck.filter(function (id) { return id === cardId; }).length;
  var unseen = side.deck.length;
  var n = Math.min(handSize || 5, unseen);
  if (!unseen || !copies || !n) return 0;
  var miss = 1;
  for (var i = 0; i < n; i++) {
    if (i >= unseen - copies) return 1;
    miss *= (unseen - copies - i) / (unseen - i);
  }
  return 1 - miss;
}
function scoutingPrediction(fight) {
  var ctx = contextOf(fight, 'opponent'), side = fight.opponent;
  return fight.scouting.known.map(function (entry) {
    var habit = HABITS[entry.id];
    return { id: entry.id, text: entry.text, condition: habit.when, card: habit.play,
      cardName: CARDS[habit.play].name, active: whenMatches(habit.when, ctx),
      chance: habitChanceInHand(side, habit.play, 5) };
  });
}
function predictedCard(fight) {
  var active = scoutingPrediction(fight).filter(function (read) { return read.active; });
  if (active.length) return active.sort(function (a, b) { return b.chance - a.chance; })[0].card;
  var weights = STYLES[fight.opponent.style].weights, best = CARD_ORDER[0];
  CARD_ORDER.forEach(function (id) { if (weights[id] > weights[best]) best = id; });
  return best;
}
function cardBaseValue(card) { if (card.kind !== 'punch') return 0; var b = card.dmg || { head: 0, body: 0 }; return b.head + b.body; }
function expectedSwing(cardId, foeWeights) {
  var mine = 0, wsum = 0, cv = cardBaseValue(CARDS[cardId]);
  for (var i = 0; i < CARD_ORDER.length; i++) {
    var oid = CARD_ORDER[i], w = foeWeights[oid] || 0;
    if (w <= 0) continue;
    wsum += w;
    mine += w * (CODE_FACTOR[RESOLUTION[cardId][oid]] * cv -
      CODE_FACTOR[RESOLUTION[oid][cardId]] * cardBaseValue(CARDS[oid]) * 0.9);
  }
  return wsum ? mine / wsum : 0;
}
function habitCard(side, ctx, rng) {
  for (var i = 0; i < side.habits.length; i++) {
    var h = HABITS[side.habits[i]];
    if (!h || !whenMatches(h.when, ctx)) continue;
    if (side.hand.indexOf(h.play) >= 0 && rng.chance(0.7)) return h.play;
  }
  return null;
}
function chooseAiCard(fight, key) {
  var side = fight[key], ctx = contextOf(fight, key), style = STYLES[side.style];
  var rng = makeRng(hashSeed(fight.seed, 'ai', key, fight.round, fight.exchange));
  var habitRng = makeRng(hashSeed(fight.seed, 'habit', key, fight.round, fight.exchange));
  var habit = habitCard(side, ctx, habitRng);
  if (habit) return habit;
  var foeWeights = Object.assign({}, STYLES[fight[otherKey(key)].style].weights);
  if (key === 'player') {
    /* Film changes the estimate, not certainty: deck composition + five-card hand odds only. */
    scoutingPrediction(fight).forEach(function (read) {
      if (!read.active || !read.chance) return;
      var certainty = read.chance;
      Object.keys(foeWeights).forEach(function (id) { foeWeights[id] *= 1 - 0.7 * certainty; });
      foeWeights[read.card] = (foeWeights[read.card] || 1) * (1 - certainty) + 12 * certainty;
    });
  }
  if (key === 'opponent') {
    var recent = fight.events.slice(-3).map(function (ev) { return ev.player.card; });
    var counts = {};
    recent.forEach(function (id) { counts[id] = (counts[id] || 0) + 1; });
    Object.keys(counts).forEach(function (id) {
      var counter = CARD_ORDER.filter(function (candidate) {
        return ['W', 'w'].indexOf(RESOLUTION[candidate][id]) >= 0;
      });
      counter.forEach(function (candidate) {
        foeWeights[candidate] = (foeWeights[candidate] || 1) * (counts[id] >= 2 ? 2 : 1.25);
      });
    });
  }
  var best = null, bestScore = -Infinity;
  for (var i = 0; i < side.hand.length; i++) {
    var id = side.hand[i], card = CARDS[id];
    var s;
    if (key === 'player') {
      var inRange = card.ranges && card.ranges.indexOf(fight.range) >= 0;
      var affordable = side.stamina >= cardCost(side, id);
      s = expectedSwing(id, foeWeights) * (inRange ? 1 : 0.62) * (affordable ? 1 : 0.6)
        + 0.015 * cardBaseValue(card);
    } else {
      s = (style.weights[id] || 1) * clamp(0.62 + expectedSwing(id, foeWeights) / 10, 0.1, 2.4);
      if (!card.ranges || card.ranges.indexOf(fight.range) < 0) s *= 0.6;
      for (var r = 0; r < SITUATION_RULES.length; r++) {
        var rule = SITUATION_RULES[r];
        if (rule.cards.indexOf(id) >= 0 && whenMatches(rule.when, ctx)) s *= rule.mul;
      }
      if (side.stamina < cardCost(side, id)) s *= 0.55;
      s *= 0.85 + rng.next() * 0.3;
    }
    if (s > bestScore) { bestScore = s; best = id; }
  }
  return best;
}

return { contextOf: contextOf, whenMatches: whenMatches, habitChanceInHand: habitChanceInHand,
  scoutingPrediction: scoutingPrediction, predictedCard: predictedCard, expectedSwing: expectedSwing,
  habitCard: habitCard, chooseAiCard: chooseAiCard };
});
