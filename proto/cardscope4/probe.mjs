// CARDSCOPE4 probes. node probe.mjs <what> [per=N] [seed=S] [name=value ...]   what: matrix | p3 | p1 | p2 | p5 | p6 | p4 | p10 | r3 | all
// name=value resizes one number for one run: a key of N (hp=44), a card (cross.dmg=6) or an AI weight (W.pos=2).
import fs from 'node:fs';
import { CARDS, N, STYLES, fighter, CHEAP } from './cards.mjs';
import { bout, clone, startAct, answerOptions } from './engine.mjs';
import { aiPilot, impatient, scripted, W0 } from './plan.mjs';

const args = process.argv.slice(2), what = args[0] || 'matrix', kv = {};
for (const a of args.slice(1)) {
  const [k, v] = a.split('='), num = isNaN(+v) ? v : +v;
  if (k === 'per' || k === 'seed' || k === 'tag') kv[k] = num;
  else if (k.startsWith('W.')) W0[k.slice(2)] = num;
  else if (k.includes('.')) { const [c, f] = k.split('.'); CARDS[c][f] = num; } else N[k] = num;
}
const per = kv.per || 40, seed0 = kv.seed || 300000, out = {}, lines = [];
const say = (s) => { lines.push(s); console.log(s); };
const pct = (x) => (100 * x).toFixed(1);
const PAIRS = []; for (let i = 0; i < 6; i++) for (let j = i + 1; j < 6; j++) PAIRS.push([STYLES[i], STYLES[j]]);
let seedN = 0;
// n bouts of A against B (seat 0 = A); returns shares and averages
function play(A, B, pa, pb, n, opt) {
  const r = { n, win: 0, ko: 0, lead: 0, tap: 0, pin: 0, cards: 0, early: 0, vis3: 0, ground: 0, dec: 0, decs: [], secs: 0, turns: 0, held: 0, quiet: 0, choices: 0, steps: 0, maxCh: 0, holdOn: 0, holdDone: 0, downs: 0, played: {}, wonWith: {}, logs: [] };
  for (let i = 0; i < n; i++) {
    const b = bout(A, B, [pa, pb], seed0 + 7919 * ++seedN + i, opt), st = b.st;
    r.win += b.win === 0; r[b.how]++; r.early += b.early; r.vis3 += [1, 2, 4, 8].filter((x) => st.vis & x).length >= 3; r.ground += !!(st.vis & 8);
    r.dec += st.dec[0]; r.decs.push(st.dec[0]); r.secs += st.secs[0]; r.turns += st.turns[0]; r.held += st.held[0]; r.quiet += st.quiet[0];
    r.choices += st.choices; r.steps += st.steps; r.maxCh = Math.max(r.maxCh, st.maxCh); r.holdOn += st.holdOn; r.holdDone += st.holdDone; r.downs += st.downs;
    for (const id in st.played[0]) { r.played[id] = (r.played[id] || 0) + 1; if (b.win === 0) r.wonWith[id] = (r.wonWith[id] || 0) + 1; }
    if (opt?.keepLogs) r.logs.push(st.log);
  }
  return r;
}
const add = (t, r) => { for (const k in r) if (typeof r[k] === 'number') t[k] = k === 'maxCh' ? Math.max(t[k] || 0, r[k]) : (t[k] || 0) + r[k]; else if (k === 'decs') (t.decs ||= []).push(...r.decs); return t; };
const AI = aiPilot();
// the 6x6 table: pa flies the row style, pb the column style
function table(pa, pb, n, mk = fighter, opt) {
  const cell = {}, tot = {}, avg = {};
  for (const s of STYLES) { cell[s] = {}; }
  for (const [a, b] of PAIRS) {
    const r1 = play(mk(a), mk(b), pa(a), pb(b), n, opt), r2 = play(mk(b), mk(a), pa(b), pb(a), n, opt);
    cell[a][b] = r1.win / n; cell[b][a] = r2.win / n; add(tot, r1); add(tot, r2);
  }
  for (const s of STYLES) avg[s] = STYLES.filter((t) => t !== s).reduce((x, t) => x + cell[s][t], 0) / 5;
  return { cell, avg, tot };
}
// both chairs the same pilot: fold the two seatings into one share for the row style
function fold(T) { const c = {}; for (const a of STYLES) { c[a] = {}; for (const b of STYLES) if (a !== b) c[a][b] = (T.cell[a][b] + 1 - T.cell[b][a]) / 2; } const avg = {}; for (const s of STYLES) avg[s] = STYLES.filter((t) => t !== s).reduce((x, t) => x + c[s][t], 0) / 5; return { cell: c, avg }; }
function show(c, avg) {
  say('you \\ him   ' + STYLES.map((s) => s.slice(0, 6).padStart(7)).join('') + '     avg');
  for (const a of STYLES) say(a.padEnd(11) + STYLES.map((b) => (a === b ? '      -' : pct(c[a][b]).padStart(7))).join('') + pct(avg[a]).padStart(8));
}
function shape(t) {
  const n = t.n, d = t.decs.slice().sort((x, y) => x - y);
  return { ko: t.ko / n, lead: t.lead / n, tap: t.tap / n, pin: t.pin / n, cards: t.cards / n, early: t.early / n, vis3: t.vis3 / n, ground: t.ground / n, dec: t.dec / n, dec95: d[Math.floor(0.95 * (d.length - 1))],
    secTurn: t.secs / t.turns, held: t.held / t.turns, quiet: t.quiet / t.turns, choices: t.choices / t.steps, maxCh: t.maxCh, holdEnds: (t.tap + t.pin) / Math.max(1, t.ground), holdFinish: t.holdDone / Math.max(1, t.holdOn), holdOn: t.holdOn / n };
}
const shapeLine = (s) => `ends: KO ${pct(s.ko)} lead ${pct(s.lead)} tap ${pct(s.tap)} pin ${pct(s.pin)} cards ${pct(s.cards)} | early ${pct(s.early)} | 3+ ranges ${pct(s.vis3)} ground ${pct(s.ground)} | decisions ${s.dec.toFixed(1)} (95%: ${s.dec95}) choices ${s.choices.toFixed(1)} max ${s.maxCh} | s/turn ${s.secTurn.toFixed(1)} | holds back ${pct(s.held)} quiet ${pct(s.quiet)} | holds on ${s.holdOn.toFixed(2)}/bout finish ${pct(s.holdFinish)} end ${pct(s.holdEnds)} of ground bouts`;
const mean = (o) => Object.values(o).reduce((a, b) => a + b, 0) / Object.values(o).length;

