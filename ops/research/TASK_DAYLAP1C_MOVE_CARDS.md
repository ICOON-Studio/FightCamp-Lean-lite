# TASK DAYLAP1C - move cards: time on a card makes a move usable (pure module + data + test)

Model: medium. Seat: Goose (GitHub issue + label `goose`, branch goose/issue-<n>). Tier: new pure module + data + test -> parse gate + that test.
Do NOT edit DayLap.gd, CoachPool.gd, GameState.gd or any scene. No GameState, no autoload, no RNG, no preload. Statics only; never mutate arguments.

Operator (S172, verbatim): "the player decides which skills to train (available skills per discipline coach knowledge etc are shown on the
screen maybe like cards) and for how long since he can click on another skill, there will be threshold that he needs to spend time on each
move to at least be usable and then can unlock other moves and combos". Design of record: research/DAYLAP1_DESIGN.md (last sections).
Model module: Godot/scripts/DayLap.gd (statics, JSON data, read-only args).

## Owned files (all new)
- `Godot/scripts/MoveCards.gd` (extends RefCounted)
- `Godot/assets/data/move_cards.json`: `usable_minutes` 120 (time on a card to make the move usable), `mastered_minutes` 600 (diminishing returns
  above it), `moves`: ~12 boxing moves, each `{"label", "discipline": "boxing", "coach_min_knowledge": 1-20, "unlocks": [ids]}`.
  Include: jab, cross, hook, uppercut, slip, parry, body_hook, jab_cross (combo, unlocked by jab+cross), jab_hook, cross_hook, 
  counter_cross (unlocked by slip), feint. A combo needs ALL its parents usable.
- `Godot/tests/move_cards_test.gd` (extends SceneTree; ok/FAIL lines; final `MOVE CARDS PASS` or `MOVE CARDS FAILS=<n>`; quit(1) on fail)

## API
- `static func available(discipline: String, coach_knowledge: int, progress: Dictionary) -> Array` - ids shown as cards: discipline matches,
  coach_knowledge >= coach_min_knowledge, and (no parents OR all parents usable in `progress`). `progress` = {move_id: minutes}.
- `static func train(progress: Dictionary, move_id: String, minutes: int, coach_knowledge: int) -> Dictionary` -> returns a NEW progress dict
  (or {"ok": false, "reason": ...} for unknown move / not available / minutes <= 0). Minutes past mastered_minutes still count but `level()` caps.
- `static func is_usable(progress: Dictionary, move_id: String) -> bool` (>= usable_minutes)
- `static func level(progress: Dictionary, move_id: String) -> float` 0..1: 0 at 0 min, ~0.5 at usable_minutes, 1.0 at mastered_minutes+, monotonic.
- `static func usable_moves(progress: Dictionary) -> Array` sorted ids.

## Acceptance
(a) fresh progress: only parentless moves within the coach's knowledge are available; combos are not;
(b) 119 min on jab -> not usable; 120 -> usable; jab_cross still unavailable until cross is ALSO usable, then it appears;
(c) coach knowledge gate: a coach at knowledge 3 never offers a move with coach_min_knowledge 10; raising knowledge shows it;
(d) level monotonic non-decreasing across 0..900 min step 30, 0 at 0, 1.0 at >= mastered_minutes, in (0,1) between;
(e) specialisation costs: 600 min all on jab leaves cross unusable (usable_moves == [jab]); splitting 120 jab + 120 cross makes both usable;
(f) refusals: unknown move, unavailable move, minutes 0/negative -> ok=false with a reason; the input progress dict is NOT mutated (deep compare);
(g) numbers come from the data: the test reads usable_minutes from the JSON and asserts 120; control arm: a copy of the table with usable_minutes
    forced to 60 flips the (b) result (usable at 60) - proves the test can read worse.
Parse gate: `python Godot/tools/check_scripts.py Godot/scripts/MoveCards.gd Godot/tests/move_cards_test.gd`
Run: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/move_cards_test.gd` (Linux/CI: `godot --headless --path Godot --script tests/move_cards_test.gd`)

## The one trap
`var x := <call>` fails when the call returns Variant - type it (`var n: int = ...`). A variable name reused in one function is a parse error.
