# R23 Digest — THE FIGHTER CARD (Claude, 2026-09-05)

The third legacy replacement, and the cheapest: the kit panel was already
the live `fighter_card` route, so this stage was an adoption and a delete.

## 1. The card is the read

`ProfileRevampPanel._read()` made **25 GameState calls per rebuild** and
rebuilt on every tab switch, every answered ask and every route arrival.
It now makes **one**: Codex's C6 `get_fighter_card(athlete_id)` (`0b84633`),
plus `get_p4p_rankings()`, which the card does not carry. `respond_to_request`
stays on the panel — it is the one write. `_alerts()` dresses the card's
`flags` instead of calling `get_fighter_flags()` again.

**The render did not move.** Re-rendered with `tools/render_profile_revamp.gd`
(windowed) against a HEAD-panel render taken on the same machine minutes
earlier: all nine views plus `sheet.png` are **pixel-identical**. The nine
committed PNGs are refreshed anyway, because they differ from both by one
region — the shell rail, which R21/R22 collapsed to GYM and TRAINING
(0.37% of the frame, `bbox (40,305)-(365,584)`); the card itself is
unchanged pixel for pixel.

## 2. Deleted

`Godot/scripts/AthleteProfileScreen.gd` (1863 lines), its `.tscn`, and
`Godot/tests/athlete_profile_test.gd`. The test retired whole: every
assertion in it was about the dead screen's own `contract_for_test()`
widgets — it never touched GameState, so nothing needed moving.

## 3. The sweep

- `smoke_test.gd`, `tools/text_overflow_audit.gd` — scene entry dropped.
- `fight_camp_panel_test.gd` — mounts `FightCampPanel.gd` itself now
  (script, name, `setup(athlete_id)`); the dead screen's tab and header
  button claims are gone, every camp rule kept, 6/6.
- `development_screen_test.gd`, `skills_moves_screen_test.gd` — the
  loaded-by-path rule re-asserted against `ProfileRevampPanel.gd`.
- `stage4d_recovery_ui_test.gd` — the assigned-station claim moved onto
  GameState: `get_recovery_options()` offers the assigned station, flags
  it `is_current`, and carries its own forecast.
- `CaptureManagementCompletionPreviews.gd`, `CaptureStage3CodexPreviews.gd`,
  `CaptureStage4DRecoveryPreviews.gd` — the profile capture function and
  its call dropped; each tool keeps its other captures.
- Comments naming the screen reworded to the past tense in seven files.
  One is left: `GameState.gd:10127`, because Codex's C7 work is live in
  that file — reword it with the next GameState touch.

## 4. Evidence

Parse gate 18/18. `profile_revamp_test` 0 failures (grown with the C6
proof: a `CardSpy` that declares ONLY the four methods the panel may use
counts one card read per rebuild; a world opponent builds with every
roster-only region empty; an unknown id builds an empty card, never half
a card; answering an ask still goes through `respond_to_request` and
rebuilds). `fight_camp_panel_test`, `scene_router_test`,
`development_screen_test`, `skills_moves_screen_test`,
`stage4d_recovery_ui_test`, `smoke_test` all green. Full suite green.

## 5. Left behind for a later stage

`FightCampPanel.gd` is now orphaned UI — the legacy screen was its only
host, and the kit card draws CAMP itself. Its test keeps the camp rules
covered; the panel is a candidate for the same discard treatment when
the CAMP surface is rebuilt.

Test: `Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/profile_revamp_test.gd`
