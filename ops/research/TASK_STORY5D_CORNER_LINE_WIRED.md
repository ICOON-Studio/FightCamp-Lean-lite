# TASK STORY5D - Holl speaks in the corner (wire StoryCampaign.corner_line into the pit-stop card)

Model: Arena (free coding worker), own branch arena/<chat-id>-fightcamp, PR into master, never merge.
Tier: one UI script edited + one host line + one GameState read + a new test -> parse gate + the new test + `corner_` neighbours.

## Prior research
`python Tools/prior_research.py corner line holl wiring` -> CAMPAIGN_PLAN.md ("Corner: Holl's cue drawn from the player's own reads;
repeated cues when his memory slips (flavour only)"), K72_CORNER_CARD.md, topics/plans_corner.md. STORY5C (merged 81255fd5) built the pure
`StoryCampaign.corner_line(state_in, line, round_number) -> {"speaker", "line", "slipped"}` (StoryCampaign.gd line 314). Gap: nothing calls
it - the wired corner card still prints `COACH: <line>`.

## What would a human do?
Put the coach's name on the line he already says, and let the line the game computed reach the player unchanged except for Holl's repeat.
Flavour only: no number in the fight moves.

## Prefab check
None needed: a call to an existing pure function from an existing panel.

## Owned files
- `Godot/scripts/CornerPitStopPanel.gd` (631 lines). The COACH line is built in `_layout_wired()` (~line 500-525):
  `_reads.text = "TANK %d%%%s   ·   CARDS %s\nCOACH: %s" % [...]`. The round shown on the title is `int(_record.get("round", 0)) + 1`
  (`present()`, ~line 209).
- `Godot/scripts/FightWorldLiveScreen.gd` (6139 lines - read only `sed -n 5320,5345p`): the call `_pit_panel.present(fight, "a", ...)` at ~line 5336.
- `Godot/scripts/GameState.gd` (~17900 lines - read only `sed -n 17680,17700p` and `sed -n 17760,17800p`): `is_story_campaign_on()` ~17686,
  `_story_state()` ~17690, `get_story_wall`-style public reads ~17765.
- New test `Godot/tests/story_corner_wired_test.gd`.

## Build
1. CornerPitStopPanel.gd: add `const StoryCampaign := preload("res://scripts/StoryCampaign.gd")` and
   `var story_state: Variant = {"mode": "off"}` (DEFAULT OFF - see the trap). Add
   `static func coach_line(story_state_in: Variant, line: String, round_number: int) -> String` returning
   `"<SPEAKER>: <spoken line>"` from `StoryCampaign.corner_line(...)`. In `_layout_wired()` replace the `COACH: %s` part with
   `coach_line(story_state, <the same line or the same "Keep doing what you are doing." fallback>, int(_record.get("round", 0)) + 1)`.
   With the story off the text must be BYTE-IDENTICAL to today's (`COACH: ` + line).
2. GameState.gd: add a public read beside the other story reads:
   `func get_story_corner_state() -> Dictionary: return _story_state() if is_story_campaign_on() else {"mode": "off"}`.
3. FightWorldLiveScreen.gd, right before `_pit_panel.present(...)`: set `_pit_panel.story_state` from
   `get_node_or_null("/root/GameState")` when it has `get_story_corner_state`, else leave `{"mode": "off"}`.

## Acceptance (the one test)
`Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/story_corner_wired_test.gd` prints `STORY CORNER WIRED PASS`, rc 0:
- `coach_line({"mode":"off"}, "Jab and move.", 3) == "COACH: Jab and move."` (off = today's text).
- `coach_line(StoryCampaign.default_state("on"), "Jab and move.", 1) == "HOLL: Jab and move."`.
- round 3 -> `"HOLL: JAB, JAB, JAB. Jab and move."`; round 4 -> no repeat.
- a fresh panel's `story_state` reads mode off (the default is off, so a host that never sets it shows COACH).
- the panel path: build the fight exactly as `tests/corner_pit_stop_test.gd` `_panel()` does (seed 97003), set
  `s["corner_wired"] = true` (the panel's fight IS `s`; `FightBeatAdapter.is_corner_wired` checks `fight.has("corner_wired")`), set
  `panel.story_state = StoryCampaign.default_state("on")`, `present(...)`, and assert `contract_for_test()["reads"]` contains `"HOLL: "`;
  the same with the default state contains `"COACH: "`.
- CONTROL: a mutant that ignores `story_state` (always COACH) must fail at least one check - say in the PR that you ran it.
Neighbours that must stay green: `tests/corner_pit_stop_test.gd`, `tests/corner_panel_test.gd`, `tests/story_corner_line_test.gd`.
Parse gate first: `python Godot/tools/check_scripts.py scripts/CornerPitStopPanel.gd tests/story_corner_wired_test.gd`.

## The one trap
`StoryCampaign.normalized(null)` reads mode **"on"** (default_state defaults to "on"). A panel whose `story_state` is null would show HOLL
in every non-story career. The default MUST be the explicit dictionary `{"mode": "off"}`.

No images, videos or windows: no `start`, no browser, nothing opened on screen. Everything you send is public: no secrets.
