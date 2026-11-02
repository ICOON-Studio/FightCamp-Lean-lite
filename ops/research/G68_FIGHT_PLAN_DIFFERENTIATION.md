# G68 — DO THE 34 FIGHT PLANS ACTUALLY DIFFER?

**Agent:** Grok (`TASK_FIGHTPLAN_DESIGN`, question 1 of 5). Design only, no
checkout, no code. **Landed and INDEPENDENTLY VERIFIED by Claude 2026-09-22**
against `Godot/assets/data/fight_plans.json` on our own tree — every figure
below was recomputed here and every one matched.

## WHY THIS MATTERS

The fight plan is the **only thing the player chooses that changes how a fight
is fought**. Attributes, learned techniques and the opponent are all fixed
before the bell. If two plans produce the same fight, the player has no lever.

## THE FINDING: THE SHAPE CAN EXPRESS A LOT, AND THE FILE USES ALMOST NONE OF IT

| Axis | Space available | Space used |
|---|---|---|
| `pace_curve` | 27 possible | **12** |
| `role_priority` | 5^8 maps | **30** |
| `target_bias` | unbounded | **15 of 34 are exactly `{head:1.0, body:1.0, legs:1.0}`** |
| Full mechanical tuple | — | **33 unique of 34** |

**VERIFIED HERE:** 34 plans; 15 flat-bias; 12 distinct `pace_curve`; 30
distinct `role_priority`; 33 distinct tuples of
(`pace_curve`, `target_bias`, `role_priority`, `phase`).

## ONE EXACT CLONE

`bjj_points_player` and `sambo_hold_player` are **mechanically identical** —
same pace curve, same target bias, same role priority, same phase. Two
different pickers, one fight. Confirmed here.

## DEAD AXES

- **`legs` is locked at 0.3** for every boxing, karate and TKD plan (4 + 3
  plans respectively) — and correctly so, since those rulesets do not kick to
  the legs, but it means the axis carries no information there.
- **Every wrestling, BJJ, judo and sambo plan has a flat bias** (`legs` 1.0
  across freestyle 3, greco 3, bjj 4, judo 3). So **ground plans differ only
  by roles, pace and phase** — `target_bias` says nothing at all about them.
  A guard player and a passer are not distinguishable by `{head, body, legs}`.

## PAIRS A PLAYER COULD NOT TELL APART

Same ruleset, so the same player is choosing between them:

1. `boxing_out_boxer` ↔ `boxing_counter_puncher`
2. `karate_blitz` ↔ `karate_kicker`
3. `bjj_passer` ↔ `bjj_points_player`
4. `wrestling_positional` ↔ `wrestling_scrambler`

**Muay Thai, TKD, MMA and judo do separate properly** — judo via its `newaza`
phase. So the schema is capable of expressing difference; most of the
catalogue simply does not use it.

## WHAT GROK SAYS IS STILL WRONG (its own words)

- **No sim-read audit.** Nobody has checked what the engine actually READS —
  `plan_alignment`, and what absence means versus `OPPORTUNISTIC`. A field the
  engine ignores is worse than no field, because it looks like a feature.
- **Q2–Q5 not opened**: what is missing from the shape, how a plan should
  respond to the fight between rounds, what a ground plan needs, and which
  coach lines mislead.
- **Greco has no greco-shaped plan.**

## WHAT THIS BUYS THE PROJECT

Two of the four indistinguishable pairs are ground plans, and the exact clone
is a ground plan — which lands on the same conclusion the capsule and
grappling work keeps reaching from the other direction: **the standing game is
modelled and the ground game is not.** The cheapest fix on this list is the
clone; the most valuable is giving `target_bias` a ground-side equivalent, so
a passer and a guard player can differ at all.
