# TASK C43 — CODEX — GRAPPLE: THE SEVENTH ATTRIBUTE

Model: top tier, effort **high**, Fast off. One session.

This is the job the luna note named as "the next Codex-shaped job": **one new
stat threaded through a dozen files, the same edit repeated.** Volume, not
judgement — every design call is already settled by J13, quoted below, and none
of them is reopened here.

## Why this exists, and what is already decided

J13 Area C (`research/J13_THE_BODY_THE_DIET_AND_THE_PICTURE.md`) settled
the stat set. The rulings you build inside, verbatim:

- **DC1 — one set.** One stat set for every discipline, never a second table
  per discipline. Grappling-relevant stats sit low and simply do not fire in a
  boxing bout.
- **DC2 — first-wave add: `GRAPPLE` only.** 0-100, the imposition attribute:
  who takes the fight to the clinch or the mat. Graded **authored** as the
  add, **DIRECT** as the missing phase — without it, DEFENSE's
  submission-resistance job never matters in wrestler-vs-boxer.
- **DC3 — `PRESSURE` is second wave and is NOT in this task.**
- **DC4 — no `chin`, no `durability`.** J10 D8 stands.
- **DC5 — `GRAPPLE` is trainable** (FIGHT IQ stays derived; never gym-train IQ).
- **DC6 — ceiling 8-10 visible stats.** Seven is inside it; do not add an
  eighth on the way past.

And the three boundaries J13 states explicitly, because each is a way to get
this wrong:

- **GRAPPLE is not TECHNIQUE.** Technique is the quality of the action; grapple
  is whether the fight *goes* where that action lives.
- **GRAPPLE is not DEFENSE.** Defense already does two jobs (landing and
  submission resistance); this adds the imposition that makes the second job
  reachable, not a third job on DEFENSE.
- **GRAPPLE is not wrestling proficiency.** Proficiency is "how good at this
  discipline" and already exists. Two wrestlers differ in GRAPPLE the way two
  boxers differ in POWER.

## Owned files

Yours this cycle; nobody else is in them. **`GameState.gd` is ~13,800 lines —
never open it whole.** Its stat seam is `STAT_KEYS` at `:137`, and
`get_athlete_rating` at `:666-680`; find the rest with
`grep -n "STAT_KEYS\|fight_iq" Godot/scripts/GameState.gd`, which is the honest
way to enumerate this job's real size.

- `Godot/scripts/GameState.gd` — `STAT_KEYS:137` and every site that derives
  from it.
- `Godot/scripts/AthleteStatModel.gd`, `Godot/scripts/AthleteDevelopment.gd`.
- Creation and training seams, and **every panel that currently prints six
  stats** — enumerate them with grep rather than assuming; that enumeration is
  the first thing your digest should report.
- `Godot/assets/data/` — any file carrying a stat list.
- The tests of everything above.

## The work

1. **`GRAPPLE` exists, 0-100, in one place.** Add it to `STAT_KEYS` and let
   every derived site follow. A site that hardcodes six stats instead of
   reading `STAT_KEYS` is a bug you are fixing, not a site you are working
   around — report how many you found.
2. **Old saves get it.** A save written before this stage has six stats; it
   must load, and it must not read as a fighter with GRAPPLE 0 unless that is
   deliberate and stated. Follow the migration pattern already in the file
   (`BodyReadiness.migrate_athlete` is the house shape: additive, idempotent,
   defaulted, reported).
3. **It is trainable** (DC5) — wire it into the same development and training
   paths the other trainable stats use. Do not invent a new curve; mirror an
   existing trainable stat exactly.
4. **It is generated** for new and world athletes the way the other six are,
   respecting whatever discipline weighting already exists. A wrestler should
   not end up with the same distribution as a boxer *if* the generator already
   varies by discipline — if it does not, do not add that, and say so.
5. **Panels print seven.** Every card, profile tab and comparison that showed
   six shows seven, using each panel's existing layout rules. **If a panel's
   layout genuinely cannot hold a seventh row, stop and report it — do not
   redesign the panel.** Layout is Cursor's, not yours.
6. **Ratings stay honest.** `get_athlete_rating` averages `STAT_KEYS`; adding a
   seventh changes every rating in the game. That is expected and correct, but
   **any test asserting a specific rating will move** — update the expectation,
   never the formula, and list every changed number in the digest.

## Refusals

- **No `PRESSURE`, no `chin`, no `durability`, no footwork, no flexibility, no
  strength split from power, no cardio split from conditioning.** DC3/DC4 and
  J13's rejection table are closed.
- **No second stat table per discipline.** DC1.
- **No simulation rebalance.** Do not tune `FightSimulation.gd` to "use"
  GRAPPLE. The attribute exists, is stored, trained, generated and displayed;
  what the fight does with it is its own stage with its own tests.
- **No layout redesign.** See 5.
- **No `HANDOFF.md`.** Claude writes your block.

## Gate

```
python Godot/tools/check_scripts.py <every .gd you touched>
```

Then the tests of each system you touched, then the full suite once in the
background before the commit. Every file in `Godot/tests/` must exit 0.

## The one trap

**`STAT_KEYS` is not the only place that knows there are six.** Panels with six
hardcoded rows, a save migration defaulting six keys, a JSON with six entries,
a test asserting a six-way average, a creation screen with six sliders — each
will keep working silently while disagreeing with the others, and the failure
shows up as a rating that differs depending on which screen you asked. **Grep
for the stat names themselves** (`fight_iq`, `conditioning`) as well as for
`STAT_KEYS`, and report the full site count in the digest. Finding twelve sites
when you expected four is the correct outcome of this task, not a problem
with it.
