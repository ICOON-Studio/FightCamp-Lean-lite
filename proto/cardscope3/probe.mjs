// CARDSCOPE3 probe: measures every bar of DESIGN_CARDGAME_SCOPE.md section 4c and prints the bar table.
// node probe.mjs <label> [per=500] [seed=1000000] [card=1000] [runs=600] [name=value ... resizes N]
import fs from 'node:fs';
import { N, CARDS, IDS, TRAPS, GUARDS, PLAYERS, OPPS, CLASSES, NEUTRAL, deckLegal, guardEffect } from './cards.mjs';
import { bout, rng, shuffle } from './engine.mjs';
import { planner, opponent, choose, PROF } from './plan.mjs';
import { randomBot, fixedBot, beginnerBot, FORCED } from './bots.mjs';

const arg = Object.fromEntries(process.argv.slice(3).map((a) => a.split('=')));
const label = process.argv[2] || 'run', per = +(arg.per || 500), SEED = +(arg.seed || 1000000), perCard = +(arg.card || 1000), nRuns = +(arg.runs || 600);
for (const [k, v] of Object.entries(arg)) { if (k in N) N[k] = +v; else if (k.includes('.')) { const [a, b] = k.split('.'); if (CARDS[a]) CARDS[a][b] = +v; else if (PROF[a]) PROF[a][b] = +v; } }
const pct = (a, b) => (b ? (100 * a) / b : 0), f1 = (x) => x.toFixed(1);
const neutralP = { name: 'P-neutral', style: 'neutral', head: 70, deck: NEUTRAL };

// one arm: `mk()` in the player's chair against every opponent, `per` bouts a pair. Returns the sums.
function arm(mk, o = {}) {
  const cls = CLASSES[o.cls || 3], players = o.players || PLAYERS, n = o.per || per, R = { n: 0, w: 0, pairs: [], dec: [], st: null, plays: {}, held: {}, resp: {}, hisSets: {}, corner: {} };
  const z = ['one', 'late', 'split', 'stop', 'stop1', 'pts', 'kd', 'dealt', 'taken', 'winMoreTaken', 'vol', 'blank', 'stopped', 'thrown', 'cards', 'dead', 'mySets', 'myTurns', 'hisSetsN', 'hisTurns', 'hisTired', 'habitOn', 'habitApplies', 'flips', 'choices', 'decisions', 'firstWin'];
  for (const k of z) R[k] = 0; R.maxChoices = 0;
  players.forEach((P, pi) => OPPS.forEach((O, oi) => {
    let pw = 0;
    for (let i = 0; i < n; i++) {
      const me = mk(), had = { set: false };
      const hook = (S, k, plan) => {
        const M = S.b[k], D = S.b[1 - k];
        if (k === 1) { if (M.habits.some((h) => M.trig.includes(h.trig))) R.habitOn++; return; }
        had.set = !!D.set;
        const fits = new Set(); S.inc.forEach((p, j) => M.hand.forEach((g) => { if (CARDS[g].kind === 'guard' && CARDS[g].w <= M.wind && guardEffect(g, p.id)) fits.add(g + j); }));
        const ch = fits.size + new Set(M.hand.filter((c) => CARDS[c].kind !== 'guard' && CARDS[c].kind !== 'tie' && (CARDS[c].kind === 'trap' ? N.trapCost : CARDS[c].w) <= M.wind)).size + 1;
        R.choices += ch; R.decisions++; if (ch > R.maxChoices) R.maxChoices = ch;
        if (o.flip && D.set && D.habits.some((h) => h.trap && D.setTrig.includes(h.trig))) {
          R.habitApplies++; const sv = S.r; S.r = () => 0.5;
          const p2 = choose(S, k, false, { prof: { ...PROF.reader, habits: 0 } }); S.r = sv;
          if (p2.seq.join() !== plan.seq.join()) R.flips++;
        }
      };
      const after = (S, k, plan, out, bell) => {
        if (k === 1) { if (plan.set) R.hisSets[plan.set] = (R.hisSets[plan.set] || 0) + 1; return; }
        const off = out.res.kd || bell, cut = out.sprung ? plan.seq.findIndex((x) => CARDS[x].cls === CARDS[out.sprung].catches) + 1 : 99;
        for (const c of [...plan.marks.filter(Boolean), ...(plan.tie ? ['tieup'] : []), ...(off ? [] : plan.seq.slice(0, N.trapEnds ? cut : 99)), ...(plan.set && !off ? [plan.set] : [])]) R.plays[c] = (R.plays[c] || 0) + 1;
        if (had.set && !bell && !out.res.kd) R.resp[out.firstCls] = (R.resp[out.firstCls] || 0) + 1;
      };
      const r = bout(P, O, [me, o.opp ? o.opp() : opponent(cls, o.oppOpt)], SEED + (o.seedOff || 0) + pi * 100000 + oi * 10000 + i, { cls, rounds: cls.rounds, hook, after });
      const st = r.st; pw += r.win === 0; R.n++; R.dec.push(st.dec);
      R.one += r.oneSided; R.late += r.late; R.split += r.split; R.stop += r.stop; R.stop1 += r.stopRound === 1; R.pts += !r.stop; R.kd += st.kds; R.dealt += r.dealt; R.taken += r.taken;
      if (r.win === 0 && r.headA > r.headB) R.winMoreTaken++;
      R.vol += st.volleys; R.blank += st.blankVolleys; R.stopped += st.stopped; R.thrown += st.thrown; R.cards += st.cardsPlayed; R.dead += st.deadTraps;
      R.mySets += st.sets[0]; R.myTurns += st.turns[0]; R.hisSetsN += st.sets[1]; R.hisTurns += st.turns[1]; R.hisTired += st.tired[1]; R.firstWin += r.win === r.firstR1;
      for (const c of new Set(P.deck)) R.held[c] = (R.held[c] || 0) + 1;
      for (const c in st.corner || {}) R.corner[c] = (R.corner[c] || 0) + st.corner[c];
    }
    R.w += pw; R.pairs.push(pct(pw, n));
  }));
  R.win = pct(R.w, R.n); return R;
}
const win = (mk, o) => arm(mk, o).win;
const reader = (o) => () => planner('reader', o);
const out = { label, per, N: { ...N } }, T0 = Date.now(), log = (...a) => console.error(`[${((Date.now() - T0) / 1000).toFixed(0)}s]`, ...a);

