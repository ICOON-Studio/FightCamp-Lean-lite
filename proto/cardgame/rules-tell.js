/* Tell chip: a shape, not a card. One free look a round, then 4 wind. */
(function (root, factory) {
  if (typeof module === 'object' && module.exports) module.exports = factory;
  if (typeof window !== 'undefined') window.FightCampTell = factory;
})(typeof globalThis !== 'undefined' ? globalThis : this, function (d) {
'use strict';
var CARDS = d.CARDS;
var SHAPES = d.SHAPES;
var SHAPE_LABEL = d.SHAPE_LABEL;
var SHAPE_OPPOSITE = d.SHAPE_OPPOSITE;
var makeRng = d.makeRng;
var hashSeed = d.hashSeed;
var chooseAiCard = d.chooseAiCard;
function tellLabel(shape) { return SHAPE_LABEL[shape] || 'setting a shot'; }
function refreshTell(fight) {
  fight.foePlan = chooseAiCard(fight, 'opponent');
  var foeShape = CARDS[fight.foePlan].shape;
  var rng = makeRng(hashSeed(fight.seed, 'tell', fight.round, fight.exchange));
  var shape;
  if (rng.chance(0.6)) shape = foeShape;
  else {
    var wrong = SHAPES.filter(function (s) { return s !== foeShape && s !== SHAPE_OPPOSITE[foeShape]; });
    shape = wrong[rng.int(wrong.length)];
  }
  fight.tell = { text: tellLabel(shape), shape: shape, accuracy: 0.6 };
  fight.tellPaid = false;
}
function tellVisible(fight) { return fight.exchange === 0 || !!fight.tellPaid; }
function payForTell(fight) {
  if (fight.exchange === 0) return true;
  if (fight.tellPaid) return true;
  if (fight.player.stamina < 4) return false;
  fight.player.stamina -= 4;
  fight.tellPaid = true;
  return true;
}
return { tellLabel: tellLabel, refreshTell: refreshTell, payForTell: payForTell, tellVisible: tellVisible };
});
