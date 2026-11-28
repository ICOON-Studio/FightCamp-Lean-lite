// OCTAGON v5 (S572): the owner's v2.0 rulebook + his v2 52-card database (ops/research/octagon/Octagon_Tactics_v2_52_Card_Database.csv,
// ops/research/octagon/Octagon_Tactics_v2_Rulebook_And_Cards.pdf). The boxing cards (BOX-01..12) + the standing Fight IQ cards
// (UNI-03..06) with HIS numbers, on the v4.9 engine (attributes, weight classes, the cup's always-there cards: Range Jab, Hold
// Ground, Elbows Down, Cover Up, Clinch & Hold) + his v2.0 rules: Feint beats a passive Defend, heavy (4+) chip + 1 stamina
// through a block, a stationary Defend at Long costs 1, reactive counters whiff for free / power counters lose 2, the
// Counter-Puncher's Economy of Motion, the Pressure Brawler's +1 speed stepping in, the Initiative +2 speed.
// Engine ids are kept where the card is the same move, so the bots and the cup tools work unchanged. CALL = our reading.
import { CARDS, PROFILES, TUNE } from './engine.mjs';
import { useV4, POOL, STYLES, profileOf } from './fighters_v4.mjs';

export const V5_CARDS = {
  jab:      { id: 'BOX-01', n: 'Step-In Jab', type: 'A', spd: 8, st: 2, legal: ['long'], pre: 1, zone: 'head', dmg: 2, chain: 1, straight: 1, t: 'Long -> Mid. 2 to the head. [Chain +1]. Claims the Lead on a hit.' },
  snap:     { id: 'BOX-02', n: 'Stiff Flicker Jab', type: 'A', spd: 9, st: 1, legal: ['long', 'mid'], zone: 'head', dmg: 1, chain: 1, straight: 1, t: 'Long or Mid. The fastest poke: 1 to the head, claims the Lead. [Chain +1].' },
  cross3:   { id: 'BOX-03', n: 'Straight Cross', type: 'A', spd: 6, st: 3, legal: ['mid'], zone: 'head', dmg: 3, chain: 1, straight: 1, leadDmg: 1, t: 'Mid. 3 to the head, +1 while you hold the Lead. [Chain +1].' },
  overhand: { id: 'BOX-04', n: 'Overhand Right', type: 'A', spd: 4, st: 4, legal: ['long'], pre: 1, zone: 'head', dmg: 5, t: 'Long -> Mid. HEAVY: 5 to the head; through a block it still chips 1 and costs him 1 stamina.' },
  lchk:     { id: 'BOX-05', n: 'Lead Check Hook', type: 'C', spd: 7, st: 2, legal: ['mid', 'close'], dmg: 3, answers: 'advancing', post: -1, reactive: 1, t: 'Mid or Close. REACTIVE counter: answers a man stepping in - it misses, you land 3 and step back a range. A whiff costs you nothing but the Lead.' },
  liver3:   { id: 'BOX-06', n: 'Left Hook to Liver', type: 'A', spd: 5, st: 3, legal: ['mid', 'close'], zone: 'body', dmg: 4, hook: 1, chain: 1, capCut: 2, t: 'Mid or Close. HEAVY: 4 to the body; his maximum stamina -2 on a clean hit. [Chain +1].' },
  upper3:   { id: 'BOX-07', n: 'Short Uppercut', type: 'A', spd: 6, st: 3, legal: ['close'], zone: 'head', dmg: 4, hook: 1, t: 'Close. HEAVY: 4 to the head.' },
  slip3:    { id: 'BOX-08', n: 'Slip & Counter Cross', type: 'C', spd: 8, st: 2, legal: ['mid'], dmg: 3, answers: 'mid', reactive: 1, t: 'Mid. REACTIVE counter: answers any attack landing at Mid - it misses, you land 3 and take the Lead. A whiff costs you nothing but the Lead.' },
  pull3:    { id: 'BOX-09', n: 'Pull Counter Right', type: 'C', spd: 6, st: 4, legal: ['mid'], dmg: 6, answers: 'mid', t: 'Mid. POWER counter: answers any attack landing at Mid - it misses, you land 6 and take the Lead. A whiff or a feint costs 2 stamina more.' },
  srf:      { id: 'BOX-10', n: 'Shoulder Feint & Level Shift', type: 'F', spd: 7, st: 1, legal: ['long', 'mid'], pre: 1, cageCut: 1, buffSpd: 1, chain: 1, t: 'Long or Mid. FEINT, steps in a range: beats a Counter and a Defend (he is pushed 1 toward the cage), you take the Lead and +1 speed next exchange. Loses to an Attack.' },
  guard:    { id: 'BOX-11', n: 'Tight High Guard', type: 'D', spd: 8, st: 0, legal: ['long', 'mid', 'close'], covers: 'any', rec: 2, t: 'Any range. Blocks an attack (a HEAVY one still chips 1 and costs you 1 stamina), +2 stamina; costs 1 at Long. Loses to a Feint.' },
  philly:   { id: 'BOX-12', n: 'Philly Shell Roll', type: 'D', spd: 7, st: 1, legal: ['mid', 'close'], covers: 'any', rec: 1, t: 'Mid or Close. Blocks an attack, +1 stamina. Loses to a Feint. (CALL: his +2 speed on your next Counter is not built yet.)' },
  cutc:     { id: 'UNI-03', n: 'Cut Off the Cage', type: 'F', spd: 7, st: 1, legal: ['long', 'mid'], pre: 1, cageCut: 2, t: 'Long or Mid. FEINT, steps in a range: beats a Counter and a Defend, he is pushed 2 toward the cage, you take the Lead. Loses to an Attack.' },
  circle3:  { id: 'UNI-04', n: 'Circle Out & Reset', type: 'D', spd: 8, st: 1, legal: ['mid', 'close'], covers: 'any', rec: 0, post: -1, cageGain: 1, t: 'Mid or Close. Blocks an attack, steps out a range, +1 cage space. Loses to a Feint.' },
  read3:    { id: 'UNI-05', n: 'Read Tendencies', type: 'F', spd: 8, st: 1, legal: ['long', 'mid', 'close'], read: 1, buffSpd: 2, chain: 1, t: 'Any range. FEINT: beats a Counter and a Defend; see 2 of his cards, draw 1, +2 speed next exchange. Loses to an Attack.' },
  breath:   { id: 'UNI-06', n: 'Second Wind Breathing', type: 'D', spd: 6, st: 0, legal: ['long', 'mid', 'close'], covers: 'any', rec: 4, t: 'Any range. Blocks an attack, +4 stamina; costs 1 at Long. Loses to a Feint.' },
};
// 20 cards, at most 2 of a card (his rulebook s1)
export const V5_DECKS = {
  out:     { jab: 2, snap: 2, cross3: 2, liver3: 1, lchk: 2, slip3: 2, pull3: 1, srf: 2, guard: 2, circle3: 2, read3: 1, breath: 1 },
  press:   { jab: 1, snap: 2, cross3: 2, overhand: 2, liver3: 2, upper3: 2, lchk: 1, pull3: 1, srf: 1, guard: 2, cutc: 2, read3: 1, breath: 1 },
  counter: { snap: 2, cross3: 2, liver3: 1, lchk: 2, slip3: 2, pull3: 2, srf: 2, guard: 1, philly: 2, circle3: 1, read3: 1, jab: 1, cutc: 1 },
};
export const deckSize = (d) => Object.values(d).reduce((x, y) => x + y, 0);

