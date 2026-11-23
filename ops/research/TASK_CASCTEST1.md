# TASK CASCTEST1 - Cascadeur FREE tier: prove AutoPhysics on our cross take, ready for Pro at the month end (S537)

Status: DONE (collected e668b108f; marked S540)

Model: claude-fable-5-2 (Code Mode console in E:\FightCamp\Lean). Discipline: boxing (demo).
Owner S537: "use the free tier, i can afford it at the end of month". LICENCE: Cascadeur Free is NON-COMMERCIAL and saves .casc
only (ops/research/K41_EXPORT_LICENCES.md). So: this is an evaluation and a recipe. NOTHING made on the free tier enters
assets/, the game or a build; .casc files stay under ops/Tools/cascadeur/casctest1/ (local, git-ignored if large).
Owner S537 METHOD: "the power does not come from twisting the knee use our research/clips when you make animations".

## Why
The bought takes are clean but our code re-bends them; FP2POSE2 twisted the rear knee outward. Cascadeur's AutoPhysics
(balance, centre of mass, momentum) and inbetweening (smooth joins) could clean a take ONCE at the bake instead of code layers
every frame (FIGHTPLAYER2_SCOPE_S510 method). Test it before any money is spent.

## Do
1. Bring Cascadeur up hidden with its script server: `python ops/Tools/cascadeur/ensure_server.py --hidden` (read its header
   and ops/Tools/cascadeur/README.md first; the traceback trap at step 3). Say whether the FREE tier allows the script server
   and FBX import at all. If not: stop and write exactly what the free tier blocks.
2. Import the source FBX of the pro right cross (the take v2 plays: find it from scripts/fight3d/v2 / assets/anim sources; NOT
   the baked .res) on our MetaHuman skeleton (ops/Tools/cascadeur/dump_rig.py, animsource1/ for the rig setup done before).
3. Measure in Cascadeur's Python, BEFORE: rear knee yaw relative to the rear foot, rear knee extension prep->contact, rear ankle
   extension, rear heel height, hip forward travel, centre of mass over the base. Reference numbers: K46_BOXER_FEET_DURING_PUNCHES.md
   (ankle ~12 deg, knee extension ~25 deg, knee ~143 at impact, GRF 61/39), CROSS_POWER_S439.md (hips ~28 cm forward, ~11 cm
   through). Then run AutoPhysics (and, for the join, inbetweening guard -> cross -> guard) and measure AFTER.
4. Pictures: viewport stills / a short side capture on the hidden desktop only (never on his monitors), before vs after,
   `ops/previews/s537_casctest1/`. Open them yourself.
5. `docs/CASCTEST1_RESULT.md`: what the free tier allows, the before/after table against the reference numbers, your verdict
   (does AutoPhysics move us toward the reference without the knee twist?), and THE RECIPE for Pro at the month end: the exact
   steps to export the cleaned takes to FBX and through our bake + tests/retarget_fidelity_test.gd + player2_test.gd.

## Prior research
ops/Tools/cascadeur/README.md, ops/research/ANIMSOURCE1A_DIGEST.md, ANIMSOURCE1B_DIGEST.md, C135_CASCADEUR_HELD_POSE.md (what
failed: no finished pose was ever produced - finish one take end to end), J30_MOVE_SCRIPT_METHOD.md, K41_EXPORT_LICENCES.md.

## What would a human do?
An animator drops the mocap take into Cascadeur, turns on AutoPhysics, checks the balance and the drive from the floor, and
fixes the knee by moving the hip and foot, not the knee.

## Prefab check
Cascadeur is owned software (installed); the takes are our bought pack.

## Contract
OWNS: ops/Tools/cascadeur/casctest1/ (scripts; .casc local), docs/CASCTEST1_RESULT.md, ops/previews/s537_casctest1/
RED_TEST: none (an evaluation)
REGRESSION: none (no game file touched)
VISUAL: stills opened by you

## Rules
Nothing opens on his monitors (hidden desktop only; kill Cascadeur by PID when done). Watchdog before starting; one heavy job.
No game file, no assets/ file. `git add -- <new>` then `git commit -m ... -- <your paths>` with
`Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`, push, report in two lines, stop.
