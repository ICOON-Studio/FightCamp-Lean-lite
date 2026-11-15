# TASK MODETELLS1 - the opponent's mode as a tell: share bands and the tape order (pure rule module + test)
Status: OPEN (S482, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default. Start from origin/main at or after
the S482 commits.

## Why now
The owner said "Yes, build it" to the plan flowchart (Q-240). Its map, ops/research/DESIGN_PLANFLOW1_V3_REVISE_KALLI_KALLI.md
section 4.1 (build row P2), makes the opponent's MODE (what the opponent is doing in an exchange) a new kind of tell that film
finds, with a share band and its own place in the tape order. The chart page (scripts/ui/PlanChart.gd) will read these
words. This task is ONLY the pure rules: no game state, no UI.

## The six modes (the game's own ids, FightFlow.WHEN_WORDS)
press, range, counter, loadup, tiring, hurt

## What to build: scripts/rules/ModeTells.gd (extends RefCounted; pure static; NO preload, NO class_name)
1. `band(films: int, shown: int) -> String` - how often film shows the opponent in one mode:
   - "" when films <= 0 or shown <= 0 (not found);
   - "often" when films >= OFTEN_FILMS (3) AND shown / films >= OFTEN_SHARE (0.75) ("3+ films and shown in at least 3 of 4");
   - "some" when shown / films >= SOME_SHARE (1.0 / 3.0), and ALSO whenever "often" is refused only because films < 3
     (with under 3 films the most a mode can show is "some");
   - "rare" otherwise (shown at least once).
   shown is clamped to [0, films].
2. `free_mode(style: String) -> String` - the mode the style word gives away (known with no film):
   "Pressure fighter" -> "press", "Out-boxer" -> "range", "Counter-puncher" -> "counter", "Volume puncher" -> "press",
   "Boxer-puncher" -> "" (no free mode), anything else -> "".
3. `tape_order(style: String, shown: Dictionary, films: int, habits: Array) -> Array` - the order film opens tells, as ids:
   "weapon", then "mode:<top unfree mode>", then every "habit:<id>" in the order given, then "mode:<second unfree mode>",
   then "weakness". Unfree modes = the six modes minus free_mode(style); ranked by shown[mode] (missing = 0) high to low, a
   tie broken by the order of the six ids above. A mode with shown 0 still ranks (film looks for it). Exactly 2 mode ids
   appear, never the free one.
4. Constants at the top: OFTEN_FILMS := 3, OFTEN_SHARE := 0.75, SOME_SHARE := 1.0 / 3.0, MODES := [the six ids].
Comment block at the top in the house style: what it is, the owner's ruling (Q-240 "Yes, build it"), the map section, and
one usage line per function.

## Test: tests/mode_tells_test.gd (extends SceneTree; prints "ok   <what>" / "FAIL <what>", ends with one line
`MODE_TELLS PASS fails=0` or `MODE_TELLS FAIL fails=<n>`, quit(0) on pass, quit(1) on fail)
Cover at least: band(0,0)=="", band(4,0)=="", band(4,3)=="often", band(4,4)=="often", band(3,2)=="some" (0.67 < 0.75),
band(2,2)=="some" (capped: under 3 films), band(1,1)=="some", band(6,1)=="rare", band(3,1)=="some" (exactly 1/3),
band(2,5) clamps to band(2,2); free_mode for every style above; tape_order for a Pressure fighter with
{"counter": 2, "range": 1} and habits ["drops_right_after_jab"] == ["weapon", "mode:counter", "habit:drops_right_after_jab",
"mode:range", "weakness"]; a Boxer-puncher with {} (all ties) == ["weapon", "mode:press", "mode:range", "weakness"] when
habits is empty (habits go between the two modes); "press" never appears for a Pressure fighter.

## Pass lines
RESULT: tests/mode_tells_test.gd -> MODE_TELLS PASS fails=0

## Contract
OWNS: scripts/rules/ModeTells.gd, tests/mode_tells_test.gd
RED_TEST: tests/mode_tells_test.gd -> MODE_TELLS PASS fails=0 (red on main: the files do not exist)
REGRESSION: tests/plan_chart_test.gd (the page these words will feed; it must stay green - nothing else may change)
VISUAL: no
NOT YOURS: every other file. Never delete or weaken a test. Both files under 500 lines.
Run: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/mode_tells_test.gd`
(headless only; the plain exe, never a terminal build; no window; no image opened).

## Prior research
DESIGN_PLANFLOW1_V3_REVISE_KALLI_KALLI.md 4.1 (share bands, tape order, free mode from the style word); OppFile.gd (the
existing tells: look, style, weapon, habit:<id>, weakness) - read only, do not change it.

## What would a human do?
A coach watching tape says "she presses most of the time" only after a few fights; with one or two films he says "she
pressed some". The style word on the booking sheet already tells him the obvious mode, so tape is spent on the next one.

## Prefab check
None: game-specific rules, a few lines of pure GDScript.
