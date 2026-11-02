# TASK SEASONPATH1 - QWEN - the first season goal: the road to the National Amateur Championships (Lean, update 30)

Model: Qwen (qwen3-coder, --yolo). Discipline: boxing (demo). Repo: E:\FightCamp\Lean (NOT the old Game repo).
Workspace: your own worktree E:\FightCamp\wt\LEAN_GYMBILLS1 (branch qwen/seasonpath1). Commit there; do not push.

## Why
Operator S323 approved the make-it-a-game plan ("Build it"; `E:\FightCamp\Game\research\MAKE_IT_A_GAME_PLAN_S323.md`,
decision 6 "THE FIRST SEASON GOAL"): the road to the National Amateur Championships - 5 bouts and 3 months with the club to
enter, a regional qualifier, then up to 4 bouts at the nationals; entering makes her "Elite" for life. You write the ONE pure
module; Claude wires it into the calendar, the World page and the goal on HOME.

## Owned files (create both; touch nothing else)
- `scripts/rules/SeasonPath.gd` (new, under 170 lines, `extends RefCounted`, static functions only, ZERO preloads)
- `tests/season_path_test.gd` (new, `extends SceneTree`, same shape as `tests/body_report_test.gd`; prints
  `SEASON_PATH failures=<n>`; quit(1 if failures else 0))

## The module
```
## England Boxing 2026 guidance (Elite NAC): 5 bouts + 3 months' registered membership to enter; Elite age 19-40; entering
## the NAC moves the boxer to Elite for life (no more Development). Regional qualifier, then the national draw (up to 4 bouts).
const MIN_BOUTS := 5
const MIN_CLUB_DAYS := 91          # 3 months with the club
const AGE_MIN := 19
const AGE_MAX := 40
## Game calendar (a decision, not a sourced date): the championships run once a game year (364 days, day 0 = career start).
const YEAR_DAYS := 364
const ENTRY_CLOSE_DAY := 140       # entries close on day 140 of each game year (week 20)
const REGIONAL_START := 14         # first regional round, days after entries close
const REGIONAL_GAP := 7            # days between regional rounds
const NATIONALS_GAP := 28          # days from the regional final to the first national round
const NATIONAL_ROUND_DAYS := [0, 1, 7, 8]   # two weekends: last 16, quarter / semi, final (offsets from the first round)
const STAGE_NAMES := ["Regional semi-final", "Regional final", "National last 16", "National quarter-final",
	"National semi-final", "National final"]

## Can she enter? {"ok": bool, "reason": String}. Checks in THIS order, first failure wins:
## turned_pro -> "Professionals cannot enter"; injured -> "Injured or suspended";
## age < AGE_MIN -> "Too young for Elite (19+)"; age > AGE_MAX -> "Too old for Elite (40 max)";
## bouts < MIN_BOUTS -> "Needs 5 bouts (has <bouts>)";
## club_days < MIN_CLUB_DAYS -> "Needs 3 months with the club (<w> weeks to go)" with w = ceil((91 - club_days) / 7.0);
## all fine -> {"ok": true, "reason": ""}.
static func eligible(bouts: int, club_days: int, age: int, injured: bool, turned_pro: bool) -> Dictionary

## The day this year's entries close for a given game day (the NEXT close on or after `day`):
## entry_close(0) == 140; entry_close(140) == 140; entry_close(141) == 140 + 364.
static func entry_close(day: int) -> int

## Bouts to win a draw of `size` entrants: ceil(log2(size)); 0 for size <= 1. (2 -> 1, 3 -> 2, 4 -> 2, 5 -> 3, 16 -> 4.)
static func bouts_to_win(size: int) -> int

## Does she get a first-round bye? Byes = next power of two - size; byes go to the top seeds, so she gets one when
## seed <= byes (seed 1 = best). size 6: byes 2 -> seeds 1-2 get one. size 8: none. size <= 1: true.
static func has_bye(size: int, seed: int) -> bool

## Her schedule for one championship (regional draw size + seed, national draw size + seed) from the entry close day:
## an Array of {"stage": STAGE_NAMES index, "day": game day} for every bout she would box if she kept winning, in order.
## Regional: the LAST bouts_to_win(regional_size) stages of the two regional stages (1 bout -> only "Regional final");
##   a bye skips her first one. A regional bout of stage s (0 or 1) is on day close + REGIONAL_START + REGIONAL_GAP * s,
##   so the regional final is ALWAYS on close + 21 (the "regional final day", also when she has no regional bout).
## Nationals: the LAST bouts_to_win(national_size) of the four national stages (2-5), with the same bye rule; a national
##   bout of stage s is on day regional_final_day + NATIONALS_GAP + NATIONAL_ROUND_DAYS[s - 2].
## national_size is clamped to 2-16, regional_size to 1-4 (a regional draw of 1 = a walkover: no regional bouts).
static func schedule(close_day: int, regional_size: int, regional_seed: int, national_size: int,
		national_seed: int) -> Array

## The words for how far she went. reached = STAGE_NAMES index of her LAST bout; won_it = she won that bout.
## Won the national final -> "National champion"; lost the national final -> "National runner-up";
## lost a national semi -> "National bronze"; lost earlier at the nationals -> "Reached the <stage name lowercase>";
## won the regional final (no national bout yet) -> "Regional champion"; lost at the regionals -> "Lost in the <stage name
## lowercase>".  (Amateur semi-final losers both get bronze.)
static func result_words(reached: int, won_it: bool) -> String

## One line for HOME. not entered: "Road to the nationals: <bouts>/5 bouts, <w> of 13 weeks with the club, entries close
## in <d> days" (w = floor(club_days / 7), capped at 13; bouts capped at 5; d = entry_close(day) - day);
## eligible and not entered: "Ready for the nationals - enter before entries close in <d> days".
static func goal_line(day: int, bouts: int, club_days: int, ok: bool) -> String
```

