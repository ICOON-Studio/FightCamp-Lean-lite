// PUNCHCHANCE1 (S560): the puncher's chance, one beat each, on the page's own code with the tweak file on it.
//   node proto/twohands/tools/punch_chance_test.mjs        exit 0 = all pass
import assert from 'node:assert/strict';
import { loadTweaked, readTweak } from './balance.mjs';
import { applyKnockdown } from './probe_punch_chance.mjs';

const A = loadTweaked(1, readTweak('ops/research/s558_balance/punch_chance_a.json'), null), B = loadTweaked(1, readTweak('ops/research/s558_balance/punch_chance_b.json'), null);
const C = loadTweaked(1, readTweak('ops/research/s558_balance/punch_chance_c.json'), null), F = loadTweaked(1, readTweak('ops/research/s558_balance/punch_chance_f.json'), null);
const p = (R, o) => ({ ...R.plan0(), ...o });
const ring = (R, f = [{}, {}], range = 2) => ({ range, f: [Object.assign(R.man(18), f[0]), Object.assign(R.man(18), f[1])] });
const has = (R, S, k) => R.plansFor(S, k).some((c) => c.pch);
let n = 0; const t = (name, fn) => { try { fn(); n++; console.log('ok', name); } catch (e) { console.log('PUNCH_CHANCE_TEST FAIL', name, e.message); process.exitCode = 1; } };

t('level men: no puncher chance for either', () => { const S = ring(A); assert.ok(!has(A, S, 0)); assert.ok(!has(A, S, 1)); });
t('the man behind on health has it, the man ahead does not', () => { const S = ring(A, [{ hp: 10 }, {}]); assert.ok(has(A, S, 0)); assert.ok(!has(A, S, 1)); });
t('only on plans with a power punch, and it costs 2 more stamina', () => { const S = ring(A, [{ hp: 10 }, {}]); const all = A.plansFor(S, 0).filter((c) => c.pch);
  assert.ok(all.every((c) => [c.lead, c.rear].some((id) => id && A.ACT[id].d >= 3))); assert.ok(!all.some((c) => c.lead === 'jab' && !c.rear)); const c = all[0]; assert.equal(A.cost(c), A.cost({ ...c, pch: false }) + 2); });
t('not without the stamina for it', () => { const S = ring(A, [{ hp: 10, st: 2 }, {}]); assert.ok(!has(A, S, 0)); });
t('it lands: double damage and he goes down from full health', () => { const S = ring(A, [{ hp: 10 }, {}]); const ev = A.resolve(S, [p(A, { rear: 'cross', pch: true }), p(A, { hr: 'low', hl: 'low' })]);
  const hit = ev.find((e) => e.k === 0 && e.t === 'hit'); assert.equal(hit.dmg, 6); assert.ok(S.f[1].hp <= 0); assert.ok(hit.down); });
t('it is blocked: his next punch lands through the guard (a counter, as any punch after a block)', () => { const S = ring(A, [{ hp: 10 }, {}]);
  const ev = A.resolve(S, [p(A, { lead: 'hook', pch: true }), p(A, { lead: 'jab', rear: 'cross', ord: ['lead', 'rear'] })]);   // moment 1: the hook meets his rear hand held high; moment 2: his cross
  assert.ok(ev.some((e) => e.k === 0 && e.t === 'block' && e.id === 'hook')); const h = ev.find((e) => e.k === 1 && e.t === 'hit' && e.id === 'cross'); assert.ok(h, JSON.stringify(ev)); assert.equal(h.dmg, 4); });
t('without the switch the same cross is blocked by the lead hand back home', () => { const S = ring(A, [{ hp: 10 }, {}]); const ev = A.resolve(S, [p(A, { lead: 'hook' }), p(A, { lead: 'jab', rear: 'cross', ord: ['lead', 'rear'] })]);
  assert.ok(ev.some((e) => e.k === 1 && e.t === 'block' && e.id === 'cross'), JSON.stringify(ev)); });
t('it falls short: wide open, his jab lands through the guard', () => { const S = ring(A, [{ hp: 10 }, {}], 3); const ev = A.resolve(S, [p(A, { rear: 'cross', pch: true }), p(A, { feet: 'back', lead: 'jab', ord: ['feet', 'lead'] })]);
  assert.ok(ev.some((e) => e.k === 0 && e.t === 'miss')); assert.ok(ev.find((e) => e.k === 1 && e.t === 'hit' && e.id === 'jab'), JSON.stringify(ev));
  const S2 = ring(A, [{ hp: 10 }, {}], 3), ev2 = A.resolve(S2, [p(A, { rear: 'cross' }), p(A, { feet: 'back', lead: 'jab', ord: ['feet', 'lead'] })]); assert.ok(ev2.some((e) => e.k === 1 && e.t === 'block' && e.id === 'jab'), JSON.stringify(ev2)); });
