// JABLAND2 counting copy of balance.mjs: identical solver/bouts, with event-only counts.
// RING SWITCHES - THE BALANCE INSTRUMENT (S555, the owner: "vs the jabber you win very easy , all your rear hands land
// easy , need better balance , i want this slice to be perfectly balance to move on (always have in scope other arts
// that will be added and knees and elbows)").
// A beat is a guessing game: both men choose a plan at once, so there is no best plan, only a best MIX of plans - the
// one neither man can improve on. The page's own solveBeat finds it (order.html, read through rules.mjs). This tool
//   table : looks the whole round ahead, last beat first (what is stamina worth with 4 beats left? a step in?), and
//           writes vtable.json, which the page's opponents and every probe then use;
//   mix   : prints the mix at each range - a switch that is never in it is DEAD (no reason to click it), one that is in
//           nearly every plan is a MUST (no decision); "exploit" near 0 = the mix is solved.
// It reads ACT / FEET / COVER from the page, so a knee, an elbow or another art's moves are measured the day they are
// in the page's tables. A change is tried WITHOUT touching the page: tweak=<file.json> { "OPPS": [{..}, ..], "N": {..}, "ACT": { "<id>":
// {..} }, "W": {..}, "src": [["text on the page", "its replacement"], ..] }.
//   node proto/twohands/tools/balance.mjs table [tweak=<f>] [out=<vtable.json>] [iters=500] [jobs=6]
//   node proto/twohands/tools/balance.mjs mix   [tweak=<f>] [table=<vtable.json>] [t=6] [st=8] [iters=2000]
//   node proto/twohands/tools/balance.mjs play  [who=mix,sensible,random] [opp=mirror,0,1,2] [n=56] [tweak=<f>] [table=<f>] [seed=1]
//     whole bouts, counted: wins, how each punch fares, how often each switch is used, where the bout is fought
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';
import { Worker, isMainThread, parentPort, workerData } from 'node:worker_threads';
import { load } from './rules.mjs';

const here = path.dirname(fileURLToPath(import.meta.url));
export const TABLE = path.join(here, '..', 'vtable.json');

// the page's rules with a change tried on them; table: a vtable path, null = none, undefined = the page's own
export function loadTweaked(seed = 1, tweak = null, table = undefined) { const tw = tweak || {};
  const R = load(seed, tw.page || 'order.html', tw.src ? (s) => { for (const [a, b] of tw.src) { if (!s.includes(a)) throw new Error('tweak: not on the page: ' + a.slice(0, 60)); s = s.replace(a, b); } return s; } : null, table === undefined);
  if (tw.N) R.setN(tw.N); if (tw.W) Object.assign(R.W, tw.W); for (const id in tw.ACT || {}) R.setAct(id, tw.ACT[id]);
  if (tw.LO) for (const id of tw.LO) R.LO.push({ lead: id, hl: 'high' }); if (tw.RO) for (const id of tw.RO) R.RO.push({ rear: id, hr: 'high' });
  (tw.OPPS || []).forEach((o, i) => Object.assign(R.OPPS[i], o));   // an opponent's skill, lean, read or health tried
  if (table) R.setVT(JSON.parse(fs.readFileSync(table, 'utf8')).VT);
  return R; }
export const readTweak = (f) => (f ? JSON.parse(fs.readFileSync(f, 'utf8')) : null);

export function stateOf(R, o = {}) { const S = { range: o.range ?? 3, f: [R.man(R.N.hp), R.man(R.N.hp)] }, st = o.st ?? [R.N.st, R.N.st];
  for (const k of [0, 1]) Object.assign(S.f[k], { st: st[k] }, o.f ? o.f[k] : {});
  return S; }

// how often each switch is in a mix
export function usage(R, plans, p) { const u = {}, add = (k, x) => { u[k] = (u[k] || 0) + x; };
  plans.forEach((c, i) => { const x = p[i]; if (x < 1e-9) return; if (c.clinch) return add('clinch', x);
    add(c.lead || 'lead held ' + c.hl, x); add(c.rear || 'rear held ' + c.hr, x); add(c.feet === 'hold' ? 'feet hold' : c.feet === 'in' ? 'step in' : c.feet === 'back' ? 'back off' : c.feet, x);
    add('punches:' + ((c.lead && R.ACT[c.lead].d ? 1 : 0) + (c.rear ? 1 : 0)), x);
    if (c.ord.length > 1) { add('ordered', x); add('first:' + c.ord[0], x); } });
  return u; }
