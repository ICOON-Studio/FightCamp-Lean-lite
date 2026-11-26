// tells.mjs - TELLS1, a TRIAL in words only (S563). The page and its rules are untouched.
// Owner S563: "do you thinkwe should show opponents itentions like more draditional card games or it is fine the way it is ?"
// Not his whole plan (a card game's "intent"): ONE body cue a beat, taken from the beat he has ALREADY chosen, as a real
// boxer gives one away (John SQ336 table A: the step in, the rear shoulder loading, the level drop). Kalli's read design
// (SQ335): honest by default, and each man lies by ONE fixed rule tied to a state the player can see - no random lies.
// His AI does not know his cue is seen, and nothing costs more for showing or faking one: this measures the FEEL only.

export const CUES = {
  shoulder: 'his rear shoulder drops back (the rear hand is loading)',
  knees: 'he bends his knees and his level drops',
  foot: 'his front foot creeps forward',
  still: 'nothing: a plain, quiet guard',
};
// what a cue means when it is true (said once, at the start of a bout)
export const MEANS = {
  shoulder: 'a big rear punch: a cross or an overhand',
  knees: 'a body punch or an uppercut',
  foot: 'a step in',
  still: 'none of those',
};
const BIG_REAR = ['cross', 'over'], LOW = ['bjab', 'lbody', 'rbody', 'lup', 'rup'];

// the cue his chosen plan really gives, his biggest threat first
export function truthOf(p) {
  if (!p || p.clinch) return 'still';
  if (BIG_REAR.includes(p.rear)) return 'shoulder';
  if (LOW.includes(p.lead) || LOW.includes(p.rear)) return 'knees';
  if (p.feet === 'in') return 'foot';
  return 'still';
}

// opp: 0 Jabber, 1 Slugger, 2 Body Snatcher. me / him: the two men as the beat starts.
// blockedBody: you blocked one of his body punches in the beat before. Returns the cue shown and whether it lies.
export function tellOf(opp, p, me, him, blockedBody) {
  const truth = truthOf(p), lie = (cue) => ({ cue, truth, fake: cue !== truth });
  if (opp === 0 && him.hp > me.hp) return lie('shoulder');                 // the Jabber, ahead on health: he shows the load, then jabs
  if (opp === 1 && him.st <= 3 && truth === 'still') return lie('shoulder'); // the Slugger, tired: he shows the load and holds
  if (opp === 2 && blockedBody && truth !== 'knees') return lie('knees');   // the Body Snatcher, after you blocked his body punch: the dip, then upstairs
  return lie(truth);
}

// the tally a player sees at each bell: every cue he showed this round, true or fake
export function ledger(list) {
  const by = {};
  for (const t of list) { const b = (by[t.cue] = by[t.cue] || { n: 0, fake: 0 }); b.n++; if (t.fake) b.fake++; }
  const parts = Object.keys(by).map((c) => `${c === 'still' ? 'quiet guard' : c === 'shoulder' ? 'rear shoulder drop' : c === 'knees' ? 'knees bend' : 'front foot creeps'} ${by[c].n} (true ${by[c].n - by[c].fake}, fake ${by[c].fake})`);
  return parts.length ? `HIS TELLS THIS ROUND: ${parts.join(', ')}` : '';
}
