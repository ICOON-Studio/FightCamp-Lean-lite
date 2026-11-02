# TASK CAMPWORDS1 - the camp sheet speaks in whole numbers and words, never decimals (design review S172 finding 4, rest of it)

Model: Qwen (small pure change + one test). Worktree E:/FightCamp/wt/GYM4F, branch qwen/campwords1 from origin/master
(`git fetch origin && git checkout -B qwen/campwords1 origin/master`).
Tier: scripts edited + new test -> parse gate + the new test + `python Godot/tools/run_tests.py --only fight_camp,camp_ --jobs 2`.

## Prior research
DEMO_DESIGN_REVIEW_S172.md finding 4: "decimals ('+0.03', '+0.15') ... Fix: whole-number effects in words". The boxing-only half is DONE
(dd7165b5 CAMP-RULES). S183 CAMPVIS1 added `FightCamp.camp_bought_lines` (Godot/scripts/FightCamp.gd, after `edge_lines`) - the plain-words
lines the fight week and result screen print. The camp sheet itself (FightCampPanel.gd) still prints decimals.

## What would a human do?
A coach says "your jab lands about 3 in 100 more often", "you tire 12% slower" - never "strike success +0.03".

## Prefab check
None: reword existing strings.

## Owned files
1. `Godot/scripts/FightCamp.gd` (`edge_lines`, ~line 284): every line in whole numbers + words. strike_success / defense_bonus / duel_drill
   are fractions: print them as whole percent ("strike success +3%", "evasion +5%"); the rest already print %, keep. No "%.1f"/"%.2f" left
   in edge_lines.
2. `Godot/scripts/FightCampPanel.gd` (1,718 lines - windows only): the protocol card line 264 (`gains x%.2f` -> `gains +N%` from
   (gain_mult - 1) * 100 rounded, or "normal gains" at 1.0); the delta rows at line 997 (`"%.2f"` from/to -> whole percent for fractional
   edges); the per-week text at 1086-1089 (`%+.1f%%/wk` -> `%+d%%/wk`, rounded). Lines 1615/1633/1640 are TOOLTIP explainer text: round
   to whole percent too. Do not change layout, sizes or which cards show.
3. NEW `Godot/tests/camp_words_test.gd`.

## Acceptance (the one test)
`Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/camp_words_test.gd` -> `CAMP WORDS PASS`, rc 0:
- `FightCamp.edge_lines` on {strike_success 0.03, defense_bonus 0.05, stamina_discount 0.12, takedown_mult 0.15, opponent_reads 2} returns
  lines with NO decimal point (regex `\d\.\d` finds nothing) and contains "3%" and "5%".
- Instance `FightCampPanel` the way an existing fight_camp test does (grep `FightCampPanel` in Godot/tests for the pattern), walk every
  Label/Button text under it: none matches `\d\.\d\d` (two-decimal numbers).
- MUTANT: put back `"%s +%.2f"` in edge_lines -> red. Say in the commit that you ran it.
Parse gate first: `python Godot/tools/check_scripts.py scripts/FightCamp.gd scripts/FightCampPanel.gd tests/camp_words_test.gd`.

## The one trap
fight_camp_test.gd and other tests may assert today's exact strings: run the tier's neighbours; if one asserts a decimal string, update
that assertion to the new words (never delete a check) and say so in the commit. Headless Godot ONLY with
`Godot_v4.7.2-stable_win64.exe --headless` (never `_console.exe`). Open no windows, view no images. Commit with `git add -- <paths>`, push, stop.
