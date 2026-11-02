# TASK U206 - the gym's money: where it comes from, where it goes, where it is heading (UI, Cursor)
Owner: Cursor (composer). Worktree D:/FightCamp/wt/U206, branch cursor/u206-finance (from master).
Operator 2026-10-01: "everything needs to have a meaning and reward the player for progressing", AAA, icons over text with
tooltips. D66_STRICT_REVIEW.md #7: "Financials are superficial - net -$231/week, $25k cash, no breakdown of income vs
expenses, no forecast. Can't tell if you're growing or dying." D66's fix: "Breakdown tab: monthly income (members,
sponsors, purses) vs costs (coaches, rent, staff); 12-week forecast; 'raise membership fees?' risk/reward prompt."

## Census first (into the digest)
The finance screen (`grep -rn "finances" Godot/scripts/SceneRouter.gd`; OfficeHubPanel.gd 1,735 lines; `grep -n "^func get_.*\(finance\|money\|ledger\|cash\|billing\|membership\|sponsor\)" Godot/scripts/GameState.gd`).
advance_week returns upkeep, payroll, billed, membership_income, sponsorship_income (GameState ~7669) - the data exists.
U205 (week in review) stores the last week's report - read it if merged, do not duplicate it.

## Deliver
- A BREAKDOWN view: income by source vs costs by line, last 4 weeks as icon tiles (banknote, users, handshake, trophy,
  building, briefcase) with per-line tooltips; net with a trend arrow (trending-up / trending-down).
- A 12-week FORECAST line from the current recurring income/costs + booked purses (clearly labelled as a projection).
- One decision prompt where a lever exists in GameState (membership fee or similar) showing its projected effect - only if
  the lever already exists; never invent a rule.
- Icons over text (GLOSSARY "Icon with tooltip"; `UIKit.icon_plate`, `UIKit.tip`, `UIKit.money_display` from U204).
- Owned: the finance panel script(s) + thin GameState reads. NEW `Godot/tests/finance_breakdown_test.gd` (a career with
  known weekly lines -> breakdown sums equal the report; forecast week 1 = current net; control: a gym with no sponsor shows
  no sponsor tile). Stills -> `previews/u206/` (OPEN THEM). `research/U206_DIGEST.md`. Never edit HANDOFF.md.

## Owned files
- `Godot/scripts/OfficeHubPanel.gd` (the money boards; S138 also edited its trophy cabinet - do not touch that block)
- `Godot/scripts/GameState.gd` (thin reads only - never read whole, sed -n windows)
- `Godot/tests/finance_breakdown_test.gd`
- `Godot/tools/u206_finance_stills.gd`
- `previews/u206/*`
- `research/U206_DIGEST.md`

## Tests
Parse gate; the new test; `python Godot/tools/run_tests.py --jobs 2 --only finance,office,money,smoke,ui_kit,ui_fx`. Watchdog first.

## Finish
git add by explicit path, commit, git push -u origin cursor/u206-finance. Do not stop at "written".
