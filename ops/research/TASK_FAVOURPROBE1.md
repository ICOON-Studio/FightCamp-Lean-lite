# TASK FAVOURPROBE1 - where favours with the hosts sit after a year of real play (probe only, no rule change)

Status: OPEN (S514, Claude main line). Discipline: boxing. Model: qwen3-coder (or any seat that runs Godot).
Source: the fight week map ops/research/AMATEURWEEK1_MAP_V6_S455.md s7-8: "Favour test target: an average club sits at
1-2, not 3." Favours with each host club live in `Career.favours` ({club: n}; a club not there counts as 1,
scripts/state/FightWeekPlan.gd `favours()`; cap 3, scripts/rules/FightWeekEvents.gd FAVOURS_MAX).
Favours are EARNED only by a host's late ask (S514, scripts/state/LateAskWire.gd: yes = +1) and SPENT by: a partner
from another club paid with a favour (FightWeekPlan.gd ~line 260), the weigh-in's Ask for a kilo (~line 272), a missed
weight (scripts/state/PullOutWire.gd weigh_miss) and the fall-through's next-month slot (PullOutWire.answer).

## Contract
OWNS: tools/favour_probe.gd, docs/FAVOURPROBE1_RESULT.md
RED_TEST: tools/favour_probe.gd -> FAVOURPROBE1 done
REGRESSION: late_ask_test, pull_out_wire_test
VISUAL: no

## Prior research
`python ops/Tools/prior_research.py favours host fight week`. Read LateAskWire.gd, PullOutWire.gd, FightWeekPlan.gd
(favours, the partner pay, the kilo), tests/late_ask_test.gd (how a club is stepped through Sim.step_day),
tests/two_boxers_two_years_test.gd (a long run of the real day loop with decisions made in code),
scripts/ui/TestJump.gd `_tidy` (how open needs are answered so the clock never stalls). ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
Play a year at the club the way a sensible player would and count, at the end, how many favours the club holds with
each host it dealt with. Then do it for many seeds and two play styles.

## Prefab check
None: favours are our own rule; only our own sim can say where they settle.

## The job
1. tools/favour_probe.gd (SceneTree, headless): 40 seeds x 2 clubs (a quick-start club with Lucy, and the TEST CLUB
   scripts/state/TestClub.gd), each stepped 364 days through `Sim.step_day`. Decisions in code, two styles:
   THRIFTY = accepts every sheet offer, says YES to every late ask, pays partners from other clubs with a favour when it
   has one, asks for the kilo whenever the weigh-in offers it, answers a fall-through with next month when a favour is
   left (else take the replacement); EAGER = the same but says NO to every late ask (earns nothing: the floor).
   Every other open need answered as TestJump._tidy does. No identical fighters in a measurement.
2. Count per run: favours with every host touched at day 364, asks received / taken, favours spent by kind.
3. docs/FAVOURPROBE1_RESULT.md: the population, the table (style x club: mean favours per touched host, % of hosts at 0,
   1, 2, 3, asks a year, spends a year by kind), and one line: is the THRIFTY average club inside 1-2? Never change a
   rule or constant; report only.
Last printed line: `FAVOURPROBE1 done`.

## Rules for this seat
Godot only through godot_slot, headless, `--audio-driver Dummy`, `--fixed-fps 60`, `--log-file E:/FightCamp/tmp/<run>.log`.
No screens opened. Nothing outside OWNS; never touch scripts/fight3d/.

## The one trap
A club not in `Career.favours` counts as 1 (FightWeekPlan.FAVOURS_START), so read favours through
`FightWeekPlan.favours(c, host)` for every host in scripts/rules/RegionShows.gd HOSTS that the club met, never by
reading the dictionary alone.
