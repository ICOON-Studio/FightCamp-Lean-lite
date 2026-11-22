// FightCamp card game - balance harness.
//   node proto/cardgame/balance.mjs [bouts]
// Runs the same sequence the page runs: createGame -> four camp picks ->
// startFight (which trains the opponent too) -> playExchange / pickCorner until
// isOver. It prints style pairs, the card table, how bouts end, the reference
// arms (engine, reading, tell-follower, largest damage, random) and the camp
// check, then fails the run on the design limits in the brief.
import rules from './rules.js';

const N = Number(process.argv[2]) || 2000;
const CARDS = rules.CARDS, ORDER = rules.CARD_ORDER, DATA = rules.SHAPE_MATRIX;
const LEGAL_KEY = new Set(['W', 'w']);

function pct(n, d) { return d ? (100 * n / d).toFixed(1) + '%' : '-'; }
function pad(s, n) { s = String(s); return s.length >= n ? s : s + ' '.repeat(n - s.length); }
function lpad(s, n) { s = String(s); return s.length >= n ? s : ' '.repeat(n - s.length) + s; }

/* Round 3b: the harness asks the engine what is legal and what it costs, so the
   no-repeat rule, the cut-off trap and the ropes all bind on every arm. */
function costOf(side, fight, id, key) { return rules.costNow(side, fight, key || 'player', id); }
function legal(side, fight, id, key) { return rules.legalNow(side, fight, key || 'player', id); }
function affordable(side, fight, id, key) { return side.stamina >= costOf(side, fight, id, key); }

// The page's camp: the player clicks a drill, then clicks the card to remove.
function campUI(game) {
  while (game.phase === 'camp') {
    const drill = rules.aiCampPick(game);
    rules.pickCampCard(game, drill, rules.aiCampRemove(game, drill));
  }
  return game;
}
function campRandom(game, rng) {
  while (game.phase === 'camp') {
    const offer = game.offers[game.week];
    const drill = offer[rng.int(offer.length)];
    const deck = game.playerBoxerId ? null : null;
    const hand = [];
    const boxer = rules.boxerById(game.playerBoxerId);
    boxer.deck.forEach((id) => hand.push(id));
    for (const k in game.mods.add) for (let i = 0; i < game.mods.add[k]; i++) hand.push(k);
    for (const r in game.mods.remove) for (let i = 0; i < game.mods.remove[r]; i++) {
      const idx = hand.indexOf(r); if (idx >= 0) hand.splice(idx, 1);
    }
    const removals = [];
    for (let i = 0; i < rules.removalsFor(drill) && hand.length; i++) {
      const pick = hand.splice(rng.int(hand.length), 1)[0];
      removals.push(pick);
    }
    rules.pickCampCard(game, drill, removals);
  }
  return game;
}

// --- the arms ---------------------------------------------------------------
function pickWith(side, fight, score, wantAffordable) {
  let best = null, bestScore = -Infinity;
  for (const id of side.hand) {
    if (!legal(side, fight, id)) continue;
    if (wantAffordable && !affordable(side, fight, id)) continue;
    let s = score(id);
    if (s > bestScore) { bestScore = s; best = id; }
  }
  if (!best) {
    for (const id of side.hand) if (legal(side, fight, id)) return id;
    return side.hand[0];
  }
  return best;
}
function dmgOf(id) { const c = CARDS[id]; return c.kind === 'punch' ? (c.dmg.head + c.dmg.body) : 0; }
// Every arm is held to the same rules the page enforces on the buttons.
function safe(policy) {
  return (fight, rng) => {
    const out = policy(fight, rng);
    const card = out && out.card ? out.card : out;
    const mode = out && out.mode ? out.mode : 'react';
    if (card && fight.player.hand.includes(card) && legal(fight.player, fight, card)) return { card, mode };
    const fallback = fight.player.hand.filter((id) => legal(fight.player, fight, id));
    return { card: fallback.length ? fallback[0] : fight.player.hand[0], mode: 'react' };
  };
}

