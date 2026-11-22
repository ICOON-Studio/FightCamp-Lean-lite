// CARDSCOPE3 greybox checks. node proto/cardscope3/engine.test.mjs
import { N, CARDS, PLAYERS, OPPS, CLASSES, NEUTRAL, guardEffect, deckLegal } from './cards.mjs';
import { bout, resolveIncoming, applyTurn, beginTurn, newBoxer, rng, judgePts } from './engine.mjs';
import { planner, opponent, guardSets, attacks } from './plan.mjs';
import { randomBot, beginnerBot, fixedBot } from './bots.mjs';

let n = 0, bad = 0;
const ok = (c, m) => { n++; if (!c) { bad++; console.log('FAIL - ' + m); } };
const mk = (hand0, hand1, inc = []) => {
  const r = rng(1), S = { b: [newBoxer({ name: 'a', deck: NEUTRAL }, r), newBoxer({ name: 'b', deck: NEUTRAL }, r)], inc, r, sprung: false, fresh: false, lastDmg: [0, 0],
    st: { volleys: 0, blankVolleys: 0, stopped: 0, thrown: 0, kds: 0, cardsPlayed: 0, deadTraps: 0, sets: [0, 0] } };
  S.over = () => S.b.some((B) => B.head >= B.headMax || B.kd >= 3);
  S.b[0].hand = hand0.slice(); S.b[1].hand = hand1.slice(); S.b[0].wind = S.b[1].wind = 6; return S;
};
const P = (id, bonus = 0) => ({ id, bonus });

