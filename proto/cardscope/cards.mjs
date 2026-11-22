// CARDSCOPE greybox (round 2) - card data, numbers, boxers. Pure data, no DOM. See ops/research/DESIGN_CARDGAME_SCOPE.md.
// Play codes: what lies on a beat. A Block card in hand is played as BLOCK (high) or BLOCK_LOW.
export const EMPTY = 0, JAB = 1, BJAB = 2, CROSS = 3, LHOOK = 4, BHOOK = 5, UPPER = 6, XC = 7,
  BLOCK = 8, BLOCK_LOW = 9, SLIP = 10, ROLL = 11, STEP = 12, TIE = 13, FEINT = 14, CHK = 15, NCODES = 16;

export const NAME = ['-', 'Jab', 'Body jab', 'Cross', 'Lead hook', 'Body hook', 'Uppercut', 'Cross counter',
  'Block high', 'Block low', 'Slip', 'Roll', 'Step back', 'Tie up', 'Feint', 'Check hook'];
//                      -  J  BJ CR LH BH UP XC BL BL SL RO ST TI FE CH
export const COST =    [0, 1, 1, 2, 2, 3, 3, 3, 1, 1, 2, 2, 2, 2, 0, 2];   // round 2: Tie up 1 -> 2; resize: Body hook 2 -> 3
export const DMG =     [0, 2, 2, 6, 6, 4, 10, 6, 0, 0, 0, 0, 0, 0, 0, 4];
export const IS_PUNCH = [0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1];
export const BODY =    [0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];   // 1 = aimed at the body
export const SHAPE =   [0, 1, 1, 1, 2, 2, 3, 1, 0, 0, 0, 0, 0, 0, 0, 2];   // 1 straight, 2 hook, 3 uppercut
export const SPEED =   [0, 1, 1, 2, 2, 2, 3, 3, 0, 0, 0, 0, 0, 0, 0, 2];   // 1 fast .. 3 slow
export const POWER =   [0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1];   // takes the Power bonus
export const IS_GUARD = [0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0];  // what a feint draws
export const CHK_BEATS = [0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0]; // the trap: a check hook beats a jab or a block
// What a card is when it lies face down: 0 nothing, 1 a punch, 2 a guard or the trap, 3 a feint.
export const KIND =    [0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 2];
export const cardOf = (code) => (code === BLOCK_LOW ? BLOCK : code);     // play code -> card in hand
// The fourteen cards a deck can hold.
export const CARDS = [JAB, BJAB, CROSS, LHOOK, BHOOK, UPPER, XC, BLOCK, SLIP, ROLL, STEP, TIE, FEINT, CHK];

// Every number of the design in one place. A resize edits this object and nothing else.
export const CFG = {
  beats: 3, exchanges: 4, rounds: 3, hand: 5,
  windCap: 7, windBack: 3, windStool: 2, windEmptyBeat: 1,
  bodyPerBack: 6, minBack: 1, bodyHookWind: 2, tiredAt: 1,
  chin: 112, chinScale: 0.85, hurtAt: 70, kdLine: 24, kdLineHurt: 18, kdWind: 2, kdStop: 3,
  counterBonus: 4, chain: 2, oneTwo: 4, bodyHead: 4, oneTwoThree: 6, feintBonus: 4,
  slowerLoses: 2, wrongEvade: 2, smother: 4, xcDamage: 6, blockStops: 4, chkDamage: 6,
  ice: 30, waterBack: 0, hideGuard: 1.5,
  judgeClean: 2, judgeThrown: 0.5, judgeDamage: 1 / 6, judgeCraft: 1, judgeGuard: 0,
  deckMin: 12, deckMax: 16, copyMax: 4, xcMax: 2,
};
// A deck is legal when it holds 12 to 16 cards, at most 4 of a card and at most 2 Cross counters.
export function deckLegal(d) {
  if (d.length < CFG.deckMin || d.length > CFG.deckMax) return false;
  const n = new Int32Array(NCODES); for (const c of d) n[c]++;
  for (const c of CARDS) if (n[c] > (c === XC ? CFG.xcMax : CFG.copyMax)) return false;
  return true;
}

export const deck = (spec) => {
  const out = [];
  for (const [card, n] of spec) for (let i = 0; i < n; i++) out.push(card);
  return out;
};

// Player boxers (your club). Numbers differ on purpose: never two identical boxers.
export const PLAYERS = [
  { id: 'p_out', style: 'out', chin: 105, cap: 7, pow: 0, quick: 1,
    deck: deck([[JAB, 3], [CROSS, 2], [BJAB, 1], [LHOOK, 1], [BLOCK, 2], [SLIP, 1], [STEP, 1], [CHK, 1]]) },
  { id: 'p_press', style: 'press', chin: 119, cap: 7, pow: 0, quick: 0,
    deck: deck([[JAB, 2], [CROSS, 1], [BHOOK, 2], [LHOOK, 2], [UPPER, 1], [BLOCK, 2], [ROLL, 1], [TIE, 1]]) },
  { id: 'p_counter', style: 'counter', chin: 108, cap: 7, pow: 0, quick: 0,
    deck: deck([[JAB, 2], [CROSS, 2], [LHOOK, 1], [XC, 1], [SLIP, 1], [ROLL, 2], [BLOCK, 2], [CHK, 1]]) },
  { id: 'p_volume', style: 'volume', chin: 105, cap: 8, pow: 0, quick: 0,
    deck: deck([[JAB, 3], [BJAB, 1], [CROSS, 2], [LHOOK, 2], [BHOOK, 1], [BLOCK, 2], [SLIP, 1]]) },
];
// The neutral deck the card-value table and the run start from.
export const BASE_PLAYER = { id: 'p_base', style: 'base', chin: 112, cap: 7, pow: 0, quick: 0,
  deck: deck([[JAB, 3], [CROSS, 2], [LHOOK, 1], [BHOOK, 1], [BLOCK, 2], [SLIP, 1], [STEP, 1], [FEINT, 1]]) };

