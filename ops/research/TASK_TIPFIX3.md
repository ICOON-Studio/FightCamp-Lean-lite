# TASK TIPFIX3 - the rest of the game's tooltips to the short house card (the screens the check does not walk yet)

Kind: code
Status: DONE (S533, PR #434 collected: rest of the game 64 -> 1 broken). Discipline: boxing. Model: Grok Dev. Branch `grok/tipfix3`, a PR into main; never merge.

## Why
Q-S294-283 asked the owner: "If yes I convert the other screens the same way". He answered "Shorter cards"; TIPFIX2 (your PR
#431, on main) made the limits shorter (25 words, 10 a line, 3 rows) and fixed the walked screens (broken 2 of 149). The
check `tests/tooltip_standard_test.gd` walks only home, reception / interview / sign, People, Fighters and Training. Every
other screen's tooltips are unchecked.

## What to do
1. New test `tests/tooltip_rest_test.gd` (keep the old file under 300 lines; reuse `Tip.faults`, `Tip.of` and the same walk
   helpers - copy the small ones, do not import test files): walk the screens the old test does not, with `TestJump` where a
   jump exists - Money, Records, Mail, the week review, Find a fighter, the Office, the calendar, the fight week / fight prep
   page, the gym floor rooms. Print each broken tooltip with `-- list`, like the old test. A ratchet `FAULTS_AT_MOST` starting
   at today's count.
2. Rewrite every broken one through `Tip.short` / `Tip.explain` / `Tip.button` to the house card (what it is, why this value,
   what to do; numbers read from the rule constants; no fighter names, no she/her; the meter is Fatigue).
3. Lower the ratchet to the new count. Target: 5 or fewer, and say what each left-over one is and why.

## Rules
- A Fable session (P4PBUILD1) is building in scripts/ui/OfferCard.gd, scripts/ui/modals/Interview.gd, scripts/ui/RosterActs.gd,
  scripts/ui/RingTopDown.gd, scripts/ui/ResultPage.gd, scripts/ui/modals/FightNight.gd, scripts/fight3d/FightOptions.gd: do NOT
  edit those; list their broken cards in the PR body instead. Another Fable session owns RingDuel / Exchanges / LineGrade /
  PlanFight / StepEffect / StepWire / StrikeMap. Do not touch scripts/fight3d.
- Do not change what a number IS - only how it is explained. Small files: no script over 500 lines.
- Note: palette_guard is red on main from P4P's new RingTopDown.gd - not yours, leave it.

## Deliverable
A PR on `grok/tipfix3`. Body: `RESULT: tests/tooltip_rest_test.gd -> TOOLTIP_REST tooltips=<n> broken=<m>`, the old test's
line, one line per other test you ran, and a before/after table of 6 rewritten cards (word counts).

## Contract
OWNS: tests/tooltip_rest_test.gd, the scripts/ui files (outside the list above) that set the broken cards
RED_TEST: tests/tooltip_rest_test.gd (new; its first count is the baseline)
REGRESSION: tests/tooltip_standard_test.gd, tests/tips_test.gd, tests/tip_notes_test.gd, tests/guide_explore_test.gd, the tests of
every screen file you touch
VISUAL: no (Claude renders stills after collecting)

## Prior research
GUIDETIPS1_STANDARD.md; TASK_TIPFIX1.md, TASK_TIPFIX2.md; Q-S294-283.
## What would a human do?
The UX writer finishes the job: every hover in the game, not just the pages the boss looked at.
## Prefab check
None.
