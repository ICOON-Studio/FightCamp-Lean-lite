# SCENES1 - four famous exchanges played with our switches (S567)

Owner S567: "can you find few clips of famous fights breakdowns and try to breakdown their actions with our game switches
and play it like the real clip next to the one with our player , see how it feels and if it canhelpwith balance or maybe
use it for the steam shop".

What exists: `proto/twohands/scenes.js` (the exchanges as switches, with what happened in the ring and what our rules must
say), `tools/scene_check.mjs` (the rules, in node: prints MATCH / MISMATCH a beat), `scene.html` (the page: pick an
exchange, each beat is fought on the page's own rules, then the whole thing plays straight through; built by
`tools/make_scene.py`). SOURCE OF THE SCRIPTS: the well-known descriptions of each exchange, written from memory, then each finish checked on film (below). No footage is in the repo; the page only links a search for the real clip.

## Checked on film (S567, after the owner's "Yes, download")
YouTube refused a direct download (its "confirm you are not a bot" check, not worked around), so the four clips were watched
in the owner's own browser and stepped through as contact sheets every 0.25-0.4 s. Nothing was saved to disk.
- Hearns v Duran: SEEN - a low reach with the left toward the body, about half a second later the right hand on the head,
  Duran falls forward on his face. The script's finishing beat stands. The earlier blocked body jab was not in the clip.
- Marquez v Pacquiao IV: SEEN (slow replay) - Pacquiao lunges in behind his lead hand; Marquez, low and near the ropes, dips
  to his left and the short right meets him as he arrives. The script stands. Marquez's dip is head movement (head.html).
- Ali v Foreman: SEEN - Foreman is leaning and reaching with both arms, hands NOT up, when Ali's series and the straight
  right land. THE FIRST SCRIPT WAS WRONG (it had Foreman holding both hands high): corrected to a push with the rear hand low.
- Mayweather v Hatton: SEEN IN PART - Mayweather backed toward the ropes with his guard up, Hatton lunges in, Mayweather turns
  out and Hatton's rush carries him to the corner. The hook itself is hidden at this frame rate.

## What our rules said (scene_check: 10 of 14 checks match the ring)
| exchange | in the ring | on our rules | verdict |
|---|---|---|---|
| Hearns v Duran, round 2 | a low left draws the guard; the right hand goes over the top | feint then overhand lands for 4, he goes down | MATCH - feint then overhand is real boxing: the fix for our feint loop must keep this exchange possible |
| Ali v Foreman, round 8 | Foreman punches himself out on a guard, then leans and reaches; Ali's series drops him | Foreman goes 6 stamina -> 1 after one two-punch beat into the guard; with his hands out, Ali's cross and hook both land and he goes down | MATCH (after the film corrected the script) - tiring and "a hand that is out guards nothing" already give this fight |
| Marquez v Pacquiao IV | Pacquiao steps in behind a jab; the right hand meets him | the right hand goes in moment 1, when Pacquiao's hands are still home: blocked. His jab then lands as a counter | MISMATCH - the page cannot TIME a counter: a lone punch is always moment 1 (the parked "a moment later" question, MOMENTGAP1 / wait.html) |
| Mayweather v Hatton, the check hook | Hatton rushes in; the lead hook meets him as Mayweather turns out | the step in cancels the back off; both hooks are blocked by held rear hands | MISMATCH - no check hook: a punch thrown while giving ground does nothing special against a man who steps in |

## What it suggests for balance (ideas, NOT measured)
1. A lone punch may wait for moment 2 (a timed counter). Measured before as a free wait (MOMENTGAP1 A: two bars lost) and
   feet-only (B: holds); the Marquez exchange needs the HAND to wait. A candidate: a punch held to moment 2 counts as a
   counter only against a man who stepped in this beat.
2. WITHDRAWN: "a spent man's guard is too good" came from my wrong Ali script, not from the rules.
3. The feint keeps opening the overhand when he has been shown that low line (Hearns): an input for FEINTFIX1, beside
   Kalli's "a slow punch after a feint lands for 2 less".
4. The check hook: the lead hook while giving ground lands as a counter on a man stepping in (the pull counter rule exists;
   "his step in cuts you off" switches it off).

## For the Steam shop
Our own pictures of these exchanges can be used. The real footage, the fighters' names and their likenesses cannot be
used without a licence from the promoters / broadcasters and the fighters: a store clip would show our re-enactment only,
with no name ("a counter right as he steps in"), never the film beside it. The side-by-side with the real clip is for the
owner's own study.
