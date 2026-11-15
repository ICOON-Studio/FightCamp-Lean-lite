# TASK BODYLOOK1 - the fighters' and coach's bodies look stitched (his S490 play)

Seat: Ziva (3D fight motion; Lean worktree E:/FightCamp/wt/ZIVA_LEAN). Model: Ziva's own. Discipline: boxing (demo).
Owner of the verdict: Claude opens every still; the operator closes it (visual gate, WORKFLOW s2).

## What he saw (verbatim, after playing the S490 build, 2026-11-15)
1. Corner coach: "terrible neck blending" - grey-haired head on a navy shirt, a visible seam where head meets body.
2. Fighters: "the humans do not look normal their shoulders look weird and their walking too".
3. "sometimes you can see through them (they seem like arts poorly stitched together)".

## Job: MEASURE FIRST, name the cause per symptom, then fix
- Stills from the live fight's own camera: `tools/fight3d_play.gd` on the hidden desktop (CLAUDE.md "Stills"), both
  boxers, guard + walking (ring walk / between exchanges) + mid-move; the corner minute for the coach (p05_corner_card).
  Every fight still through `still_framing.gd save_if_framed` (no feet-only stills).
- Per symptom, name the layer: mesh (missing part, gap at the collar, wrong cull mode / backface culling off on a
  single-sided part, alpha/transparency on skin or clothes material, depth draw mode), skin weights (shoulder candy-wrap),
  or the motion layer (the walk clip / foot plant / arm IK). Print the material settings of each body part you suspect.
- Fix the cause, never hide it with the camera. Coach head: one mesh or a collar/hair cover at the join.

## Acceptance
- Before/after stills of each symptom from the same camera and moment, opened and listed in the PR body.
- No new test is needed for a material fix; a motion change runs `golden_path_test` and the fight motion tests it touches
  (`sh tools/run_tests.sh` names; never the full suite).
- Owned files: the body/coach scenes and materials under assets/ and scripts/fight3d you name in the PR body first.

## Prior research
- `python ops/Tools/prior_research.py shoulder neck seam backface see-through walk` (S491): STAFF1_DIGEST notes
  "sleeve/shoulder deformation is still less polished" on the clothed MetaHuman staff; HANDOVERS_S349_S417 (VersusLive
  blended seam). Bodies are MetaHuman only (never MPFB/generators).

## What would a human do?
A technical artist opens the model in the editor, toggles each mesh part, checks the material cull/transparency flags
and the weight paint at the shoulder, and plays the walk clip beside a reference walk before touching any code.

## Prefab check
MetaHuman bodies are the house rule (memory feedback_metahuman_only_no_mpfb). No new asset buys (mocap packs: end of
November, his call).

## Contract
OWNS: scripts/fight3d/BoxerBuild.gd, scripts/fight3d/CornerCrew.gd, scripts/fight3d/BoxerFootwork.gd, assets/models/metahuman, assets/models/kit, docs/playtest/bodylook1 (more body files only if named in the PR body first)
RED_TEST: tools/fight3d_play.gd (before stills of each symptom on the game camera are the red)
REGRESSION: tests/golden_path_test.gd plus the fight motion tests a motion change touches (sh tools/run_tests.sh names)
VISUAL: yes
