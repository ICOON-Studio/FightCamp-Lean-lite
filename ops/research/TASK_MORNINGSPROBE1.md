# TASK MORNINGSPROBE1 - coached mornings: is solo vs shared a real choice? (probe, no game change)

Status: OPEN (S511, Claude main line). Discipline: boxing. Model: qwen3-coder (or any seat that runs Godot).
Source: the club week (owner Q-S294-241 "Yes, build it after the fight week"), map
ops/research/DESIGN_CLUBWEEK1_V9_REVISE_KALLI_KALLI.md 3.5 + section 9: "MORNINGS1 requires each to be best in 30-70 in
100 seeds" and "no screen before its table". scripts/rules/CoachedMornings.gd (owned, mult, weak_spot, deal, added) is on
main with its test, but no probe ever measured it, so the multipliers (SOLO 1.25, SOLO_WEAK 1.4, SHARED 1.15) are
ESTIMATES and the mechanic is not wired. The WEAK SPOT line is wired (S511: Training > MORNINGS). This probe decides
whether the coached-morning deal is worth a screen.

## Contract
OWNS: tools/mornings_probe1.gd, docs/MORNINGSPROBE1_RESULT.md
RED_TEST: tools/mornings_probe1.gd -> MORNINGSPROBE1 done
REGRESSION: coached_mornings_test, training_k_test
VISUAL: no

## Prior research
`python ops/Tools/prior_research.py coached mornings weak spot`. Read CoachedMornings.gd (header + deal), the map 3.5
table, WeekPlan's morning gain (a fifth of the week's pace x coach factor x headroom), and tools/ask_probe2.gd for a
real-bout loop (seed 4421 population). ops/research/GDSCRIPT_TRAPS.md first.

## What would a human do?
Give the same gym of four boxers 12 weeks of mornings three ways - all shared pairs, all solo, solo on each boxer's
weak spot - and see which wins more bouts and moves the record, on many seeds.

## The job
1. tools/mornings_probe1.gd (SceneTree, headless): the test club (scripts/state/TestClub.gd: three boxers + the BJJ
   athlete; mornings apply to the three boxers), sessional coach (6 coached mornings) and full-time (7). 100 seeds.
   Three policies for 12 weeks: ALL SHARED (pairs on the same ability), ALL SOLO (on each boxer's lowest ability),
   WEAK FIRST (solo on the WEAK SPOT when a boxer has one, else shared). Apply each morning's gain x
   CoachedMornings.mult(use, on_weak) on top of WeekPlan's normal morning gain; nothing else changes.
2. After the 12 weeks, each boxer fights 10 even bouts through the game's real bout (as ask_probe2 does) against
   opponents of the population's spread. Report per policy: stat points gained (sum and on the weakest ability), win
   rate, and on how many of the 100 seeds each policy is best. Bar from the map: each policy best on 30-70 of 100 seeds
   = a real choice; a policy best on more than 70 = dominant (name the multiplier that would move it).
3. docs/MORNINGSPROBE1_RESULT.md with the table and the population named. Last printed line: `MORNINGSPROBE1 done`.

## Rules for this seat
Godot only through godot_slot, headless, `--audio-driver Dummy`, `--fixed-fps 60`, `--log-file E:/FightCamp/tmp/<run>.log`.
No screens opened. Nothing outside OWNS; never touch scripts/fight3d/. No two identical fighters in a measurement.

## The one trap
The morning gain is clamped by headroom (potential - stat): a weak spot far under potential gains more anyway. Compare
policies on the SAME boxers and seeds, so the headroom difference is the policy's, not the population's.
