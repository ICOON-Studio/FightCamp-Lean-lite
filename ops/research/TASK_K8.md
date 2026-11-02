# TASK K8 — KALLI — the GYM hub study

Model: medium.
Self-contained. Read this file and nothing else. No code ships from this
task: the deliverable is a study, the same shape as K7. START WHENEVER
YOU HAVE CREDITS — not gated on a date.

## Why this exists

User decision 2026-09-05: every pre-kit screen is thrown away and rebuilt
from the UI kit, one hub at a time. The only approved previews are the
R18 fighter profile — `DesignLibrary/screens/profile_revamp/` (nine PNGs
plus `sheet.png`). That is the bar; look at them first. The first hub to
be rebuilt is the GYM. It replaces two legacy screens at once: FIGHTERS
(`RosterScreen`, the roster list) and MY GYM (`GymFloor`, the equipment
floor with its store). Look at those two only for the data they show;
their look is the thing being replaced.

## What the GYM hub is

A SCREEN inside the persistent shell (rail left, top bar with the day
strip and CONTINUE above; the content position comes from `ShellChrome`,
the frame you used in K4-K6). The GYM is the home the player returns to
every day: who is in the building, what state they are in, what needs a
decision, and the floor they train on.

Market reference, from the teardowns you already have: Football Manager's
squad view (a dense sortable table, status glyphs, ONE flag per row) and
MMA Arena's roster. The GYM home is a squad screen, not a wall of
portrait cards; the profile is one click away and carries the depth.

## Boards (deliver all four, 1920x1080 each)

1. **ROSTER** — the home view. Every fighter on one row or tile:
   identity (name, age, sex, discipline, division), record, condition,
   morale, weight against the limit, this week's plan, the next bout
   (opponent, org, days out) and ONE flag from the profile's action-row
   set: medical hold / open ask / weight / contract / loyalty / empty
   book / training blocked. Sort and filter (state, division, next bout).
   Selecting a fighter opens the R18 profile, which exists: show only the
   selected state.
2. **FLOOR** — the equipment floor as a picture: stations on the grid,
   condition and repair, who trains where this week, space used against
   capacity, expansion. One piece selected: its detail with REPAIR /
   ROTATE / MOVE.
3. **STORE** — buying equipment: category filters, price, footprint,
   affordable or why not. A drawer or a tab off the FLOOR, your call, but
   never a separate screen.
4. **STATES** — day one (one fighter, an empty floor), a fighter on
   medical hold, a fighter in fight week, the floor full. A contact sheet
   is fine for this board.

Answer in the digest: is the GYM one rail item (replacing MY GYM and
FIGHTERS) with ROSTER / FLOOR tabs, or do both rail items stay and land
on the hub's two tabs? Recommend one; Claude decides in R21.

## Data that exists (draw only from this; nothing is invented)

Per fighter, all through GameState and all already read by the profile:
identity, record (W-L-D and KO / SUB / DEC), condition and morale 0-100,
injury or medical hold with weeks left, weight and the class limit,
loyalty and contract weeks, open asks, the booked bout, the camp, this
week's training plan. Gym: name, city, tier, fame, money, week and day.
Floor: the grid, capacity, used space, expansion cost, equipment
instances with condition, repair cost, footprint and rotation; the store
catalog with prices and footprints. Staff: coaches with roles.

## Kit rulings (obey; the book is `DesignLibrary/kit/index.html`, 117 variants)

Bebas Neue display, IBM Plex Mono elsewhere; SIZE_MIN 12; gold x1 per
screen; green is CONTINUE only; pair blocks slate, never the gym header
colour; one figure per screen, silhouettes only; the facility is a GYM,
never a camp; age in the header. Use the profile's instruments where they
fit (`attribute_row`, `form_pips`, `rating_disc`, `split_bar`,
`alert_strip`, `tab_bar`, `modal`). Name every instrument the hub needs
that the book lacks: that list is the kit gap Claude builds first.

## Deliver

`research/GYM_HUB_K8.html` (the study), `GYM_K8_roster.png`,
`GYM_K8_floor.png`, `GYM_K8_store.png`, `GYM_K8_states.png`, and
`K8_DIGEST.md` (short: the rail answer, the kit gaps, the files). Write
them into the tree; Claude commits them. Then convert your block in
`HANDOFF.md` to COMPLETE (max 8 lines). Touch no `.gd`, `.tscn`, the kit
or the profile.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/GYM_HUB_K8.html
research/K8_DIGEST.md
```
