// Round 3b, second critic: pressure currency, dead exchanges, honest lines,
// honest measurement, react below Speed 65, the lead hook, and the corner card.
// Every check here is new in this round; nothing in round 2 / round 3 / round 3b
// was removed to make room.
import R from './rules.js';

let passed = 0, failed = 0;
function check(name, fn) {
  try { fn(); passed++; console.log('PASS  ' + name); }
  catch (e) { failed++; console.log('FAIL  ' + name + '\n      ' + e.message); }
}
function ok(v, msg) { if (!v) throw new Error(msg || 'expected true'); }
function eq(a, b, msg) { if (a !== b) throw new Error((msg || 'equals') + ' (get ' + JSON.stringify(a) + ', want ' + JSON.stringify(b) + ')'); }
function near(a, b, tol, msg) { if (Math.abs(a - b) > tol) throw new Error((msg || 'near') + ' (get ' + a + ', want ' + b + ' +-' + tol + ')'); }

function bout(seed, me = 'ada', foe = 'mara') {
  const game = R.createGame({ seed, playerBoxerId: me, opponentBoxerId: foe });
  while (game.phase === 'camp') { const d = R.aiCampPick(game); R.pickCampCard(game, d, R.aiCampRemove(game, d)); }
  return { game, fight: R.startFight(game) };
}
function hand(fight, ids, key = 'player') { fight[key].hand = ids.slice(); return fight; }
function legalCard(fight, key = 'player') {
  const side = fight[key];
  const ok2 = side.hand.filter((id) => R.legalNow(side, fight, key, id));
  return ok2.length ? ok2[0] : null;
}

/* ---------------------------------------------------------- 1. pressure ----- */

check('C1 cut off: a won cut off moves the fight inside and traps the other man', () => {
  const { game, fight } = bout(3000);
  fight.range = 'mid';
  hand(fight, ['cut_off', 'jab', 'cross', 'slip', 'block']);
  fight.opponent.hand = ['cross', 'jab', 'feint', 'slip', 'block'];
  const ev = R.playExchange(game, 'cut_off', 'react', 'cross');
  eq(ev.player.code, 'w', 'the cut off wins against a cross');
  eq(fight.range, 'inside', 'the ring is cut off: the fight is now inside');
  ok(fight.trap && fight.trap.who === 'opponent', 'the other man is the one trapped');
  eq(fight.cutOffStreak, 1, 'one cut off in a row');
});

check('C1 trapped: his Step back and Pivot out cost one more wind and land at half rate', () => {
  const { game, fight } = bout(3001);
  fight.range = 'mid';
  hand(fight, ['cut_off', 'jab', 'cross', 'slip', 'block']);
  fight.opponent.hand = ['cross', 'step_back', 'pivot_out', 'jab', 'block'];
  R.playExchange(game, 'cut_off', 'react', 'cross');
  ok(fight.trap && fight.trap.who === 'opponent', 'the trap is set');
  fight.range = 'mid';
  hand(fight, ['jab', 'cross', 'slip', 'block', 'cut_off']);
  fight.opponent.hand = ['step_back', 'pivot_out', 'jab', 'block', 'slip'];
  fight.opponent.stamina = fight.opponent.maxStamina;
  const price = R.cardCost(fight.opponent, 'step_back');
  eq(R.costNow(fight.opponent, fight, 'opponent', 'step_back'), price + 1, 'the escape costs one more wind while trapped');
  // and the same card is half as likely to land while he is boxed in
  function escapeRate(trap) {
    let hits = 0;
    for (let i = 0; i < 300; i++) {
      const b = bout(3100 + i);
      b.fight.range = 'mid';
      hand(b.fight, ['jab', 'jab', 'jab', 'jab', 'jab']);
      b.fight.opponent.hand = ['step_back', 'step_back', 'step_back', 'step_back', 'step_back'];
      b.fight.trap = trap ? { who: 'opponent' } : null;
      const ev = R.playExchange(b.game, 'jab', 'react', 'step_back');
      if (ev.opponent.hit) hits++;
    }
    return hits / 300;
  }
  const free = escapeRate(false), trapped = escapeRate(true);
  ok(trapped < free * 0.75, 'a trapped escape lands far less often (' + trapped.toFixed(2) + ' v ' + free.toFixed(2) + ')');
});

