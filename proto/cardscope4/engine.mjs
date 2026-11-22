// CARDSCOPE4 greybox: the rally on a strip. A turn = answer his volley with ONE answer, it resolves in order, then
// lay your own volley face up (cards and steps, one at a time). Nothing is rolled; a card that is no longer legal
// when it resolves (he stopped the entry) whiffs.
import { CARDS, N } from './cards.mjs';

export function rng(seed) {
  let a = seed >>> 0;
  return () => { a = (a + 0x6d2b79f5) | 0; let t = Math.imul(a ^ (a >>> 15), 1 | a); t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t; return ((t ^ (t >>> 14)) >>> 0) / 4294967296; };
}
export function shuffle(a, r) { for (let i = a.length - 1; i > 0; i--) { const j = Math.floor(r() * (i + 1)); [a[i], a[j]] = [a[j], a[i]]; } return a; }
const BIT = { a: 1, A: 2, l: 4, L: 8, h: 16 }, VB = { K: 1, P: 2, C: 4, G: 8 };
const KPs = ['K', 'P'], GG = ['G'];

export function newFighter(F, r) {
  return { name: F.name, style: F.style, mech: F.mech !== false, list: F.deck.slice(), deck: shuffle(F.deck.slice(), r), hand: [], disc: [],
    hp: N.hp, pts: 0, wind: N.start, lit: 31, dark: 0, drain: 0, dealt: 0, ctr: 0, chain: 0, free: 0 };
}
const cf = (F) => ({ ...F, hand: F.hand.slice() });
export function clone(S) {
  const c = { ...S, f: [cf(S.f[0]), cf(S.f[1])], inc: S.inc.slice(), hold: S.hold && { ...S.hold }, grip: S.grip && { ...S.grip }, tie: S.tie && { ...S.tie }, ctx: { ...S.ctx }, st: null, pj: null };
  if (S.pj) c.pj = clone(S.pj);
  return c;
}
export const posKey = (S, m) => (S.pos !== 'G' ? S.pos : (S.top === m ? 'T' : 'B') + S.rung);
export function fits(at, key) { for (const a of at) if (a === key || (key.length === 2 && (a === key[0] || a === 'G'))) return true; return false; }
export function draw(M, r) {
  while (M.hand.length < N.hand) {
    if (!M.deck.length) { if (!M.disc.length) break; M.deck = shuffle(M.disc, r); M.disc = []; }
    M.hand.push(M.deck.pop());
  }
}
function limbMask(F, L) {
  let m = 0;
  for (const ch of L) {
    const free = F.lit & ~m;
    const b = ch === 'x' ? (free & 2 ? 2 : free & 1) : ch === 'y' ? (free & 8 ? 8 : free & 4) : BIT[ch] & free;
    if (!b) return -1; m |= b;
  }
  return m;
}
export function canPay(F, [w, L]) { return (N.mode === 'limb' || F.wind >= w) && (N.mode === 'wind' || limbMask(F, L) >= 0); }
function pay(F, [w, L]) { if (N.mode !== 'limb') F.wind -= w; if (N.mode !== 'wind') F.lit &= ~limbMask(F, L); }
export function cost(S, m, id) {
  if (id === '@in' || id === '@out') return [N.stepW, 'y'];
  if (id === '@stand') return [S.rung === 0 ? N.standW + 1 : N.standW, 'y'];
  if (id === '@cover') return [N.coverW, 'x'];
  if (id === '@room') return [N.roomW, 'h'];
  if (id === '@up') return [N.upW, 'hy'];
  const c = CARDS[id], M = S.f[m];
  if (c.k === 'hold' && ((M.chain && M.style === 'bjj') || (M.free && c.leg))) return [0, ''];
  return [c.w, c.L];
}
// is this card or step legal where the bout stands now (position and status; not its price)
export function legalNow(S, m, id) {
  if (S.over) return false;
  const M = S.f[m], G = S.pos === 'G';
  if (id === '@in') return !G && S.pos !== 'C';
  if (id === '@out') return !G && S.pos !== 'K' && !(S.grip && S.grip.by !== m);
  if (id === '@stand') return G && S.top === m && !S.hold;
  if (id === '@up') return G && S.top !== m && !S.hold;
  if (S.hold) return false;
  const c = CARDS[id];
  if (c.k === 'ans') {
    if (c.act) return G && S.top !== m;
    if (c.fx === 'sprawl' || c.fx === 'headlock') return !!((S.grip && S.grip.by !== m) || (S.tie && S.tie.by !== m));
    return false;
  }
  if (c.needGrip && M.mech && !(S.grip && S.grip.by === m && S.grip.pass < S.pass)) return false;
  let at = c.at;
  if (M.mech && (c.blitz || c.enter)) at = KPs;
  if (M.mech && M.style === 'bjj' && c.k === 'hold' && M.chain) at = GG;
  return fits(at, posKey(S, m));
}
// a clean takedown cannot be answered: the judo grip, the wrestler's read of the tie-up
export function shotClean(S, a, c, pass = S.pass) {
  const A = S.f[a];
  if (!A.mech) return false;
  if (c.needGrip) return true;
  if (c.cleanIf === 'grip') return !!S.grip && S.grip.by === a && S.grip.pass < pass;
  if (c.cleanIf === 'struck' || c.cleanIf === 'quiet') return !!S.tie && S.tie.by === a && S.tie.pass < pass && S.tie.struck === (c.cleanIf === 'struck');
  return false;
}
const fxOf = (id) => (id === '@cover' ? 'cover' : CARDS[id].fx);
// does answer `id` stop pending card p (thrown by a)?
export function ansFits(S, a, id, p) {
  const c = CARDS[p.id]; if (!c) return false;
  const fx = fxOf(id), ground = !!c.at && c.at[0][0] === 'T';
  if (fx === 'cover' || fx === 'block') return c.k === 'strike' && !c.unblock;
  if (fx === 'slip') return c.k === 'strike' && !c.kick && !ground;
  if (fx === 'evade') return (c.k === 'strike' && !ground) || c.k === 'setup';
  if (fx === 'tiein') return c.k === 'strike' && !ground;
  if (fx === 'catch') return !!c.kick;
  if (fx === 'sprawl' || fx === 'headlock') return c.k === 'setup' || (c.k === 'shot' && !shotClean(S, a, c, S.pass + 1));
  if (fx === 'escape') return c.k === 'hold' || c.k === 'adv';
  return false;
}
function end(S, win, how) { if (!S.over) S.over = { win, how }; }
function checkOver(S) {
  for (const k of [0, 1]) if (S.f[k].hp <= 0) end(S, 1 - k, 'ko');
  if (N.clkPts) for (const k of [0, 1]) if (S.f[k].pts - S.f[1 - k].pts >= N.lead) end(S, k, 'lead');
}
function stand(S, pos) { S.pos = pos; S.top = -1; S.rung = 0; S.stall = 0; S.hold = null; }
function ground(S, top, rung) { S.pos = 'G'; S.top = top; S.rung = rung; S.stall = 0; S.grip = S.tie = null; }
function drainHim(D) { if (N.mode === 'limb') D.dark |= 16; else D.drain = Math.min(N.drainCap, D.drain + 1); }
function finishHold(S) {
  const h = S.hold; if (S.st) S.st.holdDone++;
  if (h.kind === 'sub') end(S, h.by, 'tap'); else { S.f[h.by].pts += h.pts; stand(S, 'K'); checkOver(S); if (S.over && S.over.how === 'lead') S.over.how = 'pin'; }
}
function resolveOne(S, a, p, ans) {
  const d = 1 - a, A = S.f[a], D = S.f[d], id = p.id, x = S.ctx;
  if (S.over) return;
  if (!legalNow(S, a, id)) { x.prev = false; x.combo = 0; if (S.st) S.st.whiff++; return; }
  if (id === '@in') { S.pos = S.pos === 'K' ? 'P' : 'C'; return; }
  if (id === '@out') { S.pos = S.pos === 'C' ? 'P' : 'K'; S.tie = null; return; }
  if (id === '@stand') { stand(S, 'P'); return; }
  if (id === '@up') { if (S.rung <= 1) stand(S, 'P'); else S.rung -= 2; return; }
  const c = CARDS[id], fx = ans ? fxOf(ans) : null;
  if (c.k === 'ans') { if (c.act) { if (S.rung <= 1) stand(S, 'P'); else S.rung -= 2; } else S.grip = S.tie = null; return; }
  if (c.k === 'strike') {
    if (S.pos === 'K' && A.mech && (c.enter || c.blitz)) S.pos = 'P';
    let dmg = c.dmg + (x.prev && A.mech && A.style === 'boxing' ? N.chain : 0) + (p.b || 0), clean = true;
    if (fx === 'block') { dmg = Math.max(0, dmg - N.block); clean = false; }
    else if (fx === 'cover') { dmg = Math.max(0, dmg - N.cover); clean = false; }
    else if (fx === 'tiein') { dmg = Math.max(0, dmg - N.tiein); clean = false; S.pos = 'C'; }
    else if (fx) {
      if (fx === 'slip') D.ctr = N.counter;
      else if (fx === 'evade') { if (D.mech) S.pos = 'K'; }
      else if (fx === 'catch') { ground(S, d, 0); D.pts += N.catchPts; if (D.mech && D.style === 'sambo') D.free = 1; }
      x.prev = false; x.combo = 0; return;
    }
    if (clean) {
      x.combo = id === 'jab' ? 1 : id === 'cross' && x.combo === 1 ? 2 : id === 'hook' && x.combo === 2 ? 3 : 0;
      if (x.combo === 3 && A.mech && A.style === 'boxing') { dmg += N.comboDmg; A.pts += N.comboPts; if (S.st) S.st.combos++; }
      A.pts += c.pts || 0;
      if (c.drain) drainHim(D);
      if (c.cripple) { if (N.mode === 'wind') drainHim(D); else D.dark |= 4; }
    } else x.combo = 0;
    D.hp -= dmg; A.dealt += dmg; x.prev = clean; if (S.pos === 'G') S.stall = 0;
    return;
  }
  x.prev = false; x.combo = 0;
  if (c.k === 'shot') {
    const clean = shotClean(S, a, c);
    if (fx && !clean) { if (fx === 'headlock') D.pts += N.headlockPts; if (S.st) S.st.stuffed++; return; }
    ground(S, a, c.to); A.pts += c.pts + ((clean && c.gripPts) || 0); D.hp -= c.dmg || 0; A.dealt += c.dmg || 0;
    if (A.mech && A.style === 'sambo' && !c.sweep) A.free = 1;
    if (S.st) S.st.downs++;
  } else if (c.k === 'setup') {
    if (fx) { if (fx === 'headlock') D.pts += N.headlockPts; if (fx === 'evade' && D.mech) S.pos = 'K'; return; }
    if (id === 'grip') { S.grip = { by: a, pass: S.pass }; S.pos = 'C'; } else S.tie = { by: a, pass: S.pass, struck: false };
  } else if (c.k === 'hold') {
    if (fx) { if (A.mech && A.style === 'bjj') A.chain = 1; if (S.top === a) S.rung = Math.max(0, S.rung - 1); return; }
    if (!N.clkHold) return;
    S.stall = 0; if (S.st) S.st.holdOn++;
    if (N.holdRoll && S.st) { if (S.r() < N.holdRoll) { S.hold = { by: a, kind: c.hk, pts: c.hpts || 0 }; finishHold(S); } return; }
    S.hold = { by: a, kind: c.hk, count: c.count, price: N.sq0, room: false, pts: c.hpts || 0 };
  } else if (c.k === 'adv') {
    if (fx) return;
    S.rung = Math.min(3, S.rung + 1); A.pts += c.pts; S.stall = 0;
  } else if (c.k === 'move') ground(S, d, 0);
}
// m answers the volley thrown at him; ans = { id, i } (i = which pending card; -1 = the hold he is in) or null
export function resolveIncoming(S, m, ans) {
  const a = 1 - m, A = S.f[a];
  S.pass++; S.ctx = { prev: false, combo: 0 };
  if (S.hold && S.hold.by === a) {
    if (ans && ans.id === 'escape') { S.hold = null; if (A.mech && A.style === 'bjj') A.chain = 1; if (S.top === a) S.rung = Math.max(0, S.rung - 1); if (S.st) S.st.escaped++; }
    else if (ans && ans.id === '@room') S.hold.room = true;
    else if (--S.hold.count <= 0) finishHold(S);
  }
  const inc = S.inc; S.inc = []; let struck = false; const stopped = !!(ans && ans.i >= 0);
  for (let i = 0; i < inc.length && !S.over; i++) {
    resolveOne(S, a, inc[i], ans && ans.i === i ? ans.id : null); checkOver(S);
    if (CARDS[inc[i].id]?.k === 'strike') struck = true;
    if (S.st) S.st.vis |= VB[S.pos];
  }
  if (!S.over && struck && !stopped && A.mech && A.style === 'karate' && S.pos === 'P' && !(S.grip && S.grip.by === m)) S.pos = 'K';
  if (S.grip && S.grip.by === a && S.grip.pass < S.pass) S.grip = null;
  if (S.tie && S.tie.by === a && S.tie.pass < S.pass) S.tie = null;
  if (S.st) S.st.vis |= VB[S.pos];
}
export function answerOptions(S, m) {
  const M = S.f[m], out = [null];
  if (S.hold && S.hold.by !== m) {
    if (M.hand.includes('escape') && canPay(M, cost(S, m, 'escape'))) out.push({ id: 'escape', i: -1 });
    if (!S.hold.room && canPay(M, cost(S, m, '@room'))) out.push({ id: '@room', i: -1 });
    return out;
  }
  for (const id of [...new Set(M.hand.filter((k) => CARDS[k].k === 'ans')), '@cover']) {
    if (!canPay(M, cost(S, m, id))) continue;
    for (let i = 0; i < S.inc.length; i++) if (ansFits(S, 1 - m, id, S.inc[i])) out.push({ id, i });
  }
  return out;
}
export function beginTurn(S, m, bell) {
  const M = S.f[m];
  if (!bell) { M.wind = Math.min(N.cap, M.wind + Math.max(0, N.back - M.drain)); M.drain = 0; M.lit = 31 & ~M.dark; M.dark = 0; }
  if (!bell && N.redraw && !(S.hold && S.hold.by !== m)) { if (S.st) M.disc.push(...M.hand); M.hand = []; } // a held fighter keeps the hand he has
  else if (!bell && M.hand.length >= N.hand && N.cycle) { const old = M.hand.shift(); if (S.st) M.disc.push(old); }
  draw(M, S.r);
}
function discard(S, M, id) { const i = M.hand.indexOf(id); if (i < 0) throw new Error('not in hand: ' + id); M.hand.splice(i, 1); if (S.st) M.disc.push(id); }
export function doAnswer(S, m, ans) {
  const M = S.f[m];
  if (ans) {
    if (!answerOptions(S, m).some((o) => o && o.id === ans.id && o.i === ans.i)) throw new Error('answer not legal: ' + ans.id);
    pay(M, cost(S, m, ans.id)); if (ans.id[0] !== '@') discard(S, M, ans.id);
    if (ans.id === '@room' && S.st) { for (let n = 0; n < N.roomDraw; n++) { const i = M.hand.findIndex((x) => x !== 'escape'); if (i >= 0) discard(S, M, M.hand[i]); } draw(M, S.r); }
  }
  resolveIncoming(S, m, ans);
  const h = S.hold; // the holder squeezes: a rising price, or he lets go
  if (h && h.by === m && !S.over) { const c = [h.price, 'aA']; if (canPay(M, c)) { pay(M, c); h.price++; } else { S.hold = null; if (S.st) S.st.letGo++; } }
}
export function startAct(S) { S.pj = clone(S); S.pj.pass++; S.pj.ctx = { prev: false, combo: 0 }; }
export const canAct = (S) => !S.over && !S.hold;
// lay one card or step: paid now, shown face up, resolved on his turn. S.pj is what happens if he stands still.
export function declare(S, m, id) {
  const M = S.f[m], c = cost(S, m, id);
  if (!legalNow(S.pj, m, id) || !canPay(M, c)) throw new Error('not legal: ' + id);
  if (id[0] !== '@') discard(S, M, id);
  pay(M, c); S.pj.f[m].wind = M.wind; S.pj.f[m].lit = M.lit;
  const p = { id, b: 0 };
  if (CARDS[id]?.k === 'strike') { p.b = M.ctr; M.ctr = 0; if (S.tie && S.tie.by !== m) S.tie.struck = true; }
  S.inc.push(p); resolveOne(S.pj, m, p, null);
}
export function endAct(S, m) {
  const M = S.f[m]; M.ctr = 0; M.chain = 0; M.free = 0; S.pj = null;
  if (S.pos === 'G' && S.top === m && !S.hold) {
    if (!S.inc.some((p) => p.id[0] !== '@')) S.stall++;
    if (S.stall >= N.stallMax) { stand(S, 'K'); S.inc = []; if (S.st) S.st.refUps++; }
  }
}
export function newBout(F0, F1, seed) {
  const r = rng(seed);
  return { f: [newFighter(F0, r), newFighter(F1, r)], pos: 'K', top: -1, rung: 0, inc: [], hold: null, grip: null, tie: null, stall: 0, pass: 0, ctx: { prev: false, combo: 0 }, over: null, r, pj: null, round: 0, turn: 0,
    st: { vis: 1, whiff: 0, stuffed: 0, downs: 0, holdOn: 0, holdDone: 0, escaped: 0, letGo: 0, refUps: 0, combos: 0, dec: [0, 0], turns: [0, 0], cards: [0, 0], quiet: [0, 0], choices: 0, steps: 0, maxCh: 0, held: [0, 0], secs: [0, 0], played: [{}, {}], log: [[], []] } };
}
// agents[k] = { answer(S,k) -> {id,i}|null, act(S,k) -> [ids] }
export function bout(F0, F1, agents, seed, opt = {}) {
  const S = newBout(F0, F1, seed), st = S.st;
  let first = opt.first ?? (S.r() < 0.5 ? 0 : 1);
  const turn = (k, bell) => {
    beginTurn(S, k, bell);
    const opts = S.inc.length || (S.hold && S.hold.by !== k) ? answerOptions(S, k) : [null];
    const ans = opts.length > 1 ? agents[k].answer(S, k, opts) : null;
    if (opts.length > 1) st.dec[k]++;
    if (opt.onAnswer) opt.onAnswer(S, k, ans, opts);
    doAnswer(S, k, ans);
    if (bell || !canAct(S)) return;
    st.turns[k]++; startAct(S);
    const seq = agents[k].act(S, k);
    if (opt.onAct) opt.onAct(S, k, seq);
    for (const id of seq) { declare(S, k, id); if (id[0] !== '@') st.played[k][id] = 1; }
    st.dec[k] += seq.length + 1; st.cards[k] += seq.length; if (!seq.length) st.quiet[k]++;
    st.log[k].push({ pos: posKey(S, k), kinds: seq.map((id) => (id[0] === '@' ? 'step' : CARDS[id].k)), ans: ans ? 1 : 0 });
    endAct(S, k);
  };
  for (let rd = 0; rd < N.rounds && !S.over; rd++) {
    S.round = rd; stand(S, 'K'); S.inc = []; S.grip = S.tie = null;
    if (rd) for (const B of S.f) B.wind = Math.min(N.cap, B.wind + N.stool);
    for (let t = 0; t < N.turns && !S.over; t++) { S.turn = t; for (const k of [first, 1 - first]) if (!S.over) turn(k, false); }
    if (!S.over && (S.inc.length || (S.hold && S.hold.by !== first))) turn(first, true);
    first = 1 - first;
  }
  const [A, B] = S.f; let win, how;
  if (S.over) ({ win, how } = S.over);
  else {
    const sa = (N.clkPts ? A.pts : 0) + A.dealt / N.dmgPer, sb = (N.clkPts ? B.pts : 0) + B.dealt / N.dmgPer;
    win = sa !== sb ? (sa > sb ? 0 : 1) : A.hp !== B.hp ? (A.hp > B.hp ? 0 : 1) : S.r() < 0.5 ? 0 : 1; how = 'cards';
  }
  return { win, how, early: !!S.over, st, S };
}
