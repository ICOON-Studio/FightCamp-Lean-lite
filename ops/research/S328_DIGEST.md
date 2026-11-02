# S328 digest - Lean update 30: the road to the National Amateur Championships (2026-11-01)

## Board
- Q-S294-47 (update 29 verdict) had no answer at session start; it stays open beside the update 30 question.

## What now works (Lean main, exported as update 30)
- `scripts/state/Champs.gd` (new, ~300 lines) wires the pure rules SeasonPath + ChampDraw (Qwen, S326) into the career.
  Entry: England Boxing's NAC rules from SeasonPath.eligible (5 bouts, 91 days with the club - new fighter key
  `joined`, set at signing; old saves count from day 0 - Elite age 19-40, fit, not pro); the entry window opens 56 days
  before the close (day 84 = Mon 30 Mar, close day 140 = Mon 25 May); a booked bout on or after the regional's eve
  blocks entry. Entering makes her Elite (`elite`), answers any open offers, and stops new ones while she is in it.
- The London regional: her + 3 of the region's women in her division (shuffled by the career's dice), ChampDraw seeds
  (rating high to low), semi Mon 8 Jun, final Mon 15 Jun. Win it -> the national draw: 8-12 of the other regions'
  champions (`NationalField.gd`: fictional names, real club names outside London, rating 62-73 vs London's 58-72), top
  seeds get the byes; rounds on SeasonPath's days (13 Jul, 14 Jul, 20 Jul, 21 Jul).
- Each round is a normal booked bout (`bout["champ"] = stage`): camp when there is time, weigh-in, the corner, the 3D
  fight. No ticket cut at a championship; no draw (level cards go to whoever took the last round - amateur judges pick
  a winner). After the bout `Bouts.after_fight -> Champs.after_bout`: ChampDraw.winners settles the other pairs with
  the career's dice, a loss ends the run (SeasonPath.result_words), a win books the next round. A bye passes on its
  day (`Champs.day_events`, last in `Sim.step_day`). An injury past the day: a head knock/suspension withdraws her, any
  other injury gives the update 29 choice (pull out = withdrawal, no $300 slot fee; fight hurt); missed weight =
  withdrawal. The result goes on her record (`titles`); a national finalist gets the promoters' call (Roster.pro_ready).
- Pages: HOME - her season line under her name (the road / "Ready for the nationals - enter before entries close in N
  days" / "Nationals: regional semi-final vs X, Mon 8 Jun" / "Nationals 2026: Regional champion") and an amber need
  "Enter Lucy for the nationals" -> WORLD > Nationals. WORLD has a 5th tab NATIONALS: the road card (bouts, weeks, age,
  fit, entry window, the dates, Enter), HER ROAD (round by round, coloured) and THE DRAW (every pair as boxed). FIGHTS >
  Calendar and WORLD > Events carry entries closing and her rounds.
- TestJump `nationals` (board button "Test: the road to the nationals (update 30)", Play task registered): a known
  career (seed 1) plays its first bouts - offers taken, a camp each, bouts simmed - until she can enter (day 91, 5-1),
  then opens WORLD > Nationals. First try found she missed weight every bout without a camp; the jump sets the camp.

## Decisions (developer)
- Every round reuses the existing bout flow instead of a tournament mode: no new fight code, the corner and the 3D view
  work in the championship for free, and the injury choice applies as it is.
- No entry fee and no travel costs: England Boxing's NAC entry is through the club; the plan's money step is the pro
  debut (John's J_PRODEBUT1 numbers), not the amateur championships.
- The national field is generated from the career's dice (one per season and division) rather than a hand-written
  bank per division: four women's divisions would have needed 40+ hand-made boxers for a view the player sees once a
  season.

## Evidence
- tests/champs_test.gd (new): entry rules and order, HOME needs row, regional draw + day 154 booking, no offers while in,
  semi -> final opponent is the other semi's winner, national draw size and days, National champion + titles + pro
  call, offers resume (control), loss words, a bye on its day, pull-out and missed-weight withdrawals (no fee), a
  head suspension withdraws, 40 real championship nights: 0 draws, 0 ticket cuts; control club bout pays $450; the
  national field is unique/deterministic; a save keeps the run. CHAMPS failures=0.
- tests/test_jump_test.gd: nationals jump eligible on WORLD > Nationals (day 91, 5-1), Enter books (or follows her bout).
- Full Lean suite (tools/run_tests.sh) green; export rebuilt it (see Lean log); stills in S328_stills/ opened and checked:
  nationals_road, home_season, nationals_entered, calendar, home_entered, national_draw, national_champion.

## Next
- Operator verdicts: Q-S294-47 (update 29) and the update 30 question.
- Update 31: the pro debut costs money (John J_PRODEBUT1: licence, the opponent's fee, tickets to sell).