export const SWITCHES = (R) => [...Object.keys(R.ACT), ...(R.FEET && R.FEET.check ? ['check'] : []), 'clinch', 'step in', 'back off', 'feet hold', 'lead held high', 'lead held low', 'rear held high', 'rear held low'];
export const nameOf = (R, a) => (R.ACT[a] ? R.ACT[a].n : R.FEET && R.FEET[a] ? R.FEET[a].n : a);

// ---- the round looked ahead: V[t][range - 1][a][b][ra * 3 + rb], t = beats left, a / b stamina, ra / rb ground given (0-2).
// Equal men, so the value with the two men swapped is the same with its sign turned.
if (!isMainThread && workerData && workerData.balanceTable) { const { tweak, VT, t, jobs, iters } = workerData, R = loadTweaked(1, tweak, null); R.setVT(VT);
  parentPort.postMessage(jobs.map(([r, a, b, ra, rb]) => [r, a, b, ra, rb, R.solveBeat(stateOf(R, { range: r, st: [a, b], f: [{ ropes: ra }, { ropes: rb }] }), t, { iters }).v])); }

export async function buildTable(tweak, o = {}) { const R = loadTweaked(1, tweak, null), n = R.N.st, VT = [null], jobsN = o.jobs || 6, iters = o.iters || 500, self = fileURLToPath(import.meta.url);
  for (let t = 1; t <= R.N.beats; t++) { const todo = []; for (let r = 1; r <= 3; r++) for (let a = 0; a <= n; a++) for (let b = 0; b <= a; b++) for (let ra = 0; ra < 3; ra++) for (let rb = 0; rb < 3; rb++) if (a > b || ra <= rb) todo.push([r, a, b, ra, rb]);
    todo.sort((x, y) => (y[1] + y[2]) - (x[1] + x[2])); const parts = Array.from({ length: jobsN }, () => []); todo.forEach((j, i) => parts[i % jobsN].push(j));   // the big states dealt round
    const got = await Promise.all(parts.map((jobs) => new Promise((ok, bad) => { const w = new Worker(self, { workerData: { balanceTable: 1, tweak, VT, t, jobs, iters } }); w.once('message', ok); w.once('error', bad); })));
    const L = Array.from({ length: 3 }, () => Array.from({ length: n + 1 }, () => Array.from({ length: n + 1 }, () => new Array(9).fill(0))));
    for (const part of got) for (const [r, a, b, ra, rb, v] of part) { const same = a === b && ra === rb; L[r - 1][a][b][ra * 3 + rb] = same ? 0 : +v.toFixed(3); if (!same) L[r - 1][b][a][rb * 3 + ra] = +(-v).toFixed(3); }
    VT.push(L); if (o.log) o.log(`beats left ${t}: at Long, full stamina v 4: ${L[2][n][4][0]}; having given ground twice v none: ${L[2][n][n][6]}; Mid ${L[1][n][4][0]}; Inside ${L[0][n][4][0]}`); }
  return VT; }

