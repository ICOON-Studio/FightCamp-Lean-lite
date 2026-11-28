// S574: the card game page's bout flow (table.mjs) plays whole bouts on each version - a random legal card a beat for you,
// the cup's reader bot for him. node proto/octagon/table_test.mjs ours|lite|pure
import { setRules, newGame, table, throwCard } from './table.mjs';
const v = process.argv[2] || 'ours'; setRules(v); let ok = 0, bad = 0, won = 0, beats = 0, tellsY = 0;
for (let i = 1; i <= 40; i++) { const pool = ['metronome', 'silk', 'longnight', 'iron', 'truck', 'bodyshop', 'snapshot', 'ghost'];
  const G = newGame({ seed: i, me: pool[i % 8], him: pool[(i * 3 + 1) % 8] }); let g = 0;
  for (; g < 200 && !G.over; g++) { const T = table(G); if (T.tellYou) tellsY++; const L = T.hand.filter((c) => !c.why);
    const c = L.length ? L[(i * 7 + g * 13) % L.length].id : 'none'; const then = T.comboOk && L.find((x) => x.id === c && x.chain) ? T.hand.filter((x) => x.type === 'A' && x.id !== c && x.count).slice(0, 1).map((x) => x.id) : [];
    const res = throwCard(G, { card: c, then }); if (res.error) { console.log('FAIL refused', c, res.error); bad++; break; } beats++; }
  if (G.over) { ok++; if (G.over.winner === 'you') won++; } else { console.log('FAIL no end, bout', i); bad++; } }
const T = table(newGame({ seed: 3 })); if (!T.hand.length || !T.you.name || !T.range) { console.log('FAIL table empty'); bad++; }
console.log(`${bad ? 'FAIL' : 'PASS'} table_test ${v}: ${ok}/40 bouts ended, random-card you won ${won}, ${(beats / 40).toFixed(1)} beats a bout, your tell ${tellsY} times`); process.exit(bad ? 1 : 0);
