// Round 2 regression checks; loaded by rules.test.mjs so the brief's command runs everything.
import R from './rules.js';
let passed = 0, failed = 0;
function check(name, fn) { try { fn(); passed++; console.log('PASS  ' + name); } catch (e) { failed++; console.log('FAIL  ' + name + '\n      ' + e.message); } }
function ok(value, message) { if (!value) throw new Error(message || 'expected true'); }
function eq(a, b, message) { if (a !== b) throw new Error((message || 'not equal') + ' (got ' + JSON.stringify(a) + ', want ' + JSON.stringify(b) + ')'); }
function near(a, b, tolerance, message) { if (Math.abs(a - b) > tolerance) throw new Error((message || 'not near') + ' (got ' + a + ', want ' + b + ' +/- ' + tolerance + ')'); }
function sameSexOpponent(id, preferred) { const me = R.boxerById(id), b = R.boxerById(preferred); return b && b.id !== id && b.pronoun === me.pronoun ? b.id : R.BOXERS.find(x => x.id !== id && x.pronoun === me.pronoun).id; }
function readyGame(seed, me = 'ada', foe = 'mara') { const game = R.createGame({ seed, playerBoxerId: me, opponentBoxerId: sameSexOpponent(me, foe) }); while (game.phase === 'camp') R.pickCampCard(game, R.aiCampPick(game)); return game; }

check('public scouting changes the AI decision without reading the opponent hand', () => {
  const fight = R.startFight(readyGame(1, 'ada', 'mara'));
  fight.player.habits = []; fight.player.hand = ['jab', 'cross', 'lead_hook', 'slip', 'block'];
  fight.player.lastCard = 'lead_hook'; fight.scouting.known = [];
  const cold = R.chooseAiCard(fight, 'player');
  fight.scouting.known = [{ id: 'roll_the_hooks', text: R.HABITS.roll_the_hooks.text }];
  const read = R.chooseAiCard(fight, 'player');
  eq(cold, 'lead_hook', 'without film the style policy chooses its usual card');
  eq(read, 'cross', 'the public hook-roll read changes the answer');
  const chance = R.scoutingPrediction(fight)[0].chance;
  fight.opponent.hand = ['jab', 'jab', 'jab', 'jab', 'jab'];
  eq(R.scoutingPrediction(fight)[0].chance, chance, 'the AI estimate does not inspect the opponent hand');
});

check('opponent counter-weights cards repeated twice in your last three exchanges', () => {
  const fight = R.startFight(readyGame(31, 'ada', 'mara'));
  fight.opponent.habits = []; fight.opponent.hand = ['jab', 'cross', 'lead_hook', 'slip', 'block'];
  fight.events = [];
  const before = R.chooseAiCard(fight, 'opponent');
  fight.events = [1, 2, 3].map(() => ({ player: { card: 'jab' } }));
  const after = R.chooseAiCard(fight, 'opponent');
  eq(before, 'cross', 'style-only answer');
  eq(after, 'lead_hook', 'repeated jabs draw a counter');
});

check('a losing Jab does not earn the next-punch setup', () => {
  const game = readyGame(714), fight = R.startFight(game);
  fight.range = 'inside'; fight.player.stats.technique = 99;
  fight.player.hand = ['jab', 'cross', 'lead_hook', 'slip', 'block'];
  fight.opponent.hand = ['uppercut']; fight.opponent.habits = [];
  const ev = R.playExchange(game, 'jab');
  eq(ev.player.code, 'l', 'the Jab loses to an inside Uppercut');
  eq(fight.player.combo, false, 'a lost Jab grants no setup');
});

check('habits: every signature appears at least three times in the fight deck', () => {
  for (const boxer of R.BOXERS) {
    const game = readyGame(712, boxer.id, R.BOXERS.find(b => b.id !== boxer.id).id);
    const fight = R.startFight(game);
    for (const id of boxer.habits) {
      const signature = R.HABITS[id].play;
      const deckCount = fight.player.deck.filter(card => card === signature).length;
      const baseCount = boxer.deck.filter(card => card === signature).length;
      eq(deckCount, Math.max(baseCount + (game.mods.add[signature] || 0), 3), boxer.name + ' has at least three ' + signature + ' signature cards');
    }
  }
});

