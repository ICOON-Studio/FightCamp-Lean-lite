// CARDSCOPE5 probes. node probe.mjs <what> [per=N] [seed=S] [name=value ...]   what: matrix | p3 | p1 | p2 | p5 | p6 | p4 | p10 | r3 | all
// The two gates of plan section 7 (round 7): node probe.mjs gate=play | gate=ship (protocol per=200 seed=500000000).
// name=value resizes one number for one run: a key of N (hp=44), a card (cross.dmg=6) or an AI weight (W.pos=2).
import fs from 'node:fs';
import { CARDS, N, STYLES, fighter, CHEAP, size } from './cards.mjs';
import { bout, clone, startAct, answerOptions } from './engine.mjs';
import { aiPilot, impatient, scripted, W0 } from './plan.mjs';
import { printedProblems } from './ui-text.mjs';
import { simulateLadder, measureTraining } from './career.mjs';

const args = process.argv.slice(2), gateArg = args.find((a) => /^gate=(play|ship)$/.test(a)) || '';
const what = gateArg ? 'gate' : args[0] || 'matrix', kv = {};
for (const a of args.filter((x) => x !== what)) {
  const [k, v] = a.split('='), num = isNaN(+v) ? v : +v;
  if (k === 'per' || k === 'seed' || k === 'tag') kv[k] = num;
  else if (k.startsWith('W.')) W0[k.slice(2)] = num;
  else size(k, num);
}
let per = kv.per || 40, seed0 = kv.seed || 300000; const out = {}, lines = [];
const say = (s) => { lines.push(s); console.log(s); };
const pct = (x) => (100 * x).toFixed(1);
const PAIRS = []; for (let i = 0; i < STYLES.length; i++) for (let j = i + 1; j < STYLES.length; j++) PAIRS.push([STYLES[i], STYLES[j]]);
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
  for (const s of STYLES) avg[s] = STYLES.filter((t) => t !== s).reduce((x, t) => x + cell[s][t], 0) / (STYLES.length - 1);
  return { cell, avg, tot };
}
// both chairs the same pilot: fold the two seatings into one share for the row style
function fold(T) { const c = {}; for (const a of STYLES) { c[a] = {}; for (const b of STYLES) if (a !== b) c[a][b] = (T.cell[a][b] + 1 - T.cell[b][a]) / 2; } const avg = {}; for (const s of STYLES) avg[s] = STYLES.filter((t) => t !== s).reduce((x, t) => x + c[s][t], 0) / (STYLES.length - 1); return { cell: c, avg }; }
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
  p1() { const a = play(fighter('boxing'), fighter('wrestling'), AI, AI, per * 4), b = play(fighter('wrestling'), fighter('boxing'), AI, AI, per * 4), t = add(add({}, a), b), s = shape(t); out.p1 = { boxing: (a.win + b.n - b.win) / (a.n + b.n), s }; say(`P1 unchanged boxing v wrestling: boxing wins ${pct(out.p1.boxing)} | ${shapeLine(s)}`); const x = play(fighter('boxing'), fighter('bjj'), AI, AI, per * 4), y = play(fighter('bjj'), fighter('boxing'), AI, AI, per * 4), z = shape(add(add({}, x), y)); out.p1.sliceSubstitution = { boxing: (x.win + y.n - y.win) / (x.n + y.n), s: z }; say(`P1 slice substitution boxing v BJJ: boxing wins ${pct(out.p1.sliceSubstitution.boxing)} | ${shapeLine(z)} (not literal P1)`); },
  p2() {
    out.p2 = {};
    for (const [arm, pts, hold] of [['a health only', 0, 0], ['b + points lead', 1, 0], ['c + the hold', 1, 1]]) { N.clkPts = pts; N.clkHold = hold; const T = table(() => AI, () => AI, per), s = shape(T.tot); out.p2[arm] = s; say(`P2 ${arm.padEnd(16)} ${shapeLine(s)}`); }
    // a blind pilot flies each art against the full AI flying the other art, both seats, and is compared with the full
    // AI's own share for that art: a clock counts only if losing sight of it costs 5 points (the round-6 bar). In a
    // two-art slice table() would seat the blind pilot in one art only and fold the two seatings into a seat
    // asymmetry, so the loop is written out.
    const F = fold(table(() => AI, () => AI, per));
    for (const [name, W] of [['health', { hp: 0, ko: 0 }], ['points', { pts: 0, lead: 0 }], ['the hold', { sub: 0, pin: 0 }]]) {
      const blind = aiPilot({ ...W0, ...W }, 'blind ' + name), share = {};
      for (const s of STYLES) { let w = 0, n = 0; for (const t of STYLES) if (t !== s) { const r1 = play(fighter(s), fighter(t), blind, AI, per), r2 = play(fighter(t), fighter(s), AI, blind, per); w += r1.win + (r2.n - r2.win); n += r1.n + r2.n; } share[s] = w / n; }
      const loss = Object.fromEntries(STYLES.map((s) => [s, F.avg[s] - share[s]]));
      out.p2['blind ' + name] = { share, loss, meanLoss: mean(loss) };
      say(`P2 AI blind to ${name}: ${STYLES.map((s) => `${s} ${pct(share[s])} (full AI ${pct(F.avg[s])}, loss ${pct(loss[s])})`).join(', ')} | mean loss ${pct(mean(loss))} (5+ = the bar)`);
    }
  },
  p5() {
    let heldTurns = 0, same = 0;
    const onAnswer = (S, k, ans, opts) => { if (!(S.hold && S.hold.by !== k) || opts.length < 2) return; heldTurns++; const rule = opts.find((o) => o && o.id === 'escape') || opts.find((o) => o && o.id === '@break') || null; same += (rule && rule.id) === (ans && ans.id); };
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
    // fine = 0: round 4's judge, every action filed under the range the turn began at (the bar). fine = 1: each action under the range it is laid at (reported beside it)
    const feat = (log, fine) => { const f = {}; let n = 0; for (const t of log.slice(0, 10)) { f['at' + t.pos[0]] = (f['at' + t.pos[0]] || 0) + 1; t.kinds.forEach((k, i) => { const r = fine ? t.at[i] : t.pos[0], kd = fine === 2 && t.kk[i] ? t.kk[i] : k; f[kd + r] = (f[kd + r] || 0) + 1; }); f.ans = (f.ans || 0) + t.ans; n++; } for (const k in f) f[k] /= Math.max(1, n); return f; };
    const raw = {}; for (const s of STYLES) { raw[s] = []; for (const t of STYLES) if (t !== s) raw[s].push(...play(fighter(s), fighter(t), AI, AI, per, { keepLogs: 1 }).logs.map((l) => l[0])); }
    for (const fine of [2, 1, 0]) {
    const logs = {}; for (const s of STYLES) logs[s] = raw[s].map((l) => feat(l, fine));
    const cen = {}; for (const s of STYLES) { const h = logs[s].slice(0, logs[s].length >> 1), c = {}; for (const f of h) for (const k in f) c[k] = (c[k] || 0) + f[k] / h.length; cen[s] = c; }
    const dist = (f, c) => { let d = 0; for (const k of new Set([...Object.keys(f), ...Object.keys(c)])) d += ((f[k] || 0) - (c[k] || 0)) ** 2; return d; };
    let ok = 0, n = 0; out.p6.judge = {};
    for (const s of STYLES) { let o = 0; const te = logs[s].slice(logs[s].length >> 1); for (const f of te) o += STYLES.reduce((b, t) => (dist(f, cen[t]) < dist(f, cen[b]) ? t : b), STYLES.find((t) => t !== s)) === s; out.p6.judge[s] = o / te.length; ok += o; n += te.length; }
    out.p6[['judgeAll', 'judgeFine', 'judgeKick'][fine]] = ok / n; out.p6['by' + fine] = { ...out.p6.judge }; say(`P6 blind judge${[' (round 4 instrument: every action filed under the range the turn began at, a kick and a punch one kind)', ' (each action under the range it is laid at; a kick and a punch one kind)', ' (each action under the range it is laid at; a kick is its own kind)'][fine]} names the style from 10 turns: ${pct(ok / n)} (${STYLES.map((s) => s + ' ' + pct(out.p6.judge[s])).join(', ')})`);
    }
  },
  p4() { const T = table(() => AI, () => AI, per), F = fold(T), s = shape(T.tot); show(F.cell, F.avg); say(shapeLine(s)); const cells = PAIRS.map(([a, b]) => [a, b, F.cell[a][b]]).sort((x, y) => Math.abs(y[2] - 0.5) - Math.abs(x[2] - 0.5)); out.p4 = { F, s, worst: cells.slice(0, 5), outside: cells.filter((c) => Math.abs(c[2] - 0.5) > 0.1).length }; say(`P4 cells outside 40-60: ${out.p4.outside} of ${PAIRS.length}; worst: ${cells.slice(0, 5).map((c) => `${c[0]} v ${c[1]} ${pct(c[2])}`).join(', ')}`); say(`D1 decisions per bout ${s.dec.toFixed(1)}; 95th percentile ${s.dec95}; max choices ${s.maxCh}`); },
  p10() { const a = table(() => AI, () => AI, per), s = table((st) => scripted(st), () => AI, per), i = table(() => impatient(), () => AI, per); out.p10 = { ai: a.avg, scripted: s.avg, impatient: i.avg }; for (const st of STYLES) say(`P10 ${st.padEnd(10)} AI ${pct(a.avg[st])} | scripted ${pct(s.avg[st])} | impatient ${pct(i.avg[st])}  (each against the AI pilot flying the other included art)`); say(`R-C11 the impatient line with a style deck against the AI pilot: ${pct(mean(i.avg))}`); },
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
// ---- the two gates of plan section 7 (round 7): the PLAY gate the owner plays, the SHIP gate the
// critics and the next art pass. P1 and L2 are measured on the slice (boxing v BJJ, real ladder states
// from simulateLadder) - never on arts or states that are not in the build.
let gateResult = null;
function gateTable(name, rows, pass, note) {
  const w = (s, n) => { s = String(s); return s.length > n ? s.slice(0, n - 1) + '…' : s.padEnd(n); };
  const wrap = (s, n) => { const out = []; while (s.length > n) { let i = s.lastIndexOf(' ', n); if (i < n / 2) i = n; out.push(s.slice(0, i)); s = s.slice(i).trimStart(); } out.push(s); return out; };
  say('');
  say(`${name} GATE - plan section 7. ${note}`);
  say(`${w('#', 3)}${w('bar', 62)}${w('measured', 58)}result`);
  for (const [i, r] of rows.entries()) {
    const bar = wrap(r.bar, 62), mes = wrap(r.measured, 58);
    const n = Math.max(bar.length, mes.length);
    for (let j = 0; j < n; j++) say(`${w(j === 0 ? i + 1 : '', 3)}${w(bar[j] || '', 62)}${w(mes[j] || '', 58)}${j === 0 ? (r.pass ? 'PASS' : 'FAIL') : ''}`);
  }
  say(`${name} GATE: ${pass ? 'PASS' : 'FAIL'} (${rows.filter((r) => r.pass).length}/${rows.length})`);
}
P.gate = async function () {
  per = kv.per || 200; seed0 = kv.seed || 500000000; // the round-6b protocol, so the rows stay comparable
  const N0 = { ...N }, lineStart = lines.length, rows = [];
  const row = (bar, measured, pass) => rows.push({ bar, measured, pass: !!pass });
  // 1-2 the page's module graph links under the stub document, and a scripted player finishes one bout and
  // one ladder step through the page's own calls (a broken import or a crash fails the gate here)
  try {
    const { install } = await import('./uidom.mjs');
    const p = install();
    const ui = await import('./ui.js');
    const screen = p.screen;
    const enabled = (sel) => screen.querySelectorAll(sel).filter((b) => !b.disabled);
    const click = (sel) => { const b = screen.querySelector(sel); if (!b) throw new Error('the page offers no ' + sel); b.click(); };
    click('[data-style="boxing"]');
    click('#skip');
    let guard = 0;
    while (!screen.querySelector('#trainNext')) {
      if (guard++ > 4000) throw new Error('the bout never reached a verdict');
      const b = ['[data-answer]', '[data-card]', '[data-floor]'].map((sel) => enabled(sel)[0]).find(Boolean);
      if (b) { b.click(); continue; }
      const end = screen.querySelector('#endTurn');
      if (end && !end.disabled) { end.click(); continue; }
      throw new Error('the page is stuck with nothing to click');
    }
    const how = ui.state.result.how;
    click('#trainNext');
    click('#skip');
    if (!screen.querySelector('#endTurn')) throw new Error('the ladder step did not reach the next bout');
    row('the page\'s module graph links (a broken import fails the test)', 'ui.js linked under the stub document', true);
    row('a scripted player finishes a bout and a ladder step through the page\'s own calls', `1 bout to a verdict (by ${how}); then verdict, training, the next bout on the table`, true);
  } catch (e) {
    row('the page\'s module graph links (a broken import fails the test)', 'link failed: ' + e.message, false);
    row('a scripted player finishes a bout and a ladder step through the page\'s own calls', 'not reached: ' + e.message, false);
  }
  // 3 the printed numbers equal the engine's
  const pr = printedProblems();
  row('the printed numbers equal the engine\'s', `${pr.checked} card lines, steps and previews checked; ${pr.problems.length} mismatches${pr.problems.length ? ': ' + pr.problems[0] : ''}`, !pr.problems.length);
  // 4-5 D1 and the pairing, on the slice, both seats
  const rA = play(fighter('boxing'), fighter('bjj'), AI, AI, per);
  const rB = play(fighter('bjj'), fighter('boxing'), AI, AI, per);
  const s = shape(add(add({}, rA), rB));
  const share = (rA.win + (rB.n - rB.win)) / (rA.n + rB.n); // the folded boxing share
  row('D1: 22.5-45 decisions a bout, 95% under 52', `${s.dec.toFixed(1)} decisions; 95th percentile ${s.dec95}`, s.dec >= 22.5 && s.dec <= 45 && s.dec95 < 52);
  row('every pairing inside 40-60', `boxing v bjj: boxing ${pct(share)} / bjj ${pct(1 - share)}`, share >= 0.4 && share <= 0.6);
  // 6 no crash in 1,000 bot bouts
  let crashed = 0, firstErr = '';
  for (let i = 0; i < 1000; i++) {
    try { bout(fighter(i % 2 ? 'bjj' : 'boxing'), fighter(i % 2 ? 'boxing' : 'bjj'), [AI, AI], 900000000 + i * 61); }
    catch (e) { if (!crashed) firstErr = e.message; crashed++; }
  }
  row('no crash in 1,000 bot bouts', `${1000 - crashed} of 1000 clean${crashed ? '; first: ' + firstErr : ''}`, !crashed);
  const playRows = rows.slice();
  const playPass = playRows.every((r) => r.pass);
  gateTable('PLAY', playRows, playPass, 'the owner may open the build when every row is PASS');
  if (gateArg !== 'gate=ship') { Object.assign(N, N0); gateResult = { tag: 'play', pass: playPass, lineStart, payload: { config: { per, seed: seed0, mode: N.mode }, play: { rows: playRows, pass: playPass } } }; writeGate(); return; }
  // ---- SHIP: PLAY, plus the full sheet, measured on the slice --------------------------------------
  say('');
  say('SHIP GATE - the full sheet (plan section 7): the critics, the next art and outside players');
  P.p2(); P.p5(); P.p6(); P.p10();
  const c = out.p2['c + the hold'];
  const blinds = [['health', out.p2['blind health'].meanLoss], ['points', out.p2['blind points'].meanLoss], ['hold', out.p2['blind the hold'].meanLoss]];
  row('P2: each way to win ends 15%+; early 40-70%; a pilot blind to any one loses 5+', `KO ${pct(c.ko)} lead ${pct(c.lead)} tap ${pct(c.tap)} pin ${pct(c.pin)}; early ${pct(c.early)}; blind health ${pct(blinds[0][1])} points ${pct(blinds[1][1])} hold ${pct(blinds[2][1])}`, c.ko >= .15 && c.lead >= .15 && c.tap + c.pin >= .15 && c.early >= .4 && c.early <= .7 && blinds.every(([, v]) => v >= 5));
  row('P1 (slice, boxing v BJJ): 3+ ranges >=80%, neither wins >60%, <=37.5 decisions', `3+ ranges ${pct(s.vis3)}%; boxing ${pct(share)} / bjj ${pct(1 - share)}; ${s.dec.toFixed(1)} decisions`, s.vis3 >= .8 && share >= .4 && share <= .6 && s.dec <= 37.5);
  row('P4: pairing 40-60%; each art\'s average 47-53', `boxing v bjj ${pct(share)}; averages boxing ${pct(share)} / bjj ${pct(1 - share)}`, share >= .4 && share <= .6 && share >= .47 && share <= .53 && 1 - share >= .47 && 1 - share <= .53);
  const p5 = out.p5;
  row('P5: the hold is a readable race (printed answer 100%; ends 15-30% of ground bouts; 20-80% of holds finish)', `printed answer ${pct(p5.same)}; ends ${pct(p5.s.holdEnds)}; finish ${pct(p5.s.holdFinish)}`, p5.same === 1 && p5.s.holdEnds >= .15 && p5.s.holdEnds <= .3 && p5.s.holdFinish >= .2 && p5.s.holdFinish <= .8);
  const p6 = out.p6;
  row('P6: each art plays differently (mechanic off changes >50% of its turns; blind judge >=90%)', STYLES.map((t) => `${t} ${pct(p6.diff[t])}`).join(' / ') + `; judge ${pct(p6.judgeAll)}`, STYLES.every((t) => p6.diff[t] > .5) && p6.judgeAll >= .9);
  const p10 = out.p10;
  row('P10: the pilot flies every deck (AI no more than 5 points below the scripted)', STYLES.map((t) => `${t}: AI ${pct(p10.ai[t])} / scripted ${pct(p10.scripted[t])}`).join(' ; '), STYLES.every((t) => p10.ai[t] - p10.scripted[t] >= -0.05));
  const l1 = simulateLadder(100, 600000000, 80);
  row('L1: 30-70 titles in 100 (model minutes shown)', `${l1.titleWins}/100 titles; ${l1.meanMinutes.toFixed(1)} modelled minutes a run (8 s a player decision)`, l1.titleWins >= 30 && l1.titleWins <= 70);
  const l2 = STYLES.map((t) => ({ t, m: measureTraining(t) }));
  row('L2: every training option best in 1-6 of ten real ladder states (from simulateLadder)', l2.map(({ t, m }) => `${t} ${m.options.map((o) => o.right).join('/')}`).join(' ; '), l2.every(({ m }) => m.pass));
  row('the beginner at 25-40% (the impatient line against the AI, per art)', STYLES.map((t) => `${t} ${pct(p10.impatient[t])}`).join(' ; '), STYLES.every((t) => p10.impatient[t] >= .25 && p10.impatient[t] <= .4));
  const shipRows = rows.slice();
  const shipPass = shipRows.every((r) => r.pass);
  gateTable('SHIP', shipRows, shipPass, 'PLAY, plus the full bar sheet; the critics and the next art pass the build when every row is PASS');
  Object.assign(N, N0);
  gateResult = { tag: 'ship', pass: shipPass, lineStart, payload: { config: { per, seed: seed0, mode: N.mode }, play: { rows: playRows, pass: playPass }, ship: { rows: shipRows, pass: shipPass, l1: { titles: l1.titleWins, minutes: +l1.meanMinutes.toFixed(1), bouts: +l1.meanBouts.toFixed(1) }, l2: Object.fromEntries(l2.map(({ t, m }) => [t, m.options.map((o) => o.right)])), blindLoss: Object.fromEntries(blinds), p2hold: { ko: c.ko, lead: c.lead, tap: c.tap, pin: c.pin, early: c.early }, beginner: p10.impatient } } };
  writeGate();
};
function writeGate() {
  fs.mkdirSync(new URL('./out/', import.meta.url), { recursive: true });
  fs.writeFileSync(new URL(`./out/gate-${gateResult.tag}.txt`, import.meta.url), lines.slice(gateResult.lineStart).join('\n') + '\n');
  fs.writeFileSync(new URL(`./out/gate-${gateResult.tag}.json`, import.meta.url), JSON.stringify(gateResult.payload, null, 1));
}

const order = what === 'all' ? ['p1', 'p2', 'p5', 'p6', 'p4', 'p10', 'r3'] : [what];
const t0 = Date.now();
for (const w of order) { await P[w](); say(`   [${w}: ${((Date.now() - t0) / 1000).toFixed(0)} s, per=${per}, seed=${seed0}, mode=${N.mode}]`); }
if (kv.tag) { fs.mkdirSync(new URL('./out/', import.meta.url), { recursive: true }); fs.writeFileSync(new URL(`./out/${kv.tag}.json`, import.meta.url), JSON.stringify(out, (k, v) => (k === 'decs' || k === 'logs' ? undefined : v), 1)); fs.writeFileSync(new URL(`./out/${kv.tag}.txt`, import.meta.url), lines.join('\n') + '\n'); }
if (what === 'gate') { process.exitCode = gateResult.pass ? 0 : 1; }
