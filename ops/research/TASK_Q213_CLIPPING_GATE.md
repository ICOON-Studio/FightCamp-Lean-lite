# TASK Q213 - The clipping gate: per-body-pair overlap budget, measured on clips and on live minutes

Owner: Qwen (qwen3-coder, medium, `--yolo`). Worktree `C:/Users/user/AppData/Local/Temp/FightCamp-Q213`, branch `qwen/q213-clipping-gate`.
Model: qwen3-coder medium. Tier: NEW TOOL + NEW TEST only - no game script edited. Parse gate + the tool + the new test.
Advances: ACTIVE MILESTONE "PLAYABLE WITH A BOXER" step 6. Operator S119: "still a lot of clipping, find a rule to enforce
about clipping, check how pros do it".

## Why
G147 (`research/G147_CLIPPING_RULE_AND_SMOOTHING.md`, read Q1, Q2 and Q5 whole) found no studio publishes a cm
budget; shipped games use a body-only push box, surface-pinned strikes and a qualitative bar. Its recommended ship gate:
**a clip or live minute FAILS if any HEAD pair overlaps >1 cm for >1 frame, or any TORSO pair >2 cm for >3 frames**;
arms may wrap 3 cm for <=3 frames; hips/thighs <=2 cm/<=3 frames; feet <=4 cm/<=5 frames. The project has capsules and
a solver but no gate. This task builds the instrument; tuning comes after the numbers.

## What would a human do?
A QA lead runs the build, records every overlap event per body pair (depth and how many consecutive frames), and files
each event over budget with the clip name and the time - never a single average.

## Prior research
- `research/G147_CLIPPING_RULE_AND_SMOOTHING.md` (the rule)
- `research/topics/contact_collision.md` (capsules, solver, contact_stop, overlap-is-distance)
- `research/U147_DIGEST.md` (overlap duration at >3 cm), `research/C191_DIGEST.md` (what still clips)
- searched: interpenetration, clipping, penetration, capsule (prior_research.py, S119)

## Prefab check
None: this measures our own engine with our own capsules (`FightBodyCapsules.posed_parts`, used by
`tools/c223_production_gate.gd` - reuse it; never write a new capsule model).

## Build - `Godot/tools/q213_clip_gate.gd` + `Godot/tests/q213_clip_gate_contract_test.gd`
1. Per frame, every capsule of fighter A against every capsule of B: surface overlap depth (cm) = max(0, r1 + r2 -
   segment distance). Classify each pair by G147's classes: HEAD (any glove/hand/forearm/head vs head), TORSO (torso/
   chest/pelvis vs torso/chest/pelvis), ARM (arm/glove vs torso, arm vs arm), LEG (thigh/shin), FOOT. Read the capsule
   names from the model; print the mapping you used so it can be checked.
2. Events: consecutive frames over the class depth limit; an event FAILS when its run exceeds the class frame limit.
3. Two modes: `mode=live seconds=N seed=S` runs the live room with `-- as_game` exactly like `tools/s119_live_record.gd`
   (read it - no frame saving needed) and reports per class: frames over, events, failing events, worst depth, and the
   clip names both fighters were playing at the worst event. `mode=clips` runs each production boxing binding through
   `tools/c223_production_gate.gd`'s bound path on the four generated legal rows and reports the same per move.
4. Output line per class plus `Q213_GATE PASS|FAIL` and the population (bodies, seed, catalogue).
5. The test is a CONTRACT with mutants: two static capsule pairs placed 0.5 cm, 1.5 cm and 3 cm into each other for
   1, 2 and 4 frames - assert which the gate passes and fails per class. Prove it catches a mutant (CLAUDE.md: prove
   contract tests with mutants).
Do NOT change any engine constant, separation, contact_stop or clip. Deliver numbers.

## SEND-BACK 1 (S119, Claude) - on 078a9cb3, same branch
1. **HEAD class is mis-assigned.** Your worst "HEAD" event is `LeftHand>RightUpperArm-RightLowerArm` - a glove on the
   opponent's ARM (a punch landing on a guard). G147's HEAD class is glove/fist/forearm vs the opponent's HEAD sphere
   ONLY. Classify by BOTH sides of the pair: HEAD = (hand|forearm|head) x opponent head; glove vs arm = ARM; glove vs
   torso = ARM (wrap). Add a contract case that a glove 3 cm into an ARM for 4 frames is an ARM event, not HEAD.
