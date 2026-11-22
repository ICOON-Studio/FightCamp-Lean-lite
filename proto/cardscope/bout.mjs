// CARDSCOPE greybox (round 2) - one bout: rounds of four exchanges, the lead changes hands every exchange,
// three judges, the corner minute. You lead exchanges 1 and 3 of a round, he leads 2 and 4 (you answer at the bell).
import { EMPTY, TIE, NCODES, CFG, TIERS, LEVELS, KIND, IS_PUNCH, BLOCK, BLOCK_LOW, FEINT, cardOf, habitOn } from './cards.mjs';
import { rng, shuffle, resolve, newResult, lineCost, enumerate, keyOf } from './rules.mjs';
import { makeOpponent } from './opponent.mjs';

function makeSide(def, r, capAdd, powAdd, carryHead, backAdd = 0) {
  const chin = Math.round(def.chin * CFG.chinScale);
  return {
    def, deck: shuffle(def.deck.slice(), r), hand: [], disc: [],
    baseCap: def.cap + capAdd, cap: def.cap + capAdd, wind: def.cap + capAdd,
    chin, hurtAt: Math.round(chin * CFG.hurtAt / CFG.chin), head: carryHead || 0, body: 0, kds: 0, tieUsed: false,
    P: { pow: def.pow + powAdd, quick: def.quick, kd: CFG.kdLine }, back: CFG.windBack + backAdd, backRound: 0,
    faceUp: false, total: null, backNow: CFG.windBack + backAdd,
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
// A level judge: more damage done, then whoever won the last exchange, then a coin from the seed. Never his by default.
export const levelGoesTo = (dmgYou, dmgHim, lastExWinner, coin) => verdict(dmgYou, dmgHim) || lastExWinner || coin();
// How the player's answer to a face-down card is classed: 0 punch, 1 block, 2 evade or tie up, 3 nothing, 4 feint.
const ansClass = (c) => (IS_PUNCH[c] ? 0 : (c === BLOCK || c === BLOCK_LOW) ? 1 : c === EMPTY ? 3 : c === FEINT ? 4 : 2);

// opts: tier (1-5), seed, rounds, shown (0-3: overrides how many cards a leader shows, both corners), tierOver {..},
// playerDeck (replaces the boxer's deck), carryHead, check (assert every line is legal), transcript (array).
export function playBout(playerDef, oppDef, bot, opts = {}) {
  const seed = opts.seed >>> 0, r = rng(seed * 2654435761 + 97), coin = rng(seed * 31 + 7);
  const tierNo = opts.tier || 3, tier = { ...TIERS[tierNo], ...(opts.tierOver || {}) };
  const rounds = opts.rounds || CFG.rounds;
  const pDef = opts.playerDeck ? { ...playerDef, deck: opts.playerDeck } : playerDef;
  const p = makeSide(pDef, r, 0, 0, opts.carryHead);
  const lvl = LEVELS[Math.max(0, Math.min(LEVELS.length - 1, tier.lvl))];
  const o = makeSide(oppDef, r, lvl[0], lvl[2], 0, lvl[1]);
  const opp = makeOpponent(oppDef, tierNo, rng(seed * 40503 + 11), opts.tierOver);
  p.total = new Int32Array(NCODES); for (const c of pDef.deck) p.total[c]++;
  o.total = new Int32Array(NCODES); for (const c of oppDef.deck) o.total[c]++;
  const R = newResult(), keys = new Int32Array(4096);
  const cards = [[0, 0], [0, 0], [0, 0]], taste = [[0, 0], [0, 0], [0, 0]];
  const st = { win: 0, method: 'pts', stopRound: 0, kdP: 0, kdO: 0, exchanges: 0, noLand: 0, blankBeats: 0, beats: 0,
    plays: new Int32Array(NCODES), judgesFor: 0, lead2: 0, roundsFor: 0, oneSided: 0, split: 0, corners: [], oppCorners: [],
    headP: 0, headO: 0, cards, oppTired: 0, dmgP: 0, dmgO: 0, leadsP: 0, trapsP: 0, hisHid: [0, 0, 0, 0],
    ansHid: [0, 0, 0, 0, 0], hisLeads: 0, habitLeads: 0, coins: [0, 0] };
  const view = { hand: p.hand, wind: 0, cap: 0, tieOk: true, shown: [0, 0, 0], hiddenCount: 0, oppWind: 0, unseen: new Int32Array(NCODES),
    total: o.total, diff: [0, 0, 0], rem: 0, round: 0, lastRound: false, cards, kdNet: 0, me: p, him: o, PA: p.P, PB: o.P,
    truth: null, tier: tierNo, exInRound: 0, leading: false, hideN: 0 };
  const mineUnseen = new Int32Array(NCODES), shownToHim = [0, 0, 0];
  bot.start && bot.start({ playerDef: pDef, oppDef, tier: tierNo, seed });
  let eyesOnHim = false, eyesOnYou = false, stopped = 0, lastExWinner = 0;
  const flip = () => { const w = coin() < 0.5 ? 1 : -1; st.coins[w > 0 ? 0 : 1]++; return w; };

  for (let rd = 0; rd < rounds && !stopped; rd++) {
    for (const s of [p, o]) { s.disc.push(...s.hand); s.hand.length = 0; draw(s, r); s.tieUsed = false; }
    const tally = [[0, 0], [0, 0], [0, 0]], dmg = [0, 0];
    let kdNet = 0, hisLeadNo = 0;
    for (let ex = 0; ex < CFG.exchanges && !stopped; ex++) {
      const youLead = ex % 2 === 0, leader = youLead ? p : o;
      p.P.kd = p.head >= p.hurtAt ? CFG.kdLineHurt : CFG.kdLine;
      o.P.kd = o.head >= o.hurtAt ? CFG.kdLineHurt : CFG.kdLine;
      if (o.wind <= CFG.tiredAt) st.oppTired++;
      // how many cards the leader lays face down: a tired or floored boxer, or one being watched, hides nothing
      let hideN = youLead ? 1 : (hisLeadNo === 0 ? tier.hideFirst : tier.hide);
      if (opts.shown != null) hideN = 3 - opts.shown;
      else if (leader.wind <= CFG.tiredAt || leader.faceUp || (youLead ? eyesOnYou : eyesOnHim)) hideN = 0;
      leader.faceUp = false;
      // what the player's corner can see
      view.wind = p.wind; view.cap = p.cap; view.tieOk = !p.tieUsed; view.oppWind = o.wind; view.leading = youLead; view.hideN = hideN;
      view.hiddenCount = youLead ? 0 : hideN; view.round = rd; view.lastRound = rd === rounds - 1; view.rem = CFG.exchanges - 1 - ex;
      view.kdNet = kdNet; view.exInRound = ex; view.truth = null;
      for (let c = 0; c < NCODES; c++) view.unseen[c] = o.total[c];
      for (const c of o.disc) view.unseen[c]--;
      for (let i = 0; i < 3; i++) view.diff[i] = tally[i][0] - tally[i][1];
      let pc, oc, hidden;
      if (youLead) {
        const pl = bot.lead(view);
        pc = pl.codes; hidden = pl.hidden;
        for (let c = 0; c < NCODES; c++) mineUnseen[c] = p.total[c];
        for (const c of p.disc) mineUnseen[c]--;
        for (let i = 0; i < 3; i++) {
          shownToHim[i] = hidden[i] ? -1 : pc[i];
          if (!hidden[i] && pc[i] !== EMPTY) mineUnseen[cardOf(pc[i])]--;
        }
        oc = opp.answer(o, p, shownToHim, mineUnseen);
        st.leadsP++;
        for (let i = 0; i < 3; i++) if (hidden[i] && !IS_PUNCH[pc[i]]) { st.trapsP++; break; }
      } else {
        const ol = opp.line(o, hideN, ex === CFG.exchanges - 1);
        oc = ol.codes; hidden = ol.hidden; hisLeadNo++;
        view.truth = oc;
        for (let i = 0; i < 3; i++) {
          view.shown[i] = hidden[i] ? -1 : oc[i];
          if (!hidden[i] && oc[i] !== EMPTY) view.unseen[cardOf(oc[i])]--;
        }
        pc = bot.pick(view);
        if (hideN === 1) {
          const h = hidden.indexOf(1), hb = habitOn(oppDef.habits || [], oc, h);
          st.hisLeads++; st.hisHid[KIND[oc[h]]]++; st.ansHid[ansClass(pc[h])]++;
          if (hb && cardOf(oc[h]) === hb.card) st.habitLeads++;
        }
      }
      if (opts.check) {
        const n = enumerate(p.hand, p.wind, !p.tieUsed, keys), k = keyOf(pc);
        let ok = false; for (let i = 0; i < n; i++) if (keys[i] === k) { ok = true; break; }
        if (!ok) throw new Error('illegal line ' + pc.join(',') + ' from hand ' + p.hand.join(',') + ' wind ' + p.wind);
        if (lineCost(oc) > o.wind) throw new Error('opponent overspent');
        if (hidden[0] + hidden[1] + hidden[2] !== hideN) throw new Error('wrong number of face-down cards');
      }
      if (opts.transcript) R.log = [];
      resolve(pc, oc, p.P, o.P, R);
      if (opts.transcript) opts.transcript.push({ round: rd + 1, exchange: ex + 1, youLead, you: pc.slice(), him: oc.slice(), hidden: hidden.slice(), beats: R.log });
      p.wind = Math.max(0, p.wind - lineCost(pc) + R.wA); o.wind = Math.max(0, o.wind - lineCost(oc) + R.wB);
      spend(p, pc); spend(o, oc);
      for (let i = 0; i < 3; i++) st.plays[pc[i]]++;
      p.head += R.hA; o.head += R.hB; p.body += R.bA; o.body += R.bB;
      st.dmgP += R.hB + R.bB; st.dmgO += R.hA + R.bA;
      // every judge counts clean punches; one also likes work, one hurt, one craft
      const cA = CFG.judgeClean * R.clA + CFG.judgeGuard * R.crA, cB = CFG.judgeClean * R.clB + CFG.judgeGuard * R.crB;
      tally[0][0] += cA + CFG.judgeThrown * R.thA; tally[0][1] += cB + CFG.judgeThrown * R.thB;
      tally[1][0] += cA + CFG.judgeDamage * (R.hB + R.bB); tally[1][1] += cB + CFG.judgeDamage * (R.hA + R.bA);
      tally[2][0] += cA + CFG.judgeCraft * R.crA; tally[2][1] += cB + CFG.judgeCraft * R.crB;
      dmg[0] += R.hB + R.bB; dmg[1] += R.hA + R.bA;
      const dd = (R.hB + R.bB) - (R.hA + R.bA); if (dd !== 0) lastExWinner = dd > 0 ? 1 : -1;
      st.exchanges++; st.beats += R.beats; st.blankBeats += R.blank; if (R.clA + R.clB === 0) st.noLand++;
      if (R.kdA) { p.kds++; st.kdO++; kdNet--; p.faceUp = true; }
      if (R.kdB) { o.kds++; st.kdP++; kdNet++; o.faceUp = true; }
      opp.observe(pc, oc, hidden, youLead);
      bot.observe && bot.observe(view, oc, pc, R, youLead, hidden);
      const pOut = p.head >= p.chin || p.kds >= CFG.kdStop, oOut = o.head >= o.chin || o.kds >= CFG.kdStop;
      if (pOut || oOut) {
        stopped = 1; st.method = 'stop'; st.stopRound = rd + 1;
        st.win = oOut && !pOut ? 1 : 0;
        break;
      }
      // wind comes back; a body hook that landed and a knockdown are taken out of what comes back
      // body work is paid late: every 8 body damage taken is 1 wind less back each exchange
      for (const s of [p, o]) s.backNow = Math.max(CFG.minBack, s.back - Math.floor(s.body / CFG.bodyPerBack)) + s.backRound;
      p.wind = Math.max(0, Math.min(p.cap, p.wind + p.backNow) - R.drA - (R.kdA ? CFG.kdWind : 0));
      o.wind = Math.max(0, Math.min(o.cap, o.wind + o.backNow) - R.drB - (R.kdB ? CFG.kdWind : 0));
      draw(p, r); draw(o, r);
    }
    if (stopped) break;
    // the three judges score the round, each on his own count. Level: damage, then the last exchange, then a coin.
    for (let j = 0; j < 3; j++) {
      taste[j][0] += tally[j][0]; taste[j][1] += tally[j][1];
      let w = kdNet !== 0 ? Math.sign(kdNet) : verdict(tally[j][0], tally[j][1]);
      if (!w) w = levelGoesTo(dmg[0], dmg[1], lastExWinner, flip);
      const loser = kdNet !== 0 ? 8 : 9;
      cards[j][0] += w > 0 ? 10 : loser; cards[j][1] += w > 0 ? loser : 10;
      if (w > 0) st.roundsFor++;
    }
    if (rd === 1) { let a = 0, b = 0; for (let j = 0; j < 3; j++) { const v = verdict(cards[j][0], cards[j][1]); if (v > 0) a++; else if (v < 0) b++; } st.lead2 = verdict(a, b); }
    if (rd < rounds - 1) {
      view.wind = p.wind; view.cap = p.cap;
      const pick = bot.corner ? bot.corner(view) : 'water', his = opp.corner(o);
      st.corners.push(pick); st.oppCorners.push(his);
      for (const [s, c] of [[p, pick], [o, his]]) {
        s.wind = c === 'water' ? s.cap : Math.min(s.cap, s.wind + CFG.windStool);
        s.backRound = c === 'water' ? CFG.waterBack : 0;
        if (c === 'ice') s.head = Math.max(0, s.head - CFG.ice);
      }
      eyesOnHim = pick === 'eyes'; eyesOnYou = his === 'eyes';
    }
  }
  st.headP = p.head; st.headO = o.head;
  if (!stopped) {
    for (let j = 0; j < 3; j++) {
      const v = verdict(cards[j][0], cards[j][1]) || verdict(taste[j][0], taste[j][1]) || levelGoesTo(0, 0, lastExWinner, flip);
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
