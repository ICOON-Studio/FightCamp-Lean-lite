# R71 — THE HONOURS READ

`GameState.get_athlete_honours(athlete_id) -> Array` is the seam between R70's
record and the screen. Before it, `get_retired_championships()` had exactly one
reference in the codebase — its own definition — so a fighter who really held
the judo world title for forty weeks had an invisible career.

## What shipped

- `Godot/scripts/GameState.gd:10620` — `get_athlete_honours()`. **It reached
  master inside Codex's C51 commit `4008551`, not its own:** C51 was in flight
  in this shared checkout and `git add -- Godot/scripts/GameState.gd` took the
  whole file, R71's hunk included. The code is byte-identical to what was
  written and tested here; only the authorship of the commit is wrong. It
  gathers
  `get_championships()` and `get_retired_championships()`, hands both to
  `TitleHonours.rows()` (G22) with the career week, and returns
  `.duplicate(true)`. No composition, no ordering and no labels live here.
- `Godot/tests/athlete_honours_test.gd` — 18 checks, written from the R71/G22
  contract rather than from either implementation.
- `Godot/scripts/TitleHonours.gd` + `Godot/tests/title_honours_test.gd` are
  G22's (Grok), landed as 4629c06 and spliced unchanged: Grok's module and
  Claude's unseen test agreed on the contract first time, so nothing needed
  fixing on either side.

## The two guarantees the seam owns

**One isolated copy.** The championship accessors under this read perform save
migration on demand — key re-keying, status backfill, the promotion stamp — and
`get_championships()` also ticks the double-champ windows. Asking what a fighter
has won must never land those maintenance writes in the live Career, so the read
takes the `get_championships_read()` discipline: one `career.duplicate(true)`
held across both gathers, restored before the return. One copy, not two.

The test proves it the hard way rather than by inspection: the fixture seeds its
belts with **no** `organization_id`, and after the read the live belt still has
none — the promotion stamp was spent on the copy.

**A retired title never re-enters the standings.** `championships` is the only
table booking, settlement, interim and double-champ paths consult, and R70's
board chips are built from its keys, so a retired key appearing there — even
transiently inside the isolated copy — would put a corrected-away discipline
back on the board and make its title defendable again. This function is the one
place that reads both tables, so the test asserts the standings gained no
retired key and that `booking_is_for_the_belt()` still answers no for the judo
division after the honours have been read.

## What the read will not say

`weeks_held` is 0 and `weeks_held_source` is `"absent"` on every retired row.
R70 deliberately stamped no retirement week — a catalogue correction is not
something that happened in the world on a date — so the game does not know when
that reign ended, and `current_week - since_week` would silently invent a reign
that ran until today. The test also scans every string on every retired row for
BEATEN, LOST, STRIPPED and VACATED: these titles came off the board by a rules
correction, not by anybody's defeat.

## Fixture note for whoever writes the next GameState-level championship test

`simulation_world.championships` is seeded **lazily on the first read**. A save
straight out of `finalize_new_career()` has no `championships` key at all, so
`world.get("championships", {})` hands back a throwaway and every row written
into it is discarded. Call `get_championships()` once to force the seed, then
take `world["championships"]`. This cost one debugging cycle here.

## Tests

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/athlete_honours_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/title_honours_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/championship_read_test.gd
```

R71 18/0, G22 102/0, C26 30/0.

## What is still not drawn

U13 draws these rows on the FIGHTER PROFILE's Development tab, driving the gold
chip from `TitleHonours.summary().chip` instead of counting `get_athlete_titles()`
at `DevelopmentPanel.gd:405-407`. Until it lands, the honours record is readable
and still unprinted.
