// FightCamp card game - round 4 gates, run by balance.mjs (or alone:
//   node proto/cardgame/balance-round4.mjs [bouts]).
// Everything here drives the page's own sequence: createGame -> four camp picks
// -> startFight -> playExchange / pickCorner until isOver. It measures what the
// round-3 harness could not see: fixed combinations, the called forecast, the
// ropes, split cards, the corner, and each boxer pair from both chairs.
import rules from './rules.js';
import { pathToFileURL } from 'node:url';

const CARDS = rules.CARDS, ORDER = rules.CARD_ORDER, STYLES = rules.STYLES;
const pct = (n, d) => (d ? (100 * n / d).toFixed(1) + '%' : '-');
const pad = (s, n) => String(s).padEnd(n);
const dmg = (id) => (CARDS[id].kind === 'punch' ? CARDS[id].dmg.head + CARDS[id].dmg.body : 0);
const legalHand = (f) => f.player.hand.filter((id) => rules.legalNow(f.player, f, 'player', id));

function camp(game) {
  while (game.phase === 'camp') { const d = rules.aiCampPick(game); rules.pickCampCard(game, d, rules.aiCampRemove(game, d)); }
}
/* policy(fight, rng) -> { cards, mode, call }; corner(game, rng) -> corner id */
function bout(seed, meId, foeId, policy, corner, foePolicy) {
  const game = rules.createGame({ seed, playerBoxerId: meId, opponentBoxerId: foeId });
  camp(game);
  const fight = rules.startFight(game);
  if (foePolicy) fight.foePolicy = foePolicy;
  const rng = rules.makeRng(rules.hashSeed(seed, 'r4'));
  while (!rules.isOver(fight)) {
    if (fight.phase === 'corner') { rules.pickCorner(game, corner ? corner(game, rng) : rules.aiCornerPick(game)); continue; }
    const out = policy(fight, rng);
    let cards = (Array.isArray(out.cards) ? out.cards : [out.cards]).filter(Boolean);
    if (fight.player.stamina <= 0) cards = cards.slice(0, 1);
    rules.playExchange(game, cards.length === 1 ? cards[0] : cards, out.mode || 'react', undefined, out.call);
  }
  return fight;
}
function run(n, family, policy, corner) {
  let wins = 0, calls = 0, right = 0, ex = 0;
  for (let i = 0; i < n; i++) {
    const me = rules.BOXERS[i % rules.BOXERS.length];
    const f = bout(rules.hashSeed(family, i), me.id, undefined, policy, corner);
    if (f.result.winner === 'player') wins++;
    ex += f.events.length;
    for (const ev of f.events) if (ev.mode === 'predict') { calls++; if (ev.correctRead || ev.shapeRead) right++; }
  }
  return { wins, n, rate: wins / n, ex, calls, right };
}

// --- policies ----------------------------------------------------------------
const engine = (f) => ({ cards: rules.chooseAiCard(f, 'player') });
function punchesBehind(f, first, count) {
  const rest = legalHand(f).filter((id) => CARDS[id].kind === 'punch');
  const used = first ? [first] : [];
  const pool = f.player.hand.slice();
  if (first) pool.splice(pool.indexOf(first), 1);
  const punches = pool.filter((id) => rest.includes(id)).sort((a, b) => dmg(b) - dmg(a)).slice(0, count);
  return used.concat(punches);
}
function shield(count) {
  return (f) => {
    const guards = legalHand(f).filter((id) => CARDS[id].kind === 'defence')
      .sort((a, b) => rules.costNow(f.player, f, 'player', a) - rules.costNow(f.player, f, 'player', b));
    const cards = punchesBehind(f, guards[0] || null, count);
    return { cards: cards.length ? cards : legalHand(f)[0] || f.player.hand[0] };
  };
}
const threeBiggest = (f) => { const c = punchesBehind(f, null, 3); return { cards: c.length ? c : legalHand(f)[0] || f.player.hand[0] }; };
const enginePlus = (count) => (f) => ({ cards: punchesBehind(f, rules.chooseAiCard(f, 'player'), count) });

function shapeWeights(shape, style) {
  const out = {};
  for (const id of ORDER) if (CARDS[id].shape === shape) out[id] = Math.max(0.05, STYLES[style].weights[id] || 0.5);
  return out;
}
function bestAgainst(f, weights) {
  let best = null, top = -Infinity;
  for (const id of legalHand(f)) {
    let s = rules.expectedSwing(id, weights);
    if (CARDS[id].ranges.indexOf(f.range) < 0) s *= 0.8;
    if (f.player.stamina < rules.costNow(f.player, f, 'player', id)) s *= 0.7;
    if (s > top) { top = s; best = id; }
  }
  return best || f.player.hand[0];
}
/* The reader: buy the look while there is wind, answer the shape on the chip.
   `call` decides when it also commits to a forecast. */
