# TASK GYMBILLS1 - QWEN - money that bites: the gym's real bills, its runway, and when it closes (Lean)

Model: Qwen (qwen3-coder, --yolo). Discipline: boxing (demo). Repo: E:\FightCamp\Lean (NOT the old Game repo).
Workspace: your own worktree E:\FightCamp\wt\LEAN_GYMBILLS1 (branch qwen/gymbills1). Commit there; do not push.

## Why
Operator S323 approved the make-it-a-game plan ("Build it"; `E:\FightCamp\Game\research\MAKE_IT_A_GAME_PLAN_S323.md`,
decision 1 "MONEY THAT BITES"): today money never forces a decision (dues 3x the real fee, $25,000 start). You write the ONE
pure module with the real-world numbers; Claude wires it into the weekly clock, the MONEY page, a red flag and a close
screen next session. The game keeps dollars: every real GBP number below is x1.25, rounded.

## Owned files (create both; touch nothing else)
- `scripts/rules/GymBills.gd` (new, under 160 lines, `extends RefCounted`, static functions only, ZERO preloads)
- `tests/gym_bills_test.gd` (new, `extends SceneTree`, same shape as `tests/pace_aim_test.gd`; prints `GYM_BILLS failures=<n>`;
  quit(1 if failures else 0))

## The module
```
## Real-world numbers (research S323): England Boxing club ~33 members; fee GBP 25-30/month; a 1,500 sq ft unit GBP
## 1,250-1,650/month; coach GBP 20-25/h (Level 1); registration GBP 250 club + 14 a boxer + 28 a coach a year.
const FEE_MONTH := 35          # a member's monthly fee, $ (GBP 28)
const RENT_MONTH := 1800       # $ (GBP 1,450)
const COACH_HOUR := 28         # $ an hour (GBP 22)
const CLUB_YEAR := 315         # $ England Boxing club fee (GBP 250)
const BOXER_YEAR := 18         # $ per registered boxer (GBP 14)
const COACH_YEAR := 35         # $ per coach (GBP 28)
const WEEKS_A_MONTH := 4.33
const CLOSE_AFTER_WEEKS := 4   # this many weeks in a row below $0 = the gym closes
const WARN_RUNWAY_WEEKS := 8   # runway under this = a NEEDS YOU flag
const START_MONTHS := 3        # start cash covers this many months of costs

## One week's money. g = {"members": int, "coach_hours_week": float, "coaches": int, "boxers": int}.
## Returns {"income": int, "rent": int, "coaching": int, "fees": int, "costs": int, "net": int} - all whole dollars:
## income = members * FEE_MONTH / WEEKS_A_MONTH; rent = RENT_MONTH / WEEKS_A_MONTH; coaching = coach_hours_week *
## COACH_HOUR; fees = (CLUB_YEAR + boxers * BOXER_YEAR + coaches * COACH_YEAR) / 52; costs = rent + coaching + fees;
## net = income - costs. Round each with roundi (round half away from zero) AFTER computing it as a float.
static func week(g: Dictionary) -> Dictionary

## Weeks of runway at this week's net: cash / -net when net < 0 (floor, never negative); 999 when net >= 0.
static func runway_weeks(cash: int, net: int) -> int

## The close rule: weeks_below = how many weeks in a row the cash has ended below 0 (the caller keeps the count).
## "closed" when weeks_below >= CLOSE_AFTER_WEEKS, "red" when cash < 0, "warn" when runway < WARN_RUNWAY_WEEKS, else "ok".
static func status(cash: int, net: int, weeks_below: int) -> String

## The next week's count of weeks below zero: weeks_below + 1 when cash < 0, else 0.
static func next_below(cash: int, weeks_below: int) -> int

## Start cash for a new gym: START_MONTHS months of this setup's costs (week(g).costs * WEEKS_A_MONTH * START_MONTHS),
## rounded to the nearest $100.
static func start_cash(g: Dictionary) -> int

## Members needed to break even for this setup (ceil of costs / (FEE_MONTH / WEEKS_A_MONTH)).
static func break_even_members(g: Dictionary) -> int

## One line for the MONEY page: "Runway: 6 weeks" / "Runway: safe" (999) / "The gym closes in 2 weeks" (red, weeks_below
## 2 -> CLOSE_AFTER_WEEKS - 2) / "The gym has closed" (closed).
static func line(cash: int, net: int, weeks_below: int) -> String
```

