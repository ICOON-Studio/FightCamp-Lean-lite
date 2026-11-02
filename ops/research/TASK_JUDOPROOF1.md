# TASK JUDOPROOF1 - prove ONE judo throw (osoto-gari) end to end before we buy 25 grappling clips

Model: Codex gpt-6.1-sol, medium (animation work; operator rule S187/S184: never astra). Worktree E:/FightCamp/wt/JUDOPROOF1, branch codex/judoproof1 from master. Push the branch; never master/HANDOFF.md/AgentComms/.
No windows/viewers/browsers; windowed Godot ONLY via `Tools\godot_hidden.ps1`; `timeout` 300 s per headless run; parse gate `python Godot/tools/check_scripts.py <files>` first.

## Why
Operator S196: "the animation needs to be like real human-like fight; I want to know what the cost will be". Ludo R27 (LUDO_ANIMATION_R27_S196.txt s3 GROUP 1 ashi-waza, s4 cost) priced judo at 14 base paired clips x $312 (8.5 h cleanup each) = $4,368, UNMEASURED. Judo has ZERO dedicated clips today
(technique_catalog `judo_osotogari` is a FAMILY clip). This task measures the real hours and quality of one throw so the plan rests on a number.
Operator choice S196: prove one throw first, then continue the design.

## What to build (no paid source; authored from Ludo's timeline)
Osoto-gari (outer reap), tori reaps uke's planted leg. Timeline from Ludo (ms): 0-180 kuzushi (sleeve pull down, collar drive up/back, uke 90% weight on the target leg, uke spine -14 deg); 180-280 entry (chest to chest, dX 28 cm outside uke's lead foot,
dZ -12 cm, tori pelvis 8 cm lower); 280-420 kake (reap, uke's planted foot leaves the mat, uke pelvis pitch 420 deg/s); 420-650 ukemi (uke slap 45 deg from torso 40 ms before back impact; tori keeps sleeve control). Treat Ludo's numbers as a first guess: where a real throw would differ, say so and use the real value.
1. NEW pure module `Godot/scripts/rules/JudoThrowKeys.gd`: key poses for both fighters as data (22 SkeletonProfileHumanoid bone rotations + root position per key, times in ms) for osoto-gari, a sample function `sample(t_ms) -> {tori:{...}, uke:{...}}`, and the grip sockets (tori hands -> uke sleeve/collar points) as per-frame world points.
2. NEW `Godot/scripts/JudoThrowPlayer.gd`: plays the sampled keys on two real fighter rigs (see `PairedClipMount.gd`, `PairedStagePlayer.gd`, `tools/preview_paired_clip.gd` for how a paired clip is mounted on two fighters; FightClipBinding.gd PAIRED_BINDINGS line ~2038 is the table format) and enforces the grip sockets with the existing contact solver (`FightPoseSolver.gd`) so hands stay on the gi points.
3. NEW `Godot/tools/judo_throw_stills.gd`: renders stills from the GAME camera (`record_room ... as_game`; save ONLY through `Godot/tools/still_framing.gd` `save_if_framed`, both men head to feet) at 0, 180, 280, 420, 550, 650 ms, plus a CSV of per-frame joint positions for both fighters (schema: LUDO_ANIMATION_R27_S196.txt s5.1, 60 Hz).
4. NEW `Godot/tools/judo_throw_metrics.py`: from that CSV compute foot sliding of the planted feet, grip distance error (hand to socket), COM of uke vs tori base of support at kake, peak joint speed, jerk. Thresholds: start from Ludo s5 numbers, print achieved beside wanted, never gate an exact count.
5. NEW test `Godot/tests/judo_throw_keys_test.gd`: RED first on master (module missing). Checks: both skeletons keep bone lengths within 1% across the clip, hands within 3 cm of sockets 0-420 ms, uke feet off the mat only inside 280-650 ms, uke ends on the mat on the back, a MUTANT that drops the sleeve socket makes the grip check fail (control arm that cannot share the bug).

## Measure and report (the point of the task)
Write `research/JUDOPROOF1_REPORT.md`: wall-clock hours you spent on each step (keys, player, grips, tuning), how many tuning rounds, what the contact solver fixed by itself versus what needed hand keys, the metric table (achieved vs wanted), and a plain verdict: would this throw pass as a real osoto-gari to a judoka, and what is the honest hours-per-throw to reproduce for 13 more? Do not describe stills you cannot see: report pixel/geometry facts; Claude opens the stills.

## Owned files
Only the five NEW files above + the report + `previews/judoproof1/`. Do NOT edit FightClipBinding.gd, GameState.gd or any existing script (read-only; the solver is called, not changed).

## Prior research
`python Tools/prior_research.py judo throw paired grip`; C199_DIGEST.md, TASK_C222_GRAPPLING_FROM_SUIT_VIDEO.md, LUDO_GRAPPLING_R14_S193.md.
## What would a human do?
Watch a real osoto-gari (kuzushi first, uke's weight on the heel, hips close, reap with the whole leg, tori stays upright); the throw is the uke's weight leaving the ground, not tori's leg moving.
## Prefab check
Mixamo/CMU have no judo pair (C75); RamsterZ paired set is BJJ/wrestling not judo; so authored keys is the route under test.

Final message: red count, green runs, metric table, hours, stills paths.