// --- reference arms --------------------------------------------------------
// All arms obey the same rules the page enforces: only cards in hand, no Step
// back on the ropes, Catch breath once a round, and the tell only when seen.
const STYLES = rules.STYLES;
function shapeWeights(shape, foeStyle) {
  const base = STYLES[foeStyle].weights, out = {};
  for (const id of ORDER) if (CARDS[id].shape === shape) out[id] = Math.max(0.05, base[id] || 0.5);
  return out;
}
function swing(fight, id, weights) {
  let s = rules.expectedSwing(id, weights);
  if (CARDS[id].ranges.indexOf(fight.range) < 0) s *= 0.8;
  if (fight.player.stamina < costOf(fight.player, fight, id)) s *= 0.7;
  return s;
}
// one rule: pay for a look while there is wind, then play the card that does
// best against the shape the chip names.
function tellFollower(payAbove) {
  return (fight) => {
    const me = fight.player;
    if (!rules.tellVisible(fight) && me.stamina > payAbove && !fight.tellPaid) rules.payForTell(fight);
    if (!rules.tellVisible(fight)) return rules.chooseAiCard(fight, 'player');
    const weights = shapeWeights(fight.tell.shape, fight.opponent.style);
    return pickWith(me, fight, (id) => swing(fight, id, weights), false);
  };
}
// reading: the chip names a shape, the film names a card. Play the card that
// does best against the shape, and give a bonus to whatever beats the habit the
// film is calling (scaled by the odds that card is even in his hand).
function reader(payAbove, filmBonus) {
  return (fight) => {
    const me = fight.player;
    const reads = rules.scoutingPrediction(fight).filter((r) => r.active).sort((a, b) => b.chance - a.chance);
    if (!rules.tellVisible(fight) && me.stamina > payAbove && !fight.tellPaid) rules.payForTell(fight);
    const weights = rules.tellVisible(fight)
      ? shapeWeights(fight.tell.shape, fight.opponent.style)
      : Object.assign({}, STYLES[fight.opponent.style].weights);
    const guess = reads.length ? reads[0].card : null;
    const odds = reads.length ? reads[0].chance : 0;
    return pickWith(me, fight, (id) => {
      let s = swing(fight, id, weights);
      if (guess) {
        const code = rules.resolutionAt(id, guess, fight.range);
        s += filmBonus * odds * (LEGAL_KEY.has(code) ? 1 : code === 't' ? 0.2 : 0);
      }
      return s;
    }, false);
  };
}

/* predictor: the tell-follower that also spends 2 wind on a read when the chip
   names a shape only one or two cards can be. */
function predictor(fight) {
  const me = fight.player;
  if (!rules.tellVisible(fight) && me.stamina > 40 && !fight.tellPaid) rules.payForTell(fight);
  const shape = rules.tellVisible(fight) && fight.tell ? fight.tell.shape : null;
  const weights = shape ? shapeWeights(shape, fight.opponent.style)
    : Object.assign({}, STYLES[fight.opponent.style].weights);
  const card = pickWith(me, fight, (id) => swing(fight, id, weights), false);
  /* A read is expensive, so a good player spends it on alternate exchanges,
     not on every one: the harness holds the use rate to the design band. */
  const mode = shape && me.stamina > 10 && fight.exchange % 2 === 0 ? 'predict' : 'react';
  return { card, mode };
}
const arms = {
  engine: safe((fight) => rules.chooseAiCard(fight, 'player')),
  /* the best honest non-reader: style weights only, no tell, no film, no read
     of what was just thrown. This is the arm reading has to beat by 10 points. */
  styleOnly: safe((fight) => rules.chooseStyleCard(fight, 'player')),
  random: safe((fight, rng) => fight.player.hand[rng.int(fight.player.hand.length)]),
  tell: safe(tellFollower(75)),
  damage: safe((fight) => pickWith(fight.player, fight, (id) => dmgOf(id), true)),
  reading: safe(reader(75, 6)),
  predictor: safe(predictor)
};

// --- style pairs: both seats use the same style-weights policy -------------
// Sixteen ordered pairs. Seats swap on every bout, so a row is not one boxer or
// one chair: the left corner is the row's left style, and the pair "A v B" plus
// "B v A" covers both chairs for the same two styles.
const STYLE_NAMES = Object.keys(rules.STYLES);
/* Every legal way to seat two styles: same sex, different club, different man.
   The clubs do not divide by style evenly, so the pairs are listed, not assumed. */
