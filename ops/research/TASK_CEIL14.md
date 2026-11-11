# TASK CEIL14 - QWEN (qwen3-coder) - a ceiling for each of the 14 abilities, shaped by the fighter's class and style (pure rule + unit test)

Status: OPEN (S433, Claude main). Discipline: boxing. Model: qwen3-coder.
Source: `ops/research/TRAINING_MAP_S432.md` section 0, row F2a CEIL14 (the foundation fixes; F2b GAIN14 comes after and is Claude's).
Checked in today's code (S433, Claude read each line):
- `scripts/rules/Recruit.gd:57-61` `ceiling(f, stat)` is the only ceiling: `clampf(pot + bias, now + 2.0, 99.0)`, bias +6 when
  `stat == CLASSES[style][2]`, -6 when `== [3]`. Those are OLD stat names ("power", "conditioning", "chin", "technique"...).
- `scripts/rules/Attrs.gd:31-33` `LEGACY` gives the old seven their children; footwork, inside and flexibility are in no list.
- `Recruit.ceiling(f, "footwork")` reads `stats.get("footwork", 50.0)`, finds no bias, returns plain `pot`. No 14-ability ceiling exists.
- Readers: only `scripts/ui/RecruitPanel.gd:65,78` (old seven). `scripts/state/Sim.gd:120` `week_ctx` passes one `"pot"` to the gain.
- The map's worked example is wrong about the person: in `scripts/state/Data.gd:210-211` Samira is a SLUGGER at pot 82, not an out-boxer
  at 68. The numbers it gives (Footwork 72, Speed 76, Inside 63, Strength 60) are right for an out-boxer at pot 68, so the test uses that.

## Contract
OWNS: scripts/rules/Recruit.gd, tests/ceiling_shape_test.gd
RED_TEST: tests/ceiling_shape_test.gd -> CEILING_SHAPE checks=7 failures=0
REGRESSION: recruit_test, playtest_s375_test
VISUAL: no

## The job
1. In `scripts/rules/Recruit.gd` add at the top `const Attrs := preload("res://scripts/rules/Attrs.gd")` and
   `const AttrGen := preload("res://scripts/rules/AttrGen.gd")` (no cycle: neither preloads Recruit), and constants
   `CLASS_BIAS := 6.0`, `TILT_HALF := 0.5`, `HOLD := 8.0`, `CEIL_MAX := 99.0`. Add one line to the header list: `ceiling_of(f, ability)`.
2. New `static func ceiling_of(f: Dictionary, ability: String) -> float`, under `ceiling()`, about 20 lines:
   - `var style := str(f.get("style", ""))` and `var cl := class_of(style)` (an unknown style gets Boxer-puncher, as `ceiling` does).
   - `parent`: the `Attrs.LEGACY` key whose list holds `ability` (`for k in Attrs.LEGACY: if (Attrs.LEGACY[k] as Array).has(ability)`),
     "" for footwork, inside, flexibility.
   - `bias`: +CLASS_BIAS when `parent == str(cl[2])`, -CLASS_BIAS when `parent == str(cl[3])`, else 0. Compare `parent`, never `ability`.
   - `tilt`: `float(AttrGen.tilt_of(style).get(ability, 0.0))` (already centred; `{}` for an unknown style = 0).
   - `pot := float(f.get("pot", 70))`; `c := clampf(pot + bias + TILT_HALF * tilt, pot - HOLD, pot + HOLD)`.
   - `now`: read with `get` only, never `[]` on a missing key: `var attrs: Dictionary = f.get("attrs", {})`,
     `var stats: Dictionary = f.get("stats", {})`; `attrs[ability]` when `attrs.has(ability)`, else `stats[parent]` when
     `parent != "" and stats.has(parent)`, else 50.0.
   - return `minf(CEIL_MAX, maxf(c, now + 2.0))`. Not rounded.
3. Do NOT change `ceiling()` (RecruitPanel and recruit_test read it), nor any other function. Keep every existing function's signature.
   Do NOT wire ceiling_of into Sim, WeekPlan or Attrs (that is F2b GAIN14).
4. `tests/ceiling_shape_test.gd` (extends SceneTree, the `_check` + final print + `quit(1 if fails else 0)` pattern of
   tests/recruit_test.gd). Call it ONLY through a helper `_c(f, a) -> float` that returns -1.0 when
   `R.get_script_method_list()` has no entry named "ceiling_of", else `float(R.call("ceiling_of", f, a))` - so the test compiles on
   main. The list holds DICTIONARIES, so `.has("ceiling_of")` on it is always false (the test would stay red after the build):
   loop it, `for m in R.get_script_method_list(): if str(m["name"]) == "ceiling_of": found = true`.
   Exactly ONE `_check` call per letter below (a to g, 7 in all): a check over many abilities gathers one bool in a loop first.
   Population (print it; each dict carries the exact "style" string): OLA, `"style": "Out-boxer"`, pot 68, attrs all 14 at 55 except strength 60; ROCCO, `"style": "Slugger"`, pot 82, attrs all 14
   at 58 except explosiveness 64; a third dict with style "nonsense", pot 70, attrs at 55; a fourth OLA copy with NO "attrs" key, only
   `stats` (the old seven at 55). Each check (within 0.01), and how it fails on main (every `_c` is -1):
   a. Ola's 14 (expected): footwork 72.19, speed 76.00 (held +8), defence 70.19, timing 68.69, inside 63.19, explosiveness 60.00 (held
      -8), strength 62.00 (now + 2), the other seven 67.19. Main: all -1.
   b. Footwork, Inside and Flexibility each get a ceiling: Ola's equal 72.19, 63.19 and 67.19 (within 0.01). Compare with these
      numbers, not with "is not 68": -1 is not 68 either, so that check would pass on main. Main: -1.
   c. An out-boxer's Footwork ceiling is above its Inside ceiling. Main: -1 > -1 is false.
   d. Rocco: explosiveness 90.00 (held) above speed 78.37; accuracy 74.00 (held), durability 85.87, footwork 77.87. Main: -1.
   e. Every ceiling of Ola and Rocco lies in [pot - 8, pot + 8] or equals now + 2, and is >= now + 2 and <= 99. Main: -1 < now + 2.
   f. The unknown style gets the Boxer-puncher class (as `ceiling` does) and no tilt: accuracy and timing 76, durability 64, footwork 70.
   g. The no-attrs Ola gives footwork 72.19 and still has no "attrs" key after the call (the function only reads). Main: -1.
   Final line: `CEILING_SHAPE checks=%d failures=%d`. On main it prints `CEILING_SHAPE checks=7 failures=7`.

