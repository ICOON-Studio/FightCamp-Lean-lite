// OCTAGON v4 (S570): fighter ATTRIBUTES + WEIGHT CLASSES + a pool to draft from (docs/OCTAGON_ATTRIBUTES_SPEC.md).
// Owner S570: "we need to add atrributes that itneract with stats ... everyone drifts his favorite fighter and compete in
// the cup" and "each weight category will have differnet limits/trehesholds". Each pool fighter becomes an engine
// profile (head / body / stamina / rocked line / speed and damage bonuses) on the v3.1 rules and his 52-card database.
import { PROFILES, TUNE } from './engine.mjs';
import { useV3, V3_DECKS } from './cards_v3.mjs';
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
export function useV4() { useV3(); TUNE.jabNoPower = 1; for (const id of Object.keys(POOL)) PROFILES[id] = profileOf(id); }
export const poolText = () => Object.entries(POOL).map(([id, f]) => { const p = profileOf(id); return `${id} = ${f.n} (${CLASSES[f.cls].n}, ${STYLES[f.style].n}): POWER ${f.a.power}, HAND SPEED ${f.a.speed}, REACH ${f.a.reach}, CHIN ${f.a.chin}, BODY ${f.a.body}, CARDIO ${f.a.cardio}, RING IQ ${f.a.iq} -> head ${Math.round(p.head * TUNE.hp)}, body ${Math.round(p.body * TUNE.hp)}, stamina ${p.st}, rocked at ${p.rocked}, +${p.dmgBonus} dmg, ${p.spdBonus >= 0 ? '+' : ''}${p.spdBonus} speed. ${f.shape}.`; }).join('\n');