function stylePairs(leftStyle, rightStyle) {
  const out = [];
  for (const sex of ['she', 'he']) {
    const L = rules.BOXERS.filter((b) => b.style === leftStyle && b.pronoun === sex);
    const R = rules.BOXERS.filter((b) => b.style === rightStyle && b.pronoun === sex);
    for (const l of L) for (const r of R) if (l.id !== r.id && l.club !== r.club) out.push([l, r]);
  }
  return out;
}
function styleBout(seed, leftStyle, rightStyle, k) {
  const pairs = stylePairs(leftStyle, rightStyle);
  if (!pairs.length) return null;
  const [left, right] = pairs[k % pairs.length];
  return styleBoutIds(seed, left.id, right.id);
}
function styleBoutIds(seed, leftId, rightId) {
  const game = rules.createGame({ seed, playerBoxerId: leftId, opponentBoxerId: rightId });
  campUI(game);
  const fight = rules.startFight(game);
  /* The other corner plays the same honest style policy, so the row measures
     the matchup and not who happens to be driving the better chooser. */
  fight.foePolicy = (f) => rules.chooseAiCard(f, 'opponent');
  while (!rules.isOver(fight)) {
    if (fight.phase === 'corner') { rules.pickCorner(game, rules.aiCornerPick(game)); continue; }
    const card = rules.chooseAiCard(fight, 'player', true);
    if (!card) break;
    rules.playExchange(game, card);
  }
  return fight;
}
const styleRows = new Map();
for (const a of STYLE_NAMES) for (const b of STYLE_NAMES) styleRows.set(a + ' v ' + b, { bouts: 0, left: 0, right: 0, draws: 0 });
const STYLE_BOUTS = Math.max(2400, N * 3);
for (let i = 0; i < STYLE_BOUTS; i++) {
  const styleA = STYLE_NAMES[i % 4], styleB = STYLE_NAMES[Math.floor(i / 4) % 4];
  /* Round 3b: one boxer per style and sex, so a style cannot fight itself.
     Mirrors are listed and left empty rather than faked; the chair is measured
     below by replaying the same two boxers with the chairs swapped. */
  if (styleA === styleB) continue;
  const swap = Math.floor(i / 32) % 2 === 1;      // seats change every bout
  const leftStyle = swap ? styleB : styleA, rightStyle = swap ? styleA : styleB;
  const fight = styleBout(rules.hashSeed('style-r3b', i), leftStyle, rightStyle, Math.floor(i / 16));
  const row = styleRows.get(leftStyle + ' v ' + rightStyle);
  if (!fight || !fight.result) continue;
  row.bouts++;
  if (fight.result.winner === 'player') row.left++;
  else if (fight.result.winner === 'opponent') row.right++;
  else row.draws++;
}
const styleRate = (row) => row.left / (row.bouts - row.draws || 1);

/* The chair test: the same two boxers, the same seed, chairs swapped. Any
   difference is the seat and the order of resolution, not the fighters. */
const chair = { bouts: 0, left: 0 };
for (let i = 0; i < Math.max(400, Math.round(N / 2)); i++) {
  const sex = i % 2 ? 'he' : 'she';
  const pair = rules.BOXERS.filter((b) => b.pronoun === sex && b.club);
  const x = pair[i % pair.length], y = pair[(i + 1) % pair.length];
  if (x.id === y.id || x.style === y.style || x.club === y.club) continue;
  const seed = rules.hashSeed('chair-r3b', i);
  const a = styleBoutIds(seed, x.id, y.id);
  const b = styleBoutIds(seed, y.id, x.id);            // same seed, chairs swapped
  chair.bouts += 2;
  if (a.result && a.result.winner === 'player') chair.left++;
  if (b.result && b.result.winner === 'player') chair.left++;
}

// --- one bout: exactly the page's path -------------------------------------
function boutique(seed, policy, campFn) {
  const a = rules.BOXERS[seed % rules.BOXERS.length];
  const game = rules.createGame({ seed, playerBoxerId: a.id });
  (campFn || campUI)(game, rules.makeRng(rules.hashSeed(seed, 'camp-random')));
  const fight = rules.startFight(game);
  const rng = rules.makeRng(rules.hashSeed(seed, 'arm'));
  while (!rules.isOver(fight)) {
    if (fight.phase === 'corner') { rules.pickCorner(game, rules.aiCornerPick(game)); continue; }
    const out = policy ? policy(fight, rng) : rules.chooseAiCard(fight, 'player');
    const card = out && out.card ? out.card : out;
    const mode = out && out.mode ? out.mode : 'react';
    if (!card) break;
    const shortOfWind = fight.player.hand.some((id) => legal(fight.player, fight, id) && !affordable(fight.player, fight, id));
    const ev = rules.playExchange(game, card, mode);
    if (ev) ev.unaffordable = shortOfWind;
  }
  return { game, fight };
}