// ---- whole bouts. who = the man in your corner: 'mix' (plays each beat's solved mix; against 'mirror' both do),
// 'sensible' (answers the other man's last beat: every plan, every order), 'random'. opp = 0 / 1 / 2 (the page's
// opponents, as the page plays them) or 'mirror' (the same man, no style). Returns counts for the report.
function bouts(R, who, opp, n) { const { N, ACT, plan0, man, cost, resolve, endBeat } = R, rnd = R.rnd, mirror = opp === 'mirror';
  if (mirror) { if (!R.OPPS[3]) R.OPPS.push({ n: 'mirror', hp: N.hp, read: 0, like: [], lean: 0 }); R.setOpp(3); } else R.setOpp(opp);
  const o = { n, w: 0, draw: 0, ko: 0, lost: 0, beats: 0, clinch: 0, rng: [0, 0, 0, 0], use: [{}, {}], pun: [{}, {}], np: [[0, 0, 0], [0, 0, 0]], dmg: [0, 0], first: {}, ordered: 0, kd: [0, 0], lvl: [0, 0, 0] };   // lvl: rounds scored, level on points, of those given to the man who backed off less (N.even, S556)
  // A pair is an actually resolved punch event in the immediately following moment of
  // an emitted feint, not a planned shot cancelled by a clinch, knockdown or stun.
  // Count landed punches in the feint moment separately from the tweak's wasted feints.
  o.feintPair = {}; o.feintCaught = {}; o.feintWasted = {};
  const countFeints = (ev) => {
    for (const f of ev.filter(e => e.t === 'flat' && e.a === 'feints')) {
      for (const e of ev) {
        if (e.k === f.k && e.m === f.m + 1 && e.id && ['hit', 'block', 'miss'].includes(e.t)) {
          const q = o.feintPair[e.id] ||= { thrown: 0, landed: 0 };
          q.thrown++; if (e.t === 'hit') q.landed++;
        }
        if (e.k === 1 - f.k && e.m === f.m && e.t === 'hit' && e.id) {
          o.feintCaught[e.id] = (o.feintCaught[e.id] || 0) + 1;
          if ((e.o || '').includes('it caught him in his feint: the feint is wasted'))
            o.feintWasted[e.id] = (o.feintWasted[e.id] || 0) + 1;
        }
      }
    }
  };
  const sensible = (S) => { const me = S.f[0], he = S.f[1], g0 = he.last || plan0(), guess = cost(g0) <= he.st ? g0 : { ...plan0(), hl: g0.hl, hr: g0.hr }; let best = plan0(), bv = -1e9;
    for (const c of R.plansFor(S, 0)) { if (c.clinch) continue; const T = { range: S.range, f: S.f.map((m) => ({ ...m, hist: [] })) }; resolve(T, [{ ...c }, { ...guess, clinch: false }]);
      const v = (he.hp - T.f[1].hp) - (me.hp - T.f[0].hp) + 0.25 * T.f[0].st + rnd() * 0.5; if (v > bv) { bv = v; best = c; } }
    return best; };
  const note = (k, c) => { const u = o.use[k], add = (x) => { u[x] = (u[x] || 0) + 1; }; if (c.clinch) return add('clinch'); add(c.lead || 'lead held ' + c.hl); add(c.rear || 'rear held ' + c.hr); add(c.feet === 'hold' ? 'feet hold' : c.feet === 'in' ? 'step in' : c.feet === 'back' ? 'back off' : c.feet);   // S559: a kick or a check counted as itself
    o.np[k][(c.lead && ACT[c.lead].d ? 1 : 0) + (c.rear ? 1 : 0)]++; if (k === 0 && c.ord && c.ord.length > 1) { o.ordered++; o.first[c.ord[0]] = (o.first[c.ord[0]] || 0) + 1; } };
  for (let b = 0; b < n; b++) { const S = { f: [man(N.hp), man(R.opp().hp)], range: 3 }; let done = false; const t = [0, 0];
    for (let r = 0; r < N.rounds && !done; r++) { S.range = 3; for (const m of S.f) { m.pts = 0; m.st = m.cap; m.g = N.guard; m.ropes = 0; m.held = 0; m.kept = 0; m.gave = 0; }
      for (let i = 0; i < N.beats && !done; i++) { S.t = N.beats - i; let mine, his;
        if (who === 'mix') { const z = R.solveBeat(S, S.t, { iters: 400 }); mine = z.A[drawAt(z.p, rnd)]; his = mirror ? z.B[drawAt(z.q, rnd)] : null; }
        else if (who === 'random') { const A = R.plansFor(S, 0); mine = A[Math.floor(rnd() * A.length)]; } else mine = sensible(S);
        if (!his) his = R.ai(S);
        note(0, mine); note(1, his); const hp = [S.f[0].hp, S.f[1].hp], ev = resolve(S, [{ ...mine }, { ...his }]); endBeat(S); o.beats++; o.rng[S.range]++; o.dmg[0] += hp[1] - S.f[1].hp; o.dmg[1] += hp[0] - S.f[0].hp;
        countFeints(ev);
        for (const e of ev) { if (e.t === 'clinch') o.clinch++; if (e.id && (e.t === 'hit' || e.t === 'block' || e.t === 'miss')) { const q = o.pun[e.k][e.id] = o.pun[e.k][e.id] || { hit: 0, block: 0, miss: 0 }; q[e.t]++; } }
        for (const k of [0, 1]) if (S.f[k].hp <= 0) { S.f[k].kd++; o.kd[k]++; S.f[1 - k].pts += 3; if (S.f[k].kd > N.kd.length) { if (k === 1) { o.w++; o.ko++; } else o.lost++; done = true; break; } S.f[k].hp = N.kd[S.f[k].kd - 1]; } }
      if (!done) { const [x, y] = S.f, lvl = x.pts === y.pts, g = lvl && N.even ? Math.sign((y.gave || 0) - (x.gave || 0)) : 0;   // g > 0: he backed off more, the level round is yours (a tweak counts gave on the page's back off)
        o.lvl[0]++; if (lvl) o.lvl[1]++; if (g) o.lvl[2]++; t[0] += x.pts > y.pts || (lvl && g >= 0) ? 10 : 9; t[1] += y.pts > x.pts || (lvl && g <= 0) ? 10 : 9; } }
    if (!done) { if (t[0] > t[1]) o.w++; else if (t[0] === t[1]) o.draw++; } }
  return o; }
