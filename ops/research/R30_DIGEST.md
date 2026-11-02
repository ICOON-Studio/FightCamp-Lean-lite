# R30 DIGEST — THE RANKINGS HUB (Claude)

The ninth legacy replacement. ONE rail item **RANKINGS** is now a CareerRoot
panel built from the kit, on Kalli's K15 boards. `RankingsBoard.gd`
(468 lines), its scene and its test are DELETED.

## What shipped

- `Godot/scripts/RankingsHubPanel.gd` — three tabs. **THE DIVISION** opens
  by default on the focused fighter's own discipline × weight × sex; sex is
  LOCKED (females never fight males), so the `ladder_scope` header only
  ever steps weight and discipline, never a fourth free picker before a
  name. **P4P** is cross-division, one sex at a time. **CHAMPIONS** lists
  every belt in a discipline+sex scope, holder or an honest VACANT —
  selecting a belt row never navigates by itself, `OPEN HOLDER` is the
  board's one gold action, the same way `FIND OURS` is the one gold action
  on the other two boards.
- Reads **Codex C13** (`d2c4f98`) only: `get_division_rankings()`,
  `get_p4p_rankings()`, `get_championships()`, `get_focused_division()` and
  `get_champion_superfight_offers()`. No new GameState work was needed —
  every gap K15's study named (`is_ours`, `movement`, the focused-division
  helper) was already closed by C13. The only reading the panel adds itself
  is `vs_ours` (AHEAD/BEHIND/OUR), a comparison against the gym's own
  best-placed fighter in the same list, computed the way ScoutingHubPanel's
  `_gap_for` already does for the gym-gap compare.
- The seam: ranked is not available. Pressing any row — ours or a world
  fighter — opens the same read-only `fighter_card` route;
  `get_fighter_card()` already resolves both a roster id and a world one,
  so no new candidate-view mode was needed.
- Kit family **"rankings"**: `ranking_row` (the # / avatar / name / record /
  movement arrow / vs-ours chip, OUR fighters get a gold ring — the same
  visual language `portrait_chip`'s `ours` flag already uses), `ladder_scope`
  (the compact weight/discipline stepper, sex stated not picked),
  `belt_holder_row` (holder or VACANT, an optional superfight note) and
  `empty_gym_ranked` (the calm first-career strip). 4 factories / 8
  variants; book **248 across 20 families**. Kit book rendered
  (`Godot/tools/render_kit.gd`, windowed).
- Routing: `rankings` is now a panel route on CareerRoot (was its own bare
  scene); `ManagementChrome.NAV_ITEMS` gained the RANKINGS entry it had
  been missing (K15's finding: the route always existed, the rail forgot
  it), and `DIRECT_SCENES` points it at `CareerRoot.tscn` like every other
  hub.

## The sweep

`rankings_board_test.gd` is deleted with the screen it tested.
`scene_router_test.gd` had one stale assertion — "a route without a panel
is refused" used to demonstrate that with `rankings`; every career-tier
route now has a panel, so the example moved to `country_map` (creation
tier, its own scene). `CaptureArenaStylePreviews.gd` and
`text_overflow_audit.gd` dropped their `RankingsBoard.tscn` references.

## Evidence

- Parse gate: 9 files (panel, test, `UIKit.gd`, `SceneRouter.gd`,
  `CareerRoot.gd`, `ManagementChrome.gd`, `scene_router_test.gd`, the two
  tool sweeps), 0 failures.
- `rankings_hub_panel_test` **30/30**; `scene_router_test` 204/204;
  `ui_kit_book_test` green (248/248 built and rendered); smoke green.
- Full suite green before the commit.
- Pictures `DesignLibrary/screens/rankings_hub/` (division, p4p, champions,
  empty), rendered by `Godot/tools/render_rankings_hub.gd`.

## Test command

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/rankings_hub_panel_test.gd
```

## Next

K16 THE RING (Kalli, in progress in the working tree as of this stage —
untracked `RING_K16.html` / `_k16_gen_check.*`, not committed yet) is the
last un-kitted surface and the next Claude build once it lands. R28 CAREER
CREATION on K13 remains queued ahead of it; `CityScreen` and `CountryMap`
are the pre-kit scenes still standing.
