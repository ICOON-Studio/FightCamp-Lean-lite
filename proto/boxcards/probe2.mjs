// BOXCARDS2 probe. node probe2.mjs [n=400] [walk=1 seed=..] [pilots=reader,reader] [name=value] [W.name=value] [D.card=n] [card.field=value]
import { N, CARDS, DECK, bout } from './rules2.mjs';
import { PILOTS, W } from './bot2.mjs';
const arg = { n: 400, walk: 0, seed: 0, pilots: 'reader,reader' };
for (const kv of process.argv.slice(2)) { const [k, v] = kv.split('='); if (k in arg) arg[k] = isNaN(+v) ? v : +v; else if (k.startsWith('W.')) W[k.slice(2)] = +v; else if (k.startsWith('D.')) DECK[k.slice(2)] = +v; else if (k.includes('.')) { const [c, f] = k.split('.'); CARDS[c][f] = +v; } else N[k] = +v; }
const names = arg.pilots.split(','), nm = (id) => CARDS[id].n, who = ['A', 'B'];
const aname = (x) => !x.id ? 'takes it' : x.trade ? 'trades with a ' + nm(x.id) : x.with ? 'slips and counters with a ' + nm(x.with) : nm(x.id).toLowerCase() + 's';
const say = (e) => ({ rest: `${who[e.k]} takes a breath`, feint: `${who[e.k]} feints`, clinch: `${who[e.k]} ties him up before the ${e.id && nm(e.id)} lands`, warned: `the referee takes a point from ${who[e.k]} for holding`,
  slipped: `${who[e.k]} slips the ${e.id && nm(e.id)}`, counter: `${who[e.k]} counters`, traded: `${who[e.k]} fires back`, short: `${who[e.k]}'s ${e.id && nm(e.id)} falls short`, wasted: `${who[e.k]}'s ${e.id && nm(e.id)} is wasted`,
  body: `${who[e.k]}'s ${e.id && nm(e.id)} lands to the body`, clean: `${who[e.k]}'s ${e.id && nm(e.id)} lands clean`, blocked: `${who[e.k]}'s ${e.id && nm(e.id)} is blocked`,
  knockdown: `${who[e.k]} IS DOWN`, count: `${who[e.k]} loses his lead to the count`, kept: `${who[e.k]} keeps ${e.n} card${e.n > 1 ? 's' : ''} unthrown` }[e.t]);
