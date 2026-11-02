# TASK Q21 — QWEN — THE TWO LADDERS G36 SOURCED, WIRED

Model: Qwen default, `--yolo`. Owner: Qwen. Base: `master` at `043a99a` or
later, `SUITE total=214 fails=1` (the one failure is Codex's
`grapple_contract_test.gd`, C70, **not yours** — leave it alone).
Assigned 2026-09-10. **One task. Do this and stop.**

---

## Why this exists

`GradeLadder.gd` carries seven ladders for the game's fifteen disciplines.
Three of the eight without one — boxing, wrestling, sanda — are **correctly
empty forever**, because C52 reviewed World Boxing, UWW and IWUF and found no
practitioner grade. **Five were never surveyed at all**, and the module says so
out loud in a comment that is now out of date:

`Godot/scripts/GradeLadder.gd:41-44` currently reads, in part:

> `sambo`: FIAS launched a ten-level system in 2026 but C52 did not source the
> level names. An empty ladder is the honest answer in all four cases — do not
> invent one.

**G36 has now sourced them.** `research/G36_THE_FIVE_LADDERS.md` (landed
`043a99a`) surveyed all five and came back with two ladders and three refusals.
Your job is to wire the two and make the module stop claiming the gap is a
fact about the world.

## What to do

**Everything you need is already written in `G36_THE_FIVE_LADDERS.md`, in a
section headed "Ready-to-paste consts". Paste from it. Do not re-research, do
not rename a rung, do not add one.**

1. **Add `LADDER_SAVATE`** — 8 rungs, `gant_bleu` … `gant_argent_technique_3`.
   The three `kangourou_*` rungs are **youth discovery only and must NOT go on
   this const** (G36's open question 1, defaulted to omit).
2. **Add `LADDER_SAMBO`** — 10 rungs, `novice` … `grand_master`.
3. **Wire both into whatever `ladder_for()` dispatches on** — read
   `GradeLadder.gd:85` and follow it. Both must answer `has_ladder() == true`.
4. **Add the two sourced `MINIMUM_AGE` entries**, and only these two:
   * `"savate|gant_argent_technique_1": 16`
   * the moniteur one is a **teaching-diploma** gate, not a grade-award gate —
     G36 says so explicitly. **Do not add it to `MINIMUM_AGE`.**
5. **Add NOTHING to `MINIMUM_WEEKS`.** G36 found no published interval for any
   of the five. The keys stay **absent** so R89 keeps labelling the interval
   `authored`. Writing `0` is a different and much stronger claim, and writing
   `-1` here would say "we looked and the rule is unknown" when the truth is
   "no rule is published" — the absent key is the honest one.
6. **Correct the two stale comments.** `GradeLadder.gd:41-44` and
   `grade_progression_test.gd:68-69` both name sambo as unsourced. It is
   sourced now. Say what is true: boxing, wrestling and sanda are empty
   **forever** by C52; pencak silat, arnis and capoeira are empty because G36
   **refused** them on sequence; savate and sambo are **wired from G36**.
7. **Extend `grade_progression_test.gd`.** It currently proves only that boxing
   and wrestling have no ladder (`:77-78`). Add, in the same function: savate
   and sambo now **have** one and start on their first rung, and boxing,
   wrestling **and sanda** still do not. Assert that the refused three —
   pencak silat, arnis, capoeira — **still have no ladder**, so nobody adds one
   later out of kindness.

## The rule that outranks tidiness

**Never widen a sourced module by guessing.** If a rung name in G36 looks odd
to you (`gant_blanc` sits *after* `gant_rouge`, which is not the order a
colour-belt instinct expects), that is the FFSbf&DA sequence and it is
sourced — **paste it, do not "fix" it**. If you think G36 is wrong, say so in
your digest and ship it as written anyway.

## Owned files

| File | Lines | Note |
| --- | --- | --- |
| `Godot/scripts/GradeLadder.gd` | 181 | Read whole. Consts `:17-40`, `MINIMUM_WEEKS` `:51`, `MINIMUM_AGE` `:61`, `has_ladder` `:81`, `ladder_for` `:85`. |
| `Godot/tests/grade_progression_test.gd` | 372 | **Do NOT read whole.** The block you extend is `sed -n '66,86p'`. |
| `research/Q21_DIGEST.md` | new | Short. |

**Read `research/G36_THE_FIVE_LADDERS.md`** — that is your source, and
the const blocks are near the end.
**Do NOT read** `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any
other digest. **`GameState.gd` is 14,766 lines — never open it whole**; if you
need it, `grep -n "GradeLadder"` and read a `sed -n` window.
**Do NOT touch `Godot/tests/grapple_contract_test.gd`** (Codex, C70) or
`Godot/tests/grade_ladder_sourced_test.gd` if it appears (Codex, C71).

## Parse gate BEFORE any test

```
python Godot/tools/check_scripts.py Godot/scripts/GradeLadder.gd Godot/tests/grade_progression_test.gd
```

## Tests

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/grade_ladder_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/grade_progression_test.gd
python Godot/tools/run_tests.py
```

**Ceiling, not an exact count:** `fails=1` or better — the one allowed failure
is C70's `grapple_contract_test.gd`, which is not yours. **If it comes back at
0, say so and push**; C70 will have landed in parallel. If anything else is
red, that is your finding and it is the deliverable.

## Done

Commit, push `master`, write `research/Q21_DIGEST.md`, then send one line:

```
python Tools/agent_comms.py send --from qwen --to claude --topic "Q21-done" --body "<commit> <suite line> <anything G36 left ambiguous>"
```

Do NOT edit `HANDOFF.md` — Claude writes your block. Stage explicit paths only;
this checkout is shared. Never a bare `git stash` / `reset --hard` / `clean`.

## The trap specific to this task

**`grade_progression_test.gd` asserts an ABSENCE, and an absence assertion is
the one kind that passes for the wrong reason.** Its whole point (`:70-71`) is
to prove "the wiring did not quietly invent a ladder for two thirds of the
gym". When you add savate and sambo you are deliberately moving two disciplines
from the absent side to the present side — so the test must be **extended**,
never **loosened**. If you find yourself deleting an assertion to make the
suite green, stop: you are removing the guard that stops someone inventing a
boxing belt. Add the positive cases and keep every negative one.
