// CARDSCOPE1 greybox - the bots that sit in the player's chair. Each stands for a kind of player.
// random: any legal answer.  fixed: the same three cards every exchange, whatever he lays.
// greedy: sees the face-up cards, wants the most damage now.  reader: public information only - counts his cards,
// learns his patterns, plays the judges and the wind.  allSeeing: the reader with the hidden card shown (a ceiling).
import { EMPTY, JAB, BJAB, CROSS, LHOOK, BHOOK, UPPER, XC, BLOCK, BLOCK_LOW, SLIP, ROLL, STEP, TIE, FEINT, NCODES,
  COST, CFG, HABITS, cardOf } from './cards.mjs';
import { rng, resolve, newResult, enumerate, decode } from './rules.mjs';

const R = newResult();
const keys = new Int32Array(4096);
const line = [0, 0, 0], his = [0, 0, 0];

export function randomBot(seed) {
  const r = rng(seed);
  return { name: 'random',
    pick(v) { const n = enumerate(v.hand, v.wind, v.tieOk, keys); return decode(keys[Math.floor(r() * n)], [0, 0, 0]); },
    corner() { return ['water', 'ice', 'eyes'][Math.floor(r() * 3)]; } };
}

// pattern: three play codes. A card not in hand, or not affordable, becomes an empty beat.
export function fixedBot(pattern) {
  return { name: 'fixed ' + pattern.join('-'),
    pick(v) {
      const used = [], out = [0, 0, 0];
      let wind = v.wind;
      for (let i = 0; i < 3; i++) {
        const c = pattern[i]; if (c === EMPTY) continue;
        const card = cardOf(c);
        let at = -1;
        for (let k = 0; k < v.hand.length; k++) if (v.hand[k] === card && !used.includes(k)) { at = k; break; }
        if (at < 0 || COST[c] > wind || (card === TIE && (!v.tieOk || out.includes(TIE)))) continue;
        used.push(at); wind -= COST[c]; out[i] = c;
      }
      return out;
    },
    corner() { return 'water'; } };
}

// Scenarios for the face-down cards: scen = list of { codes (his full line), p }.
function scenariosFrom(v, post, r, scen) {
  scen.length = 0;
  const hid = []; for (let i = 0; i < 3; i++) if (v.shown[i] < 0) hid.push(i);
  if (!hid.length) { scen.push({ codes: v.shown.slice(), p: 1 }); return; }
  if (hid.length === 1) {
    const h = hid[0], d = post(h);
    for (let c = 0; c < NCODES; c++) if (d[c] > 0) { const codes = v.shown.slice(); codes[h] = c; scen.push({ codes, p: d[c] }); }
    return;
  }
  const ds = hid.map((h) => post(h).slice()), N = 24;                 // several hidden cards: sample
  for (let s = 0; s < N; s++) {
    const codes = v.shown.slice();
    for (let x = 0; x < hid.length; x++) { let u = r(), c = 0; while (c < NCODES - 1 && (u -= ds[x][c]) > 0) c++; codes[hid[x]] = c; }
    scen.push({ codes, p: 1 / N });
  }
}

export function greedyBot(seed) {
  const r = rng(seed), scen = [], flat = new Float64Array(NCODES).fill(1 / NCODES);
  return { name: 'greedy',
    pick(v) {
      scenariosFrom(v, () => flat, r, scen);
      const n = enumerate(v.hand, v.wind, v.tieOk, keys);
      let best = -1e9, bestKey = 0;
      for (let x = 0; x < n; x++) {
        decode(keys[x], line);
        let ev = 0;
        for (const s of scen) { resolve(line, s.codes, v.PA, v.PB, R); ev += s.p * ((R.hB + R.bB) - (R.hA + R.bA) + 8 * (R.kdB - R.kdA)); }
        ev += r() * 1e-6;
        if (ev > best) { best = ev; bestKey = keys[x]; }
      }
      return decode(bestKey, [0, 0, 0]);
    },
    corner() { return 'water'; } };
}

const HIDE_W = [0.8, 0.6, 0.7, 1.3, 1.3, 1.2, 1.5, 1.5, 0.8, 0.8, 1.3, 1.3, 0.7, 0.7, 0.5];
const SC = [2.5, 3, 2.5];
const verdict = (a, b) => (a > b ? 1 : a < b ? -1 : 0);

