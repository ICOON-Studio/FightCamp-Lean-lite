// tells.mjs - TELLS1 / TELLS2, a TRIAL in words only (S563). The page and its rules are untouched.
// Owner S563: "do you thinkwe should show opponents itentions like more draditional card games or it is fine the way it is ?"
// Not his whole plan (a card game's "intent"): ONE body cue a beat, taken from the beat he has ALREADY chosen, as a real
// boxer gives one away (John SQ336 table A: the step in, the rear shoulder loading, the level drop). Kalli's read design
// (SQ335): honest by default, and each man lies by ONE fixed rule tied to a state the player can see - no random lies.
// His AI does not know his cue is seen.
// VERSION 2 (ops/research/DESIGN_TELLS2.md, from the ALLPLAY2 reports): the lie conditions fire on about 1 beat in 5 for
// every man (tell_rates.mjs), a lie is always a BLUFF (he shows more than he throws, so a caught lie leaves a gap), a fake
// costs him 1 stamina, the front foot means nothing Inside, "quiet" is split into the back foot and a quiet guard, and the
// bell ledger says WHEN each fake came.

export const CUES = {
  shoulder: 'his rear shoulder drops back (the rear hand is loading)',
  knees: 'he bends his knees and his level drops',
  foot: 'his front foot creeps forward',
  backfoot: 'his weight sits on his back foot',
  still: 'nothing: a plain, quiet guard',
};
// what a cue means when it is true (said once, at the start of a bout)
export const MEANS = {
  shoulder: 'a big rear punch: a cross or an overhand',
  knees: 'a body punch or an uppercut',
  foot: 'a step in',
  backfoot: 'a back off or a clinch',
  still: 'none of those',
};
const BIG_REAR = ['cross', 'over'], LOW = ['bjab', 'lbody', 'rbody', 'lup', 'rup'], BODY = ['bjab', 'lbody', 'rbody'];
const THREAT = { still: 0, backfoot: 1, foot: 2, knees: 3, shoulder: 4 };

// the cue his chosen plan really gives, his biggest threat first. v1: no back foot cue, the foot counts at any range.
export function truthOf(p, range = 3, v = 1) {
  if (!p) return 'still';
  if (p.clinch) return v >= 2 ? 'backfoot' : 'still';
  if (BIG_REAR.includes(p.rear)) return 'shoulder';
  if (LOW.includes(p.lead) || LOW.includes(p.rear)) return 'knees';
  if (p.feet === 'in' && (v < 2 || range > 1)) return 'foot';   // v2: Inside a step in changes nothing, so it shows nothing
  if (v >= 2 && p.feet === 'back') return 'backfoot';
  return 'still';
}

// v2: each man's ONE lie - [the condition, in words the ledger prints, the cue he fakes]. c = the state as the beat starts:
// { me, him, hisLast (his plan last beat), meLanded (a punch of yours landed last beat), blockedAny (you blocked a punch
// of his last beat), blockedBody, range }. Rates in AI-v-AI bouts (tell_rates.mjs, 12 bouts a man): 29%, 27%, 16%.
export const LIES = [
  { when: 'the beat after he backed off', test: (c) => !!(c.hisLast && c.hisLast.feet === 'back'), cue: 'shoulder' },   // the Jabber: he backs off and shows the right hand to draw you in
  { when: 'the beat after you landed on him', test: (c) => !!c.meLanded, cue: 'shoulder' },                                   // the Slugger: hurt, he shows the bomb to stop you pressing
  { when: 'the beat after you blocked one of his punches', test: (c) => !!c.blockedAny, cue: 'knees' },                         // the Body Snatcher: blocked, he dips to bring your hands down
];

/* v3 (S564, from ALLPLAY2B Arena + Ziva and the TELLS2M bot trial):
   1. A BLUFF BY DAMAGE: he fakes only when his real beat does LESS damage than the smallest punch the cue promises
      (c.ACT given). v2 ranked cues, so a fake shoulder could hide a body cross + lead uppercut (Ziva v2 R1b4, 5 damage)
      or a double uppercut (Arena V2 R1b4, 7): "the bluff was bigger than the promise".
   2. A CAP: at most 2 fakes a round and never two beats running. TELLS2M: against a strong bot the Jabber's and the
      Slugger's conditions held on 41-46% of beats, against a careful player the Slugger lied 2 of 18 - a rate that
      follows the player's style. The cap bounds the top; a second condition of HIS OWN state lifts the bottom.
   3. A SECOND CONDITION for the two men whose first depends on what YOU do (the Slugger: you landed; the Body Snatcher:
      you blocked). Both are on screen: his stamina bar, his last beat in his card. */
export const LIES3 = [
  [LIES[0]],
  [LIES[1], { when: 'when he was on 3 stamina or less', test: (c) => c.him.st <= 3, cue: 'shoulder' }],
  [LIES[2], { when: 'the beat after he threw a body punch', test: (c) => !!(c.hisLast && BODY.some((x) => c.hisLast.lead === x || c.hisLast.rear === x)), cue: 'knees' }],
];   /* S564 tell_rates opp=2: 'behind on points' held on 5% of beats against a careful player; 'after his body punch' 22% */
export const CAP3 = { round: 2 };
/* v4 (S566 TELLS4M, from TELLS3M: blind covering cost nothing, a fake hid under 3 damage):
   a. a fake shoulder may hide ONE punch of exactly 3 damage on a line the shoulder's cover (both hands high) leaves open
      - never two punches, never more than 3. With the page's punches that is a lead uppercut, Inside.
   b. the Body Snatcher also fakes the shoulder on his second condition (the beat after he threw a body punch), inside the
      same cap of 2 fakes a round, never two running. v2 and v3 calls are unchanged. */
