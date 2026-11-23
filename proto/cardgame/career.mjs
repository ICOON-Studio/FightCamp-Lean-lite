import { CARDS, N, fighter } from './cards.mjs';
import { bout } from './engine.mjs';
import { aiPilot } from './plan.mjs';

export const RUNGS = ['Club', 'Area', 'National', 'Title shot', 'Title defence 1', 'Title defence 2', 'Title defence 3'];
export const TRAINING = {
  boxing: [
    { id: 'jab', label: 'Jab timing', cost: 1, fail: 0.08 },
    { id: 'cross', label: 'Cross power', cost: 2, fail: 0.14 },
    { id: 'hook', label: 'Hook placement', cost: 2, fail: 0.18 },
    { id: 'block', label: 'Guard drill', cost: 1, fail: 0.06 },
  ],
  bjj: [
    { id: 'sweep', label: 'Sweep entries', cost: 2, fail: 0.15 },
    { id: 'pass', label: 'Guard passing', cost: 1, fail: 0.08 },
    { id: 'triangle', label: 'Triangle control', cost: 3, fail: 0.22 },
    { id: 'escape', label: 'Escape practice', cost: 1, fail: 0.05 },
  ],
};
export const freshCareer = (style = 'boxing', seed = 539) => ({ style, rung: 0, rank: 100, wins: 0, losses: 0, energy: 5, deck: fighter(style).deck.slice(), upgrades: {}, seed, bouts: 0, trainingDone: false });
export function cardVariant(id, level) {
  const key = `${id}+${level}`;
  if (!CARDS[key]) {
    const base = CARDS[id];
    CARDS[key] = { ...base, n: `${base.n} ${level === 1 ? 'II' : `+${level}`}`, dmg: base.dmg === undefined ? undefined : base.dmg + level, pts: base.pts === undefined ? undefined : base.pts + level, guard: base.fx === 'block' ? N.block + level : base.guard, count: base.count === undefined ? undefined : Math.max(1, base.count - level), w: Math.max(0, base.w - level) };
  }
  return key;
}
export function train(career, option, rng = Math.random) {
  if (career.energy < option.cost) return { ok: false, reason: 'Not enough training energy.' };
  career.energy -= option.cost;
  const before = career.deck.filter((id) => id === option.id || id.startsWith(`${option.id}+`)).length;
  if (rng() < option.fail) return { ok: false, failed: true, message: `${option.label} missed: the card printed a ${Math.round(option.fail * 100)}% failure chance.` };
  if (before) {
    const index = career.deck.findIndex((id) => id === option.id);
    if (index >= 0) career.deck[index] = cardVariant(option.id, (career.upgrades[option.id] || 0) + 1);
    else career.deck.push(cardVariant(option.id, (career.upgrades[option.id] || 0) + 1));
    career.upgrades[option.id] = (career.upgrades[option.id] || 0) + 1;
    return { ok: true, kind: 'upgrade', message: `${option.label} upgraded one ${CARDS[option.id].n}.` };
  }
  career.deck.push(option.id);
  return { ok: true, kind: 'add', message: `${option.label} added ${CARDS[option.id].n} to the deck.` };
}
export function resultCareer(career, won) {
  career.bouts++;
  if (won) { career.wins++; career.rung = Math.min(RUNGS.length - 1, career.rung + 1); }
  else { career.losses++; career.rung = Math.max(0, career.rung - 1); }
  career.rank = Math.max(1, Math.round(100 - career.wins * 18 + career.losses * 9 + (RUNGS.length - 1 - career.rung) * 2));
  career.energy = Math.min(6, career.energy + 2);
  career.trainingDone = false;
  return RUNGS[career.rung];
}
export const playerFighter = (career) => ({ ...fighter(career.style), name: 'You', deck: career.deck.slice() });
export const rivalFighter = (career, rung) => ({ ...fighter(career.style === 'boxing' ? 'bjj' : 'boxing'), name: `${RUNGS[rung]} challenger`, deck: fighter(career.style === 'boxing' ? 'bjj' : 'boxing').deck.slice() });

