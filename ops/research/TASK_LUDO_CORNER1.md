# TASK LUDO-CORNER1 - Ludo's stool + corner AP rules as ONE pure module (V1 + V2, approved D40)

Model: Qwen (qwen3-coder). Worktree E:/FightCamp/wt/LUDOCORNER1, branch qwen/ludo-corner1 from master. Push the branch; never master.
Never open a window, image viewer or browser.

## Owned files
- `Godot/assets/data/ludo_corner.json` (NEW)
- `Godot/scripts/LudoCorner.gd` (NEW)
- `Godot/tests/ludo_corner_test.gd` (NEW)
- `research/TASK_LUDO_CORNER1.md`

## Prior research
- The numbers: `research/LUDO_CORNER_TABLES_S190.md` (TABLE 1 state word + State x Tone; TABLE 2 actions per lane). Read it whole.
- Design of record: LUDO_EVALUATION_S190.md s6 V1/V2 (D40). The existing corner model it will later replace: `Godot/scripts/CornerPitStop.gd`
  (430 lines, PURE, house style to copy: no preloads, the caller passes every roll). Do NOT edit CornerPitStop.gd in this task.

## What would a human do?
Put both tables in a data file, write one pure module that reads them, and test every row of both tables plus the AP clock.

## Prefab check
N/A - our own rules module.

## Spec
`ludo_corner.json`: {"states": [ordered rules from TABLE 1A], "tone_effects": {state: {tone: {composure, bpm, volume, plan, power, defence}}},
"actions": {lane: {action_id: {ap, effect: {...}, blunder: {...}}}}, "ap_seconds": 15, "lane_ap": 2, "rushed_blunder": 0.35, "usable_s": 45}.
Tones ids: "calm", "fire", "truth". States: "groggy", "panicked", "complacent", "steady". Lanes: "cutman", "second", "chief".
Percent columns stored as fractions (+15% -> 0.15).

`LudoCorner.gd` (extends RefCounted, static only, no preloads except reading the JSON once like CareerMorning._table()):
- `state_word(head: float, composure: float, bpm: float, score_diff: int) -> String` - TABLE 1A top to bottom (score_diff > 0 = he leads).
- `tone_effect(state: String, tone: String) -> Dictionary` - the TABLE 1B row; unknown -> {} .
- `lane_plan(lane: String, picks: Array) -> Dictionary` - picks = action ids in order; returns {ok, ap_used, seconds, rushed: bool,
  reason}; ok false when an action is not in that lane or the picks need more than lane_ap + 1 AP; rushed = the picks need lane_ap + 1.
  seconds = ap_used x ap_seconds (never above usable_s).
- `resolve(lane: String, picks: Array, roll: float) -> Dictionary` - {effects: [...], blunder: bool}: every action's effect; when rushed,
  the LAST action rolls: roll < rushed_blunder -> that action's blunder replaces its effect.

## Done = (tier: new files only - parse + this test)
`python Godot/tools/check_scripts.py Godot/scripts/LudoCorner.gd Godot/tests/ludo_corner_test.gd`;
`Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/ludo_corner_test.gd` -> FAILS=0, no SCRIPT ERROR.
The test checks: each TABLE 1A boundary (just above / just below every threshold), all 12 tone rows, every TABLE 2 action's ap and effect,
2 AP = 30 s not rushed, 3 AP = 45 s rushed, 4 AP refused, a blunder on roll 0.10 and none on roll 0.90, an action from another lane refused.
Prove it can fail: list in your final message 3 mutants you tried in a COPY (e.g. PANICKED threshold 175 -> 185, rushed 0.35 -> 0.0, calm/fire
swapped) and the FAIL count each gave. Commit + push; final message: commit hash, FAILS, mutants.

## The one trap
Read the thresholds exactly: GROGGY is "head < 40 OR (head < 55 AND composure < 30)"; PANICKED needs bpm >= 175 AND (composure < 45 OR
deficit >= 2). Order matters - groggy wins over panicked.
