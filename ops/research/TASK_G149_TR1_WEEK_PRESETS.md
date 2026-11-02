# TASK G149 - TR1: a training week in one click (Grok, S133)

Model: the Grok Build CLI default (`Tools/grok_task.ps1`). Worktree `D:/FightCamp/wt/G148` re-branched to
`grok/g149-week-presets` from master (your own worktree from G148, already merged).

## Why
Dola's strict review D66 (`research/D66_STRICT_REVIEW.md`, weakness 4, screenshot 21_program): "Training calendar
is passive - all days OFF; no quick-set templates ... setting up a week feels like tedious data entry". Operator
2026-09-30: "assign someone to add those features from dolas report". Roadmap backlog TR1: "one-click week presets +
copy a day; setting a week takes <= 3 clicks". Cursor (U201) and Qwen (Q219) are doing the other D66 items - do not
touch their screens.

## Prior research (read first)
- `research/topics/ui_screens.md` (canonical) and `topics/training*.md` if present; `D66_STRICT_REVIEW.md`;
  `G133_TUNING_LOOPS_AND_THE_CORNER_CLOCK.md` (Football Manager training intensity). `python Tools/prior_research.py
  training week program preset schedule`.

## What would a human do?
A Football Manager UI designer: a row of preset buttons above the week (BALANCED, POWER, CONDITIONING, TECHNIQUE,
RECOVERY) that fills all seven days in one click using the same write the day editor already uses, then the player
tweaks single days. Rest days are part of every preset.

## Prefab check
The write path EXISTS - reuse it, invent nothing: `TrainingHubPanel.gd` (1077 lines) `_write(focus, station_id)` (:915)
calls `GameState.set_week_program_day(athlete_id, day, focus, station_id)`; `clear_week_program(athlete_id)` exists
(:891); a day already offers its foci with stations through `_impact(focus)` (:676) / the day drawer's options
(`_build_session` :402). Copy/paste of one day exists (`_on_copy` :869, `_on_paste` :885).

## The work
1. NEW `Godot/assets/data/week_presets.json`: 4-5 presets, each seven entries (Mon..Sun) of a focus id or "rest".
   Use ONLY focus ids the game already offers (read them from the day options / GameState; grep, never invent), and at
   least one rest day in every preset. Name and one-line purpose per preset.
2. `TrainingHubPanel.gd`: a preset strip on the week view (near the filters, `_build_week` :190) - one click applies
   the preset to the SELECTED fighter's whole week through `set_week_program_day` day by day (station from the same
   `_impact` lookup the drawer uses; a focus the fighter cannot train that day is skipped and named on the status
   line - never forced). Each preset button carries a hover (`UIKit.tip(node, "text")`) with its purpose. An
   "APPLY TO ALL SHOWN" action is optional; if you add it, it runs the same per-fighter path.
3. Keep every existing refusal: `_apply()` (:922) and `OWNED_WEEK_REFUSALS` (a camp or recovery that owns the week
   must still refuse).

## Owned files (edit ONLY these; anything else = send-back)
- `Godot/scripts/TrainingHubPanel.gd` - `_build_week` and helpers you add at the end of the file.
- NEW: `Godot/assets/data/week_presets.json`, `Godot/tests/week_presets_test.gd`, `previews/g149/*`,
  `research/G149_DIGEST.md`.
- Do NOT edit `GameState.gd`, `UIKit.gd`, `ProfileRevampPanel.gd` or any other screen (other agents are in them).

## Parse gate (before any test)
`python Godot/tools/check_scripts.py Godot/scripts/TrainingHubPanel.gd`

## Test (tier: one script edited + a new test)
One: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe" --headless --path Godot --script tests/week_presets_test.gd`
Your test: every preset's foci exist in the game's options; applying a preset through the panel (`press_for_test` /
the panel's own test hooks at :1023-1068 show the pattern) fills all seven days of the selected fighter with the
preset (rest days rest); a fighter whose week is owned by a camp is refused, unchanged. Then:
`python Godot/tools/run_tests.py --jobs 2 --only training_hub,week_program,discipline_program,week_presets`
(never serial; wait on the runner's exit).

## Evidence
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/s64_career_walk.gd -- plan=research/s117_boxer_walk.plan out=docs/previews/g149 as_game`
Open `21_program` (or the program shot) - the preset strip reads cleanly, nothing overlaps.

## Acceptance
1. One click sets a whole week (<= 3 clicks from the training screen to a full week); test green.
2. All listed tests green.
3. Branch pushed; explicit `git add` by path (never `git add .`, never `Godot/.godot`); 10-line `G149_DIGEST.md`.

## The one trap
Presets must use foci the game really offers - a made-up focus id silently writes nothing (or a refusal). Read the ids
from the game, and prove it in the test.
