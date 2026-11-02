# TASK SCOUTFID1 - what a scout's report lets you see (pure module + headless test)

Repository: ICOON-Studio/FightCamp, branch from `master`. Work on your own `arena/...` branch and open a PR into master; never merge.
Model: Arena Agent Mode (any). Tier: new pure module + its own test only.

## Why
A boxing-club management game (Godot 4.7.2, GDScript). The fighter profile screen shows nine 0-100 boxing attributes, six body
regions with wear (0 = fresh, 100 = wrecked) and a radar. For OUR fighter everything is exact. For an OPPONENT, what you see depends on
how well he has been scouted, level 0 to 3 (design by our lead designer, approved by the producer):
- 0 unscouted: public record only - attributes hidden ("??"), tick bars empty, radar hidden, body hidden.
- 1 surface: attributes as LETTER GRADES A-E, tick bar is one flat block for the grade, radar shows only a coarse shape, body shows
  only major injuries.
- 2 advanced: attributes as an 8-POINT RANGE that contains the true value, tick bar = solid ticks up to the low end + "uncertain"
  ticks up to the high end, radar = an inner and an outer polygon, body = band names without the %.
- 3 deep: exact numbers, exact 20-tick bars, exact radar, exact body %, 30-day change visible.
This task is the pure maths that turns (true value, scout level) into what the screen may print. The screen itself is a later task.

## Prior research
`research/LUDO_ROUND37_S202_reply2b.txt` section 4 (the four levels) and `LUDO_ROUND37_S202_reply2a.txt` (band colours, tick bar),
`research/LUDO_ROUND37_VERDICT_S202.md` (no invented numbers). The existing `Godot/scripts/rules/FighterReadout.gd` has an older
`masked()` - leave it untouched; this is a new module.

## What would a human do?
Football Manager hides an unscouted player's attributes behind ranges that narrow as the scout watches more. Same here, but the range is
deterministic (a fixed per-fighter offset), so reopening the screen never shows a different range for the same fighter.

## Prefab check
Nothing to reuse: it is twenty lines of banding maths; no library does this.

## Owned files (create both; edit nothing else)
- `Godot/scripts/rules/ScoutFidelity.gd` - `extends RefCounted`, `class_name ScoutFidelity`, static funcs only. PURE: no `preload`,
  no `load(`, no autoload, no GameState, no RNG, no Node/scene access, no file access. Results depend only on arguments. Every function
  returns a NEW Dictionary/Array and never mutates its input.
- `Godot/tests/scout_fidelity_test.gd` - `extends SceneTree`; one `PASS <name>` or `FAIL <name>: <detail>` line per check and a final
  `SCOUTFID total=<n> fails=<m>`; `quit(0)` only when fails == 0, else `quit(1)`.

## API (exact names)
Constants: `TICKS := 20`, `POINTS_PER_TICK := 5`, `RANGE_WIDTH := 8`.
1. `band(value: float) -> Dictionary` - {"name", "color"}: 90-100 "ELITE" "#6366F1"; 75-89 "EXCELLENT" "#22C55E"; 60-74 "COMPETENT"
   "#EAB308"; 40-59 "MEDIOCRE" "#F97316"; 0-39 "POOR" "#EF4444". Inclusive lower edges; values clamped to 0..100.
2. `grade(value: float) -> Dictionary` - {"letter", "color"}: A 85-100 "#22C55E"; B 70-84 "#38BDF8"; C 55-69 "#EAB308"; D 40-54
   "#F97316"; E 0-39 "#EF4444".
3. `filled_ticks(value: float) -> int` - `floori(clamp(value,0,100) / 5)`, so 78 -> 15, 100 -> 20, 4 -> 0.
4. `attribute_view(value: float, level: int, offset: int = 4) -> Dictionary` - level clamped 0..3. Always keys: "mode", "text",
   "solid_ticks", "range_ticks", "color", "show_delta".
   - 0: mode "hidden", text "??", solid 0, range 0, color "#475569", show_delta false. The true value must NOT appear anywhere in the
     returned Dictionary (no "value" key).
   - 1: mode "grade", text = the letter, color = grade colour, solid_ticks = filled_ticks of the grade's LOWER edge (A -> 17, B -> 14,
     C -> 11, D -> 8, E -> 0), range_ticks 0, show_delta false. No "value" key.
   - 2: mode "range", "low", "high" ints with high - low == 8 (RANGE_WIDTH), low <= value <= high, both inside 0..100. The position of
     the true value inside the range is `offset` clamped to 0..8: low = value - offset, then shifted (never narrowed) to fit 0..100.
     text "%d - %d" % [low, high]; solid_ticks = filled_ticks(low); range_ticks = filled_ticks(high) - filled_ticks(low); color = band
     colour of low; show_delta false. No "value" key.
   - 3: mode "exact", "value" int (rounded), text str(value), solid_ticks = filled_ticks(value), range_ticks 0, color = band colour,
     show_delta true.
