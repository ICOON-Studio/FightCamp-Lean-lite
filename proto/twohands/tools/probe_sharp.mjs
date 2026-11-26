// PROGP2 (S563) - THE SHARP CHOICE MEASURED: "cheaper" or "faster", for each punch (probe P2 of
// ops/research/DESIGN_PROGRESSION1.md 3b). At Sharp (mastery 60) the player picks ONE upgrade for a move, for that fighter,
// for good: "cheaper" (1 stamina less, min 1) or "faster" (one speed step: slow -> medium -> fast). Before any screen or
// critic the balance tool must say whether the choice is a real one: an upgrade that does nothing is a dead card, one that
// is always right is a clog. Today the page (order.html) gives both men ONE shared punch table (ACT: a punch's stamina and
// its speed). This probe tries PER-MAN TABLES WITHOUT touching the page: rules.mjs loads the page's rules through a patch
// (a text replacement at load time) so each man carries his own copy of the punch table as a field on the man, falling back
// to ACT - then plays whole bouts of the solved mix against itself (balance.mjs `play who=mix opp=mirror` style: both men
// draw from the beat's solveBeat), with man A and man B given DIFFERENT tables. The bouts loop is balance.mjs's mirror
// loop, read to the letter, with only the two men's creation changed; equal tables must therefore replay balance's mirror
// bout for bout (probe_sharp_test.mjs holds that). Every place the rules read a punch's stamina or speed FOR A MAN reads
// HIS table: the cost of a plan (cost, and its call sites in plansFor / resolve / ai) and who lands first in a moment
// (the speed sort and its same-speed group in resolve).
//   node proto/twohands/tools/probe_sharp.mjs a=cross:cheaper b= n=84 jobs=2 seed=1 [json=<f>]
// a= / b= take punch:up pairs (up = cheaper | faster); a missing b= is today's man. An upgrade that does nothing (the jab
// already costs 1 and is already fast) is refused with "needs its own pair" - the design already says some moves get a
// different pair. Output: wins / draws / stoppages for A, knockdowns each, the usual per-switch use for each man, the
// upgraded punch's share of beats (A v B), the two switches whose use moved most between A and B, and the stoppages bar
// (10-40%) flagged if the pair lands outside it.
// THE LOOK-AHEAD: vtable.json was built for equal men. It is used AS IT IS here - an approximation for unequal men: it
// reads both men's punches at today's numbers.
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';
import { Worker, isMainThread, parentPort, workerData } from 'node:worker_threads';
import { load } from './rules.mjs';

const here = path.dirname(fileURLToPath(import.meta.url));
export const PAGE = 'order.html';