export const LIES4 = [LIES3[0], LIES3[1], [...LIES3[2], { when: LIES3[2][1].when, test: LIES3[2][1].test, cue: 'shoulder' }]];
const OPEN4 = { shoulder: ['body', 'under'] };   // the lines both-hands-high leaves open (the page's COVER.high = straight, side)
const hits = (p, A) => (p && !p.clinch ? [p.lead, p.rear].filter((id) => id && A[id] && A[id].d) : []);
// v4: may this real beat stand behind a fake of this cue? (a bluff by damage, or the one hidden 3 on an open line)
export function fakeOk4(p, cue, A) {
  if (dmgOf(p, A) < promiseOf(cue, A)) return true;
  const h = hits(p, A);
  return !!OPEN4[cue] && h.length === 1 && A[h[0]].d === 3 && OPEN4[cue].includes(A[h[0]].line);
}
const dmgOf = (p, A) => (p && !p.clinch ? ((p.lead && A[p.lead] && A[p.lead].d) || 0) + ((p.rear && A[p.rear] && A[p.rear].d) || 0) : 0);
const PROMISE = { shoulder: BIG_REAR, knees: LOW };
const promiseOf = (cue, A) => Math.min(...(PROMISE[cue] || []).filter((id) => A[id] && A[id].d).map((id) => A[id].d), 99);
/* v3 teaches it (Arena fix 2, Ziva fix 1): the legend says what a fake hides and what the quiet guard does not cover */
export const LEGEND3 = 'A FAKE ALWAYS HURTS LESS THAN IT SHOWS: a fake shoulder hides a beat weaker than a cross, a fake knees bend a beat with no punch. He fakes at most twice a round, never two beats running. A quiet guard does not cover his LEAD hand: a jab or a lead hook can still come.';

// opp: 0 Jabber, 1 Slugger, 2 Body Snatcher. p: his chosen plan. c: the state (see LIES). v: 1 (the first trial), 2 or 3.
// Returns { cue shown, truth, fake, when (v2: the condition of a fake, for the ledger) }.
export function tellOf(opp, p, c, v = 1) {
  const truth = truthOf(p, c.range, v), lie = (cue, when) => ({ cue, truth, fake: cue !== truth, when: cue !== truth ? when : '' });
  if (v >= 4) {   // as v3, with LIES4 and fakeOk4
    const capped = (c.fakesRound || 0) >= CAP3.round || !!c.fakedLast;
    if (!capped) for (const L of LIES4[opp] || []) if (L.test(c) && L.cue !== truth && fakeOk4(p, L.cue, c.ACT)) return lie(L.cue, L.when);
    return lie(truth, '');
  }
  if (v >= 3) {   // c also carries ACT (the page's punches), fakesRound (his fakes this round) and fakedLast (last beat was one)
    const capped = (c.fakesRound || 0) >= CAP3.round || !!c.fakedLast;
    if (!capped) for (const L of LIES3[opp] || []) {
      const bluff = c.ACT ? dmgOf(p, c.ACT) < promiseOf(L.cue, c.ACT) : THREAT[L.cue] > THREAT[truth];
      if (L.test(c) && L.cue !== truth && bluff) return lie(L.cue, L.when);
    }
    return lie(truth, '');
  }
  if (v >= 2) {
    const L = LIES[opp];
    if (L && L.test(c) && THREAT[L.cue] > THREAT[truth]) return lie(L.cue, L.when);   // a bluff only: he shows more than he throws
    return lie(truth, '');
  }
  // v1 (the first ALLPLAY2 bouts)
  if (opp === 0 && c.him.hp > c.me.hp) return lie('shoulder');                  // the Jabber, ahead on health: he shows the load, then jabs
  if (opp === 1 && c.him.st <= 3 && truth === 'still') return lie('shoulder');  // the Slugger, tired: he shows the load and holds
  if (opp === 2 && c.blockedBody && truth !== 'knees') return lie('knees');     // the Body Snatcher, after you blocked his body punch
  return lie(truth);
}

const NAME = { still: 'quiet guard', shoulder: 'rear shoulder drop', knees: 'knees bend', foot: 'front foot creeps', backfoot: 'weight on the back foot' };
// the tally a player sees at each bell: every cue he showed this round, true or fake (v2: and WHEN each fake came)
export function ledger(list) {
  const by = {};
  for (const t of list) { const b = (by[t.cue] = by[t.cue] || { n: 0, fake: 0, when: {} }); b.n++; if (t.fake) { b.fake++; if (t.when) b.when[t.when] = (b.when[t.when] || 0) + 1; } }
  const parts = Object.keys(by).map((c) => { const w = Object.entries(by[c].when).map(([k, n]) => `${n === by[c].fake ? (n > 1 ? 'all' : 'it') : n} ${k}`).join(', ');
    return `${NAME[c]} ${by[c].n} (true ${by[c].n - by[c].fake}, fake ${by[c].fake}${w ? ': ' + w : ''})`; });
  return parts.length ? `HIS TELLS THIS ROUND: ${parts.join(', ')}` : '';
}
