// design aid: how well can the hidden card be predicted from public information? (calibration seeds)
import { NAME, NCODES, PLAYERS, OPPONENTS, cardOf } from './cards.mjs';
import { playBout } from './bout.mjs';
import { readerBot } from './bots.mjs';
for (const [nm, o] of [['count + learn', {}], ['no count', { count: false }], ['film', { film: true }], ['no learn', { learn: false }]]) {
  let n = 0, top = 0, psum = 0, s = 300000; const conf = {}; const truthHist = new Array(NCODES).fill(0);
  for (const p of PLAYERS) for (const op of OPPONENTS) for (let i = 0; i < 30; i++) {
    s++;
    const bot = readerBot({ seed: s, ...o }), pick = bot.pick;
    bot.pick = (v) => {
      const hid = v.shown.indexOf(-1);
      if (hid >= 0 && v.hiddenCount === 1) {
        const post = bot.debugPosterior(v, hid), truth = v.truth[hid];
        let best = 0; for (let c = 1; c < NCODES; c++) if (post[c] > post[best]) best = c;
        n++; psum += post[truth]; if (best === truth) top++; truthHist[cardOf(truth)]++;
      }
      return pick(v);
    };
    playBout(p, op, bot, { seed: s });
  }
  console.log(`${nm}: hidden cards ${n}, most likely guess right ${(100 * top / n).toFixed(1)}%, average chance given to the true card ${(100 * psum / n).toFixed(1)}%`);
  if (nm === 'count + learn') console.log('  what the hidden card was: ' + truthHist.map((x, c) => (x ? `${NAME[c]} ${(100 * x / n).toFixed(0)}%` : '')).filter(Boolean).join(', '));
}
