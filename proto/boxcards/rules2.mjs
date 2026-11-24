// BOXCARDS2 (S550, after Arena's critic of version 1: "the answerer sees the whole volley"): the volley is laid FACE
// DOWN and turned over ONE PUNCH AT A TIME. Each punch as it turns asks the other man: pay to stop it, or take it. He
// sees how many cards are still face down, never what they are. No dice: the only chance is the draw.
// A bout is 3 rounds; in a round each man leads 3 times, turn about. Every number is in N: node probe2.mjs name=value
export const N = {
  rounds: 3, leads: 3, hand: 5, volley: 3,
  cap: 6, rec: 3, capMin: 2, rest: 2, restPts: 2, restFresh: 1,
  blockLeak: 1, slipTired: 1, tiredAt: 4, clinchW: 1, holdFree: 2,
  kdAt: 8, kdTo: 6, bellDaze: 1, fade: 1, koCap: 3, kdRound: 2, kdBout: 3,
};
export const CARDS = {
  jab:    { n: 'Jab',       k: 'punch', w: 1, d: 1, s: 1, zone: 'head', long: 1 },
  cross:  { n: 'Cross',     k: 'punch', w: 2, d: 3, s: 2, zone: 'head', power: 1 },
  hook:   { n: 'Lead hook', k: 'punch', w: 2, d: 3, s: 2, zone: 'head', power: 1 },
  body:   { n: 'Body hook', k: 'punch', w: 2, d: 1, s: 1, zone: 'body' },
  upper:  { n: 'Uppercut',  k: 'punch', w: 3, d: 4, s: 2, zone: 'head', power: 1, unblock: 1 },
  feint:  { n: 'Feint',     k: 'feint', w: 1 },
  block:  { n: 'Block',     k: 'ans', w: 1 },
  slip:   { n: 'Slip',      k: 'ans', w: 1 },
  step:   { n: 'Step back', k: 'ans', w: 1 },
  clinch: { n: 'Clinch',    k: 'ans', w: 1 },
};
export const DECK = { jab: 5, cross: 3, hook: 3, body: 3, upper: 2, feint: 2, block: 3, slip: 3, step: 2, clinch: 2 };
export const deckList = () => Object.entries(DECK).flatMap(([id, c]) => Array(c).fill(id));
export function rng(seed) { let a = seed >>> 0; return () => { a |= 0; a = a + 0x6D2B79F5 | 0; let t = Math.imul(a ^ a >>> 15, 1 | a); t = t + Math.imul(t ^ t >>> 7, 61 | t) ^ t; return ((t ^ t >>> 14) >>> 0) / 4294967296; }; }
export const shuffle = (a, r) => { for (let i = a.length - 1; i > 0; i--) { const j = Math.floor(r() * (i + 1)); [a[i], a[j]] = [a[j], a[i]]; } return a; };

export function newBout(seed, first = 0) {
  const r = rng(seed);
  const man = () => ({ deck: shuffle(deckList(), r), pile: [], hand: [], wind: N.cap, cap: N.cap, daze: 0, kds: 0, kdsRound: 0,
    pts: 0, kdScored: 0, total: 0, ropes: 0, held: 0, holds: 0, skip: 0, thrown: 0, hurt: 0, pen: 0 });
  return { r, f: [man(), man()], round: 1, first, over: null, cards: [] };
}
export function draw(S, k) { const m = S.f[k]; while (m.hand.length < N.hand) { if (!m.deck.length) { m.deck = shuffle(m.pile, S.r); m.pile = []; if (!m.deck.length) break; } m.hand.push(m.deck.pop()); } }
const spend = (m, id) => { const i = m.hand.indexOf(id); if (i < 0) throw new Error('not in hand: ' + id); m.hand.splice(i, 1); m.pile.push(id); };
export const slipCost = (m) => CARDS.slip.w + (m.cap <= N.tiredAt ? N.slipTired : 0);
export const volleyCost = (v) => v.reduce((s, id) => s + CARDS[id].w, 0);
export function legalVolley(S, a, v) {
  const h = [...S.f[a].hand]; if (v.length > N.volley || volleyCost(v) > S.f[a].wind) return false;
  for (const id of v) { const i = h.indexOf(id); if (i < 0 || CARDS[id].k === 'ans') return false; h.splice(i, 1); }
  return !v.length || CARDS[v[v.length - 1]].k !== 'feint';
}
// the answers a man may lay to ONE punch as it turns. `shown` is the punch, or null when a feint has hidden it (then he
// answers blind, and an answer that cannot meet the punch is wasted). A slip may carry a counter: {id:'slip', with}
export function answers(S, d, shown, i = 0) {
  const m = S.f[d], has = (id) => m.hand.includes(id), c = shown && CARDS[shown], out = [{ id: null }];
  if (has('block') && m.wind >= 1 && (!c || (c.zone === 'head' && !c.unblock))) out.push({ id: 'block' });
  if (has('step') && m.wind >= 1 && !m.ropes && (!c || !c.long)) out.push({ id: 'step' });
  if (has('clinch') && m.wind >= N.clinchW && !m.held && i > 0) out.push({ id: 'clinch' });        // he must have come in behind his first card
  const sc = slipCost(m);
  if (has('slip') && m.wind >= sc) { out.push({ id: 'slip' });                                           // a jab is never countered; nor a punch he cannot see
    if (c && !c.long) for (const p of new Set(m.hand)) if (CARDS[p].k === 'punch' && m.wind >= sc + CARDS[p].w) out.push({ id: 'slip', with: p }); }
  if (c && !c.long && i === 0) for (const p of ['cross', 'hook']) if (has(p) && m.wind >= CARDS[p].w) out.push({ id: p, trade: 1 });   // a trade goes over the LEAD punch only
  return out;
}
const same = (x, y) => x.id === y.id && (x.with || null) === (y.with || null) && !!x.trade === !!y.trade;

