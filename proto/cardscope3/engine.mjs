// CARDSCOPE3 greybox: the rally. A turn = answer his volley (guards), it lands, then throw yours and set one trap.
import { CARDS, N, guardEffect } from './cards.mjs';

export function rng(seed) {
  let a = seed >>> 0;
  return () => { a = (a + 0x6d2b79f5) | 0; let t = Math.imul(a ^ (a >>> 15), 1 | a); t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t; return ((t ^ (t >>> 14)) >>> 0) / 4294967296; };
}
export function shuffle(a, r) { for (let i = a.length - 1; i > 0; i--) { const j = Math.floor(r() * (i + 1)); [a[i], a[j]] = [a[j], a[i]]; } return a; }
const zero = () => ({ clean: 0, thrown: 0, dmg: 0, craft: 0, kd: 0 });

export function newBoxer(b, r, cls) {
  return { name: b.name, style: b.style, list: b.deck.slice(), deck: shuffle(b.deck.slice(), r), hand: [], disc: [],
    wind: N.start, cap: (b.cap ?? N.cap) + (cls?.cap || 0), back: b.back ?? N.back, headMax: (b.head ?? N.head) + N.headPlus, head: 0, body: 0,
    pow: (b.pow || 0) + (cls?.pow || 0), kd: 0, set: null, setTrig: [], open: !!cls?.open, watching: false, drain: 0, down: false,
    tieUsed: false, habits: b.habits || [], rd: zero(), tot: zero(), trig: [],
    tally: { turns: 0, cls: { jab: 0, rear: 0, hook: 0 }, lead: { jab: 0, rear: 0, hook: 0 }, sets: {} } };
}
export const hurt = (B) => B.head >= N.hurtAt;
export const kdLine = (B) => (hurt(B) ? N.kdHurt : N.kd);
export function windBack(B) { return Math.max(1, B.back - Math.floor(B.body / N.bodyStep) - B.drain - (B.down ? N.kdBack : 0) - (hurt(B) ? N.hurtBack : 0)); }
export function draw(B, r) {
  while (B.hand.length < N.hand) {
    if (!B.deck.length) { if (!B.disc.length) break; B.deck = shuffle(B.disc, r); B.disc = []; }
    B.hand.push(B.deck.pop());
  }
}
// can `viewer` see the other boxer's set card?
export const seesSet = (S, viewer) => { const D = S.b[1 - viewer]; return !!D.set && (D.open || S.b[viewer].watching); };

// what his volley does to M under these guards (pure). marks[i] = guard card id on punch i, or null
export function resolveIncoming(S, m, marks, tie) {
  const M = S.b[m], D = S.b[1 - m];
  let head = 0, body = 0, clean = 0, craft = 0, drain = 0, evades = 0, landed = 0, prev = false, stopped = 0, blocks = 0;
  for (let i = 0; i < S.inc.length; i++) {
    const p = S.inc[i], c = CARDS[p.id];
    let dm = c.dmg + p.bonus + (prev ? N.chain : 0) + (c.w >= 2 ? D.pow : 0);
    const g = !tie && marks[i] ? guardEffect(marks[i], p.id) : null;
    if (tie) { dm = Math.floor(dm / 2); prev = false; stopped++; }
    else if (g === 'evade' || g === 'parry') { craft++; stopped++; if (g === 'evade') evades++; else blocks++; prev = false; continue; }
    else if (g === 'block') { craft++; stopped++; blocks++; dm = Math.max(0, dm - (c.shape === 'upper' ? N.splitBlock : N.block)); prev = false; }
    else { clean++; prev = true; if (c.drain) drain += c.drain; }
    if (dm > 0) { landed++; if (c.zone === 'head') head += dm; else body += dm; }
  }
  return { head, body, clean, craft, drain, evades, landed, stopped, kd: head >= kdLine(M), ctr: evades ? N.counter : blocks ? N.blockCtr : 0 };
}
const take = (hand, id) => { const i = hand.indexOf(id); if (i < 0) throw new Error('not in hand: ' + id); hand.splice(i, 1); };

export function beginTurn(S, m, bell) {
  const M = S.b[m];
  if (M.set) { S.st.deadTraps++; if (N.trapBack) M.hand.push(M.set); else { reveal(S, m); M.disc.push(M.set); } M.set = null; }
  if (!bell || N.bellBack) { M.wind = Math.min(M.cap, M.wind + Math.max(0, windBack(M) - (S.fresh ? N.leadDry : 0))); M.drain = 0; M.down = false; }
  draw(M, S.r);
  const cl = new Set(S.inc.map((p) => CARDS[p.id].cls));
  M.trig = ['jab', 'rear', 'hook'].filter((c) => cl.has(c)); if (S.inc.length <= 1) M.trig.push('quiet');
}
function reveal(S, m) { const M = S.b[m]; for (const t of M.setTrig) { const o = (M.tally.sets[t] ||= {}); o[M.set] = (o[M.set] || 0) + 1; } }

