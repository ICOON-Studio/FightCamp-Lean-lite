// CARDSCOPE5 pilots. ONE AI pilot flies any deck from public information (probe P10; later: opponents and ghost decks).
// Beside it: the impatient line (rule of thumb) and a scripted priority list per style.
import { CARDS, N, MOVE } from './cards.mjs';
import { clone, declare, resolveIncoming, legalNow, canPay, cost, ansFits, placeKey, fits, answerOptions, atFor, groundStep, keyWords } from './engine.mjs';
import { WORDS, PAIRS } from './board.mjs';

export const W0 = { hp: 1, ko: 1, pts: 4, pos: 3, posS: 0.8, wind: 2, lead: 1.5, sub: 30, pin: 6, held: 10, setup: 4, drain: 2, lock: 1, up: 1.2, ref: 2 };
// the places a card can name, in the round-9 keys (board.mjs): the standing ranges, the join, the ground places
export const KEYS = ['K', 'P', 'C', 'over', 'gt', 'gb', 'past', 'pin', 'down'];
export const worth = (c) => (c.k === 'strike' ? c.dmg + 4 * (c.pts || 0) : c.k === 'shot' ? 4 * c.pts + (c.dmg || 0) + 3 : c.k === 'hold' ? 12 : c.k === 'adv' ? 4 * c.pts + 2 : c.k === 'setup' ? 3 : c.k === 'move' ? 1 : 0);
export const moveWorth = (id) => (id === '@stand' || id === '@up' ? 6 : id === '@pull' ? 9 : id === '@in' || id === '@out' || id === '@back' ? 2 : 0);
export { keyWords };
const FIT = new Map();
// what each move (audit 4c) is worth to THIS deck where the bout stands now: the tie and the pilot both read it
export function openMoves(S, m) {
  const F = S.f[m], me = S.at[m], him = S.at[1 - m], j = S.j, out = [];
  const isMove = (id) => !!MOVE[id];
  // WHAT HIS HAND SAYS: a set-up in hand is an entrance; a card that needs a tie he holds is worth the tie (worth() has
  // no way to price an entrance, so the places alone under-rate the grappler and he never ties up at all)
  const hand = S.f[m].hand;
  const wantsTie = hand.includes('tieup') || hand.includes('grip') || (F.mech && F.style === 'bjj' && (hand.includes('@pull') ? false : true) && hand.some((id) => CARDS[id] && (CARDS[id].needGrip || CARDS[id].k === 'hold')));
  const ally = (at, key = placeKey(S, m)) => (at && fits(atFor(F, CARDS['sweep']), key, j) ? 1 : 0);
  if (S.hold && S.hold.by !== m) { out.push({ id: '@break', w: S.hold.kind === 'pin' ? 0 : 3 }); return out; }
  if (me === 'stand' && him === 'stand') {
    if (j.kind !== 'clinch' && j.reach === 'K') out.push({ id: '@in', w: 1 });
    if (j.kind === 'clinch' || j.reach === 'P') out.push({ id: '@out', w: 1 });
    if (j.kind !== 'clinch' && j.reach === 'P') out.push({ id: '@in', w: 3 });
    if (j.kind !== 'clinch') { // the tie-up in hand is worth making, above all to a man whose cards need it
      if (hand.includes('tieup')) out.push({ id: 'tieup', w: 6 });
      if (hand.includes('grip') && j.reach === 'P') out.push({ id: 'grip', w: 6 });
      if (wantsTie) out.push({ id: '@in', w: 4 }); // Step in at PUNCH is the entry that makes the tie
    }
    if (F.mech && F.style === 'bjj') { if (j.kind === 'clinch' && S.tie && S.tie.by === m) out.push({ id: '@pull', w: 10 }); else if (j.kind !== 'clinch') out.push({ id: '@pull', w: 5 }); }
  } else if (me === 'stand' && (him === 'seat' || him === 'back')) {
    out.push({ id: '@out', w: j.leg ? 1 : 0 }, { id: '@in', w: j.leg ? 4 : 2 });
    if (fits(atFor(F, CARDS.upkick), 'down', j)) out.push({ id: 'upkick', w: 4 });
  } else if (me === 'stand' && him === 'gbot') out.push({ id: '@back', w: 5 });
  else if (me === 'gtop') { out.push({ id: '@stand', w: 5 }); if (fits(atFor(F, CARDS.pass), 'gt', j)) out.push({ id: 'pass', w: 6 }); }
  else if (me === 'gbot' && him === 'stand') { // standing in his guard: tripod / sickle / ankle pick (M8), the up-kick is a foul here
    if (S.f[m].hand.includes('sweep') && legalNow(S, m, 'sweep')) out.push({ id: 'sweep', w: 9 });
    if (S.f[m].hand.includes('triangle') || S.f[m].hand.includes('armbar')) out.push({ id: '@stand', w: 0 });
  }
  else if (me === 'gbot') { if (fits(atFor(F, CARDS.sweep), 'gb', j)) out.push({ id: 'sweep', w: 7 }); out.push({ id: '@up', w: 2 }); }
  else if (me === 'seat' || me === 'back') { out.push({ id: '@up', w: 4 }); if (fits(atFor(F, CARDS.upkick), 'down', j) && him === 'stand') out.push({ id: 'upkick', w: 4 }); if (fits(atFor(F, CARDS.sweep), 'down', j)) out.push({ id: 'sweep', w: 5 }); }
  else if (me === 'past') { if (fits(atFor(F, CARDS.pass), 'past', j)) out.push({ id: 'pass', w: 6 }); }
  else if (me === 'pin') out.push({ id: 'escape', w: 5 });
  void ally;
  return out.filter((x) => legalNow(S, m, x.id) && (isMove(x.id) || S.f[m].hand.includes(x.id)));
}
export const resetFit = () => FIT.clear(); // the sizing search changes card numbers: the table must be rebuilt
// the moves each place can offer (audit 4c): a place is worth something to a man if he can DO something there, card or move
const MOVEFIT = { K: ['@in'], P: ['@in', '@pull'], C: ['@out', '@pull'], over: ['@in', '@out'], gt: ['@stand'], gb: [], past: [], pin: ['@up'], down: ['@up'] };
// how much of this deck is alive at each place (worth per wind, averaged over the deck, moves included)
export function fit(F, key) {
  const id = F.list.join() + F.mech + F.style; let t = FIT.get(id);
  if (!t) {
    t = {};
    for (const k of KEYS) {
      let s = 0;
      for (const c of F.list.map((i) => CARDS[i])) { const at = atFor(F, c); if (at && fits(at, k)) s += worth(c) / Math.max(1, c.w); }
      for (const mv of MOVEFIT[k] || []) if (mv !== '@pull' || (F.mech && F.style === 'bjj')) s += moveWorth(mv) / 2;
      t[k] = s / F.list.length;
    }
    FIT.set(id, t);
  }
  return t[key];
}
// the hold as both men can read it: under a submission the held fighter gets N.heldBack wind a turn and breaks free the
// first turn he can pay the price, which goes up by 1 a turn; a pin has no price (only the Escape card) and scores at the
// top of every turn; if the countdown ends first it is the tap (or the full pin). No card is drawn while held.
export function outlook(S) {
  const h = S.hold, V = S.f[1 - h.by]; let w = V.wind, price = h.brk;
  for (let j = 1; j <= h.count; j++) {
    w = Math.min(N.cap, w + Math.max(0, N.heldBack - (j === 1 ? V.drain : 0)));
    if (h.kind === 'sub' && w >= price) return { fin: 0, turns: j, pts: h.tick * j, price }; // a pin cannot be bought off
    price += N.tighten;
  }
  return { fin: 1, turns: h.count, pts: h.tick * h.count + h.pts, price };
}
// the chance the held man has his one Escape in hand: he knows; the holder reads the open pile
function escChance(S, m) {
  const V = S.f[1 - S.hold.by];
  if (m !== S.hold.by) return V.hand.includes('escape') && V.wind + N.heldBack > CARDS.escape.w ? 1 : 0;
  return V.disc.includes('escape') ? 0 : Math.min(1, V.hand.length / Math.max(1, V.list.length - V.disc.length));
}
const dz = (hp) => 60 / (Math.max(hp, 0) + 6);
export function value(S, m, W = W0) {
  if (S.over) return S.over.win === m ? 1e4 : -1e4;
  const M = S.f[m], H = S.f[1 - m], ld = M.pts - H.pts;
  let v = W.hp * (M.hp - H.hp) + W.ko * (dz(H.hp) - dz(M.hp)) + W.pts * ld + W.lead * (Math.max(0, ld - 4) ** 2 - Math.max(0, -ld - 4) ** 2)
    + (S.hold ? 0 : (S.at[m] !== 'stand' || S.at[1 - m] !== 'stand' ? W.pos : W.posS) * (fit(M, placeKey(S, m)) - fit(H, placeKey(S, 1 - m)))) + W.wind * (N.mode === 'limb' ? 0 : M.wind - H.wind) + W.drain * (H.drain - M.drain);
  if (S.hold) {
    const h = S.hold, o = outlook(S), e = escChance(S, m);
    v += (h.by === m ? 1 : -1) * ((1 - e) * ((o.fin ? (h.kind === 'sub' ? W.sub : W.pin) : W.wind * o.price) + W.pts * o.pts + W.held * o.turns) + e * (W.wind * CARDS.escape.w + W.pts * h.tick + W.held));
  }
  // a tie-up (or a judo grip) belongs to one man. Audit 4c: it is his entrance (the clinch entry, the pull, the throw that
  // needs a grip, the throw behind his own punch) - so to the man who holds it the tie is worth his BEST move off it, and
  // to the other man it is worth the trouble of breaking it
  if (S.tie && S.f[S.tie.by].mech) {
    const holder = S.tie.by, H2 = S.f[holder], best = openMoves(S, holder).reduce((b, mv) => Math.max(b, mv.w), 0);
    v += (S.tie.by === m ? 1 : -1) * (W.setup + W.lock * best / 10 + (S.tie.mode === 'grip' ? 2 : 0));
  }
  return v;
}
// what he can still hold to answer with: [{id, p}] from his list less his discards (the table prints this count)
export function hisAnswers(S, h) {
  const H = S.f[h], left = {};
  for (const id of H.list) if (CARDS[id].k === 'ans') left[id] = (left[id] || 0) + 1;
  for (const id of H.disc) if (left[id]) left[id]--;
  const n = Math.max(5, H.list.length - H.disc.length), out = [{ id: '@cover', p: 1 }];
  for (const [id, r] of Object.entries(left)) if (r > 0) out.push({ id, p: 1 - (1 - r / n) ** 5 });
  return out;
}
// my volley as it lies: its value if he stands still, pulled toward his best single answer by the chance he holds it
function evalVolley(C, m, his, W) {
  const base = (ans) => { const c = clone(C); c.pj = null; if (ans) c.f[1 - m].wind -= cost(c, 1 - m, ans.id)[0]; resolveIncoming(c, 1 - m, ans); return value(c, m, W); };
  const U = base(null); let e = U;
  for (const t of his) for (let i = 0; i < C.inc.length; i++) if (ansFits(C, m, t.id, C.inc[i])) e = Math.min(e, U + t.p * (base({ id: t.id, i }) - U));
  return e;
}
export const MOVES = ['@in', '@out', '@stand', '@back', '@up', '@pull'];
export function actions(C, m) {
  const M = C.f[m], out = [];
  if (C.pj.ended) return out; // the move he laid ended his volley: nothing more this turn
  for (const id of [...new Set(M.hand), ...MOVES]) if (legalNow(C.pj, m, id) && canPay(M, cost(C, m, id))) out.push(id);
  return out;
}
function count(S, n) { if (S.st) { S.st.choices += n; S.st.steps++; if (n > S.st.maxCh) S.st.maxCh = n; } }
// the time model of bar P3: 2 s a decision + a look at each legal option (0.6 s a wind price, 0.4 s a limb icon)
function look(S, m, ids) {
  if (!S.st) return;
  let t = 2;
  for (const id of ids) { const [w, L] = id ? cost(S, m, id) : [0, '']; t += (N.mode !== 'limb' && id ? 0.6 : 0) + (N.mode !== 'wind' ? 0.4 * L.length : 0); }
  S.st.secs[m] += t;
}
export function aiPilot(W = W0, name = 'ai') {
  return {
    name,
    answer(S, m, opts) {
      let best = null, bv = -Infinity;
      const held = S.hold && S.hold.by !== m; // in a hold a tie goes to getting out
      for (const o of held ? opts.slice().reverse() : opts) {
        const c = clone(S);
        if (o) { const [w] = cost(c, m, o.id); if (N.mode !== 'limb') c.f[m].wind -= w; }
        resolveIncoming(c, m, o);
        const v = value(c, m, W);
        if (v > bv) { bv = v; best = o; }
      }
      count(S, opts.length); look(S, m, opts.map((o) => o && o.id));
      return best;
    },
    act(S, m) {
      let C = clone(S); const his = hisAnswers(S, 1 - m), seq = [];
      let best = evalVolley(C, m, his, W);
      for (;;) {
        const acts = actions(C, m); let top = null;
        if (C === S || C.st === null) { count(S, acts.length + 1); look(S, m, [...acts, null]); }
        for (const id of acts) { // two cards deep: a step or a set-up is judged with the best card behind it
          const c2 = clone(C); declare(c2, m, id); const v1 = evalVolley(c2, m, his, W); let v = v1;
          for (const id2 of actions(c2, m)) { const c3 = clone(c2); declare(c3, m, id2); v = Math.max(v, evalVolley(c3, m, his, W)); }
          if (!top || v > top.v) top = { v, v1, id, c: c2 };
        }
        if (!top || top.v <= best + 0.01 || seq.length >= 7) { if (S.st && acts.some((id) => id[0] !== '@')) S.st.held[m]++; break; }
        best = top.v1; seq.push(top.id); C = top.c;
        if (C.pj.ended) break; // a move that ends the volley: nothing more may be laid after it
      }
      return seq;
    },
  };
}
// where a deck wants to stand: the standing range where most of it is alive
const want = (F) => ['K', 'P', 'C'].reduce((b, k) => (fit(F, k) > fit(F, b) ? k : b), 'K');
const threat = (p) => (CARDS[p.id] ? worth(CARDS[p.id]) : 0);
function ruleAnswer(S, m, opts) {
  if (S.hold && S.hold.by !== m) return opts.find((o) => o && o.id === 'escape') || opts.find((o) => o && o.id === '@break') || null;
  let best = null, bv = 0;
  for (const o of opts) if (o) { const v = threat(S.inc[o.i]) + (o.id === '@cover' ? 0 : 0.5); if (v > bv) { bv = v; best = o; } }
  return best && (best.id !== '@cover' || threat(S.inc[best.i]) >= 4) ? best : null;
}
// a priority-list pilot: prio(S,m,C) -> ordered card ids to try; steps toward `to` when nothing on the list is legal
function listPilot(name, prio, to) {
  return {
    name,
    answer: (S, m, opts) => ruleAnswer(S, m, opts),
    act(S, m) {
      const C = clone(S), seq = [], goal = to || want(S.f[m]);
      for (let n = 0; n < 8; n++) {
        const acts = actions(C, m); if (!acts.length) break;
        let id = prio(C, m, acts).find((x) => acts.includes(x));
        if (!id) {
          // no card on the list is legal here: walk on the places, in flight words (never a code)
          const me = C.pj.at[m], him = C.pj.at[1 - m], R = 'KPC';
          if (me === 'stand' && him === 'stand') { const k = placeKey(C.pj, m); id = R.indexOf(k) < R.indexOf(goal) ? '@in' : R.indexOf(k) > R.indexOf(goal) ? '@out' : null; }
          else if (me === 'stand' && (him === 'seat' || him === 'back')) id = acts.find((x) => x === 'upkick') || (C.pj.j.leg ? '@out' : null); // he refuses to follow and walks away
          else if (me === 'stand' && him === 'gbot') id = acts.includes('@back') ? '@back' : null;
          else if (me === 'gtop') id = acts.includes('pass') ? 'pass' : acts.includes('@stand') ? (seq.length ? null : '@stand') : null;
          else if (me === 'gbot' || me === 'seat' || me === 'back' || me === 'knee') id = acts.find((x) => x === 'sweep' || x === 'upkick') || (seq.length ? null : acts.includes('@up') ? '@up' : null);
          else if (me === 'past') id = acts.find((x) => CARDS[x] && CARDS[x].k === 'hold');
          if (!id || !acts.includes(id)) break;
        }
        declare(C, m, id); seq.push(id);
        if (C.pj.ended) break;
      }
      return seq;
    },
  };
}
const dearFirst = (C, m, acts) => acts.filter((x) => x[0] !== '@' && CARDS[x].k !== 'ans').sort((a, b) => CARDS[b].w - CARDS[a].w);
export const impatient = () => listPilot('impatient', dearFirst);
const gripOn = (C, m) => C.tie && C.tie.by === m && C.tie.mode === 'grip';
const onGround = (C) => C.at[0] !== 'stand' || C.at[1] !== 'stand';
const SCRIPT = {
  boxing: [(C) => (onGround(C) ? (C.at[0] === 'gtop' ? ['hook', 'cross', 'pass'] : C.at[0] === 'stand' ? ['cross', 'hook'] : ['upkick']) : placeKey(C, 0) === 'C' ? ['hook', 'bodyhook', 'upper'] : ['jab', 'cross', 'hook', 'upper', 'bodyhook']), 'P'],
  kickboxing: [(C) => (placeKey(C, 0) === 'C' ? ['knee', 'kbhook'] : ['highkick', 'bodykick', 'onetwo', 'lowkick', 'kbhook', 'knee']), 'P'],
  karate: [(C) => (placeKey(C, 0) === 'K' ? ['revpunch', 'headkick', 'roundhouse', 'frontkick', 'legkick'] : ['headkick', 'roundhouse', 'frontkick', 'legkick', 'revpunch']), 'K'],
  judo: [(C, m) => (onGround(C) ? ['pin', 'armlock'] : gripOn(C, m) ? ['shoulderthrow', 'hipthrow', 'footsweep'] : ['grip']), 'P'],
  wrestling: [(C) => (onGround(C) ? ['fall', 'gnp', 'ride'] : ['slam', 'double', 'single']), 'P'],
  bjj: [(C, m) => (C.at[m] === 'gtop' ? ['pass', 'kimura', 'armbar'] : C.at[m] === 'gbot' ? ['triangle', 'armbar', 'kimura', 'sweep'] : C.at[m] === 'stand' && onGround(C) ? ['upkick', 'sweep'] : ['choke', 'sweep', 'tieup', '@pull']), 'P'],
  sambo: [(C) => (onGround(C) ? ['kneebar', 'anklelock', 'casualpin'] : ['sthrow', 'trip', 'overhand']), 'C'],
};
export const scripted = (style) => listPilot('scripted ' + style, (C, m, acts) => SCRIPT[style][0](C.pj, m).concat(acts.filter((x) => x === 'sprawl' || x === 'headlock')), SCRIPT[style][1]);
export { WORDS, PAIRS };
export { answerOptions };
