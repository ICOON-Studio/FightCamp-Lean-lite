# S434 digest (2026-11-11)

## Landed on main (pushed)
- Main's red tests: week_actual_test (since REST1 a rest morning lifts Cardio; WeekPlan._attr_to_old now projects it),
  week_plan_test (the 15% bar reads the five roadwork mornings; the rest mornings checked on their own), head_coach_test
  (red, not in the CI list: its fighter made weight either way; she now starts 4 kg over; joins run_tests.sh).
  guard_knee_test (red since HUMANFIGHT1's stepping route: rear knees bow out -0.068 v +0.029) -> HUMANFIGHT2B's brief.
- Collected after a blind reviewer + skeptic workflow (ops/tmp_s434/collect_review*.jsonl):
  STANDDOWN1 (Antigravity, PR 204), CEIL14 (Qwen, PR 205, test fixes), DUESWIRE1 (Cursor, PR 206: honest junior news,
  the card keeps the roll's dues and odds, the second coach's odds, real days, golden step moved to
  tests/golden_dues_step.gd on the game's day step; golden_path awaits _play() again), KNOWN0 (Qwen, PR 207, test fixes).
- The stand-down wired (F6): Injuries.after_bout sets it, PadWeek.stood_down rests the locked sparring nights, the news
  says "no sparring until <day>: the head took N damage". tests/stand_down_wire_test.gd walks it on Sim.step_day.
- PROTABLES1 (his Q-187): eight pro tables. The 6.3% red was seed luck: probe 8 seeds x 20 years, every table 0.8-1.2%
  a year, the old four alone reach 7.4% on seeds 1-3 (ops/research/PROTABLES1_INVERSIONS_S434.md). world_years reads
  the spread (a table's mean < 3%, no year > 10%, <= 5% of table-years > 5%); retirements per table.
- CI time limit 24 -> 32 min (KNOWN0's run was cancelled at 24 with no failure).
- CALLSPREAD1 briefed (F15, Qwen; dispatch after the foundation lands).
- A Qwen re-run of DUESSUMS1 (S431 Goose work) stopped; the brief and the queue entry closed.
- Build 18:16 exported, smoke-run 300 frames clean; WHAT_TO_TRY current.

## In flight at handover
- Workflow wf_91da691c-70b (foundation fixes): rebased claude/foundation-s433 onto main (360ddf39 CARDIO1, b310627c NOCAMP1,
  cc81f972 PUNCHSTART1; no conflicts, 8 tests green); then fix + skeptic per item from ops/tmp_s434/foundation_reviews.json.
  It dies with the session; its commits stay on the branch. Script:
  C:\Users\user\.claude\projects\E--FightCamp-Lean\cc06cf94-1b7f-4ff3-ac8d-fa7ac72dd524\workflows\scripts\foundation-fixes-s434-wf_91da691c-70b.js
- Seats: HUMANFIGHT2B (Cursor, the animation item, with the guard knee), DUESSUMS3B (Antigravity), CORNERFACE2 (Qwen).

## His words
- Q-189 "Yes, delete them" (acted on in S433).
- The paid seat: he asked what it is, proposed "gym sponsorship ... link it to external sponsors?", then said a local
  sponsor paying the boxer is "not the correct approach". Asked again as Q-190 (sponsors back the gym and the gym
  sponsors a boxer / just rename / something else). The seat was scored only inside the Club week map (7, 7), never alone.

## Traps
- `sed -n 32p` after inserting a line: the target moved; check the edit landed (golden_path `_play()` was not awaited and
  the dues step's checks never ran while the test printed failures=0).
- A comment inside a call's parentheses is a parse error that shows up as "could not preload" in every reader.
- The dispatcher relaunches a brief whose Status still says OPEN when the earlier run was on another seat's branch name
  (goose/...): close the brief when its work is read.
- Miro P0: the frame cannot shrink while the 14 surplus slots stay (deleting needs his OK); the cards update fine.
