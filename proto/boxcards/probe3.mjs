// BOXCARDS3 probe. node probe3.mjs [n=100] [walk=1 seed=..] [pilots=reader,reader] [from=1] [name=value] [W.name=value]
// Besides version 2's bars it measures whether THE DEFENCE IS A DECISION (owner S551: the "Take it" button was not one).
import { N, CARDS, bout, lines } from './rules3.mjs';
import { PILOTS, W, clone, lineWorth } from './bot3.mjs';
const arg = { n: 100, walk: 0, seed: 0, from: 1, pilots: 'reader,reader' };
for (const kv of process.argv.slice(2)) { const [k, v] = kv.split('='); if (k in arg) arg[k] = isNaN(+v) ? v : +v; else if (k.startsWith('W.')) W[k.slice(2)] = +v; else if (k in N) N[k] = +v; else throw new Error('unknown ' + k); }
const names = arg.pilots.split(','), nm = (id) => CARDS[id].n, who = ['A', 'B'];
const aname = (x) => !x ? '-' : x.trade ? 'trade ' + nm(x.id) : x.with ? 'Slip+' + nm(x.with) : nm(x.id);
const say = (e) => ({ rest: `${who[e.k]} takes a breath`, feint: `${who[e.k]} feints`, drawn: `${who[e.k]}'s ${e.id && nm(e.id)} is drawn out by it`, clinch: `${who[e.k]} ties him up before the ${e.id && nm(e.id)} lands`,
  warned: `the referee takes a point from ${who[e.k]} for holding`, slipped: `${who[e.k]} slips the ${e.id && nm(e.id)}`, counter: `${who[e.k]} counters`, traded: `${who[e.k]} fires back`, short: `${who[e.k]}'s ${e.id && nm(e.id)} falls short`,
  wasted: `${who[e.k]}'s ${e.id && nm(e.id)} is wasted`, body: `${who[e.k]}'s ${e.id && nm(e.id)} lands to the body`, clean: `${who[e.k]}'s ${e.id && nm(e.id)} lands clean`, blocked: `${who[e.k]}'s ${e.id && nm(e.id)} is blocked`,
  knockdown: `${who[e.k]} IS DOWN`, count: `${who[e.k]} loses his lead to the count`, kept: `${who[e.k]} keeps ${e.n} card${e.n > 1 ? 's' : ''} unthrown` }[e.t]);
if (arg.walk) {
  const b = bout(names.map((x) => PILOTS[x]()), arg.seed, { first: arg.seed % 2,
    onEx(S, a, v, ev, before, asked) {
      if (!v) { console.log(`  R${S.round} ${say(ev[0])}`); return; }
      const st = (k) => `${who[k]} wind ${before[k].wind}/${before[k].cap} head ${before[k].daze} [${before[k].hand.map(nm).join(', ')}]`;
      console.log(`  R${S.round} ${st(0)} | ${st(1)}`);
      console.log(`     ${who[a]} lays ${v.length ? v.map(nm).join(', ') : 'nothing'}` + (asked[0] ? `   ${who[1 - a]} lays against them: ${asked[0].map(aname).join(', ')}` : ''));
      console.log('     ' + ev.map(say).join('; ') + `   round points ${S.f[0].pts}-${S.f[1].pts}`);
    },
    onBell(S, sc) { console.log(`  BELL round ${S.cards.length}: ${sc[0]}-${sc[1]}   wind bars ${S.f[0].cap}/${S.f[1].cap}, heads ${S.f[0].daze}/${S.f[1].daze}\n`); } });
  console.log(`RESULT: ${b.win < 0 ? 'a draw' : who[b.win] + ' wins'} by ${b.how}${b.t ? ' ' + b.t.join('-') : ''}`); process.exit(0);
}
const r = { first: 0, seat0: 0, draws: 0, how: {}, laid: {}, ex: 0, empty: 0, size: [0, 0, 0, 0], combo: 0, comboBouts: 0, kdBouts: 0,
  lays: 0, choice: 0, nothing: 0, nLines: 0, cards: 0, ans: {}, fate: { worked: 0, wasted: 0, drawn: 0, unreached: 0 }, hind: 0, hindGap: 0, place: [0, 0, 0], placeN: [0, 0, 0] };
