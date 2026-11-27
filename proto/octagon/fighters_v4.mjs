// OCTAGON v4 (S570): fighter ATTRIBUTES + WEIGHT CLASSES + a pool to draft from (docs/OCTAGON_ATTRIBUTES_SPEC.md).
// Owner S570: "we need to add atrributes that itneract with stats ... everyone drifts his favorite fighter and compete in
// the cup" and "each weight category will have differnet limits/trehesholds". Each pool fighter becomes an engine
// profile (head / body / stamina / rocked line / speed and damage bonuses) on the v3.1 rules and his 52-card database.
import { PROFILES, TUNE } from './engine.mjs';
import { useV3, V3_DECKS } from './cards_v3.mjs';
import { CARDS as CARDS_ALL } from './engine.mjs';
// caps, the class's punch weight, health and stamina bases (J20 corpus: lighter men throw more, heavier men finish more)
export const CLASSES = {
  light:  { n: 'Lightweight',  cap: { power: 7, speed: 10, cardio: 10 }, punch: 0, health: 9,  stamina: 11 },
  welter: { n: 'Welterweight', cap: { power: 8, speed: 9, cardio: 9 },   punch: 0, health: 10, stamina: 10 },
  middle: { n: 'Middleweight', cap: { power: 9, speed: 8, cardio: 8 },   punch: 1, health: 10, stamina: 10 },
  heavy:  { n: 'Heavyweight',  cap: { power: 10, speed: 7, cardio: 7 },  punch: 1, health: 12, stamina: 9, heavyPower: 1 },
};
export const STYLES = {
  out: { n: 'Out-Fighter', deck: () => V3_DECKS.out },
  press: { n: 'Pressure', deck: () => V3_DECKS.press },
  counter: { n: 'Counter-Puncher', deck: () => ({ slip3: 2, pull3: 2, check3: 1, srf: 2, snap: 3, cross3: 2, lhook3: 1, liver3: 1, guard: 2, circle3: 1, read3: 1, jab: 1, cutc: 1 }) },
};
// the middleweight pool (fictional; 42 points each)
export const POOL = {
  metronome: { n: 'Diego "The Metronome" Ruiz', style: 'out', cls: 'middle', a: { power: 4, speed: 7, reach: 9, chin: 5, body: 5, cardio: 7, iq: 5 }, shape: 'long, quick jab, never tired' },
  silk:      { n: 'Ray "Silk" Okafor', style: 'out', cls: 'middle', a: { power: 5, speed: 8, reach: 8, chin: 4, body: 4, cardio: 7, iq: 6 }, shape: 'fastest hands, glass chin' },
  longnight: { n: 'Jake "Long Night" Brennan', style: 'out', cls: 'middle', a: { power: 5, speed: 7, reach: 7, chin: 6, body: 6, cardio: 8, iq: 3 }, shape: 'the 12-round engine, little craft' },
  iron:      { n: '"Iron" Ike Mbeki', style: 'press', cls: 'middle', a: { power: 8, speed: 5, reach: 4, chin: 8, body: 7, cardio: 6, iq: 4 }, shape: 'walks through anything' },
  truck:     { n: 'Tomas "The Truck" Kowal', style: 'press', cls: 'middle', a: { power: 9, speed: 4, reach: 5, chin: 7, body: 8, cardio: 5, iq: 4 }, shape: 'one punch, slow hands' },
  bodyshop:  { n: 'Marco "Body Shop" Duarte', style: 'press', cls: 'middle', a: { power: 6, speed: 6, reach: 4, chin: 6, body: 6, cardio: 8, iq: 6 }, shape: 'digs to the body all night' },
  snapshot:  { n: 'Sonny "Snapshot" Vale', style: 'counter', cls: 'middle', a: { power: 6, speed: 8, reach: 5, chin: 5, body: 5, cardio: 5, iq: 8 }, shape: 'the reader, fragile' },
  ghost:     { n: 'Lin "Ghost" Hayes', style: 'counter', cls: 'middle', a: { power: 5, speed: 7, reach: 6, chin: 5, body: 5, cardio: 6, iq: 8 }, shape: 'slips and makes you pay' },
};
const step = (v, hi2, hi1, lo) => (v >= hi2 ? 2 : v >= hi1 ? 1 : v <= lo ? -1 : 0);
export function checkFighter(f) { const C = CLASSES[f.cls], a = f.a, bad = [];
  const sum = Object.values(a).reduce((x, y) => x + y, 0); if (sum !== 42) bad.push(`points ${sum} (must be 42)`);
  for (const [k, cap] of Object.entries(C.cap)) if (a[k] > cap) bad.push(`${k} ${a[k]} over the ${C.n} cap ${cap}`);
  return bad; }
