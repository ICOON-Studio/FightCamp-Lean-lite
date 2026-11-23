// CARDSCOPE5 greybox: every number, card and deck. Six arts on one strip (KICK - PUNCH - CLINCH - GROUND). Plain node.
import fs from 'node:fs';
export const N = {
  mode: 'wind', // round 4 decided: one wind pool (the limb arms stay in the code and are not re-run)
  hp: 30, cap: 6, back: 3, heldBack: 2, tighten: 1, start: 4, stool: 2, hand: 5, turns: 5, rounds: 2,
  lead: 8, counter: 3, block: 4, cover: 2, tiein: 3, coverW: 1, stepW: 1, pullW: 1, standW: 1, upW: 3, cycle: 1, redraw: 1, drainCap: 1,
  comboDmg: 5, comboPts: 2, catchPts: 2, headlockPts: 1, dmgPer: 5, stallMax: 2, copies: 3, own: 12,
  clkPts: 1, clkHold: 1, holdRoll: 0, // clocks (P2) and the hidden-roll control arm (P5)
};
// limbs: a lead arm, A rear arm, l lead leg, L rear leg, h hips; x any arm, y any leg
const K = ['K'], P = ['P'], C = ['C'], PC = ['P', 'C'], KP = ['K', 'P'];
const S = (n, st, w, L, at, dmg, zone, x = {}) => ({ n, st, k: 'strike', w, L, at, dmg, zone, ...x });
const T = (n, st, w, L, at, to, pts, x = {}) => ({ n, st, k: 'shot', w, L, at, to, pts, ...x });
const H = (n, st, w, L, at, count, hk, x = {}) => ({ n, st, k: 'hold', w, L, at, count, hk, ...x });
const A = (n, st, w, L, fx, vs, x = {}) => ({ n, st, k: 'ans', w, L, fx, vs, ...x });
export const CARDS = {
  // shared core: two Sprawls and one Escape in every deck
  sprawl: A('Sprawl', 'core', 1, 'hL', 'sprawl', 'a takedown or a grip'),
  escape: A('Escape', 'core', 1, 'h', 'escape', 'a hold or a pass as it is laid; played in your turn: stand up', { act: 'standup' }),
  // boxing: owns PUNCH. own mechanic: combinations (the jab steps in from KICK by itself; a punch laid behind a punch
  // costs 1 less; the short punches - hook, body hook, uppercut - also work inside, in the CLINCH; jab, cross, hook
  // clean in order = the finisher)
  jab: S('Jab', 'boxing', 1, 'a', P, 2, 'head', { enter: 1 }),
  cross: S('Cross', 'boxing', 2, 'A', P, 5, 'head', { pts: 1 }),
  hook: S('Lead hook', 'boxing', 2, 'hl', P, 5, 'head', { pts: 1, inside: 1 }),
  bodyhook: S('Body hook', 'boxing', 2, 'ah', P, 3, 'body', { drain: 1, inside: 1 }),
  upper: S('Uppercut', 'boxing', 3, 'Ah', P, 7, 'head', { pts: 1, unblock: 1, inside: 1 }),
  slip: A('Slip', 'boxing', 2, 'h', 'slip', 'a punch: it misses, your next punch +4'),
  block: A('Block', 'boxing', 1, 'x', 'block', 'a strike: 6 off'),
  // kickboxing (owner S538): stands and trades across KICK, PUNCH and CLINCH; no takedowns, no ground. own mechanic:
  // hands and feet (his kicks land from PUNCH range too and he stays there to trade; a strike of another kind than his
  // last - kick, punch, knee - costs 1 less and carries him in by itself: a punch behind a kick steps in to PUNCH, the
  // knee behind a punch takes the CLINCH). The low kick hurts the leg: 1 wind, and his steps cost 1 more that turn
  onetwo: S('One-two', 'kickboxing', 2, 'aA', P, 4, 'head', { pts: 1 }),
  kbhook: S('Left hook', 'kickboxing', 2, 'hl', P, 4, 'head'),
  lowkick: S('Low kick', 'kickboxing', 1, 'L', KP, 2, 'leg', { kick: 1, cripple: 1 }),
  bodykick: S('Body kick', 'kickboxing', 2, 'Lh', K, 4, 'body', { kick: 1, pts: 1 }),
  highkick: S('High kick', 'kickboxing', 3, 'Lh', K, 6, 'head', { kick: 1, pts: 2 }),
  knee: S('Knee', 'kickboxing', 2, 'lh', C, 5, 'body', { pts: 1, kneeC: 1 }),
  check: A('Check', 'kickboxing', 1, 'y', 'check', 'a kick: it misses, your next strike +counter'),
  // karate: owns KICK. own mechanic: in-and-out (the punch blitzes in from KICK, a kick thrown from PUNCH springs back
  // out, a strike that changes the range costs 1 less, a volley that is not stopped ends back at KICK)
  frontkick: S('Front kick', 'karate', 1, 'l', K, 2, 'body', { kick: 1, pts: 1 }),
  roundhouse: S('Roundhouse', 'karate', 2, 'Lh', K, 4, 'body', { kick: 1, pts: 2 }),
  headkick: S('Head kick', 'karate', 3, 'Lh', K, 6, 'head', { kick: 1, pts: 3, drain: 1 }),
  legkick: S('Leg kick', 'karate', 1, 'L', KP, 2, 'leg', { kick: 1, cripple: 1 }),
  revpunch: S('Reverse punch', 'karate', 2, 'A', P, 4, 'head', { pts: 1, blitz: 1 }),
  evade: A('Step off', 'karate', 2, 'y', 'evade', 'a strike, or a takedown that is not clean: it misses and you are back at KICK'),
  // judo: owns CLINCH. own mechanic: the grip (no throw without it; a grip that has stood a turn makes the throw unstoppable)
  grip: { n: 'Grip', st: 'judo', k: 'setup', w: 1, L: 'aA', at: PC },
  hipthrow: T('Hip throw', 'judo', 2, 'hL', C, 2, 4, { dmg: 3, needGrip: 1 }),
  footsweep: T('Foot sweep', 'judo', 1, 'l', C, 1, 2, { needGrip: 1 }),
  shoulderthrow: T('Shoulder throw', 'judo', 3, 'aAh', C, 2, 6, { dmg: 4, needGrip: 1 }),
  pin: H('Hold-down', 'judo', 2, 'aAh', ['T1', 'T2', 'T3'], 2, 'pin', { hpts: 2, tick: 2, brk: 5 }),
  armlock: H('Armlock', 'judo', 2, 'aA', ['T2', 'T3'], 2, 'sub', { brk: 6 }),
  tiein: A('Tie in', 'judo', 1, 'x', 'tiein', 'a strike: 1 off and you are in the CLINCH'),
  // wrestling: decides where the bout is. own mechanic: chain wrestling (his shot travels from any standing range; a
  // stuffed shot leaves him tied up in the CLINCH and his next shot cannot be stopped)
  double: T('Double leg', 'wrestling', 2, 'aALh', C, 1, 2, { cleanIf: 'tie' }),
  single: T('Single leg', 'wrestling', 1, 'aAl', C, 0, 2, { cleanIf: 'tie' }),
  slam: T('Body lock slam', 'wrestling', 3, 'aAhL', C, 2, 4, { dmg: 4, cleanIf: 'tie' }),
  gnp: S('Ground strikes', 'wrestling', 2, 'A', ['T'], 4, 'head', { pts: 1 }),
  fall: H('The fall', 'wrestling', 2, 'aAh', ['T1', 'T2', 'T3'], 2, 'pin', { hpts: 4, tick: 1, brk: 6 }),
  ride: { n: 'Ride', st: 'wrestling', k: 'adv', w: 1, L: 'h', at: ['T'], pts: 1 },
  headlock: A('Front headlock', 'wrestling', 1, 'hL', 'headlock', 'a takedown: it is stuffed'),
  // bjj: owns GROUND, on top and underneath. own mechanic: the guard (Pull guard is his own step from PUNCH or CLINCH;
  // his holds and sweeps work from underneath, at once behind the pull)
  sweep: T('Sweep', 'bjj', 2, 'lLh', ['B0', 'B1'], 1, 2, { sweep: 1 }),
  pass: { n: 'Guard pass', st: 'bjj', k: 'adv', w: 2, L: 'aAh', at: ['T0', 'T1', 'T2'], pts: 2 },
  triangle: H('Triangle', 'bjj', 2, 'lLh', ['B0'], 3, 'sub', { brk: 6 }),
  armbar: H('Armbar', 'bjj', 2, 'aAh', ['B0', 'T2', 'T3'], 2, 'sub', { brk: 6 }),
  choke: H('Rear choke', 'bjj', 2, 'aA', ['T3'], 1, 'sub', { brk: 7 }),
  kimura: H('Kimura', 'bjj', 2, 'aA', ['B1', 'T1', 'T2'], 2, 'sub', { brk: 5 }),
  // sambo: punch, throw, lock in one go. own mechanic: punch-to-throw-to-lock (his throw goes from PUNCH range, off
  // the exchange; laid right behind his own punch it cannot be stopped; and his hold may be laid in the same volley
  // right behind the throw; everybody else throws from the CLINCH and waits a turn with the hold)
  sthrow: T('Sambo throw', 'sambo', 2, 'aAh', C, 0, 3, { dmg: 2 }),
  trip: T('Leg trip', 'sambo', 1, 'l', C, 0, 1),
  kneebar: H('Knee bar', 'sambo', 2, 'aAl', ['G'], 2, 'sub', { leg: 1, brk: 6 }),
  anklelock: H('Ankle lock', 'sambo', 1, 'aA', ['G'], 3, 'sub', { leg: 1, brk: 5 }),
  casualpin: H('Chest hold', 'sambo', 2, 'aAh', ['T'], 2, 'pin', { hpts: 2, tick: 1, brk: 4 }),
  overhand: S('Overhand', 'sambo', 2, 'A', P, 5, 'head', { pts: 1 }),
  catchkick: A('Catch the kick', 'sambo', 1, 'x', 'catch', 'a kick: it misses and he is taken down'),
};
// Round 5 sizing: sized.json holds the numbers tune.mjs found on sizing seeds (300000 and up; real-sport points pinned).
// They overwrite the first-draft numbers written on the cards above; report.mjs prints the table as sized.
const SZ = new URL('./sized.json', import.meta.url);
export const SIZED = fs.existsSync(SZ) ? JSON.parse(fs.readFileSync(SZ, 'utf8')) : {};
export const FLOOR = { '@in': 'Step in', '@out': 'Step out', '@stand': 'Let him up', '@up': 'Get up', '@cover': 'Cover up', '@break': 'Break free', '@pull': 'Pull guard' };
const d = (o) => Object.entries(o).flatMap(([k, n]) => Array(n).fill(k));
const CORE = { sprawl: 2, escape: 1 };
export const OWN = {
  boxing: { jab: 3, cross: 2, hook: 2, bodyhook: 1, upper: 1, slip: 1, block: 2 },
  kickboxing: { onetwo: 2, kbhook: 2, lowkick: 2, bodykick: 2, highkick: 1, knee: 2, check: 1 },
  karate: { frontkick: 2, roundhouse: 2, headkick: 2, legkick: 1, revpunch: 3, evade: 2 },
  judo: { grip: 3, hipthrow: 2, footsweep: 2, shoulderthrow: 1, pin: 2, armlock: 1, tiein: 1 },
  wrestling: { double: 2, single: 2, slam: 1, gnp: 2, fall: 1, ride: 2, headlock: 2 },
  bjj: { sweep: 3, pass: 2, triangle: 2, armbar: 2, choke: 1, kimura: 2 },
  sambo: { sthrow: 2, trip: 2, kneebar: 2, anklelock: 1, casualpin: 1, overhand: 3, catchkick: 1 },
};
// a key is a number of N (hp), of a card (cross.dmg) or a count in a style deck (own.sambo.overhand)
export function size(k, v) { const q = k.split('.'); if (q[0] === 'own') OWN[q[1]][q[2]] = v; else if (q[1]) CARDS[q[0]][q[1]] = v; else N[k] = v; }
for (const [k, v] of Object.entries(SIZED)) size(k, v);
export const STYLES = Object.keys(OWN);
export const fighter = (style, x = {}) => ({ name: style, style, deck: d({ ...OWN[style], ...CORE }), mech: true, ...x });
// round 3's failure, re-run: the cheapest legal decks (fixed 15, at most 3 of a card)
export const CHEAP = {
  boxing: { name: 'cheap boxing', style: 'boxing', mech: true, deck: d({ jab: 3, bodyhook: 3, block: 3, cross: 3, ...CORE }) },
  karate: { name: 'cheap karate', style: 'karate', mech: true, deck: d({ frontkick: 3, legkick: 3, evade: 3, revpunch: 3, ...CORE }) },
  mix: { name: 'cheap mix', style: 'mma', mech: false, deck: d({ jab: 3, legkick: 3, trip: 3, block: 3, ...CORE }) },
};
export function deckLegal(deck) {
  const n = {}; for (const c of deck) n[c] = (n[c] || 0) + 1;
  return deck.length === N.own + 3 && n.sprawl === 2 && n.escape === 1 && Object.entries(n).every(([k, v]) => CARDS[k] && (CARDS[k].st === 'core' || v <= N.copies));
}