## Tests (all must pass)
1. Write this first and see it fail (module missing): eligible(5, 91, 22, false, false) == {"ok": true, "reason": ""}.
2. Order: eligible(0, 0, 17, true, true).reason == "Professionals cannot enter"; eligible(0, 0, 17, true, false).reason ==
   "Injured or suspended"; eligible(0, 0, 17, false, false).reason == "Too young for Elite (19+)";
   eligible(9, 200, 41, false, false).reason == "Too old for Elite (40 max)".
3. eligible(3, 200, 22, false, false).reason == "Needs 5 bouts (has 3)"; eligible(5, 77, 22, false, false).reason ==
   "Needs 3 months with the club (2 weeks to go)"; eligible(5, 90, 22, false, false).reason ends "(1 weeks to go)".
4. entry_close(0) == 140; entry_close(140) == 140; entry_close(141) == 504; entry_close(600) == 868.
5. bouts_to_win: 0->0, 1->0, 2->1, 3->2, 4->2, 5->3, 8->3, 9->4, 16->4.
6. has_bye(6, 1) and has_bye(6, 2) true; has_bye(6, 3) false; has_bye(8, 1) false; has_bye(1, 1) true.
7. schedule(140, 4, 3, 16, 9): regional bouts at days 154 (stage 0) and 161 (stage 1); national bouts at 189, 190, 196,
   197 (stages 2, 3, 4, 5). Exactly 6 entries, in that order.
8. schedule(140, 2, 1, 8, 1): regional only stage 1 at day 161 (a 2-draw is the final; it keeps the final's day);
   nationals: 8 -> 3 bouts = stages 3, 4, 5 at 161 + 28 + [1, 7, 8] = 190, 196, 197.
9. Byes: schedule(140, 3, 1, 6, 2): regional draw 3 -> 2 rounds, seed 1 has a bye -> only stage 1 at 161; national draw 6
   -> 3 rounds, seed 2 has a bye -> stages 4, 5 at 196, 197.
10. Walkover: schedule(140, 1, 1, 2, 1) -> only the national final, stage 5 at 140 + 14 + 7 + 28 + 8 = 197 (the regional final
    day still counts as 161 for the gap).
11. result_words: (5, true) "National champion"; (5, false) "National runner-up"; (4, false) "National bronze";
    (3, false) "Reached the national quarter-final"; (1, true) "Regional champion"; (0, false) "Lost in the regional
    semi-final".
12. goal_line(0, 2, 35, false) == "Road to the nationals: 2/5 bouts, 5 of 13 weeks with the club, entries close in 140 days";
    goal_line(100, 7, 120, true) == "Ready for the nationals - enter before entries close in 40 days".
13. Same input -> same output; no function changes its inputs.

## The one test command (from the worktree root)
```
"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script tests/season_path_test.gd
```
NEVER the `_console.exe`. Output must show `SEASON_PATH failures=0` and no `SCRIPT ERROR`. No output in 60 s = a script
error: run `python tools/check_scripts.py scripts/rules/SeasonPath.gd` if it exists, else read your code for a typo.
Regression (must stay green): `tests/body_report_test.gd` -> `BODY_REPORT failures=0`.
Read `E:\FightCamp\Game\research\GDSCRIPT_TRAPS.md` first (Variant `:=`, `%%`, integer division).

## Prior research
searched: national championships amateur entry regional (prior_research.py). Game `research/MAKE_IT_A_GAME_PLAN_S323.md`
(numbers table: England Boxing 2026 guidance - 5 bouts + 3 months, regional entry, up to 4 bouts, Elite for life);
`research/G101_SKILL_BAND_WORDS.md` (entering the EB NAC locks the boxer out of Development; 3x3 min);
`research/C52_THE_TOURNAMENT_AND_THE_GRADE.md` (store the organiser's format and a variable bout count, never one bracket
shape - hence draw sizes and byes). Lean `scripts/rules/AmateurBooking.gd` (bouts_of, read only).

## What would a human do?
A club coach counts his boxer's bouts on her medical card and her months of registration, sends the entry form before the
closing date, and plans the camp backwards from the regional draw. Draws are published with byes for the top seeds; the
national stages run over two weekends, so a boxer may fight on consecutive days.

## Prefab check
Nothing to buy: a pure calendar/eligibility module over our own state.

## Contract
OWNS: scripts/rules/SeasonPath.gd, tests/season_path_test.gd (Lean repo)
RED_TEST: tests/season_path_test.gd (fails before the module exists - test 1)
REGRESSION: tests/body_report_test.gd
VISUAL: none (pure rules)

## When done
Commit both files on qwen/seasonpath1, message ending `RESULT: tests/season_path_test.gd -> SEASON_PATH failures=0`, and
paste the last 25 lines of the test run in your final answer. Leave this brief uncommitted.
