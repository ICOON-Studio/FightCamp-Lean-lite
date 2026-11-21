# TASK_ANIMHANDS1 - the hit man's hands move with his reaction (owner C435 on film 15)

Model: claude-fable-5-2 (owner S512 "use fable for animations"). Discipline: boxing (demo).
Standing approval for animation fixes (owner S510): build it, film it, send it; no question needed.

## The defect (owner, review board C435, 2026-11-20, on `ops/previews/s531_film15_hit.jpg`)
"reds hands are not moving with the reaction"
Open that still yourself first. Frames 3-4: red's head and trunk snap back from the jab, but both gloves stay parked in
the air where the guard was, so the arms stretch away from a body that has left them. The hands should travel WITH the
head and trunk (a guard that is part of the body that got hit), then come back to the guard as he recovers.

## Where (fight player v2, scripts/fight3d/v2 - the only place animation work goes, METHOD S510)
- `ChoreoReact.gd` picks the reaction take; `GuardHold.gd` holds the guard; `Player2.gd` plays the layers.
- Likely cause to check first (do not assume): the guard hold / the free-hand hold keeps the gloves at their pre-hit
  place (in the world or the guard pose) on top of the reaction take, so the take's own arm motion never shows. S531
  films 11-13 added "the guard in front of the face" and "the free hand held" - read those commits (03e7a87af,
  43e7a33f6, a626cd8b0, 448325656) before changing anything.
- Fix the cause at its layer (e.g. the hold follows the head/chest bone during a reaction, or releases for the take's
  length and eases back). No new correction layer on top (METHOD: owner S510).

## Contract
OWNS: scripts/fight3d/v2/GuardHold.gd, scripts/fight3d/v2/ChoreoReact.gd, scripts/fight3d/v2/Player2.gd, tests/player2_test.gd
RED_TEST: tests/player2_test.gd (a new check: during a reaction, each glove's distance to the head stays within a bound
  of its guard distance - red on main first, then green)
REGRESSION: tests/choreographer_test.gd tests/player2_test.gd
VISUAL: one film of the v2 player (the S531 film tool) + a hit still like s531_film15_hit.jpg, opened by you, posted with
  `python ops/Tools/review_add.py --stage S534 --rating "your call" --title "Film 16: hands move with the hit" <files>`

## Rules
- Godot only through `python ops/Tools/godot_slot.py run --who animhands1 -- <command>`; windowed renders on the hidden
  desktop (tools/hidden_desktop.py). Nothing on his monitors.
- Do NOT touch these files (other sessions own them): scripts/rules/LineGrade.gd, scripts/state/LiveRound.gd,
  scripts/state/StepWire.gd (STEPPAY2, uncommitted work in progress), anything under scripts/ui or scripts/rules.
- Stage explicit paths only (`git add -- <files>`); never stash/reset/checkout ./clean. Commit to main, push when done.
- No 500+ line file: Player2.gd is at 499 lines - any new code goes in GuardHold.gd or a new small module.

## Prior research
`python ops/Tools/prior_research.py guard hold reaction hands` ; memory notes S531 films 9-15 (critics swing; the owner's
film notes since film 11 drive the loop). Mocap pack is his money call at the END OF NOVEMBER - do not ask.

## What would a human do?
An animator scrubs the hit frames, sees the IK/hold pinning the hands, and parents the guard to the chest during the hit.

## Prefab check
None needed: the reaction takes already carry arm motion; the job is to stop overriding it.

## Done
player2_test red -> green, the film and the still posted, one line on the map (`python ops/Tools/where_we_are.py done
"Film 16: hands move with hit"`), commit + push, then report in two lines.
