# TASK Q36 — QWEN — DOES A CLIP FIT IN A BEAT?

Model: qwen (CLI, `--yolo`), medium effort.
Owner: qwen. Tier: **NEW TEST FILE ONLY** — parse gate plus this one test. Do
NOT run the full suite.

## Why this exists

You have measured where a punch happens (Q34) and what a collision floor would
cost (Q35). The remaining unmeasured axis is **time**, and it decides a purchase.

Your own Q32 found that a beat's span **VARIES** — median 14 s, but as short as
**0.25 s on terminal beats** — and that the presented rate is 66 action beats
per bout with 92.6% of impacts dropped. Meanwhile U39 (`6feb41f`) measured the
one clip we own at **2.47 s**, and U40 is slicing it into single punches that
will land somewhere near **0.8 s** each.

Nobody has checked whether the clips fit the beats. If a meaningful share of
beats are shorter than the clip that must play in them, then either the clip
gets cut off mid-punch, or the stage runs behind the fight — and the fix is
either shorter clips (a purchase decision) or a playback rule (a code decision).
**Measure it before we buy.**

## What is already known — do not re-derive

- `FightBeatAdapter.gd` is the seam: `begin`, `is_fight_over`, `advance_beat`,
  `result`, `state_view`. **A beat is a WINDOW of fight-time, 280 ticks = 14 s
  at 20 Hz** — sizing it by time is what makes the drop happen. Read this file
  for its public API; **do not edit it.**
- `Godot/scripts/FightClipBinding.gd` — U39's, and **Cursor is editing it right
  now under U40.** Read `metadata_for` to see the `length_s` / `reach_m` shape;
  **do not edit it**, and do not depend on how many roles it binds, because that
  number is changing under you. Take clip lengths as PARAMETERS of your
  measurement (2.47 s for the combo, and a sliced-punch candidate of 0.8 s),
  not by reading whatever the dictionary happens to hold when you run.
- `Godot/scripts/FightStageDirector.gd` — `role_for_strike`, `role_for_react`.
  Read it whole (321 lines); do not edit it.

## Owned files

- `Godot/tests/fight_beat_timing_test.gd` — NEW, yours.
- `research/Q36_THE_BEAT_FITS.md` — NEW, yours.

**Do not edit any script.** This is a measurement.

## What to measure

Over **200 seeded boxing bouts, seeds 200000–200199** — the same seeds as Q34
and Q35, so all three studies are comparable — drive the fight through
`FightBeatAdapter` and record, for every presented beat:

1. **The span distribution.** Min, P05, P25, median, P75, P95, max, and a
   histogram. Q32 said the median is 14 s and terminal beats can be 0.25 s;
   confirm or correct that with the full shape. **How many beats are under
   1.0 s? Under 2.47 s?**
2. **The fit, against three candidate clip lengths** — 2.47 s (the combo as it
   exists), 0.80 s (a sliced single punch) and 1.20 s (a generous single punch).
   For each: what share of beats are **too short to contain it**?
3. **Which beats are the short ones?** Terminal beats (the fight ends), knockdown
   beats, round-end beats, or ordinary ones? **If short beats are almost all
   terminal or knockdown beats, the problem nearly vanishes** — those are exactly
   the moments where a cut-off punch is masked by a knockdown clip or a stoppage,
   and M15 has already boarded a hard cut there. Say so plainly if that is what
   the data shows.
4. **The gap the other way.** When a beat is 14 s and the clip is 0.8 s, what
   fills the other 13 seconds? Count it: across a bout, how many seconds of
   presented fight-time have **no strike clip to play**? Express it as a share.
   This is the same hole J18 is researching from the literature side — you are
   measuring ours.
5. **Back-to-back beats.** How often do two action beats arrive close enough
   together that the second would have to interrupt the first's clip? Give the
   share and the median gap between consecutive action beats.

## The gate and the traps

- `python Godot/tools/check_scripts.py Godot/tests/fight_beat_timing_test.gd`
- `Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_beat_timing_test.gd`

**rc=0 IS NOT A PASS (R75).** Read the output.

**Trap 1: assert only that the measurement occurred and is sane** — beats > 0,
spans finite and non-negative, histogram sums to the sample count. **Never gate
on an exact value and never on an exact zero.**

**Trap 2: another agent is mid-edit on `FightClipBinding.gd`.** Treat clip
lengths as parameters you declare at the top of your test, not as data you read
out of a file that is changing. If you read the dictionary, your measurement
becomes unreproducible the moment U40 lands.

**Trap 3: run `git status -s` before you commit** and `git add -- <explicit
paths>` only. Never `git add -A`, never a bare `git stash` / `reset --hard` /
`clean` — this checkout is shared and other agents have work in flight.

## Deliverable

`Q36_THE_BEAT_FITS.md`: the tables, then **VERDICT** — one line on whether the
clips we are about to buy fit the beats the engine produces, and one line on
whether the short beats are concentrated in moments where it does not matter.

Commit, push **master**, then:
`python Tools/agent_comms.py send --from qwen --to claude --subject Q36-done --body "<sha> beats=N span-med=Xs under-1s=A% under-2.47s=B% short-beats-are=<terminal/kd/ordinary> no-clip-share=C% back-to-back=D% verdict=<fits/does-not-fit>"`
Do not edit `HANDOFF.md`.
