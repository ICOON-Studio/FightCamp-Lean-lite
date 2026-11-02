# TASK_S15 — THE ROUTE ROW: A WALKING MAN IS NOT A FROZEN ONE

Owner: Claude. Model: Opus, HIGH effort, Fast OFF.
GREENLIT by the operator 2026-09-18 ("Go B with A folded in **then c**"), to run
AFTER S14. This is S9's OPTION A, unblocked at last by the footwork ruling.

## THE ROW

After S13, `technique_class: movement` is **the largest single block of
degrades left**: 30,599 beats, **39.4% of every remaining degrade**, 9.1% of all
action beats. Three ids, `research/S13_PRESENTATION_SPLIT.md`:

| id | beats | share of action beats |
|---|---:|---:|
| `boxing_circle_rear` | 10,295 | 3.07% |
| `boxing_step_in_out` | 10,170 | 3.03% |
| `boxing_circle_lead` | 10,134 | 3.02% |

Nothing to buy. They degrade because footwork arrives on the ACTION path, where
`FightStagePlayer._thrower_clip` (`:1016`) can only offer a STRIKE role — while
the eight-way walk overlay is ALREADY grafted and already running under the man.

## THE RULING THIS STAGE EXECUTES, AND ITS EXACT LIMIT

Operator, 2026-09-18, verbatim:

> "Footwork is purely scoring and rhythm, and helps dodge, repositioning and in
> general is the catalyst in transitioning defined by speed, never needed to
> move anybody."

So: a movement beat must stop being handed to a strike presenter and stop being
counted as a frozen fighter. **It must NOT be made to carry the man**, and the
walk must NOT be biased toward the beat — S10 measured that the correlation does
not exist (any action beat 63.6% walking, a `boxing_circle_lead` beat 60.1%,
3.5 points apart) and the operator has ruled it is not supposed to. Re-opening
that is forbidden.

## THE HONESTY PROBLEM THAT IS THE WHOLE STAGE

**This is ACCOUNTING before it is picture, and S6c is the precedent that must
not be repeated.** Routing `mma_guard_gnp` off the action path moved 4.65 points
out of the degrade column — a true statement about `_thrower_clip` and a false
one about what the eye got, because in a running room only 11 of 79 routed
beats (13.9%) actually played a film.

Here it is sharper still: **S10 measured that ~39.8% of these beats are a man
who genuinely is NOT walking.** Routing alone moves 30,599 beats out of the
degrade column and gives roughly 12,000 of them nothing to do. So the stage has
two halves and must report them apart:

1. **THE ROUTE** — a `movement` beat is accounted as footwork, not as a failed
   strike. Cheap, correct, and mostly a counter.
2. **THE STILL MAN** — what plays for the ~39.8% who are not travelling.
   Under the ruling this is RHYTHM: a stance shift, a bounce, a weight change.
   **Establish what the stance layer already does before adding anything** —
   `_queue_stance` (`FightStagePlayer.gd:373`) and the `idle` binding already
   own a resting body, and Q85 measured 0 frozen frames through it. It is
   entirely possible the honest answer is that nothing is owed and the counter
   was the only defect. **That is a legitimate result — say it if it is true.**

**DO NOT report a single number for this stage.** "30,599 beats out of the
degrade column" is the sentence that would make this stage read four times
better than it is.

## OWNED FILES

`Godot/scripts/FightBeatAdapter.gd` (where a beat's class is read),
`Godot/scripts/FightStagePlayer.gd` (`_thrower_clip:1016`, `_queue_stance:373`),
`Godot/scripts/FightWorldLiveScreen.gd` (the degrade counter at `:718`, and the
routing precedent S6c added at `:532`),
`Godot/tools/measure_presentation_split.gd` (the ROUTE tally must follow),
new `research/S15_*`.

## GATE (tier: a script edited)

```
python Godot/tools/check_scripts.py <each touched .gd>
python Godot/tools/run_tests.py --only beat
python Godot/tools/run_tests.py --only stage
python Godot/tools/run_tests.py --only world
```
Then the FULL SUITE ONCE: `python Godot/tools/run_tests.py --timeout 2400 --jobs 3`,
**fails=6 or better as a CEILING**, failing FILENAMES matching
`AgentComms/last_suite.json` name for name. THREE jobs, not four.

Re-measure into `res://research/S15_PRESENTATION_SPLIT.md` — never over S9's,
S13's or S14's file.
