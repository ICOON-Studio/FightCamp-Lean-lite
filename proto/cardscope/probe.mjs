// CARDSCOPE greybox (round 2) - the measurements. node proto/cardscope/probe.mjs <fixed|ladder|info|cards|breaker|report|time> [scale]
// Population (named in every output): 4 player boxers x 4 opponent boxers from other clubs, one of each style, all
// different in cards and numbers; opponent class "regional" (tier 3) unless a block says otherwise.
import fs from 'node:fs';
import { NCODES, NAME, CARDS, PLAYERS, OPPONENTS, BASE_PLAYER, BLOCK, JAB, EMPTY, TIERS, deckLegal } from './cards.mjs';
import { playBout } from './bout.mjs';
import { rng } from './rules.mjs';
import { randomBot, fixedBot, greedyBot, readerBot, allSeeingBot } from './bots.mjs';
import { beginnerBot, tableBot } from './bots2.mjs';

const OUT = new URL('./out/', import.meta.url);
fs.mkdirSync(OUT, { recursive: true });
const save = (name, data) => fs.writeFileSync(new URL(name + '.json', OUT), JSON.stringify(data, null, 1));
const load = (name) => JSON.parse(fs.readFileSync(new URL(name + '.json', OUT), 'utf8'));
const pct = (a, b) => (b ? Math.round(1000 * a / b) / 10 : 0);
const scale = Number(process.argv[3] || 1);

// Play `per` bouts on each of the 16 pairs. mk(seed) makes the bot.
export function field(mk, per, opts = {}, seed0 = 1000) {
  const a = { n: 0, win: 0, stop: 0, stopR1: 0, kd: 0, ex: 0, noLand: 0, blank: 0, beats: 0, oneSided: 0, split: 0, pts: 0, late: 0,
    plays: new Array(NCODES).fill(0), corners: { water: 0, ice: 0, eyes: 0 }, pair: {}, oppTired: 0, dmgP: 0, dmgO: 0, leadsP: 0, trapsP: 0,
    hisHid: [0, 0, 0, 0], ansHid: [0, 0, 0, 0, 0], hisLeads: 0, habitLeads: 0, winsHitMore: 0, flipOn: 0, flipDiff: 0 };
  let s = seed0;
  for (const p of PLAYERS) for (const o of OPPONENTS) {
    let w = 0;
    for (let i = 0; i < per; i++) {
      s++;
      const bot = mk(s), st = playBout(p, o, bot, { ...opts, seed: s });
      a.oppTired += st.oppTired; a.dmgP += st.dmgP; a.dmgO += st.dmgO; a.leadsP += st.leadsP; a.trapsP += st.trapsP; a.hisLeads += st.hisLeads;
      a.habitLeads += st.habitLeads; if (st.win && st.headP > st.headO) a.winsHitMore++;
      for (let k = 0; k < 4; k++) a.hisHid[k] += st.hisHid[k]; for (let k = 0; k < 5; k++) a.ansHid[k] += st.ansHid[k];
      if (bot.stat) { a.flipOn += bot.stat.applies; a.flipDiff += bot.stat.differs; }
      a.n++; a.win += st.win; w += st.win;
      if (st.method === 'stop') { a.stop++; if (st.stopRound === 1) a.stopR1++; } else { a.pts++; a.split += st.split; }
      a.kd += st.kdP + st.kdO; a.ex += st.exchanges; a.noLand += st.noLand; a.blank += st.blankBeats; a.beats += st.beats;
      a.oneSided += st.oneSided; a.late += st.late;
      for (let c = 0; c < NCODES; c++) a.plays[c] += st.plays[c];
      for (const c of st.corners) a.corners[c]++;
    }
    a.pair[p.style + ' v ' + o.style] = pct(w, per);
  }
  a.winPct = pct(a.win, a.n);
  return a;
}

