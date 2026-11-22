// CARDSCOPE3 greybox: one planner, many profiles (greedy, table player, reader, all-seeing, the opponent classes).
import { CARDS, N, TRAPS, guardEffect } from './cards.mjs';
import { resolveIncoming, windBack, seesSet, kdLine, judgePts } from './engine.mjs';

const cnt = (a, id) => { let n = 0; for (const x of a) if (x === id) n++; return n; };
// chance that a hand of 5 from a pool of n holds one of k copies
const holds = (k, n) => { if (k <= 0) return 0; let q = 1; for (let j = 0; j < 5; j++) q *= Math.max(0, n - k - j) / Math.max(1, n - j); return 1 - q; };

export const PROF = {
  greedy: { model: 'still', belief: 'none', wTake: 1, wDeal: 1, wKeep: 0, wJ: 0, sets: 'no', kdPen: 0, kdBonus: 0 },
  table: { model: 'still', belief: 'mid', wTake: 1, wDeal: 1, wKeep: 0, wJ: 0.5, sets: 'tally', kdPen: 6, kdBonus: 0, climb: true },
  reader: { model: 'read', belief: 'read', wTake: 1.1, wDeal: 1, wKeep: 1.0, wJ: 0.6, sets: 'tally', kdPen: 12, kdBonus: 5, habits: 2, count: true, tally: true },
  see: { model: 'see', belief: 'see', wTake: 1.1, wDeal: 1, wKeep: 1.0, wJ: 0.6, sets: 'see', kdPen: 12, kdBonus: 5, habits: 2, count: true, tally: true },
};