const P = {
  matrix() { const T = table(() => AI, () => AI, per), F = fold(T); show(F.cell, F.avg); say(shapeLine(shape(T.tot))); out.matrix = { F, shape: shape(T.tot) }; },
  p3() {
    out.p3 = {};
    for (const mode of ['wind', 'limb', 'both']) {
      N.mode = mode;
      const T = table(() => AI, () => AI, per), s = shape(T.tot), F = fold(T);
      const up = table(() => AI, () => impatient(), per), cheap = {};
      for (const k in CHEAP) cheap[k] = mean(Object.fromEntries(STYLES.map((t) => [t, play(CHEAP[k], fighter(t), impatient(), AI, per).win / per])));
      const cells = PAIRS.map(([a, b]) => F.cell[a][b]);
      out.p3[mode] = { s, aiOverImp: mean(up.avg), cheap, worstCell: Math.max(...cells.map((x) => Math.abs(x - 0.5))) };
      say(`P3 ${mode.padEnd(5)} AI over impatient ${pct(mean(up.avg))} | holds a playable card back ${pct(s.held)} of turns | s/turn ${s.secTurn.toFixed(1)} | cheap deck (impatient): ${Object.entries(cheap).map(([k, v]) => k + ' ' + pct(v)).join(', ')} | worst cell off 50 by ${pct(out.p3[mode].worstCell)}`);
      say('   ' + shapeLine(s));
    }
    N.mode = 'wind';
  },
  p1() { const a = play(fighter('boxing'), fighter('wrestling'), AI, AI, per * 4), b = play(fighter('wrestling'), fighter('boxing'), AI, AI, per * 4), t = add(add({}, a), b), s = shape(t); out.p1 = { boxing: (a.win + b.n - b.win) / (a.n + b.n), s }; say(`P1 boxing v wrestling: boxing wins ${pct(out.p1.boxing)} | ${shapeLine(s)}`); },
  p2() {
    out.p2 = {};
    for (const [arm, pts, hold] of [['a health only', 0, 0], ['b + points lead', 1, 0], ['c + the hold', 1, 1]]) { N.clkPts = pts; N.clkHold = hold; const T = table(() => AI, () => AI, per), s = shape(T.tot); out.p2[arm] = s; say(`P2 ${arm.padEnd(16)} ${shapeLine(s)}`); }
    for (const [name, W] of [['health', { hp: 0, ko: 0 }], ['points', { pts: 0, lead: 0 }], ['the hold', { sub: 0, pin: 0 }]]) { const T = table(() => aiPilot({ ...W0, ...W }), () => AI, per); out.p2['blind ' + name] = mean(T.avg); say(`P2 AI blind to ${name}: ${pct(mean(T.avg))} against the full AI (50 = no loss)`); }
  },
  p5() {
    let heldTurns = 0, same = 0;
    const onAnswer = (S, k, ans, opts) => { if (!(S.hold && S.hold.by !== k) || opts.length < 2) return; heldTurns++; const rule = opts.find((o) => o && o.id === 'escape') || opts.find((o) => o && o.id === '@room') || null; same += (rule && rule.id) === (ans && ans.id); };
    const T = table(() => AI, () => AI, per, fighter, { onAnswer }), s = shape(T.tot);
    out.p5 = { same: same / Math.max(1, heldTurns), heldTurns, s };
    say(`P5 visible race: AI answer = the printed rule in ${pct(out.p5.same)} of ${heldTurns} held turns | a hold ends ${pct(s.holdEnds)} of bouts that reach the ground | ${pct(s.holdFinish)} of holds that go on finish | ${s.holdOn.toFixed(2)} holds a bout`);
    N.holdRoll = Math.max(0.05, Math.min(0.95, s.holdFinish)); const R = table(() => AI, () => AI, per), rs = shape(R.tot), up = table(() => AI, () => impatient(), Math.ceil(per / 2)); N.holdRoll = 0;
    const up0 = table(() => AI, () => impatient(), Math.ceil(per / 2));
    out.p5.roll = { s: rs, aiOverImp: mean(up.avg), aiOverImpRace: mean(up0.avg) };
    say(`P5 hidden roll (p=${pct(s.holdFinish)}): a hold ends ${pct(rs.holdEnds)} of ground bouts | AI over impatient ${pct(mean(up.avg))} (visible race: ${pct(mean(up0.avg))})`);
  },
  p6() {
    out.p6 = { diff: {} };
    const off = aiPilot();
    for (const s of STYLES) {
      let turns = 0, diff = 0;
      const flip = (S, k, f) => { const c = clone(S); c.f[k].mech = false; if (c.pj) c.pj.f[k].mech = false; return f(c); };
      const onAnswer = (S, k, ans, opts) => { if (k !== 0 || opts.length < 2) return; const o = flip(S, k, (c) => { const oo = answerOptions(c, k); return oo.length > 1 ? off.answer(c, k, oo) : null; }); S._ad = JSON.stringify(o) !== JSON.stringify(ans); };
      const onAct = (S, k, seq) => { if (k !== 0) return; const o = flip(S, k, (c) => { startAct(c); c.pj.f[k].mech = false; return off.act(c, k); }); turns++; if (S._ad || o.join() !== seq.join()) diff++; S._ad = false; };
      for (const t of STYLES) if (t !== s) play(fighter(s), fighter(t), AI, AI, Math.ceil(per / 2), { onAnswer, onAct });
      out.p6.diff[s] = diff / turns; say(`P6 ${s.padEnd(10)} the turn changes with the mechanic off in ${pct(diff / turns)} of ${turns} turns`);
    }
    // the blind judge: profiles from kinds of action and where they happen, no card names
    const feat = (log) => { const f = {}; let n = 0; for (const t of log.slice(0, 10)) { f['at' + t.pos[0]] = (f['at' + t.pos[0]] || 0) + 1; for (const k of t.kinds) { f[k + t.pos[0]] = (f[k + t.pos[0]] || 0) + 1; } f.ans = (f.ans || 0) + t.ans; n++; } for (const k in f) f[k] /= Math.max(1, n); return f; };
    const logs = {}; for (const s of STYLES) { logs[s] = []; for (const t of STYLES) if (t !== s) logs[s].push(...play(fighter(s), fighter(t), AI, AI, per, { keepLogs: 1 }).logs.map((l) => feat(l[0]))); }
    const cen = {}; for (const s of STYLES) { const h = logs[s].slice(0, logs[s].length >> 1), c = {}; for (const f of h) for (const k in f) c[k] = (c[k] || 0) + f[k] / h.length; cen[s] = c; }
    const dist = (f, c) => { let d = 0; for (const k of new Set([...Object.keys(f), ...Object.keys(c)])) d += ((f[k] || 0) - (c[k] || 0)) ** 2; return d; };
    let ok = 0, n = 0; out.p6.judge = {};
    for (const s of STYLES) { let o = 0; const te = logs[s].slice(logs[s].length >> 1); for (const f of te) o += STYLES.reduce((b, t) => (dist(f, cen[t]) < dist(f, cen[b]) ? t : b), s === 'boxing' ? 'karate' : 'boxing') === s; out.p6.judge[s] = o / te.length; ok += o; n += te.length; }
    out.p6.judgeAll = ok / n; say(`P6 blind judge names the style from 10 turns: ${pct(ok / n)} (${STYLES.map((s) => s + ' ' + pct(out.p6.judge[s])).join(', ')})`);
  },
  p4() { const T = table(() => AI, () => AI, per), F = fold(T), s = shape(T.tot); show(F.cell, F.avg); say(shapeLine(s)); const cells = PAIRS.map(([a, b]) => [a, b, F.cell[a][b]]).sort((x, y) => Math.abs(y[2] - 0.5) - Math.abs(x[2] - 0.5)); out.p4 = { F, s, worst: cells.slice(0, 5), outside: cells.filter((c) => Math.abs(c[2] - 0.5) > 0.1).length }; say(`P4 cells outside 40-60: ${out.p4.outside} of 15; worst: ${cells.slice(0, 5).map((c) => `${c[0]} v ${c[1]} ${pct(c[2])}`).join(', ')}`); },
  p10() { const a = table(() => AI, () => AI, per), s = table((st) => scripted(st), () => AI, per), i = table(() => impatient(), () => AI, per); out.p10 = { ai: a.avg, scripted: s.avg, impatient: i.avg }; for (const st of STYLES) say(`P10 ${st.padEnd(10)} AI ${pct(a.avg[st])} | scripted ${pct(s.avg[st])} | impatient ${pct(i.avg[st])}  (each against the AI pilot flying the other five)`); say(`R-C11 the impatient line with a style deck against the AI pilot: ${pct(mean(i.avg))}`); },
  r3() {
    out.r3 = { cheap: {} };
    for (const k in CHEAP) { const imp = mean(Object.fromEntries(STYLES.map((t) => [t, play(CHEAP[k], fighter(t), impatient(), AI, per).win / per]))), ai = mean(Object.fromEntries(STYLES.map((t) => [t, play(CHEAP[k], fighter(t), AI, AI, per).win / per]))); out.r3.cheap[k] = { imp, ai }; say(`R-C8 ${CHEAP[k].name.padEnd(13)} impatient ${pct(imp)} | AI ${pct(ai)}`); }
    // card matchups by lift
    let pass = 0, n = 0; out.r3.cards = {};
    for (const s of STYLES) {
      const ids = [...new Set(fighter(s).deck)].filter((id) => CARDS[id].st !== 'core'), rank = {};
      for (const t of STYLES) if (t !== s) { const r = play(fighter(s), fighter(t), AI, AI, per * 2), base = r.win / r.n; const lift = ids.map((id) => [id, r.played[id] >= 5 ? (r.wonWith[id] || 0) / r.played[id] - base : -9]).sort((x, y) => y[1] - x[1]); lift.forEach(([id], i) => ((rank[id] ||= []).push(i))); }
      for (const id of ids) { const ok = rank[id].some((i) => i < 3) && rank[id].some((i) => i >= ids.length / 2); out.r3.cards[id] = rank[id]; pass += ok; n++; }
    }
    out.r3.cardShare = pass / n; say(`R-B6 cards with a matchup (top three against one style, bottom half against another): ${pass} of ${n} = ${pct(pass / n)}`);
  },
};
const order = what === 'all' ? ['p1', 'p2', 'p5', 'p6', 'p4', 'p10', 'r3'] : [what];
const t0 = Date.now();
for (const w of order) { P[w](); say(`   [${w}: ${((Date.now() - t0) / 1000).toFixed(0)} s, per=${per}, seed=${seed0}, mode=${N.mode}]`); }
if (kv.tag) { fs.mkdirSync(new URL('./out/', import.meta.url), { recursive: true }); fs.writeFileSync(new URL(`./out/${kv.tag}.json`, import.meta.url), JSON.stringify(out, (k, v) => (k === 'decs' || k === 'logs' ? undefined : v), 1)); fs.writeFileSync(new URL(`./out/${kv.tag}.txt`, import.meta.url), lines.join('\n') + '\n'); }
