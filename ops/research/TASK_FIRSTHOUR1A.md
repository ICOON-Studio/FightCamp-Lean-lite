# TASK FIRSTHOUR1A (S222) - the reveal schedule: every mechanic ON, introduced one at a time over weeks 1-4 (pure module + data + test)

Model: Goose (cloud, label `goose`). Repo ICOON-Studio/FightCamp, branch `goose/issue-<n>` from master. Open a PR, never merge.
No LFS-loading code or tests. Do not delete or shorten any existing test. Touch only the owned files.
APPROVED: operator board Q-S221-2 "Approve, build it" on `research/K86_FIRSTHOUR_VERDICT_S222.md` - read it WHOLE, and
`research/K86_KALLI_REPLY.md` (Kalli's minute table, the week 2-4 list, the 8 confusion fixes, the 12 "how" lines).
Operator rule (S221): every built feature stays ON - this module never switches a mechanic off; it only says WHEN the game starts
TALKING about it (its card, its meter, its first tooltip).

## Prior research
`Godot/scripts/FirstHour.gd` (86 lines) + `Godot/assets/data/first_hour.json` (Ludo's 16 beats, S190) + `tests/first_hour_test.gd`:
the pattern to copy (pure static RefCounted, JSON table, cached). `Godot/scripts/GameSwitches.gd` GAME_ON lists the switch names.

## What would a human do?
Football Manager / RimWorld drip-feed systems: each system's first card appears the first time it matters, never two in the same beat.

## Prefab check
None - a data table + a pure lookup in the repo's own pattern.

## Owned files
- NEW `Godot/assets/data/reveal_schedule.json`: `{"mechanics": [{id, switch (GameSwitches key or ""), reveal_week, trigger (flag name or ""),
  before ("grey_meter" | "card_waits" | "silent"), grey_text, first_tip (<= 14 words)}]}` covering at least: station_wear (week 2,
  trigger first_station_band_drop), club_capacity (week 2), candidate_card_v2 (week 2), stress (week 2, grey "Fills after week 1"),
  career_wear (week 1 review), area_wear / zone moving in the gym (week 3), open_spar_night (week 3), sandbox_parity quick money
  (week 4; never in story mode before chapter_1_end), debt decision (trigger cash_below_zero_2_weeks + a warning card one week before),
  corner_cutman + corner_doctor (fight 1: only on cut / knockdown), skip_drawer (merged into the day clock), pad_chains/technique stages.
- NEW `Godot/scripts/RevealSchedule.gd` (pure static, no autoload/preload/RNG/nodes; < 200 lines):
  `entry(id) -> Dictionary`, `is_revealed(id, state) -> bool` where state = {week:int, flags:Dictionary, story_mode:bool},
  `newly_revealed(state_before, state_after) -> Array` (ids that turn on between two states, ordered, at most ONE per week tick - the
  rest queue to the next tick: "never two in the same beat"), `before_mode(id)`, `grey_text(id)`, `first_tip(id)`.
- NEW `Godot/assets/data/tutorial_how_lines.json`: Kalli's 12 lines verbatim, each with an `anchor` (screen + element id the line
  points at, e.g. "office:desk", "locker:fighter_card", "floor:station", "timeline:clock").
- NEW `Godot/tests/reveal_schedule_test.gd`.

## Acceptance - `reveal_schedule_test.gd`
(a) every `switch` named in the JSON exists in GameSwitches.GAME_ON (read the file as text, no autoload); (b) week 1, no flags: none of
the week-2+ ids revealed; (c) week 2 + first_station_band_drop: station_wear revealed; (d) story_mode true, week 6, no chapter_1_end:
quick money NOT revealed; (e) cash below zero 1 week -> only the warning; 2 weeks -> the debt decision; (f) newly_revealed from week 1 to
week 3 in one jump returns them in order and the queue rule holds (one per tick); (g) 12 how lines, each <= 14 words, each with an
anchor; every first_tip <= 14 words. `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/reveal_schedule_test.gd`
exits 0, prints `REVEAL PASS checks=<n>`. Parse gate: `python Godot/tools/check_scripts.py <touched .gd>`. CI green on your branch.

## The one trap
This is a schedule of WHEN the game explains things, not a feature switch: do not touch GameSwitches.gd and do not make any
`GameSwitches.on()` depend on it.
