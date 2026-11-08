# TASK SWINGCENSUS1 - AGY (Argon High) - every random swing the player feels, and what they are told
Kind: research
Status: OPEN (S402, Claude main). Discipline: boxing. Model: Argon High. Mechanics list row R11: critics 8 and 8, first on the operator's build list.

## Contract
OWNS: docs/SWING_CENSUS.md (a document only)
RED_TEST: tests/plain_words_test.gd -> PLAIN_WORDS failures=0 (no game file changes; this stays green)
REGRESSION: plain_words
VISUAL: no

## Prior research
`python ops/Tools/prior_research.py random reason why`. scripts/rules/WeekCause.gd already names the sessions behind each training gain; scripts/rules/FightWhy.gd explains a fight. ops/research/S400_REVIEW/MECHANICS_LIST_S401.md row R11.

## What would a human do?
When something bad or good happens out of nowhere, want one line saying why, so the next decision can change.

## Prefab check
None needed.

## Why
The player must always be able to read why a number moved. That is our lead over Corner King, which never says why. WeekCause covers training gains only. A fair roll with no reason reads as the game cheating.

## Do
Read scripts/state and scripts/rules. Boxing and the gym only: leave out Bjj*, Grappl*, NoGi, and anything that only builds the world at the start (WorldGen, AttrGen, Names, Faces, PriorBouts, RivalPast, BalanceHarness). Start from every `randf`, `randi`, `randi_range`, `pick_random`, including InjuryRoll, WeekTwist, PushBack, GymSpend, Sim.step_day, RoundScript, Knockdowns, Matchmaking, members joining and leaving.

Write docs/SWING_CENSUS.md, one table, one row per roll the player can feel:
| file:line | what it moves | chance and what raises or lowers it | what the player reads today (exact text and screen, or NOTHING) | verdict: OK / NO REASON / REASON HIDES THE CAUSE | one sentence in plain words the game could show, naming the real cause from data the code already has |

Then, under the table: the rolls with NO REASON ranked by how much they hurt or help the player, the top 10 marked, and which existing screen line each belongs on. No new screens. Rolls that cannot be felt get one line each in a list at the end, not a row.

## Rules for this seat
Change no game file. Godot only through `python ops/Tools/godot_slot.py run --who agy -- ...`, headless, `--audio-driver Dummy`. No screens opened. Quote exact line numbers: every row is checked against the code.

## The one trap
A reason must be true. Only name causes the code actually used for that roll, never a plausible story.
