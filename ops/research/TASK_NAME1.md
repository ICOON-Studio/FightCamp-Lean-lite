# TASK NAME1 - New Career asks YOUR NAME; the story cards say it

Model: any. Owner: Arena (cloud, own `arena/` branch, PR only, never merge). Tier: scripts edited -> parse gate + the focused tests.

## Prior research
`python Tools/prior_research.py "player name" "New Career name"`: no prior study. Design of record: `research/CAMPAIGN_PLAN.md`
line 81: "New Career asks three things: your name, Story On/Beside/Off, the gym name". Two of the three exist since S164
(`CreationFlowPanel._build_gym`, lines 263-300: GYM NAME field + STORY chip strip). The name is asked nowhere and used nowhere.

## What would a human do?
A manager game asks who you are once, on the same screen as the gym name, and then the characters address you by it. Nothing else
changes: a player who leaves it blank is called "Coach".

## Prefab check
None: one LineEdit in our own UIKit style, one string in the save, one placeholder in the card text.

## Spec (exact)
1. `Godot/scripts/CreationFlowPanel.gd` (624 lines), `_build_gym()` lines 263-300: add a second field. Layout on the gym step
   (y = 78 caption, y = 100 field, TakeHost from y = 176): GYM NAME field width 620 -> 400 (x = MARGIN); new caption "YOUR NAME"
   (`UIKit.caps`, name "PlayerCap") at x = MARGIN + 420, y = 78; new `LineEdit` name "PlayerField", x = MARGIN + 420, y = 100,
   size 220 x 52, `max_length` 24, same font/style overrides as the gym field (copy lines 274-281), `placeholder_text = "Coach"`.
   The STORY caption/strip stay at MARGIN + 660. Keep the typed value in a new `var _player_name := ""` (survives `rebuild()`
   like `_gym_name`); `text_changed` -> `_on_player_typed(text)` sets it and nothing else (no refusal, no take redraw).
   Tooltip: `UIKit.tip(field, "The name the gym's people call you. Blank = Coach")` - plain `tooltip_text` is wiped by UserSettings.
2. Commit: in `_on_name_typed` where `story_set_mode(_story_mode)` is called (line ~388-390), also call
   `story_state.story_set_player_name(_player_name)` (guard with `has_method`). Also add `"player_name": _player_name` to the
   debug/read dictionary at line ~596 beside `"gym_name"`, and a `func player_name_for_test() -> String` beside
   `story_mode_for_test()` (line 623).
3. `Godot/scripts/StoryCampaign.gd`: the state (line 9 doc, `_fresh` line 39, `normalized` lines 42-55) gains `"player_name": ""`
   (normalized keeps a present string, default ""). New `static func set_player_name(state_in, name: String) -> Dictionary`
   (strip_edges, max 24 chars) like `set_mode` (line 170). `with_names(card_in, fighter_first_name, player_name: String = "")`
   (line 177): replace `{you}` with `player_name` or "Coach" when empty, in title/body/choice label/tip, same loop as `{fighter}`.
4. `Godot/scripts/GameState.gd` (NEVER read whole - `sed -n 17740,17800p`): new `func story_set_player_name(name: String) -> void`
   beside `story_set_mode` (line 17780, same guards); the two `with_names(...)` calls at lines 17754 and 17757 pass
   `str(_story_state().get("player_name", ""))` as the third argument.
5. `Godot/assets/data/story_beats.json` (9 beats): the `welcome` card body gains the address once:
   "Dessa has had a stroke. The keys are yours now, {you}.\nThe bills are in the drawer. The ring is empty." No other text changes.

## Acceptance (exact)
New test `Godot/tests/new_career_player_name_test.gd`, modelled on `Godot/tests/new_career_story_mode_test.gd` (same private save
dir pattern, a NEW save dir name `user://fightcamp_player_name_test`, same `_open` helper), arms:
- typed "Ronda" on the PlayerField, OPEN GYM -> saved `career.story.player_name == "Ronda"` and `get_story_read()["current"]["body"]`
  contains "Ronda" and no "{you}" (needs `-- as_game` for the saved arms, like the sibling test; headless asserts the field value);
- control: nothing typed -> `player_name == ""` and the body contains "Coach" and no "{you}";
- 25 typed chars -> saved length 24.
Plus `Godot/tests/story_campaign_test.gd`: 2 checks for `with_names(card, "Kid", "Ronda")` ({you} -> Ronda) and `with_names(card, "Kid")`
({you} -> Coach). Mutant proof in the PR description: comment out the `{you}` replace -> both tests go red.
```
python Godot/tools/check_scripts.py Godot/scripts/CreationFlowPanel.gd Godot/scripts/StoryCampaign.gd Godot/scripts/GameState.gd Godot/tests/new_career_player_name_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/new_career_player_name_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/new_career_story_mode_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/story_campaign_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/story_inbox_panel_test.gd
```
All four print no FAIL. CI has no LFS: these tests load no LFS models. Do not delete or shorten any test.

## Owned files
`CreationFlowPanel.gd` (624), `StoryCampaign.gd` (~230), `GameState.gd` (window 17740-17800 only), `story_beats.json`,
`tests/new_career_player_name_test.gd` (new), `tests/story_campaign_test.gd` (append only).

## The one trap
`var x := some_call()` is a parse error when the call returns Variant - type it (`var name: String = ...`). A parse error hangs a
headless test (rc=124), so run the parse gate first.
