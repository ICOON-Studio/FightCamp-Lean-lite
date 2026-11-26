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
const BIG_REAR = ['cross', 'over'], LOW = ['bjab', 'lbody', 'rbody', 'lup', 'rup'];
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

// opp: 0 Jabber, 1 Slugger, 2 Body Snatcher. p: his chosen plan. c: the state (see LIES). v: 1 (the first trial) or 2.
// Returns { cue shown, truth, fake, when (v2: the condition of a fake, for the ledger) }.
export function tellOf(opp, p, c, v = 1) {
  const truth = truthOf(p, c.range, v), lie = (cue, when) => ({ cue, truth, fake: cue !== truth, when: cue !== truth ? when : '' });
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