// every legal way to guard his volley
export function guardSets(S, m, blind) {
  const M = S.b[m], inc = S.inc, out = [], used = M.hand.map(() => false), marks = inc.map(() => null);
  (function rec(i, w, ng) {
    if (i === inc.length) { out.push({ marks: marks.slice(), tie: false, w }); return; }
    rec(i + 1, w, ng);
    const seen = new Set();
    for (let h = 0; h < M.hand.length; h++) {
      const id = M.hand[h], c = CARDS[id];
      if (used[h] || c.kind !== 'guard' || seen.has(id) || c.w > w) continue;
      if (!blind && !guardEffect(id, inc[i].id)) continue;
      const n2 = ng + (id === 'parry' ? 0 : 1); if (n2 > N.maxGuards) continue;
      seen.add(id); used[h] = true; marks[i] = id; rec(i + 1, w - c.w, n2); used[h] = false; marks[i] = null;
    }
  })(0, M.wind, 0);
  if (inc.length && !M.tieUsed && M.wind >= CARDS.tieup.w && M.hand.includes('tieup')) out.push({ marks: inc.map(() => null), tie: true, w: M.wind - CARDS.tieup.w });
  return out;
}
// every volley (ordered punches, up to 4) with or without a trap set, within wind w
export function attacks(hand, w) {
  const out = [], left = {}; for (const id of hand) left[id] = (left[id] || 0) + 1;
  const ids = Object.keys(left), seq = [];
  (function rec(wl) {
    out.push({ seq: seq.slice(), set: null, cost: w - wl });
    if (wl >= N.trapCost) for (const t of TRAPS) if (left[t]) out.push({ seq: seq.slice(), set: t, cost: w - wl + N.trapCost });
    if (seq.length >= 4) return;
    for (const id of ids) { const c = CARDS[id]; if (c.kind !== 'punch' || !left[id] || c.w > wl) continue; left[id]--; seq.push(id); rec(wl - c.w); seq.pop(); left[id]++; }
  })(w);
  return out;
}
// what M believes his set card is: { trapId: chance }
export function trapBelief(S, m, prof) {
  const D = S.b[1 - m]; if (!D.set || prof.belief === 'none') return null;
  if (prof.belief === 'see' || seesSet(S, m)) return { [D.set]: 1 };
  const k = {}; let sum = 0;
  for (const t of TRAPS) { k[t] = Math.max(0, cnt(D.list, t) - (prof.count ? cnt(D.disc, t) : 0)); sum += k[t]; }
  if (!sum) for (const t of TRAPS) { k[t] = cnt(D.list, t); sum += k[t]; }
  const b = {};
  if (prof.belief === 'mid') { for (const t of TRAPS) if (k[t]) b[t] = 0.5; return b; }
  for (const t of TRAPS) b[t] = k[t] / sum;
  const hb = D.habits.slice(0, prof.habits || 0).find((h) => D.setTrig.includes(h.trig));
  if (hb && hb.trap && k[hb.trap]) { for (const t of TRAPS) b[t] *= 1 - N.habitKeep; b[hb.trap] += N.habitKeep; return b; }
  if (prof.tally) {
    let best = null, bn = 1;
    for (const t of D.setTrig) { const o = D.tally.sets[t]; if (!o) continue; const n = Object.values(o).reduce((a, x) => a + x, 0); if (n > bn) { bn = n; best = o; } }
    if (best) for (const t of TRAPS) b[t] = ((best[t] || 0) + b[t]) / (bn + 1);
  }
  return b;
}
// expected result of a volley thrown at D
function landed(S, m, seq, counter, prof) {
  const M = S.b[m], D = S.b[1 - m]; let dmg = 0, head = 0, clean = 0, pc = 0;
  const pool = D.deck.length + D.hand.length, av = {};
  const have = (g) => (g in av ? av[g] : (av[g] = prof.model === 'see' ? cnt(D.hand, g) : Math.max(0, cnt(D.list, g) - (prof.count ? cnt(D.disc, g) : 0))));
  const p1 = (g) => { const k = have(g); if (k <= 0) return 0; av[g] = k - 1; return prof.model === 'see' ? 1 : holds(k, pool); };
  let budget = prof.model === 'still' ? 0 : Math.min(D.cap, D.wind + windBack(D));
  const stop = seq.map(() => [0, 0]);
  if (prof.model !== 'still') {
    const order = seq.map((id, i) => i).sort((a, b) => CARDS[seq[b]].dmg - CARDS[seq[a]].dmg);
    for (const i of order) {
      const id = seq[i], c = CARDS[id]; let pe = 0, pb = 0;
      if (c.cls === 'jab') pe = p1('parry');
      if (budget > 0) {
        if (c.shape !== 'hook') pe += (1 - pe) * p1('slip') * Math.min(1, budget);
        if (c.shape !== 'straight') pe += (1 - pe) * p1('roll') * Math.min(1, budget);
        pb = (1 - pe) * p1('block') * Math.min(1, budget) * (c.dmg >= 4 ? 1 : 0.5);
        budget -= pe + pb;
      }
      stop[i] = [pe, pb];
    }
  }
  for (let i = 0; i < seq.length; i++) {
    const c = CARDS[seq[i]], [pe, pb] = stop[i];
    const d = c.dmg + (i === 0 ? counter : 0) + N.chain * pc + (c.w >= 2 ? M.pow : 0);
    pc = 1 - pe - pb;
    const e = d * pc + Math.max(0, d - (c.shape === 'upper' ? N.splitBlock : N.block)) * pb;
    dmg += e; if (c.zone === 'head') head += e; clean += pc;
    if (c.drain) dmg += 2 * pc * c.drain;
  }
  return { dmg, head, clean };
}
// how much each judge still cares this round (a round already far apart is worth little more)
function judgeW(S, m, prof) {
  const o = { clean: 0, thrown: 0, dmg: 0, craft: 0 }; if (!prof.wJ) return o;
  for (const ts of ['work', 'hurt', 'craft']) {
    const gap = Math.abs(judgePts(S.b[m].rd, ts) - judgePts(S.b[1 - m].rd, ts)), c = (prof.model === 'still' ? 1 : gap <= 4 ? 1 : 0.3) * prof.wJ;
    o.clean += 2 * c; if (ts === 'work') o.thrown += 0.5 * c; if (ts === 'hurt') o.dmg += c / 5; if (ts === 'craft') o.craft += c;
  }
  return o;
}
function pThrows(S, m, cls, prof, flat) {
  const D = S.b[1 - m];
  if (prof.sets === 'see') return D.hand.some((id) => CARDS[id].cls === cls) ? (N.trapFirst ? 0.45 : 0.85) : 0.05;
  if (flat) return 0.4;
  return ((N.trapFirst ? D.tally.lead : D.tally.cls)[cls] + (N.trapFirst ? 0.7 : 1)) / (D.tally.turns + 2);
}
const AVG = { jab: 2, rear: 7, hook: 5 };

