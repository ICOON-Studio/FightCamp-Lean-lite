# G69 — WHAT THE ENGINE ACTUALLY READS OFF A FIGHT PLAN

**Agent:** Grok (`TASK_FIGHTPLAN_DESIGN`, question 2 of 5). Design only.
**Landed 2026-09-22.** Its three checkable claims were VERIFIED here against
our own tree before landing — see the verification note at the end. This is the
audit it asked for itself at the end of G68, and it did it before proposing a
single new field.

## THE HEADLINE: THERE ARE TWO ENGINES AND THEY DO NOT HONOUR THE SAME FIELDS

- **Realtime** runs boxing, kickboxing, Muay Thai and MMA.
- **Atomic** runs BJJ, judo, wrestling, sambo, karate and TKD.

A plan field can therefore be live in one discipline and dead in another, which
is invisible from the data file. That alone explains a good deal of G68's
finding that most of the catalogue does not differentiate.

## ABSENCE IS NOT `OPPORTUNISTIC`, AND THE DIFFERENCE IS LOAD-BEARING

This was the open question G68 raised and it has a definite answer:

| | atomic | realtime |
|---|---|---|
| role **missing** from `role_priority` | SECONDARY / 1.0 | SECONDARY / 1.0 |
| role explicitly `OPPORTUNISTIC` | **0.8** | **0.5** |

**So writing `OPPORTUNISTIC` is a real, deliberate de-prioritisation, and
omitting the key is not the same thing.** Any plan that meant "I don't care
about this role" and simply left it out has been saying "SECONDARY" instead.

## DEAD OR HALF-DEAD TODAY

Fields that exist in the schema and are not consumed on at least one path:

- **`phase`** — realtime never calls `phase_factor`. **VERIFIED:**
  `FightPlans.phase_factor` (`FightPlans.gd:183`) has exactly one caller,
  `FightSimulation.gd:3011`, which is the atomic engine.
- **`excludes_emphasis`** — the live corner has no grappling call to exclude,
  so it excludes nothing.
- **`target_bias` on the ground** — consistent with G68, where every wrestling,
  BJJ, judo and sambo plan is flat `{1,1,1}`.
- **`target_bias.legs`** in the atomic `_pick_target_region`.
- **File-level contingencies** on the live path.
- **Realtime role weights are computed but never applied as thrown**, because
  `FightMoves.ROLE_PRIORITY_FROM_PLAN` is `false`. **VERIFIED:**
  `FightMoves.gd:113` — `const ROLE_PRIORITY_FROM_PLAN := false`. **So a
  PRIMARY role does not arrive as more punches thrown.** This is the same
  switch Qwen's Q113 found and measured: turning it on took a `counter` role
  at weight 3.0 from 3–27% up to 35–67% across plans.

## THE ONE FIELD IT WOULD ADD, AND WHY IT THEN REFUSED TO ADD IT YET

Its proposal: **`seat_bias`** over GrappleSeat words — guard, half, side,
mount, back, over_under — read by `_grapple_ground`, `_grapple_standing` and
the atomic GROUND draw. That is the ground-side equivalent of `target_bias`
G68 said was the highest-value missing thing, and it is the field that would
finally let a passer differ from a guard player.

**Then its own self-objection overturned its recommendation, and it is right:**

> *"Do not author `seat_bias` yet. `_run_grapple` reads no plan field at all.
> Wire existing `role_weights` + `phase` into that stream first, then add the
> map. Unread schema is how the Q1 clone lived."*

**VERIFIED:** `_run_grapple` in `FightRealtime.gd` reads no plan field —
no `plan`, no `role_priority`, no `target_bias`, no `pace`.

So the order is: **make the existing fields live on the grapple path, THEN add
the new one.** Adding `seat_bias` to a stream that reads nothing would produce
exactly the defect G68 found — schema that looks like a feature and changes no
fight.

## WHAT IT SAYS NOT TO ADD

Per-plan hurt/abandon scripts, technique deny-lists, opponent-strength fields,
and a plan-level `preferred_range`. That half of the answer is usually the
useful one and it declined all four.

## STILL OPEN

Q3 — the plan and the corner are two dictionaries with no shared relationship.
Q4 (ground plans) is now partly answered by `seat_bias` above. Q5 (which coach
lines mislead) untouched.

## VERIFICATION NOTE

Three claims were checked here rather than taken from the report, and all three
held: `ROLE_PRIORITY_FROM_PLAN := false` at `FightMoves.gd:113`; `phase_factor`
called only from the atomic engine at `FightSimulation.gd:3011`; and
`_run_grapple` consuming no plan field.
