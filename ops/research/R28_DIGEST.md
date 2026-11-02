# R28 DIGEST — CAREER CREATION (the tenth legacy replacement)

Task file `TASK_R28.md`. Kalli K13's ONE FLOW WITH STEPS, on Codex C14's
pre-career reads (`02ce4cb`). Ships after C15 landed (`b433ced`); nothing
in this stage touches the ring.

## What shipped

- **`CreationChrome`** — the THIRD chrome family (`CreationChrome.gd`,
  `UIKit.creation_chrome`): brand + a 1/2/3 step strip + BACK + the
  committed trail + body. No rail, no Continue, no set-piece gear. Built
  ONCE by the root and re-lettered per step, the way BootChrome is.
  Shares the mark, the ground and the brand geometry with BootChrome so
  NEW CAREER walks out of the gate into step 1 as the same house.
- **`CreationRoot`** (`CreationRoot.tscn` + `.gd`) — one host, three
  steps, body swap only. It owns the committed choices (they have to
  outlive a body swap) and exactly ONE write: the `finalize_new_career()`
  the player asks for with OPEN GYM. It arms nothing — `begin_new_career`
  stays the boot's — and refuses to finish with no armed slot.
- **`CreationFlowPanel`** — the three boards. COUNTRY (economy / talent
  depth / combat popularity per market, sortable A-Z / economy / talent /
  combat, never filtered), CITY (rival gyms, promotions, booked events),
  GYM (name field + the starter take). Selecting is NOT committing: only
  the board's one gold commits, which is what makes BACK safe.
- **Kit family "creation"**, 7 factories / 13 variants: `creation_chrome`,
  `step_strip`, `committed_trail`, `market_card`, `city_intel`,
  `starter_take`, `creation_seam`. Book now 261 variants across 21
  families. `starter_take` reuses `floor_grid` through a private adapter
  (`_creation_floor_view`) - K13's "floor_grid cousin" - because the save's
  floor and the gym hub's view of one are different shapes.
- **The seam**, K7 inverted: CreationChrome fold 180 -> shutter 220 ->
  ShellChrome lock 240 -> settle 140 = 780 ms. `creation_seam` draws the
  shell ARRIVING (rail column in from the left, top band landing) where
  `phase_shutter` draws it leaving. Green CONTINUE is never drawn in this
  family at all.

## The hard rule, proved

`creation_root_test.gd` presses OPEN GYM for real and compares the saved
career against `get_creation_gym_take()` for the same name: same floor
width and item count, same roster names in order, same used space. The
preview is keyed on the typed name and calls the same generator
`finalize_new_career` does, so what is on screen is what is saved.

## Deleted (discarded, not migrated)

`CountryMap.gd` (252) + scene, `CityScreen.gd` (404) + scene, `GymHub.gd`
(156) + scene. The three route ids are unchanged - `country_map`, `city`,
`gym_pick` now carry a `step` and name `CreationRoot.tscn` - so every call
site (the boot's NEW CAREER seam included) keeps working. `SceneRouter`
gained a creation-tier in-place branch (`show_step`) beside the boot's.
Repointed: `smoke_test` (scene list + the populated-world check, now on the
C14 reads through a mounted flow), `world_management_ui_test` (the three
legacy sections rewritten against the C14 reads plus a real finalize),
`text_overflow_audit`, and the two legacy capture tools dropped their dead
frames.

## Two kit fixes found by looking at the renders

- `UIKit.button` had no **disabled** face: the engine fell back to the
  project theme and drew an illegal gold action as unstyled ghost text.
  It now draws a dimmed body with DIM text, everywhere in the game.
- `creation_depth_line()` - "1 CITY", not "1 CITIES". The first decision
  in the game is not the place to print machine grammar.

## Verification

- Parse gate: 9/9 files, 0 fails.
- `creation_root_test.gd`: 50 checks, 0 failures.
- Repointed neighbours: `scene_router_test` 204/204, `boot_root_test`
  26/26, `boot_panels_test` 44/44, `world_management_ui_test` 21/21,
  `ui_kit_book_test` 0 failures.
- Full suite (125 tests, once, before the commit): all green. The single
  red in that run was this stage's own `creation_depth_line` missing from
  the book's `helpers` list - declared, re-run, 0 failures.

## Pictures

`DesignLibrary/screens/creation/` - `country_empty`, `country`, `city`,
`gym`, `gym_unnamed` - rendered by `Godot/tools/render_creation.gd`
(windowed). Kit renders for the 13 new variants are in
`DesignLibrary/kit/renders/`.

## Not done here

No render of the seam mid-flight (it is a tween, not a board). The market
board is 175 cards long because every country in the world is a market;
sorting is in, filtering deliberately is not - a market the player came
looking for must never be missing because a chip is lit.
