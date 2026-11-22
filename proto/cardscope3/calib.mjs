// sizing aid on its own seeds (300000 and up). node calib.mjs [per=40] [cls=3] [name=value ...] resizes one number of N
import { N, PLAYERS, OPPS, CLASSES, CARDS } from './cards.mjs';
import { bout } from './engine.mjs';
import { planner, opponent, PROF } from './plan.mjs';
import { randomBot, beginnerBot } from './bots.mjs';

const arg = Object.fromEntries(process.argv.slice(2).map((a) => a.split('=')));
const per = +(arg.per || 40), ci = +(arg.cls || 3);
for (const [k, v] of Object.entries(arg)) {
  if (k in N) N[k] = +v;
  else if (k.includes('.')) { const [a, b] = k.split('.'); if (CARDS[a]) CARDS[a][b] = +v; else if (PROF[a]) PROF[a][b] = +v; else if (a === 'cls') CLASSES[ci][b] = +v; }
}
const cls = CLASSES[ci];
const bots = { random: randomBot, beginner: beginnerBot, greedy: () => planner('greedy'), table: () => planner('table'), reader: () => planner('reader'), see: () => planner('see') };
const only = arg.bots ? arg.bots.split(',') : Object.keys(bots);
for (const nm of only) {
  let w = 0, n = 0, dec = 0, stop = 0, kd = 0, one = 0, late = 0, dealt = 0, taken = 0, tired = 0, turns = 0, stopd = 0, thr = 0, sets = 0, pt = 0; const pair = [];
  PLAYERS.forEach((P, pi) => OPPS.forEach((O, oi) => {
    let pw = 0;
    for (let i = 0; i < per; i++) {
      const r = bout(P, O, [bots[nm](), opponent(cls)], 300000 + pi * 100000 + oi * 10000 + i, { cls, rounds: cls.rounds });
      pw += r.win === 0; n++; dec += r.st.dec; stop += r.stop; kd += r.st.kds; one += r.oneSided; late += r.late; dealt += r.dealt; taken += r.taken;
      tired += r.st.tired[1]; turns += r.st.turns[1]; stopd += r.st.stopped; thr += r.st.thrown; sets += r.st.sets[0]; pt += r.st.turns[0];
    }
    w += pw; pair.push(Math.round((100 * pw) / per));
  }));
  const f = (x) => (100 * x / n).toFixed(1);
  console.log(`${nm.padEnd(8)} win ${f(w)}  dec ${(dec / n).toFixed(1)}  stop ${f(stop)} kd ${(kd / n).toFixed(2)}  one ${f(one)} late ${f(late)}  dmg ${(dealt / n).toFixed(0)}/${(taken / n).toFixed(0)}  oppTired ${(100 * tired / turns).toFixed(1)}  stopped ${(100 * stopd / thr).toFixed(0)}  mySets ${(100 * sets / pt).toFixed(0)}  pairs ${pair.join(' ')}`);
}