const drawAt = (mix, rnd) => { let x = rnd(), i = 0; while (i < mix.length - 1 && (x -= mix[i]) > 0) i++; return i; };
const merge = (a, b) => { if (!a) return b; for (const k in b) { if (typeof b[k] === 'number') a[k] = (a[k] || 0) + b[k]; else if (Array.isArray(b[k]) && typeof b[k][0] === 'number') b[k].forEach((x, i) => { a[k][i] += x; }); else if (Array.isArray(b[k])) b[k].forEach((x, i) => { a[k][i] = merge(a[k][i], x); }); else a[k] = merge(a[k] || {}, b[k]); } return a; };
if (!isMainThread && workerData && workerData.balancePlay) { const { tweak, table, who, opp, n, seed } = workerData; parentPort.postMessage(bouts(loadTweaked(seed, tweak, table), who, opp, n)); }
export async function play(who, opp, n, o = {}) { const jobs = o.jobs || 7, self = fileURLToPath(import.meta.url), each = Math.ceil(n / jobs);
  const got = await Promise.all(Array.from({ length: jobs }, (_, i) => new Promise((ok, bad) => { const w = new Worker(self, { workerData: { balancePlay: 1, tweak: o.tweak || null, table: o.table, who, opp, n: each, seed: (o.seed || 1) * 100 + i } }); w.once('message', ok); w.once('error', bad); })));
  return got.reduce(merge, null); }
// the report of one pairing
export function report(R, who, opp, o) { const pc = (x) => (100 * x).toFixed(0) + '%', L = [], name = opp === 'mirror' ? 'the same man (no style)' : R.OPPS[opp].n, tot = (q) => q.hit + q.block + q.miss;
  L.push(`${who} v ${name}: wins ${pc(o.w / o.n)}, draws ${pc(o.draw / o.n)}, stops him ${pc(o.ko / o.n)}, is stopped ${pc(o.lost / o.n)}; knockdowns a bout ${(o.kd[1] / o.n).toFixed(1)} v ${(o.kd[0] / o.n).toFixed(1)}; health taken a bout ${(o.dmg[0] / o.n).toFixed(1)} v ${(o.dmg[1] / o.n).toFixed(1)}; beats at Inside / Mid / Long ${[1, 2, 3].map((r) => pc(o.rng[r] / o.beats)).join(' / ')}; clinches a bout ${(o.clinch / o.n).toFixed(1)}; rounds level on points ${pc(o.lvl[1] / Math.max(1, o.lvl[0]))}${o.lvl[2] ? `, ${pc(o.lvl[2] / Math.max(1, o.lvl[1]))} of them given on ground` : ''}`);
  for (const k of [0, 1]) { const u = o.use[k], np = o.np[k], nb = o.beats;
    L.push(`  ${k ? 'he ' : 'you'} a beat: ` + Object.keys(u).sort((a, b) => u[b] - u[a]).map((a) => `${nameOf(R, a)} ${pc(u[a] / nb)}`).join(', ') + ` | punches in a plan: none ${pc(np[0] / nb)}, one ${pc(np[1] / nb)}, two ${pc(np[2] / nb)}`);
    L.push(`  ${k ? 'his ' : 'your'} punches (thrown a bout: lands / blocked / misses): ` + Object.keys(o.pun[k]).sort((a, b) => tot(o.pun[k][b]) - tot(o.pun[k][a])).map((id) => { const q = o.pun[k][id]; return `${R.ACT[id].n} ${(tot(q) / o.n).toFixed(1)}: ${pc(q.hit / tot(q))} / ${pc(q.block / tot(q))} / ${pc(q.miss / tot(q))}`; }).join(', ')); }
  if (o.ordered) L.push(`  your order, of the beats with one to choose (${pc(o.ordered / o.beats)}): first ` + Object.keys(o.first).map((s) => `${s} ${pc(o.first[s] / o.ordered)}`).join(', '));
  return L.join('\n'); }

