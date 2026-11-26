// LONG1 PROBE (S565): a counting COPY of balance.mjs's bout loop (who=mix, opp=mirror), counting what the
// page's bars cannot see: what happens in beats that START at Long. Nothing here changes the rules; it only
// counts. Same args as balance.mjs play: tweak=, table=, n=, seed= (plus optional jobs= for the same split
// balance.mjs play uses). Definitions, fixed before any run:
//  - "at Long" for points/health: the range in the moment the punch lands, rebuilt from the beat's range
//    events in order (a feet moment moves the men before the punches in that same moment). A beat-start
//    cross-check (all hits in a beat that started at Long) is printed too.
//  - "nothing thrown": both plans have lead==null, rear==null and no clinch.
//  - "step in from Long": a beat that starts at Long with feet=='in' in that man's plan. "Got in" = the men
//    end the beat closer than Long (range after resolve < 3). "Stopped" = a hit whose words say it meets
//    him stepping in and stops him (L1's words; 0 where there is no such rule). "Paid the fence tax" =
//    stamina lost beyond the plan's cost in that beat, at least 1, with no body hit on the stepper that
//    beat to confuse it with a shortened stamina bar; the fence condition (opponent lead held high) is
//    counted separately.
//  - "outfighter's round": a completed round (no stoppage) won on points by the man who scored more points
//    AT Long in that round than his opponent scored in the whole round.
//  - "first step in": beat index (0 = first beat of the round) of the first feet=='in' plan in the round.
//   node proto/twohands/tools/probe_long.mjs tweak=<f> table=<vt> n=84 seed=1 jobs=2
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';
import { Worker, isMainThread, parentPort, workerData } from 'node:worker_threads';
import { loadTweaked, readTweak } from './balance.mjs';

const drawAt = (mix, rnd) => { let x = rnd(), i = 0; while (i < mix.length - 1 && (x -= mix[i]) > 0) i++; return i; };
const RNGN = { Inside: 1, Mid: 2, Long: 3 };
const rangeFromWords = (a) => { const to = / to (Inside|Mid|Long)$/.exec(a || ''); if (to) return RNGN[to[1]]; const st = /^stays (Inside|Mid|Long)$/.exec(a || ''); return st ? RNGN[st[1]] : null; };

