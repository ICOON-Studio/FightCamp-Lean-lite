// CARDSCOPE greybox (round 2) - two bots that stand for a person at the table.
// beginner: the critic's rule-of-thumb player. One rule per shown card, one fixed answer to the face-down card, jab,
//   cross, hook in order when it leads. No counting, no judges, no memory.
// table player: a person helped by the table (design 3.9). It places one card at a time and keeps the placement whose
//   printed numbers are best: damage both ways and the three judges' counts for this exchange on the shown beats, the
//   middle of the printed range on the face-down beat. No memory, no plan for the wind, no look past this exchange.
import { EMPTY, JAB, BJAB, CROSS, LHOOK, BHOOK, UPPER, XC, BLOCK, BLOCK_LOW, SLIP, ROLL, STEP, TIE, FEINT, CHK, NCODES,
  COST, CFG, cardOf } from './cards.mjs';
import { resolve, newResult } from './rules.mjs';
import { HIDE_SETS } from './bots.mjs';

const R = newResult();
// The rule of thumb: what to try, in order, against each card he shows.
const RULE = {
  [JAB]: [SLIP, BLOCK], [BJAB]: [SLIP, BLOCK_LOW], [CROSS]: [XC, SLIP, BLOCK], [XC]: [SLIP, BLOCK],
  [LHOOK]: [ROLL, BLOCK], [BHOOK]: [ROLL, BLOCK_LOW], [CHK]: [ROLL, CROSS, LHOOK], [UPPER]: [STEP, BLOCK],
  [BLOCK]: [BHOOK, BJAB, UPPER], [BLOCK_LOW]: [CROSS, LHOOK, JAB], [SLIP]: [LHOOK, BHOOK, UPPER], [ROLL]: [CROSS, JAB, UPPER],
  [STEP]: [], [TIE]: [UPPER], [FEINT]: [JAB, CROSS, LHOOK, BJAB, BHOOK], [EMPTY]: [JAB, CROSS, LHOOK, BJAB, BHOOK],
};
const LEAD = [[JAB, BJAB, CROSS, LHOOK, BHOOK, CHK], [CROSS, LHOOK, BHOOK, JAB, BJAB, CHK, UPPER], [LHOOK, CROSS, BHOOK, CHK, UPPER, JAB, BJAB]];

// Takes cards out of a hand one by one, minding the wind and the one tie-up a round.
function taker(v) {
  const used = new Array(v.hand.length).fill(false);
  let wind = v.wind, tied = !v.tieOk;
  return (code) => {
    const card = cardOf(code);
    if (COST[code] > wind || (card === TIE && tied)) return false;
    for (let k = 0; k < v.hand.length; k++) if (v.hand[k] === card && !used[k]) { used[k] = true; wind -= COST[code]; if (card === TIE) tied = true; return true; }
    return false;
  };
}
const leadInOrder = (v) => {
  const take = taker(v), codes = [0, 0, 0];
  for (let i = 0; i < 3; i++) for (const c of LEAD[i]) if (take(c)) { codes[i] = c; break; }
  const sets = HIDE_SETS[v.hideN];
  return { codes, hidden: sets[sets.length - 1].slice() };
};

export function beginnerBot(o = {}) {
  const opt = { hidden: BLOCK, ...o };
  return { name: 'beginner',
    pick(v) {
      const take = taker(v), out = [0, 0, 0];
      for (let i = 0; i < 3; i++) {
        const s = v.shown[i];
        if (s < 0) { if (opt.hidden !== EMPTY && take(opt.hidden)) out[i] = opt.hidden; continue; }
        for (const c of RULE[s]) if (take(c)) { out[i] = c; break; }
      }
      return out;
    },
    lead: leadInOrder,
    corner() { return 'water'; } };
}

export function tableBot() {
  const line = [0, 0, 0], scen = [];
  // the number the table prints for a line: this exchange only
  function printed(v) {
    let lo = 1e9, hi = -1e9;
    for (const s of scen) {
      resolve(line, s, v.PA, v.PB, R);
      const dd = (R.hB + R.bB) - (R.hA + R.bA);
      const judges = CFG.judgeClean * (R.clA - R.clB) + CFG.judgeGuard * (R.crA - R.crB) + (CFG.judgeThrown * (R.thA - R.thB) + CFG.judgeDamage * dd + CFG.judgeCraft * (R.crA - R.crB)) / 3;
      const val = dd + 2 * judges + 10 * (R.kdB - R.kdA);
      if (val < lo) lo = val; if (val > hi) hi = val;
    }
    return (lo + hi) / 2;                                       // the middle of the printed range
  }
  return { name: 'table player',
    pick(v) {
      // what can lie face down: every card he still holds and can pay for, or nothing (the table prints this range)
      scen.length = 0;
      let budget = v.oppWind; const hid = [];
      for (let i = 0; i < 3; i++) { if (v.shown[i] < 0) hid.push(i); else budget -= COST[v.shown[i]]; }
      if (!hid.length) scen.push(v.shown.slice());
      else {
        const opts = [EMPTY];
        for (let c = 1; c < NCODES; c++) if (v.unseen[cardOf(c)] > 0 && COST[c] <= budget) opts.push(c);
        const fill = (k, codes) => { if (k === hid.length) { scen.push(codes.slice()); return; } for (const c of opts) { codes[hid[k]] = c; fill(k + 1, codes); } };
        fill(0, v.shown.slice());
      }
      line[0] = line[1] = line[2] = 0;
      const used = new Array(v.hand.length).fill(false);
      let wind = v.wind, tied = !v.tieOk, base = printed(v);
      for (let step = 0; step < 3; step++) {
        let best = base + 1e-9, bi = -1, bk = -1, bc = 0;
        for (let i = 0; i < 3; i++) {
          if (line[i] !== EMPTY) continue;
          for (let k = 0; k < v.hand.length; k++) {
            const card = v.hand[k];
            if (used[k] || COST[card] > wind || (card === TIE && tied)) continue;
            for (const code of card === BLOCK ? [BLOCK, BLOCK_LOW] : [card]) {
              line[i] = code; const val = printed(v); line[i] = EMPTY;
              if (val > best) { best = val; bi = i; bk = k; bc = code; }
            }
          }
        }
        if (bi < 0) break;
        line[bi] = bc; used[bk] = true; wind -= COST[bc]; if (bc === TIE) tied = true; base = best;
      }
      return line.slice();
    },
    lead: leadInOrder,                                          // the table cannot print his answer: it leads like the beginner
    corner() { return 'water'; } };
}
