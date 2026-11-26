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
import { LIES, LIES3, LIES4, tellOf, fakeOk4, fakeOk5, hiddenPunch5 } from './tells.mjs';
import { cover, botPlan, bouts, lieCueHolds, punchInto, caughtLoading } from './probe_tells.mjs';

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

/* S566 TELLS4M: version 4 and BOT 2 fixed (v2 and v3 calls unchanged: the tests above, plus the v3 checks here) */
const A = R.ACT, c4 = (o = {}) => ({ ...ctx(o), ACT: A, fakesRound: 0, fakedLast: false });
test('v4: a fake shoulder may hide one 3-damage punch on an open line (a lead uppercut), never two, never a hook, never more', () => {
  assert.ok(fakeOk4(plan({ lead: 'lup' }), 'shoulder', A), 'lead uppercut, under, 3: allowed');
  assert.ok(!fakeOk4(plan({ lead: 'hook' }), 'shoulder', A), 'lead hook is on a covered line (side)');
  assert.ok(!fakeOk4(plan({ lead: 'lup', rear: 'rbody' }), 'shoulder', A), 'two punches: never');
  assert.ok(!fakeOk4(plan({ rear: 'rup' }), 'shoulder', A), '4 damage: never');
  assert.ok(fakeOk4(plan({ lead: 'jab' }), 'shoulder', A) && fakeOk4(plan({ rear: 'rbody' }), 'shoulder', A), 'under 3 as in v3');
  assert.ok(!fakeOk4(plan({ lead: 'jab' }), 'knees', A) && fakeOk4(plan(), 'knees', A), 'a fake knees still hides no punch');
  const cj = c4({ hisLast: plan({ feet: 'back' }) });
  const t4 = tellOf(0, plan({ lead: 'lup' }), cj, 4), t3 = tellOf(0, plan({ lead: 'lup' }), cj, 3);
  assert.equal(t4.cue, 'shoulder'); assert.ok(t4.fake); assert.equal(t3.cue, 'knees', 'v3 unchanged: no fake over 2 damage'); assert.ok(!t3.fake);
});
test('v4: the Body Snatcher fakes the shoulder after his body punch, inside the cap; v3 does not', () => {
  assert.equal(LIES4[2].length, LIES3[2].length + 1); assert.equal(LIES4[2][2].cue, 'shoulder');
  const cb = c4({ hisLast: plan({ rear: 'rbody' }) }), jab = plan({ lead: 'jab' });
  assert.equal(tellOf(2, jab, cb, 4).cue, 'shoulder'); assert.ok(tellOf(2, jab, cb, 4).fake);
  assert.ok(!tellOf(2, jab, cb, 3).fake, 'v3: a jab beat cannot fake knees (1 damage is not under 1)');
  assert.equal(tellOf(2, plan(), cb, 4).cue, 'knees', 'an empty beat: knees comes first');
  assert.ok(!tellOf(2, jab, { ...cb, fakesRound: 2 }, 4).fake, 'the cap of 2 a round'); assert.ok(!tellOf(2, jab, { ...cb, fakedLast: true }, 4).fake, 'never two running');
});
test('BOT 2 fixed: it doubts only that man\'s lying cue under a holding condition, and punches into it', () => {
  const cj = c4({ hisLast: plan({ feet: 'back' }), range: 2 }), base = plan({ hl: 'low', hr: 'low' });
  assert.ok(lieCueHolds(0, cj, 'shoulder', 3)); assert.ok(!lieCueHolds(0, cj, 'knees', 3), 'the Jabber never fakes knees');
  const got = botPlan(2, 0, base, { cue: 'shoulder', fake: true }, cj, 3, { fix: 1, FEET: R.FEET });
  assert.equal(got.lead, 'jab', 'at Mid the cheapest punch that reaches: the jab (1 stamina; ties: bigger, then lead)'); assert.deepEqual(got.ord, ['lead']); assert.equal(got.hr, 'low', 'the other held hand stays');
  const ins = punchInto(base, { ...cj, range: 1 }, R.FEET); assert.equal(ins.lead, 'hook', 'Inside: 2 stamina, 3 damage, the lead first');
  const kn = botPlan(2, 0, base, { cue: 'knees' }, cj, 3, { fix: 1 }); assert.equal(kn.hl, 'low'); assert.equal(kn.hr, 'low', 'an honest cue is covered as BOT 1');
  assert.deepEqual(botPlan(2, 0, base, { cue: 'shoulder' }, cj, 3), base, 'without fix=1 BOT 2 is the TELLS3M bot');
  const tired = punchInto(base, { ...cj, me: { ...cj.me, st: 0 } }, R.FEET); assert.deepEqual(tired, base, 'no stamina: no punch added');
  const lng = punchInto(base, { ...cj, range: 3 }, R.FEET); assert.equal(lng.lead, 'jab', 'at Long: the jab');
});