function land(S, who, pid, ev, leak = null) {            // a punch from `who` reaches the other man; true = he is down
  const c = CARDS[pid], M = S.f[1 - who], P = S.f[who];
  if (c.zone === 'body') { M.cap = Math.max(N.capMin, M.cap - c.d); M.wind = Math.min(M.wind, M.cap); P.pts += c.s; ev.push({ t: 'body', k: who, id: pid }); return false; }
  if (leak != null) { M.daze += leak; ev.push({ t: 'blocked', k: who, id: pid, dz: leak }); return false; }
  M.daze += c.d; P.pts += c.s; ev.push({ t: 'clean', k: who, id: pid, dz: c.d });
  if (c.power && M.daze >= N.kdAt) {
    M.kds++; M.kdsRound++; P.kdScored++; M.daze = N.kdTo; M.skip = 1; M.hurt = 1; ev.push({ t: 'knockdown', k: 1 - who });
    if (M.cap <= N.koCap) S.over = { win: who, how: 'knockout' };
    else if (M.kdsRound >= N.kdRound || M.kds >= N.kdBout) S.over = { win: who, how: 'stoppage' };
    return true;
  }
  return false;
}
// one exchange. answer(S, d, view) is asked at each punch: view = { i, left, shown, legal, seen: the cards turned so far }
// Cards never turned (the exchange was stopped) go back to the leader's hand and cost him nothing.
export function exchange(S, a, volley, answer, o = {}) {
  const A = S.f[a], d = 1 - a, D = S.f[d], ev = [];
  if (!legalVolley(S, a, volley)) throw new Error('illegal volley: ' + volley.join(','));
  if (!volley.length) { A.wind = Math.min(A.cap, A.wind + N.rest); D.pts += N.restPts; if (N.restFresh) { A.pile.push(...A.hand); A.hand = []; } ev.push({ t: 'rest', k: a }); D.held = 0; return ev; }   // the judges mark the man who will not lead
  A.ropes = 0;
  let blind = !!o.blind, clinched = false; const seen = [];   // o.blind: a bot asks "what if the hidden punch is this one"
  for (let i = 0; i < volley.length; i++) {
    const pid = volley[i], c = CARDS[pid];
    spend(A, pid); A.wind -= c.w;
    if (c.k === 'feint') { ev.push({ t: 'feint', k: a }); blind = true; seen.push(pid); continue; }
    A.thrown++;
    const shown = blind ? null : pid, legal = answers(S, d, shown, o.at ?? i);
    const pick = answer(S, d, { i, left: volley.length - i - 1, shown, legal, seen: [...seen] }) || legal[0];
    const ans = legal.find((x) => same(x, pick)); if (!ans) throw new Error('illegal answer: ' + JSON.stringify(pick));
    blind = false; seen.push(pid);
    let stop = false;
    if (ans.id === 'block') { spend(D, 'block'); D.wind -= 1;
      if (c.zone === 'head' && !c.unblock) land(S, a, pid, ev, c.power ? N.blockLeak : 0); else { ev.push({ t: 'wasted', k: d, id: 'block' }); stop = land(S, a, pid, ev); } }
    else if (ans.id === 'slip') { spend(D, 'slip'); D.wind -= slipCost(D) ; ev.push({ t: 'slipped', k: d, id: pid });
      if (ans.with) { spend(D, ans.with); D.wind -= CARDS[ans.with].w; D.thrown++; ev.push({ t: 'counter', k: d }); land(S, d, ans.with, ev); stop = true; } }
    else if (ans.id === 'step') { spend(D, 'step'); D.wind -= 1; D.ropes = 1;
      if (c.long) { ev.push({ t: 'wasted', k: d, id: 'step' }); stop = land(S, a, pid, ev); } else { ev.push({ t: 'short', k: a, id: pid }); stop = true; } }
    else if (ans.id === 'clinch') { spend(D, 'clinch'); D.wind -= N.clinchW; A.wind = Math.max(0, A.wind - N.clinchW); clinched = true; D.holds++;
      if (D.holds > N.holdFree) { D.pen++; ev.push({ t: 'warned', k: d }); }
      ev.push({ t: 'clinch', k: d, id: pid }); stop = true; }
    else if (ans.trade) { spend(D, ans.id); D.wind -= CARDS[ans.id].w; D.thrown++;
      if (c.long) { ev.push({ t: 'wasted', k: d, id: ans.id }); stop = land(S, a, pid, ev); }
      else { const down = land(S, a, pid, ev); if (!down) { ev.push({ t: 'traded', k: d }); land(S, d, ans.id, ev); } stop = true; } }
    else stop = land(S, a, pid, ev);
    if (stop || S.over) { const back = volley.length - i - 1; if (back) ev.push({ t: 'kept', k: a, n: back }); break; }
  }
  D.held = clinched ? 1 : 0;
  return ev;
}
// the bell: a man who scored a knockdown takes the round 10-8 (10-7 for two); else 10-9 on clean points, the busier man
// when level, else 10-10. A referee's point for holding comes off after that.
export function bell(S) {
  const [x, y] = S.f, kd = x.kdScored - y.kdScored;
  const w = kd ? (kd > 0 ? 0 : 1) : x.pts !== y.pts ? (x.pts > y.pts ? 0 : 1) : x.thrown !== y.thrown ? (x.thrown > y.thrown ? 0 : 1) : -1;
  const lose = 10 - 1 - Math.abs(kd), sc = [w === 1 ? lose : 10, w === 0 ? lose : 10];
  if (w < 0) sc[0] = sc[1] = 10;
  sc[0] -= x.pen; sc[1] -= y.pen; S.cards.push(sc);
  for (const m of S.f) { m.total += m.pts; m.pts = 0; m.kdScored = 0; m.kdsRound = 0; m.pen = 0; m.holds = 0; m.daze = Math.max(0, m.daze - N.bellDaze); m.wind = m.cap;
    m.held = 0; m.ropes = 0; m.skip = 0; m.thrown = 0; m.hurt = 0; m.pile.push(...m.hand); m.hand = []; }
  return sc;
}
export function verdict(S) {
  const t = [0, 1].map((k) => S.cards.reduce((s, c) => s + c[k], 0));
  if (t[0] !== t[1]) return { win: t[0] > t[1] ? 0 : 1, how: 'decision', t };
  const p = S.f.map((m) => m.total);
  return { win: p[0] === p[1] ? -1 : p[0] > p[1] ? 0 : 1, how: p[0] === p[1] ? 'draw' : 'decision on punches', t };
}
export const nextLead = (S, lead) => { const t = [0, 1].map((k) => S.cards.reduce((s, c) => s + c[k], 0)); return t[0] !== t[1] ? (t[0] < t[1] ? 0 : 1) : 1 - lead; };
export function tick(S, x) { for (const k of [0, 1]) { const m = S.f[k]; if (x) { m.wind = Math.min(m.cap, m.wind + N.rec); if (!m.hurt) m.daze = Math.max(0, m.daze - N.fade); } draw(S, k); } }
// a whole bout. pilots[k] = { lead(view, k) -> [ids], answer(view, k, punchView) }. A pilot gets S; an honest one reads
// only its own hand and what is on the table (bot2.mjs `mine`).
export function bout(pilots, seed, o = {}) {
  const S = newBout(seed, o.first || 0); let lead = S.first;
  for (S.round = 1; S.round <= N.rounds && !S.over; S.round++) {
    if (S.round > 1) lead = nextLead(S, lead);
    let a = lead;
    for (let x = 0; x < 2 * N.leads && !S.over; x++, a = 1 - a) {
      tick(S, x);
      if (S.f[a].skip) { S.f[a].skip = 0; o.onEx?.(S, a, null, [{ t: 'count', k: a }]); continue; }
      const before = o.onEx ? snap(S) : null, volley = pilots[a].lead(S, a), asked = [];
      const ev = exchange(S, a, volley, (T, d, view) => { const ans = pilots[d].answer(T, d, view); asked.push({ view, ans }); return ans; });
      o.onEx?.(S, a, volley, ev, before, asked);
    }
    if (!S.over) { const sc = bell(S); o.onBell?.(S, sc); }
  }
  return { S, ...(S.over || verdict(S)) };
}
export const snap = (S) => S.f.map((m) => ({ wind: m.wind, cap: m.cap, daze: m.daze, pts: m.pts, hand: [...m.hand] }));