// Opponents (other clubs). Round 2: the same wind and the same hands as you up to regional class (no "lvl" step), and
// decks re-cut so that what lies face down is a fork: punches, guards, the trap, a feint, nothing.
// Two habits each: one ends on a punch, one does not.
export const OPPONENTS = [
  { id: 'o_out', style: 'out', chin: 108, cap: 7, pow: 0, quick: 1, habits: ['onetwo', 'coversafter'],
    deck: deck([[JAB, 3], [CROSS, 2], [BJAB, 1], [XC, 1], [BLOCK, 2], [STEP, 1], [CHK, 1], [FEINT, 1]]) },
  { id: 'o_press', style: 'press', chin: 122, cap: 7, pow: 0, quick: 0, habits: ['bodyfirst', 'rollafter'],
    deck: deck([[JAB, 2], [BHOOK, 3], [LHOOK, 1], [UPPER, 1], [BLOCK, 1], [TIE, 1], [ROLL, 2], [CHK, 1]]) },
  { id: 'o_counter', style: 'counter', chin: 112, cap: 7, pow: 0, quick: 0, habits: ['slipcross', 'trapfirst'],
    deck: deck([[JAB, 2], [CROSS, 2], [LHOOK, 1], [XC, 1], [SLIP, 2], [BLOCK, 1], [FEINT, 1], [CHK, 2]]) },
  { id: 'o_volume', style: 'volume', chin: 105, cap: 8, pow: 0, quick: 0, habits: ['onetwo', 'breather'],
    deck: deck([[JAB, 3], [BJAB, 2], [CROSS, 2], [LHOOK, 1], [BHOOK, 1], [BLOCK, 1], [FEINT, 1], [CHK, 1]]) },
];

// How much each style likes each card (index = play code). Used by the opponent's line builder.
export const STYLE_W = {
  //         -  J    BJ   CR   LH   BH   UP   XC   BL   BLo  SL   RO   ST   TI   FE   CH
  out:     [0, 1.0, 0.5, 0.7, 0.2, 0.1, 0.0, 0.3, 0.4, 0.3, 0.4, 0.2, 0.7, 0.1, 0.3, 0.6],
  press:   [0, 0.4, 0.4, 0.4, 0.8, 1.0, 0.7, 0.0, 0.4, 0.3, 0.1, 0.4, 0.0, 0.5, 0.2, 0.2],
  counter: [0, 0.4, 0.2, 0.7, 0.5, 0.2, 0.3, 1.0, 0.4, 0.3, 0.9, 0.7, 0.3, 0.1, 0.5, 0.9],
  volume:  [0, 0.9, 0.7, 0.7, 0.7, 0.5, 0.2, 0.0, 0.2, 0.2, 0.2, 0.1, 0.1, 0.1, 0.4, 0.3],
};

// A habit rules the face-down card. when(s, h): s = his three cards, h = the beat that lies face down; true when the
// habit's trigger is on the table (it reads only the cards that are face up). card = what then lies face down.
export const HABITS = {
  onetwo: { say: 'follows the jab with the cross', card: CROSS, when: (s, h) => h > 0 && s[h - 1] === JAB },
  coversafter: { say: 'covers up behind the cross', card: BLOCK, when: (s, h) => h > 0 && s[h - 1] === CROSS },
  bodyfirst: { say: 'goes to the body first', card: BHOOK, when: (s, h) => h === 0 },
  rollafter: { say: 'rolls under after his hook', card: ROLL, when: (s, h) => h > 0 && (s[h - 1] === LHOOK || s[h - 1] === BHOOK) },
  slipcross: { say: 'slips, then the cross', card: CROSS, when: (s, h) => h > 0 && s[h - 1] === SLIP },
  trapfirst: { say: 'opens with the check hook', card: CHK, when: (s, h) => h === 0 },
  breather: { say: 'takes the last beat off', card: EMPTY, when: (s, h) => h === 2 },
};
export const HABIT_P = 0.9;   // how often he keeps to a habit when its trigger is on the table
// The first of his habits whose trigger is on the table for face-down beat h, or null.
export function habitOn(names, s, h) {
  for (const n of names) if (HABITS[n].when(s, h)) return HABITS[n];
  return null;
}

// Paper steps over the player: [top wind, wind back, power]. Used from the title bout up only.
export const LEVELS = [[0, 0, 0], [1, 0, 0], [1, 0, 1]];
// Opponent class on the ladder. hide = cards he lays face down; hideFirst = on his first lead of a round;
// adapt = how much he uses what you have shown him; noise = how loosely he leads; ans = how loosely he answers.
export const TIERS = {
  1: { name: 'novice', hide: 0, hideFirst: 0, adapt: 0, lvl: 0, noise: 2.0, ans: 16 },
  2: { name: 'open class', hide: 1, hideFirst: 1, adapt: 0.3, lvl: 0, noise: 1.2, ans: 12 },
  3: { name: 'regional', hide: 1, hideFirst: 1, adapt: 0.7, lvl: 0, noise: 0.7, ans: 2 },
  4: { name: 'title', hide: 1, hideFirst: 1, adapt: 1.0, lvl: 1, noise: 0.6, ans: 1.5 },
  5: { name: 'professional', hide: 1, hideFirst: 2, adapt: 1.0, lvl: 2, noise: 0.6, ans: 1.5 },
};
