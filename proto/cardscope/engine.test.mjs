// CARDSCOPE1 greybox tests: node proto/cardscope/engine.test.mjs
import { EMPTY, JAB, BJAB, CROSS, LHOOK, BHOOK, UPPER, XC, BLOCK, BLOCK_LOW, SLIP, ROLL, STEP, TIE, FEINT, COST, CFG,
  PLAYERS, OPPONENTS, CARDS } from './cards.mjs';
import { resolve, newResult, enumerate, decode, lineCost } from './rules.mjs';
import { playBout } from './bout.mjs';
import { randomBot, fixedBot, greedyBot, readerBot, allSeeingBot } from './bots.mjs';

let failed = 0, count = 0;
const check = (name, ok, extra = '') => { count++; if (!ok) failed++; console.log((ok ? 'PASS ' : 'FAIL ') + name + (ok ? '' : ' ' + extra)); };
const P = () => ({ pow: 0, quick: 0, kd: 99 });
const ex = (a, b, pa = P(), pb = P()) => resolve(a, b, pa, pb, newResult());

let r = ex([CROSS, 0, 0], [0, 0, 0]);
check('a punch into nothing lands clean', r.hB === 6 && r.clA === 1);
r = ex([CROSS, 0, 0], [BLOCK, 0, 0]);
check('a block stops 4: 2 of a cross gets through, no score, credit to the blocker', r.hB === 2 && r.clA === 0 && r.crB === 1);
r = ex([JAB, 0, 0], [BLOCK, 0, 0]);
check('a blocked jab does nothing', r.hB === 0 && r.crB === 1);
r = ex([BHOOK, 0, 0], [BLOCK, 0, 0]);
check('a body hook goes under a high block and takes 1 wind', r.bB === 4 && r.wB === 1);
r = ex([BHOOK, 0, 0], [BLOCK_LOW, 0, 0]);
check('a low block stops the body hook', r.bB === 0 && r.crB === 1);
r = ex([UPPER, 0, 0], [BLOCK, 0, 0]);
check('an uppercut splits the block: 6 of 10 lands and it counts', r.hB === 6 && r.clA === 1 && r.crB === 0);
r = ex([CROSS, 0, 0], [SLIP, CROSS, 0]);
check('slip a straight: it misses, the counter does +4', r.hB === 0 && r.hA === 10 && r.crB === 2);
r = ex([LHOOK, 0, 0], [SLIP, 0, 0]);
check('slip into a hook: it lands +2', r.hB === 8);
r = ex([LHOOK, 0, 0], [ROLL, LHOOK, 0]);
check('roll a hook: it misses, the counter does +4', r.hB === 0 && r.hA === 10);
r = ex([UPPER, 0, 0], [ROLL, 0, 0]);
check('an uppercut catches a roll', r.hB === 12);
r = ex([CROSS, 0, 0], [STEP, 0, 0]);
check('step back: it misses, no credit', r.hB === 0 && r.crB === 0);
r = ex([JAB, 0, 0], [CROSS, 0, 0]);
check('trade: the faster punch lands clean, the slower loses 2', r.hB === 2 && r.hA === 4);
r = ex([CROSS, 0, 0], [LHOOK, 0, 0]);
check('trade at the same speed: both land', r.hB === 6 && r.hA === 6);
r = ex([CROSS, 0, 0], [LHOOK, 0, 0], { pow: 0, quick: 1, kd: 99 }, P());
check('quick hands win a trade at the same speed', r.hB === 6 && r.hA === 4);
r = ex([JAB, CROSS, 0], [0, 0, 0]);
check('one-two: the cross does +4', r.hB === 2 + 10);
r = ex([JAB, CROSS, LHOOK], [0, 0, 0], P(), P());
check('one-two-hook: +4 then +6', r.hB === 2 + 10 + 12);
r = ex([BHOOK, LHOOK, 0], [0, 0, 0]);
check('body then head: the hook does +4', r.bB === 4 && r.hB === 10);
r = ex([JAB, CROSS, 0], [BLOCK, 0, 0]);
check('a blocked jab ends the chain', r.hB === 6);
r = ex([FEINT, CROSS, 0], [BLOCK, BLOCK, 0]);
check('a feint draws the guard: the next guard fails, +4', r.hB === 10 && r.clA === 1);
r = ex([FEINT, 0, 0], [CROSS, 0, 0]);
check('a feint against a punch: you are hit', r.hA === 6);
r = ex([XC, 0, 0], [JAB, 0, 0]);
check('cross counter beats a straight for 6', r.hB === 6 && r.hA === 0 && r.crA === 2);
r = ex([XC, 0, 0], [LHOOK, 0, 0]);
check('cross counter against a hook is a slow cross', r.hB === 4 && r.hA === 6);
r = ex([TIE, 0, 0], [CROSS, LHOOK, 0]);
check('tie up smothers this beat and softens the next', r.hA === 2);
r = ex([TIE, 0, 0], [UPPER, 0, 0]);
check('an uppercut lands on a tie-up', r.hA === 10);
r = ex([0, 0, 0], [0, 0, 0]);
check('three empty beats give 3 wind and count as blanks', r.wA === 3 && r.blank === 3);
r = ex([JAB, CROSS, LHOOK], [0, 0, 0], P(), { pow: 0, quick: 0, kd: 12 });
check('a knockdown ends the exchange', r.kdB === 1 && r.beats === 2 && r.hB === 12);

