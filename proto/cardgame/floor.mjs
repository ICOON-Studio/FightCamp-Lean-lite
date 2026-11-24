// ROUND 9b (CARDREAL_AUDIT section 9): the floor's own prices, and the basic defences every fighter has with no card.
// Kalli's largest finding on round 9: five turning points of the walked bout were decided by "he had no card for it" -
// a draw, not a choice. A fighter can always frame off a tie, keep his base against a pull or a sweep, fight a hold as
// it is put on, and kick up off his back; what he cannot always do is afford it. These are answers paid in WIND:
// defend, or keep the wind to attack. The CARDS of the same kind stay the stronger version (the Sprawl card, the Escape
// card that takes the holder a layer back, the Up-kick card that hits harder).
// Own file because engine.mjs sits at the owner's 500-line limit. No import from engine.mjs: no cycle.
import { N, CARDS } from './cards.mjs';

// what each no-card answer does, in the engine's answer words (fxOf)
export const FLOOR_FX = { '@frame': 'frame', '@base': 'base', '@escape': 'escape', '@kick': 'up', '@hold': 'legs' };
export const FLOOR_ANS = Object.keys(FLOOR_FX);
// the price of every move of the floor: [wind, limbs]
export function moveCost(S, m, id) {
  if (id === '@in' || id === '@out' || id === '@back') return [N.stepW + (S.f[m].lame ? 1 : 0), 'y'];
  if (id === '@stand') return [N.standW, 'y'];
  if (id === '@cover') return [N.coverW, 'x'];
  if (id === '@pull') return [N.pullW, 'h'];
  if (id === '@break') return [S.hold ? S.hold.brk : 99, ''];
  if (id === '@up') return [N.upW, 'hy'];
  if (id === '@frame') return [N.frameW, 'x'];
  if (id === '@base') return [N.baseW, 'h'];
  if (id === '@escape') return [N.escW, 'h'];
  if (id === '@kick') return [N.kickW, 'y'];
  if (id === '@post') return [N.postW, 'x'];
  if (id === '@gnp') return [N.topW, 'x'];
  if (id === '@hold') return [N.holdW, 'y'];
  return null;
}
// the up-kick's damage: the card's as printed, the no-card kick's own (smaller) number
export const kickDmg = (ans, card) => (ans === '@kick' ? N.kickDmg : card);
// A1 THE KNOCKDOWN: a punch that lands for N.kdDmg or more on a STANDING man and leaves him hurt (N.kdHp or under, not
// out) seats him; the puncher stands over him inside the reach of his feet (pair 3).
export const isKnockdown = (S, a, d, dmg) => dmg >= N.kdDmg && S.f[d].hp > 0 && S.f[d].hp <= N.kdHp && S.at[a] === 'stand' && S.at[d] === 'stand';
// A2 THE STOPPAGE and I1 "GET UP": the referee's two counts on a man who is down. gnp[m] = the turns running in which
// punches landed on m while he was down and he laid nothing back; idle[m] = his empty turns running on the floor in
// front of a standing man. Laying anything, or being on his feet, clears both.
export const refCounts = () => ({ gnp: [0, 0], idle: [0, 0] });
// SLICE 2 (S549, audit 9a C, B4). POSTURE: S.post = the seat of the man IN GUARD ON TOP whose posture is BROKEN (a pull
// breaks it; a takedown or following him down leaves it up), null otherwise. THE LEGS: S.legs = { n, on } while a man
// stands in the guard - n the holds paid running (cap N.legsMax), on = held through his coming turn. Both are dropped
// the moment the places they describe are gone; place() and placeBoth() call this.
export function fixPost(S) {
  if (S.post != null && S.at[S.post] !== 'gtop') S.post = null;
  if (S.legs && !(S.at.includes('stand') && S.at.includes('gbot'))) S.legs = null;
  if (S.tried != null && S.at[S.tried] === 'stand') S.tried = null; // I3: on his feet again, the failed pull is forgotten
}
export const holdLegs = (S) => { S.j = { ...S.j, g: 'closed' }; S.legs = { n: (S.legs?.n || 0) + 1, on: true }; S.stall = 0; if (S.st) S.st.legHolds = (S.st.legHolds || 0) + 1; };
// a hold goes on (one place for the card's count, its break price and its points)
export function putHold(S, by, id) {
  const h = CARDS[id];
  S.hold = { by, kind: h.hk, count: h.count, brk: h.brk, tick: h.tick || 0, pts: h.hpts || 0, card: id };
  S.stall = 0; if (S.st) S.st.holdOn++;
}
// SLICE 3 (audit 9a I5): nobody working with a man STANDING in the guard. The referee does not stand both up at kicking
// range: the legs are opened and the standing man is left over a man on his back, inside the reach of his feet (pair 3)
// - he still has to pass the up-kick to leave.
export const inPair4 = (S) => S.at.includes('stand') && S.at.includes('gbot');
export function openLegs(S) {
  S.at = S.at.map((p) => (p === 'gbot' ? 'back' : p)); S.j = { kind: 'apart', leg: true }; S.stall = 0; fixPost(S);
  if (S.st) { S.st.refUps++; S.st.refLog.push('nobody working, a man standing in the guard: the legs are opened'); }
}
// I4: a clinch held through a whole exchange (both turns) with nothing laid by either man is broken, apart at PUNCH
export function idleClinch(S) {
  if (S.j.kind !== 'clinch' || S.inc.length) { S.cl = 0; return; }
  S.cl = (S.cl || 0) + 1;
  if (S.cl >= 2) { S.cl = 0; S.tie = null; S.j = { kind: 'apart', reach: 'P' }; if (S.st) S.st.refLog.push('an idle clinch, broken'); }
}
