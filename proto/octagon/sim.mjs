// Octagon Tactics bots + a balance run (S570, TASK_OCTAGON1 step 3).
//   node proto/octagon/sim.mjs [n=1000] [seed=1]
// Bots: random (any legal card), greedy (attack with the Lead or when fresh, defend when low, combos when it can),
// reader (counts his last 3 card TYPES and plays what beats the most likely one). Prints wins, KO share, card play and
// win rates, Lead streaks, comebacks, dead and must-play cards.
import { newBout, play, legalCards, why, CARDS, PROFILES, TUNE, useV2 } from './engine.mjs';
const arg = Object.fromEntries(process.argv.slice(2).map((x) => x.split('='))), N = +(arg.n || 1000);
for (const key of Object.keys(TUNE)) if (arg[key] !== undefined) TUNE[key] = +arg[key]; if (arg.v2) { useV2(); for (const key of Object.keys(TUNE)) if (arg[key] !== undefined) TUNE[key] = +arg[key]; }
let seed = +(arg.seed || 1); const r = () => { seed ^= seed << 13; seed >>>= 0; seed ^= seed >> 17; seed ^= seed << 5; seed >>>= 0; return seed / 4294967296; };
const pick = (a) => a[Math.floor(r() * a.length)];
const BEATS = { A: 'F', F: 'C', C: 'A' }, ANSWER = { A: 'C', F: 'A', C: 'F' };
function chain(S, k, first) { if (S.init !== k || !CARDS[first].chain) return []; const h = [...S.f[k].hand]; h.splice(h.indexOf(first), 1); return h.filter((id) => CARDS[id].type === 'A' && CARDS[id].legal.includes(first === 'jab' ? 'mid' : S.range)).slice(0, 2); }
function react(S, k) { return S.f[k].hand.find((id) => ['C', 'D'].includes(CARDS[id].type)) || null; }
const BOTS = {
  random(S, k) { const L = legalCards(S, k); const c = L.length ? pick(L) : 'none'; return { card: c, then: c !== 'none' ? chain(S, k, c) : [], react: react(S, k) }; },
  greedy(S, k) { const L = legalCards(S, k), F = S.f[k]; if (!L.length) return { card: 'none' }; const by = (t) => L.filter((id) => CARDS[id].type === t);
    let c; if (F.st <= 4 && by('D').length) c = pick(by('D')); else if ((S.init === k || F.st > F.stMax / 2) && by('A').length) c = by('A').sort((x, y) => CARDS[y].dmg - CARDS[x].dmg)[0]; else c = pick(L);
    return { card: c, then: chain(S, k, c), react: react(S, k) }; },
  reader(S, k) { const L = legalCards(S, k); if (!L.length) return { card: 'none' }; const his = S.log.slice(-3).map((e) => e.plays[1 - k]).filter((id) => id !== 'none').map((id) => CARDS[id].type);
    const cnt = { A: 0, C: 0, F: 0, D: 0 }; his.forEach((t) => cnt[t]++); const likely = Object.keys(cnt).sort((x, y) => cnt[y] - cnt[x])[0];
    let want = likely === 'D' ? 'F' : ANSWER[likely] || 'A'; if (S.f[1 - k].rocked) want = 'A'; if (S.f[k].st <= 3) want = 'D';
    const opts = L.filter((id) => CARDS[id].type === want); const c = opts.length ? pick(opts) : pick(L); return { card: c, then: chain(S, k, c), react: react(S, k) }; },
};
const stats = {}; const S0 = (key) => (stats[key] = stats[key] || { n: 0, wins: [0, 0, 0], ko: 0, plays: {}, won: {}, streak: [], comeback: [0, 0], ex: 0, defend: 0, legal: {} });
for (const [ba, bb] of [['random', 'random'], ['greedy', 'random'], ['reader', 'greedy'], ['reader', 'reader'], ['greedy', 'greedy']]) for (const [pa, pb] of [['out', 'press'], ['press', 'out'], ['out', 'out'], ['press', 'press']]) {
  const st = S0(`${ba}(${pa}) v ${bb}(${pb})`);
  for (let i = 0; i < N; i++) { const S = newBout(Math.floor(r() * 1e9), pa, pb, [ba, bb]); let run = 0, holder = -1, behind = -1;
    for (let g = 0; g < 200 && !S.over; g++) { for (const k of [0, 1]) for (const id of legalCards(S, k)) st.legal[id] = (st.legal[id] || 0) + 1;
      const P = [BOTS[ba](S, 0), BOTS[bb](S, 1)]; if (TUNE.discard) for (const k of [0, 1]) P[k].discard = S.f[k].hand.find((id) => id !== P[k].card && why(S, k, id)) || null; const before = S.round; play(S, P); st.ex++;
      for (const k of [0, 1]) if (P[k].card !== 'none') { st.plays[P[k].card] = (st.plays[P[k].card] || 0) + 1; if (CARDS[P[k].card].type === 'D') st.defend++; }
      const last = S.log[S.log.length - 1]; const w = S.init; if (w === holder && w >= 0) run++; else { if (run) st.streak.push(run); run = w >= 0 ? 1 : 0; holder = w; }
      for (const k of [0, 1]) if (last.lines.some((e) => e.k === k && /^lands/.test(e.t)) && P[k].card !== 'none') st.won[P[k].card] = (st.won[P[k].card] || 0) + 1;
      if (S.round === 2 && before === 1) behind = S.score[0] === S.score[1] ? -1 : S.score[0] < S.score[1] ? 0 : 1; }
    st.n++; const w = S.over ? S.over.winner : -1; st.wins[w < 0 ? 2 : w]++; if (S.over && /KO/.test(S.over.how)) st.ko++; if (behind >= 0) { st.comeback[0]++; if (w === behind) st.comeback[1]++; } } }
const pc = (x) => (100 * x).toFixed(0) + '%';
for (const [key, st] of Object.entries(stats)) { const tot = Object.values(st.plays).reduce((a, b) => a + b, 0), sl = st.streak.length ? st.streak.reduce((a, b) => a + b, 0) / st.streak.length : 0;
  console.log(`${key}: n ${st.n} | A wins ${pc(st.wins[0] / st.n)}, B ${pc(st.wins[1] / st.n)}, draws ${pc(st.wins[2] / st.n)} | KO/TKO ${pc(st.ko / st.n)} | Lead streak mean ${sl.toFixed(2)} (max ${Math.max(0, ...st.streak)}) | behind after R1 came back ${pc(st.comeback[1] / Math.max(1, st.comeback[0]))} of ${st.comeback[0]} | Defend ${pc(st.defend / tot)} of cards`);
  if (/^(reader|greedy)/.test(key) && /out\) v .*\(press/.test(key)) console.log('   plays: ' + Object.entries(st.plays).sort((x, y) => y[1] - x[1]).map(([id, n]) => `${id} ${pc(n / tot)} (lands ${pc((st.won[id] || 0) / n)})`).join(', ')); }
