// The deal (split out of engine.mjs in S549 for the 500-line limit): the seeded dice, the shuffle, a new fighter, the
// copy of a bout the forecast and the pilot play on, and the draw. Same code, moved; engine.mjs re-exports every name.
import { N } from './cards.mjs';

export function rng(seed) {
  let a = seed >>> 0;
  return () => { a = (a + 0x6d2b79f5) | 0; let t = Math.imul(a ^ (a >>> 15), 1 | a); t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t; return ((t ^ (t >>> 14)) >>> 0) / 4294967296; };
}
export function shuffle(a, r) { for (let i = a.length - 1; i > 0; i--) { const j = Math.floor(r() * (i + 1)); [a[i], a[j]] = [a[j], a[i]]; } return a; }
export function newFighter(F, r) {
  return { name: F.name, style: F.style, mech: F.mech !== false, list: F.deck.slice(), deck: shuffle(F.deck.slice(), r), hand: [], disc: [],
    hp: N.hp, pts: 0, wind: N.start, lit: 31, dark: 0, drain: 0, dealt: 0, ctr: 0, chain: 0, free: 0, lame: 0 };
}
const cf = (F) => ({ ...F, hand: F.hand.slice() });
export function clone(S) {
  const c = { ...S, f: [cf(S.f[0]), cf(S.f[1])], at: S.at.slice(), j: { ...S.j }, inc: S.inc.map((p) => ({ ...p })), hold: S.hold && { ...S.hold }, tie: S.tie && { ...S.tie }, timid: S.timid.slice(), gnp: (S.gnp || [0, 0]).slice(), idle: (S.idle || [0, 0]).slice(), ctx: { ...S.ctx }, legs: S.legs && { ...S.legs }, st: null, pj: null };
  if (S.pj) c.pj = clone(S.pj);
  return c;
}
export function draw(M, r) {
  while (M.hand.length < N.hand) {
    if (!M.deck.length) { if (!M.disc.length) break; M.deck = shuffle(M.disc, r); M.disc = []; }
    M.hand.push(M.deck.pop());
  }
}
