# TASK FOURMONEY1 - the money of four starters: a pure probe over the existing bill rules (test + result page)

Status: OPEN (S484, Claude main). Discipline: boxing (the BJJ starter pays the same stipend). Model: Qwen (qwen3-coder), default.

## Why now
The owner's S428 scope ("we sshould force the player to have 4 fighters,different weight classes and bjj") makes the start
four fighters. FOURSTART1's design map needs the money first (ops/research/SCOPE_FOUR_FIGHTERS_S428.md line 18: "the money
(stipends $250 each, dues, start cash: re-measure with GymBills)"). Today Career.start_cash (scripts/state/Career.gd 131-136)
counts ONE stipend. This probe measures what four stipends do. It changes NO game code.

## What to build
1. `tests/four_money_probe_test.gd` (extends SceneTree, `_init()`, quit at the end; preload only
   res://scripts/rules/GymBills.gd and res://scripts/rules/ClubStart.gd). For each start id in ClubStart.ids() and for
   fighters n = 1 and n = 4, compute the weekly costs exactly as Career.start_cash does, but with n stipends of $250 and
   "boxers": n: GymBills.week({"members": ClubStart.members(id), "coaches": 1, "boxers": n, "rent_mult":
   ClubStart.rent_mult(id), "month": 1}) -> rent + fees + power + insurance + GymBills.KIT_BUDGET["standard"]["week"] + 450
   (the first sessional coach, CLAUDE.md "Decided numbers") + 250 * n. Then print one line per (id, n):
   `FOURMONEY <id> n=<n> week_costs=<int> income=<GymBills.week(...).income> net=<income - week_costs>
    start_cash=<round(week_costs * 4.33 * ClubStart.months(id) / 100) * 100> runway_weeks=<GymBills.runway_weeks(start_cash, net)>
    break_even_members=<ceil(week_costs / (35 / 4.33))>`
   Also print, for "fresh" with n = 4 and the CURRENT start cash (n = 1's start_cash), the runway in weeks:
   `FOURMONEY fresh n=4 on_today_cash runway_weeks=<int>`.
   Checks (bounds, never exact values): for every id, n=4 week_costs > n=1 week_costs by 750 +/- 60 (three more stipends
   plus three boxers' fees); runway_weeks >= 0; break_even_members(n=4) > break_even_members(n=1). On success print
   `FOURMONEY PASS fails=0`, else `FOURMONEY FAIL fails=<k>` and each failed check.
2. `docs/FOURMONEY1_RESULT.md`: the table of the printed lines (3 starts x 2), and three plain sentences: how many weeks a
   fresh gym lasts with four stipends on today's start cash, what start cash keeps three months for four, and how many
   members break even with four.

## Contract
OWNS: tests/four_money_probe_test.gd, docs/FOURMONEY1_RESULT.md
RED_TEST: tests/four_money_probe_test.gd -> FOURMONEY PASS fails=0 (new file; red on main because it does not exist)
REGRESSION: tests/four_money_probe_test.gd only (no game file changes; nothing else can move)
VISUAL: no
NOT YOURS: every other file. Do not edit GymBills.gd, ClubStart.gd or Career.gd. Never delete or weaken a test.

## Test command (tier: a new test file only - parse + that test)
`%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/four_money_probe_test.gd`
(the plain exe only, never _console.exe; never sleep to wait, use a foreground timeout of 120 s).

## Pass lines (put them in the commit message / result page)
RESULT: tests/four_money_probe_test.gd -> FOURMONEY PASS fails=0
RESULT: docs/FOURMONEY1_RESULT.md -> rows=6

## The one trap
GDScript `:=` on a Dictionary read is a Variant - type it (`var x: int = int(d["k"])`); see ops/research/GDSCRIPT_TRAPS.md.

## Prior research
ops/research/SCOPE_FOUR_FIGHTERS_S428.md; Career.start_cash (S324, S397 money bites); GymBills (S397).
## What would a human do?
Add the three extra stipends to last year's bill sheet and see how many weeks the bank lasts.
## Prefab check
None: our own bill rules.