// 1. the ladder of bots at regional class
const Rd = arm(reader(), { flip: true }); out.reader = Rd.win; log('reader', f1(Rd.win));
const Tb = arm(() => planner('table'));
out.ladder = { random: win(randomBot), beginner: win(beginnerBot), greedy: win(() => planner('greedy')), table: Tb.win, reader: Rd.win, see: win(() => planner('see')) };
// 2. the best fixed line: 400 orders screened, the best 5 re-measured on fresh seeds
{ const r = rng(SEED + 77), cand = [];
  for (let i = 0; i < 400; i++) { const o = shuffle(IDS.slice(), r).slice(0, 4 + Math.floor(r() * 11)); cand.push({ o, s: arm(() => fixedBot(o), { per: 6, seedOff: 5e6 }).win }); }
  cand.push({ o: ['parry', 'slip', 'roll', 'block', 'jab', 'cross', 'hook', 'bodyhook', 'upper', 'bodyjab'], s: 100 });
  cand.sort((a, b) => b.s - a.s);
  out.fixed = cand.slice(0, 5).map((c) => ({ order: c.o.map((i) => CARDS[i].name).join(' > '), screen: c.s, win: win(() => fixedBot(c.o), { seedOff: 6e6 }), ids: c.o })).sort((a, b) => b.win - a.win);
  out.ladder.fixed = out.fixed[0].win; log('fixed', f1(out.ladder.fixed)); }