const keys = new Int32Array(4096), c = [0, 0, 0];
let n = enumerate([JAB, CROSS, BLOCK, TIE, UPPER], 3, true, keys), ok = true, sawLow = false;
for (let i = 0; i < n; i++) { decode(keys[i], c); if (lineCost(c) > 3) ok = false; if (c.includes(BLOCK_LOW)) sawLow = true; if (c.filter((x) => x === JAB).length > 1) ok = false; }
check('every listed answer is affordable and uses each card once; block can go low', ok && sawLow && n > 10, 'n=' + n);
n = enumerate([TIE, JAB], 5, false, keys); ok = true;
for (let i = 0; i < n; i++) { decode(keys[i], c); if (c.includes(TIE)) ok = false; }
check('tie up is off the table once used in the round', ok);

const bots = [() => randomBot(5), () => fixedBot([BLOCK, JAB, CROSS]), () => greedyBot(5), () => readerBot({ seed: 5 }), () => allSeeingBot(5)];
let legal = true, why = '';
try { for (const mk of bots) for (let s = 1; s <= 12; s++) for (const tier of [1, 3, 5]) playBout(PLAYERS[s % 4], OPPONENTS[(s + 1) % 4], mk(), { seed: s, tier, check: true }); }
catch (e) { legal = false; why = e.message; }
check('every bot and the opponent only play legal lines (5 bots x 36 bouts)', legal, why);
const a = playBout(PLAYERS[0], OPPONENTS[1], readerBot({ seed: 9 }), { seed: 77 });
const b = playBout(PLAYERS[0], OPPONENTS[1], readerBot({ seed: 9 }), { seed: 77 });
check('same seed, same bout', JSON.stringify(a.cards) === JSON.stringify(b.cards) && a.win === b.win && a.headO === b.headO);
let draws = 0, bad = 0;
for (let s = 1; s <= 200; s++) {
  const st = playBout(PLAYERS[s % 4], OPPONENTS[(s >> 2) % 4], greedyBot(s), { seed: s });
  if (st.win !== 0 && st.win !== 1) draws++;
  if (st.method === 'pts') for (const cd of st.cards) if (cd[0] + cd[1] < 3 * 18 || cd[0] + cd[1] > 3 * 19) bad++;
}
check('no drawn bouts; every round scored 10-9 or 10-8', draws === 0 && bad === 0);
check('thirteen cards, all with a cost', CARDS.length === 13 && CARDS.every((k) => COST[k] >= 0));
console.log(failed ? `RESULT: FAIL - ${failed} of ${count} checks` : `RESULT: PASS - all ${count} checks green`);
process.exit(failed ? 1 : 0);
