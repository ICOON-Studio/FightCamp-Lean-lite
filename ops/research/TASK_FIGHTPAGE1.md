# TASK FIGHTPAGE1 - the FIGHT ANALYSIS page, film-night mode (their tape): punches list, report, mark a pattern

Status: OPEN (S495, Claude main). Discipline: boxing. Model: Grok Dev (`python ops/Tools/gbot.py send --to dev --file ...`).
Repo ICOON-Studio/FightCamp-Lean, branch `grok/fightpage1` from main, PR into main, never merge.

## Why now
The owner approved the page (board Q-S294-256, "Yes, build it"). The approved look is the mockup
`docs/mockups/s495/fight_analysis/fight_analysis_v3.png` (its HTML beside it, `fight_analysis_v3.html` - read both: the
HTML gives the exact words, sizes and colours). Map: `ops/research/FIGHTFILM1_MAP_V3_S495.md` sections 2.1 and 2.2 (read
them whole). The rule modules are on main and tested: `scripts/rules/FightLog.gd` (lines, words, filter, count_line,
seen_count), `scripts/rules/FilmBout.gd` (a past bout: exchanges with beats, clean_counts, mode_counts),
`scripts/rules/FilmPattern.gd` (claims, word_text, figure, report_game, report_weapon, checks). This task builds the SCREEN
for a film night only. Claude wires it into the fight week, adds the 3D film into the left panel and the "your bout" mode.

## What to build (each file under 500 lines; plain Control scripts built in code, like scripts/ui/TapeRoom.gd)
- `scripts/ui/FightAnalysis.gd` - `extends Control`, the page: wood frame + slate cards (WoodKit.slate / UI.card - read
  scripts/ui/UI.gd and scripts/ui/WoodKit.gd), header, the four panels, the state.
- `scripts/ui/FightAnalysisList.gd` - THE PUNCHES panel (SHOW ME pickers, count line, the list with 30 s dividers).
- `scripts/ui/FightAnalysisReport.gd` - THE REPORT panel (tabs, bars, games, combinations, three number sentences).
- `tests/fight_analysis_test.gd` - headless test (below).

### Entry point
```
var p = FightAnalysis.new()
p.for_tape(opp: Dictionary, films: Array, night: Dictionary, on_check: Callable, on_file: Callable, on_done: Callable)
parent.add_child(p)
```
- `opp`: the opponent dict (name, sex "f"/"m", style, threat, weak, habits). `films`: FilmBout.build outputs (1-4), in
  order; each also carries `row` (the RivalPast row: d, vs, vs_club, win, how) - Claude passes it in.
- `night`: `{checks_left: int, opp_checks_left: int, cost_words: String, marked: Array}` (marked = claims kept from earlier
  films: `{when, then, words, per_film: Array of "7 of 31" strings, word}`).
- `on_check(claim: Dictionary, films_seen: Array) -> Dictionary` returns `{word, k, n, e, z}` (Claude's FilmCount; the
  test passes a fake). The page spends one check (`checks_left` and `opp_checks_left` -1), shows the coach's line, adds
  the claim to MARKED TONIGHT.
- `on_file(claim, word, films_seen_count)` - the page calls it on File it and shows the figure on the button from
  `FilmPattern.figure(word, films, false)` ("File it at 70%"). `on_done()` - Done for tonight (the page closes itself).

