// tell_rates.mjs - TELLS2 prep (S563): how often would each candidate lie condition fire in real bouts?
// ALLPLAY2 (Claude, Arena): the Jabber lied 0 of 18 for one player and 6 of 18 for another, the Slugger 1 of 18 - a man
// who almost never lies is a lookup table. Both asked for about 1 lie in 5 for every man. This plays the page's own AI
// against itself (the man in the player's corner is the same AI, seen from his side) and counts, per opponent, the share
// of beats where each candidate condition holds AND the cue it would fake differs from the truth (a lie that shows).
//   node proto/twohands/tools/tell_rates.mjs [bouts=12] [seed=1]
import { load } from './rules.mjs';
import { truthOf, tellOf } from './tells.mjs';

const arg = Object.fromEntries(process.argv.slice(2).filter((a) => a.includes('=')).map((a) => a.split('=')));
const BOUTS = Number(arg.bouts || 12), SEED = Number(arg.seed || 1), ME = arg.me || 'ai';
/* S564 me=guard: a cautious player (ALLPLAY2B Arena landed 4 punches in 18 beats on the Slugger): both hands held, high or
   low by the dice, a lead jab or body jab on one beat in three where it reaches; the feet hold */
const guardPlan = (R, range) => { const p = R.plan0(), x = R.rnd(); p.hl = x < 0.5 ? 'high' : 'low'; p.hr = R.rnd() < 0.6 ? 'high' : 'low';
  if (x < 0.34) { const j = R.rnd() < 0.5 ? 'jab' : 'bjab'; if (R.ACT[j] && R.ACT[j].reach.includes(range)) { p.lead = j; p.ord = ['lead']; } } return p; };
const R0 = load(1), { N } = R0;
// the candidate conditions: [name, opp, condition(state), the cue it fakes]
const BIG = (id) => id === 'cross' || id === 'over';
const CAND = [
  ['Jabber: ahead on health (S563 trial)', 0, (c) => c.him.hp > c.me.hp, 'shoulder'],
  ['Jabber: he backed off last beat', 0, (c) => c.hisLast && c.hisLast.feet === 'back', 'shoulder'],
  ['Jabber: his last punch landed', 0, (c) => c.hisLanded, 'shoulder'],
  ['Slugger: stamina 3 or less (S563 trial)', 1, (c) => c.him.st <= 3, 'shoulder'],
  ['Slugger: stamina 4 or less', 1, (c) => c.him.st <= 4, 'shoulder'],
  ['Slugger: you landed on him last beat', 1, (c) => c.meLanded, 'shoulder'],
  ['Slugger: he backed off last beat (S564)', 1, (c) => c.hisLast && c.hisLast.feet === 'back', 'shoulder'],
  ['Body Snatcher: you blocked his body punch (S563 trial)', 2, (c) => c.blockedBody, 'knees'],
  ['Body Snatcher: you blocked any punch of his', 2, (c) => c.blockedAny, 'knees'],
  ['Body Snatcher: he is behind on points this round', 2, (c) => c.him.pts < c.me.pts, 'knees'],
];

function bout(opp, seed) {
  const F = [R0.man(N.hp), R0.man(R0.OPPS[opp].hp)]; let range = 3, n = 0, kdOver = false;
  const ctx = { hisLast: null, hisLanded: false, meLanded: false, blockedBody: false, blockedAny: false };
  const rows = [];
  for (let round = 1; round <= N.rounds && !kdOver; round++) {
    const fk = { round: 0, last: false };   /* TELLS3: his fakes this round, and whether last beat was one */
    for (let b = 0; b < N.beats && !kdOver; b++) {
      const R = load(seed * 1000 + n); R.setOpp(opp); const t = N.beats - b;
      const T = { f: F, range, t }, his = R.ai(T) || R.plan0();
      const mine = ME === 'guard' ? guardPlan(R, range) : (R.ai({ f: [F[1], F[0]], range, t }) || R.plan0());   // the same AI in the player's corner (me=guard: a cautious player, S564)
      const truth = truthOf(his), c = { ...ctx, me: { ...F[0] }, him: { ...F[1] } };
      const v2 = tellOf(opp, his, { ...c, range }, 2);   /* TELLS2 as built: bluffs only */
      const v3 = tellOf(opp, his, { ...c, range, ACT: R0.ACT, fakesRound: fk.round, fakedLast: fk.last }, 3);   /* TELLS3 (S564): bluff by damage, the cap, second conditions */
      fk.round += v3.fake ? 1 : 0; fk.last = v3.fake;
      rows.push([...CAND.filter((k) => k[1] === opp).map((k) => (k[2](c) && k[3] !== truth ? 1 : 0)), v2.fake ? 1 : 0, v2.cue === 'still' ? 1 : 0, v3.fake ? 1 : 0]);
      const ev = R.resolve(T, [{ ...mine }, { ...his }]); R.endBeat(T); range = T.range; n++;
      ctx.hisLast = his;
      ctx.hisLanded = ev.some((e) => e.k === 1 && e.t === 'hit');
      ctx.meLanded = ev.some((e) => e.k === 0 && e.t === 'hit');
      ctx.blockedBody = ev.some((e) => e.k === 1 && e.t === 'block' && R0.ACT[e.id] && R0.ACT[e.id].line === 'body');
      ctx.blockedAny = ev.some((e) => e.k === 1 && e.t === 'block');
      for (const k of [0, 1]) if (F[k].hp <= 0) { F[k].kd++; F[1 - k].pts += 3; if (F[k].kd > N.kd.length) kdOver = true; else F[k].hp = N.kd[F[k].kd - 1]; }
    }
    for (const m of F) { m.pts = 0; m.st = m.cap; m.g = N.guard; m.ropes = 0; m.held = 0; m.kept = 0; m.gave = 0; }
    range = 3;
  }
  return rows;
}

const out = [`TELL_RATES bouts=${BOUTS} a man, seed=${SEED}, me=${ME} (the page's AI in his corner, ${ME === 'guard' ? 'a cautious guard-first player' : 'the same AI'} in yours; a lie counts when its condition holds and the cue it fakes is not the truth)`];
for (const opp of [0, 1, 2]) {
  const rows = []; for (let i = 0; i < BOUTS; i++) rows.push(...bout(opp, SEED * 100 + i));
  const cs = CAND.filter((k) => k[1] === opp), pct = (j) => { const f = rows.reduce((s, r) => s + r[j], 0); return `${f} of ${rows.length} beats = ${Math.round(100 * f / rows.length)}%`; };
  cs.forEach((k, j) => out.push(`  ${k[0]}: ${pct(j)}`));
  out.push(`  >> TELLS2 as built (${R0.OPPS[opp].n}): fakes ${pct(cs.length)}; quiet guard shown ${pct(cs.length + 1)}`);
  out.push(`  >> TELLS3 as built (${R0.OPPS[opp].n}): fakes ${pct(cs.length + 2)}`);
}
console.log(out.join('\n'));