// ---- THE PATCH. Seven text replacements on the page's rules (read through rules.mjs, the file itself is never edited).
// Each name says which text of the page is replaced. man(hp) -> man(hp, o): the o fields are the man's own attributes,
// here his own copy of the punch table (tb). cost(p) -> cost(p, m): a punch's stamina is read from the MAN's table, with
// ACT as the fallback; spdOf is the same for a punch's speed, used by the speed sort and its same-speed group in
// resolve (who lands first in a moment). The three cost call sites that act for a man pass him: plansFor (the man the
// plan is for), resolve (the man who pays), ai (the man he is reading).
const MAN_SRC = 'const man = (hp) => ({ hp, max: hp, st: N.st, cap: N.st, g: N.guard, pts: 0, kd: 0, ropes: 0, held: 0, kept: 0, last: null });';
const MAN_REP = 'const man = (hp, o) => { o = o || {}; return { hp, max: hp, st: N.st, cap: N.st, g: N.guard, tb: o.tb, pts: 0, kd: 0, ropes: 0, held: 0, kept: 0, last: null }; };';
const COST_SRC = 'const cost = (p) => (p.lead ? ACT[p.lead].st : 0) + (p.rear ? ACT[p.rear].st : 0) + FEET[p.feet].st + (p.clinch ? 1 : 0);';
const COST_REP = 'const cost = (p, m) => (p.lead ? ((m && m.tb && m.tb[p.lead]) || ACT[p.lead]).st : 0) + (p.rear ? ((m && m.tb && m.tb[p.rear]) || ACT[p.rear]).st : 0) + FEET[p.feet].st + (p.clinch ? 1 : 0);\nconst spdOf = (sh, f) => (Object.assign({}, sh.a, f[sh.k].tb && f[sh.k].tb[sh.id]).sp);';
const PLANSFOR_SRC = 'if (cost(c0) > me.st || (feet === \'back\' && me.ropes >= 2) || (feet === \'in\' && me.kept)) continue;';
const PLANSFOR_REP = 'if (cost(c0, me) > me.st || (feet === \'back\' && me.ropes >= 2) || (feet === \'in\' && me.kept)) continue;';
const RESOLVE_COST_SRC = 'f[k].st -= cost(P[k]);';
const RESOLVE_COST_REP = 'f[k].st -= cost(P[k], f[k]);';
const AI_COST_SRC = 'guess = cost(yours) <= you.st ? yours :';
const AI_COST_REP = 'guess = cost(yours, you) <= you.st ? yours :';
const SORT_SRC = 'shots.sort((x, y) => x.a.sp - y.a.sp);';
const SORT_REP = 'shots.sort((x, y) => spdOf(x, f) - spdOf(y, f));';
const GROUP_SRC = 'while (y < shots.length && shots[y].a.sp === shots[x].a.sp) y++;';
const GROUP_REP = 'while (y < shots.length && spdOf(shots[y], f) === spdOf(shots[x], f)) y++;';
export const PATTERNS = [[MAN_SRC, MAN_REP, 'man(hp): the man creator'], [COST_SRC, COST_REP, 'cost(p): a plan\'s stamina, per man'], [PLANSFOR_SRC, PLANSFOR_REP, 'plansFor: the cost check for the man the plan is for'], [RESOLVE_COST_SRC, RESOLVE_COST_REP, 'resolve: the man who pays for his plan'], [AI_COST_SRC, AI_COST_REP, 'ai: the cost of the habit he reads'], [SORT_SRC, SORT_REP, 'resolve: who lands first (the speed sort)'], [GROUP_SRC, GROUP_REP, 'resolve: the same-speed group']];
export const applyPatch = (s) => { for (const [f, r, name] of PATTERNS) { if (!s.includes(f)) throw new Error('probe_sharp: not on the page (' + name + '): ' + f.slice(0, 60)); s = s.replace(f, r); } return s; };

// ---- THE SETS. a=cross:cheaper - a man with that ONE punch upgraded; a missing key is today's value. cheaper = 1 stamina
// less (min 1: a punch that already costs 1 has no cheaper upgrade); faster = one speed step (sp 1 is fast: a fast punch has
// no faster upgrade). The table is a full copy of the page's ACT with the upgraded punch's field changed.
export const SPEED = ['', 'fast', 'medium', 'slow'];
export function setOf(R, str = '') { const o = { hp: R.N.hp, tb: null, ups: [], src: String(str) };
  if (!String(str).trim()) return o;
  const tb = {}; for (const id in R.ACT) tb[id] = { ...R.ACT[id] };
  for (const pair of String(str).split(',')) { if (!pair.trim()) continue; const [id, up] = pair.split(':');
    if (!R.ACT[id] || !R.ACT[id].d) throw new Error(`probe_sharp: not a punch with a cost or a speed to give: ${id} (${str})`);
    if (up !== 'cheaper' && up !== 'faster') throw new Error(`probe_sharp: unknown upgrade ${up} (use cheaper or faster) (${str})`);
    if (up === 'cheaper' && tb[id].st <= 1) throw new Error(`probe_sharp: the ${R.ACT[id].n} already costs 1 stamina - no cheaper upgrade, needs its own pair (${str})`);
    if (up === 'faster' && tb[id].sp <= 1) throw new Error(`probe_sharp: the ${R.ACT[id].n} is already fast - no faster upgrade, needs its own pair (${str})`);
    if (up === 'cheaper') tb[id] = { ...tb[id], st: tb[id].st - 1 }; else tb[id] = { ...tb[id], sp: tb[id].sp - 1 };
    o.ups.push({ id, up }); }
  o.tb = tb; return o; }