/* S567 TELLS5M: version 5 (v5a caught loading, v5b the Jabber's lead body hook); v2 / v3 / v4 calls unchanged */
test('v5a: a punch that lands on him in a fake-cue beat does +1 damage (caught loading)', () => {
  const S = { f: [R.man(R.N.hp), R.man(R.N.hp)] };
  const ev = [{ k: 0, t: 'hit', id: 'jab' }, { k: 1, t: 'hit', id: 'cross' }, { k: 0, t: 'block' }, { k: 0, t: 'miss' }];
  const hp0 = S.f[1].hp;
  assert.equal(caughtLoading(S, ev, { cue: 'shoulder', fake: true }), 1, 'one of your punches landed: one +1');
  assert.equal(S.f[1].hp, hp0 - 1, 'the man takes the +1 damage');
  assert.equal(caughtLoading(S, ev, { cue: 'shoulder', fake: false }), 0, 'an honest cue: no +1');
  assert.equal(caughtLoading(S, ev, null), 0, 'the mirror has no cue: no +1');
  assert.equal(caughtLoading(S, [], { cue: 'shoulder', fake: true }), 0, 'nothing landed: no +1');
});
test('v5a: the probe counts the +1s landed, and without catch=1 there is no +1', () => {
  const o = bouts(load(7), 1, 0, 1, 4, 0, 1);
  assert.ok(o.tl.plus1 != null && o.tl.plus1 >= 0, 'the +1 count exists with catch=1');
  assert.ok(o.tl.plus1Beats >= 0 && o.tl.plus1Beats <= o.tl.beats, 'the beats with a +1 are counted');
  const plain = bouts(load(7), 1, 0, 1, 4, 0, 0);
  assert.equal(plain.tl.plus1, undefined, 'without catch=1 there is no +1');
});
test('v5b: the Jabber\'s shoulder fake may hide his lead hook to the body, at the ranges it reaches', () => {
  // the page's body hook (lbody: 2 damage, line body, reach Inside/Mid) is a plain bluff with the page's punches
  // (2 < the shoulder's promise of 3), so the v5b branch is checked with a synthetic 3-damage lead body punch, where
  // the reach clause binds.
  assert.equal(hiddenPunch5(plan({ lead: 'lbody' }), 'shoulder', A, 1, 0), 'bluff', 'the page\'s body hook (2): a plain bluff');
  const A3 = { ...A, lbody: { ...A.lbody, d: 3 } };
  assert.equal(hiddenPunch5(plan({ lead: 'lbody' }), 'shoulder', A3, 1, 0), 'lead body hook', 'a 3-damage lead body punch, Inside');
  assert.equal(hiddenPunch5(plan({ lead: 'lbody' }), 'shoulder', A3, 2, 0), 'lead body hook', 'Mid: the body hook reaches');
  assert.notEqual(hiddenPunch5(plan({ lead: 'lbody' }), 'shoulder', A3, 3, 0), 'lead body hook', 'at Long it does not reach');
  assert.equal(hiddenPunch5(plan({ lead: 'lbody' }), 'shoulder', A3, 2, 1), 'lead uppercut', 'the Slugger: the v4 route only');
  assert.equal(hiddenPunch5(plan({ rear: 'lbody' }), 'shoulder', A3, 2, 0), 'lead uppercut', 'a rear-slot body punch is not the lead hook');
  assert.equal(hiddenPunch5(plan({ lead: 'lbody', rear: 'jab' }), 'shoulder', A3, 1, 0), null, 'two punches never hide');
  assert.equal(hiddenPunch5(plan({ lead: 'lup' }), 'shoulder', A, 1, 0), 'lead uppercut', 'v4 keeps its one hidden 3');
  assert.ok(fakeOk5(plan({ lead: 'lbody' }), 'shoulder', A, 2, 0) && fakeOk5(plan({ lead: 'lup' }), 'shoulder', A, 1, 0));
  assert.ok(!fakeOk5(plan({ lead: 'lbody', rear: 'jab' }), 'shoulder', A, 1, 0), 'two punches: never');
});
test('v5b: with the page\'s punches the lead body hook (2) was already a valid bluff (2 < the shoulder promise of 3)', () => {
  for (const r of [1, 2, 3]) assert.equal(fakeOk5(plan({ lead: 'lbody' }), 'shoulder', A, r, 0), fakeOk4(plan({ lead: 'lbody' }), 'shoulder', A), `range ${r}: the same decision as v4`);
  const cj = c4({ hisLast: plan({ feet: 'back' }), range: 2 });
  assert.equal(tellOf(0, plan({ lead: 'lbody' }), cj, 5).cue, 'shoulder'); assert.ok(tellOf(0, plan({ lead: 'lbody' }), cj, 5).fake);
  assert.ok(!tellOf(0, plan({ lead: 'lbody' }), { ...cj, fakesRound: 2 }, 5).fake, 'the cap of 2 a round still holds');
  assert.ok(!tellOf(0, plan({ lead: 'lbody' }), { ...cj, fakedLast: true }, 5).fake, 'never two running');
  const t4 = tellOf(0, plan({ lead: 'lup' }), cj, 4); assert.equal(t4.cue, 'shoulder'); assert.ok(t4.fake, 'v4 unchanged: the hidden uppercut');
});
console.log(`PROBE_TELLS_TEST ${process.exitCode ? 'FAILED' : 'passed'} (${n} passed)`);