5. `offset_for(fighter_id: String) -> int` - a deterministic 0..8 offset from the id (sum of the UTF-8 bytes mod 9). Same id ->
   same offset always.
6. `region_view(wear: float, level: int) -> Dictionary` - keys "visible" (bool), "text", "color". Wear bands (lower edge inclusive):
   0-14 "PRISTINE" "#22C55E"; 15-29 "MINOR" "#84CC16"; 30-49 "MODERATE" "#EAB308"; 50-69 "HEAVY" "#F97316"; 70-84 "SEVERE" "#EF4444";
   85-100 "CRITICAL" "#7F1D1D". Level 0: visible false, text "UNKNOWN", color "#333E56". Level 1: visible only if wear >= 70 (a major
   injury), text = band name; otherwise visible false, text "". Level 2: visible true, text = band name, NO digit anywhere in text.
   Level 3: visible true, text "%d%% %s" % [round(wear), band name].
7. `radar_view(values: Array, level: int, offsets: Array = []) -> Dictionary` - values = 9 floats 0..100 (one per attribute, CHIN
   included - never drop an axis). Level 0: {"mode": "hidden"}. Level 1: {"mode": "shape", "points": each value rounded to the nearest
   20}. Level 2: {"mode": "band", "inner": each attribute's range low, "outer": its range high} using `attribute_view(v, 2, offsets[i])`
   (offset 4 when `offsets` is short). Level 3: {"mode": "exact", "points": values rounded to int}. Every array has exactly 9 entries.

## Test checks (each its own PASS/FAIL line)
- band/grade edges: 89 vs 90, 74 vs 75, 59 vs 60, 39 vs 40, 84 vs 85, 69 vs 70, 54 vs 55; clamping of -5 and 130.
- filled_ticks: 78 -> 15, 100 -> 20, 0 -> 0, 4.9 -> 0, 5 -> 1.
- Level 0 hides: for 25 values 0..100, `attribute_view(v, 0)` has no "value"/"low"/"high" key and its text is "??".
- Level 1: 78 -> "B", solid 14; 92 -> "A"; 10 -> "E", solid 0; no "value" key.
- Level 2 contains the truth: for every int v in 0..100 and every offset 0..8: low <= v <= high, high - low == 8, 0 <= low, high <= 100.
- Level 2 is stable: same (v, offset) twice -> identical Dictionaries; offset_for("ath_12") twice -> same int in 0..8.
- Level 2 hides the centre: across offsets 0..8 for v = 50 at least 5 DIFFERENT `low` values appear (the range is not always centred).
- Level 3 exact: 78 -> value 78, text "78", solid 15, show_delta true; colour = band(78).color.
- Regions: level 0 invisible; level 1 shows wear 72 but hides wear 40; level 2 text has no digit for wear 0..100; level 3 text "72% SEVERE".
- Radar: 9 entries at every level; level 0 hidden; level 2 inner[i] <= values[i] <= outer[i] for all 9.
- Purity: input arrays/dicts unchanged after each call (compare a duplicate(true) taken before).
- PURITY (source): read `res://scripts/rules/ScoutFidelity.gd` as text in the test and FAIL if it contains `preload`, `load(`,
  `GameState`, `randf`, `randi` or `RandomNumberGenerator`.
- CAN READ WORSE: inside the test, a deliberately broken level-2 rule (`low = value + 1`) must FAIL the "contains the truth" check -
  assert the check function returns false for it.

## How to run (CI runs it; no LFS models are loaded by this test)
`godot --headless --path Godot --script tests/scout_fidelity_test.gd` -> `SCOUTFID total=<n> fails=0`, exit code 0.

## The one trap
Do not delete or weaken a check to get green - CI's test guard fails a PR whose test lost lines. GDScript: `var x := <call>` fails when
the call returns Variant - type it (`var n: int = ...`); `%` in a format string is `%%`. If a check is wrong, say so in the PR.
