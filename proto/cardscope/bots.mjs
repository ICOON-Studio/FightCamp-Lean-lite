// CARDSCOPE greybox (round 2) - the bots that sit in the player's chair. Each stands for a kind of player.
// Every bot answers (pick) when he leads and lays three cards (lead) when it leads.
// random: any legal line.  fixed: the same three cards every exchange.  greedy: sees the face-up cards, wants the most
// damage now.  reader: public information only - counts his cards, learns his patterns and his answers, plays the judges
// and the wind.  allSeeing: the reader with his face-down card shown (a ceiling, not a legal player).
// beginner and table player: bots2.mjs.
import { EMPTY, BLOCK, BLOCK_LOW, TIE, NCODES, COST, DMG, IS_PUNCH, CFG, HABITS, HABIT_P, cardOf } from './cards.mjs';
import { rng, resolve, newResult, enumerate, decode } from './rules.mjs';
import { PRIOR, ctxOf } from './opponent.mjs';

const R = newResult();
const keys = new Int32Array(4096);
const line = [0, 0, 0], his = [0, 0, 0];
export const HIDE_SETS = { 0: [[0, 0, 0]], 1: [[1, 0, 0], [0, 1, 0], [0, 0, 1]], 2: [[1, 1, 0], [1, 0, 1], [0, 1, 1]], 3: [[1, 1, 1]] };

export function randomBot(seed) {
  const r = rng(seed);
  const any = (v) => { const n = enumerate(v.hand, v.wind, v.tieOk, keys); return decode(keys[Math.floor(r() * n)], [0, 0, 0]); };
  return { name: 'random', pick: any,
    lead(v) { const sets = HIDE_SETS[v.hideN]; return { codes: any(v), hidden: sets[Math.floor(r() * sets.length)].slice() }; },
    corner() { return ['water', 'ice', 'eyes'][Math.floor(r() * 3)]; } };
}

