# TASK TECHSTAGE1_FIX1 (S215) - your branch turns two room switch gates red that pass on master

Model: Codex sol. Worktree E:/FightCamp/wt/TECHSTAGE1, branch codex/techstage1 (HEAD 89f6be7b). Never master.

## Evidence (Claude, S215, same machine, same exe, headless, both runs side by side)
| gate | master (green) | codex/techstage1 (red) |
|---|---|---|
| switch_gate_contact_push_carry | root/hip pops ON 7 < OFF 19 PASS | ON 25 < OFF 23 FAIL |
| switch_gate_hold_pair_geometry | p90 rel-place err ON 0.512 < OFF 1.119 PASS; single-hold frames 284 | ON 2.884 < OFF 2.531 FAIL; frames 259 |
`run_tests.py --jobs 2 --only technique,q226,switch_gate,pad_chain,certified,game_switches` on the branch: 37 total, these 2 fail.
Master has only one unrelated change since your base d17fc2e4 (EQUIPSLOTS1A, club code) - the regression is yours.
The single-hold frame count changed 284 -> 259: the fight itself (choices/timings) differs in these gates, so something your branch
changed reaches the fight when `technique_stages` is NOT meant to be on (switch gates set every room switch explicitly via
tools/switch_gate_common.gd; check whether technique_stages is on in their run - GameSwitches registry, `as_game`, configure options -
and whether the role-weight "usage-weighted expected choice multiplier", contact thresholds or counter bias apply when it is off).

## Do
1. Find what differs with the stages switch OFF (or what turns it on in the gate run). OFF must be byte-identical to master in the
   fight engine; if the gate harness legitimately runs the game set, the stage change must not break these two gates either.
2. Fix it on the branch. Never loosen a gate, never set a switch in the harness to hide it.
3. Run both gates (headless `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/switch_gate_contact_push_carry_test.gd`,
   same for hold_pair_geometry) - numbers must match master's (or be better), then rerun the whole list above (--jobs 2, or --jobs 1 off GREEN).
   Your +30..70% specialist acceptance must still hold.
4. Append a FIX1 section to TECHSTAGE1_VALIDATION.md (cause, fix, before/after). Commit, push codex/techstage1.

Scope note (Claude decided S215): visible clip speed is NOT this task - it is TECHSTAGE1B (TASK_TECHSTAGE1B.md), after this merges.

## Owned files
Same as TASK_TECHSTAGE1.md (TechniqueStage.gd, FightRealtime.gd, AthleteDevelopment.gd, GameSwitches.gd, their tests) + TECHSTAGE1_VALIDATION.md.

## Rules
Watchdog before every Godot run. Headless only, never _console.exe. No viewers. Never master.

## The one trap
A switch gate passing on master and failing here with a DIFFERENT frame count means the fight timeline changed - compare the two
timelines (first differing tick), do not tune the gate's numbers.
