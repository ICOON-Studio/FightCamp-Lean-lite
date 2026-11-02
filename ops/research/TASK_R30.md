# TASK R30 — CLAUDE — THE RANKINGS HUB

Model: Opus, high effort, Fast off (new system + GameState-adjacent panel).

## Spec

The ninth legacy replacement. Kalli K15 ruled RANKINGS earns its own rail
item (`TASK_K15.md`, `K15_DIGEST.md`) — the route already existed
(`SceneRouter.ROUTES["rankings"]`) but `ManagementChrome.NAV_ITEMS` never
listed it, a bug, not a verdict. Codex C13 (`d2c4f98`) closed every gap
K15 named (`is_ours`, `movement`, `get_focused_division`), so this is a
straight build: no further GameState work needed.

Three tabs: **THE DIVISION** (default open, the focused fighter's own
discipline × weight × sex — sex LOCKED, never a picker), **P4P**
(cross-division, one sex at a time) and **CHAMPIONS** (every belt this
world has earned, holder or an honest VACANT).

Reads only: `get_division_rankings`, `get_p4p_rankings`,
`get_championships`, `get_focused_division`, `get_champion_superfight_offers`
(all read-only, `GameState.gd:9251-9394`). The only reading the panel adds
itself is `vs_ours` (AHEAD/BEHIND/OUR) — a comparison against the gym's own
best-placed fighter in the same list, computed client-side like
ScoutingHubPanel's `_gap_for`.

Seam: ranked is not available. Every row press — OUR or WORLD — opens the
same read-only `fighter_card` route (`get_fighter_card()` already resolves
both roster and world ids). CHAMPIONS is select-then-act: choosing a belt
row never navigates by itself, `OPEN HOLDER` is the board's one gold
action (K15's board list), same as `FIND OURS` is on the other two boards.

## Owned files

- New: `Godot/scripts/RankingsHubPanel.gd`, `Godot/tests/rankings_hub_panel_test.gd`
- Edited: `Godot/scripts/UIKit.gd` (new factories `ranking_row`,
  `ladder_scope`, `belt_holder_row`, `empty_gym_ranked`), `Godot/scripts/SceneRouter.gd`
  (`rankings` route gets a `panel`), `Godot/scripts/CareerRoot.gd` (HOSTED
  fallback), `Godot/scripts/ManagementChrome.gd` (NAV_ITEMS + DIRECT_SCENES),
  `Godot/assets/data/ui_kit_manifest.json` (new "rankings" family),
  `Godot/tests/scene_router_test.gd` (the stale "rankings has no panel"
  assertion), `Godot/tools/CaptureArenaStylePreviews.gd` and
  `Godot/tools/text_overflow_audit.gd` (dropped `RankingsBoard.tscn`
  references).
- Deleted: `Godot/scripts/RankingsBoard.gd` (468 lines), its scene,
  `Godot/tests/rankings_board_test.gd`.

## Parse gate

`python Godot/tools/check_scripts.py Godot/scripts/RankingsHubPanel.gd Godot/scripts/UIKit.gd Godot/scripts/SceneRouter.gd Godot/scripts/CareerRoot.gd Godot/scripts/ManagementChrome.gd Godot/tests/rankings_hub_panel_test.gd Godot/tests/scene_router_test.gd`

## Test command

`Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/rankings_hub_panel_test.gd`

Then the full suite once, including `tests/ui_kit_book_test.gd` (needs
`tools/render_kit.gd` re-run, windowed, to produce the four new factories'
renders) and `tests/scene_router_test.gd` (repointed).
