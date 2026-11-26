// TELLS2M (S563) - THE TELLS, VERSION 2, MEASURED ON THE INSTRUMENT (ops/research/TASK_TELLS2M.md).
// Owner S563: "do you thinkwe should show opponents itentions like more draditional card games or it is fine the way it is ?"
// Version 2 of the tell lives in the words tool (tells.mjs: tellOf(opp, plan, c, 2)). Before it goes near the page, this
// asks how much a tell is worth to a bot in the player's corner. Whole bouts, the page's opponents (opp 0 / 1 / 2) choosing
// with ai() as on the page; his beat is chosen FIRST and his cue taken from it (as play_cli.mjs, tells=2):
//   BOT 0 "no tell"            the page's mix (balance.mjs who=mix) - the control; against opp=mirror it IS balance's mirror
//   BOT 1 "follows blindly"    BOT 0's beat, its HELD hands set to cover the lines the cue names (rear shoulder -> lead high
//                              + rear high; knees -> lead low + rear low; back foot / quiet -> as BOT 0; front foot -> as
//                              BOT 0 but no back off), its punches kept
//   BOT 2 "knows his lie"      BOT 1, but when that man's lie condition holds (LIES[opp].test(c)) it plays BOT 0's beat
// A fake costs him 1 stamina after the beat (as play_cli.mjs). The bouts loop is balance.mjs's to the letter (mirror:
// bout for bout the same, probe_tells_test.mjs holds that); against a man the only change in the random stream is that his
// ai() is drawn before your mix (his beat is chosen before yours), which leaves every distribution as it was.
//   node proto/twohands/tools/probe_tells.mjs bot=0|1|2 opp=mirror|0|1|2 [n=12] [jobs=2] [seed=1] [json=<f>]
import fs from 'node:fs';
import { fileURLToPath, pathToFileURL } from 'node:url';
import { Worker, isMainThread, parentPort, workerData } from 'node:worker_threads';
import { load } from './rules.mjs';
import { tellOf, LIES, LIES3, LIES4, CAP3, fakeOk4 } from './tells.mjs';
/* S564 v=3: tells version 3 (bluff by damage, at most 2 fakes a round never two running, second conditions). BOT 2 knows
   the whole rule: a condition holds and the cap is not reached. Default v=2 replays TELLS2M as it ran. */
const liesOf = (v) => (v >= 4 ? LIES4 : LIES3);
/* S566 TELLS4M: BOT 2 FIXED (fix=1). It doubts a cue only when that cue is the one this man fakes under a condition that
   holds now (cap not reached); then it plays BOT 0's beat with one held hand turned into the cheapest punch that reaches
   (after its own step; ties: the bigger punch, then the lead). Any other cue it covers like BOT 1. */
export const lieCueHolds = (opp, c, cue, v = 3) => (c.fakesRound || 0) < CAP3.round && !c.fakedLast && (liesOf(v)[opp] || []).some((L) => L.cue === cue && L.test(c));
export function punchInto(base, c, FEET) { const A = c.ACT, p = { ...base, ord: [...(base.ord || [])] }; if (p.clinch || !A) return p;
  const r = Math.max(1, Math.min(3, c.range + (p.feet === 'in' ? -1 : p.feet === 'back' ? 1 : 0))), used = (p.lead ? A[p.lead].st : 0) + (p.rear ? A[p.rear].st : 0) + ((FEET && FEET[p.feet]) ? FEET[p.feet].st : p.feet === 'hold' ? 0 : 1);
  let best = null;
  for (const [hand, h] of [['lead', 0], ['rear', 1]]) { if (p[hand]) continue;
    for (const id in A) { const a = A[id]; if (a.h !== h || !a.d || !a.reach || !a.reach.includes(r) || used + a.st > c.me.st) continue;
      if (!best || a.st < best.a.st || (a.st === best.a.st && a.d > best.a.d)) best = { hand, id, a }; } }
  if (!best) return p; p[best.hand] = best.id; p.ord = [...p.ord, best.hand]; return p; }
