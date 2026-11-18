# S518 digest (2026-11-18, Opus, main line)

Owner at start (weekly usage 90%): "work normally do not worry about the 10%".

## Shipped
- R9 rival gym offer checked on the real screens (tools/rival_offer_still.gd, ops/previews/s518): reads right.
- R6 hot streak + DUCKED / OWED: scripts/state/HotStreak.gd (won the last 3 AND +15 ladder points in 8 weeks; c.results
  rows carry "pts" from BoutFinish). AskLadder feeds yes_score (-20 from a corner 0-8 points above). AskFlow.book: a No
  then = DUCKED (once a week), two inside 8 weeks = OWED (score 95 = Yes; booking clears). AskPanel: the run line once
  under the title, the DUCKED / OWED chip on the card; a Yes despite the run says "they take it even with your boxer on
  a run". tests/hot_streak_test.gd (19 checks, nightly list). Still tools/duck_still.gd (review board).
- Goose critics collected by hand (PRs failed to open): guard damage v3 7/6/5 (below 7 -> v4 after John SQ221), club
  week v11 7/8/6 (passes Goose; John SQ222 pending).
- LADDERPROBE4 launched on Qwen (qwen/ladderprobe4): rival calls a season by answer policy.

## Evidence
hot_streak, ladder_table, ask_wire, ask_bout, ask_dates, rival_offer_wire, golden_path green. Exported Builds/FightCamp.exe.

## Delegated
Qwen LADDERPROBE4 (running). John SQ221/SQ222 (queued since S517).

## Next
Collect LADDERPROBE4; John's answers -> guard v4 (Dola) / club week v11 to the board at 7+/7+; his mat plan note.