function emptyLead() { return { jab: 0, bjab: 0, feint: 0, high: 0, low: 0, other: 0, total: 0 }; }
function boutsLong(R, n) {
  const { N, ACT, man, cost, resolve, endBeat } = R, rnd = R.rnd;
  if (!R.OPPS[3]) R.OPPS.push({ n: 'mirror', hp: N.hp, read: 0, like: [], lean: 0 });
  R.setOpp(3);
  const o = { n, beats: 0, longStart: 0, nothingThrownLong: 0, longPts: [0, 0], longDmg: [0, 0], longPtsStart: [0, 0],
    longPtsByPunch: {}, longDmgByPunch: {}, stepTried: [0, 0], stepGotIn: [0, 0], stepStopped: [0, 0], stepFencePaid: [0, 0], stepFenceCond: [0, 0],
    leadLong: emptyLead(), leadLongYou: emptyLead(), leadLongHe: emptyLead(), rounds: 0, outfighterRounds: 0, outfighterYou: 0, outfighterHe: 0,
    firstStepBeats: [], firstStepNoStepRounds: 0, arrivalStSum: [0, 0], arrivalN: [0, 0], leadHighAll: 0, manBeatsAll: 0,
    rngAfter: [0, 0, 0, 0], rngStart: [0, 0, 0, 0], ko: 0, lost: 0, w: 0, draw: 0, kd: [0, 0], jabAll: 0, bjabAll: 0, stepInAll: 0, clinchAll: 0 };
  const classifyLead = (bucket, plan) => { bucket.total++; if (plan.lead === 'jab') bucket.jab++; else if (plan.lead === 'bjab') bucket.bjab++; else if (plan.lead === 'feint') bucket.feint++; else if (!plan.lead && plan.hl === 'high') bucket.high++; else if (!plan.lead && plan.hl === 'low') bucket.low++; else bucket.other++; };
  for (let b = 0; b < n; b++) {
    const S = { f: [man(N.hp), man(R.opp().hp)], range: 3 }; let done = false; const t = [0, 0];
    for (let r = 0; r < N.rounds && !done; r++) {
      S.range = 3; for (const m of S.f) { m.pts = 0; m.st = m.cap; m.g = N.guard; m.ropes = 0; m.held = 0; m.kept = 0; m.gave = 0; }
      let firstStep = null; const roundLongPts = [0, 0];
      for (let i = 0; i < N.beats && !done; i++) {
        S.t = N.beats - i; const rangeStart = S.range;
        const z = R.solveBeat(S, S.t, { iters: 400 }); const mine = z.A[drawAt(z.p, rnd)], his = z.B[drawAt(z.q, rnd)];
        const plans = [{ ...mine }, { ...his }];
        o.beats++; o.rngStart[rangeStart]++; o.manBeatsAll += 2;
        for (const k of [0, 1]) { const p = plans[k]; if (!p.lead && p.hl === 'high' && !p.clinch) o.leadHighAll++; if (p.lead === 'jab') o.jabAll++; if (p.lead === 'bjab') o.bjabAll++; if (p.feet === 'in') o.stepInAll++; if (p.clinch) o.clinchAll++; }
        if (firstStep === null && plans.some((p) => p.feet === 'in')) firstStep = i;
        const isLongStart = rangeStart === 3;
        if (isLongStart) {
          o.longStart++;
          if (plans.every((p) => !p.lead && !p.rear && !p.clinch)) o.nothingThrownLong++;
          classifyLead(o.leadLong, plans[0]); classifyLead(o.leadLongYou, plans[0]); classifyLead(o.leadLong, plans[1]); classifyLead(o.leadLongHe, plans[1]);
        }
        const stBefore = [S.f[0].st, S.f[1].st], hpBefore = [S.f[0].hp, S.f[1].hp];
        const ev = resolve(S, plans); const rangeAfter = S.range; const stAfterResolve = [S.f[0].st, S.f[1].st];
        endBeat(S); o.rngAfter[rangeAfter]++;
        // points/health while at Long, rebuilt moment by moment from the range events
        let curRange = rangeStart; const bodyHitOn = [false, false];
        for (const e of ev) {
          if (e.t === 'range') { const nr = rangeFromWords(e.a); if (nr) curRange = nr; continue; }
          if (e.t === 'hit' && e.id && ACT[e.id] && ACT[e.id].body) bodyHitOn[1 - e.k] = true;
          if (e.t === 'hit' && e.id) {
            if (isLongStart) o.longPtsStart[e.k] += e.pts || 0;
            if (curRange === 3) {
              o.longPts[e.k] += e.pts || 0; o.longDmg[e.k] += e.dmg || 0; roundLongPts[e.k] += e.pts || 0;
              const q = o.longPtsByPunch[e.id] = o.longPtsByPunch[e.id] || { pts: 0, dmg: 0, hits: 0 }; q.pts += e.pts || 0; q.dmg += e.dmg || 0; q.hits++;
              const d = o.longDmgByPunch[e.id] = o.longDmgByPunch[e.id] || { pts: 0, dmg: 0, hits: 0 }; d.pts += e.pts || 0; d.dmg += e.dmg || 0; d.hits++;
            }
          }
        }
        // step in from Long
        if (isLongStart) for (const k of [0, 1]) {
          if (plans[k].feet !== 'in') continue;
          o.stepTried[k]++; const gotIn = rangeAfter < 3; if (gotIn) { o.stepGotIn[k]++; o.arrivalStSum[k] += stAfterResolve[k]; o.arrivalN[k]++; }
          if (ev.some((e) => e.t === 'hit' && /stops (him|you): still at Long/.test(e.o || ''))) o.stepStopped[k]++;
          const opp = plans[1 - k]; if (!opp.lead && opp.hl === 'high') o.stepFenceCond[k]++;
          const tax = stBefore[k] - cost(plans[k]) - stAfterResolve[k];
          if (tax >= 1 && !bodyHitOn[k]) o.stepFencePaid[k]++;
        }
        for (const k of [0, 1]) if (S.f[k].hp <= 0) { S.f[k].kd++; o.kd[k]++; S.f[1 - k].pts += 3; if (S.f[k].kd > N.kd.length) { if (k === 1) { o.w++; o.ko++; } else o.lost++; done = true; break; } S.f[k].hp = N.kd[S.f[k].kd - 1]; }
      }
      if (firstStep === null) o.firstStepNoStepRounds++; else o.firstStepBeats.push(firstStep);
      if (!done) {
        const [x, y] = S.f, lvl = x.pts === y.pts, g = lvl && N.even ? Math.sign((y.gave || 0) - (x.gave || 0)) : 0;
        o.rounds++; const winner = x.pts > y.pts || (lvl && g >= 0) ? 0 : 1, loser = 1 - winner;
        if (roundLongPts[winner] > S.f[loser].pts) { o.outfighterRounds++; if (winner === 0) o.outfighterYou++; else o.outfighterHe++; }
        t[0] += x.pts > y.pts || (lvl && g >= 0) ? 10 : 9; t[1] += y.pts > x.pts || (lvl && g <= 0) ? 10 : 9;
      }
    }
    if (!done) { if (t[0] > t[1]) o.w++; else if (t[0] === t[1]) o.draw++; }
  }
  return o;
}
const merge = (a, b) => { if (!a) return b; for (const k in b) { if (k === 'firstStepBeats') { a[k] = a[k].concat(b[k]); continue; } if (typeof b[k] === 'number') a[k] = (a[k] || 0) + b[k]; else if (Array.isArray(b[k]) && typeof b[k][0] === 'number') b[k].forEach((x, i) => { a[k][i] += x; }); else if (Array.isArray(b[k])) b[k].forEach((x, i) => { a[k][i] = merge(a[k][i], x); }); else a[k] = merge(a[k] || {}, b[k]); } return a; };
if (!isMainThread && workerData && workerData.probeLong) { const { tweak, table, n, seed } = workerData; parentPort.postMessage(boutsLong(loadTweaked(seed, tweak, table), n)); }
async function playLong(tweak, table, n, seed, jobs) { if (jobs <= 1) return boutsLong(loadTweaked(seed, tweak, table), n); const self = fileURLToPath(import.meta.url), each = Math.ceil(n / jobs);
  const got = await Promise.all(Array.from({ length: jobs }, (_, i) => new Promise((ok, bad) => { const w = new Worker(self, { workerData: { probeLong: 1, tweak: tweak || null, table, n: each, seed: seed * 100 + i } }); w.once('message', ok); w.once('error', bad); })));
  return got.reduce(merge, null); }