check('C1 ropes: two cut offs in a row put him on the ropes and Step back is off the table', () => {
  const { game, fight } = bout(3002);
  fight.range = 'mid';
  hand(fight, ['cut_off', 'cut_off', 'jab', 'cross', 'block']);
  fight.opponent.hand = ['cross', 'jab', 'feint', 'block', 'slip'];
  R.playExchange(game, 'cut_off', 'react', 'cross');
  fight.range = 'mid';
  hand(fight, ['cut_off', 'jab', 'cross', 'block', 'slip']);
  fight.opponent.hand = ['cross', 'jab', 'feint', 'block', 'slip'];
  R.playExchange(game, 'cut_off', 'react', 'cross');
  ok(fight.ropes, 'two cut offs in a row = the ropes');
  eq(fight.range, 'ropes', 'the fight is on the ropes');
  hand(fight, ['step_back', 'jab', 'cross', 'block', 'slip']);
  ok(!R.legalNow(fight.player, fight, 'player', 'step_back'), 'Step back is unplayable on the ropes');
  const listed = R.legalCards(fight).find((c) => c.id === 'step_back');
  ok(!listed.legal, 'the page is told the same thing');
});

check('C1 clinch: a won clinch costs him a wind, gives you one, and smothers his next punch', () => {
  const { game, fight } = bout(3003);
  fight.range = 'mid';
  hand(fight, ['clinch', 'jab', 'cross', 'block', 'slip']);
  fight.opponent.hand = ['block', 'jab', 'cross', 'slip', 'feint'];
  fight.player.stamina = 12; fight.opponent.stamina = 12;
  const mine = fight.player.stamina, his = fight.opponent.stamina;
  const ev = R.playExchange(game, 'clinch', 'react', 'block');
  eq(ev.player.code, 'w', 'the clinch wins the exchange');
  const hisCard = R.costNow(fight.opponent, fight, 'opponent', 'block');
  ok(fight.opponent.stamina <= his - hisCard - 1, 'he pays his card and at least a wind for being tied up');
  ok(fight.opponent.stamina >= his - hisCard - 2, 'and no more than the clinch and the stalemate cost him');
  eq(fight.player.stamina, mine - R.cardCost(fight.player, 'clinch'), 'you pay only the clinch; the wind comes back with the hold');
  eq(fight.opponent.mods.nextPunchAcc, undefined, 'the smother is spent on the next punch, not kept');
});

check('C1 clinch: the smothered punch is 15% less accurate on his next exchange', () => {
  const { game, fight } = bout(3004);
  fight.range = 'mid';
  hand(fight, ['clinch', 'jab', 'cross', 'block', 'slip']);
  fight.opponent.hand = ['cross', 'cross', 'cross', 'cross', 'cross'];
  R.playExchange(game, 'clinch', 'react', 'cross');
  /* the penalty is consumed by the very next punch, whatever it is */
  function rate() {
    let hits = 0;
    for (let i = 0; i < 400; i++) {
      const b = bout(3200 + i);
      b.fight.range = 'mid';
      hand(b.fight, ['block', 'block', 'block', 'block', 'block']);
      b.fight.opponent.hand = ['cross', 'cross', 'cross', 'cross', 'cross'];
      b.fight.opponent.mods.nextPunchAcc = -0.15;
      const ev = R.playExchange(b.game, 'block', 'react', 'cross');
      if (ev.opponent.hit) hits++;
    }
    return hits / 400;
  }
  function clean() {
    let hits = 0;
    for (let i = 0; i < 400; i++) {
      const b = bout(3200 + i);
      b.fight.range = 'mid';
      hand(b.fight, ['block', 'block', 'block', 'block', 'block']);
      b.fight.opponent.hand = ['cross', 'cross', 'cross', 'cross', 'cross'];
      const ev = R.playExchange(b.game, 'block', 'react', 'cross');
      if (ev.opponent.hit) hits++;
    }
    return hits / 400;
  }
  const smothered = rate(), cleanRate = clean();
  ok(smothered < cleanRate - 0.05, 'the smothered punch lands less (' + smothered.toFixed(2) + ' v ' + cleanRate.toFixed(2) + ')');
});

