// CARDSCOPE1 greybox - one bout: rounds of four exchanges, three judges, the corner minute.
import { EMPTY, TIE, NCODES, CFG, TIERS, LEVELS, cardOf } from './cards.mjs';
import { rng, shuffle, resolve, newResult, lineCost, enumerate, keyOf } from './rules.mjs';
import { makeOpponent } from './opponent.mjs';

function makeSide(def, r, chinAdd, capAdd, powAdd, carryHead, backAdd = 0) {
  const chin = def.chin + chinAdd;
  return {
    def, deck: shuffle(def.deck.slice(), r), hand: [], disc: [],
    baseCap: def.cap + capAdd, cap: def.cap + capAdd, wind: def.cap + capAdd,
    chin, hurtAt: Math.round(chin * CFG.hurtAt / CFG.chin), head: carryHead || 0, body: 0, kds: 0, tieUsed: false,
    P: { pow: def.pow + powAdd, quick: def.quick, kd: CFG.kdLine }, back: CFG.windBack + backAdd, backRound: 0,
  };
}
function draw(s, r) {
  while (s.hand.length < CFG.hand) {
    if (!s.deck.length) { if (!s.disc.length) break; s.deck = shuffle(s.disc, r); s.disc = []; }
    s.hand.push(s.deck.pop());
  }
}
function spend(s, codes) {
  for (let i = 0; i < 3; i++) {
    const c = codes[i];
    if (c === EMPTY) continue;
    const card = cardOf(c), at = s.hand.indexOf(card);
    if (at < 0) throw new Error('card not in hand: ' + card);
    s.hand.splice(at, 1); s.disc.push(card);
    if (card === TIE) s.tieUsed = true;
  }
}
const verdict = (a, b) => (a > b ? 1 : a < b ? -1 : 0);

