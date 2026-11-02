# R68 — THE BELT HAS A PROMOTION (Claude, 2026-09-08)

Operator decision off R67's recovered mail. Two problems that turn out to be
one: the CHAMPIONS read paid for all 57 belts to draw eight, and a belt had no
promotion to scope it by.

## 1. A belt is sanctioned by a promotion now

`WorldPopulation.promotions_by_standing()` orders every promotion in the world
**tier, then reputation, then id** — total and deterministic, so the same world
always answers the same. Tier before reputation because the tier is the
standing and the reputation only orders inside it.

`sanctioning_organization_id()` gives a discipline's belts to the
highest-standing promotion that actually runs it. **Derived, never authored:**
the organizations table already carries `disciplines` (real catalogue entries)
and `discipline_weights` (generated markets), and `organization_disciplines()`
reads a weight above zero as the same statement in the other vocabulary. No
second catalogue was created, so there is none to drift.

The stamp is written ONCE and never overwritten — the way R39's sanctioning
stamp is — because a later catalogue bump must not move a belt from one
promotion to another underneath a running career. It runs on seed and by
migration, so existing saves get it on load.

**A discipline no promotion in this world runs stamps `""`.** That is a
recorded answer, not a failure: a world with kickboxing fighters and no
kickboxing promotion has an unsanctioned belt, and inventing a sanctioning body
would be a lie every screen downstream would repeat. The board gives that
bucket its own chip rather than hiding it or folding it into someone else's
name.

## 2. The read is scoped, and 250 ms became 13 ms

`get_championships_read(scope)` takes **one** `career.duplicate(true)` where it
took 58, and builds contenders only for the belts asked for. The isolation
guarantee the per-belt copies were paying for — a screen question must never
land C26's on-demand save migrations in the live Career — is kept by holding
one copy across the whole read.

Measured on a fresh career, 53 belts, three passes each:

| | |
|---|---|
| pre-R68 (one copy per belt) | **250 ms** |
| R68, unscoped | 33 ms |
| **R68, the scope the board actually asks for** | **13 ms** |
| the eight singular calls it replaced | 4 ms |

Cursor's 520 ms was a deeper seeded save, where each `career.duplicate(true)`
costs more; the shape is the same and the ~0.5 s CHAMPIONS press is gone.
`get_championship_read()` (single belt) went from two copies to one in the same
pass.

**Every belt ROW still comes back whatever the scope.** The chips above the
board are built from them, and a board that could not see the belts it is not
showing could not offer to show them. Only contenders are scoped, and a row
whose contenders were not built says `contenders_loaded: false` rather than
presenting an empty division — an empty `contenders` array meant both "nobody
is ranked here" and "you did not ask for this one", and a screen could not tell
them apart. `build_many` takes an explicit `scoped` flag because a scope that
matches no belt leaves the same empty dictionary as asking for everything.

## 3. The board opens on the promotion you have heard of

Two strips, coarse above fine: **PROMOTION** (most popular first) then
**DISCIPLINE** (the belts that promotion sanctions), then the eight weight
rows. Rank 1 is the default, so the board opens on a title the player knows
instead of on whatever the key order happened to put first. Changing promotion
clears the discipline — keeping one the new promotion does not sanction would
draw eight empty skeletons.

The promotion strip is drawn only when there is more than one promotion to
offer, and a single-promotion world keeps the discipline strip exactly where it
has always been. The board superlative line moves down by the strip's real
height; the eight belt rows never move.

## 4. G15 finally accepts the engine's own word

`BeltLineage.reign()` was briefed `title_status "held"`; the engine writes
`"champion"` (`WorldPopulation.gd:11`) and `ChampionshipRead` passes it
through, so **every real champion came back state `unknown`**. Both U5
implementations independently translated at the call site. One line in the
module accepts both words now, and `RankingsHubPanel._lineage_row()` — the
workaround — is deleted. `belt_lineage_test` asserts the engine's word reads
the reign with nothing marked unknown.

## Verification

Parse gate 9/9. `championship_read_test` **14 checks** (was 8),
`rankings_hub_panel_test` **95** (was 88), `belt_lineage_test` 0 failures.
The new assertions are independent: the test re-derives a belt's promotion from
the organizations table itself rather than calling the module it is checking,
so agreement is evidence and not a tautology. One of them covers the path every
EXISTING save takes rather than the seed: the `organization_id` is stripped from
every belt, `ensure_championships()` re-stamps them on load, and the test
asserts the same answer came back with no belt otherwise moved - the migration
is a label, never a result. Full suite run once before the commit.
