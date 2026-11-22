// sizing aid: the same reader in both chairs (are the decks and the chairs level?)
import { N, PLAYERS, OPPS, CLASSES, CARDS } from './cards.mjs';
import { bout } from './engine.mjs';
import { planner } from './plan.mjs';
const arg = Object.fromEntries(process.argv.slice(2).map((a) => a.split('=')));
for (const [k, v] of Object.entries(arg)) { if (k in N) N[k] = +v; else if (k.includes('.')) { const [a, b] = k.split('.'); CARDS[a][b] = +v; } }
const per = +(arg.per || 60); let w = 0, n = 0, fw = 0; const rows = [];
PLAYERS.forEach((P, pi) => { const row = []; OPPS.forEach((O, oi) => { let pw = 0;
  for (let i = 0; i < per; i++) { const r = bout(P, O, [planner('reader'), planner(arg.opp || 'reader', { know: { habits: 0 } })], 310000 + pi * 100000 + oi * 10000 + i); pw += r.win === 0; n++; fw += r.win === r.firstR1; }
  w += pw; row.push(Math.round(100 * pw / per)); }); rows.push(row.join(' ')); });
console.log('player wins', (100 * w / n).toFixed(1), ' first-thrower wins', (100 * fw / n).toFixed(1), ' pairs', rows.join(' | '));
