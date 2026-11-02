# TASK TECHSTAGE1_FIX2 (S217) - renderer scope granted under the switch; explain the OFF arm

Model: Codex sol (gpt-6.1-sol, NEVER astra). Worktree E:/FightCamp/wt/TECHSTAGE1, branch codex/techstage1 (HEAD 4ba7e3ce). Never master.

## Claude's decision on your scope request (S217)
I read `FightWorldLiveScreen.gd` 4520-4532 on master. Your diagnosis is right: `push_b = -shift*0.5` is then SUBTRACTED,
so B moves with A (+shift/2) while its hold origin is carried by -shift/2.
GRANTED, with one condition: the correction applies ONLY when `_contact_push_carry` is ON. With the switch OFF the line stays
exactly as it is (the certified C223 palette was gated on it; OFF must stay byte-identical to master):
```gdscript
	_node_a.position += push_a
	if _contact_push_carry:
		_node_b.position += push_b   # S217 TECHSTAGE1_FIX2: B moves along the line it is carried by
	else:
		_node_b.position -= push_b
```
`Godot/scripts/FightWorldLiveScreen.gd` is now an owned file for THIS hunk only (6,645 lines - never read whole:
`sed -n 4480,4560p`). Any other edit there is out of scope.

## The part the sign fix does NOT explain - do this too
Master: contact_push_carry pops ON 7 < OFF 19. Your branch: ON 6 / OFF 6. The OFF arm moved 19 -> 6 on your branch while the
sign line is the same on both. The room fight timeline still differs with the stage work present. Find the first differing tick
between master and your branch in the OFF arm of `switch_gate_contact_push_carry_test.gd` (log both, diff) and name the cause in
TECHSTAGE1_VALIDATION.md. If the cause is your presenter clock / recovery change running unconditionally, gate it behind
`technique_stages` so the OFF room is byte-identical to master. Never tune the gate.

## Acceptance (all from the tests' own output lines, pasted into TECHSTAGE1_VALIDATION.md FIX2)
1. `switch_gate_contact_push_carry`: ON < OFF, and the OFF arm equals master's (19) or you explain exactly why it cannot.
2. `switch_gate_hold_pair_geometry`: ON < OFF (master 0.512 < 1.119).
3. Q226 conditioning: green (master 90.9 > 90.5).
4. `python Godot/tools/run_tests.py --jobs 2 --only technique,q226,switch_gate,pad_chain,certified,game_switches` (ONE comma list):
   all 37 pass. `--jobs 1` if the watchdog is not GREEN.
5. Specialist +30..70% lands still holds.
Commit, push codex/techstage1, update the HANDOFF claim. Resolve your blockers JSON files (resolved_at) in the same commit.

## Prior research
`research/topics/contact_collision.md`; OVERLAP1_DIGEST.md (the contact_stop push); U198_DIGEST.md (root write order:
`_stop_posed_contact` runs after the late cap - do not move it). TECHSTAGE1_VALIDATION.md FIX1 (your own numbers).

## What would a human do?
A programmer would fix the obvious sign bug behind the switch it belongs to, then diff the two timelines to find why the
control arm moved, instead of shipping a green gate on a changed fight.

## Prefab check
None applies - internal room solver.

## Owned files
TASK_TECHSTAGE1.md list (TechniqueStage.gd, FightRealtime.gd, AthleteDevelopment.gd, GameSwitches.gd, their tests) +
TECHSTAGE1_VALIDATION.md + the one FightWorldLiveScreen.gd hunk above + AgentComms/blockers/*TECHSTAGE1_FIX1*.json.

## Rules
Watchdog (`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once`) before every Godot run; RED = wait.
Headless only (`Godot_v4.7.2-stable_win64.exe --headless`), never _console.exe. Never open images/windows. Never master.
Parse gate first: `python Godot/tools/check_scripts.py <touched .gd>`.

## The one trap
A switch gate whose OFF arm changed is not fixed by making ON smaller - the OFF arm is the control; it must match master.
