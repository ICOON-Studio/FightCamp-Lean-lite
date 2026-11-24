// BOXCARDS2 bots. `reader`: as the leader he tries every volley against a few hands the other man MAY hold (dealt from
// the cards he has not seen) and plays the best on average; as the answerer he weighs, at each punch as it turns, every
// answer he may lay against taking it - an answer that ends the exchange is also worth the face-down cards it stops.
// He reads his own hand and the table only. `slugger`: his dearest volley, a block when he has one.
import { N, CARDS, DECK, exchange, volleyCost, rng, shuffle } from './rules2.mjs';

export const clone = (S) => ({ ...S, over: null, cards: S.cards.map((c) => [...c]), f: S.f.map((m) => ({ ...m, pile: [...m.pile], hand: [...m.hand] })) });
export const W = { pts: 1, daze: 0.45, cap: 1.6, wind: 0.25, kd: 6, win: 40, busy: 0.3, pen: 1, card: 0.15, unseen: 1.0, k: 6 };
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
// the punches the leader may still hold, by what the answerer has seen (the leader's pile, which holds this volley so far)
function unseenPunches(S, a) { const he = S.f[a], out = []; for (const [id, n] of Object.entries(DECK)) if (CARDS[id].k === 'punch') { const left = n - he.pile.filter((x) => x === id).length; if (left > 0) out.push([id, left]); } return out; }
const ends = (ans, pid) => ans.id === 'clinch' || !!ans.with || (ans.id === 'step' && !CARDS[pid].long) || (!!ans.trade && !CARDS[pid].long);
function tryAnswer(S, d, pid, ans, blind, at) {
  const T = clone(S), A = T.f[1 - d]; A.hand.push(pid); A.wind += CARDS[pid].w; A.thrown--;
  exchange(T, 1 - d, [pid], () => ans, { blind, at });
  return worth(T, d) - W.card * (ans.id ? 1 + (ans.with ? 1 : 0) : 0);
}
export function answerBot(S, d, view) {
  let best = view.legal[0], bv = -1e9;
  const cand = view.shown ? [[view.shown, 1]] : unseenPunches(S, 1 - d), tot = cand.reduce((s, c) => s + c[1], 0);
  for (const ans of view.legal) {
    let v = 0; for (const [pid, n] of cand) v += (n / tot) * (tryAnswer(S, d, pid, ans, !view.shown, view.i) + (ends(ans, pid) ? W.unseen * view.left : 0));
    if (v > bv + 1e-9) { bv = v; best = ans; }
  }
  return best;
}
export function leadBot(S, a) {
  const D = S.f[1 - a], pool = [...D.deck, ...D.hand], r = rng(S.round * 7919 + S.f[a].pile.length * 131 + D.pile.length * 17 + S.cards.length + 1), hands = [];
  for (let i = 0; i < W.k; i++) hands.push(shuffle([...pool], r).slice(0, D.hand.length));
  let best = [], bv = -1e9;
  for (const v of volleys(S, a)) {
    let sum = 0; const hs = v.length ? hands : [D.hand];
    for (const h of hs) { const T = clone(S); T.f[1 - a].hand = [...h]; exchange(T, a, v, answerBot); sum += worth(T, a); }
    const x = sum / hs.length; if (x > bv + 1e-9) { bv = x; best = v; }
  }
  return best;
}
export const reader = () => ({ lead: leadBot, answer: answerBot });
export const slugger = () => ({
  lead(S, a) { let best = [], bc = -1; for (const v of volleys(S, a)) { const c = v.reduce((s, id) => s + (CARDS[id].d || 0), 0); if (c > bc) { bc = c; best = v; } } return best; },
  answer(S, d, view) { return view.legal.find((x) => x.id === 'block') || view.legal[0]; },
});
// the blind pilots a critic would try: each leads or answers as named, and is the reader for the rest
const fixed = (order) => (S, a) => { const m = S.f[a], h = [...m.hand], v = []; let w = m.wind; for (const id of order) { const i = h.indexOf(id); if (i >= 0 && w >= CARDS[id].w && v.length < N.volley) { v.push(id); h.splice(i, 1); w -= CARDS[id].w; } } return v; };
export const PILOTS = { reader, slugger,
  same: () => ({ lead: fixed(['jab', 'cross', 'hook']), answer: answerBot }),
  jabs: () => ({ lead: fixed(['jab', 'jab', 'jab']), answer: answerBot }),
  never: () => ({ lead: () => [], answer: answerBot }),
  holder: () => ({ lead: leadBot, answer: (S, d, v) => v.legal.find((x) => x.id === 'clinch') || answerBot(S, d, v) }),
  runner: () => ({ lead: leadBot, answer: (S, d, v) => v.legal.find((x) => x.id === 'step') || answerBot(S, d, v) }),
  taker: () => ({ lead: leadBot, answer: (S, d, v) => v.legal[0] }),
  first: () => ({ lead: leadBot, answer: (S, d, v) => v.legal[1] || v.legal[0] }),
};
