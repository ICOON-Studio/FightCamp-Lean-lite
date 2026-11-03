# S378 digest (2026-11-03)

## Built and pushed (main)
- Seat shells fixed fa59bedc: Cursor auto-updated at 16:58 (the LOCOWALK1 launch) and since then runs the WORKSPACE's
  `.claude/settings.json` PreToolUse hook without `CLAUDE_PROJECT_DIR` -> `python "/ops/Tools/rule_guard.py"` rc 2 -> every
  shell call rejected. The hook now finds rule_guard.py from CLAUDE_PROJECT_DIR / CURSOR_PROJECT_DIR / the cwd and fails open;
  rule_guard strips a BOM (PowerShell pipes). Proven both ways: the old hook reproduced the dead shell, the new one let a Cursor
  run print `git log -1`; `git stash` still blocked under bash and PowerShell with the env var empty. Note in cursor_task.cmd.
- PLANCOMBO1 d55bb3ca (Kalli's NAMED_SHARE, S377 "not done"): PLAYBOOK > Game plan has a GO-TO COMBINATION row - one of the
  fighter's own drilled combinations (f["plan_combo"]). In the bout it decides 40 % of the combination exchanges (not 33 %)
  while it is still thrown whole at the round's mid energy (OwnCombos.whole_at = the ring's rule: tired hand-speed cap + 1 for
  a signature), and the ring picks it 1.21x as often (row "weight" in Combos.pick). A long go-to wins the fresh rounds and
  stops paying once he cannot finish it - the trade. The row says the share and "R1 whole · R2 whole · R3 too tired".
  Tests: combo_plan_test g (10 checks), game_plan_test 7 (5); round_script, round_style, plan_bout, balance_harness,
  golden_path, fight_feel, plan_test_it, peak_camp, no_pronoun green. Review workflow (rules / integration / UI lenses +
  a refuter per finding): 0 defects; its one note (card vs ring "whole" rule differed in a narrow energy band) applied.
  Still: ops/previews/S378/plan_combo_goto.png (tools/plan_combo_still.gd).
- Update 74 test jump: `FightCamp.exe -- jump=gameplan` (Lucy booked, a jab-cross-lead hook signature + a jab-cross drilled,
  opens on the GO-TO row); board target "Test: the plan's go-to combination (update 74)", task "FightCamp Play test gameplan",
  shortcut "Test game plan go-to".

## Seats
- LOCOWALK1 (cursor) CANCELLED: dead shell (above) -> it wrote a sine-wave leg generator in FightClips.gd that did not
  compile (checks 1/5); PR #31 closed unmerged; its fight-stills CI run cancelled.
- LOCOWALK2 (cursor) QUEUED (launches when a PC slot frees - Ziva + agy hold both): TASK_LOCOWALK2.md - Ludo's CAPTURED
  presets, not text-to-motion: `ludo model animate-preset --model <our boxer via clip_gltf export> --preset-id <id> --in-place
  --crop-loop` (0.5 credits; cap 10; 536 credits on the account) - walk_backward / backpedal -> walk_back_guard, walk_forward /
  walk_confident -> walk_guard, walk_relaxed; previews free first (eyes); import via clip_gltf; tools/locowalk_bake.gd merges
  the walk's hips + legs with mc_Box1_M3_Idle's guard upper body offline. No clip built in code. Same drawn-bone bars.
- FIGHT9R7 (agy, Argon High) RUNNING since 17:45 on BASE claude/fight9base; its before film judged 4/10.
- BJJ9 round 10 (Ziva) RUNNING: GrappleFinish.gd (new) + BeltMatch/GrappleBrowser edits for the armbar finish; nothing pushed.

## Not done
- walk_back_guard -> KnockdownCount.WALK_CLIP waits on LOCOWALK2's clips (then brief FIGHT9 to put the fight's footwork on
  the step clips + StepRoot, FootPlant as ground contact only).
- Roster boxer tiles have no face photo (Ana's card has one).
- The operator has not played updates 73-74.

## HANDOFF
- Commit: main (this digest's commit). Evidence: ops/previews/S378/plan_combo_goto.png; test outputs above.
- Next: collect LOCOWALK2 against its bars (eyes burst yourself); FIGHT9R7 only at a real 9/10 (check each score against its
  verdict file); BJJ9 at 9/10; if Ludo's presets fail the bars, the mocap-pack purchase goes to the operator (his money).