// 3. forced arms: the set card (C6), guards (D2), punches unseen (B10)
out.forced = Object.fromEntries(Object.keys(FORCED).map((k) => [k, win(reader(FORCED[k]))]));
out.noGuard = win(reader({ noGuard: true })); out.allGuard = win(reader({ allGuard: true }));
out.blind = { reader: win(reader({ blind: true })), random: win(randomBot) };
// 4. knowledge: habits, counting, the tally; he reads you back; the corner
out.know = { h0: win(reader({ know: { habits: 0 } })), h1: win(reader({ know: { habits: 1 } })), nocount: win(reader({ know: { count: false } })), notally: win(reader({ know: { habits: 0, tally: false } })) };
const bf = out.fixed[0].ids;
out.adapt = { fixedAdapt: out.ladder.fixed, fixedFlat: win(() => fixedBot(bf), { seedOff: 6e6, oppOpt: { adapt: false } }), noteAdapt: win(reader(FORCED.jabfirst)), noteFlat: win(reader(FORCED.jabfirst), { oppOpt: { adapt: false } }) };
out.corner = Object.fromEntries(['random', 'water', 'ice', 'watch'].map((c) => [c, win(reader({ corner: c }))])); out.corner.informed = Rd.win; out.corner.picks = Rd.corner;
log('forced, knowledge, corner done');
// 5. the classes, the mirror
out.classes = [1, 2, 3, 4, 5].map((c) => ({ cls: CLASSES[c].name, beginner: win(beginnerBot, { cls: c }), table: win(() => planner('table'), { cls: c }), greedy: win(() => planner('greedy'), { cls: c }), reader: win(reader(), { cls: c }) }));
{ const M = arm(reader(), { opp: () => planner('reader', { know: { habits: 0 } }) }); out.mirror = { firstWin: pct(M.firstWin, M.n), playerWin: M.win }; }
log('classes, mirror done');
// 6. the card table: the neutral deck plus two copies of one card against each opponent style
const cellWin = (deck, oi, c, n, off = 0) => { let w = 0; const P = { ...neutralP, deck }; for (let i = 0; i < n; i++) w += bout(P, OPPS[oi], [planner('reader'), opponent(CLASSES[c])], SEED + 2e6 + off + oi * 50000 + i, { cls: CLASSES[c], rounds: CLASSES[c].rounds }).win === 0; return pct(w, n); };
out.cardBase = OPPS.map((_, oi) => cellWin(NEUTRAL, oi, 3, perCard));
out.cardTable = IDS.map((id) => ({ id, name: CARDS[id].name, w: OPPS.map((_, oi) => cellWin([...NEUTRAL, id, id], oi, 3, perCard)) }));
for (let oi = 0; oi < 4; oi++) { const s = out.cardTable.map((r) => r.w[oi]).sort((a, b) => b - a); for (const r of out.cardTable) (r.rank ||= [])[oi] = s.indexOf(r.w[oi]) + 1; }
log('card table done');
// 7. the run: 8 bouts, a pick of 1 from 3 before each bout
{ const ladder = [1, 1, 2, 2, 3, 3, 4, 5], lift = (id, oi) => out.cardTable.find((r) => r.id === id).w[oi] - out.cardBase[oi], res = {};
  for (const mode of ['informed', 'random', 'none']) {
    let wins = 0, bouts = 0, wide = 0, offers = 0;
    for (let k = 0; k < nRuns; k++) {
      const r = rng(SEED + 3e6 + k), P = PLAYERS[k % 4]; let deck = P.deck.slice();
      for (let b = 0; b < 8; b++) {
        const oi = Math.floor(r() * 4), offer = shuffle(IDS.slice(), r).slice(0, 3).filter((id) => deck.filter((x) => x === id).length < (CARDS[id].kind === 'trap' ? N.maxTrap : N.maxCopy));
        if (offer.length > 1) { offers++; const ls = offer.map((id) => lift(id, oi)); if (Math.max(...ls) - Math.min(...ls) >= 4) wide++; }
        if (offer.length && mode !== 'none') { const pick = mode === 'random' ? offer[Math.floor(r() * offer.length)] : offer.slice().sort((x, y) => lift(y, oi) - lift(x, oi))[0]; if (mode === 'random' || lift(pick, oi) > 0) { deck.push(pick); if (deck.length > 15) { const ks = [...new Set(deck)].filter((x) => { const t = deck.slice(); t.splice(t.indexOf(x), 1); return deckLegal(t); }); const out1 = mode === 'random' ? ks[Math.floor(r() * ks.length)] : ks.sort((x, y) => lift(x, oi) - lift(y, oi))[0]; deck.splice(deck.indexOf(out1), 1); } } }
        const c = CLASSES[ladder[b]];
        wins += bout({ ...P, deck }, OPPS[oi], [planner('reader'), opponent(c)], SEED + 4e6 + k * 10 + b, { cls: c, rounds: c.rounds }).win === 0; bouts++;
      }
    }
    res[mode] = { win: pct(wins, bouts), perRun: (8 * wins) / bouts, wide: wide / nRuns, offers: offers / nRuns };
  }
  out.run = res; log('run done'); }
