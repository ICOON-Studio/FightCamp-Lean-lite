// OCTAGON v6 (S573): the owner's v2.7 Director's Cut (ops/research/octagon/v27/Octagon_Tactics_v2_7_Directors_Cut_Print_And_Play.pdf,
// text in v27_text.txt) - boxing only: BOX-01..12 + FIQ-01..04 + SYS-01 with HIS numbers. Built SEPARATELY from v5 (owner S572:
// "keep the current version and work seperately on the new rules"); v2.7 replaces v2.6 for this line (he sent it S573).
// His v2.7 rules on: Signature Stance Guard always there, Desperation Surge, the 5-category matrix (Counter v Counter / Counter v
// Defend / Defend v Defend = neutral reset, both +1 stamina), Initiative +2 speed with the non-stacking speed cap, heavy chip,
// Long tax, reactive whiffs free / power counters -2, Economy of Motion, Pocket Armor, Deep Breath only if unhit, [Tell: Color]
// (owner S573: the feint shows the colour of his NEXT card) and [Tell: Name] (Read Tendencies).
// Our cup extras are OFF here (Hold Ground, Range Jab, Elbows Down, Clinch & Hold, rock rules) - his rules are the line.
// CALL = our reading where his card or rule is silent or does not fit the engine.
import { CARDS, PROFILES, TUNE } from './engine.mjs';
import { useV4, POOL, STYLES, profileOf } from './fighters_v4.mjs';