check('context: ahead means more damage dealt, not more damage taken', () => {
  const game = readyGame(701);
  const fight = R.startFight(game);
  fight.player.head = 25; fight.opponent.head = 0;
  fight.player.totals.damage = 4; fight.opponent.totals.damage = 12;
  eq(R.contextOf(fight, 'player').selfAhead, false, 'the boxer who took more damage is not ahead');
  fight.player.totals.damage = 20; fight.opponent.totals.damage = 12;
  eq(R.contextOf(fight, 'player').selfAhead, true, 'the boxer who dealt more damage is ahead');
});

check('scouting: live prediction shows active condition and hand odds without reading hidden hand', () => {
  const game = readyGame(702, 'ada', 'mara');
  const fight = R.startFight(game);
  fight.scouting.known = [{ id: 'clinch_when_hurt', text: R.HABITS.clinch_when_hurt.text }];
  fight.opponent.head = 45;
  const a = R.scoutingPrediction(fight)[0];
  eq(a.card, 'clinch', 'the film names the signature');
  eq(a.active, true, 'the current hurt condition is active');
  ok(a.chance > 0 && a.chance < 1, 'signature-in-hand chance is uncertain');
  const chance = a.chance;
  fight.opponent.hand = ['jab', 'jab', 'jab', 'jab', 'jab'];
  eq(R.scoutingPrediction(fight)[0].chance, chance, 'changing hidden hand does not alter the estimate');
});

check('tell chips have the promised blind/one-habit/two-habit reliability', () => {
  const results = [];
  for (const count of [0, 1, 2]) {
    let right = 0;
    for (let seed = 1; seed <= 500; seed++) {
      const game = readyGame(seed + count * 1000, 'ada', 'mara'), fight = R.startFight(game);
      fight.scouting.known = fight.opponent.habits.slice(0, count).map(id => ({ id, text: R.HABITS[id].text }));
      R.refreshTell(fight);
      if (fight.tell.card === fight.foePlan) right++;
      eq(fight.tell.accuracy, [0.55, 0.70, 0.85][count], 'the displayed tell confidence matches film');
    }
    results.push(right / 500);
  }
  for (let i = 0; i < 3; i++) ok(Math.abs(results[i] - [0.55, 0.70, 0.85][i]) < 0.08, 'tell sample is calibrated: ' + results[i].toFixed(2));
});

check('range matchup overrides remain anti-symmetric and resolve the listed reads', () => {
  eq(R.resolutionAt('cross', 'jab', 'mid'), 'w', 'cross beats jab at mid');
  eq(R.resolutionAt('jab', 'cross', 'mid'), 'l', 'the reverse is a loss');
  eq(R.resolutionAt('jab', 'uppercut', 'out'), 'w', 'jab catches the out-range uppercut');
  eq(R.resolutionAt('uppercut', 'jab', 'out'), 'l', 'the uppercut misses the jab outside');
  eq(R.resolutionAt('slip', 'uppercut', 'inside'), 'X', 'slipping into an uppercut is countered');
  eq(R.resolutionAt('uppercut', 'slip', 'inside'), 'W', 'the uppercut crushes the slip');
  eq(R.resolutionAt('lead_hook', 'pivot_out', 'mid'), 'w', 'lead hook catches the pivot');
  eq(R.resolutionAt('pivot_out', 'lead_hook', 'mid'), 'l', 'pivot loses to lead hook');
  for (const range of ['out', 'mid', 'inside']) for (const a of R.CARD_ORDER) for (const b of R.CARD_ORDER)
    eq(R.resolutionAt(b, a, range), R.FLIP[R.resolutionAt(a, b, range)], range + ' matchup flips: ' + a + ' v ' + b);
});

