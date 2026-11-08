# TASK OFFERGONE1 - QWEN (qwen3-coder) - an expired fight offer is never a dead end

Status: OPEN (S401, Claude main). Discipline: boxing. Model: qwen3-coder.
Source: ops/research/S400_REVIEW/CORNER_KING_REFINED_S401.md, the rule-breaks list, item 3. This is a defect fix on today's screen: no layout or design change.

## Contract
OWNS: scripts/ui/areas/BoutPage.gd:21-26, scripts/state/Needs.gd, tests/offer_gone_test.gd
RED_TEST: tests/offer_gone_test.gd -> OFFER_GONE failures=0
REGRESSION: golden_path_test, test_jump_test, first_hour_walk_test, plain_words_test
VISUAL: no

## Prior research
`python ops/Tools/prior_research.py offer expired`. STRUCTURE_BY_MENU.md rows 11_bout_unsafe and 12_bout: "an expired offer must close itself and clear the flag".

## What would a human do?
Press the link, find the offer has gone, and expect to be taken back to the list of fights. A flag that says a fight offer needs an answer must only exist while it can be answered.

## Prefab check
None needed.

## How it works today (read these first)
- scripts/ui/areas/BoutPage.gd build(): when Bouts.find_offer finds nothing it shows the muted line "That offer is gone." and nothing else. There is no way on.
- scripts/state/Bouts.gd line ~115-145: offers expire with the days (`o["expired"] = true`), and a new pair can replace them, so an old id stops existing.
- scripts/state/Needs.gd builds the "needs you" flags, including the one for an offer to answer.
- Find how other pages navigate (main.act / main.go, grep scripts/ui/areas) and use the same route to the Fights area.

## The rule
1. BoutPage, offer not found: keep the line "That offer is gone." and add one button under it, "Back to Fights", that opens the Fights area with the game's normal navigation.
2. Needs: no flag ever points at an offer that has expired, been answered or no longer exists. If the Needs code already holds, the test proves it and you change nothing there.

## Do
1. tests/offer_gone_test.gd FIRST (prints `OFFER_GONE failures=<n>`). Run it on main: it must fail, because the button does not exist. It covers: BoutPage built with an unknown id contains a button with the text "Back to Fights"; a career with an open offer has the offer flag; after the day passes the offer's expiry, the flag is gone; an answered offer has no flag. Population: Data.lucy via Career.quick_start, as tests/exchanges_test.gd sets up a fighter.
2. Make it pass inside OWNS. Under 500 lines per file.
3. Run REGRESSION. Do not change any number or threshold in an existing test. If one goes red, stop and put what you measured in the PR body.

## Rules for this seat
Godot only through `python ops/Tools/godot_slot.py run --who qwen -- ...`, headless, `--audio-driver Dummy`. Parse check before any test. No screens opened. Nothing outside OWNS. PR body: `RESULT: tests/offer_gone_test.gd -> OFFER_GONE failures=0`.

## The one trap
Button text goes through plain_words_test. A control built off-tree can read 0 wide in a headless test: test the button exists and its text, not its size.