export const lieHolds = (opp, c, v = 2) => (v >= 4 ? (c.fakesRound || 0) < CAP3.round && !c.fakedLast && LIES4[opp].some((L) => L.test(c)) : v >= 3 ? (c.fakesRound || 0) < CAP3.round && !c.fakedLast && (LIES3[opp] || []).some((L) => L.test(c)) : !!(LIES[opp] && LIES[opp].test(c)));
import { report as balReport } from './balance.mjs';

export const BOTS = ['no tell (the page\'s mix)', 'follows the tell blindly', 'knows his lie'];
export const CUE_KEYS = ['shoulder', 'knees', 'foot', 'backfoot', 'still'];

// BOT 1's change to a beat: the HELD hands cover the lines the cue names; a punching hand keeps its punch.
export function cover(base, cue) {
  const p = { ...base, ord: [...(base.ord || [])] };
  if (p.clinch) return p;
  const held = (h) => { if (!p.lead) p.hl = h; if (!p.rear) p.hr = h; };
  if (cue === 'shoulder') held('high');
  else if (cue === 'knees') held('low');
  else if (cue === 'foot' && p.feet === 'back') { p.feet = 'hold'; p.ord = p.ord.filter((s) => s !== 'feet'); }
  return p;
}
// the beat a bot plays: base = BOT 0's beat (a draw from the solved mix), tell = tellOf(...), c = the state as the beat starts
export function botPlan(bot, opp, base, tell, c, v = 2, o = {}) {
  if (bot === 0 || !tell) return { ...base, ord: [...(base.ord || [])] };
  if (bot === 2 && o.fix) return lieCueHolds(opp, c, tell.cue, v) ? punchInto(base, c, o.FEET) : cover(base, tell.cue);
  if (bot === 2 && lieHolds(opp, c, v)) return { ...base, ord: [...(base.ord || [])] };
  return cover(base, tell.cue);
}

const drawAt = (mix, rnd) => { let x = rnd(), i = 0; while (i < mix.length - 1 && (x -= mix[i]) > 0) i++; return i; };   // as balance.mjs
const merge = (a, b) => { if (!a) return b; for (const k in b) { if (typeof b[k] === 'number') a[k] = (a[k] || 0) + b[k]; else if (Array.isArray(b[k]) && typeof b[k][0] === 'number') b[k].forEach((x, i) => { a[k][i] += x; }); else if (Array.isArray(b[k])) b[k].forEach((x, i) => { a[k][i] = merge(a[k][i], x); }); else a[k] = merge(a[k] || {}, b[k]); } return a; };   // as balance.mjs
const PROMISE_CUE = { shoulder: ['cross', 'over'], knees: ['bjab', 'lbody', 'rbody', 'lup', 'rup'] };
const planDmg = (p, A) => (p && !p.clinch ? ((p.lead && A[p.lead] && A[p.lead].d) || 0) + ((p.rear && A[p.rear] && A[p.rear].d) || 0) : 0);
const cueMinDmg = (cue, A) => Math.min(...(PROMISE_CUE[cue] || []).filter((id) => A[id] && A[id].d).map((id) => A[id].d), 99);