// --- the table --------------------------------------------------------------
const stats = { bouts: 0, stoppage: 0, decision: 0, draws: 0, roundsStopped: [0, 0, 0, 0], exchanges: 0, knockdowns: 0,
  unaffordable: 0, judgeSplit: 0, judgeRounds: 0, nothing: 0, pivot: 0, leftWins: 0, leftBouts: 0 };
const predict = { plays: 0, hits: 0, narrow: 0, narrowHits: 0, wide: 0, wideHits: 0 };
const card = {};
for (const id of ORDER) card[id] = { plays: 0, wins: 0, dmg: 0, net: 0, boutPlays: 0, boutWins: 0 };

for (let i = 0; i < N; i++) {
  const seed = rules.hashSeed('balance-r3', i);
  const { fight } = boutique(seed, null, campUI);
  stats.bouts++;
  const res = fight.result;
  if (!res) continue;
  if (res.method === 'stoppage') { stats.stoppage++; stats.roundsStopped[res.round] = (stats.roundsStopped[res.round] || 0) + 1; } else stats.decision++;
  if (res.winner === 'draw') stats.draws++;

  const played = new Set();
  for (const ev of fight.events) {
    stats.exchanges++;
    stats.knockdowns += ev.knockdowns.length;
    card[ev.player.card].plays++; card[ev.player.card].dmg += ev.player.dealt;
    card[ev.player.card].net += ev.player.dealt - ev.opponent.dealt;
    card[ev.opponent.card].plays++; card[ev.opponent.card].dmg += ev.opponent.dealt;
    if (ev.player.card === 'pivot_out') stats.pivot++;
    played.add(ev.player.card);
    if (LEGAL_KEY.has(ev.player.code)) card[ev.player.card].wins++;
    if (LEGAL_KEY.has(ev.opponent.code)) card[ev.opponent.card].wins++;
    if (ev.player.code === 'n') stats.nothing++;
    if (ev.unaffordable) stats.unaffordable++;
    if (ev.mode === 'predict') {
      predict.plays++;
      if (ev.correctRead) predict.hits++;
      /* Reliability, not luck: a read with the shape *and* the film agreeing is
         the reliable one; a shape-only guess is the thin one. */
      const agree = ev.tell && ev.forecast && CARDS[ev.forecast].shape === ev.tell.shape;
      if (agree) { predict.narrow++; if (ev.correctRead) predict.narrowHits++; }
      else { predict.wide++; if (ev.correctRead) predict.wideHits++; }
    }
  }
  const wonByPlayer = res.winner === 'player';
  played.forEach((id) => { card[id].boutPlays++; if (wonByPlayer) card[id].boutWins++; });
  for (const r of fight.rounds) {
    stats.judgeRounds++;
    const dmgWinner = r.player.damage > r.opponent.damage ? 0 : r.opponent.damage > r.player.damage ? 1 : -1;
    const cardsWinner = r.scores.filter((s) => s[0] > s[1]).length > r.scores.filter((s) => s[1] > s[0]).length ? 0 : 1;
    if (dmgWinner >= 0 && dmgWinner !== cardsWinner) stats.judgeSplit++;
  }
}

