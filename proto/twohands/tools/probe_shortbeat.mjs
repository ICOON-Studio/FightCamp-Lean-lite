// SHORTBEAT1 counting copy of balance.mjs play: same choice, random calls, resolution and workers.
// Compare its standard report with balance.mjs play at identical seed, n and jobs.
import fs from 'node:fs';
import { fileURLToPath, pathToFileURL } from 'node:url';
import { Worker, isMainThread, parentPort, workerData } from 'node:worker_threads';
import { loadTweaked, readTweak, report, bars } from './balance.mjs';
function bouts(R, who, opp, n) { const { N, ACT, plan0, man, cost, resolve, endBeat } = R, rnd = R.rnd, mirror = opp === 'mirror';
  if (mirror) { if (!R.OPPS[3]) R.OPPS.push({ n: 'mirror', hp: N.hp, read: 0, like: [], lean: 0 }); R.setOpp(3); } else R.setOpp(opp);
  const o = { n, w: 0, draw: 0, ko: 0, lost: 0, beats: 0, clinch: 0, rng: [0, 0, 0, 0], use: [{}, {}], pun: [{}, {}], np: [[0, 0, 0], [0, 0, 0]], dmg: [0, 0], first: {}, ordered: 0, kd: [0, 0], lvl: [0, 0, 0] };   // lvl: rounds scored, level on points, of those given to the man who backed off less (N.even, S556)
  o.open = { rounds: 0, acts: [0, 0, 0, 0], plans: {}, actions: {}, bothHold: 0, range: [0, 0, 0, 0], dmg: 0, spent: 0, roundDamage: 0, singleStep: 0, stepWin: 0, stepDraw: 0, stoppedRound: 0, jab: 0, punches: 0 };
  const sensible = (S) => { const me = S.f[0], he = S.f[1], g0 = he.last || plan0(), guess = cost(g0) <= he.st ? g0 : { ...plan0(), hl: g0.hl, hr: g0.hr }; let best = plan0(), bv = -1e9;
    for (const c of R.plansFor(S, 0)) { if (c.clinch) continue; const T = { range: S.range, f: S.f.map((m) => ({ ...m, hist: [] })) }; resolve(T, [{ ...c }, { ...guess, clinch: false }]);
      const v = (he.hp - T.f[1].hp) - (me.hp - T.f[0].hp) + 0.25 * T.f[0].st + rnd() * 0.5; if (v > bv) { bv = v; best = c; } }
    return best; };
  const note = (k, c) => { const u = o.use[k], add = (x) => { u[x] = (u[x] || 0) + 1; }; if (c.clinch) return add('clinch'); add(c.lead || 'lead held ' + c.hl); add(c.rear || 'rear held ' + c.hr); add(c.feet === 'hold' ? 'feet hold' : c.feet === 'in' ? 'step in' : c.feet === 'back' ? 'back off' : c.feet);   // S559: a kick or a check counted as itself
    o.np[k][(c.lead && ACT[c.lead].d ? 1 : 0) + (c.rear ? 1 : 0)]++; if (k === 0 && c.ord && c.ord.length > 1) { o.ordered++; o.first[c.ord[0]] = (o.first[c.ord[0]] || 0) + 1; } };
  for (let b = 0; b < n; b++) { const S = { f: [man(N.hp), man(R.opp().hp)], range: 3 }; let done = false; const t = [0, 0];
    for (let r = 0; r < N.rounds && !done; r++) { S.range = 3; for (const m of S.f) { m.pts = 0; m.st = m.cap; m.g = N.guard; m.ropes = 0; m.held = 0; m.kept = 0; m.gave = 0; }
      let stepper = -1;
      for (let i = 0; i < N.beats && !done; i++) { S.t = N.beats - i; let mine, his;
        if (who === 'mix') { const z = R.solveBeat(S, S.t, { iters: 400 }); mine = z.A[drawAt(z.p, rnd)]; his = mirror ? z.B[drawAt(z.q, rnd)] : null; }
        else if (who === 'random') { const A = R.plansFor(S, 0); mine = A[Math.floor(rnd() * A.length)]; } else mine = sensible(S);
        if (!his) his = R.ai(S);
        note(0, mine); note(1, his);
        const hp = [S.f[0].hp, S.f[1].hp], st = S.f.map(m => m.st);
        if (i === 0) { const ps = [mine, his], a = ps.map(p => p.clinch ? 1 : Number(!!p.lead) + Number(!!p.rear) + Number(p.feet !== 'hold'));
          o.open.rounds++; for (let k = 0; k < 2; k++) { o.open.acts[a[k]]++; const key = R.planWords(ps[k]); o.open.plans[key] = (o.open.plans[key] || 0) + 1; const action = ps[k].clinch ? 'clinch' : R.ordOf(ps[k]).map(slot => slot === 'feet' ? ps[k].feet : ps[k][slot]).join('>') || 'hold'; o.open.actions[action] = (o.open.actions[action] || 0) + 1; }
          if (a[0] === 0 && a[1] === 0) o.open.bothHold++;
          const steps = ps.map(p => !p.clinch && p.feet === 'in'); if (steps[0] !== steps[1]) stepper = steps[0] ? 0 : 1; }
        const ev = resolve(S, [{ ...mine }, { ...his }]);
        const damage = hp[0] - S.f[0].hp + hp[1] - S.f[1].hp;
        o.open.roundDamage += damage;
        if (i === 0) { o.open.range[S.range]++; o.open.dmg += damage; o.open.spent += st[0] - S.f[0].st + st[1] - S.f[1].st; }
        for (const e of ev) if (e.id && ACT[e.id]?.d && ['hit','block','miss'].includes(e.t)) { o.open.punches++; if (e.id === 'jab' || e.id === 'bjab') o.open.jab++; }
        endBeat(S); o.beats++; o.rng[S.range]++; o.dmg[0] += hp[1] - S.f[1].hp; o.dmg[1] += hp[0] - S.f[0].hp;
        for (const e of ev) { if (e.t === 'clinch') o.clinch++; if (e.id && (e.t === 'hit' || e.t === 'block' || e.t === 'miss')) { const q = o.pun[e.k][e.id] = o.pun[e.k][e.id] || { hit: 0, block: 0, miss: 0 }; q[e.t]++; } }
        for (const k of [0, 1]) if (S.f[k].hp <= 0) { S.f[k].kd++; o.kd[k]++; S.f[1 - k].pts += 3; if (S.f[k].kd > N.kd.length) { if (k === 1) { o.w++; o.ko++; } else o.lost++; done = true; break; } S.f[k].hp = N.kd[S.f[k].kd - 1]; } }
      if (done && stepper !== -1) o.open.stoppedRound++;
      if (!done) { const [x, y] = S.f, lvl = x.pts === y.pts, g = lvl && N.even ? Math.sign((y.gave || 0) - (x.gave || 0)) : 0;   // g > 0: he backed off more, the level round is yours (a tweak counts gave on the page's back off)
        if (stepper !== -1) { o.open.singleStep++; const cmp = Math.sign(x.pts - y.pts) || g; if (!cmp) o.open.stepDraw++; else if ((cmp > 0 ? 0 : 1) === stepper) o.open.stepWin++; }
        o.lvl[0]++; if (lvl) o.lvl[1]++; if (g) o.lvl[2]++; t[0] += x.pts > y.pts || (lvl && g >= 0) ? 10 : 9; t[1] += y.pts > x.pts || (lvl && g <= 0) ? 10 : 9; } }
    if (!done) { if (t[0] > t[1]) o.w++; else if (t[0] === t[1]) o.draw++; } }
  return o; }
