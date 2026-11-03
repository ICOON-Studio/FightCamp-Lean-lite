# S373 digest (2026-11-03, Claude) - Lean 53ae555d -> (see HANDOFF)

## What happened
- Collected John J_TESTS4 (research/J_TESTS4_ANSWER.md): two same-device boxing studies put men:women rear-hand force at
  1.34-1.39 (Busko 2016 club 1.36; Loturco 2016 national team 1.34-1.39); novice 1.7 ESTIMATE. Men's force anchors
  830 / 1,080 / 1,340 N (TestDay.POWER_MEN_AT) - Danny's wall has the force row.
- Collected Kalli K_CALIB1 (research/K_CALIB1_ANSWER.md): women's bleep club anchor 60 -> 8.0 (SkillAwards.BLEEP_WOMEN_AT);
  punches shown to 0.1 as the average of 3 tries, force in 25 N steps (about 5 new bests a 12-week camp per test, not
  2 / 10); a norm word BEGINNER / CLUB / ELITE for that sex beside every records-wall number (TestDay.norm; CLUB from
  halfway to the club mark after the still showed Danny's 12.2 as BEGINNER).
- Danny's missed weight: the cut model is sourced (500 kcal/day + Reale 2017 fight-week 0.5-1 %), the gap was the offer
  saying nothing. Sim.weigh_forecast dry-runs the camp to the weigh-in (matches the real days to 0.01 kg); the offer's
  TERMS show "On the scale: 61.6 now, 60.5 on the day" (green/red) and a red warning. John J_WEIGHT1 sent for real
  amateur cut rates before any change to the model.
- FLOWBOUT1 on screen: the Record tab says what the plan did each night; PLAYBOOK > Game plan lines show "In bouts: 8 of
  12 won, works" (PlanRecord.rates/verdict). plan_record_ui_test 5/0.
- Women's classes 57 / 60 / 65 / 75 kg (John J_MEN1: 61.2 in no rulebook, 66 dropped 1 Jan 2025); Lucy 61.4 and Samira
  66.4 keep the 1.4 kg cut; SaveGame._classes_2025 moves an old save once. women_classes_test 6/0.
- GOALTESTS1 phase 2: a passed grade's moves are graded - combo card border + "<Grade> grade" chip, 8 % less gas (Gold
  15 %; SkillAwards.ECONOMY, ESTIMATE) on the card and in the bout (Combos.round_spend econ over RoundStyle.SHARE:
  Standard alone = -5.5 % of a round's punch gas). Kalli K_GRADED1 sent for the numbers.
- Operator S369 fight items: tired legs - BodyBurn's emptying tank now raises the legs' Burn (holo + HUD legs ring amber
  then red), shortens steps and lightens shots (TANK_POWER 0.6, ESTIMATE); burn_probe round 3: Maria's holo legs red,
  steps 0.91 from the tank alone. "Exchanges won" now says what an exchange is. tired_legs_test 7/0.
- Brief defects 35 -> 0 (John/Kalli briefs Kind: research; finished ones DONE/SUPERSEDED; content briefs exempt).
- FIGHT9 round 2 (agy, PR #25): delivered, but its after-film was NOT JUDGED - Gemini's project hit its MONTHLY SPEND CAP
  (HTTP 429; our log: $8.65 in November) - and loop_next read the missing score as a drop, queueing R3 back on round 1.
  Its RED_TEST probe also had agy's own parse error (BeatClips.speed one argument). Claude fixed the probe (a6fadb9b on
  agy/fight9r2): 15/18 PASS - the operator's C218 moving legs fixed (knees over toes 4.4 deg, no cave 0.351 m), no
  referee, jab lands; 3 FAIL = the clinch breaks pass through (~34 frames). TASK_FIGHT9R3 rewritten: BASE agy/fight9r2,
  the push-off first. seat_dispatch (cf25e3d0): an unjudged film holds the loop (`rejudge <task>`), the compile gate
  --check-only parses the brief's RED_TEST/REGRESSION/tools scripts. Board Q-S294-94: raise the spend cap?
- BJJ9 (Ziva): rounds 6 and 7 committed on ziva/bjj9 (f1e25860); BJJ9_ROUNDS.md table stops at round 5 (4/10); her
  judging uses the same Gemini project, so she is blind too until the cap is raised.
- Queued Qwen PASSEDSTAMP1 (the PASSED stamp card in the week review when a grade passes).
- Stills: ops/previews/S373/ (offer forecast green + red, records walls, graded combos, record plan, burn round 3) - on
  the review board.

## HANDOFF
- Working commit: see `git log -1` on main (pushed); CI green on every push this session; exe: Builds/ (update 70) - see
  export.log in ops/previews/S373/.
- In flight: FIGHT9R3 (agy, queued - the reconcile launches it; BASE agy/fight9r2); PASSEDSTAMP1 (qwen, queued); John
  J_WEIGHT1 and Kalli K_GRADED1 (gbot threads); Ziva BJJ9 on ziva/bjj9 (round 8 next).
- Blocked on the operator: Q-S294-94 - the Gemini monthly spend cap (ai.studio/spend). Until then no Argon verdicts.
- Remaining: FIGHT9 + BJJ9 to 9/10; rejudge FIGHT9R2 (and R3) once the cap is raised; collect PASSEDSTAMP1 (add its test
  to run_tests.sh); apply J_WEIGHT1 (cut rates) and K_GRADED1 (economy %); guide_tour with Danny + Ana (not run this
  session); the 3D pad-round test-day moment (agents); scouting -> plan.
- Exact next action: read the board for Q-S294-94; if raised, `python ops/Tools/seat_dispatch.py rejudge FIGHT9R2`;
  read seat_dispatch.log for FIGHT9R3 / PASSEDSTAMP1; collect John J_WEIGHT1 and Kalli K_GRADED1 (gbot thread).