function reader(call, buy) {
  return (f) => {
    if (buy !== false && !rules.tellVisible(f) && f.player.stamina > 30) rules.payForTell(f);
    const seen = rules.tellVisible(f) && f.tell ? f.tell.shape : null;
    const film = rules.scoutingPrediction(f).filter((r) => r.active).sort((a, b) => b.chance - a.chance)[0];
    const weights = seen ? shapeWeights(seen, f.opponent.style) : Object.assign({}, STYLES[f.opponent.style].weights);
    const card = bestAgainst(f, weights);
    const c = call(f, seen, film);
    return c && f.player.stamina > 12 ? { cards: card, mode: 'predict', call: c } : { cards: card };
  };
}
const favShape = (f) => { const w = STYLES[f.opponent.style].weights; let b = ORDER[0]; for (const id of ORDER) if (w[id] > w[b]) b = id; return CARDS[b].shape; };
const never = () => null;
const onTell = (f, seen) => seen;                                   // the chip names a shape: call it
const onFilm = (f, seen, film) => (film && film.chance >= 0.85 ? film.card : null);
const onBoth = (f, seen, film) => onFilm(f, seen, film) || seen;
const always = (f, seen) => seen || favShape(f);

export function round4(N, only) {
  const lines = [], defects = [], say = (s) => lines.push(s);
  const n = Math.max(640, Math.round(N / 2));
  const pn = Math.max(2000, N);
  const want = (k) => !only || only === k || (only === 'fast' && k !== 'pairs');

  if (want('combo')) {
  say('Round 4: fixed combinations (no reading), the engine in the other corner');
  const combos = [['engine card alone', engine], ['engine card + 1 biggest punch', enginePlus(1)], ['engine card + 2 biggest punches', enginePlus(2)],
    ['3 biggest punches', threeBiggest], ['cheapest defence + 1 punch', shield(1)], ['cheapest defence + 2 punches (shield)', shield(2)]];
  for (const [name, policy] of combos) {
    const r = run(n, 'combo-r4', policy);
    say('  ' + pad(name, 40) + pct(r.wins, r.n));
    if (policy !== engine && r.rate > 0.55) defects.push('fixed combination "' + name + '" wins ' + pct(r.wins, r.n) + ' (limit 55%)');
  }

  }
  if (want('call')) {
  say('');
  say('Round 4: the called forecast (the reader buys the look above 30 wind)');
  const base = run(pn, 'call-r4', reader(never));
  const tellCall = run(pn, 'call-r4', reader(onTell));
  const filmCall = run(pn, 'call-r4', reader(onFilm));
  const bothCall = run(pn, 'call-r4', reader(onBoth));
  const allCall = run(pn, 'call-r4', reader(always, false));
  for (const [name, r] of [['never predicts', base], ['calls the shape on the chip', tellCall], ['calls the card on an 85% habit', filmCall],
    ['calls both', bothCall], ['predicts every exchange, buys no look', allCall]]) {
    say('  ' + pad(name, 40) + pct(r.wins, r.n) + '   calls in ' + pct(r.calls, r.ex) + ' of exchanges, right ' + pct(r.right, r.calls));
  }
  if (tellCall.rate - base.rate < 0.03) defects.push('calling the shape on the chip is worth ' + ((tellCall.rate - base.rate) * 100).toFixed(1) + ' points (target 3+)');
  if (filmCall.rate < base.rate) defects.push('calling the card on an 85% habit loses points (' + pct(filmCall.wins, filmCall.n) + ' v ' + pct(base.wins, base.n) + ')');
  if (allCall.rate > 0.40) defects.push('predicting every exchange wins ' + pct(allCall.wins, allCall.n) + ' (limit 40%)');

  }
  if (want('ropes')) {
  say('');
  say('Round 4: the ropes, split cards and the corner (engine in both corners)');
  const ropes = { ex: 0, on: 0, pex: 0, pon: 0, pivot: 0, cards: 0 }, dec = { n: 0, split: 0, close: 0 };
  for (let i = 0; i < n; i++) {
    const me = rules.BOXERS[i % rules.BOXERS.length];
    const f = bout(rules.hashSeed('ropes-r4', i), me.id, undefined, engine);
    const pressure = f.player.style === 'pressure' || f.opponent.style === 'pressure';
    for (const ev of f.events) {
      ropes.ex++; ropes.cards += 2;
      if (ev.range === 'ropes') ropes.on++;
      if (pressure) { ropes.pex++; if (ev.range === 'ropes') ropes.pon++; }
      if (ev.player.card === 'pivot_out') ropes.pivot++;
      if (ev.opponent.card === 'pivot_out') ropes.pivot++;
    }
    if (f.result.method === 'decision') { dec.n++; if (f.result.margin < 5) dec.split++; if (f.result.margin === 1) dec.close++; }
  }
  say('  ' + pad('exchanges on the ropes (a pressure fighter in the bout)', 58) + pct(ropes.pon, ropes.pex));
  say('  ' + pad('exchanges on the ropes (all bouts)', 58) + pct(ropes.on, ropes.ex));
  say('  ' + pad('Pivot out share of cards played', 58) + pct(ropes.pivot, ropes.cards));
  say('  ' + pad('decisions that are not 5-0', 58) + pct(dec.split, dec.n) + '   (3-2: ' + pct(dec.close, dec.n) + ')');
  if (ropes.pon / ropes.pex < 0.03) defects.push('the ropes are reached in ' + pct(ropes.pon, ropes.pex) + ' of a pressure fighter\'s exchanges (floor 3%)');
  if (dec.split / dec.n < 0.25 || dec.split / dec.n > 0.40) defects.push('split cards are ' + pct(dec.split, dec.n) + ' of decisions (target 25-40%)');

  }
  if (want('corner')) {
  const cornerIds = rules.CORNER_CARDS.map((c) => c.id), picks = {};
  const counting = (game) => { const id = rules.aiCornerPick(game); picks[id] = (picks[id] || 0) + 1; return id; };
  const informed = run(pn, 'corner-r4', engine, counting);
  const randomPick = run(pn, 'corner-r4', engine, (game, rng) => game.fight.corner[rng.int(game.fight.corner.length)]);
  say('  ' + pad('the corner\'s own pick v a random corner pick', 58) + pct(informed.wins, informed.n) + ' v ' + pct(randomPick.wins, randomPick.n));
  const total = Object.values(picks).reduce((a, b) => a + b, 0);
  say('  corner picks: ' + cornerIds.map((id) => id + ' ' + pct(picks[id] || 0, total)).join(', '));
  for (const id of cornerIds) {
    const r = run(n, 'corner-r4', engine, (game) => (game.fight.corner.includes(id) ? id : rules.aiCornerPick(game)));
    say('  ' + pad('  always ' + id + ' when offered', 58) + pct(r.wins, r.n));
  }
  /* A tripwire, not the target: the critic asked for 4+ points and the corner is still inside the noise. */
  if (informed.rate - randomPick.rate < -0.01) defects.push('the informed corner loses to a random corner pick by ' + ((randomPick.rate - informed.rate) * 100).toFixed(1) + ' points');

  }
  if (want('pairs')) {
  say('');
  say('Round 4: every legal boxer pair from both chairs (same public policy in both)');
  const per = Math.max(1000, Math.round(N / 2));
  const same = (f) => ({ cards: rules.chooseAiCard(f, 'player', true) });
  const foe = (f) => rules.chooseAiCard(f, 'opponent');
  const B = rules.BOXERS;
  for (let x = 0; x < B.length; x++) for (let y = x + 1; y < B.length; y++) {
    if (B[x].pronoun !== B[y].pronoun || B[x].club === B[y].club) continue;
    let ab = 0, ba = 0;
    for (let i = 0; i < per; i++) {
      if (bout(rules.hashSeed('pair-r4', x, y, i), B[x].id, B[y].id, same, null, foe).result.winner === 'player') ab++;
      if (bout(rules.hashSeed('pair-r4', x, y, i), B[y].id, B[x].id, same, null, foe).result.winner === 'player') ba++;
    }
    const sum = 100 * (ab + ba) / per;
    say('  ' + pad(B[x].name + ' v ' + B[y].name, 34) + pct(ab, per) + ' + ' + pct(ba, per) + ' = ' + sum.toFixed(1));
    for (const [l, r, w] of [[B[x], B[y], ab], [B[y], B[x], ba]]) {
      if (w / per < 0.40 || w / per > 0.60) defects.push(l.name + ' v ' + r.name + ' sits at ' + pct(w, per) + ' (limit 40-60%)');
    }
    if (Math.abs(sum - 100) > 6) defects.push('the chairs for ' + B[x].name + ' v ' + B[y].name + ' sum to ' + sum.toFixed(1) + ' (target 100 +- 6)');
  }
  }
  return { lines, defects };
}

if (import.meta.url === pathToFileURL(process.argv[1]).href) {
  const out = round4(Number(process.argv[2]) || 2000, process.argv[3]);
  out.lines.forEach((l) => console.log(l));
  out.defects.forEach((d) => console.log('DEFECT: ' + d));
  console.log(out.defects.length ? 'RESULT: FAIL - ' + out.defects.length + ' round-4 defect(s)' : 'RESULT: PASS - round 4 gates');
  if (out.defects.length) process.exit(1);
}
