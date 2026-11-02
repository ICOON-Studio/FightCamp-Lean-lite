# TASK Q37 — QWEN — CORRECT Q36's GAP FIGURE, THEN MEASURE WHAT FILLS IT

Model: qwen (CLI, `--yolo`), medium effort.
Owner: qwen. Tier: **ONE OWNED RESEARCH FILE CORRECTED + ONE NEW TEST FILE** —
parse gate plus your one new test. Do NOT run the full suite.

## Part 1 — a correction, and the reasoning is yours to check

Q36 (`5694aa3`) is good work and its headline verdict stands: **the clips fit.**
99.95% of action beats have room for the 2.47 s combo, nothing is ever
interrupted by the next beat, and the short beats are concentrated entirely in
terminal knockdown moments where M15's hard cut hides the truncation. That
section is sound and is not being reopened.

**But §4's "8.8% of presented fight-time has no strike clip to play" is wrong,
and §5 of your own file contains the proof:**

> *"A clip that is 2.47 s long has **11.53 s of slack** before the next beat
> arrives."*

§4 counted only the **1,164 wholly-empty beats**. It did not count the 11.53 s
of slack inside each of the **12,114 action beats** — where there is likewise no
strike clip playing. The task file asked for exactly that: *"When a beat is 14 s
and the clip is 0.8 s, what fills the other 13 seconds? Count it."*

The arithmetic off your own published numbers:

```
action-beat time                     169,033.9 s
clip coverage    12,114 × 2.47 s   =  29,921.6 s
uncovered inside action beats      = 139,112.3 s
empty beats                        =  16,284.1 s
total uncovered                    = 155,396.4 s
                     of 185,318.0 s  =  83.9%
```

**The true no-clip share is ~84%, not 8.8% — an order of magnitude.** And it
gets worse, not better, with the sliced single punches U40 is producing: at
0.8 s per punch, coverage falls to about **94.8% uncovered**.

**Check this arithmetic yourself before accepting it.** If you think it is
wrong, say so and show why — a disagreement between two readings of the same
data is settled in the data, and I would rather be corrected than agreed with.

**Then fix `research/Q36_THE_BEAT_FITS.md` in place**: correct §4 and the
VERDICT's last sentence, and add a short note saying what the original figure
counted and why it understated. **Do not delete the original number** — record
it as corrected, the way this project records every other correction. Leave the
rest of the file alone; §1, §2, §3 and §5 are right.

This matters because J18 is being researched right now on the premise that the
non-striking share of a fight is the biggest hole in the animation plan. At 8.8%
it looks like a rounding error. At 84% it is the whole problem.

## Part 2 — measure what has to fill it

Q34 found only **28.7% of boxing ticks are inside striking range**. So ~84% of
screen time is two men moving, and we own exactly one `idle`. What does that
motion actually look like? Over **200 seeded boxing bouts, seeds 200000–200199**
(same seeds again — comparability across Q34/Q35/Q36/Q37 is the point):

1. **The intent stream.** `FightIntent` names four: `close`, `hold`, `retreat`,
   `circle`. What share of decision ticks is each? **This is the locomotion
   shopping list** — a clip set has to cover whatever is common.
2. **How fast do they move?** Distribution of per-tick displacement, converted
   to **metres per second**: min, P05, P25, median, P75, P95, max. An in-place
   locomotion cycle has to be speed-matched to the engine (G42: the engine owns
   translation), so the **spread** matters more than the median — a single
   forward cycle can only look right across a narrow speed band.
3. **How often does direction change?** Per beat, and per ten seconds. If a man
   reverses every second, a directional clip set is being cross-faded constantly
   and the blend matters more than the clips.
4. **Lateral versus forward.** What share of movement is along the line between
   the two men (closing/retreating) versus perpendicular (circling)? This
   decides whether we need side-step cycles at all, or only forward and back.
5. **Are both men moving?** Or does one press while the other holds? Report the
   share of ticks where both are displacing versus one.
6. **Does it change with the tank?** Compare the first round against the last:
   do speeds fall and does `hold` rise as fatigue bites? If so, a single-speed
   locomotion set will look wrong late, and that is a purchase consequence.

## Owned files

- `research/Q36_THE_BEAT_FITS.md` — yours, CORRECT in place (Part 1).
- `Godot/tests/fight_locomotion_test.gd` — NEW, yours.
- `research/Q37_THE_MOVEMENT.md` — NEW, yours.

**Do not edit any script.** `Godot/scripts/FightIntent.gd` and
`Godot/scripts/RingSpace.gd` are small — read them whole. `FightRealtime.gd` is
~2100 lines; never open it whole.

## Gate and traps

```
python Godot/tools/check_scripts.py Godot/tests/fight_locomotion_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_locomotion_test.gd
```

**rc=0 is NOT a pass (R75).** Read the output.

**Trap 1: assert only that the measurement occurred and is sane** — never an
exact value, never an exact zero. Same discipline as Q34/Q35/Q36.

**Trap 2, and it is the lesson of this task: a share is only meaningful against
the right denominator.** §4's error was dividing by the wrong thing — counting
empty windows instead of empty seconds. For every percentage you publish here,
**state the denominator in the same sentence.** "38% of decision ticks" and
"38% of fight-time" are different claims and only one of them will be true.

**Trap 3:** `git status -s` before committing, `git add -- <explicit paths>`
only. Several agents have work in flight in this shared checkout. Never
`git add -A`, never a bare `git stash` / `reset --hard` / `clean`.

## Deliverable

Commit both the correction and the new study, push **master**, then:
`python Tools/agent_comms.py send --from qwen --to claude --subject Q37-done --body "<sha> q36-corrected=<yes/no-and-why> true-gap=<n>% intents=close/hold/retreat/circle=A/B/C/D speed-med=<n>m/s speed-p05-p95=<a>-<b> dir-changes-per-10s=<n> lateral-share=<n>% both-moving=<n>% fatigue-effect=<yes/no>"`
Do not edit `HANDOFF.md`.
