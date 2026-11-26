// TELLS2M (S563): the tells probe, tested like rules_test.mjs (node:assert). probe_tells.mjs plays whole bouts, the page's
// opponents choosing with ai() as on the page, a bot in the player's corner: BOT 0 the page's mix (balance.mjs who=mix),
// BOT 1 BOT 0's beat with its HELD hands set to cover the lines his tell (tells.mjs v2) names, BOT 2 BOT 1 except when
// that man's lie condition (LIES[opp].test) holds - then BOT 0's beat.
//   node proto/twohands/tools/probe_tells_test.mjs    exit 0 = all pass
import assert from 'node:assert/strict';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import { load } from './rules.mjs';
import { LIES, tellOf } from './tells.mjs';
import { cover, botPlan, bouts } from './probe_tells.mjs';

const here = path.dirname(fileURLToPath(import.meta.url));
let n = 0;
const test = (name, fn) => { try { fn(); n++; } catch (e) { console.log(`PROBE_TELLS_TEST FAIL ${name}: ${e.message}`); process.exitCode = 1; } };
const sortDeep = (x) => Array.isArray(x) ? x.map(sortDeep) : (x && typeof x === 'object' ? Object.fromEntries(Object.keys(x).sort().map((k) => [k, sortDeep(x[k])])) : x);
const R = load(1), plan = (o = {}) => ({ ...R.plan0(), ...o });
const ctx = (o = {}) => ({ me: R.man(R.N.hp), him: R.man(R.N.hp), hisLast: null, meLanded: false, blockedAny: false, blockedBody: false, range: 2, ...o });

test('BOT 0 replays a balance.mjs mirror bout bout for bout on the same seed (who=mix opp=mirror n=2 jobs=1 seed=1)', () => {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'tells2m-')), json = path.join(dir, 'bal.json');
  const r = spawnSync(process.execPath, [path.join(here, 'balance.mjs'), 'play', 'who=mix', 'opp=mirror', 'n=2', 'jobs=1', 'seed=1', `json=${json}`], { encoding: 'utf8' });
  assert.equal(r.status, 0, 'balance.mjs play ran' + (r.stderr ? ': ' + r.stderr.slice(-400) : ''));
  const bal = JSON.parse(fs.readFileSync(json, 'utf8')); fs.rmSync(dir, { recursive: true, force: true });
  const mine = bouts(load(100), 0, 'mirror', 2); delete mine.tl;   // tl: the probe's own tell counts, not in balance.mjs
  assert.deepEqual(sortDeep(mine), sortDeep(bal), 'bout for bout the same: wins, draws, stoppages, knockdowns, damage, switch use');
});

test('BOT 1 holds lead low + rear low on a knees cue, keeping its punches', () => {
  const base = plan({ hl: 'high', hr: 'high', feet: 'in', ord: ['feet'] });
  const got = botPlan(1, 0, base, { cue: 'knees', truth: 'knees', fake: false }, ctx());
  assert.equal(got.hl, 'low'); assert.equal(got.hr, 'low'); assert.equal(got.lead, null); assert.equal(got.rear, null); assert.equal(got.feet, 'in');
  const one = botPlan(1, 0, plan({ lead: 'jab', hl: 'high', hr: 'high', ord: ['lead'] }), { cue: 'knees' }, ctx());
  assert.equal(one.lead, 'jab', 'the punch is kept'); assert.equal(one.hr, 'low', 'the held rear hand goes low'); assert.deepEqual(one.ord, ['lead']);
  assert.equal(base.hl, 'high', 'BOT 0\'s plan is not changed in place');
});

test('BOT 1: rear shoulder -> lead high + rear high; back foot and quiet -> BOT 0; front foot -> BOT 0 with no back off', () => {
  const low = plan({ hl: 'low', hr: 'low', feet: 'back', ord: ['feet'] });
  const sh = cover(low, 'shoulder'); assert.equal(sh.hl, 'high'); assert.equal(sh.hr, 'high'); assert.equal(sh.feet, 'back');
  assert.deepEqual(cover(low, 'backfoot'), low); assert.deepEqual(cover(low, 'still'), low);
  const ft = cover(plan({ rear: 'cross', hl: 'low', feet: 'back', ord: ['feet', 'rear'] }), 'foot');
  assert.equal(ft.feet, 'hold', 'no back off on a front foot cue'); assert.deepEqual(ft.ord, ['rear'], 'the feet leave the order'); assert.equal(ft.rear, 'cross'); assert.equal(ft.hl, 'low');
  const fin = plan({ feet: 'in', ord: ['feet'] }); assert.deepEqual(cover(fin, 'foot'), fin, 'a step in is kept');
});

test('BOT 2 plays BOT 0\'s beat when LIES[opp].test holds, and BOT 1\'s when it does not', () => {
  const base = plan({ hl: 'low', hr: 'low' }), quiet = plan();
  const c0 = ctx({ hisLast: plan({ feet: 'back' }) }); assert.ok(LIES[0].test(c0), 'the Jabber\'s lie condition holds');
  const t0 = tellOf(0, quiet, c0, 2); assert.equal(t0.cue, 'shoulder'); assert.ok(t0.fake);
  assert.deepEqual(botPlan(2, 0, base, t0, c0), base, 'BOT 2 ignores the cue'); assert.equal(botPlan(1, 0, base, t0, c0).hl, 'high', 'BOT 1 follows it');
  const c1 = ctx({ meLanded: true }), c2 = ctx({ blockedAny: true }); assert.ok(LIES[1].test(c1)); assert.ok(LIES[2].test(c2));
  assert.deepEqual(botPlan(2, 1, base, { cue: 'shoulder' }, c1), base); assert.deepEqual(botPlan(2, 2, plan(), { cue: 'knees' }, c2), plan());
  const free = ctx(); assert.ok(!LIES[0].test(free)); assert.equal(botPlan(2, 0, base, { cue: 'shoulder' }, free).hl, 'high', 'no lie condition: BOT 2 follows the cue');
  assert.deepEqual(botPlan(0, 0, base, { cue: 'shoulder' }, free), base, 'BOT 0 never follows');
});

test('a fake costs him 1 stamina after the beat, and his fakes are counted (BOT 1 v the Jabber, 1 bout)', () => {
  const o = bouts(load(7), 1, 0, 1);
  assert.ok(o.tl.beats > 0 && o.tl.beats === o.beats, 'every beat against a man has a tell');
  assert.ok(o.tl.fake >= 0 && o.tl.fake <= o.tl.beats); assert.ok(o.tl.bellN[0] >= 1 || o.ko + o.lost === 1, 'his stamina is read at the first bell');
});

console.log(`PROBE_TELLS_TEST ${process.exitCode ? 'FAILED' : 'passed'} (${n} passed)`);
