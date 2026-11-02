# TASK R85 — CLAUDE — THE REBASELINE: THE CARDS ARE RE-PINNED AGAINST THE REAL ENGINE

Model: Opus, high effort, Fast off. Owner: Claude. **Fresh session — do not
start this inside the R86 session.** Base: `dd6a545`, `SUITE total=202
fails=0`.

---

## The ruling this executes, and its one duty

The operator ruled REBASELINE on 2026-09-09. C62 found that a continuous causal
model can be perfectly deterministic and still not reproduce the ten pinned
`judge_panel_test.gd` scorecards. Those values are **accepted as gone** and are
re-pinned against the real-time engine. One engine, not two.

> **A commit that deletes the old pinned cards without adding new ones is
> forbidden** — that is precisely the R75 failure, a suite that passes because
> it stopped checking.

So the window with no scoring gate is kept at zero: the old cards die and the
new ones are pinned **in the same change**.

## THE BLOCKER DISSOLVED — read this before planning anything

R84 reported, and `CURRENT_STATUS.md` still says, that a split or majority
decision is arithmetically impossible and the three-judge panel is decorative.
R85R then argued this raised it from a curiosity to a **blocker for R85**,
because the scorecard screen would render three identical rows.

**R86 measured it again and the report was wrong — or rather, it was true only
of the DEFAULT scoring profile, which is what every one of those sweeps
used.** `FightRealtime.begin` does `Scoring.profile_for(options.get("ruleset",
{}))`, and no test passes a ruleset, so every measured fight scored under
`DEFAULT_WEIGHTS` — where `volume` is 0.0 and `control` is 1.0 against a
`control_score` the real-time engine never emits. Damage really was the only
non-zero weight, but only because the profile was empty.

Boxing's own ruleset carries **`volume: 0.2`** and **`zones.body_hand: 0.3`**,
`judge_count: 3`, `judge_sigma: 0.06` — and `volume` is in
`JudgePanel.SECONDARY_WEIGHTS`, with `striker_eye` nudging it by 2.0 sigma.
Measured over 40 twelve-round bouts under the real boxing ruleset:

| Profile | Decisions | Panels disagreeing on a round | Different totals |
| --- | --- | --- | --- |
| none (what R84 measured) | 11 unanimous, 3 unanimous_draw | **0** | **0** |
| **boxing** | 10 unanimous, **1 split**, **2 majority_draw**, 1 unanimous_draw | **7 of 14** | **7 of 14** |
| **mma** | 10 unanimous, **1 majority**, **1 split_draw**, 2 unanimous_draw | 4 of 14 | 3 of 14 |

**The panel is not decorative and grappling is not required.** Fix the claim in
`CURRENT_STATUS.md` and `HANDOFF.md` as part of this task — a stale conclusion
read as fact is the exact failure mode that cost C17 a cycle.

## What to do

1. **Run the real-time engine under real rulesets.** The ten pinned specs in
   `judge_panel_test.gd:_cards_of` span seven rulesets and take an ATHLETE
   shape (`discipline`, learned techniques, a tactical rating) that
   `FightRealtime.begin` does not accept — it takes `stats` and `reach_cm`.
   Decide and write down how a bout spec reaches the new engine. **Prefer a
   bridge in the test over widening `begin`'s contract**; if `begin` must
   change, say why in the digest.
2. **Judo, taekwondo and both wrestlings are the honest problem.** The
   real-time engine emits no grappling at all, so a judo card off it is not a
   rebaselined judo card — it is a striking card wearing judo's ruleset. The
   old `wrestling_9` card is already `0-0/0-0`. **Decide explicitly**: re-pin
   only the striking rulesets against the real-time engine and keep the
   federation rulesets pinned against the atomic engine until grappling lands,
   or re-pin all ten and label the grappling ones as known-degenerate. Either
   is defensible; leaving it implicit is not.
3. **Capture and pin.** New cards, in the same format, with a comment saying
   what engine and what commit produced them.
4. **Retire `PRE_R38_CARDS` in the same commit** that adds the replacements.
   Never in a separate one.
5. **Only then**, consider whether `FightSimulation.gd` can go. The ruling says
   the atomic engine stays *until the real-time engine can pin its replacement
   cards* — if step 2 leaves federation rulesets on the atomic engine, it
   stays, and that is a finding to report, not a failure.

## Owned files

| File | Lines | How to read it |
| --- | --- | --- |
| `Godot/tests/judge_panel_test.gd` | 293 | Owned. Read whole — it is small. `PRE_R38_CARDS` at `:16`, the comparison at `:143`, `_cards_of` and the ten specs at `:243`. |
| `Godot/scripts/FightRealtime.gd` | 940 | Owned. **Never whole.** `begin` `:181`, `advance_tick` `:344`, `result` `:428`, `_close_round` `:475`, `_run_impact` `:707`. |
| `research/R85_DIGEST.md` | — | Yours. New. |

Read-only: `Godot/scripts/RoundScoring.gd` (`profile_for` `:26`,
`round_points` `:68`), `Godot/scripts/JudgePanel.gd` (`SECONDARY_WEIGHTS`
`:24`, `BIAS_NUDGE` `:32`, `panel` `:42`),
`Godot/assets/data/combat_rulesets.json`. Take the HANDOFF slice, never the
file. **`GameState.gd` is 12,900+ lines — never open it whole.**

## Gates

1. **The suite never loses its scoring gate.** At no commit in this task does
   `judge_panel_test.gd` run with no pinned cards at all.
2. **The new cards are reproducible** — pin them, then assert a second run
   matches, so a card that is secretly non-deterministic cannot be pinned.
3. **A split or majority decision actually OCCURS** under a real ruleset,
   asserted in the engine's own numbers. That is the R84 finding closed, and it
   must be asserted rather than described.
4. The R82 replay gate is unmoved: log, bodies, scorecards, result and
   stoppage all byte-identical across two runs of a seed.
5. Every existing `judge_panel_test` assertion T1–T9 still passes, including T9
   — **no real official is ever named**.

## Parse gate BEFORE any test

```
python Godot/tools/check_scripts.py Godot/tests/judge_panel_test.gd Godot/scripts/FightRealtime.gd
```

## Tests

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/judge_panel_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_realtime_test.gd
python Godot/tools/run_tests.py
```

**Ceiling, not an exact count:** `fails=0`, `total` at least 202.

## The trap specific to this task

**Do not re-pin a card you have not proved is stable.** The whole value of a
pinned card is that it goes red when behaviour moves; a card captured from a
single run of an engine that is still being tuned is a card that will go red
for no reason next week and be "fixed" by re-pinning, which is R75 arriving
slowly. Run each bout twice and pin only what agrees with itself — and note in
the digest that R86 moved every seeded fight, so anybody re-pinning after a
tuning change must expect exactly that and re-run rather than assume a defect.