// ---- WHOLE BOUTS. balance.mjs bouts(R, 'mix', opp, n), with the tell, the bot's change and the fake's cost added.
// o = balance.mjs's counts + o.tl (the tells: beats, fakes, cues shown, beats the bot changed, his / your stamina at bells).
export function bouts(R, bot, opp, n, v = 2, fix = 0) { const { N, ACT, man, resolve, endBeat } = R, rnd = R.rnd, mirror = opp === 'mirror';
  if (mirror) { if (!R.OPPS[3]) R.OPPS.push({ n: 'mirror', hp: N.hp, read: 0, like: [], lean: 0 }); R.setOpp(3); } else R.setOpp(opp);
  const o = { n, w: 0, draw: 0, ko: 0, lost: 0, beats: 0, clinch: 0, rng: [0, 0, 0, 0], use: [{}, {}], pun: [{}, {}], np: [[0, 0, 0], [0, 0, 0]], dmg: [0, 0], first: {}, ordered: 0, kd: [0, 0], lvl: [0, 0, 0] };
  const z0 = () => new Array(N.rounds).fill(0);
  o.tl = { beats: 0, fake: 0, ...(v >= 3 ? { fakeBluff: 0, fakeOver: {} } : {}), ...(fix ? { susp: 0, suspFake: 0, punched: 0 } : {}), ...(v >= 4 ? { fakeHid3: 0 } : {}), cue: Object.fromEntries(CUE_KEYS.map((k) => [k, 0])), cueFake: Object.fromEntries(CUE_KEYS.map((k) => [k, 0])), changed: 0, lieHeld: 0, lieSkipped: 0, bellSt: z0(), bellMe: z0(), bellN: z0(), stopRound: z0() };
  const note = (k, c) => { const u = o.use[k], add = (x) => { u[x] = (u[x] || 0) + 1; }; if (c.clinch) return add('clinch'); add(c.lead || 'lead held ' + c.hl); add(c.rear || 'rear held ' + c.hr); add(c.feet === 'hold' ? 'feet hold' : c.feet === 'in' ? 'step in' : c.feet === 'back' ? 'back off' : c.feet);
    o.np[k][(c.lead && ACT[c.lead].d ? 1 : 0) + (c.rear ? 1 : 0)]++; if (k === 0 && c.ord && c.ord.length > 1) { o.ordered++; o.first[c.ord[0]] = (o.first[c.ord[0]] || 0) + 1; } };
  const same = (a, b) => a.clinch === b.clinch && a.lead === b.lead && a.rear === b.rear && a.hl === b.hl && a.hr === b.hr && a.feet === b.feet;
  for (let b = 0; b < n; b++) { const S = { f: [man(N.hp), man(R.opp().hp)], range: 3 }; let done = false; const t = [0, 0];
    const ctx = { hisLast: null, meLanded: false, blockedAny: false, blockedBody: false };   // as play_cli.mjs: carried over the bell
    for (let r = 0; r < N.rounds && !done; r++) { S.range = 3; const fk = { round: 0, last: false }; for (const m of S.f) { m.pts = 0; m.st = m.cap; m.g = N.guard; m.ropes = 0; m.held = 0; m.kept = 0; m.gave = 0; }
      for (let i = 0; i < N.beats && !done; i++) { S.t = N.beats - i; let mine, his, tell = null;
        if (mirror) { const z = R.solveBeat(S, S.t, { iters: 400 }); mine = z.A[drawAt(z.p, rnd)]; his = z.B[drawAt(z.q, rnd)]; }
        else { his = R.ai(S) || R.plan0();   // his beat first (play_cli.mjs since S563), then his cue from it
          const c = { me: { ...S.f[0] }, him: { ...S.f[1] }, ...ctx, range: S.range, ...(v >= 3 ? { ACT, fakesRound: fk.round, fakedLast: fk.last } : {}) }; tell = tellOf(opp, his, c, v); fk.round += tell.fake ? 1 : 0; fk.last = tell.fake;
          const z = R.solveBeat(S, S.t, { iters: 400 }), base = z.A[drawAt(z.p, rnd)]; mine = botPlan(bot, opp, base, tell, c, v, { fix, FEET: R.FEET });
          const T = o.tl; T.beats++; T.cue[tell.cue]++; if (tell.fake) { T.fake++; T.cueFake[tell.cue]++; if (v >= 3) { const d = planDmg(his, ACT), m = cueMinDmg(tell.cue, ACT); if (d < m) T.fakeBluff++; else if (v >= 4 && fakeOk4(his, tell.cue, ACT)) { T.fakeBluff++; T.fakeHid3++; } else { const k = `${tell.cue}:${his.lead || '-'}+${his.rear || '-'}(${d}>=${m})`; T.fakeOver[k] = (T.fakeOver[k] || 0) + 1; } } } if (!same(base, mine)) T.changed++; if (fix && bot === 2 && lieCueHolds(opp, c, tell.cue, v)) { T.susp++; if (tell.fake) T.suspFake++; if (mine.lead !== base.lead || mine.rear !== base.rear) T.punched++; }
          if (lieHolds(opp, c, v)) { T.lieHeld++; if (bot === 2 && !same(base, cover(base, tell.cue))) T.lieSkipped++; } }
        note(0, mine); note(1, his); const hp = [S.f[0].hp, S.f[1].hp], ev = resolve(S, [{ ...mine }, { ...his }]); endBeat(S); o.beats++; o.rng[S.range]++; o.dmg[0] += hp[1] - S.f[1].hp; o.dmg[1] += hp[0] - S.f[0].hp;
        if (tell && tell.fake) S.f[1].st = Math.max(0, S.f[1].st - 1);   // TELLS2: a bluff costs the liar 1 stamina (as play_cli.mjs)
        ctx.hisLast = his; ctx.meLanded = ev.some((e) => e.k === 0 && e.t === 'hit'); ctx.blockedAny = ev.some((e) => e.k === 1 && e.t === 'block');
        ctx.blockedBody = ev.some((e) => e.k === 1 && e.t === 'block' && ACT[e.id] && ACT[e.id].line === 'body');
        for (const e of ev) { if (e.t === 'clinch') o.clinch++; if (e.id && (e.t === 'hit' || e.t === 'block' || e.t === 'miss')) { const q = o.pun[e.k][e.id] = o.pun[e.k][e.id] || { hit: 0, block: 0, miss: 0 }; q[e.t]++; } }
        for (const k of [0, 1]) if (S.f[k].hp <= 0) { S.f[k].kd++; o.kd[k]++; S.f[1 - k].pts += 3; if (S.f[k].kd > N.kd.length) { if (k === 1) { o.w++; o.ko++; } else o.lost++; o.tl.stopRound[r]++; done = true; break; } S.f[k].hp = N.kd[S.f[k].kd - 1]; } }
      if (!done) { o.tl.bellSt[r] += S.f[1].st; o.tl.bellMe[r] += S.f[0].st; o.tl.bellN[r]++;   // the stamina at this bell, before the corner refills it
        const [x, y] = S.f, lvl = x.pts === y.pts, g = lvl && N.even ? Math.sign((y.gave || 0) - (x.gave || 0)) : 0;
        o.lvl[0]++; if (lvl) o.lvl[1]++; if (g) o.lvl[2]++; t[0] += x.pts > y.pts || (lvl && g >= 0) ? 10 : 9; t[1] += y.pts > x.pts || (lvl && g <= 0) ? 10 : 9; } }
    if (!done) { if (t[0] > t[1]) o.w++; else if (t[0] === t[1]) o.draw++; } }
  return o; }

