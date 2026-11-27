// BUILD1 greybox probe (S570): the fighter's body as a ship - a build = the cards his body holds + three pools
// (attack, defence, conditioning) on a 50..100 scale, 100 = today's man on order.html. Reads the page's rules through
// rules.mjs; the page is NOT edited: four small patches are made in memory only (per-man deck filter, spend cap a beat,
// guard bar size, stamina floor), plus an optional link (health caps the stamina bar, RULES569 idea 3) for the comeback check.
// Both men play the beat's solved mix (solveBeat), the look-ahead is today's vtable.json (made for two equal full-deck men:
// an approximation for unequal builds, said in the result).
//   node build1_probe.mjs a=<build> b=<build> n=12 seed=1 [hcap=1] [jobs=1] [json=<out>]
//   build = DECK:C:A:D   DECK in out|pres|full ; C conditioning, A attack, D defence (50..100)
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';
import { Worker, isMainThread, parentPort, workerData } from 'node:worker_threads';
const here = path.dirname(fileURLToPath(import.meta.url));
const TOOLS = path.resolve(here, '..', '..', '..', 'proto', 'twohands', 'tools');
const { load } = await import(pathToFileURL(path.join(TOOLS, 'rules.mjs')).href);

// every body holds the BASE cards (jab, cross, the guard, the feet: the basics a coach teaches in week one, like the two
// free blocks in Mixed Martial Cards); a build adds 3 discipline cards (its slots at the start of a career) and drills one
// card (a drilled card: +1 damage, or 1 less stamina).
export const DRILL = { jab_d: ['jab', { d: 2, n: 'Jab (drilled)' }], hook_d: ['hook', { st: 1, n: 'Lead hook (drilled)' }], cross_d: ['cross', { d: 4, n: 'Cross (drilled)' }], lbody_d: ['lbody', { d: 3, n: 'Body hook (drilled)' }] };
// v2 (after v1: the generalist beat both specialists, the defence pool bought nothing): a LEGS card per style and the
// generalist pays for breadth with no drill. Legs cards: 'stalk' = he may step in even after your jab landed (cuts the
// ring off); 'craft' = he may back off once more on the ropes (ring craft).
export const LEGS = { out2: 'craft', pres2: 'stalk' };
export const DECKS = {
  out: ['jab_d', 'cross', 'bjab', 'feint', 'rbody'],          // outboxer: the lead hand is the weapon, the body jab and the feint, the body cross
  pres: ['jab', 'cross', 'hook_d', 'lbody', 'clinch'],        // pressure fighter: the hook drilled cheap, the body hook, the clinch
  ctr: ['jab', 'cross_d', 'hook', 'bjab', 'rbody'],           // the generalist control: same budget (3 cards + 1 drill)
  out2: ['jab_d', 'cross', 'bjab', 'feint', 'rbody'],
  pres2: ['jab', 'cross', 'hook', 'lbody_d', 'clinch'],
  gen2: ['jab', 'cross', 'hook', 'bjab', 'rbody', 'over'],     // 4 cards, no drill, no legs card
  full: ['jab', 'bjab', 'hook', 'lup', 'lbody', 'feint', 'push', 'cross', 'over', 'rup', 'rbody', 'clinch'],   // today's page: every card, no drill
};
const PATCH = [
  ['const c0 = { ...plan0(), ...lo, ...ro, feet };', 'const c0 = { ...plan0(), ...lo, ...ro, feet }; if (me.deck && ((c0.lead && !me.deck.includes(c0.lead)) || (c0.rear && !me.deck.includes(c0.rear)))) continue;'],
  ['if (cost(c0) > me.st ||', 'if (cost(c0) > Math.min(me.st, me.spend ?? 99) ||'],
  ['if (S.range <= 1 && !me.held && me.st >= 1)', 'if (S.range <= 1 && !me.held && me.st >= 1 && (!me.deck || me.deck.includes(\'clinch\')))'],
  ['D.cap = Math.max(N.capMin, D.cap - 1)', 'D.cap = Math.max(D.capMin ?? N.capMin, D.cap - 1)'],
  ['m.g = Math.min(N.guard, m.g + N.grec)', 'm.g = Math.min(m.gmax ?? N.guard, m.g + N.grec)'],
  ['D.hp -= dmg;', 'D.hp -= dmg * (A.pw ?? 1) / (D.ab ?? 1);'],
  ["(feet === 'back' && me.ropes >= 2) || (feet === 'in' && me.kept)", "(feet === 'back' && me.ropes >= (me.legs === 'craft' ? 3 : 2)) || (feet === 'in' && me.kept && me.legs !== 'stalk')"],
];
export function rules(seed) { const R = load(seed, 'order.html', (s) => { s = s.replace(/\r\n/g, '\n'); for (const [a, b] of PATCH) { if (!s.includes(a)) throw new Error('patch not on the page: ' + a); s = s.replace(a, b); } return s; });
  for (const id in DRILL) { const [base, mod] = DRILL[id]; R.setAct(id, { ...R.ACT[base], ...mod }); if (R.ACT[base].h) R.RO.push({ rear: id, hr: 'high' }); else R.LO.push({ lead: id, hl: 'high' }); }
  return R; }
