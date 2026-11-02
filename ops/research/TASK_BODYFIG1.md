# TASK_BODYFIG1 - the body map's live figure (Lean repo)

Model: qwen3-coder (Qwen seat - small module + unit test)
Discipline: boxing (demo)
Repo: the Lean game (E:\FightCamp\Lean), worked in the worktree named in the prompt. Godot 4.7.2, GDScript.

## Why
Operator S316: "add a body visual with muscle that will be real time interactive on where the hits are being taken and
changing colour on that area". Plan approved Q-S294-29 "Yes, build it" (Game research/S316_BODY_MAP_PLAN.md step 2).
The rules exist: `scripts/rules/BodyMap.gd` (six places, values 0-100, `band(v)`). This task is ONLY the drawn figure;
Claude wires it into the fight HUD afterwards.

## Prior research
Game research/S316_BODY_MAP_PLAN.md (the design), topics/body_damage.md via BodyMap.gd (settled bands: fine > 55,
hurt <= 55, critical <= 35, doctor <= 15). Broadcasts show region tallies; EA UFC shows region bars + icons; Fight Night
Champion's face damage was the best liked (G132).

## What would a human do?
A TV graphics artist draws a plain front-view silhouette and tints the struck region; a cutman reads the face and ribs.
So: a simple, readable figure (head with two eyes and a nose, a torso with two rib patches), flat colours, no realism.

## Prefab check
No Godot asset-library body-map widget fits (searched: "body map", "damage silhouette"); a 150-line `_draw()` Control is
smaller than any import. Licence: our own code.

## Build: scripts/ui/BodyFigure.gd (new, < 220 lines, `extends Control`, `class_name` NOT used)
Pure drawing from data, no preloads except `res://scripts/rules/BodyMap.gd`.
- `custom_minimum_size` 90 x 150 by default. Everything is drawn in `_draw()` scaled to `size` (keep the 90:150 shape,
  centred), so a bigger figure (the corner card) is the same node with a bigger size.
- The figure, front view, flat shapes: head (circle), neck, torso (rounded rectangle or polygon), two upper arms, two legs
  down to the hips are enough. Fill Color(0.18, 0.18, 0.2), outline Color(1, 1, 1, 0.35) width 1.5.
- Six PLACES (BodyMap.PLACES) drawn on top, each a filled shape in its band colour:
  "head" = the whole head circle tinted at 45 % alpha; "left_eye" / "right_eye" = small circles; "nose" = a small
  triangle or circle under the eyes; "left_ribs" / "right_ribs" = rounded patches on each side of the torso.
  FRONT VIEW: the boxer's LEFT eye and ribs are on the VIEWER'S RIGHT (as when you face a person). Put that in a comment.
- Band colours (const BAND_COLOURS: Dictionary): fine Color("#6cc27a"), hurt Color("#f0a020"), critical Color("#e0503c"),
  doctor Color("#a050e0").
- API:
  - `func set_values(values: Dictionary) -> void` - place -> 0..100 (missing places = 100); queue_redraw().
  - `func hit(place: String, punch: String) -> void` - flash that place: it draws Color.WHITE blended over its band
    colour, fading from 1.0 to 0.0 over FLASH_S := 0.35 s (in `_process`), and remembers the punch (keep the last 3 per
    place, newest first).
  - `func colour_of(place: String) -> Color` - the colour that place is drawn in now (band colour, flash blended in).
  - `func tip_of(place: String) -> String` - e.g. "Nose 62 (hurt) - cross, jab, jab"; with no punches: "Nose 100 (fine)".
    Names: Head, Left eye, Right eye, Nose, Left ribs, Right ribs.
  - `func place_at(local_pos: Vector2) -> String` - which place a point (in this Control's local pixels) is on, "" if none.
    Hovering sets `tooltip_text` to `tip_of(place_at(mouse))` (override `_get_tooltip(at_position)` and return it).
- Set `mouse_filter = MOUSE_FILTER_PASS`.

## Test: tests/body_figure_test.gd (new, `extends SceneTree`, prints `BODY_FIGURE failures=<n>`, quits 1 on failure)
1. Bands: set_values({"nose": 56}) -> colour_of("nose") == fine colour; 55 -> hurt; 35 -> critical; 15 -> doctor; a
   missing place reads fine.
2. Flash: hit("left_eye", "jab") -> colour_of("left_eye") is near WHITE (each channel >= 0.9); after simulating > FLASH_S
   of `_process(delta)` calls it equals the band colour again.
3. Tips: three hits on "nose" (jab, cross, lead_hook) then a fourth (jab) -> tip lists exactly the newest three, newest
   first: "Nose 100 (fine) - jab, lead_hook, cross".
4. Geometry, front view: with size 90 x 150, place_at() of the centre of each place's drawn shape returns that place; the
   "left_eye" centre has a LARGER x than the "right_eye" centre; same for the ribs; place_at(Vector2(2, 2)) == "".
   (Expose `func centre_of(place: String) -> Vector2` for this, in local pixels.)
5. Scale: at size 180 x 300 the centres scale by 2 (within 1 px).
Add the node to `root` before testing so `_process` and `size` work; call `_process(delta)` directly for time.

## Commands
- Parse gate: `python E:\FightCamp\Game\Godot\tools\check_scripts.py scripts/ui/BodyFigure.gd tests/body_figure_test.gd`
- The one test (tier: new test file only): `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless
  --audio-driver Dummy --path . --script tests/body_figure_test.gd` -> `BODY_FIGURE failures=0`
- Also keep green: `--script tests/body_map_test.gd` -> `BODY_MAP failures=0`.

## Contract
OWNS: scripts/ui/BodyFigure.gd, tests/body_figure_test.gd   (Lean repo)
RED_TEST: tests/body_figure_test.gd
REGRESSION: tests/body_map_test.gd
VISUAL: none in this task (Claude takes the HUD still after wiring)

## VISUAL GATE
This task draws no game-camera still; the figure is judged by Claude on the fight HUD still (still_framing / the Lean
fight3d stills) after wiring, and by the operator. Do not open any window or image viewer.

## The one trap
Front view mirrors left and right: the boxer's left side is drawn on the viewer's right. Test 4 checks it.
Do not touch any other file. Do not open any window. Do not push. Commit on your branch with a clear message.
