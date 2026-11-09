# TASK PRESENT1A - CURSOR (Grok 4.7 High) - every number and word on the screens says what it means

Status: OPEN (S416, Claude main). Discipline: boxing. Model: grok-4.7-high.
Source: the operator, playing the build: "your presetnation to the player is extremely bad, noone understand your menu options and path to learning the game", and on "-15%": "wtf they lose strengh ?". ops/research/S416_NEW_PLAYER_CRITIC.md is a stranger's read of 20 screens, with the exact replacement words per screen.

## Contract
OWNS: scripts/ui/, tests/words_on_screens_test.gd
RED_TEST: tests/plain_words_test.gd -> PLAIN_WORDS failures=0
REGRESSION: plain_words_test, no_pronoun_test, grey_reason_test, menus_round4_test, first_week_test, golden_path_test
VISUAL: no

## Prior research
ops/research/S416_NEW_PLAYER_CRITIC.md: read every screen's section 2, and items 3, 8, 9 of "To reach 10/10". scripts/ui/StaffCard.gd `_tile` and `_figure` are the pattern: the caption is on the screen, never only on hover. ops/research/MENU_BUILD_RULES.md, ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
Read each label aloud to someone who has never played, and rewrite the ones that need explaining.

## Prefab check
None: this is wording.

## The job: words only. No new layout, no new mechanic, no number changed.
1. Every number on a screen gets a noun or a unit beside it, visible without hover. Start with: the coach bars' "+30%" (say what improves and that it is against no coach: read the value's real meaning in scripts/rules/CoachAreas.gd and scripts/ui/StaffCard.gd first, never guess), "0.9 over" (say kg over the limit), "Gap -9" (BoutCompare: say what the gap is between), "File 0 of 4 found" (scouting report), "Net -$309 to -$362" (a week).
2. Every disabled button says why on the button or directly under it, in words ("Needs 4 wins"), using SM.grey_reason or the rule that disables it. Hover alone does not count.
3. Jargon from the critic's item 8, in what the player reads only: file -> scouting report, gap -> a plain phrase, edge -> bonus. Save keys, node names, function names and variables do not change.
4. Take the critic's replacement text screen by screen wherever it is words on an existing label or button and is true. Check each against the code: the critic could not see the rules, so where its wording is wrong, write the true version.
5. Leave out: the corner (scripts/ui/CornerJobsRow.gd, scripts/fight3d/CornerOverlay.gd, waiting on the operator's answer), the Money page layout, any weekly checklist, and any screen move. List in the PR body every critic item you did not do and why.
6. tests/words_on_screens_test.gd prints `WORDS_ON_SCREENS failures=<n>`: render People, Fights, a bout page and the fighter Overview headless and fail on each of the old bare strings you replaced, and on any disabled button with no visible reason on those pages.

## Rules
Godot through `python ops/Tools/godot_slot.py run --who cursor -- <godot cmd>`. No he or she for a boxer anywhere (tests/no_pronoun_test.gd). No file over 500 lines: GamePlan.gd is at 496. Text must fit: a label that clips is worse than a short one. A test pinned to an old word may have that word updated; no number or bar in a test changes. You cannot see images, so report anything that may now wrap.

## The one trap
A confident label that is false is worse than a bare number. Every sentence must be what the rule really does, and you must name in the PR body the function you read for each number you explained.

## Result lines (PR body)
RESULT: tests/plain_words_test.gd -> PLAIN_WORDS failures=0
RESULT: tests/words_on_screens_test.gd -> WORDS_ON_SCREENS failures=0