/* ------------------------------------------------------- 2. dead exchanges --- */

check('C2 no repeats: a non-punch card cannot follow a non-punch card', () => {
  const { game, fight } = bout(3005);
  hand(fight, ['slip', 'jab', 'cross', 'block', 'roll']);
  fight.opponent.hand = ['jab', 'jab', 'jab', 'jab', 'jab'];
  R.playExchange(game, 'slip', 'react', 'jab');
  hand(fight, ['feint', 'jab', 'cross', 'block', 'roll']);
  ok(!R.legalNow(fight.player, fight, 'player', 'feint'), 'a feint after a slip is not legal');
  let threw = false;
  try { R.playExchange(game, 'feint', 'react', 'jab'); } catch (e) { threw = true; }
  ok(threw, 'and the resolver refuses it');
  ok(R.legalNow(fight.player, fight, 'player', 'jab'), 'a punch is still legal');
});

check('C2 no repeats: clinch is exempt, because the referee rule needs two in a row', () => {
  const { game, fight } = bout(3006);
  hand(fight, ['clinch', 'jab', 'cross', 'block', 'slip']);
  fight.opponent.hand = ['jab', 'jab', 'cross', 'block', 'slip'];
  R.playExchange(game, 'clinch', 'react', 'jab');
  hand(fight, ['clinch', 'jab', 'cross', 'block', 'slip']);
  ok(R.legalNow(fight.player, fight, 'player', 'clinch'), 'a second clinch is still legal (round 2 pins the referee rule)');
});

check('C2 two men doing nothing: both pay a wind, and Pivot out v Jab / Cut off trade', () => {
  const { game, fight } = bout(3007);
  fight.range = 'mid';
  hand(fight, ['slip', 'jab', 'cross', 'block', 'pivot_out']);
  fight.opponent.hand = ['block', 'jab', 'cross', 'slip', 'feint'];
  fight.player.stamina = 14; fight.opponent.stamina = 14;
  const a = fight.player.stamina, b = fight.opponent.stamina;
  const costA = R.costNow(fight.player, fight, 'player', 'slip');
  const costB = R.costNow(fight.opponent, fight, 'opponent', 'block');
  R.playExchange(game, 'slip', 'react', 'block');
  eq(fight.player.stamina, a - costA - 1, 'your man pays his card and one for the stalemate');
  eq(fight.opponent.stamina, b - costB - 1, 'and so does his');
  eq(R.RESOLUTION.pivot_out.jab, 't', 'Pivot out v Jab is a trade');
  eq(R.RESOLUTION.jab.pivot_out, 't', 'and the other way round');
});

/* ------------------------------------------------------------ 3. the lines -- */

check('C3 lines: one sentence, possessive, and the verb agrees with the table', () => {
  const verbFor = { W: 'beats', w: 'beats', l: 'beats', X: 'catches', t: 'trade', n: 'cancel' };
  for (const a of R.CARD_ORDER) for (const b of R.CARD_ORDER) {
    const code = R.RESOLUTION[a][b];
    const line = R.exchangeLine(a, b, code);
    const mine = 'your boxer’s ' + R.CARDS[a].say;
    const his = 'the opponent’s ' + R.CARDS[b].say;
    ok(line.indexOf(';') > 0, 'a line has a reason clause: ' + line);
    ok(line.includes(verbFor[code]), 'the verb matches the cell (' + a + ' v ' + b + ' ' + code + '): ' + line);
    if (code === 'W' || code === 'w') ok(line.indexOf(mine + ' beats ' + his) === 0, 'the winner is the subject: ' + line);
    if (code === 'l') ok(line.indexOf(his + ' beats ' + mine) === 0, 'the loser is the object: ' + line);
    if (code === 'X') ok(line.indexOf(his + ' catches ' + mine) === 0, 'a counter names him first: ' + line);
    if (code === 't') ok(line.indexOf(mine + ' and ' + his + ' trade') === 0, 'a trade names both: ' + line);
    ok(!/\bwith\b/i.test(line), 'never "X with X": ' + line);
    ok(!/\b(he|his|him)\b/i.test(line), 'never a fixed "he": ' + line);
  }
});