export function useV5() {
  useV4();
  Object.assign(CARDS, V5_CARDS);
  for (const st of Object.keys(V5_DECKS)) STYLES[st].deck = () => V5_DECKS[st];
  for (const id of Object.keys(POOL)) PROFILES[id] = profileOf(id);
  // the v2.0 rules (each a switch in engine.mjs TUNE; v4.8 holdReads is replaced by feintDef, whiff1 by ctrSplit)
  Object.assign(TUNE, { feintDef: 1, chip: 1, longTax: 1, ctrSplit: 1, econ: 1, pressPre: 1, chipPress: 0, taxReset: 1, holdReads: 0, buffOne: 0, lead: 1, hp: 1, rockSafe: 1, ctrRefund: 1, openSoft: 1, fix572: 1, wallClinch: 1 });   /* v5.4 (S573, cup r13 fun 7/8/8/7 = 7.5, all four seats: a pinned or spent man had no real choice): Clinch & Hold also at cage space 0 or under 3 stamina, once a round, 1 stamina, the referee breaks to Mid - bots 41-58% */   /* v5.3 (cup r12 on v5.2: fun 7/8/7/8 = 7.5, depth 7.0): a free reactive whiff gives up the Lead as its text says; a feint battle pushes nobody - bots 40-58% */   /* v5.2 (cup r11 on v5.1: fun 8/8/7/8 = 7.75, depth 7.25; John, Maria, Kalli: a first-exchange counter that rocks decides a round blind): no rock on a round's first exchange - bots 41-58%, rocks 0.63 -> 0.57 a bout */   /* v5.1 (cup r10 on v5: fun 7/8/7/7 = 7.25, depth 7.0 - Maria: a rocked man's Cover Up is safe from a feint, a clean counter gives 1 stamina back) - bots 40-57%, finishes 10%; powHalf + feintBase measured (42-57%, finishes 5%) and left off: only Claude asked */   /* bots n=40 (pool_v5d): 41-56%, finishes 10%. CALLS v his book, measured: Initiative +1 not +2, health x1.0 (v4.5 had 1.25), the Brawler's extra chip off - with them the Pressure men won 57-64% */
}
