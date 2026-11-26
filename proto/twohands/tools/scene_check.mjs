// SCENE_CHECK (S567): each famous exchange in scenes.js played on the page's own rules - does our game say what the ring said?
//   node proto/twohands/tools/scene_check.mjs [scene id]
import fs from 'node:fs';
import path from 'node:path';
import { load } from './rules.mjs';
const here = path.dirname(new URL(import.meta.url).pathname.replace(/^\/([A-Za-z]:)/, '$1'));
const SCENES = new Function(fs.readFileSync(path.join(here, '..', 'scenes.js'), 'utf8') + '\nreturn RS_SCENES;')();
const R0 = load(1), { N, ACT, RNG } = R0;
const mk = (R, p) => { const m = R.plan0(); if (p.clinch) { m.clinch = true; return m; } const L = p.lead || 'high', H = p.rear || 'high';
  if (L === 'high' || L === 'low') m.hl = L; else m.lead = L; if (H === 'high' || H === 'low') m.hr = H; else m.rear = H; m.feet = p.feet || 'hold';
  const acts = [...(m.feet !== 'hold' ? ['feet'] : []), ...(m.lead ? ['lead'] : []), ...(m.rear ? ['rear'] : [])], want = (p.order || '').split(',').filter((x) => acts.includes(x)); m.ord = [...want, ...acts.filter((x) => !want.includes(x))]; return m; };
let ok = 0, all = 0;
for (const sc of SCENES.filter((s) => !process.argv[2] || s.id === process.argv[2])) {
  const F = [R0.man(N.hp), R0.man(N.hp)]; for (const k of [0, 1]) { F[k].hp = sc.hp[k]; F[k].st = sc.st[k]; if (sc.ropes) F[k].ropes = sc.ropes[k]; }
  const T = { f: F, range: sc.range, t: N.beats }; console.log(`\n== ${sc.title} (${sc.bout}) - ${sc.blue} is blue, ${sc.red} is red; starts at ${RNG[sc.range]}`);
  sc.beats.forEach((b, i) => { const R = load(100 + i), plans = [mk(R, b.blue), mk(R, b.red)], cost = plans.map((p) => R.cost(p)), st0 = [F[0].st, F[1].st], named = (s) => String(s).replace(/\byou\b/gi, sc.blue).replace(/\bhe\b/gi, sc.red).replace(/\byour\b/gi, sc.blue + "'s").replace(/\bhis\b/gi, sc.red + "'s").replace(/\bhim\b/gi, sc.red);
    console.log(` beat ${i + 1} at ${RNG[T.range]}. REAL: ${b.real}`); console.log(`   ${sc.blue}: ${R.planWords(plans[0])} (${cost[0]} of ${st0[0]} stamina)   ${sc.red}: ${R.planWords(plans[1])} (${cost[1]} of ${st0[1]} stamina)`);
    const pay = [0, 1].map((k) => cost[k] <= st0[k]); const ev = R.resolve(T, plans.map((p) => ({ ...p }))); R.endBeat(T);
    for (const e of ev) console.log(`     ${e.m != null ? 'moment ' + (e.m + 1) + ' ' : ''}${e.k === 0 ? sc.blue : e.k === 1 ? sc.red : ''}: ${named(e.a || e.t)}${e.o ? ' - ' + named(e.o) : ''}`);
    const hit = (k, id) => ev.some((e) => e.k === k && e.t === 'hit' && (id === 'any' || id === true || e.id === id)), anyHit = (k) => ev.some((e) => e.k === k && e.t === 'hit'), down = [F[0].hp <= 0, F[1].hp <= 0], w = b.want || {}, checks = [];
    if (w.blueHit === false) checks.push(['no punch of ' + sc.blue + ' lands', !anyHit(0)]); else if (w.blueHit) checks.push([`${sc.blue}'s ${w.blueHit === 'any' ? 'punch' : ACT[w.blueHit].n} lands`, hit(0, w.blueHit)]);
    if (w.redHit === false) checks.push(['no punch of ' + sc.red + ' lands', !anyHit(1)]);
    if (w.redDown) checks.push([sc.red + ' goes down', down[1]]); if (w.redTired) checks.push([sc.red + ' is at 2 stamina or less', F[1].st <= 2]);
    if (!pay[0] || !pay[1]) checks.push(['both can pay for the beat', false]);
    for (const [what, pass] of checks) { all++; if (pass) ok++; console.log(`   ${pass ? 'MATCH' : 'MISMATCH'}: ${what}`); }
    console.log(`   after: ${sc.blue} health ${F[0].hp}, stamina ${F[0].st}; ${sc.red} health ${F[1].hp}, stamina ${F[1].st}; range ${RNG[T.range]}`); for (const k of [0, 1]) if (F[k].hp <= 0) F[k].hp = N.kd[0]; }); }
console.log(`\nSCENE_CHECK ${ok} of ${all} match the ring`);