if (!isMainThread && workerData && workerData.tellsProbe) { const { bot, opp, n, seed, v, fix } = workerData; parentPort.postMessage(bouts(load(seed), bot, opp, n, v || 2, fix || 0)); }
// jobs split as balance.mjs play: worker i plays ceil(n / jobs) bouts on seed * 100 + i
export async function play(bot, opp, n, o = {}) { const jobs = o.jobs || 2, self = fileURLToPath(import.meta.url), each = Math.ceil(n / jobs);
  const got = await Promise.all(Array.from({ length: jobs }, (_, i) => new Promise((ok, bad) => { const w = new Worker(self, { workerData: { tellsProbe: 1, bot, opp, n: each, seed: (o.seed || 1) * 100 + i, v: o.v || 2, fix: o.fix || 0 } }); w.once('message', ok); w.once('error', bad); })));
  return got.reduce(merge, null); }

// the numbers of one pairing (the result table reads these)
export function summary(o) { const dec = o.n - o.draw, T = o.tl, f = (x) => +x.toFixed(3);
  const s = { n: o.n, wins: o.w, draws: o.draw, decided: dec, winDec: dec ? f(o.w / dec) : null, stop: f((o.ko + o.lost) / o.n), ko: o.ko, lost: o.lost,
    kdBout: f((o.kd[0] + o.kd[1]) / o.n), kdHim: f(o.kd[1] / o.n), kdYou: f(o.kd[0] / o.n), fakeBeat: T.beats ? f(T.fake / T.beats) : null, changed: T.beats ? f(T.changed / T.beats) : null,
    lieHeld: T.beats ? f(T.lieHeld / T.beats) : null, bellHim: T.bellN.map((c, i) => (c ? +(T.bellSt[i] / c).toFixed(2) : null)), bellYou: T.bellN.map((c, i) => (c ? +(T.bellMe[i] / c).toFixed(2) : null)), bells: T.bellN };
  const s3 = T.fakeBluff == null ? s : { ...s, fakeBluff: T.fakeBluff, bluffShare: T.fake ? f(T.fakeBluff / T.fake) : null, fakeOver: T.fakeOver };
  const s4 = T.fakeHid3 == null ? s3 : { ...s3, fakeHid3: T.fakeHid3 };
  return T.susp == null ? s4 : { ...s4, dmgHim: f(o.dmg[1] / o.n), susp: T.susp, suspFake: T.suspFake, punched: T.punched }; }

