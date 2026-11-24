// The guide (round 8, TASK CARDROUND8). The coach's six lines, in the order he says them, and the moment each is due.
// Every number in a line is the engine's own (a number of N, or a card's), read when the line is spoken, so the words
// cannot drift from the rules; the same six lines fill the How to play page (item 4 of the brief). Pure: no document,
// no page state, so node can test the words against the engine.
import { N } from './cards.mjs';
import { clone, resolveIncoming } from './engine.mjs';

// ROUND 9 (item 7): the ONE-SWITCH STRIP is gone. The page says where EACH man is, in plain fight words, and names each
// button by the state (Step in over a grounded man is Follow him down; Step out, Walk away; Pull guard with no tie, Sit
// down). The picture on the How to play page is the paper's own list of places, not a switch with a light on it.
export const PLACES_PICTURE = ['Standing', 'Seated on the floor', 'On his back', 'On his knees', 'In his guard, on top', 'In his guard, underneath', 'Past his guard', 'Pinned'];
const strip = () => `standing apart at kicking or punching range, in the clinch, standing over a man who is down, in his guard on top or underneath, past his guard, or pinned under him.`;
// the coach's lines, in the order the brief lists them. text() reads the engine's numbers at the moment of speaking.
export const GUIDE = [
  { id: 'volley', title: 'His volley', target: 'volleysheet',
    text: () => `His volley is face up: what he throws this turn, a card or a move at a time. A card can be answered, and so can a move that leaves contact, goes to the ground or rises from it (the pull, the stand-up, getting up, the walk away) - each answer says what it stops.` },
  { id: 'wind', title: 'Wind', target: 'wind',
    text: () => `Wind pays for your cards. The number by your name is what you have now; ${N.back} comes back at the start of each of your turns, up to ${N.cap}. A greyed card costs more wind than you have, or does not work where you stand.` },
  { id: 'range', title: 'Where each man is', target: 'range',
    text: () => `Every man has his OWN place, and the page says where each of you is: ${strip()} A move changes only the place of the man who plays it - when one man stands up, the other stays on the floor until his own turn. Every card says the place it works at. Steps cost ${N.stepW} wind.` },
  { id: 'lay', title: 'Laying cards', target: 'hand',
    text: () => `Lay your cards one at a time: each is paid in wind and resolves on his turn. End turn when your volley is laid.` },
  { id: 'win', title: 'Points, health and the ways to win', target: 'score',
    text: () => `Health is ${N.hp}; points come from clean punches and takedowns. The ways to win: a knockout (his health gone), a points lead of ${N.lead}, or a hold - a submission or a pin. Nobody wins by a pin alone: the referee stands a held pin up, apart at kicking range.` },
  { id: 'bell', title: 'The bell and the rounds', target: 'rounds',
    text: () => `${N.rounds} rounds of ${N.turns} turns each. At the bell the last volley is resolved and any hold ends where it is - no tap on the bell. The next round starts with both men standing, apart at kicking range.` },
];
export const guideLines = () => GUIDE.map(({ id, title, target, text }) => ({ id, title, target, text: text() }));
// the moment each line is due. His volley: the answer table is up, or (a rival who laid nothing) your own turn after
// his. Wind, the strip, laying: your hand and your wind are on screen. The ways to win: the first point or point of
// health that moves, or at the latest the bell. The bell: the first bell, or the end of the bout. The coach says the
// lines in this order and one at a time: a line whose moment has not come holds the rest.
export function guideMoment(id, ctx) {
  if (id === 'volley') return !!ctx.answer || (!!ctx.act && !!ctx.rivalActed);
  if (id === 'wind' || id === 'range' || id === 'lay') return !!ctx.act;
  if (id === 'win') return !!ctx.scored || !!ctx.bell;
  if (id === 'bell') return !!ctx.bell;
  return false;
}
// the next line the coach says: the first line not yet said, if its moment has come; else nothing (he waits)
export function nextGuideLine(seen, ctx) {
  for (const line of GUIDE) {
    if (seen.includes(line.id)) continue;
    return guideMoment(line.id, ctx) ? { id: line.id, title: line.title, target: line.target, text: line.text() } : null;
  }
  return null;
}
// THE LOW-HEALTH WARNING (round 8, item 3): what his laid volley does to your health if you do not answer. Measured by
// the engine itself on a copy of the bout, so the warning can never disagree with the resolution: the same cards, the
// same combo, the same numbers. ko = it would take your health to 0; low = it would leave you under a quarter.
export function volleyThreat(S, m) {
  const hp = S.f[m].hp;
  if (!S.inc.length) return { dmg: 0, after: hp, ko: false, low: false };
  const c = clone(S), before = c.f[m].hp;
  resolveIncoming(c, m, null);
  const after = c.f[m].hp, dmg = Math.max(0, before - after);
  return { dmg, after, ko: after <= 0, low: after > 0 && after < N.hp / 4 };
}
export { strip };
export const threatLine = (t) => (t.ko ? 'This volley knocks you out unless you answer.' : t.low ? 'This volley takes you under a quarter of your health unless you answer.' : '');
