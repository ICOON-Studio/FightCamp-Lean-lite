# SCENES1 - four famous exchanges played with our switches (S567)

Owner S567: "can you find few clips of famous fights breakdowns and try to breakdown their actions with our game switches
and play it like the real clip next to the one with our player , see how it feels and if it canhelpwith balance or maybe
use it for the steam shop".

What exists: `proto/twohands/scenes.js` (the exchanges as switches, with what happened in the ring and what our rules must
say), `tools/scene_check.mjs` (the rules, in node: prints MATCH / MISMATCH a beat), `scene.html` (the page: pick an
exchange, each beat is fought on the page's own rules, then the whole thing plays straight through; built by
`tools/make_scene.py`). SOURCE OF THE SCRIPTS: the well-known descriptions of each exchange, written from memory - NOT yet
checked against the film frame by frame. No footage is in the repo; the page only links a search for the real clip.

## What our rules said (scene_check: 8 of 14 checks match the ring)
| exchange | in the ring | on our rules | verdict |
|---|---|---|---|
| Marquez v Pacquiao IV, the counter right | Pacquiao steps in behind a jab; the right hand lands over it; he is out | the right hand is thrown in moment 1, when his hands are still home: blocked. His jab then lands as a counter | MISMATCH - the page cannot TIME a counter: a lone punch is always moment 1. This is the parked "a moment later" question (MOMENTGAP1, wait.html) seen from a real fight |
| Ali v Foreman, round 8 | Foreman punches himself out on a guard; Ali's three punches then drop him | the tiring works (Foreman 6 stamina -> 1 after one two-punch beat into the guard), but a spent Foreman holding both hands high still blocks everything | HALF - stamina is right, a spent man's guard is too good: nothing of Ali's lands |
| Hearns v Duran, round 2 | a body jab draws the lead hand down; the same look, then the right hand over the top | body jab blocked low; feint then overhand lands for 4 and he goes down | MATCH - feint then overhand is real boxing. The fix for our feint loop must keep this exchange possible (after he was shown the body jab the beat before) |
| Mayweather v Hatton, the check hook | Hatton rushes in with a hook; the lead hook meets him as Mayweather gives ground | the step in cuts off the back off; both hooks are blocked by held rear hands | MISMATCH - no check hook: a punch thrown while backing off does nothing special against a man who steps in |

## What it suggests for balance (ideas, NOT measured)
1. A lone punch may be thrown in moment 2 (a waited counter). Already measured as a free wait (MOMENTGAP1 A: two bars lost)
   and as feet-only (B: holds); the Marquez exchange needs the HAND to wait. A candidate: a held hand that punches
   second counts as a counter only against a man who stepped in this beat.
2. A man at 1 stamina or less blocks with a broken guard (as at guard 0). Feedback loop to cap: tired -> hit more -> down;
   it must not turn every third round into a knockdown (watch knockdowns a bout and stoppages).
3. The feint keeps opening the overhand when the SAME line was shown the beat before (Hearns): a design input for
   FEINTFIX1, beside Kalli's "a slow punch after a feint lands for 2 less".
4. The check hook: backing off with the lead hook against a man stepping in lands as a counter (the pull counter rule
   exists; it is switched off by "his step in cuts you off").

## For the Steam shop
Our own pictures of these exchanges can be used. The real footage, the fighters' names and their likenesses cannot be
used without a licence from the promoters / broadcasters and the fighters: a store clip would show our re-enactment only,
with no name ("a counter right as he steps in"), never the film beside it. The side-by-side with the real clip is for the
owner's own study.