// The best fixed line: every pattern of three cards, screened, then the best re-measured on fresh seeds with each
// choice of face-down beat for its own leads.
function fixed() {
  const t0 = Date.now();
  const pats = [];
  for (let a = 0; a < NCODES; a++) for (let b = 0; b < NCODES; b++) for (let c = 0; c < NCODES; c++) pats.push([a, b, c]);
  let scored = pats.map((p) => ({ p, h: 2, w: field(() => fixedBot(p), 3, {}, 5000).winPct }));
  scored.sort((x, y) => y.w - x.w);
  scored = scored.slice(0, 40).map((x) => ({ p: x.p, h: 2, w: field(() => fixedBot(x.p), 30, {}, 9000).winPct }));
  scored.sort((x, y) => y.w - x.w);
  const six = [];
  for (const x of scored.slice(0, 6)) for (const h of [0, 1, 2]) six.push({ p: x.p, h, w: field(() => fixedBot(x.p, h), Math.round(100 * scale), {}, 20000).winPct });
  six.sort((x, y) => y.w - x.w);
  const best = six[0], per = Math.round(250 * scale);
  const res = { bestFixed: best.p.map((c) => NAME[c]), hideAt: best.h + 1, top6: six.slice(0, 6).map((x) => ({ line: x.p.map((c) => NAME[c]).join(' / ') + ' (hides beat ' + (x.h + 1) + ')', win: x.w })) };
  res.fixed = field(() => fixedBot(best.p, best.h), per, {}, 50000);
  res.fixedNoAdapt = field(() => fixedBot(best.p, best.h), per, { tierOver: { adapt: 0 } }, 50000);
  res.random = field((s) => randomBot(s), per);
  res.seconds = Math.round((Date.now() - t0) / 1000);
  save('fixed', res);
  console.log('fixed done', res.seconds, 's', res.bestFixed.join(' / '), res.fixed.winPct, 'random', res.random.winPct);
}

function ladder() {
  const t0 = Date.now(), per = Math.round(250 * scale);
  const res = { population: '4 player boxers x 4 opponents (16 pairs), regional class, ' + per + ' bouts a pair' };
  res.greedy = field((s) => greedyBot(s), per);
  res.reader = field((s) => readerBot({ seed: s }), per);
  res.allSeeing = field((s) => allSeeingBot(s), per);
  res.beginner = field(() => beginnerBot(), per);
  res.table = field(() => tableBot(), per);
  // the reader forced to one answer against every face-down card
  res.forced = {};
  for (const [nm, code] of [['block', BLOCK], ['jab', JAB], ['punch', -2], ['empty', EMPTY]]) res.forced[nm] = field((s) => readerBot({ seed: s, hiddenAnswer: code }), per).winPct;
  res.stubbornNoAdapt = field((s) => readerBot({ seed: s, hiddenAnswer: BLOCK }), per, { tierOver: { adapt: 0 } }).winPct;
  res.seconds = Math.round((Date.now() - t0) / 1000);
  save('ladder', res);
  console.log('ladder done', res.seconds, 's', res.greedy.winPct, res.reader.winPct, res.allSeeing.winPct, res.beginner.winPct, res.table.winPct);
}

function info() {
  const t0 = Date.now(), per = Math.round(125 * scale), res = { population: '16 pairs, ' + per + ' bouts a pair a cell' };
  res.shown = {};
  for (const shown of [0, 1, 2, 3]) {
    res.shown[shown] = {
      random: field((s) => randomBot(s), per, { shown }).winPct, greedy: field((s) => greedyBot(s), per, { shown }).winPct,
      reader: field((s) => readerBot({ seed: s }), per, { shown }).winPct, allSeeing: field((s) => allSeeingBot(s), per, { shown }).winPct };
  }
  res.tiers = {};
  for (const tier of [1, 2, 3, 4, 5]) {
    res.tiers[tier] = { name: TIERS[tier].name,
      greedy: field((s) => greedyBot(s), per, { tier }).winPct, reader: field((s) => readerBot({ seed: s }), per, { tier }).winPct,
      beginner: field(() => beginnerBot(), per * 2, { tier }).winPct, table: field(() => tableBot(), per, { tier }).winPct };
  }
  const big = per * 2;
  const f2 = field((s) => readerBot({ seed: s, film: 2, flip: true }), big);
  res.flip = { on: f2.flipOn, differs: f2.flipDiff, hisLeads: f2.hisLeads };
  res.read = { full: field((s) => readerBot({ seed: s }), big).winPct, film: f2.winPct, film1: field((s) => readerBot({ seed: s, film: 1 }), big).winPct,
    noCount: field((s) => readerBot({ seed: s, count: false }), big).winPct, noLearn: field((s) => readerBot({ seed: s, learn: false }), big).winPct };
  res.corner = {};
  for (const c of ['informed', 'random', 'water', 'ice', 'eyes']) {
    const f = field((s) => readerBot({ seed: s, corner: c }), big);
    res.corner[c] = { win: f.winPct, picks: f.corners };
  }
  res.seconds = Math.round((Date.now() - t0) / 1000);
  save('info', res);
  console.log('info done', res.seconds, 's');
}