// L2: deterministic state sweep; value is incremental expected damage/position utility adjusted for training energy and failure risk.
export function trainingUtility(option, style, state) {
  const card = CARDS[option.id];
  const fit = style === 'boxing'
    ? (option.id === 'jab' ? ['K', 'P'].includes(state.range) : option.id === 'hook' ? ['P', 'C'].includes(state.range) : option.id === 'cross' ? state.range === 'P' : option.id === 'block' ? state.incoming : false)
    : (option.id === 'sweep' ? ['B0', 'B1'].includes(state.pos) : option.id === 'pass' ? ['T0', 'T1', 'T2'].includes(state.pos) : option.id === 'triangle' ? state.pos === 'B0' : option.id === 'escape' ? state.held : false);
  const kit = (card.dmg || 0) + (card.pts || 0) * 2 + (card.k === 'hold' ? 5 : card.k === 'shot' ? 2 : 0);
  const synergy = style === 'boxing'
    ? (option.id === 'jab' && state.range === 'K' ? 20 : option.id === 'cross' && state.range === 'P' ? 20 : option.id === 'hook' && state.range === 'C' ? 20 : option.id === 'block' && state.incoming ? 25 : 0)
    : (option.id === 'sweep' && ['B0', 'B1'].includes(state.pos) ? 20 : option.id === 'pass' && state.pos[0] === 'T' ? 20 : option.id === 'triangle' && state.pos === 'B0' && state.behind ? 25 : option.id === 'escape' && state.held ? 25 : 0);
  return (fit ? kit + synergy : 1) - option.cost * 1.7 - option.fail * 9;
}
export function measureTraining(style) {
  const states = Array.from({ length: 10 }, (_, i) => {
    const phase = i % 4;
    if (style === 'boxing') return phase === 0 ? { range: 'K' } : phase === 1 ? { range: 'P' } : phase === 2 ? { range: 'C' } : { range: 'K', incoming: true };
    return phase === 0 ? { pos: 'B1', ground: true } : phase === 1 ? { pos: 'T1', ground: true } : phase === 2 ? { pos: 'B0', ground: true, behind: true } : { pos: 'B0', ground: true, held: true };
  });
  const options = TRAINING[style];
  const top = states.map((state) => Math.max(...options.map((o) => trainingUtility(o, style, state))));
  const chosen = options.map((option) => states.reduce((n, state, i) => n + (trainingUtility(option, style, state) >= top[i] - 1e-9 ? 1 : 0), 0));
  return { states: states.length, options: options.map((o, i) => ({ id: o.id, right: chosen[i] })), pass: chosen.every((n) => n >= 1 && n <= 6) };
}
export const ladderBudgetSeconds = (decisions, secondsPerDecision = 8) => decisions * secondsPerDecision;
export function simulateLadder(runs = 100, seed = 600000000, maxBouts = 80) {
  const AI = aiPilot(), results = []; let titleWins = 0, boutCount = 0, decisionCount = 0, capped = 0;
  for (let i = 0; i < runs; i++) {
    const career = freshCareer(i % 2 ? 'boxing' : 'bjj', seed + i * 1009); let wonTitle = false, runDecisions = 0;
    for (let n = 0; n < maxBouts; n++) {
      const r = bout(playerFighter(career), rivalFighter(career, career.rung), [AI, AI], seed + i * 1009 + n * 31);
      const won = r.win === 0; boutCount++; decisionCount += r.st.dec[0]; runDecisions += r.st.dec[0];
      wonTitle = won && career.rung === RUNGS.length - 1;
      resultCareer(career, won);
      if (wonTitle) break;
      const opts = TRAINING[career.style], phase = n % 4, state = career.style === 'boxing'
        ? phase === 0 ? { range: 'K' } : phase === 1 ? { range: 'P' } : phase === 2 ? { range: 'C' } : { range: 'K', incoming: true }
        : phase === 0 ? { pos: 'B1', ground: true } : phase === 1 ? { pos: 'T1', ground: true } : phase === 2 ? { pos: 'B0', ground: true, behind: true } : { pos: 'B0', ground: true, held: true };
      const choice = opts.slice().sort((a, b) => trainingUtility(b, career.style, state) - trainingUtility(a, career.style, state))[0];
      train(career, choice, seededRandom(seed + i * 991 + n * 17));
    }
    if (wonTitle) titleWins++; else capped++;
    results.push({ title: wonTitle, bouts: career.bouts, decisions: runDecisions });
  }
  const winners = results.filter((x) => x.title), avg = (xs, key) => xs.length ? xs.reduce((n, x) => n + x[key], 0) / xs.length : 0;
  return { runs, titleWins, titleRate: titleWins / runs, meanBouts: boutCount / runs, bouts: boutCount, meanMinutes: decisionCount / runs * 8 / 60, titleWinnerMeanBouts: avg(winners, 'bouts'), titleWinnerMeanMinutes: avg(winners, 'decisions') * 8 / 60, capped, results };
}
function seededRandom(seed) { let a = seed >>> 0; return () => { a = (a + 0x6d2b79f5) | 0; let t = Math.imul(a ^ (a >>> 15), 1 | a); t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t; return ((t ^ (t >>> 14)) >>> 0) / 4294967296; }; }
export const assertCareer = (c) => { if (!RUNGS[c.rung] || c.rank < 1 || c.energy < 0 || c.deck.length < 15) throw new Error('Invalid career state'); return true; };
void N;
