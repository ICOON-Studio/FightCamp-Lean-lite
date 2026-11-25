// RING SWITCHES: the rules, read from the page itself (order.html since S555, the owner: "i want version with the
// order of actions"; switch.html is the old version without order, kept but no longer built on; everything above "// ---- the page"), so a probe or
// a test can never drift from what the owner plays. The S551 probes carried a hand copy of the rules.
//   import { load } from './rules.mjs'; const R = load(seed);   // R.resolve, R.ai, R.endBeat, R.man, R.N, R.ACT, ...
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const here = path.dirname(fileURLToPath(import.meta.url));
export function mulberry(seed) { let a = seed >>> 0; return () => { a |= 0; a = (a + 0x6D2B79F5) | 0; let t = Math.imul(a ^ (a >>> 15), 1 | a); t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t; return ((t ^ (t >>> 14)) >>> 0) / 4294967296; }; }

export function load(seed = 1, page = 'order.html', patch = null, useTable = true) {   // patch(src) -> src: a probe tries a rule without touching the page
  const html = fs.readFileSync(path.join(here, '..', page), 'utf8');
  const from = html.indexOf('<script>') + 8, to = html.indexOf('// ---- the page');
  if (from < 8 || to < 0) throw new Error('rules.mjs: the page has no "// ---- the page" mark');
  const src = patch ? patch(html.slice(from, to)) : html.slice(from, to);
  const rng = mulberry(seed);
  const stub = { getElementById: () => ({ classList: { add() {}, remove() {} }, style: {} }), querySelector: () => null, querySelectorAll: () => [] };
  const MathS = Object.create(Math); MathS.random = rng;
  const fn = new Function('document', 'fetch', 'Math', 'Audio', 'Image', src + `
    ;return { N, RNG, ACT, FEET, COVER, OPPS, LO, RO, plan0, man, cost, covers, resolve, endBeat, ai, planWords, slotOf, heightOf,
      ordOf: typeof ordOf === 'function' ? ordOf : null, perms: typeof perms === 'function' ? perms : null,
      W: typeof W === 'object' ? W : null, plansFor: typeof plansFor === 'function' ? plansFor : null, worth: typeof worth === 'function' ? worth : null, solveBeat: typeof solveBeat === 'function' ? solveBeat : null,
      setVT: (t) => { VT = t; }, getVT: () => VT, setN: (o) => Object.assign(N, o), setAct: (id, o) => { ACT[id] = { ...ACT[id], ...o }; },
      setOpp: (i) => { oppI = i; OPP = OPPS[i]; }, opp: () => OPP };`);
  const R = fn(stub, () => new Promise(() => {}), MathS, function () {}, function () {});
  R.rnd = rng;
  const vt = path.join(here, '..', 'vtable.json'); if (R.solveBeat && useTable && fs.existsSync(vt)) R.setVT(JSON.parse(fs.readFileSync(vt, 'utf8')).VT);   // the round looked ahead, as the page loads it
  return R;
}
