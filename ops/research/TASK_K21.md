# TASK K21 — THE FIGHT CAMP, HOW IT READS (Kalli)

Model: top tier, effort high, Fast off.

Study only. **No `.gd`, no `.tscn`.** Deliverables go in `research/`.
Kalli pushes only its own research files and **never edits `HANDOFF.md`** —
Claude writes your block.

## Why this exists

`FightCampPanel.gd` (536 lines) is the **last file in the game minting its own
palette** — R33 killed the other one. But the worse fact is that **FIGHT CAMP
is unreachable**: the panel is mounted by nothing (it hung off
`AthleteProfileScreen`, which R23 deleted), and the profile's CAMP tab has a
`START A CAMP` button that calls a method which only sets a meta and returns.

So a whole shipped system has no way in: the focus track, the protocol, a
sparring partner in a role matched to the opponent, a visiting coach on an
earned specialist slot, film study that unlocks a counter at depth 3, the
weight-cut diet plan, a projection that is computed by the same maths that will
be applied, and a report card graded at settlement. The weekly pass has been
running camps nobody can start.

R34 rebuilds it and gives it a route. You rule how it reads.

## What the surface has to hold

Three states in one system, and they are not equally weighted.

1. **SETUP** — the decision. Five or six picks (focus track, protocol, partner
   role + partner, visiting coach, counter, cut plan) against a **PROJECTION**
   that re-computes on every pick: edges, tightness, fatigue on the night,
   injury risk, film depth, cost, Fight IQ. C20 (`TASK_C20.md`, Codex, in
   flight) is adding `deltas` — what the LAST pick changed, each with a tone —
   so the screen can show the consequence of a choice, not just its result.
2. **PROGRESS** — the camp running. A week log, the shape built so far, the
   film at its current depth, the body, the counter pick once film reaches
   depth 3, and pulling out.
3. **REPORT** — the fight-day card. A grade, projected against built, injuries,
   cost.

## The questions your boards must answer

1. **Where does SETUP live?** Today the CAMP tab is a read-only summary inside
   the fighter's profile and the real surface is orphaned. Is SETUP a full
   profile tab, a drill-in off that tab, or a set-piece over it the way R33's
   BOUT AGREEMENT is? Rule it and say what is lost the other way. Note the
   shape of the decision: a camp is committed once, weeks ahead, and then runs
   — that is closer to booking than to a weekly board.
2. **How does a projection read BEFORE you commit to it?** This is the heart of
   the stage. Seven or eight figures move on every pick. Do they read as a
   before/after pair, a delta column, a single moving block, something else?
   Name the instrument, and rule how a tone (good / warn / bad / flat) shows
   without becoming a wall of arrows. **Injury risk is not the same kind of
   number as an edge** — say whether it gets its own treatment.
3. **The partner and the coach are people, not options.** Partners come in
   roles matched to the opponent (roster fighters free — they lose their own
   week — world fighters for a fee); coaches occupy earned specialist slots.
   How do a person-choice and a setting-choice sit on the same board without
   the people becoming a dropdown?
4. **What does the week log look like?** PROGRESS is the state the player will
   see most often, once per week for several weeks. Rule what a week row says
   and what it does not.
5. **The report card.** Projected against built, with a grade. How does that
   read as a verdict on the player's own decisions rather than a receipt?

## Deliverables

- `research/CAMP_K21.html` — boards at 1920×1080, plus the PNGs.
- `research/K21_DIGEST.md` — same shape as `K20_DIGEST.md`: pick +
  rejects with what is lost, priority order, gold ×1 per board, KEEP vs
  REPLACE against what exists, kit gaps named as instruments, reads relied on,
  blockers.

Suggested boards: **SETUP** (the picks and the projection), **THE PROJECTION**
(the instrument on its own, in two or three states), **PROGRESS** (the week
log mid-camp), **REPORT** (the grade), and **THE SEAM** (how the profile's CAMP
tab reaches it and comes back).

## Rules that bind

Kit rulings from K16 / K19 / K20 still hold: Bebas / Plex, SIZE_MIN 12, **gold
exactly once per board**, green is the way out only, a pair block is a slate,
silhouettes never portraits. **The facility is a GYM** — a fight camp is the
preparation for a named opponent, and the word never refers to the building.
Females never fight males. **Invent no numbers**: every figure on a board comes
from `FightCamp.gd`, `WeightCut.gd`, the existing camp reads or C20. R33 has
just shipped THE BOOKING family in the kit — reuse `verdict_chip`,
`reason_chip`, `counter_strip` and friends where they fit rather than minting a
near-duplicate.

## Reads

`Godot/scripts/FightCampPanel.gd` (the surface being replaced — note its three
states, and that its palette at `:24-32` is what R34 is deleting),
`Godot/scripts/FightCamp.gd` (374 lines — `focus_tracks` `75`, `protocols`
`83`, `partner_roles` `91`, `counters` `99`, `slots_for_gym` `108`,
`weeks_available` `120`, `injury_chance` `141`, `week_effects` `176`,
`projection` `224`, `edge_lines` `266`, `film_report` `286`, `grade` `358`),
`Godot/scripts/WeightCut.gd` (248 lines — `diet_plan` `98`, `status` `134`,
`projection` `223`), `Godot/assets/data/fight_camp.json`,
`research/TASK_C20.md` (the API shape you are ruling on),
`K20_DIGEST.md` and `research/R33_DIGEST.md` (the kit family just added).
Do not read `GameState.gd` whole; if you need the options shape, take
`sed -n '797,850p' Godot/scripts/GameState.gd`.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/CAMP_K21.html
research/K21_DIGEST.md
```