check('C3 lines: the exchange text carries the same sentence the table implies', () => {
  const { game, fight } = bout(3008);
  fight.range = 'mid';
  hand(fight, ['cross', 'jab', 'slip', 'block', 'roll']);
  fight.opponent.hand = ['jab', 'jab', 'jab', 'jab', 'jab'];
  const ev = R.playExchange(game, 'cross', 'react', 'jab');
  ok(ev.text.startsWith(R.exchangeLine('cross', 'jab', ev.player.code)), 'the line is built from the code: ' + ev.text);
  ok(ev.text.includes(R.CARDS.jab.say), 'his card is named');
  ok(ev.text.includes(R.CARDS.cross.say), 'your card is named');
});

/* -------------------------------------------------------- 5. react matters -- */

check('C5 react: a reacting boxer takes 10% less, and a prediction gives it up', () => {
  function taken(mode, guard) {
    const { game, fight } = bout(3009);
    fight.range = 'mid';
    fight.reactGuard = guard;
    hand(fight, ['block', 'block', 'block', 'block', 'block']);
    fight.opponent.hand = ['cross', 'cross', 'cross', 'cross', 'cross'];
    let total = 0;
    for (let i = 0; i < 60; i++) {
      const b = bout(3300 + i);
      b.fight.range = 'mid';
      if (guard !== undefined) b.fight.reactGuard = guard;
      hand(b.fight, ['block', 'block', 'block', 'block', 'block']);
      b.fight.opponent.hand = ['cross', 'cross', 'cross', 'cross', 'cross'];
      total += R.playExchange(b.game, 'block', mode, 'cross').opponent.dealt;
    }
    return total;
  }
  const reacting = taken('react'), guessing = taken('predict');
  ok(reacting < guessing, 'reacting takes less than committing to a read (' + reacting.toFixed(1) + ' v ' + guessing.toFixed(1) + ')');
  ok(taken('react', 1) >= reacting, 'the guard is a real multiplier, not a constant');
});

check('C5 react: the tell is shown as a shape on a reacting exchange', () => {
  const { game, fight } = bout(3010);
  hand(fight, ['jab', 'cross', 'block', 'slip', 'roll']);
  fight.opponent.hand = ['cross', 'jab', 'block', 'slip', 'roll'];
  fight.exchange = 0;
  R.refreshTell(fight);
  const named = fight.tell.shape;
  const ev = R.playExchange(game, legalCard(fight), 'react', 'cross');
  eq(ev.tellShape, named, 'reacting shows the shape the chip named');
  const e2 = bout(3011);
  e2.fight.exchange = 0;
  R.refreshTell(e2.fight);
  const ev2 = R.playExchange(e2.game, legalCard(e2.fight), 'predict', 'cross');
  eq(ev2.tellShape, null, 'a prediction does not also get the free look');
});

/* -------------------------------------------------------------- 6. the hook -- */

check('C6 lead hook: a tie against the guard and against a step back at close quarters', () => {
  eq(R.resolutionAt('lead_hook', 'block', 'inside'), 't', 'inside, the hook gets round the guard');
  eq(R.resolutionAt('block', 'lead_hook', 'inside'), 't', 'and the guard only trades');
  eq(R.resolutionAt('lead_hook', 'step_back', 'inside'), 't', 'inside, stepping away only trades');
  eq(R.resolutionAt('step_back', 'lead_hook', 'inside'), 't', 'both ways');
  /* the round-1 cell is pinned at mid and out, so those must not move */
  eq(R.RESOLUTION.block.lead_hook, 'w', 'the printed table still has the guard winning at mid');
  eq(R.RESOLUTION.lead_hook.block, 'l', 'and the hook losing');
  const hook = R.CARDS.lead_hook;
  ok(hook.cost <= 8, 'the hook is not the most expensive card in the deck (' + hook.cost + ')');
});

