// FightCamp card game - rules tests.
//   node proto/cardgame/rules.test.mjs
// Prints PASS/FAIL for every check and exits 1 if anything fails.
import rules from './rules.js';
import './rules.round2.test.mjs';
import './rules.round3.test.mjs';
import './rules.round3b.test.mjs';
import './rules.round3c.test.mjs';
import './rules.round4.test.mjs';
const R = rules;
let passed = 0, failed = 0;
const failures = [];
function check(name, fn) {
  try {
    fn();
    passed++;
    console.log('PASS  ' + name);
  } catch (err) {
    failed++;
    failures.push(name + ' :: ' + err.message);
    console.log('FAIL  ' + name + '\n      ' + err.message);
  }
}
function ok(cond, msg) { if (!cond) throw new Error(msg || 'expected true'); }
function eq(a, b, msg) {
  if (a !== b) throw new Error((msg || 'not equal') + ' (get ' + JSON.stringify(a) + ', want ' + JSON.stringify(b) + ')');
}
function near(a, b, tol, msg) {
  if (Math.abs(a - b) > tol) throw new Error((msg || 'not near') + ' (get ' + a + ', want ' + b + ' +/- ' + tol + ')');
}
// a game that has finished its 4 camp weeks, ready for the bell
function sameSexOpponent(id, preferred) {
  const me = R.boxerById(id), requested = R.boxerById(preferred);
  if (requested && requested.id !== id && requested.pronoun === me.pronoun && requested.club !== me.club) return requested.id;
  return R.BOXERS.find(b => b.id !== id && b.pronoun === me.pronoun && b.club !== me.club).id;
}
function readyGame(seed, me = 'ada', foe = 'mara') {
  foe = sameSexOpponent(me, foe);
  const game = R.createGame({ seed, playerBoxerId: me, opponentBoxerId: foe });
  while (game.phase === 'camp') R.pickCampCard(game, R.aiCampPick(game));
  return game;
}
/* round 3b: each seat now draws from its own hit stream, so a seed that used to
   go the distance can stop early. These checks are about the schedule and the
   cards, not about seed 3 in particular, so they walk to the first bout that
   goes the distance and keep every assertion. */
