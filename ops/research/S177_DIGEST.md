# S177 DIGEST - BUYER1 items 1-3 done, the hall runs the career's mornings; stills + 30 s video sent (2026-10-08)

Resumed from roadmap now (S176 BUYER1). Model Opus 5.5. Everything stays behind `gym3d_main` (OFF for players) until
the operator OKs the video.

## What now works (commits 12daefd6 .. 755a3415, all on master)
1. **The four still defects fixed** (12daefd6): no coach body before a coach is hired (GymHallPanel: a career with
   nobody signed shows an empty floor); the wall sign reads the career gym name (`layout_for(..., gym_name)`); the boxer
   trains in kit - procedural gloves (the fight room's CCSkin, synced per frame), boots painted into the generated body
   (the boot mesh only fits Tripo feet), white kit retired (755a3415: white trunks read as underwear on pale skin, purple
   took the slot); sealed grey concrete floor + smaller streaked wear. Also: the coach is the generated body in a painted
   tracksuit + trainers standing on RamsterZ Standing_Idle (probe: 6.8 deg weight shift - stand-in until STAFF1); the
   clock word follows the wall clock (11:20 printed AFTERNOON); `set_card` refreshes the HUD at once.
2. **THE INTERVIEW + THE COACH HIRE** (`scripts/InterviewPanel.gd`): goals (ambition sentence), favourite art (a MARTIAL
   ART - operator brief verbatim: "His favorite art can be stored. It does not put a non-boxing move on week one"; read
   from the candidate's secondary disciplines, which get_candidate_card now carries), strong/weak side (best/worst of
   the six, 1-20 + band), pay -> three boxing cards (knowledge floor 2 so a week can always be filled, labelled) -> gold
   SIGN at exactly three. Coach hire: the four tags as sentences read from CareerMorning.tag_effects. Pronouns follow
   the fighter's sex (the board's first recruit was a woman).
3. **The hall runs the mornings** (e87ccf3e, 8aa2d479, 30a2e375): no coach -> hire panel (NOT NOW = next on the board);
   no fighter -> interview (the date holds); else the morning card from get_morning; SKIP = skip_morning; STEP IN opens
   the floor with his first card; END DAY / LEAVE files the visit (file_visit); next morning on DayLap.overnight + card
   progress; the coach's tag goes to the day. Film corner TV dark until a bout is booked, then lit with the opponent
   (FilmRoomPanel.read_film). Office hype push: once a week, poster/quote/photo, push_cost cash, +push now; a week with no
   push cools, never under bout_hype_base (`office_hype_push`, `_file_week_hype`).
4. **TAGS1 merged** (Arena PR #61, 68fe9c63): pad man x1.15 at pads/bag while he stands there; conditioner x1.25
   recovery at bike/treadmill/weights/rest, move minutes at 85%; other tags byte-identical.
5. **The cloud S176 walk-clip work merged** (e89949b4, diff applied, code+data only): walk cycle, ring stairs + climb,
   tools/gym_hall_video.gd. Its digest kept as S176C_DIGEST.md.

## Evidence
- Tests: interview_panel_test 28/0 (mutant SIGN-at-two red), gym_hall_mornings_wired_test 19/0 (real career; CONTROL
  mornings OFF), gym_hall_3d_test 40, career_mornings_path_test 0 fails (+6 hype checks), daylap_coach_tags_test 0
  (JSON mutant red), gym_hall_ring_steps 10, gym_hall_walk_clip 10; suites gym_hall, daylap, day_lap, career_mornings,
  candidate_card, scouting, fight_kits, training_floor, floor_, press, hype, week_review: 0 fails.
- Stills docs/previews/buyer1 01, 02a, 02, 03, 04, 05, 06 (as_game, 1080p) and docs/previews/gym3d1_walk/hall_30s.mp4,
  all opened; SENT to the operator for his OK.
- Nightly 10-08 (@1bd09b94, 571/5): set unchanged; fight_plan_ai_corner red since 10-06 = a coin-flip wins gate
  (measured: not NIGHTLY1C2; red after the #47 revert) -> NIGHTLY1D queued.

## Owed / open
- Operator OK on the stills + video -> then gym3d_main ON (and career_mornings with it).
- MORNING1T RUNNING on Arena (chat 01a11c19): port PR #60's 204-check rule test onto master's CareerMorning; collect,
  run its mutants, merge, close #60 (do NOT merge #60 itself).
- Go Watch (later activity), the tutorial's "how" lines pointing at this morning - not built.
- Week review NET does not count mid-week spends (decor, the push) - pre-existing pattern, not changed.
- fighter_gloves_both_corners_test needs ~1300 s alone: never wrap run_tests in a shorter `timeout`.

## Delegation
Arena: TAGS1 (merged), MORNING1T (running). No other free seat used: Cline's free model ended 10-05, Codex is out.

## Operator verdict after the ship (verbatim)
"I have no idea what have you designed. What you designed it doesn't look like a gym at all. I see a board in the middle, a chair. [...] You have a bathtub in the gym floor, that is funny but shows really poor judging skiils. Like this is a gym floor. Do gym floor have bathtubs? The whole design is uh, is very bad."
The floor layout (gym_hall.json places: whiteboard mid-floor, chairs, physio table + ice bath, TV corner on the training floor) is REJECTED. Redesign next, asking the operator instead of guessing.