// ---- THE BARS (S555). "Perfectly balanced" (the owner) said in numbers, for the bout between two equal men who both
// play the solved mix - what the RULES are worth with nobody making a mistake. Each line: PASS / FAIL, the number, the bar.
export function bars(R, o) { const L = [], pc = (x) => (100 * x).toFixed(0) + '%', nb = o.beats, both = (f) => (f(0) + f(1)) / 2, use = (a) => both((k) => (o.use[k][a] || 0) / nb), tot = (q) => q.hit + q.block + q.miss;
  const bar = (name, ok, val) => L.push(`  ${ok ? 'PASS' : 'FAIL'} ${name}: ${val}`), pun = (id) => { const q = { hit: 0, block: 0, miss: 0 }; for (const k of [0, 1]) for (const x in q) q[x] += (o.pun[k][id] || q)[x] || 0; return q; };
  const rng = [1, 2, 3].map((r) => o.rng[r] / nb); bar('every range is fought at (each 15-55% of beats)', rng.every((x) => x >= 0.15 && x <= 0.55), `Inside ${pc(rng[0])}, Mid ${pc(rng[1])}, Long ${pc(rng[2])}`);
  const acts = [...Object.keys(R.ACT), ...(R.FEET && R.FEET.check ? ['check'] : []), 'clinch', 'step in', 'back off'], top = acts.map((a) => [a, use(a)]).sort((x, y) => y[1] - x[1]);
  bar('no switch is a must (none in over 40% of beats)', top[0][1] <= 0.4, top.slice(0, 3).map(([a, x]) => `${nameOf(R, a)} ${pc(x)}`).join(', '));
  const dead = acts.filter((a) => use(a) < 0.03); bar('no switch is dead (each in at least 3% of beats)', !dead.length, dead.length ? dead.map((a) => `${nameOf(R, a)} ${pc(use(a))}`).join(', ') : 'none under 3%');
  const rates = Object.keys(R.ACT).filter((id) => R.ACT[id].d && tot(pun(id)) / o.n >= 1).map((id) => { const q = pun(id); return [id, q.hit / tot(q), q.miss / tot(q)]; });
  const off = rates.filter(([, h, m]) => h < 0.3 || h > 0.65 || m > 0.4); bar('every punch lands 30-65% of the time and falls short at most 40%', !off.length, off.length ? off.map(([id, h, m]) => `${R.ACT[id].n} lands ${pc(h)}, short ${pc(m)}`).join('; ') : rates.map(([id, h]) => `${R.ACT[id].n} ${pc(h)}`).join(', '));
  const stop = (o.ko + o.lost) / o.n, kd = (o.kd[0] + o.kd[1]) / o.n; bar('bouts end both ways (stoppages 10-40%, draws at most 20%, 0.5-2.5 knockdowns a bout)', stop >= 0.1 && stop <= 0.4 && o.draw / o.n <= 0.2 && kd >= 0.5 && kd <= 2.5, `stoppages ${pc(stop)}, draws ${pc(o.draw / o.n)}, knockdowns ${kd.toFixed(1)}`);
  const two = both((k) => o.np[k][2] / nb), none = both((k) => o.np[k][0] / nb); bar('one punch, two punches and holding all have their beats (two 15-45%, none 5-25%)', two >= 0.15 && two <= 0.45 && none >= 0.05 && none <= 0.25, `two ${pc(two)}, none ${pc(none)}`);
  bar('the clinch is a rescue, not a habit (at most 2 a bout)', o.clinch / o.n <= 2, (o.clinch / o.n).toFixed(1));
  const fmax = Math.max(...Object.values(o.first)) / Math.max(o.ordered, 1); bar('the order is a choice (no slot first in over 60% of ordered beats; an order to choose in 40%+ of beats)', fmax <= 0.6 && o.ordered / nb >= 0.4, `ordered ${pc(o.ordered / nb)}, most often first ${pc(fmax)}`);
  bar('the mirror is fair (wins 40-60% of decided bouts)', o.n - o.draw > 0 && Math.abs(o.w / (o.n - o.draw) - 0.5) <= 0.1, pc(o.w / Math.max(o.n - o.draw, 1)));
  return `BARS ${L.filter((l) => / PASS /.test(l)).length} of ${L.length} pass\n` + L.join('\n'); }

