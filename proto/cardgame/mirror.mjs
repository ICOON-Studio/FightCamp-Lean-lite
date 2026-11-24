// S549 (owner: "the real test should be a boxer vs boxer"): 400 bot bouts of ONE art against itself, and what the bout
// is made of - how it ends, who wins by seat and by going first, which cards are laid and which never, how many
// decisions. node mirror.mjs [style=boxing] [name=value ...]
import { CARDS, N, fighter } from './cards.mjs';
import { bout } from './engine.mjs';
import { aiPilot } from './plan.mjs';
let style = 'boxing';
for (const kv of process.argv.slice(2)) { const [k, v] = kv.split('='); if (k === 'style') style = v; else N[k] = +v; }
const n = 400, r = { seat0: 0, first: 0, how: {}, laid: {}, ans: {}, dec: 0, hp: 0, kds: 0, combos: 0, quiet: 0, turns: 0, early: 0, places: {} };
for (let i = 0; i < n; i++) {
  const first = i % 2;
  const b = bout(fighter(style), fighter(style), [aiPilot(), aiPilot()], 500000000 + 7919 * i, { first,
    onAnswer(S, k, a) { const id = a ? a.id : 'no answer'; r.ans[id] = (r.ans[id] || 0) + 1; },
    onAct(S, k, seq) { r.turns++; if (!seq.length) r.quiet++; for (const id of seq) r.laid[id] = (r.laid[id] || 0) + 1;
      const key = S.at[0] !== 'stand' || S.at[1] !== 'stand' ? 'a man down' : S.j.kind === 'clinch' ? 'clinch' : S.j.reach === 'K' ? 'long range' : 'punching range'; r.places[key] = (r.places[key] || 0) + 1; } });
  r.seat0 += b.win === 0; r.first += b.win === first; r.how[b.how] = (r.how[b.how] || 0) + 1; r.early += b.early ? 1 : 0;
  r.dec += b.st.dec[0] + b.st.dec[1]; r.hp += b.S.f[0].hp + b.S.f[1].hp; r.kds += b.st.kds || 0; r.combos += b.st.combos || 0;
}
const pc = (x, of) => (100 * x / of).toFixed(1) + '%';
const deck = [...new Set(fighter(style).deck)];
console.log(`${style} v ${style}, ${n} bot bouts`);
console.log('the man who goes first wins', pc(r.first, n), '| seat 0 wins', pc(r.seat0, n), '| ends before the last bell', pc(r.early, n), '| how', JSON.stringify(r.how));
console.log('decisions a bout (both men)', (r.dec / n).toFixed(1), '| health left, a man', (r.hp / n / 2).toFixed(1), 'of', N.hp, '| knockdowns a bout', (r.kds / n).toFixed(2), '| combinations a bout', (r.combos / n).toFixed(2), '| empty turns', pc(r.quiet, r.turns));
console.log('where the turns are spent', JSON.stringify(Object.fromEntries(Object.entries(r.places).map(([k, v]) => [k, pc(v, r.turns)]))));
console.log('laid a bout', JSON.stringify(Object.fromEntries(Object.entries(r.laid).sort((a, b) => b[1] - a[1]).map(([k, v]) => [CARDS[k]?.n || k, +(v / n).toFixed(2)]))));
console.log('answers a bout', JSON.stringify(Object.fromEntries(Object.entries(r.ans).sort((a, b) => b[1] - a[1]).map(([k, v]) => [CARDS[k]?.n || k, +(v / n).toFixed(2)]))));
console.log('in the deck and never laid or answered with', JSON.stringify(deck.filter((id) => !r.laid[id] && !r.ans[id]).map((id) => CARDS[id].n)));
