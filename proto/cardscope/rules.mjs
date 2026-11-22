// CARDSCOPE1 greybox - the exchange in three beats. Pure rules: no DOM, no dice inside a hit.
import { EMPTY, JAB, CROSS, LHOOK, BHOOK, UPPER, XC, BLOCK, BLOCK_LOW, SLIP, ROLL, STEP, TIE, FEINT,
  COST, DMG, IS_PUNCH, BODY, SHAPE, SPEED, POWER, STRAIGHT, CFG } from './cards.mjs';

// Seeded random numbers: same seed, same bout.
export function rng(seed) {
  let a = seed >>> 0;
  return () => {
    a = (a + 0x6D2B79F5) | 0;
    let t = Math.imul(a ^ (a >>> 15), 1 | a);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}
export function shuffle(arr, r) {
  for (let i = arr.length - 1; i > 0; i--) {
    const j = Math.floor(r() * (i + 1));
    const t = arr[i]; arr[i] = arr[j]; arr[j] = t;
  }
  return arr;
}

// One punch meeting the other corner's card on the same beat. Results land in these module-level slots.
let _d = 0, _clean = 0, _defCred = 0, _defCtr = 0, _attCred = 0;
function hit(c, d, ctr, chain, p1, p2, feintOpen, smothered, PX, PY, dCtr) {
  _d = 0; _clean = 0; _defCred = 0; _defCtr = 0; _attCred = 0;
  if (!IS_PUNCH[c]) return;
  let base, speed = SPEED[c];
  if (c === XC) {
    if (STRAIGHT[d]) { _d = CFG.xcDamage + PX.pow; _clean = 1; _attCred = 2; return; }   // the read was right
    base = DMG[XC] + PX.pow;                                                          // otherwise a slow cross
  } else base = DMG[c] + (POWER[c] ? PX.pow : PX.pow >> 1);                         // light punches take half the Power
  if (ctr) { base += CFG.counterBonus; speed = 1; }
  if (chain > 0) {
    let bonus = CFG.chain;
    if (chain >= 2 && p2 === JAB && p1 === CROSS && c === LHOOK) bonus = CFG.oneTwoThree;
    else if (p1 === JAB && c === CROSS) bonus = CFG.oneTwo;
    else if (p1 === BHOOK && c === LHOOK) bonus = CFG.bodyHead;
    base += bonus;
  }
  if (feintOpen) base += CFG.feintBonus;
  if (smothered) base -= CFG.smother;
  if (base < 0) base = 0;
  if (d === TIE) { if (c === UPPER) { _d = base; _clean = base > 0 ? 1 : 0; } return; }
  if (d === STEP) return;
  if (d === BLOCK || d === BLOCK_LOW) {
    if (!feintOpen && (d === BLOCK_LOW) === (BODY[c] === 1)) {
      _d = base > CFG.blockStops ? base - CFG.blockStops : 0;                           // a block stops 4
      if (_d * 2 > base) _clean = 1; else _defCred = 1;                                 // more than half through = it landed
      return;
    }
    _d = base; _clean = base > 0 ? 1 : 0; return;
  }
  if (d === SLIP || d === ROLL) {
    if (!feintOpen) {
      if (SHAPE[c] === (d === SLIP ? 1 : 2)) { _defCred = 1; _defCtr = 1; return; }     // made to miss
      _d = base + CFG.wrongEvade; _clean = 1; return;                                   // walked into it
    }
    _d = base; _clean = base > 0 ? 1 : 0; return;
  }
  if (IS_PUNCH[d]) {
    if (d === XC && STRAIGHT[c]) return;                                                // countered: it misses
    const ds = dCtr ? 1 : SPEED[d];
    if (speed * 2 - PX.quick > ds * 2 - PY.quick) base -= CFG.slowerLoses;              // beaten to the punch
    if (base < 0) base = 0;
  }
  _d = base; _clean = base > 0 ? 1 : 0;
}

// Result slots of one exchange. A = the player's corner, B = the opponent's.
export function newResult() {
  return { hA: 0, hB: 0, bA: 0, bB: 0, clA: 0, clB: 0, crA: 0, crB: 0, wA: 0, wB: 0, thA: 0, thB: 0, kdA: 0, kdB: 0,
    blank: 0, beats: 0, log: null };
}

// a, b: three play codes each. PA, PB: { pow, quick, kd } (kd = head damage in one exchange that puts her down).
export function resolve(a, b, PA, PB, R) {
  let hA = 0, hB = 0, bA = 0, bB = 0, clA = 0, clB = 0, crA = 0, crB = 0, wA = 0, wB = 0;
  let ctrA = 0, ctrB = 0, chA = 0, chB = 0, p1A = 0, p2A = 0, p1B = 0, p2B = 0, fA = 0, fB = 0, smA = 0, smB = 0;
  let kdA = 0, kdB = 0, blank = 0, beats = 0, thA = 0, thB = 0;
  for (let i = 0; i < 3; i++) {
    const ca = a[i], cb = b[i];
    beats++; thA += IS_PUNCH[ca]; thB += IS_PUNCH[cb];
    hit(ca, cb, ctrA, chA, p1A, p2A, fA, smA, PA, PB, ctrB);
    const dA = _d, cA = _clean, credB = _defCred, nCtrB = _defCtr, acA = _attCred;
    hit(cb, ca, ctrB, chB, p1B, p2B, fB, smB, PB, PA, ctrA);
    const dB = _d, cB = _clean, credA = _defCred, nCtrA = _defCtr, acB = _attCred;
    if (BODY[ca]) { bB += dA; if (ca === BHOOK && cA) wB -= 1; } else hB += dA;
    if (BODY[cb]) { bA += dB; if (cb === BHOOK && cB) wA -= 1; } else hA += dB;
    clA += cA; clB += cB;
    crA += credA + acA + (ctrA && cA ? 1 : 0);
    crB += credB + acB + (ctrB && cB ? 1 : 0);
    if (R.log) R.log.push({ beat: i + 1, a: ca, b: cb, toB: dA, toA: dB, cleanA: cA, cleanB: cB, counterA: ctrA, counterB: ctrB });
    if (cA) { chA++; p2A = p1A; p1A = ca; } else { chA = 0; p1A = 0; p2A = 0; }
    if (cB) { chB++; p2B = p1B; p1B = cb; } else { chB = 0; p1B = 0; p2B = 0; }
    fA = (ca === FEINT && cb >= BLOCK && cb <= ROLL) ? 1 : 0;
    fB = (cb === FEINT && ca >= BLOCK && ca <= ROLL) ? 1 : 0;
    smA = cb === TIE ? 1 : 0; smB = ca === TIE ? 1 : 0;
    ctrA = nCtrA; ctrB = nCtrB;
    if (ca === EMPTY) wA += CFG.windEmptyBeat;
    if (cb === EMPTY) wB += CFG.windEmptyBeat;
    if (dA === 0 && dB === 0 && !credA && !credB) blank++;
    if (hA >= PA.kd) kdA = 1;
    if (hB >= PB.kd) kdB = 1;
    if (kdA || kdB) break;
  }
  R.hA = hA; R.hB = hB; R.bA = bA; R.bB = bB; R.clA = clA; R.clB = clB; R.crA = crA; R.crB = crB;
  R.wA = wA; R.wB = wB; R.thA = thA; R.thB = thB; R.kdA = kdA; R.kdB = kdB; R.blank = blank; R.beats = beats;
  return R;
}

export const lineCost = (c) => COST[c[0]] + COST[c[1]] + COST[c[2]];
export const keyOf = (c) => c[0] + 15 * c[1] + 225 * c[2];
export function decode(key, out) { out[0] = key % 15; out[1] = ((key / 15) | 0) % 15; out[2] = (key / 225) | 0; return out; }

// Every legal answer from a hand: at most one card a beat, cost within wind, one tie-up at most and only if allowed.
// A Block card gives two answers (high, low). Fills `out` with line keys and returns how many.
const seen = new Int32Array(3375); let stamp = 0;
export function enumerate(hand, wind, tieOk, out) {
  stamp++;
  let n = 0;
  const m = hand.length;
  for (let i = -1; i < m; i++) {
    const ci = i < 0 ? 0 : hand[i];
    if (ci === TIE && !tieOk) continue;
    const wi = wind - COST[ci];
    if (wi < 0) continue;
    for (let j = -1; j < m; j++) {
      if (j >= 0 && j === i) continue;
      const cj = j < 0 ? 0 : hand[j];
      if (cj === TIE && (!tieOk || ci === TIE)) continue;
      const wj = wi - COST[cj];
      if (wj < 0) continue;
      for (let k = -1; k < m; k++) {
        if (k >= 0 && (k === i || k === j)) continue;
        const ck = k < 0 ? 0 : hand[k];
        if (ck === TIE && (!tieOk || ci === TIE || cj === TIE)) continue;
        if (wj - COST[ck] < 0) continue;
        const vi = ci === BLOCK ? 2 : 1, vj = cj === BLOCK ? 2 : 1, vk = ck === BLOCK ? 2 : 1;
        for (let x = 0; x < vi; x++) for (let y = 0; y < vj; y++) for (let z = 0; z < vk; z++) {
          const key = (ci + x) + 15 * (cj + y) + 225 * (ck + z);
          if (seen[key] !== stamp) { seen[key] = stamp; out[n++] = key; }
        }
      }
    }
  }
  return n;
}
