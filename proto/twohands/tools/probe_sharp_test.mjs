// PROGP2 (S563): the Sharp choice probe, tested like rules_test.mjs (node:assert). The probe (probe_sharp.mjs) reads the
// page's rules through rules.mjs with a patch - a text replacement at load time - so each man carries his OWN copy of the
// punch table (a punch's stamina and its speed read PER MAN, falling back to ACT); the page file is never edited. Bouts:
// the solved mix against itself (balance.mjs play who=mix opp=mirror style: both men draw from solveBeat), man A with ONE
// punch upgraded, man B today's man.
//   node proto/twohands/tools/probe_sharp_test.mjs    exit 0 = all pass
import assert from 'node:assert/strict';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import { load } from './rules.mjs';
import { applyPatch, setOf, bouts } from './probe_sharp.mjs';

const here = path.dirname(fileURLToPath(import.meta.url));
let n = 0;
const test = (name, fn) => { try { fn(); n++; } catch (e) { console.log(`PROBE_SHARP_TEST FAIL ${name}: ${e.message}`); process.exitCode = 1; } };
const sortDeep = (x) => Array.isArray(x) ? x.map(sortDeep) : (x && typeof x === 'object' ? Object.fromEntries(Object.keys(x).sort().map((k) => [k, sortDeep(x[k])])) : x);

test('equal tables: the probe plays the same bouts as balance.mjs mirror with the same seed (n=4, jobs=1, seed=1)', () => {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'progp2-')), json = path.join(dir, 'bal.json');
  const r = spawnSync(process.execPath, [path.join(here, 'balance.mjs'), 'play', 'who=mix', 'opp=mirror', 'n=4', 'jobs=1', 'seed=1', `json=${json}`], { encoding: 'utf8' });
  assert.equal(r.status, 0, 'balance.mjs play ran' + (r.stderr ? ': ' + r.stderr.slice(-400) : ''));
  const bal = JSON.parse(fs.readFileSync(json, 'utf8'));
  fs.rmSync(dir, { recursive: true, force: true });
  const R = load(100, 'order.html', applyPatch), today = () => setOf(R, '');
  const mine = bouts(R, 4, today(), today());
  assert.deepEqual(sortDeep(mine), sortDeep(bal), 'bout for bout the same: wins, draws, stoppages, knockdowns, damage, switch use');
});

test('a man whose Cross costs 1 pays 1 for it in cost(); a man without a table pays today\'s 2', () => {
  const R = load(3, 'order.html', applyPatch), { plan0, cost } = R;
  const cheap = R.man(R.N.hp, setOf(R, 'cross:cheaper')), today = R.man(R.N.hp, setOf(R, ''));
  assert.equal(cheap.tb.cross.st, 1, 'the table carries the cheaper Cross');
  const one = { ...plan0(), rear: 'cross', feet: 'hold' };
  assert.equal(cost(one, cheap), 1, 'the cheap Cross costs 1');
  assert.equal(cost(one, today), 2, 'today\'s Cross costs 2');
  const two = { ...plan0(), lead: 'jab', rear: 'cross', feet: 'hold' };
  assert.equal(cost(two, cheap), 2, 'jab 1 + cheap Cross 1');
  assert.equal(cost(two, today), 3, 'jab 1 + Cross 2');
  assert.equal(cost({ ...plan0(), clinch: true }, cheap), 1, 'a clinch costs 1 whatever the table');
  assert.throws(() => setOf(R, 'jab:cheaper'), /no cheaper upgrade/, 'the jab already costs 1: no cheaper upgrade');
  assert.throws(() => setOf(R, 'bjab:cheaper'), /no cheaper upgrade/, 'the body jab already costs 1');
});

test('a man whose Cross is fast lands it before a medium punch in the same moment (a medium Cross is beaten to it)', () => {
  const R = load(7, 'order.html', applyPatch), { plan0, resolve } = R;
  const fast = R.man(R.N.hp, setOf(R, 'cross:faster')), today = R.man(R.N.hp, setOf(R, ''));
  assert.equal(fast.tb.cross.sp, 1, 'the table carries the faster Cross (fast)');
  const plan = (m) => ({ ...plan0(), rear: 'cross', hl: 'low' });   // lead held low: the straight line is open for both
  const ev = resolve({ f: [fast, today], range: 2 }, [plan(0), plan(1)]);
  const hits = ev.filter((e) => e.t === 'hit');
  assert.equal(hits.length, 1, 'only the fast Cross lands');
  assert.equal(hits[0].k, 0, 'it is man A\'s');
  assert.ok(ev.some((e) => e.k === 1 && /beaten to the punch/.test(e.o || '')), 'the medium Cross is stopped by the faster one');
  const ev2 = resolve({ f: [R.man(R.N.hp, setOf(R, '')), R.man(R.N.hp, setOf(R, ''))], range: 2 }, [plan(0), plan(1)]);
  assert.equal(ev2.filter((e) => e.t === 'hit').length, 2, 'two medium Crosses in the same moment: both land');
});

test('the patch throws if a pattern is not on the page; the page itself is never touched', () => {
  assert.throws(() => applyPatch('const N = {}; nothing of the page here'), /not on the page/);
  const html = fs.readFileSync(path.join(here, '..', 'order.html'), 'utf8');
  const src = html.slice(html.indexOf('<script>') + 8, html.indexOf('// ---- the page'));
  assert.throws(() => applyPatch(src.replace('const man = (hp)', 'const man2 = (hp)')), /not on the page/, 'a pattern gone: throw');
  assert.throws(() => applyPatch(src.replace('shots.sort((x, y) => x.a.sp - y.a.sp);', 'shots.sort((x, y) => 0);')), /not on the page/, 'the speed sort gone: throw');
  assert.doesNotThrow(() => applyPatch(src), 'the page as it is: the patch applies');
});

test('setOf builds each man his table from punch:up; a punch with no upgrade to give, or a bad input, throws', () => {
  const R = load(5, 'order.html', applyPatch);
  assert.equal(setOf(R, '').tb, null, 'no upgrade: today\'s table, no copy');
  const c = setOf(R, 'cross:cheaper');
  assert.equal(c.tb.cross.st, 1); assert.equal(c.tb.cross.sp, 2, 'cheaper leaves the speed alone');
  assert.deepEqual(c.ups, [{ id: 'cross', up: 'cheaper' }]);
  const f = setOf(R, 'cross:faster');
  assert.equal(f.tb.cross.sp, 1); assert.equal(f.tb.cross.st, 2, 'faster leaves the cost alone');
  const both = setOf(R, 'over:cheaper,rup:faster');
  assert.equal(both.tb.over.st, 2); assert.equal(both.tb.rup.sp, 2);
  assert.throws(() => setOf(R, 'jab:faster'), /no faster upgrade/, 'the jab is already fast');
  assert.throws(() => setOf(R, 'hook:faster'), /no faster upgrade/, 'the lead hook is already fast');
  assert.throws(() => setOf(R, 'cheese:cheaper'), /not a punch/);
  assert.throws(() => setOf(R, 'cross:slower'), /unknown upgrade/);
});

console.log(`PROBE_SHARP_TEST ${n} passed${process.exitCode ? ' - FAILURES above' : ''}`);