// What adding two copies of one card to the neutral deck is worth against each opponent style, and the 8-bout run.
function cards() {
  const t0 = Date.now(), per = Math.round(1500 * scale);
  const res = { population: 'neutral 12-card deck + 2 copies of one card v each opponent boxer, reader, ' + per + ' bouts a cell', matrix: {}, base: {} };
  const one = (deck, o, n, seed0) => {
    let w = 0;
    for (let i = 0; i < n; i++) w += playBout(BASE_PLAYER, o, readerBot({ seed: seed0 + i }), { seed: seed0 + i, playerDeck: deck }).win;
    return pct(w, n);
  };
  for (const o of OPPONENTS) res.base[o.style] = one(BASE_PLAYER.deck, o, per, 700000);
  for (const card of CARDS) {
    res.matrix[NAME[card]] = {};
    for (const o of OPPONENTS) res.matrix[NAME[card]][o.style] = one(BASE_PLAYER.deck.concat([card, card]), o, per, 700000);
  }
  save('cards', res);
  // the run: 8 bouts, one card picked from three before each bout, the next opponent's style known
  const tiers = [1, 1, 2, 2, 3, 3, 4, 5], runs = Math.round(600 * scale);
  const val = (card, style) => res.matrix[NAME[card]][style];
  const bestOf = (offer, style) => { const vs = offer.map((c) => val(c, style)); return offer[vs.indexOf(Math.max(...vs))]; };
  const arms = { informed: { wins: 0, bouts: 0 }, random: { wins: 0, bouts: 0 }, noPick: { wins: 0, bouts: 0 } };
  let offers = 0, wide = 0, differs = 0;
  for (let run = 0; run < runs; run++) {
    const r = rng(run * 7919 + 3), plan = [];
    for (let b = 0; b < 8; b++) {
      const offer = [];
      while (offer.length < 3) { const c = CARDS[Math.floor(r() * CARDS.length)]; if (!offer.includes(c)) offer.push(c); }
      plan.push({ opp: OPPONENTS[Math.floor(r() * 4)], offer, pickR: Math.floor(r() * 3) });
    }
    for (const arm of ['informed', 'random', 'noPick']) {
      let deck = BASE_PLAYER.deck.slice(), losses = 0;
      for (let b = 0; b < 8 && losses < 3; b++) {
        const { opp, offer, pickR } = plan[b];
        if (arm === 'informed') {
          const vs = offer.map((c) => val(c, opp.style)), bestHere = bestOf(offer, opp.style);
          offers++; if (Math.max(...vs) - Math.min(...vs) >= 4) wide++;
          if (OPPONENTS.some((x) => x !== opp && bestOf(offer, x.style) !== bestHere)) differs++;
          if (deckLegal(deck.concat([bestHere]))) deck = deck.concat([bestHere]);
        } else if (arm === 'random' && deckLegal(deck.concat([offer[pickR]]))) deck = deck.concat([offer[pickR]]);
        const seed = 900000 + run * 8 + b;
        const st = playBout(BASE_PLAYER, opp, readerBot({ seed }), { seed, tier: tiers[b], playerDeck: deck, rounds: b === 7 ? 4 : 3 });
        arms[arm].wins += st.win; arms[arm].bouts++; if (!st.win) losses++;
      }
    }
  }
  const per1 = (f) => Object.fromEntries(Object.entries(arms).map(([k, v]) => [k, f(v)]));
  res.run = { runs, arms, winsPerRun: per1((v) => Math.round(100 * v.wins / runs) / 100), winPct: per1((v) => pct(v.wins, v.bouts)),
    wideOffersPerRun: Math.round(100 * wide / runs) / 100, offersPerRun: Math.round(100 * offers / runs) / 100,
    bestChangesWithOpponentPct: pct(differs, offers) };
  res.seconds = Math.round((Date.now() - t0) / 1000);
  save('cards', res);
  console.log('cards done', res.seconds, 's');
}

const cmd = process.argv[2];
if (cmd === 'ladder') ladder();
else if (cmd === 'fixed') fixed();
else if (cmd === 'breaker') { const { breaker } = await import('./probe2.mjs'); breaker(scale, save); }
else if (cmd === 'info') info();
else if (cmd === 'cards') cards();
else if (cmd === 'time') {
  for (const [nm, mk] of [['random', (s) => randomBot(s)], ['fixed', () => fixedBot([1, 3, 4])], ['greedy', (s) => greedyBot(s)], ['reader', (s) => readerBot({ seed: s })], ['table', () => tableBot()]]) {
    const t = Date.now(), f = field(mk, 5);
    console.log(nm, ((Date.now() - t) / f.n).toFixed(2), 'ms a bout');
  }
} else if (cmd === 'report') { const { report } = await import('./report.mjs'); report(load); }