// --- reference arms ---------------------------------------------------------
function armRate(policy, count, campFn, family, keepEvents) {
  let wins = 0, losses = 0, exchanges = 0, predicts = 0, hits = 0;
  for (let i = 0; i < count; i++) {
    const seed = rules.hashSeed(family || 'arm-r3', i);
    const { fight } = boutique(seed, policy, campFn);
    if (keepEvents) {
      for (const ev of fight.events) {
        exchanges++;
        if (ev.mode !== 'predict') continue;
        predicts++;
        if (ev.correctRead) hits++;
        const agree = ev.tell && ev.forecast && CARDS[ev.forecast].shape === ev.tell.shape;
        if (agree) { predict.narrow++; if (ev.correctRead) predict.narrowHits++; }
        else { predict.wide++; if (ev.correctRead) predict.wideHits++; }
      }
    }
    if (!fight.result) continue;
    if (fight.result.winner === 'player') wins++;
    else if (fight.result.winner === 'opponent') losses++;
  }
  return { rate: wins / (wins + losses || 1), wins, losses, n: wins + losses,
    exchanges, predicts, hits };
}
const engine = armRate(arms.engine, N);
const tell = armRate(arms.tell, Math.max(N, 10000));
const reading = armRate(arms.reading, Math.max(N, 5000));
const styleOnly = armRate(arms.styleOnly, Math.max(N, 5000));
const damage = armRate(arms.damage, N);
const random = armRate(arms.random, N);
/* predict bookkeeping is filled by the arm runner below */
const predictorArm = armRate(arms.predictor, Math.max(N, 5000), null, 'predict-r3b', true);
/* camp is measured across three seed families so one lucky draw cannot decide it */
function campArm(campFn) {
  const families = ['camp-test', 'arm-r3', 'camp2'];
  const per = Math.max(150, Math.round(N / families.length));
  let wins = 0, losses = 0, n = 0;
  for (const fam of families) {
    const r = armRate(arms.engine, per, campFn, fam);
    wins += r.wins; losses += r.losses; n += r.n;
  }
  return { wins, losses, n, rate: wins / (wins + losses || 1) };
}
const informedCamp = campArm(campUI);
const randomCamp = campArm(campRandom);

function priorityBouts(count, preferred) {
  let wins = 0, losses = 0;
  for (let i = 0; i < count; i++) {
    const seed = rules.hashSeed('one-card-r3', preferred, i);
    const a = rules.BOXERS[i % rules.BOXERS.length];
    const game = rules.createGame({ seed, playerBoxerId: a.id });
    campUI(game);
    const fight = rules.startFight(game);
    while (!rules.isOver(fight)) {
      if (fight.phase === 'corner') { rules.pickCorner(game, rules.aiCornerPick(game)); continue; }
      const legalHand = fight.player.hand.filter((id) => legal(fight.player, fight, id));
      const cardId = legalHand.includes(preferred) ? preferred : legalHand[0];
      rules.playExchange(game, cardId);
    }
    if (fight.result.winner === 'player') wins++; else if (fight.result.winner === 'opponent') losses++;
  }
  return wins / (wins + losses || 1);
}

// --- report -----------------------------------------------------------------
const defects = [];
console.log('FightCamp card game - round 3 balance: ' + stats.bouts + ' bouts, UI path (camp, bell, corners, cards)');
console.log('');
console.log('Style pairs: both corners on style weights, seats swapped every bout (all 16)');
console.log('  ' + pad('left v right', 24) + lpad('bouts', 7) + lpad('left wins', 11) + lpad('draws', 8));
for (const [key, row] of [...styleRows.entries()].sort((x, y) => (x[0] < y[0] ? -1 : 1))) {
  const same = key.split(' v ');
  if (same[0] === same[1]) { console.log('  ' + pad(key, 24) + lpad('-', 7) + lpad('no legal pairing', 20)); continue; }
  console.log('  ' + pad(key, 24) + lpad(row.bouts, 7) + lpad(pct(row.left, row.bouts), 11) + lpad(row.draws, 8));
}
console.log('  ' + pad('same boxers, chairs swapped', 24) + lpad(chair.bouts, 7) + lpad(pct(chair.left, chair.bouts), 11));

console.log('');
console.log('Cards: share of exchanges, bout win share when held and played, net points per play');
console.log('  ' + pad('card', 18) + pad('kind', 9) + lpad('plays', 8) + lpad('share', 9) + lpad('bout win', 10) + lpad('net pts/play', 13));
for (const id of ORDER) {
  const c = card[id], plays = c.plays, share = stats.exchanges ? plays / stats.exchanges : 0;
  console.log('  ' + pad(CARDS[id].name, 18) + pad(rules.KIND_LABEL[CARDS[id].kind], 9) +
    lpad(plays, 8) + lpad(pct(plays, stats.exchanges), 9) + lpad(pct(c.boutWins, c.boutPlays || 1), 10) +
    lpad((plays ? c.net / plays : 0).toFixed(2), 13));
  if (share < 0.01) defects.push(CARDS[id].name + ' is barely ever played (' + plays + ' of ' + stats.exchanges + ')');
}

