// BOXCARDS3 bots (the defence is laid, not asked). `reader`: as the man answering he deals the leader a few hands he MAY
// hold (from the cards not yet in the leader's pile), takes the volleys of the length he sees (and the first card he
// sees) from each, and lays the line that does best on average. As the leader he tries every volley against a few hands
// the other man may hold, each answered by that same line-layer. He reads his own hand and the table only.
import { N, CARDS, exchange, lines, volleyCost, rng, shuffle } from './rules3.mjs';

export const clone = (S) => ({ ...S, over: null, cards: S.cards.map((c) => [...c]), f: S.f.map((m) => ({ ...m, pile: [...m.pile], hand: [...m.hand] })) });
export const W = { pts: 1, daze: 0.45, cap: 1.6, wind: 0.25, kd: 6, win: 40, busy: 0.3, pen: 1, card: 0.15, hands: 3, vols: 4, k: 3 };
export function worth(S, k) {
  const me = S.f[k], he = S.f[1 - k];
  if (S.over) return S.over.win === k ? W.win : -W.win;
  return W.pts * (me.pts - he.pts) + W.daze * (he.daze - me.daze) + W.cap * (me.cap - he.cap) + W.kd * (me.kdScored - he.kdScored) - W.pen * (me.pen - he.pen)
    + W.wind * (Math.min(me.cap, me.wind + N.rec) - Math.min(he.cap, he.wind + N.rec)) + W.busy * Math.sign(me.thrown - he.thrown);
}
export function volleys(S, a) {
  const m = S.f[a], kinds = [...new Set(m.hand.filter((id) => CARDS[id].k !== 'ans'))], out = [[]];
  const count = (id) => m.hand.filter((x) => x === id).length;
  const go = (v) => { for (const id of kinds) {
    if (v.filter((x) => x === id).length >= count(id)) continue;
    const nv = [...v, id]; if (volleyCost(nv) > m.wind) continue;
    if (CARDS[id].k !== 'feint') out.push(nv);
    if (nv.length < N.volley) go(nv);
  } };
  go([]); return out;
}
const seedOf = (S, x) => S.round * 7919 + S.f[0].pile.length * 131 + S.f[1].pile.length * 17 + S.cards.length * 53 + x;
// what a line is worth to the man laying it against one volley the leader might hold (hand = the leader's dealt hand)
export function lineWorth(S, d, line, hand, vol) {
  const T = clone(S), before = T.f[d].hand.length; T.f[1 - d].hand = [...hand];
  exchange(T, 1 - d, vol, line);
  return worth(T, d) - W.card * (before - T.f[d].hand.length);
}
// the volleys he must be ready for: [hand, volley] pairs of the length (and first card) he sees
export function guesses(S, d, view, r) {
  const A = S.f[1 - d], pool = [...A.deck, ...A.hand], out = [];
  for (let i = 0; i < W.hands * 4 && out.length < W.hands * W.vols; i++) {
    const hand = shuffle([...pool], r).slice(0, A.hand.length), T = clone(S); T.f[1 - d].hand = hand;
    const fit = shuffle(volleys(T, 1 - d).filter((v) => v.length === view.n && (!view.first || v[0] === view.first)), r).slice(0, W.vols);
    for (const v of fit) out.push([hand, v]);
  }
  return out;
}
export function layBot(S, d, view) {
  const all = lines(S, d, view.n); if (all.length < 2) return all[0];
  const g = guesses(S, d, view, rng(seedOf(S, 7 + view.n)));
  if (!g.length) return all[0];
  let best = all[0], bv = -1e9;
  for (const line of all) { let v = 0; for (const [hand, vol] of g) v += lineWorth(S, d, line, hand, vol); if (v > bv + 1e-9) { bv = v; best = line; } }
  return best;
}
export function leadBot(S, a) {
  const D = S.f[1 - a], pool = [...D.deck, ...D.hand], r = rng(seedOf(S, 1)), hands = [];
  for (let i = 0; i < W.k; i++) hands.push(shuffle([...pool], r).slice(0, D.hand.length));
  const memo = hands.map(() => new Map());            // his line depends on his hand, the count and the card he sees: never on the rest
  let best = [], bv = -1e9;
  for (const v of volleys(S, a)) {
    let sum = 0;
    for (let h = 0; h < hands.length; h++) {
      const T = clone(S); T.f[1 - a].hand = [...hands[h]];
      if (!v.length) { exchange(T, a, v, null); sum += worth(T, a); continue; }
      const key = v.length + ':' + (N.seeFirst ? v[0] : '');
      if (!memo[h].has(key)) memo[h].set(key, layBot(T, 1 - a, { n: v.length, first: N.seeFirst ? v[0] : null }));
      exchange(T, a, v, memo[h].get(key)); sum += worth(T, a);
    }
    const x = sum / hands.length; if (x > bv + 1e-9) { bv = x; best = v; }
  }
  return best;
}
export const reader = () => ({ lead: leadBot, lay: layBot });
// the blind pilots a critic would try: each leads or lays as named, and is the reader for the rest
const fixed = (order) => (S, a) => { const m = S.f[a], h = [...m.hand], v = []; let w = m.wind; for (const id of order) { const i = h.indexOf(id); if (i >= 0 && w >= CARDS[id].w && v.length < N.volley) { v.push(id); h.splice(i, 1); w -= CARDS[id].w; } } return v; };
const count = (line, f) => line.filter((x) => x && f(x)).length;
const most = (f) => (S, d, view) => lines(S, d, view.n).reduce((b, l) => (count(l, f) > count(b, f) ? l : b));
export const PILOTS = { reader,
  same: () => ({ lead: fixed(['jab', 'cross', 'hook']), lay: layBot }),
  jabs: () => ({ lead: fixed(['jab', 'jab', 'jab']), lay: layBot }),
  never: () => ({ lead: () => [], lay: layBot }),
  taker: () => ({ lead: leadBot, lay: () => null }),                                   // never defends
  wall: () => ({ lead: leadBot, lay: most((x) => x.id === 'block') }),                 // a block wherever he can
  allin: () => ({ lead: leadBot, lay: most(() => true) }),                            // an answer in every place he can pay for
  slipper: () => ({ lead: leadBot, lay: most((x) => x.id === 'slip') }),
  holder: () => ({ lead: leadBot, lay: most((x) => x.id === 'clinch') }),
  runner: () => ({ lead: leadBot, lay: most((x) => x.id === 'step') }),
  firstonly: () => ({ lead: leadBot, lay: (S, d, v) => { const l = layBot(S, d, { ...v, n: 1 }); return [l[0], ...Array(v.n - 1).fill(null)]; } }),   // answers only the card he sees
};