export const V6_CARDS = {
  jab:      { id: 'BOX-01', n: 'Step-In Jab', type: 'A', spd: 8, st: 1, legal: ['long'], pre: 1, zone: 'head', dmg: 2, chain: 1, straight: 1, t: 'Long -> Mid. 2 to the head, claims the Lead on a hit. [Chain +1].' },
  cross3:   { id: 'BOX-02', n: 'Straight Cross', type: 'A', spd: 7, st: 2, legal: ['mid'], zone: 'head', dmg: 3, chain: 1, straight: 1, afterJab: 1, t: 'Mid. 3 to the head, +1 after a Jab (in a combo) or a Double Jab Feint. [Chain +1].' },
  overhand: { id: 'BOX-03', n: 'Overhand Right', type: 'A', spd: 4, st: 3, legal: ['long'], pre: 1, zone: 'head', dmg: 5, t: 'Long -> Mid. HEAVY: 5 to the head; 1 chip + 1 stamina through a block.' },
  lhook3:   { id: 'BOX-04', n: 'Lead Left Hook', type: 'A', spd: 6, st: 2, legal: ['mid', 'close'], zone: 'head', dmg: 4, hook: 1, t: 'Mid or Close. HEAVY: 4 to the head; 1 chip + 1 stamina through a block.' },
  liver3:   { id: 'BOX-05', n: 'Liver Hook', type: 'A', spd: 6, st: 2, legal: ['mid', 'close'], zone: 'body', dmg: 3, hook: 1, capCut: 1, t: 'Mid or Close. 3 to the body; his maximum stamina -1 on a clean hit.' },
  upper3:   { id: 'BOX-06', n: 'Rear Uppercut', type: 'A', spd: 5, st: 2, legal: ['close'], zone: 'head', dmg: 4, hook: 1, t: 'Close. HEAVY: 4 to the head.' },
  slip3:    { id: 'BOX-07', n: 'Slip & Counter Jab', type: 'C', spd: 9, st: 1, legal: ['mid'], dmg: 2, answers: 'mid', reactive: 1, chain: 1, t: 'Mid. REACTIVE counter: answers any attack landing at Mid - it misses, you land 2 and take the Lead. A whiff costs nothing more.' },
  pull3:    { id: 'BOX-08', n: 'Pull Counter Cross', type: 'C', spd: 9, st: 3, legal: ['mid'], dmg: 5, answers: 'mid', t: 'Mid. POWER counter: answers any attack landing at Mid - it misses, you land 5. A whiff or a feint costs 2 stamina more.' },
  lchk:     { id: 'BOX-09', n: 'Check Left Hook', type: 'C', spd: 8, st: 2, legal: ['mid'], dmg: 3, answers: 'advancing', post: -1, reactive: 1, t: 'Mid. REACTIVE counter: answers a man stepping in - it misses, you land 3 and pivot out to Long. A whiff costs nothing more.' },
  twitch:   { id: 'BOX-10', n: 'Shoulder Twitch Feint', type: 'F', spd: 8, st: 0, legal: ['long', 'mid'], cageCut: 1, tell: 'color', t: 'Long or Mid. FEINT: beats a Counter and a Defend - you take the Lead, he is pushed 1 toward the cage, and TELL: next exchange you see the colour of his card before you choose. Loses to an Attack.' },
  djab:     { id: 'BOX-11', n: 'Double Jab Feint', type: 'F', spd: 7, st: 1, legal: ['long'], pre: 1, cageCut: 1, t: 'Long -> Mid. FEINT, steps in safely: beats a Counter and a Defend, he is pushed 1 toward the cage; your next Straight Cross +1. Loses to an Attack.' },
  guard:    { id: 'BOX-12', n: 'High Guard & Shell', type: 'D', spd: 6, st: 0, legal: ['long', 'mid', 'close'], covers: 'any', rec: 1, t: 'Any range. Blocks an attack (a HEAVY one still chips 1 and costs you 1 stamina), +1 stamina; costs 1 at Long. Loses to a Feint.' },
  cutc:     { id: 'FIQ-01', n: 'Cut the Cage', type: 'F', spd: 7, st: 1, legal: ['long'], pre: 1, cageCut: 2, t: 'Long -> Mid. FEINT: beats a Counter and a Defend, he is pushed 2 toward the cage, you take the Lead. Loses to an Attack.' },
  circle3:  { id: 'FIQ-02', n: 'Circle Out & Reset', type: 'D', spd: 8, st: 1, legal: ['close'], covers: 'any', rec: 0, post: -1, cageGain: 2, t: 'Close. Blocks an attack, steps out to Mid, +2 cage space. Loses to a Feint.' },
  read3:    { id: 'FIQ-03', n: 'Read Tendencies', type: 'F', spd: 9, st: 0, legal: ['long', 'mid', 'close'], read: 1, chain: 0, t: 'Any range. FEINT: beats a Counter and a Defend; TELL: you see ONE card of his hand (v6.4, his v2.7 card), draw 1, take the Lead. Loses to an Attack.' },
  breath:   { id: 'FIQ-04', n: 'Deep Breath & Pace', type: 'D', spd: 6, st: 0, legal: ['long', 'mid'], covers: 'none', rec: 3, recUnhit: 1, t: 'Long or Mid. +3 stamina if he does not hit you (it blocks nothing); costs 1 at Long. Loses to a Feint.' },
  stance:   { id: 'SYS-01', n: 'Signature Stance Guard', type: 'D', spd: 5, st: 0, legal: ['long', 'mid', 'close'], covers: 'any', rec: 0, virtual: 1, t: 'ALWAYS THERE (outside your hand): blocks any one attack, head or body (a HEAVY one still chips 1); no stamina back; free the first time in a round, then +1 stamina a use (v6.7; +2 in v6.6); +1 more at Long. Loses to a Feint.' },
};
// 20 cards, at most 2 of a card; every deck keeps at least two Close attacks (cup r12-r13). CALL: the decks are ours (his PDF lists cards, not boxing decks)
export const V6_DECKS = {
  out:     { jab: 2, cross3: 2, lhook3: 1, liver3: 1, slip3: 2, lchk: 2, twitch: 2, djab: 1, guard: 2, circle3: 2, read3: 2, breath: 1 },
  press:   { jab: 1, cross3: 2, overhand: 2, lhook3: 2, liver3: 2, upper3: 2, pull3: 1, twitch: 1, djab: 1, guard: 2, cutc: 2, read3: 1, breath: 1 },
  counter: { jab: 1, cross3: 2, lhook3: 1, liver3: 1, slip3: 2, pull3: 2, lchk: 2, twitch: 2, guard: 2, circle3: 1, read3: 2, breath: 2 },
};
export const deckSize = (d) => Object.values(d).reduce((x, y) => x + y, 0);