export const descOf = (R, o) => { if (!o.ups.length) return "today's punches (the page's table)";
  return "today's punches, " + o.ups.map((u) => { const act = R.ACT[u.id], t = o.tb[u.id];
    return act.n + ' ' + (u.up === 'cheaper' ? 'cheaper (' + act.st + ' -> ' + t.st + ' stamina)' : 'faster (' + SPEED[act.sp] + ' -> ' + SPEED[t.sp] + ')'); }).join(', '); };

const drawAt = (mix, rnd) => { let x = rnd(), i = 0; while (i < mix.length - 1 && (x -= mix[i]) > 0) i++; return i; };   // as balance.mjs
const nameOf = (R, a) => (R.ACT[a] ? R.ACT[a].n : R.FEET && R.FEET[a] ? R.FEET[a].n : a);   // as balance.mjs

// ---- WHOLE BOUTS: the solved mix against itself (who=mix, opp=mirror in balance.mjs). balance.mjs's loop, with the two
// men created from the two sets. S.bt is not set: nothing on the page reads it.
export function bouts(R, n, a, b) { const { N, ACT, resolve, endBeat } = R, rnd = R.rnd;
  const o = { n, w: 0, draw: 0, ko: 0, lost: 0, beats: 0, clinch: 0, rng: [0, 0, 0, 0], use: [{}, {}], pun: [{}, {}], np: [[0, 0, 0], [0, 0, 0]], dmg: [0, 0], first: {}, ordered: 0, kd: [0, 0], lvl: [0, 0, 0] };
  const note = (k, c) => { const u = o.use[k], add = (x) => { u[x] = (u[x] || 0) + 1; }; if (c.clinch) return add('clinch'); add(c.lead || 'lead held ' + c.hl); add(c.rear || 'rear held ' + c.hr); add(c.feet === 'hold' ? 'feet hold' : c.feet === 'in' ? 'step in' : c.feet === 'back' ? 'back off' : c.feet);
    o.np[k][(c.lead && ACT[c.lead].d ? 1 : 0) + (c.rear ? 1 : 0)]++; if (k === 0 && c.ord && c.ord.length > 1) { o.ordered++; o.first[c.ord[0]] = (o.first[c.ord[0]] || 0) + 1; } };
  for (let bt = 0; bt < n; bt++) { const S = { f: [R.man(a.hp, a), R.man(b.hp, b)], range: 3 }; let done = false; const t = [0, 0];
    for (let r = 0; r < N.rounds && !done; r++) { S.range = 3; for (const m of S.f) { m.pts = 0; m.st = m.cap; m.g = N.guard; m.ropes = 0; m.held = 0; m.kept = 0; m.gave = 0; }
      for (let i = 0; i < N.beats && !done; i++) { S.t = N.beats - i;
        const z = R.solveBeat(S, S.t, { iters: 400 }); const mine = z.A[drawAt(z.p, rnd)], his = z.B[drawAt(z.q, rnd)];
        note(0, mine); note(1, his); const hp = [S.f[0].hp, S.f[1].hp], ev = resolve(S, [{ ...mine }, { ...his }]); endBeat(S); o.beats++; o.rng[S.range]++; o.dmg[0] += hp[1] - S.f[1].hp; o.dmg[1] += hp[0] - S.f[0].hp;
        for (const e of ev) { if (e.t === 'clinch') o.clinch++; if (e.id && (e.t === 'hit' || e.t === 'block' || e.t === 'miss')) { const q = o.pun[e.k][e.id] = o.pun[e.k][e.id] || { hit: 0, block: 0, miss: 0 }; q[e.t]++; } }
        for (const k of [0, 1]) if (S.f[k].hp <= 0) { S.f[k].kd++; o.kd[k]++; S.f[1 - k].pts += 3; if (S.f[k].kd > N.kd.length) { if (k === 1) { o.w++; o.ko++; } else o.lost++; done = true; break; } S.f[k].hp = N.kd[S.f[k].kd - 1]; } }
      if (!done) { const [x, y] = S.f, lvl = x.pts === y.pts, g = lvl && N.even ? Math.sign((y.gave || 0) - (x.gave || 0)) : 0;
        o.lvl[0]++; if (lvl) o.lvl[1]++; if (g) o.lvl[2]++; t[0] += x.pts > y.pts || (lvl && g >= 0) ? 10 : 9; t[1] += y.pts > x.pts || (lvl && g <= 0) ? 10 : 9; } }
    if (!done) { if (t[0] > t[1]) o.w++; else if (t[0] === t[1]) o.draw++; } }
  return o; }

