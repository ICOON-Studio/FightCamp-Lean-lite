# TASK Q39 — QWEN — OUR ENGINE'S OUTPUTS, IN UFC UNITS

Model: qwen (CLI, `--yolo`), medium effort.
Owner: qwen. Tier: **NEW TEST FILE ONLY** — parse gate plus this one test. Do
NOT run the full suite.

## Why this exists — the bar just moved

The operator's standard for this simulator: **the UFC should be able to use it
to see how fights can go.** That makes it a fidelity problem, and fidelity means
our OUTPUTS have to match the outputs of real fights.

You proved the method works today. Q38 compared our movement speed against a
GPS study of real boxers, with matched denominators, and found we run at
**2.26× a real fighter's pace** — a defect nobody suspected, found in one
measurement. **This task does the same thing for everything else.**

A parallel research desk (J20) is assembling the published real-world numbers.
**You are building our side of the comparison.** Neither of you should see the
other's answer first — that is deliberate, and it is why you must not tune
anything toward a number you expect.

## What to measure — in the units the real statistics use

200 seeded bouts, seeds **200000–200199**, so this is comparable with Q34–Q38.
Do it for **MMA** as the primary ruleset (the UFC statistics are MMA) and give
**boxing** as a secondary table.

**Report every figure with its definition and its denominator in the same row.**
That discipline is not optional here: these numbers will be compared against
published statistics whose definitions differ, and a mismatch of denominators
would produce a fake defect or hide a real one. It has already cost this project
time twice.

1. **Strikes landed per minute** and **absorbed per minute**, per fighter. State
   whether your "landed" means every scored impact or only some subset, because
   the real statistic counts *significant* strikes and we must be able to line
   the two up.
2. **Striking accuracy** — landed as a share of attempted. We have both: the
   attempt gate at `FightRealtime.gd:1192` rejects out-of-range attempts, and
   `contact` distinguishes `missed` from the rest. **Say exactly which
   quantities you divided.**
3. **Target distribution** — head / torso / leg / arm as a share of landed
   strikes. Q32 measured 65.3 / 28.2 / 3.2 / 0; confirm or correct it on this
   seed set, for MMA specifically.
4. **Position split** — share of fight time at distance, in the clinch, and on
   the ground; plus control time. We model all three (`GrappleSeat`) and have
   never checked the split.
5. **Takedowns** — attempts per 15 minutes, accuracy, and submission attempts
   per 15 minutes.
6. **Outcomes over the 200 bouts** — finish rate; the KO/TKO, submission and
   decision split; **the distribution by round**; and the share of decisions
   that are split or majority.
7. **Knockdowns** — per fight and per 15 minutes. R84 measured a knockdown in
   **41.5%** of bouts, which looks high against real MMA. Confirm the number and
   give it in per-15-minute form too, since that is how the real statistic is
   published.
8. **Round-by-round decay** — output in round 1 versus the last round. Real
   fighters slow; ours should too, and R86 wired fatigue in, so this is a check
   that it actually shows up in the output rather than only in the tank.

## Owned files

- `Godot/tests/fight_ufc_units_test.gd` — NEW, yours.
- `research/Q39_OUR_NUMBERS.md` — NEW, yours.

**Do not edit any script.** If a number cannot be derived from what the engine
exposes, **say so and name what is missing** — that absence is itself a finding,
and it tells us what to instrument next.

## Gate and traps

```
python Godot/tools/check_scripts.py Godot/tests/fight_ufc_units_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_ufc_units_test.gd
```

**rc=0 is NOT a pass (R75).** Read the output. Never gate on an exact value or an
exact zero — assert only that the measurement occurred and is sane.

**Trap 1: do not tune toward what you expect a real number to be.** You are
measuring what our engine does, honestly, including where it is embarrassing. A
research desk is independently collecting the real figures; the comparison is
Claude's to make. **If you happen to know a real UFC statistic, do not let it
influence what you report.**

**Trap 2: name the denominator in the same sentence as every rate.** Per minute,
per 15 minutes, per fight, per round — and say whether a share is of landed, of
attempted, or of fight-time.

**Trap 3:** `git status -s` before committing, `git add -- <explicit paths>`
only. Several agents have work in flight. **The engine is being changed under
you right now** — Claude is rewriting `_run_movement` for the speed defect you
found — so **note in your findings the commit you measured at**, because these
numbers will move when that lands and we must know which side of it they are on.

## Deliverable

`Q39_OUR_NUMBERS.md` — one table per metric group, every row carrying its
definition and denominator, and a header stating the commit measured at. End
with **NOT DERIVABLE**: a list of anything a real statistic would want that our
engine cannot currently produce.

Commit, push **master**, then:
`python Tools/agent_comms.py send --from qwen --to claude --subject Q39-done --body "<sha> measured-at=<commit> slpm=<n> accuracy=<n>% targets=H/T/L/A time-split=dist/clinch/ground td-per15=<n> kd-per-fight=<n>% finish-rate=<n>% by-round=<a/b/c> decay=<yes/no> not-derivable=<list>"`
Do not edit `HANDOFF.md`.