// a pool fighter -> an engine profile (head and body x TUNE.hp happen in newBout)
export function profileOf(id) { const f = POOL[id], C = CLASSES[f.cls], a = f.a;
  const power = step(a.power, 9, 7, 3) + (C.heavyPower && a.power >= 9 ? 1 : 0);
  return { n: f.n, attr: a, cls: f.cls, style: f.style, head: C.health + a.chin, body: C.health + a.body, st: C.stamina + a.cardio,
    rocked: 3 + Math.ceil(a.chin / 2), cardio: 2 + Math.floor(a.cardio / 2), bodyStep: 3 + Math.ceil(a.body / 3),
    dmgBonus: power + C.punch, punch: C.punch, spdBonus: step(a.speed, 9, 7, 3), reach: a.speed * 10 + a.reach, reflex: a.iq, ctrAt: 7,
    readN: 1 + Math.floor(a.iq / 4),
    trait: `${C.n} ${STYLES[f.style].n}. POW ${a.power} SPD ${a.speed} REA ${a.reach} CHIN ${a.chin} BODY ${a.body} CAR ${a.cardio} IQ ${a.iq} - ${f.shape}.`,
    deck: STYLES[f.style].deck() }; }
export function useV4() { useV3(); TUNE.jabNoPower = 1; TUNE.swapRange = 1; TUNE.swapFree = 1; TUNE.spentRest = 1;   /* S571 stamina-lock fix */ TUNE.noReRock = 1; TUNE.pushMid = 1; TUNE.jabTrade = 3; TUNE.longJab = 1; TUNE.feelFlat = 1; TUNE.elbows = 1; TUNE.holdParry = 1; TUNE.score107 = 1; TUNE.ctrHalfPow = 1; TUNE.rockClinch = 1; TUNE.buffOne = 1; TUNE.hp = 1.25; TUNE.feelMeets = 1; TUNE.baitCap = 1; TUNE.reactZone = 1; TUNE.halfNoCut = 1; TUNE.holdReads = 1; TUNE.holdTax = 1; TUNE.whiff1 = 1;   /* v4.9 (cup v4 r7-r8, all four seats: waiting was free, two whiffed counters emptied a counter-puncher): Hold Ground after a Defend costs 1 unless spent; a whiffed counter costs 1 not 2 - bots 41-55%, finishes 31% (the bots never hold twice: only the cup can show holdTax) */   /* v4.8 (cup v4 r7: three of four seats - waiting at Long was a free parry or a free gift): Hold Ground at Long reads a feint that steps in (Cut the Cage) - bots 44-58%, finishes 29% */   /* v4.7 (cup v4 r7, Claude: a kept Elbows Down let a body combo through; a halved liver hook still cut max stamina) - bots 43-58%, finishes 30% */   /* v4.6 (cup v4 r6 on v4.5: fun 8/7/7/6 = 7.0, depth 7.0 - at target; Kalli: the Range Jab meets a man stepping in; John + Maria + Kalli: a baited counter costs at most 3) - bots 44-55%, finishes 30% */ for (const id of Object.keys(CARDS_ALL)) if (CARDS_ALL[id].t) CARDS_ALL[id].t = CARDS_ALL[id].t.replace('+2 speed next exchange', '+1 speed next exchange');   /* v4.5 card text says the real boost */   /* v4.5 (cup v4 r5: fun 6/6/6/7, 7 of the last 8 agent bouts were KOs, most inside 2 rounds - agents read better than the bots, so their bouts end before the depth shows): a counter adds half the power bonus, Clinch & Hold for a rocked man, a read boosts +1 not +2, health x1.25. Bots 42-59%, finishes 24% (agents finish far more than bots: 87% v 48% at the old health) */   /* v4.4 (cup v4 r4: fun 7/7/6/6, a Range Jab drill on a man standing still): Elbows Down in every deck, Hold Ground parries a jab at Long, a 12+ round scores 10-7 - bots 43-59%, finishes 48% */   /* v4.3 (cup v4 r3, John + Maria + Kalli): a jab meeting a man stepping in halves his punch; the Range Jab is speed 8 for everyone - bots 44-58%, finishes 48% */   /* S571 v4.2 (cup v4 r2 verdicts): no rock twice in a row, push back only out of Close, a jab takes 2 off the punch it meets instead of cancelling it, a Range Jab always there at Long - bots 43-60%, finishes 53% */ for (const id of Object.keys(POOL)) PROFILES[id] = profileOf(id); }
export const poolText = () => Object.entries(POOL).map(([id, f]) => { const p = profileOf(id); return `${id} = ${f.n} (${CLASSES[f.cls].n}, ${STYLES[f.style].n}): POWER ${f.a.power}, HAND SPEED ${f.a.speed}, REACH ${f.a.reach}, CHIN ${f.a.chin}, BODY ${f.a.body}, CARDIO ${f.a.cardio}, RING IQ ${f.a.iq} -> head ${Math.round(p.head * TUNE.hp)}, body ${Math.round(p.body * TUNE.hp)}, stamina ${p.st}, rocked at ${p.rocked}, +${p.dmgBonus} dmg, ${p.spdBonus >= 0 ? '+' : ''}${p.spdBonus} speed. ${f.shape}.`; }).join('\n');
