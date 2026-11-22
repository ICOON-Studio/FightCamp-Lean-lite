// CARDSCOPE1 greybox - the opponent: he lays three cards first, hides some, and reads what you keep doing.
// He never sees your cards before he lays his. He uses only what you have already shown him in this bout.
import { EMPTY, JAB, BJAB, CROSS, LHOOK, BHOOK, UPPER, XC, BLOCK, BLOCK_LOW, SLIP, ROLL, STEP, TIE, FEINT, NCODES,
  COST, IS_PUNCH, BODY, POWER, IS_GUARD, STYLE_W, HABITS, TIERS } from './cards.mjs';
import { resolve, newResult, enumerate, decode } from './rules.mjs';

// What one of his cards is worth against one of yours on a single beat (his point of view).
const U = [];
export function buildValues() {
  U.length = 0;
  const R = newResult(), P = { pow: 0, quick: 0, kd: 99 };
  for (let oc = 0; oc < NCODES; oc++) {
    U.push(new Float64Array(NCODES));
    for (let pc = 0; pc < NCODES; pc++) {
      resolve([pc, 0, 0], [oc, 0, 0], P, P, R);
      let v = (R.hA + R.bA) - (R.hB + R.bB) + 1.6 * (R.crB - R.crA) - 0.6 * COST[oc];
      if ((oc === SLIP || oc === ROLL) && R.crB > 0) v += 2.4;            // a counter is coming
      if (oc === FEINT && IS_GUARD[pc]) v += 2.4;                          // you bit
      if (oc === BHOOK && R.bA > 0) v += 1.0;                              // your wind
      if (oc === EMPTY) v += 0.8;                                          // his wind
      U[oc][pc] = v;
    }
  }
}
buildValues();

// What a typical good player does (before he has seen you): by context of his own card on that beat.
// Contexts: 0 his card is face down, 1 he shows a head punch, 2 a body punch, 3 a guard, 4 nothing or a feint.
const prior = (pairs) => { const a = new Float64Array(NCODES).fill(0.01); for (const [c, w] of pairs) a[c] = w; return a; };
const PRIOR = [
  prior([[BLOCK, .22], [BLOCK_LOW, .08], [SLIP, .08], [ROLL, .05], [STEP, .07], [EMPTY, .15], [JAB, .12], [CROSS, .10], [LHOOK, .05], [BHOOK, .04]]),
  prior([[BLOCK, .40], [SLIP, .15], [ROLL, .10], [STEP, .10], [JAB, .10], [EMPTY, .05], [CROSS, .05], [XC, .05]]),
  prior([[BLOCK_LOW, .45], [STEP, .10], [JAB, .15], [CROSS, .15], [EMPTY, .05], [ROLL, .10]]),
  prior([[BJAB, .10], [BHOOK, .20], [FEINT, .10], [EMPTY, .30], [JAB, .10], [CROSS, .10], [UPPER, .10]]),
  prior([[JAB, .25], [CROSS, .30], [LHOOK, .20], [UPPER, .10], [BHOOK, .10], [EMPTY, .05]]),
];
const ctxOf = (code) => (IS_PUNCH[code] ? (BODY[code] ? 2 : 1) : (IS_GUARD[code] ? 3 : 4));
const HIDE_SETS = { 0: [[0, 0, 0]], 1: [[1, 0, 0], [0, 1, 0], [0, 0, 1]], 2: [[1, 1, 0], [1, 0, 1], [0, 1, 1]], 3: [[1, 1, 1]] };

export function makeOpponent(def, tierNo, r, over = {}) {
  const tier = { ...TIERS[tierNo], ...over };
  const cntIdx = [0, 1, 2].map(() => new Float64Array(NCODES));
  const cntCtx = [0, 1, 2, 3, 4].map(() => new Float64Array(NCODES));
  const ES = [0, 1, 2].map(() => new Float64Array(NCODES));   // his card shown on beat i
  const EH = [0, 1, 2].map(() => new Float64Array(NCODES));   // his card face down on beat i
  const keys = new Int32Array(4096), c = [0, 0, 0];
  const sw = STYLE_W[def.style];
  const habits = (def.habits || []).map((h) => HABITS[h]);

  function expect(i, ctx, oc) {
    const ci = cntIdx[i], cc = cntCtx[ctx], pr = PRIOR[ctx], u = U[oc], k = tier.adapt;
    let tot = 0, ev = 0;
    for (let pc = 0; pc < NCODES; pc++) {
      const w = k * (ci[pc] + cc[pc]) + 3 * pr[pc];
      tot += w; ev += w * u[pc];
    }
    return ev / tot;
  }

  return {
    def, tier,
    // side = his side of the table. hideN = how many cards go face down this exchange.
    line(side, hideN, lastOfRound) {
      for (let i = 0; i < 3; i++) for (let oc = 0; oc < NCODES; oc++) {
        ES[i][oc] = expect(i, ctxOf(oc), oc);
        EH[i][oc] = expect(i, 0, oc);
      }
      const n = enumerate(side.hand, side.wind, !side.tieUsed, keys);
      const active = habits.filter((h) => r() < h.p);
      const sets = HIDE_SETS[hideN];
      let best = -1e9, bestKey = 0, bestSet = sets[0];
      for (let x = 0; x < n; x++) {
        decode(keys[x], c);
        let np = 0, ng = 0, ne = 0, cost = 0, s = 0;
        for (let i = 0; i < 3; i++) {
          const k = c[i];
          np += IS_PUNCH[k]; ng += IS_GUARD[k]; cost += COST[k]; if (k === EMPTY) ne++;
          s += 1.6 * sw[k];
        }
        for (let i = 0; i < 2; i++) {
          if (c[i] === JAB && POWER[c[i + 1]]) s += 1.0;
          if ((c[i] === SLIP || c[i] === ROLL) && IS_PUNCH[c[i + 1]]) s += 0.8;
        }
        if (ng > 1) s -= 1.6 * (ng - 1);
        if (np === 0 && side.wind >= 3) s -= 2.4;
        if (!lastOfRound) { const left = side.wind - cost + ne; if (left < 2) s -= 0.7 * (2 - left); }
        for (const h of active) if (h.test(c)) s += 12;
        for (const set of sets) {
          let v = s;
          for (let i = 0; i < 3; i++) v += set[i] ? EH[i][c[i]] : ES[i][c[i]];
          v += -Math.log(-Math.log(r() + 1e-12)) * 1.0 * tier.noise;
          if (v > best) { best = v; bestKey = keys[x]; bestSet = set; }
        }
      }
      return { codes: decode(bestKey, [0, 0, 0]), hidden: bestSet.slice() };
    },
    // After the beats are played he has seen your three cards.
    observe(playerCodes, oppCodes, hidden) {
      for (let i = 0; i < 3; i++) {
        cntIdx[i][playerCodes[i]]++;
        cntCtx[hidden[i] ? 0 : ctxOf(oppCodes[i])][playerCodes[i]]++;
      }
    },
    corner(side) {
      if (side.head >= 0.45 * side.chin) return 'ice';
      return 'water';
    },
  };
}
