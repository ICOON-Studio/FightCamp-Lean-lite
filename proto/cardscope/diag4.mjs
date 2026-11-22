// sizing aid: every pair at the chosen paper steps (calibration seeds)
import { PLAYERS, OPPONENTS } from './cards.mjs';
import { playBout } from './bout.mjs';
import { readerBot, greedyBot } from './bots.mjs';
for (const [nm, mk] of [['reader', (s) => readerBot({ seed: s })], ['greedy', (s) => greedyBot(s)]]) {
  let n = 0, win = 0, late = 0, one = 0, stop = 0, split = 0, pts = 0, kd = 0, s = 310000; const rows = [];
  for (const p of PLAYERS) for (const o of OPPONENTS) {
    let w = 0;
    for (let i = 0; i < 100; i++) { s++; const st = playBout(p, o, mk(s), { seed: s }); n++; w += st.win; late += st.late; one += st.oneSided; kd += st.kdP + st.kdO; if (st.method === 'stop') stop++; else { pts++; split += st.split; } }
    win += w; rows.push(`${p.style} v ${o.style} ${w}`);
  }
  console.log(`${nm}: ${(100 * win / n).toFixed(1)}% | late ${(100 * late / n).toFixed(1)}% one-sided ${(100 * one / n).toFixed(1)}% stopped ${(100 * stop / n).toFixed(1)}% split ${(100 * split / pts).toFixed(1)}% kd ${(kd / n).toFixed(2)}`);
  console.log('  ' + rows.join(', '));
}