## The trap
Never call `Attrs.of(f)` (or `Attrs.sync`/`absorb`) inside ceiling_of: `Attrs.of` migrates and WRITES `f["attrs"]` and `f["stats_seen"]`,
so a panel that only looks at a recruit would change the recruit. Read the dicts only. And compare the class's names with the
ability's PARENT, never with the ability: "speed" and "fight_iq" are both, so a direct compare looks right for those two and
silently drops the bias on the other nine.

## GDScript traps that apply (ops/research/GDSCRIPT_TRAPS.md)
- `var x := d.get(...)` is Variant: type it (`var tilt: float = float(...)`). In a format string `%` is `%%`.
- A variable name reused in one function is a parse error, even across blocks (the test's loops over fighters).
- `call`/`callv` with the wrong number of arguments returns null/{} without stopping: `R.call("ceiling_of", f, a)`, two arguments.
- `clampf(x, lo, hi)` with lo > hi: never pass `now + 2` as lo with 99 as hi; use the `maxf` then `minf` of step 2.

## Prior research
`python ops/Tools/prior_research.py ceiling potential headroom` and `... ceiling_of tilt archetype Recruit`: TRAINING_MAP_S432.md (F2a,
T16, the shares), FIGHTER_MODEL_S397.md (the archetype tilts AttrGen.TILTS holds), RPG_LAYER_MAP_S432.md (each attribute's ceiling on the
card), CRITIC_PACK.md (headroom clamp((potential - stat) / 25, 0.10, 1.25)), K66_ATTRIBUTE_SYSTEMS_IN_SHIPPED_GAMES.md.

## What would a human do?
A coach looking at a new out-boxer says: the feet and hand speed can go a long way, the inside work and raw strength will
always lag. One number per ability, read from the fighter's build and style, never one number for everything.

## Prefab check
None: our own rules (Recruit.CLASSES, AttrGen.TILTS, Attrs.LEGACY are the inputs).

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path . --script res://tests/ceiling_shape_test.gd`
on the PC. Parse first, through the same `godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path .`
prefix, with `--check-only --script res://scripts/rules/Recruit.gd`, then the same for `res://tests/ceiling_shape_test.gd`. No file over 500 lines:
Recruit.gd is 123 lines now (about 145 after), the test is new (keep it under 120). Do not add the test to tools/run_tests.sh.
Never "he" or "she" in text.

## Result lines (PR body)
RESULT: tests/ceiling_shape_test.gd -> CEILING_SHAPE checks=7 failures=0
RESULT: tests/recruit_test.gd -> RECRUIT PASS fails=0
RESULT: tests/playtest_s375_test.gd -> PLAYTEST_S375 failures=0
Paste in the PR body: the 14 ceilings printed for Ola and Rocco, and the main-tree run of the test (failures=7).