if (arg.walk) {
  const b = bout(names.map((x) => PILOTS[x]()), arg.seed, { first: arg.seed % 2,
    onEx(S, a, v, ev, before, asked) {
      if (!v) { console.log(`  R${S.round} ${say(ev[0])}`); return; }
      const st = (k) => `${who[k]} wind ${before[k].wind}/${before[k].cap} head ${before[k].daze} [${before[k].hand.map(nm).join(', ')}]`;
      console.log(`  R${S.round} ${st(0)} | ${st(1)}`);
      console.log(`     ${who[a]} lays ${v.length ? v.length + ' face down: ' + v.map(nm).join(', ') : 'nothing'}` + (asked.length ? `   ${who[1 - a]}: ` + asked.map((q) => (q.view.shown ? nm(q.view.shown) : 'hidden punch') + ' -> ' + aname(q.ans || {})).join('; ') : ''));
      console.log('     ' + ev.map(say).join('; ') + `   round points ${S.f[0].pts}-${S.f[1].pts}`);
    },
    onBell(S, sc) { console.log(`  BELL round ${S.cards.length}: ${sc[0]}-${sc[1]}   wind bars ${S.f[0].cap}/${S.f[1].cap}, heads ${S.f[0].daze}/${S.f[1].daze}\n`); } });
  console.log(`RESULT: ${b.win < 0 ? 'a draw' : who[b.win] + ' wins'} by ${b.how}${b.t ? ' ' + b.t.join('-') : ''}`); process.exit(0);
}
const r = { first: 0, seat0: 0, draws: 0, how: {}, laid: {}, ans: {}, asks: 0, dec: [0, 0], kds: 0, kdBouts: 0, combo: 0, comboBouts: 0, ex: 0, empty: 0, size: [0, 0, 0, 0], capEnd: 0, heldIn: {}, usedIn: {}, kept: 0, open: {}, pen: 0, real: 0 };
const ids = Object.keys(CARDS);
for (let i = 0; i < arg.n; i++) {
  const first = i % 2, held = {}, used = {}; let kd = 0, combo = 0;
  const b = bout(names.map((x) => PILOTS[x]()), 77000001 + 7919 * i + arg.seed, { first,
    onEx(S, a, v, ev, before, asked) {
      if (!v) return; r.ex++; if (!v.length) r.empty++; r.size[v.length]++; r.dec[a]++;
      for (const k of [0, 1]) for (const id of before[k].hand) held[id] = 1;
      let landed = 0;
      for (const e of ev) { if ((e.t === 'clean' || e.t === 'body') && e.k === a) landed++; if (e.t === 'knockdown') kd++; if (e.t === 'kept') r.kept += e.n; if (e.t === 'warned') r.pen++; }
      for (const q of asked) { r.asks++; if (q.view.legal.length > 1) { r.dec[1 - a]++; r.real++; } const x = q.ans || {}; const key = !x.id ? 'takes it' : x.trade ? 'trade' : x.with ? 'slip and counter' : x.id; r.ans[key] = (r.ans[key] || 0) + 1;
        if (x.id) used[x.trade ? 'trade' : x.id] = 1; if (x.with) used.counter = 1; }
      const turned = v.length - (ev.find((e) => e.t === 'kept')?.n || 0); for (const id of v.slice(0, turned)) { r.laid[id] = (r.laid[id] || 0) + 1; used[id] = 1; }
      if (v.length) { const o = CARDS[v[0]].k === 'feint' ? 'a feint' : v[0] === 'jab' ? 'a jab' : CARDS[v[0]].zone === 'body' ? 'a body hook' : 'a power punch'; r.open[o] = (r.open[o] || 0) + 1; }
      if (landed >= 2) combo++;
    } });
  for (const id of ids) { if (held[id]) r.heldIn[id] = (r.heldIn[id] || 0) + 1; if (used[id]) r.usedIn[id] = (r.usedIn[id] || 0) + 1; }
  for (const k of ['trade', 'counter']) if (used[k]) r.usedIn[k] = (r.usedIn[k] || 0) + 1;
  r.first += b.win === first ? 1 : b.win < 0 ? 0.5 : 0; r.seat0 += b.win === 0 ? 1 : b.win < 0 ? 0.5 : 0; r.draws += b.win < 0;
  r.how[b.how] = (r.how[b.how] || 0) + 1; r.kds += kd; r.kdBouts += kd > 0; r.combo += combo; r.comboBouts += combo > 0; r.capEnd += b.S.f[0].cap + b.S.f[1].cap;
}
const n = arg.n, pc = (x, of) => (100 * x / of).toFixed(1) + '%';
const cards = (r.how.decision || 0) + (r.how['decision on punches'] || 0) + (r.how.draw || 0);
const never = ids.filter((id) => (r.usedIn[id] || 0) / (r.heldIn[id] || 1) < 0.02);
const perMan = (r.dec[0] + r.dec[1]) / n / 2;
const bars = [
  ['goes to the cards 40-70% (the S549 bar)', cards / n, 0.40, 0.70, 1],
  ['the man who leads first wins 45-55%', r.first / n, 0.45, 0.55, 1],
  ['a combination (2+ punches of one volley land) in most bouts', r.comboBouts / n, 0.5, 1, 1],
  ['decisions a bout, one man, 22-45', perMan, 22, 45, 0],
  ['empty leads under 10%', r.empty / r.ex, 0, 0.0999, 1],
  ['cards used in under 2% of the bouts they were held: none', never.length, 0, 0, 0],
];
console.log(`boxer v boxer, version 2, ${n} bouts, ${names.join(' v ')}`);
console.log('how', JSON.stringify(r.how), '| seat 0 wins', pc(r.seat0, n), '| knockdowns a bout', (r.kds / n).toFixed(2), 'in', pc(r.kdBouts, n), 'of bouts | wind bar left', (r.capEnd / n / 2).toFixed(2), '| points for holding', r.pen);
console.log('volley sizes 0/1/2/3', r.size.map((x) => pc(x, r.ex)).join(' '), '| combinations a bout', (r.combo / n).toFixed(2), '| cards kept unthrown a bout', (r.kept / n).toFixed(2));
console.log('turned a bout', JSON.stringify(Object.fromEntries(Object.entries(r.laid).sort((a, b) => b[1] - a[1]).map(([k, v]) => [nm(k), +(v / n).toFixed(2)]))));
console.log('at a punch he', JSON.stringify(Object.fromEntries(Object.entries(r.ans).sort((a, b) => b[1] - a[1]).map(([k, v]) => [k, pc(v, r.asks)]))), '| punches where he had a choice', pc(r.real, r.asks));
console.log('a volley opens with', JSON.stringify(Object.fromEntries(Object.entries(r.open).map(([k, v]) => [k, pc(v, r.ex - r.empty)]))));
console.log('used in, of the bouts held', JSON.stringify(Object.fromEntries(ids.map((id) => [nm(id), pc(r.usedIn[id] || 0, r.heldIn[id] || 1)]))), '| trade', pc(r.usedIn.trade || 0, n), '| slip and counter', pc(r.usedIn.counter || 0, n));
let pass = 0; for (const [what, v, lo, hi, isPc] of bars) { const ok = v >= lo && v <= hi; pass += ok; console.log(ok ? 'PASS' : 'FAIL', what, '->', isPc ? pc(v, 1) : (+v).toFixed(1), what.startsWith('cards used') && never.length ? never.map(nm).join(', ') : ''); }
console.log(`BARS ${pass} of ${bars.length}`);
