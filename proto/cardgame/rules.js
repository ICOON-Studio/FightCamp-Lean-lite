/* ============================================================================
   FightCamp card game - prototype rules (boxing only)
   A PURE module: no DOM, no I/O, no Date, no Math.random, no shared state.
   Pass a seed and the same bout plays out the same way, exchange by exchange.

   Shape of a bout
     CAMP   4 weeks, each week pick 1 of 3 training cards. They add cards to your
            fight deck (or raise a stat a little). The camp shapes the deck.
     SCOUT  before the bell you see the opponent's style and 0-2 of his habits.
     FIGHT  3 rounds x 6 exchanges. Both corners play one card face down, then
            reveal. Punches hurt, defence stops punches, footwork changes range.
     CORNER between rounds pick 1 of 3 corner cards; each one costs something.

   Everything here is data: CARDS, MATRIX_ROWS, HABITS, STYLES, CAMP_CARDS,
   CORNER_CARDS, BOXERS. A new martial art is new card data (see README).

   Loads as a classic <script> (window.FightCampRules) so index.html opens by
   double-click, and as a CommonJS module in Node for rules.test.mjs and
   balance.mjs. See README, "Why the page does not use an ES module import".
   ========================================================================== */
(function (root, factory) {
  var api = factory();
  if (typeof module === 'object' && module.exports) module.exports = api;
  if (typeof window !== 'undefined') window.FightCampRules = api;
})(typeof globalThis !== 'undefined' ? globalThis : this, function () {
'use strict';

/* --- seeded RNG (mulberry32) --------------------------------------------- */
function makeRng(seed) {
  var s = (seed >>> 0) || 0x9e3779b9;
  var rng = {
    next: function () {
      s = (s + 0x6d2b79f5) >>> 0;
      var t = s;
      t = Math.imul(t ^ (t >>> 15), t | 1);
      t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
      return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
    },
    int: function (n) { return Math.floor(rng.next() * n); },
    chance: function (p) { return rng.next() < p; },
    shuffle: function (arr) {
      for (var i = arr.length - 1; i > 0; i--) { var j = rng.int(i + 1); var t = arr[i]; arr[i] = arr[j]; arr[j] = t; }
      return arr;
    }
  };
  return rng;
}
function hashSeed() {
  var h = 0x811c9dc5;
  for (var a = 0; a < arguments.length; a++) {
    var s = String(arguments[a]);
    for (var i = 0; i < s.length; i++) { h ^= s.charCodeAt(i); h = Math.imul(h, 16777619); }
    h = Math.imul(h ^ 0x9e3779b9, 0x85ebca6b) >>> 0;
  }
  return h >>> 0;
}
function clamp(v, lo, hi) { return v < lo ? lo : v > hi ? hi : v; }

/* --- boxing card data ----------------------------------------------------- */
var KIND_LABEL = { punch: 'Punch', defence: 'Defence', footwork: 'Footwork' };
var CARD_ORDER = ['jab', 'cross', 'lead_hook', 'body_hook', 'uppercut',
  'slip', 'block', 'roll', 'clinch', 'step_back', 'pivot_out', 'cut_off'];

var CARDS = {
  jab: { id: 'jab', art: 'boxing', name: 'Jab', say: 'jab', kind: 'punch', cost: 3, tags: ['straight'], setsUp: true,
    dmg: { head: 4, body: 1 }, acc: 0.9, ranges: ['out', 'mid'],
    effect: 'Cheap straight. Land it and the next punch sits down on him.' },
  cross: { id: 'cross', art: 'boxing', name: 'Cross', say: 'cross', kind: 'punch', cost: 6, tags: ['straight', 'power'],
    dmg: { head: 12, body: 3 }, acc: 0.62, ranges: ['mid', 'inside'],
    effect: 'The right hand. The shot that ends fights.' },
  lead_hook: { id: 'lead_hook', art: 'boxing', name: 'Lead hook', say: 'lead hook', kind: 'punch', cost: 6, tags: ['hook'],
    dmg: { head: 11, body: 3 }, acc: 0.64, ranges: ['mid', 'inside'],
    effect: 'Comes around the guard; catches a man coming in.' },
  body_hook: { id: 'body_hook', art: 'boxing', name: 'Body hook', say: 'body hook', kind: 'punch', cost: 5, tags: ['hook', 'body'],
    dmg: { head: 2, body: 11 }, acc: 0.66, ranges: ['inside'],
    effect: 'Digs the body: costs him wind as well as points.' },
  uppercut: { id: 'uppercut', art: 'boxing', name: 'Uppercut', say: 'uppercut', kind: 'punch', cost: 7, tags: ['uppercut'],
    dmg: { head: 14, body: 3 }, acc: 0.58, ranges: ['inside'],
    effect: 'Up the middle, through the guard. The big one.' },
  slip: { id: 'slip', art: 'boxing', name: 'Slip', say: 'slip', kind: 'defence', cost: 3, tags: ['evade'],
    counter: { head: 3, body: 0 }, guard: 0.36, acc: 0.9, ranges: ['out', 'mid', 'inside'],
    effect: 'Off the line of a straight punch; short counter back.' },
  block: { id: 'block', art: 'boxing', name: 'Block', say: 'block', kind: 'defence', cost: 3, tags: ['guard'],
    counter: { head: 2, body: 0 }, guard: 0.55, acc: 0.9, ranges: ['out', 'mid', 'inside'],
    effect: 'Gloves high, take it on the arms. Cheap and safe.' },
  roll: { id: 'roll', art: 'boxing', name: 'Roll', say: 'roll', kind: 'defence', cost: 4, tags: ['evade'],
    counter: { head: 3, body: 0 }, guard: 0.3, acc: 0.85, ranges: ['mid', 'inside'],
    effect: 'Roll under the hooks and come back up.' },
  clinch: { id: 'clinch', art: 'boxing', name: 'Clinch', say: 'clinch', kind: 'defence', cost: 3, tags: ['hold'],
    counter: { head: 1, body: 3 }, guard: 0.45, acc: 0.9, ranges: ['mid', 'inside'],
    effect: 'Tie him up; his tank pays for the wrestling.' },
  step_back: { id: 'step_back', art: 'boxing', name: 'Step back', say: 'step back', kind: 'footwork', cost: 3, tags: ['escape'],
    counter: { head: 2, body: 0 }, guard: 0.32, acc: 0.9, ranges: ['out', 'mid'], rangeAfter: 'out',
    effect: 'Out of range; he punches air.' },
  pivot_out: { id: 'pivot_out', art: 'boxing', name: 'Pivot out', say: 'pivot out', kind: 'footwork', cost: 4, tags: ['escape'],
    counter: { head: 2, body: 0 }, guard: 0.45, acc: 0.9, ranges: ['out', 'mid', 'inside'], rangeAfter: 'mid',
    effect: 'Spin off the ropes and reset the angle.' },
  cut_off: { id: 'cut_off', art: 'boxing', name: 'Cut off the ring', say: 'cut off the ring', kind: 'footwork', cost: 4, tags: ['close'],
    counter: { head: 1, body: 3 }, guard: 0.1, acc: 0.9, ranges: ['mid', 'inside'], rangeAfter: 'inside',
    effect: 'Walk him down and take his exit away.' }
};

/* Resolution table: the row card played against the column card.
   W you crush it (he whiffs, you land full)   w you win the exchange
   t trade (both land)                         l you lose it
   X you are countered (you land nothing)      n nothing doing (both waste it)
   Anti-symmetric by definition: MATRIX[a][b] is always FLIP of MATRIX[b][a]. */
var MATRIX_COLS = 'jab cross lead_hook body_hook uppercut slip block roll clinch step_back pivot_out cut_off';
var MATRIX_ROWS = [
  'ttttllltwwlw', // jab
  'tttlllltwlll', // cross
  'ttttlwllwltt', // lead_hook
  'twtttwtllllt', // body_hook
  'wwwtttwwlllt', // uppercut
  'wwlltnnnlnnl', // slip
  'wwwtlnnnlnnl', // block
  'ttwwlnnntnnl', // roll
  'lllwwwwtnllt', // clinch
  'lwwwwnnnwnnX', // step_back
  'wwtwwnnnwnnw', // pivot_out
  'lwtttwwwtWln'  // cut_off
];
var FLIP = { W: 'X', w: 'l', t: 't', l: 'w', X: 'W', n: 'n' };
var CODE_FACTOR = { W: 1.5, w: 1.15, t: 0.7, l: 0.3, X: 0, n: 0 };
var RESOLUTION = {};
CARD_ORDER.forEach(function (a, i) {
  RESOLUTION[a] = {};
  CARD_ORDER.forEach(function (b, j) { RESOLUTION[a][b] = MATRIX_ROWS[i].charAt(j); });
});

/* --- styles: how a corner likes to fight (1 = neutral) -------------------- */
var STYLES = {
  out: { id: 'out', name: 'Out-boxer', blurb: 'Boxes at range, on the back foot, and wins on the jab.', weights: {
    jab: 1.5, cross: 1.25, lead_hook: 1.0, body_hook: 0.6, uppercut: 0.55, slip: 1.25, block: 1.0, roll: 1.0,
    clinch: 0.8, step_back: 1.05, pivot_out: 1.25, cut_off: 0.7 } },
  pressure: { id: 'pressure', name: 'Pressure fighter', blurb: 'Walks you down, works the body, smothers you inside.', weights: {
    jab: 1.2, cross: 1.1, lead_hook: 1.2, body_hook: 1.6, uppercut: 0.9, slip: 0.8, block: 0.9, roll: 0.7,
    clinch: 1.3, step_back: 0.4, pivot_out: 0.5, cut_off: 1.5 } },
  counter: { id: 'counter', name: 'Counter-puncher', blurb: 'Waits, makes you miss, and answers with the right hand.', weights: {
    jab: 0.95, cross: 1.4, lead_hook: 0.85, body_hook: 0.6, uppercut: 1.3, slip: 1.45, block: 1.2, roll: 1.35,
    clinch: 0.7, step_back: 1.2, pivot_out: 0.9, cut_off: 0.5 } },
  volume: { id: 'volume', name: 'Volume puncher', blurb: 'Throws in bunches and tries to out-work you.', weights: {
    jab: 1.5, cross: 1.1, lead_hook: 1.4, body_hook: 1.2, uppercut: 0.8, slip: 0.95, block: 1.05, roll: 0.85,
    clinch: 0.8, step_back: 0.8, pivot_out: 0.85, cut_off: 1.0 } }
};

/* The read: habits. If the situation in `when` is true and he holds the card,
   he plays it - in that situation, every time. That is what makes the scouting
   file and the corner worth the trouble. Shown to the player as words. */
var HABITS = {
  jab_to_open: { id: 'jab_to_open', text: 'He opens every round with the jab.', when: { exchange: 0 }, play: 'jab' },
  right_after_jab: { id: 'right_after_jab', text: 'After his own jab he sits down on the right hand.', when: { lastSelfCard: 'jab' }, play: 'cross' },
  clinch_when_hurt: { id: 'clinch_when_hurt', text: 'Hurt him and he holds: he looks for the clinch.', when: { selfHurt: true }, play: 'clinch' },
  step_back_when_hit: { id: 'step_back_when_hit', text: 'Hit him clean and he gives ground.', when: { lastTookClean: true }, play: 'step_back' },
  body_when_tired: { id: 'body_when_tired', text: 'With his tank low he digs the body hook.', when: { selfLowStamina: true }, play: 'body_hook' },
  uppercut_when_crowded: { id: 'uppercut_when_crowded', text: 'Crowd him and he fires the uppercut.', when: { inFightRange: 'inside' }, play: 'uppercut' },
  hold_when_ahead: { id: 'hold_when_ahead', text: 'Ahead on damage, he holds to kill the round.', when: { selfAhead: true }, play: 'clinch' },
  slip_the_cross: { id: 'slip_the_cross', text: 'He slips the right hand.', when: { lastOppCard: 'cross' }, play: 'slip' },
  roll_the_hooks: { id: 'roll_the_hooks', text: 'He rolls under your hooks.', when: { lastOppCard: 'lead_hook' }, play: 'roll' },
  cut_the_ring: { id: 'cut_the_ring', text: 'Step away from him and he cuts the ring off.', when: { lastOppCard: 'step_back' }, play: 'cut_off' }
};

/* --- camp cards: 4 weeks, 1 of 3 each ------------------------------------ */
var CAMP_CARDS = [
  { id: 'double_jab', name: 'Double-jab drills', add: { jab: 2 }, text: 'Two more jabs in the deck.' },
  { id: 'right_hand', name: 'Right-hand work', add: { cross: 1 }, text: 'One more cross. The right hand ends fights.' },
  { id: 'body_work', name: 'Body work', add: { body_hook: 1 }, text: 'One more body hook. His tank pays.' },
  { id: 'head_movement', name: 'Head movement', add: { slip: 1, roll: 1 }, text: 'A slip and a roll in the deck.' },
  { id: 'guard_drill', name: 'Guard drill', add: { block: 1 }, text: 'One more block. Nothing is free.' },
  { id: 'ring_craft', name: 'Ring craft', add: { pivot_out: 1, cut_off: 1 }, text: 'A pivot and a cut-off in the deck.' },
  { id: 'uppercut_pads', name: 'Uppercut on the pads', add: { uppercut: 1 }, text: 'One more uppercut for the inside.' },
  { id: 'roadwork', name: 'Roadwork', stat: { stamina: 5 }, text: '+5 Stamina: more wind, cheaper cards.' },
  { id: 'weights', name: 'Weight work', stat: { power: 5 }, text: '+5 Power: every punch hurts more.' },
  { id: 'ladder', name: 'Speed ladder', stat: { speed: 5 }, text: '+5 Speed: sharper counters, more ties won.' },
  { id: 'sparring', name: 'Hard sparring', stat: { technique: 3, chin: 2 }, text: '+3 Technique, +2 Chin.' },
  { id: 'film', name: 'Film study', stat: { defence: 2 }, scout: 1, text: '+2 Defence and one more habit in the file.' }
];

/* --- corner cards: between rounds, 1 of 3, each costs something ---------- */
var CORNER_CARDS = [
  { id: 'ice_eye', name: 'Ice the eye', text: 'Take 10 off the head damage you carry. It costs 5 wind.',
    healHead: 10, stamina: -5 },
  { id: 'breathe', name: 'Breathe', text: '+16 wind, but you feel your way in: your first exchange is light.',
    stamina: 16, mod: { firstExchange: -0.35 } },
  { id: 'gloves_high', name: 'Gloves high', text: 'Block is 1 cheaper next round; your punches land 15% softer.',
    mod: { block_discount: 1, punch: -0.15 } },
  { id: 'change_plan', name: 'Change the plan', text: 'Draw 2 cards now. It costs 6 wind to think.',
    draw: 2, stamina: -6 },
  { id: 'stool', name: 'Sit on the stool', text: '+10 wind and 6 off the body, but he starts the next round faster.',
    stamina: 10, healBody: 6, mod: { foe_first: 0.2 } },
  { id: 'study', name: 'Study his corner', text: 'One more habit in the file. 3 wind to watch him breathe.',
    scout: 1, stamina: -3 }
];

/* --- the roster (prototype: boxing only) --------------------------------- */
var BOXERS = [
  { id: 'ada', name: 'Ada Nowak', pronoun: 'she', poss: 'her', style: 'out', blurb: 'Schooled amateur. Best feet in the gym.',
    stats: { power: 54, speed: 82, stamina: 68, chin: 55, technique: 80, defence: 72 },
    deck: ['jab', 'jab', 'cross', 'cross', 'lead_hook', 'uppercut', 'slip', 'slip', 'block', 'step_back', 'pivot_out', 'cut_off'],
    habits: ['jab_to_open', 'cut_the_ring'] },
  { id: 'mara', name: 'Mara Okafor', pronoun: 'she', poss: 'her', style: 'pressure', blurb: 'Never takes a step back. Body first.',
    stats: { power: 74, speed: 58, stamina: 84, chin: 76, technique: 60, defence: 58 },
    deck: ['jab', 'body_hook', 'body_hook', 'lead_hook', 'uppercut', 'slip', 'roll', 'clinch', 'cut_off', 'cut_off', 'block', 'pivot_out'],
    habits: ['body_when_tired', 'clinch_when_hurt'] },
  { id: 'tomas', name: 'Tomas Reiner', pronoun: 'he', poss: 'his', style: 'counter', blurb: 'Won the nationals by making people miss.',
    stats: { power: 62, speed: 74, stamina: 60, chin: 66, technique: 78, defence: 76 },
    deck: ['jab', 'cross', 'cross', 'uppercut', 'lead_hook', 'slip', 'slip', 'roll', 'roll', 'step_back', 'pivot_out', 'block'],
    habits: ['slip_the_cross', 'hold_when_ahead'] },
  { id: 'ines', name: 'Ines Duarte', pronoun: 'she', poss: 'her', style: 'volume', blurb: 'Throws thirty a round and never sits down.',
    stats: { power: 56, speed: 70, stamina: 80, chin: 62, technique: 66, defence: 60 },
    deck: ['jab', 'jab', 'lead_hook', 'lead_hook', 'body_hook', 'uppercut', 'block', 'block', 'slip', 'roll', 'step_back', 'pivot_out'],
    habits: ['right_after_jab', 'cut_the_ring'] },
  { id: 'kwame', name: 'Kwame Boateng', pronoun: 'he', poss: 'his', style: 'pressure', blurb: 'A cruiserweight who fights like a middleweight.',
    stats: { power: 86, speed: 48, stamina: 70, chin: 80, technique: 54, defence: 50 },
    deck: ['jab', 'body_hook', 'body_hook', 'cross', 'uppercut', 'slip', 'roll', 'clinch', 'cut_off', 'cut_off', 'block', 'step_back'],
    habits: ['uppercut_when_crowded', 'clinch_when_hurt'] },
  { id: 'lena', name: 'Lena Voss', pronoun: 'she', poss: 'her', style: 'out', blurb: 'Tall, awkward, walks onto a right hand now and then.',
    stats: { power: 64, speed: 72, stamina: 64, chin: 88, technique: 70, defence: 66 },
    deck: ['jab', 'cross', 'cross', 'lead_hook', 'uppercut', 'slip', 'slip', 'block', 'step_back', 'pivot_out', 'pivot_out', 'cut_off'],
    habits: ['jab_to_open', 'roll_the_hooks'] },
  { id: 'rio', name: 'Rio Tanaka', pronoun: 'he', poss: 'his', style: 'counter', blurb: 'Fast hands, slower feet. Loves the check hook.',
    stats: { power: 58, speed: 88, stamina: 62, chin: 58, technique: 76, defence: 70 },
    deck: ['jab', 'cross', 'cross', 'uppercut', 'body_hook', 'slip', 'slip', 'roll', 'block', 'step_back', 'pivot_out', 'pivot_out'],
    habits: ['roll_the_hooks', 'hold_when_ahead'] },
  { id: 'piotr', name: 'Piotr Zawada', pronoun: 'he', poss: 'his', style: 'volume', blurb: 'Tough as a boot. Wins the last round every time.',
    stats: { power: 66, speed: 62, stamina: 90, chin: 72, technique: 58, defence: 54 },
    deck: ['jab', 'jab', 'cross', 'lead_hook', 'body_hook', 'uppercut', 'block', 'slip', 'clinch', 'step_back', 'cut_off', 'cut_off'],
    habits: ['body_when_tired', 'step_back_when_hit'] }
];

/* Judges score landed punches and damage, with a taste and a little noise. */
var JUDGES = [
  { name: 'J. Alvarez', landed: 0.55, damage: 1.35, aggression: 0.10, noise: 0.10 },
  { name: 'M. Petrov', landed: 0.35, damage: 1.75, aggression: 0.05, noise: 0.06 },
  { name: 'S. Boateng', landed: 0.75, damage: 1.00, aggression: 0.20, noise: 0.14 }
];

/* Situational nudges for the AI: the same card is not worth the same always. */
var SITUATION_RULES = [
  { when: { lastOppStraight: true }, cards: ['slip'], mul: 1.4 },
  { when: { lastOppHook: true }, cards: ['roll'], mul: 1.4 },
  { when: { foeLowStamina: true }, cards: ['body_hook', 'cut_off'], mul: 1.3 },
  { when: { selfHurt: true }, cards: ['block', 'clinch', 'step_back'], mul: 1.25 },
  { when: { foeHurt: true }, cards: ['cross', 'uppercut', 'lead_hook'], mul: 1.2 },
  { when: { exchange: 0 }, cards: ['jab'], mul: 1.25 },
  { when: { combo: true }, cards: ['cross', 'lead_hook', 'uppercut'], mul: 1.3 },
  { when: { gassed: true }, cards: ['block', 'step_back', 'clinch'], mul: 1.3 }
];
var CAMP_PREF = {
  out: ['ladder', 'roadwork', 'double_jab', 'guard_drill'],
  pressure: ['body_work', 'weights', 'right_hand', 'roadwork'],
  counter: ['head_movement', 'guard_drill', 'sparring', 'uppercut_pads'],
  volume: ['double_jab', 'body_work', 'ring_craft', 'roadwork']
};

/* --- small helpers -------------------------------------------------------- */
function boxerById(id) { for (var i = 0; i < BOXERS.length; i++) if (BOXERS[i].id === id) return BOXERS[i]; return null; }
function cardById(id) { for (var i = 0; i < CAMP_CARDS.length; i++) if (CAMP_CARDS[i].id === id) return CAMP_CARDS[i]; return null; }
function cornerById(id) { for (var i = 0; i < CORNER_CARDS.length; i++) if (CORNER_CARDS[i].id === id) return CORNER_CARDS[i]; return null; }
function maxStamina(stats) { return Math.round(62 + stats.stamina * 0.42); }
function cardCost(side, cardId) {
  var cost = CARDS[cardId].cost * (1.12 - side.stats.stamina / 320);
  if (cardId === 'block' && side.mods && side.mods.block_discount) cost -= side.mods.block_discount;
  return Math.max(1, Math.round(cost));
}
function isHurt(side) { return side.head >= 40 || side.stamina <= 0; }
function totalDamage(side) { return side.head + side.body; }
function otherKey(key) { return key === 'player' ? 'opponent' : 'player'; }

/* --- game: camp, then the scouting file ---------------------------------- */
function campOffers(seed) {
  var out = [];
  for (var w = 0; w < 4; w++) {
    var rng = makeRng(hashSeed(seed, 'camp', w));
    var pool = rng.shuffle(CAMP_CARDS.map(function (c) { return c.id; }));
    out.push(pool.slice(0, 3));
  }
  return out;
}
function createGame(opts) {
  opts = opts || {};
  var seed = (opts.seed === undefined ? 1 : opts.seed) >>> 0;
  var playerBoxerId = opts.playerBoxerId || 'ada';
  var opponentBoxerId = opts.opponentBoxerId;
  if (!opponentBoxerId) {
    var pool = BOXERS.filter(function (b) { return b.id !== playerBoxerId; });
    opponentBoxerId = pool[hashSeed(seed, 'foe') % pool.length].id;
  }
  return {
    seed: seed, phase: 'camp', week: 0,
    playerBoxerId: playerBoxerId, opponentBoxerId: opponentBoxerId,
    offers: campOffers(seed), picks: [],
    mods: { stat: {}, add: {}, scout: 0 },
    scouting: null, fight: null
  };
}
function statLine(boxer, mods) {
  var out = {};
  for (var k in boxer.stats) out[k] = clamp(boxer.stats[k] + ((mods && mods.stat && mods.stat[k]) || 0), 1, 99);
  return out;
}
function pickCampCard(game, cardId) {
  if (game.phase !== 'camp') throw new Error('camp is over');
  if (game.offers[game.week].indexOf(cardId) < 0) throw new Error('not in this week\'s offer: ' + cardId);
  var card = cardById(cardId);
  for (var k in (card.stat || {})) game.mods.stat[k] = (game.mods.stat[k] || 0) + card.stat[k];
  for (var d in (card.add || {})) game.mods.add[d] = (game.mods.add[d] || 0) + card.add[d];
  if (card.scout) game.mods.scout += card.scout;
  game.picks.push(cardId);
  game.week += 1;
  if (game.week >= 4) { game.phase = 'scout'; game.scouting = scoutReport(game); }
  return game;
}
function scoutReport(game) {
  var foe = boxerById(game.opponentBoxerId);
  var rng = makeRng(hashSeed(game.seed, 'scout', foe.id));
  var n = clamp(rng.int(3) + game.mods.scout, 0, foe.habits.length);
  var seen = rng.shuffle(foe.habits.slice()).slice(0, n);
  return {
    boxerId: foe.id, name: foe.name, style: foe.style, styleName: STYLES[foe.style].name,
    stats: statLine(foe), blurb: foe.blurb,
    known: seen.map(function (id) { return { id: id, text: HABITS[id].text }; }),
    fleeting: foe.habits.length - n,
    summary: n === 0 ? 'Nothing on film. You fight him cold.' :
      n === 1 ? 'One thing on film, and you have to trust it.' : 'Two things on film. Enough to build a plan.'
  };
}

/* --- sides and the fight ------------------------------------------------- */
function makeSide(boxer, statMods, addMods) {
  var stats = statLine(boxer, { stat: statMods || {} });
  var deck = boxer.deck.slice();
  for (var k in (addMods || {})) for (var i = 0; i < addMods[k]; i++) deck.push(k);
  return {
    boxerId: boxer.id, name: boxer.name, pronoun: boxer.pronoun, poss: boxer.poss,
    style: boxer.style, styleName: STYLES[boxer.style].name, stats: stats, deck: deck,
    draw: [], hand: [], discard: [],
    maxStamina: maxStamina(stats), stamina: maxStamina(stats),
    head: 0, body: 0, knockdowns: 0,
    totals: { thrown: 0, landed: 0, damage: 0 },
    round: { thrown: 0, landed: 0, damage: 0, kd: 0 },
    lastCard: null, lastTookClean: false, lastLandedClean: false, combo: false,
    mods: {}, habits: boxer.habits.slice()
  };
}
function refill(side, rng, target) {
  while (side.hand.length < target) {
    if (!side.draw.length) {
      if (!side.discard.length) break;
      side.draw = rng.shuffle(side.discard.splice(0, side.discard.length));
    }
    side.hand.push(side.draw.pop());
  }
}
function startFight(game) {
  if (game.phase !== 'scout') throw new Error('camp first');
  var rng = makeRng(hashSeed(game.seed, 'fight'));
  var fight = {
    seed: game.seed, phase: 'fight', round: 1, exchange: 0, range: 'mid',
    rng: rng, judgeRng: makeRng(hashSeed(game.seed, 'judges')),
    player: makeSide(boxerById(game.playerBoxerId), game.mods.stat, game.mods.add),
    opponent: makeSide(boxerById(game.opponentBoxerId)),
    rounds: [], events: [], corner: null, result: null,
    scouting: game.scouting
  };
  fight.player.draw = rng.shuffle(fight.player.deck.slice());
  fight.opponent.draw = rng.shuffle(fight.opponent.deck.slice());
  refill(fight.player, rng, 5);
  refill(fight.opponent, rng, 5);
  game.fight = fight;
  game.phase = 'fight';
  return fight;
}
function isOver(fight) { return fight.result !== null; }
function legalCards(fight, key) {
  var side = fight[key || 'player'], out = [];
  for (var i = 0; i < side.hand.length; i++) {
    var cost = cardCost(side, side.hand[i]);
    out.push({ id: side.hand[i], card: CARDS[side.hand[i]], cost: cost, affordable: side.stamina >= cost });
  }
  return out;
}

/* --- the AI -------------------------------------------------------------- */
function contextOf(fight, key) {
  var me = fight[key], foe = fight[otherKey(key)];
  var lastOpp = foe.lastCard ? CARDS[foe.lastCard] : null;
  return {
    exchange: fight.exchange, round: fight.round, range: fight.range, inFightRange: fight.range,
    lastSelfCard: me.lastCard, lastOppCard: foe.lastCard,
    lastOppStraight: !!(lastOpp && lastOpp.tags.indexOf('straight') >= 0),
    lastOppHook: !!(lastOpp && lastOpp.tags.indexOf('hook') >= 0),
    lastTookClean: me.lastTookClean, lastLandedClean: me.lastLandedClean,
    selfHurt: isHurt(me), foeHurt: isHurt(foe),
    selfLowStamina: me.stamina < me.maxStamina * 0.3,
    foeLowStamina: foe.stamina < foe.maxStamina * 0.3,
    selfAhead: totalDamage(me) > totalDamage(foe) + 6,
    gassed: me.stamina < 5, combo: !!me.combo
  };
}
function whenMatches(when, ctx) {
  for (var k in when) { if (ctx[k] !== when[k]) return false; }
  return true;
}
function cardBaseValue(card) { var b = card.dmg || card.counter || { head: 0, body: 0 }; return b.head + b.body; }
function expectedSwing(cardId, foeWeights) {
  var mine = 0, wsum = 0, cv = cardBaseValue(CARDS[cardId]);
  for (var i = 0; i < CARD_ORDER.length; i++) {
    var oid = CARD_ORDER[i], w = foeWeights[oid] || 0;
    if (w <= 0) continue;
    wsum += w;
    mine += w * (CODE_FACTOR[RESOLUTION[cardId][oid]] * cv -
      CODE_FACTOR[RESOLUTION[oid][cardId]] * cardBaseValue(CARDS[oid]) * 0.9);
  }
  return wsum ? mine / wsum : 0;
}
function habitCard(side, ctx) {
  for (var i = 0; i < side.habits.length; i++) {
    var h = HABITS[side.habits[i]];
    if (!h || !whenMatches(h.when, ctx)) continue;
    if (side.hand.indexOf(h.play) >= 0) return h.play;
  }
  return null;
}
function chooseAiCard(fight, key) {
  var side = fight[key], ctx = contextOf(fight, key), style = STYLES[side.style];
  var habit = habitCard(side, ctx);
  if (habit) return habit;
  var foeWeights = STYLES[fight[otherKey(key)].style].weights;
  var rng = makeRng(hashSeed(fight.seed, 'ai', key, fight.round, fight.exchange));
  var best = null, bestScore = -1;
  for (var i = 0; i < side.hand.length; i++) {
    var id = side.hand[i], card = CARDS[id];
    var s = (style.weights[id] || 1) * clamp(0.62 + expectedSwing(id, foeWeights) / 10, 0.1, 2.4);
    if (!card.ranges || card.ranges.indexOf(fight.range) < 0) s *= 0.6;
    for (var r = 0; r < SITUATION_RULES.length; r++) {
      var rule = SITUATION_RULES[r];
      if (rule.cards.indexOf(id) >= 0 && whenMatches(rule.when, ctx)) s *= rule.mul;
    }
    if (side.stamina < cardCost(side, id)) s *= 0.55;
    s *= 0.85 + rng.next() * 0.3;
    if (s > bestScore) { bestScore = s; best = id; }
  }
  return best;
}
function aiCampPick(game) {
  var prefs = CAMP_PREF[boxerById(game.playerBoxerId).style] || [];
  var offer = game.offers[game.week];
  for (var i = 0; i < prefs.length; i++) if (offer.indexOf(prefs[i]) >= 0) return prefs[i];
  return offer[0];
}
function aiCornerPick(game, key) {
  key = key || 'player';
  var fight = game.fight, side = fight[key];
  var offer = key === 'player' ? fight.corner : fight.foeCorner;
  function has(id) { return offer.indexOf(id) >= 0; }
  if (side.head >= 30 && has('ice_eye')) return 'ice_eye';
  if (side.stamina < side.maxStamina * 0.45 && has('breathe')) return 'breathe';
  if (key === 'player' && fight.scouting.known.length < 2 && has('study')) return 'study';
  if (has('gloves_high')) return 'gloves_high';
  if (has('change_plan')) return 'change_plan';
  return offer[0];
}
function applyCorner(fight, side, card, key) {
  if (card.healHead) side.head = Math.max(0, side.head - card.healHead);
  if (card.healBody) side.body = Math.max(0, side.body - card.healBody);
  if (card.stamina) side.stamina = clamp(side.stamina + card.stamina, 0, side.maxStamina);
  if (card.mod) for (var k in card.mod) {
    if (k === 'foe_first' && key !== 'player') side.mods.firstExchange = card.mod[k];
    else side.mods[k] = card.mod[k];
  }
  if (card.draw && key === 'player') refill(side, fight.rng, side.hand.length + card.draw);
  if (card.scout && key === 'player') revealHabit(fight);
}

/* --- one exchange -------------------------------------------------------- */
function strike(fight, side, foe, cardId, foeCardId, code, opts) {
  var card = CARDS[cardId], foeCard = CARDS[foeCardId], factor = CODE_FACTOR[code];
  var out = { card: cardId, code: code, hit: false, head: 0, body: 0, dealt: 0, verdict: 'finds nothing' };
  if (factor === 0) return out;
  var base = card.dmg || card.counter || { head: 0, body: 0 };
  var inRange = !card.ranges || card.ranges.indexOf(fight.range) >= 0;
  var punch = card.kind === 'punch';
  var statMul = punch ? 1 + (side.stats.power - 50) / 150 : 1 + (side.stats.speed - 50) / 150;
  var guardMul = (code === 'l' || code === 'X' || code === 't')
    ? 1 - (foeCard.guard || 0) * (code === 't' ? 0.6 : 1) : 1;
  var defMul = 1 - (foe.stats.defence - 50) / 320;
  var hitChance = card.acc + (side.stats.technique - 50) / 220
    + (factor >= 1 ? 0.05 : factor <= 0.3 ? -0.07 : 0)
    + (inRange ? 0 : -0.12) + (opts.gassed ? -0.08 : 0) + (punch && opts.setup ? 0.05 : 0);
  out.hit = fight.rng.chance(clamp(hitChance, 0.25, 0.97));
  if (!out.hit) { out.verdict = 'misses'; return out; }
  var mult = factor * statMul * guardMul * defMul * (inRange ? 1 : 0.62) * (opts.gassed ? 0.6 : 1) * opts.bonus;
  if (punch && opts.setup) mult *= 1.15;
  out.head = Math.max(0, base.head * mult);
  out.body = Math.max(0, base.body * mult);
  out.dealt = out.head + out.body;
  out.verdict = code === 'W' ? 'lands flush' : code === 'w' ? 'lands' :
    code === 't' ? 'lands in a trade' : code === 'l' ? 'is mostly smothered' : 'is half-blocked';
  return out;
}
function knockdownChance(shotHead, defender) {
  if (shotHead < 4) return 0;
  var p = (shotHead - 4) / 24;
  p *= 1 + defender.head / 120;
  p *= 1 + (defender.maxStamina - defender.stamina) / 300;
  p *= 1.25 - defender.stats.chin / 230;
  if (isHurt(defender)) p *= 1.35;
  return clamp(p, 0, 0.55);
}
function rangeAfter(a, b, fight) {
  var order = ['cut_off', 'clinch', 'uppercut', 'body_hook', 'step_back', 'pivot_out', 'jab'];
  var landedCards = {};
  if (a.hit) landedCards[a.card] = true;
  if (b.hit) landedCards[b.card] = true;
  for (var i = 0; i < order.length; i++) {
    var id = order[i];
    if (!landedCards[id]) continue;
    var card = CARDS[id];
    if (card.rangeAfter) return card.rangeAfter;
    if (id === 'clinch' || id === 'uppercut' || id === 'body_hook') return 'inside';
    if (id === 'jab' && fight.range === 'inside') return 'mid';
  }
  return fight.range;
}
function exchangeText(fight, a, b, kd) {
  var foe = fight.opponent;
  function phrase(hit) { return hit.verdict; }
  var txt = 'Your ' + CARDS[a.card].say + ' ' + phrase(a) + '; ' +
    foe.poss + ' ' + CARDS[b.card].say + ' ' + phrase(b);
  kd.forEach(function (k) {
    txt += k.who === 'player' ? ' — you are down!' : ' — ' + foe.name.split(' ')[0] + ' is down!';
  });
  return txt;
}
function playExchange(game, playerCardId) {
  var fight = game.fight;
  if (!fight || fight.phase !== 'fight') throw new Error('the bell has gone');
  var me = fight.player, foe = fight.opponent;
  if (me.hand.indexOf(playerCardId) < 0) throw new Error('not in hand: ' + playerCardId);
  var foeCardId = chooseAiCard(fight, 'opponent');

  me.hand.splice(me.hand.indexOf(playerCardId), 1);
  foe.hand.splice(foe.hand.indexOf(foeCardId), 1);
  me.discard.push(playerCardId); foe.discard.push(foeCardId);

  var meCost = cardCost(me, playerCardId), foeCost = cardCost(foe, foeCardId);
  var meGassed = me.stamina < meCost, foeGassed = foe.stamina < foeCost;
  me.stamina = Math.max(0, me.stamina - meCost);
  foe.stamina = Math.max(0, foe.stamina - foeCost);

  var first = fight.exchange === 0;
  var bonusA = first && me.mods.firstExchange ? 1 + me.mods.firstExchange : 1;
  var bonusB = first && foe.mods.firstExchange ? 1 + foe.mods.firstExchange : 1;
  if (first && me.mods.foe_first) bonusB *= 1 + me.mods.foe_first;
  var a = strike(fight, me, foe, playerCardId, foeCardId, RESOLUTION[playerCardId][foeCardId], {
    gassed: meGassed, setup: me.combo, bonus: bonusA });
  var b = strike(fight, foe, me, foeCardId, playerCardId, RESOLUTION[foeCardId][playerCardId], {
    gassed: foeGassed, setup: foe.combo, bonus: bonusB });
  me.combo = !!(a.hit && CARDS[playerCardId].setsUp);
  foe.combo = !!(b.hit && CARDS[foeCardId].setsUp);

  me.head += b.head; me.body += b.body;
  foe.head += a.head; foe.body += a.body;
  foe.stamina = Math.max(0, Math.round(foe.stamina - a.body * 0.45));
  me.stamina = Math.max(0, Math.round(me.stamina - b.body * 0.45));
  if (CARDS[playerCardId].id === 'clinch' && a.code !== 'X' && a.hit) foe.stamina = Math.max(0, foe.stamina - 4);
  if (CARDS[foeCardId].id === 'clinch' && b.code !== 'X' && b.hit) me.stamina = Math.max(0, me.stamina - 4);
  me.lastTookClean = b.head >= 5; foe.lastTookClean = a.head >= 5;
  me.lastCard = playerCardId; foe.lastCard = foeCardId;

  [[me, a, foe], [foe, b, me]].forEach(function (row) {
    var side = row[0], hit = row[1];
    side.totals.thrown += 1; side.round.thrown += 1;
    side.totals.damage += hit.dealt; side.round.damage += hit.dealt;
    if (hit.hit) { side.totals.landed += 1; side.round.landed += 1; }
  });

  var knockdowns = [];
  if (a.hit) {
    var p1 = knockdownChance(a.head, foe);
    if (p1 > 0 && fight.rng.chance(p1)) { foe.knockdowns += 1; foe.round.kd += 1; foe.stamina = Math.max(0, foe.stamina - 12); knockdowns.push({ who: 'opponent' }); }
  }
  if (b.hit) {
    var p2 = knockdownChance(b.head, me);
    if (p2 > 0 && fight.rng.chance(p2)) { me.knockdowns += 1; me.round.kd += 1; me.stamina = Math.max(0, me.stamina - 12); knockdowns.push({ who: 'player' }); }
  }

  var range = rangeAfter(a, b, fight);
  fight.range = range;
  var stop = checkStoppage(fight);
  var event = {
    round: fight.round, exchange: fight.exchange, player: a, opponent: b,
    code: RESOLUTION[playerCardId][foeCardId], range: range,
    knockdowns: knockdowns, stoppage: stop
  };
  event.text = exchangeText(fight, a, b, knockdowns);
  fight.events.push(event);

  refill(me, fight.rng, 5); refill(foe, fight.rng, 5);
  fight.exchange += 1;
  if (stop) { finishEarly(fight, stop); return event; }
  if (fight.exchange >= 6) endRound(game);
  return event;
}
function checkStoppage(fight) {
  var sides = [['player', fight.player], ['opponent', fight.opponent]];
  for (var i = 0; i < sides.length; i++) {
    var side = sides[i][1];
    if (side.knockdowns >= 3) return { who: sides[i][0], why: 'three knockdowns' };
    if (side.head >= 100) return { who: sides[i][0], why: 'the damage is too much' };
    if (side.stamina <= 0 && side.head >= 32) return { who: sides[i][0], why: 'hurt and out of wind' };
  }
  return null;
}

/* --- rounds, the corner, the result -------------------------------------- */
function judgeRound(meStats, foeStats, av, bv) {
  if (Math.abs(av - bv) < 0.35) return [10, 10];
  var meWon = av > bv;
  var hi = meWon ? meStats : foeStats, lo = meWon ? foeStats : meStats;
  var big = hi.kd > 0 ||
    (lo.damage > 0 && hi.damage / lo.damage >= 2.2 && hi.landed >= lo.landed * 1.5) ||
    (lo.damage === 0 && hi.damage >= 12);
  return meWon ? [10, big ? 8 : 9] : [big ? 8 : 9, 10];
}
function scoreRound(fight, meStats, foeStats) {
  var out = [];
  for (var j = 0; j < JUDGES.length; j++) {
    var judge = JUDGES[j];
    var jitter = 1 + (fight.judgeRng.next() - 0.5) * judge.noise * 2;
    var av = (judge.landed * meStats.landed + judge.damage * meStats.damage + judge.aggression * meStats.thrown * 0.15) * jitter;
    var bv = (judge.landed * foeStats.landed + judge.damage * foeStats.damage + judge.aggression * foeStats.thrown * 0.15) / (jitter || 1);
    out.push(judgeRound(meStats, foeStats, av, bv));
  }
  return out;
}
function endRound(game) {
  var fight = game.fight;
  fight.rounds.push({
    round: fight.round,
    player: { thrown: fight.player.round.thrown, landed: fight.player.round.landed, damage: fight.player.round.damage, kd: fight.player.round.kd },
    opponent: { thrown: fight.opponent.round.thrown, landed: fight.opponent.round.landed, damage: fight.opponent.round.damage, kd: fight.opponent.round.kd },
    scores: scoreRound(fight, fight.player.round, fight.opponent.round)
  });
  if (fight.round >= 3) { decision(fight); return; }
  fight.phase = 'corner';
  fight.corner = makeRng(hashSeed(fight.seed, 'corner', fight.round, 'player'))
    .shuffle(CORNER_CARDS.map(function (c) { return c.id; })).slice(0, 3);
  fight.foeCorner = makeRng(hashSeed(fight.seed, 'corner', fight.round, 'opponent'))
    .shuffle(CORNER_CARDS.map(function (c) { return c.id; })).slice(0, 3);
  fight.foeCornerPick = aiCornerPick(game, 'opponent');
  [fight.player, fight.opponent].forEach(function (side) {
    side.mods = {}; side.round = { thrown: 0, landed: 0, damage: 0, kd: 0 };
  });
  fight.exchange = 0;
}
function revealHabit(fight) {
  var foe = boxerById(fight.opponent.boxerId);
  var known = fight.scouting.known.map(function (k) { return k.id; });
  for (var i = 0; i < foe.habits.length; i++) {
    if (known.indexOf(foe.habits[i]) < 0) {
      fight.scouting.known.push({ id: foe.habits[i], text: HABITS[foe.habits[i]].text });
      fight.scouting.fleeting = Math.max(0, fight.scouting.fleeting - 1);
      return true;
    }
  }
  return false;
}
function pickCorner(game, cardId) {
  var fight = game.fight;
  if (fight.phase !== 'corner') throw new Error('no corner now');
  if (fight.corner.indexOf(cardId) < 0) throw new Error('not offered: ' + cardId);
  var card = cornerById(cardId);
  applyCorner(fight, fight.player, card, 'player');
  var foeCardId = fight.foeCornerPick || aiCornerPick(game, 'opponent');
  applyCorner(fight, fight.opponent, cornerById(foeCardId), 'opponent');
  fight.cornerUsed = { player: cardId, opponent: foeCardId };
  [fight.player, fight.opponent].forEach(function (side) {
    side.stamina = clamp(side.stamina + 14 + Math.round(side.stats.stamina * 0.12), 0, side.maxStamina);
    side.body = Math.max(0, side.body - 6);
    refill(side, fight.rng, 5);
    side.lastTookClean = false; side.lastLandedClean = false; side.lastCard = null;
  });
  fight.corner = null;
  fight.round += 1;
  fight.exchange = 0;
  fight.phase = 'fight';
  fight.range = 'mid';
  return game;
}
function finishEarly(fight, stop) {
  fight.result = {
    winner: stop.who === 'player' ? 'opponent' : 'player',
    method: 'stoppage', why: stop.why, round: fight.round, loser: stop.who,
    text: (stop.who === 'player' ? 'You are stopped' : fight.opponent.name + ' is stopped') +
      ' in round ' + fight.round + ' (' + stop.why + ').',
    scorecards: null, margin: null
  };
  fight.phase = 'over';
  return fight.result;
}
function decision(fight) {
  var totals = JUDGES.map(function (j, i) {
    var me = 0, foe = 0;
    fight.rounds.forEach(function (r) { me += r.scores[i][0]; foe += r.scores[i][1]; });
    return { judge: j.name, player: me, opponent: foe };
  });
  var meCards = totals.filter(function (t) { return t.player > t.opponent; }).length;
  var foeCards = totals.filter(function (t) { return t.opponent > t.player; }).length;
  var winner = meCards > foeCards ? 'player' : foeCards > meCards ? 'opponent' : 'draw';
  var line = totals.map(function (t) { return t.player + '-' + t.opponent; }).join(', ');
  fight.result = {
    winner: winner, method: 'decision', round: 3, scorecards: totals, margin: Math.abs(meCards - foeCards),
    text: (winner === 'player' ? 'You win on points.' : winner === 'opponent' ?
      fight.opponent.name + ' wins on points.' : 'A draw.') + ' (' + line + ' on the three cards.)'
  };
  fight.phase = 'over';
  return fight.result;
}

/* --- a whole AI-vs-AI bout, used by balance.mjs -------------------------- */
function simulateAiBout(opts) {
  var game = createGame(opts);
  while (game.phase === 'camp') pickCampCard(game, aiCampPick(game));
  var fight = startFight(game);
  while (!isOver(fight)) {
    if (fight.phase === 'corner') { pickCorner(game, aiCornerPick(game)); continue; }
    var card = chooseAiCard(fight, 'player');
    if (!card) throw new Error('no legal card for ' + fight.player.name);
    playExchange(game, card);
  }
  return { game: game, fight: fight };
}

return {
  makeRng: makeRng, hashSeed: hashSeed, clamp: clamp,
  KIND_LABEL: KIND_LABEL, CARD_ORDER: CARD_ORDER, CARDS: CARDS,
  MATRIX_COLS: MATRIX_COLS, MATRIX_ROWS: MATRIX_ROWS, FLIP: FLIP, RESOLUTION: RESOLUTION,
  CODE_FACTOR: CODE_FACTOR, STYLES: STYLES, HABITS: HABITS, CAMP_CARDS: CAMP_CARDS,
  CORNER_CARDS: CORNER_CARDS, BOXERS: BOXERS, JUDGES: JUDGES,
  createGame: createGame, campOffers: campOffers, pickCampCard: pickCampCard,
  scoutReport: scoutReport, startFight: startFight, legalCards: legalCards,
  cardCost: cardCost, playExchange: playExchange, pickCorner: pickCorner,
  chooseAiCard: chooseAiCard, contextOf: contextOf, aiCampPick: aiCampPick,
  aiCornerPick: aiCornerPick, isOver: isOver, judgeRound: judgeRound,
  scoreRound: scoreRound, simulateAiBout: simulateAiBout, boxerById: boxerById,
  checkStoppage: checkStoppage, rangeAfter: rangeAfter, expectedSwing: expectedSwing,
  maxStamina: maxStamina, isHurt: isHurt, knock: knockdownChance
};
});