// o: { seed, see (all-seeing), count (use his discard pile), film (knows his habits), learn (watch his patterns),
//      corner: 'informed' | 'random' | 'water' | 'ice' | 'eyes', hiddenAnswer: play code always put against a hidden card }
export function readerBot(o = {}) {
  const opt = { seed: 1, see: false, count: true, film: false, learn: true, corner: 'informed', hiddenAnswer: -1, ...o };
  const r = rng(opt.seed), scen = [], post = new Float64Array(NCODES);
  const q = new Float64Array(NCODES);                         // how common each card is in his deck
  const posCnt = [0, 1, 2].map(() => new Float64Array(NCODES)), posTot = [0, 0, 0];
  const bigCnt = []; for (let i = 0; i <= NCODES; i++) bigCnt.push(new Float64Array(NCODES));
  const bigTot = new Float64Array(NCODES + 1);
  let hi = 0, lo = 0;
  const A = 4;

  function posterior(v, h) {
    post.fill(0);
    let budget = v.oppWind; for (let i = 0; i < 3; i++) if (v.shown[i] > 0) budget -= COST[v.shown[i]];
    const prev = h === 0 ? NCODES : (v.shown[h - 1] < 0 ? -1 : cardOf(v.shown[h - 1]));
    let tot = 0;
    for (let c = 0; c < NCODES; c++) {
      if (c === BLOCK_LOW) continue;
      if (c !== EMPTY && (v.total[c] === 0 || COST[c] > budget)) continue;
      if (c !== EMPTY && v.unseen[c] <= 0) continue;
      let w = c === EMPTY || !opt.count ? 1 : v.unseen[c] / v.total[c];
      w *= HIDE_W[c] * (posCnt[h][c] + A * q[c]) / (posTot[h] + A);
      if (prev >= 0) w *= ((bigCnt[prev][c] + A * q[c]) / (bigTot[prev] + A)) / q[c];
      post[c] = w; tot += w;
    }
    const pHi = (hi + 1.3) / (hi + lo + 2);
    post[BLOCK_LOW] = post[BLOCK] * (1 - pHi); post[BLOCK] *= pHi;
    for (let c = 0; c < NCODES; c++) post[c] /= tot;
    return post;
  }

  return { name: opt.see ? 'all-seeing' : 'reader',
    debugPosterior: (v, h) => posterior(v, h),
    start(info) {
      for (const a of posCnt) a.fill(0); posTot.fill(0); for (const a of bigCnt) a.fill(0); bigTot.fill(0); hi = 0; lo = 0;
      q.fill(0); const n = info.oppDef.deck.length;
      for (const c of info.oppDef.deck) q[c] += 0.8 / n;
      q[EMPTY] = 0.2; q[BLOCK_LOW] = q[BLOCK];
      if (opt.film) for (const h of info.oppDef.habits || []) {            // found on film in camp
        if (h === 'onetwo') { bigCnt[JAB][CROSS] += 8; bigTot[JAB] += 8; }
        if (h === 'hookfinish') { posCnt[2][LHOOK] += 8; posTot[2] += 8; }
        if (h === 'bodyfirst') { posCnt[0][BHOOK] += 6; posCnt[0][BJAB] += 3; posTot[0] += 9; }
        if (h === 'coversafter') for (const k of [CROSS, LHOOK]) { bigCnt[k][BLOCK] += 6; bigTot[k] += 6; }
        if (h === 'slipcross') { bigCnt[SLIP][CROSS] += 8; bigTot[SLIP] += 8; }
      }
    },
    observe(v, hisCodes) {
      if (!opt.learn) return;
      let prev = NCODES;
      for (let i = 0; i < 3; i++) {
        const c = cardOf(hisCodes[i]);
        posCnt[i][c]++; posTot[i]++; bigCnt[prev][c]++; bigTot[prev]++;
        if (hisCodes[i] === BLOCK) hi++; else if (hisCodes[i] === BLOCK_LOW) lo++;
        prev = c;
      }
    },
    pick(v) {
      if (opt.see) { scen.length = 0; scen.push({ codes: v.truth, p: 1 }); }
      else scenariosFrom(v, (h) => posterior(v, h), r, scen);
      // what this exchange is worth: the judges, the damage, the wind, a finish
      const me = v.me, him = v.him, jw = [1, 1, 1];
      let kdFor = 3.2, kdAg = 3.2, dmgW = 0.025, takenW = 0.03;
      if (v.lastRound) {
        let canWin = 0, safe = 0, kdWins = 0, kdLoses = 0;
        for (let j = 0; j < 3; j++) {
          const a = v.cards[j][0], b = v.cards[j][1], w = verdict(a + 10, b + 9), l = verdict(a + 9, b + 10);
          jw[j] = w !== l ? 1.3 : 0.1;
          if (w >= 0) canWin++; if (l > 0) safe++;
          if (verdict(a + 10, b + 8) >= 0) kdWins++; if (verdict(a + 8, b + 10) <= 0) kdLoses++;
        }
        if (canWin < 2) { dmgW *= 3; kdFor = kdWins >= 2 ? 6 : 1.5; }
        if (safe >= 2) { takenW *= 2; kdAg = kdLoses >= 2 ? 6 : 1.5; }
      }
      if (v.kdNet !== 0) for (let j = 0; j < 3; j++) jw[j] *= 0.15;
      const remScale = Math.sqrt(v.rem + 0.15);
      const hisMult = 1 + 1.2 * (him.head / him.chin) ** 2, myMult = 1 + 1.2 * (me.head / me.chin) ** 2;
      const windOn = !(v.lastRound && v.rem === 0);
      const hid = []; for (let i = 0; i < 3; i++) if (v.shown[i] < 0) hid.push(i);
      const n = enumerate(v.hand, v.wind, v.tieOk, keys);
      let best = -1e9, bestKey = 0;
      for (let x = 0; x < n; x++) {
        decode(keys[x], line);
        const cost = COST[line[0]] + COST[line[1]] + COST[line[2]];
        let ev = 0;
        for (const s of scen) {
          resolve(line, s.codes, v.PA, v.PB, R);
          let val = 0;
          if (R.kdB) val += kdFor; if (R.kdA) val -= kdAg;
          if (v.kdNet + R.kdB - R.kdA === 0) {
            const dc = CFG.judgeClean * (R.clA - R.clB);
            val += jw[0] / (1 + Math.exp(-(v.diff[0] + dc + CFG.judgeThrown * (R.thA - R.thB)) / (SC[0] * remScale)));
            val += jw[1] / (1 + Math.exp(-(v.diff[1] + dc + CFG.judgeDamage * (R.hB + R.bB - R.hA - R.bA)) / (SC[1] * remScale)));
            val += jw[2] / (1 + Math.exp(-(v.diff[2] + dc + CFG.judgeCraft * (R.crA - R.crB)) / (SC[2] * remScale)));
          }
          val += dmgW * (R.hB * hisMult + 0.5 * R.bB) - takenW * (R.hA * myMult + 0.5 * R.bA);
          if (him.head + R.hB >= him.chin || (R.kdB && him.kds + 1 >= CFG.kdStop)) val += 8;
          if (me.head + R.hA >= me.chin || (R.kdA && me.kds + 1 >= CFG.kdStop)) val -= 8;
          if (windOn) {
            const mine = Math.min(v.cap, Math.max(0, v.wind - cost + R.wA - (R.kdA ? CFG.kdWind : 0)) + CFG.windBack);
            const hisCost = COST[s.codes[0]] + COST[s.codes[1]] + COST[s.codes[2]];
            const theirs = Math.max(0, v.oppWind - hisCost + R.wB - (R.kdB ? CFG.kdWind : 0));
            val += 0.10 * mine - 0.05 * theirs;
          }
          ev += s.p * val;
        }
        ev += r() * 0.02;                                       // do not be the same boxer twice
        if (opt.hiddenAnswer >= 0) { let ok = true; for (const h of hid) if (line[h] !== opt.hiddenAnswer) ok = false; if (ok) ev += 50; }
        if (ev > best) { best = ev; bestKey = keys[x]; }
      }
      return decode(bestKey, [0, 0, 0]);
    },
    corner(v) {
      if (opt.corner === 'random') return ['water', 'ice', 'eyes'][Math.floor(r() * 3)];
      if (opt.corner !== 'informed') return opt.corner;
      if (v.me.head >= 0.45 * v.me.chin) return 'ice';
      if (v.wind + CFG.windStool <= v.cap - 3) return 'water';
      return 'eyes';
    } };
}
export const allSeeingBot = (seed) => readerBot({ seed, see: true });
export { HABITS };
