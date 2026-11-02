# TASK_Q168 - the control arm for TRAPS: how submissions happen in the engine TODAY (Qwen, research + tool)

Model: qwen3-coder, medium, `--yolo`. Owner: qwen. Assigned S66, 2026-09-24. Engine lane.

## Why
The operator's direction, 2026-09-24, verbatim: "I think we should use the word trap to resolve critical moments in the
fight. Be a factor in the submission event should be associated How other events like grappling maybe maybe we should do
it proper study and find ways to deepen the decision making of the fighter the logic Transition of moves".
Grok G72 is designing a TRAP as an engine state (a control won at a cost that gates finishes and forces the defender into
a dilemma), on top of GroundGraph (`research/S58_THE_GROUND_GRAPH_WIRED.md`). Whatever it proposes will be judged
against a BASELINE - this task builds that baseline, so the design is measured, not admired. No engine edits.

## What to measure (a new tool, `Godot/tools/q168_submission_baseline.gd`)
Base your branch on YOUR Q166 round-4 branch (`qwen/q166-ground-game-finish` @ `12b69831`) merged with `origin/master`,
because that is the calibrated submission mechanism the next stage starts from. Two populations, 40 MMA bouts each, named
in the output (your R133 grappler vs striker; your brawler vs kicker - never identical fighters), `ground_arm` OFF and ON
(GroundGraph's switch). Per population and arm:
1. Submission ATTEMPTS per fighter-fight (J20 D6 anchor: ~0.5-1.0) and finishes per attempt.
2. For every attempt: the seat it opened from, how long the seat was held before it opened, who was on top, the
   progress curve, and how it ended (tap / escape / bell / position lost). A table by seat.
3. Escapes: from which seats, how often, and what the escaping man did (seat change, stand-up, reversal) - and
   whether ANY defender action ever chose between two threats (expect: no - that absence is the point).
4. The share of submissions whose preceding 10 seconds contained a control event (`control` grapple kind) versus none.
5. What the engine offers as a "why" for each finish today (the log fields a result screen could read).
Print the anchors beside the numbers, and the populations, in the output. Save `research/Q168_SUBMISSION_BASELINE.md`
with the tables and `research/q168_baseline.json` with the raw rows.

## Owned files
`Godot/tools/q168_submission_baseline.gd` (new), `research/Q168_SUBMISSION_BASELINE.md`, `research/q168_baseline.json`.
Nothing else - no engine or test edits.

## Gate (tier: new tool only)
`python Godot/tools/check_scripts.py Godot/tools/q168_submission_baseline.gd`; run the tool; no suite. Prove the instrument can
read a submission: print one full attempt row from a bout you know ends by submission before trusting any zero. Branch
`qwen/q168-submission-baseline`. Commit, push, `python Tools/agent_comms.py send --from qwen --to claude --topic Q168 --body "..."`.
Do NOT edit HANDOFF.md. `FightRealtime.gd` is ~5,100 lines and `GroundGraph.gd`/`GrappleResolve.gd` are read-only here:
grep, then `sed -n 'A,Bp'` windows.
Trap: a counter that cannot move reads as "no change" - grep the engine for the exact `kind` strings you filter on
(`submission_attempt`, `submission_finish`, `control`, `seat`) before you count them.
