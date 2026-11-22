/* Boxing card, matrix, roster, and tuning data. */
(function (root, factory) {
  var data = factory();
  if (typeof module === 'object' && module.exports) module.exports = data;
  if (typeof window !== 'undefined') window.FightCampData = data;
})(typeof globalThis !== 'undefined' ? globalThis : this, function () {
'use strict';
var KIND_LABEL = { punch: 'Punch', defence: 'Defence', footwork: 'Footwork' };
var CARD_ORDER = ['jab', 'cross', 'lead_hook', 'body_hook', 'uppercut',
  'slip', 'block', 'roll', 'clinch', 'step_back', 'pivot_out', 'cut_off',
  'feint', 'catch_breath', 'check_hook', 'pull_counter', 'cross_counter'];

var CARDS = {
  jab: { id: 'jab', art: 'boxing', name: 'Jab', say: 'jab', kind: 'punch', cost: 4, tags: ['straight'], shape: 'straight', setsUp: true,
    dmg: { head: 4, body: 1 }, acc: 0.9, ranges: ['out', 'mid'],
    effect: 'Cheap straight. Land it and the next punch sits down on target.' },
  cross: { id: 'cross', art: 'boxing', name: 'Cross', say: 'cross', kind: 'punch', cost: 8, tags: ['straight', 'power'], shape: 'straight',
    dmg: { head: 12, body: 3 }, acc: 0.62, ranges: ['mid', 'inside'],
    effect: 'The right hand. A fight-ending shot.' },
  lead_hook: { id: 'lead_hook', art: 'boxing', name: 'Lead hook', say: 'lead hook', kind: 'punch', cost: 8, tags: ['hook'], shape: 'looping',
    dmg: { head: 11, body: 3 }, acc: 0.64, ranges: ['mid', 'inside'],
    effect: 'Comes around the guard; catches an opponent coming in.' },
  body_hook: { id: 'body_hook', art: 'boxing', name: 'Body hook', say: 'body hook', kind: 'punch', cost: 7, tags: ['hook', 'body'], shape: 'looping',
    dmg: { head: 2, body: 10 }, acc: 0.66, ranges: ['inside'],
    effect: 'Digs the body: costs the opponent wind as well as points.' },
  uppercut: { id: 'uppercut', art: 'boxing', name: 'Uppercut', say: 'uppercut', kind: 'punch', cost: 10, tags: ['uppercut'], shape: 'uppercut',
    dmg: { head: 14, body: 3 }, acc: 0.58, ranges: ['inside'],
    effect: 'Up the middle, through the guard. A big shot.' },
  slip: { id: 'slip', art: 'boxing', name: 'Slip', say: 'slip', kind: 'defence', cost: 4, tags: ['evade'], shape: 'evade',
    counter: { head: 3, body: 0 }, guard: 0.36, acc: 0.9, ranges: ['out', 'mid', 'inside'],
    effect: 'Off the line of a straight punch; short counter back.' },
  block: { id: 'block', art: 'boxing', name: 'Block', say: 'block', kind: 'defence', cost: 3, tags: ['guard'], shape: 'guard',
    counter: { head: 2, body: 0 }, guard: 0.55, acc: 0.9, ranges: ['out', 'mid', 'inside'],
    effect: 'Gloves high, take it on the arms. Cheap and safe.' },
  roll: { id: 'roll', art: 'boxing', name: 'Roll', say: 'roll', kind: 'defence', cost: 6, tags: ['evade'], shape: 'evade',
    counter: { head: 3, body: 0 }, guard: 0.3, acc: 0.85, ranges: ['mid', 'inside'],
    effect: 'Roll under the hooks and come back up.' },
  clinch: { id: 'clinch', art: 'boxing', name: 'Clinch', say: 'clinch', kind: 'defence', cost: 4, tags: ['hold'], shape: 'hold',
    counter: { head: 1, body: 3 }, guard: 0.45, acc: 0.9, ranges: ['mid', 'inside'],
    effect: 'Tie up the opponent; their tank pays for the wrestling.' },
  step_back: { id: 'step_back', art: 'boxing', name: 'Step back', say: 'step back', kind: 'footwork', cost: 4, tags: ['escape'], shape: 'escape',
    counter: { head: 2, body: 0 }, guard: 0.32, acc: 0.9, ranges: ['out', 'mid'], rangeAfter: 'out',
    effect: 'Out of range; the opponent punches air.' },
  pivot_out: { id: 'pivot_out', art: 'boxing', name: 'Pivot out', say: 'pivot out', kind: 'footwork', cost: 7, tags: ['escape'], shape: 'escape',
    counter: { head: 1, body: 0 }, guard: 0.4, acc: 0.9, ranges: ['out', 'mid', 'inside', 'ropes'], rangeAfter: 'mid',
    effect: 'Spin off the ropes and reset the angle.' },
  cut_off: { id: 'cut_off', art: 'boxing', name: 'Cut off the ring', say: 'cut off the ring', kind: 'footwork', cost: 6, tags: ['close'], shape: 'close',
    counter: { head: 1, body: 3 }, guard: 0.1, acc: 0.9, ranges: ['mid', 'inside', 'ropes'], rangeAfter: 'inside',
    effect: 'Walk the opponent down and take away the exit.' },
  feint: { id: 'feint', art: 'boxing', name: 'Feint', say: 'feint', kind: 'footwork', cost: 2, tags: ['setup'], shape: 'feint',
    counter: { head: 0, body: 0 }, acc: 0.9, ranges: ['out', 'mid', 'inside'],
    effect: 'A fake. The next punch is sharper, unless a clean hit cancels it.' },
  catch_breath: { id: 'catch_breath', art: 'boxing', name: 'Catch breath', say: 'catch breath', kind: 'footwork', cost: 1, tags: ['rest'], shape: 'rest',
    counter: { head: 0, body: 0 }, acc: 0.9, ranges: ['out', 'mid', 'inside'],
    effect: 'Once a round: 6 wind back, but body shots hurt more this exchange.' },
  check_hook: { id: 'check_hook', art: 'boxing', name: 'Check hook', say: 'check hook', kind: 'punch', cost: 8, tags: ['hook'], shape: 'looping',
    dmg: { head: 10, body: 2 }, acc: 0.62, ranges: ['mid', 'inside'],
    effect: 'Stops a man walking in or holding. Beats Cut off and Clinch.' },
  pull_counter: { id: 'pull_counter', art: 'boxing', name: 'Pull counter', say: 'pull counter', kind: 'defence', cost: 6, tags: ['evade'], shape: 'evade',
    counter: { head: 4, body: 0 }, guard: 0.4, acc: 0.88, ranges: ['out', 'mid'],
    effect: 'Pull back and answer the straight at range. Weak to the body hook.' },
  cross_counter: { id: 'cross_counter', art: 'boxing', name: 'Cross counter', say: 'cross counter', kind: 'punch', cost: 9, tags: ['straight'], shape: 'straight',
    dmg: { head: 13, body: 2 }, acc: 0.6, ranges: ['mid', 'inside'],
    effect: 'Answer a hook with the right hand. Beats the looping shots.' }
};

/* Shape rules build the table: hook beats straight is a rule, not 289 letters.
   SHAPE_MATRIX[row shape][col shape] is the base; EXCEPTIONS are named pairs. */
var SHAPES = ['straight', 'looping', 'uppercut', 'evade', 'guard', 'hold', 'escape', 'close', 'feint', 'rest'];
var SHAPE_MATRIX = {
  straight: { straight: 't', looping: 't', uppercut: 'l', evade: 'l', guard: 'l', hold: 'w', escape: 'l', close: 't', feint: 't', rest: 'w' },
  looping: { straight: 't', looping: 't', uppercut: 'l', evade: 'w', guard: 'l', hold: 't', escape: 'l', close: 't', feint: 't', rest: 'w' },
  uppercut: { straight: 'w', looping: 'w', uppercut: 't', evade: 'w', guard: 'w', hold: 'l', escape: 'l', close: 't', feint: 'n', rest: 'w' },
  evade: { straight: 'w', looping: 'l', uppercut: 'l', evade: 'n', guard: 'n', hold: 'w', escape: 'w', close: 'w', feint: 'n', rest: 'n' },
  guard: { straight: 'w', looping: 'w', uppercut: 'l', evade: 'n', guard: 'n', hold: 'l', escape: 'n', close: 'l', feint: 'l', rest: 'n' },
  hold: { straight: 'l', looping: 't', uppercut: 'w', evade: 'l', guard: 'w', hold: 'n', escape: 'l', close: 't', feint: 'l', rest: 'l' },
  escape: { straight: 'w', looping: 'w', uppercut: 'w', evade: 'l', guard: 'n', hold: 'w', escape: 'n', close: 'l', feint: 'n', rest: 'l' },
  close: { straight: 't', looping: 't', uppercut: 't', evade: 'l', guard: 'w', hold: 't', escape: 'w', close: 'n', feint: 'l', rest: 'w' },
  feint: { straight: 't', looping: 't', uppercut: 'n', evade: 'n', guard: 'w', hold: 'w', escape: 'n', close: 'w', feint: 'n', rest: 'n' },
  rest: { straight: 'l', looping: 'l', uppercut: 'l', evade: 'n', guard: 'n', hold: 'w', escape: 'w', close: 'l', feint: 'n', rest: 'n' }
};
var FLIP = { W: 'X', w: 'l', t: 't', l: 'w', X: 'W', n: 'n' };
var CODE_FACTOR = { W: 1.5, w: 1.15, t: 0.7, l: 0.3, X: 0, n: 0 };
var EXCEPTIONS = {
  'jab>cross': 'l', 'jab>roll': 't', 'jab>step_back': 'w', 'jab>cut_off': 'w',
  'cross>body_hook': 'l', 'cross>slip': 'X', 'cross>roll': 't', 'cross>cut_off': 'l',
  'lead_hook>roll': 'X', 'lead_hook>clinch': 'w', 'lead_hook>pivot_out': 'w',
  'body_hook>cross': 'w', 'body_hook>uppercut': 't', 'body_hook>block': 't', 'body_hook>roll': 'X', 'body_hook>clinch': 'l',
  'uppercut>body_hook': 't', 'uppercut>slip': 'W',
  'slip>jab': 'W', 'slip>cross': 'W', 'slip>uppercut': 'X', 'slip>cross_counter': 'W',
  'block>body_hook': 't',
  'roll>jab': 't', 'roll>cross': 't', 'roll>lead_hook': 'W', 'roll>body_hook': 'W', 'roll>check_hook': 'W', 'roll>clinch': 'l',
  'clinch>lead_hook': 'l', 'clinch>body_hook': 'w', 'clinch>roll': 'w', 'clinch>check_hook': 'X',
  'step_back>jab': 'l', 'step_back>cut_off': 'X',
  'pivot_out>lead_hook': 'l', 'pivot_out>check_hook': 'X', 'pivot_out>cut_off': 'w', 'cut_off>pivot_out': 'l',
  'pivot_out>jab': 't', 'pivot_out>cross': 'l',
  'cut_off>jab': 'l', 'cut_off>cross': 'w', 'cut_off>step_back': 'W', 'cut_off>pivot_out': 'l', 'cut_off>check_hook': 'X',
  'check_hook>cut_off': 'W', 'check_hook>clinch': 'W', 'check_hook>pivot_out': 'W',
  'cross>feint': 'w', 'lead_hook>feint': 'w',
  'pull_counter>jab': 'W', 'pull_counter>cross': 'W', 'pull_counter>cross_counter': 'W',
  'cross_counter>lead_hook': 'W', 'cross_counter>body_hook': 'W', 'cross_counter>check_hook': 'W'
};
var REASONS = {
  'cross>jab': 'Cross beats Jab at mid/inside', 'jab>cross': 'Cross beats Jab at mid/inside',
  'slip>cross': 'Slip counters Cross', 'cross>slip': 'Slip counters Cross',
  'slip>jab': 'Slip counters Jab', 'jab>slip': 'Slip counters Jab',
  'slip>cross_counter': 'Slip counters Cross counter', 'cross_counter>slip': 'Slip counters Cross counter',
  'slip>lead_hook': 'Slip counters Lead hook on the inside', 'lead_hook>slip': 'Slip counters Lead hook on the inside',
  'roll>body_hook': 'Roll counters Body hook', 'body_hook>roll': 'Roll counters Body hook',
  'roll>lead_hook': 'Roll counters Lead hook', 'lead_hook>roll': 'Roll counters Lead hook',
  'roll>check_hook': 'Roll counters Check hook', 'check_hook>roll': 'Roll counters Check hook',
  'uppercut>slip': 'Uppercut counters Slip — slipping into it', 'slip>uppercut': 'Uppercut counters Slip — slipping into it',
  'uppercut>roll': 'Uppercut catches Roll', 'roll>uppercut': 'Uppercut catches Roll',
  'cut_off>step_back': 'Cut off counters Step back', 'step_back>cut_off': 'Cut off counters Step back',
  'check_hook>cut_off': 'Check hook beats Cut off', 'cut_off>check_hook': 'Check hook beats Cut off',
  'check_hook>clinch': 'Check hook beats Clinch', 'clinch>check_hook': 'Check hook beats Clinch',
  'check_hook>pivot_out': 'Check hook catches Pivot out', 'pivot_out>check_hook': 'Check hook catches Pivot out',
  'lead_hook>pivot_out': 'Lead hook catches Pivot out', 'pivot_out>lead_hook': 'Lead hook catches Pivot out',
  'pivot_out>cut_off': 'Stepping out against a man cutting the ring is a trade',
  'cut_off>pivot_out': 'Stepping out against a man cutting the ring is a trade',
  'pull_counter>jab': 'Pull counter beats Jab at range', 'jab>pull_counter': 'Pull counter beats Jab at range',
  'pull_counter>cross': 'Pull counter beats Cross at range', 'cross>pull_counter': 'Pull counter beats Cross at range',
  'pull_counter>cross_counter': 'Pull counter beats Cross counter', 'cross_counter>pull_counter': 'Pull counter beats Cross counter',
  'cross_counter>lead_hook': 'Cross counter beats Lead hook', 'lead_hook>cross_counter': 'Cross counter beats Lead hook',
  'cross_counter>body_hook': 'Cross counter beats Body hook', 'body_hook>cross_counter': 'Cross counter beats Body hook',
  'cross_counter>check_hook': 'Cross counter beats Check hook', 'check_hook>cross_counter': 'Cross counter beats Check hook',
  'clinch>uppercut': 'Clinch smothers Uppercut', 'uppercut>clinch': 'Clinch smothers Uppercut',
  'clinch>roll': 'Clinch smothers Roll', 'roll>clinch': 'Clinch smothers Roll',
  'feint>block': 'Feint draws the guard', 'block>feint': 'Feint draws the guard',
  'feint>clinch': 'Feint makes a holding man reach', 'clinch>feint': 'Feint makes a holding man reach',
  'jab>feint': 'A straight punches through a feint', 'feint>jab': 'A straight punches through a feint',
  'cross>feint': 'A straight punches through a feint', 'feint>cross': 'A straight punches through a feint',
  'lead_hook>feint': 'A hook punishes a feint', 'feint>lead_hook': 'A hook punishes a feint',
  'body_hook>feint': 'A hook punishes a feint', 'feint>body_hook': 'A hook punishes a feint',
  'body_hook>catch_breath': 'A body hook punishes a man catching breath', 'catch_breath>body_hook': 'A body hook punishes a man catching breath',
};
function shapeOf(id) { return CARDS[id].shape; }
function baseCode(a, b) {
  var key = a + '>' + b, rev = b + '>' + a;
  if (EXCEPTIONS[key]) return EXCEPTIONS[key];
  if (EXCEPTIONS[rev]) return FLIP[EXCEPTIONS[rev]];
  return SHAPE_MATRIX[shapeOf(a)][shapeOf(b)];
}
var MATRIX_COLS = CARD_ORDER.join(' ');
var MATRIX_ROWS = CARD_ORDER.map(function (a) {
  return CARD_ORDER.map(function (b) { return baseCode(a, b); }).join('');
});
var RESOLUTION = {};
CARD_ORDER.forEach(function (a) {
  RESOLUTION[a] = {};
  CARD_ORDER.forEach(function (b) { RESOLUTION[a][b] = baseCode(a, b); });
});
var SHAPE_OPPOSITE = { straight: 'looping', looping: 'straight', uppercut: 'evade', evade: 'uppercut', guard: 'hold', hold: 'guard', escape: 'close', close: 'escape', feint: 'rest', rest: 'feint' };
var SHAPE_LABEL = { straight: 'loading a straight', looping: 'loading a looping shot', uppercut: 'loading an uppercut', evade: 'looking to evade', guard: 'gloves high', hold: 'looking to tie up', escape: 'looking to move out', close: 'walking you down', feint: 'feinting', rest: 'catching breath' };

/* --- styles: how a corner likes to fight (1 = neutral) -------------------- */
var STYLES = {
  out: { id: 'out', name: 'Out-boxer', blurb: 'Boxes at range, on the back foot, and wins on the jab.', weights: {
    jab: 1.5, cross: 1.25, lead_hook: 1.0, body_hook: 0.6, uppercut: 0.55, slip: 1.25, block: 1.0, roll: 1.0,
    clinch: 0.8, step_back: 1.05, pivot_out: 1.25, cut_off: 0.7, feint: 1.1, catch_breath: 0.7, check_hook: 0.8, pull_counter: 1.2, cross_counter: 0.9 } },
  pressure: { id: 'pressure', name: 'Pressure fighter', blurb: 'Walks you down, works the body, smothers you inside.', weights: {
    jab: 1.2, cross: 1.1, lead_hook: 1.2, body_hook: 1.6, uppercut: 0.9, slip: 0.8, block: 0.9, roll: 0.7,
    clinch: 1.3, step_back: 0.4, pivot_out: 0.5, cut_off: 1.5, feint: 0.9, catch_breath: 0.8, check_hook: 1.3, pull_counter: 0.6, cross_counter: 1.0 } },
  counter: { id: 'counter', name: 'Counter-puncher', blurb: 'Waits, makes you miss, and answers with the right hand.', weights: {
    jab: 0.95, cross: 1.4, lead_hook: 0.85, body_hook: 0.6, uppercut: 1.6, slip: 1.45, block: 1.2, roll: 1.35,
    clinch: 0.7, step_back: 1.2, pivot_out: 0.9, cut_off: 0.5, feint: 1.3, catch_breath: 0.9, check_hook: 0.9, pull_counter: 1.4, cross_counter: 1.3 } },
  volume: { id: 'volume', name: 'Volume puncher', blurb: 'Throws in bunches and tries to out-work you.', weights: {
    jab: 1.62, cross: 1.19, lead_hook: 1.51, body_hook: 1.3, uppercut: 0.86, slip: 0.95, block: 1.05, roll: 0.85,
    clinch: 0.8, step_back: 0.8, pivot_out: 0.85, cut_off: 1.0, feint: 1.0, catch_breath: 1.1, check_hook: 1.0, pull_counter: 0.9, cross_counter: 1.1 } }
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

/* --- camp cards: 4 weeks, 1 of 3 each. Each pick adds and removes one. --- */
var CAMP_CARDS = [
  { id: 'double_jab', name: 'Double-jab drills', add: { jab: 2 }, stat: { technique: 4 }, text: 'Two more jabs in the deck, +4 Technique.' },
  { id: 'right_hand', name: 'Right-hand work', add: { cross: 1 }, stat: { power: 4 }, text: 'One more cross, +4 Power. The right hand ends fights.' },
  { id: 'body_work', name: 'Body work', add: { body_hook: 1 }, stat: { power: 4 }, text: 'One more body hook, +4 Power. The opponent’s tank pays.' },
  { id: 'head_movement', name: 'Head movement', add: { slip: 1, roll: 1 }, stat: { defence: 3 }, text: 'A slip and a roll in the deck, +3 Defence.' },
  { id: 'guard_drill', name: 'Guard drill', add: { block: 1 }, stat: { defence: 4 }, text: 'One more block, +4 Defence. Nothing is free.' },
  { id: 'ring_craft', name: 'Ring craft', add: { pivot_out: 1, cut_off: 1 }, stat: { speed: 3 }, text: 'A pivot and a cut-off in the deck, +3 Speed.' },
  { id: 'uppercut_pads', name: 'Uppercut on the pads', add: { uppercut: 1 }, stat: { power: 4 }, text: 'One more uppercut for the inside, +4 Power.' },
  { id: 'roadwork', name: 'Roadwork', stat: { stamina: 5 }, text: '+5 Stamina: more wind, cheaper cards. One card leaves the deck.' },
  { id: 'weights', name: 'Weight work', stat: { power: 5 }, text: '+5 Power: every punch hurts more. One card leaves the deck.' },
  { id: 'ladder', name: 'Speed ladder', stat: { speed: 5 }, text: '+5 Speed: sharper counters, more ties won. One card leaves the deck.' },
  { id: 'sparring', name: 'Hard sparring', stat: { technique: 4, chin: 2 }, text: '+4 Technique, +2 Chin.' },
  { id: 'film', name: 'Film study', stat: { defence: 3 }, scout: 1, text: '+3 Defence and one more habit in the file.' },
  { id: 'feint_work', name: 'Feint work', add: { feint: 1 }, stat: { technique: 4 }, text: 'One feint in the deck, +4 Technique. Set up the next punch.' },
  { id: 'check_hook_drill', name: 'Check-hook drill', add: { check_hook: 1 }, stat: { speed: 4 }, text: 'One check hook, +4 Speed. Beats Cut off and Clinch.' },
  { id: 'counter_drill', name: 'Counter drill', add: { pull_counter: 1, cross_counter: 1 }, stat: { technique: 4 }, text: 'A pull counter and a cross counter in the deck, +4 Technique.' },
  { id: 'breath_drill', name: 'Breath work', add: { catch_breath: 1 }, stat: { stamina: 5 }, text: 'One catch breath, +5 Stamina. 6 wind back, once a round.' }
];

/* --- corner cards: between rounds, 1 of 3, each costs something ---------- */
var CORNER_CARDS = [
  { id: 'ice_eye', name: 'Ice the eye', text: 'Take 10 off the head damage you carry. It costs 5 wind.',
    healHead: 10, stamina: -5 },
  { id: 'breathe', name: 'Breathe', text: '+20 wind, but you feel your way in: your first exchange is light.',
    stamina: 20, mod: { firstExchange: -0.35 } },
  { id: 'gloves_high', name: 'Gloves high', text: 'Block is 1 cheaper next round; your punches land 15% softer.',
    mod: { block_discount: 1, punch: -0.15 } },
  { id: 'change_plan', name: 'Change the plan', text: 'Draw 2 cards now. It costs 6 wind to think.',
    draw: 2, stamina: -6 },
  { id: 'stool', name: 'Sit on the stool', text: '+10 wind and 6 off the body, but you take 20% more in the first exchange and the opponent draws one extra card.',
    stamina: 10, healBody: 6, mod: { takenFirst: 0.2 }, foeDraw: 1 },
  { id: 'study', name: 'Study the opponent’s corner', text: 'One more habit in the file. 3 wind to study the opponent.',
    scout: 1, stamina: -3 },
  { id: 'go_body', name: 'Go to the body', text: 'Next round your body punches land 25% harder and your head punches 15% softer.',
    mod: { bodyPunch: 0.25, headPunch: -0.15 } },
  { id: 'box_move', name: 'Box and move', text: 'The round opens at range and Step back costs 1 wind; your punches land 10% softer.',
    mod: { startOut: true, stepCheap: true, punch: -0.10 } }
];

/* --- the roster (prototype: boxing only) --------------------------------- */
var BOXERS = [
  { id: 'ada', name: 'Ada Nowak', pronoun: 'she', poss: 'her', style: 'out', club: 'North', blurb: 'Schooled amateur. Best feet in the gym.',
    stats: { power: 54, speed: 82, stamina: 68, chin: 55, technique: 80, defence: 68 },
    deck: ['jab', 'jab', 'cross', 'lead_hook', 'uppercut', 'slip', 'slip', 'block', 'step_back', 'pivot_out', 'cut_off', 'cut_off', 'feint', 'catch_breath'],
    habits: ['jab_to_open', 'cut_the_ring'] },
  { id: 'mara', name: 'Mara Okafor', pronoun: 'she', poss: 'her', style: 'pressure', club: 'South', blurb: 'Never takes a step back. Body first.',
    stats: { power: 74, speed: 58, stamina: 84, chin: 76, technique: 60, defence: 58 },
    deck: ['jab', 'body_hook', 'body_hook', 'lead_hook', 'uppercut', 'slip', 'roll', 'block', 'clinch', 'clinch', 'cut_off', 'cut_off', 'pivot_out', 'catch_breath', 'feint'],
    habits: ['body_when_tired', 'clinch_when_hurt'] },
  { id: 'tomas', name: 'Tomas Reiner', pronoun: 'he', poss: 'his', style: 'counter', club: 'North', blurb: 'Won the nationals by making people miss.',
    stats: { power: 66, speed: 78, stamina: 64, chin: 70, technique: 82, defence: 80 },
    deck: ['jab', 'cross', 'cross', 'uppercut', 'lead_hook', 'block', 'slip', 'slip', 'roll', 'clinch', 'clinch', 'step_back', 'pivot_out', 'catch_breath', 'check_hook'],
    habits: ['slip_the_cross', 'hold_when_ahead'] },
  { id: 'ines', name: 'Ines Duarte', pronoun: 'she', poss: 'her', style: 'volume', club: 'North', blurb: 'Throws thirty a round and never sits down.',
    stats: { power: 60, speed: 70, stamina: 80, chin: 62, technique: 70, defence: 60 },
    deck: ['jab', 'jab', 'cross', 'cross', 'lead_hook', 'body_hook', 'uppercut', 'block', 'block', 'slip', 'roll', 'step_back', 'cut_off', 'catch_breath', 'feint'],
    habits: ['right_after_jab', 'cut_the_ring'] },
  { id: 'kwame', name: 'Kwame Boateng', pronoun: 'he', poss: 'his', style: 'pressure', club: 'South', blurb: 'A cruiserweight who fights like a middleweight.',
    stats: { power: 86, speed: 48, stamina: 70, chin: 80, technique: 54, defence: 50 },
    deck: ['jab', 'body_hook', 'body_hook', 'uppercut', 'uppercut', 'slip', 'roll', 'clinch', 'clinch', 'cut_off', 'cut_off', 'step_back'],
    habits: ['uppercut_when_crowded', 'clinch_when_hurt'] },
  { id: 'lena', name: 'Lena Voss', pronoun: 'she', poss: 'her', style: 'out', club: 'South', blurb: 'Tall, awkward, walks onto a right hand now and then.',
    stats: { power: 64, speed: 72, stamina: 64, chin: 82, technique: 70, defence: 66 },
    deck: ['jab', 'jab', 'cross', 'lead_hook', 'uppercut', 'slip', 'roll', 'roll', 'step_back', 'pivot_out', 'pivot_out', 'block'],
    habits: ['jab_to_open', 'roll_the_hooks'] },
  { id: 'rio', name: 'Rio Tanaka', pronoun: 'he', poss: 'his', style: 'counter', club: 'North', blurb: 'Fast hands, slower feet. Loves the check hook.',
    stats: { power: 62, speed: 90, stamina: 66, chin: 62, technique: 80, defence: 74 },
    deck: ['jab', 'cross', 'cross', 'uppercut', 'body_hook', 'slip', 'roll', 'roll', 'clinch', 'clinch', 'step_back', 'pivot_out'],
    habits: ['roll_the_hooks', 'hold_when_ahead'] },
  { id: 'piotr', name: 'Piotr Zawada', pronoun: 'he', poss: 'his', style: 'volume', club: 'South', blurb: 'Tough as a boot. Wins the last round every time.',
    stats: { power: 72, speed: 66, stamina: 90, chin: 76, technique: 62, defence: 58 },
    deck: ['jab', 'jab', 'lead_hook', 'body_hook', 'body_hook', 'uppercut', 'block', 'slip', 'clinch', 'step_back', 'step_back', 'cut_off'],
    habits: ['body_when_tired', 'step_back_when_hit'] }
];

/* Judges score landed punches and damage, with a taste and a little noise. */
var JUDGES = [
  { name: 'J. Alvarez', landed: 3.2, damage: 0.05, aggression: 0.30, noise: 0.18, defence: 0.10, taste: 'Counts landed punches; hard shots score no more than light ones.' },
  { name: 'M. Petrov', landed: 0.10, damage: 1.75, aggression: 0.05, noise: 0.06, defence: 0.10, taste: 'Scores damage above all.' },
  { name: 'S. Boateng', landed: 2.2, damage: 0.30, aggression: 1.60, noise: 0.20, defence: 0.15, taste: 'Rewards the busier boxer: punches thrown and landed.' },
  { name: 'K. Osei', landed: 0.30, damage: 1.00, aggression: 0.05, noise: 0.12, defence: 0.90, taste: 'Scores defence: making the other one miss counts double.' },
  { name: 'A. Novak', landed: 1.9, damage: 0.70, aggression: 0.30, noise: 0.16, defence: 0.30, taste: 'Leans to the cleaner, busier work over the single hard shot.' }
];

/* Situational nudges for the AI: the same card is not worth the same always. */
var SITUATION_RULES = [
  { when: { lastOppStraight: true }, cards: ['slip', 'pull_counter'], mul: 1.4 },
  { when: { lastOppHook: true }, cards: ['roll', 'cross_counter'], mul: 1.4 },
  { when: { foeLowStamina: true }, cards: ['body_hook', 'cut_off'], mul: 1.3 },
  { when: { selfHurt: true }, cards: ['block', 'clinch', 'step_back'], mul: 1.25 },
  { when: { foeHurt: true }, cards: ['cross', 'uppercut', 'lead_hook'], mul: 1.2 },
  { when: { exchange: 0 }, cards: ['jab'], mul: 1.25 },
  { when: { combo: true }, cards: ['cross', 'lead_hook', 'uppercut'], mul: 1.3 },
  { when: { gassed: true }, cards: ['block', 'step_back', 'clinch'], mul: 1.3 },
  /* Round 4: the pressure ladder. A won cut off is followed by work inside; a
     man on the ropes looks for the pivot, and the other one lets his hands go. */
  { when: { pressing: true }, cards: ['body_hook', 'uppercut', 'lead_hook', 'cross'], mul: 1.4 },
  { when: { onRopes: true }, cards: ['pivot_out'], mul: 3.0 },
  { when: { onRopes: true }, cards: ['clinch'], mul: 1.3 },
  { when: { foeOnRopes: true }, cards: ['body_hook', 'uppercut', 'lead_hook'], mul: 1.3 }
];
/* Measured over 250 bouts a drill in balance.mjs: how much each camp card moved
   the win rate. The informed corner ranks the week's offers with it. */
var DRILL_VALUE = { right_hand: 7.2, weights: 6.0, sparring: 4.4, head_movement: 4.8, counter_drill: 4.8,
  ladder: 3.6, body_work: 3.4, feint_work: 3.2, roadwork: 2.6, check_hook_drill: 1.6, ring_craft: 1.2,
  double_jab: 1.0, film: 0.8, uppercut_pads: -0.4, guard_drill: -0.8, breath_drill: -1.0 };
var CAMP_PREF = {
  out: ['right_hand', 'head_movement', 'weights', 'counter_drill', 'feint_work', 'ladder', 'sparring', 'body_work'],
  pressure: ['right_hand', 'weights', 'body_work', 'counter_drill', 'head_movement', 'feint_work', 'sparring', 'ladder'],
  counter: ['right_hand', 'head_movement', 'counter_drill', 'weights', 'feint_work', 'sparring', 'ladder', 'body_work'],
  volume: ['right_hand', 'head_movement', 'weights', 'counter_drill', 'body_work', 'feint_work', 'sparring', 'ladder']
};

return {KIND_LABEL: KIND_LABEL, CARD_ORDER: CARD_ORDER, CARDS: CARDS, MATRIX_COLS: MATRIX_COLS, MATRIX_ROWS: MATRIX_ROWS, FLIP: FLIP, CODE_FACTOR: CODE_FACTOR, RESOLUTION: RESOLUTION, STYLES: STYLES, HABITS: HABITS, CAMP_CARDS: CAMP_CARDS, CORNER_CARDS: CORNER_CARDS, BOXERS: BOXERS, JUDGES: JUDGES, SITUATION_RULES: SITUATION_RULES, CAMP_PREF: CAMP_PREF, SHAPES: SHAPES, SHAPE_MATRIX: SHAPE_MATRIX, EXCEPTIONS: EXCEPTIONS, REASONS: REASONS, SHAPE_OPPOSITE: SHAPE_OPPOSITE, SHAPE_LABEL: SHAPE_LABEL, DRILL_VALUE: DRILL_VALUE};
});