function report(o, R) { const pc = (x) => (100 * x).toFixed(0) + '%', f1 = (x) => x.toFixed(1), f2 = (x) => x.toFixed(2), L = [], n = o.n;
  const sorted = [...o.firstStepBeats].sort((a, b) => a - b), meanFirst = sorted.length ? sorted.reduce((s, x) => s + x, 0) / sorted.length : 0, medFirst = sorted.length ? sorted[Math.floor(sorted.length / 2)] : 0;
  const byPunch = Object.keys(o.longPtsByPunch).sort((a, b) => o.longPtsByPunch[b].pts - o.longPtsByPunch[a].pts).map((id) => `${R.ACT[id].n} ${o.longPtsByPunch[id].hits} hits, ${f1(o.longPtsByPunch[id].pts / n)} pts, ${f1(o.longPtsByPunch[id].dmg / n)} health a bout`).join('; ') || 'none';
  L.push(`PROBE_LONG n=${n}: beats ${o.beats} (${f1(o.beats / n)} a bout); ranges at beat START Inside/Mid/Long ${pc(o.rngStart[1] / o.beats)} / ${pc(o.rngStart[2] / o.beats)} / ${pc(o.rngStart[3] / o.beats)}; ranges AFTER the beat (balance's count) ${pc(o.rngAfter[1] / o.beats)} / ${pc(o.rngAfter[2] / o.beats)} / ${pc(o.rngAfter[3] / o.beats)}`);
  L.push(`beats that START at Long: ${o.longStart} (${f1(o.longStart / n)} a bout, ${pc(o.longStart / o.beats)} of all beats); of them NOTHING thrown by either man ${o.nothingThrownLong} (${pc(o.nothingThrownLong / Math.max(o.longStart, 1))})`);
  L.push(`punches landing WHILE at Long: points a bout you ${f1(o.longPts[0] / n)} v he ${f1(o.longPts[1] / n)} (pooled ${f1((o.longPts[0] + o.longPts[1]) / n)}); health taken a bout you ${f1(o.longDmg[0] / n)} v he ${f1(o.longDmg[1] / n)} (pooled ${f1((o.longDmg[0] + o.longDmg[1]) / n)}); by punch: ${byPunch}`);
  L.push(`cross-check, points in beats that STARTED at Long (any moment): you ${f1(o.longPtsStart[0] / n)} v he ${f1(o.longPtsStart[1] / n)} (pooled ${f1((o.longPtsStart[0] + o.longPtsStart[1]) / n)} a bout)`);
  const tried = o.stepTried[0] + o.stepTried[1], got = o.stepGotIn[0] + o.stepGotIn[1];
  L.push(`step in from Long: tried a bout you ${f1(o.stepTried[0] / n)} v he ${f1(o.stepTried[1] / n)} (pooled ${f1(tried / n)}); got in (end the beat closer than Long) ${pc(got / Math.max(tried, 1))} (you ${pc(o.stepGotIn[0] / Math.max(o.stepTried[0], 1))}, he ${pc(o.stepGotIn[1] / Math.max(o.stepTried[1], 1))}); stopped by the jab a bout you ${f1(o.stepStopped[0] / n)} v he ${f1(o.stepStopped[1] / n)} (pooled ${f1((o.stepStopped[0] + o.stepStopped[1]) / n)}); paid the fence tax a bout you ${f1(o.stepFencePaid[0] / n)} v he ${f1(o.stepFencePaid[1] / n)} (pooled ${f1((o.stepFencePaid[0] + o.stepFencePaid[1]) / n)}); fence condition met (opponent lead held high) a bout pooled ${f1((o.stepFenceCond[0] + o.stepFenceCond[1]) / n)}`);
  const ll = o.leadLong, share = (x) => pc(x / Math.max(ll.total, 1));
  L.push(`lead hand at Long (man-beats ${ll.total}): jab ${share(ll.jab)}, body jab ${share(ll.bjab)}, feint ${share(ll.feint)}, held high ${share(ll.high)}, held low ${share(ll.low)}, other ${share(ll.other)}; you: jab ${pc(o.leadLongYou.jab / Math.max(o.leadLongYou.total, 1))}, body jab ${pc(o.leadLongYou.bjab / Math.max(o.leadLongYou.total, 1))}, feint ${pc(o.leadLongYou.feint / Math.max(o.leadLongYou.total, 1))}, high ${pc(o.leadLongYou.high / Math.max(o.leadLongYou.total, 1))}, low ${pc(o.leadLongYou.low / Math.max(o.leadLongYou.total, 1))}; he: jab ${pc(o.leadLongHe.jab / Math.max(o.leadLongHe.total, 1))}, body jab ${pc(o.leadLongHe.bjab / Math.max(o.leadLongHe.total, 1))}, feint ${pc(o.leadLongHe.feint / Math.max(o.leadLongHe.total, 1))}, high ${pc(o.leadLongHe.high / Math.max(o.leadLongHe.total, 1))}, low ${pc(o.leadLongHe.low / Math.max(o.leadLongHe.total, 1))}`);
  L.push(`outfighter's rounds: ${o.outfighterRounds} of ${o.rounds} completed rounds (${pc(o.outfighterRounds / Math.max(o.rounds, 1))}, ${f2(o.outfighterRounds / n)} a bout; you ${o.outfighterYou}, he ${o.outfighterHe})`);
  L.push(`first step in of a round: mean ${f2(meanFirst)} beats before it (median ${medFirst}), over ${sorted.length} rounds with a step in; ${o.firstStepNoStepRounds} rounds with none; distribution beats-before: ${[0, 1, 2, 3, 4, 5].map((i) => `${i}:${sorted.filter((x) => x === i).length}`).join(' ')}`);
  L.push(`stamina on arrival at Mid (after the step beat, before recovery): you ${o.arrivalN[0] ? f2(o.arrivalStSum[0] / o.arrivalN[0]) : '-'} over ${o.arrivalN[0]} arrivals, he ${o.arrivalN[1] ? f2(o.arrivalStSum[1] / o.arrivalN[1]) : '-'} over ${o.arrivalN[1]}; lead held high share of ALL man-beats ${pc(o.leadHighAll / Math.max(o.manBeatsAll, 1))}; jab in ${pc(o.jabAll / Math.max(o.manBeatsAll, 1))} of all man-beats, body jab ${pc(o.bjabAll / Math.max(o.manBeatsAll, 1))}, step in ${pc(o.stepInAll / Math.max(o.manBeatsAll, 1))}`);
  L.push(`bout: wins ${pc(o.w / n)}, stops ${pc((o.ko + o.lost) / n)} (ko ${o.ko}, lost ${o.lost}), draws ${pc(o.draw / n)}, knockdowns a bout ${f1((o.kd[0] + o.kd[1]) / n)}`);
  return L.join('\n'); }
const isMain = isMainThread && import.meta.url === pathToFileURL(process.argv[1] || '').href;
if (isMain) { const arg = (k, d) => { const a = process.argv.find((x) => x.startsWith(k + '=')); return a ? a.split('=').slice(1).join('=') : d; };
  const tweak = readTweak(arg('tweak', '')), table = arg('table', '') || undefined, n = Number(arg('n', 84)), seed = Number(arg('seed', 1)), jobs = Number(arg('jobs', 1));
  const R = loadTweaked(1, tweak, table || undefined), t0 = Date.now(), o = await playLong(tweak, table, n, seed, jobs);
  console.log(`# node proto/twohands/tools/probe_long.mjs tweak=${arg('tweak', '(none)')} table=${arg('table', '(page)')} n=${n} seed=${seed} jobs=${jobs}`);
  console.log(report(o, R) + `\n  (${o.n} bouts, ${((Date.now() - t0) / 1000).toFixed(0)} s)`); }
