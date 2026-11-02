# TASK GLOBE1 (S223) - pick the country on a spinning 3D globe (New Career step 1)

Model: cloud Cursor (label `cursor`), composer default. Branch cursor/issue-<n>; never master. Read `.github/CLOUD_AGENT.md` first.
Approved: operator Q-S221-3 "Approve, build it" on `research/LUDO_ROUND61_VERDICT_S223.md` part A (read it; Ludo's full spec
is `research/LUDO_ROUND61_REPLY_S223.txt` PART A). Operator note verbatim: "ask ludo to use a 3d rotating globe to pick a country".

## What exists
- `Godot/scripts/CreationFlowPanel.gd` (798 lines) builds the New Career steps; `_build_country()` at ~232 draws the list of market
  cards (`_cards(_sorted(_markets), "market", 116.0)`, `UIKit.market_card`), the sort strip and the CHOOSE MARKET action
  (`_on_choose_market`). `_markets` rows carry country, economy, talent_depth, combat_popularity, city_count, gym_count.
  Every country in the world is a market (the list is long). Keep `_on_select` / `_on_choose_market` as the ONLY way a choice is made.
- The 3D gym backdrop behind the New Career screens (S222 MENUBG1) - the globe sits in front of it.

## Do
1. New `Godot/scripts/creation/GlobePicker.gd` (+ a small shader file) - a SubViewport 3D scene: one sphere (64x64), an
   equirectangular map texture in our palette (sea #141619 with 15-degree grid lines #22262C, land #2A2B30, borders #3A3E48), the
   picked country filled gold #E5B842 with a glowing edge, an amber rim glow, a brass pin with a red head (#C62F2A) on the picked
   country's centre. Idle spin slow (one turn per ~90 s); drag rotates with inertia (decay 0.92/frame); wheel zooms FOV 35-60.
2. Picking: ray -> sphere hit -> lat/lon -> sample a hidden COUNTRY ID image (each country a unique colour) -> country name ->
   the same `_on_select` the cards use. Small countries (a few pixels): also clickable by a pin/marker within 12 px of the cursor.
3. Data: Natural Earth admin-0 countries (public domain, naturalearthdata.com - ship it; put the licence line in
   `Godot/assets/data/LICENCES.md` or the existing licence file). Bake the two textures (look map + ID map, <= 2048x1024 each,
   PNG) with a script under `Godot/tools/` and commit the PNGs + the id->country JSON. Map Natural Earth names to OUR market
   names (`_markets[].country`); report any market with no match.
4. Layout at 1920x1080: globe left/centre; the right 480 px panel = the picked market's numbers (the ones `_build_country`
   shows today) + CHOOSE MARKET. A search box top-left (type -> the globe turns to that country in ~450 ms, cubic ease-out;
   Enter selects) is the keyboard path. Keep the A-Z / number sorts as a collapsible list under the search box.
5. New switch `globe_picker` in `GameSwitches.GAME_ON` (ships ON, read via `GameSwitches.on()`); OFF = today's card list
   unchanged (plain `--script` tests are the OFF arm).
6. Prefab check FIRST: search the Godot Asset Library and GitHub for a licensed Godot 4 globe/country picker; use it if it fits
   and name its licence in the PR; Ludo named "Godot-Globe-3D (MIT)" - not verified, check it exists.

## Gate
- Parse: `python Godot/tools/check_scripts.py <every touched .gd>`.
- New test `Godot/tests/globe_picker_test.gd`: lat/lon math round-trips (0,0), (51.5,-0.1) London, (-33.9,151.2) Sydney,
  (64.1,-21.9) Reykjavik, (-41.3,174.8) Wellington; ID lookup returns United Kingdom / Australia / Iceland / New Zealand for those;
  a pick routes to the same selected market as a card click; OFF arm = the card list builds as before.
- Existing: `python Godot/tools/run_tests.py --jobs 2 --only creation,new_career`.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md, screen form)
1. A still of today's country step first (RED: the long card list).
2. Stills of the globe step at 1920x1080 and 1280x720 from the game's own flow (`-- as_game`), idle and with a country picked.
3. Report per still: overlaps, clipped text, the globe's size/position, what the player reads.
4. Do not call it accepted. Claude opens every still; the operator closes it.

## Prior research
LUDO_ROUND61_REPLY_S223.txt part A; M_HUD2_MARIA.md 8.1 (gym creation step look); S184_TIPS_AUDIT2.md (country card tooltips).

## What would a human do?
Football Manager / Motorsport Manager style: a tactile globe that is a nicer way in, with search and a plain list always one click
away - never the only path.

## Prefab check
See Do 6. Natural Earth (public domain) for the shapes.

## The one trap
The picked country must be the SAME market row the cards select (names differ between Natural Earth and our data - e.g. "United
States of America" vs ours): build an explicit name map and test it; never pick by the Natural Earth label alone.