export function useV6(opt = {}) {
  useV4();
  Object.assign(CARDS, V6_CARDS);
  for (const st of Object.keys(V6_DECKS)) STYLES[st].deck = () => V6_DECKS[st];
  for (const id of Object.keys(POOL)) PROFILES[id] = profileOf(id);
  Object.assign(TUNE, {
    feintDef: 1, chip: 1, chipPress: 1, longTax: 1, ctrSplit: 1, econ: 1, taxReset: 1, fix572: 1, lead: 2, hp: 1,   // his v2.0 rules kept in v2.7; chipPress = Pocket Armor's +1 chip
    stance: 1, surge: 1, neutral1: 1, capOne: 1, tellColor: 1, pocket: 1, readCards: 1,   /* readCards (S574): his FIQ-03 card shows ONE card - pure and lite showed 2 until S574 (cup r18 E5) */                                    // his v2.7 rules (S573)
    holdCard: 0, longJab: 0, elbows: 0, rockClinch: 0, wallClinch: 0, cover: 0, ctrDuel: 0, pressPre: 0, rockSafe: 0, ctrRefund: 0, openSoft: 0, holdReads: 0, holdParry: 0, feelMeets: 0,   // our cup extras OFF
  });
  const S574 = { gapStop: 2, resetTax: 2, fakeJab: 1, stickMove: 1, circleMid: 1, startLong: 1, featPt: 1, pinLeak: 1, pull4: 1, ctrPt: 1, chkLong: 1, stickCost: 1, resetD: 1, heavyTrade: 1, stopNoStep: 1, circleFeint: 1, comboHalf: 1, roundKeep: 2, holdTwice: 1, ctrCtr: 1 };   /* S575 (cup r21 asks, grid2.txt): roundKeep 2 - a round that ended inside starts the next at Mid, else at Long (John: Pressure could not close at Long; roundKeep 1, keep the range, put Long Night at 41-44); holdTwice - a second Hold Ground in a row does not parry (Kalli); ctrCtr - counter v counter costs both 1 (Claude: a free reset); bots v6.9 45-57%, lite 44-57% */   /* comboHalf (cup r21, Maria + Claude: one cross-hook combo did 10) - the combo's extra punches land at half: v6.9 46-53%, lite 44-57% (grid17.txt) */   /* circleFeint (cup r21): a Defend beaten by a feint does not step out - bots unchanged (grid16.txt) */   /* stopNoStep (cup r20, Claude: a stopped Overhand still walked him Long -> Close): a step-in punch beaten to it by a faster one does not step in - bots 44-55 / 46-57 (grid14.txt) */   /* v6.9 (cup r19): chkLong - the Check Left Hook meets a man stepping in from Long (Kalli: every round opens at Long, the counter-puncher's counters sat dead), stickCost - stick and move costs 1 stamina (Kalli), resetD - only a leader who GUARDED pays the reset tax, a Counter is a read (John), heavyTrade - a heavy punch (4+) lands through a faster straight of 3 or less (Maria: a slow power fighter takes one jab to land one bomb) - bots v6.9 46-55%, lite 44-56% (grid12.txt) */   /* ctrPt (v6.8, balance rating #2: Counter-Puncher 4 from all three seats; John's fix): a clean counter scores 2 with the judges, not 1 - bots unchanged (grid7.txt); slipLong (Kalli) lifted Snapshot to 59 and dropped Iron to 41-43, Ghost's own numbers only moved the weak spot to Long Night (grid8, grid9) */   /* featPt, pinLeak, pull4 (cup r18: Kalli - three won exchanges scored 0-0 behind a guard, the fence earned nothing, one 6-point counter decided the fight): bots unchanged 40-59% (grid6.txt) */   /* startLong (cup r18, Claude v Kalli: the bout opened at Mid, the out-fighter's worst range; his v2.7 names no start range): every round starts at Long - v6.7 41-57%, all three styles ~50%; lite 41-57% (grid5.txt) */
  const pull4 = () => { CARDS.pull3 = { ...CARDS.pull3, t: 'Mid. POWER counter: answers any attack landing at Mid - it misses, you land 4 (S574; his card 5). A whiff or a feint costs 2 stamina more.' }; };
  const chkLong = () => { CARDS.lchk = { ...CARDS.lchk, legal: ['long', 'mid'], t: 'Long or Mid (v6.9). REACTIVE counter: answers a man stepping in - it misses, you land 3 and pivot out to Long. A whiff costs nothing more.' }; };
  const circleMid = () => { CARDS.circle3 = { ...CARDS.circle3, legal: ['mid', 'close'], t: 'Mid or Close (v6.7). Blocks an attack, steps out one range, +2 cage space. Loses to a Feint.' }; };
  /* S574 lite=1 (owner: "focus on balance first then fun and depth also try my version too"): his v2.7 exactly as written plus the
     FEWEST changes that balance it on the bots (pure: Truck 66-70%, Iron 64-67%, out-fighters 32-37%): half the power bonus, the
     Range Jab at Long and Mid (a punch that does not step in; it meets a man stepping in from Long), and the five S574 switches below
     - bots n=200 x 3 seeds 40-58%, finishes 13%. ops/research/octagon/s574/grid4.txt */
  if (opt.lite) { Object.assign(TUNE, { powHalf: 1, longJab: 1, feelMeets: 1, feelMid: 1 }, S574); CARDS.feel = { ...CARDS.feel, legal: ['long', 'mid'], t: 'Always there at Long or Mid: a pawing jab - 1 to the head. Does not step in; it meets a man stepping in from Long.' }; TUNE.stanceTax = 1; TUNE.feelTax = 1; circleMid();   /* feelTax in lite (cup r20, Kalli v Maria: 14 of 18 exchanges were paws or guards at Long - fun 6.5, depth 5.5): a Range Jab straight after your own costs 1 more, as in v6.9 - bots unchanged (grid15.txt) */
   pull4(); chkLong(); CARDS.stance = { ...CARDS.stance, t: 'ALWAYS THERE (outside your hand): blocks any one attack, head or body (a HEAVY one still chips 1); no stamina back (his v2.7 card); free the first time in a round, then +1 a use (S574: all four seats - free every time, a leader stalled a whole round); like every Defend, +1 at Long (his Long Tax). Loses to a Feint.' }; return; }
  if (opt.pure) return;   // pure=1: v2.7 exactly as written - bots: Iron 69-77%, Truck 74%, out-fighters 31-35% (Pressure runs away)
  /* v6.1 (S573, owner: "check if 2.7 is missing anything from the version that rate 7/8 ... and see if you can fix it"): v2.7 lacks
     what the cup added to v5 (7.5-7.75 fun). Measured on the bots, n=20 each (docs/OCTAGON_V6_RESULT.md): Initiative +1 alone 31-68%;
     + the always-there cards 37-67%; + the rocked/pinned man's outs 35-66%; + all of v5's cup fixes 34-62%; Pocket Armor or the
     +1 chip off changed little; HALF THE POWER BONUS was the missing piece (the v2.7 punches are cheaper, so POWER paid every
     exchange): all of it 41-58%, n=40 37-59%, finishes 40% (v5.4: 9%). */
  if (+(opt.feelMid ?? 1)) { TUNE.feelMid = 1; CARDS.feel = { ...CARDS.feel, legal: ['long', 'mid'], t: 'Always there at Long or Mid (v6.2): a pawing jab - 1 to the head, keeps him honest. Does not step in.' }; }   /* v6.2 (cup r14, Kalli + Claude: whole hands with no punch at Mid) */
  /* v6.3 (cup r15 on v6.2: fun 8/7/7/8 = 7.5, depth 7.0; Range Jab + Stance Guard half of all plays - Kalli, John, Claude; the Pressure man never reached Close - John): a Range Jab straight after a Range Jab costs 1 more; a Cut the Cage that beats a Defend walks him to Close - bots 39-57% */
  /* v6.4 (cup r16 on v6.3: fun 7.0, depth 6.75; John + Kalli: two cards shown + the Lead set up a free power counter): Read Tendencies shows ONE card, as his v2.7 card says - bots unchanged (they do not use the read) */
  /* v6.5 STATUSES (owner S573: 'add statuses and debugs like staggered or stunned, keg injured, cut etc' + 'a rocked man should give something up'): STAGGERED (2 under his rock line, or a rock the rules blocked: -1 speed, no stepping in next exchange - the legs), ROCKED +1 to the judges, CUT (his v2.7 Eye Cut, opened by clean STRAIGHT punches of 2+ - the 2nd opens it, each one after widens it; shows one card of his hand every exchange; the doctor stops it at 5), WINDED (body at half: Defends give 1 less back). Bots n=40: heavy cuts (4+) put Truck 60-62%; sharp cuts 2 with the doctor at 3 stopped 39%, at 4 15%, at 5 4% (35-57%), at 7 never */
  /* v6.6 (cup r17 on v6.5: fun 8/7/7/7 = 7.25, depth 7.0): the live judges' score on the screen (Kalli r12, r13, r15, r17) - display only; a Stance Guard repeat costs 2, not 1 (John, Kalli, Maria r17: the man ahead stalled round 3 behind guards) - bots 37-59% */
  Object.assign(TUNE, { liveScore: 1, status: 1, cutSharp: 2, cutStop: 5, readCards: 1, feelTax: +(opt.feelTax ?? 1), cutClose: +(opt.cutClose ?? 1), stanceTax: +(opt.stanceTax ?? 2), lead: 1, powHalf: 1, openSoft: 1, ctrRefund: 1, holdCard: 1, longJab: 1, elbows: 1, holdParry: 1, feelMeets: 1, cover: 1, rockClinch: 1, rockSafe: 1, wallClinch: 1 });
  /* v6.7 (S574, the v6.6 balance rating - all four seats 6/10, Out-Fighter 4): John's 2+ speed faster stops the slower punch (gapStop),
     Kalli's a neutral reset costs the man ahead on the cards 1 stamina (resetTax 2), Maria's a step-in punch that catches a feint lands
     the damage but not the range (fakeJab), and the out-fighter's way out: a landed Step-In Jab steps straight back to Long (stickMove,
     out-fighters only) and Circle Out works at Mid too (circleMid). Bots n=200 x 3 seeds: v6.6 37-60% -> 42-58% (Long Night 37 -> 42,
     Metronome 40 -> 45, Truck 59 -> 54); the reset tax and the feint fix do not move the bots (they never stall or farm feints) -
     those two are for the agents. ops/research/octagon/s574/grid.txt, grid2.txt */
  if (!opt.v66) { Object.assign(TUNE, S574, { cutStop: 6, stanceTax: 1, cutOnce: 1 });   /* cutOnce (cup r20 John, r21 Kalli + John: the cut showed a card every exchange - half his hand open): once, at the start of each round */
   circleMid(); pull4(); chkLong(); }   /* stanceTax 1 (cup r18, Maria: the repeat cost reached 4 by round 3; the stall is now paid by featPt) */   /* cutStop 6 (S574): starting at Long means more jabs, more cuts - the doctor at 5 stopped 12%, at 6 3% (42-56%) */
}