// plan = { marks:[guard id|null per incoming punch], tie:bool, seq:[punch ids in order], set: trap id|null }
export function applyTurn(S, m, plan, bell) {
  const M = S.b[m], D = S.b[1 - m], st = S.st;
  let cards = 0;
  if (plan.tie) { if (M.tieUsed || M.wind < CARDS.tieup.w) throw new Error('tie up not legal'); take(M.hand, 'tieup'); M.disc.push('tieup'); M.wind -= CARDS.tieup.w; M.tieUsed = true; cards++; }
  else for (const g of plan.marks) if (g) { if (CARDS[g].kind !== 'guard') throw new Error('not a guard'); take(M.hand, g); M.disc.push(g); M.wind -= CARDS[g].w; cards++; }
  if (M.wind < 0) throw new Error('wind');
  if (plan.marks.filter((g) => g && g !== 'parry').length > N.maxGuards) throw new Error('one guard a turn');
  const res = resolveIncoming(S, m, plan.marks, plan.tie);
  const nInc = S.inc.length;
  M.head += res.head; M.body += res.body; M.drain += res.drain;
  for (const T of [D.rd, D.tot]) { T.clean += res.clean; T.dmg += res.head + res.body; }
  for (const T of [M.rd, M.tot]) T.craft += res.craft;
  if (!S.fresh) { st.volleys++; if (!res.landed && !S.sprung) st.blankVolleys++; } S.fresh = false; st.stopped += res.stopped; S.sprung = false;
  S.lastDmg[1 - m] = res.head + res.body;
  S.inc = [];
  if (res.kd) { M.kd++; M.down = true; D.rd.kd++; D.tot.kd++; st.kds++; }
  const out = { res, nInc, cards, firstCls: 'none', sprung: null };
  if (S.over()) return out;
  if (!bell && !res.kd) {
    let first = true;
    for (const id of plan.seq) {
      const c = CARDS[id]; if (c.kind !== 'punch') throw new Error('not a punch');
      take(M.hand, id); M.disc.push(id); M.wind -= c.w; cards++;
      if (M.wind < 0) throw new Error('wind');
      M.rd.thrown++; M.tot.thrown++; st.thrown++;
      if (first) out.firstCls = c.cls;
      if (D.set && CARDS[D.set].catches === c.cls && (first || !N.trapFirst)) {
        const t = CARDS[D.set]; M.head += t.dmg; st.stopped++; S.sprung = true; out.sprung = D.set;
        for (const T of [D.rd, D.tot]) { T.clean++; T.dmg += t.dmg; T.craft++; }
        reveal(S, 1 - m); D.disc.push(D.set); D.set = null;
        if (S.over() || N.trapEnds) break;
      } else S.inc.push({ id, bonus: first ? res.ctr : 0 });
      first = false;
    }
    if (plan.set && !S.over()) {
      if (CARDS[plan.set].kind !== 'trap') throw new Error('not a trap');
      take(M.hand, plan.set); M.wind -= N.trapCost; if (M.wind < 0) throw new Error('wind');
      M.set = plan.set; M.setTrig = M.trig.slice(); cards++; st.sets[m]++;
    }
    M.tally.turns++; if (plan.seq.length) M.tally.lead[CARDS[plan.seq[0]].cls]++;
    for (const c of new Set(plan.seq.map((i) => CARDS[i].cls))) M.tally.cls[c]++;
  }
  st.cardsPlayed += cards; out.cards = cards;
  return out;
}
const TASTES = ['work', 'hurt', 'craft'];
export const judgePts = (T, taste) => 2 * T.clean + (taste === 'work' ? 0.5 * T.thrown : taste === 'hurt' ? T.dmg / 5 : T.craft);