// 8. the breaker search in the pro debut
{ const brk = (deck, n, off) => { let s = 0; for (let oi = 0; oi < 4; oi++) s += cellWin(deck, oi, 5, n, off); return s / 4; };
  const cut = (id, k) => [...Array(k).fill(id), ...NEUTRAL.filter((c) => c !== id).slice(0, 12 - k)];
  let cand = [{ why: 'neutral deck', deck: NEUTRAL.slice() }];
  for (const id of IDS) { cand.push({ why: CARDS[id].name + ' stacked to its limit', deck: cut(id, CARDS[id].kind === 'trap' ? N.maxTrap : N.maxCopy) }); cand.push({ why: 'neutral + 2 ' + CARDS[id].name, deck: [...NEUTRAL, id, id] }); }
  const six = [...TRAPS.flatMap((t) => [t, t]), 'jab', 'jab', 'cross', 'cross', 'hook', 'block', 'slip', 'roll'];
  cand.push({ why: 'six traps', deck: six }, { why: 'guards and jabs', deck: ['jab', 'jab', 'jab', 'jab', 'block', 'block', 'block', 'slip', 'slip', 'roll', 'roll', 'parry', 'parry', 'cross'] }, { why: 'punches only', deck: ['jab', 'jab', 'jab', 'cross', 'cross', 'cross', 'hook', 'hook', 'hook', 'upper', 'bodyhook', 'bodyhook'] });
  cand = cand.filter((c) => deckLegal(c.deck)); for (const c of cand) c.s = brk(c.deck, 60, 0);
  for (let round = 1; round <= 2; round++) {
    const best = cand.slice().sort((a, b) => b.s - a.s)[0], sw = [];
    for (const o of new Set(best.deck)) for (const i of IDS) { if (i === o) continue; const d = best.deck.slice(); d.splice(d.indexOf(o), 1, i); if (deckLegal(d)) sw.push({ why: `swap round ${round}: ${CARDS[o].name} out, ${CARDS[i].name} in`, deck: d, s: brk(d, 25, 1000 * round) }); }
    sw.sort((a, b) => b.s - a.s); for (const c of sw.slice(0, 4)) c.s = brk(c.deck, 60, 0); cand.push(...sw.slice(0, 4));
  }
  cand.sort((a, b) => b.s - a.s);
  const fin = (c) => ({ why: c.why, deck: c.deck.map((i) => CARDS[i].name).join(', '), win: brk(c.deck, 250, 7000) });
  out.breaker = cand.slice(0, 5).map(fin).sort((a, b) => b.win - a.win);
  out.breakNeutral = fin(cand.find((c) => c.why === 'neutral deck')).win; out.sixTraps = fin(cand.find((c) => c.why === 'six traps')).win;
  out.bestTwo = cand.filter((c) => c.why.startsWith('neutral + 2')).slice(0, 3).map(fin).sort((a, b) => b.win - a.win)[0]; log('breaker done'); }

// the reader's own bouts
const q = (a, p) => a.slice().sort((x, y) => x - y)[Math.floor(p * (a.length - 1))], mean = (a) => a.reduce((s, x) => s + x, 0) / a.length;
const playsTot = Object.values(Rd.plays).reduce((a, x) => a + x, 0);
out.rd = { one: pct(Rd.one, Rd.n), late: pct(Rd.late, Rd.n), split: pct(Rd.split, Rd.pts), stop: pct(Rd.stop, Rd.n), stop1: pct(Rd.stop1, Rd.n), kd: Rd.kd / Rd.n, dealt: Rd.dealt / Rd.n, taken: Rd.taken / Rd.n, winMoreTaken: pct(Rd.winMoreTaken, Rd.w),
  blank: pct(Rd.blank, Rd.vol), dead: pct(Rd.dead, Rd.cards), stopped: pct(Rd.stopped, Rd.thrown), mySets: pct(Rd.mySets, Rd.myTurns), hisSets: pct(Rd.hisSetsN, Rd.hisTurns), hisTired: pct(Rd.hisTired, Rd.hisTurns), hisMix: Rd.hisSets, resp: Rd.resp,
  habitOn: pct(Rd.habitOn, Rd.hisTurns), flips: pct(Rd.flips, Rd.habitApplies), habitApplies: Rd.habitApplies, choices: Rd.choices / Rd.decisions, maxChoices: Rd.maxChoices, dec: mean(Rd.dec), dec95: q(Rd.dec, 0.95), tdec: mean(Tb.dec), tdec95: q(Tb.dec, 0.95), pairs: Rd.pairs,
  plays: Object.fromEntries(IDS.map((id) => [id, pct(Rd.plays[id] || 0, playsTot * (Rd.held[id] || 0) / Rd.n || 1)])) };
fs.mkdirSync(new URL('./out/', import.meta.url), { recursive: true });
fs.writeFileSync(new URL(`./out/${label}.json`, import.meta.url), JSON.stringify(out, null, 1));
log('written out/' + label + '.json');
