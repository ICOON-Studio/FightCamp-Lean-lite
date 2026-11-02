# TASK Q219 - GF1 part B: an offer says how hard the fight is, a camp focus says what it builds BEFORE you pick it (Qwen, S133)

Model: qwen3-coder (the launcher's pinned `--yolo` setting). Worktree `D:/FightCamp/wt/Q219`, branch
`qwen/q219-gf1-offers-camp`.

## Why
Dola's strict review D66 (`research/D66_STRICT_REVIEW.md`, weaknesses 3 and 6): offers carry no difficulty
("even bout" is vague) and camp focuses "The Striking Shark" / "The Marathon Man" show no effect, with an empty
"Projection: nothing to choose yet" box. Operator 2026-09-30: "assign someone to add those features from dolas report".
This is part B of roadmap GF1 (demo 2026-10-06). Part A (card, skills, home) is Cursor's U201 - do not touch it.

## Prior research (read first)
- `research/topics/ui_screens.md` (canonical), `J52_TOOLTIPS_AND_TUTORIAL.md`, `S78_DIGEST.md`,
  `D66_STRICT_REVIEW.md`. `python Tools/prior_research.py offer matchmaking camp focus projection` for more.

## What would a human do?
A UI designer on Football Manager's match offers and training focus: one short line on the row itself (opponent record
+ a difficulty word), the reasons in a hover; each focus card lists the numbers it moves, and the projection box shows
the focus the mouse is on before anything is committed.

## Prefab check
Reuse what exists: `UIKit.tip(node, spec)` (UIKit.gd:205; spec = a Glossary id, a plain line or {term, text, title,
now}) and the `TipLayer` autoload. The numbers already exist in data: `assets/data/fight_camp.json` (239 lines)
`focus_tracks[]` with `edges {stat: [per_week, cap]}`, `tightness_per_week`, `load_scale`, `injury_scale`
(e.g. striking_shark: strike_success 0.01 a week, cap 0.03). Do NOT edit `Glossary.gd` (Cursor owns it) - use plain
text or {title, text} tips.

## The work
1. Offers (`ScheduleHubPanel.gd` 2613 lines, "offers" tab - `_build_offers` :1046-1103; amateur rows `_amateur_row`
   :1112-1180 with the grade chip `_amateur_grade_words` :1186; pro rows through `UIKit.booking_offer_row` :4588):
   every offer row shows the opponent's record (W-L) and one difficulty word, and a hover says WHY - the inputs the
   grade really uses. Today amateur grading is the record-experience gap only (`AmateurMatchmaking.gd` 279 lines:
   `grade` :77-91, EVEN_MAX_GAP 2 / STEP_MAX_GAP 6 / DEBUT_UNSAFE_AT 3 at :18-23; the sentence `_line` :211-231); pro rows
   come from `GameState.get_booking_board` (:16295) and `_booking_grade_offer` (:16450). Say exactly those inputs
   ("he has 4 more fights than yours - a step up"); never show a win % or a style edge the code does not compute.
2. Camp (`FightCampPanel.gd` 1070 lines; focus cards `_build_setup` :177-215 show `track.banks` text only; empty
   projection `_build_projection` :324-340 "NOTHING TO PROJECT YET"; deltas `_delta_rows` :985 / `_deltas` :1007): each
   focus card lists what it builds per week and its cap, read from `fight_camp.json` edges (and the load/injury scale as
   words), and hovering a card fills the projection box with that focus's deltas (same `_deltas` path) before it is
   picked. After a pick the box behaves as today.

## Owned files (edit ONLY these; anything else = send-back)
- `Godot/scripts/ScheduleHubPanel.gd` - ONLY `_build_offers`, `_amateur_row`, `_amateur_grade_words` and helpers you
  add at the end of the file.
- `Godot/scripts/AmateurMatchmaking.gd` - ONLY `_line` (:211-231) and a new read-only helper that returns the grade's
  inputs.
- `Godot/scripts/UIKit.gd` (8308 lines - never read whole) - ONLY `booking_offer_row` (:4588..end of that func).
- `Godot/scripts/GameState.gd` (17,654 lines - NEVER read whole; `sed -n 16440,16560p`) - ONLY inside
  `_booking_grade_offer` to ADD fields to the offer dictionary (e.g. the opponent's record); change no value.
- `Godot/scripts/FightCampPanel.gd` - `_build_setup`, `_build_projection` and helpers you add.
- NEW: `Godot/tests/gf1_offers_camp_tips_test.gd`, `previews/q219/*`, `research/Q219_DIGEST.md`.

## Parse gate (before any test)
`python Godot/tools/check_scripts.py Godot/scripts/ScheduleHubPanel.gd Godot/scripts/AmateurMatchmaking.gd Godot/scripts/UIKit.gd Godot/scripts/GameState.gd Godot/scripts/FightCampPanel.gd`

## Test (tier: scripts edited)
One: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe" --headless --path Godot --script tests/gf1_offers_camp_tips_test.gd`
Your new test builds the offers tab and the camp panel headless and asserts: every offer row shows a record and a
difficulty word and its hover (`TipLayer.body_for`, the game's own function) names the grade's real inputs; every
focus card shows at least one per-week number that equals `fight_camp.json`; hovering a card makes the projection box
non-empty. FightCampPanel must be in the tree before `setup()` (it reads `get_tree().root.get_node_or_null("GameState")`
at :66-67). Then:
`python Godot/tools/run_tests.py --jobs 2 --only schedule_hub_panel,amateur_board,amateur_matchmaking,booking_board_api,fight_camp,camp_board_api,gf1_offers`
(never serial; wait on the runner's exit).

## Screens (evidence)
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/s64_career_walk.gd -- plan=research/s117_boxer_walk.plan out=docs/previews/q219 as_game`
(needs a window - godot_hidden hides it). Open 47_offers and 60_start_a_camp: nothing overlaps or overflows.

## Acceptance
1. Every offer row: record + difficulty word + a hover with the real inputs; every focus card: its per-week numbers;
   the projection box never empty while a card is hovered (test green).
2. All listed tests green.
3. Branch pushed; explicit `git add` by path (never `git add .`, never `Godot/.godot`); 10-line `Q219_DIGEST.md`.

## The one trap
Say only what the code computes: the amateur grade uses the record gap and nothing else, so a hover that mentions style
or ranking would be a lie. `GameState.gd` and `UIKit.gd` are huge and shared with Cursor's U201 - stay inside the named
functions.
