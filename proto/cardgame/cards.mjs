// CARDSCOPE5 greybox data, ROUND 9 (TASK_CARDROUND9): every number, card and deck, and the moves' own rows. Each fighter
// has his own place now (board.mjs); a card names the place it works at in words in the page and in board.mjs's keys
// here: K kick range, P punch range, C the clinch, over = standing over a man who is down, gt = in his guard on top,
// gb = in his guard underneath, past = past his guard on top, pin = pinned underneath him, down = on the floor and apart.
// Every card carries `real`: the CARDREAL_AUDIT row it follows (the REAL-FIGHT gate of this round).
import SIZED_DATA from './sized.json' with { type: 'json' };
export const N = {
  mode: 'wind', // round 4 decided: one wind pool (the limb arms stay in the code and are not re-run)
  hp: 30, cap: 6, back: 3, heldBack: 2, tighten: 1, start: 4, stool: 2, hand: 5, turns: 5, rounds: 2,
  lead: 8, counter: 3, block: 4, cover: 2, tiein: 3, coverW: 1, stepW: 1, pullW: 1, standW: 1, minW: 1, upW: 3, cycle: 1, redraw: 1, drainCap: 1,
  comboDmg: 5, comboPts: 2, catchPts: 2, headlockPts: 1, dmgPer: 5, stallMax: 2, copies: 3, own: 12,
  clkPts: 1, clkHold: 1, holdRoll: 0, riseDmg: 3, surcharge: 1, timidAt: 3, warnAt: 2,
  // ROUND 9b (audit section 9), FIRST GUESSES, reported and not tuned: the no-card answers' wind, the no-card up-kick's
  // damage, the knockdown (a punch for kdDmg or more that leaves him at kdHp or under), the stoppage (tkoTurns turns)
  frameW: 1, baseW: 2, escW: 2, kickW: 2, kickDmg: 2, kdDmg: 6, kdHp: 10, tkoTurns: 2,
  // S548 MEASURED (400 bot bouts, docs/CARDROUND9B_RESULT.md). Keep your base has two halves:
  //  - against a PULL (baseOn): ON, and only for a man who threw no punch in his last turn (the owner's 'weaker version').
  //    Measured harmless: boxing stays 44.5%; the bot never pays for it (0 of 400), a player can.
  //  - against a SWEEP (baseSweep): OFF. It is the half that broke the pairing - always there: boxing 99.5%; only after a
  //    turn with no punch: 69.3% (gate 40-60). A sweep is the jiu-jitsu man's one way up from his back.
  //  - the no-card escape from a hold as it is laid (escOn): OFF - holds laid fall from 0.28 a bout to 0.
  baseOn: 1, baseSweep: 0, escOn: 0,
};
// limbs: a lead arm, A rear arm, l lead leg, L rear leg, h hips; x any arm, y any leg
const K = ['K'], P = ['P'], C = ['C'], PC = ['P', 'C'], KP = ['K', 'P'], KPC = ['K', 'P', 'C'];
const at = (p, ...gs) => (gs.length ? { p, gs } : p);
const S = (n, st, w, L, at, dmg, zone, x = {}) => ({ n, st, k: 'strike', w, L, at, dmg, zone, ...x });
const T = (n, st, w, L, at, to, pts, x = {}) => ({ n, st, k: 'shot', w, L, at, to, pts, ...x });
const H = (n, st, w, L, at, count, hk, x = {}) => ({ n, st, k: 'hold', w, L, at, count, hk, ...x });
const A = (n, st, w, L, fx, vs, x = {}) => ({ n, st, k: 'ans', w, L, fx, vs, ...x });
export const CARDS = {
  // shared core: two Sprawls and one Escape in every deck
  sprawl: A('Sprawl', 'core', 1, 'hL', 'sprawl', 'a takedown, a grip or a pull as it is laid', { real: '2b Sprawl REAL; M10 the sprawl against the pull' }),
  escape: A('Escape', 'core', 1, 'h', 'escape', 'a hold or a pass as it is laid; played in your turn: recover guard', { act: 'recover', real: '2b Escape (WRONG fixed: stays on the ground, the holder one layer back); 4c Escape' }),
  // boxing: owns PUNCH. own mechanic: combinations (the jab steps in from KICK by itself; a punch laid behind a punch
  // costs 1 less; the short punches - hook, body hook, uppercut - also work inside, in the CLINCH; jab, cross, hook
  // clean in order = the finisher). The cross is also the punch down (half damage) and the ground punch; the hook is a
  // ground punch too (M11, M12 - rules hung on the cards the boxer already holds, not new cards)
  jab: S('Jab', 'boxing', 1, 'a', P, 2, 'head', { enter: 1, real: '2b Jab REAL' }),
  cross: S('Cross', 'boxing', 2, 'A', P, 5, 'head', { pts: 1, punchDown: 1, real: '2b Cross REAL; M12 punch down (half damage)' }),
  hook: S('Lead hook', 'boxing', 2, 'hl', P, 5, 'head', { pts: 1, inside: 1, punchDown: 1, real: '2b Lead hook REAL; M11 ground punch' }),
  bodyhook: S('Body hook', 'boxing', 2, 'ah', P, 3, 'body', { drain: 1, inside: 1, real: '2b Body hook REAL' }),
  upper: S('Uppercut', 'boxing', 3, 'Ah', P, 7, 'head', { pts: 1, unblock: 1, inside: 1, real: '2b Uppercut REAL' }),
  slip: A('Slip', 'boxing', 2, 'h', 'slip', 'a punch: it misses, your next punch +4', { real: '2b Slip REAL' }),
  block: A('Block', 'boxing', 1, 'x', 'block', 'a strike: 6 off', { real: '2b Block REAL' }),
  // kickboxing (owner S538): stands and trades across KICK, PUNCH and CLINCH; no takedowns, no ground. own mechanic:
  // hands and feet (his kicks land from PUNCH range too and he stays there to trade; a strike of another kind than his
  // last costs 1 less and carries him in by itself). The low kick hurts the leg: 1 wind, and his steps cost 1 more
  onetwo: S('One-two', 'kickboxing', 2, 'aA', P, 4, 'head', { pts: 1, real: '2c One-two REAL' }),
  kbhook: S('Left hook', 'kickboxing', 2, 'hl', P, 4, 'head', { real: '2c Left hook REAL' }),
  lowkick: S('Low kick', 'kickboxing', 1, 'L', KP, 2, 'leg', { kick: 1, cripple: 1, real: '2c Low kick REAL' }),
  bodykick: S('Body kick', 'kickboxing', 2, 'Lh', K, 4, 'body', { kick: 1, pts: 1, real: '2c Body kick REAL' }),
  highkick: S('High kick', 'kickboxing', 3, 'Lh', K, 6, 'head', { kick: 1, pts: 2, real: '2c High kick REAL' }),
  knee: S('Knee', 'kickboxing', 2, 'lh', C, 5, 'body', { pts: 1, kneeC: 1, real: '2c Knee REAL' }),
  check: A('Check', 'kickboxing', 1, 'y', 'check', 'a kick: it misses, your next strike +counter', { real: '2c Check REAL' }),
  // karate: owns KICK. own mechanic: in-and-out (the punch blitzes in from KICK, a kick thrown from PUNCH springs back
  // out, a strike that changes the range costs 1 less, a volley that is not stopped ends back at KICK)
  frontkick: S('Front kick', 'karate', 1, 'l', K, 2, 'body', { kick: 1, pts: 1, real: '2c Front kick REAL' }),
  roundhouse: S('Roundhouse', 'karate', 2, 'Lh', K, 4, 'body', { kick: 1, pts: 2, real: '2c Roundhouse REAL' }),
  headkick: S('Head kick', 'karate', 3, 'Lh', K, 6, 'head', { kick: 1, pts: 3, drain: 1, real: '2c Head kick REAL' }),
  legkick: S('Leg kick', 'karate', 1, 'L', KP, 2, 'leg', { kick: 1, cripple: 1, real: '2c Leg kick REAL' }),
  revpunch: S('Reverse punch', 'karate', 2, 'A', P, 4, 'head', { pts: 1, blitz: 1, real: '2c Reverse punch REAL' }),
  evade: A('Step off', 'karate', 2, 'y', 'evade', 'a strike, or a takedown that is not clean: it misses and you are back at KICK', { real: '2c Step off REAL' }),
  // judo: owns the CLINCH. own mechanic: the grip (no throw without it; a stood grip makes the answer 1 wind dearer,
  // never impossible - audit 2d). All three throws land at side control: to 2 (audit 2c)
  grip: { n: 'Grip', st: 'judo', k: 'setup', w: 1, L: 'aA', at: KPC, real: '2c Grip REAL (judo reaches the collar tie from kicking range, at punching range, or inside the clinch)' },
  hipthrow: T('Hip throw', 'judo', 2, 'hL', C, 2, 4, { dmg: 3, needGrip: 1, real: '2c Hip throw WRONG fixed: to 2 (side control)' }),
  footsweep: T('Foot sweep', 'judo', 1, 'l', C, 2, 2, { needGrip: 1, real: '2c Foot sweep WRONG fixed: to 2' }),
  shoulderthrow: T('Shoulder throw', 'judo', 3, 'aAh', C, 2, 6, { dmg: 4, needGrip: 1, real: '2c Shoulder throw WRONG fixed: to 2' }),
  pin: H('Hold-down', 'judo', 2, 'aAh', [at('past', 'side', 'mount')], 2, 'pin', { hpts: 2, tick: 2, brk: 5, real: '2c Hold-down WRONG fixed: side control or mount only, never the back' }),
  armlock: H('Armlock', 'judo', 2, 'aA', ['past'], 2, 'sub', { brk: 6, real: '2c Armlock REAL' }),
  tiein: A('Tie in', 'judo', 1, 'x', 'tiein', 'a strike: 1 off and you are in the CLINCH', { real: '2c Tie in REAL' }),
  // wrestling: decides where the bout is. own mechanic: chain wrestling (his shot travels from any standing range; a
  // stuffed shot leaves him tied up in the CLINCH). No takedown is unanswerable (audit 2d: a stood tie makes the answer
  // 1 wind dearer)
  double: T('Double leg', 'wrestling', 2, 'aALh', C, 1, 2, { cleanIf: 'tie', real: '2c Double leg REAL' }),
  single: T('Single leg', 'wrestling', 1, 'aAl', C, 0, 2, { cleanIf: 'tie', real: '2c Single leg REAL' }),
  slam: T('Body lock slam', 'wrestling', 3, 'aAhL', C, 0, 4, { dmg: 4, cleanIf: 'tie', real: '2c Body lock slam REAL' }),
  gnp: S('Ground strikes', 'wrestling', 2, 'A', ['gt', 'past'], 4, 'head', { pts: 1, real: '2c Ground strikes REAL; M11' }),
  fall: H('The fall', 'wrestling', 2, 'aAh', ['gt', 'past'], 2, 'pin', { hpts: 4, tick: 1, brk: 6, real: '2c The fall REAL' }),
  ride: { n: 'Ride', st: 'wrestling', k: 'adv', w: 1, L: 'h', at: ['gt', 'past'], pts: 1, real: '2c Ride REAL' },
  headlock: A('Front headlock', 'wrestling', 1, 'hL', 'headlock', 'a takedown: it is stuffed', { real: '2c Front headlock MISSING-LINK: it snaps a shot down, the knees are out of scope (M18)' }),
  // bjj: owns the GROUND, on top and underneath. own mechanic: the guard. ROUND 9: Tie up is the clinch entry a pull
  // needs (M9); the Up-kick is the reason a standing man respects the feet (M5); the Sweep is the risk of standing out
  // of the guard (M8)
  tieup: { n: 'Tie up', st: 'bjj', k: 'setup', w: 1, L: 'aA', at: KPC, tie: 1, real: '4c Tie up (new card); M9 a pull needs a grip' },
  sweep: T('Sweep', 'bjj', 2, 'lLh', [at('gb', 'closed', 'half')], 2, 2, { sweep: 1, real: '2c Sweep REAL; 4c sweep from the guard (mount) and against a standing man (M8)' }),
  pass: { n: 'Guard pass', st: 'bjj', k: 'adv', w: 2, L: 'aAh', at: ['gt', 'past'], pts: 2, real: '2c Guard pass REAL' },
  triangle: H('Triangle', 'bjj', 2, 'lLh', [at('gb', 'closed')], 3, 'sub', { brk: 6, real: '2c Triangle REAL; 4c an arm attack answers the stand-up' }),
  armbar: H('Armbar', 'bjj', 2, 'aAh', [at('gb', 'closed'), 'past'], 2, 'sub', { brk: 6, real: '2c Armbar REAL; 4c an arm attack answers the stand-up' }),
  choke: H('Rear choke', 'bjj', 2, 'aA', [at('past', 'back')], 1, 'sub', { brk: 7, real: '2c Rear choke REAL' }),
  kimura: H('Kimura', 'bjj', 2, 'aA', [at('gb', 'half'), at('gt', 'half'), at('past', 'side')], 2, 'sub', { brk: 5, real: '2c Kimura REAL; 4c from the half guard' }),
  upkick: S('Up-kick', 'bjj', 1, 'y', ['down'], 3, 'head', { kick: 1, up: 1, real: '4c Up-kick (new card); M5, rule 3: only at a STANDING man in leg range' }),
  // sambo: punch, throw, lock in one go. own mechanic: punch-to-throw-to-lock (his throw goes from PUNCH range, off the
  // exchange; laid right behind his own punch the answer costs 1 more, never nothing; and his hold may be laid in the
  // same volley right behind the throw)
  sthrow: T('Sambo throw', 'sambo', 2, 'aAh', C, 0, 3, { dmg: 2, real: '2c Sambo throw MISSING-LINK: from PUNCH only behind his own punch, and answerable' }),
  trip: T('Leg trip', 'sambo', 1, 'l', C, 1, 1, { real: '2c Leg trip REAL' }),
  kneebar: H('Knee bar', 'sambo', 2, 'aAl', ['G'], 2, 'sub', { leg: 1, brk: 6, real: '2c Knee bar REAL' }),
  anklelock: H('Ankle lock', 'sambo', 1, 'aA', ['G'], 3, 'sub', { leg: 1, brk: 5, real: '2c Ankle lock REAL' }),
  casualpin: H('Chest hold', 'sambo', 2, 'aAh', ['past'], 2, 'pin', { hpts: 2, tick: 1, brk: 4, real: '2c Chest hold REAL' }),
  overhand: S('Overhand', 'sambo', 2, 'A', P, 5, 'head', { pts: 1, real: '2c Overhand REAL' }),
  catchkick: A('Catch the kick', 'sambo', 1, 'x', 'catch', 'a kick: it misses and he is taken down', { real: '2c Catch the kick REAL' }),
};
// Round 5 sizing: sized.json holds the numbers tune.mjs found on sizing seeds (300000 and up; real-sport points pinned).
// They overwrite the first-draft numbers written on the cards above; report.mjs prints the table as sized.
export const SIZED = SIZED_DATA;
// THE FLOOR (the moves of audit 4c). Eight moves; the button's NAME follows the state (ui-text.mjs moveName), never the
// code. `ends` = nothing more can be laid after it that turn. `real` = the audit row, the REAL-FIGHT gate of round 9.
export const MOVE = {
  '@in': { n: 'Step in', ends: 0, real: '4c step 1 Step in; 4c Follow him down' },
  '@out': { n: 'Step out', ends: 0, real: '4c step 1 Step out; 4c Walk away; 4c Step out of the clinch (M15, answerable)' },
  '@stand': { n: 'Stand up in the guard', ends: 1, real: '4c Stand up in the guard (M7, the owner\'s case)' },
  '@back': { n: 'Back away', ends: 0, real: '4c Back away (M7 step 4)' },
  '@up': { n: 'Get up', ends: 1, real: '4c Get up in open space (M6)' },
  // A pull made from his TIE does not end the volley: "a pull straight into a triangle needs an arm and the head already
  // held" - only behind a pull made from a tie may a hold follow in the same volley (audit 4c, the MISSING-LINK row).
  // The sit (no tie) is his whole turn, as before. Declared in engine.mjs endsVolley, which reads the tie.
  '@pull': { n: 'Pull guard', ends: 0, real: '4c Pull guard from his tie; 4c Sit down with no tie' },
  '@cover': { n: 'Cover up', ends: 0, real: '2a Cover up REAL' },
  '@frame': { n: 'Frame', ends: 0, ans: 1, real: '9a H1 Frame: the tie fails, both stay at punching range' },
  '@base': { n: 'Keep your base', ends: 0, ans: 1, real: '9a B1 Keep your base: the pull or the sweep fails' },
  '@escape': { n: 'Fight the hold', ends: 0, ans: 1, real: '9a B2 Escape a hold as it is laid: the holder stays where he is' },
  '@kick': { n: 'Up-kick', ends: 0, real: '9a B3 Up-kick from your back with no card' },
  '@break': { n: 'Break free', ends: 0, real: '2a Break free (WRONG fixed: both stay down, the holder one layer back)' },
};
export const FLOOR = Object.fromEntries(Object.entries(MOVE).map(([k, m]) => [k, m.n]));
const d = (o) => Object.entries(o).flatMap(([k, n]) => Array(n).fill(k));
const CORE = { sprawl: 2, escape: 1 };
export const OWN = {
  boxing: { jab: 3, cross: 2, hook: 2, bodyhook: 1, upper: 1, slip: 1, block: 2 },
  kickboxing: { onetwo: 2, kbhook: 2, lowkick: 2, bodykick: 2, highkick: 1, knee: 2, check: 1 },
  karate: { frontkick: 2, roundhouse: 2, headkick: 2, legkick: 1, revpunch: 3, evade: 2 },
  judo: { grip: 3, hipthrow: 2, footsweep: 2, shoulderthrow: 1, pin: 2, armlock: 1, tiein: 1 },
  wrestling: { double: 2, single: 2, slam: 1, gnp: 2, fall: 1, ride: 2, headlock: 2 },
  // round 9: the two new cards take the room of duplicate passes and submissions (the deck stays 15). `own.bjj.pass: 3`
  // in sized.json is only the card's price; the count lives here.
  bjj: { tieup: 2, upkick: 1, sweep: 2, pass: 2, triangle: 2, armbar: 1, kimura: 1, choke: 1 },
  sambo: { sthrow: 2, trip: 2, kneebar: 2, anklelock: 1, casualpin: 1, overhand: 3, catchkick: 1 },
};
// a key is a number of N (hp), of a card (cross.dmg) or a count in a style deck (own.sambo.overhand)
export function size(k, v) { const q = k.split('.'); if (q[0] === 'own') OWN[q[1]][q[2]] = v; else if (q[1]) CARDS[q[0]][q[1]] = v; else N[k] = v; }
for (const [k, v] of Object.entries(SIZED)) size(k, v);
// sized.json carries `own.<style>.<card>` numbers from the round-5 search (a pricing search may add a copy); the round-9
// deck is the 15 cards the brief sizes (15 own + core = 15): recompute it from OWN, with the two new cards in their place
OWN.bjj = { tieup: 2, upkick: 1, sweep: SIZED['own.bjj.sweep'] ?? 2, pass: 2, triangle: SIZED['own.bjj.triangle'] ?? 2, armbar: 1, kimura: 1, choke: 1 };
OWN.boxing = { jab: 3, cross: SIZED['own.boxing.cross'] ?? 2, hook: 2, bodyhook: 1, upper: 1, slip: 1, block: SIZED['own.boxing.block'] ?? 2 };
export const STYLES = ['boxing', 'bjj'];
export const fighter = (style, x = {}) => ({ name: style, style, deck: d({ ...OWN[style], ...CORE }), mech: true, ...x });
// round 3's failure, re-run: the cheapest legal decks (fixed 15, at most 3 of a card)
export const CHEAP = {
  boxing: { name: 'cheap boxing', style: 'boxing', mech: true, deck: d({ jab: 3, bodyhook: 3, block: 3, cross: 3, ...CORE }) },
  karate: { name: 'cheap karate', style: 'karate', mech: true, deck: d({ frontkick: 3, legkick: 3, evade: 3, revpunch: 3, ...CORE }) },
  mix: { name: 'cheap mix', style: 'mma', mech: false, deck: d({ jab: 3, legkick: 3, trip: 3, block: 3, ...CORE }) },
};
export function deckLegal(deck) {
  const n = {}; for (const c of deck) n[c] = (n[c] || 0) + 1;
  return deck.length === N.own + 3 && n.sprawl === 2 && n.escape === 1 && Object.entries(n).every(([k, v]) => CARDS[k] && (CARDS[k].st === 'core' || v <= N.copies));
}
