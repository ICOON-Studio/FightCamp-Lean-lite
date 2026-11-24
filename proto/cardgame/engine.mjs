// ROUND 9 (TASK_CARDROUND9): the card game on the real-fight position model (CARDREAL_AUDIT section 4). A turn = answer
// his volley with ONE answer, it resolves in order, then lay your own volley face up (cards and moves, one at a time).
// Each fighter has his own place (board.mjs): a move names whose place changes, and nobody is moved for free. A move
// that leaves contact, goes to the ground or rises from it is answerable like a card (audit 2d, 4c). Nothing is rolled;
// a card that is no longer legal when it resolves (he stopped the entry) whiffs.
import { CARDS, N, MOVE } from './cards.mjs';
import { GUARD_KINDS, PAST_KINDS, pairOk, joinFor, groundStep } from './board.mjs';
export { groundStep, GUARD_KINDS, PAST_KINDS } from './board.mjs';
export { newBout, bout } from './desk.mjs'; // the round and turn loop (desk.mjs), re-exported: one import for the callers
export { resolveMove } from './moves.mjs'; // the floor moves (audit 4c), their own file: one import for the callers
import { resolveMove } from './moves.mjs';
import { FLOOR_FX, FLOOR_ANS, moveCost, kickDmg, isKnockdown } from './floor.mjs';

export function rng(seed) {
  let a = seed >>> 0;
  return () => { a = (a + 0x6d2b79f5) | 0; let t = Math.imul(a ^ (a >>> 15), 1 | a); t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t; return ((t ^ (t >>> 14)) >>> 0) / 4294967296; };
}
export function shuffle(a, r) { for (let i = a.length - 1; i > 0; i--) { const j = Math.floor(r() * (i + 1)); [a[i], a[j]] = [a[j], a[i]]; } return a; }
const BIT = { a: 1, A: 2, l: 4, L: 8, h: 16 };
const DOWN = ['seat', 'back'], GROUNDKEYS = ['gt', 'gb', 'past', 'pin', 'down'];

