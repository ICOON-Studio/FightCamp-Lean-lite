// CARDSCOPE3 greybox: the simple players (random, a fixed line, the rule-of-thumb beginner) and the forced arms.
import { CARDS, N, guardEffect } from './cards.mjs';
import { resolveIncoming } from './engine.mjs';
import { guardSets, attacks, cornerPick } from './plan.mjs';

export const randomBot = () => ({
  act(S, m, bell) {
    const gs = guardSets(S, m), g = gs[Math.floor(S.r() * gs.length)], res = resolveIncoming(S, m, g.marks, g.tie);
    if (bell || res.kd) return { marks: g.marks, tie: g.tie, seq: [], set: null };
    const at = attacks(S.b[m].hand, g.w), a = at[Math.floor(S.r() * at.length)];
    return { marks: g.marks, tie: g.tie, seq: a.seq, set: a.set };
  },
  corner: (S, k) => cornerPick(S, k, 'random'),
});
// a fixed line: card names in a fixed order, played top down while wind lasts; a guard goes on the biggest punch it stops
export const fixedBot = (order) => ({
  act(S, m, bell) {
    const M = S.b[m], hand = M.hand.slice(), marks = S.inc.map(() => null), seq = [];
    let w = M.wind, set = null, tie = false;
    for (const id of order) {
      const c = CARDS[id];
      for (;;) {
        const h = hand.indexOf(id); if (h < 0 || c.w > w) break;
        if (c.kind === 'guard') {
          let bi = -1;
          S.inc.forEach((p, i) => { if (!marks[i] && guardEffect(id, p.id) && (bi < 0 || CARDS[p.id].dmg > CARDS[S.inc[bi].id].dmg)) bi = i; });
          if (bi < 0 || tie || (id !== 'parry' && marks.filter((g) => g && g !== 'parry').length >= N.maxGuards)) break; marks[bi] = id;
        } else if (c.kind === 'tie') { if (M.tieUsed || !S.inc.length || marks.some(Boolean) || tie) break; tie = true; }
        else if (c.kind === 'trap') { if (set || bell || w < N.trapCost) break; set = id; w -= N.trapCost; hand.splice(h, 1); continue; }
        else { if (bell || seq.length >= 4) break; seq.push(id); }
        w -= c.w; hand.splice(h, 1);
      }
    }
    const res = resolveIncoming(S, m, marks, tie);
    return res.kd ? { marks, tie, seq: [], set: null } : { marks, tie, seq, set };
  },
  corner: (S, k) => cornerPick(S, k, 'water'),
});
// the beginner's rule of thumb: guard what you see with the right guard, biggest first, then jab, cross, hook
export const beginnerBot = () => ({
  act(S, m, bell) {
    const M = S.b[m], hand = M.hand.slice(), marks = S.inc.map(() => null); let w = M.wind;
    const order = S.inc.map((p, i) => i).sort((a, b) => CARDS[S.inc[b].id].dmg - CARDS[S.inc[a].id].dmg);
    for (const i of order) for (const g of ['parry', 'slip', 'roll', 'block']) {
      const h = hand.indexOf(g); if (h < 0 || CARDS[g].w > w || !guardEffect(g, S.inc[i].id)) continue;
      if (g !== 'parry' && marks.filter((x) => x && x !== 'parry').length >= N.maxGuards) continue;
      marks[i] = g; w -= CARDS[g].w; hand.splice(h, 1); break;
    }
    const seq = [], res = resolveIncoming(S, m, marks, false);
    if (!bell && !res.kd) for (const id of ['jab', 'cross', 'hook', 'bodyjab', 'bodyhook', 'upper']) for (;;) {
      const h = hand.indexOf(id); if (h < 0 || CARDS[id].w > w || seq.length >= 4) break;
      seq.push(id); w -= CARDS[id].w; hand.splice(h, 1);
    }
    return { marks, tie: false, seq, set: null };
  },
  corner: (S, k) => cornerPick(S, k, 'water'),
});
// forced answers to his set card (bar C6)
export const FORCED = {
  ignore: { know: { belief: 'none' } },
  jabfirst: { filter: (a, S, m) => !S.b[m].hand.includes('jab') || a.seq[0] === 'jab' },
  jabsonly: { filter: (a) => a.seq.every((id) => id === 'jab' || id === 'bodyjab') },
  nothing: { filter: (a) => a.seq.length === 0 },
};
