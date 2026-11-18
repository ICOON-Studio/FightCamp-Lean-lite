# TASK MONEYFOUR2 - class nights on the BUILT club week: is the money worth the pad time lost? (probe)

Status: OPEN (S520, Claude main line). Discipline: boxing. Model: qwen (any seat that runs Godot headless).
Source: club week v11 built S519 (ops/research/CLUBWEEK1_BUILD_S519.md: "MONEYFOUR2 (class money vs mastery lost)").
scripts/rules/ClubClasses.gd: a weekday pad evening turned into a class = +$117 that week (ClubDeal.class_cash), a new
member every 16 class nights (MEMBER_A_NIGHT 0.0625, an ESTIMATE), and every boxer on pads that evening drills at the bag
rate (BAG_SHARE 0.5: half the mastery). Nights live in career.coach["classes"] (dows 0-4); ClubWeek reads them.
Nobody has measured whether 0, 1, 2 or 5 class nights is ever the right call.

## Contract
OWNS: tools/money_four2_probe.gd, docs/MONEYFOUR2_RESULT.md
RED_TEST: tools/money_four2_probe.gd -> MONEYFOUR2 done
REGRESSION: class_nights_test, club_week_walk_test
VISUAL: no

## Prior research
`python ops/Tools/prior_research.py class nights money mastery`. Read docs/MONEYFOUR1_RESULT.md and tools/money_four_probe.gd
(a year of a four-fighter club's money), scripts/rules/ClubClasses.gd, scripts/rules/ClubDeal.gd, scripts/state/ClubWeek.gd
lines ~120-175 (the class night on the bag), scripts/ui/areas/Training.gd ~115 (the toggle the screen uses),
tools/ladder_probe.gd (bouts). ops/research/GDSCRIPT_TRAPS.md first.

## What would a human do?
Run the same club a season with no extra class night, one, two and every weekday, and put the extra money beside what the
boxers lost: move mastery, record, ladder points. A real choice is one where the answer depends on the club's state
(cash short vs boxers near a fight).

## Prefab check
None needed: reuse money_four_probe.gd's money sampling and ladder_probe.gd's bout loop by preload; never edit them.

## The job
1. tools/money_four2_probe.gd (SceneTree, headless): the TEST CLUB (TestClub.gd) with Reid sessional, 30 seeds from 4421,
   182 days through Sim.step_day, sheet offers accepted and bouts fought as ladder_probe.gd does.
2. Arms: classes on 0, 1 (Wed), 2 (Tue+Thu) and 5 weekday nights, set through ClubClasses.toggle on c.coach on day 0.
   A fifth arm, CASH-SHORT: the 2-night arm with cash set to 4 weeks of costs on day 0 (does the money save the gym?).
3. Report per arm: extra class cash over the run, members joined from classes, cash at day 182, weeks below $0, each
   boxer's move mastery gained (sum over moves), win rate, ladder points at day 182. Then the trade in one line per arm:
   "$X more for Y mastery and Z wins fewer". Bar: no arm should win on BOTH money and record by a wide margin (that arm
   is a free lunch: name the number - $117, BAG_SHARE, MEMBER_A_NIGHT - that would fix it).
4. docs/MONEYFOUR2_RESULT.md with the population named, the tables, the reproduce line. Last printed line: `MONEYFOUR2 done`.

## Rules for this seat
Godot only through `python ops/Tools/godot_slot.py run --who moneyfour2 -- <godot> --headless --audio-driver Dummy
--fixed-fps 60 --log-file E:/FightCamp/tmp/moneyfour2.log --path . --script res://tools/money_four2_probe.gd`.
No screens opened. Nothing outside OWNS; never touch scripts/fight3d/. No two identical fighters in a measurement.

## The one trap
The coach's usual $350 adult class (GameMoney.CLASSES_WITH_COACH) is NOT the extra class night: do not count it in the
arms' difference. Mastery lost only shows on boxers who had pad evenings: read it per boxer, never pooled with Ana (mats).
