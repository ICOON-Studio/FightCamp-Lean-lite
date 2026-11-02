# TASK FIRSTHOUR1B (S222) - wire the reveal schedule into the game: one "NEW" card per week, grey meters before their week, the 12 how lines in the guide

Model: cloud Cursor (label `cursor`). Repo ICOON-Studio/FightCamp, branch `cursor/issue-<n>` from master. Open a PR, never merge.
No Git LFS on the cloud box: tests must not load models. Do not delete or shorten any existing test. New features ship ON (operator S221).
APPROVED: operator board Q-S221-2 "Approve, build it" on `research/K86_FIRSTHOUR_VERDICT_S222.md` (read it whole).
Built already (S222, merged): `Godot/scripts/RevealSchedule.gd` (pure; `is_revealed`, `newly_revealed`, `next_to_announce(state,
announced)`, `before_mode`, `grey_text`, `first_tip`, `how_lines`) + `assets/data/reveal_schedule.json` + `assets/data/tutorial_how_lines.json`
+ `tests/reveal_schedule_test.gd`. Every mechanic stays ON; this only decides when the game TALKS about it.

## Prior research
- The guide: `Godot/scripts/TutorialGuide.gd` (pure read of facts + state) + `GameState.get_tutorial_read` (~line 18411), `tutorial_note`,
  `tutorial_ack_step`; drawn by `Godot/scripts/GuideCard.gd` (229 lines, docked bottom-right, one step at a time). Use THIS guide - do not
  add a third tutorial system (CoachMarks.gd is the older S78 one; FirstHour.gd is unused data).
- The week tick: `GameState.advance_week()` (~line 8229; GameState is 20,000+ lines - NEVER read whole, grep + read +-40 lines).

## Owned files
1. `GameState.gd` - ONE block marked `# --- FIRSTHOUR1B reveal`: `reveal_state() -> {week, flags, story_mode}` built from the career
   (week number; flags: first_station_band_drop when any station first drops a band, cash_below_zero_1_week / _2_weeks from the weekly cash
   history, chapter_1_end, fight_1_cut / fight_1_knockdown from the first bout's result); at the end of `advance_week` (and after the first
   bout) call `RevealSchedule.next_to_announce(reveal_state(), career["reveal_announced"])` and, if not "", append it and queue a
   "NEW" card `{id, title, first_tip}` in `career["reveal_queue"]`. `get_reveal_card() -> Dictionary` / `ack_reveal_card(id)`.
   Old saves without the keys: everything already past its week counts as announced (no flood of cards on load).
2. `GuideCard.gd` - when `get_reveal_card()` is not empty it shows that card first (same plate, gold "NEW" tag, the first_tip line,
   GOT IT = ack), then the guide's normal step.
3. Grey meters: the fighter profile's STRESS and CAREER WEAR bars (grep `STRESSHDR1` / `career_wear` in the profile scripts) draw grey
   with `RevealSchedule.grey_text(id)` while `before_mode == "grey_meter"` and the id is not yet revealed; the numbers still run.
4. How lines: `TutorialGuide.gd` reads each step's "how" line from `tutorial_how_lines.json` by anchor where one matches the step's screen
   (keep the step's own line when none matches). List in the PR which of the 12 lines landed on which step.
5. NEW `Godot/tests/reveal_wiring_test.gd`.

## Acceptance - `reveal_wiring_test.gd`
(a) new story career, week 1: no reveal card; profile stress bar is grey with the grey text; (b) tick to week 2 with a station band drop:
exactly ONE card, then after ack and another tick the next one (never two at once); (c) cash below zero two weeks running: the warning card
came a week before the debt decision; (d) an old save at week 6 loads with no backlog of cards; (e) `GameSwitches.on()` results are identical
before and after (the schedule never switches anything off); (f) the guide still passes `tests/` that cover TutorialGuide / GuideCard
(grep them and run them). Parse gate `python Godot/tools/check_scripts.py <touched .gd>`.

## The one trap
`advance_week` returns early for a due bout or a blocking decision - queue the reveal only on a week that actually advanced, or the same
card is queued twice.
