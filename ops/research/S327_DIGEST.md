# S327 digest - Lean update 29: the board verdicts on money and injuries, the load model, the body report (2026-10-31)

## Board answers acted on (quoted)
- Q-S294-45 (update 27): "Money too harsh".
- Q-S294-46 (update 28): "optiononplayer if he pulls out. needs to be clear to theplayer about how serious,how many weeks it the
  injury will heal ,to judge".

## What now works (Lean main 1f42951, e8aa789 + the golden-path seed commit; exported as update 29)
- Money (GymBills / BoutRules / Needs): the gym closes after 8 weeks in a row below $0 (was 4); a loss costs 1 member, a
  stoppage loss 2 (was 3 / 5); an open sponsor offer is a HOME need ("A sponsor is waiting: ...") that opens MONEY > Deals.
- Injury choice (Injuries.gd): every line says how serious (minor <= 14 days, moderate <= 28, serious longer) and the day she
  is fit; an injury past a booked bout sets choice "pending" = a red need that stops time and opens a locked modal: Pull her
  out ($300 slot) or She fights hurt (10 / 15 / 20 off her tank at the first bell by severity; after the bout the days left
  x 1.5). A head knock or a stoppage suspension is never a choice (no doctor clears a head injury) - she is pulled out.
  TestJump "injury" now lands on the choice.
- Load model (TrainingLoad / InjuryRoll / Injuries): "her usual" is an EWMA (Williams et al. 2017) whose span is the
  Banister fitness time constant (42 days): weekly weight 1 - e^(-7/42) = 0.1535; stored f["chronic"] (old saves' f["load"]
  read once as their average). Back from a rest week at Normal = 1.12x, safe (the 4-week average read 1.21-1.38x). A camp
  starts at the hardest setting that stays safe vs her usual, never below Normal (TrainingLoad.camp_default); the Hard camp
  protocol ("biggest gains, more risk") still trains Hard.
- Qwen BOUTBURN1 collected by diff (2 added files, BoutBurn.gd + bout_burn_test.gd, BOUT_BURN failures=0; in run_tests.sh).
- Update 29 part B: BoutNight._finish -> BoutBurn.per_round -> BodyReport.report + change_line (f["last_body_report"]);
  the result page shows BODY REPORT ("Lucy's jab arm went in round 2. Next week: Technique.") with a button that sets her
  focus (act bodyfocus). Golden path checks both.

## Evidence
- Harness n=40 x 26 weeks, before the money change: careless closed 25 %, sensible 0 % (min cash ~12,400 of 14,600).
- After all S327 changes: careless closed 15 % (6, all at week 24), sensible 0 %; injured at least once careless 53 %,
  sensible 48 % (training 15, bout 8, pulled out 8 in 40 careers).
- tools/roll_probe.gd: the game's injury seeds give 1.25 % hurt weeks at a 1.3 % chance (13 / 1040; free RNG control 0.96 %) -
  the dice are fair, the excess came from the camp's jump to Hard (a 1.5x week = 3x risk every camp).
- Tests: the export gate (tools/run_tests.sh, 50 tests) - golden path went red once on a random Career.seed (a debut-camp
  injury); fixed by a fixed seed in the golden path (2 runs green), then the gate ran again inside the export.

## Decisions (Claude, developer)
- Money: soften the two levers that are not real-world (the 4-week close; members walking out after one loss) and surface
  the sponsor, instead of raising start cash (S324: $25,000 start cash meant money never forced a decision).
- Injury bound revised: sensible 10-35 % cannot hold with real rates - 1.3 per 1000 h training over 26 normal weeks gives
  ~29 %, 3.7 bouts at ~6 % give ~20 %, together ~43 %. New bound sensible 30-50 %, careless above sensible and 50-80 %.
  The rates stay real.
- The golden path plays one known career (fixed seed); balance spread is the harness's job.

## Next
- Operator verdict on update 29 (board question). Then update 30: the road to the nationals (SeasonPath + ChampDraw).
