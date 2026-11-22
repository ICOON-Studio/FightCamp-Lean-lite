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
    gassed: me.stamina < 5, combo: !!me.combo,
    ropes: fight.range === 'ropes', catchUsed: !!me.catchUsed
  };
}
function whenMatches(when, ctx) {
  for (var k in when) { if (ctx[k] !== when[k]) return false; }
  return true;
}
function unseenPool(side) {
  /* Cards not yet discarded: the full deck minus the public discard pile. */
  var pool = side.deck.slice();
  side.discard.forEach(function (id) {
    var idx = pool.indexOf(id);
    if (idx >= 0) pool.splice(idx, 1);
  });
  return pool;
}
function habitChanceInHand(side, cardId, handSize) {
  var unseen = unseenPool(side);
  var copies = unseen.filter(function (id) { return id === cardId; }).length;
  var n = Math.min(handSize || 5, unseen.length);
  if (!unseen.length || !copies || !n) return 0;
  var miss = 1;
  for (var i = 0; i < n; i++) {
    if (i >= unseen.length - copies) return 1;
    miss *= (unseen.length - copies - i) / (unseen.length - i);
  }
  return 1 - miss;
}
function habitChanceAtBell(side, cardId, handSize) {
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
      chance: habitChanceInHand(side, habit.play, 5),
      chanceAtBell: habitChanceAtBell(side, habit.play, 5) };
  });
}
function predictedCard(fight) {
  var active = scoutingPrediction(fight).filter(function (read) { return read.active; });
  /* The read is the tell first (a shape, ~60% reliable) and the film second.
     Round 3b: it used to ignore the tell entirely, so a prediction could never
     get better with a better tell. */
  /* An active file is a named card and beats a 60% shape guess; the chip is
     what you fall back on when no habit is live. */
  var certain = active.slice().sort(function (a, b) { return b.chance - a.chance; })[0];
  if (certain) return certain.card;
  var told = (fight.exchange === 0 || !!fight.tellPaid) && fight.tell ? fight.tell.shape : null;
  if (told) {
    var weights = STYLES[fight.opponent.style].weights, best = null, bestW = -1;
    CARD_ORDER.forEach(function (id) {
      if (CARDS[id].shape !== told) return;
      var w = (weights[id] || 0.5) * (CARDS[id].kind === 'punch' ? 1.2 : 1);
      active.forEach(function (read) { if (read.card === id) w += (read.chance || 0) * 2; });
      if (w > bestW) { bestW = w; best = id; }
    });
    if (best) return best;
  }
  if (active.length) return active.sort(function (a, b) { return b.chance - a.chance; })[0].card;
  var fallback = STYLES[fight.opponent.style].weights, pick = CARD_ORDER[0];
  CARD_ORDER.forEach(function (id) { if (fallback[id] > fallback[pick]) pick = id; });
  return pick;
}
function cardBaseValue(card) {
  if (card.kind === 'punch') { var b = card.dmg || { head: 0, body: 0 }; return b.head + b.body; }
  var c = card.counter || { head: 0, body: 0 }; return (c.head + c.body) * 0.5;
}
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
    if (h.play === 'step_back' && ctx.ropes) continue;
    if (h.play === 'catch_breath' && ctx.catchUsed) continue;
    if (side.hand.indexOf(h.play) >= 0 && rng.chance(0.7)) return h.play;
  }
  return null;
}
/* Legality mirrors the exchange engine: no repeat non-punch, no catch breath
   twice, no step back on the ropes, and a trapped man pays for his escape. */
function aiLegal(side, fight, key, id) {
  if (id === 'catch_breath' && side.catchUsed) return false;
  if (fight.ropes && id === 'step_back') return false;
  if (id !== 'clinch' && CARDS[id].kind !== 'punch' && side.lastCard &&
      CARDS[side.lastCard].kind !== 'punch' &&
      side.hand.some(function (x) { return CARDS[x].kind === 'punch'; })) return false;
  return true;
}
function aiCost(side, fight, key, id) {
  var cost = cardCost(side, id) + ((CARDS[id].ranges && CARDS[id].ranges.indexOf(fight.range) >= 0) ? 0 : 1);
  var trapped = fight.trap && fight.trap.who === key;
  if (trapped && (id === 'step_back' || id === 'pivot_out')) cost += 1;
  return cost;
}
/* The honest baseline: style weights, the range, and nothing else. No tell, no
   film, no read of what the other man just threw. Both seats can use it, so a
   style matchup measured with it is symmetric. */