const merge = (a, b) => { if (!a) return b; for (const k in b) { if (typeof b[k] === 'number') a[k] = (a[k] || 0) + b[k]; else if (Array.isArray(b[k]) && typeof b[k][0] === 'number') b[k].forEach((x, i) => { a[k][i] += x; }); else if (Array.isArray(b[k])) b[k].forEach((x, i) => { a[k][i] = merge(a[k][i], x); }); else a[k] = merge(a[k] || {}, b[k]); } return a; };   // as balance.mjs

if (!isMainThread && workerData && workerData.sharpProbe) { const { n, seed, a, b } = workerData; parentPort.postMessage(bouts(load(seed, PAGE, applyPatch), n, a, b)); }
export async function play(n, opts = {}) { const jobs = opts.jobs || 2, self = fileURLToPath(import.meta.url), each = Math.ceil(n / jobs);
  const R0 = opts.a || opts.b ? null : load(1, PAGE, applyPatch);   // the defaults: today's man on both sides
  const a = opts.a || setOf(R0, ''), b = opts.b || setOf(R0, '');
  const got = await Promise.all(Array.from({ length: jobs }, (_, i) => new Promise((ok, bad) => { const w = new Worker(self, { workerData: { sharpProbe: 1, n: each, seed: (opts.seed || 1) * 100 + i, a, b } }); w.once('message', ok); w.once('error', bad); })));
  return got.reduce(merge, null); }