check('habit signature fires about 70% when true and held', () => {
  const game = readyGame(712), fight = R.startFight(game);
  const side = fight.opponent, ctx = R.contextOf(fight, 'opponent');
  side.habits = ['jab_to_open']; side.hand = ['jab', 'cross'];
  let fired = 0;
  for (let seed = 1; seed <= 1000; seed++) {
    if (R.habitCard(side, ctx, R.makeRng(seed)) === 'jab') fired++;
  }
  ok(fired > 650 && fired < 750, 'fired ' + fired + ' times of 1000');
});

check('a fresh boxer cannot be knocked down on the opening exchange', () => {
  const game = readyGame(713), fight = R.startFight(game);
  fight.player.hand = ['cross', 'jab', 'lead_hook', 'slip', 'block'];
  fight.opponent.hand = ['jab']; fight.opponent.habits = [];
  const ev = R.playExchange(game, 'cross');
  eq(ev.knockdowns.length, 0, 'fresh R1 exchange one is protected from a knockdown');
});

check('fight RNG: hit draws cannot perturb shuffles or knockdown draws', () => {
  const a = R.startFight(readyGame(711)), b = R.startFight(readyGame(711));
  for (let i = 0; i < 50; i++) a.hitRng.next();
  eq(a.shuffleRng.next(), b.shuffleRng.next(), 'shuffle stream is independent');
  eq(a.knockdownRng.next(), b.knockdownRng.next(), 'knockdown stream is independent');
  eq(a.judgeRng.next(), b.judgeRng.next(), 'judging stream is independent');
});

check('exchange choice: a correct prediction costs extra wind and resolves as a clean win', () => {
  const game = readyGame(706, 'ada', 'mara'), fight = R.startFight(game);
  fight.scouting.known = [{ id: 'jab_to_open', text: R.HABITS.jab_to_open.text }];
  fight.opponent.hand = ['jab']; fight.opponent.habits = ['jab_to_open'];
  const cost = R.cardCost(fight.player, 'cross') + 2, before = fight.player.stamina;
  const ev = R.playExchange(game, 'cross', 'predict');
  eq(ev.forecast, 'jab', 'the opening habit is the public forecast');
  eq(ev.correctRead, true, 'the read matched'); eq(ev.code, 'W', 'a correct read wins cleanly');
  eq(before - fight.player.stamina, cost, 'prediction spends two extra wind');
});

check('exchange choice: a wrong prediction gives the opponent the next outcome step', () => {
  const game = readyGame(707, 'ada', 'mara'), fight = R.startFight(game);
  fight.player.hand = ['cross', 'jab', 'slip', 'block', 'pivot_out'];
  fight.opponent.hand = ['cross']; fight.opponent.habits = [];
  const forecast = R.predictedCard(fight);
  if (forecast === 'cross') throw new Error('fixture needs a different public forecast');
  const ev = R.playExchange(game, 'cross', 'predict');
  eq(ev.correctRead, false, 'the player guessed wrong');
  eq(ev.actualCode, 't', 'cross against cross is normally a trade');
  eq(ev.opponent.code, 'w', 'the wrong read exposes the player');
});

check('defence pays in position or wind, never damage; only the exchange winner moves range', () => {
  const game = readyGame(708, 'ada', 'mara'), fight = R.startFight(game);
  fight.player.hand = ['slip', 'jab', 'block', 'roll', 'pivot_out'];
  fight.opponent.hand = ['cross']; fight.opponent.habits = [];
  const ev = R.playExchange(game, 'slip');
  eq(ev.player.dealt, 0, 'a winning Slip does not score damage');
  eq(fight.player.opening, true, 'a winning Slip creates the next-punch opening');
  const rangeGame = readyGame(709, 'ada', 'mara'), rangeFight = R.startFight(rangeGame);
  rangeFight.player.hand = ['step_back', 'jab', 'cross', 'block', 'slip'];
  rangeFight.opponent.hand = ['jab']; rangeFight.opponent.habits = [];
  const lost = R.playExchange(rangeGame, 'step_back');
  eq(lost.player.code, 'l', 'step back loses to the following jab');
  eq(rangeFight.range, 'mid', 'a losing chip hit does not move range');
});

