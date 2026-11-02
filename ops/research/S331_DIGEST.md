# S331 digest - Lean update 33: the nationals come sooner (2026-11-01)

## Board
- Q-S294-48 (update 30, the road to the nationals) answered: "Too long to reach". Acted on (below).
- Still open: Q-S294-47 (update 29), Q-S294-49 (update 31), Q-S294-50 (update 32 look).

## What now works (Lean, exported as update 33)
- The 3-months rule counts from her England Boxing REGISTRATION, as the sourced rule says ("5 bouts + 3 months'
  registered membership", TASK_SEASONPATH1 / England Boxing 2026 Elite NAC guidance) - update 30 had counted 3 months
  with OUR club, so a 3-1 walk-in waited 13 weeks for nothing.
  - `Roster.registered_day(f, day)`: a fighter keeps a given "registered"; otherwise one with bouts on her card
    registered bouts x AmateurBooking.LEAD_WEEKS_MAX weeks before signing (she boxed them at most at the club-show
    pace); a novice registers the day she signs. Lucy (3-1) = day -112.
  - `Champs.club_days` reads "registered" (old saves: "joined", then day 0).
  - Words: "Needs 3 months registered (N weeks to go)", HOME "Road to the nationals: 4/5 bouts, entries close in N days"
    (the weeks part shows only while she is short of 13), Nationals ring REGISTERED.
- Game calendar (our decision, not a sourced date): entries close day 70 / week 10 (was 140 / week 20);
  NATIONALS_GAP 21 days (was 28).
- Measured in the real flow (TestJump nationals, a known career): Lucy can enter on day 33 (week 5) - was day 91+
  (week 14); regional semi Mon 30 Mar, final Mon 6 Apr, nationals from Mon 27 Apr; the national final day 120
  (week 18) - was day 197 (week 29).

## Decisions (developer)
- Fixed the misread rule before touching the calendar: it is the real-world number, and it alone takes Lucy's wait
  from 13 weeks to one bout.
- Week 10 close: leaves a fresh quick start room for one bout at the 2-4 week lead plus a declined offer; a novice
  signed later carries over to next season (the road says so).
- 3 weeks regional final -> nationals: one camp's length, so each national round is still a normal bout with a camp.

## Evidence
- season_path_test, champs_test (new checks: a 3-1 walk-in registered day -112; a novice registered on day 0 needs 8
  more weeks; HOME counts registered weeks) PASS; test_jump_test, golden_path_test PASS; full suite 52/52
  (tools/run_tests.sh), export.sh green.
- Stills (research/S331_stills, tools/update30_still.gd on the hidden desktop), opened: nationals_road (week 5,
  REGISTERED 13 of 13, entries close Mon 16 Mar), nationals_entered (regional semi 30 Mar vs Aisha Rahman, draw),
  national_draw, national_champion, home_season, calendar.

## Next
- His verdicts on Q-S294-47 / 49 / 50 and the new update 33 question; MENULOOK1 (GYM, MONEY, FIGHTS, her page as
  pictures) waits on Q-S294-50.

---

# S331 part 2 (operator: "Keep going here") - update 34 + the HOME look question

## Board answers that came in during the session
- Q-S294-49 (update 31): "Yes, both right" - the debut costs and the Nationals page stay.
- Q-S294-50 (update 32): "Change the look first" (no note) - the picture pages are not to be copied to every page yet.

## HOME: three looks (Q-S294-52, mockups, not in the game)
- His earlier "Layout looks cheap / like a spreadsheet" (Q-S294-40) and "gym art is bright and alive" ruled out a
  re-tint of the brown cards. Three directions, same real content (Lucy vs Erin Doyle 25 Apr, the 4 needs, money,
  the next 4 weeks), HTML rendered headless (Edge, own profile, nothing on screen): research/S331_looks/
  A Fight bill (red/navy poster, the next bout as the hero, ticket-stub to-dos), B Gym whiteboard (bright: polaroid,
  marker notes, sticky notes, magnet planner), C Broadcast (tale of the tape, angled slabs, news ticker).
- All three show the boxers' faces. Finding: the pages CAN know her face - FightCast._class_body(limit) picks the body by
  weight class (S330's "the pages do not know" was wrong) - but there are only 3 bodies, so two lightweights share a
  face. Whichever look he picks, faces need a body per fighter (more bodies or variation) before the pages show them.

## INSIDEMISS1 fixed (update 34)
- Cause: GloveClear (after PunchReach and HitSnap in the stack) leans her trunk away from the other head up close; the
  lean carried the landing glove with it (the striking hand was only exempt from the glove clearance, not the lean).
- Fix: PunchReach.settle() re-lands the armed glove; GloveClear calls it after the head lean. `-- nosettle` = control.
- tools/hit_gap_probe.gd, 150 s, 26 landed each: settle 0 far (> 0.15 m), p50 0.008, max 0.084 m; nosettle 2 far
  (inside jab left -0.21, body hook short -0.15 at 1.12 m), p50 0.044, max 0.211 (baseline before the edit: 2 far, max 0.254).
- tools/inside_guard_probe.gd: gloves deep in a head inside 0/633 (control 2/633); heads apart unchanged (min 0.182 vs 0.188).
- Game-camera stills (tools/contact_stills.gd): S331_stills/inside_*_miss00-06cm.png - glove on the face, boots, both
  boxers whole.
