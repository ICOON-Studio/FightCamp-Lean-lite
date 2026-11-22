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
var REASONS = d.REASONS || {};
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
/* A non-punch card cannot follow a non-punch card while a punch is available:
   two men feinting and blocking at each other is not a fight. */
function otherKey(key) { return key === 'player' ? 'opponent' : 'player'; }
function repeatsNonPunch(side, cardId) {
  /* Two exemptions, both because another rule needs the repeat: the referee's
     two-clinches warning (round 2), and the ropes ladder (round 3b) which is
     "two cut offs in a row". A man cutting the ring off twice is doing a job. */
  if (cardId === 'clinch' || cardId === 'cut_off') return false;
  return CARDS[cardId].kind !== 'punch' && !!side.lastCard && CARDS[side.lastCard].kind !== 'punch' &&
    side.hand.some(function (id) { return CARDS[id].kind === 'punch'; });
}
function legalNow(side, fight, key, cardId) {
  if (fight.ropes && cardId === 'step_back') return false;
  if (cardId === 'catch_breath' && side.catchUsed) return false;
  if (repeatsNonPunch(side, cardId)) return false;
  return true;
}
/* Cost at this moment: price, range, and the cut-off trap on an escape. */
function costNow(side, fight, key, cardId) {
  var cost = cardCost(side, cardId) + (CARDS[cardId].ranges.indexOf(fight.range) >= 0 ? 0 : 1);
  var trapped = fight.trap && fight.trap.who === key && !!key;
  if (trapped && (cardId === 'step_back' || cardId === 'pivot_out')) cost += 1;
  return cost;
}
function advanceOutcome(code) { return ({ X: 'X', W: 'W', w: 'W', t: 'w', l: 't', n: 'w' })[code] || code; }
function strike(fight, side, foe, cardId, foeCardId, code, opts) {
  var card = CARDS[cardId], foeCard = CARDS[foeCardId];
  var factor = CODE_FACTOR[code];
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
    + (inRange ? 0 : -0.06) + (opts.gassed ? -0.08 : 0) + (punch && opts.setup ? 0.05 : 0)
    + (opts.accPenalty || 0)
    + (punch && opts.opening ? 0.15 : 0) + (punch && opts.feint ? 0.15 : 0) + (punch && opts.reactive ? opts.reactive : 0);
  if (cardId === 'uppercut' && fight.range === 'out') hitChance = 0.5;
  /* Trapped on the ropes by a cut-off: the exit is half a step slower. */
  if (opts.trapped && (cardId === 'step_back' || cardId === 'pivot_out')) hitChance *= 0.5;
  out.hit = (opts.rng || fight.hitRng).chance(clamp(hitChance, 0.25, 0.97));
  out.code = code;
  if (!out.hit) { out.verdict = 'misses'; return out; }
  var punchMod = punch ? 1 + (side.mods.punch || 0) : 1;
  var mult = factor * statMul * guardMul * defMul * (opts.gassed ? 0.6 : 1) * opts.bonus * punchMod;

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
  return clamp(p * 0.22, 0, 0.5);
}
function rangeAfter(a, b, fight) {
  if (fight.ropes) {
    var w = a.hit && ['W', 'w'].indexOf(a.code) >= 0 ? a : b.hit && ['W', 'w'].indexOf(b.code) >= 0 ? b : null;
    if (w && w.card === 'pivot_out') return 'mid';
    return 'ropes';
  }
  var winner = a.hit && ['W', 'w'].indexOf(a.code) >= 0 ? a :
    b.hit && ['W', 'w'].indexOf(b.code) >= 0 ? b : null;
  if (!winner) return fight.range;
  var id = winner.card, card = CARDS[id];
  if (card.rangeAfter) return card.rangeAfter;
  if (id === 'clinch' || id === 'uppercut' || id === 'body_hook') return 'inside';
  if (id === 'jab' && fight.range === 'inside') return 'mid';
  return fight.range;
}
/* Round 3b: one sentence, built from the outcome code, possessive, and true to
   the table. The verb is chosen by the code and by nothing else, so a line can
   never say "slips the body hook" while the table says the body hook landed. */
