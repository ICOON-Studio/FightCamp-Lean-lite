# TASK PRODEBUT1 - QWEN - what the pro debut costs and pays: licence, medicals, tickets, her share (Lean, update 31)

Model: Qwen (qwen3-coder, --yolo). Discipline: boxing (demo). Repo: E:\FightCamp\Lean (NOT the old Game repo).
Workspace: your own worktree E:\FightCamp\wt\LEAN_GYMBILLS1 (branch qwen/prodebut1). Commit there; do not push.

## Why
Update 31: a pro debut on a small-hall show is not a fixed purse. The boxer needs a BBBofC licence and brain scans, the
promoter gives her 100 tickets to sell, the first ~60 pay for the night (the opponent's fee, the hall, the officials), and
she gets half of what she sells above that. John measured it (E:\FightCamp\Game\research\J_PRODEBUT1_JOHN.md). Game
money is GBP x 1.25. This module is the money sheet; Claude wires it into the pro offer and the debut night.

## Owned files (create both; touch nothing else)
- `scripts/rules/ProDebut.gd` (new, under 120 lines, `extends RefCounted`, static functions only, ZERO preloads)
- `tests/pro_debut_test.gd` (new, `extends SceneTree`, same shape as `tests/season_path_test.gd`; prints
  `PRO_DEBUT failures=<n>`; quit(1 if failures else 0))

## The module
```
const LICENCE := 230          # BBBofC boxer licence, GBP 184 a year
const MEDICALS := 875         # first licence: MRI + MRA, medical + bloods, eye test, about GBP 700
const CORNER_LICENCE := 140   # the gym's trainer/second licence, GBP 110 a year
const TICKETS := 100          # tickets the promoter hands her to sell
const TICKET_PRICE := 50      # GBP 40
const BREAK_EVEN := 60        # the first 60 sold pay the promoter's night (opponent fee + expenses + hall)
const HER_SHARE := 0.5        # of the ticket money above break-even
const MANAGER := 0.15
const TRAINER := 0.10         # the gym is her manager and trainer: it keeps MANAGER + TRAINER of her share
const FAMILY := 20            # family and friends buy this many whatever happens
const PER_MEMBER := 0.5       # each gym member buys half a ticket (round DOWN the member part: members / 2)
const PER_WIN := 2            # each amateur win brings two
const PER_TITLE := 10         # each championship title she holds brings ten

## What the gym pays when she signs: LICENCE, plus MEDICALS on her first licence, plus CORNER_LICENCE when the gym's
## trainer is not licensed yet.
static func start_costs(first_licence: bool, trainer_licensed: bool) -> int

## Tickets she sells: FAMILY + floor(members * PER_MEMBER) + PER_WIN * am_wins + PER_TITLE * titles, clamped 0..TICKETS.
## Negative inputs count as 0.
static func tickets_sold(members: int, am_wins: int, titles: int) -> int

## The night's money for `sold` tickets (clamped 0..TICKETS) and the promoter's terms (1.0 first promoter, 0.9 second):
## {"sold": int, "money": sold * TICKET_PRICE, "above": max(0, sold - BREAK_EVEN),
##  "share": int(round(above * TICKET_PRICE * HER_SHARE * terms)),
##  "gym": int(round(share * (MANAGER + TRAINER))), "her": share - gym}
## Below break-even she fights for nothing: share 0, gym 0, her 0 (never negative - no debt to the promoter).
static func night(sold: int, terms: float) -> Dictionary

## The sheet shown on the pro offer before the player signs:
## {"costs": start_costs(first_licence, trainer_licensed), "sold": tickets_sold(members, am_wins, titles),
##  "night": night(sold, terms), "gym_net": night.gym - costs}
static func sheet(members: int, am_wins: int, titles: int, first_licence: bool, trainer_licensed: bool, terms: float) -> Dictionary
```

## Tests (all must pass)
1. Write this first and see it fail (module missing): start_costs(true, false) == 1245.
2. start_costs(true, true) == 1105; start_costs(false, true) == 230; start_costs(false, false) == 370.
3. tickets_sold(40, 7, 0) == 54 (20 + 20 + 14); tickets_sold(41, 7, 0) == 54 (member part rounds down);
   tickets_sold(40, 7, 1) == 64; tickets_sold(0, 0, 0) == 20; tickets_sold(200, 20, 5) == 100 (clamped);
   tickets_sold(-5, -1, -1) == 20.
4. night(60, 1.0): above 0, share 0, gym 0, her 0, money 3000.
5. night(100, 1.0): above 40, money 5000, share 1000, gym 250, her 750.
6. night(70, 1.0): above 10, share 250, gym 63 (round 62.5 -> 63 in Godot), her 187. night(70, 0.9): share 225, gym 56, her 169.
7. night(30, 1.0): share 0, her 0 (no debt); night(150, 1.0)["sold"] == 100; night(-3, 1.0)["sold"] == 0.
8. For every sold 0..100 and terms in [1.0, 0.9]: her >= 0, gym >= 0, gym + her == share, share never falls as sold rises.
9. sheet(40, 7, 1, true, false, 1.0): costs 1245, sold 64, night.share 100, night.gym 25, gym_net -1220.
10. sheet(120, 9, 2, false, true, 1.0): sold 100, costs 230, gym_net 20.
11. Every result Dictionary has exactly the keys listed above (night: sold, money, above, share, gym, her; sheet: costs,
    sold, night, gym_net).

## The one test command (from the worktree root)
```
"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script tests/pro_debut_test.gd
```
Use exactly that exe (never the console variant). Output must show `PRO_DEBUT failures=0` and no `SCRIPT ERROR`. No output in
60 s = a script error. Regression (must stay green): `tests/season_path_test.gd` -> `SEASON_PATH failures=0`.
Read `E:\FightCamp\Game\research\GDSCRIPT_TRAPS.md` first (Variant `:=`, `%%`, integer division: write floor() on a
float, never `int / int` for the member part).

## Prior research
searched: pro debut purse ticket licence (S329). Game `research/J_PRODEBUT1_JOHN.md` (the measured table these
numbers come from); Kalli K-PROLINE1 (the old flat $1,500 debut purse this replaces; GYM_SHARE 0.35 had a 25 % manager cut
John found no source for - 15 % is typical).

## What would a human do?
A small-hall promoter hands a debutant ~100 tickets at GBP 40; her family, her gym and her amateur following buy them; the
first ~60 cover the opponent (about GBP 1,200 + GBP 300 expenses) and the hall; above that she gets about half, and her
manager (15 %) and trainer (10 %) take their cut. Before any of it she pays the BBBofC licence and the brain scans.

## Prefab check
Nothing to buy: a few static functions over our own numbers.

## Contract
OWNS: scripts/rules/ProDebut.gd, tests/pro_debut_test.gd (Lean repo)
RED_TEST: tests/pro_debut_test.gd (fails before the module exists - test 1)
REGRESSION: tests/season_path_test.gd
VISUAL: none (pure rules)

## When done
Commit both files on qwen/prodebut1, message ending `RESULT: tests/pro_debut_test.gd -> PRO_DEBUT failures=0`, and paste
the last 25 lines of the test run in your final answer. Leave this brief uncommitted.
