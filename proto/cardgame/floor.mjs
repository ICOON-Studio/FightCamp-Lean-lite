// ROUND 9b (CARDREAL_AUDIT section 9): the floor's own prices, and the basic defences every fighter has with no card.
// Kalli's largest finding on round 9: five turning points of the walked bout were decided by "he had no card for it" -
// a draw, not a choice. A fighter can always frame off a tie, keep his base against a pull or a sweep, fight a hold as
// it is put on, and kick up off his back; what he cannot always do is afford it. These are answers paid in WIND:
// defend, or keep the wind to attack. The CARDS of the same kind stay the stronger version (the Sprawl card, the Escape
// card that takes the holder a layer back, the Up-kick card that hits harder).
// Own file because engine.mjs sits at the owner's 500-line limit. No import from engine.mjs: no cycle.
import { N } from './cards.mjs';

// what each no-card answer does, in the engine's answer words (fxOf)
export const FLOOR_FX = { '@frame': 'frame', '@base': 'base', '@escape': 'escape', '@kick': 'up' };
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
