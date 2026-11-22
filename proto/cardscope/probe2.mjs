// CARDSCOPE greybox (round 2) - bar C8: is there a breaker deck? node proto/cardscope/probe.mjs breaker [scale]
// The pro debut (class 5, four rounds), the reader, the neutral boxer with each candidate deck against all four opponents.
// Candidates: the critic's two breaker decks made legal, every card stacked to its limit on the neutral deck cut to 12,
// then two rounds of one-card swaps from the best of those. The best three are measured again on fresh seeds.
import { NAME, CARDS, OPPONENTS, BASE_PLAYER, JAB, CROSS, LHOOK, BHOOK, XC, BLOCK, SLIP, STEP, TIE, FEINT, CFG, deck, deckLegal } from './cards.mjs';
import { playBout } from './bout.mjs';
import { readerBot } from './bots.mjs';

const evalDeck = (d, n, seed0) => {
  let w = 0, t = 0;
  for (const o of OPPONENTS) for (let i = 0; i < n; i++) { const seed = seed0 + t++; w += playBout(BASE_PLAYER, o, readerBot({ seed }), { seed, tier: 5, rounds: 4, playerDeck: d }).win; }
  return Math.round(1000 * w / t) / 10;
};
const show = (d) => CARDS.map((c) => [c, d.filter((x) => x === c).length]).filter((x) => x[1]).map((x) => x[1] + ' ' + NAME[x[0]]).join(', ');

export function breaker(scale, save) {
  const t0 = Date.now(), n1 = Math.round(20 * scale), n2 = Math.round(15 * scale), n3 = Math.round(125 * scale);
  const cands = [{ why: 'the neutral deck', d: BASE_PLAYER.deck.slice() },
    { why: 'the thin Cross counter deck of the critic, made legal', d: deck([[XC, 2], [BLOCK, 3], [JAB, 2], [TIE, 1], [SLIP, 2], [CROSS, 2]]) },
    { why: 'neutral deck with two Cross counters for Feint and Step back', d: deck([[JAB, 3], [CROSS, 2], [LHOOK, 1], [BHOOK, 1], [BLOCK, 2], [SLIP, 1], [XC, 2]]) }];
  const dropOrder = [FEINT, STEP, BHOOK, LHOOK, SLIP, BLOCK, CROSS, JAB];
  for (const card of CARDS) {                                   // one card stacked to its limit
    const d = BASE_PLAYER.deck.slice(), lim = card === XC ? CFG.xcMax : CFG.copyMax;
    while (d.filter((x) => x === card).length < lim) {
      const out = dropOrder.find((x) => x !== card && d.includes(x));
      d.splice(d.indexOf(out), 1); d.push(card);
    }
    cands.push({ why: NAME[card] + ' stacked to its limit', d });
  }
  for (const c of cands) c.w = evalDeck(c.d, n1, 500000);
  cands.sort((a, b) => b.w - a.w);
  let cur = cands[0];
  const climbed = [];
  for (let round = 1; round <= 2; round++) {                    // one-card swaps
    let best = null;
    for (const out of new Set(cur.d)) for (const inn of CARDS) {
      if (inn === out) continue;
      const d = cur.d.slice(); d.splice(d.indexOf(out), 1); d.push(inn);
      if (!deckLegal(d)) continue;
      const w = evalDeck(d, n2, 520000 + round * 10000);
      if (!best || w > best.w) best = { why: `swap round ${round}: ${NAME[out]} out, ${NAME[inn]} in`, d, w };
    }
    climbed.push(best); cur = best;
  }
  const finals = cands.slice(0, 3).concat(climbed).map((c) => ({ why: c.why, deck: show(c.d), screen: c.w, win: evalDeck(c.d, n3, 600000) }));
  finals.sort((a, b) => b.win - a.win);
  const res = { population: `pro debut (class 5, four rounds), reader, neutral boxer with the deck v each of 4 opponents; final measure ${n3} bouts an opponent`,
    neutral: evalDeck(BASE_PLAYER.deck, n3, 600000), decksTried: cands.length, finals, screened: cands.map((c) => ({ why: c.why, win: c.w })),
    seconds: Math.round((Date.now() - t0) / 1000) };
  save('breaker', res);
  console.log('breaker done', res.seconds, 's best', finals[0].win, finals[0].deck);
}