check('referee: two consecutive clinches warn; the third costs a round point', () => {
  const game = readyGame(710, 'ada', 'mara'), fight = R.startFight(game);
  fight.opponent.hand = ['jab']; fight.opponent.habits = [];
  fight.player.hand = ['clinch', 'jab', 'cross', 'slip', 'block'];
  R.playExchange(game, 'clinch');
  fight.player.hand = ['clinch', 'jab', 'cross', 'slip', 'block'];
  const second = R.playExchange(game, 'clinch');
  fight.player.hand = ['clinch', 'jab', 'cross', 'slip', 'block'];
  const third = R.playExchange(game, 'clinch');
  ok(second.referee.some(line => line.includes('warning')), 'the second clinch warns');
  ok(third.referee.some(line => line.includes('lose a point')), 'the third clinch deducts');
  eq(fight.player.round.deductions, 1, 'one point is charged to this round');
});

check('corner: gloves high applies the promised 15% punch damage reduction for the next round', () => {
  function run(gloves) {
    const game = readyGame(703, 'ada', 'mara');
    const fight = R.startFight(game);
    fight.player.hand = ['cross', 'jab', 'slip', 'block', 'pivot_out'];
    fight.opponent.hand = ['jab', 'jab', 'jab', 'jab', 'jab'];
    if (gloves) fight.player.mods.punch = -0.15;
    return R.playExchange(game, 'cross').player.dealt;
  }
  near(run(true), run(false) * 0.85, 1e-9, 'punch damage is multiplied by 0.85');
});

check('corner: change the plan draws two extra cards for both corners', () => {
  const game = readyGame(704);
  const fight = R.startFight(game);
  for (let i = 0; i < 6 && fight.phase === 'fight'; i++) R.playExchange(game, fight.player.hand[0]);
  if (fight.phase !== 'corner') throw new Error('expected the corner');
  fight.corner = ['change_plan']; fight.foeCorner = ['change_plan']; fight.foeCornerPick = 'change_plan';
  R.pickCorner(game, 'change_plan');
  eq(fight.player.hand.length, 7, 'player keeps two extra choices');
  eq(fight.opponent.hand.length, 7, 'opponent gets the same two extra choices');
});

check('corner: study is replaced when both habits are already known', () => {
  const game = readyGame(705);
  const fight = R.startFight(game);
  fight.scouting.known = fight.opponent.habits.map(id => ({ id, text: R.HABITS[id].text }));
  fight.exchange = 5;
  R.playExchange(game, fight.player.hand[0]);
  if (fight.phase !== 'corner') throw new Error('expected the corner');
  ok(!fight.corner.includes('study'), 'no useless Study offer');
  ok(!fight.foeCorner.includes('study'), 'the opponent cannot waste a corner pick studying an unavailable file');
  eq(new Set(fight.corner).size, 3, 'replacement keeps three distinct choices');
});

check('house rule: bouts only pair same-sex boxers', () => {
  for (const boxer of R.BOXERS) {
    for (let seed = 1; seed <= 20; seed++) {
      const game = R.createGame({ seed, playerBoxerId: boxer.id });
      eq(R.boxerById(game.opponentBoxerId).pronoun, boxer.pronoun, boxer.name + ' gets a same-sex opponent');
    }
  }
  let refused = false;
  try { R.createGame({ seed: 1, playerBoxerId: 'ada', opponentBoxerId: 'tomas' }); } catch (_) { refused = true; }
  ok(refused, 'an explicit cross-sex pairing is rejected');
});
if (failed) { console.log('RESULT: FAIL - round 2 (' + failed + ' failed)'); process.exit(1); }
console.log('RESULT: PASS - round 2 (' + passed + ' checks green)');
