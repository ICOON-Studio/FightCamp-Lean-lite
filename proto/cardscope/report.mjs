// CARDSCOPE greybox (round 2) - the bar table. node proto/cardscope/probe.mjs report  (reads out/*.json, prints markdown)
// B1-B18: the round 1 bars, unchanged. C1-C12: the round 2 bars (design page 4b). PASS = B1-B7 and C1-C12.
import { NAME, CARDS, PLAYERS, OPPONENTS, BLOCK, BLOCK_LOW } from './cards.mjs';

const f1 = (x) => (Math.round(x * 10) / 10).toFixed(1);

export function report(load) {
  const L = load('ladder'), F = load('fixed'), I = load('info'), C = load('cards'), K = load('breaker');
  const rows = [];
  const bar = (id, core, name, pass, measured) => rows.push({ id, core, name, pass, measured });
  const rd = L.reader, W = { random: F.random.winPct, fixed: F.fixed.winPct, greedy: L.greedy.winPct, reader: rd.winPct, allSeeing: L.allSeeing.winPct,
    beginner: L.beginner.winPct, table: L.table.winPct };
  const w = (k) => W[k];

  bar('B1', 1, 'Reading beats a fixed line (15+)', w('reader') - w('fixed') >= 15, `reader ${f1(w('reader'))}% v best fixed line ${f1(w('fixed'))}% = +${f1(w('reader') - w('fixed'))} (${F.bestFixed.join(' / ')}, hides beat ${F.hideAt})`);
  bar('B2', 1, 'Thinking beats not thinking (30+)', w('reader') - w('random') >= 30, `reader ${f1(w('reader'))}% v random ${f1(w('random'))}% = +${f1(w('reader') - w('random'))}`);
  const topFixed = Math.max(...F.top6.map((x) => x.win), w('fixed'));
  bar('B3', 1, 'No line that needs no reading (best fixed under 45%, 10+ under the reader)', w('fixed') < 45 && w('reader') - topFixed >= 10, `best fixed ${f1(w('fixed'))}% on fresh seeds (screen best ${f1(topFixed)}%)`);
  bar('B4', 1, 'Close fights (one-sided under 35%)', rd.oneSided / rd.n < 0.35, `${f1(100 * rd.oneSided / rd.n)}% one-sided`);
  bar('B5', 1, 'Decided late (30%+ won from level or behind after round 2)', rd.late / rd.n >= 0.30, `${f1(100 * rd.late / rd.n)}%`);
  // B6: rank the cards inside each opponent column
  const styles = OPPONENTS.map((o) => o.style), names = CARDS.map((c) => NAME[c]), half = Math.floor(names.length / 2) + 1;
  const rank = {}; for (const n of names) rank[n] = {};
  for (const s of styles) names.slice().sort((a, b) => C.matrix[b][s] - C.matrix[a][s]).forEach((n, i) => { rank[n][s] = i + 1; });
  const flat = names.filter((n) => !(styles.some((s) => rank[n][s] <= 4) && styles.some((s) => rank[n][s] >= half)));
  bar('B6', 1, 'Every card has a matchup (top four v one style, bottom half v another)', flat.length === 0, flat.length ? 'no matchup swing: ' + flat.join(', ') : `all ${names.length} cards swing`);
  const R = C.run;
  bar('B7', 1, 'The run has choices (3+ wide offers a run; informed picks beat random picks)', R.wideOffersPerRun >= 3 && R.winPct.informed > R.winPct.random,
    `${R.wideOffersPerRun} wide offers of ${R.offersPerRun} a run; bouts won: informed ${f1(R.winPct.informed)}%, random pick ${f1(R.winPct.random)}%, no pick ${f1(R.winPct.noPick)}%; wins a run ${R.winsPerRun.informed} v ${R.winsPerRun.random}`);
  const order = w('random') < w('fixed') && w('fixed') < w('greedy') && w('greedy') < w('reader') && w('reader') < w('allSeeing');
  bar('B8', 0, 'A ladder of skill (random < fixed < greedy < reader < all-seeing; reader 8+ over greedy)', order && w('reader') - w('greedy') >= 8,
    `${f1(w('random'))} / ${f1(w('fixed'))} / ${f1(w('greedy'))} / ${f1(w('reader'))} / ${f1(w('allSeeing'))}`);
  const gap = w('allSeeing') - w('reader');
  bar('B9', 0, 'The hidden card is a bet, not the game (all-seeing 5 to 20 over the reader)', gap >= 5 && gap <= 20, `+${f1(gap)}`);
  const lead = (k) => I.shown[k].reader - I.shown[k].random;
  bar('B10', 0, 'Showing beats guessing (reader lead over random 10+ bigger with 2 shown than with 0)', lead(2) - lead(0) >= 10,
    `lead over random with 0 / 1 / 2 / 3 cards shown: ${[0, 1, 2, 3].map((k) => f1(lead(k))).join(' / ')}`);
  const stop = 100 * rd.stop / rd.n, kd = rd.kd / rd.n, r1 = 100 * rd.stopR1 / rd.n;
  bar('B11', 0, 'Stoppages 10-25%, knockdowns 0.3-1.0 a bout, round-1 stoppages under 3%', stop >= 10 && stop <= 25 && kd >= 0.3 && kd <= 1.0 && r1 < 3, `${f1(stop)}% stopped, ${kd.toFixed(2)} knockdowns a bout, ${f1(r1)}% in round 1`);
  const nl = 100 * rd.noLand / rd.ex, bl = 100 * rd.blank / rd.beats;
  bar('B12', 0, 'No blanks (no punch lands in under 15% of exchanges; dead beats under 25%)', nl < 15 && bl < 25, `${f1(nl)}% of exchanges, ${f1(bl)}% of beats`);
  const plays = rd.plays.slice(); plays[BLOCK] += plays[BLOCK_LOW]; plays[BLOCK_LOW] = 0; plays[0] = 0;
  const tot = plays.reduce((a, b) => a + b, 0), use = [];
  const low = [], high = [];
  for (const c of CARDS) {
    const decks = PLAYERS.filter((p) => p.deck.includes(c)).length, share = 100 * plays[c] / tot, inDeck = decks ? share * PLAYERS.length / decks : 0;
    use.push(`${NAME[c]} ${f1(share)}`);
    if (decks && inDeck < 3) low.push(NAME[c]); if (share > 30) high.push(NAME[c]);
  }
  bar('B13', 0, 'No dead card, no card for everything (3%+ where held, none over 30%)', !low.length && !high.length, `share of cards played: ${use.join(', ')}${low.length ? '; dead: ' + low.join(', ') : ''}${high.length ? '; too much: ' + high.join(', ') : ''}`);
  bar('B14', 0, 'Split cards (15%+ of points decisions)', rd.pts > 0 && rd.split / rd.pts >= 0.15, `${f1(100 * rd.split / Math.max(1, rd.pts))}%`);
  const b15 = I.read.film - I.read.full >= 4 && I.read.full - I.read.noCount >= 3;
  bar('B15', 0, 'Film and counting pay (habits known 4+, counting 3+)', b15,
    `both habits known +${f1(I.read.film - I.read.full)} (one habit +${f1(I.read.film1 - I.read.full)}), counting +${f1(I.read.full - I.read.noCount)}, watching him +${f1(I.read.full - I.read.noLearn)} (reader ${f1(I.read.full)}%)`);
  bar('B16', 0, 'He reads you back (best fixed line loses 8+ to the adapting opponent)', F.fixedNoAdapt.winPct - w('fixed') >= 8,
    `fixed line ${f1(F.fixedNoAdapt.winPct)}% v a non-adapting opponent, ${f1(w('fixed'))}% v the adapting one; a reader who always blocks high on the hidden card: ${f1(L.stubbornNoAdapt)}% v ${f1(L.forced.block)}%`);
  const ci = I.corner, pk = ci.informed.picks, pt = pk.water + pk.ice + pk.eyes;
  bar('B17', 0, 'The corner is a decision (informed 3+ over random; each card 15%+ of informed picks)', ci.informed.win - ci.random.win >= 3 && Math.min(pk.water, pk.ice, pk.eyes) / pt >= 0.15,
    `informed ${f1(ci.informed.win)}%, random ${f1(ci.random.win)}%, always water ${f1(ci.water.win)}%, ice ${f1(ci.ice.win)}%, watch him ${f1(ci.eyes.win)}%; informed picks water ${f1(100 * pk.water / pt)}%, ice ${f1(100 * pk.ice / pt)}%, watch him ${f1(100 * pk.eyes / pt)}%`);
  const pv = Object.values(rd.pair), lo = Math.min(...pv), hi = Math.max(...pv);
  bar('B18', 0, 'Styles (every pair 40-90% for the reader)', lo >= 40 && hi <= 90, `lowest ${f1(lo)}%, highest ${f1(hi)}%`);

  // ---- round 2 bars
  bar('C1', 1, 'Equal paper holds (reader 55-65% at regional, same wind and hands)', w('reader') >= 55 && w('reader') <= 65, `${f1(w('reader'))}%`);
  const tired = 100 * rd.oppTired / rd.ex;
  bar('C2', 1, 'He tires (starts 5-15% of exchanges on 1 wind or less)', tired >= 5 && tired <= 15, `${f1(tired)}% of exchanges`);
  const ratio = rd.dmgP / rd.dmgO;
  bar('C3', 1, 'Nobody is the heavier hitter (damage dealt and taken within 10%)', ratio >= 0.9 && ratio <= 1.1,
    `dealt ${f1(rd.dmgP / rd.ex)} and taken ${f1(rd.dmgO / rd.ex)} an exchange (ratio ${ratio.toFixed(2)}); ${f1(100 * rd.winsHitMore / Math.max(1, rd.win))}% of wins with more head damage taken than given`);
  const traps = 100 * rd.trapsP / rd.leadsP;
  bar('C4', 1, 'You set traps (your face-down card is not a punch in 30%+ of leads)', traps >= 30, `${f1(traps)}% of the reader's leads`);
  const hh = rd.hisHid.map((x) => 100 * x / rd.hisLeads);
  bar('C5', 1, 'The hidden card is a fork (punch under 55%, guard or trap 20%+, nothing or feint 15%+)', hh[1] < 55 && hh[2] >= 20 && hh[0] + hh[3] >= 15,
    `punch ${f1(hh[1])}%, guard or trap ${f1(hh[2])}%, nothing ${f1(hh[0])}%, feint ${f1(hh[3])}%`);
  const fz = L.forced, worst = Math.max(fz.block, fz.jab, fz.punch, fz.empty);
  bar('C6', 1, 'No fixed answer to the hidden card (always block / jab / punch / empty each 10+ under free choice)', w('reader') - worst >= 10,
    `free ${f1(w('reader'))}%; always block ${f1(fz.block)}%, jab ${f1(fz.jab)}%, a punch ${f1(fz.punch)}%, empty ${f1(fz.empty)}%`);
  const ah = rd.ansHid.map((x) => 100 * x / rd.hisLeads);
  bar('C7', 1, 'The answers spread (no class of answer to the hidden card over 40%)', Math.max(...ah) <= 40,
    `punch ${f1(ah[0])}%, block ${f1(ah[1])}%, evade or tie up ${f1(ah[2])}%, nothing ${f1(ah[3])}%, feint ${f1(ah[4])}%`);
  bar('C8', 1, 'No breaker deck (no legal deck over 50% in the pro debut)', K.finals[0].win <= 50,
    `best of ${K.decksTried} decks and 2 swap rounds: ${f1(K.finals[0].win)}% (${K.finals[0].deck}); neutral deck ${f1(K.neutral)}%`);
  let lift = -99, liftAt = '';
  for (const n of names) for (const s of styles) { const d = C.matrix[n][s] - C.base[s]; if (d > lift) { lift = d; liftAt = `${n} v ${s}`; } }
  bar('C9', 1, 'No pair is a key (no added pair lifts a pair-up by more than 25)', lift <= 25, `biggest lift +${f1(lift)} (${liftAt})`);
  const gapBR = w('reader') - w('beginner'), up = w('table') - w('beginner');
  bar('C10', 1, 'The table makes the skill a person\'s (table player closes half the beginner-reader gap, 10+ over the beginner)', up >= 10 && up >= 0.5 * gapBR,
    `beginner ${f1(w('beginner'))}%, table player ${f1(w('table'))}%, reader ${f1(w('reader'))}%: ${f1(100 * up / Math.max(1e-9, gapBR))}% of the gap`);
  const bt = [1, 2, 3].map((t) => I.tiers[t].beginner);
  bar('C11', 1, 'No cliff (beginner 70%+ novice, 45-60% open class, 25-40% regional)', bt[0] >= 70 && bt[1] >= 45 && bt[1] <= 60 && bt[2] >= 25 && bt[2] <= 40,
    `beginner ${f1(bt[0])} / ${f1(bt[1])} / ${f1(bt[2])}%`);
  const hab = 100 * rd.habitLeads / rd.hisLeads, fl = 100 * I.flip.differs / Math.max(1, I.flip.on);
  bar('C12', 1, 'Habits rule and flip (a habit on the table in 50%+ of his leads; the answer flips in 30%+ where one applies; B15)', hab >= 50 && fl >= 30 && b15,
    `habit on the table in ${f1(hab)}% of his leads; answer differs in ${f1(fl)}% of ${I.flip.on} exchanges where a known habit applies; B15 ${b15 ? 'passes' : 'fails'}`);

  const out = [];
  out.push(`Population: ${L.population}. Card table: ${C.population}. Run: ${R.runs} runs of 8 bouts. Breaker: ${K.population}.`, '');
  out.push('| # | Bar | Result | Measured |', '|---|---|---|---|');
  for (const r of rows) out.push(`| ${r.id}${r.core ? ' (core)' : ''} | ${r.name} | **${r.pass ? 'PASS' : 'FAIL'}** | ${r.measured} |`);
  const isB = (r) => r.id[0] === 'B', coreB = rows.filter((r) => r.core && isB(r)), cs = rows.filter((r) => !isB(r)), sup = rows.filter((r) => !r.core);
  const n = (a) => a.filter((r) => r.pass).length, pass = n(coreB) === coreB.length && n(cs) === cs.length;
  out.push('', `Round 1 core bars (B1-B7): ${n(coreB)} of ${coreB.length} pass. Round 2 bars (C1-C12): ${n(cs)} of ${cs.length} pass. Supporting bars (B8-B18): ${n(sup)} of ${sup.length} pass. Verdict: **${pass ? 'PASS' : 'FAIL'}**.`, '');
  out.push('Reader by pair (player style v opponent style): ' + Object.entries(rd.pair).map(([k, v]) => `${k} ${f1(v)}`).join(', '), '');
  out.push('Opponent class (beginner / table player / greedy / reader): ' + Object.values(I.tiers).map((t) => `${t.name} ${f1(t.beginner)} / ${f1(t.table)} / ${f1(t.greedy)} / ${f1(t.reader)}`).join(', '), '');
  out.push('Cards shown by the leader 0 / 1 / 2 / 3 - random, greedy, reader, all-seeing: ' + [0, 1, 2, 3].map((k) => `[${k}] ${f1(I.shown[k].random)}, ${f1(I.shown[k].greedy)}, ${f1(I.shown[k].reader)}, ${f1(I.shown[k].allSeeing)}`).join('  '), '');
  out.push('Best fixed lines found: ' + F.top6.map((x) => `${x.line} ${f1(x.win)}%`).join('; '), '');
  out.push('Breaker search, final measure: ' + K.finals.map((x) => `${f1(x.win)}% ${x.why} [${x.deck}]`).join('; '), '');
  out.push(`What two more copies of a card are worth (reader win %, neutral deck alone: ${styles.map((s) => s + ' ' + f1(C.base[s])).join(', ')}):`, '', '| card | ' + styles.map((s) => 'v ' + s).join(' | ') + ' |', '|---|' + styles.map(() => '---:').join('|') + '|');
  for (const nm of names) out.push(`| ${nm} | ` + styles.map((s) => `${f1(C.matrix[nm][s])} (${rank[nm][s]})`).join(' | ') + ' |');
  console.log(out.join('\n'));
}
