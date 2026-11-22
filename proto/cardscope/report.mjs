// CARDSCOPE1 greybox - the bar table. node proto/cardscope/probe.mjs report  (reads out/*.json, prints markdown)
import { NAME, CARDS, PLAYERS, OPPONENTS, BLOCK, BLOCK_LOW } from './cards.mjs';

const f1 = (x) => (Math.round(x * 10) / 10).toFixed(1);

export function report(load) {
  const L = load('ladder'), I = load('info'), C = load('cards');
  const rows = [];
  const bar = (id, core, name, pass, measured) => rows.push({ id, core, name, pass, measured });
  const w = (k) => L[k].winPct, rd = L.reader;

  bar('B1', 1, 'Reading beats a fixed line (15+)', w('reader') - w('fixed') >= 15, `reader ${f1(w('reader'))}% v best fixed line ${f1(w('fixed'))}% = +${f1(w('reader') - w('fixed'))} (${L.bestFixed.join(' / ')})`);
  bar('B2', 1, 'Thinking beats not thinking (30+)', w('reader') - w('random') >= 30, `reader ${f1(w('reader'))}% v random ${f1(w('random'))}% = +${f1(w('reader') - w('random'))}`);
  const topFixed = Math.max(...L.top6.map((x) => x.win), w('fixed'));
  bar('B3', 1, 'No line that needs no reading (best fixed under 45%, 10+ under the reader)', w('fixed') < 45 && w('reader') - topFixed >= 10, `best fixed ${f1(w('fixed'))}% on fresh seeds (screen best ${f1(topFixed)}%)`);
  bar('B4', 1, 'Close fights (one-sided under 35%)', rd.oneSided / rd.n < 0.35, `${f1(100 * rd.oneSided / rd.n)}% one-sided`);
  bar('B5', 1, 'Decided late (30%+ won from level or behind after round 2)', rd.late / rd.n >= 0.30, `${f1(100 * rd.late / rd.n)}%`);
  // B6: rank the cards inside each opponent column
  const styles = OPPONENTS.map((o) => o.style), names = CARDS.map((c) => NAME[c]);
  const rank = {}; for (const n of names) rank[n] = {};
  for (const s of styles) names.slice().sort((a, b) => C.matrix[b][s] - C.matrix[a][s]).forEach((n, i) => { rank[n][s] = i + 1; });
  const flat = names.filter((n) => !(styles.some((s) => rank[n][s] <= 4) && styles.some((s) => rank[n][s] >= 7)));
  bar('B6', 1, 'Every card has a matchup (top four v one style, bottom half v another)', flat.length === 0, flat.length ? 'no matchup swing: ' + flat.join(', ') : 'all 13 cards swing');
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
  let low = [], high = [];
  for (const c of CARDS) {
    const decks = PLAYERS.filter((p) => p.deck.includes(c)).length, share = 100 * plays[c] / tot, inDeck = decks ? share * PLAYERS.length / decks : 0;
    use.push(`${NAME[c]} ${f1(share)}`);
    if (decks && inDeck < 3) low.push(NAME[c]); if (share > 30) high.push(NAME[c]);
  }
  bar('B13', 0, 'No dead card, no card for everything (3%+ where held, none over 30%)', !low.length && !high.length, `share of cards played: ${use.join(', ')}${low.length ? '; dead: ' + low.join(', ') : ''}${high.length ? '; too much: ' + high.join(', ') : ''}`);
  bar('B14', 0, 'Split cards (15%+ of points decisions)', rd.pts > 0 && rd.split / rd.pts >= 0.15, `${f1(100 * rd.split / Math.max(1, rd.pts))}%`);
  bar('B15', 0, 'Film and counting pay (habits known 4+, counting 3+)', I.read.film - I.read.full >= 4 && I.read.full - I.read.noCount >= 3,
    `film +${f1(I.read.film - I.read.full)}, counting +${f1(I.read.full - I.read.noCount)}, watching his patterns +${f1(I.read.full - I.read.noLearn)} (reader ${f1(I.read.full)}%)`);
  bar('B16', 0, 'He reads you back (best fixed line loses 8+ to the adapting opponent)', L.fixedNoAdapt.winPct - w('fixed') >= 8,
    `fixed line ${f1(L.fixedNoAdapt.winPct)}% v a non-adapting opponent, ${f1(w('fixed'))}% v the adapting one; a reader who always blocks high on the hidden card: ${f1(L.stubbornNoAdapt.winPct)}% v ${f1(L.stubborn.winPct)}%`);
  const ci = I.corner, pk = ci.informed.picks, pt = pk.water + pk.ice + pk.eyes;
  bar('B17', 0, 'The corner is a decision (informed 3+ over random; each card 15%+ of informed picks)', ci.informed.win - ci.random.win >= 3 && Math.min(pk.water, pk.ice, pk.eyes) / pt >= 0.15,
    `informed ${f1(ci.informed.win)}%, random ${f1(ci.random.win)}%, always water ${f1(ci.water.win)}%, ice ${f1(ci.ice.win)}%, watch him ${f1(ci.eyes.win)}%; informed picks water ${f1(100 * pk.water / pt)}%, ice ${f1(100 * pk.ice / pt)}%, watch him ${f1(100 * pk.eyes / pt)}%`);
  const pv = Object.values(rd.pair), lo = Math.min(...pv), hi = Math.max(...pv);
  bar('B18', 0, 'Styles (every pair 40-90% for the reader)', lo >= 40 && hi <= 90, `lowest ${f1(lo)}%, highest ${f1(hi)}%`);

  const out = [];
  out.push(`Population: ${L.population}. Card table: ${C.population}. Run: ${R.runs} runs of 8 bouts.`, '');
  out.push('| # | Bar | Result | Measured |', '|---|---|---|---|');
  for (const r of rows) out.push(`| ${r.id}${r.core ? ' (core)' : ''} | ${r.name} | **${r.pass ? 'PASS' : 'FAIL'}** | ${r.measured} |`);
  const core = rows.filter((r) => r.core), cp = core.filter((r) => r.pass).length, sp = rows.filter((r) => !r.core && r.pass).length;
  out.push('', `Core bars: ${cp} of ${core.length} pass. Supporting bars: ${sp} of ${rows.length - core.length} pass. Verdict: **${cp === core.length ? 'PASS' : 'FAIL'}**.`, '');
  out.push('Reader by pair (player style v opponent style): ' + Object.entries(rd.pair).map(([k, v]) => `${k} ${f1(v)}`).join(', '), '');
  out.push('Opponent class (greedy / reader): ' + Object.values(I.tiers).map((t) => `${t.name} ${f1(t.greedy)} / ${f1(t.reader)}`).join(', '), '');
  out.push('Cards shown 0 / 1 / 2 / 3 - random, greedy, reader, all-seeing: ' + [0, 1, 2, 3].map((k) => `[${k}] ${f1(I.shown[k].random)}, ${f1(I.shown[k].greedy)}, ${f1(I.shown[k].reader)}, ${f1(I.shown[k].allSeeing)}`).join('  '), '');
  out.push('Best fixed lines found: ' + L.top6.map((x) => `${x.line} ${f1(x.win)}%`).join('; '), '');
  out.push(`What two more copies of a card are worth (reader win %, neutral deck alone: ${styles.map((s) => s + ' ' + f1(C.base[s])).join(', ')}):`, '', '| card | ' + styles.map((s) => 'v ' + s).join(' | ') + ' |', '|---|' + styles.map(() => '---:').join('|') + '|');
  for (const n of names) out.push(`| ${n} | ` + styles.map((s) => `${f1(C.matrix[n][s])} (${rank[n][s]})`).join(' | ') + ' |');
  console.log(out.join('\n'));
}
