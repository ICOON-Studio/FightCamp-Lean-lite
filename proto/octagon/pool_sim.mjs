// v4 pool balance (S570): every pool fighter against every other, both corners, reader bots - each fighter's win rate
// (target 40-60%), the class's finish rate and the comeback share.   node proto/octagon/pool_sim.mjs [n=60] [seed=7]
import { newBout, play, legalCards, why, CARDS, TUNE } from './engine.mjs';
import { useV4, POOL } from './fighters_v4.mjs';
useV4();
const arg = Object.fromEntries(process.argv.slice(2).map((x) => x.split('='))), N = +(arg.n || 60);
for (const key of Object.keys(TUNE)) if (arg[key] !== undefined) TUNE[key] = +arg[key];
let seed = +(arg.seed || 7); const r = () => { seed ^= seed << 13; seed >>>= 0; seed ^= seed >> 17; seed ^= seed << 5; seed >>>= 0; return seed / 4294967296; };
const pick = (a) => a[Math.floor(r() * a.length)], ANSWER = { A: 'C', F: 'A', C: 'F' };
function chain(S, k, first) { if (S.init !== k || !CARDS[first] || !CARDS[first].chain) return []; const h = [...S.f[k].hand]; h.splice(h.indexOf(first), 1); return h.filter((id) => CARDS[id].type === 'A').slice(0, 2); }
function reader(S, k) { const L0 = legalCards(S, k), L = L0.filter((id) => id !== 'hold').length ? L0.filter((id) => id !== 'hold') : L0;   /* bots: Hold Ground only when nothing else is legal */ if (!L.length) return { card: 'none' }; const his = S.log.slice(-3).map((e) => e.plays[1 - k]).filter((id) => id !== 'none' && CARDS[id]).map((id) => CARDS[id].type);
  const cnt = { A: 0, C: 0, F: 0, D: 0 }; his.forEach((t) => cnt[t]++); const likely = Object.keys(cnt).sort((x, y) => cnt[y] - cnt[x])[0];
  let want = likely === 'D' ? 'F' : ANSWER[likely] || 'A'; if (S.f[1 - k].rocked) want = 'A'; if (S.f[k].st <= 3) want = 'D';
  const opts = L.filter((id) => CARDS[id].type === want && id !== 'hold'); const c = opts.length ? pick(opts) : pick(L);
  return { card: c, then: chain(S, k, c), react: S.f[k].hand.find((id) => ['C', 'D'].includes(CARDS[id].type)) || null, discard: S.f[k].hand.find((id) => id !== c && why(S, k, id)) || null }; }
const ids = Object.keys(POOL), W = Object.fromEntries(ids.map((id) => [id, [0, 0]])); let bouts = 0, fin = 0, cbN = 0, cbW = 0;
for (const a of ids) for (const b of ids) { if (a === b) continue;
  for (let i = 0; i < N; i++) { const S = newBout(Math.floor(r() * 1e9), a, b, [a, b]); let behind = -1;
    for (let g = 0; g < 200 && !S.over; g++) { const before = S.round; play(S, [reader(S, 0), reader(S, 1)]); if (S.round === 2 && before === 1) behind = S.score[0] === S.score[1] ? -1 : S.score[0] < S.score[1] ? 0 : 1; }
    bouts++; const w = S.over ? S.over.winner : -1; W[a][1]++; W[b][1]++; if (w === 0) W[a][0]++; else if (w === 1) W[b][0]++; else { W[a][0] += 0.5; W[b][0] += 0.5; }
    if (S.over && /KO/.test(S.over.how)) fin++; if (behind >= 0) { cbN++; if (w === behind) cbW++; } } }
console.log(`POOL_SIM ${bouts} bouts, finishes ${(100 * fin / bouts).toFixed(0)}% (middleweight target 40-50%), comebacks ${(100 * cbW / Math.max(1, cbN)).toFixed(0)}%`);
for (const id of ids.sort((x, y) => W[y][0] / W[y][1] - W[x][0] / W[x][1])) console.log(`  ${id.padEnd(10)} ${(100 * W[id][0] / W[id][1]).toFixed(0)}%  (${POOL[id].style})`);
