// CARDSCOPE1 greybox - card data, numbers, boxers. Pure data, no DOM. See ops/research/DESIGN_CARDGAME_SCOPE.md.
// Play codes: what lies on a beat. A Block card in hand is played as BLOCK (high) or BLOCK_LOW.
export const EMPTY = 0, JAB = 1, BJAB = 2, CROSS = 3, LHOOK = 4, BHOOK = 5, UPPER = 6, XC = 7,
  BLOCK = 8, BLOCK_LOW = 9, SLIP = 10, ROLL = 11, STEP = 12, TIE = 13, FEINT = 14, NCODES = 15;

export const NAME = ['-', 'Jab', 'Body jab', 'Cross', 'Lead hook', 'Body hook', 'Uppercut', 'Cross counter',
  'Block high', 'Block low', 'Slip', 'Roll', 'Step back', 'Tie up', 'Feint'];
//                      -  J  BJ CR LH BH UP XC BL BL SL RO ST TI FE
export const COST =    [0, 1, 1, 2, 2, 2, 3, 3, 1, 1, 2, 2, 2, 1, 0];
export const DMG =     [0, 2, 2, 6, 6, 4, 10, 6, 0, 0, 0, 0, 0, 0, 0];
export const IS_PUNCH = [0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0];
export const BODY =    [0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0];   // 1 = aimed at the body
export const SHAPE =   [0, 1, 1, 1, 2, 2, 3, 1, 0, 0, 0, 0, 0, 0, 0];   // 1 straight, 2 hook, 3 uppercut
export const SPEED =   [0, 1, 1, 2, 2, 2, 3, 3, 0, 0, 0, 0, 0, 0, 0];   // 1 fast .. 3 slow
export const POWER =   [0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0];   // takes the Power bonus
export const STRAIGHT = [0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];  // what a cross counter beats
export const IS_GUARD = [0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0];  // what a feint draws
export const cardOf = (code) => (code === BLOCK_LOW ? BLOCK : code);     // play code -> card in hand
// The thirteen cards a deck can hold.
export const CARDS = [JAB, BJAB, CROSS, LHOOK, BHOOK, UPPER, XC, BLOCK, SLIP, ROLL, STEP, TIE, FEINT];

// Every number of the design in one place. A resize edits this object and nothing else.
export const CFG = {
  beats: 3, exchanges: 4, rounds: 3, hand: 5,
  windCap: 7, windBack: 3, windStool: 2, windEmptyBeat: 1,
  bodyPerCap: 8, minCap: 4,
  chin: 112, hurtAt: 70, kdLine: 24, kdLineHurt: 18, kdWind: 2, kdStop: 3,
  counterBonus: 4, chain: 2, oneTwo: 4, bodyHead: 4, oneTwoThree: 6, feintBonus: 4,
  slowerLoses: 2, wrongEvade: 2, smother: 4, xcDamage: 6, blockStops: 4,
  ice: 20, eyesExchanges: 4, waterBack: 1,
  judgeClean: 2, judgeThrown: 0.5, judgeDamage: 1 / 6, judgeCraft: 1,
};

const deck = (spec) => {
  const out = [];
  for (const [card, n] of spec) for (let i = 0; i < n; i++) out.push(card);
  return out;
};

// Player boxers (your club). Numbers differ on purpose: never two identical boxers.
export const PLAYERS = [
  { id: 'p_out', style: 'out', chin: 105, cap: 7, pow: 0, quick: 1,
    deck: deck([[JAB, 3], [CROSS, 2], [BJAB, 1], [LHOOK, 1], [BLOCK, 2], [SLIP, 1], [STEP, 1], [FEINT, 1]]) },
  { id: 'p_press', style: 'press', chin: 119, cap: 7, pow: 0, quick: 0,
    deck: deck([[JAB, 2], [CROSS, 1], [BHOOK, 2], [LHOOK, 2], [UPPER, 1], [BLOCK, 2], [ROLL, 1], [TIE, 1]]) },
  { id: 'p_counter', style: 'counter', chin: 108, cap: 7, pow: 0, quick: 0,
    deck: deck([[JAB, 2], [CROSS, 2], [LHOOK, 1], [XC, 1], [SLIP, 2], [ROLL, 1], [BLOCK, 2], [FEINT, 1]]) },
  { id: 'p_volume', style: 'volume', chin: 105, cap: 8, pow: 0, quick: 0,
    deck: deck([[JAB, 3], [BJAB, 1], [CROSS, 2], [LHOOK, 2], [BHOOK, 1], [BLOCK, 2], [SLIP, 1]]) },
];
// The neutral deck the card-value table and the run start from.
export const BASE_PLAYER = { id: 'p_base', style: 'base', chin: 112, cap: 7, pow: 0, quick: 0,
  deck: deck([[JAB, 3], [CROSS, 2], [LHOOK, 1], [BHOOK, 1], [BLOCK, 2], [SLIP, 1], [STEP, 1], [FEINT, 1]]) };