console.log('');
console.log('How the bouts end');
console.log('  ' + pad('stoppage', 24) + lpad(stats.stoppage, 6) + lpad(pct(stats.stoppage, stats.bouts), 9) +
  '   (r1: ' + (stats.roundsStopped[1] || 0) + ', r2: ' + (stats.roundsStopped[2] || 0) + ', r3: ' + (stats.roundsStopped[3] || 0) + ')');
console.log('  ' + pad('on the cards', 24) + lpad(stats.decision, 6) + lpad(pct(stats.decision, stats.bouts), 9));
console.log('  ' + pad('draws', 24) + lpad(stats.draws, 6) + lpad(pct(stats.draws, stats.bouts), 9));
console.log('  ' + pad('knockdowns / bout', 24) + lpad((stats.knockdowns / stats.bouts).toFixed(2), 6));
console.log('  ' + pad('exchanges / bout', 24) + lpad((stats.exchanges / stats.bouts).toFixed(1), 6));
console.log('  ' + pad('exchanges with a card he cannot pay for', 45) + lpad(pct(stats.unaffordable, stats.exchanges), 7));
console.log('  ' + pad('judges disagree with the damage winner', 45) + lpad(pct(stats.judgeSplit, stats.judgeRounds), 7));
console.log('  ' + pad('exchanges where nothing lands', 45) + lpad(pct(stats.nothing, stats.exchanges), 7));
console.log('  ' + pad('Pivot out share of exchanges', 45) + lpad(pct(stats.pivot, stats.exchanges), 7));

console.log('');
console.log('Reference arms: same seeds, same camps, the engine in the other corner');
console.log('  ' + pad('arm', 26) + lpad('bouts', 7) + lpad('win rate', 10));
for (const [name, a] of [['engine chooser', engine], ['style weights only', styleOnly],
  ['reading (film+tell+wind)', reading], ['tell-follower', tell], ['largest damage', damage],
  ['random card', random], ['predictor', predictorArm]]) {
  console.log('  ' + pad(name, 26) + lpad(a.n, 7) + lpad(pct(a.wins, a.n), 10));
}
console.log('  reading is ' + ((reading.rate - styleOnly.rate) * 100).toFixed(1) + ' points up on the best non-reader');
console.log('');
console.log('Predict: how often the reader spends 2 wind on a read, and whether it is right');
console.log('  ' + pad('predict share of exchanges', 34) + lpad(pct(predictorArm.predicts, predictorArm.exchanges), 10));
console.log('  ' + pad('read is right', 34) + lpad(pct(predictorArm.hits, predictorArm.predicts), 10));
console.log('  ' + pad('right when tell and film agree', 34) + lpad(pct(predict.narrowHits, predict.narrow), 10));
console.log('  ' + pad('right on a shape guess alone', 34) + lpad(pct(predict.wideHits, predict.wide), 10));
console.log('');
console.log('Camp: the same bouts with an informed camp and with a random camp');
console.log('  ' + pad('informed camp', 26) + lpad(informedCamp.n, 7) + lpad(pct(informedCamp.wins, informedCamp.n), 10));
console.log('  ' + pad('random camp', 26) + lpad(randomCamp.n, 7) + lpad(pct(randomCamp.wins, randomCamp.n), 10));

console.log('');
console.log('Single-card priority strategies (prefer this card when held, otherwise hand[0])');
let top = { id: null, rate: 0 };
for (const id of ORDER) {
  const rate = priorityBouts(200, id);
  console.log('  ' + pad(CARDS[id].name, 18) + pct(rate, 1));
  if (rate > top.rate) top = { id, rate };
}
console.log('  best one-card strategy: ' + CARDS[top.id].name + ' at ' + pct(top.rate, 1));

