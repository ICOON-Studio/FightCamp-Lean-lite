# TASK TECHSTAGE1B (S215) - a mastered move LOOKS faster: the strike clip plays at the stage speed

Model: Codex sol (gpt-6.1-sol, reasoning high). Branch `codex/techstage1b` cut from master AFTER TECHSTAGE1 merges.
Worktree E:/FightCamp/wt/TECHSTAGE1B (seed: Tools\seed_godot_cache.ps1 -Worktree E:\FightCamp\wt\TECHSTAGE1B).
Claude decided the scope (S215): the ownership expansion Codex asked for in TECHSTAGE1 is approved as this task.

## Prior research
TECHSTAGE1_VALIDATION.md "Ownership gap": the engine (FightRealtime) already charges `technique_speed` on commitment/recovery
clocks and records it in action metadata ON, but playback ignores it - FightWorldLiveScreen `_whole_phase_for_choice` (L3571)
calls FightStagePlayer `whole_phases` (L834), which returns RAW clip length. TechniqueStage.gd (stages + multipliers),
GameSwitches.gd (`technique_stages`).

## What would a human do?
A signature jab looks snappier on TV than a just-learned one. Play the clip faster by the same factor the engine used for its
clocks, so the picture and the engine agree - never a different number for the eye.

## Do
1. Carry the per-action speed multiplier the engine recorded (action metadata, switch ON) through FightBeatAdapter to the player.
2. FightStagePlayer: scale the strike's whole-clip phases/time by it (contact phase lands when the engine's contact does);
   `_whole_phase_for_choice` uses the same scaled timing.
3. Switch OFF (and every non-boxing ruleset): byte-identical to today - multiplier absent = 1.0, no new RNG draws.
4. Test (new, blind from this contract, red first on master): `tests/technique_stage_playback_test.gd` - same move, stage 1 vs
   stage 4 fighter, switch ON: stage-4 whole-clip duration shorter by the engine multiplier (bound +-5%), contact frame aligned
   with the engine contact tick (bound 1 frame); switch OFF: durations equal. Name the population in the output. Prove it with a
   mutant (multiplier ignored in the player -> red).
5. Run: parse gate, the new test, then `python Godot/tools/run_tests.py --jobs 2 --only technique,warp,whole,stage_player,switch_gate,game_switches`
   (`--jobs 1` if the watchdog is not GREEN) - nothing green goes red (q226_strands and face_drawn_foe are red on master already;
   record their numbers, do not fix them here).
6. TECHSTAGE1B_DIGEST.md: what changed, numbers, mutant. Commit, push codex/techstage1b. Never master.

## Owned files (line counts S215 - NEVER read the two big ones whole; grep + sed -n windows)
- Godot/scripts/FightBeatAdapter.gd (1,440)
- Godot/scripts/FightStagePlayer.gd (6,499) - `whole_phases` ~L834 and its callers
- Godot/scripts/FightWorldLiveScreen.gd (6,645) - `_whole_phase_for_choice` ~L3571 and its caller
- Godot/tests/technique_stage_playback_test.gd (NEW)
- research/TECHSTAGE1B_DIGEST.md (NEW)

## Prefab check
None - our own clip player.

## Rules
Watchdog before every Godot run (RED = wait). Headless Godot_v4.7.2-stable_win64.exe only (never _console.exe). No image
viewers/browsers. `git add -- <files>`. No windowed runs needed.

## The one trap
Scaling a clip by changing AnimationPlayer speed_scale globally would also speed the guard/idle blend and the OTHER fighter -
scale only this strike's whole-clip phases.
