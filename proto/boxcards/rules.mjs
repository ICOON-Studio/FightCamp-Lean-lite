// BOXCARDS1 (S550, CARDBOX_SCOPE_S549 phase 2-3): boxer v boxer only, a fresh small engine. No dice in a resolution:
// the only chance is the draw. A bout is 3 rounds; in a round each man leads 3 times, turn about. The leader lays a
// VOLLEY of up to 3 cards face up; the other man lays ONE answer. One answer cannot cover three punches.
// Every number is in N so a probe can sweep it: node probe.mjs name=value
export const N = {
  rounds: 3, leads: 3, hand: 5, volley: 3,
  cap: 6, rec: 3, capMin: 2, rest: 2,          // wind: the pool, back each exchange, the floor body work can push it to
  blockOff: 2, counterPlus: 0, slipPlus: 2, slipTired: 1, tiredAt: 4, clinchW: 1,
  kdAt: 7, kdTo: 6, bellDaze: 1, fade: 1, koCap: 3, kdRound: 2, kdBout: 3, kdCap: 0,
};
// k: punch | feint | ans. w wind, d daze (head) or cap (body), s the judges' points for a clean one
export const CARDS = {
  jab:    { n: 'Jab',       k: 'punch', w: 1, d: 1, s: 1, zone: 'head', long: 1 },
  cross:  { n: 'Cross',     k: 'punch', w: 2, d: 3, s: 2, zone: 'head', power: 1, counter: 1 },
  hook:   { n: 'Lead hook', k: 'punch', w: 2, d: 3, s: 2, zone: 'head', power: 1, counter: 1 },
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
const shuffle = (a, r) => { for (let i = a.length - 1; i > 0; i--) { const j = Math.floor(r() * (i + 1)); [a[i], a[j]] = [a[j], a[i]]; } return a; };

export function newBout(seed, first = 0) {
  const r = rng(seed);
  const man = () => ({ deck: shuffle(deckList(), r), pile: [], hand: [], wind: N.cap, cap: N.cap, daze: 0, kds: 0, kdsRound: 0,
    pts: 0, card: 0, total: 0, ready: 0, ropes: 0, held: 0, skip: 0, thrown: 0 });
  return { r, f: [man(), man()], round: 1, first, log: [], over: null, cards: [] };
}
export function draw(S, k) { const m = S.f[k]; while (m.hand.length < N.hand) { if (!m.deck.length) { m.deck = shuffle(m.pile, S.r); m.pile = []; if (!m.deck.length) break; } m.hand.push(m.deck.pop()); } }
const spend = (m, ids) => { for (const id of ids) { const i = m.hand.indexOf(id); if (i < 0) throw new Error('not in hand: ' + id); m.hand.splice(i, 1); m.pile.push(id); } };
export const slipCost = (m) => CARDS.slip.w + (m.cap <= N.tiredAt ? N.slipTired : 0);
export const volleyCost = (v) => v.reduce((s, id) => s + CARDS[id].w, 0);

// the answers a man may lay to a volley: {id, at?} - slip names the punch it makes miss; a counter is a cross or hook
export function answers(S, d, volley) {
  const m = S.f[d], out = [{ id: null }], has = (id) => m.hand.includes(id);
  if (!volley.length) return out;
  if (has('block') && m.wind >= CARDS.block.w) out.push({ id: 'block' });
  if (has('step') && m.wind >= CARDS.step.w && !m.ropes) out.push({ id: 'step' });
  if (has('clinch') && m.wind >= N.clinchW && !m.held) out.push({ id: 'clinch' });
  if (has('slip') && m.wind >= slipCost(m)) volley.forEach((id, i) => { if (CARDS[id].k === 'punch' && !(i > 0 && volley[i - 1] === 'feint')) out.push({ id: 'slip', at: i }); });
  // a counter goes over a power punch or a body punch that LEADS a volley; never over a jab (he is at the end of it) or a feint
  const open = CARDS[volley[0]];
  if (open.k === 'punch' && !open.long) for (const id of ['cross', 'hook']) if (has(id) && m.wind >= CARDS[id].w) out.push({ id, counter: 1 });
  return out;
}

// one exchange, on a copy-free state: returns the lines of what happened. a leads, d answers.
export function resolve(S, a, volley, ans) {
  const A = S.f[a], D = S.f[d_of(a)], ev = [], d = d_of(a);
  spend(A, volley); A.wind -= volleyCost(volley); A.thrown += volley.filter((x) => CARDS[x].k === 'punch').length;
  if (volley.length) A.ropes = 0;                       // a man who leads has come off the ropes
  if (!volley.length) { A.wind = Math.min(A.cap, A.wind + N.rest); ev.push({ t: 'rest', k: a }); D.held = 0; return ev; }
  const id = ans.id;
  if (id) { spend(D, [id]); D.wind -= id === 'slip' ? slipCost(D) : id === 'clinch' ? N.clinchW : CARDS[id].w; }
  if (id === 'clinch') A.wind = Math.max(0, A.wind - N.clinchW);
  D.held = id === 'clinch' ? 1 : 0; if (id === 'step') D.ropes = 1;
  const land = (who, to, pid, plus = 0, off = 0) => {    // a punch reaches `to`
    const c = CARDS[pid], M = S.f[to];
    if (c.zone === 'body') { M.cap = Math.max(N.capMin, M.cap - c.d); M.wind = Math.min(M.wind, M.cap); S.f[who].pts += c.s; ev.push({ t: 'body', k: who, id: pid }); return 0; }
    const dz = Math.max(0, c.d + plus - off); const clean = off === 0;
    M.daze += dz; if (clean) S.f[who].pts += c.s;
    ev.push({ t: clean ? 'clean' : 'blocked', k: who, id: pid, dz });
    if (clean && c.power && M.daze >= N.kdAt) return knock(S, to, ev);
    return 0;
  };
  let bonus = A.ready ? N.slipPlus : 0; A.ready = 0;
  for (let i = 0; i < volley.length; i++) {
    const pid = volley[i], c = CARDS[pid];
    if (c.k === 'feint') { ev.push({ t: 'feint', k: a }); if (id === 'clinch' && i === 0) { ev.push({ t: 'clinch', k: d }); break; } continue; }
    if (ans.counter && i === 0) {                         // he takes the first punch and fires back; the volley ends there
      const down = land(a, d, pid, bonus); bonus = 0;
      if (!down && !S.over) land(d, a, id, N.counterPlus), ev.push({ t: 'countered', k: d });
      break;
    }
    if (id === 'slip' && ans.at === i) { ev.push({ t: 'slipped', k: d, id: pid }); D.ready = 1; bonus = 0; continue; }
    if (id === 'step' && !c.long) { ev.push({ t: 'short', k: a, id: pid }); bonus = 0; continue; }
    const off = id === 'block' && c.zone === 'head' && !c.unblock ? N.blockOff : 0;
    const down = land(a, d, pid, bonus, off); bonus = 0;
    if (down || S.over) break;
    if (id === 'clinch') { ev.push({ t: 'clinch', k: d }); break; }
  }
  return ev;
}
const d_of = (a) => 1 - a;
function knock(S, k, ev) {
  const M = S.f[k]; M.kds++; M.kdsRound++; M.card--; M.daze = N.kdTo; M.skip = 1; M.hurt = 1; M.cap = Math.max(N.capMin, M.cap - N.kdCap);
  ev.push({ t: 'knockdown', k });
  if (M.cap <= N.koCap) S.over = { win: 1 - k, how: 'knockout' };
  else if (M.kdsRound >= N.kdRound || M.kds >= N.kdBout) S.over = { win: 1 - k, how: 'stoppage' };
  return 1;
}
// the bell: the round goes 10-9 to the man with more clean points (10-10 level), each knockdown took a point already
export function bell(S) {
  const [x, y] = S.f, lvl = x.pts === y.pts, w = lvl ? (x.thrown === y.thrown ? -1 : x.thrown > y.thrown ? 0 : 1) : x.pts > y.pts ? 0 : 1;   // level on clean punches: the busier man
  const sc = [10 + x.card - (w === 1 ? 1 : 0), 10 + y.card - (w === 0 ? 1 : 0)];
  S.cards.push(sc);
  for (const m of S.f) { m.total += m.pts; m.pts = 0; m.card = 0; m.kdsRound = 0; m.daze = Math.max(0, m.daze - N.bellDaze); m.wind = m.cap; m.held = 0; m.ropes = 0; m.skip = 0; m.ready = 0; m.thrown = 0; m.hurt = 0; m.pile.push(...m.hand); m.hand = []; }   // the corner: a fresh hand
  return sc;
}
export function verdict(S) {
  const t = [0, 1].map((k) => S.cards.reduce((s, c) => s + c[k], 0));
  if (t[0] !== t[1]) return { win: t[0] > t[1] ? 0 : 1, how: 'decision', t };
  const p = S.f.map((m) => m.total);
  return { win: p[0] === p[1] ? -1 : p[0] > p[1] ? 0 : 1, how: p[0] === p[1] ? 'draw' : 'decision on punches', t };
}
// a whole bout. pilots[k] = { lead(S, k) -> [ids], answer(S, k, volley, legal) -> one of legal }. hooks for a probe.
export function bout(pilots, seed, o = {}) {
  const S = newBout(seed, o.first || 0);
  let lead = S.first;
  for (S.round = 1; S.round <= N.rounds && !S.over; S.round++) {
    if (S.round > 1) { const t = S.f.map((m, k) => S.cards.reduce((s, c) => s + c[k], 0)); if (t[0] !== t[1]) lead = t[0] < t[1] ? 0 : 1; else lead = 1 - lead; }
    let a = lead;
    for (let x = 0; x < 2 * N.leads && !S.over; x++, a = 1 - a) {
      for (const k of [0, 1]) { const m = S.f[k]; m.wind = Math.min(m.cap, m.wind + (x ? N.rec : 0)); if (x && !m.hurt) m.daze = Math.max(0, m.daze - N.fade); draw(S, k); }   // a man who has been down this round does not clear his head before the bell
      if (S.f[a].skip) { S.f[a].skip = 0; o.onEx?.(S, a, null, null, [{ t: 'count', k: a }]); continue; }
      const volley = pilots[a].lead(S, a), legal = answers(S, 1 - a, volley);
      const ans = volley.length ? pilots[1 - a].answer(S, 1 - a, volley, legal) : { id: null };
      const before = o.onEx ? snap(S) : null, ev = resolve(S, a, volley, ans);
      o.onEx?.(S, a, volley, ans, ev, before, legal);
    }
    if (!S.over) { const sc = bell(S); o.onBell?.(S, sc); }
  }
  return { S, ...(S.over || verdict(S)) };
}
export const snap = (S) => S.f.map((m) => ({ wind: m.wind, cap: m.cap, daze: m.daze, pts: m.pts, hand: [...m.hand] }));