// ---- THE REPORT of one pairing (the usual balance.mjs lines, named A and B instead of you and he, plus the upgraded
// punch's share of beats, A v B - the feedback loop "upgrade -> more use of that punch").
export function report(R, a, b, o, secs) { const pc = (x) => (100 * x).toFixed(0) + '%', tot = (q) => q.hit + q.block + q.miss, nb = Math.max(1, o.beats), decided = Math.max(0, o.n - o.draw);
  const L = [`PROBE_SHARP a=${a.src || '(today)'} b=${b.src || '(today)'} n=${o.n} seed-manifest: jobs split by seed*100+i (page ${PAGE} through rules.mjs with the per-man punch-table patch; the page file is not edited)`];
  L.push(`A [${descOf(R, a)}]  v  B [${descOf(R, b)}]: A wins ${pc(o.w / Math.max(decided, 1))} of decided (${o.w} of ${decided}), draws ${pc(o.draw / o.n)} of all; stoppages: A stops B ${pc(o.ko / o.n)}, B stops A ${pc(o.lost / o.n)}; knockdowns a bout (suffered): A ${(o.kd[0] / o.n).toFixed(1)} / B ${(o.kd[1] / o.n).toFixed(1)}; health dealt a bout: A ${(o.dmg[0] / o.n).toFixed(1)} / B ${(o.dmg[1] / o.n).toFixed(1)}; beats at Inside / Mid / Long ${[1, 2, 3].map((r) => pc(o.rng[r] / nb)).join(' / ')}; clinches a bout ${(o.clinch / o.n).toFixed(1)}`);
  for (const [k, tag] of [[0, 'A'], [1, 'B']]) { const u = o.use[k], np = o.np[k];
    L.push(`  ${tag} a beat: ` + Object.keys(u).sort((x, y) => u[y] - u[x]).map((x) => `${nameOf(R, x)} ${pc(u[x] / nb)}`).join(', ') + ` | punches in a plan: none ${pc(np[0] / nb)}, one ${pc(np[1] / nb)}, two ${pc(np[2] / nb)}`);
    L.push(`  ${tag} punches (thrown a bout: lands / blocked / misses): ` + Object.keys(o.pun[k]).sort((x, y) => tot(o.pun[k][y]) - tot(o.pun[k][x])).map((id) => { const q = o.pun[k][id]; return `${R.ACT[id].n} ${(tot(q) / o.n).toFixed(1)}: ${pc(q.hit / tot(q))} / ${pc(q.block / tot(q))} / ${pc(q.miss / tot(q))}`; }).join(', ')); }
  for (const u of a.ups) { const id = u.id;
    L.push(`  the upgraded punch ${R.ACT[id].n} (${u.up}): A has it in ${pc((o.use[0][id] || 0) / nb)} of beats, B in ${pc((o.use[1][id] || 0) / nb)} of beats; thrown a bout: A ${(tot(o.pun[0][id] || { hit: 0, block: 0, miss: 0 }) / o.n).toFixed(1)} / B ${(tot(o.pun[1][id] || { hit: 0, block: 0, miss: 0 }) / o.n).toFixed(1)}`); }
  const gap = {}; for (const s of new Set([...Object.keys(o.use[0]), ...Object.keys(o.use[1])])) gap[s] = (o.use[0][s] || 0) / nb - (o.use[1][s] || 0) / nb;
  L.push(`  how the two men fought differently, the switches whose use moved most (A share - B share): ` + Object.keys(gap).sort((x, y) => Math.abs(gap[y]) - Math.abs(gap[x])).slice(0, 2).map((s) => `${nameOf(R, s)} ${gap[s] >= 0 ? '+' : ''}${(100 * gap[s]).toFixed(0)}% (A ${pc((o.use[0][s] || 0) / nb)} / B ${pc((o.use[1][s] || 0) / nb)})`).join(', '));
  const stop = (o.ko + o.lost) / o.n;
  L.push(`  stoppages ${pc(stop)} of all bouts (bar 10-40%): ${stop >= 0.1 && stop <= 0.4 ? 'inside the bar' : 'FLAG: outside the bar'}`);
  L.push(`  NOTE: the look-ahead table vtable.json was built for equal men - used as it is here: an approximation for unequal men (it reads both men's punches at today's numbers).`);
  if (secs != null) L.push(`  (${o.n} bouts, ${secs} s)`);
  return L.join('\n'); }

const isMain = isMainThread && import.meta.url === pathToFileURL(process.argv[1] || '').href;
if (isMain) { const arg = (k, d) => { const x = process.argv.find((y) => y.startsWith(k + '=')); return x ? x.split('=').slice(1).join('=') : d; };
  const R = load(1, PAGE, applyPatch), a = setOf(R, arg('a', '')), b = setOf(R, arg('b', '')), n = Number(arg('n', 84)), jobs = Number(arg('jobs', 2)), seed = Number(arg('seed', 1));
  if (!(n > 0)) throw new Error('probe_sharp: n must be at least 1'); if (!(jobs >= 1)) throw new Error('probe_sharp: jobs must be at least 1');
  const t0 = Date.now(), o = await play(n, { a, b, jobs, seed });
  console.log(report(R, a, b, o, ((Date.now() - t0) / 1000).toFixed(0)));
  if (arg('json', '')) fs.writeFileSync(arg('json', ''), JSON.stringify(o)); }
