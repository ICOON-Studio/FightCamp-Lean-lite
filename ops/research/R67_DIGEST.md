# R67 — THE BACKLOG NOBODY WROTE UP (Claude, 2026-09-08)

Five holes `triage` and the board found, all of them finished-or-broken work
that nobody had been told to look at. No new feature.

## 1. Eleven tasks written up

C30, C32, C33, C40, C43, K18, R47–R51 all had a pushed digest and no HANDOFF
block, so `status_of()` printed `COMPLETE?`. Eleven blocks written from the
digests, then `sweep`: 48 finished blocks moved to `HANDOFF_ARCHIVE.md` and the
Active claims slice came down to 889 lines. Every one now reads `COMPLETE`.

`triage` had only ever named K18, because its orphan check is a substring test
against the whole slice and the other ten are *mentioned* somewhere in it. The
board's `COMPLETE?` is the sharper signal of the two.

## 2. Three stranded reports recovered

Cursor wrote them to its own branch, so `inbox` could not see them. Recovered
onto master and acked. **They were not duplicates**, and two carried findings
nobody had acted on — both recorded in HANDOFF `## Direction notes`:

- `get_championships_read()` is **4x slower** than the eight singular calls it
  replaced (520 ms vs 129 ms, reproduced three times): it builds contenders for
  all 57 world belts when the board draws 8. Master took the read and it was not
  reverted. **Live regression, operator's call.**
- `BeltLineage.reign()` (G15) was briefed `title_status "held"`; the engine
  writes `"champion"`, so every real champion returns state `unknown`. Both U5
  implementations worked around it at the call site.

The `u5-belt-board-one-read-dbdf` branch also held **two defect fixes still live
on master**, now landed: a champion with zero defences was printing a defence
date (the engine stamps `last_defended_week` with the week the belt was WON —
`WorldPopulation.gd:1294-1298` — so every newly crowned champion read
"0 DEFENCES · LAST DEFENDED WEEK 68"), and a vacated belt could take a board
superlative (`_vacate_on_the_scale()` keeps `since_week`, `:1193`, so G15's
`board()` still ranks a belt nobody holds). The count is the fact now, not the
date; a superlative may only name a belt that is actually standing.
`rankings_hub_panel_test` **82 → 88 checks, 0 failures.**

The other branches are ruled on in the Direction note. None is deleted here.

## 3. The vacuous gate closed — 82 task files

`done --task` returned 0 for any task file with no `## Owned files` section: it
found nothing to check, printed "nothing to gate", and passed. **89 of 166
files**, more than half the corpus. Three changes:

- `done` refuses a file that declares no ownership. Silence is not a pass.
- The parser reads prose, not only "``- `path` ``" bullets — 12 files declared
  ownership it could not see. It pairs backticks *first* (the old lazy pattern
  started at a closing backtick and ran into the prose after it, which is how
  C5 came to "own" a file that was never written), binds an exclusion to a whole
  bullet or sentence rather than a line, and `resolve_owned` now understands a
  project-relative `tests/foo.gd`.
- 82 files backfilled, every path from that file's own parse-gate command, test
  command, build sections or shipped deliverables. Two needed a ruling and carry
  it in the file: **U1 was cancelled unbuilt** (J12 answered it) and **J9 was
  superseded** before John started (Codex delivered it as C31).

**166 of 166 task files gate now, and every declared `.gd` resolves.**

## 4. `BOXING_MIN_ROUND_SCORE`, reported three times and never assigned

`fight_simulation_test.gd:631` read a constant R38 deleted when it moved the
boxing knockdown floor into the ruleset. The test exited 0 and printed
"233 checks, 0 failures" while emitting a SCRIPT ERROR, so it looked green and
failed the strict runner. C33, C40 and C45 each reported it.

The line now reads the floor where the rule lives —
`state["scoring_profile"]["min_round_score"]`, boxing's own `7`. The assertion
runs for the first time: **234 checks, 0 failures, no script error.**

## 5. R66 retrofitted onto ArenaFit, and the two ring figures reconciled

R66 section 4 published its ring footprints as hand arithmetic, one stage before
G20 built the module that does exactly that arithmetic. `arena_fit_test.gd` now
computes the whole table through `ArenaFit.fits()`, so a row that changes fails
a test.

**11.88 m and 10.68 m were never in conflict — same formula, different ring.**
10.68 m is the 16 ft ABC floor (`club_ring`: canvas 4.88 + 0.46 apron each side
= 5.80 platform, + 2.44 ringside each side). The test's case is the 20 ft ABC
ceiling, whose 7.02 m platform rounded to 7 m gives 11.88 and unrounded 11.90.
Nothing said which ring each belonged to; both are asserted side by side now in
`_r66_ring_footprints()`, with the four platform sizes, the four depth verdicts,
and the fact that a sanctioned venue is refused by the fixed 7.5 m depth — short
by 3.18 m, which no legal cell size closes.

`arena_fit_test` **0 failures.**

## Verification

Parse gate 4/4. `arena_fit_test` 0 failures, `fight_simulation_test` 234/0,
`rankings_hub_panel_test` 88/0. Full suite run once in the background before the
commit. `done --task` sampled across C16, R30, R48, R62, U10, Q8, G20, C5 — all
GATE PASS, and all eight had been passing on nothing before this.