function chooseStyleCard(fight, key) {
  var side = fight[key], style = STYLES[side.style];
  var best = null, bestScore = -Infinity;
  for (var i = 0; i < side.hand.length; i++) {
    var id = side.hand[i];
    if (!aiLegal(side, fight, key, id)) continue;
    var s = style.weights[id] || 1;
    if (!CARDS[id].ranges || CARDS[id].ranges.indexOf(fight.range) < 0) s *= 0.72;
    if (side.stamina < aiCost(side, fight, key, id)) s *= 0.55;
    if (s > bestScore) { bestScore = s; best = id; }
  }
  if (!best) for (var j = 0; j < side.hand.length; j++) if (aiLegal(side, fight, key, side.hand[j])) return side.hand[j];
  return best;
}
function chooseAiCard(fight, key, publicOnly) {
  var side = fight[key], ctx = contextOf(fight, key), style = STYLES[side.style];
  var rng = makeRng(hashSeed(fight.seed, 'ai', key, fight.round, fight.exchange));
  var habitRng = makeRng(hashSeed(fight.seed, 'habit', key, fight.round, fight.exchange));
  var habit = habitCard(side, ctx, habitRng);
  if (habit && aiLegal(side, fight, key, habit)) return habit;
  var foeWeights = Object.assign({}, STYLES[fight[otherKey(key)].style].weights);
  if (key === 'player' && !publicOnly) {
    /* The file is a belief, not a swap: mix the general read with the habit's
       own card, weighted by how likely that card is to be in the hand. */
    var totalWeight = 0;
    Object.keys(foeWeights).forEach(function (id) { totalWeight += foeWeights[id]; });
    scoutingPrediction(fight).forEach(function (read) {
      if (!read.active || !read.chance) return;
      var certainty = read.chance;
      Object.keys(foeWeights).forEach(function (id) { foeWeights[id] *= 1 - certainty; });
      foeWeights[read.card] = (foeWeights[read.card] || 0) + certainty * totalWeight;
    });
    /* The tell is only public on the free look of the round or after paying 4. */
    var tellSeen = fight.exchange === 0 || !!fight.tellPaid;
    if (tellSeen && fight.tell && fight.tell.shape) {
      var shape = fight.tell.shape;
      Object.keys(foeWeights).forEach(function (id) {
        if (CARDS[id].shape === shape) foeWeights[id] = (foeWeights[id] || 1) * 1.8;
      });
    }
  }
  if (key === 'opponent' || publicOnly) {
    /* What he has just thrown twice is worth answering: this is public
       information, and both chairs may use it (round 3b made it key-aware so a
       style matchup can be measured with the same policy in both chairs). */
    var recent = fight.events.slice(-3).map(function (ev) { return ev[key === 'player' ? 'opponent' : 'player'].card; });
    var counts = {};
    recent.forEach(function (id) { counts[id] = (counts[id] || 0) + 1; });
    Object.keys(counts).forEach(function (id) {
      var counter = CARD_ORDER.filter(function (candidate) {
        return ['W', 'w'].indexOf(RESOLUTION[candidate][id]) >= 0;
      });
      counter.forEach(function (candidate) {
        foeWeights[candidate] = (foeWeights[candidate] || 1) * (counts[id] >= 2 ? 4 : 1.25);
      });
    });
  }
  var best = null, bestScore = -Infinity;
  for (var i = 0; i < side.hand.length; i++) {
    var id = side.hand[i], card = CARDS[id];
    if (!aiLegal(side, fight, key, id)) continue;
    var s;
    if (key === 'player' && !publicOnly) {
      var inRange = card.ranges && card.ranges.indexOf(fight.range) >= 0;
      var affordable = side.stamina >= aiCost(side, fight, key, id);
      s = expectedSwing(id, foeWeights) * (inRange ? 1 : 0.62) * (affordable ? 1 : 0.6)
        + 0.015 * cardBaseValue(card);
      /* A feint is worth playing when a real punch is behind it. */
      if (id === 'feint') s += side.hand.some(function (x) { return CARDS[x].kind === 'punch' && CARDS[x].cost >= 6; }) ? 8.5 : -0.5;
      if (id === 'catch_breath') s += side.stamina < side.maxStamina * 0.7 ? 6 : 1;
      if (id === 'block') s += ctx.lastOppCard && CARDS[ctx.lastOppCard].kind === 'punch' && (CARDS[ctx.lastOppCard].dmg.head + CARDS[ctx.lastOppCard].dmg.body) >= 7 ? 1.1 : 0.4;
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
  habitChanceAtBell: habitChanceAtBell, unseenPool: unseenPool,
  scoutingPrediction: scoutingPrediction, predictedCard: predictedCard, expectedSwing: expectedSwing,
  habitCard: habitCard, chooseAiCard: chooseAiCard, chooseStyleCard: chooseStyleCard };
});
