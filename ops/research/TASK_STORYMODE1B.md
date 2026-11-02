# TASK STORYMODE1B (S218) - New Career presets + Settings "convert to pure sandbox" (screens + GameState wiring)

Model: cloud Cursor (label `cursor`). Branch `cursor/issue-<n>` from master. Never master. Needs STORYMODE1A on master
(`StoryCampaign.gd`: PRESETS, PRESET_ORDER, DEFAULT_PRESET, apply_preset, preset_of, set_guidance, convert_to_sandbox, is_converted,
the `guidance` and `converted` state keys) - read that file's header first.

## Why
The CEO approved Ludo round 52 (board Q-S212-12, "Approve - build it"; spec `research/LUDO_ROUND52_VERDICT_S217.md`): the story
can be skipped, the story is the tutorial, and STORY and GUIDANCE are two independent switches. STORYMODE1A built the rules. This task
puts them on the two screens the player touches: New Career (pick a start) and Settings (leave the story for good).

## Prior research
`LUDO_ROUND52_VERDICT_S217.md`; `StoryCampaign.gd` (STORYMODE1A); `CreationFlowPanel.gd` (707 lines: STORY_MODES/STORY_TIPS ~76,
`_story_mode` ~92, the STORY strip ~324-333, `_on_story_mode` ~364, the commit in the OPEN GYM handler ~447-452);
`SettingsBoardPanel.gd` (301 lines: `_section`, `_row`, `_build_ruleset` ~189); GameState.gd (19,876 lines - NEVER read whole; the
story block is ~17925-18110: `is_story_campaign_on`, `_story_state`, `story_set_mode` ~18102, `story_set_player_name`).
## What would a human do?
A new player picks how they want to start in one click with the recommended start lit; a returning player opens an advanced option;
anyone can leave the story from Settings, is told plainly that it is permanent and what they keep, and confirms.
## Prefab check
None - existing UIKit components only (filter_strip, tips, confirm_sheet). No new art, no new widget.

## Do
1. GameState.gd (edit ONLY inside the story block, next to `story_set_mode`; same guards `has_active_career() and is_story_campaign_on()`):
   `story_apply_preset(preset_id: String)`, `story_set_guidance(on: bool)`, `story_convert_to_sandbox()`, and the reads
   `get_story_preset() -> String` (StoryCampaign.preset_of) and `get_story_guidance() -> bool`, `is_story_converted() -> bool`.
   Convert touches ONLY career["story"] - cash, roster, injuries, records and contracts are not touched.
2. CreationFlowPanel.gd - the GYM step's STORY question becomes a START question:
   - Replace the STORY strip with a strip of the 3 presets in PRESET_ORDER, labels "THE HOUSE THAT HOLDS", "GUIDED SANDBOX",
     "OPEN SANDBOX", DEFAULT_PRESET lit. Tooltips (one line each): house = "The story campaign: Mara Solano at Calder House. It
     teaches the game as you play."; guided = "Your own gym and fighters, no story. A checklist shows what to try next."; open =
     "Your own gym, no story, no checklist. Everything is open on day 1."
   - A small "ADVANCED" chip under it reveals the two raw switches: STORY (the existing ON / BESIDE / OFF strip) and GUIDANCE
     (ON / OFF). Picking a preset sets both; changing a raw switch shows the matching preset lit, or none ("custom",
     e.g. story ON + guidance OFF = CAMPAIGN VETERAN is reachable only here).
   - On OPEN GYM: `story_apply_preset` (or the raw pair via story_set_mode + story_set_guidance when custom), then
     `story_set_player_name` as today.
3. SettingsBoardPanel.gd - a new "STORY" section under RULESET: rows GUIDANCE (ON/OFF, live, via story_set_guidance) and STORY
   (read-only text: "CAMPAIGN" / "INBOX ONLY" / "OFF" / "PURE SANDBOX" when converted). While the story is not converted and is not
   off, a button "CONVERT TO PURE SANDBOX" opens `UIKit.confirm_sheet` with: "Leave the story for good? Your gym, cash, fighters,
   injuries, records and contracts stay exactly as they are. Story characters become ordinary people in the world. This cannot be
   undone." Buttons "CONVERT" / "KEEP THE STORY". CONVERT calls story_convert_to_sandbox and rebuilds; the button is gone after.
4. Keep every existing node name the current tests use, or update those tests in the same commit and say which in the PR.

## Tests
- Update `Godot/tests/new_career_story_mode_test.gd` (it picks chips by the old STORY strip): arms for each preset (house -> mode on +
  guidance true; guided -> off + true; open -> off + false), the control arm (no chip touched = house_that_holds), and one ADVANCED
  arm (story on + guidance off -> saved state preset_of == "campaign_veteran"). Keep its existing `-- as_game` / headless split.
- New `Godot/tests/settings_story_convert_test.gd`: a live career with story on -> Settings shows the CONVERT button; pressing it and
  CONVERT in the sheet -> is_story_converted() true, mode off, cash/roster size/records unchanged (compare before/after), the button
  is gone, GUIDANCE still toggles; KEEP THE STORY changes nothing (control arm).
- Run: `python Godot/tools/check_scripts.py <every touched .gd>`, both tests, then
  `python Godot/tools/run_tests.py --jobs 1 --only story,new_career,settings,creation`.

## The one trap
Headless tests run with game switches OFF and the story only exists when `is_story_campaign_on()`; follow the existing test's
`-- as_game` pattern for the saved-state arms. Never change a switch default to make a test pass.
