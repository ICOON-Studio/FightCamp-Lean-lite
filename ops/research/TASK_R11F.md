# TASK R11F - QWEN (qwen3-coder) - members who leave after a loss are named on the result

Status: OPEN (S405, Claude main). Discipline: boxing. Model: qwen3-coder.
Source: mechanics row R11, "every random swing gets a readable reason" (ops/research/S400_REVIEW/MECHANICS_DECISION_S402.md), row 9 of docs/SWING_CENSUS.md. Claude read this row against today's code.

## Contract
OWNS: scripts/ui/modals/FightNight.gd, tests/loss_members_why_test.gd
RED_TEST: tests/loss_members_why_test.gd -> LOSS_MEMBERS_WHY failures=0
REGRESSION: fight_flow_test, plain_words_test, no_pronoun_test, save_load_test, golden_path_test
VISUAL: no

## Prior research
`python ops/Tools/prior_research.py members leave loss stoppage`. R11A, R11B, R11D and R11E are the same kind of row. Operator S398: nothing on screen unless the player can act on it.

## What would a human do?
A gym owner hears after a bad night that two members cancelled, and hears why: they watched the stoppage.

## Prefab check
None needed.

## How it works today (read these first)
- scripts/state/BoutNight.gd about line 350: a loss takes members off the club and stores the number in `m["members_lost"]`. A stoppage (`stop != ""`) loses more.
- scripts/ui/modals/FightNight.gd about line 330: the result page builds an array `take` of `[value, label, colour]` for the row at the foot of the page. Nothing reads `members_lost`, so the drop is silent.

## The rule
1. When `int(m.get("members_lost", 0)) > 0`, add one entry to `take`: value `-N`; label "MEMBERS LEFT AFTER THE STOPPAGE" when the bout ended by stoppage, otherwise "MEMBERS LEFT AFTER THE LOSS"; colour UI.RED.
2. Use whichever field the page already reads to know the bout was stopped; read the file to find it. A win, a draw, or an old save without `members_lost` shows no entry.
3. Every number, chance and rule stays unchanged. Only this screen changes.

## Do
1. tests/loss_members_why_test.gd FIRST (prints `LOSS_MEMBERS_WHY failures=<n>`). Run it on main: it must fail. Cover: a stoppage loss, a points loss, a win, and a bout dictionary without `members_lost`, by building the result page and reading its labels.
2. Make it pass inside OWNS. FightNight.gd is 384 lines; stay under 500.
3. Run REGRESSION. Do not change any number or threshold in an existing test. If one goes red, stop and put what you measured in the PR body.

## Rules for this seat
Godot only through godot_slot, headless, `--audio-driver Dummy`. Parse check before any test. No screens opened. Nothing outside OWNS. PR body: `RESULT: tests/loss_members_why_test.gd -> LOSS_MEMBERS_WHY failures=0`, plus one RESULT line per REGRESSION test.

## The one trap
Do not draw a random number anywhere. No his/her in the words: no_pronoun_test reads them.
