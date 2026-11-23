# S539 digest (2026-11-23, 03:00-05:10, Opus)

## Built (in the S539 build, Builds/FightCamp.exe; docs/WHAT_TO_TRY.txt)
- Pro weigh-in miss answers (owner "build the weigh-in miss answers for pro bouts", "do it here"): WeighMiss.gd + WeighMissWire.gd,
  weigh-in pop-up, GuardState feeds missed_weight; weigh_miss_test 13/13; 78cff7ff2; stills ops/previews/s539_weighmiss.
- Strong / OK / Bad replace Beats it / Works / Walks into it (owner "i do not understand it ... find something else"); f9a5bc0c7.
- Opponents adjust shown (PLANREADSHOW1, 983016e51); the false month-without-a-fight morale line cut (9ebfb3342);
  win read moves with mood (MOODREAD1 fe72931fd; Claude's "66 FAIL" was a bad run, bout_read_test 93/0 verified).

## Measured
- Combo counter REPEATBITE1 + 2: FAIL (best P2: spam read 34/100 and -6.1 v counter-puncher; varied plan read 17/100, bar < 15) -> Q-307.
- Club show v4 HOSTPROBE1 FAIL 2/10; v5 HOSTPROBE2 FAIL 3/9 (hall, reserves, sell, novice solved; promise now priced) -> Q-308.
- Deep coaches COACHDEEP1 PASS 5/5 (who coaches whom + chemistry); then the owner's 24 grilling answers
  (ops/research/COACHDEEP_GRILL_S539.md) -> COACHDEEP2 running. Kalli/Dola critics on v1 out (SQ302/303).
- Knowledge v7 (rival clock, Q-305 "Yes, add the deadline"): Kalli 7/6/6, Dola 8/7/8 -> v8.
- STEPPAY4 gate: 8 of 10 steps pass all legs (was 5); cut_off regressed, step_back v Slugger over -> STEPPAY5 running.
- LEDGERPROBE1 (S538) FAIL -> contract tab dropped.

## Decided by the owner
Q-305 rival deadline; Q-306 make repeats bite; card game plan "ok" (CARDGAME_PLAN_S539.md) and "written exclusively by
arena,dola,ludo ... claude coordinates"; deep coaches like Football Manager, 24 answers; 2D picture test yes; Matt Pocock skills
installed (mattpocock-skills plugin).

## Reference reads (our words only)
MMAEMPIRE1_COMPARE.md (camps, weigh-in answers, backups, activity list, round stats); FIGHTBIZ1_COMPARE.md (2D fight = ~60 paired
pictures + tweens behind a Godot-web 3D; round read with a range). The FIGHTBIZ1 worker overwrote his demo save slot 1 while he
played; restored; rule saved (memory feedback_reference_game_saves_s539).

## Lessons
- A finished tab's prompt line is Claude Code's suggestion, not the owner's words (memory corrected).
- Re-run a surprising red before acting on it (the 66-FAIL run).
