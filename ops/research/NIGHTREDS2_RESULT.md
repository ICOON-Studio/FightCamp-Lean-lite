# NIGHTREDS2 RESULT - the three red tests of the 05:00 run of 2026-11-25 (S559)

Worker: Claude Opus 5.5, console. Main checkout, headless through godot_slot, one Godot at a time, watchdog GREEN before each run.

## 1. tests/dues_card_test.gd - already fixed on main, green now
- FAIL (nightly, commit e8a291540): "cheap/standard/premium stays inside the board (174,332 412x600 vs 174,217 1286x704)" x3.
- Cause: the test measured the dues board BEFORE the Dues tab opened it (the books page's height then); S547 shortened a books
  row, so the closed board was 11 px short of the cards. Fixed on main after the nightly by b27e77b6f (S555): the board is
  measured after it opens, and the open board must also fit the office window (HostScroll), which is the check that would catch a
  cut card. That makes the check stricter, not looser.
- Now: `DUES_CARD failures=0` (cards 412-413 x 600, gaps 24.0), exit 0.

## 2. tests/ring_steps_test.gd - already fixed on main, green now
- FAIL: "DB every played take has its feet table (without one: [\"pro_body_cross\"])".
- Cause: BODYCROSS4 (075844273) made pro_body_cross a played take without a row in assets/data/foot_db.json. Fixed after the
  nightly by 9c85d3490 (nightly review 11-25: pro_body_cross gets its feet table).
- Now: `RINGSTEPS failures=0`, exit 0.

## 3. tests/matchmaking_bots_test.gd - fixed here (the bot's taste, plus the instrument)
- FAIL (nightly): "scouting is worth it: fewer stoppage losses than blind (+0.03)" (smart 0.83, blind 0.81 stoppages a career).
  Red since S535 DMGCLASS2 (68067e0ba, NIGHTREDS1_RESULT): pro world bouts no longer stop at four counts. That rule is right
  and is not touched (nothing under scripts/ changed).
- Instrument fault found first: the numbers depended on run order. WorldBout.cached keeps the first rows a pair was read at
  (within CACHE_DRIFT), and BoutRead keys by stat bucket, so each bot inherited the caches of the bots run before it. Same
  seeds, same blind code: blind read 0.81 (nightly), 0.97 (probe, smart then blind), 0.86 (probe with only smart's taste
  changed). Smart minus blind read +0.14, +0.03, -0.02, +0.00. The control arm shared the change.
  Fix: `_run` empties `WorldBout._cache` and calls `BoutRead.clear_cache()` before each bot. Every bot now starts from
  the same state, and blind printed 0.82 in every later run.
- Cause (clean caches, 120 careers, per-bout rows from tools/matchbots2_probe.gd):
  | | bouts v top-power third | read shown | won | stopped per bout |
  |---|---|---|---|---|
  | blind | 375 | 0.70 | 0.54 | 15.2% |
  | smart, scouted | 297 | 0.55 | 0.60 | 14.1% |
  | smart, signed UNSCOUTED | 126 | 0.71 | 0.44 | 23.8% |
  The scouted read is not overconfident. The smart bot spent its two looks a pick (SCOUTS_PER_PICK) walking down the list,
  turned those down, then signed the next option on the level read. Those blind signings against punchers are where the extra
  stoppages come from (0.93 smart against 0.82 blind, clean). In one sentence: the scout signed fights it had not scouted.
- Change (tests/matchmaking_bots_test.gd `_smart`, `sign_look := true`): the scouting bot also scouts the fight it is about to
  sign, when it can afford it (money >= 3 x SCOUT_COST, the same rule as its other looks). This is what the file's header has
  always said ("scouting the fight it is about to take"), and the PLAYER can do it: every pro offer row has Scout ($250)
  and a "Stopped: N% chance" line from the read (scripts/ui/ProFights.gd:224). No bar or margin was changed.
- Tried and dropped: reading a scouted opponent whose stop line is red (>= 15%) as 0 or 2.5 points harder. Stoppages went 0.92 /
  0.86 (still above blind 0.82), and top-10 finishes fell from 41 to 33 / 24 (scouting's +5 bar would fail). Red covers about a
  third of the fights, so the rule blocked the climb instead of the punchers.
- Before / after (the test, all four bots):
  | | smart place | smart top-10 | smart stopped | blind stopped | scouting top-10 | scouting stops | failures |
  |---|---|---|---|---|---|---|---|
  | nightly 11-25 | 12.0 | 46 | 0.83 | 0.81 | +16 | +0.03 | 1 |
  | after (run 1 = run 2) | 11.0 | 46 | 0.79 | 0.82 | +17 | -0.03 | 0 |
  Other bars after: smart beats easy by 7.5, beats hard by +2.0 (hard 13.0), rating +7.9 v easy +6.5.
- Read honestly: the stoppage margin is thin (-0.03 a career = 4 stoppages in 120 careers). It passes because it is now
  deterministic, not because it has room. Gym money: scouting costs $3,145 a career against blind (was $2,703).
- Run time 740-831 s (was 567 s): each bot now rebuilds its own bout caches.
- RESULT: tests/matchmaking_bots_test.gd -> MATCHMAKING_BOTS failures=0 (twice, identical lines)

## Files (OWNS)
- tests/matchmaking_bots_test.gd: the cache reset, `sign_look`, and the S548 MATCHBOTS2 probe hooks (careers / bout_fn /
  on_bout / last_read), which were left on disk uncommitted by the MATCHBOTS2 worker that died in the PC restart. They are
  adopted and committed here: with nothing set, the test runs as written.
- tools/matchbots2_probe.gd (+ .uid): the same dead worker's probe, adopted; `look=0` brings back the bot before this fix.
- ops/research/NIGHTREDS2_RESULT.md.
No other test imports the bot test (only the probe preloads it). Nothing under scripts/ changed.

## For the session
- MATCHBOTS2 (live_runs.json, "queued") is covered by this: its step 0-3 are answered here. Mark it done, don't relaunch it.
  live_runs.json was not edited: it is a shared file with other open edits.
- Same caveat as NIGHTREDS1: other bot or probe tests that run several arms in one process share the WorldBout and BoutRead
  caches the same way (see memory reference-boutread-cache-run-order).