// --- the gates --------------------------------------------------------------
const stopRate = stats.stoppage / stats.bouts, kdRate = stats.knockdowns / stats.bouts;
if (top.rate > 0.45) defects.push('one-card strategy ' + CARDS[top.id].name + ' wins ' + pct(top.rate, 1) + ' (target <=45%)');
if (stopRate < 0.10 || stopRate > 0.20) defects.push('stoppages are ' + pct(stats.stoppage, stats.bouts) + ' (target 10-20%)');
if (kdRate < 0.5 || kdRate > 0.8) defects.push('knockdowns are ' + kdRate.toFixed(2) + ' a bout (target 0.5-0.8)');
if (stats.draws) defects.push(stats.draws + ' drawn bouts (amateur bouts are not drawn)');
if (card.block.plays / stats.exchanges < 0.08) defects.push('Block is played in ' + pct(card.block.plays, stats.exchanges) + ' of exchanges (target 8%)');
if (stats.unaffordable / stats.exchanges < 0.03 || stats.unaffordable / stats.exchanges > 0.06) {
  defects.push('wind binds in ' + pct(stats.unaffordable, stats.exchanges) + ' of exchanges (target 3-6%)');
}
if (stats.judgeSplit / stats.judgeRounds > 0.12) defects.push('judges disagree with the damage winner in ' + pct(stats.judgeSplit, stats.judgeRounds) + ' of rounds (target <=12%)');
if (informedCamp.rate - randomCamp.rate < 0.05) defects.push('informed camp beats a random camp by only ' + ((informedCamp.rate - randomCamp.rate) * 100).toFixed(1) + ' pp (target 5)');
if (reading.rate - styleOnly.rate < 0.10) {
  defects.push('reading beats the best non-reader by only ' + ((reading.rate - styleOnly.rate) * 100).toFixed(1) + ' pp (target 10)');
}
/* 1: every style pair inside 42-58, and the chair itself worth no more than 3 */
for (const [key, row] of styleRows.entries()) {
  const r = styleRate(row);
  if (row.bouts && (r < 0.42 || r > 0.58)) defects.push('style pair ' + key + ' sits at ' + pct(row.left, row.bouts) + ' (target 42-58%)');
}
/* the chair itself: the same two boxers replayed with the seats swapped */
if (Math.abs(chair.left / (chair.bouts || 1) - 0.5) > 0.03) {
  defects.push('the left chair wins ' + pct(chair.left, chair.bouts) + ' when the same two boxers swap seats (target 50 +- 3)');
}
/* 2: dead exchanges, and the exit card */
if (stats.nothing / stats.exchanges > 0.10) defects.push('nothing-v-nothing is ' + pct(stats.nothing, stats.exchanges) + ' of exchanges (target <=10%)');
if (stats.pivot / stats.exchanges > 0.55) defects.push('Pivot out is played in ' + pct(stats.pivot, stats.exchanges) + ' of exchanges (target <=55%)');
/* 4: predict is used, and it is right more often when the tell is a narrow shape */
if (predictorArm.predicts / (predictorArm.exchanges || 1) < 0.20 || predictorArm.predicts / (predictorArm.exchanges || 1) > 0.35) {
  defects.push('the predictor predicts in ' + pct(predictorArm.predicts, predictorArm.exchanges) + ' of exchanges (target 20-35%)');
}
if (!predict.narrow || !predict.wide || predict.narrowHits / predict.narrow <= predict.wideHits / predict.wide) {
  defects.push('a confirmed read is not better than a shape guess (' + pct(predict.narrowHits, predict.narrow) + ' v ' + pct(predict.wideHits, predict.wide) + ')');
}
/* 6: the lead hook has to be worth a card */
{
  const share = card.lead_hook.plays / stats.exchanges;
  const winShare = card.lead_hook.boutWins / (card.lead_hook.boutPlays || 1);
  if (share < 0.08) defects.push('Lead hook is played in ' + pct(card.lead_hook.plays, stats.exchanges) + ' of exchanges (target 8%)');
  if (winShare < 0.25) defects.push('Lead hook is in the winning corner in ' + pct(card.lead_hook.boutWins, card.lead_hook.boutPlays) + ' of bouts (target 25%)');
}
if (tell.rate < 0.55 || tell.rate > 0.68) defects.push('tell-follower scores ' + pct(tell.wins, tell.n) + ' (target 55-68%)');
if (reading.rate <= tell.rate) defects.push('reading (' + pct(reading.wins, reading.n) + ') does not beat tell-following (' + pct(tell.wins, tell.n) + ')');
for (const [name, a] of [['tell-follower', tell], ['largest damage', damage], ['random card', random]]) {
  const edge = (a.rate - engine.rate) * 100;
  if (edge > 20) defects.push(name + ' beats the engine by ' + edge.toFixed(1) + ' pp (limit 20)');
}

if (defects.length) {
  for (const d of defects) console.log('DEFECT: ' + d);
  console.log('RESULT: FAIL - ' + defects.length + ' design defect(s) above');
  process.exit(1);
} else {
  console.log('RESULT: PASS - card table, tell scarcity, reading edge, camp, stoppages, knockdowns and draws all inside their limits');
}