export function report(R, bot, opp, o, extra = {}) { const v = extra.v || 2; const pc = (x) => (x == null ? '-' : (100 * x).toFixed(0) + '%'), s = summary(o), T = o.tl, mirror = opp === 'mirror';
  const name = mirror ? 'the mirror mix (the same man, no style, no tells)' : R.OPPS[opp].n, L = [];
  L.push(`PROBE_TELLS bot=${bot} (BOT ${bot}: ${BOTS[bot]}) v ${name}: n=${o.n} seed=${extra.seed ?? 1} jobs=${extra.jobs ?? 2} (worker i: seed*100+i; page order.html through rules.mjs, tells.mjs v2; nothing edited)`);
  L.push(`  wins of decided ${pc(s.winDec)} (${s.wins} of ${s.decided}), draws ${s.draws}; stoppages ${pc(s.stop)} (he is stopped ${o.ko}, you are stopped ${o.lost}); knockdowns a bout ${s.kdBout.toFixed(2)} (him ${s.kdHim.toFixed(2)}, you ${s.kdYou.toFixed(2)})`);
  if (!mirror) {
    L.push(`  his tells: ${T.beats} beats, fakes ${T.fake} = ${pc(s.fakeBeat)} of beats; cues shown ${CUE_KEYS.map((k) => `${k} ${T.cue[k]} (fake ${T.cueFake[k]})`).join(', ')}`);
    if (T.susp != null) L.push(`  BOT 2 fixed: doubted ${T.susp} cues (${T.suspFake} really fake = ${T.susp ? pc(T.suspFake / T.susp) : '-'}), punched into ${T.punched} of them; health he dealt a bout ${(o.dmg[1] / o.n).toFixed(1)}`);
    if (T.fakeHid3 != null) L.push(`  v4: fakes hiding the one 3-damage punch on an open line: ${T.fakeHid3} of ${T.fake}`);
    L.push(`  his lie condition held on ${pc(s.lieHeld)} of beats; the bot changed BOT 0's beat on ${pc(s.changed)} of beats${bot === 2 ? `; BOT 2 ignored a cue that would have changed its beat on ${T.lieSkipped} beats` : ''}`);
  }
  L.push(`  stamina at the bells (avg, of ${R.N.st}; bells reached ${s.bells.join(' / ')}): him ${s.bellHim.map((x) => (x == null ? '-' : x.toFixed(1))).join(' / ')}; you ${s.bellYou.map((x) => (x == null ? '-' : x.toFixed(1))).join(' / ')}; stoppages by round ${T.stopRound.join(' / ')}`);
  const bar = (ok, txt) => L.push(`  ${ok ? 'PASS' : 'FAIL'} ${txt}`);
  bar(s.stop >= 0.1 && s.stop <= 0.4, `stoppages 10-40%: ${pc(s.stop)}`);
  if (!mirror) bar(s.fakeBeat >= 0.15 && s.fakeBeat <= 0.3, `his fakes on 15-30% of beats: ${pc(s.fakeBeat)}`);
  if (!mirror && T.fakeBluff != null) { const ex = Object.entries(T.fakeOver || {}); bar(T.fake === T.fakeBluff, `bluff share (fake real damage < cue's smallest punch${v >= 4 ? ', or v4: one 3-damage punch on an open line' : ''}) 100%: ${T.fake ? pc(s.bluffShare) : '-'} (${T.fakeBluff} of ${T.fake}${ex.length ? '; exceptions ' + ex.map(([k, c]) => k + 'x' + c).join(', ') : ', 0 exceptions'})`); }
  if (mirror) bar(s.winDec != null && Math.abs(s.winDec - 0.5) <= 0.1, `BOT 0 about 50% v the mirror mix (40-60% of decided): ${pc(s.winDec)}`);
  if (bot === 1 && !mirror) bar(s.winDec != null && s.winDec <= 0.55, `BOT 1 wins at most 55% of decided: ${pc(s.winDec)}`);
  if (bot === 2 && !mirror) L.push(`  (BOT 2 bar - 70%+ of decided, OR 10 points more than BOT 1 - is judged in docs/TELLS2M_RESULT.md against BOT 1's file: ${pc(s.winDec)} here)`);
  L.push(balReport(R, `bot${bot}`, opp, o).split('\n').map((l) => '  ' + l).join('\n'));
  L.push(`  SUMMARY ${JSON.stringify({ bot, opp, ...s })}`);
  if (extra.secs != null) L.push(`  (${o.n} bouts, ${extra.secs} s)`);
  return L.join('\n'); }

