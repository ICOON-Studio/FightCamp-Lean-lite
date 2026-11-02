# TASK KM3B (S219) - unbury the neck on the MetaHuman men (fighter_reachability_contract nightly red)

Model: Codex sol (gpt-6.1-sol, NEVER astra). Own seeded worktree E:/FightCamp/wt/KM3B, branch codex/km3b from master. Never master.
Queue: after FLYFOOT1 and TECHSTAGE1 FIX5.

## Primary source (Claude S219)
`Godot/tests/fighter_reachability_contract_test.gd` now witnesses the SHIPPED bodies (MetaHuman mh_boxer_01 1.83 m + mh_boxer_04
1.90 m via MetaHumanRig.load_fighter; MPFB is banned). On master it reads `checks=24 failures=8`: neck 0.15 and 0.50 have NO usable
approach on both men (E:/FightCamp/tmp/reach_s219.txt). Cause (KM2/KM3): the thorax capsule (Chest -> Neck, FighterCapsules.gd
CAPSULE_DEFS "thorax") ends AT the Neck bone and its hemispherical cap reaches a full radius past it, burying the neck.

## Candidate fix already written: Arena PR #43 (branch arena/01a10416-fightcamp, 2026-10-04, never merged)
`"cut": "shoulder_line"` on the thorax def: the far endpoint moves to where Chest->Neck crosses the mean UpperArm origin, AFTER the
radius is measured over the full span; `posed()` re-applies the cut. Its own numbers (MPFB era): 27-29/128 usable neck approaches;
G73 upper-chest hold 47.94 -> 45.48 % (f01), 46.65 -> 41.38 % (f02); FALL 26.86 -> 22.29 %, 47.64 -> 31.69 %, and on the then
shipped men FALL 33.33 -> 7.18 % - that last drop is UNJUDGED: find out what FALL measures and whether 7 % is right or a regression.
Master has moved since (a1a6f85f "inlet radius unburies the neck, holes the rib cage") - port the cut onto master by DIFF, do not
take the file from the branch.

## Do
1. Red first: the reachability test on master (8 failures) + the G73 hold / FALL numbers on the MetaHuman men on master.
2. Port the cut, re-measure: reachability >= 5 usable approaches at every pair, G73 hold not collapsing (S55 split_inlet took 47% ->
   5%: anything below 35 % is a fail), FALL explained with a real-boxing reason, the C154 posed witness green.
3. `python Godot/tools/run_tests.py --jobs 2 --only capsule,reach,clinch,c223,posed` (parse gate first). Then the C223 production
   gate on 4 certified pairs (Tools/c223_parallel.py production) - contacts move when the chest capsule shortens.
4. Report a table master vs fix for every number above. If PR #43's cut fails, say why and propose the next geometry.

## VISUAL GATE
Not a body/animation look change by itself, but contacts move: attach one game-camera still pair (guard + a body hook contact)
through record_room.gd -- as_game + still_framing.gd save_if_framed, and report gap / noses / wrists / feet per still.

## Prior research
Q220_DIGEST.md (PR #43's digest), KM1_GAME_REVIEW.md, KM2 notes in FighterCapsules.gd, G73 hold tests, S55 split_inlet history.

## Prefab check
None - our own capsule geometry.

## The one trap
Do not retire or loosen the neck pairs to pass - the test says the red is the real defect.