// opts: tier (1-5), seed, rounds, shown (0-3: overrides how many cards he shows), tierOver {adapt,..},
// playerDeck (replaces the boxer's deck), carryHead, check (assert every answer is legal), transcript (array).
export function playBout(playerDef, oppDef, bot, opts = {}) {
  const seed = opts.seed >>> 0, r = rng(seed * 2654435761 + 97);
  const tierNo = opts.tier || 3, tier = { ...TIERS[tierNo], ...(opts.tierOver || {}) };
  const rounds = opts.rounds || CFG.rounds;
  const pDef = opts.playerDeck ? { ...playerDef, deck: opts.playerDeck } : playerDef;
  const p = makeSide(pDef, r, 0, 0, 0, opts.carryHead);
  const lvl = LEVELS[Math.max(0, Math.min(LEVELS.length - 1, (opts.oppLvl != null ? opts.oppLvl : oppDef.lvl) + tier.lvl))];
  const o = makeSide(oppDef, r, 0, lvl[0], lvl[1], 0, lvl[0]);
  const opp = makeOpponent(oppDef, tierNo, rng(seed * 40503 + 11), opts.tierOver);
  const total = new Int32Array(NCODES); for (const c of oppDef.deck) total[c]++;
  const R = newResult(), keys = new Int32Array(4096);
  const cards = [[0, 0], [0, 0], [0, 0]], taste = [[0, 0], [0, 0], [0, 0]];
  const st = { win: 0, method: 'pts', stopRound: 0, kdP: 0, kdO: 0, exchanges: 0, noLand: 0, blankBeats: 0, beats: 0,
    plays: new Int32Array(NCODES), judgesFor: 0, lead2: 0, roundsFor: 0, oneSided: 0, split: 0, corners: [],
    headP: 0, headO: 0, cards };
  const view = { hand: p.hand, wind: 0, cap: 0, tieOk: true, shown: [0, 0, 0], hiddenCount: 0, oppWind: 0, unseen: new Int32Array(NCODES),
    total, diff: [0, 0, 0], rem: 0, round: 0, lastRound: false, cards, kdNet: 0, me: p, him: o, PA: p.P, PB: o.P,
    truth: null, tier: tierNo, exInRound: 0 };
  bot.start && bot.start({ playerDef: pDef, oppDef, tier: tierNo, seed });
  let eyes = 0, faceUpNext = false, stopped = 0, lastExWinner = 0;

  for (let rd = 0; rd < rounds && !stopped; rd++) {
    for (const s of [p, o]) { s.disc.push(...s.hand); s.hand.length = 0; draw(s, r); s.tieUsed = false; }
    const tally = [[0, 0], [0, 0], [0, 0]], dmg = [0, 0];
    let kdNet = 0;
    for (let ex = 0; ex < CFG.exchanges && !stopped; ex++) {
      p.P.kd = p.head >= p.hurtAt ? CFG.kdLineHurt : CFG.kdLine;
      o.P.kd = o.head >= o.hurtAt ? CFG.kdLineHurt : CFG.kdLine;
      let hideN = opts.shown != null ? 3 - opts.shown : (ex < 2 ? tier.hideEarly : tier.hide);
      if (opts.shown == null && (o.wind <= 1 || faceUpNext || eyes > 0)) hideN = 0;
      faceUpNext = false; if (eyes > 0) eyes--;
      const ol = opp.line(o, hideN, ex === CFG.exchanges - 1);
      // what the player's corner can see
      view.wind = p.wind; view.cap = p.cap; view.tieOk = !p.tieUsed; view.oppWind = o.wind;
      view.hiddenCount = hideN; view.round = rd; view.lastRound = rd === rounds - 1; view.rem = CFG.exchanges - 1 - ex;
      view.kdNet = kdNet; view.truth = ol.codes; view.exInRound = ex;
      for (let c = 0; c < NCODES; c++) view.unseen[c] = total[c];
      for (const c of o.disc) view.unseen[c]--;
      for (let i = 0; i < 3; i++) {
        view.shown[i] = ol.hidden[i] ? -1 : ol.codes[i];
        if (!ol.hidden[i] && ol.codes[i] !== EMPTY) view.unseen[cardOf(ol.codes[i])]--;
        view.diff[i] = tally[i][0] - tally[i][1];
      }
      const pc = bot.pick(view);
      if (opts.check) {
        const n = enumerate(p.hand, p.wind, !p.tieUsed, keys), k = keyOf(pc);
        let ok = false; for (let i = 0; i < n; i++) if (keys[i] === k) { ok = true; break; }
        if (!ok) throw new Error('illegal answer ' + pc.join(',') + ' from hand ' + p.hand.join(',') + ' wind ' + p.wind);
        if (lineCost(ol.codes) > o.wind) throw new Error('opponent overspent');
      }
      if (opts.transcript) R.log = [];
      resolve(pc, ol.codes, p.P, o.P, R);
      if (opts.transcript) opts.transcript.push({ round: rd + 1, exchange: ex + 1, you: pc.slice(), him: ol.codes.slice(), hidden: ol.hidden.slice(), beats: R.log });
      p.wind = Math.max(0, p.wind - lineCost(pc) + R.wA); o.wind = Math.max(0, o.wind - lineCost(ol.codes) + R.wB);
      spend(p, pc); spend(o, ol.codes);
      for (let i = 0; i < 3; i++) st.plays[pc[i]]++;
      p.head += R.hA; o.head += R.hB; p.body += R.bA; o.body += R.bB;
      for (const s of [p, o]) s.cap = Math.max(CFG.minCap, s.baseCap - Math.floor(s.body / CFG.bodyPerCap));
      // every judge counts clean punches; one also likes work, one hurt, one craft
      const cA = CFG.judgeClean * R.clA, cB = CFG.judgeClean * R.clB;
      tally[0][0] += cA + CFG.judgeThrown * R.thA; tally[0][1] += cB + CFG.judgeThrown * R.thB;
      tally[1][0] += cA + CFG.judgeDamage * (R.hB + R.bB); tally[1][1] += cB + CFG.judgeDamage * (R.hA + R.bA);
      tally[2][0] += cA + CFG.judgeCraft * R.crA; tally[2][1] += cB + CFG.judgeCraft * R.crB;
      dmg[0] += R.hB + R.bB; dmg[1] += R.hA + R.bA;
      const dd = (R.hB + R.bB) - (R.hA + R.bA); if (dd !== 0) lastExWinner = dd > 0 ? 1 : -1;
      st.exchanges++; st.beats += R.beats; st.blankBeats += R.blank; if (R.clA + R.clB === 0) st.noLand++;
      if (R.kdA) { p.kds++; st.kdO++; kdNet--; p.wind = Math.max(0, p.wind - CFG.kdWind); }
      if (R.kdB) { o.kds++; st.kdP++; kdNet++; o.wind = Math.max(0, o.wind - CFG.kdWind); faceUpNext = true; }
      opp.observe(pc, ol.codes, ol.hidden);
      bot.observe && bot.observe(view, ol.codes, pc, R);
      const pOut = p.head >= p.chin || p.kds >= CFG.kdStop, oOut = o.head >= o.chin || o.kds >= CFG.kdStop;
      if (pOut || oOut) {
        stopped = 1; st.method = 'stop'; st.stopRound = rd + 1;
        st.win = oOut && !pOut ? 1 : 0;
        break;
      }
      for (const s of [p, o]) { s.wind = Math.min(s.cap, s.wind + s.back + s.backRound); draw(s, r); }
    }
    if (stopped) break;
    // the three judges score the round, each on his own count
    for (let j = 0; j < 3; j++) {
      taste[j][0] += tally[j][0]; taste[j][1] += tally[j][1];
      let w = kdNet !== 0 ? Math.sign(kdNet) : verdict(tally[j][0], tally[j][1]);
      if (!w) w = verdict(dmg[0], dmg[1]) || lastExWinner || -1;
      const loser = kdNet !== 0 ? 8 : 9;
      cards[j][0] += w > 0 ? 10 : loser; cards[j][1] += w > 0 ? loser : 10;
      if (w > 0) st.roundsFor++;
    }
    if (rd === 1) { let a = 0, b = 0; for (let j = 0; j < 3; j++) { const v = verdict(cards[j][0], cards[j][1]); if (v > 0) a++; else if (v < 0) b++; } st.lead2 = verdict(a, b); }
    if (rd < rounds - 1) {
      view.wind = p.wind; view.cap = p.cap;
      const pick = bot.corner ? bot.corner(view) : 'water';
      st.corners.push(pick);
      for (const [s, c] of [[p, pick], [o, opp.corner(o)]]) {
        s.wind = c === 'water' ? s.cap : Math.min(s.cap, s.wind + CFG.windStool);
        s.backRound = c === 'water' ? CFG.waterBack : 0;
        if (c === 'ice') s.head = Math.max(0, s.head - CFG.ice);
      }
      if (pick === 'eyes') eyes = CFG.eyesExchanges;
    }
  }
  st.headP = p.head; st.headO = o.head;
  if (!stopped) {
    for (let j = 0; j < 3; j++) {
      const v = verdict(cards[j][0], cards[j][1]) || verdict(taste[j][0], taste[j][1]) || lastExWinner || -1;
      if (v > 0) st.judgesFor++;
    }
    st.win = st.judgesFor >= 2 ? 1 : 0;
    st.split = st.judgesFor === 1 || st.judgesFor === 2 ? 1 : 0;
    st.oneSided = st.roundsFor === 0 || st.roundsFor === rounds * 3 ? 1 : 0;
  } else st.oneSided = st.stopRound < rounds ? 1 : 0;
  // "turned late": the winner was level or behind on the cards after round 2
  st.late = st.stopRound && st.stopRound < 3 ? 0 : ((st.win ? st.lead2 <= 0 : st.lead2 >= 0) ? 1 : 0);
  bot.end && bot.end(st);
  return st;
}
