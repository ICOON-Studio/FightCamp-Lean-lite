// CARDSCOPE greybox (round 2) - the opponent. When he leads he lays three cards, hides some, keeps to his habits and
// reads what you keep doing. When you lead he answers what he can see, with the same rules as you. He never sees a
// face-down card or your hand; he uses only what the table and this bout have shown him.
import { EMPTY, JAB, BJAB, CROSS, LHOOK, BHOOK, UPPER, XC, BLOCK, BLOCK_LOW, SLIP, ROLL, STEP, TIE, FEINT, CHK, NCODES,
  COST, IS_PUNCH, BODY, POWER, IS_GUARD, STYLE_W, HABITS, HABIT_P, TIERS, CFG, KIND, cardOf } from './cards.mjs';
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
      if (oc === CHK && R.hA >= CFG.chkDamage) v += 2.0;                    // your next beat is gone
      U[oc][pc] = v;
    }
  }
}
buildValues();

// What a typical good player does (before he has seen you): by context of his own card on that beat.
// Contexts: 0 his card is face down, 1 he shows a head punch, 2 a body punch, 3 a guard, 4 nothing or a feint.
const prior = (pairs) => { const a = new Float64Array(NCODES).fill(0.01); for (const [c, w] of pairs) a[c] = w; return a; };
export const PRIOR = [
  prior([[BLOCK, .16], [BLOCK_LOW, .06], [SLIP, .08], [ROLL, .08], [STEP, .06], [EMPTY, .14], [JAB, .12], [CROSS, .12], [LHOOK, .06], [BHOOK, .04], [XC, .04]]),
  prior([[BLOCK, .40], [SLIP, .15], [ROLL, .10], [STEP, .10], [JAB, .10], [EMPTY, .05], [CROSS, .05], [XC, .05]]),
  prior([[BLOCK_LOW, .45], [STEP, .10], [JAB, .15], [CROSS, .15], [EMPTY, .05], [ROLL, .10]]),
  prior([[BJAB, .10], [BHOOK, .20], [FEINT, .10], [EMPTY, .30], [JAB, .10], [CROSS, .10], [UPPER, .10]]),
  prior([[JAB, .25], [CROSS, .30], [LHOOK, .20], [UPPER, .10], [BHOOK, .10], [EMPTY, .05]]),
];
// What a typical player lays face down when he leads.
const HPRIOR = prior([[CROSS, .18], [LHOOK, .14], [UPPER, .06], [BHOOK, .06], [JAB, .05], [BLOCK, .09], [BLOCK_LOW, .03], [SLIP, .07], [ROLL, .05],
  [CHK, .12], [FEINT, .05], [EMPTY, .10]]);
export const ctxOf = (code) => (IS_PUNCH[code] ? (BODY[code] ? 2 : 1) : (IS_GUARD[code] ? 3 : 4));
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
  const cntHid = new Float64Array(NCODES), R = newResult(), scen = [], m = [0, 0, 0], HB = 12;
  const gumbel = () => -Math.log(-Math.log(r() + 1e-12));

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
      const keep = r() < HABIT_P;                               // this exchange he keeps to his habits (or breaks them)
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
        for (const set of sets) {
          let v = s;
          // a habit: with its trigger on the table the face-down card is the habit's card (or, on a break, is not)
          for (let i = 0; i < 3; i++) m[i] = set[i] ? -1 : c[i];
          for (let h = 0; h < 3; h++) {
            if (!set[h]) continue;
            if (KIND[c[h]] === 2) v += CFG.hideGuard;             // a guard or the trap is worth more unseen
            let hb = null; for (const x of habits) if (x.when(m, h)) { hb = x; break; }
            if (!hb) continue;
            const match = cardOf(c[h]) === hb.card;
            v += keep ? (match ? HB : -HB) : (match ? -HB : 0);
          }
          for (let i = 0; i < 3; i++) v += set[i] ? EH[i][c[i]] : ES[i][c[i]];
          v += gumbel() * tier.noise;
          if (v > best) { best = v; bestKey = keys[x]; bestSet = set; }
        }
      }
      return { codes: decode(bestKey, [0, 0, 0]), hidden: bestSet.slice() };
    },
    // After the beats are played he has seen your three cards.
    // You led: he answers what he sees. shown = your three cards (-1 = face down), unseen = your cards not yet seen.
    answer(side, foe, shown, unseen) {
      let budget = foe.wind; const hid = [];
      for (let i = 0; i < 3; i++) { if (shown[i] < 0) hid.push(i); else budget -= COST[shown[i]]; }
      scen.length = 0;
      if (!hid.length) scen.push({ codes: shown.slice(), p: 1 });
      else {
        const w = new Float64Array(NCODES); let tot = 0;
        for (let k = 0; k < NCODES; k++) {
          if (k !== EMPTY && (unseen[cardOf(k)] <= 0 || COST[k] > budget)) continue;
          w[k] = 3 * HPRIOR[k] + tier.adapt * cntHid[k]; tot += w[k];
        }
        if (hid.length === 1) { for (let k = 0; k < NCODES; k++) if (w[k] > 0) { const codes = shown.slice(); codes[hid[0]] = k; scen.push({ codes, p: w[k] / tot }); } }
        else for (let x = 0; x < 10; x++) {
          const codes = shown.slice();
          for (const h of hid) { let u = r() * tot, k = 0; while (k < NCODES - 1 && (u -= w[k]) > 0) k++; codes[h] = k; }
          scen.push({ codes, p: 0.1 });
        }
      }
      const n = enumerate(side.hand, side.wind, !side.tieUsed, keys);
      let best = -1e9, bestKey = 0;
      for (let x = 0; x < n; x++) {
        decode(keys[x], c);
        const left = side.wind - COST[c[0]] - COST[c[1]] - COST[c[2]];
        let ev = 0;
        for (const s of scen) {
          resolve(s.codes, c, foe.P, side.P, R);
          ev += s.p * ((R.hA + 0.6 * R.bA) - (R.hB + 0.6 * R.bB) + 1.5 * (R.clB - R.clA) + (R.crB - R.crA) + 8 * (R.kdA - R.kdB)
            + R.drA - R.drB + 1.0 * Math.min(side.cap, left + R.wB + CFG.windBack));
        }
        ev += gumbel() * tier.ans;
        if (ev > best) { best = ev; bestKey = keys[x]; }
      }
      return decode(bestKey, [0, 0, 0]);
    },
    observe(playerCodes, oppCodes, hidden, youLead) {
      if (youLead) { for (let i = 0; i < 3; i++) if (hidden[i]) cntHid[playerCodes[i]]++; return; }
      for (let i = 0; i < 3; i++) {
        cntIdx[i][playerCodes[i]]++;
        cntCtx[hidden[i] ? 0 : ctxOf(oppCodes[i])][playerCodes[i]]++;
      }
    },
    corner(side) {
      if (side.head >= 0.5 * side.chin) return 'ice';
      if (side.wind + CFG.windStool < side.cap) return 'water';
      return 'eyes';
    },
  };
}
