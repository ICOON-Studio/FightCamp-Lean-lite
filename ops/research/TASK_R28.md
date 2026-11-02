# TASK R28 — CLAUDE — CAREER CREATION

Model: Opus, high effort, Fast off (new chrome family + a new root scene,
same tier as R20/R29's spine work).

## Spec

The tenth legacy replacement, and the first BEFORE a career exists (no
rail, no ShellChrome). Kalli K13 ruled ONE FLOW WITH STEPS
(`research/TASK_K13.md`, `K13_DIGEST.md`, `CREATION_K13.html` +
five PNGs): a single `CreationFlow` under its OWN `CreationChrome` -
COUNTRY -> CITY -> GYM, a committed trail so step 3 is never blind, gold
×1 is always the forward action. NOT the K7 set-piece frame (fight gear)
and NOT ShellChrome (rail + Continue are career-only) - a third chrome
family, matching how R29 justified `BootChrome` as a fourth.

Codex C14 (`02ce4cb`) delivers every read this needs, pre-career:
`get_creation_markets()` (economy / talent depth / combat popularity per
country), `get_creation_city_board(country_name)` (rivals, orgs, events -
via a throwaway `WorldPopulation`, no Career created), and
`get_creation_gym_take(country_name, city_name, gym_name)` (starter floor
+ roster silhouette, keyed by `gym_name` exactly as `finalize_new_career`
uses it, so the preview is the saved gym). All three are read-only; no
further Codex work is needed.

Writes are the existing API, unchanged: `begin_new_career(slot)`
(`GameState.gd:2515`), `finalize_new_career(country_name, city_name,
gym_name, starter_floor)` (`:2542`), `generate_starter_boxing_floor(seed_key)`
(`:2889`) for the actual floor handed to `finalize_new_career` (the
preview in `get_creation_gym_take` must call the same generator with the
same key so what the player saw is what gets saved).

## Shape (K13 sections A-D)

- **CreationChrome**: brand + a horizontal 1/2/3 step strip (done/current/
  ahead) + BACK + the committed trail (country -> city chips once chosen)
  + body. No rail, no Continue unit - those are ShellChrome's.
- **THE COUNTRY**: markets list from `get_creation_markets()` - economy,
  talent depth, combat popularity per country; gold CHOOSE MARKET. Leave
  out rivals/orgs/events/coaches/prospects - those are step 2+.
- **THE CITY**: `get_creation_city_board()` - rival gyms, organizations,
  world events for the chosen country; trail shows the committed country;
  gold ENTER CITY. Leave out full `get_world_coaches` / prospects
  (SCOUTING owns those after the save exists) and floor editing.
- **THE GYM**: name entry + `get_creation_gym_take()`'s starter floor
  tiles + roster silhouettes; gold OPEN GYM. Leave out store/repair/
  assign - GYM hub owns those from day one.
- **THE HANDOFF**: K13's seam, K7's language INVERTED - creation INSTALLS
  the shell where K7 REMOVES it. CreationChrome folds (180ms) -> shutter
  (220ms) -> ShellChrome locks on THE DAY (240ms) -> settle (140ms) =
  780ms total, matching K7's own shutter and K14's boot seam. Green
  CONTINUE is illegal until the shell actually locks.
- **STATES**: nothing chosen yet, a market with no detail, an empty/
  invalid gym name, backing out mid-flow.

## Owned files

- New: `Godot/scenes/CreationRoot.tscn` (or a script-only root if a scene
  file is not needed - follow `BootRoot`/`SetpieceRoot`'s precedent of
  ONE scene building the chrome once and swapping a board/step), the new
  `CreationChrome` build (likely `Godot/scripts/CreationChrome.gd` next to
  `ShellChrome.gd`/`SetpieceChrome` conventions), a new `CreationFlowPanel.gd`
  or similar owning the three step boards, and `Godot/tests/creation_root_test.gd`
  (or similarly named).
- Kit gaps K13 named (family "creation"): `creation_chrome`, `step_strip`,
  `committed_trail`, `market_card`, `city_intel`, `starter_take`,
  `creation_seam`. Reuse first: `pair` (slate), `badge`, `alert_strip`,
  `filter_strip`, `squad_row` rhythm, `capacity_meter`, a `floor_grid`
  cousin, `illegal_refusal`.
- `SceneRouter.ROUTES`: `country_map` / `city` / `gym_pick` currently point
  at `CountryMap.tscn` / `CityScreen.tscn` / `GymHub.tscn` (tier
  "creation", no `panel` key) - repoint to the new root the same way R20's
  spine did for tier "career", or mint a tier-1 hosting root if the
  existing pattern does not fit three sequential steps in one scene.
  `CareerRoot.gd`'s `HOSTED` fallback and `ManagementChrome` are NOT
  involved here (creation has no rail).
- Delete `Godot/scripts/CountryMap.gd` (252), `Godot/scripts/CityScreen.gd`
  (404), `Godot/scripts/GymHub.gd` (156) and their scenes/tests once the
  new flow replaces them - discarded, not migrated, same standing rule as
  every prior stage.

## Hard rules

- No screen here ever mounts K7's set-piece chrome or ShellChrome directly
  - CreationChrome is its own family until the handoff settle frame.
- The GYM step's preview must be provably the same gym the save gets:
  test it against a real `finalize_new_career` call the way C14's own
  test already proves the read matches, not just that the read runs.
- MainMenu is not this stage's problem - R29 already replaced it with
  BootRoot; NEW CAREER's landing route into this flow is the only seam.

## Parse gate / test command

Parse gate: run `check_scripts.py` on every new/edited `.gd` file before
any engine run. Test:
`Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/creation_root_test.gd`
(name to match whatever the actual test file ends up being called), then
the full suite once before the commit.
