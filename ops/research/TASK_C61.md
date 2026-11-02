# TASK C61 — CODEX — THE SKILL THAT NARROWS, NOT ONLY RAISES

**Owner:** codex
**Model:** the strongest available, effort **high**, Fast **off**.
Reason: `FightSimulation.gd` is the core of the game, this changes the shape of
every landed/missed roll in it, and the deliverable is a measurement the
operator will make a balance decision from. Getting the number wrong is worse
than not producing it.

## Why this exists

R80 (`a7ea7eb`) shipped the burst and the stance matchup, and in doing so made
an old gap visible. Today skill only moves the **mean**:

```gdscript
var execution_quality := 0.6 + 0.4 * combined_mastery      # :1296
var success_chance := clampf(0.35 + 0.5 * execution_quality - ..., 0.1, 0.95)
var landed := rng.randf() < success_chance                 # :1352
```

A 95-technique fighter and a 25-technique fighter draw from the **identically
shaped** distribution — one flat `rng.randf()` against a threshold. The only
difference is where the threshold sits. Nothing in the engine says an expert is
more *repeatable*; it only says he is more *likely*.

The question this task answers is:

> Does striking skill belong in the engine as a narrower spread, a higher
> centre, or both — and what does adding a spread term actually do to a fight?

This came out of assessing a paper (AiShifu, *J. Student Research* HS Ed.
2023) that claimed a black belt's poses were more consistent than a beginner's.
**Do not cite that paper and do not go looking for it**: it is n=2 and its own
Figure 7 contradicts its abstract — the black belt was *more accurate but more
variable*. It is recorded as a rejected source, not as evidence. The question
survived it; the answer did not come with it.

You are not being asked to do a literature review. You are being asked to make
the engine able to answer the question and to report what it says.

## Part 1 — measure what we have now

Write a **throwaway probe** (`research/_c61_probe.gd`, run with
`--script research/_c61_probe.gd`, **deleted before you commit** — R80 did the
same and the digest carries the numbers instead).

Sweep the `technique` stat across at least five levels (e.g. 20 / 40 / 60 / 80 /
95) with **every other stat and both fixtures held constant**, run a decent
number of seeded fights at each level, and report per level:

- mean land rate, and the **standard deviation of the land rate across seeds**
- mean and standard deviation of `damage` on landed actions
- the spread of round-score margins

The expected result is that the mean climbs and the spread does **not** narrow.
Say so with numbers. If it turns out the spread already narrows for some
structural reason, say that instead and stop before Part 2 — that is a complete
and useful answer, and over-delivering a mechanism nobody needs is worse than
reporting the finding.

## Part 2 — the mechanism, behind a switch

Add a **consistency term**: skill narrows the spread of execution, it does not
only raise its centre. Shape is yours to choose and to justify in the digest;
the obvious form is to keep `success_chance` as the centre and draw the roll
from a distribution whose width shrinks as `combined_mastery` rises, rather
than from a flat `randf()`.

Hard requirements:

- **It ships OFF by default.** `options.get("consistency", false)` in
  `begin_fight`, stored on `fight_state`, exactly the way R80's
  `_burst_enabled` is done at `:456`. With it off, every existing seeded fight
  must be **byte-identical** to today — same exchange stream, same winner, same
  method, same cards.
- **It must not change the number of draws taken from `_rng` when off.** If
  your mechanism needs extra random numbers, take them from a separate
  generator seeded from the bout seed the way `_burst_rng` (`:455`) and
  `_judge_rng` are, or restructure so the draw count is unchanged. This is the
  single easiest way to break the whole test suite.
- A fighter at the floor of skill must not become *more* random than today, and
  one at the ceiling must not become deterministic. Name the bounds you chose.

## Part 3 — what it costs

Re-run the Part 1 probe with `consistency: true` and report the same table.
The operator decides from that table whether this ships on by default; **you do
not flip the default**. State plainly in the digest what a high-skill fighter's
win rate does against a low-skill one with the term on versus off — if it turns
a 65/35 matchup into a 90/10 one, that is the finding, and it is a good enough
reason for the operator to say no.

## Owned files

- `Godot/scripts/FightSimulation.gd` — **3,197 lines. Never open it whole.**
  Anchors: `:158` (`TECHNIQUE_STAT_EXECUTION_WEIGHT`, read only),
  `:376` (`begin_fight` — the option goes beside `_burst_enabled` at `:456`),
  `:455-456` (the `_burst_rng` / `_burst_enabled` pattern to copy),
  `:1285` (`_resolve_action`), `:1296` (`execution_quality`),
  `:1349` (`success_chance`), `:1352` (the roll itself),
  `:2466` / `:2519` (`_weighted_choice`'s own `execution_quality` — a
  **different** figure used for draw weighting; decide and say whether it is in
  scope, do not change it by accident).
- `Godot/tests/fight_simulation_test.gd` — 954 lines, new coverage. Read the
  sections you extend, not the file. `_test_burst_never_moves_the_fight` is the
  pattern for your off-by-default determinism test: copy its shape.
- `research/C61_DIGEST.md` — new.

**Do NOT touch** `Godot/tests/judge_panel_test.gd`, `AthleteDevelopment.gd`, or
anything under `Godot/scripts/` other than `FightSimulation.gd`.

## Gate

```bash
python Godot/tools/check_scripts.py Godot/scripts/FightSimulation.gd Godot/tests/fight_simulation_test.gd
```

Focused first, then the suite once in the background before the commit:

```bash
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_simulation_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/judge_panel_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_scoring_test.gd
python Godot/tools/run_tests.py
```

**As of `a7ea7eb` the suite stands at `total=190 fails=2`** — `athlete_
development_test.gd` and `stat_help_test.gd`, both from Q11's migration
regression (`CURRENT_DEVELOPMENT_VERSION` went 2→3 without migration stamping
it). Those two are **not yours** and `AthleteDevelopment.gd` is not your file.
Your gate is **fails=2 or better**; if you happen to land lower, say so and
push. Never gate on an exact count.

R75: rc=0 is **not** a pass. Read the runner's `SUITE total=N fails=M` line.

## The trap

`Godot/tests/judge_panel_test.gd:16` holds `PRE_R38_CARDS` — **ten seeded bouts
pinned card-for-card**. R80 learned this the hard way: a small stance weighting
on the draw moved `boxing_11` from a two-round to a three-round fight and the
whole snapshot went red. Your change sits *closer* to the roll than R80's did,
so with the switch on it will move those cards; with the switch off it must not
move them by a single character. That test is your real gate, not
`fight_simulation_test.gd`. Run it early and often, not once at the end.

Second trap, smaller: `_resolve_action` is called for single actions **and for
every link of a chain** (`mods.in_chain`). Whatever you do to the roll happens
once per link, so a four-link combination feels your change four times. Check
`combo_chains_test.gd` too.

## Follow-up, named and out of scope

R80's burst jitter is flat regardless of who is throwing —
`rng.randf_range(-0.9, 0.9)` on `thrown` at `_write_burst`. If the ruling here
is that skill narrows spread, the burst's texture should narrow with it. That is
the **next** slice. Name it in your digest and stop.