export function newFighter(F, r) {
  return { name: F.name, style: F.style, mech: F.mech !== false, list: F.deck.slice(), deck: shuffle(F.deck.slice(), r), hand: [], disc: [],
    hp: N.hp, pts: 0, wind: N.start, lit: 31, dark: 0, drain: 0, dealt: 0, ctr: 0, chain: 0, free: 0, lame: 0 };
}
const cf = (F) => ({ ...F, hand: F.hand.slice() });
export function clone(S) {
  const c = { ...S, f: [cf(S.f[0]), cf(S.f[1])], at: S.at.slice(), j: { ...S.j }, inc: S.inc.map((p) => ({ ...p })), hold: S.hold && { ...S.hold }, tie: S.tie && { ...S.tie }, timid: S.timid.slice(), gnp: (S.gnp || [0, 0]).slice(), idle: (S.idle || [0, 0]).slice(), ctx: { ...S.ctx }, st: null, pj: null };
  if (S.pj) c.pj = clone(S.pj);
  return c;
}
// THE PLACE A CARD NAMES, in board.mjs keys: K P C kick / punch / the clinch; over standing over a man who is down;
// gt gb the guard, on top / underneath; past past his guard; pin pinned; down on the floor and apart
const KEYWORD = { K: 'kick range', P: 'punch range', C: 'the clinch', over: 'standing over a man who is down', gt: 'in his guard, on top', gb: 'in his guard, underneath', past: 'past his guard', pin: 'pinned', down: 'on the floor, apart' };
export const keyWords = (k) => KEYWORD[k] || k;
export function placeKey(S, m) {
  const me = S.at[m], him = S.at[1 - m], j = S.j;
  if (me === 'stand') { if (j.kind === 'clinch') return 'C'; if (him === 'stand') return j.reach === 'K' ? 'K' : 'P'; return 'over'; }
  if (me === 'gtop') return 'gt';
  if (me === 'gbot') return 'gb';
  if (me === 'past') return 'past';
  if (me === 'pin') return 'pin';
  return 'down';
}
export const posKey = placeKey; // the round-8 name for the same idea (one key per fighter now)
export function fits(atList, key, j = {}) {
  for (const a of atList) {
    const p = typeof a === 'string' ? a : a.p, gs = typeof a === 'string' ? null : a.gs;
    if (p === key || (p === 'G' && GROUNDKEYS.includes(key))) {
      // a guard kind / past kind the card names must be the one that holds - except where no join is given (the pilot's
      // static "where can this card ever be played" table reads the place alone)
      if (!gs || (!j.g && !j.top) || gs.includes(j.g) || gs.includes(j.top)) return true;
    }
  }
  return false;
}
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
function baseCost(S, m, id) {
  const mc = moveCost(S, m, id); if (mc) return mc; // the floor's own prices (floor.mjs)
  const c = CARDS[id], M = S.f[m], Q = S.pj;
  if (Q && M.mech && c.k === 'strike') { // the two strikers' own mechanics are prices
    const last = S.inc[S.inc.length - 1], lc = last && CARDS[last.id];
    // a combination is CHEAPER, never free. Flooring at 0 made a jab behind a jab cost NOTHING, so a boxer chained
    // punches without limit - measured at 7.5 cards a volley against the jiu-jitsu man's 3.2, with 11-damage
    // combinations for 3 wind. A fighter with no wind cannot throw, and that must hold for every card he owns.
    if (M.style === 'boxing' && !c.kick && lc && lc.k === 'strike' && !lc.kick) return [Math.max(N.minW, c.w - 1), c.L];
    if (M.style === 'kickboxing' && Q.ctx.lastT && Q.ctx.lastT !== kindOf(c)) return [Math.max(N.minW, c.w - 1), c.L];
    if (M.style === 'karate' && c.w > 1 && c.blitz && placeKey(Q, m) === 'K') return [c.w - 1, c.L];
  }
  return [c.w, c.L];
}
// audit 2d: a grip or tie that stood a turn makes the ANSWER 1 wind dearer, never impossible
export function cost(S, m, id, p) {
  const [w, L] = baseCost(S, m, id);
  const a = 1 - m;
  if (p && S.tie && S.tie.by === a && S.tie.pass < S.pass && (CARDS[p.id]?.k === 'shot' || p.id === '@pull')) return [w + N.surcharge, L];
  return [w, L];
}
const kindOf = (c) => (c.kick ? 'k' : c.kneeC ? 'n' : 'p');
// kickboxing's own mechanic: a strike of another kind than his last carries him to its own range by itself. Round 9: the
// round-8 strip is two places now (apart at KICK/PUNCH, and the CLINCH), so the clinch reads as 'C' - the knee behind the
// punch takes the clinch, and the punch behind the knee pushes back off to PUNCH. Both men must be on their feet.
function carries(S, M, c) {
  if (!(M.mech && M.style === 'kickboxing' && c.k === 'strike')) return null;
  if (S.at[0] !== 'stand' || S.at[1] !== 'stand') return null;
  if (S.j.kind === 'entangled') return null;
  const r = S.j.kind === 'clinch' ? 'C' : S.j.reach, t = S.ctx.lastT;
  return r === 'K' && kindOf(c) === 'p' && t === 'k' ? 'P' : r === 'P' && c.kneeC && t === 'p' ? 'C' : r === 'C' && kindOf(c) === 'p' && t === 'n' ? 'P' : null;
}
// where a card is playable for this fighter: the places it names, widened or narrowed by his art's own mechanic
export function atFor(F, c) {
  let at = c.at; if (!at) return at;
  if (F.mech) {
    if (c.enter || c.blitz || (c.kick && (F.style === 'karate' || F.style === 'kickboxing'))) at = ['K', 'P'];
    if (F.style === 'wrestling' && c.k === 'shot') at = ['K', 'P', 'C'];
    if (F.style === 'boxing' && c.inside) at = ['P', 'C'];
    if (F.style === 'sambo' && c.k === 'shot') at = ['P', 'C'];
    // the punches down (M12): from standing over a man who is down, and from on top on the ground (M11: weak in the
    // guard, full past it). A rule hung on the boxer's own hook and cross, never a new card
    if (c.punchDown) at = [...at, 'over', 'gt', 'past'];
  }
  if (c.leg && !(F.mech && F.style === 'sambo')) at = ['gt', 'past'];
  if (!(F.mech && F.style === 'bjj')) at = at.filter((a) => (typeof a === 'string' ? a !== 'gb' : a.p !== 'gb'));
  return at;
}
const onTop = (S, m) => S.at[m] === 'gtop' || S.at[m] === 'past';
const atGuard = (S, m) => S.at[m] === 'gbot';
const standOver = (S, m) => S.at[m] === 'stand' && (DOWN.includes(S.at[1 - m]));
// is this card or step legal where the bout stands now (places and status; not its price)
export function legalNow(S, m, id) {
  if (S.over) return false;
  const M = S.f[m], me = S.at[m], him = S.at[1 - m], j = S.j, key = placeKey(S, m);
  const bothStand = me === 'stand' && him === 'stand';
  if (id === '@in') {
    if (bothStand) return j.kind !== 'clinch' && (j.reach === 'K' || j.reach === 'P'); // KICK -> PUNCH, PUNCH -> the clinch
    return standOver(S, m) && down(S, 1 - m); // step closer, or follow him down
  }
  if (id === '@out') {
    if (bothStand) return j.kind === 'clinch' || j.reach === 'P'; // the clinch -> apart at PUNCH; PUNCH -> KICK
    return standOver(S, m) && !!j.leg; // walk away, out of leg range
  }
  if (id === '@stand') return me === 'gtop' && !S.hold;
  if (id === '@back') return me === 'stand' && (him === 'gbot' || S.j.kind === 'clinch'); // out of the clinch, or out of his legs
  if (id === '@up') return (me === 'seat' || me === 'back' || me === 'knee') && him === 'stand' && !S.hold;
  // Pull guard (audit 4c): with HIS OWN tie, from the clinch it made; with no tie, the same button is Sit down, from
  // apart. (Round 9 first wrote this as "never in the clinch", which forbade the very move the audit names - walked bout
  // turn 4, the BJJ man pulling off his collar tie in his own volley.)
  // PULLING FROM A CLINCH. Audit 4b pair 2: the clinch is "a collar tie before a pull" - contact is exactly where a pull
  // starts, and the memo's own walked bout has the jiu-jitsu man pulling out of a clinch (7, turn 4). Round 9's gate asked
  // for the tie he had made HIMSELF or for being out of the clinch, so a jiu-jitsu man tied up by a boxer - in contact,
  // in the one place his game begins - could not pull at all: 68-100% of his clinch turns were dead cards. What a pull
  // needs is CONTACT, and the clinch is contact; his own tie (a set-up he spent a card on) is what lets a hold follow in
  // the same volley, which declare() reads separately.
  // 9b H1b: off HIS OWN tie the pull needs the tie to have stood through one of the other man's turns
  if (id === '@pull') return !S.hold && M.mech && M.style === 'bjj' && bothStand && !(S.tie && S.tie.by === m && !S.tie.stood);
  if (FLOOR_FX[id]) return id === '@kick' && !S.hold && (me === 'seat' || me === 'back') && him === 'stand' && !!j.leg; // 9b B3
  if (S.hold || id === '@break') return false;
  const c = CARDS[id];
  if (c.k === 'ans') {
    if (c.act) return key === 'pin' || key === 'gb'; // Escape in his own turn: recover guard, never stands up
    if (c.fx === 'sprawl') return !!S.tie && S.tie.by !== m;
    return false;
  }
  // the up-kick: only from the floor, at a STANDING man, inside the reach of the feet (rule 3: never at a man in the guard)
  if (c.up) return (me === 'seat' || me === 'back') && him === 'stand' && !!j.leg;
  // the sweep: from the guard, at the man on top of it (hip bump) or at a man standing out of it (tripod, sickle, ankle
  // pick - M8); from the seat, the ankle pick; never at a man past the guard
  if (c.sweep) return (key === 'gb' && (him === 'gtop' || (him === 'stand' && !!j.leg))) || (key === 'down' && him === 'stand' && !!j.leg);
  if (c.needGrip && M.mech && !(S.tie && S.tie.by === m && S.tie.mode === 'grip')) return false;
  // the sambo throw (audit 2c MISSING-LINK): the grab is part of his own punch, so it goes from PUNCH only and only
  // right behind his own punch laid this same volley - and it is answerable like any other step off contact.
  if (M.mech && M.style === 'sambo' && id === 'sthrow' && !(key === 'P' && S.ctx.lastT === 'p')) return false;
  if (c.k === 'shot' && S.tie && S.tie.by !== m && S.f[1 - m].mech) return false; // a gripped man cannot shoot: the grip owns his posture
  // Tie up (4c), and the judo Grip with it: a set-up that makes contact - from PUNCH range, from KICK (reaching in as the
  // step in would, the punch that punishes it landing on the way), or inside the clinch as a better hold
  if ((id === 'tieup' || id === 'grip') && !bothStand) return false;
  // audit 2c: hold-downs, rolls and ground strikes are the man ON TOP's; ground punches inside the guard are a rule on the
  // boxer's own hook and cross (M11), never on the bjj man's. The rule takes only the GROUND places away: at PUNCH the
  // cross is the plain cross and works for anybody (the round-9 test caught the rule refusing it there too).
  if ((id === 'hook' || id === 'cross') && c.punchDown && !M.mech && ['over', 'gt', 'past'].includes(key)) return false;
  // a hold needs a settled position: not in the volley of the takedown (sambo's own mechanic is the exception; so is BJJ's pull)
  if (c.k === 'hold' && S.gpass === S.pass && !(S.gby === m && M.mech && (M.style === 'sambo' || M.style === 'bjj'))) return false;
  return !!carries(S, M, c) || fits(atFor(M, c), key, j);
}
const down = (S, m) => DOWN.includes(S.at[m]);
export const fxOf = (id) => (id === '@cover' ? 'cover' : FLOOR_FX[id] || (CARDS[id]?.up ? 'up' : CARDS[id]?.fx));
export const strikeFits = (S, m, id, key) => !!CARDS[id] && CARDS[id].k === 'strike' && fits(atFor(S.f[m], CARDS[id]), key, S.j);
// does answer `id` (laid by m, the man answering) stop pending card or move p (laid by a = 1 - m)?
export function ansFits(S, a, id, p) {
  const m = 1 - a, c = CARDS[p.id], fx = fxOf(id);
  if (!c) { // a MOVE: only the windows the audit names (4c), never more
    if (p.id === '@kick') return fx === 'cover' || fx === 'block'; // 9b B3: the kick with no card is covered like a strike
    if (fx === 'base') return p.id === '@pull'; // 9b B1: Keep your base stops the pull (and the sweep, below)
    if (fx === 'frame' || id === '@escape') return false;
    if (fx === 'up') return p.id === '@in' || p.id === '@out' || p.id === '@back'; // follow him down, walk away, back away
    if (fx === 'sprawl') return p.id === '@in' || p.id === '@pull'; // following him down / the pull: posture
    if (p.id === '@pull') return fx === 'sprawl';
    if (p.id === '@stand') return (id === 'sweep' && atGuard(S, m)) || (CARDS[id]?.k === 'hold' && atGuard(S, m) && fits(atFor(S.f[m], CARDS[id]), 'gb', S.j));
    if (p.id === '@back') return id === 'sweep' && atGuard(S, m);
    if (p.id === '@out' && S.j.kind === 'clinch') return S.tie && S.tie.by === m ? id === '@pull' : strikeFits(S, m, id, 'C');
    if (p.id === '@in' && S.at[m] === 'stand' && S.at[a] === 'stand') return false;
    return false;
  }
  const ground = ['gt', 'past', 'over', 'gb', 'pin', 'down'].includes(placeKey(S, a));
  if (fx === 'frame') return c.k === 'setup'; // 9b H1: the frame stops a tie or a grip as it is laid
  if (fx === 'base') return !!c.sweep;
  if (id === '@escape') return c.k === 'hold'; // 9b B2: a hold as it is laid, never a pass (that is the card)
  if (fx === 'cover' || fx === 'block') return c.k === 'strike' && !c.unblock;
  if (fx === 'slip') return c.k === 'strike' && !c.kick && !ground;
  if (fx === 'evade') return (c.k === 'strike' && !ground) || c.k === 'shot'; // no takedown is unanswerable (2d): a stood tie just makes it dearer
  if (fx === 'tiein') return c.k === 'strike' && !ground;
  if (fx === 'catch' || fx === 'check') return !!c.kick;
  if (fx === 'sprawl') return c.k === 'setup' || c.k === 'shot';
  if (fx === 'headlock') return c.k === 'shot';
  if (fx === 'up') return c.k === 'strike' && placeKey(S, a) === 'over'; // the up-kick answers the punch down (M12)
  if (fx === 'escape') return c.k === 'hold' || c.k === 'adv';
  return false;
}
function end(S, win, how) { if (!S.over) S.over = { win, how }; }
function checkOver(S) {
  for (const k of [0, 1]) if (S.f[k].hp <= 0) end(S, 1 - k, 'ko');
  if (N.clkPts && !S.over) for (const k of [0, 1]) if (S.f[k].pts - S.f[1 - k].pts >= N.lead) end(S, k, 'lead');
}
// put a man somewhere and rebuild the join; the engine REFUSES a pair a fight does not have (audit 4b)
export function place(S, m, p, jp = {}) {
  const at = S.at.slice(); at[m] = p;
  const j = joinFor(at, { ...S.j, ...jp });
  if (!pairOk(at, j)) throw new Error(`illegal pair: ${at.join(' / ')} ${JSON.stringify(j)}`);
  S.at = at; S.j = j;
}
export function placeBoth(S, at, jp = {}) {
  const j = joinFor(at, { ...S.j, ...jp });
  if (!pairOk(at, j)) throw new Error(`illegal pair: ${at.join(' / ')} ${JSON.stringify(j)}`);
  S.at = at.slice(); S.j = j;
}
// the referee stands both men up, apart at KICK: the only stand-up there is (audit 2d, 4c)
function refUp(S, why) { S.at = ['stand', 'stand']; S.j = { kind: 'apart', reach: 'K' }; S.tie = null; S.hold = null; S.stall = 0; if (S.st) { S.st.refUps++; S.st.refLog.push(why); } }
export function hit(S, by, to, dmg, pts = 0) { if (!dmg) return; S.f[to].hp -= dmg; S.f[by].dealt += dmg; if (pts) S.f[by].pts += pts; checkOver(S); }
function drainHim(D) { if (N.mode === 'limb') D.dark |= 16; else D.drain = Math.min(N.drainCap, D.drain + 1); }
// the hold ends and BOTH STAY DOWN, the holder one layer back (audit 2a Break free, 2b Escape, 4c)
function backOneLayer(S, by) {
  const o = 1 - by;
  if (S.at[by] === 'past') {
    if (S.j.top === 'back') { placeBoth(S, by === 0 ? ['past', 'pin'] : ['pin', 'past'], { top: 'side' }); }
    else { placeBoth(S, by === 0 ? ['gtop', 'gbot'] : ['gbot', 'gtop'], { g: 'half' }); }
  } else if (S.at[by] === 'gbot') S.j = { kind: 'entangled', g: 'closed' }; // the plain guard he attacked from
  S.hold = null;
  void o;
}
function finishHold(S, bell = false) {
  const h = S.hold; if (!h) return;
  if (S.st) S.st.holdDone++;
  S.hold = null;
  if (h.kind === 'sub') { if (!bell) end(S, h.by, 'tap'); return; }
  S.f[h.by].pts += h.pts;
  refUp(S, 'a pin that ran its count'); // audit 2d: the points stand, the referee stands them apart at KICK
  checkOver(S);
  if (S.over && S.over.how === 'lead') S.over.how = 'pin';
}
const visBit = (S) => (S.at[0] !== 'stand' || S.at[1] !== 'stand' ? 8 : S.j.kind === 'clinch' ? 4 : S.j.reach === 'K' ? 1 : 2);
// a takedown or throw lands: `to` 0 the guard, 1 the half guard, 2 side control, 3 the back
function landShot(S, a, to) {
  const top = to >= 2 ? (to >= 3 ? 'back' : 'side') : to === 1 ? 'half' : 'closed';
  if (to >= 2) placeBoth(S, a === 0 ? ['past', 'pin'] : ['pin', 'past'], { top });
  else placeBoth(S, a === 0 ? ['gtop', 'gbot'] : ['gbot', 'gtop'], { g: top });
  S.tie = null; S.stall = 0; S.gpass = S.pass; S.gby = a;
  if (S.st) S.st.downs++;
}
// one laid thing (card or move) resolves, with the defender's one answer applied to it
function resolveOne(S, a, p, ans) {
  const d = 1 - a, A = S.f[a], D = S.f[d], x = S.ctx;
  if (S.over) return;
  if (!legalNow(S, a, p.id)) { x.prev = false; x.combo = 0; x.lastT = null; if (S.st) S.st.whiff++; return; }
  if (p.id[0] === '@') { x.prev = false; x.combo = 0; x.lastT = null; resolveMove(S, a, p, ans); return; }
  const c = CARDS[p.id], fx = ans ? fxOf(ans) : null, key = placeKey(S, a);
  if (c.k === 'ans') { // Escape played in his own turn: recover guard, both stay down (audit 2b WRONG fixed)
    if (c.act) {
      if (S.at[a] === 'pin') placeBoth(S, a === 0 ? ['gbot', 'gtop'] : ['gtop', 'gbot'], { g: S.j.top === 'side' ? 'closed' : 'half' }); // 9b H3
      else S.j = { kind: 'entangled', g: 'closed' };
    } else S.tie = null;
    return;
  }
  if (c.k === 'strike') {
    const ct = carries(S, A, c); if (ct) S.j = ct === 'C' ? { kind: 'clinch', by: a } : { kind: 'apart', reach: ct };
    if (A.mech) { if (key === 'K' && c.enter) S.j = { ...S.j, reach: 'P' }; else if (key === 'P' && (c.kick || c.blitz) && A.style === 'karate') S.j = { ...S.j, reach: 'K' }; }
    // the punch down (M12) and the ground punch from inside the guard (M11) are HALF of it; past the guard it is all of it
    const weak = key === 'over' || key === 'gt';
    let dmg = (weak ? Math.ceil(c.dmg / 2) : c.dmg) + (p.b || 0), clean = true;
    if (fx === 'block') { dmg = Math.max(0, dmg - (CARDS[ans]?.guard || N.block)); clean = false; }
    else if (fx === 'cover') { dmg = Math.max(0, dmg - N.cover); clean = false; }
    else if (fx === 'tiein') { dmg = Math.max(0, dmg - N.tiein); clean = false; S.j = { ...S.j, kind: 'clinch' }; }
    else if (fx === 'up') { // the up-kick: the punch down misses and he is kicked instead
      hit(S, d, a, kickDmg(ans, CARDS.upkick.dmg), 0); if (S.st) S.st.upkicks++;
      x.prev = false; x.combo = 0; x.lastT = null; return;
    } else if (fx) {
      if (fx === 'slip' || fx === 'check') D.ctr = N.counter;
      else if (fx === 'evade') { if (D.mech && S.at[d] === 'stand' && S.at[a] === 'stand') S.j = { kind: 'apart', reach: 'K' }; }
      else if (fx === 'catch') { if (S.at[d] === 'stand') { placeBoth(S, d === 0 ? ['gtop', 'gbot'] : ['gbot', 'gtop'], { g: 'closed' }); D.pts += N.catchPts; S.gpass = S.pass; S.stall = 0; } }
      x.prev = false; x.combo = 0; x.lastT = null; return;
    }
    x.lastT = kindOf(c);
    if (clean) {
      x.combo = p.id === 'jab' ? 1 : p.id === 'cross' && x.combo === 1 ? 2 : p.id === 'hook' && x.combo === 2 ? 3 : 0;
      if (x.combo === 3 && A.mech && A.style === 'boxing') { dmg += N.comboDmg; A.pts += N.comboPts; if (S.st) S.st.combos++; }
      A.pts += c.pts || 0;
      if (c.drain) drainHim(D);
      if (c.cripple) { D.lame = 1; if (N.mode === 'wind') drainHim(D); else D.dark |= 4; }
    } else x.combo = 0;
    if (dmg > 0 && S.at[d] !== 'stand') S.gnpHit = true; // 9b A2: the referee counts punches that land on a man who is down
    D.hp -= dmg; A.dealt += dmg; x.prev = clean; S.stall = 0;
    if (c.close && S.j.reach === 'P') S.j = { ...S.j, kind: 'clinch' };
    if (isKnockdown(S, a, d, dmg)) { S.tie = null; placeBoth(S, d === 0 ? ['seat', 'stand'] : ['stand', 'seat'], { kind: 'apart', leg: true }); if (S.st) S.st.kds = (S.st.kds || 0) + 1; } // 9b A1
    checkOver(S);
    return;
  }
  x.prev = false; x.combo = 0;
  if (c.k === 'shot') {
    if (fx === 'evade' || fx === 'sprawl' || fx === 'headlock' || fx === 'base') { // no takedown is unanswerable (2d); a stood tie only prices it dearer
      if (fx === 'headlock') D.pts += N.headlockPts;
      if (fx === 'evade' && D.mech && S.at[d] === 'stand' && S.at[a] === 'stand') S.j = { kind: 'apart', reach: 'K' };
      // chain wrestling is the SHOOTER's own mechanic (audit 2c): his stuffed shot leaves HIM tied up with the man he
      // shot at, holding the tie - so his next shot is a chain, not a new entry. (Round 8 read the defender's style here.)
      if (fx === 'sprawl' && S.at[a] === 'stand' && S.at[d] === 'stand' && A.mech && A.style === 'wrestling') { placeBoth(S, S.at.slice(), { kind: 'clinch', by: a }); S.tie = { by: a, mode: 'tie', pass: S.pass }; }
      if (S.st) S.st.stuffed++;
      return;
    }
    if (c.sweep) { // the sweep: he comes up on top, the other man in half guard
      placeBoth(S, a === 0 ? ['gtop', 'gbot'] : ['gbot', 'gtop'], { g: 'half' }); A.pts += c.pts; S.gpass = S.pass; S.stall = 0;
      if (S.st) S.st.sweeps++;
      return;
    }
    landShot(S, a, c.to); A.pts += c.pts; if (c.dmg) hit(S, a, d, c.dmg);
    return;
  }
  if (c.k === 'setup') {
    if (fx) { if (fx === 'headlock') D.pts += N.headlockPts; if (fx === 'evade' && D.mech) S.j = { kind: 'apart', reach: 'K' }; return; }
    S.tie = { by: a, mode: p.id === 'grip' ? 'grip' : 'tie', pass: S.pass };
    S.j = { ...S.j, kind: 'clinch', by: a };
    return;
  }
  if (c.k === 'hold') {
    if (fx) { if (ans !== '@escape') backOneLayer(S, a); return; } // stopped as it was laid: the CARD takes the holder one layer back (2b); the no-card escape (9b B2) leaves him where he is
    if (!N.clkHold) return;
    S.stall = 0; if (S.st) S.st.holdOn++;
    if (N.holdRoll && S.st) { if (S.r() < N.holdRoll) { S.hold = { by: a, kind: c.hk, pts: c.hpts || 0 }; finishHold(S); } return; }
    S.hold = { by: a, kind: c.hk, count: c.count, brk: c.brk, tick: c.tick || 0, pts: c.hpts || 0, card: p.id };
    return;
  }
  if (c.k === 'adv') {
    if (fx) return;
    // THE GUARD PASS IS ONE RUNG, NOT TWO (audit 2c, the rung table): full guard -> HALF guard -> side control. It used
    // to jump gtop straight to past/side in a single card, which skipped the half guard entirely - and the half guard is
    // where the bottom man's kimura lives (audit 4c). Jumping it took the jiu-jitsu man's whole guard game off the board
    // and handed the boxer side control for one card.
    if (S.at[a] === 'gtop') {
      if (S.j.g === 'closed' || S.j.g === 'open') placeBoth(S, S.at.slice(), { g: 'half' });        // into the half guard
      else placeBoth(S, a === 0 ? ['past', 'pin'] : ['pin', 'past'], { top: 'side' });              // half guard -> past
    }
    else if (S.at[a] === 'past') placeBoth(S, a === 0 ? ['past', 'pin'] : ['pin', 'past'], { top: S.j.top === 'side' ? 'mount' : 'back' });
    A.pts += c.pts; S.stall = 0; S.gpass = S.pass;
    return;
  }
}
// m answers the volley thrown at him; ans = { id, i } (i = which laid thing; -1 = the hold he is in) or null
export function resolveIncoming(S, m, ans) {
  const a = 1 - m, A = S.f[a];
  S.pass++; S.ctx = { prev: false, combo: 0 };
  if (S.hold && S.hold.by === a) {
    const h = S.hold;
    if (h.tick) { A.pts += h.tick; checkOver(S); if (S.over && S.over.how === 'lead') S.over.how = 'pin'; }
    if (S.over) { /* the pin's points ended it */ }
    else if (ans && (ans.id === 'escape' || ans.id === '@break')) { backOneLayer(S, h.by); if (S.st) S.st.escaped++; } // both stay down
    else { h.brk += N.tighten; if (--h.count <= 0) finishHold(S); } // the hold tightens
  }
  const inc = S.inc; S.inc = []; let struck = false; const stopped = !!(ans && ans.i >= 0);
  for (let i = 0; i < inc.length && !S.over; i++) {
    resolveOne(S, a, inc[i], ans && ans.i === i ? ans.id : null); checkOver(S);
    if (CARDS[inc[i].id]?.k === 'strike' || inc[i].id[0] === '@') struck = true;
    if (S.st) S.st.vis |= visBit(S);
  }
  if (!S.over && struck && !stopped && A.mech && A.style === 'karate' && S.at[0] === 'stand' && S.at[1] === 'stand' && S.j.reach === 'P' && !(S.tie && S.tie.by === m)) S.j = { ...S.j, reach: 'K' };
  // a CLINCH TIE stands until it is used or the clinch ends (audit 7: "takes it ... still holds" the collar tie for
  // a whole exchange, then pulls guard off it on his own turn). It used to be dropped after one pass, which made the
  // pull a one-turn move and broke the walked bout at turn 4.
  if (S.tie && S.j.kind !== 'clinch') S.tie = null;
  // 9b A2: punches landed on him while he was down. An answer that fights back (the up-kick, a sweep, a hold - anything but covering) clears the count
  if (S.gnpHit) { S.gnpHit = false; if (ans && !['cover', 'block'].includes(fxOf(ans.id))) S.gnp[m] = 0; else if (++S.gnp[m] >= N.tkoTurns && !S.over) end(S, a, 'tko'); }
  if (S.st) S.st.vis |= visBit(S);
}
// a move or a card that ends the volley: nothing more can be laid after it that turn.
// THE PULL IS THE ONE THAT DEPENDS ON WHAT HE HAD: from his own collar tie it carries him straight into the guard with the
// boxer's arm and head still in his hands, and a hold may follow in the same volley (audit 4c, line "a pull straight into
// a triangle ... only behind a pull made from a tie"). With no tie it is only a sit, and it ends his turn. Round 9 first
// read `ends: 1` off the card for both, which made the triangle-in-the-same-volley the audit names impossible to lay.
export const endsVolley = (id, S, m) => (id === '@pull' ? !(S && S.tie && S.tie.by === m) : !!(MOVE[id] && MOVE[id].ends));
export function answerOptions(S, m) {
  const M = S.f[m], out = [null];
  if (S.hold && S.hold.by !== m) {
    if (M.hand.includes('escape') && canPay(M, cost(S, m, 'escape'))) out.push({ id: 'escape', i: -1 });
    if (S.hold.kind === 'sub' && M.wind >= S.hold.brk) out.push({ id: '@break', i: -1 });
    return out;
  }
  const ids = [...new Set([...M.hand, '@cover', '@pull', ...FLOOR_ANS])];
  for (const id of ids) {
    if (id === '@pull' && !legalNow(S, m, '@pull')) continue;
    if (id === '@kick' && !(['seat', 'back', 'gbot'].includes(S.at[m]) && S.at[1 - m] === 'stand')) continue;
    if ((id === '@base' && !N.baseOn) || (id === '@escape' && !N.escOn)) continue; // built, measured, switched OFF (cards.mjs N)
    for (let i = 0; i < S.inc.length; i++) {
      if (!ansFits(S, 1 - m, id, S.inc[i])) continue;
      if (!canPay(M, cost(S, m, id, S.inc[i]))) continue;
      out.push({ id, i });
    }
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
    pay(M, cost(S, m, ans.id, S.inc[ans.i])); if (ans.id[0] !== '@') discard(S, M, ans.id);
  }
  resolveIncoming(S, m, ans);
}
export function startAct(S) { S.pj = clone(S); S.pj.pass++; S.pj.ctx = { prev: false, combo: 0 }; }
export const canAct = (S) => !S.over && !S.hold && !(S.pj && S.pj.ended);
// lay one card or move: paid now, shown face up, resolved on his turn. S.pj is the bout IF HE STANDS STILL - the page and
// the pilot price and preview against it - and every declared thing resolves into that same pending clone, one behind
// the other. ROUND 9 (the copy bug): the clone used to be thrown away when the turn closed, so a step's own effect (the
// punch as a man rose, the guard a pull closed) never reached the bout. endAct COMMITS the pending clone back into the
// bout now; the wind and the hand are already paid on the bout itself, by the same amounts, so they are not re-applied.
export function declare(S, m, id) {
  if (S.pj && S.pj.ended) throw new Error('not legal: the turn ended with the move before this one');
  const c = cost(S, m, id);
  if (!legalNow(S.pj, m, id) || !canPay(S.f[m], c)) throw new Error('not legal: ' + id);
  if (id[0] !== '@') discard(S, S.f[m], id);
  pay(S.f[m], c); S.pj.f[m].wind = S.f[m].wind; S.pj.f[m].lit = S.f[m].lit;
  const p = { id, b: 0 };
  if (CARDS[id]?.k === 'strike') { p.b = S.f[m].ctr; S.f[m].ctr = 0; if (S.tie && S.tie.by !== m) S.tie.struck = true; }
  // was the pull made off his own tie? read BEFORE it resolves, because resolving it is what drops the tie
  const pulledFromTie = id === '@pull' && !!(S.tie && S.tie.by === m);
  S.inc.push(p); resolveOne(S.pj, m, p, null);
  if (id === '@pull' ? !pulledFromTie : endsVolley(id, S.pj, m)) S.pj.ended = true;
}
const WORK = ['strike', 'hold', 'adv', 'shot'];
// the referee's own rules (audit 4d). Two clocks, and they are different clocks:
//  - the pair where NOBODY works: one full exchange (both turns) with no strike and no attack from either man, then the
//    referee stands both up, apart at KICK (4c "Referee stand-up"). Holding a place is not work (rule 6).
//  - the grounded man who will not engage (rule 5, Leites): HIS turn with nothing laid towards the standing man, and he
//    is stood up there and then; the count runs per round - warned the second time, a point off the third (4c, 4e).
export function endAct(S, m) {
  // S.pj is the FORECAST - what the bout is if he stands still - never the bout. The whole volley (cards AND moves) is
  // re-resolved on the real places when the other man answers it (resolveIncoming), so nothing is committed here; the
  // forecast is discarded.
  S.pj = null;
  const M = S.f[m]; M.ctr = 0; M.chain = 0; M.free = 0; if (M.lame) M.lame--;
  if (S.inc.length || S.at[m] === 'stand') { S.gnp[m] = 0; S.idle[m] = 0; } // 9b A2, I1
  if (S.tie && S.tie.by !== m) S.tie.stood = true; // 9b H1b: the tie has stood through one of his turns
  const me = S.at[m], him = S.at[1 - m], laid = S.inc.filter((p) => p.id[0] !== '@' && CARDS[p.id]);
  // a MOVE counts as work on the ground too: the guard pass, the back take, the sweep, the stand-up - "the boxer is
  // working, so no referee" (audit 7, turn 12). Read only from cards, the referee stood up a busy man's bout.
  const worked = laid.some((p) => WORK.includes(CARDS[p.id].k))
    || S.inc.some((p) => p.id === '@stand' || p.id === '@back' || p.id === '@in' || (p.id === '@out' && DOWN.includes(S.at[m])));
  const grappled = ['gtop', 'gbot', 'past', 'pin'].includes(me) || ['gtop', 'gbot', 'past', 'pin'].includes(him);
  if (!grappled) S.stall = 0;
  else if (worked) S.stall = 0;
  else if (++S.stall >= 2 * N.stallMax) refUp(S, 'nobody working on the ground'); // one exchange, both turns
  if (S.hold) return;
  // pair 3 (audit 4c, last rows): the man DOWN who laid nothing towards the standing man in HIS OWN turn is stood up,
  // there and then. Round 9 first read this the wrong way round and stood up the STANDING man (and charged him with
  // timidity) whenever the other was on the floor and apart - the walked bout caught it on the very first follow-down.
  if (DOWN.includes(S.at[m]) && S.j.kind === 'apart' && him === 'stand') {
    // a MOVE towards the standing man counts as work too: getting up (@up), the up-kick he throws from the floor, the
    // sweep, the shot. Round 9 read only cards here, so the man who laid Get up was stood up by the referee before his
    // own move ever resolved - and the punch as he rose could never land, because he was already on his feet.
    const work = S.inc.some((p) => p.id[0] === '@' ? (p.id === '@up' || p.id === '@in' || p.id === '@back' || p.id === '@kick') : CARDS[p.id] && (CARDS[p.id].up || CARDS[p.id].sweep || CARDS[p.id].k === 'shot' || CARDS[p.id].punchDown));
    if (!work) { if (++S.idle[m] >= 2) { S.idle[m] = 0; standHimUp(S, m); } else if (S.st) S.st.warn.push({ m, kind: 'get up' }); } // 9b I1
  }
}
// the referee stands up the grounded man who will not engage, apart at KICK; the count is per round: warned the second
// time, a point off the third (audit 4c last row, 4e)
export function standHimUp(S, m) {
  S.at = ['stand', 'stand']; S.j = { kind: 'apart', reach: 'K' }; S.tie = null; S.stall = 0;
  S.timid[m]++;
  if (S.st) {
    S.st.refUps++; S.st.refLog.push('the grounded man will not engage'); S.st.timid = (S.st.timid || 0) + 1;
    // audit 4c, 4e: the point off is the referee's, and it does NOT reset the count (a reset would be a free way out of
    // the cap: sit, be warned, sit, be warned - never penalised twice)
    if (S.timid[m] >= N.timidAt) { S.f[m].pts -= 1; S.st.timidPts = (S.st.timidPts || 0) + 1; S.st.warn.push({ m, kind: 'point off' }); }
    else if (S.timid[m] === N.warnAt) S.st.warn.push({ m, kind: 'warning' });
  }
}