// pattern: three play codes. A card not in hand, or not affordable, becomes an empty beat. hideAt: the beat it hides.
export function fixedBot(pattern, hideAt = 2) {
  const pick = (v) => {
    const used = [], out = [0, 0, 0];
    let wind = v.wind;
    for (let i = 0; i < 3; i++) {
      const c = pattern[i]; if (c === EMPTY) continue;
      const card = cardOf(c);
      let at = -1;
      for (let k = 0; k < v.hand.length; k++) if (v.hand[k] === card && !used.includes(k)) { at = k; break; }
      if (at < 0 || COST[c] > wind || (c === TIE && (!v.tieOk || out.includes(TIE)))) continue;
      used.push(at); wind -= COST[c]; out[i] = c;
    }
    return out;
  };
  return { name: 'fixed ' + pattern.join('-'), pick,
    lead(v) { const sets = HIDE_SETS[v.hideN]; return { codes: pick(v), hidden: sets[Math.min(hideAt, sets.length - 1)].slice() }; },
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
// Which beats to lay face down: the n cards that hit hardest (a damage chaser hides his best shot).
function hideHeaviest(codes, n) {
  const idx = [0, 1, 2].sort((a, b) => DMG[codes[b]] - DMG[codes[a]] || b - a), hidden = [0, 0, 0];
  for (let i = 0; i < n; i++) hidden[idx[i]] = 1;
  return hidden;
}

export function greedyBot(seed) {
  const r = rng(seed), scen = [], flat = new Float64Array(NCODES).fill(1 / NCODES), none = [0, 0, 0];
  const best = (v, value) => {
    const n = enumerate(v.hand, v.wind, v.tieOk, keys);
    let top = -1e9, key = 0;
    for (let x = 0; x < n; x++) { decode(keys[x], line); const ev = value() + r() * 1e-6; if (ev > top) { top = ev; key = keys[x]; } }
    return decode(key, [0, 0, 0]);
  };
  return { name: 'greedy',
    pick(v) {
      scenariosFrom(v, () => flat, r, scen);
      return best(v, () => { let ev = 0; for (const s of scen) { resolve(line, s.codes, v.PA, v.PB, R); ev += s.p * ((R.hB + R.bB) - (R.hA + R.bA) + 8 * (R.kdB - R.kdA)); } return ev; });
    },
    lead(v) {                                                   // the most damage if he stands still
      const codes = best(v, () => { resolve(line, none, v.PA, v.PB, R); return R.hB + R.bB; });
      return { codes, hidden: hideHeaviest(codes, v.hideN) };
    },
    corner() { return 'water'; } };
}

//              -    J    BJ   CR   LH   BH   UP   XC   BL   BLo  SL   RO   ST   TI   FE   CH
const HIDE_W = [0.8, 0.6, 0.7, 1.3, 1.3, 1.2, 1.5, 1.5, 0.9, 0.9, 1.3, 1.3, 0.7, 0.7, 0.7, 1.5];
const SC = [2.5, 3, 2.5];
const verdict = (a, b) => (a > b ? 1 : a < b ? -1 : 0);

// o: { seed, see (all-seeing), count (use his discard pile), film (how many of his habits are known before the bell),
//      learn (watch his patterns and his answers), corner: 'informed' | 'random' | 'water' | 'ice' | 'eyes',
//      hiddenAnswer: play code always put against a face-down card (-2 = always a punch), flip (count habit flips) }
export function readerBot(o = {}) {
  const opt = { seed: 1, see: false, count: true, film: 0, learn: true, corner: 'informed', hiddenAnswer: -1, flip: false, dmgK: 1, kdK: 1, windK: 2, plain: null, ...o };
  const r = rng(opt.seed), scen = [], post = new Float64Array(NCODES);
  const q = new Float64Array(NCODES);                         // how common each card is in his deck
  const hidPos = [0, 1, 2].map(() => new Float64Array(NCODES)), hidPosTot = [0, 0, 0];   // what lay face down on each beat
  const hidAft = []; for (let i = 0; i <= NCODES; i++) hidAft.push(new Float64Array(NCODES)); // ... after each shown card
  const hidAftTot = new Float64Array(NCODES + 1);
  const ans = [0, 1, 2, 3, 4].map(() => new Float64Array(NCODES));                        // how he answers, by what he saw
  const K = 8, samp = [0, 1, 2, 3, 4].map(() => new Int32Array(K * 3)), cdf = new Float64Array(NCODES);
  let hi = 0, lo = 0, known = [];
  const A = 2.5, W = { jw: [1, 1, 1], kdFor: 0, kdAg: 0, dmgW: 0, takenW: 0, remScale: 1, hisMult: 1, myMult: 1, windOn: true };
  const stat = { applies: 0, differs: 0 };

  function posterior(v, h, useFilm) {
    post.fill(0);
    let budget = v.oppWind; for (let i = 0; i < 3; i++) if (v.shown[i] > 0) budget -= COST[v.shown[i]];
    const prev = h > 0 && v.shown[h - 1] >= 0 ? cardOf(v.shown[h - 1]) : NCODES;
    const can = (c) => c === EMPTY || (v.total[c] > 0 && COST[c] <= budget && (!opt.count || v.unseen[c] > 0));
    let tot = 0;
    for (let c = 0; c < NCODES; c++) {
      if (c === BLOCK_LOW || !can(c)) continue;
      let w = c === EMPTY || !opt.count ? 1 : v.unseen[c] / v.total[c];
      w *= HIDE_W[c] * (hidPos[h][c] + A * q[c]) / (hidPosTot[h] + A);
      w *= ((hidAft[prev][c] + A * q[c]) / (hidAftTot[prev] + A)) / q[c];
      post[c] = w; tot += w;
    }
    for (let c = 0; c < NCODES; c++) post[c] /= tot;
    if (useFilm) {                                              // a known habit prints its card on the face-down slot
      let hb = null; for (const x of known) if (x.when(v.shown, h)) { hb = x; break; }
      if (hb && can(hb.card)) { for (let c = 0; c < NCODES; c++) post[c] *= 1 - HABIT_P; post[hb.card] += HABIT_P; }
    }
    const pHi = (hi + 1.3) / (hi + lo + 2);
    post[BLOCK_LOW] = post[BLOCK] * (1 - pHi); post[BLOCK] *= pHi;
    return post;
  }
  // what this exchange is worth: the judges, the damage, the wind, a finish
  function weigh(v) {
    const me = v.me, him = v.him, jw = W.jw; jw[0] = jw[1] = jw[2] = 1;
    W.kdFor = 3.2 * opt.kdK; W.kdAg = 3.2 * opt.kdK; W.dmgW = 0.025 * opt.dmgK; W.takenW = 0.03 * opt.dmgK;
    if (v.lastRound) {
      let canWin = 0, safe = 0, kdWins = 0, kdLoses = 0;
      for (let j = 0; j < 3; j++) {
        const a = v.cards[j][0], b = v.cards[j][1], w = verdict(a + 10, b + 9), l = verdict(a + 9, b + 10);
        jw[j] = w !== l ? 1.3 : 0.1;
        if (w >= 0) canWin++; if (l > 0) safe++;
        if (verdict(a + 10, b + 8) >= 0) kdWins++; if (verdict(a + 8, b + 10) <= 0) kdLoses++;
      }
      if (canWin < 2) { W.dmgW *= 3; W.kdFor = kdWins >= 2 ? 6 : 1.5; }
      if (safe >= 2) { W.takenW *= 2; W.kdAg = kdLoses >= 2 ? 6 : 1.5; }
    }
    if (v.kdNet !== 0) for (let j = 0; j < 3; j++) jw[j] *= 0.15;
    W.remScale = Math.sqrt(v.rem + 0.15);
    W.hisMult = 1 + 1.2 * (him.head / him.chin) ** 2; W.myMult = 1 + 1.2 * (me.head / me.chin) ** 2;
    W.windOn = !(v.lastRound && v.rem === 0);
  }
  function score(v, cost, hisCost) {
    const me = v.me, him = v.him, jw = W.jw;
    if (opt.plain) { const k = opt.plain; return (R.hB + R.bB) - (R.hA + R.bA) + 8 * (R.kdB - R.kdA) + k[0] * (R.clA - R.clB) + k[1] * (R.crA - R.crB) + k[2] * (R.thA - R.thB) + k[3] * (Math.max(0, v.wind - cost + R.wA) - R.drA) - k[4] * (Math.max(0, v.oppWind - hisCost + R.wB) - R.drB); }
    let val = 0;
    if (R.kdB) val += W.kdFor; if (R.kdA) val -= W.kdAg;
    if (v.kdNet + R.kdB - R.kdA === 0) {
      const dc = CFG.judgeClean * (R.clA - R.clB) + CFG.judgeGuard * (R.crA - R.crB);
      val += jw[0] / (1 + Math.exp(-(v.diff[0] + dc + CFG.judgeThrown * (R.thA - R.thB)) / (SC[0] * W.remScale)));
      val += jw[1] / (1 + Math.exp(-(v.diff[1] + dc + CFG.judgeDamage * (R.hB + R.bB - R.hA - R.bA)) / (SC[1] * W.remScale)));
      val += jw[2] / (1 + Math.exp(-(v.diff[2] + dc + CFG.judgeCraft * (R.crA - R.crB)) / (SC[2] * W.remScale)));
    }
    val += W.dmgW * (R.hB * W.hisMult + 0.5 * R.bB) - W.takenW * (R.hA * W.myMult + 0.5 * R.bA);
    if (him.head + R.hB >= him.chin || (R.kdB && him.kds + 1 >= CFG.kdStop)) val += 8;
    if (me.head + R.hA >= me.chin || (R.kdA && me.kds + 1 >= CFG.kdStop)) val -= 8;
    if (W.windOn) {
      const mine = Math.max(0, Math.min(v.cap, Math.max(0, v.wind - cost + R.wA) + me.backNow) - R.drA - (R.kdA ? CFG.kdWind : 0));
      const theirs = Math.max(0, Math.max(0, v.oppWind - hisCost + R.wB) + him.backNow - R.drB - (R.kdB ? CFG.kdWind : 0));
      val += opt.windK * (0.10 * mine - 0.05 * theirs);
    }
    return val;
  }
  // the answer to his three cards
  function choose(v, useFilm, jitter) {
    if (opt.see) { scen.length = 0; scen.push({ codes: v.truth, p: 1 }); }
    else scenariosFrom(v, (h) => posterior(v, h, useFilm), r, scen);
    weigh(v);
    const hid = []; for (let i = 0; i < 3; i++) if (v.shown[i] < 0) hid.push(i);
    const n = enumerate(v.hand, v.wind, v.tieOk, keys);
    let best = -1e9, bestKey = 0;
    for (let x = 0; x < n; x++) {
      decode(keys[x], line);
      const cost = COST[line[0]] + COST[line[1]] + COST[line[2]];
      let ev = 0;
      for (const s of scen) { resolve(line, s.codes, v.PA, v.PB, R); ev += s.p * score(v, cost, COST[s.codes[0]] + COST[s.codes[1]] + COST[s.codes[2]]); }
      if (jitter) ev += r() * 0.02;                             // do not be the same boxer twice
      if (opt.hiddenAnswer !== -1 && hid.length) {
        let ok = true; for (const h of hid) if (opt.hiddenAnswer === -2 ? !IS_PUNCH[line[h]] : line[h] !== opt.hiddenAnswer) ok = false;
        if (ok) ev += 50;
      }
      if (ev > best) { best = ev; bestKey = keys[x]; }
    }
    return decode(bestKey, [0, 0, 0]);
  }

  return { name: opt.see ? 'all-seeing' : 'reader', stat,
    debugPosterior: (v, h) => posterior(v, h, true),
    start(info) {
      for (const a of hidPos) a.fill(0); hidPosTot.fill(0); for (const a of hidAft) a.fill(0); hidAftTot.fill(0); hi = 0; lo = 0;
      for (const a of ans) a.fill(0);
      q.fill(0); const n = info.oppDef.deck.length;
      for (const c of info.oppDef.deck) q[c] += 0.8 / n;
      q[EMPTY] = 0.2; q[BLOCK_LOW] = q[BLOCK];
      known = (info.oppDef.habits || []).slice(0, opt.film).map((h) => HABITS[h]);   // found on film in camp
    },
    observe(v, hisCodes, myCodes, res, youLead, hidden) {
      if (!opt.learn) return;
      if (youLead) { for (let i = 0; i < 3; i++) ans[hidden[i] ? 0 : ctxOf(myCodes[i])][hisCodes[i]]++; return; }
      for (let h = 0; h < 3; h++) {
        if (!hidden[h]) continue;
        const c = cardOf(hisCodes[h]), prev = h > 0 && !hidden[h - 1] ? cardOf(hisCodes[h - 1]) : NCODES;
        hidPos[h][c]++; hidPosTot[h]++; hidAft[prev][c]++; hidAftTot[prev]++;
        if (hisCodes[h] === BLOCK) hi++; else if (hisCodes[h] === BLOCK_LOW) lo++;
      }
    },
    pick(v) {
      const real = choose(v, true, true);
      if (opt.flip && known.length && v.hiddenCount === 1) {
        const h = v.shown.indexOf(-1);
        let on = false; for (const x of known) if (x.when(v.shown, h)) { on = true; break; }
        if (on) { const alt = choose(v, false, false); stat.applies++; if (alt[h] !== real[h]) stat.differs++; }
      }
      return real;
    },
    // Laying three cards: he answers after seeing the face-up ones. His answers are drawn from what he has done in this
    // bout in the same spot (shown head punch, shown body punch, shown guard, nothing shown, face down), then every
    // legal line and every choice of face-down card is played against the same draws.
    lead(v) {
      weigh(v);
      for (let ctx = 0; ctx < 5; ctx++) {
        let tot = 0;
        for (let c = 0; c < NCODES; c++) {
          const gone = c !== EMPTY && (v.total[cardOf(c)] === 0 || (opt.count && v.unseen[cardOf(c)] <= 0));
          tot += gone ? 0 : (opt.learn ? ans[ctx][c] : 0) + 3 * PRIOR[ctx][c]; cdf[c] = tot;
        }
        for (let k = 0; k < K * 3; k++) { const u = r() * tot; let c = 0; while (c < NCODES - 1 && cdf[c] < u) c++; samp[ctx][k] = c; }
      }
      const sets = HIDE_SETS[v.hideN], n = enumerate(v.hand, v.wind, v.tieOk, keys);
      let best = -1e9, bestKey = 0, bestSet = sets[0];
      for (let x = 0; x < n; x++) {
        decode(keys[x], line);
        const cost = COST[line[0]] + COST[line[1]] + COST[line[2]];
        for (const set of sets) {
          let ev = 0;
          for (let k = 0; k < K; k++) {
            let hc = 0;
            for (let i = 0; i < 3; i++) { his[i] = samp[set[i] ? 0 : ctxOf(line[i])][k * 3 + i]; hc += COST[his[i]]; }
            while (hc > v.oppWind) {                            // he cannot pay for all of it: the dearest card goes
              let d = 0; for (let i = 1; i < 3; i++) if (COST[his[i]] > COST[his[d]]) d = i;
              hc -= COST[his[d]]; his[d] = EMPTY;
            }
            resolve(line, his, v.PA, v.PB, R);
            ev += score(v, cost, hc);
          }
          ev = ev / K + r() * 0.02;
          if (ev > best) { best = ev; bestKey = keys[x]; bestSet = set; }
        }
      }
      return { codes: decode(bestKey, [0, 0, 0]), hidden: bestSet.slice() };
    },
    corner(v) {
      if (opt.corner === 'random') return ['water', 'ice', 'eyes'][Math.floor(r() * 3)];
      if (opt.corner !== 'informed') return opt.corner;
      if (v.me.head >= 0.5 * v.me.chin) return 'ice';
      if (v.wind + CFG.windStool < v.cap) return 'water';
      return 'eyes';
    } };
}
export const allSeeingBot = (seed) => readerBot({ seed, see: true });