## Tests (all must pass)
1. Write this first and see it fail (module missing): week({"members": 0, "coach_hours_week": 0.0, "coaches": 0,
   "boxers": 0}).income == 0.
2. A real club: week({"members": 33, "coach_hours_week": 6.0, "coaches": 1, "boxers": 2}): income 267 (33*35/4.33 =
   266.7 -> 267), rent 416 (1800/4.33 = 415.7), coaching 168, fees 7 ((315+36+35)/52 = 7.4 -> 7), costs 591, net -324.
   (A real small club loses money on dues alone - that is the point: it needs shows, more members or fewer hours.)
3. income rises by about 8 per extra member (34 members -> 275).
4. runway_weeks(3000, -324) == 9; runway_weeks(3000, 50) == 999; runway_weeks(-100, -324) == 0.
5. status: (3000, -324, 0) -> "ok" (runway 9 >= 8); (2000, -324, 0) -> "warn" (runway 6); (-10, -324, 1) -> "red";
   (-10, -324, 4) -> "closed"; (500, 100, 0) -> "ok".
6. next_below: (-1, 2) -> 3; (0, 2) -> 0; (100, 3) -> 0.
7. start_cash for the test-2 club: 591 * 4.33 * 3 = 7677 -> 7700.
8. break_even_members for the test-2 club: 591 / (35/4.33) = 73.1 -> 74.
9. line: (3000, -324, 0) "Runway: 9 weeks"; (3000, 50, 0) "Runway: safe"; (-10, -324, 2) "The gym closes in 2 weeks";
   (-10, -324, 4) "The gym has closed".
10. Every value in week() is an int; same input -> same output.

## The one test command (from the worktree root)
```
"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script tests/gym_bills_test.gd
```
NEVER the `_console.exe`. Output must show `GYM_BILLS failures=0` and no `SCRIPT ERROR`. No output in 60 s = a script error
hanging `_initialize`: kill it and fix. Parse gate first: `... --headless --path . --check-only --script
res://scripts/rules/GymBills.gd`. Do NOT change a constant or a test number to pass - if the brief contradicts itself,
keep the constant, report the measured value and why.

## Contract
OWNS: scripts/rules/GymBills.gd, tests/gym_bills_test.gd   (Lean repo)
RED_TEST: tests/gym_bills_test.gd -> GYM_BILLS failures=0
REGRESSION: game_money_test
VISUAL: no (Claude wires it into the clock and the MONEY page)

## The one trap
GDScript `:=` on a Variant from a Dictionary is a parse error: write `var m: int = int(g.get("members", 0))`. Integer
division truncates: compute in floats (`float(x)`) and round once with roundi. No multi-line lambdas inside a call.

## Prior research
Lean `docs/research` + Game `research/MAKE_IT_A_GAME_PLAN_S323.md` (the numbers and their sources: England Boxing
2024/25 deck, club price pages, unit listings, coach job adverts, England Boxing fee page). Existing money code to read,
not change: `scripts/rules/GameMoney.gd`.

## What would a human do?
A club treasurer keeps a monthly sheet: dues in, rent and coaching out, the governing body's fees once a year, and the
weeks the bank balance lasts. Real small clubs run at a loss on dues and live on shows, grants and volunteer coaches.

## Prefab check
Nothing to buy: a pure numbers module over our own state.

## When done
Commit both files on qwen/gymbills1, message ending `RESULT: tests/gym_bills_test.gd -> GYM_BILLS failures=0`, and paste the
last 20 lines of the test run in your final answer.