2. **Clips mode is not what was asked.** Required: each PRODUCTION boxing binding (the C223-certified ones - read
   `FightClipBinding.gd` rows with `"provenance": "exact"`) played through `play_role` on the four generated legal
   rows exactly as `tools/c223_production_gate.gd` bound path / `tools/s119_showreel.gd` do (receiver at the move's
   certified spacing), one row per move x body. Keep the live-room AI run as `mode=live` only.
3. **Report the worst single-frame depth per class beside the gate verdict** (your TORSO 15.55 cm "passes" on run length
   alone - print it so a reader sees it; do NOT change the G147 rule).
Master now has C223 run 9 (10/36 certified): merge origin/master into your branch first. Re-run live 180 s and clips.

## SEND-BACK 2 (S120, Claude) - on 7bab1d63, same branch
Classes split is accepted (head 1 event). Clips mode still measures the wrong population, read from your own code
(`_run_clips`): (a) it drops every binding with a `"sequence"` key, so `boxing_one_two` and `boxing_double_jab` are never
played - 8 moves measured, 10 are certified; (b) the receiver sits at a constant `gap = 1.07 if hook/uppercut else 1.23`.
Each move was certified at ITS OWN spacing per body, e.g. the RamsterZ jab at 1.06 / 1.015 / 1.125 / 1.11 m on rows
A/B/C/D (`docs/previews/c223/run10_jab_bound.json`, field `fixture_spacing_m`, rows whose `candidate` starts `owned`).
A 17 cm too-close receiver manufactures torso overlap, so today's torso 28.7 cm cannot be trusted.
1. **Merge origin/master into your branch first** (S120 merges C223 run 10: RamsterZ jab + recertified one-two/double jab).
2. **Spacing from the certificate, never a constant.** For each (move, attacker rig) read `fixture_spacing_m` from the
   latest `previews/c223/run*_*.json` row with that `move` and `rig` whose `mechanical_failures` is empty
   (glob the files, newest run number wins; chains live in `run10_chain.json`). Print the spacing and the certificate
   file on every `Q213_CLIPS` line. A certified move with no certificate row is a loud `push_error`, never a default.
3. **Sequences played the production way** - mirror `tools/c223_sequence_gate.gd` (the one-two and double jab through
   `FightStagePlayer.sequence_plan` / `play_role`), measured whole, both parts.
4. Re-run `mode=clips` and `mode=live seconds=180 seed=94301`; first digest line becomes `clips N/10 pass`, plus the
   per-move worst depth table with the spacing column.

## Gate (tier: new tool + new test)
PC watchdog first (`Tools\pc_watchdog.ps1 -Once`; RED = stop). `python Godot/tools/check_scripts.py <new files>`.
`python Godot/tools/run_tests.py --only q213_clip_gate` then the tool: `Tools\godot_hidden.ps1 --path Godot --script
tools/q213_clip_gate.gd -- as_game mode=live seconds=180 seed=94301`, and `mode=clips`. Zero SCRIPT ERROR.

## Owned files
`Godot/tools/q213_clip_gate.gd`, `Godot/tests/q213_clip_gate_contract_test.gd`, `research/Q213_DIGEST.md`.
Read-only: everything else. `FightWorldLiveScreen.gd` is ~5,000 lines - windows only (`_node_a`, `_player_a`, `_body_a`).

## Deliver
Commit and push to your branch; Q213_DIGEST.md first line `clip gate: live FAIL|PASS (head N events, torso N), clips N/5 pass`,
then the per-class tables. One `python Tools/agent_comms.py send --from qwen --to claude --topic Q213 "<one line>"`.
Do NOT edit HANDOFF.md, do NOT push master. **Trap:** an average hides the defect - the gate is per EVENT (depth AND run
length), and the head class must include the glove, not only the fist bone.