export let DEF2 = 0;   // def=2: the defence pool also takes the weight out of the punches that land (a mirror of attack's weight)
export function setDef(x) { DEF2 = x; }
export function parse(b) { const [deck, C, A, D] = b.split(':'); return { deck, C: +C, A: +A, D: +D }; }
// the 50..100 scale to the engine: 100 = today's man (health 18, stamina 8, spend up to 6 a beat = no cap, guard 6, floor 4)
// the 50..100 scale to the engine: 75 = today's man on order.html (health 18, stamina 8, spend up to 6 a beat, guard 6,
// punches at full weight). Conditioning C: health and the stamina bar; attack A: stamina you may spend in one beat and
// the weight of your punches; defence D: the guard bar. The stamina bar stops at 8 (the look-ahead table's top).
export function makeMan(R, b) { const { N } = R, m = R.man(Math.round(N.hp * b.C / 75));
  m.cap = m.st = m.cap0 = Math.min(N.st, Math.max(3, Math.round(N.st * b.C / 75))); m.capMin = Math.min(m.cap, Math.max(2, Math.round(N.capMin * b.C / 75)));
  m.spend = Math.min(6, Math.max(3, Math.round(6 * b.A / 75))); m.pw = b.A / 75; m.gmax = m.g = Math.max(2, Math.round(N.guard * b.D / 75));
  m.deck = DECKS[b.deck]; m.legs = LEGS[b.deck] || null; if (DEF2) m.ab = b.D / 75; m.kdUp = N.kd.map((x) => Math.max(1, Math.round(x * m.max / N.hp))); return m; }

const SW = (c, ACT) => { const o = []; if (c.clinch) return ['clinch']; o.push(c.lead || 'lead held ' + c.hl, c.rear || 'rear held ' + c.hr, c.feet === 'hold' ? 'feet hold' : c.feet === 'in' ? 'step in' : 'back off'); return o; };
const drawAt = (mix, rnd) => { let x = rnd(), i = 0; while (i < mix.length - 1 && (x -= mix[i]) > 0) i++; return i; };
function bouts(seed, A, B, n, hcap) { const R = rules(seed), { N, resolve, endBeat, ACT } = R, rnd = R.rnd;
  if (!R.OPPS[3]) R.OPPS.push({ n: 'mirror', hp: N.hp, read: 0, like: [], lean: 0 }); R.setOpp(3);
  const o = { n, w: 0, l: 0, draw: 0, ko: 0, lost: 0, beats: 0, kd: [0, 0], dmg: [0, 0], use: [{}, {}], np: [[0, 0, 0], [0, 0, 0]], rng: [0, 0, 0, 0], clinch: 0, behind1: 0, comeback: 0, stEnd: [0, 0], stN: 0, plans: [0, 0] };
  for (let b = 0; b < n; b++) { const S = { f: [makeMan(R, A), makeMan(R, B)], range: 3 }; let done = false; const t = [0, 0]; let behind = -1;
    for (let r = 0; r < N.rounds && !done; r++) { S.range = 3; for (const m of S.f) { m.pts = 0; m.st = m.cap; m.g = m.gmax; m.ropes = 0; m.held = 0; m.kept = 0; m.gave = 0; }
      for (let i = 0; i < N.beats && !done; i++) { S.t = N.beats - i; const z = R.solveBeat(S, S.t, { iters: 400 }), mine = z.A[drawAt(z.p, rnd)], his = z.B[drawAt(z.q, rnd)]; o.plans[0] += z.A.length; o.plans[1] += z.B.length;
        [mine, his].forEach((c, k) => { for (const s of SW(c, ACT)) o.use[k][s] = (o.use[k][s] || 0) + 1; o.np[k][(c.lead && ACT[c.lead].d ? 1 : 0) + (c.rear ? 1 : 0)]++; });
        const hp = [S.f[0].hp, S.f[1].hp], ev = resolve(S, [{ ...mine }, { ...his }]); endBeat(S); o.beats++; o.rng[S.range]++; o.dmg[0] += hp[1] - S.f[1].hp; o.dmg[1] += hp[0] - S.f[0].hp;
        if (hcap) for (const m of S.f) { let c = Math.max(m.capMin, Math.ceil(m.cap0 * Math.max(0, m.hp) / m.max)); if (hcap === 2) c = Math.max(c, m.cap0 - 2); if (c < m.cap) { m.cap = c; m.st = Math.min(m.st, c); } }   // hcap 2: the link takes at most 2 off the bar
        for (const e of ev) if (e.t === 'clinch') o.clinch++;
        for (const k of [0, 1]) if (S.f[k].hp <= 0) { S.f[k].kd++; o.kd[k]++; S.f[1 - k].pts += 3; if (S.f[k].kd > N.kd.length) { if (k === 1) { o.w++; o.ko++; } else { o.l++; o.lost++; } done = true; break; } S.f[k].hp = S.f[k].kdUp[S.f[k].kd - 1]; } }
      if (r === 0 && !done) { const d0 = S.f[0].hp / S.f[0].max - S.f[1].hp / S.f[1].max; behind = Math.abs(d0) >= 0.15 ? (d0 < 0 ? 0 : 1) : -1; }
      if (!done) { const [x, y] = S.f, j = R.judge(x, y); t[0] += j.sc[0]; t[1] += j.sc[1]; } }
    for (const k of [0, 1]) o.stEnd[k] += S.f[k].st; o.stN++;
    let win = -1; if (done) win = S.f[1].kd > N.kd.length ? 0 : 1; else { if (t[0] > t[1]) { o.w++; win = 0; } else if (t[1] > t[0]) { o.l++; win = 1; } else o.draw++; }
    if (behind >= 0) { o.behind1++; if (win === behind) o.comeback++; } }
  return o; }