const drawAt = (mix, rnd) => { let x = rnd(), i = 0; while (i < mix.length - 1 && (x -= mix[i]) > 0) i++; return i; };
const merge = (a, b) => { if (!a) return b; for (const k in b) { if (typeof b[k] === 'number') a[k] = (a[k] || 0) + b[k]; else if (Array.isArray(b[k]) && typeof b[k][0] === 'number') b[k].forEach((x, i) => { a[k][i] += x; }); else if (Array.isArray(b[k])) b[k].forEach((x, i) => { a[k][i] = merge(a[k][i], x); }); else a[k] = merge(a[k] || {}, b[k]); } return a; };
if (!isMainThread && workerData && workerData.shortbeat) { const { tweak, table, who, opp, n, seed } = workerData; parentPort.postMessage(bouts(loadTweaked(seed, tweak, table), who, opp, n)); }
export async function play(who, opp, n, o = {}) { const jobs = o.jobs || 7, self = fileURLToPath(import.meta.url), each = Math.ceil(n / jobs);
  const got = await Promise.all(Array.from({ length: jobs }, (_, i) => new Promise((ok, bad) => { const w = new Worker(self, { workerData: { shortbeat: 1, tweak: o.tweak || null, table: o.table, who, opp, n: each, seed: (o.seed || 1) * 100 + i } }); w.once('message', ok); w.once('error', bad); })));
  return got.reduce(merge, null); }

