// The career layer: the ladder, the rivals on it, the training turn between bouts, and the two probes (L1, L2).
import { CARDS, N, fighter } from './cards.mjs';
import { bout } from './engine.mjs';
import { aiPilot, impatient, scripted, worth } from './plan.mjs';

export const RUNGS = ['Club', 'Area', 'National', 'Title shot', 'Title defence 1', 'Title defence 2', 'Title defence 3'];
export const TITLE_SHOT = RUNGS.indexOf('Title shot');
export const CUT_AT_LOSSES = 6; // a career is a title or six losses: the gym cuts a boxer who keeps losing
// the belt is won at the TITLE SHOT, not at the last defence: read the rung before resultCareer moves it
export const takesTitle = (career, won) => !!won && RUNGS[career.rung] === 'Title shot';
export const TRAINING = {
  boxing: [
    { id: 'jab', label: 'Jab timing', cost: 1, fail: 0.08 },
    { id: 'cross', label: 'Cross power', cost: 2, fail: 0.14 },
    { id: 'escape', label: 'Escape practice', cost: 1, fail: 0.05 }, // out of the hold: the one card that gets a held boxer out
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
  const key = `${id}+${level}`, base = CARDS[id];
  if (!base) throw new Error('no such card to train: ' + id);
  if (!CARDS[key]) {
    CARDS[key] = { ...base, n: `${base.n} ${level === 1 ? 'II' : `+${level}`}`, dmg: base.dmg === undefined ? undefined : base.dmg + level, pts: base.pts === undefined ? undefined : base.pts + level, guard: base.fx === 'block' ? N.block + level : base.guard, count: base.count === undefined ? undefined : Math.max(1, base.count - level), w: Math.max(0, base.w - level) };
  }
  return key;
}
const levelOf = (id, base) => (id === base ? 0 : +(id.slice(base.length + 1)) || 0);
// one card in, one card out: a second upgrade of the same card replaces the copy already in the deck, it never adds one
export function train(career, option, rng = Math.random) {
  if (career.energy < option.cost) return { ok: false, reason: 'Not enough training energy.' };
  career.energy -= option.cost;
  if (rng() < option.fail) return { ok: false, failed: true, message: `${option.label} missed: the card printed a ${Math.round(option.fail * 100)}% failure chance.` };
  const base = option.id, copies = career.deck.map((id, i) => ({ i, id, lv: id === base || id.startsWith(base + '+') ? levelOf(id, base) : -1 })).filter((c) => c.lv >= 0);
  const next = cardVariant(base, (career.upgrades[base] || 0) + 1);
  career.upgrades[base] = (career.upgrades[base] || 0) + 1;
  if (!copies.length) { career.deck.push(base); return { ok: true, kind: 'add', message: `${option.label} added ${CARDS[base].n} to the deck.` }; }
  const low = copies.sort((a, b) => a.lv - b.lv)[0];
  career.deck[low.i] = next;
  return { ok: true, kind: 'upgrade', message: `${option.label} upgraded one ${CARDS[base].n}.` };
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
// RIVALS BY RUNG. The Club rung is the house rule's "opponents from other clubs": a novice of the player's own art whose
// deck is the printed one with his best cards swapped for his cheapest (a first bout is fought, and trained for, in the
// art the player came with: the guard drill and the escape practice have a real bout to be right in). THE FIRST BOUT of
// a career is the exception (owner S541: "against the other art", plan section 3, so the first bout teaches the two
// arts' difference): the same softest club deck with the other art's cards, flown by that art's own priority list (the
// impatient line cannot fly a grappler: at KICK he has no card to lay, so he would only step out and never show his
// art). From Area up the rival is the other art; from National up his best cards are upgraded, as a title fighter's are.
// A national title fighter is far better than a club novice, and the ladder now says so.
export const RIVAL_RECIPE = [
  { swap: 3, same: true }, // 0 Club: a novice of the player's own art, his three best cards swapped for his cheapest
  { up: 2, by: 1 },   // 1 Area: the other art's printed deck, his two best cards upgraded once
  { up: 4, by: 2 },   // 2 National
  { up: 6, by: 2 },   // 3 Title shot
  { up: 8, by: 3 },   // 4 Title defence 1
  { up: 10, by: 4 },  // 5 Title defence 2
  { up: 12, by: 5 },  // 6 Title defence 3: the champion's deck, every card of his art upgraded
];
const power = (id) => worth(CARDS[id]) / Math.max(1, CARDS[id].w);
export function rivalFighter(career, rung) {
  const recipe = RIVAL_RECIPE[Math.max(0, Math.min(RIVAL_RECIPE.length - 1, rung))];
  const other = career.bouts === 0 && rung === 0; // the first bout of a career is against the other art (plan section 3)
  const style = other ? (career.style === 'boxing' ? 'bjj' : 'boxing') : recipe.same ? career.style : career.style === 'boxing' ? 'bjj' : 'boxing', base = fighter(style);
  const own = base.deck.filter((id) => CARDS[id].st === style), core = base.deck.filter((id) => CARDS[id].st === 'core');
  const rank = own.slice().sort((a, b) => power(b) - power(a));
  let deck = own.slice();
  if (recipe.swap) for (let i = 0; i < recipe.swap; i++) deck[deck.indexOf(rank[i])] = rank[rank.length - 1 - i];
  if (recipe.up) for (let i = 0; i < recipe.up; i++) deck[deck.indexOf(rank[i])] = cardVariant(rank[i], recipe.by);
  return { ...base, name: `${RUNGS[rung]} challenger`, deck: core.concat(deck) };
}
// a rival's corner by rung: the first bout's novice plays the other art's own line (the priority list, which knows that
// art's entries); a later club novice's corner plays the dearest card it can; a title fighter's reads the table
export const rivalPilot = (rung, career) => (rung <= 0 ? (career?.bouts === 0 ? scripted(rivalFighter(career, rung).style) : impatient()) : aiPilot());
// THE STATE A CAREER TRAINS IN, read off the bout it just fought: where his own cards had to be legal (the share of
// them laid at each place on the strip), whether he was held, whether he was struck, whether he was behind on the
// cards. Nothing here is hand-made: it is the ladder's own record, per art, and it says where the deck had to work.
export function trainingState(r, m = 0) {
  const log = r.st.log[m], his = r.st.log[1 - m], share = {}; let laid = 0;
  for (const t of log) t.kinds.forEach((kd, i) => { if (kd === 'step' || kd === 'move') return; share[t.at[i]] = (share[t.at[i]] || 0) + 1; laid++; });
  if (!laid) for (const t of log) { share[t.pos[0]] = (share[t.pos[0]] || 0) + 1; laid++; } // a bout in which he laid no card (held from the first turn): where he was
  if (!laid) { share.K = 1; laid = 1; }
  for (const k in share) share[k] /= laid;
  const pos = Object.entries(share).sort((a, b) => b[1] - a[1])[0]?.[0] || 'K';
  return { pos, share, range: pos[0], ground: pos === 'T' || pos === 'B', struck: his.some((t) => t.kinds.includes('strike')),
    held: his.some((t) => t.kinds.includes('hold')), behind: r.S.f[m].pts < r.S.f[1 - m].pts };
}
export function trainingUtility(option, style, state) {
  const card = CARDS[option.id];
  // how much of the bout was fought where this card is legal: a share, not a hand-made yes
  const at = (keys) => (state.share ? keys.reduce((n, k) => n + (state.share[k] || 0), 0) : keys.includes(state.pos) ? 1 : 0);
  const fit = style === 'boxing'
    ? (option.id === 'jab' ? at(['K', 'P']) : option.id === 'cross' ? at(['P']) : option.id === 'escape' ? (state.held ? 1 : 0) : state.struck ? 1 : 0)
    : (option.id === 'sweep' ? at(['B']) : option.id === 'pass' ? at(['T']) : option.id === 'triangle' ? at(['B']) : state.held ? 1 : 0);
  const kit = (card.dmg || 0) + (card.pts || 0) * 2 + (card.k === 'hold' ? 5 : card.k === 'shot' ? 2 : 0);
  // the synergy is where the bout was fought: the entry from KICK is the jab's, the exchange at PUNCH the cross's; the
  // guard drill is for a bout in which he was hit, the escape practice for one in which he was held (the boxer never
  // lays a card in the CLINCH on this ladder, so the hook had no state to be right in and the slot is the escape's).
  // Weights sized on the ladder's own states (L2) so that each option is the pick somewhere and none is the pick
  // everywhere; the hand-made spread in engine.test.mjs must cycle too.
  const synergy = style === 'boxing'
    ? (option.id === 'jab' ? at(['K']) * 60 : option.id === 'cross' ? at(['P']) * 20 : option.id === 'escape' && state.held ? 30 : option.id === 'block' && state.struck ? 70 : 0)
    : (option.id === 'sweep' ? at(['B']) * 20 : option.id === 'pass' ? at(['T']) * 20 : option.id === 'triangle' ? at(['B']) * (state.behind ? 30 : 20) : option.id === 'escape' && state.held ? 30 : 0);
  return fit * (kit + synergy) + (1 - fit) * 1 - option.cost * 1.7 - option.fail * 9;
}
// L2: the ten states are ten of the ladder's own training states for this art, every ⌊n/10⌋-th of a 100-run ladder in
// run order, so they span club bouts and title defences alike. Not hand-made, not chosen.
export function measureTraining(style, states) {
  const options = TRAINING[style];
  const sts = states ? states.slice(0, 10) : (() => { const all = simulateLadder(100, 600000000, 80, style).states, step = Math.max(1, Math.floor(all.length / 10)); return all.filter((_, i) => i % step === 0).slice(0, 10); })();
  const top = sts.map((state) => Math.max(...options.map((o) => trainingUtility(o, style, state))));
  const chosen = options.map((option) => sts.reduce((n, state, i) => n + (trainingUtility(option, style, state) >= top[i] - 1e-9 ? 1 : 0), 0));
  return { states: sts.length, options: options.map((o, i) => ({ id: o.id, right: chosen[i] })), pass: chosen.every((n) => n >= 1 && n <= 6), samples: sts };
}
export const ladderBudgetSeconds = (decisions, secondsPerDecision = 8) => decisions * secondsPerDecision;
export function simulateLadder(runs = 100, seed = 600000000, maxBouts = 80, style) {
  const AI = aiPilot(), results = [], byRung = RUNGS.map(() => ({ bouts: 0, wins: 0 })); let titleWins = 0, boutCount = 0, decisionCount = 0, capped = 0;
  for (let i = 0; i < runs; i++) {
    const career = freshCareer(style || (i % 2 ? 'boxing' : 'bjj'), seed + i * 1009); let wonTitle = false, runDecisions = 0; const states = [];
    for (let n = 0; n < maxBouts; n++) {
      const r = bout(playerFighter(career), rivalFighter(career, career.rung), [AI, rivalPilot(career.rung, career)], seed + i * 1009 + n * 31);
      const won = r.win === 0; boutCount++; decisionCount += r.st.dec[0]; runDecisions += r.st.dec[0];
      byRung[career.rung].bouts++; if (won) byRung[career.rung].wins++;
      wonTitle = wonTitle || takesTitle(career, won); // sticky: a defence lost and regained is still a title won
      const defended = career.rung === RUNGS.length - 1; // the last defence, read before resultCareer moves the rung
      resultCareer(career, won);
      if ((defended && won) || career.losses >= CUT_AT_LOSSES) break; // the career ends at the last defence or the cut
      const state = trainingState(r); states.push(state);
      const choice = TRAINING[career.style].slice().sort((a, b) => trainingUtility(b, career.style, state) - trainingUtility(a, career.style, state))[0];
      train(career, choice, seededRandom(seed + i * 991 + n * 17));
    }
    if (wonTitle) titleWins++; else if (career.losses < CUT_AT_LOSSES) capped++;
    results.push({ title: wonTitle, bouts: career.bouts, decisions: runDecisions, cut: !wonTitle && career.losses >= CUT_AT_LOSSES, states });
  }
  const winners = results.filter((x) => x.title), avg = (xs, key) => xs.length ? xs.reduce((n, x) => n + x[key], 0) / xs.length : 0;
  return { runs, titleWins, titleRate: titleWins / runs, meanBouts: boutCount / runs, bouts: boutCount, meanMinutes: decisionCount / runs * 8 / 60, titleWinnerMeanBouts: avg(winners, 'bouts'), titleWinnerMeanMinutes: avg(winners, 'decisions') * 8 / 60, capped, cut: results.filter((x) => x.cut).length, byRung, results, states: results.flatMap((x) => x.states) };
}
function seededRandom(seed) { let a = seed >>> 0; return () => { a = (a + 0x6d2b79f5) | 0; let t = Math.imul(a ^ (a >>> 15), 1 | a); t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t; return ((t ^ (t >>> 14)) >>> 0) / 4294967296; }; }
export const assertCareer = (c) => { if (!RUNGS[c.rung] || c.rank < 1 || c.energy < 0 || c.deck.length < 15) throw new Error('Invalid career state'); return true; };
void N;