const t0 = Date.now();
for (let s = arg.from; s < arg.from + arg.n; s++) {
  let combo = 0;
  const b = bout(names.map((x) => PILOTS[x]()), s, { first: s % 2,
    onEx(S, a, v, ev, before, asked) {
      if (!v) return; r.ex++; r.size[v.length]++; if (!v.length) { r.empty++; return; }
      for (const id of v) r.laid[id] = (r.laid[id] || 0) + 1;
      const d = 1 - a, clean = ev.filter((e) => (e.t === 'clean' || e.t === 'body') && e.k === a).length; if (clean >= 2) { r.combo++; combo = 1; }
      // the defence: rebuild the table as it stood, list what he might have laid, and what hindsight says was best
      const T = clone(S); for (const k of [0, 1]) Object.assign(T.f[k], { wind: before[k].wind, cap: before[k].cap, daze: before[k].daze, pts: before[k].pts, ropes: before[k].ropes, held: before[k].held, hand: [...before[k].hand] });
      const line = asked[0] || v.map(() => null), all = lines(T, d, v.length);
      r.lays++; r.nLines += all.length; if (all.length > 1) { r.choice++; if (line.every((x) => !x)) r.nothing++; }
      line.forEach((x, i) => { r.placeN[i]++; if (x) { r.place[i]++; r.cards++; const key = x.trade ? 'trade' : x.with ? 'slip+counter' : x.id; r.ans[key] = (r.ans[key] || 0) + 1; } });
      // the fate of each laid answer, read from the events in order
      let i = 0, turned = 0; const fate = line.map((x) => (x ? 'unreached' : null));
      for (const e of ev) { if (e.t === 'feint') { turned++; i = turned - 1; continue; } if (e.t === 'drawn') { fate[i] = 'drawn'; continue; }
        if (e.t === 'wasted' && e.k === d) { fate[turned] = 'wasted'; continue; }
        if (['clean', 'body', 'blocked', 'slipped', 'short', 'clinch'].includes(e.t) && (e.k === a || e.t === 'slipped' || e.t === 'clinch')) { if (fate[turned] === 'unreached') fate[turned] = 'worked'; turned++; } }
      for (const f of fate) if (f) r.fate[f]++;
      const got = lineWorth(T, d, line, before[a].hand, v); let top = -1e9; for (const l of all) top = Math.max(top, lineWorth(T, d, l, before[a].hand, v));
      if (top - got < 0.01) r.hind++; r.hindGap += top - got;
    } });
  r.comboBouts += combo; if (b.S.f.some((m) => m.kds)) r.kdBouts++;
  if (b.win < 0) r.draws++; else { if (b.win === s % 2) r.first++; if (b.win === 0) r.seat0++; }
  r.how[b.how] = (r.how[b.how] || 0) + 1;
}
const pc = (x, n) => (n ? (100 * x / n).toFixed(0) : '-') + '%', n = arg.n, dec = n - r.draws;
console.log(`BOXCARDS3 ${names.join(' v ')}  bouts ${n}  seeFirst ${N.seeFirst}  (${((Date.now() - t0) / 1000).toFixed(0)} s)`);
console.log(`  first lead wins ${pc(r.first, dec)} | seat A wins ${pc(r.seat0, dec)} | draws ${pc(r.draws, n)} | ${Object.entries(r.how).map(([k, v]) => k + ' ' + pc(v, n)).join(', ')}`);
console.log(`  leads: empty ${pc(r.empty, r.ex)}, sizes 1/2/3 ${[1, 2, 3].map((k) => pc(r.size[k], r.ex)).join(' ')} | a combination (2+ land) in ${pc(r.comboBouts, n)} of bouts | a knockdown in ${pc(r.kdBouts, n)}`);
console.log(`  cards led: ${Object.keys(CARDS).filter((id) => CARDS[id].k !== 'ans').map((id) => nm(id) + ' ' + (r.laid[id] || 0)).join(', ')}`);
console.log(`  THE DEFENCE: laid ${(r.lays / n).toFixed(1)} times a bout, ${(r.nLines / r.lays).toFixed(0)} lines to pick from on average; had a choice ${pc(r.choice, r.lays)}`);
console.log(`    laid NOTHING though he could answer ${pc(r.nothing, r.choice)} (version 2's "Take it" with a choice: 1%) | answers a line ${(r.cards / r.lays).toFixed(2)} | by place 1/2/3: ${[0, 1, 2].map((i) => pc(r.place[i], r.placeN[i])).join(' ')}`);
console.log(`    answers laid: ${Object.entries(r.ans).map(([k, v]) => k + ' ' + v).join(', ')}`);
console.log(`    what became of them: worked ${pc(r.fate.worked, r.cards)}, wasted ${pc(r.fate.wasted, r.cards)}, drawn out by a feint ${pc(r.fate.drawn, r.cards)}, never reached ${pc(r.fate.unreached, r.cards)}`);
console.log(`    hindsight: his line was the best one against what really came ${pc(r.hind, r.lays)} of the time; average gap ${(r.hindGap / r.lays).toFixed(2)} points`);
