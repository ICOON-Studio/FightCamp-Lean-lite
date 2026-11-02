# TASK HUMAN1 - heads that react: every landed hit snaps the head, near misses make it pull away (Ludo steps 1 + 3)

Model: Codex gpt-6.1-sol (CODEX_MODEL=gpt-6.1-sol - animation). Worktree E:/FightCamp/wt/HUMAN1, branch codex/human1 from master. Push
the branch; never master, never HANDOFF.md, never AgentComms/. Never open a window, viewer, video player or browser; windowed Godot
ONLY via `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <args>`; frames with your file tool. Headless:
`Godot_v4.7.2-stable_win64.exe` (NEVER `_console.exe`). `timeout` on every Godot run (300 s headless, 1200 s windowed).

Operator S192: "ask ludo what is missing to make the animations like humanlike and do whatever it says".

## Owned files
- `Godot/scripts/FightAliveStance.gd` (122 lines) - the additive layer lives here (it already owns breathing/sway: `continuous_sample`,
  `sample`, `restore`, `apply`).
- `Godot/scripts/FightStagePlayer.gd` (~6,100 lines - windows only; grep `contact`, `hit_react`, `_play_reaction`) - light/medium hits
  (damage <= 25) STOP replacing the playing clip and fire the additive impulse instead; > 25 keeps today's full reaction.
- `Godot/tools/record_room.gd` bench columns ONLY: fill the placeholder columns for steps 1 and 3 with REAL measured values
  (head rotation delta, hit-impulse weight, glove-to-head distance, flinch deflection) - read BENCH1_BASELINE.md for which are placeholders.
- `Godot/tests/human1_test.gd` (NEW), `research/BENCH1_BASELINE.md` (append a "## After HUMAN1" block).

## Prior research
- The maths is merged and tested - REUSE it, never re-derive: `Godot/scripts/FightHitAdditive.gd` (snap_angle_deg, push_cm,
  is_full_interrupt, envelope) and `Godot/scripts/FightFlinch.gd` (triggers, retreat, chin_tuck_deg, envelope) - `TASK_HUMAN_MATH1.md`.
- Spec + verdicts: `LUDO_ANIMATION_R12_S192.md` section 1 steps 1 and 3 (thresholds), `LUDO_ANIMATION_R13_S193.md` "Claude's verdict
  (round 13)" - its corrections win: our switches default OFF; bone writes go ON TOP of the freshly sampled pose once per frame (never
  multiply onto the previous frame's pose - it accumulates); bone names through the existing rig map (never "Spine2"/"Head" literals).
- Memory traps: modifiers run only in the deferred update; headless `get_bone_global_pose()` needs the skeleton updated.
- The measuring stick: `BENCH1_BASELINE.md` (master 78484b8f) - STEP 1 measured 0 (threshold >= 4.0 deg), STEP 3 measured 0 (>= 3.0 cm).

## What would a human do?
A hit that lands does not stop a man's punch - his head snaps back 4-24 degrees and settles in a fifth of a second while his body keeps
working. A glove that whistles past makes him pull his head a few centimetres away and tuck his chin.

## Spec
1. Switches `human_hit_additive` and `human_flinch` (FightStagePlayer/room options, default OFF; NOT in DEMO_SWITCHES - the operator
   turns them on after the video). Same pattern as existing room switches (grep `breath` / `alive_stance` options in FightWorldLiveScreen).
2. Hit additive: on a presented contact with damage <= 25, add FightHitAdditive's snap (head 0.6 / neck 0.3 / spine 0.1 split, away from
   the impact normal) + push, weighted by `envelope(t)`; the attacker's and defender's current clips keep playing (progress not reset).
3. Flinch: each frame, if `FightFlinch.triggers(...)` for the opponent's glove, retreat + chin tuck weighted by its envelope; zeroed at
   once if that punch lands (step 1 takes priority, no compounding).
4. OFF: byte-identical presentation (same seed, switches off -> the bench CSV pose columns equal master's within 1e-6).

## Done (tier: script edited - parse, focused test, related runs)
- Parse gate on every touched .gd.
- `human1_test.gd` (headless, two DIFFERENT boxers - name them): a forced 18-damage contact -> defender head rotation delta >= 4 deg
  within 50 ms and back under 0.5 deg by 300 ms; the attacker's clip time keeps advancing through the contact; a 34-damage contact still
  plays the full reaction; a whiff passing 20 cm from the head -> >= 3 cm retreat; an idle fighter's head does NOT drift over 10 s
  (accumulation guard); OFF -> pose identical to master. RED first on master (paste the count).
- `python Godot/tools/run_tests.py --only anim_smooth --jobs 2`, `--only bench1 --jobs 2`, `--only fight_stage --jobs 2` -> 0 fails.
- Re-run the benchmark (BENCH1_BASELINE.md "Reproduce") with `human_hit_additive human_flinch` on; append the STEP lines under
  "## After HUMAN1" - STEP 1 and STEP 3 must PASS; no other STEP may get worse.
- Two stills from the game camera through `still_framing.gd` `save_if_framed` to `previews/human1/`: the frame after the
  10 s landed cross (head snapped) and the 3 s whiff (head pulled away). Open both; describe them.
Commit + push codex/human1. Final message: red count, green results, before/after STEP lines, the two stills.

## The one trap
The additive must be applied AFTER the clip samples the pose in the same frame and removed before the next sample (FightAliveStance's
restore/apply pair) - otherwise the snap stacks frame on frame and the head drifts off the body.
