// ROUND 9 (TASK_CARDROUND9): the FLOOR moves, resolved - audit 4c, before and after for EACH man. Split out of engine.mjs
// when the round-9 model pushed that file past the owner's 500-line limit. It is the same code, moved: each move names
// whose place changes, the other man's window is read off the join, and nothing here touches the rules of a laid card.
import { CARDS, N } from './cards.mjs';
import { legalNow, place, placeBoth, hit, strikeFits, fxOf } from './engine.mjs';
import { kickDmg, putHold, holdLegs } from './floor.mjs';

// a MOVE: before and after for EACH man, and the other man's window (audit 4c)
function resolveMove(S, a, p, ans) {
  const d = 1 - a, id = p.id, fx = ans ? fxOf(ans) : null;
  // a move laid at a pair that no longer holds (the other man rose, walked off, or was stood up by the referee) whiffs,
  // exactly as a card does - except the CLINCH ENTRY, which reads the two men instead of the join
  if (!legalNow(S, a, id) && !(id === '@in' && S.at[a] === 'stand' && S.at[d] === 'stand')) { if (S.st) S.st.whiff++; return; }
  if (id === '@in') {
    if (S.at[a] === 'stand' && S.at[d] === 'stand') {
      // at KICK, Step in only closes the range; at PUNCH it is the clinch entry, and the man coming in can be hit
      if (S.j.reach === 'K') S.j = { kind: 'apart', reach: 'P' };
      else if (fx && strikeFits(S, d, ans, 'P')) { const c = CARDS[ans]; hit(S, d, a, c.dmg, c.pts || 0); if (!S.over) placeBoth(S, S.at.slice(), { kind: 'clinch', by: a }); }
      else placeBoth(S, S.at.slice(), { kind: 'clinch', by: a });
      return;
    }
    if (!S.j.leg) { S.j = { kind: 'apart', leg: true }; return; } // step into the reach of his feet

    if (fx === 'up') { hit(S, d, a, kickDmg(ans, CARDS.upkick.dmg), 0); if (S.st) S.st.upkicks++; return; } // kicked on the way in and he stays up
    placeBoth(S, a === 0 ? ['gtop', 'gbot'] : ['gbot', 'gtop'], { g: 'open' }); S.tie = null; S.stall = 0;
    if (S.st) S.st.downs++;
    return;
  }
  if (id === '@out') {
    if (S.j.kind === 'clinch') { // leaving a clinch is fought for (audit 2a MISSING-LINK, M15)
      const holder = S.tie ? S.tie.by : -1;
      if (ans === '@pull') { // the tie holder drags him back down off the tie
        placeBoth(S, d === 0 ? ['gbot', 'gtop'] : ['gtop', 'gbot'], { g: 'closed' }); S.tie = null; S.stall = 0; S.post = a; // C1
        if (S.st) S.st.pulls++;
        return;
      }
      if (fx && strikeFits(S, d, ans, 'C')) { const c = CARDS[ans]; hit(S, d, a, c.dmg, c.pts || 0); }
      S.tie = null;
      if (!S.over) placeBoth(S, S.at.slice(), { kind: 'apart', reach: 'P' });
      void holder;
      return;
    }
    if (S.at[a] === 'stand' && S.at[d] === 'stand') { S.j = { kind: 'apart', reach: 'K' }; return; }
    if (fx === 'up') { hit(S, d, a, kickDmg(ans, CARDS.upkick.dmg), 0); if (S.st) S.st.upkicks++; } // kicked as he leaves
    if (!S.over) S.j = { kind: 'apart', leg: false };
    return;
  }
  if (id === '@stand') { // the boxer stands up out of his guard: the BJJ man STAYS on his back (the owner's case)
    if (ans === 'sweep') { placeBoth(S, a === 0 ? ['gbot', 'gtop'] : ['gtop', 'gbot'], { g: 'open' }); S.stall = 0; if (S.st) S.st.sweeps++; return; }
    if (ans && CARDS[ans]?.k === 'hold') { putHold(S, d, ans); return; } // an arm attack as his posture opens
    // pair 4: standing in his guard. E2: standing up in a CLOSED guard opens it - unless he pays Hold the legs (B4)
    if (fx === 'legs') { place(S, a, 'stand'); holdLegs(S); return; }
    place(S, a, 'stand', { g: S.j.g === 'closed' ? 'open' : S.j.g }); S.stall = 0; return;
  }
  if (id === '@gnp') { // F1: the jiu-jitsu fighter's punch from on top; the Escape card recovers guard as he punches
    if (ans === 'escape') { placeBoth(S, a === 0 ? ['gtop', 'gbot'] : ['gbot', 'gtop'], { g: S.j.top === 'side' ? 'closed' : 'half' }); return; }
    const dmg = Math.max(0, N.topDmg - (fx === 'cover' ? N.cover : fx === 'block' ? N.block : 0));
    if (dmg > 0 && N.topTko) S.gnpHit = true; // the referee's stoppage count (A2) - switched in cards.mjs N
    hit(S, a, d, dmg, 0); S.stall = 0; if (S.st) S.st.topPunches = (S.st.topPunches || 0) + 1;
    return;
  }
  if (id === '@post') { // C2: he posts on an arm to sit up, and the arm can be taken
    if (ans && CARDS[ans]?.k === 'hold') putHold(S, d, ans); else { S.post = null; if (S.st) S.st.posts = (S.st.posts || 0) + 1; }
    return;
  }
  if (id === '@back') {
    if (fx === 'legs') { holdLegs(S); return; } // B4: the back-away fails, the legs lock round him again
    if (ans === 'sweep') { placeBoth(S, a === 0 ? ['gbot', 'gtop'] : ['gtop', 'gbot'], { g: 'open' }); S.stall = 0; if (S.st) S.st.sweeps++; return; }
    if (fx === 'up') { hit(S, d, a, kickDmg(ans, CARDS.upkick.dmg), 0); if (S.st) S.st.upkicks++; return; } // kicked as he backs out
    // BACK AWAY IS OUT OF HIS LEGS, NOT A TAKEDOWN. This used to knock the OTHER man to his back unconditionally, so a
    // boxer laying Back away in a clinch put the jiu-jitsu man on the floor and stayed standing himself - the clinch
    // turned into a knock-down for the man who did nothing. Audit 4c: "Back away (boxer, out of the guard)" is the
    // ground move (pair 4 -> pair 3); out of a CLINCH the step off contact is Step out, which the tie holder may answer.
    if (S.j.kind === 'clinch') { S.tie = null; placeBoth(S, S.at.slice(), { kind: 'apart', reach: 'P' }); S.stall = 0; return; }
    place(S, d, 'back'); S.j = { kind: 'apart', leg: true }; S.stall = 0; return; // pair 3, in leg range
  }
  if (id === '@pull') {
    const tied = S.tie && S.tie.by === a;
    if (!tied) { place(S, a, 'seat'); S.j = { kind: 'apart', leg: true }; S.stall = 0; if (S.st) S.st.sits++; return; } // SIT DOWN: he sits, the boxer stays standing
    S.tie = null;
    if (fx === 'sprawl' || fx === 'base') { placeBoth(S, a === 0 ? ['seat', 'stand'] : ['stand', 'seat'], { kind: 'apart', leg: true }); S.tried = a; S.stall = 0; if (S.st) S.st.sprawled++; return; } // the Sprawl card, or Keep your base (9b B1)
    // the pull off his own tie IS a settled position: the boxer comes down into the guard with his arm and head still
    // held, so a hold may follow in the same volley (audit 4c, the MISSING-LINK row). A hold needs a settled position,
    // and a pull made from a tie is exactly that - it is not the volley of a takedown.
    placeBoth(S, a === 0 ? ['gbot', 'gtop'] : ['gtop', 'gbot'], { g: 'closed' }); S.stall = 0;
    S.gpass = S.pass; S.gby = a; S.post = d; // C1: pulled down bent over - his posture is broken
    if (S.st) S.st.pulls++;
    return;
  }
  if (id === '@kick') { // 9b B3: the up-kick with no card, off his back at a standing man inside the reach of his feet
    hit(S, a, d, Math.max(0, N.kickDmg - (fx === 'cover' ? N.cover : fx === 'block' ? N.block : 0)), 0); S.stall = 0; if (S.st) S.st.upkicks++;
    return;
  }
  if (id === '@up') {
    // a punch as he rises: the window is the pair he is getting up OUT OF (in leg range of a standing man), read BEFORE
    // the place moves and the join is rebuilt from the new places. Read after, the window was always gone; read off a
    // name the join does not always have, it was always open. The rise is answerable like any entry (audit 4c).
    if (S.j.leg !== false) { hit(S, d, a, N.riseDmg, 0); if (S.st) S.st.riseHits++; if (S.over) return; }
    place(S, a, 'stand'); S.stall = 0; if (S.st) S.st.rises++;
    return;
  }
}
// D1, E1 (audit 9a): a punch thrown from inside the guard, or down from standing in it, is an arm given. The man
// underneath answers the punch itself: it does not land, and his hold is on (from standing the puncher is pulled back
// down, bent over) - or, against the standing man, he sweeps him as he punches.
export function guardCatch(S, a, ans) {
  const d = 1 - a;
  if (S.st) S.st.catches = (S.st.catches || 0) + 1;
  if (ans === 'sweep') { placeBoth(S, d === 0 ? ['gtop', 'gbot'] : ['gbot', 'gtop'], { g: 'half' }); S.f[d].pts += CARDS.sweep.pts; S.gpass = S.pass; S.stall = 0; if (S.st) S.st.sweeps++; return; }
  if (S.at[a] === 'stand') { placeBoth(S, a === 0 ? ['gtop', 'gbot'] : ['gbot', 'gtop'], { g: 'closed' }); S.post = a; }
  putHold(S, d, ans);
}
export { resolveMove };
