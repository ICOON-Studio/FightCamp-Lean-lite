// BOXCARDS1 probe: bot bouts of boxer v boxer against the bars of CARDBOX_SCOPE_S549 phase 3.
// node probe.mjs [n=400] [walk=1 seed=..] [pilots=reader,reader] [name=value ...] [W.name=value ...]
import { N, CARDS, DECK, bout } from './rules.mjs';
import { reader, slugger, W } from './bot.mjs';
const arg = { n: 400, walk: 0, seed: 0, pilots: 'reader,reader', quiet: 0 };
for (const kv of process.argv.slice(2)) { const [k, v] = kv.split('='); if (k in arg) arg[k] = isNaN(+v) ? v : +v; else if (k.startsWith('W.')) W[k.slice(2)] = +v; else if (k.startsWith('D.')) DECK[k.slice(2)] = +v; else if (k.includes('.')) { const [c, f] = k.split('.'); CARDS[c][f] = +v; } else N[k] = isNaN(+v) ? v : +v; }
const mk = { reader, slugger }, names = arg.pilots.split(',');
const nm = (id) => CARDS[id].n, who = ['A', 'B'];
const say = (e) => ({ rest: `${who[e.k]} takes a breath`, feint: `${who[e.k]} feints`, drawn: `${who[e.k]} bites on the feint: his ${e.id && nm(e.id)} hits air`,
  clinch: `${who[e.k]} ties him up, the referee breaks them`, countered: `${who[e.k]} fired back as it landed`, slipped: `${who[e.k]} slips the ${e.id && nm(e.id)}`,
  short: `${who[e.k]}'s ${e.id && nm(e.id)} falls short`, body: `${who[e.k]}'s ${e.id && nm(e.id)} lands to the body`, clean: `${who[e.k]}'s ${e.id && nm(e.id)} lands clean (${e.dz})`,
  blocked: `${who[e.k]}'s ${e.id && nm(e.id)} is blocked (${e.dz} gets through)`, knockdown: `${who[e.k]} IS DOWN`, count: `${who[e.k]} is still shaking it off: no lead` }[e.t]);

