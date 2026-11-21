/* Fight-exchange resolver, injected with the pure rules dependencies. */
(function (root, factory) {
  if (typeof module === 'object' && module.exports) module.exports = factory;
  if (typeof window !== 'undefined') window.FightCampExchange = factory;
})(typeof globalThis !== 'undefined' ? globalThis : this, function (d) {
'use strict';
var CARDS = d.CARDS;
var predictedCard = d.predictedCard;
var CODE_FACTOR = d.CODE_FACTOR;
var FLIP = d.FLIP;
var RESOLUTION = d.RESOLUTION;
var makeRng = d.makeRng;
var hashSeed = d.hashSeed;
var clamp = d.clamp;
var cardCost = d.cardCost;
var chooseAiCard = d.chooseAiCard;
var refreshTell = d.refreshTell;
var refill = d.refill;
var isHurt = d.isHurt;
var checkStoppage = d.checkStoppage;
var finishEarly = d.finishEarly;
var endRound = d.endRound;
function advanceOutcome(code) { return ({ X: 'X', W: 'W', w: 'W', t: 'w', l: 't', n: 'w' })[code] || code; }
function strike(fight, side, foe, cardId, foeCardId, code, opts) {
  var card = CARDS[cardId], foeCard = CARDS[foeCardId], factor = CODE_FACTOR[code];
  var out = { card: cardId, code: code, hit: false, head: 0, body: 0, dealt: 0, verdict: 'finds nothing' };
  if (factor === 0) return out;
  var punch = card.kind === 'punch';
  var base = punch ? (card.dmg || { head: 0, body: 0 }) : { head: 0, body: 0 };
  var inRange = !card.ranges || card.ranges.indexOf(fight.range) >= 0;
  var statMul = punch ? 1 + (side.stats.power - 50) / 150 : 1 + (side.stats.speed - 50) / 150;
  var guardMul = (code === 'l' || code === 'X' || code === 't')
    ? 1 - (foeCard.guard || 0) * (code === 't' ? 0.6 : 1) : 1;
  var defMul = 1 - (foe.stats.defence - 50) / 320;
  var hitChance = card.acc + (side.stats.technique - 50) / 220
    + (factor >= 1 ? 0.05 : factor <= 0.3 ? -0.07 : 0)
    + (inRange ? 0 : -0.12) + (opts.gassed ? -0.08 : 0) + (punch && opts.setup ? 0.05 : 0)
    + (punch && opts.opening ? 0.15 : 0) + (punch && opts.reactive ? opts.reactive : 0);
  if (cardId === 'uppercut' && fight.range === 'out') hitChance = 0.5;
  out.hit = fight.hitRng.chance(clamp(hitChance, 0.25, 0.97));
  if (!out.hit) { out.verdict = 'misses'; return out; }
  var punchMod = punch ? 1 + (side.mods.punch || 0) : 1;
  var mult = factor * statMul * guardMul * defMul * (inRange ? 1 : 0.62) * (opts.gassed ? 0.6 : 1) * opts.bonus * punchMod;
  if (punch && opts.setup) mult *= 1.15;
  if (punch && opts.opening) mult *= 1.3;
  out.head = Math.max(0, base.head * mult);
  out.body = Math.max(0, base.body * mult);
  out.dealt = out.head + out.body;
  out.verdict = code === 'W' ? 'lands flush' : code === 'w' ? 'lands' :
    code === 't' ? 'lands in a trade' : code === 'l' ? 'is mostly smothered' : 'is half-blocked';
  return out;
}
function knockdownChance(shotHead, defender) {
  if (shotHead < 4) return 0;
  var p = (shotHead - 4) / 24;
  p *= 1 + defender.head / 120;
  p *= 1 + (defender.maxStamina - defender.stamina) / 300;
  p *= 1.25 - defender.stats.chin / 230;
  if (isHurt(defender)) p *= 1.35;
  return clamp(p * 0.4, 0, 0.55);
}
function rangeAfter(a, b, fight) {
  /* Position belongs to the exchange winner; a losing chip hit cannot move it. */
  var winner = a.hit && ['W', 'w'].indexOf(a.code) >= 0 ? a :
    b.hit && ['W', 'w'].indexOf(b.code) >= 0 ? b : null;
  if (!winner) return fight.range;
  var id = winner.card, card = CARDS[id];
  if (card.rangeAfter) return card.rangeAfter;
  if (id === 'clinch' || id === 'uppercut' || id === 'body_hook') return 'inside';
  if (id === 'jab' && fight.range === 'inside') return 'mid';
  return fight.range;
}
function exchangeText(fight, a, b, kd) {
  var foe = fight.opponent;
  function phrase(hit) { return hit.verdict; }
  var txt = 'Your ' + CARDS[a.card].say + ' ' + phrase(a) + '; ' +
    foe.poss + ' ' + CARDS[b.card].say + ' ' + phrase(b);
  function action(hit, target, owner) {
    var id = hit.card, label = CARDS[id].say;
    var text = id === 'slip' ? 'slips the ' + target : id === 'roll' ? 'rolls under the ' + target :
      id === 'block' ? 'blocks the ' + target : id === 'step_back' ? 'takes the ' + target + ' out of range' :
      id === 'pivot_out' ? 'pivots away from the ' + target : id === 'clinch' ? 'ties up the ' + target :
      id === 'cut_off' ? 'cuts off the ring against the ' + target : null;
    if (text) return owner + ' ' + text + ' with ' + label;
    return owner + ' ' + label + ' ' + hit.verdict;
  }
  txt = action(a, CARDS[b.card].say, 'Your boxer') + '; ' + action(b, CARDS[a.card].say, 'the opponent');
  kd.forEach(function (k) {
      txt += k.who === 'player' ? ' — your boxer is down!' : ' — the opponent is down!';
  });
  return txt;
}
function resolutionAt(a, b, range) {
  if ((range === 'out' || range === 'mid') && a === 'cross' && b === 'jab') return 'w';
  if ((range === 'out' || range === 'mid') && a === 'jab' && b === 'cross') return 'l';
  if ((range === 'out' || range === 'mid') && a === 'jab' && b === 'uppercut') return 'w';
  if ((range === 'out' || range === 'mid') && a === 'uppercut' && b === 'jab') return 'l';
  if (a === 'slip' && b === 'uppercut') return 'X';
  if (a === 'uppercut' && b === 'slip') return 'W';
  if (a === 'lead_hook' && b === 'pivot_out') return 'w';
  if (a === 'pivot_out' && b === 'lead_hook') return 'l';
  return RESOLUTION[a][b];
}
function playExchange(game, playerCardId, mode, opponentCardId) {
  var fight = game.fight;
  if (!fight || fight.phase !== 'fight') throw new Error('the bell has gone');
  var me = fight.player, foe = fight.opponent;
  mode = mode === 'predict' ? 'predict' : 'react';
  if (me.hand.indexOf(playerCardId) < 0) throw new Error('not in hand: ' + playerCardId);
  var foeCardId = opponentCardId || (fight.opponent.hand.indexOf(fight.foePlan) >= 0 ? fight.foePlan : chooseAiCard(fight, 'opponent'));
  if (fight.opponent.hand.indexOf(foeCardId) < 0) throw new Error('opponent card is not in hand: ' + foeCardId);

  me.hand.splice(me.hand.indexOf(playerCardId), 1);
  foe.hand.splice(foe.hand.indexOf(foeCardId), 1);
  me.discard.push(playerCardId); foe.discard.push(foeCardId);

  var meCost = cardCost(me, playerCardId), foeCost = cardCost(foe, foeCardId);
  var modeCost = mode === 'predict' ? 2 : 0;
  var meGassed = me.stamina < meCost + modeCost, foeGassed = foe.stamina < foeCost;
  me.stamina = Math.max(0, me.stamina - meCost - modeCost);
  foe.stamina = Math.max(0, foe.stamina - foeCost);

  var first = fight.exchange === 0;
  var bonusA = first && me.mods.firstExchange ? 1 + me.mods.firstExchange : 1;
  var bonusB = first && foe.mods.firstExchange ? 1 + foe.mods.firstExchange : 1;
  if (first && me.mods.foe_first) bonusB *= 1 + me.mods.foe_first;
  var baseCode = resolutionAt(playerCardId, foeCardId, fight.range), codeA = baseCode, codeB = FLIP[baseCode];
  var forecast = mode === 'predict' ? predictedCard(fight) : null;
  var correctRead = mode === 'predict' && forecast === foeCardId;
  if (mode === 'predict') {
    if (correctRead) { codeA = 'W'; codeB = 'X'; }
    else { codeB = advanceOutcome(codeB); codeA = FLIP[codeB]; bonusB *= 1.2; }
  }
  var reactive = mode === 'react' && me.stats.speed >= 65 ? clamp((me.stats.speed - 65) / 200, 0, 0.15) : 0;
  var foeReactive = foe.stats.speed >= 65 ? clamp((foe.stats.speed - 65) / 200, 0, 0.15) : 0;
  var a = strike(fight, me, foe, playerCardId, foeCardId, codeA, {
    gassed: meGassed, setup: me.combo, opening: me.opening, reactive: reactive, bonus: bonusA });
  var b = strike(fight, foe, me, foeCardId, playerCardId, codeB, {
    gassed: foeGassed, setup: foe.combo, opening: foe.opening, reactive: foeReactive, bonus: bonusB });
  me.combo = !!(a.hit && CARDS[playerCardId].setsUp && ['W', 'w', 't'].indexOf(a.code) >= 0);
  foe.combo = !!(b.hit && CARDS[foeCardId].setsUp && ['W', 'w', 't'].indexOf(b.code) >= 0);
  if (CARDS[playerCardId].kind === 'punch') me.opening = false;
  if (CARDS[foeCardId].kind === 'punch') foe.opening = false;
  if (['slip', 'roll'].indexOf(playerCardId) >= 0 && ['W', 'w'].indexOf(a.code) >= 0) me.opening = true;
  if (['slip', 'roll'].indexOf(foeCardId) >= 0 && ['W', 'w'].indexOf(b.code) >= 0) foe.opening = true;
  if (playerCardId === 'block' && ['W', 'w'].indexOf(a.code) >= 0) me.stamina = Math.min(me.maxStamina, me.stamina + 1);
  if (foeCardId === 'block' && ['W', 'w'].indexOf(b.code) >= 0) foe.stamina = Math.min(foe.maxStamina, foe.stamina + 1);
  if (playerCardId === 'step_back' && ['W', 'w'].indexOf(a.code) >= 0) foe.stamina = Math.max(0, foe.stamina - 1);
  if (foeCardId === 'step_back' && ['W', 'w'].indexOf(b.code) >= 0) me.stamina = Math.max(0, me.stamina - 1);

  me.head += b.head; me.body += b.body;
  foe.head += a.head; foe.body += a.body;
  foe.stamina = Math.max(0, Math.round(foe.stamina - a.body * 0.45));
  me.stamina = Math.max(0, Math.round(me.stamina - b.body * 0.45));
  if (CARDS[playerCardId].id === 'clinch' && a.code !== 'X' && a.hit) foe.stamina = Math.max(0, foe.stamina - 4);
  if (CARDS[foeCardId].id === 'clinch' && b.code !== 'X' && b.hit) me.stamina = Math.max(0, me.stamina - 4);
  me.lastTookClean = b.head >= 5; foe.lastTookClean = a.head >= 5;
  me.lastCard = playerCardId; foe.lastCard = foeCardId;
  var referee = [];
  [[me, playerCardId, 'you'], [foe, foeCardId, 'the opponent']].forEach(function (entry) {
    var side = entry[0];
    side.clinchStreak = entry[1] === 'clinch' ? side.clinchStreak + 1 : 0;
    if (side.clinchStreak === 2) referee.push(entry[2] + ' receive a referee warning for holding');
    if (side.clinchStreak >= 3) { side.round.deductions += 1; referee.push(entry[2] + ' lose a point for repeated holding'); }
  });

  [[me, a, foe], [foe, b, me]].forEach(function (row) {
    var side = row[0], hit = row[1];
    side.totals.thrown += 1; side.round.thrown += 1;
    side.totals.damage += hit.dealt; side.round.damage += hit.dealt;
    if (hit.hit) { side.totals.landed += 1; side.round.landed += 1; }
  });

  var knockdowns = [];
  if (a.hit) {
    var p1 = fight.round === 1 && fight.exchange === 0 && foe.head === 0 && foe.stamina === foe.maxStamina ? 0 : knockdownChance(a.head, foe);
    if (p1 > 0 && fight.knockdownRng.chance(p1)) { foe.knockdowns += 1; foe.round.kd += 1; foe.stamina = Math.max(0, foe.stamina - 12); knockdowns.push({ who: 'opponent' }); }
  }
  if (b.hit) {
    var p2 = fight.round === 1 && fight.exchange === 0 && me.head === 0 && me.stamina === me.maxStamina ? 0 : knockdownChance(b.head, me);
    if (p2 > 0 && fight.knockdownRng.chance(p2)) { me.knockdowns += 1; me.round.kd += 1; me.stamina = Math.max(0, me.stamina - 12); knockdowns.push({ who: 'player' }); }
  }

  var range = rangeAfter(a, b, fight);
  fight.range = range;
  var stop = checkStoppage(fight);
  var event = {
    round: fight.round, exchange: fight.exchange, player: a, opponent: b,
    code: codeA, actualCode: baseCode, mode: mode, forecast: forecast, correctRead: correctRead, range: range,
    knockdowns: knockdowns, stoppage: stop, referee: referee, tell: fight.tell
  };
  event.text = exchangeText(fight, a, b, knockdowns) + (referee.length ? ' — ' + referee.join('; ') : '');
  fight.events.push(event);

  refill(me, fight.shuffleRng, 5); refill(foe, fight.shuffleRng, 5);
  fight.exchange += 1;
  if (stop) { finishEarly(fight, stop); return event; }
  if (fight.exchange >= 6) endRound(game);
  else refreshTell(fight);
  return event;
}

return { strike: strike, knockdownChance: knockdownChance, rangeAfter: rangeAfter, exchangeText: exchangeText, resolutionAt: resolutionAt, playExchange: playExchange };
});
