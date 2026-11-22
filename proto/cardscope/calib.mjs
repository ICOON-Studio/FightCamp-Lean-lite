// CARDSCOPE1 greybox - sizing sweep. Calibration seeds only (300000+); the bar table runs on other seeds.
// node proto/cardscope/calib.mjs  -> one line per setting: reader / greedy win %, stoppages, one-sided, late, split.
import { PLAYERS, OPPONENTS } from './cards.mjs';
import { playBout } from './bout.mjs';
import { readerBot } from './bots.mjs';

export function cell(mk, per, opts) {
  const a = { n: 0, win: 0, stop: 0, one: 0, late: 0, split: 0, pts: 0, kd: 0 };
  let s = 300000;
  for (const p of PLAYERS) for (const o of OPPONENTS) for (let i = 0; i < per; i++) {
    s++;
    const st = playBout(p, o, mk(s), { ...opts, seed: s });
    a.n++; a.win += st.win; a.one += st.oneSided; a.late += st.late; a.kd += st.kdP + st.kdO;
    if (st.method === 'stop') a.stop++; else { a.pts++; a.split += st.split; }
  }
  const p = (x, n = a.n) => (100 * x / Math.max(1, n)).toFixed(0).padStart(3);
  return `${p(a.win)}% win ${p(a.stop)}% stop ${p(a.one)}% one-sided ${p(a.late)}% late ${p(a.split, a.pts)}% split ${(a.kd / a.n).toFixed(2)} kd`;
}
const per = Number(process.argv[2] || 60);
// size each opponent boxer's paper step so the reader wins about 65% against him, then show every pair at that step
for (const o of OPPONENTS) {
  let line = o.style + ':';
  for (let lvl = 0; lvl <= 8; lvl++) {
    let w = 0, n = 0, s = 300000 + lvl * 1000;
    for (const p of PLAYERS) for (let i = 0; i < per; i++) { s++; w += playBout(p, o, readerBot({ seed: s }), { seed: s, oppLvl: lvl }).win; n++; }
    line += ` [${lvl}] ${Math.round(100 * w / n)}`;
  }
  console.log(line);
}
