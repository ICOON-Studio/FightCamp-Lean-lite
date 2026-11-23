/* Fight camp: offers, the add-and-remove pick, and the informed corner that
   reads the drill table. Injected with data and RNG so the rules stay pure. */
(function (root, factory) {
  if (typeof module === 'object' && module.exports) module.exports = factory;
  if (typeof window !== 'undefined') window.FightCampCamp = factory;
})(typeof globalThis !== 'undefined' ? globalThis : this, function (d) {
'use strict';
var CARDS = d.CARDS, CAMP_CARDS = d.CAMP_CARDS, CAMP_PREF = d.CAMP_PREF, DRILL_VALUE = d.DRILL_VALUE;
var makeRng = d.makeRng, hashSeed = d.hashSeed;
var boxerById = d.boxerById, cardById = d.cardById;
function campOffers(seed) {
  var rng = makeRng(hashSeed(seed, 'camp'));
  var pool = rng.shuffle(CAMP_CARDS.map(function (c) { return c.id; }));
  var out = [];
  for (var w = 0; w < 4; w++) out.push(pool.slice(w * 3, w * 3 + 3));
  return out;
}
function deckWithMods(game) {
  var boxer = boxerById(game.playerBoxerId);
  var deck = boxer.deck.slice();
  for (var k in game.mods.add) for (var i = 0; i < game.mods.add[k]; i++) deck.push(k);
  for (var r in game.mods.remove) for (var j = 0; j < game.mods.remove[r]; j++) {
    var idx = deck.indexOf(r); if (idx >= 0) deck.splice(idx, 1);
  }
  return deck;
}
function removalsFor(cardId) {
  var card = cardById(cardId), n = 0;
  for (var d2 in (card.add || {})) n += card.add[d2];
  return Math.max(1, n);
}
function autoRemove(game, drillId, taken) {
  var card = cardById(drillId);
  var deck = deckWithMods(game);
  var added = Object.keys(card.add || {});
  var candidates = deck.filter(function (id) { return added.indexOf(id) < 0 && (!taken || taken.indexOf(id) < 0); });
  if (!candidates.length) return null;
  function value(id) { var c = CARDS[id]; return (c.dmg ? c.dmg.head + c.dmg.body : 0) + (c.counter ? (c.counter.head + c.counter.body) * 0.5 : 0); }
  function count(id) { return deck.filter(function (x) { return x === id; }).length; }
  candidates.sort(function (a, b) { return (count(a) > 1 ? 0 : 1) - (count(b) > 1 ? 0 : 1) || value(a) - value(b); });
  return candidates[0];
}
function pickCampCard(game, cardId, removeIds) {
  if (game.phase !== 'camp') throw new Error('camp is over');
  if (game.offers[game.week].indexOf(cardId) < 0) throw new Error('not in this week\'s offer: ' + cardId);
  var card = cardById(cardId);
  var deck = deckWithMods(game);
  var need = removalsFor(cardId);
  var removals = removeIds === undefined || removeIds === null ? [] :
    (Array.isArray(removeIds) ? removeIds.slice() : [removeIds]);
  while (removals.length < need) {
    var auto = autoRemove(game, cardId, removals);
    if (!auto) break;
    removals.push(auto);
  }
  if (removals.length > need) throw new Error('this drill removes ' + need + ' card(s)');
  removals.forEach(function (remove) {
    if (deck.indexOf(remove) < 0) throw new Error('cannot remove a card not in the deck: ' + remove);
    deck.splice(deck.indexOf(remove), 1);
  });
  for (var k in (card.stat || {})) game.mods.stat[k] = (game.mods.stat[k] || 0) + card.stat[k];
  for (var a in (card.add || {})) game.mods.add[a] = (game.mods.add[a] || 0) + card.add[a];
  removals.forEach(function (remove) { game.mods.remove[remove] = (game.mods.remove[remove] || 0) + 1; });
  if (deckWithMods(game).length > 16) throw new Error('the fight deck is capped at 16');
  if (card.scout) game.mods.scout += card.scout;
  game.picks.push(cardId);
  game.week += 1;
  return game;
}
/* The informed corner takes the best of the week's three and stops stacking a
   card it already has three of. DRILL_VALUE is measured in the harness. */
function aiCampPick(game) {
  var offer = game.offers[game.week], deck = deckWithMods(game), prefs = CAMP_PREF[boxerById(game.playerBoxerId).style] || [];
  var best = offer[0], bestScore = -Infinity;
  offer.forEach(function (id) {
    var card = cardById(id), score = DRILL_VALUE[id] || 0;
    if (prefs.indexOf(id) >= 0) score += (prefs.length - prefs.indexOf(id)) * 0.1;
    for (var k in (card.add || {})) {
      var have = deck.filter(function (x) { return x === k; }).length + card.add[k];
      if (have > 3) score -= 1.5 * (have - 3);
    }
    if (score > bestScore) { bestScore = score; best = id; }
  });
  return best;
}
function aiCampRemove(game, drillId) {
  var deck = deckWithMods(game);
  var card = cardById(drillId);
  var added = Object.keys(card.add || {});
  function value(id) {
    var c = CARDS[id];
    var punch = c.dmg ? c.dmg.head + c.dmg.body : 0;
    var guard = c.counter ? (c.counter.head + c.counter.body) * 1.5 + (c.guard || 0) * 10 : 0;
    var foot = c.rangeAfter ? 3 : 0;
    var trick = id === 'feint' ? 2 : id === 'catch_breath' ? 5 : 0;
    return punch + guard + foot + trick + c.cost * 0.1;
  }
  function count(id) { return deck.filter(function (x) { return x === id; }).length; }
  var candidates = deck.filter(function (id) { return added.indexOf(id) < 0; });
  candidates.sort(function (a, b) { return (count(a) > 1 ? 0 : 1) - (count(b) > 1 ? 0 : 1) || value(a) - value(b); });
  var out = [];
  for (var i = 0; i < removalsFor(drillId) && i < candidates.length; i++) out.push(candidates[i]);
  return out;
}
return { campOffers: campOffers, deckWithMods: deckWithMods, removalsFor: removalsFor,
  autoRemove: autoRemove, pickCampCard: pickCampCard, aiCampPick: aiCampPick, aiCampRemove: aiCampRemove };
});
