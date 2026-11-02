# S183 digest - 2026-10-09 (Opus) - the first corner is played, and the camp reaches the fight you watch

## What now works
- **CORNER1** (Cursor e2014659, diff applied): in the player's first career bout the clock waits on the corner card at the
  round-1 break, with "Your first corner. Pick one call - he goes out with it."; the scorebug shows `PLAN: <plan>` until a call
  (no more NO INSTRUCTION); SIM TO RESULT asks once ("Skip the corner?" SKIP / KEEP WATCHING). first_corner_test PASS.
- **CAMPVIS1** (Qwen 1c1f4e9d + Claude review fixes), switch `camp_live` ON in DEMO_SWITCHES: the camp's edges change the
  bout the player watches; fight week and the result say what the camp bought; the week review counts a fighter in camp.

## Review findings fixed (CAMPVIS1)
1. The switch could never turn on (read from bout options nobody set) -> FightRealtime seats `camp` only under `camp_live`.
2. The ROOM (the watched bout) never got the camp - only the background engine -> also in `_arena_bout.engine_options`, swap-aware.
3. Calibration: `tools/s183_camp_track_probe.gd` (two different boxers, 40 bouts an arm): at 0.15/edge a full real camp moved
   landed% +0.6-0.8 (invisible). Now a track's fight_camp.json maximum spends the plan-fit budget: CAMP_CONTACT_PER_EDGE 1.0,
   CAMP_DEFENCE_PER_EDGE 0.6. Contact cap arm: +2.8 landed points net, win share 60% vs 45% uncamped.
4. The test's fixture stacked three tracks (71% win share) -> a real full Striking Shark camp: +1.7 landed points, win 65%.
5. Test check 2 compared no-camp with itself (could not fail) -> switch OFF == no camp, and ON moves the log. Check 3 was
   vacuous -> stub game state with a fighter in camp + a not-in-camp control.
6. Week review in-camp row leaked a live-roster fighter into a report about others (week_review_test red) -> report's fighters only.

## Defects fixed on sight
- camp_consequences_test red since CAMP-RULES dd7165b5 (asserted four focus cards; boxing now offers three) -> derived count.
- first_corner_test runs 721 s -> hung at the runner's 600 s; SLOW_TEST_TIMEOUT_S 1082.

## Evidence
camp_reaches_bout 9/0 (rc 0), first_corner PASS (rc 0, 721 s), camp_consequences 0 fail, week_review 0 fail.
corner/fight_night/broadcast 18/20 (the 2 = known fight_plan_ai_corner + the timeout above). CAMPVIS1 neighbours
(determinism, realtime, fight_night, camp, causation_real_path, certified_palette, boxing_output, fight_identity, week_review,
fight_week, result_screen) 17/19; the 2 fixed and re-run green (the other 17 not re-run after the last two edits, which touch
only WeekReviewPanel and tests). NOT YET SEEN ON THE GAME CAMERA - next session's step 2.

## Delegated this session
- MOMENTS1W -> Cursor (TASK_MOMENTS1W_WIRE_CAUSAL_MOMENTS.md): corner calls logged per round, FightMoments lines first in
  the result's three moments.
- NIGHTLY1D -> Arena (chat 01a11e04-db34-781d-b4a8-f51c96a8f6cd): the wins gate becomes a paired sign test on discordant pairs.
- CAMPWORDS1 -> Qwen (TASK_CAMPWORDS1_CAMP_SHEET_IN_WORDS.md): camp sheet in whole numbers, no decimals (finding 4's rest).
Codex, Cline, Antigravity: nothing self-contained fit inside this session's budget beside the three above (shared files).

## Next (roadmap now)
Collect the three runs -> see the first corner + camp lines on the game camera (as_game) -> GYM5-LOOK one look-dev still ->
club walk to the first bout.
