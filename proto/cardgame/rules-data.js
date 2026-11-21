/* Boxing card, matrix, roster, and tuning data. */
(function (root, factory) {
  var data = factory();
  if (typeof module === 'object' && module.exports) module.exports = data;
  if (typeof window !== 'undefined') window.FightCampData = data;
})(typeof globalThis !== 'undefined' ? globalThis : this, function () {
'use strict';
var KIND_LABEL = { punch: 'Punch', defence: 'Defence', footwork: 'Footwork' };
var CARD_ORDER = ['jab', 'cross', 'lead_hook', 'body_hook', 'uppercut',
  'slip', 'block', 'roll', 'clinch', 'step_back', 'pivot_out', 'cut_off'];

var CARDS = {
  jab: { id: 'jab', art: 'boxing', name: 'Jab', say: 'jab', kind: 'punch', cost: 3, tags: ['straight'], shape: 'straight', setsUp: true,
    dmg: { head: 4, body: 1 }, acc: 0.9, ranges: ['out', 'mid'],
    effect: 'Cheap straight. Land it and the next punch sits down on target.' },
  cross: { id: 'cross', art: 'boxing', name: 'Cross', say: 'cross', kind: 'punch', cost: 6, tags: ['straight', 'power'], shape: 'straight',
    dmg: { head: 12, body: 3 }, acc: 0.62, ranges: ['mid', 'inside'],
    effect: 'The right hand. A fight-ending shot.' },
  lead_hook: { id: 'lead_hook', art: 'boxing', name: 'Lead hook', say: 'lead hook', kind: 'punch', cost: 6, tags: ['hook'], shape: 'looping',
    dmg: { head: 11, body: 3 }, acc: 0.64, ranges: ['mid', 'inside'],
    effect: 'Comes around the guard; catches an opponent coming in.' },
  body_hook: { id: 'body_hook', art: 'boxing', name: 'Body hook', say: 'body hook', kind: 'punch', cost: 5, tags: ['hook', 'body'], shape: 'looping',
    dmg: { head: 2, body: 10 }, acc: 0.66, ranges: ['inside'],
    effect: 'Digs the body: costs the opponent wind as well as points.' },
  uppercut: { id: 'uppercut', art: 'boxing', name: 'Uppercut', say: 'uppercut', kind: 'punch', cost: 7, tags: ['uppercut'], shape: 'uppercut',
    dmg: { head: 14, body: 3 }, acc: 0.58, ranges: ['inside'],
    effect: 'Up the middle, through the guard. A big shot.' },
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
    effect: 'Tie up the opponent; their tank pays for the wrestling.' },
  step_back: { id: 'step_back', art: 'boxing', name: 'Step back', say: 'step back', kind: 'footwork', cost: 3, tags: ['escape'],
    counter: { head: 2, body: 0 }, guard: 0.32, acc: 0.9, ranges: ['out', 'mid'], rangeAfter: 'out',
    effect: 'Out of range; the opponent punches air.' },
  pivot_out: { id: 'pivot_out', art: 'boxing', name: 'Pivot out', say: 'pivot out', kind: 'footwork', cost: 5, tags: ['escape'],
    counter: { head: 1, body: 0 }, guard: 0.4, acc: 0.9, ranges: ['out', 'mid', 'inside'], rangeAfter: 'mid',
    effect: 'Spin off the ropes and reset the angle.' },
  cut_off: { id: 'cut_off', art: 'boxing', name: 'Cut off the ring', say: 'cut off the ring', kind: 'footwork', cost: 4, tags: ['close'],
    counter: { head: 1, body: 3 }, guard: 0.1, acc: 0.9, ranges: ['mid', 'inside'], rangeAfter: 'inside',
    effect: 'Walk the opponent down and take away the exit.' }
};

/* Resolution table: the row card played against the column card.
   W you crush it (the opponent whiffs, you land full)   w you win the exchange
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

/* The read: habits. If the situation in `when` is true and the signature card is in hand,
   the opponent chooses it 70% of the time. That is what makes the scouting
   file and the corner worth the trouble. Shown to the player as words. */
var HABITS = {
  jab_to_open: { id: 'jab_to_open', text: 'The opponent opens every round with the jab.', when: { exchange: 0 }, play: 'jab' },
  right_after_jab: { id: 'right_after_jab', text: 'After their own jab, the opponent sits down on the right hand.', when: { lastSelfCard: 'jab' }, play: 'cross' },
  clinch_when_hurt: { id: 'clinch_when_hurt', text: 'When hurt, the opponent holds and looks for the clinch.', when: { selfHurt: true }, play: 'clinch' },
  step_back_when_hit: { id: 'step_back_when_hit', text: 'After a clean hit, the opponent gives ground.', when: { lastTookClean: true }, play: 'step_back' },
  body_when_tired: { id: 'body_when_tired', text: 'With wind low, the opponent digs the body hook.', when: { selfLowStamina: true }, play: 'body_hook' },
  uppercut_when_crowded: { id: 'uppercut_when_crowded', text: 'When crowded, the opponent fires the uppercut.', when: { inFightRange: 'inside' }, play: 'uppercut' },
  hold_when_ahead: { id: 'hold_when_ahead', text: 'Ahead on damage, the opponent holds to kill the round.', when: { selfAhead: true }, play: 'clinch' },
  slip_the_cross: { id: 'slip_the_cross', text: 'The opponent slips the right hand.', when: { lastOppCard: 'cross' }, play: 'slip' },
  roll_the_hooks: { id: 'roll_the_hooks', text: 'The opponent rolls under your hooks.', when: { lastOppCard: 'lead_hook' }, play: 'roll' },
  cut_the_ring: { id: 'cut_the_ring', text: 'Step away and the opponent cuts the ring off.', when: { lastOppCard: 'step_back' }, play: 'cut_off' }
};

/* --- camp cards: 4 weeks, 1 of 3 each ------------------------------------ */
var CAMP_CARDS = [
  { id: 'double_jab', name: 'Double-jab drills', add: { jab: 2 }, text: 'Two more jabs in the deck.' },
  { id: 'right_hand', name: 'Right-hand work', add: { cross: 1 }, text: 'One more cross. The right hand ends fights.' },
  { id: 'body_work', name: 'Body work', add: { body_hook: 1 }, text: 'One more body hook. The opponent’s tank pays.' },
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
  { id: 'stool', name: 'Sit on the stool', text: '+10 wind and 6 off the body, but the opponent starts the next round faster.',
    stamina: 10, healBody: 6, mod: { foe_first: 0.2 } },
  { id: 'study', name: 'Study the opponent’s corner', text: 'One more habit in the file. 3 wind to study the opponent.',
    scout: 1, stamina: -3 }
];

/* --- the roster (prototype: boxing only) --------------------------------- */
var BOXERS = [
  { id: 'ada', name: 'Ada Nowak', pronoun: 'she', poss: 'her', style: 'out', blurb: 'Schooled amateur. Best feet in the gym.',
    stats: { power: 54, speed: 82, stamina: 68, chin: 55, technique: 80, defence: 68 },
    deck: ['jab', 'jab', 'cross', 'lead_hook', 'uppercut', 'slip', 'slip', 'block', 'step_back', 'pivot_out', 'cut_off', 'cut_off'],
    habits: ['jab_to_open', 'cut_the_ring'] },
  { id: 'mara', name: 'Mara Okafor', pronoun: 'she', poss: 'her', style: 'pressure', blurb: 'Never takes a step back. Body first.',
    stats: { power: 74, speed: 58, stamina: 84, chin: 76, technique: 60, defence: 58 },
    deck: ['jab', 'body_hook', 'body_hook', 'lead_hook', 'uppercut', 'slip', 'roll', 'clinch', 'clinch', 'cut_off', 'cut_off', 'pivot_out'],
    habits: ['body_when_tired', 'clinch_when_hurt'] },
  { id: 'tomas', name: 'Tomas Reiner', pronoun: 'he', poss: 'his', style: 'counter', blurb: 'Won the nationals by making people miss.',
    stats: { power: 62, speed: 74, stamina: 60, chin: 66, technique: 78, defence: 76 },
    deck: ['jab', 'cross', 'cross', 'uppercut', 'lead_hook', 'slip', 'slip', 'roll', 'clinch', 'clinch', 'step_back', 'pivot_out'],
    habits: ['slip_the_cross', 'hold_when_ahead'] },
  { id: 'ines', name: 'Ines Duarte', pronoun: 'she', poss: 'her', style: 'volume', blurb: 'Throws thirty a round and never sits down.',
    stats: { power: 60, speed: 70, stamina: 80, chin: 62, technique: 70, defence: 60 },
    deck: ['jab', 'jab', 'cross', 'cross', 'lead_hook', 'body_hook', 'uppercut', 'block', 'slip', 'roll', 'step_back', 'cut_off'],
    habits: ['right_after_jab', 'cut_the_ring'] },
  { id: 'kwame', name: 'Kwame Boateng', pronoun: 'he', poss: 'his', style: 'pressure', blurb: 'A cruiserweight who fights like a middleweight.',
    stats: { power: 86, speed: 48, stamina: 70, chin: 80, technique: 54, defence: 50 },
    deck: ['jab', 'body_hook', 'body_hook', 'uppercut', 'uppercut', 'slip', 'roll', 'clinch', 'clinch', 'cut_off', 'cut_off', 'step_back'],
    habits: ['uppercut_when_crowded', 'clinch_when_hurt'] },
  { id: 'lena', name: 'Lena Voss', pronoun: 'she', poss: 'her', style: 'out', blurb: 'Tall, awkward, walks onto a right hand now and then.',
    stats: { power: 64, speed: 72, stamina: 64, chin: 82, technique: 70, defence: 66 },
    deck: ['jab', 'jab', 'cross', 'lead_hook', 'uppercut', 'slip', 'roll', 'roll', 'step_back', 'pivot_out', 'pivot_out', 'block'],
    habits: ['jab_to_open', 'roll_the_hooks'] },
  { id: 'rio', name: 'Rio Tanaka', pronoun: 'he', poss: 'his', style: 'counter', blurb: 'Fast hands, slower feet. Loves the check hook.',
    stats: { power: 58, speed: 88, stamina: 62, chin: 58, technique: 76, defence: 70 },
    deck: ['jab', 'cross', 'cross', 'uppercut', 'body_hook', 'slip', 'roll', 'roll', 'clinch', 'clinch', 'step_back', 'pivot_out'],
    habits: ['roll_the_hooks', 'hold_when_ahead'] },
  { id: 'piotr', name: 'Piotr Zawada', pronoun: 'he', poss: 'his', style: 'volume', blurb: 'Tough as a boot. Wins the last round every time.',
    stats: { power: 68, speed: 62, stamina: 90, chin: 72, technique: 58, defence: 54 },
    deck: ['jab', 'jab', 'lead_hook', 'body_hook', 'body_hook', 'uppercut', 'block', 'slip', 'clinch', 'step_back', 'step_back', 'cut_off'],
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

return {KIND_LABEL: KIND_LABEL, CARD_ORDER: CARD_ORDER, CARDS: CARDS, MATRIX_COLS: MATRIX_COLS, MATRIX_ROWS: MATRIX_ROWS, FLIP: FLIP, CODE_FACTOR: CODE_FACTOR, RESOLUTION: RESOLUTION, STYLES: STYLES, HABITS: HABITS, CAMP_CARDS: CAMP_CARDS, CORNER_CARDS: CORNER_CARDS, BOXERS: BOXERS, JUDGES: JUDGES, SITUATION_RULES: SITUATION_RULES, CAMP_PREF: CAMP_PREF};
});