### Panels (as the mockup; exact words from the HTML)
1. HEADER: "<name> vs <name>" (names ONLY here, owner S448), the bout line from the row ("club show, Feb 2026 - Holt won
   on points"), the cost chip (`night.cost_words`), FILM n OF m, Next film (disabled on the last), CHECKS as pips +
   "<checks_left> left - <opp_checks_left> for this opponent" (no he/she: owner S412), Done for tonight.
2. LEFT - THE FILM: a dark empty Control named `FilmSlot` (Claude puts the 3D film there), under it Previous moment /
   Next moment (jump between the lines the filter shows; the selected line highlights), 0.5x/1x/2x (store the speed only),
   the round + clock of the selected line, "moment n of m", the timeline (three rounds, a tick per shown line, a cursor at
   the selected line) and the ROUNDS STRIP: per round which corner won it (count exchanges `won`), as in the mockup's
   three cells (no judges' cards on a past bout).
3. MIDDLE - THE PUNCHES: SHOW ME = Them / The other / Both, Hand, Punch, Result, Range, Round, Their game, After (each a
   small OptionButton with Any first; values from the lines). The count line from `FightLog.count_line(shown, all)`; with
   an After pick, the camera line from `FightLog.seen_count` ("seen on camera: right low after 5 of 21 jabs - 10 not seen").
   The list: one row a line (clock "R1 0:06", corner dot, hand+punch+target, range, after or "-", result), a divider each
   exchange naming their game (`sit`), clicking a row selects it, clicking an after cell sets the After filter. Use a
   ScrollContainer; build rows lazily or reuse them - a bout has ~160-200 lines and must not stall.
4. RIGHT - THE REPORT: tabs Them / The other; THROWN, LANDED, CLEAN bars per punch (sort: count | clean rate), head/body;
   LANDED BY ROUND; LANDED BY RANGE; THEIR GAME as shares (`FilmBout.mode_counts`); THEIR COMBINATIONS (two or more "b"
   punches within 1.5 s; the most common sequences with clickable times that select the line); WHAT THE NUMBERS SAY: three
   sentences that state numbers only. Two "Check it (1)" buttons: best weapon (claim `{when: "report", then: "weapon"}`)
   and their game (`{when: "report", then: "game"}`) - they go through on_check like any claim.
5. BOTTOM LEFT - MARK A PATTERN: WHEN and THEN pickers (`FilmPattern.WHEN_WORDS` / `THEN_WORDS`, "9 choices" / "8 choices
   - within 2 s"), the coach's box (after a check: `FilmPattern.word_text(word, "her" if sex == "f" else "him")` + "All of
   them: k of n" + one line with the figure), buttons Check it with the coach (n left; disabled at 0), File it at <figure>%
   (only after a check with word pass or maybe), Watch list. MARKED TONIGHT: each claim, per film side by side, its word.

### Look rules (hard)
- Colours ONLY from `scripts/ui/Palette.gd` names (tests/palette_guard_test.gd fails a new file with a loose colour:
  `Color(Palette.TEXT, 0.4)` is fine, `Color(1, 1, 1, 0.4)` / "#hex" is not). Corner dots as the mockup: THEM (the boxer
  on film) = Palette.BLUE_CORNER, THE OTHER = Palette.RED_CORNER; results Landed and Clean = Palette.GOOD (Clean bold),
  Blocked / Missed / Slipped = Palette.MUTED.
- Fonts and sizes from UI.font / UI.label sizes; it must fit 1920x1080 at the owner's text size Largest
  (scripts/ui/TextScale.gd: `TextScale.use(tree, 1.3)` before building the page, then `TextScale.overflow(page)` must
  return [] - no text outside its box).
- Names only in the header; no he/she anywhere except the coach's word (owner S412, S448).

## The test: tests/fight_analysis_test.gd (extends SceneTree; headless)
Build two films with FilmBout.build for an opponent that has drops_right_after_jab (and one without), open the page with a
fake on_check that returns `{word: "pass", k: 7, n: 31, e: 2.1, z: 3.4}`, and assert:
the page builds with no error; the list row count = FightLog.lines over film 1; SHOW ME Them + Punch jab -> the count line
equals FightLog.count_line(filtered, all); After right low -> the camera line matches seen_count; Next moment moves the
selection to the next shown line; Check it -> checks_left drops by 1, the coach line says "That's her", File it shows 70%;
Next film loads film 2 and keeps MARKED TONIGHT; checks at 0 disable Check it; no Label anywhere contains "he " or " she "
or the opponent's name outside the header; built again after `TextScale.use(tree, 1.3)`, `TextScale.overflow(page)` is
empty. Print `FIGHT_ANALYSIS failures=<n>`; quit(1 if n > 0 else 0).

## Contract
OWNS: scripts/ui/FightAnalysis.gd, scripts/ui/FightAnalysisList.gd, scripts/ui/FightAnalysisReport.gd, tests/fight_analysis_test.gd
RED_TEST: tests/fight_analysis_test.gd -> FIGHT_ANALYSIS failures=0 (red on main: the file does not exist)
REGRESSION: tests/palette_guard_test.gd (no new loose colours), tests/file_limits_test.gd, tests/fight_log_test.gd, tests/film_bout_test.gd
VISUAL: yes - Claude renders the page at 1920x1080 at text sizes Normal and Largest and the owner judges it against the mockup.
NOT YOURS: every other file (the rule modules, Main, the fight week, TapeRoom). Never delete or weaken a test.
Run: plain headless `godot --headless --audio-driver Dummy --path . --script res://tests/<name>.gd` (Godot 4.7.2) on your box
(the PC's godot_slot / hidden_desktop are not on your box; skip stills - Claude renders them).
PR body: `RESULT: tests/fight_analysis_test.gd -> FIGHT_ANALYSIS failures=0`, a RESULT line for each regression test,
and the line count of each new file.

GDSCRIPT TRAPS (ops/research/GDSCRIPT_TRAPS.md): never `var x := <an Array or Dictionary element>`; Array has no join();
a Label needs `autowrap_mode` + a minimum width to wrap; `Color.TRANSPARENT` is see-through WHITE - use Palette.CLEAR;
preload names must not clash; no class_name on the new scripts.

## Prior research
docs/mockups/s495/fight_analysis/fight_analysis_v3.html + .png (the spec); map sections 2.1, 2.2; scripts/ui/TapeRoom.gd
(how a screen is built in code here); scripts/ui/UI.gd, WoodKit.gd, Palette.gd, TextScale.gd.

## What would a human do?
A UI programmer builds the approved mockup panel by panel on the game's own kit, feeds it real tapes from the rule modules,
and keeps every decision (what a check costs, what filing does) behind the callables the designer wires.

## Prefab check
None: our own screen kit (UI.gd, WoodKit.gd).
