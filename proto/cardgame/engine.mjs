// CARDSCOPE5 greybox: the rally on a strip. A turn = answer his volley with ONE answer, it resolves in order, then
// lay your own volley face up (cards and steps, one at a time). Nothing is rolled; a card that is no longer legal
// when it resolves (he stopped the entry) whiffs.
import { CARDS, N } from './cards.mjs';

export function rng(seed) {
  let a = seed >>> 0;
  return () => { a = (a + 0x6d2b79f5) | 0; let t = Math.imul(a ^ (a >>> 15), 1 | a); t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t; return ((t ^ (t >>> 14)) >>> 0) / 4294967296; };
}
export function shuffle(a, r) { for (let i = a.length - 1; i > 0; i--) { const j = Math.floor(r() * (i + 1)); [a[i], a[j]] = [a[j], a[i]]; } return a; }
const BIT = { a: 1, A: 2, l: 4, L: 8, h: 16 }, VB = { K: 1, P: 2, C: 4, G: 8 };
const KPs = ['K', 'P'], PCs = ['P', 'C'], TOPS = ['T1', 'T2', 'T3'];

export function newFighter(F, r) {
  return { name: F.name, style: F.style, mech: F.mech !== false, list: F.deck.slice(), deck: shuffle(F.deck.slice(), r), hand: [], disc: [],
    hp: N.hp, pts: 0, wind: N.start, lit: 31, dark: 0, drain: 0, dealt: 0, ctr: 0, chain: 0, free: 0, lame: 0 };
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
  if (id === '@in' || id === '@out') return [N.stepW + (S.f[m].lame ? 1 : 0), 'y']; // a kicked leg: steps cost 1 more for a turn
  if (id === '@stand') return [S.rung === 0 ? N.standW + 1 : N.standW, 'y'];
  if (id === '@cover') return [N.coverW, 'x'];
  if (id === '@pull') return [N.pullW, 'h'];
  if (id === '@break') return [S.hold.brk, ''];
  if (id === '@up') return [N.upW, 'hy'];
  const c = CARDS[id], M = S.f[m], Q = S.pj;
  if (Q && M.mech && c.k === 'strike') { // the two strikers' own mechanics are prices: what a line costs
    const last = S.inc[S.inc.length - 1], lc = last && CARDS[last.id];
    if (M.style === 'boxing' && !c.kick && lc && lc.k === 'strike' && !lc.kick) return [Math.max(0, c.w - 1), c.L];
    if (M.style === 'kickboxing' && Q.ctx.lastT && Q.ctx.lastT !== kindOf(c)) return [Math.max(0, c.w - 1), c.L]; // hands and feet
    if (M.style === 'karate' && c.w > 1 && c.blitz && Q.pos === 'K') return [c.w - 1, c.L];
  }
  return [c.w, c.L];
}
const SR = ['K', 'P', 'C'];
const kindOf = (c) => (c.kick ? 'k' : c.kneeC ? 'n' : 'p');
// kickboxing's own mechanic: a strike of another kind than his last goes to its own range by itself: a punch behind a
// kick steps in to PUNCH, the knee behind a punch takes the CLINCH, a punch behind the knee pushes off back to PUNCH
const carries = (S, M, c) => (M.mech && M.style === 'kickboxing' && c.k === 'strike' ? (S.pos === 'K' && kindOf(c) === 'p' && S.ctx.lastT === 'k' ? 'P' : S.pos === 'P' && c.kneeC && S.ctx.lastT === 'p' ? 'C' : S.pos === 'C' && kindOf(c) === 'p' && S.ctx.lastT === 'n' ? 'P' : null) : null);
// where a card is playable for this fighter: the printed ranges, widened or narrowed by his art's own mechanic
export function atFor(F, c) {
  let at = c.at; if (!at) return at;
  if (F.mech) {
    if (c.enter || c.blitz || (c.kick && (F.style === 'karate' || F.style === 'kickboxing'))) at = KPs; // the kickboxer kicks from PUNCH range and stays there
    if (F.style === 'wrestling' && c.k === 'shot') at = SR;
    if (F.style === 'boxing' && c.inside) at = PCs; // infighting: the short punches work in the CLINCH
    if (F.style === 'sambo' && c.k === 'shot') at = PCs; // the sambo throw goes off the punch exchange: no clinch needed first
  }
  if (c.leg && !(F.mech && F.style === 'sambo')) at = TOPS; // a leg lock from any place on the ground is sambo's; without it, it needs a settled top position like any lock
  if (!(F.mech && F.style === 'bjj') && at.some((a) => a[0] === 'B')) at = at.filter((a) => a[0] !== 'B'); // the guard is BJJ's
  return at;
}
// is this card or step legal where the bout stands now (position and status; not its price)
export function legalNow(S, m, id) {
  if (S.over) return false;
  const M = S.f[m], G = S.pos === 'G';
  if (id === '@in') return !G && S.pos !== 'C';
  if (id === '@out') return !G && S.pos !== 'K' && !(S.grip && S.grip.by !== m && !(M.mech && M.style === 'karate')); // a grip holds a man in; not the karate man, who is never there
  if (id === '@stand') return G && S.top === m && !S.hold;
  if (id === '@up') return G && S.top !== m && !S.hold;
  if (id === '@pull') return !S.hold && M.mech && M.style === 'bjj' && S.pos !== 'G'; // he sits to guard from any range and makes him come
  if (S.hold || id === '@break') return false;
  const c = CARDS[id];
  if (c.k === 'ans') {
    if (c.act) return G && S.top !== m;
    if (c.fx === 'sprawl') return !!((S.grip && S.grip.by !== m) || (S.tie && S.tie.by !== m));
    return false;
  }
  if (c.needGrip && M.mech && !(S.grip && S.grip.by === m)) return false;
  if (c.k === 'shot' && S.grip && S.grip.by !== m && S.f[1 - m].mech) return false; // a gripped man cannot shoot or throw: the grip owns his posture
  // a hold needs a settled position: not in the volley of the takedown (sambo's own mechanic is the exception; so is BJJ's own pull)
  if (c.k === 'hold' && S.gpass === S.pass && !(S.gby === m && (S.gpull || (M.mech && M.style === 'sambo')))) return false;
  return !!carries(S, M, c) || fits(atFor(M, c), posKey(S, m));
}
// a clean takedown cannot be answered: the judo grip, the wrestler's read of the tie-up
export function shotClean(S, a, c, pass = S.pass, behindPunch = S.ctx.lastT === 'p') {
  const A = S.f[a];
  if (!A.mech) return false;
  if (A.style === 'sambo' && c.k === 'shot') return behindPunch; // punch-to-throw: his throw right behind his own punch cannot be stopped
  if (c.needGrip) return !!S.grip && S.grip.by === a && S.grip.pass < pass;
  if (c.cleanIf === 'tie') return !!S.tie && S.tie.by === a && S.tie.pass < pass;
  return false;
}
const fxOf = (id) => (id === '@cover' ? 'cover' : CARDS[id].fx);
// does answer `id` stop pending card p (thrown by a)?
export function ansFits(S, a, id, p) {
  const c = CARDS[p.id]; if (!c) return false;
  const fx = fxOf(id), ground = !!c.at && c.at[0][0] === 'T', before = CARDS[S.inc[S.inc.indexOf(p) - 1]?.id], bp = !!before && before.k === 'strike' && !before.kick; // the card laid just before it is a punch
  if (fx === 'cover' || fx === 'block') return c.k === 'strike' && !c.unblock;
  if (fx === 'slip') return c.k === 'strike' && !c.kick && !ground;
  if (fx === 'evade') return (c.k === 'strike' && !ground) || (c.k === 'shot' && !c.sweep && !shotClean(S, a, c, S.pass + 1, bp)); // he is not there: a strike, or a shot that is not clean
  if (fx === 'tiein') return c.k === 'strike' && !ground;
  if (fx === 'catch' || fx === 'check') return !!c.kick;
  if (fx === 'sprawl') return c.k === 'setup' || (c.k === 'shot' && !shotClean(S, a, c, S.pass + 1, bp));
  if (fx === 'headlock') return c.k === 'shot' && !shotClean(S, a, c, S.pass + 1, bp); // it snaps a shooter down; it does not stop a grip
  if (fx === 'escape') return c.k === 'hold' || c.k === 'adv';
  return false;
}
function end(S, win, how) { if (!S.over) S.over = { win, how }; }
function checkOver(S) {
  for (const k of [0, 1]) if (S.f[k].hp <= 0) end(S, 1 - k, 'ko');
  if (N.clkPts) for (const k of [0, 1]) if (S.f[k].pts - S.f[1 - k].pts >= N.lead) end(S, k, 'lead');
}
function stand(S, pos) { S.pos = pos; S.top = -1; S.rung = 0; S.stall = 0; S.hold = null; }
function ground(S, top, rung, by, pull) { S.pos = 'G'; S.top = top; S.rung = rung; S.stall = 0; S.grip = S.tie = null; S.gpass = S.pass; S.gby = by; S.gpull = !!pull; }
function drainHim(D) { if (N.mode === 'limb') D.dark |= 16; else D.drain = Math.min(N.drainCap, D.drain + 1); }
function finishHold(S) {
  const h = S.hold; if (S.st) S.st.holdDone++;
  if (h.kind === 'sub') end(S, h.by, 'tap'); else { S.f[h.by].pts += h.pts; stand(S, 'C'); checkOver(S); if (S.over && S.over.how === 'lead') S.over.how = 'pin'; }
}
function resolveOne(S, a, p, ans) {
  const d = 1 - a, A = S.f[a], D = S.f[d], id = p.id, x = S.ctx;
  if (S.over) return;
  if (!legalNow(S, a, id)) { x.prev = false; x.combo = 0; x.lastT = null; if (S.st) S.st.whiff++; return; }
  if (id === '@in') { S.pos = S.pos === 'K' ? 'P' : 'C'; return; }
  if (id === '@out') { S.pos = S.pos === 'C' ? 'P' : 'K'; S.tie = null; return; }
  if (id === '@stand') { stand(S, 'P'); return; }
  if (id === '@up') { // the ride (wrestling's own): under a wrestler Get up wins back one rung only, and he is up only from the guard
    const ride = D.mech && D.style === 'wrestling';
    if (S.rung <= (ride ? 0 : 1)) stand(S, 'P'); else S.rung -= ride ? 1 : 2; return;
  }
  if (id === '@pull') { ground(S, d, 0, a, true); return; }
  const c = CARDS[id], fx = ans ? fxOf(ans) : null;
  if (c.k === 'ans') { if (c.act) { if (S.rung <= 1) stand(S, 'P'); else S.rung -= 2; } else S.grip = S.tie = null; return; }
  if (c.k === 'strike') {
    // the boxer's jab takes him in and he stays in; the karate blitz goes in and is back out at KICK before the answer
    const ct = carries(S, A, c); if (ct) S.pos = ct;
    if (A.mech) { if (S.pos === 'K' && c.enter) S.pos = 'P'; else if (S.pos === 'P' && (c.kick || c.blitz) && A.style === 'karate') S.pos = 'K'; }
    let dmg = c.dmg + (p.b || 0), clean = true;
    if (fx === 'block') { dmg = Math.max(0, dmg - (CARDS[ans]?.guard || N.block)); clean = false; }
    else if (fx === 'cover') { dmg = Math.max(0, dmg - N.cover); clean = false; }
    else if (fx === 'tiein') { dmg = Math.max(0, dmg - N.tiein); clean = false; S.pos = 'C'; }
    else if (fx) {
      if (fx === 'slip' || fx === 'check') D.ctr = N.counter;
      else if (fx === 'evade') { if (D.mech) S.pos = 'K'; }
      else if (fx === 'catch') { ground(S, d, 0, d); D.pts += N.catchPts; }
      x.prev = false; x.combo = 0; x.lastT = null; return;
    }
    x.lastT = kindOf(c);
    if (clean) {
      x.combo = id === 'jab' ? 1 : id === 'cross' && x.combo === 1 ? 2 : id === 'hook' && x.combo === 2 ? 3 : 0;
      if (x.combo === 3 && A.mech && A.style === 'boxing') { dmg += N.comboDmg; A.pts += N.comboPts; if (S.st) S.st.combos++; }
      A.pts += c.pts || 0;
      if (c.drain) drainHim(D);
      if (c.cripple) { D.lame = 1; if (N.mode === 'wind') drainHim(D); else D.dark |= 4; }
    } else x.combo = 0;
    D.hp -= dmg; A.dealt += dmg; x.prev = clean; if (S.pos === 'G') S.stall = 0;
    if (c.close && S.pos === 'P') S.pos = 'C';
    return;
  }
  x.prev = false; x.combo = 0;
  if (c.k === 'shot') {
    const clean = shotClean(S, a, c);
    if (fx && !clean) {
      if (fx === 'headlock') D.pts += N.headlockPts;
      if (fx === 'evade') { if (D.mech) S.pos = 'K'; if (S.st) S.st.stuffed++; return; }
      if (A.mech && A.style === 'wrestling') { S.tie = { by: a, pass: S.pass }; S.pos = 'C'; } // chain wrestling: stuffed, he stays on the legs
      if (S.st) S.st.stuffed++; return;
    }
    ground(S, a, c.to, a); A.pts += c.pts; D.hp -= c.dmg || 0; A.dealt += c.dmg || 0;
    if (S.st) S.st.downs++;
  } else if (c.k === 'setup') {
    if (fx) { if (fx === 'headlock') D.pts += N.headlockPts; if (fx === 'evade' && D.mech) S.pos = 'K'; return; }
    if (id === 'grip') { S.grip = { by: a, pass: S.pass }; S.pos = 'C'; } else S.tie = { by: a, pass: S.pass, struck: false };
  } else if (c.k === 'hold') {
    if (fx) { if (S.top === a) S.rung = Math.max(0, S.rung - 1); return; }
    if (!N.clkHold) return;
    S.stall = 0; if (S.st) S.st.holdOn++;
    if (N.holdRoll && S.st) { if (S.r() < N.holdRoll) { S.hold = { by: a, kind: c.hk, pts: c.hpts || 0 }; finishHold(S); } return; }
    S.hold = { by: a, kind: c.hk, count: c.count, brk: c.brk, tick: c.tick || 0, pts: c.hpts || 0 };
  } else if (c.k === 'adv') {
    if (fx) return;
    S.rung = Math.min(3, S.rung + 1); A.pts += c.pts; S.stall = 0;
  }
}
// m answers the volley thrown at him; ans = { id, i } (i = which pending card; -1 = the hold he is in) or null
export function resolveIncoming(S, m, ans) {
  const a = 1 - m, A = S.f[a];
  S.pass++; S.ctx = { prev: false, combo: 0 };
  if (S.hold && S.hold.by === a) {
    const h = S.hold; // a pin scores at the top of every turn it is on, also the turn he gets out: sure points
    if (h.tick) { A.pts += h.tick; checkOver(S); if (S.over && S.over.how === 'lead') S.over.how = 'pin'; }
    // out by the Escape card or (a submission only) by paying the hold's price: both men are back on their feet in the CLINCH.
    // The hold tightens: the price goes up by 1 every turn he stays in, so the first turn he can pay is the cheapest
    if (S.over) { /* the pin's points ended it */ } else if (ans && (ans.id === 'escape' || ans.id === '@break')) { stand(S, 'C'); if (S.st) S.st.escaped++; }
    else { h.brk += N.tighten; if (--h.count <= 0) finishHold(S); }
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
    if (S.hold.kind === 'sub' && M.wind >= S.hold.brk) out.push({ id: '@break', i: -1 }); // a pin has no price: only the Escape card gets him out
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
  if (!bell) { M.wind = Math.min(N.cap, M.wind + Math.max(0, (S.hold && S.hold.by !== m ? N.heldBack : N.back) - M.drain)); M.drain = 0; M.lit = 31 & ~M.dark; M.dark = 0; }
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
  }
  resolveIncoming(S, m, ans);
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
  const M = S.f[m]; M.ctr = 0; M.chain = 0; M.free = 0; S.pj = null; if (M.lame) M.lame--;
  if (S.pos === 'G' && S.top !== m && S.inc.some((p) => p.id[0] !== '@')) S.stall = 0; // work from underneath keeps it on the ground
  if (S.pos === 'G' && S.top === m && !S.hold) {
    if (!S.inc.some((p) => p.id[0] !== '@')) S.stall++;
    if (S.stall >= N.stallMax) { stand(S, 'K'); S.inc = []; if (S.st) S.st.refUps++; }
  }
}
export function newBout(F0, F1, seed) {
  const r = rng(seed);
  return { f: [newFighter(F0, r), newFighter(F1, r)], pos: 'K', top: -1, rung: 0, inc: [], hold: null, grip: null, tie: null, stall: 0, pass: 0, gpass: -1, gby: -1, gpull: false, ctx: { prev: false, combo: 0 }, over: null, r, pj: null, round: 0, turn: 0,
    st: { vis: 1, whiff: 0, stuffed: 0, downs: 0, holdOn: 0, holdDone: 0, escaped: 0, letGo: 0, refUps: 0, combos: 0, dec: [0, 0], turns: [0, 0], cards: [0, 0], quiet: [0, 0], choices: 0, steps: 0, maxCh: 0, held: [0, 0], secs: [0, 0], played: [{}, {}], log: [[], []] } };
}
// agents[k] = { answer(S,k) -> {id,i}|null, act(S,k) -> [ids] }
export function bout(F0, F1, agents, seed, opt = {}) {
  const S = newBout(F0, F1, seed), st = S.st;
  let first = opt.first ?? (S.r() < 0.5 ? 0 : 1);
  const turn = (k, bell, noAct) => {
    beginTurn(S, k, bell);
    const opts = S.inc.length || (S.hold && S.hold.by !== k) ? answerOptions(S, k) : [null];
    const ans = opts.length > 1 ? agents[k].answer(S, k, opts) : null;
    if (opts.length > 1) st.dec[k]++;
    if (opt.onAnswer) opt.onAnswer(S, k, ans, opts);
    doAnswer(S, k, ans);
    if (bell || noAct || !canAct(S)) return;
    st.turns[k]++; startAct(S);
    const seq = agents[k].act(S, k);
    if (opt.onAct) opt.onAct(S, k, seq);
    const at = [];
    for (const id of seq) { at.push(posKey(S.pj, k)[0]); declare(S, k, id); if (id[0] !== '@') st.played[k][id] = 1; }
    st.dec[k] += seq.length + 1; st.cards[k] += seq.length; if (!seq.length) st.quiet[k]++;
    st.log[k].push({ pos: posKey(S, k), kinds: seq.map((id) => (id === '@pull' ? 'move' : id[0] === '@' ? 'step' : CARDS[id].k)), kk: seq.map((id) => (CARDS[id]?.kick ? 'kick' : null)), at, ans: ans ? 1 : 0 });
    endAct(S, k);
  };
  for (let rd = 0; rd < N.rounds && !S.over; rd++) {
    S.round = rd; stand(S, 'K'); S.inc = []; S.grip = S.tie = null;
    if (rd) for (const B of S.f) B.wind = Math.min(N.cap, B.wind + N.stool);
    for (let t = 0; t < N.turns && !S.over; t++) { S.turn = t; for (const k of [first, 1 - first]) if (!S.over) turn(k, false); }
    if (!S.over && S.inc.length) turn(first, true);
    for (let g = 0; g < 9 && S.hold && !S.over; g++) turn(1 - S.hold.by, false, true); // the bell waits for a hold: it runs to its end
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
