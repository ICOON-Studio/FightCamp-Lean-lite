# TASK TURNPROBE1 - turning pro: do the two promoters, the one ask and the timing make a real choice? (probe)

Status: OPEN (S523, Claude main line). Discipline: boxing. Model: qwen (any seat that runs Godot headless).
Source: design ops/research/DESIGN_TURNPRO1_V2_REVISE_KALLI_KALLI.md section 7 (the probes and their pass lines), built in
S523: scripts/rules/ProCall.gd (the numbers, every ESTIMATE a named constant), scripts/state/ProOfferWire.gd (the offer:
`offers`, `asked`, `expires`; `ask`, `back_to_plain`, `money`, `lapse_if_due`), scripts/state/Roster.gd check_pro /
turn_pro(c, house) / decline_pro / debut_night, scripts/state/ProLean.gd (the house's lean on the first 6 pro fights).
Nobody has measured whether signing early, waiting for rank, or picking a house is ever the right call.

## Contract
OWNS: tools/turn_pro_probe.gd, docs/TURNPROBE1_RESULT.md
RED_TEST: tools/turn_pro_probe.gd -> TURNPROBE1 done
REGRESSION: pro_offer_wire_test, pro_call_test, pro_lean_test, golden_path_test
VISUAL: no

## Prior research
`python ops/Tools/prior_research.py turning pro promoter probe`. Read tools/money_four_probe.gd and tools/career_harness.gd
(a career played by the sensible player, `_decide`), tools/harness_money.gd, tools/ladder_probe.gd (bouts fought),
docs/MONEYFOUR1_RESULT.md. ops/research/GDSCRIPT_TRAPS.md first.

## What would a human do?
Play the same careers five ways - sign at the first call, wait for rank, build the club first, never sign, follow the
boxer's wish - and compare the gym's cash at week 52 and 104. A real choice is one where the best way depends on the
club (stipend paid or not, members, the boxer's tickets).

## Prefab check
None needed: reuse career_harness.gd's decisions and harness_money.gd's sampling by preload; never edit them.

## The job
1. tools/turn_pro_probe.gd (SceneTree, headless): one-boxer careers from Career.quick_start, 104 weeks through Sim (as
   career_harness does), bouts accepted and fought. START SMALL: 30 careers per bot per seed set, 2 seed sets (4421,
   9001); print the wall time; scale to 200 per bot and 3 seed sets only if one set took under 15 minutes. Half the
   careers pay the stipend, half put the boxer on the day job (GymSpend, as money_four_probe does).
2. Bots, each answering c.pro_offer when it is open (never leave it to lapse unless the bot says so):
   YES - signs at the first call; first takes the ask whose ProOfferWire.money gives the gym the most by debut day.
   RANK - declines until rank 1 or a title, then signs (the door may close: count it).
   PREP - declines while members < 90 and only one house calls; signs at the first side-by-side call or 90+ members.
   NEVER - Stay amateur every time.
   AMB - signs if Recruit.ambition says pro, else declines once, then signs.
   For each signing pick the house whose ProOfferWire.money(...)["by_debut"] is higher.
3. Report per bot and seed set: cash at weeks 52 and 104 (median, p25, p75), share of careers where the bot had the best
   cash at 104, debut gym money < 0 share, door closed share, debut win rate split by opp_gap 1.0 / 1.5, how often both
   houses called together, how often Harrow & Finch was picked, each ask's pick share and each counter's take share,
   morale at signing (AMB). Then the design's nine pass lines (section 7) each PASS / FAIL with the number, and for each
   FAIL the ProCall constant that would move it (name it; do not change it).
4. docs/TURNPROBE1_RESULT.md with the population named (seeds, careers, stipend split), the tables, the reproduce line.
   Last printed line: `TURNPROBE1 done`.

## Rules for this seat
Godot only through `python ops/Tools/godot_slot.py run --who turnprobe1 -- <godot> --headless --audio-driver Dummy
--fixed-fps 60 --log-file E:/FightCamp/tmp/turnprobe1.log --path . --script res://tools/turn_pro_probe.gd`.
Wrap the run in `timeout 3600`. No screens opened. Nothing outside OWNS; never touch scripts/fight3d/. No two identical
fighters in a measurement (each career its own seed and boxer).

## The one trap
check_pro runs after bouts and at the week's end only: an offer the bot never answers lapses after 14 days and the
promoter waits 2 more wins (ProOfferWire.lapse_if_due) - a bot that forgets to answer reads as "never offered". Answer
the offer the same day it opens (poll c.pro_offer every Sim day).
