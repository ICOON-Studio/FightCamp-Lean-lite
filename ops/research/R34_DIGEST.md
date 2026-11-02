# R34 — THE FIGHT CAMP (Claude, 2026-09-06)

The last file minting its own palette is gone, and the system it drew is
reachable for the first time since R23 deleted its host.

## What shipped

**`FightCampPanel.gd` rebuilt on the kit.** The nine private colours and the
raw `BEBAS`/`MONO` preloads at the old `:24-32` are deleted; every colour,
font, gauge, pair, frame, dial and empty state is `UITokens.gd` /
`UIKit.gd`. **No new kit instrument was added** — the camp week rail
(`UIKit.camp_week_rail`, already in the kit and unused by anything) now has
its screen, so `ui_kit_manifest.json` and the kit book are untouched and the
parity test still passes.

Three states, each rebuilt rather than restyled:

- **SETUP** — the six picks down one column (focus, protocol, the partner
  cast by ROLE first then by who can play it, the visiting coach, the film
  counter, the diet), THE SCALE TODAY on `weigh_bar`, and the PROJECTION
  dock: the figures as graded `pair` rows, injury risk in its own RISK band
  below them, **what that pick changed** against the pick before it, the
  shape it banks, and the diet lines.
- **PROGRESS** — the week rail in the head, a card per week with what that
  week actually did, CAMP SHAPE (built against projected), FILM STUDY on a
  depth gauge, BODY & FATIGUE on `gauge_bar` per region, the counter row and
  the way out.
- **REPORT** — a `grade_dial` docked the same quarter for injury that
  `FightCamp.grade()` docks, so the ring and the letter agree; the facts
  column; BUILT AGAINST THE PROJECTION edge by edge with a ratio bar each;
  and the injuries the camp took.
- The honest fourth board: **no bout booked** says what a camp is and what it
  needs, and never pretends to be a screen with nothing on it.

**The route, on K21's ruling.** `ProfileRevampPanel`'s CAMP tab stays a
read-only summary (the `profile_revamp_test` "CampState" gate is untouched)
and every decision lives in a booking-shaped SET-PIECE over it, the way R33
opens BOUT AGREEMENT: scrim, `UIKit.setpiece_chrome` (the band names the
fighter, the opponent and the weeks out; the one gold is START CAMP inside
the body), the camp surface in the `BodySlot`, and a way out that returns to
the tab. The button now works: `START A CAMP` on a booked bout, `OPEN THE
CAMP` on a live one, and only an unbooked fighter is still sent to the board.
`_want("camp")` is no longer a dead end.

**C20 spliced.** Codex's `get_camp_board(athlete_id, choices)` landed in the
tree mid-stage and the panel reads it: ONE read per rebuild, `board.state`
decides which state to draw, and the panel passes `_compare_against` so the
delta strip is Codex's own diff. `_board()` composes the identical shape from
the four old reads when `get_camp_board` is absent, so the panel works with
or without C20 and needed no edit when it arrived.

## What did not change

`FightCamp.gd`, `WeightCut.gd` and `GameState.gd` are untouched by this
commit. Starting still goes through `start_fight_camp()`, the counter through
`set_fight_camp_counter()` (still refused before film depth 3), leaving
through `end_fight_camp()`; the gym's specialist slots still gate the
visiting coach. No number on the screen is computed by the screen.

## Two notes back to Codex (C20) - both answered

1. **A camp the fighter walked out of read as a fresh SETUP** in the WIP the
   panel was first spliced against — `get_camp_board` routed on `camp.active`
   alone. **Codex fixed it in the committed C20 (`f1aa8fb`)**: `left` now
   routes to `progress`, so the shape that is still fading a quarter a week is
   shown as what it is. The panel's local override for that case is deleted.
2. **`progress.weeks` is the array of completed weeks and `total_weeks` is
   the count**, where every other camp read uses `weeks` as the count. Codex
   confirms this is deliberate (the row array is the required shape), so the
   panel normalises both in `_normalise_progress()` and reads `total_weeks`.

## K21 applied (it landed mid-stage, `e9625bc`)

Kalli's study arrived after the layout was built, so it was taken as a change
list rather than a rebuild:

- **SETUP is a set-piece over the profile CAMP seam**, not a tab mount. Done —
  see the route above. The first build mounted it in the tab body at the work
  tabs' altitude; that is gone.
- **Injury risk is its own RISK band and never an edge.** It left the
  projection's figure column for its own kicker, meter and dress.
- **Gold once per board.** SETUP: the projection frame went from gold to the
  gym colour and FIGHT IQ from a gold cell to a plain figure, so START CAMP is
  the one gold. REPORT: the BUILT frame went to the gym colour, leaving the
  grade mark as the only gold.
- **PULL OUT is slate, never loud** — it was a red `bad` button, it is now a
  standard one. It is a way out, not a verdict.
- **Green is CONTINUE only** — the CAMP tab's own action was a green `go`
  button; it is the gold `START CAMP` of K21's seam board now.
- **Not applied:** K21 also wants the report's PROJECTED VS BUILT pairs to
  cover tightness, film depth, Fight IQ and fatigue-on-the-night, not only the
  edges. `get_fight_camp_report()` exposes `projected_edges` but not the rest
  of the projection, and this stage invents no numbers and does not touch
  `GameState.gd`. It needs C20 (or a later stage) to widen the report payload.

## Gates

Parse gate on both scripts and the render tool: clean.
`fight_camp_panel_test` 0 failures (its node names are unchanged — nothing in
`Godot/tests/` was edited), plus `profile_revamp_test`, `fight_camp_test`,
`weight_cut_test`, `office_nav_and_profile_overlay_test`, `ui_kit_book_test`
and Codex's `camp_board_api_test` (35 checks) all green. Full suite green
before the commit.

## Renders

`Godot/tools/render_camp.gd` → `DesignLibrary/screens/camp/`:
`blocked.png`, `setup.png` (the picks pressed on the panel itself, so every
figure is the one the game would apply), `progress.png` (week 4 of 6),
`report.png`. Run WITHOUT `--headless`.

## Test it

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_camp_panel_test.gd
```
