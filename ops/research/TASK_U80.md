# TASK U80 - CURSOR - THE DEFENCE CAP IS A SWITCH: GIVE IT A CURVE

Model: Composer, **medium effort**. Owner: cursor. Launched `-p --force --trust`.

**Test tier: A SCRIPT IS EDITED.** Parse gate, then the focused tests, then the named
subsets below. NOT the full suite - that is Claude's, once, at integration.

## Owned files

- `Godot/scripts/FightSimulation.gd` - **3,560 lines. NEVER open it whole.** You edit ONE
  function in it. Read only the windows named below.
- `research/U80_DEFENCE_CURVE.md` - **NEW, yours alone.** The measured before/after.

Do NOT edit any test, any data file, `HANDOFF.md`, `AgentComms/roadmap.json`, or any other
script. Do NOT re-pin a test to make your change pass.

## Why this exists

U73 (yours, `fb34129`) measured that technique defence is not a dial, it is a switch.
`_defender_defense_factor` sums the magnitudes of every defence node whose phases meet the
seat and whose effects answer the incoming role, then does:

```
bonus = clampf(bonus / 40.0, 0.0, 0.35)
```

It saturates at a magnitude sum of 14. The median defence node is magnitude 13. So one
node puts a fighter near the ceiling and two put him on it: a land rate is either ~25% or
~60% with almost nothing in between, and every defence node past the first is worth
nothing. A fighter who has trained four answers to a takedown is no better defended than
one who trained one.

U73's recommendation, already measured against generated opponents:

```
bonus = 0.35 * (1.0 - exp(-sum / 60.0))
```

Mean land rate 33.7% -> 43.4%; saturated cells 28 of 60 -> 3 of 60. The ceiling stays
0.35, so nothing gets MORE defended than today's maximum - the curve only stops a single
node from reaching it.

## Where things are (windows only)

- `Godot/scripts/FightSimulation.gd`:
  - `sed -n '2693,2715p'` - `_defender_defense_factor`, its doc comment, and the two lines
    you change. **Line 2710 is the cap; line 2711 combines it with the defence stat.**
  - `sed -n '95,130p'` - `DEFENSE_CLASSES` and `DEFENSE_ANSWERS`, the vocabulary that
    decides which effect keys answer which incoming role. **Read it, do not change it.**
  - `sed -n '1455,1472p'` - the call site: `defense_factor` times `_mobility_factor`, then
    the `success_chance` clamp that consumes it.
- `research/U73_*.md` - your own delivered measurement. It has the 60-cell table.

## The contract

Replace ONLY the saturation. Keep every other term of `_defender_defense_factor`
identical: the defence-stat base, the `_mobility_factor` multiplication at the call site,
the 0.6 outer clamp, and the answer test through `DEFENSE_ANSWERS`.

The curve constant is NEW, so it gets a name, not a literal:

```gdscript
const DEFENCE_CURVE_SCALE := 60.0
```

Put it beside `SUBMISSION_BASE_THRESHOLD` (line 162) with a comment that carries U73's
numbers, exactly as `SUBMISSION_SWITCH_CARRY` carries its own measurement.

**GDScript traps that cost a cycle here:** `var x := <call>` fails when the call returns
Variant - write `var n: float = ...`. `exp()` is a global function in Godot 4, no `Math.`
prefix. Reusing a variable name inside one function is a parse error even across separate
`if` blocks.

## Gate - in this order, and watch each one FAIL before you trust it

1. **Parse gate, always first.** A parse error HANGS a headless test for its full 600 s
   timeout instead of failing it:
   `python Godot/tools/check_scripts.py Godot/scripts/FightSimulation.gd`
2. **Sweep the new constant.** `DEFENCE_CURVE_SCALE` at 30 / 45 / 60 / 90, plus the
   unchanged tree as the 0 row. **Run the instrument on the UNCHANGED tree FIRST** - R138's
   tool had rotted a day after it was written and printed zero rows.
   `<godot> --headless --path Godot --script tools/measure_ground_seats.gd`
   It prints five matchups, names its population and the catalogue md5. Put the five-row
   table in `U80_DEFENCE_CURVE.md`. If 60 is not the best cell, say so and push the better
   one - this is a CEILING, not an exact target.
3. **Focused tests:**
   `python Godot/tools/run_tests.py --only technique_defence_answers --jobs 4`
   `python Godot/tools/run_tests.py --only fight_beat_defence --jobs 4`
4. **Named subsets, all of them:** `grapple`, `judge`, `ring`, `technique`, `smoke`,
   `fight_simulation`, `fight_stamina`, `fight_log` - each as
   `python Godot/tools/run_tests.py --only <name> --jobs 4`.
   **Ceiling: `ring` and `technique` may each carry ONE failure and no more.**
   `fight_scoring_test` (judo uchi-mata ippon, `19 >= 22`) and
   `fight_stage_technique_fidelity_test` are PRE-EXISTING - both fail identically on an
   unmodified HEAD, verified 2026-09-13. Every other subset must be `fails=0`. If you land
   FEWER failures than that, say so and push - do not hold a better result back.
5. **Do NOT run `--only fight`.** It matches 67 tests by substring, including
   `fight_metres_test`, which alone burns its full 600 s timeout.

## The trap specific to this task

**A number near its anchor can be an accident.** Do not stop at "mean land rate went up".
Report the SATURATED-CELL count too (how many of U73's 60 cells sit at the 0.35 ceiling),
because that is the defect - the mean can improve while the switch is still a switch. And
name the population in your own output: the operator rule is that two fighters built from
the same numbers are not a control group, and `measure_ground_seats.gd` already prints its
five pairs and their stats for you to quote.

## When you are done

Commit with paths on the commit line (`git add -- <file> <file>`), push, write your digest,
send one line with `python Tools/agent_comms.py send`. Do NOT edit `HANDOFF.md`.
`git show --stat HEAD` before you push: another agent's staged mail file has been swept
into a commit twice.
