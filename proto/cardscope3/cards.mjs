// CARDSCOPE3 greybox: every number, card, boxer, habit and class the probe runs. Plain node, no page.
export const N = {
  cap: 6, back: 3, start: 4, stool: 2, hand: 5, turns: 3, rounds: 3,
  head: 50, hurtAt: 42, kd: 18, kdHurt: 14, chain: 2, counter: 3, block: 4, splitBlock: 1,
  trapCost: 0, bodyStep: 8, kdBack: 2, hurtBack: 0, ice: 14, habitKeep: 0.9, trapEnds: 0, bellBack: 0, leadDry: 1, coin: 0, maxGuards: 1, trapBack: 1, trapFirst: 1, blockCtr: 0, headPlus: 0, lastLead: 0, maxTrap: 2, maxCopy: 4,
};
const P = (name, w, cls, shape, dmg, zone, x = {}) => ({ name, w, kind: 'punch', cls, shape, dmg, zone, ...x });
export const CARDS = {
  jab: P('Jab', 1, 'jab', 'straight', 2, 'head'),
  bodyjab: P('Body jab', 1, 'jab', 'straight', 2, 'body'),
  cross: P('Cross', 2, 'rear', 'straight', 6, 'head'),
  hook: P('Lead hook', 2, 'hook', 'hook', 6, 'head'),
  bodyhook: P('Body hook', 2, 'hook', 'hook', 4, 'body', { drain: 1 }),
  upper: P('Uppercut', 3, 'rear', 'upper', 9, 'head'),
  block: { name: 'Block', w: 1, kind: 'guard' },
  slip: { name: 'Slip', w: 2, kind: 'guard' },
  roll: { name: 'Roll', w: 2, kind: 'guard' },
  parry: { name: 'Parry', w: 1, kind: 'guard' },
  tieup: { name: 'Tie up', w: 4, kind: 'tie' },
  checkhook: { name: 'Check hook', w: 2, kind: 'trap', catches: 'jab', dmg: 8 },
  xcounter: { name: 'Cross counter', w: 2, kind: 'trap', catches: 'rear', dmg: 8 },
  pullcounter: { name: 'Pull counter', w: 2, kind: 'trap', catches: 'hook', dmg: 8 },
};
export const IDS = Object.keys(CARDS);
export const TRAPS = IDS.filter((i) => CARDS[i].kind === 'trap');
export const PUNCHES = IDS.filter((i) => CARDS[i].kind === 'punch');
export const GUARDS = ['block', 'slip', 'roll', 'parry', 'tieup'];

// what a guard does to a punch: 'evade' (misses, you counter), 'parry' (misses), 'block', or null (does not fit)
export function guardEffect(g, p) {
  const c = CARDS[p];
  if (g === 'block') return 'block';
  if (g === 'parry') return c.cls === 'jab' ? 'parry' : null;
  if (g === 'slip') return c.shape === 'straight' || c.shape === 'upper' ? 'evade' : null;
  if (g === 'roll') return c.shape === 'hook' || c.shape === 'upper' ? 'evade' : null;
  return null;
}
const d = (o) => Object.entries(o).flatMap(([k, n]) => Array(n).fill(k));
export const NEUTRAL = d({ jab: 3, bodyjab: 1, cross: 3, hook: 2, block: 1, slip: 1, roll: 1 });
export const PLAYERS = [
  { name: 'P-out', style: 'out', head: 68, deck: d({ jab: 4, bodyjab: 1, cross: 3, hook: 1, upper: 1, block: 1, slip: 1, parry: 1, checkhook: 1, xcounter: 1 }) },
  { name: 'P-press', style: 'press', head: 74, deck: d({ jab: 2, bodyjab: 1, cross: 1, hook: 3, bodyhook: 3, upper: 1, block: 2, roll: 1, tieup: 1, pullcounter: 1 }) },
  { name: 'P-counter', style: 'counter', head: 70, deck: d({ jab: 3, cross: 3, hook: 2, upper: 1, block: 1, slip: 1, roll: 1, parry: 1, xcounter: 1, checkhook: 1 }) },
  { name: 'P-volume', style: 'volume', head: 71, deck: d({ jab: 4, bodyjab: 2, cross: 2, hook: 2, bodyhook: 2, block: 1, slip: 1, parry: 1, checkhook: 1 }) },
];
// opponents from other clubs: each two habits that rule his set card (what you threw last -> what he sets)
export const OPPS = [
  { name: 'O-out', style: 'out', head: 69, deck: d({ jab: 4, bodyjab: 1, cross: 3, hook: 2, block: 1, slip: 1, parry: 1, checkhook: 1, xcounter: 1 }), habits: [{ trig: 'jab', trap: 'checkhook' }, { trig: 'rear', trap: 'xcounter' }] },
  { name: 'O-press', style: 'press', head: 75, deck: d({ jab: 1, bodyjab: 1, cross: 2, hook: 3, bodyhook: 3, upper: 1, block: 2, roll: 1, pullcounter: 1, xcounter: 1 }), habits: [{ trig: 'hook', trap: 'pullcounter' }, { trig: 'quiet', trap: 'xcounter' }] },
  { name: 'O-counter', style: 'counter', head: 70, deck: d({ jab: 3, cross: 3, hook: 2, upper: 1, block: 1, slip: 1, roll: 1, parry: 1, xcounter: 1, pullcounter: 1 }), habits: [{ trig: 'rear', trap: 'xcounter' }, { trig: 'hook', trap: 'pullcounter' }] },
  { name: 'O-volume', style: 'volume', head: 72, deck: d({ jab: 4, bodyjab: 2, cross: 2, hook: 2, bodyhook: 1, block: 2, parry: 1, checkhook: 1, pullcounter: 1 }), habits: [{ trig: 'jab', trap: 'checkhook' }, { trig: 'quiet', trap: null }] },
];
// the five classes: how he boxes (eps = share of turns played at random; prof = which planner), then paper
export const CLASSES = [
  null,
  { name: 'novice', eps: 0.65, prof: 'greedy', open: true, adapt: false, noTraps: true },
  { name: 'open class', eps: 0.38, prof: 'greedy', open: false, adapt: false },
  { name: 'regional', eps: 0.02, prof: 'reader', open: false, adapt: true },
  { name: 'title', eps: 0.02, prof: 'reader', open: false, adapt: true, cap: 1 },
  { name: 'professional', eps: 0, prof: 'reader', open: false, adapt: true, cap: 1, pow: 1, rounds: 4 },
];
export function deckLegal(deck) {
  if (deck.length < 12 || deck.length > 16) return false;
  const n = {};
  for (const c of deck) n[c] = (n[c] || 0) + 1;
  return Object.entries(n).every(([c, k]) => k <= (CARDS[c].kind === 'trap' ? N.maxTrap : N.maxCopy));
}
