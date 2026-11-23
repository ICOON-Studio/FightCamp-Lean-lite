/* Five judges, no draws. Punches on damage, defence on clean wins. */
(function (root, factory) {
  if (typeof module === 'object' && module.exports) module.exports = factory;
  if (typeof window !== 'undefined') window.FightCampJudge = factory;
})(typeof globalThis !== 'undefined' ? globalThis : this, function (d) {
'use strict';
var JUDGES = d.JUDGES;
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
    var meDef = (meStats.defencePoints || 0) * (judge.defence || 0.2) + (meStats.defence || 0) * 0.5;
    var foeDef = (foeStats.defencePoints || 0) * (judge.defence || 0.2) + (foeStats.defence || 0) * 0.5;
    var av = (judge.landed * meStats.landed + judge.damage * meStats.damage + judge.aggression * meStats.thrown * 0.15 + meDef) * jitter;
    var bv = (judge.landed * foeStats.landed + judge.damage * foeStats.damage + judge.aggression * foeStats.thrown * 0.15 + foeDef) / (jitter || 1);
    out.push(judgeRound(meStats, foeStats, av, bv));
  }
  return out;
}
function exchangeWins(fight) {
  var p = 0, o = 0;
  fight.events.forEach(function (ev) {
    if (ev.player.dealt > ev.opponent.dealt) p++;
    else if (ev.opponent.dealt > ev.player.dealt) o++;
  });
  return { player: p, opponent: o };
}
function decision(fight) {
  var wins = exchangeWins(fight);
  var totals = JUDGES.map(function (j, i) {
    var me = 0, foe = 0;
    fight.rounds.forEach(function (r) { me += r.scores[i][0]; foe += r.scores[i][1]; });
    if (me === foe) {
      if (wins.player > wins.opponent) foe = Math.max(7, foe - 1);
      else if (wins.opponent > wins.player) me = Math.max(7, me - 1);
      else {
        var dmgP = fight.player.totals.damage, dmgO = fight.opponent.totals.damage;
        if (dmgP > dmgO) foe = Math.max(7, foe - 1);
        else if (dmgO > dmgP) me = Math.max(7, me - 1);
        else foe = Math.max(7, foe - 1);
      }
    }
    return { judge: j.name, player: me, opponent: foe };
  });
  var meCards = totals.filter(function (t) { return t.player > t.opponent; }).length;
  var foeCards = totals.filter(function (t) { return t.opponent > t.player; }).length;
  var winner = meCards > foeCards ? 'player' : 'opponent';
  var line = totals.map(function (t) { return t.player + '-' + t.opponent; }).join(', ');
  fight.result = {
    winner: winner, method: 'decision', round: 3, scorecards: totals, margin: Math.abs(meCards - foeCards),
    text: (winner === 'player' ? 'Your boxer wins on points.' : 'The opponent wins on points.') + ' (' + line + ' on the five cards.)'
  };
  fight.phase = 'over';
  return fight.result;
}
return { judgeRound: judgeRound, scoreRound: scoreRound, decision: decision, exchangeWins: exchangeWins };
});