if (arg.walk) {
  const b = bout([mk[names[0]](), mk[names[1]]()], arg.seed, { first: arg.seed % 2,
    onEx(S, a, v, ans, ev, before) {
      if (!v) { console.log(`  R${S.round} ${say(ev[0])}`); return; }
      const st = (k) => `${who[k]} wind ${before[k].wind}/${before[k].cap} daze ${before[k].daze} [${before[k].hand.map(nm).join(', ')}]`;
      console.log(`  R${S.round} ${st(0)} | ${st(1)}`);
      console.log(`     ${who[a]} leads: ${v.length ? v.map(nm).join(' - ') : 'nothing'}   ${who[1 - a]} answers: ${ans.id ? (ans.counter ? 'counter ' : '') + nm(ans.id) + (ans.at != null ? ' (the ' + nm(v[ans.at]) + ')' : '') : 'no answer'}`);
      console.log('     ' + ev.map(say).join('; ') + `   round points ${S.f[0].pts}-${S.f[1].pts}`);
    },
    onBell(S, sc) { console.log(`  BELL round ${S.cards.length}: ${sc[0]}-${sc[1]}   wind caps ${S.f[0].cap}/${S.f[1].cap}, daze ${S.f[0].daze}/${S.f[1].daze}\n`); } });
  console.log(`RESULT: ${b.win < 0 ? 'a draw' : who[b.win] + ' wins'} by ${b.how}${b.t ? ' ' + b.t.join('-') : ''}`);
  process.exit(0);
}
const r = { first: 0, seat0: 0, draws: 0, how: {}, laid: {}, legalIn: {}, laidIn: {}, ans: {}, dec: 0, kds: 0, kdBouts: 0, combo: 0, comboBouts: 0, ex: 0, empty: 0, size: [0, 0, 0, 0], wide: 0, wideRounds: 0, rounds: 0, capEnd: 0, bodyKO: 0, open: {}, corner: {}, plan: {} };
const ids = Object.keys(CARDS);
for (let i = 0; i < arg.n; i++) {
  const first = i % 2, seen = {}, used = {}; let kd = 0, combo = 0, plans = null;
  const b = bout([mk[names[0]](), mk[names[1]]()], 77000001 + 7919 * i + arg.seed, { first,
    onEx(S, a, v, ans, ev, before, legal) {
      if (!v) return; r.ex++; r.dec += v.length || legal.length > 1 ? 2 : 1; if (!v.length) r.empty++; r.size[v.length]++;
      for (const k of [0, 1]) for (const id of before[k].hand) seen[id] = 1;
      for (const id of v) { r.laid[id] = (r.laid[id] || 0) + 1; used[id] = 1; }
      if (v.length) { const key = ans.id ? (ans.counter ? 'counter' : ans.id) : 'none'; r.ans[key] = (r.ans[key] || 0) + 1; if (ans.id) used[ans.counter ? 'counter' : ans.id] = 1; }
      if (v.length) { const o = CARDS[v[0]].k === 'feint' ? 'a feint' : v[0] === 'jab' ? 'a jab' : CARDS[v[0]].zone === 'body' ? 'a body hook' : 'a power punch'; r.open[o] = r.open[o] || { n: 0, pts: 0, hurt: 0 }; r.open[o].n++; r.open[o].pts += S.f[a].pts - before[a].pts; r.open[o].hurt += S.f[a].daze - before[a].daze; }
      let landed = 0; for (const e of ev) { if ((e.t === 'clean' || e.t === 'body') && e.k === a) landed++; if (e.t === 'knockdown') kd++; }
      if (landed >= 2) combo++;
    },
    onBell(S, sc, picks) { r.rounds++; if (Math.abs(sc[0] - sc[1]) >= 2) r.wideRounds++; for (const pk of picks || []) if (pk.id) r.corner[pk.id] = (r.corner[pk.id] || 0) + 1;
      if (plans) for (const k of [0, 1]) if (plans[k].id) { const key = plans[k].id + ' v ' + plans[1 - k].id; r.plan[key] = r.plan[key] || [0, 0]; r.plan[key][0]++; r.plan[key][1] += sc[k] > sc[1 - k] ? 1 : sc[k] === sc[1 - k] ? 0.5 : 0; }
      plans = picks && picks.length ? picks : null; } });
  for (const id of ids) { if (seen[id]) r.legalIn[id] = (r.legalIn[id] || 0) + 1; if (used[id]) r.laidIn[id] = (r.laidIn[id] || 0) + 1; }
  if (used.counter) r.laidIn.counter = (r.laidIn.counter || 0) + 1;
  r.first += b.win === first ? 1 : b.win < 0 ? 0.5 : 0; r.seat0 += b.win === 0 ? 1 : b.win < 0 ? 0.5 : 0; r.draws += b.win < 0;
  r.how[b.how] = (r.how[b.how] || 0) + 1; r.kds += kd; r.kdBouts += kd > 0; r.combo += combo; r.comboBouts += combo > 0;
  r.capEnd += b.S.f[0].cap + b.S.f[1].cap;
}
const n = arg.n, pc = (x, of) => (100 * x / of).toFixed(1) + '%';
const cards = (r.how.decision || 0) + (r.how['decision on punches'] || 0) + (r.how.draw || 0);
const never = ids.filter((id) => (r.laidIn[id] || 0) / (r.legalIn[id] || 1) < 0.02);
const bars = [
  ['goes to the cards 40-70%', cards / n, 0.40, 0.70],
  ['the man who leads first wins 45-55%', r.first / n, 0.45, 0.55],
  ['a combination (2+ punches of one volley land) in most bouts', r.comboBouts / n, 0.5, 1],
  ['decisions a bout 22-45', r.dec / n, 22, 45],
  ['empty leads under 10%', r.empty / r.ex, 0, 0.10],
  ['every card laid in 2%+ of the bouts it was held', never.length, 0, 0],
];
console.log(`boxer v boxer, ${n} bouts, ${names.join(' v ')}`);
console.log('how', JSON.stringify(r.how), '| draws', r.draws, '| seat 0 wins', pc(r.seat0, n), '| knockdowns a bout', (r.kds / n).toFixed(2), 'in', pc(r.kdBouts, n), 'of bouts | wind cap left, a man', (r.capEnd / n / 2).toFixed(2));
console.log('volley sizes 0/1/2/3', r.size.map((x) => pc(x, r.ex)).join(' '), '| combinations a bout', (r.combo / n).toFixed(2));
console.log('laid a bout', JSON.stringify(Object.fromEntries(Object.entries(r.laid).sort((a, b) => b[1] - a[1]).map(([k, v]) => [nm(k), +(v / n).toFixed(2)]))));
console.log('answers', JSON.stringify(Object.fromEntries(Object.entries(r.ans).sort((a, b) => b[1] - a[1]).map(([k, v]) => [k, pc(v, r.ex - r.empty)]))));
console.log('bouts a card was used in, of the bouts it was held', JSON.stringify(Object.fromEntries(ids.map((id) => [nm(id), pc(r.laidIn[id] || 0, r.legalIn[id] || 1)]))), '| counter', pc(r.laidIn.counter || 0, n));
console.log('a volley opens with (share, points it scored, daze it cost the leader)', JSON.stringify(Object.fromEntries(Object.entries(r.open).map(([k, v]) => [k, [pc(v.n, r.ex - r.empty), +(v.pts / v.n).toFixed(2), +(v.hurt / v.n).toFixed(2)]]))));
if (N.corner) console.log('the corner picks', JSON.stringify(r.corner));
if (N.corner === 2) console.log('a plan against a plan: rounds, share of them won', JSON.stringify(Object.fromEntries(Object.entries(r.plan).sort().map(([k, v]) => [k, [v[0], pc(v[1], v[0])]]))));
let pass = 0; for (const [what, v, lo, hi] of bars) { const ok = v >= lo && v <= hi; pass += ok; console.log(ok ? 'PASS' : 'FAIL', what, '->', v <= 1 && hi <= 1 && what.includes('%') ? pc(v, 1) : (+v).toFixed(1), never.length && what.startsWith('every') ? never.map(nm).join(', ') : ''); }
console.log(`BARS ${pass} of ${bars.length}`);
