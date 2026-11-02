# R83 DIGEST — R82 stage 2: the core reads the fighter, and the fight hurts

Claude, 2026-09-09. Owned: `FightRealtime.gd`, `fight_realtime_test.gd`.
`FightSimulation.gd` untouched — the rebaseline ruling stands.

## What shipped

Both seams closed as body replacements, exactly as the brief scoped them.

**1. The decision seam.** `_decide()` is **deleted**, not kept as a fallback —
a dead second decision model still counts as two. `_run_decision` now calls
`FightIntent.decide(stats, gap, preferred, stamina, place, roll)` (Q15).
`preferred_range` and `tolerance` are settled **once in `_build_fighter`** and
stored on the man. `_run_movement` needed **no change**: Q15 returns
close/hold/retreat/circle, which is what it already switched on.

**2. The damage seam.** `_run_impact` builds every record through
`ImpactModel.make_impact` (C63) and applies both channels — `wear_from`
subtracts from a new six-region `body_condition` per fighter, and
`shock_chance` is rolled against `_rng_impact`. The log event carries what the
blow cost: `wear`, `shock`, `shocked`, `flash_knockdown`.

`_fresh_body_condition()` is a function, not a const, on purpose: GDScript
dictionaries are references, so one shared constant would have been **one body
between the two men**. The test asserts they are separate.

## The two pinned gaps, both closed

**Gap 1 — four words vs six.** `absorbed` and `slipped` sat in
`ImpactModel.CONTACTS` and in U20's wear table for a whole stage while no
producer could emit them. They are the **defender's** words, and stage 1 gave
the defender no say in what happened to him. Defence now downgrades a blow one
rung of U20's ladder: clean → `absorbed` (1.0 → 0.25), glancing → `slipped`
(0.4 → 0.0), at `0.10 + 0.35 * defense`.

The downgrade **direction is the whole point**. Wiring it the other way —
letting a good defensive roll turn `blocked` (0.0) into `absorbed` (0.25) —
reads just as naturally in English and would have meant better defence taking
*more* damage. `blocked` and `missed` are already zero and are left alone.

Asserting the vocabulary is *legal* was not enough — that passed before, with
two words dead. The test asserts all six **occur**. Verified across 12 seeds:
none missing in any of them.

**Gap 2 — refusals must fail, not vanish.** `make_impact` returns `{}` on a
word it does not know. Nothing built through it before, so a typo would have
produced no event, no error and no fight that looked wrong. Refusals are now
counted on state, `push_error`ed, and asserted zero — with `impacts_built` as
the witness, because zero refusals proves nothing if nothing was ever built.
A full fight: **947 impacts built, 947 logged, 0 refused.**

## The gate

Unmoved. Seeded replay is still byte-for-byte across three seeds, and now
covers the **bodies** too — two men who took the same blows must end in the
same condition, or the replay is byte-identical about everything except what it
did. Every draw comes from `_rng_impact` / `_rng_decision`; the per-impact
count is **fixed at seven** and nothing is drawn inside an `if`. A conditional
draw would still replay against itself, but it would make the stream's position
depend on the fight's content, so the next person to add a rule here would
shift every seeded fight without touching a number.

`fight_realtime_test.gd`: **61 checks, 0 failures** (was ~31).

## Numbers from a real fight (seed 4001, 3x5 at 20 Hz, 20,400 ticks)

| | |
| --- | --- |
| Impacts | 947 built, 947 logged, **0 refused** |
| Contacts | clean 248, missed 244, glancing 203, absorbed 94, slipped 92, blocked 66 |
| End condition A | head 72.3, torso 68.0 |
| End condition B | head 69.3, torso 70.1 |
| Shocks | 2–6 per fight across 12 seeds, never zero |

Damage does **not** run away: both men finish a hard three-rounder at ~70%
head and torso with no stoppage rule in play. U20's conservation-split worry
does not bite at this impact rate — no rebalancing needed before R84.

## TWO THINGS R84 MUST KNOW

**1. `is_flash_knockdown` is mathematically unreachable.** C63's own numbers:
`shock_chance` peaks at **0.16** for a head shot (force 1.0 against a fully
destroyed head) and **0.04** for the body, while `FLASH_SHOCK_FLOOR` is
**0.25**. The flash rule *also* demands a head still above 80, where the
ceiling is only **0.096**. The two conditions cannot both hold, so U20's
headline recovered knockdown can never fire — 0 in every fight run.
`HEAD_SHOCK_MAX` (0.45) and `LIVER_SHOCK_MAX` (0.20) are dead constants for
the same reason.

This is the *same class of defect as gap 1*: a feature dead on arrival that no
test would catch. `ImpactModel.gd` is **C63's file and not R83's to edit** —
it needs a small owned fix (lower `FLASH_SHOCK_FLOOR` to ~0.10, or raise
`HEAD_SHOCK_BASE`), and **R84 cannot do stoppage until it lands**. The R83
test deliberately does not assert a flash knockdown, and says why in a comment,
so it will not go red when the fix arrives.

**2. Only two of six regions can ever be hit.** `_run_impact` picks
`REGIONS[rng.randi_range(0, 1)]` — head_neck and torso_core only, inherited
unchanged from stage 1. The four limb regions sit at 100.0 forever, so their
`REGION_WEAR_COEFFICIENTS` (0.6/0.8) are unexercised. **Left deliberately
alone**: a strike-target distribution is a balance decision, not a wiring one,
and changing it would have shifted every seeded fight for a reason this task
did not ask for. R84 should decide it explicitly.

## Files

- `Godot/scripts/FightRealtime.gd` — both seams, the six-word vocabulary,
  `body_condition`, `body_condition_of()`, refusal counters.
- `Godot/tests/fight_realtime_test.gd` — 61 checks; five new tests plus the
  bodies folded into the replay gate.
