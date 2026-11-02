# TASK LOOPOFF1 - switch OFF everything outside the one core loop (S238, LOOP1, operator-approved)

Seat: Grok Dev (gbot `--to dev`, own Linux box, Godot 4.7.2, no LFS). Branch `grok/loopoff1`, PR to master; Claude merges by diff.
Model: Grok Dev default. Discipline: BOXING (the demo).

Operator S237 (verbatim): "focus on one simple loop and keep it simple: (no story yet switch that thing off for now) [...] can we filter
out everything else and keep what wee need only for that ?" Approved verdict (board Q-S237-1, research/LOOP1_VERDICT_S238.md):
"build it, the equipment wear is not what matters on this , the loop , animations,workout,feeling of progrsession and improvement from
training these are what matters for now". Nothing is deleted: each feature comes back by flipping its switch.

## What is on master (read; line numbers at commit e339535b)
- `Godot/scripts/GameSwitches.gd` (~104 lines): `GAME_ON` (switches the game ships ON), `DEFAULT_OFF` (declared OFF, name -> reason),
  `in_game()` (not a plain --script run, or `as_game`), `on(name)` (career key > user arg `name` / `name=1` > in_game() and GAME_ON).
- `Godot/scripts/GameState.gd` (21,007 lines - NEVER read whole; use `sed -n`):
  - ~18775 `is_tutorial_guide_on()` returns `bool(career.get("tutorial_guide", empty_gym_start()))` (the 11-step guide card).
  - ~18925 `is_story_campaign_on()` returns `bool(career.get("story_campaign", empty_gym_start()))` - EVERY story reader goes through it
    (get_story_read, get_story_wall, get_story_corner_state, get_story_result_line, get_story_guidance ...).
  An existing save carries `story_campaign: true` and `tutorial_guide: true` - the loop must switch them off for HIS save too.

## Do
1. GameSwitches.gd: move these OUT of `GAME_ON` into `DEFAULT_OFF`, each with the reason "LOOP1 S238: outside the core loop
   (operator Q-S237-1)": `floor_events`, `floor_cuts`, `corner_rehearsal`, `open_spar_night`, `decision_card`, `station_wear`, `street_vista`.
   Add two new DEFAULT_OFF entries: `story` ("LOOP1 S238: story campaign off - 'no story yet switch that thing off for now'") and
   `tutorial_guide_card` ("LOOP1 S238: the 11-step guide card off; the goal card replaces it").
2. GameState.gd: `is_story_campaign_on()` returns false when `GameSwitches.in_game() and not GameSwitches.on("story")`, otherwise its
   current value. Same for `is_tutorial_guide_on()` with `tutorial_guide_card`. A plain --script run is unchanged (control arm), and
   a user arg `story=1` / `tutorial_guide_card=1` brings each back. Do not change any save data (the career keys stay as they are).
3. Every test that runs `as_game` (or otherwise relies on in_game()) and needs one of these features ON must pass the feature's user arg
   itself (e.g. `-- as_game story=1`, `-- as_game floor_events=1`), or read the switch through its own seam - find them with
   `grep -rln "as_game" Godot/tests Godot/tools/run_tests.py` and the switch names. Do NOT delete a test or weaken an assertion.
   `Godot/tools/run_tests.py` may carry per-test arg lists - check how as_game tests get their args before changing tests.
4. Update `Godot/tests/game_switches_test.gd` (or add `loop1_switches_test.gd`) to assert: the 9 names are OFF in_game, ON with their
   user arg, and every remaining GAME_ON name is still ON.

## Tests (red on master first - paste the red lines in the PR body)
New `Godot/tests/loop1_switches_test.gd` (extends SceneTree, `_initialize`, prints `LOOP1_SWITCHES failures=N`, quit(1) on fail):
run it twice - plain (`--script tests/loop1_switches_test.gd`) and as the game (`... -- as_game`) - and assert per arm: plain = story and
guide unchanged from the career keys; as_game = both OFF even with career {"story_campaign": true, "tutorial_guide": true}; as_game +
`story=1` = story back ON. Print the population line (a career dict with both keys true, boxing).
Then run: `python Godot/tools/run_tests.py --jobs 2 --only story,tutorial,game_switches,floor_event,floor_cut,corner_rehearsal,open_spar,decision_card,station_wear,street_vista,loop1`
and paste the SUITE line plus each FAIL's own line (exit code alone is not a pass). Parse gate first:
`python Godot/tools/check_scripts.py Godot/scripts/GameSwitches.gd Godot/scripts/GameState.gd <every touched test>`.

## Rules
GDSCRIPT_TRAPS.md. GameState.gd is never read whole. THE ONE TRAP: an as_game test that goes red because its feature is now OFF gets the
feature's user arg - never a deleted check, never the feature turned back on in GAME_ON.

## Prior research
LOOP1_SCOPE_S237.md, LOOP1_VERDICT_S238.md (the keep/off table), CLAUDE.md s10 (switches; tests are the OFF control arm), TASK_SPARWIRE1.md
(your last wiring round - same repo conventions).

## What would a human do?
Tape over the switches on the panel you are not using today, label each tape, leave the wiring in the wall.

## Prefab check
None - our own switch table.
