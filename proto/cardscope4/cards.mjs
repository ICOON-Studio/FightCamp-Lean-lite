// CARDSCOPE4 greybox: every number, card and deck. Six arts on one strip (KICK - PUNCH - CLINCH - GROUND). Plain node.
export const N = {
  mode: 'wind', // 'wind' = one pool | 'limb' = five limb lights | 'both'   (probe P3)
  hp: 30, cap: 6, back: 3, start: 4, stool: 2, hand: 5, turns: 5, rounds: 2,
  lead: 8, chain: 1, counter: 3, block: 4, cover: 2, tiein: 3, coverW: 1, stepW: 1, standW: 1, upW: 3, cycle: 1, redraw: 1, roomDraw: 2, roomW: 2, sq0: 2, drainCap: 1,
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
  // shared core: two of each in every deck
  sprawl: A('Sprawl', 'core', 1, 'hL', 'sprawl', 'a takedown, a grip or a tie-up'),
  escape: A('Escape', 'core', 1, 'h', 'escape', 'a hold or a pass; played in your turn: stand up', { act: 'standup' }),
  // boxing: owns PUNCH. own mechanic: combinations (the jab steps in from KICK, each clean punch behind another +1, jab cross hook in order = the finisher)
  jab: S('Jab', 'boxing', 1, 'a', P, 2, 'head', { enter: 1 }),
  cross: S('Cross', 'boxing', 2, 'A', P, 5, 'head', { pts: 1 }),
  hook: S('Lead hook', 'boxing', 2, 'hl', PC, 5, 'head', { pts: 1 }),
  bodyhook: S('Body hook', 'boxing', 2, 'ah', PC, 3, 'body', { drain: 1 }),
  upper: S('Uppercut', 'boxing', 3, 'Ah', PC, 7, 'head', { pts: 1, unblock: 1 }),
  slip: A('Slip', 'boxing', 2, 'h', 'slip', 'a punch: it misses, your next punch +4'),
  block: A('Block', 'boxing', 1, 'x', 'block', 'a strike: 6 off'),
  // karate: owns KICK. own mechanic: in-and-out (the reverse punch blitzes from KICK, and a karate volley that is not stopped ends back at KICK)
  frontkick: S('Front kick', 'karate', 1, 'l', K, 2, 'body', { kick: 1, pts: 1 }),
  roundhouse: S('Roundhouse', 'karate', 2, 'Lh', K, 4, 'body', { kick: 1, pts: 2 }),
  headkick: S('Head kick', 'karate', 3, 'Lh', K, 6, 'head', { kick: 1, pts: 3, drain: 1 }),
  legkick: S('Leg kick', 'karate', 1, 'L', KP, 2, 'leg', { kick: 1, cripple: 1 }),
  revpunch: S('Reverse punch', 'karate', 2, 'A', P, 4, 'head', { pts: 1, blitz: 1 }),
  evade: A('Step off', 'karate', 2, 'y', 'evade', 'a strike, a grip or a tie-up: it misses and you are back at KICK'),
  // judo: owns CLINCH. own mechanic: the grip (laid this turn, next turn's throw cannot be stopped)
  grip: { n: 'Grip', st: 'judo', k: 'setup', w: 1, L: 'aA', at: PC },
  hipthrow: T('Hip throw', 'judo', 2, 'hL', C, 2, 2, { dmg: 3, cleanIf: 'grip', gripPts: 2 }),
  footsweep: T('Foot sweep', 'judo', 1, 'l', C, 1, 2, { cleanIf: 'grip' }),
  shoulderthrow: T('Shoulder throw', 'judo', 3, 'aAh', C, 2, 6, { dmg: 4, needGrip: 1 }),
  pin: H('Hold-down', 'judo', 2, 'aAh', ['T2', 'T3'], 2, 'pin', { hpts: 4 }),
  armlock: H('Armlock', 'judo', 2, 'aA', ['T2', 'T3'], 2, 'sub'),
  tiein: A('Tie in', 'judo', 1, 'x', 'tiein', 'a strike: 1 off and you are in the CLINCH'),
  // wrestling: decides where the bout is. own mechanic: the tie-up read (he punched: Double leg is clean; he did not: Single leg)
  tieup: { n: 'Tie-up', st: 'wrestling', k: 'setup', w: 1, L: 'a', at: PC },
  double: T('Double leg', 'wrestling', 3, 'aALh', PC, 1, 2, { dmg: 2, cleanIf: 'struck' }),
  single: T('Single leg', 'wrestling', 2, 'aAl', PC, 1, 2, { cleanIf: 'quiet' }),
  slam: T('Body lock slam', 'wrestling', 3, 'aAhL', C, 2, 4, { dmg: 4 }),
  gnp: S('Ground strikes', 'wrestling', 2, 'A', ['T'], 4, 'head', { pts: 1 }),
  fall: H('The fall', 'wrestling', 2, 'aAh', ['T1', 'T2', 'T3'], 2, 'pin', { hpts: 4 }),
  ride: { n: 'Ride', st: 'wrestling', k: 'adv', w: 1, L: 'h', at: ['T'], pts: 1 },
  headlock: A('Front headlock', 'wrestling', 1, 'hL', 'headlock', 'a takedown, a grip or a tie-up (1 point for it was sized away)'),
  // bjj: owns GROUND, top and bottom. own mechanic: chains (an escaped hold makes the next hold free, from anywhere on the ground)
  pull: { n: 'Guard pull', st: 'bjj', k: 'move', w: 0, L: 'h', at: PC },
  sweep: T('Sweep', 'bjj', 2, 'lLh', ['B0', 'B1'], 1, 2, { sweep: 1 }),
  pass: { n: 'Guard pass', st: 'bjj', k: 'adv', w: 2, L: 'aAh', at: ['T0', 'T1', 'T2'], pts: 2 },
  triangle: H('Triangle', 'bjj', 2, 'lLh', ['B0'], 2, 'sub'),
  armbar: H('Armbar', 'bjj', 2, 'aAh', ['B0', 'T2', 'T3'], 2, 'sub'),
  choke: H('Rear choke', 'bjj', 2, 'aA', ['T3'], 1, 'sub'),
  kimura: H('Kimura', 'bjj', 2, 'aA', ['B1', 'T1', 'T2'], 2, 'sub'),
  // sambo: throw, then straight onto a leg. own mechanic: throw-to-lock (after a scored throw the leg lock is free)
  sthrow: T('Sambo throw', 'sambo', 2, 'aAh', PC, 0, 3, { dmg: 2 }),
  trip: T('Leg trip', 'sambo', 1, 'l', PC, 0, 1),
  kneebar: H('Knee bar', 'sambo', 2, 'aAl', ['G'], 1, 'sub', { leg: 1 }),
  anklelock: H('Ankle lock', 'sambo', 1, 'aA', ['G'], 2, 'sub', { leg: 1 }),
  casualpin: H('Chest hold', 'sambo', 2, 'aAh', ['T'], 2, 'pin', { hpts: 3 }),
  overhand: S('Overhand', 'sambo', 2, 'A', P, 5, 'head', { pts: 1 }),
  catchkick: A('Catch the kick', 'sambo', 1, 'x', 'catch', 'a kick: it misses and he is taken down'),
};
// Round 4 sizing (tune.mjs, a coordinate search on sizing seeds 300000 and up, real-sport points pinned). These are the
// numbers the measured run used; they overwrite the first-draft numbers written on the cards above. report.mjs prints the table.
export const SIZED = {"gnp.dmg": 6, "triangle.w": 2, "ride.pts": 1, "armbar.count": 1, "stallMax": 1, "sweep.w": 1, "revpunch.pts": 1, "revpunch.w": 2, "revpunch.dmg": 4, "upper.pts": 0, "triangle.count": 3, "evade.w": 2, "slam.dmg": 5, "kneebar.w": 2, "catchPts": 0, "frontkick.w": 2, "hook.pts": 1, "gnp.pts": 1, "overhand.w": 3, "dmgPer": 3, "double.pts": 2, "block.w": 1, "pin.hpts": 2, "cross.w": 2, "shoulderthrow.w": 2, "frontkick.pts": 1, "roundhouse.dmg": 5, "overhand.dmg": 6, "casualpin.hpts": 2, "fall.count": 2, "slam.pts": 3, "hipthrow.dmg": 5, "tiein.w": 2, "hipthrow.pts": 2, "roundhouse.pts": 2, "trip.pts": 1, "armbar.w": 1, "hipthrow.w": 2, "footsweep.pts": 2, "casualpin.count": 1, "casualpin.w": 1, "upper.dmg": 6, "armlock.w": 3, "tieup.w": 1, "armlock.count": 3, "headlock.w": 2, "bodyhook.dmg": 4, "counter": 4, "sweep.pts": 2, "legkick.dmg": 1, "headkick.dmg": 6, "slip.w": 1, "pin.w": 1, "standW": 2, "pass.w": 2, "kimura.count": 1, "cross.pts": 0, "gnp.w": 2, "trip.w": 2, "pin.count": 2, "double.dmg": 0, "fall.hpts": 4, "sthrow.pts": 3, "frontkick.dmg": 2, "block": 6, "ride.w": 1, "fall.w": 3, "overhand.pts": 0, "anklelock.w": 3, "headkick.pts": 3, "footsweep.w": 1, "kimura.w": 2, "sthrow.dmg": 1, "anklelock.count": 3, "pull.w": 3, "shoulderthrow.pts": 6, "roomW": 3, "catchkick.w": 1, "headlockPts": 0, "tiein": 1, "shoulderthrow.dmg": 5, "cross.dmg": 4, "roundhouse.w": 2, "stepW": 0, "kneebar.count": 2, "comboDmg": 5, "grip.w": 1, "hook.w": 2, "sthrow.w": 2, "chain": 1, "comboPts": 3, "pass.pts": 3, "double.w": 2, "sq0": 2, "bodyhook.w": 3, "lead": 8};
for (const [k, v] of Object.entries(SIZED)) { const [c, f] = k.split('.'); if (f) CARDS[c][f] = v; else N[k] = v; }
export const FLOOR = { '@in': 'Step in', '@out': 'Step out', '@stand': 'Let him up', '@up': 'Get up', '@cover': 'Cover up', '@room': 'Make room' };
const d = (o) => Object.entries(o).flatMap(([k, n]) => Array(n).fill(k));
const CORE = { sprawl: 2, escape: 1 };
export const OWN = {
  boxing: { jab: 3, cross: 2, hook: 2, bodyhook: 1, upper: 1, slip: 1, block: 2 },
  karate: { frontkick: 2, roundhouse: 2, headkick: 2, legkick: 2, revpunch: 2, evade: 2 },
  judo: { grip: 2, hipthrow: 2, footsweep: 2, shoulderthrow: 1, pin: 2, armlock: 2, tiein: 1 },
  wrestling: { tieup: 2, double: 2, single: 2, slam: 1, gnp: 2, fall: 1, ride: 1, headlock: 1 },
  bjj: { pull: 2, sweep: 2, pass: 2, triangle: 2, armbar: 2, choke: 1, kimura: 1 },
  sambo: { sthrow: 2, trip: 2, kneebar: 2, anklelock: 2, casualpin: 1, overhand: 2, catchkick: 1 },
};
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
