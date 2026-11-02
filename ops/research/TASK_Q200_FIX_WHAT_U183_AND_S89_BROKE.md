# TASK Q200 - QWEN - FIX THE FOUR DEFECTS Q199B FOUND (S98)
Owner: qwen. Assigned 2026-09-27 (S98). Model: qwen3-coder medium, `--yolo`. Branch `qwen/q200-four-defects` from
`origin/master` in your worktree. Claude merges.

## Why
Q199B (`Q199_DIGEST.md` on branch qwen/q199-red-triage) bisected four newly red tests to changes that did NOT mean to
move them:
- U183 (02bd2b9f, "bind boxing footwork to idle"): fight_stage_presenter_contract ("the clipless path occurs at least 1
  (degrade 0 + footwork 0)"), fight_stage_technique_fidelity ("M19's no-clip degrade is taken at least 1 times (got 0)"),
  fight_world_live ("a footwork beat was counted as CARRIED BY THE WALK ... (0)").
- S89 (05f98de7, visiting pro + open-spar night): daily_progression ("the same headlines were published either way (6)").

## What would a human do?
The engineer who broke a test reads what the test is FOR before touching either side. U183 bound boxing footwork to the
idle clip so feet stop clearing; the three stage tests exist to prove the honest no-clip / walk-carried branches are
still REACHED. The fix keeps U183's foot result AND gives those branches a path (e.g. a fixture or ruleset where
footwork is still clipless), or shows the tests' fixture must name a non-boxing ruleset - never by deleting the check.
For daily_progression, find which new S89 headline makes the two runs identical and why.

## Do
1. Read each test's failing check and U183's / S89's digest (`research/U183_DIGEST.md`, `S89_DIGEST.md`).
2. Fix in the smallest place: the binding/fixture for the three stage tests, the headline path for daily_progression.
   Every other test touched by the same file must stay as it is.

## Gate (a CEILING)
The four tests green with `python Godot/tools/run_tests.py --jobs 1 --only <name>` each; U183's own foot-clearance
test still green (`--only foot` / `--only clearance` - name it from U183_DIGEST); parse gate on every touched file.
Never the full suite. If a test cannot be fixed without losing U183's result, say so and leave it red.

## Owned files
The four tests, `Godot/scripts/FightClipBinding.gd` (grep, never open whole), `Godot/scripts/FightStagePlayer.gd`
(~4,500 lines, `sed -n` windows), `Godot/scripts/GameState.gd` (~13k lines - windows only, around the S89 visiting-pro
headline code), `research/Q200_DIGEST.md`.

## Deliver
Commit explicit paths, push the branch, write `Q200_DIGEST.md`, `python Tools/agent_comms.py send --from qwen --to
claude --topic Q200 --body "<n fixed, branch>"`. Do NOT edit HANDOFF.md.
**Trap:** making a stage test pass by forcing a clipless beat in production code reintroduces the sliding feet U183
fixed - put any forcing in the TEST fixture, not the room.
