# TASK TIPFIX2 - shorter cards: tighten the tooltip limits, then rewrite every card that breaks them

Kind: code
Status: DONE (S533, PR #431 collected: broken 4 -> 2, cards ~25 words). Discipline: boxing. Model: Grok Dev. Branch `grok/tipfix2`, a PR into main; never merge.

## Why
The owner looked at the build-1 cards (coach pay, the Fatigue card, the mastery bar, the guide) and answered on the board
Q-S294-283: **"Shorter cards"**. Example of what is too long today (the Fatigue card on Fighters): a WHAT of 13 words, four
rows, a MOVES IT of 12 words and a YOUR MOVE of 13 words - about 40 words and 9 lines for one number.

## The new limits (decided by Claude; change them in `scripts/ui/Tip.gd`)
- `FULL_WORDS` 45 -> **25** (a FULL card's sentences, rows not counted)
- `LINE_WORDS` 14 -> **10** (WHAT and MOVES IT, one sentence each)
- `SHORT_WORDS` 20 -> **14** (a SHORT card and a BUTTON line)
- `MAX_ROWS` 4 -> **3**
- Keep the four parts (WHAT / NOW or rows / MOVES IT / YOUR MOVE), but a card may drop MOVES IT when YOUR MOVE already says it
  (e.g. "Rest days bring it down" + "Plan a rest day before 80" -> keep only "Plan a rest day before 80 - rest brings it down").
- Worked target, the Fatigue card: title "Fatigue 8 of 100 - fresh"; WHAT "How worn your boxer is: training and fights raise
  it."; rows Fresh under 50 / Tired from 70 / Next day counts 60% from 80; YOUR MOVE "Plan a rest day before it reaches 80."
  (about 20 words). Numbers still read from the rule constants.

## What to do
1. Change the four constants; update the header comment of Tip.gd (lines 8, 18-22) to match.
2. Run `tests/tooltip_standard_test.gd -- list`: every card now over the limits shows as long / line / rows.
3. Rewrite each one shorter (cut words, never meaning: what it is, why this value, what to do). Start with the cards the owner
   saw: coach pay, Fatigue, mastery bar (`scripts/ui/TipCards.gd` and the screens that set them).
4. Lower `FAULTS_AT_MOST` to the new count; target: no more than today's 4.
5. Run the tooltip test and the tests of every screen file you touched.

## Rules
- Do not touch scripts/fight3d, StepEffect / RingDuel / tools/treevalue_probe.gd. A Fable session is building P4PBUILD1 in
  scripts/ui/OfferCard.gd, scripts/ui/modals/Interview.gd, scripts/ui/RosterActs.gd, scripts/ui/RingTopDown.gd: if a card
  you must shorten lives there, keep the change to the card's text lines only and say so in the PR body.
- Do not change what a number IS - only how it is explained. No fighter names, no "she/her" in card text. The meter is Fatigue.
- Small files: no script over 500 lines.

## Deliverable
A PR on `grok/tipfix2`. Body: `RESULT: tests/tooltip_standard_test.gd -> TOOLTIP_STANDARD tooltips=<n> broken=<m>` plus one
line per other test you ran, and a before/after table of the coach pay, Fatigue and mastery cards plus 3 more (word counts).

## Contract
OWNS: scripts/ui/Tip.gd, scripts/ui/TipCards.gd, scripts/ui/ (the files that set the long cards), tests/tooltip_standard_test.gd
RED_TEST: tests/tooltip_standard_test.gd (red on main once the limits drop)
REGRESSION: tests/tooltip_standard_test.gd, tests/tips_test.gd, tests/tip_notes_test.gd, tests/guide_explore_test.gd
VISUAL: no (Claude renders stills of the three cards after collecting)

## Prior research
GUIDETIPS1_STANDARD.md; TASK_TIPFIX1.md (PR #429); Q-S294-283 answer "Shorter cards".
## What would a human do?
An editor takes each card and cuts it to what a player reads in two seconds while hovering.
## Prefab check
None (our own card helper).