const isMain = isMainThread && import.meta.url === pathToFileURL(process.argv[1] || '').href;
if (isMain) { const arg = (k, d) => { const a = process.argv.find((x) => x.startsWith(k + '=')); return a ? a.split('=').slice(1).join('=') : d; }, pc = (x) => (100 * x).toFixed(0) + '%';
  const mode = process.argv[2] || 'mix', tweak = readTweak(arg('tweak', ''));
  if (mode === 'play') { const table = arg('table', ''), R = loadTweaked(1, tweak, table || undefined), n = Number(arg('n', 56)), jobs = Number(arg('jobs', 7)), seed = Number(arg('seed', 1));
    for (const who of arg('who', 'mix').split(',')) for (const op of arg('opp', 'mirror').split(',')) { const opp = op === 'mirror' ? op : Number(op), t0 = Date.now(), o = await play(who, opp, n, { tweak, table: table || undefined, jobs, seed });
      console.log(report(R, who, opp, o) + `\n  (${o.n} bouts, ${((Date.now() - t0) / 1000).toFixed(0)} s)`); if (who === 'mix' && opp === 'mirror') console.log(bars(R, o)); console.log('FEINT_COUNTS ' + JSON.stringify({pair: o.feintPair, caught: o.feintCaught, wasted: o.feintWasted})); if (arg('json', '')) fs.writeFileSync(arg('json', ''), JSON.stringify(o)); } }
  else if (mode === 'table') { const out = arg('out', TABLE), t0 = Date.now(), VT = await buildTable(tweak, { iters: Number(arg('iters', 500)), jobs: Number(arg('jobs', 6)), log: (s) => console.log('BALANCE_TABLE ' + s) });
    const R = loadTweaked(1, tweak, null); fs.writeFileSync(out, JSON.stringify({ made: 'tools/balance.mjs table', N: R.N, W: R.W, VT }));
    console.log(`BALANCE_TABLE wrote ${out} in ${((Date.now() - t0) / 1000).toFixed(0)} s`); }
  else { const table = arg('table', ''), R = loadTweaked(1, tweak, table || (tweak ? null : undefined)), iters = Number(arg('iters', 2000)), t = Number(arg('t', R.N.beats)), st = Number(arg('st', R.N.st)), seen = {};
    console.log(`BALANCE_MIX ${t} beats left, both men on ${st} stamina${R.getVT() ? ', the round looked ahead' : ', NO table (one beat only)'}`);
    for (const range of [3, 2, 1]) { const r = R.solveBeat(stateOf(R, { range, st: [st, st] }), t, { iters }), u = usage(R, r.A, r.p), acts = SWITCHES(R);
      console.log(`\n${R.RNG[range]}: ${r.A.length} plans a man, exploit ${r.exploit.toFixed(2)}`);
      console.log('  in the mix: ' + acts.filter((a) => (u[a] || 0) >= 0.005).sort((a, b) => u[b] - u[a]).map((a) => `${nameOf(R, a)} ${pc(u[a])}`).join(', '));
      console.log('  NEVER: ' + acts.filter((a) => (u[a] || 0) < 0.005).map((a) => nameOf(R, a)).join(', '));
      console.log(`  punches in a plan: none ${pc(u['punches:0'] || 0)}, one ${pc(u['punches:1'] || 0)}, two ${pc(u['punches:2'] || 0)}; an order to choose in ${pc(u.ordered || 0)} (first: ${['feet', 'lead', 'rear'].map((s) => s + ' ' + pc((u['first:' + s] || 0) / Math.max(u.ordered || 0, 1e-9))).join(', ')})`);
      console.log('  top plans: ' + r.A.map((c, i) => [r.p[i], R.planWords(c)]).sort((a, b) => b[0] - a[0]).slice(0, 5).map(([x, w]) => `${pc(x)} ${w}`).join(' | '));
      for (const a of acts) seen[a] = Math.max(seen[a] || 0, u[a] || 0); }
    console.log('\nDEAD AT EVERY RANGE (under 3% of every mix): ' + (Object.keys(seen).filter((a) => seen[a] < 0.03).map((a) => nameOf(R, a)).join(', ') || 'none'));
    console.log('A MUST SOMEWHERE (over 60% of a mix): ' + (Object.keys(seen).filter((a) => seen[a] > 0.6 && !/held|hold/.test(a)).map((a) => `${nameOf(R, a)} ${pc(seen[a])}`).join(', ') || 'none')); } }
