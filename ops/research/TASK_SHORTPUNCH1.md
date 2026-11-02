# TASK_SHORTPUNCH1 - short punches up close: where to start a clip so the fist travels 15-30 cm (Lean repo)

Model: qwen3-coder (Qwen seat - small pure module + unit test)
Discipline: boxing (demo)
Repo: the Lean game, worked in the worktree named in the prompt. Godot 4.7.2, GDScript.

## Why
Up close (the "inside" range, chest to chest) our boxers throw the same hook and uppercut clips they throw at long range: the
clips are authored at range, so the fist winds up wide and travels 60-90 cm. Real inside punches are short. Claude will
measure each punch clip's fist path (a table of [time, distance travelled so far]) and, when the boxers are inside, start the
clip part-way through so only the last 15-30 cm of the fist's path plays before contact. This task is the pure math.

## Prior research
Game repo `research/J_INSIDE2_JOHN.md` (John, S315): "inside punches travel 15-30 cm" (DrillGrid), short shovel hooks and
uppercuts with a sharply bent elbow, mostly to the body; Dempsey's shovel hook. Searched: shovel, inside, uppercut, short, hook
(`Tools/prior_research.py`) - S315/S316 digests carry the same 15-30 cm number; nothing measured per clip yet.

## What would a human do?
An animator cutting a long hook into a short one keeps the end of the swing (the snap into contact and the return) and drops the
wind-up: the fist starts close and travels a hand's length. A coach says "short hooks inside, elbow in, 6 to 12 inches".

## Prefab check
Nothing to import: interpolation over our own measured table. Our code.

## Build: scripts/rules/ShortPunch.gd (new, < 120 lines, `extends RefCounted`, static funcs only, ZERO preloads)
```
const TRAVEL_M := {"lead_hook": 0.25, "rear_hook": 0.25, "lead_uppercut": 0.20, "rear_uppercut": 0.20,
	"body_hook": 0.22, "jab": 0.20, "cross": 0.22}
const MIN_M := 0.15
const MAX_M := 0.30
const MIN_WIND_S := 0.08
```
`static func want(move: String, roll: float) -> float`
- The fist travel for this punch up close: TRAVEL_M[move] (unknown move -> 0.22) plus (roll - 0.5) * 0.08, clamped to
  [MIN_M, MAX_M]. roll is 0..1 (the beat's random roll), so two hooks are not identical.

`static func path_at(path: Array, t: float) -> float`
- path = Array of [t_s, cum_m] pairs (Array of 2 floats), t ascending, cum_m non-decreasing: how far the fist has travelled
  (metres, along its path) by clip time t_s. Linear interpolation between samples; before the first sample -> the first cum;
  after the last -> the last cum; empty path -> 0.0.

`static func skip(path: Array, contact_s: float, want_m: float, speed: float = 1.0) -> float`
- The clip time to start at so the fist travels want_m before contact: the time s <= contact_s where
  path_at(contact_s) - path_at(s) == want_m (linear interpolation between the two samples that bracket it; search back from
  contact_s).
- Clamp the result to [0.0, max(0.0, contact_s - MIN_WIND_S * speed)] (at least MIN_WIND_S of real time before contact).
- The fist travels less than want_m in the whole clip before contact -> 0.0. Empty path or contact_s <= 0 -> 0.0.

`static func merge(combo_skip: float, short_skip: float) -> float`
- Both the combo rhythm and the short punch skip into the clip; the later start wins: max of the two.

## Test: tests/short_punch_test.gd (new, `extends SceneTree`, prints `SHORT_PUNCH failures=<n>`, quits 1 on failure, else 0)
Build paths by hand (no other preloads). A straight-line path P = [[0.0,0.0],[0.1,0.10],[0.2,0.30],[0.3,0.60],[0.4,0.80],
[0.5,0.85]] (fist 0.80 m travelled at contact 0.4).
1. path_at: P at 0.25 -> 0.45 (+-0.001); at -1 -> 0.0; at 9 -> 0.85; [] -> 0.0.
2. skip(P, 0.4, 0.20) -> 0.3 (0.80 - 0.60 = 0.20 exactly). skip(P, 0.4, 0.30): the start must have travelled
   0.80 - 0.30 = 0.50, between [0.2, 0.30] and [0.3, 0.60] -> t = 0.2 + 0.1 * (0.50 - 0.30) / 0.30 = 0.2667 (+-0.001).
3. Clamp: skip(P, 0.4, 0.01) -> 0.32 (contact 0.4 - MIN_WIND_S 0.08); with speed 2.0 -> 0.24.
4. Too short a path: skip(P, 0.4, 0.95) -> 0.0; skip([], 0.4, 0.2) -> 0.0; skip(P, 0.0, 0.2) -> 0.0.
5. want: every move in TRAVEL_M for roll 0, 0.5, 1 stays in [0.15, 0.30]; want("lead_hook", 0.5) == 0.25; want("??", 0.5)
   == 0.22; want("lead_hook", 0.0) != want("lead_hook", 1.0).
6. merge(0.1, 0.3) == 0.3; merge(0.3, 0.0) == 0.3.
7. Non-uniform samples: Q = [[0.0,0.0],[0.05,0.02],[0.30,0.50],[0.35,0.70]] contact 0.35, want 0.25 -> path at contact 0.70,
   need cum 0.45 -> between 0.05 (0.02) and 0.30 (0.50): t = 0.05 + 0.25 * (0.43 / 0.48) = 0.2740 (+-0.001).

## Commands
- Parse: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path .
  --check-only --script scripts/rules/ShortPunch.gd` (and the test) - no "Parse Error" lines.
- The one test (tier: new test file only): `... --headless --audio-driver Dummy --path . --script
  tests/short_punch_test.gd` -> `SHORT_PUNCH failures=0`.

## Contract
OWNS: scripts/rules/ShortPunch.gd, tests/short_punch_test.gd   (Lean repo)
RED_TEST: tests/short_punch_test.gd
REGRESSION: tests/short_punch_test.gd
VISUAL: none (math; Claude takes the inside still on the game's camera after wiring)

## VISUAL GATE
No still in this task; Claude takes the inside-range still on the game's camera after wiring (both boxers head to feet,
gap/noses/wrists/feet). Do not open any window.
