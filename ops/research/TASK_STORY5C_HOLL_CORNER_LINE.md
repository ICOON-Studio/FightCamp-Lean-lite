# TASK STORY5C - Holl's corner line (pure function + data + test)

Model: Arena (free coding worker), own branch arena/<chat-id>-fightcamp, PR into master, never merge.
Tier: a pure static added to an existing module + a new test -> parse gate + the new test + `story_` neighbours.

## Prior research
`python Tools/prior_research.py corner cue holl repeated` -> CAMPAIGN_PLAN.md (Holl = head coach, 58, "memory slipping, repeats three
cues"; "a cue repeated ('jab, jab, jab') shows decline without a new rule"; "Corner: Holl's cue drawn from the player's own reads;
repeated cues when his memory slips (flavour only)"), topics/plans_corner.md, J55 (the corner minute). Today the wired corner card prints
`COACH: <line>` from the fight read (CornerPitStopPanel.gd ~line 522). Gap: no speaker, no slip.

## What would a human do?
A writer would leave the instruction exactly as the game computed it (it is the player's own read - never change its meaning), put the
coach's name on it, and in later rounds let the old man fix on the first word of it and say it three times. Flavour only: no stat moves.

## Prefab check
None needed: a pure string function in the existing pure module `StoryCampaign.gd` (no GameState, no autoload, no RNG) + one data block.

## Owned files
- `Godot/scripts/StoryCampaign.gd` (~320 lines). Add ONE static at the end, after `static func result_line` (~line 291). Do not change any
  existing function.
- `Godot/assets/data/story_beats.json`: add a top-level key `"corner"` (keys today: `_doc`, `chapter`, `default_days`, `cards`).
- New test `Godot/tests/story_corner_line_test.gd` (copy the style of `Godot/tests/story_result_line_test.gd`: `extends SceneTree`,
  ok/FAIL lines, a final `STORY CORNER LINE PASS` or `FAILS=<n>`, `quit(1)` on any fail).

## Build
1. Data, `story_beats.json` -> `"corner": {"speaker": "HOLL", "slip_from_round": 3, "slip_every": 2, "repeat": 3}`.
2. `static func corner_line(state_in: Variant, line: String, round_number: int) -> Dictionary` returning `{"speaker": String, "line": String,
   "slipped": bool}`:
   - mode "off" (via `normalized(state_in)["mode"]`) -> `{"speaker": "COACH", "line": line, "slipped": false}` - the line is returned
     byte-identical.
   - mode "on" or "beside" -> speaker = the data's `speaker` ("HOLL").
   - SLIP: when `round_number >= slip_from_round` and `(round_number - slip_from_round) % slip_every == 0` (rounds 3, 5, 7 ...), and the
     line has a first word: the cue = the line's first word (letters only, upper case); the returned line = the cue repeated `repeat`
     times joined by ", " plus "." then one space then the ORIGINAL line unchanged. Example: "Jab and move." in round 3 ->
     "JAB, JAB, JAB. Jab and move." and `slipped` true. Rounds 1, 2, 4, 6 -> the original line, `slipped` false.
   - An empty line never slips (returns "" with the speaker).
   - Never mutates `state_in`. Deterministic (no RNG, no time).

## Acceptance (the one test)
`Godot/tests/story_corner_line_test.gd`, headless:
(a) off-mode returns COACH + the exact same line for rounds 1..8;
(b) on-mode round 1 and 2: speaker HOLL, line unchanged, slipped false;
(c) on-mode round 3: "Jab and move." -> "JAB, JAB, JAB. Jab and move.", slipped true; round 4 unchanged; round 5 slips again;
(d) "beside" behaves as "on";
(e) the original instruction is always a suffix of the returned line (its meaning is never changed) - check over 6 different lines x rounds 1..8;
(f) empty line -> "" , slipped false;
(g) the state dictionary passed in is unchanged after the calls (compare a deep duplicate);
(h) the numbers come from the data: read `StoryCampaign.data()["corner"]` in the test and assert `slip_from_round` is 3 (so a change to the
    data is the way to tune it, not the code).
Run: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/story_corner_line_test.gd` (NEVER `_console.exe`).
Neighbours: `python Godot/tools/run_tests.py --only story_ --jobs 2` stays green.

## The one trap
`StoryCampaign.data()` caches the JSON in `static var _cache`; if the test edits data, it must not - read only. Do not wire this into
CornerPitStopPanel or GameState (Claude wires it after the merge). Do not delete or weaken any existing test.
