# TASK GYMSURVIVE1 - does a fresh gym survive two years? (probe, no screen)

Status: OPEN (S530, Claude main). Discipline: boxing. Model: Goose (cloud) - a probe, no window.

## Why
Two probes this week ended their careers early: SIGPACE1 (docs/SIGPACE1_RESULT.md) froze every number from week 52 (its loop
stops at `c.closed`), and TURNPROBE3/3B ended every bot below $0 by week 104. The money probes so far cover half a year
(docs/MONEYFOUR2_RESULT.md, 182 days) or the start runway (docs/FOURMONEY1_RESULT.md). Nobody has measured whether a gym
run the way a sensible player runs it lives through two years - and if it closes, why.

## What to build (probe-side only - do NOT edit scripts/ or tests/)
New `tools/gym_survive_probe.gd` (under 450 lines). Population: `Career.quick_start()` (the game's own start: one walk-in boxer
signed, the shipped cash and members), 30 careers x 2 seeds (4421, 9001), 104 weeks, the game's day loop (Sim.step_day)
with the bout loop as tools/turn_pro_probe3.gd `_answer_open` does it (accept sheet offers, camps, weigh-ins, fight by the
sim, after_fight). Arms - the player's money policy, set on day 0 and held:
- PASSIVE: touch nothing (today's probes).
- SENSIBLE: one class night (ClubClasses, as MONEYFOUR2's N1), sign a second walk-in when one arrives and cash > 3 months
  of costs, accept the first pro offer (Roster.turn_pro with the plain deal).
- LEAN: SENSIBLE + the half stipend / day job for the boxer when cash < 8 weeks of costs (DayJob / the stipend switch).
Per arm print: share of careers closed by week 26 / 52 / 78 / 104, the median closure week, cash at weeks 13 / 26 / 52 / 104
(median [p10..p90]), members at the same weeks, and for every closed career the week's biggest cost lines at closure
(GymBills.week / GymSpend.costs) and income lines. Print `closed` and `final_day` per career in the log.

## Pass line (print it)
`GYMSURVIVE1 done arm=<arm> closed104=<share> med_close_week=<n|none>` per arm. Report only; never change a rule.

## Deliverable
`tools/gym_survive_probe.gd`, `docs/GYMSURVIVE1_RESULT.md` (method, tables, the closure causes), one PR adding only those two
files. Pilot with 4 careers first, print `arms=` / `pilot=` on the first line and the projected time; stop at 90 minutes.
RESULT: tools/gym_survive_probe.gd -> GYMSURVIVE1 done ...

## Contract
OWNS: tools/gym_survive_probe.gd, docs/GYMSURVIVE1_RESULT.md
RED_TEST: tools/gym_survive_probe.gd prints GYMSURVIVE1 done
REGRESSION: tests/gym_bills_test.gd, tests/game_money_test.gd (read-only)
VISUAL: no

## The trap
Bouts.after_fight clears f["bout"] in the same step - read fights from c.results (newest first). A closed career must stop
being sampled; never repeat its last snapshot into later weeks (SIGPACE1 did).

## Prior research
docs/MONEYFOUR2_RESULT.md, docs/FOURMONEY1_RESULT.md, docs/SIGPACE1_RESULT.md (Claude's read at the bottom),
ops/research/TURNPROBE3_READ_S530.md, scripts/state/GymBills.gd, scripts/state/GameMoney.gd.
## What would a human do?
Run a small club for two years the sensible way - a class night, a second boxer when there is room, the first pro deal -
and see whether the bank account survives it.
## Prefab check
None: our own probe.