var LINE_VERB = { W: 'beats', w: 'beats', l: 'beats', X: 'catches', t: 'trade', n: 'cancel' };
var LINE_WHY = {
  W: 'clean, unanswered work', w: 'the cleaner work lands',
  l: 'the shorter answer lands first', X: 'he read it coming',
  t: 'neither man gives ground', n: 'neither man commits'
};
function reasonFor(aId, bId, code) {
  var won = ['W', 'w'].indexOf(code) >= 0;
  var keys = won ? [aId + '>' + bId, bId + '>' + aId] : [bId + '>' + aId, aId + '>' + bId];
  for (var i = 0; i < keys.length; i++) if (REASONS[keys[i]]) return REASONS[keys[i]];
  return LINE_WHY[code] || LINE_WHY.n;
}
function exchangeLine(aId, bId, code, mineLabel) {
  var mine = 'your boxer\u2019s ' + (mineLabel || CARDS[aId].say);
  var his = 'the opponent\u2019s ' + CARDS[bId].say;
  var head;
  if (code === 'W' || code === 'w') head = mine + ' beats ' + his;
  else if (code === 'l') head = his + ' beats ' + mine;
  else if (code === 'X') head = his + ' catches ' + mine;
  else if (code === 't') head = mine + ' and ' + his + ' trade';
  else head = 'nothing lands: ' + mine + ' and ' + his + ' cancel';
  return head + '; ' + reasonFor(aId, bId, code);
}
function exchangeText(fight, a, b, kd, comboA, comboB) {
  var mineLabel = comboA && comboA.length > 1
    ? comboA.map(function (id) { return CARDS[id].say; }).join('-') : null;
  var txt = exchangeLine(a.card, b.card, a.code, mineLabel);
  if (comboB && comboB.length > 1) {
    txt += '; the opponent\u2019s ' + comboB.map(function (id) { return CARDS[id].say; }).join('-') + ' came behind it';
  }
  kd.forEach(function (k) {
    txt += k.who === 'player' ? ' — your boxer is down!' : ' — the opponent is down!';
  });
  return txt;
}
function resolutionAt(a, b, range) {
  if (range === 'out' && a === 'cross' && b === 'jab') return 't';
  if (range === 'out' && a === 'jab' && b === 'cross') return 't';
  if ((range === 'out' || range === 'mid') && a === 'cross' && b === 'jab') return 'w';
  if ((range === 'out' || range === 'mid') && a === 'jab' && b === 'cross') return 'l';
  if ((range === 'out' || range === 'mid') && a === 'jab' && b === 'uppercut') return 'w';
  if ((range === 'out' || range === 'mid') && a === 'uppercut' && b === 'jab') return 'l';
  if (a === 'slip' && b === 'uppercut') return 'X';
  if (a === 'uppercut' && b === 'slip') return 'W';
  /* Round 3b: the lead hook is the weakest card. A hook gets round a guard and
     catches a man stepping away only at close quarters, where the arm is short
     enough to land it; at mid and out the pinned base cells stand. */
  if (range === 'inside' && a === 'lead_hook' && b === 'block') return 't';
  if (range === 'inside' && a === 'block' && b === 'lead_hook') return 't';
  if (range === 'inside' && a === 'lead_hook' && b === 'step_back') return 't';
  if (range === 'inside' && a === 'step_back' && b === 'lead_hook') return 't';
  /* Round 3b: Pivot out v Cut off was asked to be a trade. The base cell is
     pinned by a round-1 test ("pivot out beats cut off"), so the trade is
     applied at inside range only, where the pivot has no room to escape. */
  if (range === 'inside' && a === 'pivot_out' && b === 'cut_off') return 't';
  if (range === 'inside' && a === 'cut_off' && b === 'pivot_out') return 't';
  if (range === 'inside' && a === 'slip' && b === 'lead_hook') return 'W';
  if (range === 'inside' && a === 'lead_hook' && b === 'slip') return 'X';
  if (a === 'lead_hook' && b === 'pivot_out') return 'w';
  if (a === 'pivot_out' && b === 'lead_hook') return 'l';
  return RESOLUTION[a][b];
}
function playExchange(game, playerCardId, mode, opponentCardId) {
  var fight = game.fight;
  if (!fight || fight.phase !== 'fight') throw new Error('the bell has gone');
  var me = fight.player, foe = fight.opponent;
  /* A just-landed knockdown protection: a fresh pair at the opening bell
     cannot be dropped before a punch has been thrown in anger. */
  var openingBell = fight.round === 1 && fight.exchange === 0 &&
    me.head === 0 && me.stamina === me.maxStamina && foe.head === 0 && foe.stamina === foe.maxStamina;
  mode = mode === 'predict' ? 'predict' : 'react';
  var combo = Array.isArray(playerCardId) ? playerCardId.slice() : [playerCardId];
  if (!combo.length || combo.length > 3) throw new Error('a combo is one to three cards');
  combo.forEach(function (id) {
    if (me.hand.indexOf(id) < 0) throw new Error('not in hand: ' + id);
    if (fight.ropes && id === 'step_back') throw new Error('step back is off the table on the ropes');
    if (id === 'catch_breath' && me.catchUsed) throw new Error('catch breath is once a round');
    if (repeatsNonPunch(me, id)) throw new Error('a non-punch card cannot follow a non-punch card: ' + id);
  });
  var foeCardId = opponentCardId || (fight.foePolicy ? fight.foePolicy(fight) :
    fight.opponent.hand.indexOf(fight.foePlan) >= 0 ? fight.foePlan : chooseAiCard(fight, 'opponent'));
  if (fight.opponent.hand.indexOf(foeCardId) < 0) throw new Error('opponent card is not in hand: ' + foeCardId);
  combo.forEach(function (id) { me.hand.splice(me.hand.indexOf(id), 1); me.discard.push(id); });
  foe.hand.splice(foe.hand.indexOf(foeCardId), 1);
  foe.discard.push(foeCardId);
  var foeCost = costNow(foe, fight, 'opponent', foeCardId);
  var meCost = 0;
  combo.forEach(function (id) { meCost += costNow(me, fight, 'player', id); });
  meCost += Math.max(0, combo.length - 1);
  var modeCost = mode === 'predict' ? 2 : 0;
  var meGassed = me.stamina < meCost + modeCost, foeGassed = foe.stamina < foeCost;
  me.stamina = Math.max(0, me.stamina - meCost - modeCost);
  foe.stamina = Math.max(0, foe.stamina - foeCost);
  var first = fight.exchange === 0;
  var bonusA = first && me.mods.firstExchange ? 1 + me.mods.firstExchange : 1;
  var bonusB = first && foe.mods.firstExchange ? 1 + foe.mods.firstExchange : 1;
  if (first && me.mods.takenFirst) bonusB *= 1 + me.mods.takenFirst;
  if (first && foe.mods.takenFirst) bonusA *= 1 + foe.mods.takenFirst;
  if (first) { delete me.mods.firstExchange; delete foe.mods.firstExchange; delete me.mods.takenFirst; delete foe.mods.takenFirst; }
  var baseCode = resolutionAt(combo[0], foeCardId, fight.range), codeA = baseCode, codeB = FLIP[baseCode];
  var forecast = mode === 'predict' ? predictedCard(fight) : null;
  var correctRead = mode === 'predict' && forecast === foeCardId;
  if (mode === 'predict') {
    if (correctRead) { codeA = 'W'; codeB = 'X'; }
    else { codeB = advanceOutcome(codeB); codeA = FLIP[codeB]; bonusB *= 1.2; }
  }
  var reactive = mode === 'react' && me.stats.speed >= 65 ? clamp((me.stats.speed - 65) / 200, 0, 0.15) : 0;
  var foeReactive = foe.stats.speed >= 65 ? clamp((foe.stats.speed - 65) / 200, 0, 0.15) : 0;
  var foeAccPenalty = foe.mods.nextPunchAcc || 0;
  var hitA = makeRng(hashSeed(fight.seed, 'hit', 'player', fight.round, fight.exchange));
  var hitB = makeRng(hashSeed(fight.seed, 'hit', 'opponent', fight.round, fight.exchange));
  var kdA = makeRng(hashSeed(fight.seed, 'kd', 'player', fight.round, fight.exchange));
  var kdB = makeRng(hashSeed(fight.seed, 'kd', 'opponent', fight.round, fight.exchange));
  var b = strike(fight, foe, me, foeCardId, combo[0], codeB, {
    gassed: foeGassed, setup: foe.combo, opening: foe.opening, feint: foe.feint, reactive: foeReactive, bonus: bonusB,
    trapped: !!(fight.trap && fight.trap.who === 'opponent'), accPenalty: foeAccPenalty, rng: hitB });
  var aList = [];
  var setup = me.combo, opening = me.opening, feint = me.feint;
  combo.forEach(function (id, idx) {
    var code = idx === 0 ? codeA : resolutionAt(id, foeCardId, fight.range);
    var hit = strike(fight, me, foe, id, foeCardId, code, {
      gassed: meGassed, setup: setup, opening: opening, feint: feint, reactive: reactive, bonus: bonusA,
      trapped: !!(fight.trap && fight.trap.who === 'player'), accPenalty: me.mods.nextPunchAcc || 0, rng: hitA });
    aList.push(hit);
    if (CARDS[id].kind === 'punch') { setup = !!(hit.hit && CARDS[id].setsUp && ['W', 'w'].indexOf(hit.code) >= 0); opening = false; feint = false; }
    if (['slip', 'roll'].indexOf(id) >= 0 && ['W', 'w'].indexOf(hit.code) >= 0) opening = true;
    if (id === 'feint' && ['W', 'w', 't', 'l', 'n'].indexOf(hit.code) >= 0) feint = true;
    if (id === 'block' && ['W', 'w'].indexOf(hit.code) >= 0) me.stamina = Math.min(me.maxStamina, me.stamina + (correctRead ? 2 : 1));
    if (id === 'step_back' && ['W', 'w'].indexOf(hit.code) >= 0) foe.stamina = Math.max(0, foe.stamina - 1);
    if (id === 'catch_breath') { me.stamina = Math.min(me.maxStamina, me.stamina + 6); me.catchUsed = true; }
  });
  var a = aList[0];
  me.combo = setup; me.opening = opening; me.feint = feint;
  foe.combo = !!(b.hit && CARDS[foeCardId].setsUp && ['W', 'w'].indexOf(b.code) >= 0);
  if (CARDS[foeCardId].kind === 'punch') foe.opening = false;
  if (['slip', 'roll'].indexOf(foeCardId) >= 0 && ['W', 'w'].indexOf(b.code) >= 0) foe.opening = true;
  if (foeCardId === 'block' && ['W', 'w'].indexOf(b.code) >= 0) foe.stamina = Math.min(foe.maxStamina, foe.stamina + 1);
  if (foeCardId === 'step_back' && ['W', 'w'].indexOf(b.code) >= 0) me.stamina = Math.max(0, me.stamina - 1);
  if (foeCardId === 'feint') foe.feint = true;
  if (foeCardId === 'catch_breath') { foe.stamina = Math.min(foe.maxStamina, foe.stamina + 6); foe.catchUsed = true; }
  if (me.feint && ['W', 'w'].indexOf(b.code) >= 0) me.feint = false;
  if (foe.feint && ['W', 'w'].indexOf(a.code) >= 0) foe.feint = false;

  var aHead = 0, aBody = 0, bHead = b.head, bBody = b.body;
  aList.forEach(function (hit) { aHead += hit.head; aBody += hit.body; });
  if (combo.indexOf('catch_breath') >= 0) bBody *= 1.5;
  if (foeCardId === 'catch_breath') aBody *= 1.5;
  a.head = aHead; a.body = aBody; a.dealt = aHead + aBody;
  b.head = bHead; b.body = bBody; b.dealt = bHead + bBody;
  /* React is the hands-up posture: 10% less taken. The opponent is always
     covering; a prediction is the moment you commit and lose that cover. */
  var guard = typeof fight.reactGuard === 'number' ? fight.reactGuard : 0.9;
  var meGuard = mode === 'react' ? guard : 1;
  b.head *= meGuard; b.body *= meGuard; b.dealt = b.head + b.body;
  a.head *= guard; a.body *= guard; a.dealt = a.head + a.body;
  me.head += b.head; me.body += b.body;
  foe.head += a.head; foe.body += a.body;
  foe.stamina = Math.max(0, Math.round(foe.stamina - a.body * 0.45));
  me.stamina = Math.max(0, Math.round(me.stamina - b.body * 0.45));
  /* A won clinch: he pays a wind, you take one back, and his next punch is
     smothered (-15% accuracy). */
  if (combo.indexOf('clinch') >= 0 && ['W', 'w'].indexOf(a.code) >= 0) {
    foe.stamina = Math.max(0, foe.stamina - 1);
    me.stamina = Math.min(me.maxStamina, me.stamina + 1);
    foe.mods.nextPunchAcc = -0.15;
  }
  if (foeCardId === 'clinch' && ['W', 'w'].indexOf(b.code) >= 0) {
    me.stamina = Math.max(0, me.stamina - 1);
    foe.stamina = Math.min(foe.maxStamina, foe.stamina + 1);
    me.mods.nextPunchAcc = -0.15;
  }
  delete me.mods.nextPunchAcc; delete foe.mods.nextPunchAcc;
  /* Two men holding, feinting and stepping: the referee is counting the clock. */
  var meNonPunch = combo.every(function (id) { return CARDS[id].kind !== 'punch'; });
  if (meNonPunch && CARDS[foeCardId].kind !== 'punch') {
    me.stamina = Math.max(0, me.stamina - 1);
    foe.stamina = Math.max(0, foe.stamina - 1);
  }
  aList.forEach(function (hit) {
    var id = hit.card;
    if (CARDS[id].kind !== 'punch' && ['W', 'w'].indexOf(hit.code) >= 0 && b.dealt === 0) {
      var c = CARDS[id].counter || { head: 0, body: 0 };
      me.totals.defencePoints = (me.totals.defencePoints || 0) + c.head + c.body;
      me.round.defencePoints = (me.round.defencePoints || 0) + c.head + c.body;
      me.totals.defence = (me.totals.defence || 0) + 1; me.round.defence = (me.round.defence || 0) + 1;
    }
  });
  if (CARDS[foeCardId].kind !== 'punch' && ['W', 'w'].indexOf(b.code) >= 0 && a.dealt === 0) {
    var fc = CARDS[foeCardId].counter || { head: 0, body: 0 };
    foe.totals.defencePoints = (foe.totals.defencePoints || 0) + fc.head + fc.body;
    foe.round.defencePoints = (foe.round.defencePoints || 0) + fc.head + fc.body;
    foe.totals.defence = (foe.totals.defence || 0) + 1; foe.round.defence = (foe.round.defence || 0) + 1;
  }
  me.lastTookClean = b.head >= 5; foe.lastTookClean = a.head >= 5;
  me.lastCard = combo[combo.length - 1]; foe.lastCard = foeCardId;
  var referee = [];
  [[me, combo[combo.length - 1], 'you'], [foe, foeCardId, 'the opponent']].forEach(function (entry) {
    var side = entry[0];
    side.clinchStreak = entry[1] === 'clinch' ? side.clinchStreak + 1 : 0;
    if (side.clinchStreak === 2) { side.stamina = Math.max(0, side.stamina - 2); referee.push(entry[2] + ' receive a referee warning for holding'); }
    if (side.clinchStreak >= 3) { side.round.deductions += 1; referee.push(entry[2] + ' lose a point for repeated holding'); }
  });
  me.totals.thrown += combo.length; me.round.thrown += combo.length;
  me.totals.damage += a.dealt; me.round.damage += a.dealt;
  aList.forEach(function (hit) { if (hit.hit && CARDS[hit.card].kind === 'punch') { me.totals.landed += 1; me.round.landed += 1; } });
  foe.totals.thrown += 1; foe.round.thrown += 1;
  foe.totals.damage += b.dealt; foe.round.damage += b.dealt;
  if (b.hit && CARDS[foeCardId].kind === 'punch') { foe.totals.landed += 1; foe.round.landed += 1; }
  var knockdowns = [];
  if (a.hit) {
    var p1 = openingBell ? 0 : knockdownChance(a.head, foe);
    if (p1 > 0 && kdB.chance(p1)) { foe.knockdowns += 1; foe.round.kd += 1; foe.stamina = Math.max(0, foe.stamina - 12); knockdowns.push({ who: 'opponent' }); }
  }
  if (b.hit) {
    var p2 = openingBell ? 0 : knockdownChance(b.head, me);
    if (p2 > 0 && kdA.chance(p2)) { me.knockdowns += 1; me.round.kd += 1; me.stamina = Math.max(0, me.stamina - 12); knockdowns.push({ who: 'player' }); }
  }
  var range = rangeAfter(a, b, fight);
  fight.range = range;
  var cutWinner = a.hit && ['W', 'w'].indexOf(a.code) >= 0 && a.card === 'cut_off' ? 'player' :
    b.hit && ['W', 'w'].indexOf(b.code) >= 0 && b.card === 'cut_off' ? 'opponent' : null;
  if (cutWinner) {
    fight.cutOffStreak = fight.cutOffBy === cutWinner ? (fight.cutOffStreak || 0) + 1 : 1;
    fight.cutOffBy = cutWinner;
    /* Walled in: his next step out is slower and costs more. */
    fight.trap = { who: otherKey(cutWinner) };
  } else {
    fight.cutOffStreak = 0;
    fight.cutOffBy = null;
    fight.trap = null;
  }
  var pivoted = (a.card === 'pivot_out' && ['W', 'w'].indexOf(a.code) >= 0) ||
    (b.card === 'pivot_out' && ['W', 'w'].indexOf(b.code) >= 0);
  if (fight.cutOffStreak >= 2) { fight.ropes = true; fight.range = 'ropes'; }
  else if (fight.ropes && pivoted) { fight.ropes = false; fight.range = 'mid'; }
  var stop = checkStoppage(fight);
  var event = {
    round: fight.round, exchange: fight.exchange, player: a, opponent: b,
    combo: combo, foeCard: foeCardId,
    code: codeA, actualCode: baseCode, mode: mode, forecast: forecast, correctRead: correctRead, range: range,
    knockdowns: knockdowns, stoppage: stop, referee: referee, tell: fight.tell, tellSeen: !!fight.tellSeen,
    /* Reacting is the hands-up look: it takes 10% off what lands and it lets the
       boxer see the shape the tell is naming. */
    tellShape: mode === 'react' && fight.tell && fight.tell.shape ? fight.tell.shape : null
  };
  event.text = exchangeText(fight, a, b, knockdowns, combo, [foeCardId]) + (referee.length ? ' — ' + referee.join('; ') : '');
  fight.events.push(event);
  refill(me, fight.shuffleRng, 5); refill(foe, fight.shuffleRng, 5);
  fight.exchange += 1;
  if (stop) { finishEarly(fight, stop); return event; }
  if (fight.exchange >= 6) endRound(game);
  else refreshTell(fight);
  return event;
}

return { strike: strike, knockdownChance: knockdownChance, rangeAfter: rangeAfter, exchangeText: exchangeText,
  resolutionAt: resolutionAt, playExchange: playExchange, legalNow: legalNow, costNow: costNow, repeatsNonPunch: repeatsNonPunch,
  exchangeLine: exchangeLine, reasonFor: reasonFor };
});