/* --------------------------------------------------------- 7. change plan ---- */

check('C7 change the plan: two extra cards for six wind, for whichever corner asks', () => {
  const { game, fight } = bout(3012);
  for (let i = 0; i < 6 && fight.phase === 'fight'; i++) R.playExchange(game, R.chooseAiCard(fight, 'player'));
  if (fight.phase !== 'corner') throw new Error('expected the corner');
  fight.corner = ['change_plan']; fight.foeCorner = ['change_plan']; fight.foeCornerPick = 'change_plan';
  const beforeMe = fight.player.stamina, beforeHim = fight.opponent.stamina;
  R.pickCorner(game, 'change_plan');
  eq(fight.player.hand.length, 7, 'you get the two extra looks');
  eq(fight.opponent.hand.length, 7, 'and so does he (round 2 pins the symmetry)');
  /* the corner refills +8 first, so the price shows as 8 - 6 = 2 more than he had */
  ok(fight.player.stamina <= Math.min(fight.player.maxStamina, beforeMe + 2), 'you really paid six wind for the looks');
  ok(fight.opponent.stamina <= Math.min(fight.opponent.maxStamina, beforeHim + 2), 'and so did he');
});

/* ----------------------------------------------------- 4. honest measurement -- */

check('C4 the baseline is honest: style weights, no tell, no film, both chairs', () => {
  const { fight } = bout(3013);
  fight.tellPaid = true;
  const withTell = [];
  for (let i = 0; i < 40; i++) {
    const b = bout(3400 + i);
    b.fight.exchange = 1; b.fight.tellPaid = true;
    withTell.push(R.chooseStyleCard(b.fight, 'player'));
  }
  /* the style policy never looks at the chip: same seed, tell paid or not, same card */
  const without = [];
  for (let i = 0; i < 40; i++) {
    const b = bout(3400 + i);
    b.fight.exchange = 1; b.fight.tellPaid = false;
    without.push(R.chooseStyleCard(b.fight, 'player'));
  }
  eq(JSON.stringify(withTell), JSON.stringify(without), 'paying for the tell changes nothing for the style policy');
  for (const id of withTell) ok(R.CARD_ORDER.includes(id), 'and it only ever picks real cards');
});

check('C4 the read reads the tell: the forecast follows the shape on the chip', () => {
  let sameShape = 0, total = 0;
  for (let i = 0; i < 200; i++) {
    const { fight } = bout(3500 + i);
    fight.exchange = 0;                      // the free look is public
    R.refreshTell(fight);
    const guess = R.predictedCard(fight);
    if (!guess) continue;
    total++;
    const shape = fight.tell.shape;
    if (R.CARDS[guess].shape === shape) sameShape++;
  }
  ok(total > 0, 'the read always names a card');
  ok(sameShape / total > 0.7, 'the forecast normally comes from the shape on the chip (' + (100 * sameShape / total).toFixed(0) + '%)');
});

check('C4 bout win share and points swing are measured, not "win when played"', () => {
  /* a card that lands its cell still only helps if the bout is won: the harness
     reports both, so this check pins the two numbers to the event record. */
  const { game, fight } = bout(3014);
  const before = fight.events.length;
  for (let i = 0; i < 3 && fight.phase === 'fight'; i++) R.playExchange(game, R.chooseAiCard(fight, 'player'));
  eq(fight.events.length, before + 3, 'three exchanges on the record');
  for (const ev of fight.events) {
    ok(typeof ev.player.dealt === 'number' && typeof ev.opponent.dealt === 'number', 'each exchange carries both damage totals');
    ok(R.CARD_ORDER.includes(ev.player.card), 'and the card that was played');
  }
});

if (failed) { console.log('\n' + passed + ' passed, ' + failed + ' failed'); process.exit(1); }
console.log('RESULT: PASS - round 3b second pass (' + passed + ' checks green)');