const merge = (a, b) => { if (!a) return b; for (const k in b) { if (typeof b[k] === 'number') a[k] += b[k]; else if (Array.isArray(b[k]) && typeof b[k][0] === 'number') b[k].forEach((x, i) => { a[k][i] += x; }); else if (Array.isArray(b[k])) b[k].forEach((x, i) => { for (const s in x) a[k][i][s] = (a[k][i][s] || 0) + x[s]; }); } return a; };
if (!isMainThread && workerData && workerData.b1) { const { seed, A, B, n, hcap, def } = workerData; DEF2 = def; parentPort.postMessage(bouts(seed, A, B, n, hcap)); }

export function report(o, a, b) { const pc = (x) => (100 * x).toFixed(0) + '%', L = [], nb = o.beats;
  L.push(`${a} v ${b}: wins ${pc(o.w / o.n)}, losses ${pc(o.l / o.n)}, draws ${pc(o.draw / o.n)}; stoppages ${pc((o.ko + o.lost) / o.n)} (his ${pc(o.ko / o.n)}); knockdowns a bout ${(o.kd[1] / o.n).toFixed(1)} v ${(o.kd[0] / o.n).toFixed(1)}; health taken ${(o.dmg[0] / o.n).toFixed(1)} v ${(o.dmg[1] / o.n).toFixed(1)}; Inside / Mid / Long ${[1, 2, 3].map((r) => pc(o.rng[r] / nb)).join(' / ')}; clinches ${(o.clinch / o.n).toFixed(1)}; plans a beat ${(o.plans[0] / nb).toFixed(0)} v ${(o.plans[1] / nb).toFixed(0)}; stamina at the last bell ${(o.stEnd[0] / o.stN).toFixed(1)} v ${(o.stEnd[1] / o.stN).toFixed(1)}; behind 15%+ after round 1: ${o.behind1} bouts, came back ${o.comeback} (${pc(o.comeback / Math.max(1, o.behind1))})`);
  for (const k of [0, 1]) { const u = o.use[k]; L.push(`  ${k ? 'B' : 'A'} a beat: ` + Object.keys(u).sort((x, y) => u[y] - u[x]).map((s) => `${s} ${pc(u[s] / nb)}`).join(', ') + ` | punches: none ${pc(o.np[k][0] / nb)}, one ${pc(o.np[k][1] / nb)}, two ${pc(o.np[k][2] / nb)}`); }
  const keys = new Set([...Object.keys(o.use[0]), ...Object.keys(o.use[1])]); let tv = 0; for (const s of keys) tv += Math.abs((o.use[0][s] || 0) - (o.use[1][s] || 0)) / nb; L.push(`  plan-mix distance A v B (0 = the same mix, 3 = nothing shared): ${(tv / 2).toFixed(2)}`);
  return L.join('\n'); }
const isMain = isMainThread && import.meta.url === pathToFileURL(process.argv[1] || '').href;
if (isMain) { const arg = (k, d) => { const x = process.argv.find((s) => s.startsWith(k + '=')); return x ? x.split('=').slice(1).join('=') : d; };
  const a = arg('a', 'full:100:100:100'), b = arg('b', 'full:100:100:100'), n = +arg('n', 12), seed = +arg('seed', 1), jobs = +arg('jobs', 1), hcap = +arg('hcap', 0), t0 = Date.now(), self = fileURLToPath(import.meta.url), each = Math.ceil(n / jobs);
  const got = await Promise.all(Array.from({ length: jobs }, (_, i) => new Promise((ok, bad) => { const w = new Worker(self, { workerData: { b1: 1, seed: seed * 100 + i, A: parse(a), B: parse(b), n: each, hcap, def: +arg('def', 0) } }); w.once('message', ok); w.once('error', bad); })));
  const o = got.reduce(merge, null); console.log(report(o, a, b) + `\n  (${o.n} bouts, seed ${seed}${hcap ? ', health caps stamina' + (hcap === 2 ? ' (at most 2)' : '') : ''}${+arg('def', 0) ? ', defence takes weight off' : ''}, ${((Date.now() - t0) / 1000).toFixed(0)} s)`);
  if (arg('json', '')) fs.writeFileSync(arg('json', ''), JSON.stringify(o)); }
