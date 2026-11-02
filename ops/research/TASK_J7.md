# TASK J7 — THE SCALE AND THE BELT: WHAT IS ACTUALLY PUBLISHED (John)

**Status: ASSIGNED 2026-09-07.** Research only. Depends on R42 (`a534dad`).

Model: top tier, effort high, Fast off. One delivery.

## Why this exists

R42 shipped a rule the game now enforces: **a contestant who misses the
contracted limit cannot win or retain the belt; the one who made weight still
can.** A champion who misses and wins keeps the fight and the division goes
vacant. When both miss, the belt does not move at all.

That rule was written the way R41's `interim_hold_weeks` was written — as a
**GAME RULE with no federation's name on it** (J1 §4.1). It was shipped
because it is the honest direction, not because a citation was in hand.

Nobody has checked what is actually published. That is this pack.

## The four questions

**Number your decisions P1–Pn**, so nothing collides with J3's D1–D16,
J4's E1–E34, J5's G1–G34 or J6's A1–A18.

### Area 1 — The championship weight itself
What do commissions and the Unified Rules publish about the weight allowance
for a **championship** bout as against an ordinary one? Is the zero-allowance
championship limit a regulation, an ABC recommendation, or a sanctioning
body's own condition? Where does the game's own allowance
(`WeightCut.gd:69` `allowance_for`) sit against it?

### Area 2 — Who is ineligible, and who says so
Is *"a contestant who missed weight cannot win the title"* a **published
rule** of anyone — a state commission, the ABC, a sanctioning body's own
championship regulations — or is it contractual and promotional practice
recorded case by case? Distinguish, as J4 and J5 both did, a **statute** from
a **body's own published condition** from **CUSTOMARY journalism**. If the
three disagree, say so and mark UNKNOWN rather than picking a favourite.

### Area 3 — What happens to the belt
When the ineligible contestant wins anyway, what is published about the
outcome — vacancy, a stripping procedure, a hearing, a period to make weight
again? **And when both contestants miss?** R42 shipped "the belt does not
move" as the smaller rule and said the code argued for it; say whether
anything published argues otherwise. This is the single most decision-shaped
question in the pack.

### Area 4 — The purse, the catchweight, and the day after
The game already forfeits a **20%** fine and converts the bout to a
catchweight (`WeightCut.gd:189` reading the `miss` block of
`assets/data/weight_classes.json`). What is published about
the forfeit percentage, about who approves a bout going ahead after a miss,
and about second-day / day-of weigh-ins and hydration testing? **Say plainly
whether any of it is shippable or whether it is scenery**, in J5's and J6's
voice.

## What the pack must end with

- A **decisions page** up front, one recommendation and one line why per call,
  in J6's table shape.
- **File-level anchors**: what is live in the game today versus what this
  study proposes, marked honest / invented / absent — including R42's own
  `championship_rules.json` (which R42 deliberately did **not** add a knob to)
  and `WeightCut.gd`'s `miss` block.
- A **priority ruling** with the standing question answered explicitly:
  **does any of this outrank J5's rank-2 membership object?** J6 A16 said no
  for the athlete ledger; say so or say why not, and do not reopen J5's
  priority, R40, J3 Areas 1–3, J4 E1–E3, or R42's shipped rule.
- A **scenery list**, as plainly as J2 §5.1.

## The trap to avoid

R42 is **already shipped and correct as a game rule**. This pack is not a
review of it and must not recommend rewriting it because a citation is
missing — J1 §4.1 exists precisely so a game rule may be authored without a
federation's name. What the pack is for: knowing which parts are backed, which
parts are a body's own condition the game may one day want to name, and which
parts are the game's own honest invention. **"Nothing is published, ship
nothing" is an acceptable answer here, exactly as it was in J5 and J6.**

Do not author a percentage, a hearing procedure, a rehydration ladder or a
day-of-weight system. If Area 4 tempts you toward a second weigh-in mechanic,
that is a new mode, not a fifth area.

## Out of scope

- No `.gd`, no `.tscn`, no `Godot/assets/data/`, no `HANDOFF.md` edits.
  **Claude writes your HANDOFF block.**
- No reopening of J5's priority ruling or R42's rule.
- No federation's name attached to any number the game already ships.

## Done

Push `research/J7_THE_SCALE_AND_THE_BELT.md` and your land note.
Message Claude; Claude writes the HANDOFF block and marks the task done.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/J7_THE_SCALE_AND_THE_BELT.md
```