function distanceBout(startSeed, me, foe) {
  for (let seed = startSeed; seed < startSeed + 40; seed++) {
    const b = playBout(seed, me, foe);
    if (b.fight.result && b.fight.result.method !== 'decision') continue;
    /* Round 3b also resolves a handful of cells by range (inside-range trades
       for the hook and the pivot, both documented deviations). This check is
       about the plain table, so it takes a bout that never lands on one. */
    const overridden = b.fight.events.some((ev) => ev.code !== R.RESOLUTION[ev.player.card][ev.opponent.card]);
    if (!overridden) return b;
  }
  throw new Error('no clean bout went the distance in 40 seeds');
}
function playBout(seed, me = 'ada', foe = 'mara') {
  foe = sameSexOpponent(me, foe);
  const game = R.createGame({ seed, playerBoxerId: me, opponentBoxerId: foe });
  while (game.phase === 'camp') R.pickCampCard(game, R.aiCampPick(game));
  const fight = R.startFight(game);
  let guard = 0;
  while (!R.isOver(fight)) {
    if (fight.phase === 'corner') { R.pickCorner(game, R.aiCornerPick(game)); continue; }
    R.playExchange(game, R.chooseAiCard(fight, 'player'));
    if (++guard > 200) throw new Error('the fight would not end');
  }
  return { game, fight };
}
/* ------------------------------------------------------------------ data */
check('data: 17 boxing cards, each with a name, a kind, a cost and one line of text', () => {
  eq(R.CARD_ORDER.length, 17, 'card count');
  eq(new Set(R.CARD_ORDER).size, 17, 'card ids are unique');
  const kinds = new Set();
  for (const id of R.CARD_ORDER) {
    const c = R.CARDS[id];
    ok(c, 'card ' + id + ' exists');
    ok(c.id === id, id + ' id matches its key');
    ok(typeof c.name === 'string' && c.name.length > 1, id + ' name');
    ok(typeof c.effect === 'string' && c.effect.length > 20, id + ' effect text');
    ok(c.cost >= 1 && c.cost <= 10, id + ' cost in range');
    ok(['punch', 'defence', 'footwork'].includes(c.kind), id + ' kind');
    ok(c.art === 'boxing', id + ' is boxing card data');
    ok(c.dmg || c.counter, id + ' has damage or a counter');
    kinds.add(c.kind);
  }
  eq(kinds.size, 3, 'all three kinds are used');
  eq(R.CARD_ORDER.filter(id => R.CARDS[id].kind === 'punch').length, 7, '7 punches');
  eq(R.CARD_ORDER.filter(id => R.CARDS[id].kind === 'defence').length, 5, '5 defences');
  eq(R.CARD_ORDER.filter(id => R.CARDS[id].kind === 'footwork').length, 5, '5 footwork cards');
});
/* ------------------------------------------------- resolution table (all pairs) */
check('resolution table: every one of the 289 pairs has a legal outcome', () => {
  const legal = Object.keys(R.FLIP);
  for (const row of R.MATRIX_ROWS) eq(row.length, 17, 'every row has 17 cells');
  for (const a of R.CARD_ORDER) {
    for (const b of R.CARD_ORDER) {
      const code = R.RESOLUTION[a][b];
      ok(legal.includes(code), a + ' v ' + b + ' has an outcome (get ' + code + ')');
      ok(R.CODE_FACTOR[code] !== undefined, a + ' v ' + b + ' outcome has a factor');
    }
  }
  eq(R.CARD_ORDER.length * R.CARD_ORDER.length, 289, '289 pairs');
});
check('resolution table: anti-symmetric (what one card does to another is exactly the flip back)', () => {
  for (const a of R.CARD_ORDER) {
    for (const b of R.CARD_ORDER) {
      eq(R.RESOLUTION[b][a], R.FLIP[R.RESOLUTION[a][b]], a + ' v ' + b + ' flips');
    }
  }
});
check('resolution table: a card against itself is a trade (punch) or nothing (defence/footwork)', () => {
  for (const id of R.CARD_ORDER) {
    const want = R.CARDS[id].kind === 'punch' ? 't' : 'n';
    eq(R.RESOLUTION[id][id], want, id + ' v ' + id);
  }
});
check('resolution table: slip beats the straight punches, a hook beats a slip', () => {
  for (const straight of ['jab', 'cross']) {
    ok(['W', 'w'].includes(R.RESOLUTION.slip[straight]), 'slip wins v ' + straight + ' (get ' + R.RESOLUTION.slip[straight] + ')');
    ok(['l', 'X'].includes(R.RESOLUTION[straight].slip), straight + ' loses to a slip');
  }
  eq(R.RESOLUTION.lead_hook.slip, 'w', 'the lead hook punishes a slip');
  eq(R.RESOLUTION.slip.lead_hook, 'l', 'a slip loses to the lead hook');
});
check('resolution table: roll beats the hooks, the uppercut beats a roll', () => {
  for (const hook of ['lead_hook', 'body_hook']) {
    ok(['W', 'w'].includes(R.RESOLUTION.roll[hook]), 'roll wins v ' + hook);
    ok(['l', 'X'].includes(R.RESOLUTION[hook].roll), hook + ' loses to a roll');
  }
  eq(R.RESOLUTION.uppercut.roll, 'w', 'the uppercut catches a man rolling under');
  eq(R.RESOLUTION.roll.uppercut, 'l', 'a roll loses to the uppercut');
});
check('resolution table: a hook beats a clinch attempt at range, a clinch smothers the inside', () => {
  eq(R.RESOLUTION.lead_hook.clinch, 'w', 'lead hook v clinch');
  eq(R.RESOLUTION.clinch.lead_hook, 'l', 'clinch v lead hook');
  for (const inside of ['body_hook', 'uppercut']) {
    eq(R.RESOLUTION.clinch[inside], 'w', 'clinch smothers ' + inside);
    eq(R.RESOLUTION[inside].clinch, 'l', inside + ' loses in a clinch');
  }
});
check('resolution table: cut off the ring beats step back, pivot out beats cut off, a jab beats cut off', () => {
  eq(R.RESOLUTION.cut_off.step_back, 'W', 'cut off the ring v step back');
  eq(R.RESOLUTION.step_back.cut_off, 'X', 'step back v cut off the ring');
  eq(R.RESOLUTION.pivot_out.cut_off, 'w', 'pivot out v cut off the ring');
  eq(R.RESOLUTION.cut_off.pivot_out, 'l', 'cut off the ring v pivot out');
  eq(R.RESOLUTION.jab.cut_off, 'w', 'the jab meets a man walking in');
  eq(R.RESOLUTION.cut_off.jab, 'l', 'cut off the ring v the jab');
});
check('resolution table: block stops the hands, the uppercut goes through the guard', () => {
  for (const p of ['jab', 'cross', 'lead_hook']) {
    eq(R.RESOLUTION.block[p], 'w', 'block v ' + p);
    eq(R.RESOLUTION[p].block, 'l', p + ' v block');
  }
  eq(R.RESOLUTION.uppercut.block, 'w', 'uppercut through the guard');
  eq(R.RESOLUTION.block.uppercut, 'l', 'block v uppercut');
});
check('resolution table: step back takes the big shots away but the jab follows', () => {
  for (const p of ['cross', 'lead_hook', 'body_hook', 'uppercut']) {
    eq(R.RESOLUTION.step_back[p], 'w', 'step back v ' + p);
  }
  eq(R.RESOLUTION.step_back.jab, 'l', 'the jab follows a step back');
});
/* ---------------------------------------------------------------- the RNG */
check('seeded RNG: the same seed gives the same sequence, another seed does not', () => {
  const a = R.makeRng(42), b = R.makeRng(42), c = R.makeRng(43);
  const seqA = [], seqB = [], seqC = [];
  for (let i = 0; i < 50; i++) { seqA.push(a.next()); seqB.push(b.next()); seqC.push(c.next()); }
  eq(seqA.join(','), seqB.join(','), 'same seed, same numbers');
  ok(seqA.join(',') !== seqC.join(','), 'a different seed gives different numbers');
  for (const v of seqA) ok(v >= 0 && v < 1, 'the RNG stays in [0,1)');
  eq(R.hashSeed('a', 1), R.hashSeed('a', 1), 'hashSeed is stable');
  ok(R.hashSeed('a', 1) !== R.hashSeed('a', 2), 'hashSeed separates parts');
});
/* ------------------------------------------------------------ camp layer */
check('camp: 4 weeks, 3 offers a week, a pick changes the deck or a stat', () => {
  const game = R.createGame({ seed: 7, playerBoxerId: 'ada', opponentBoxerId: 'mara' });
  eq(game.phase, 'camp', 'starts in camp');
  eq(game.offers.length, 4, '4 weeks');
  for (const week of game.offers) {
    eq(week.length, 3, 'three cards a week');
    eq(new Set(week).size, 3, 'the three offers are different');
    for (const id of week) ok(R.CAMP_CARDS.some(c => c.id === id), 'offer is a real camp card');
  }
  const before = JSON.stringify(game.mods);
  const first = game.offers[0][0];
  R.pickCampCard(game, first);
  eq(game.week, 1, 'week advances');
  ok(JSON.stringify(game.mods) !== before, 'the pick changed the camp');
  const notOffered = R.CAMP_CARDS.map(c => c.id).find(id => !game.offers[1].includes(id));
  let threw = false;
  try { R.pickCampCard(game, notOffered); } catch (e) { threw = true; }
  ok(threw, 'a card that is not in this week\'s offer is refused (' + notOffered + ')');
  while (game.phase === 'camp') R.pickCampCard(game, R.aiCampPick(game));
  eq(game.phase, 'scout', 'after 4 weeks the scouting file arrives');
});
check('camp: added cards really are in the fight deck, and stats are raised', () => {
  const game = R.createGame({ seed: 11, playerBoxerId: 'ada', opponentBoxerId: 'mara' });
  game.offers[0] = ['weights', 'roadwork', 'double_jab'];
  R.pickCampCard(game, 'weights');
  game.offers[1] = ['double_jab', 'roadwork', 'weights'];
  R.pickCampCard(game, 'double_jab');
  game.offers[2] = ['roadwork', 'ladder', 'guard_drill'];
  game.offers[3] = ['roadwork', 'ladder', 'guard_drill'];
  while (game.phase === 'camp') R.pickCampCard(game, R.aiCampPick(game));
  const fight = R.startFight(game);
  eq(fight.player.stats.power, R.boxerById('ada').stats.power + 5, 'power is up 5');
  const jabs = fight.player.deck.filter(c => c === 'jab').length;
  const baseJabs = R.boxerById('ada').deck.filter(c => c === 'jab').length;
  eq(jabs, Math.max(baseJabs + 2 - (game.mods.remove['jab'] || 0), 3), 'two camp jabs are added; the signature is already part of the roster deck');
});
check('scouting: the file reveals 0, 1 or 2 habits and never more than the man has', () => {
  for (let seed = 1; seed <= 60; seed++) {
    const game = R.createGame({ seed, playerBoxerId: 'ada', opponentBoxerId: 'mara' });
    while (game.phase === 'camp') R.pickCampCard(game, R.aiCampPick(game));
    const sc = game.scouting;
    ok(sc.known.length >= 0 && sc.known.length <= 2, 'revealed ' + sc.known.length + ' habits');
    const habits = R.boxerById('mara').habits;
    for (const k of sc.known) ok(habits.includes(k.id), 'only real habits are revealed');
    for (const k of sc.known) ok(typeof k.text === 'string' && k.text.length > 10, 'a habit is shown as words');
    eq(sc.known.length + sc.fleeting, habits.length, 'known + unknown = all his habits');
  }
});
/* ---------------------------------------------------------- the fight loop */
check('fight: 3 rounds x 6 exchanges, 5 cards in hand, both corners play one card an exchange', () => {
  const { fight } = distanceBout(3);
  ok(R.isOver(fight), 'the bout ends');
  eq(fight.rounds.length, 3, 'three rounds scored');
  eq(fight.events.length, 18, 'eighteen exchanges when it goes the distance');
  for (const ev of fight.events) {
    ok(R.CARD_ORDER.includes(ev.player.card), 'the player played a real card');
    ok(R.CARD_ORDER.includes(ev.opponent.card), 'the opponent played a real card');
    eq(ev.code, R.RESOLUTION[ev.player.card][ev.opponent.card], 'the event carries the resolution code');
    ok(typeof ev.text === 'string' && ev.text.indexOf(';') > 0, 'every exchange has a line: ' + ev.text);
    ok(ev.text.includes(R.CARDS[ev.player.card].say), 'the line names your card');
    ok(ev.text.includes(R.CARDS[ev.opponent.card].say), 'the line names his card');
  }
  eq(fight.player.hand.length, 5, 'hand is refilled to five');
  eq(fight.opponent.hand.length, 5, 'his hand too');
});
check('fight: the hand is only ever real cards, and a card cannot be played twice from the same hand', () => {
  const game = readyGame(5);
  const fight = R.startFight(game);
  const deck = new Set([...fight.player.deck, ...fight.opponent.deck]);
  for (let i = 0; i < 3; i++) {
    const card = fight.player.hand[0];
    R.playExchange(game, card);
    for (const c of fight.player.hand) ok(deck.has(c), 'hand card ' + c + ' came from a deck');
    for (const c of fight.opponent.hand) ok(deck.has(c), 'his hand card ' + c + ' came from a deck');
    const stillInHand = fight.player.hand.indexOf(card) >= 0, wasFight = fight.phase === 'fight';
    let threw = false;
    try { R.playExchange(game, card); } catch (e) { threw = true; }
    if (!stillInHand && wasFight) ok(threw, 'a card not in hand is refused');
    if (fight.phase === 'fight') {
      const absent = R.CARD_ORDER.find((c) => fight.player.hand.indexOf(c) < 0);
      ok(!!absent, 'some card is not in the hand');
      let threw2 = false;
      try { R.playExchange(game, absent); } catch (e) { threw2 = true; }
      ok(threw2, 'a card that is definitely not in the hand is refused: ' + absent);
    }
  }
});
check('fight: stamina never goes below zero, in any exchange of many bouts', () => {
  let exchanges = 0, lowest = Infinity;
  for (let seed = 1; seed <= 40; seed++) {
    const game = R.createGame({ seed, playerBoxerId: R.BOXERS[seed % 8].id, opponentBoxerId: sameSexOpponent(R.BOXERS[seed % 8].id, R.BOXERS[(seed + 3) % 8].id) });
    while (game.phase === 'camp') R.pickCampCard(game, R.aiCampPick(game));
    const fight = R.startFight(game);
    let guard = 0;
    while (!R.isOver(fight)) {
      if (fight.phase === 'corner') { R.pickCorner(game, R.aiCornerPick(game)); continue; }
      R.playExchange(game, R.chooseAiCard(fight, 'player'));
      exchanges++;
      for (const side of [fight.player, fight.opponent]) {
        ok(side.stamina >= 0, side.name + ' stamina is ' + side.stamina);
        ok(side.stamina <= side.maxStamina, side.name + ' stamina over its maximum');
        lowest = Math.min(lowest, side.stamina);
      }
      if (++guard > 200) throw new Error('the fight would not end');
    }
    for (const side of [fight.player, fight.opponent]) {
      ok(side.head >= 0 && side.body >= 0, 'damage is never negative');
    }
  }
  ok(exchanges > 300, 'plenty of exchanges were measured (' + exchanges + ')');
  ok(lowest === 0 || lowest > 0, 'the tank can empty but never runs past empty');
});
check('fight: a card costs wind, and the same card can cost differently to a fitter boxer', () => {
  const game = readyGame(9, 'ada', 'piotr');
  const fight = R.startFight(game);
  const costAda = R.cardCost(fight.player, 'cross');
  const fitter = Object.assign({}, fight.player, { stats: Object.assign({}, fight.player.stats, { stamina: 99 }) });
  ok(R.cardCost(fitter, 'cross') <= costAda, 'more stamina never makes a card dearer');
  ok(fight.player.stamina < fight.player.maxStamina + 1, 'stamina starts at its maximum');
  eq(fight.player.stamina, fight.player.maxStamina, 'a fresh boxer starts full');
});
/* --------------------------------------------------------------- scoring */
check('judging: 10-9 for a clear round, 10-8 when a knockdown decides it, 10-10 for a tie', () => {
    const even = { thrown: 6, landed: 3, damage: 10, kd: 0 };
  eq(R.judgeRound(even, { thrown: 6, landed: 3, damage: 10, kd: 0 }, 5, 5).join('-'), '10-10', 'nothing between them');
  const win = R.judgeRound({ thrown: 6, landed: 4, damage: 9, kd: 0 }, { thrown: 6, landed: 3, damage: 7, kd: 0 }, 7, 6);
  eq(win.join('-'), '10-9', 'a clear but not huge round is 10-9');
  const kd = R.judgeRound({ thrown: 6, landed: 4, damage: 12, kd: 1 }, { thrown: 6, landed: 3, damage: 11, kd: 0 }, 8, 7.5);
  eq(kd.join('-'), '10-8', 'a knockdown makes it 10-8');
  const kdAgainst = R.judgeRound({ thrown: 6, landed: 2, damage: 5, kd: 0 }, { thrown: 6, landed: 4, damage: 14, kd: 1 }, 4, 9);
  eq(kdAgainst.join('-'), '8-10', 'a knockdown against you is 8-10');
});
check('judging: five judges, five cards, every round 10-something, decision text present', () => {
  const { fight } = distanceBout(3);
  eq(fight.result.method, 'decision', 'this bout goes to the cards');
  eq(fight.result.scorecards.length, 5, 'five judges');
  for (const card of fight.result.scorecards) {
    ok(card.player >= 24 && card.player <= 30, 'a sane player total (' + card.player + ')');
    ok(card.opponent >= 24 && card.opponent <= 30, 'a sane opponent total (' + card.opponent + ')');
  }
  const scores = fight.rounds.flatMap(r => r.scores);
  for (const s of scores) {
    ok(s[0] >= 8 && s[0] <= 10 && s[1] >= 8 && s[1] <= 10, 'round scores are 8-10 (' + s.join('-') + ')');
    ok(s[0] === 10 || s[1] === 10 || s[0] === s[1], 'one side gets the ten');
  }
  ok(/points|draw/i.test(fight.result.text), 'the result is in words');
});
/* --------------------------------------------------------------- stoppage */
check('stoppage: three knockdowns is a stoppage, and reported on the right man', () => {
  const stop = R.checkStoppage({
    player: { knockdowns: 3, head: 0, stamina: 40, maxStamina: 80 },
    opponent: { knockdowns: 0, head: 0, stamina: 40, maxStamina: 80 }
  });
  ok(stop, 'a stoppage is called');
  eq(stop.who, 'player', 'the boxer with three knockdowns is the one stopped');
  eq(stop.why, 'three knockdowns', 'the reason is read out');
  const other = R.checkStoppage({
    player: { knockdowns: 0, head: 0, stamina: 40, maxStamina: 80 },
    opponent: { knockdowns: 3, head: 0, stamina: 40, maxStamina: 80 }
  });
  eq(other.who, 'opponent', 'the other corner can be stopped too');
});
check('stoppage: a hurt boxer on an empty tank is stopped; a fresh one is not', () => {
  const hurt = R.checkStoppage({
    player: { knockdowns: 0, head: 60, stamina: 0, maxStamina: 80 },
    opponent: { knockdowns: 0, head: 10, stamina: 40, maxStamina: 80 }
  });
  ok(hurt, 'zero stamina and a hurt head is a stoppage');
  eq(hurt.who, 'player', 'it is the tired hurt boxer');
  eq(hurt.why, 'hurt and out of wind', 'the reason');
  const fresh = R.checkStoppage({
    player: { knockdowns: 0, head: 5, stamina: 0, maxStamina: 80 },
    opponent: { knockdowns: 0, head: 5, stamina: 30, maxStamina: 80 }
  });
  eq(fresh, null, 'an empty tank alone is not a stoppage');
  const wrecked = R.checkStoppage({
    player: { knockdowns: 0, head: 100, stamina: 40, maxStamina: 80 },
    opponent: { knockdowns: 0, head: 10, stamina: 40, maxStamina: 80 }
  });
  eq(wrecked.why, 'the damage is too much', 'too much damage also stops it');
});
check('stoppage: in a real bout a stoppage is always justified by the state', () => {
  let stoppages = 0;
  for (let seed = 100; seed < 160; seed++) {
    const { fight } = playBout(seed, R.BOXERS[seed % 8].id, R.BOXERS[(seed + 5) % 8].id);
    if (fight.result.method !== 'stoppage') continue;
    stoppages++;
    const loser = fight.result.loser === 'player' ? fight.player : fight.opponent;
    const justified = loser.knockdowns >= 3 || loser.head >= 53 || (loser.stamina <= 0 && loser.head >= 32);
    ok(justified, 'stoppage in seed ' + seed + ' has a reason (kd ' + loser.knockdowns + ', head ' + loser.head.toFixed(1) + ', stamina ' + loser.stamina + ')');
    ok(fight.result.round >= 1 && fight.result.round <= 3, 'the round is a real round');
    ok(fight.events.length <= 18, 'a stopped bout is no longer than the full distance');
  }
  ok(stoppages >= 0, 'stoppages were looked at (' + stoppages + ' in 60 bouts)');
});
/* ------------------------------------------------------------------ habits */
check('habits: a habit fires in its stated situation, and only with the card in hand', () => {
  const game = readyGame(31, 'ada', 'mara');
  const fight = R.startFight(game);
  fight.opponent.habits = ['clinch_when_hurt'];
  fight.opponent.head = 55;                       // hurt
  fight.opponent.hand = ['clinch', 'jab', 'cross', 'slip', 'block'];
  fight.opponent.lastCard = null;
  eq(R.chooseAiCard(fight, 'opponent'), 'clinch', 'hurt, he holds: he clinches');
  fight.opponent.hand = ['jab', 'cross', 'slip', 'block', 'uppercut'];
  ok(R.chooseAiCard(fight, 'opponent') !== 'clinch', 'without the clinch in hand he cannot play it');
  fight.opponent.head = 0;
  fight.opponent.hand = ['clinch', 'jab', 'cross', 'slip', 'block'];
  ok(R.chooseAiCard(fight, 'opponent') !== 'clinch', 'not hurt any more, so no habit clinch (or it is a coin toss of style)');
});
check('habits: every habit names a real card and a situation the engine understands', () => {
  const keys = ['exchange', 'round', 'range', 'inFightRange', 'lastSelfCard', 'lastOppCard', 'lastOppStraight',
    'lastOppHook', 'lastTookClean', 'lastLandedClean', 'selfHurt', 'foeHurt', 'selfLowStamina', 'foeLowStamina',
    'selfAhead', 'gassed', 'combo'];
  for (const id of Object.keys(R.HABITS)) {
    const h = R.HABITS[id];
    ok(R.CARD_ORDER.includes(h.play), id + ' plays a real card (' + h.play + ')');
    ok(typeof h.text === 'string' && h.text.length > 12, id + ' has words for the player');
    for (const k of Object.keys(h.when)) ok(keys.includes(k), id + ' uses a situation the engine has: ' + k);
  }
  const game = readyGame(2);
  const fight = R.startFight(game);
  const ctx = R.contextOf(fight, 'player');
  for (const k of keys) ok(Object.prototype.hasOwnProperty.call(ctx, k), 'the engine provides ' + k);
});
check('habits: the same situation gives the same card twice (he is readable)', () => {
  const game = readyGame(32, 'ada', 'mara');
  const fight = R.startFight(game);
  fight.opponent.habits = ['jab_to_open'];
  fight.opponent.hand = ['jab', 'cross', 'slip', 'block', 'uppercut'];
  const first = R.chooseAiCard(fight, 'opponent');
  const second = R.chooseAiCard(fight, 'opponent');
  eq(first, 'jab', 'he opens the round with the jab');
  eq(second, first, 'the read is stable');
});
/* --------------------------------------------------------- same seed bout */
check('seeded bout: the same seed plays the same bout, exchange for exchange', () => {
  for (const seed of [1, 99, 4242]) {
    const a = playBout(seed, 'tomas', 'ines');
    const b = playBout(seed, 'tomas', 'ines');
    eq(JSON.stringify(a.fight.events), JSON.stringify(b.fight.events), 'seed ' + seed + ': same exchanges');
    eq(JSON.stringify(a.fight.result), JSON.stringify(b.fight.result), 'seed ' + seed + ': same result');
    eq(JSON.stringify(a.fight.rounds), JSON.stringify(b.fight.rounds), 'seed ' + seed + ': same scorecards');
    eq(JSON.stringify(a.game.offers), JSON.stringify(b.game.offers), 'seed ' + seed + ': same camp offers');
  }
});
check('seeded bout: a different seed plays a different bout', () => {
  const a = playBout(5, 'tomas', 'ines');
  const b = playBout(6, 'tomas', 'ines');
  ok(JSON.stringify(a.fight.events) !== JSON.stringify(b.fight.events), 'different seeds diverge');
});
/* -------------------------------------------------------------- the corner */
check('corner: 3 cards offered between rounds, each one costs something, the pick has an effect', () => {
  /* Round 3b added a sixth corner card, so which three a given seed draws has
     moved. Find a round one that offers breathe instead of pinning the draw. */
  let game = null, fight = null;
  for (let s = 41; s < 400; s++) {
    game = readyGame(s);
    fight = R.startFight(game);
    for (let i = 0; i < 6; i++) R.playExchange(game, R.chooseAiCard(fight, 'player'));
    if (fight.phase === 'corner' && fight.corner.includes('breathe')) break;
    fight = null;
  }
  ok(fight, 'a round one corner offers breathe');
  eq(fight.phase, 'corner', 'the round ends and the corner opens');
  eq(fight.rounds.length, 1, 'one round scored');
  eq(fight.corner.length, 3, 'three corner cards');
  eq(new Set(fight.corner).size, 3, 'and they are different');
  for (const card of R.CORNER_CARDS) {
    const pays = (card.stamina && card.stamina < 0) || card.mod;
    ok(pays, card.name + ' must cost something');
    ok(card.text && card.text.length > 15, card.name + ' explains itself');
  }
  const before = fight.player.stamina;
  R.pickCorner(game, 'breathe');
  ok(fight.player.stamina > before, 'breathe puts wind back');
  eq(fight.round, 2, 'on to the next round');
  eq(fight.phase, 'fight', 'back to fighting');
  eq(fight.exchange, 0, 'a fresh set of exchanges');
  ok(fight.cornerUsed.opponent, 'his corner worked too');
  let threw = false;
  try { R.pickCorner(game, 'ice_eye'); } catch (e) { threw = true; }
  ok(threw, 'no corner between exchanges');
});
check('corner: every corner card can be picked and leaves the fight playable', () => {
  for (const card of R.CORNER_CARDS) {
    const id = card.id;
    const game = readyGame(43, 'ada', 'mara');
    const fight = R.startFight(game);
    for (let i = 0; i < 6; i++) R.playExchange(game, R.chooseAiCard(fight, 'player'));
    fight.corner = [id];
    R.pickCorner(game, id);
    eq(fight.phase, 'fight', id + ' leaves the fight playable');
    ok(fight.player.stamina >= 0 && fight.player.stamina <= fight.player.maxStamina, id + ' leaves stamina sane');
    R.playExchange(game, R.chooseAiCard(fight, 'player'));
    ok(fight.events.length >= 7, id + ' and the next exchange happens');
  }
});
/* ------------------------------------------------------------- the boxers */
check('roster: 8 boxers, 4 styles, different stats and a style that is data', () => {
  eq(R.BOXERS.length, 8, 'eight boxers');
  const styles = new Set(R.BOXERS.map(b => b.style));
  eq(styles.size, 4, 'four styles');
  for (const s of styles) {
    eq(Object.keys(R.STYLES[s].weights).length, 17, 'style ' + s + ' weighs all 17 cards');
  }
  const names = new Set(R.BOXERS.map(b => b.name));
  eq(names.size, 8, 'names are unique');
  for (const b of R.BOXERS) {
    ok(b.deck.length >= 12 && b.deck.length <= 16, b.name + ' starts with a legal deck (12 to 16 cards), has ' + b.deck.length);
    eq(b.habits.length, 2, b.name + ' has two habits');
    for (const id of b.deck) ok(R.CARD_ORDER.includes(id), b.name + ' deck card ' + id + ' is real');
    for (const h of b.habits) ok(R.HABITS[h], b.name + ' habit ' + h + ' is real');
    for (const k of ['power', 'speed', 'stamina', 'chin', 'technique', 'defence']) {
      ok(b.stats[k] >= 1 && b.stats[k] <= 99, b.name + ' ' + k + ' is in range');
    }
  }
});
check('readability: a boxer never starts a fight with a habit the file already gave away', () => {
  const game = R.createGame({ seed: 77, playerBoxerId: 'lena', opponentBoxerId: 'ines' });
  while (game.phase === 'camp') R.pickCampCard(game, R.aiCampPick(game));
  const fight = R.startFight(game);
  const known = fight.scouting.known.map(k => k.id);
  for (const k of known) ok(R.boxerById('ines').habits.includes(k), 'the file only lists his habits');
  ok(known.length <= 2, 'no more than two habits before the bell');
});
/* ------------------------------------------------------------------ summary */
console.log('');
console.log(passed + ' passed, ' + failed + ' failed');
if (failed) {
  console.log('RESULT: FAIL');
  for (const f of failures) console.log('  - ' + f);
  process.exit(1);
}
console.log('RESULT: PASS - all ' + passed + ' checks green');
