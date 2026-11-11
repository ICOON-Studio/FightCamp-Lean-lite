# TASK RANKSHOWUI - CURSOR (Grok 4.7 High) - the rank a fight earned, shown in the Why and on the fighter's page

Status: OPEN (S437, Claude main). Discipline: boxing. Model: grok-4.7-high.
Source: operator S428 "every fight should display the rank earned the rankings" (ops/research/SCOPE_FOUR_FIGHTERS_S428.md).
The result page already shows it as a tile (rules/Aftermath.rank, fed by state/AfterFight "rank_words"). Two places a
player looks next still say nothing: the WHY panel under the result, and the fighter's own page, where an unranked
boxer shows no rank line at all (ui/FighterCard.gd line 32 prints a chip only when f["rank"] > 0). You cannot see
pictures: work from the node names and the numbers below, and print the numbers asked for.

## Contract
OWNS: scripts/ui/WhyCard.gd, scripts/ui/FighterCard.gd, scripts/ui/RankRow.gd, scripts/state/AfterFight.gd, scripts/ui/modals/FightNight.gd, tests/rank_show_ui_test.gd, docs/RANKSHOWUI_RESULT.md
RED_TEST: tests/rank_show_ui_test.gd -> RANK_SHOW_UI failures=0
REGRESSION: rank_line_test, fight_why_test, fight_stats_test, bout_read_test, file_limits_test, no_pronoun_test
VISUAL: yes
NOT YOURS: scripts/rules/RankLine.gd, scripts/rules/Aftermath.gd, scripts/state/Region.gd (read them; do not edit), every other screen.

## What exists (read these first)
- scripts/rules/RankLine.gd (144 lines, pure): `after(rows_before, rows_after, name, min_wins)` -> {was, now, moved,
  entered, left, passed, need, words}; `before(rows, name, min_wins)` -> {now, need, words} ("Number 5." /
  "Unranked: 2 wins from entering.").
- scripts/state/AfterFight.gd (96 lines): `_rows(c, f)` builds her division's rows; line 52 puts
  `facts["rank_words"]` for amateurs only (a pro is off the amateur table).
- scripts/ui/WhyCard.gd (29 lines): `build(rounds, first, opp)` -> rows YOUR PLAN / AGAINST YOU / NEXT, called once from
  scripts/ui/modals/FightNight.gd line 314.
- scripts/ui/FighterCard.gd: the gold chip "#N IN THE REGION" at line 32.
- scripts/state/Region.gd: RANK_MIN_WINS (4), `rankings(c, div)`.

## The job
1. tests/rank_show_ui_test.gd FIRST, red on main. It builds the real nodes headless (no picture needed) and reads them:
   a. WhyCard with rank words "Now number 3, up from 5; she passed Dana Mills." has a node named "WhyRank" whose text
      holds those words; with empty rank words there is NO "WhyRank" node (a pro, or no table).
   b. FighterCard for an amateur with 1 win, unranked: a node named "RankRow" whose text is RankLine.before's words
      for her ("Unranked: 3 wins from entering."). For a ranked amateur (rank 3): "RankRow" reads "Number 3." and the
      gold chip is still there. For a pro: no "RankRow".
   c. The words on the card equal RankLine.before(...)["words"] for the same rows: the card computes nothing itself.
   d. A real path: play one amateur bout to the result with the helpers tests/fight_why_test.gd or
      tests/first_hour_walk_test.gd already use, and assert the result modal holds "WhyRank" with the same words as the
      rank tile's first line. Print `RANK_SHOW_UI failures=<n>` and at least 10 asserts.
2. scripts/state/AfterFight.gd: make the rank words reachable for the Why (a small `rank_words(c, f, before)` or return
   them beside the tiles); the rows helper `_rows` becomes callable from the fighter card (rename to `rows`, keep the
   old call sites working). No new sums.
3. scripts/ui/WhyCard.gd: `build` takes the rank words as an optional last argument (default ""); when not empty, a
   fourth row with the head "RANKING" and the words, named "WhyRank", same fonts and colours as the other rows
   (UI.caps head 150 wide, UI.label body). FightNight.gd line 314 passes the words. Nothing else in FightNight changes.
4. scripts/ui/RankRow.gd (new, small): `build(c, f) -> Control` or null. Amateur: one line, name "RankRow", the words
   of RankLine.before on AfterFight's rows. Pro: null. FighterCard adds it under the top chips row.
   Words come from RankLine only (plain game English, no "delta", no symbols, never the word "Engine").
5. docs/RANKSHOWUI_RESULT.md: what you changed, the test's last line, and the exact text each of the three cases
   printed (copy from the test output).

## Traps
- ops/research/GDSCRIPT_TRAPS.md first (Variant `:=`, reused names, Label sizing).
- A test that only builds your own new function is not enough (S420): 1d must go through the game's result path.
- FighterCard is used on the Fighters page AND the fighter's page; the row must not push the card past its box: keep
  it ONE line (autowrap off, clip_text on) and print its minimum width in the result file.
- tests are the OFF control arm; do not add a GameSwitch (the feature is simply on).

## Prior research
ops/research/TASK_RANKSHOW1.md (the pure module's brief), SCOPE_FOUR_FIGHTERS_S428.md, tests/rank_line_test.gd.

## What would a human do?
A boxing result page prints "Now number 3 (up from 5)" where the story of the fight is told, and a prospect's own
page always says where she stands: a number, or how many wins from a number.

## Prefab check
No asset or library applies.

Every Godot job through the queue: `python ops/Tools/godot_slot.py run --who cursor -- <godot.exe> --headless
--audio-driver Dummy --path . --script res://tests/rank_show_ui_test.gd` (the plain win64 exe, never the console one).
Parse first: `--check-only` on each touched file. Under 500 lines a script. Nothing opens on a monitor.
RESULT lines for the PR body: `RESULT: tests/rank_show_ui_test.gd -> RANK_SHOW_UI failures=0`.
