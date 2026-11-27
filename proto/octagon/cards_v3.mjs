// OCTAGON v3 (S570): the owner's 52-card database (ops/research/octagon/Octagon_Tactics_52_Card_Database.csv), the
// boxing cards (BOX-01..12) + the standing Fight IQ cards (UNI-03..06), on the v2 rules (engine.mjs useV2) + his combo
// rule (a combo goes on after a hit OR a block). Numbers are his; the rule calls that differ are marked CALL.
import { CARDS, PROFILES, TUNE, useV2 } from './engine.mjs';
export const V3_CARDS = {
  jab:     { id: 'BOX-01', n: 'Step-In Jab', type: 'A', spd: 8, st: 2, legal: ['long'], pre: 1, zone: 'head', dmg: 2, chain: 1, straight: 1, t: 'Long -> Mid. 2 to the head. [Chain +1]: with the Lead, chain another Attack. Claims the Lead on a hit.' },
  snap:    { id: 'BOX-02', n: 'Snap Jab', type: 'A', spd: 9, st: 1, legal: ['mid'], zone: 'head', dmg: 2, chain: 1, straight: 1, t: 'Mid. The fastest punch: 2 to the head. [Chain +1].' },
  cross3:  { id: 'BOX-03', n: 'Straight Cross', type: 'A', spd: 7, st: 3, legal: ['mid'], zone: 'head', dmg: 4, chain: 1, straight: 1, afterJab: 1, t: 'Mid. 4 to the head; +1 if chained after a jab, or thrown after your feint. [Chain +1].' },
  overhand:{ id: 'BOX-04', n: 'Overhand Right', type: 'A', spd: 5, st: 4, legal: ['long'], pre: 1, zone: 'head', dmg: 6, pushOnHit: 1, t: 'Long -> Mid. Heavy: 6 to the head and he is pushed back a range on a clean hit.' },
  lhook3:  { id: 'BOX-05', n: 'Lead Left Hook', type: 'A', spd: 6, st: 3, legal: ['mid', 'close'], zone: 'head', dmg: 5, hook: 1, finRock: 1, t: 'Mid or Close. 5 to the head. [Finisher]: as the 3rd card of a combo it ROCKS him.' },
  liver3:  { id: 'BOX-06', n: 'Ripping Liver Hook', type: 'A', spd: 6, st: 3, legal: ['mid', 'close'], zone: 'body', dmg: 5, hook: 1, capCut: 2, t: 'Mid or Close. 5 to the body; his maximum stamina -2 on a clean hit. [Finisher].' },
  upper3:  { id: 'BOX-07', n: 'Short Uppercut', type: 'A', spd: 6, st: 3, legal: ['close'], zone: 'head', dmg: 5, hook: 1, t: 'Close. 5 to the head.' },
  slip3:   { id: 'BOX-08', n: 'Slip & Cross', type: 'C', spd: 7, st: 3, legal: ['mid'], dmg: 5, answers: 'head', t: 'Mid. Answers ANY head attack: it misses, your cross lands 5, you take the Lead. A body attack (or nothing to answer): you whiff, -2 stamina.' },
  pull3:   { id: 'BOX-09', n: 'Pull Counter Cross', type: 'C', spd: 8, st: 3, legal: ['mid'], dmg: 6, answers: 'mid', post: -1, t: 'Mid. Answers any attack landing at Mid: it misses, you land 6, take the Lead and step back to Long.' },
  check3:  { id: 'BOX-10', n: 'Check Hook', type: 'C', spd: 7, st: 2, legal: ['long', 'mid'], dmg: 4, answers: 'advancing', post: -1, t: 'Long or Mid (CALL: his card says Mid, but the attacks that step in start at Long). Answers a man stepping in: it misses, you land 4 and pivot out.' },
  srf:     { id: 'BOX-11', n: 'Shoulder Roll & Feint', type: 'F', spd: 8, st: 1, legal: ['mid'], bait: 3, drawWin: 1, buffSpd: 1, t: 'Mid. Feint: beats a Counter (he loses 3 more stamina, you draw 1); if you are not hit your next exchange +1 speed. Loses to an Attack.' },
  guard:   { id: 'BOX-12', n: 'Tight High Guard', type: 'D', spd: 9, st: 0, legal: ['mid', 'close'], covers: 'head', cap: 6, rec: 2, t: 'Mid or Close, free. Blocks up to 6 head damage (more goes through), +2 stamina. A BODY attack goes under it. Gives up the Lead.' },
  cutc:    { id: 'UNI-03', n: 'Cut the Cage', type: 'F', spd: 7, st: 1, legal: ['long', 'mid'], pre: 1, cageCut: 1, t: 'Long or Mid. Feint: step in one range; if you are not hit his cage space -1 and you claim the Lead. Loses to an Attack, beats a Counter.' },
  circle3: { id: 'UNI-04', n: 'Circle Out & Reset', type: 'D', spd: 8, st: 1, legal: ['mid', 'close'], covers: 'half', rec: 0, post: -1, cageGain: 2, t: 'Mid or Close. Step out a range, +2 cage space, the Lead neutral; an attack does half (CALL: his card does not say it blocks).' },
  read3:   { id: 'UNI-05', n: 'Read Tendencies', type: 'F', spd: 9, st: 1, legal: ['long', 'mid', 'close'], read: 2, buffSpd: 2, t: 'Any range. Feint: see 2 of his cards (v2), draw 2, +2 speed next exchange. Loses to an Attack.' },
  breath:  { id: 'UNI-06', n: 'Deep Breath & Pace', type: 'D', spd: 7, st: 0, legal: ['long'], covers: 'none', rec: 5, t: 'Long. +5 stamina and the Rocked state clears - but you block nothing.' },
};
export const V3_DECKS = {
  out:   { jab: 2, snap: 3, cross3: 2, lhook3: 1, liver3: 1, slip3: 1, pull3: 1, check3: 1, srf: 2, guard: 2, circle3: 2, read3: 1, cutc: 1 },   // S570 bots: reader v reader 43-42 / 42-43
  press: { jab: 1, snap: 1, cross3: 2, overhand: 2, lhook3: 2, liver3: 3, upper3: 2, slip3: 1, pull3: 1, srf: 1, guard: 2, cutc: 1, read3: 1 },
};
export function useV3() {
  useV2(); TUNE.chainBlock = 1; TUNE.ctrDuel = 1; TUNE.headRest = 2; TUNE.hp = 1.1; TUNE.holdCard = 1; TUNE.idleCounter = 1; TUNE.chainHalf = 1; TUNE.guardTax = 1;   // v3.1 from John's cup-v3 verdict   // bots S570: styles 44-41 / 45-39, KO 21-30%, comebacks 15-22%
  Object.assign(CARDS, V3_CARDS);
  for (const p of ['out', 'press']) PROFILES[p].deck = V3_DECKS[p];
}