if (isMainThread && import.meta.url === pathToFileURL(process.argv[1] || '').href) {
 const arg = (k,d) => { const x=process.argv.find(y=>y.startsWith(k+'=')); return x ? x.slice(k.length+1) : d; };
 const tweak=readTweak(arg('tweak','')), table=arg('table','') || undefined, n=+arg('n',84), jobs=+arg('jobs',2), seed=+arg('seed',1), who='mix', op=arg('opp','mirror'), opp=op==='mirror'?op:+op, start=Date.now();
 const R=loadTweaked(1,tweak,table), o=await play(who,opp,n,{tweak,table,jobs,seed}), x=o.open;
 const pc=(a,b) => b ? (100*a/b).toFixed(2)+'%' : 'n/a';
 console.log(`SHORTBEAT COUNT who=${who} opp=${op} n=${n} seed=${seed} jobs=${jobs} tweak=${arg('tweak','none')} table=${table || 'page'}`);
 console.log(report(R,who,opp,o)); if (op==='mirror') console.log(bars(R,o));
 console.log('OPEN '+JSON.stringify(x));
 console.log(`OPEN ${x.rounds} rounds, fighter plans 0/1/2/3: ${x.acts.map(a=>pc(a,2*x.rounds)).join(' / ')}; both hold ${pc(x.bothHold,x.rounds)}; range Inside/Mid/Long ${x.range.slice(1).map(a=>pc(a,x.rounds)).join(' / ')}; health dealt ${ (x.dmg/x.rounds).toFixed(3)} and stamina spent ${(x.spent/x.rounds).toFixed(3)} per round (both men); health/started round ${(x.roundDamage/x.rounds).toFixed(3)}; lone-stepper wins ${x.stepWin}/${x.singleStep} scored rounds (${pc(x.stepWin,x.singleStep)}), draws ${x.stepDraw}, stopped excluded ${x.stoppedRound}; jab share ${pc(x.jab,x.punches)} (${x.jab}/${x.punches})`);
 console.log('TOP OPEN ACTIONS (ignoring guards) '+Object.entries(x.actions).sort((a,b)=>b[1]-a[1]).map(([p,c])=>`${p}: ${c} (${pc(c,2*x.rounds)})`).join(' | '));
 console.log('TOP OPEN PLANS '+Object.entries(x.plans).sort((a,b)=>b[1]-a[1]).map(([p,c])=>`${p}: ${c} (${pc(c,2*x.rounds)})`).join(' | '));
 console.log(`(${o.n} bouts, ${((Date.now()-start)/1000).toFixed(0)} s)`);
 if(arg('json','')) fs.writeFileSync(arg('json',''),JSON.stringify(o));
}
