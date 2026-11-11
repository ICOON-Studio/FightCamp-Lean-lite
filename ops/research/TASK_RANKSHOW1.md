# TASK RANKSHOW1 - QWEN (qwen3-coder) - the rank a fight earned, as a pure line the result, the Why and the news can show

Status: OPEN (S428, Claude main). Discipline: boxing. Model: qwen3-coder.
Source: operator S428 "every fight should display the rank earned the rankings" (scope: ops/research/SCOPE_FOUR_FIGHTERS_S428.md).
What exists: Region.rankings(c, div) (net wins, then wins, then rating; our amateurs enter at RANK_MIN_WINS 4), Region.update_rank
(f["rank"], news "ranking_in" / "ranking_up"), BoutRead.rank_move(rows, f, opp_name, order, min_wins) -> {now, win, loss, need} which the BOUT
PAGE (BoutCompare.read_card) shows BEFORE the fight. What is missing: the rank line AFTER the fight (result screen, the Why, the fighter's
page) and a line that works for every fighter, including one still unranked ("2 wins from entering the rankings"), a fall, and a pass of named
fighters. This task is the pure rule and its tests only (the screens are a later Cursor task).

## Contract
OWNS: scripts/rules/RankLine.gd, tests/rank_line_test.gd
RED_TEST: tests/rank_line_test.gd -> RANK_LINE failures=0
REGRESSION: bout_read_test
VISUAL: no

## The job
1. Read scripts/state/Region.gd lines 160-200 (rankings, before, our_rank, update_rank), scripts/rules/BoutRead.gd 470-500 (rank_move, _after,
   rank_of) and tests/bout_read_test.gd (how rows are built). RankLine takes ROWS (arrays of {name, w, l, rating, ours, fid}) and dictionaries, never
   a Career: it has no preload of Region or any state class (a pure module with zero preloads except BoutRead if you need rank_of).
2. `RankLine.after(rows_before: Array, rows_after: Array, name: String, min_wins: int) -> Dictionary` returns
   {was: int (0 = unranked), now: int, moved: int (was - now when both ranked, else 0), entered: bool, left: bool, passed: Array[String] (the names
   she moved above), need: int (wins still needed to enter, 0 when ranked), words: String}.
   `words` is plain game English, no jargon: "Now number 3, up from 5; she passed Dana Mills and Rosa Pike." / "Enters the rankings at number 8." / "Down
   to number 6 from 4." / "Unranked: 2 wins from entering." / "Still number 3." (no word "delta", no symbols).
3. `RankLine.before(rows, name, min_wins) -> {now, need, words}` for the fight card: "Number 5. A win could move her to 3." is NOT in scope (that is
   BoutRead.rank_move); only "Number 5" / "Unranked: 2 wins from entering".
4. tests/rank_line_test.gd (write it first, red): enters at exactly min_wins; climbs and names the passed fighters in order; falls when she loses and
   another passes her; unranked with 0, 1, 3 wins gives the right `need`; a rival below her who wins does not move her; two rows equal on net wins
   and wins split on rating; the words contain no digits other than the ranks and counts; determinism (same input, same output). At least 12 asserts.
   Print `RANK_LINE failures=<n>`.

## Prior research
Region.gd, BoutRead.gd, tests/bout_read_test.gd, ops/research/GDSCRIPT_TRAPS.md (read it: Variant `:=`, reused names).

## What would a human do?
A boxing page prints "Now number 3 (up from 5)" under the result and names who she overtook; an unranked prospect sees how many wins she needs.

## Prefab check
No asset or library applies.

Every Godot job through the queue: `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path .
--script res://tests/rank_line_test.gd` (the plain win64 exe, never the console one). Parse first: `--check-only` on both files.
Stay under 500 lines a script. RESULT lines for the PR body: `RESULT: tests/rank_line_test.gd -> RANK_LINE failures=0`.