// what a guard does
ok(guardEffect('slip', 'cross') === 'evade' && guardEffect('slip', 'hook') === null, 'a slip beats straight punches only');
ok(guardEffect('roll', 'hook') === 'evade' && guardEffect('roll', 'jab') === null, 'a roll beats hooks only');
ok(guardEffect('slip', 'upper') === 'evade' && guardEffect('roll', 'upper') === 'evade', 'the uppercut is slow: both evades beat it');
ok(guardEffect('parry', 'jab') === 'parry' && guardEffect('parry', 'bodyjab') === 'parry' && guardEffect('parry', 'cross') === null, 'a parry stops jabs only');
// the volley lands
let S = mk([], [], [P('jab'), P('cross'), P('hook')]);
let r = resolveIncoming(S, 0, [null, null, null], false);
ok(r.head === 2 + 6 + N.chain + 6 + N.chain && r.clean === 3, 'three clean punches chain: 2, 8, 8');
r = resolveIncoming(S, 0, ['parry', null, null], false);
ok(r.head === 6 + 6 + N.chain && r.clean === 2, 'a stopped jab breaks the chain to the cross');
r = resolveIncoming(S, 0, [null, 'block', null], false);
ok(r.head === 2 + (6 + N.chain - N.block) + 6 && r.clean === 2 && r.ctr === N.blockCtr, 'a blocked cross leaks, is not clean, and breaks the chain');
r = resolveIncoming(S, 0, [null, 'slip', null], false);
ok(r.head === 2 + 6 && r.evades === 1 && r.ctr === N.counter, 'a slipped cross misses and earns the counter');
S = mk([], [], [P('upper')]);
ok(resolveIncoming(S, 0, ['block'], false).head === 9 - N.splitBlock, 'the uppercut splits a block');
ok(resolveIncoming(S, 0, [null], true).head === 4, 'a tie up halves it');
S = mk([], [], [P('jab'), P('cross'), P('hook'), P('cross')]);
ok(resolveIncoming(S, 0, [null, null, null, null], false).kd === true, 'a big volley is a knockdown');
S = mk([], [], [P('bodyhook')]);
r = resolveIncoming(S, 0, [null], false);
ok(r.body === 4 && r.head === 0 && r.drain === 1, 'a body hook goes to the body and takes wind');
// one guard a turn
S = mk(['block', 'slip', 'parry', 'jab', 'cross'], [], [P('jab'), P('cross')]);
ok(guardSets(S, 0).every((g) => g.marks.filter((x) => x && x !== 'parry').length <= 1), 'one guard a turn (the parry is free of it)');
let threw = false; try { applyTurn(S, 0, { marks: ['block', 'slip'], tie: false, seq: [], set: null }, false); } catch (e) { threw = true; }
ok(threw, 'the engine refuses two guards');
// traps
S = mk(['jab', 'cross'], ['checkhook'], []); S.b[1].set = 'checkhook'; S.b[1].hand = [];
let o = applyTurn(S, 0, { marks: [], tie: false, seq: ['jab', 'cross'], set: null }, false);
ok(o.sprung === 'checkhook' && S.b[0].head === CARDS.checkhook.dmg && S.inc.length === 1 && S.inc[0].id === 'cross' && S.b[1].set === null, 'a jab that leads walks onto the check hook; the cross still goes');
S = mk(['cross', 'jab'], [], []); S.b[1].set = 'checkhook';
o = applyTurn(S, 0, { marks: [], tie: false, seq: ['cross', 'jab'], set: null }, false);
ok(!o.sprung && S.inc.length === 2 && S.b[1].set === 'checkhook', 'a trap only catches the punch that leads');
beginTurn(S, 1, false);
ok(S.b[1].set === null && S.b[1].hand.includes('checkhook'), 'a trap nothing walked onto comes back to the hand');
S = mk(['xcounter', 'jab'], [], []);
applyTurn(S, 0, { marks: [], tie: false, seq: ['jab'], set: 'xcounter' }, false);
ok(S.b[0].set === 'xcounter' && S.b[0].wind === 6 - 1 - N.trapCost, 'setting a trap costs ' + N.trapCost);
// the counter rides on the first punch
S = mk(['slip', 'cross'], [], [P('cross')]);
applyTurn(S, 0, { marks: ['slip'], tie: false, seq: ['cross'], set: null }, false);
ok(S.inc[0].bonus === N.counter, 'slip, then the cross is a counter');
// knocked down: no volley
S = mk(['cross'], [], [P('jab'), P('cross'), P('hook'), P('cross')]);
o = applyTurn(S, 0, { marks: [null, null, null, null], tie: false, seq: ['cross'], set: null }, false);
ok(o.res.kd && S.inc.length === 0 && S.b[0].hand.includes('cross') && S.b[0].down, 'a floored boxer throws nothing that turn');
// plans
ok(attacks(['jab', 'jab', 'cross', 'block', 'checkhook'], 3).every((a) => a.cost <= 3), 'no volley over the wind');
ok(judgePts({ clean: 2, thrown: 4, dmg: 10, craft: 3 }, 'work') === 6 && judgePts({ clean: 2, thrown: 4, dmg: 10, craft: 3 }, 'hurt') === 6 && judgePts({ clean: 2, thrown: 4, dmg: 10, craft: 3 }, 'craft') === 7, 'the three judges count as written');
ok(deckLegal(NEUTRAL) && !deckLegal([...NEUTRAL, 'checkhook', 'checkhook', 'checkhook']) && !deckLegal(NEUTRAL.slice(0, 11)), 'deck rules: 12 to 16, two of a trap');
ok([...PLAYERS, ...OPPS].every((b) => deckLegal(b.deck)), 'every boxer has a legal deck');
ok(PLAYERS.every((p) => OPPS.every((q) => p.deck.join() !== q.deck.join())), 'never the same boxer on both sides');
// whole bouts: legal, seeded, never drawn
const bots = [randomBot, beginnerBot, () => fixedBot(['block', 'jab', 'cross', 'checkhook']), () => planner('greedy'), () => planner('table'), () => planner('reader'), () => planner('see')];
let legal = true, wins = [0, 0], first = [0, 0];
for (let i = 0; i < 280; i++) {
  const c = CLASSES[1 + (i % 5)];
  try { const b = bout(PLAYERS[i % 4], OPPS[(i >> 2) % 4], [bots[i % 7](), opponent(c)], 5000 + i, { cls: c, rounds: c.rounds }); wins[b.win]++; first[b.firstR1]++; if (b.win !== 0 && b.win !== 1) legal = false; } catch (e) { legal = false; console.log(e.message); }
}
ok(legal, '280 bouts of every bot against every class play out legally with a winner');
ok(first[0] > 90 && first[1] > 90, 'the coin for who throws first falls both ways');
const a = bout(PLAYERS[0], OPPS[1], [planner('reader'), opponent(CLASSES[3])], 42, { cls: CLASSES[3] }), b = bout(PLAYERS[0], OPPS[1], [planner('reader'), opponent(CLASSES[3])], 42, { cls: CLASSES[3] });
ok(a.win === b.win && a.dealt === b.dealt && a.st.dec === b.st.dec, 'same seed, same bout');
ok(a.st.dec >= 15 && a.st.dec <= 60, 'a bout is tens of decisions, not hundreds');
console.log(bad ? `RESULT: FAIL - ${bad} of ${n} checks failed` : `RESULT: PASS - all ${n} checks green`);
process.exit(bad ? 1 : 0);