const isMain = isMainThread && import.meta.url === pathToFileURL(process.argv[1] || '').href;
if (isMain) { const arg = (k, d) => { const a = process.argv.find((x) => x.startsWith(k + '=')); return a ? a.split('=').slice(1).join('=') : d; };
  const bot = Number(arg('bot', 0)), op = arg('opp', 'mirror'), opp = op === 'mirror' ? op : Number(op), n = Number(arg('n', 12)), jobs = Number(arg('jobs', 2)), seed = Number(arg('seed', 1)), v = Number(arg('v', 2)), fix = Number(arg('fix', 0));
  if (![0, 1, 2].includes(bot)) throw new Error('probe_tells: bot=0|1|2'); if (opp !== 'mirror' && ![0, 1, 2].includes(opp)) throw new Error('probe_tells: opp=mirror|0|1|2');
  if (opp === 'mirror' && bot !== 0) throw new Error('probe_tells: the mirror has no tells - bot=0 only');
  const R = load(1), t0 = Date.now(), o = await play(bot, opp, n, { jobs, seed, v, fix });
  console.log(`TELLS VERSION ${v}${fix ? ' (BOT 2 fixed, fix=1)' : ''}`); console.log(report(R, bot, opp, o, { seed, jobs, v, secs: ((Date.now() - t0) / 1000).toFixed(0) }));
  if (arg('json', '')) fs.writeFileSync(arg('json', ''), JSON.stringify(o)); }
