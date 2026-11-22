// CARDSCOPE4 pilots. ONE AI pilot flies any deck from public information (probe P10; later: opponents and ghost decks).
// Beside it: the impatient line (rule of thumb) and a scripted priority list per style.
import { CARDS, N } from './cards.mjs';
import { clone, declare, resolveIncoming, legalNow, canPay, cost, ansFits, posKey, fits, answerOptions } from './engine.mjs';

export const W0 = { hp: 1, ko: 1, pts: 4, pos: 3, posS: 0.8, wind: 0.5, lead: 1.5, sub: 30, pin: 14, setup: 4, drain: 2 };
const KEYS = ['K', 'P', 'C', 'T0', 'T1', 'T2', 'T3', 'B0', 'B1', 'B2', 'B3'];
export const worth = (c) => (c.k === 'strike' ? c.dmg + 4 * (c.pts || 0) : c.k === 'shot' ? 4 * c.pts + (c.dmg || 0) + 3 : c.k === 'hold' ? 12 : c.k === 'adv' ? 4 * c.pts + 2 : c.k === 'setup' ? 3 : c.k === 'move' ? 1 : 0);
const FIT = new Map();
// how much of this deck is alive at each place on the strip (worth per wind, averaged over the deck)
export function fit(F, key) {
  const id = F.list.join() + F.mech; let t = FIT.get(id);
  if (!t) {
    t = {};
    for (const k of KEYS) {
      let s = 0;
      for (const c of F.list.map((i) => CARDS[i])) { const at = c.at && (F.mech && (c.blitz || c.enter) ? ['K', 'P'] : c.at); if (at && fits(at, k)) s += worth(c) / Math.max(1, c.w); }
      t[k] = s / F.list.length;
    }
    FIT.set(id, t);
  }
  return t[key];
}
// the chance the held fighter still finds his Escape: his list less his open discard pile; he keeps his hand, Make room draws two
export function escapeOdds(S, m = S.hold.by) {
  const V = S.f[1 - S.hold.by], n = (a) => a.reduce((q, id) => q + (id === 'escape'), 0);
  const esc = n(V.list) - n(V.disc), pool = Math.max(5, V.list.length - V.disc.length), looks = S.hold.room ? N.roomDraw : N.hand + N.roomDraw;
  if (m !== S.hold.by && V.hand.includes('escape')) return 0.9; // only the held fighter sees his own hand
  return esc <= 0 ? 0 : Math.min(1, 1 - (1 - esc / pool) ** looks);
}
const dz = (hp) => 60 / (Math.max(hp, 0) + 6);
export function value(S, m, W = W0) {
  if (S.over) return S.over.win === m ? 1e4 : -1e4;
  const M = S.f[m], H = S.f[1 - m], ld = M.pts - H.pts;
  let v = W.hp * (M.hp - H.hp) + W.ko * (dz(H.hp) - dz(M.hp)) + W.pts * ld + W.lead * (Math.max(0, ld - 4) ** 2 - Math.max(0, -ld - 4) ** 2)
    + (S.pos === 'G' ? W.pos : W.posS) * (fit(M, posKey(S, m)) - fit(H, posKey(S, 1 - m))) + W.wind * (N.mode === 'limb' ? 0 : M.wind - H.wind) + W.drain * (H.drain - M.drain);
  if (S.hold) v += (S.hold.by === m ? 1 : -1) * (S.hold.kind === 'sub' ? W.sub : W.pin) * (0.15 + 0.85 * (1 - escapeOdds(S, m)));
  if (S.grip && S.f[S.grip.by].mech) v += (S.grip.by === m ? 1 : -1) * W.setup;
  if (S.tie && S.f[S.tie.by].mech) v += (S.tie.by === m ? 1 : -1) * W.setup;
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
export function actions(C, m) {
  const M = C.f[m], out = [];
  for (const id of [...new Set(M.hand), '@in', '@out', '@stand', '@up']) if (legalNow(C.pj, m, id) && canPay(M, cost(C, m, id))) out.push(id);
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
      for (const o of opts) {
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
      }
      return seq;
    },
  };
}
// where a deck wants to stand: the standing range where most of it is alive
const want = (F) => ['K', 'P', 'C'].reduce((b, k) => (fit(F, k) > fit(F, b) ? k : b), 'K');
const threat = (p) => (CARDS[p.id] ? worth(CARDS[p.id]) : 0);
function ruleAnswer(S, m, opts) {
  if (S.hold && S.hold.by !== m) return opts.find((o) => o && o.id === 'escape') || opts.find((o) => o && o.id === '@room') || null;
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
          const pos = C.pj.pos, R = 'KPC';
          if (pos === 'G') id = C.pj.top === m ? (seq.length ? null : '@stand') : acts.find((x) => x === 'escape') || '@up';
          else if (R.indexOf(pos) < R.indexOf(goal)) id = '@in'; else if (R.indexOf(pos) > R.indexOf(goal)) id = '@out';
          if (!id || !acts.includes(id)) break;
        }
        declare(C, m, id); seq.push(id);
      }
      return seq;
    },
  };
}
const dearFirst = (C, m, acts) => acts.filter((x) => x[0] !== '@' && CARDS[x].k !== 'ans').sort((a, b) => CARDS[b].w - CARDS[a].w);
export const impatient = () => listPilot('impatient', dearFirst);
const gripOn = (C, m) => C.grip && C.grip.by === m, tieOn = (C, m) => C.tie && C.tie.by === m;
const SCRIPT = {
  boxing: [() => ['jab', 'cross', 'hook', 'upper', 'bodyhook'], 'P'],
  karate: [() => ['headkick', 'roundhouse', 'revpunch', 'frontkick', 'legkick'], 'K'],
  judo: [(C, m) => (C.pos === 'G' ? ['pin', 'armlock'] : gripOn(C, m) ? ['shoulderthrow', 'hipthrow', 'footsweep'] : ['grip', 'footsweep']), 'C'],
  wrestling: [(C, m) => (C.pos === 'G' ? ['gnp', 'ride'] : tieOn(C, m) ? (C.tie.struck ? ['double', 'slam', 'single'] : ['single', 'slam', 'double']) : ['tieup', 'slam', 'double', 'single']), 'P'],
  bjj: [() => ['choke', 'armbar', 'triangle', 'kimura', 'pass', 'sweep', 'pull'], 'P'],
  sambo: [(C) => (C.pos === 'G' ? ['kneebar', 'anklelock', 'casualpin'] : ['sthrow', 'trip', 'overhand']), 'C'],
};
export const scripted = (style) => listPilot('scripted ' + style, (C, m, acts) => SCRIPT[style][0](C.pj, m).concat(acts.filter((x) => x === 'sprawl' || x === 'headlock')), SCRIPT[style][1]);
export { answerOptions };
