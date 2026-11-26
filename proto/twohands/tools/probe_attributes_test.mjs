// PROGP3 (S560): the attributes probe, tested like rules_test.mjs (node:assert). The probe (probe_attributes.mjs) reads the
// page's rules through rules.mjs with a patch - a text replacement at load time, so each man carries his OWN health, stamina
// bar, recovery and guard as fields on the man, falling back to N; the page file is never edited. Bouts: the solved mix
// against itself (balance.mjs play who=mix opp=mirror style: both men draw from solveBeat), man A and man B on different sets.
//   node proto/twohands/tools/probe_attributes_test.mjs    exit 0 = all pass
import assert from 'node:assert/strict';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import { load } from './rules.mjs';
import { applyPatch, setOf, bouts } from './probe_attributes.mjs';

const here = path.dirname(fileURLToPath(import.meta.url));
let n = 0;
const test = (name, fn) => { try { fn(); n++; } catch (e) { console.log(`PROBE_ATTRIBUTES_TEST FAIL ${name}: ${e.message}`); process.exitCode = 1; } };
const sortDeep = (x) => Array.isArray(x) ? x.map(sortDeep) : (x && typeof x === 'object' ? Object.fromEntries(Object.keys(x).sort().map((k) => [k, sortDeep(x[k])])) : x);

test('equal sets: the probe plays the same bouts as balance.mjs mirror with the same seed (n=4, jobs=1, seed=1)', () => {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'progp3-')), json = path.join(dir, 'bal.json');
  const r = spawnSync(process.execPath, [path.join(here, 'balance.mjs'), 'play', 'who=mix', 'opp=mirror', 'n=4', 'jobs=1', 'seed=1', `json=${json}`], { encoding: 'utf8' });
  assert.equal(r.status, 0, 'balance.mjs play ran' + (r.stderr ? ': ' + r.stderr.slice(-400) : ''));
  const bal = JSON.parse(fs.readFileSync(json, 'utf8'));
  fs.rmSync(dir, { recursive: true, force: true });
  const R = load(100, 'order.html', applyPatch), today = () => setOf('hp:18,st:8,rec:1,guard:6');
  const mine = bouts(R, 4, today(), today());
  assert.deepEqual(sortDeep(mine), sortDeep(bal), 'bout for bout the same: wins, draws, stoppages, knockdowns, damage, switch use');
});

test('health 20 is knocked down later than health 16 in a fixed beat script (a cross to the head every beat)', () => {
  const R = load(3, 'order.html', applyPatch), { N, plan0, resolve } = R, plan = (o = {}) => ({ ...plan0(), ...o });
  const downAt = (hp) => { const S = { f: [R.man(hp), R.man(N.hp)], range: 2 }; for (let b = 1; b <= 12; b++) { resolve(S, [plan({ hl: 'low' }), plan({ rear: 'cross' })]); if (S.f[0].hp <= 0) return b; } return 99; };
  assert.equal(downAt(16), 6); assert.equal(downAt(20), 7); assert.ok(downAt(20) > downAt(16), 'the tougher man lasts longer');
});

test('the patch throws if a pattern is not on the page; the page itself is never touched', () => {
  assert.throws(() => applyPatch('const N = {}; nothing of the page here'), /not on the page/);
  const html = fs.readFileSync(path.join(here, '..', 'order.html'), 'utf8');
  const src = html.slice(html.indexOf('<script>') + 8, html.indexOf('// ---- the page'));
  assert.throws(() => applyPatch(src.replace('const man = (hp)', 'const man2 = (hp)')), /not on the page/, 'a pattern gone: throw');
  assert.doesNotThrow(() => applyPatch(src), 'the page as it is: the patch applies');
});

test('each man carries his own health, stamina bar, recovery and guard - falling back to N where no field is given', () => {
  const R = load(5, 'order.html', applyPatch), { N, endBeat, plan0 } = R;
  const a = R.man(20, { st: 9, guard: 7, rec: 1, recPlus: true });
  assert.equal(a.hp, 20); assert.equal(a.max, 20); assert.equal(a.st, 9); assert.equal(a.cap, 9); assert.equal(a.g, 7);
  const plain = R.man(N.hp); assert.equal(plain.st, N.st); assert.equal(plain.cap, N.st); assert.equal(plain.g, N.guard);
  const S = { f: [a, plain], range: 3, bt: 1 }; a.st = 2; plain.st = 2; a.last = { ...plan0() }; plain.last = { ...plan0() };
  endBeat(S); assert.equal(a.st, 2 + 1 + 2 * N.hold, 'beat 1: his rec back, the hold bonus as on the page'); assert.equal(plain.st, 2 + N.rec + 2 * N.hold, 'no fields: exactly the page');
  S.bt = 2; a.st = 2; endBeat(S); assert.equal(a.st, 2 + 1 + 2 * N.hold + 1, 'beat 2: recPlus = one more back');
  S.bt = 3; a.st = 2; endBeat(S); assert.equal(a.st, 2 + 1 + 2 * N.hold, 'beat 3: no bonus on the odd beat');
  const S2 = { f: [R.man(18, { guard: 5 }), R.man(18, { guard: 7 })], range: 2, bt: 1 };
  S2.f[0].g = 5; S2.f[1].g = 6; endBeat(S2);
  assert.equal(S2.f[0].g, 5, 'guard 5 regens to his own 5, not N.guard 6'); assert.equal(S2.f[1].g, 7, 'guard 7 regens to his own 7, not N.guard 6');
});

test('setOf reads the a= / b= arguments; rec:1+ means one more back on every second beat; bad input throws', () => {
  assert.deepEqual(setOf('hp:20,st:8,rec:1,guard:6'), { hp: 20, st: 8, rec: 1, guard: 6, recPlus: false, src: 'hp:20,st:8,rec:1,guard:6' });
  const plus = setOf('rec:1+'); assert.equal(plus.rec, 1); assert.equal(plus.recPlus, true); assert.equal(plus.hp, 18, 'a missing key falls back to today');
  assert.throws(() => setOf('hp:20,cheese:1'), /unknown/); assert.throws(() => setOf('hp:twenty'), /number/);
});

console.log(`PROBE_ATTRIBUTES_TEST ${n} passed${process.exitCode ? ' - FAILURES above' : ''}`);
