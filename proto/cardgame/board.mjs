// ROUND 9 (TASK_CARDROUND9): the real-fight position model on paper first, as code (CARDREAL_AUDIT section 4a, 4b).
// Each fighter has HIS OWN place, and what joins them is a separate thing. A move names whose place changes; nobody is
// moved for free. This file holds the places, the joins, the legal pairs and the plain words the page speaks. The
// engine (engine.mjs), the pilot (plan.mjs), the ladder (career.mjs) and the page (ui-text.mjs) all read this file, so a
// place cannot exist in one of them and not the others.
//
// THE PLACES (each man on his own): stand, seat (sitting up on the floor), back (flat on his back), knee, gtop (in the
// other man's guard, on top), gbot (his own guard, underneath), past (past the guard: side control, mount, the back),
// pin (on his back with his guard passed).
// THE JOIN: { kind: 'apart' | 'clinch' | 'entangled', reach: 'K' | 'P' (both standing apart), leg: true|false (one man
// down: is the standing man inside the reach of the feet), by (who holds the tie), g (guard kind closed|open|half),
// top (past kind side|mount|back) }.
//
// GrappleMap names where it has one (proto/grapplemap/bjj_slice.json): gbot = "standing vs supine w/ legs extended"
// (bottom), gtop = "posture broken full guard" (top), gbot+half = "half guard kimura" (bottom), past/back = "back w/ arm
// trapped", past/side = "chest pass" / side control, seat = the seated end of "standing vs supine".
export const PLACES = ['stand', 'seat', 'back', 'knee', 'gtop', 'gbot', 'past', 'pin'];
export const GUARD_KINDS = ['closed', 'open', 'half'];
export const PAST_KINDS = ['side', 'mount', 'back'];
// PLAIN FIGHT WORDS (round 9, item 7): no codes on the screen, ever. `own` is how you read yourself, `him` the other man.
export const WORDS = {
  stand: { own: 'standing', him: 'standing' },
  seat: { own: 'sitting on the floor', him: 'sitting on the floor' },
  back: { own: 'on your back', him: 'on his back' },
  knee: { own: 'on your knees', him: 'on his knees' },
  gtop: { own: 'in his guard, on top', him: 'in your guard, on top' },
  gbot: { own: 'in his guard, underneath', him: 'in your guard, underneath' },
  past: { own: 'past his guard', him: 'past your guard' },
  pin: { own: 'pinned under him', him: 'pinned under you' },
};
// the guard's own words (how his legs are round you) and the past-the-guard ones
export const GUARD_WORDS = { closed: 'his legs locked round you', open: 'his legs open, feet on your hips', half: 'one of his legs caught, half guard' };
export const PAST_WORDS = { side: 'side control', mount: 'mounted on him', back: 'you have his back' };
const DOWN = ['seat', 'back'];
const isDown = (p) => DOWN.includes(p);
// what joins the two men, read off the two places: no move may leave a join that a fight does not have. A join the new
// places cannot hold (a clinch with a man on the floor, a past kind with both men standing) falls back to the nearest
// real one instead of being refused - the move that put them there already said what it did.
export function joinFor(at, j = {}) {
  const [A, B] = at, g = GUARD_KINDS.includes(j.g) ? j.g : 'closed', top = PAST_KINDS.includes(j.top) ? j.top : 'side';
  const either = (...ps) => ps.includes(A) || ps.includes(B);
  if (either('gtop', 'gbot')) return { kind: 'entangled', g };
  if (either('past', 'pin')) return { kind: 'entangled', top };
  // a clinch needs two men on their feet (refused list): anything else falls back to apart with the leg reading kept.
  if (A === 'stand' && B === 'stand') return j.kind === 'clinch' ? { kind: 'clinch', by: j.by } : { kind: 'apart', reach: j.reach === 'P' ? 'P' : 'K' };
  // pair 3 and pair 7: one man on his feet, the other down. `leg` says whether the standing man is inside the reach of
  // the feet, and it is the caller's to set - a seated man is "in leg range" by default, a man walked away from is not.
  // (Round 9's first cut left seated/back men out of this branch, so every sit-down silently became out of range.)
  if (A === 'stand' || B === 'stand') return j.kind === 'clinch' && (A === 'knee' || B === 'knee') ? { kind: 'clinch', by: j.by } : { kind: 'apart', leg: j.leg !== false };
  return { kind: 'apart' };
}
// the legal pairs of audit 4b. Anything not one of these is refused with the reason below (pairOk).
export const PAIRS = [
  { z: '1', name: 'both standing, apart at KICK or PUNCH', ok: (A, B, j) => A === 'stand' && B === 'stand' && j.kind === 'apart' && (j.reach === 'K' || j.reach === 'P') },
  { z: '2', name: 'both standing, in the clinch (who holds the tie)', ok: (A, B, j) => A === 'stand' && B === 'stand' && j.kind === 'clinch' },
  { z: '3', name: 'one standing, the other seated or on his back, apart (out of / in leg reach)', ok: (A, B, j) => ((A === 'stand' && isDown(B)) || (B === 'stand' && isDown(A))) && j.kind === 'apart' },
  { z: '4', name: 'standing in his guard (the legs still round him)', ok: (A, B, j) => ((A === 'stand' && B === 'gbot') || (B === 'stand' && A === 'gbot')) && j.kind === 'entangled' && GUARD_KINDS.includes(j.g) },
  { z: '5', name: 'in his guard, on top, and in his guard, underneath', ok: (A, B, j) => ((A === 'gtop' && B === 'gbot') || (B === 'gtop' && A === 'gbot')) && j.kind === 'entangled' && GUARD_KINDS.includes(j.g) },
  { z: '6', name: 'past the guard and pinned', ok: (A, B, j) => ((A === 'past' && B === 'pin') || (B === 'past' && A === 'pin')) && j.kind === 'entangled' && PAST_KINDS.includes(j.top) },
  { z: '7', name: 'a standing man and a man on his knees', ok: (A, B, j) => ((A === 'stand' && B === 'knee') || (B === 'stand' && A === 'knee')) && (j.kind === 'apart' || j.kind === 'clinch') },
  { z: '8', name: 'both down, apart (a double sit)', ok: (A, B, j) => isDown(A) && isDown(B) && j.kind === 'apart' },
];
export const REFUSED = [
  'in his guard on top with anything but a man in his guard underneath',
  'past the guard with anything but a pinned man (and the reverse)',
  'both men on top, or both underneath',
  'a clinch with a man seated or on his back (the fence comes later)',
];
// is this a real arrangement? `at` = [place of the man in seat 0, place of the man in seat 1]
export function pairOk(at, j) {
  if (!Array.isArray(at) || at.length !== 2 || !PLACES.includes(at[0]) || !PLACES.includes(at[1])) return false;
  if (!j || !['apart', 'clinch', 'entangled'].includes(j.kind)) return false;
  return PAIRS.some((p) => p.ok(at[0], at[1], j));
}
// every legal pair as a readable key, for the test that reaches each one: places sorted + the join
export const pairKey = (at, j) => [...at].sort().join('|') + '|' + j.kind + (j.kind === 'entangled' ? '|' + (j.g || j.top) : j.kind === 'apart' ? '|' + (j.reach || (isDown(at[0]) || isDown(at[1]) ? (j.leg ? 'leg' : 'out') : '')) : j.kind === 'clinch' ? '|tie' : '');
// the ground step 0..3 that the ladder's old training states read: how far the man on top has got. Guard = 0 (full) or
// 1 (half / open); past the guard = 2 (side, mount) or 3 (the back). Read off the places, never hand-made (§5).
export const groundStep = (S, m) => {
  const me = S.at[m], him = S.at[1 - m], j = S.j;
  if (me === 'gtop' || him === 'gtop') return j.g === 'closed' ? 0 : 1;
  if (me === 'past' || him === 'past') return j.top === 'back' ? 3 : 2;
  return 0;
};
