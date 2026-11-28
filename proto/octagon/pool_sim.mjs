// v4 pool balance (S570): every pool fighter against every other, both corners, reader bots - each fighter's win rate
// (target 40-60%), the class's finish rate and the comeback share.   node proto/octagon/pool_sim.mjs [n=60] [seed=7]
import { newBout, play, legalCards, why, CARDS, TUNE } from './engine.mjs';
import { useV4, POOL } from './fighters_v4.mjs';
import { useV5 } from './cards_v5.mjs';
import { useV6 } from './cards_v6.mjs';
const arg = Object.fromEntries(process.argv.slice(2).map((x) => x.split('='))), N = +(arg.n || 60);
if (arg.v6 === '1') useV6(arg.pure === '1' ? { pure: 1 } : {}); else if (arg.v5 === '1') useV5(); else useV4();   /* S573: v6 = the owner's v2.7 Director's Cut, boxing */   /* S572: v5 = the owner's v2.0 rulebook + v2 cards */
for (const key of Object.keys(TUNE)) if (arg[key] !== undefined) TUNE[key] = +arg[key];
let seed = +(arg.seed || 7); const r = () => { seed ^= seed << 13; seed >>>= 0; seed ^= seed >> 17; seed ^= seed << 5; seed >>>= 0; return seed / 4294967296; };
const pick = (a) => a[Math.floor(r() * a.length)], ANSWER = { A: 'C', F: 'A', C: 'F' };
function chain(S, k, first) { if (S.init !== k || !CARDS[first] || !CARDS[first].chain) return []; const h = [...S.f[k].hand]; h.splice(h.indexOf(first), 1); return h.filter((id) => CARDS[id].type === 'A').slice(0, 2); }
function reader(S, k, hint) { const L0 = legalCards(S, k), L = L0.filter((id) => id !== 'hold').length ? L0.filter((id) => id !== 'hold') : L0;   /* bots: Hold Ground only when nothing else is legal */ if (!L.length) return { card: 'none' }; const his = S.log.slice(-3).map((e) => e.plays[1 - k]).filter((id) => id !== 'none' && CARDS[id]).map((id) => CARDS[id].type);
  const cnt = { A: 0, C: 0, F: 0, D: 0 }; his.forEach((t) => cnt[t]++); const likely = Object.keys(cnt).sort((x, y) => cnt[y] - cnt[x])[0];
  let want = likely === 'D' ? 'F' : ANSWER[likely] || 'A'; if (S.f[1 - k].rocked) want = 'A'; if (S.f[k].st <= 3) want = 'D'; if (hint) want = hint === 'AC' ? 'D' : r() < 0.5 ? 'A' : 'F';   /* S573 v6 tell: Red/Blue -> block it; Yellow/Green -> hit the feint or feint the guard */
  const opts = L.filter((id) => CARDS[id].type === want && id !== 'hold'); const c = opts.length ? pick(opts) : pick(L);
  return { card: c, then: chain(S, k, c), react: S.f[k].hand.find((id) => ['C', 'D'].includes(CARDS[id].type)) || null, discard: S.f[k].hand.find((id) => id !== c && why(S, k, id)) || null }; }
const ids = Object.keys(POOL), W = Object.fromEntries(ids.map((id) => [id, [0, 0]])); let tells = 0, stag = 0, cuts = 0, docs = 0, bouts = 0, fin = 0, cbN = 0, cbW = 0, idle = 0, exs = 0, locked = 0, rocks = 0, reRocks = 0, pushes = 0;
for (const a of ids) for (const b of ids) { if (a === b) continue;
  for (let i = 0; i < N; i++) { const S = newBout(Math.floor(r() * 1e9), a, b, [a, b]); let behind = -1;
    for (let g = 0; g < 200 && !S.over; g++) { const before = S.round; { const h = [0, 1].find((x) => S.f[x].tellAt === S.n + 1); if (h === undefined) play(S, [reader(S, 0), reader(S, 1)]); else { const pv = reader(S, 1 - h), c = CARDS[pv.card], ph = reader(S, h, c && ['A', 'C'].includes(c.type) ? 'AC' : 'FD'); tells++; play(S, h === 0 ? [ph, pv] : [pv, ph]); } } if (S.round === 2 && before === 1) behind = S.score[0] === S.score[1] ? -1 : S.score[0] < S.score[1] ? 0 : 1; }
    { let run = 0, worst = 0; for (const L of S.log) { exs++; const still = L.plays.every((c) => c === 'hold' || c === 'none'); if (still) { idle++; run++; worst = Math.max(worst, run); } else run = 0; } if (worst >= 3) locked++; }   { let prev = [0, 0]; for (const L of S.log) { const now = [0, 1].map((k) => L.lines.some((x) => x.k === k && /^ROCKED/.test(x.t)) ? 1 : 0); for (const k of [0, 1]) { rocks += now[k]; if (now[k] && prev[k]) reRocks++; } if (L.lines.some((x) => /pushed back a range/.test(x.t))) pushes++; prev = now; } }   /* S571: rocked twice in a row (cup v4 r2) */   /* S571: the stamina lock - exchanges where neither man does anything, bouts with 3+ in a row */
    for (const L of S.log) for (const e of L.lines) { if (/is STAGGERED/.test(e.t)) stag++; if (/is CUT over/.test(e.t)) cuts++; }   if (S.over && /doctor/.test(S.over.how)) docs++;
    bouts++; const w = S.over ? S.over.winner : -1; W[a][1]++; W[b][1]++; if (w === 0) W[a][0]++; else if (w === 1) W[b][0]++; else { W[a][0] += 0.5; W[b][0] += 0.5; }
    if (S.over && /KO/.test(S.over.how)) fin++; if (behind >= 0) { cbN++; if (w === behind) cbW++; } } }
console.log(`POOL_SIM ${bouts} bouts, tells ${(tells / bouts).toFixed(2)} a bout, staggers ${(stag / bouts).toFixed(2)}, cuts ${(cuts / bouts).toFixed(2)}, doctor stops ${(100 * docs / bouts).toFixed(0)}%, finishes ${(100 * fin / bouts).toFixed(0)}% (middleweight target 40-50%), comebacks ${(100 * cbW / Math.max(1, cbN)).toFixed(0)}%, both idle ${(100 * idle / Math.max(1, exs)).toFixed(1)}% of exchanges, locked bouts (3+ idle in a row) ${(100 * locked / bouts).toFixed(1)}%, rocks ${(rocks / bouts).toFixed(2)} a bout, rocked twice in a row ${(100 * reRocks / Math.max(1, rocks)).toFixed(1)}% of rocks, push-backs ${(pushes / bouts).toFixed(2)} a bout`);
for (const id of ids.sort((x, y) => W[y][0] / W[y][1] - W[x][0] / W[x][1])) console.log(`  ${id.padEnd(10)} ${(100 * W[id][0] / W[id][1]).toFixed(0)}%  (${POOL[id].style})`);
