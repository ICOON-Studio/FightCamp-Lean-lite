# TASK REALISM1 - make the live fight pass its real-bout realism test (fight_stage_realism_test.gd, red for weeks)

Model: gpt-6.1-sol (Codex, animation). Long task. Keep fixing and re-running until green - there is NO two-run limit. Only if sol
cannot finish the whole task does Claude re-run it on astra (operator S206: "astra for super hard animation tasks that sol fails").
Operator S206: Codex works on animation non-stop. Both S206 Codex runs (ANIMSCURVE1, ANIMFATIGUE1) reported the same baseline red:
`Godot/tests/fight_stage_realism_test.gd` (1,833 lines, S4a) - 13 checks, 7 failing on master: exchange spacing/rhythm, stance
variety, foot skating, canvas penetration, two join-speed gates, and body overlap. It is also in the nightly's red set.

## What the test is (read its header first: `sed -n 1,80p`)
It plays the real FightWorldLive room with its own legal pair (two different male welterweights - an out-boxer and a pressure
puncher), reads what the PLAYER sees frame by frame (AnimationPlayer take/position + composed skeleton poses), and checks each
rule against a real study (JPES 2016 time-motion etc.), printing the study beside the number. THE TEST IS THE SPEC: do NOT loosen
a threshold, remove a check or change what it measures. If you are certain a rule is wrong against its own cited study, stop and
write the evidence in your summary - Claude decides.

## Do
1. Run it on master first and record every failing line (name, measured value, threshold, study) in your summary.
2. Fix the CAUSES in the fight presentation - `Godot/scripts/FightStagePlayer.gd` (~6.4k lines), `Godot/scripts/
   FightWorldLiveScreen.gd` (~9k lines) and the presenter/spacing/footwork modules they call. NEVER read those two files whole:
   grep for the system the failing check names (spacing, stance, foot plant / skate, canvas / floor, join / blend speed, overlap /
   separation) and read only those windows. One failing rule at a time; commit after each one that turns green.
3. Hard rules (each cost a regression before): nothing moves root or feet inside a certified clip's contact window (U211 regressed
   32/32 certified pairs); a planted foot may slide at most 1.5 cm; OFF switches stay byte-identical; never two identical fighters.

## Acceptance (tier: edited scripts)
- `fight_stage_realism_test.gd` -> all checks pass (or the evidence for a rule you believe wrong, see above).
- Then `python Godot/tools/run_tests.py --jobs 1 --only fight_stage,certified,bench1,intent_bus,scurve,fatigue,glove_spring,
  playable_loop` - nothing that was green may go red (list before/after in your summary).
- The C223 certified gate must not regress: `python Tools/c223_parallel.py production -- report=E:/FightCamp/tmp/realism1_c223.json`
  before your first fix and after your last; the pass counts must be equal or better (print both).
- Parse every touched .gd first; run Godot with `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe"` (never _console).

## Owned files
Godot/scripts/FightStagePlayer.gd, Godot/scripts/FightWorldLiveScreen.gd and the presenter modules they call for the failing rules.
NOT the test. NOT certified_moves.json. NOT clip_phases.json (unless a phase time is provably wrong - say so first).

## Prior research
The test header (its studies), topics/footwork.md, topics/playback_blend.md, topics/contact_collision.md, topics/pace_calibration.md
(`python Tools/prior_research.py spacing skate canvas overlap join` for the rest), LUDO_ROUND38_VERDICT_S204.md (our rules).

## What would a human do?
An animation lead watching a fight that "doesn't look like boxing" fixes rhythm first (time between exchanges), then feet (no
skating, no sinking into the canvas), then bodies (no interpenetration), checking each against reference footage.

## Prefab check
None - this is our presentation layer.

## The one trap
A rule that measures the PLAYER'S view must be fixed in what is drawn, not in a getter the test could read - the test reads composed
bone poses, so a fix that only changes a reported number will not (and must not) turn it green.

## ROUND 2 (S207, Claude) - the C223 baseline blocker, decided
Your round 1 (f5ebe8cc) stopped because 8 source GLBs for combat_cross / combat_hook / combat_long_hook / combat_right_hook are absent.
They are absent EVERYWHERE (main checkout too, no backup) - nobody can run those 4 rows, so they are not your blocker.
1. The other untracked c223 assets are now copied into your worktree (Godot/assets/anim/c223/, gitignored).
2. C223 regression = the rows whose sources exist. Run the gate on master (switches as shipped) and on your branch with the SAME row set;
   list the skipped rows by name in your summary. "Not regress" = no row that passed on master fails on your branch.
3. Now do the real work: fix the 7 failing presentation checks (R1 rhythm, R2 stance variety, R3 skating, R3b canvas, R5/R5b join
   speed, R7 overlap). The test is the spec - never loosen it.
