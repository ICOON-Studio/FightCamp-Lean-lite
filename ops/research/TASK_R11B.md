# TASK R11B - QWEN (qwen3-coder) - the week's member change says why

Status: OPEN (S404, Claude main). Discipline: boxing. Model: qwen3-coder.
Source: mechanics row R11, "every random swing gets a readable reason" (ops/research/S400_REVIEW/MECHANICS_DECISION_S402.md), row 6 of docs/SWING_CENSUS.md. Claude read this row against the code on S404; the census's line numbers are out of date, so trust the names below. Start every Godot run through `python ops/Tools/godot_slot.py run --who qwen -- <godot cmd>`.

## Contract
OWNS: scripts/rules/Membership.gd, scripts/state/Sim.gd, scripts/ui/modals/WeekReview.gd, tests/membership_why_test.gd
RED_TEST: tests/membership_why_test.gd -> MEMBERSHIP_WHY failures=0
REGRESSION: membership_test, week_read_test, review_reveal_test, plain_words_test, no_pronoun_test, save_load_test, golden_path_test
VISUAL: no

## Prior research
`python ops/Tools/prior_research.py swing reason members`. Operator S398: nothing on screen unless the player can act on it, so the reason names something the player controls. tests/injury_why_test.gd (R11A) is the pattern to copy.

## What would a human do?
A gym owner sees two members left this week and asks why. The answer is one short clause: the place is full, the dues are too steep for the gym's name, or word is getting round.

## Prefab check
None needed.

## How it works today (read these first)
- scripts/rules/Membership.gd: `natural_members(reputation, band)` is what the gym could carry, `step_members` moves a fraction of the gap, `settle_week(members, reputation, cap, band)` returns the week's result.
- scripts/state/Sim.gd about line 297 calls `settle_week` with `GymSpend.member_cap(career)`. The week's result reaches the review as `r["members_delta"]`.
- scripts/ui/modals/WeekReview.gd line 153: `UI.kv("Members", "%d (%+d)" ...)`. It shows the change with no reason.

## The rule
1. Add a pure `Membership.week_cause(before: int, after: int, natural: int, cap: int, band: String) -> String` returning one plain clause, or "" when nothing changed:
   - No change: "".
   - Rose and `after` has reached `cap` while `natural` is above `cap`: "the gym is full now".
   - Rose otherwise: "word is getting round".
   - Fell and band is "premium" with the premium draw below 1.0 for this reputation: "the dues are putting people off".
   - Fell and `natural` is at or above `cap` (so the room cap is what forced it): "the gym has less room".
   - Fell otherwise: "more than the gym's name can hold".
2. `settle_week` stays as it is for every number. Sim stores the clause in the same week result as `members_why`, using the values it already has.
3. WeekReview shows it after the count: "33 (+2): word is getting round". An old save or a result with no `members_why` reads exactly as today.
4. Every number and chance stays unchanged.

## Do
1. tests/membership_why_test.gd FIRST (prints `MEMBERSHIP_WHY failures=<n>`). Run it on main: it must fail. Cover each branch of rule 1, a real career (main.act("quick")) played one week showing the clause in the week result, and a result with no `members_why`.
2. Make it pass inside OWNS. Files stay under 500 lines; WeekReview is 483, so keep the addition to one or two lines there.
3. Run REGRESSION. Do not change any number or threshold in an existing test. If one goes red, stop and put what you measured in the PR body.

## Rules for this seat
Godot only through godot_slot, headless, `--audio-driver Dummy`. Parse check before any test. No screens opened. Nothing outside OWNS. PR body: `RESULT: tests/membership_why_test.gd -> MEMBERSHIP_WHY failures=0`.

## The one trap
Do not draw a random number anywhere: one more rng call shifts every later roll in the career, and save_load and golden_path go red for no visible reason. No his/her in the words: no_pronoun_test reads them.