// Opponents (other clubs). Two habits each: fixed patterns a reader can learn or find on film.
export const OPPONENTS = [
  { id: 'o_out', style: 'out', chin: 108, cap: 7, pow: 0, quick: 1, lvl: 5, habits: ['onetwo', 'coversafter'],
    deck: deck([[JAB, 4], [CROSS, 3], [BJAB, 1], [XC, 1], [BLOCK, 1], [STEP, 1], [SLIP, 1]]) },
  { id: 'o_press', style: 'press', chin: 122, cap: 7, pow: 0, quick: 0, lvl: 4, habits: ['bodyfirst', 'hookfinish'],
    deck: deck([[JAB, 2], [BHOOK, 3], [LHOOK, 2], [UPPER, 1], [BLOCK, 2], [TIE, 1], [ROLL, 1]]) },
  { id: 'o_counter', style: 'counter', chin: 112, cap: 7, pow: 0, quick: 0, lvl: 5, habits: ['slipcross', 'hookfinish'],
    deck: deck([[JAB, 2], [CROSS, 2], [LHOOK, 2], [XC, 2], [SLIP, 1], [ROLL, 1], [BLOCK, 1], [FEINT, 1]]) },
  { id: 'o_volume', style: 'volume', chin: 105, cap: 8, pow: 0, quick: 0, lvl: 1, habits: ['onetwo', 'bodyfirst'],
    deck: deck([[JAB, 3], [BJAB, 2], [CROSS, 2], [LHOOK, 2], [BHOOK, 1], [BLOCK, 1], [FEINT, 1]]) },
];

// How much each style likes each card (index = play code). Used by the opponent's line builder.
export const STYLE_W = {
  //         -  J    BJ   CR   LH   BH   UP   XC   BL   BLo  SL   RO   ST   TI   FE
  out:     [0, 1.0, 0.5, 0.7, 0.2, 0.1, 0.0, 0.3, 0.4, 0.3, 0.4, 0.2, 0.7, 0.1, 0.3],
  press:   [0, 0.4, 0.4, 0.4, 0.8, 1.0, 0.7, 0.0, 0.4, 0.3, 0.1, 0.4, 0.0, 0.5, 0.2],
  counter: [0, 0.4, 0.2, 0.7, 0.5, 0.2, 0.3, 1.0, 0.4, 0.3, 0.9, 0.7, 0.3, 0.1, 0.5],
  volume:  [0, 0.9, 0.7, 0.7, 0.7, 0.5, 0.2, 0.0, 0.2, 0.2, 0.2, 0.1, 0.1, 0.1, 0.4],
};

// Habit = a pattern in the line he lays. p = how often it rules an exchange when he holds the cards.
export const HABITS = {
  onetwo: { p: 0.85, test: (c) => (c[0] === JAB && c[1] === CROSS) || (c[1] === JAB && c[2] === CROSS) },
  hookfinish: { p: 0.8, test: (c) => c[2] === LHOOK },
  bodyfirst: { p: 0.8, test: (c) => c[0] === BHOOK || c[0] === BJAB },
  coversafter: { p: 0.8, test: (c) => (POWER[c[0]] && (c[1] === BLOCK || c[1] === BLOCK_LOW)) || (POWER[c[1]] && (c[2] === BLOCK || c[2] === BLOCK_LOW)) },
  slipcross: { p: 0.8, test: (c) => (c[0] === SLIP && c[1] === CROSS) || (c[1] === SLIP && c[2] === CROSS) },
};

// How much better than you he is on paper: steps of wind (top and back per exchange) and power. Each opponent boxer has
// his own step for the regional class (lvl), sized so that no style is a walkover or a wall; the class moves it.
export const LEVELS = [[0, 0], [1, 0], [1, 1], [2, 1], [2, 2], [3, 2], [3, 3], [4, 3], [4, 4]];
// Opponent class on the ladder. hide = cards laid face down; hideEarly = in the first two exchanges of a round.
export const TIERS = {
  1: { name: 'novice', hide: 0, hideEarly: 0, adapt: 0, lvl: -3, noise: 1.0 },
  2: { name: 'open class', hide: 1, hideEarly: 1, adapt: 0.3, lvl: -1, noise: 0.8 },
  3: { name: 'regional', hide: 1, hideEarly: 1, adapt: 0.7, lvl: 0, noise: 0.7 },
  4: { name: 'title', hide: 1, hideEarly: 1, adapt: 1.0, lvl: 1, noise: 0.6 },
  5: { name: 'professional', hide: 1, hideEarly: 2, adapt: 1.0, lvl: 2, noise: 0.6 },
};