t('the first power punch takes it, not the jab before it', () => { const S = ring(A, [{ hp: 10 }, {}]); const ev = A.resolve(S, [p(A, { lead: 'jab', rear: 'cross', pch: true, ord: ['lead', 'rear'] }), p(A, { hl: 'low', hr: 'low' })]);
  assert.equal(ev.find((e) => e.id === 'jab' && e.t === 'hit').dmg, 1); assert.equal(ev.find((e) => e.id === 'cross' && e.t === 'hit').dmg, 6); });   // the jab is not doubled; the cross is, 3 x 2
t('once a round', () => { const S = ring(A, [{ hp: 10 }, {}]); A.resolve(S, [p(A, { rear: 'cross', pch: true }), p(A, {})]); A.endBeat(S); assert.ok(!has(A, S, 0));
  for (let i = 1; i < A.N.beats; i++) A.endBeat(S); S.f[0].hp = 5; S.f[1].hp = 9; assert.ok(has(A, S, 0)); });
t('the man it dropped gets no switch that round', () => { const S = ring(A, [{ hp: 10 }, {}]); A.resolve(S, [p(A, { rear: 'cross', pch: true }), p(A, { hr: 'low', hl: 'low' })]); A.endBeat(S); S.f[1].hp = 6;
  assert.ok(!has(A, S, 1)); for (let i = 1; i < A.N.beats; i++) A.endBeat(S); assert.ok(has(A, S, 1)); });
t('the cards trigger: closed in rounds 1 and 2, open in the last round to the man behind on the cards', () => { const S = ring(B, [{ hp: 10 }, {}]); assert.ok(!has(B, S, 0));
  S.f[1].pts = 4; for (let i = 0; i < B.N.beats; i++) B.endBeat(S); assert.ok(!has(B, S, 0)); for (const m of S.f) m.pts = 0; S.f[1].pts = 2; for (let i = 0; i < B.N.beats; i++) B.endBeat(S);
  assert.ok(has(B, S, 0)); assert.ok(!has(B, S, 1)); });
t('the value table states never see it (level health, round 1): the look-ahead is the page\'s own', () => { const S = { range: 2, f: [A.man(18), A.man(18)] }; S.f[0].st = 8; S.f[1].st = 3; assert.ok(!has(A, S, 0)); assert.ok(!has(A, S, 1)); });
t('the free knockdown (PUNCHCHANCE2 F): an all-in drop gets up on his knockdown health, scores 3, and does not count toward the stoppage; off by default it counts as before', () => {
  const mk = (R, kd) => { const S = { f: [R.man(18), R.man(18)] }; S.f[1].kd = kd; S.f[1].hp = 0; S.f[1].pts = 0; S.f[0].pts = 0; const o = { kd: [0, 0] }, rec = { kd: [0, 0] }; return { S, o, rec }; };
  // F, first knockdown, all-in: free - kd unchanged, up on 6, 3 points, not tallied
  { const { S, o, rec } = mk(F, 0); assert.equal(applyKnockdown(S, 1, F.N, o, rec, true), 'free'); assert.equal(S.f[1].kd, 0); assert.equal(S.f[1].hp, F.N.kd[0]); assert.equal(S.f[0].pts, 3); assert.equal(o.kd[1], 0); assert.equal(rec.kd[1], 0); }
  // F, second knockdown, all-in: free - kd unchanged, up on 4
  { const { S, o, rec } = mk(F, 1); assert.equal(applyKnockdown(S, 1, F.N, o, rec, true), 'free'); assert.equal(S.f[1].kd, 1); assert.equal(S.f[1].hp, F.N.kd[1]); assert.equal(S.f[0].pts, 3); }
  // F, one more would stop, all-in: still free, not a stoppage
  { const { S, o, rec } = mk(F, 2); assert.equal(applyKnockdown(S, 1, F.N, o, rec, true), 'free'); assert.equal(S.f[1].kd, 2); assert.equal(S.f[1].hp, F.N.kd[1]); }
  // F, a normal drop (not all-in): counted as before
  { const { S, o, rec } = mk(F, 0); assert.equal(applyKnockdown(S, 1, F.N, o, rec, false), 'up'); assert.equal(S.f[1].kd, 1); assert.equal(S.f[1].hp, F.N.kd[0]); assert.equal(o.kd[1], 1); }
  // C (pcFree off): an all-in drop counts as before, and the third stops
  { const { S, o, rec } = mk(C, 0); assert.equal(applyKnockdown(S, 1, C.N, o, rec, true), 'up'); assert.equal(S.f[1].kd, 1); assert.equal(o.kd[1], 1); }
  { const { S, o, rec } = mk(C, 2); assert.equal(applyKnockdown(S, 1, C.N, o, rec, true), 'stop'); assert.equal(S.f[1].kd, 3); } });
console.log(`PUNCH_CHANCE_TEST ${n} passed`);