// agents[k] = { act(S,k,bell) -> plan, corner(S,k) -> 'water'|'ice'|'watch', dec?(S,k,plan) } ; boxer 0 is the player
export function bout(P, O, agents, seed, opt = {}) {
  const r = rng(seed), rounds = opt.rounds || N.rounds;
  const S = { b: [newBoxer(P, r, opt.pcls), newBoxer(O, r, opt.cls)], inc: [], r, round: 0, turn: 0, lastTurn: false, cards: [], lastDmg: [0, 0], sprung: false,
    st: { volleys: 0, blankVolleys: 0, stopped: 0, thrown: 0, kds: 0, cardsPlayed: 0, deadTraps: 0, sets: [0, 0], dec: 0, turns: [0, 0], tired: [0, 0], setDown: [0, 0], maxChoices: 0, choices: 0 } };
  S.over = () => S.b.some((B) => B.head >= B.headMax || B.kd >= 3);
  let first = opt.first ?? (r() < 0.5 ? 0 : 1);
  const firstR1 = first;
  const turn = (k, bell) => {
    beginTurn(S, k, bell); const M = S.b[k];
    if (!bell) { S.st.turns[k]++; if (M.wind <= 2) S.st.tired[k]++; if (S.b[1 - k].set) S.st.setDown[1 - k]++; }
    const plan = agents[k].act(S, k, bell);
    if (opt.hook) opt.hook(S, k, plan, bell);
    const o = applyTurn(S, k, plan, bell);
    if (k === 0) S.st.dec += o.cards + 1;
    if (opt.after) opt.after(S, k, plan, o, bell);
  };
  let stopRound = 0;
  for (let rd = 0; rd < rounds && !S.over(); rd++) {
    S.round = rd;
    for (const B of S.b) { B.rd = zero(); B.tieUsed = false; if (B.set) { B.disc.push(B.set); B.set = null; } }
    S.inc = []; S.fresh = true;
    if (N.lastLead && rd === rounds - 1 && rd > 0) { const t = S.cards.flat().reduce((a, c) => a + c[0] - c[1], 0); if (t !== 0) first = t < 0 ? 0 : 1; }
    S.b[1 - first].wind = Math.min(S.b[1 - first].cap, S.b[1 - first].wind + N.coin);
    for (let t = 0; t < N.turns && !S.over(); t++) { S.turn = t; S.lastTurn = t === N.turns - 1; for (const k of [first, 1 - first]) { if (!S.over()) turn(k, false); } }
    if (!S.over() && S.inc.length) turn(first, true);
    if (S.over()) { stopRound = rd + 1; break; }
    S.cards.push(TASTES.map((ts) => {
      const [a, b] = S.b.map((B) => B.rd);
      if (a.kd !== b.kd) return a.kd > b.kd ? [10, 8] : [8, 10];
      const pa = judgePts(a, ts), pb = judgePts(b, ts);
      const w = pa !== pb ? pa > pb : a.dmg !== b.dmg ? a.dmg > b.dmg : r() < 0.5;
      return w ? [10, 9] : [9, 10];
    }));
    if (rd < rounds - 1) {
      for (const k of [0, 1]) S.b[k].watching = false;
      for (const k of [0, 1]) {
        const B = S.b[k], pick = agents[k].corner(S, k);
        B.wind = Math.min(B.cap, B.wind + N.stool);
        if (pick === 'water') B.wind = B.cap; else if (pick === 'ice') B.head = Math.max(0, B.head - N.ice); else B.watching = true;
        if (k === 0) { S.st.dec++; (S.st.corner ||= {})[pick] = (S.st.corner[pick] || 0) + 1; }
      }
    }
    first = 1 - first;
  }
  const [A, B] = S.b; let win, split = false, oneSided, late;
  const tot = (upTo) => TASTES.map((_, j) => S.cards.slice(0, upTo).reduce((s, c) => [s[0] + c[j][0], s[1] + c[j][1]], [0, 0]));
  if (stopRound) {
    const aOut = A.head >= A.headMax || A.kd >= 3, bOut = B.head >= B.headMax || B.kd >= 3;
    win = aOut && bOut ? (r() < 0.5 ? 0 : 1) : aOut ? 1 : 0; oneSided = stopRound < rounds;
  } else {
    const js = tot(rounds).map(([a, b]) => (a !== b ? (a > b ? 0 : 1) : A.tot.dmg !== B.tot.dmg ? (A.tot.dmg > B.tot.dmg ? 0 : 1) : r() < 0.5 ? 0 : 1));
    const n0 = js.filter((x) => x === 0).length; win = n0 >= 2 ? 0 : 1; split = n0 === 1 || n0 === 2;
    oneSided = S.cards.every((c) => c.every((j) => (j[0] > j[1] ? 0 : 1) === win));
  }
  const mid = tot(Math.min(S.cards.length, rounds - 1)).reduce((s, [a, b]) => [s[0] + a, s[1] + b], [0, 0]);
  late = mid[win] <= mid[1 - win];
  return { win, stop: !!stopRound, stopRound, split, oneSided, late, firstR1, st: S.st, dealt: A.tot.dmg, taken: B.tot.dmg, headA: A.head, headB: B.head, S };
}
