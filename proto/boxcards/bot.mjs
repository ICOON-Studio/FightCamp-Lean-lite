// BOXCARDS1 bots. `reader` looks one exchange ahead: as the leader it weighs every volley against the answers the other
// man may hold (he sees no hand: he counts the cards not yet seen); as the answerer he sees the volley and picks his
// best legal answer. `slugger` is the weak player of the bars: his dearest volley, his first answer.
import { N, CARDS, DECK, answers, resolve, volleyCost } from './rules.mjs';

export const clone = (S) => ({ ...S, over: null, cards: S.cards.map((c) => [...c]), f: S.f.map((m) => ({ ...m, deck: m.deck, pile: [...m.pile], hand: [...m.hand] })) });
// what a state is worth to man k (W can be swept by a probe)
export const W = { pts: 1, daze: 0.45, cap: 1.6, wind: 0.25, kd: 6, ready: 0.8, win: 40, lean: 0, busy: 0.3, keep: 0.5 };
export function worth(S, k) {
  const me = S.f[k], he = S.f[1 - k];
  if (S.over) return S.over.win === k ? W.win : -W.win;
  return W.pts * (me.pts - he.pts) + W.daze * (he.daze - me.daze) + W.cap * (me.cap - he.cap) + W.wind * (Math.min(me.cap, me.wind + N.rec) - Math.min(he.cap, he.wind + N.rec)) + W.busy * Math.sign(me.thrown - he.thrown)
    + W.kd * (me.card - he.card) + W.ready * (me.ready - he.ready);
}
export function volleys(S, a) {
  const m = S.f[a], kinds = [...new Set(m.hand.filter((id) => CARDS[id].k !== 'ans'))], out = [[]];
  const count = (id) => m.hand.filter((x) => x === id).length;
  const go = (v) => { for (const id of kinds) {
    if (v.filter((x) => x === id).length >= count(id)) continue;
    const nv = [...v, id]; if (volleyCost(nv, m) > m.wind) continue;
    if (CARDS[id].k !== 'feint') out.push(nv);            // a volley never ends on a feint
    if (nv.length < N.volley) go(nv);
  } };
  go([]); return out;
}
const tryIt = (S, a, v, ans) => { const T = clone(S); resolve(T, a, v, { ...ans }); return T; };
export function bestAnswer(S, d, volley, legal) {
  let best = legal[0], bv = -1e9;
  for (const ans of legal) { const v = worth(tryIt(S, 1 - d, volley, ans), d); if (v > bv) { bv = v; best = ans; } }
  return best;
}
// the chance he holds at least one of a card: from the cards the leader has not seen (his own hand and both piles are seen)
function holds(S, a, id) {
  const he = S.f[1 - a], gone = he.pile.filter((x) => x === id).length, left = DECK[id] - gone;
  const unseen = he.deck.length + he.hand.length, h = he.hand.length;
  if (left <= 0 || unseen <= 0) return 0;
  let p = 1; for (let i = 0; i < h; i++) p *= Math.max(0, (unseen - left - i)) / (unseen - i);
  return 1 - p;
}
export function volleyValue(S, a, v) {
  if (!v.length) return worth(tryIt(S, a, v, { id: null }), a);
  const he = S.f[1 - a], T = clone(S); T.f[1 - a].hand = Object.keys(DECK);   // every answer he could hold, wind allowing
  const rows = answers(T, 1 - a, v).map((ans) => ({ ans, v: worth(tryIt(T, a, v, ans), a), p: ans.id ? holds(S, a, ans.id) : 1 }));
  rows.sort((x, y) => x.v - y.v);                           // he picks what is worst for the leader, of what he holds
  let left = 1, ev = 0; for (const r of rows) { ev += left * r.p * r.v; left *= 1 - r.p; if (left < 1e-6) break; }
  return ev;
}
export const reader = () => ({
  lead(S, a) { let best = [], bv = -1e9; for (const v of volleys(S, a)) { const x = volleyValue(S, a, v) + W.lean * v.length; if (x > bv) { bv = x; best = v; } } return best; },
  answer: bestAnswer,
  // the corner: what each choice is worth by the same scale; advice keeps his dearest punches and a feint
  corner(S, k) { if (N.corner === 2) return { id: N.planOnly || ['body', 'counter', 'box'][Math.floor(S.r() * 3)] }; const m = S.f[k], order = ['upper', 'cross', 'hook', 'feint', 'slip', 'step', 'body', 'block', 'clinch', 'jab'];
    const keep = [...m.hand].sort((a, b) => order.indexOf(a) - order.indexOf(b)).slice(0, N.keep);
    const v = { water: m.cap < N.cap ? W.cap : -1, ice: W.daze * Math.max(0, m.daze - N.bellDaze) , advice: W.keep * keep.filter((id) => order.indexOf(id) < 4).length };
    const id = Object.keys(v).sort((a, b) => v[b] - v[a])[0]; return { id, keep }; },
});
export const slugger = () => ({
  lead(S, a) { let best = [], bc = -1; for (const v of volleys(S, a)) { const c = v.reduce((s, id) => s + (CARDS[id].d || 0), 0); if (c > bc) { bc = c; best = v; } } return best; },
  answer(S, d, volley, legal) { return legal.find((x) => x.id === 'block') || legal.find((x) => x.id && !x.counter) || legal[0]; },
});
