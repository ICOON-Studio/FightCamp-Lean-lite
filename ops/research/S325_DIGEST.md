# S325 digest - Lean update 28: injuries and suspensions (2026-10-31)

## What now works (Lean a1893fd, 8f44db3; exported Builds/FightCamp.exe, all 48 suite tests green)
- `scripts/state/Injuries.gd` wires Qwen's InjuryRoll into the career:
  - after every bout a roll from the fight model's SETTLED head damage (m["damage"]["a"] x 2.2: a bout between equals carries
    ~22 damage, x2.2 puts its worst place at ~50 where InjuryRoll gives the real ~6 %; the 3D view never decides);
  - a stoppage loss = England Boxing's suspension (30 days; 90 for a second inside 90 days; 365 for a third inside a year),
    recorded in f["ko_history"];
  - each week a training roll from TrainingLoad (normal 10 h; a hard camp, protocol 3, 15 h = up to 3x the first week);
  - while out: no offers (next_offer_day held), training at the rest week's 25 %, open offers withdrawn, an injury running
    past a booked bout pulls her out (club pays BoutRules.MISSED_WEIGHT_COST $300 for the empty slot), news when cleared.
- Shown: fighter page Injuries row (red), roster NEXT BOUT column, result page ribbon "INJURY REPORT".
- Defect fixed: the result ribbon said "NO CHANGE" for members after a loss although update 27 takes members - shows -N red.
- Defect fixed: every career rolled the same dice (seeds from day + fighter id only) - `Career.seed` (randi() at quick start;
  old saves 0) feeds Injuries; the harness sets it per career.
- Defect fixed: `tools/run_tests.sh` lacked 7 tests (gym_bills, money_close, injury_roll, training_load, body_report,
  injuries, season_path) - the S324 modules were never in the export gate. All green now.
- Board: "Test: an injury pulls her out" (TestJump jump=injury, scheduled task + launch target + .lnk).

## Evidence
- tests/injuries_test.gd INJURIES failures=0 (suspension 30/90, ko_history, pull-out + $300, offers withdrawn, no offers while
  out, cleared, load history; control arms: fit fighter, stoppage WIN, strain healing before the bout).
- tests/test_jump_test.gd TESTJUMP failures=0 (injury jump lands on her page, bout gone, own save slot).
- Career harness (tools/career_harness.gd, n=40 x 26 weeks, Lucy +-4 stats, seeds per career, careless habits at p=0.5):
  careless closes 23 %, injured at least once 45 % (bout 7, training 17, pulled out 10); sensible closes 0 %, injured 43 %.
  Hard camps 53 % vs 39 % without. Plan bounds (careless 50-80, sensible 10-35) are judged at update 29 when the player
  chooses Light/Normal/Hard - the real training rate alone (1.3 % a 10 h week) gives ~29 % over 26 weeks to anyone.
- Stills (real renders, hidden desktop, tools/injury_still.gd): research/S325_stills/fighter_page_injured.png,
  roster_injured.png, result_page_injury.png (that hand injury was put on her for the picture). Review board + SendUserFile.

## Agents
- Qwen BODYREPORT1 collected (73d1394, BODY_REPORT 0) - the board's "dead" was a stale Lean run; the out file had it done.
- Qwen SEASONPATH1 briefed + launched + collected (1fb76dd, SEASON_PATH 0): eligibility (5 bouts, 91 days, Elite 19-40),
  entry close day 140 of each 364-day game year, regional + national schedule with byes, result words, HOME goal line.
- Qwen CHAMPDRAW1 running (seeds, standard seed order, byes, other bouts by rating) - branch qwen/champdraw1.
- John J-PRODEBUT1 queued (seat queue SQ24): what a UK pro debut costs (licence, medicals, opponent fee, tickets).

## Decisions (Claude, developer)
- The injury roll reads the words' fight model, never the 3D body map (K-FIGHT3D1: the 3D view shows, it never decides).
- Until update 29 a week trains "normal", a hard camp "hard"; real injury rates kept; bounds checked when the choice exists.
- Injuries.gd is its own state file: Bouts.gd is at 500 lines (the cap) - split it before anything else lands in it.

## Questions on the board
Q-S294-45 (update 27 verdict) still open; Q-S294-46 (update 28 verdict) added with the fighter-page still.

## Next
Update 29 (Light/Normal/Hard + load gauge + post-fight body report), then update 30 (the road to the nationals).
Structural debt: Bouts.gd at 500 lines - split (offers/booking vs fight night) in update 29 before wiring the body report.