// the planner. o = { prof, eps, forceSet, noSet, filter(att, S, m), noGuard, allGuard, blind, flat }
export function choose(S, m, bell, o) {
  const prof = o.prof, M = S.b[m], D = S.b[1 - m], J = judgeW(S, m, prof);
  const gs = guardSets(S, m, o.blind);
  let atts = bell ? [{ seq: [], set: null, cost: 0 }] : attacks(M.hand, M.wind);
  if (o.noSet) atts = atts.filter((a) => !a.set);
  if (o.filter && D.set) { const f = atts.filter((a) => o.filter(a, S, m)); if (f.length) atts = f; }
  if (o.forceSet) { const f = atts.filter((a) => a.set === o.forceSet); if (f.length) atts = f; }
  if (o.eps && S.r() < o.eps) {
    const g = gs[Math.floor(S.r() * gs.length)], res = resolveIncoming(S, m, g.marks, g.tie);
    const ok = res.kd ? [{ seq: [], set: null }] : atts.filter((a) => a.cost <= g.w);
    const a = ok.length ? ok[Math.floor(S.r() * ok.length)] : { seq: [], set: null };
    return { marks: g.marks, tie: g.tie, seq: a.seq, set: a.set };
  }
  const belief = trapBelief(S, m, prof);
  const aVal = (a, counter) => {
    const key = 'v' + counter; if (a[key] !== undefined) return a[key];
    const E = landed(S, m, a.seq, counter, prof);
    let v = prof.wDeal * E.dmg + J.clean * E.clean + J.thrown * a.seq.length + J.dmg * E.dmg;
    if (prof.kdBonus) v += prof.kdBonus * Math.max(0, Math.min(1, (E.head - (kdLine(D) - 4)) / 4));
    if (belief) {
      const seen = new Set();
      for (const id of a.seq) {
        const c = CARDS[id]; if (seen.has(c.cls) || (N.trapFirst && seen.size)) break; seen.add(c.cls);
        for (const t in belief) if (CARDS[t].catches === c.cls) v -= belief[t] * (prof.wTake * CARDS[t].dmg + J.clean + prof.wDeal * (c.dmg + (N.trapEnds ? 4 : 0)) + (M.head + CARDS[t].dmg >= M.headMax ? 30 : 0));
      }
    }
    if (a.set && prof.sets !== 'no') { const t = CARDS[a.set]; v += pThrows(S, m, t.catches, prof, o.flat) * (prof.wDeal * t.dmg + prof.wTake * AVG[t.catches] + J.clean + J.craft); }
    else if (a.set) v -= 1;
    return (a[key] = v);
  };
  const gVal = (g) => {
    if (o.blind) { let v = 0; g.marks.forEach((x) => { if (x) v += x === 'block' ? 3 : x === 'parry' ? 0.6 : 2.2; }); return { v, res: { kd: false, evades: 0, ctr: 0 } }; }
    const res = resolveIncoming(S, m, g.marks, g.tie);
    let v = -prof.wTake * (res.head + 0.8 * res.body + 2 * res.drain) - J.clean * res.clean - J.dmg * (res.head + res.body) + J.craft * res.craft;
    if (res.kd) v -= prof.kdPen + 4;
    if (M.head + res.head >= M.headMax) v -= 40;
    return { v, res };
  };
  const keep = (wl) => prof.wKeep * Math.min(wl, M.cap - N.back);
  let pool = gs;
  if (o.noGuard) pool = [gs[0]];
  if (o.allGuard) { let b = 1e9; const sc = gs.map((g) => { const r = resolveIncoming(S, m, g.marks, g.tie); const x = r.head + r.body; if (x < b) b = x; return x; }); pool = gs.filter((g, i) => sc[i] === b); }
  if (prof.climb) return climb(bell, pool, atts, gVal, aVal);
  let best = null, bv = -1e9;
  for (const g of pool) {
    const G = gVal(g);
    if (G.res.kd || bell) { if (G.v > bv) { bv = G.v; best = { marks: g.marks, tie: g.tie, seq: [], set: null }; } continue; }
    for (const a of atts) { if (a.cost > g.w) continue; const v = G.v + aVal(a, G.res.ctr) + keep(g.w - a.cost); if (v > bv) { bv = v; best = { marks: g.marks, tie: g.tie, seq: a.seq, set: a.set }; } }
  }
  return best;
}
// the table player: one card at a time, keep the one the printed numbers like best, stop when nothing improves
function climb(bell, gs, atts, gVal, aVal) {
  const nG = (g) => (g.tie ? 1 : g.marks.filter(Boolean).length);
  let g = gs.find((x) => !x.tie && nG(x) === 0) || gs[0], G = gVal(g), a = atts.find((x) => !x.seq.length && !x.set) || atts[0];
  const val = (G1, a1) => G1.v + (G1.res.kd || bell ? 0 : aVal(a1, G1.res.ctr));
  const pre = (x, y) => x.seq.every((c, i) => y.seq[i] === c);
  for (;;) {
    let cur = val(G, a), nx = null;
    for (const g2 of gs) {
      if (nG(g2) !== nG(g) + 1 || a.cost > g2.w) continue;
      if (!g2.tie && !g.marks.every((x, i) => !x || g2.marks[i] === x)) continue;
      const G2 = gVal(g2), v = val(G2, a); if (v > cur + 1e-9) { cur = v; nx = [g2, G2, a]; }
    }
    if (!bell && !G.res.kd) for (const a2 of atts) {
      if (a2.cost > g.w || !pre(a, a2)) continue;
      const grow = (a2.set === a.set && a2.seq.length === a.seq.length + 1) || (!a.set && a2.set && a2.seq.length === a.seq.length);
      if (!grow) continue;
      const v = val(G, a2); if (v > cur + 1e-9) { cur = v; nx = [g, G, a2]; }
    }
    if (!nx) break;
    [g, G, a] = nx;
  }
  const off = G.res.kd || bell;
  return { marks: g.marks, tie: g.tie, seq: off ? [] : a.seq, set: off ? null : a.set };
}
export function cornerPick(S, k, mode) {
  const B = S.b[k];
  if (mode === 'random') return ['water', 'ice', 'watch'][Math.floor(S.r() * 3)];
  if (mode && mode !== 'informed') return mode;
  if (B.head >= N.hurtAt - 6) return 'ice';
  if (B.wind + N.stool <= B.cap - 2) return 'water';
  return TRAPS.reduce((a, t) => a + cnt(S.b[1 - k].list, t), 0) >= 2 && S.round % 2 === 0 ? 'watch' : B.head >= 14 ? 'ice' : 'water';
}
// an agent from a profile name and options
export function planner(name, o = {}) {
  const prof = { ...PROF[name], ...(o.know || {}) };
  return { act: (S, m, bell) => choose(S, m, bell, { ...o, prof }), corner: (S, k) => cornerPick(S, k, o.corner) };
}
// the opponent of a class: keeps his habits when their trigger is on the table
export function opponent(cls, o = {}) {
  const prof = { ...PROF[cls.prof], habits: 0 }, adapt = o.adapt ?? cls.adapt;
  return {
    act(S, m, bell) {
      const M = S.b[m], x = { prof, eps: cls.eps, flat: !adapt, noSet: !!cls.noTraps };
      const hb = bell ? null : M.habits.find((h) => M.trig.includes(h.trig));
      if (hb && !cls.noTraps && S.r() < N.habitKeep) { if (hb.trap && M.hand.includes(hb.trap)) x.forceSet = hb.trap; else x.noSet = true; }
      const p = choose(S, m, bell, x);
      if ((prof.sets === 'no' && !x.forceSet && p.set) || cls.noTraps) p.set = null;
      return p;
    },
    corner: (S, k) => cornerPick(S, k, 'informed'),
  };
}
