# S273 DIGEST - 2026-10-20 - LOOP1 two stores fixed, fighters-only studio fight, the guard stays a guard, steady camera

## Operator (verbatim)
- "can you make the fight without rendering anything else other thatn the fighters" / "like in the rokoko mocaps" /
  "and open the render on my samsung monitor" / "i want to seethe fighters fight without rendering anything else like rokoko mockaps"
- "can you open the fighterso nactionforge ?"
- "do we need rokoko walking animations ?"
- "why the video looks so bad and the clips onthe board (rokoko) look so good?"
- "remove all the camera shakes and shit"
- "you aredoing something wrong" (screenshot: red straight-legged, chest to chest, blue's glove in his face)
- "Add guarde wtf is idle in a boxing match"
- "newsession ?"
- Start: no open board questions, no board answers, no unseen review comments.

## Landed (master)
- 04831c33 LOOP1 TWO STORES (Ziva Round 3 root cause): the floor's days now count. rules/FloorWeek.gd (pure: station minutes ->
  programme focus, week_days / overlay / summary); GameState lived days carry their weekday, note_day_started (START DAY),
  get_training_hub overlays the floor's days on the programme's REST slots, the week's body row carries a floor summary;
  WeekReviewPanel lists the floor-trained fighter (ON THE FLOOR n DAYS, TRAINING - RING...). The programme store is never
  written (no programme slices on top of the floor = no double count, a CONTROL check). FOUND: a floor day that completed the
  week DROPPED its report (only CareerRoot's CONTINUE stored it) - GymHallPanel._week_filed stores it + opens the review.
  tests/floor_week_bookkeeping_test.gd red on master -> green plain; 7/7 plain. Stills: docs/previews/s273_loop1 (PLANNED 1/1,
  review lists Arthur Walsh with Ring + his gains) - board + sent.
- b7adc0cb ZIVAFIX1 collected by diff (Cursor #288): city cards first / 3D a frame later (shell 2.9 ms), globe hit radius 32 px
  (Ludo S270; Cursor had 28), no sway under the pointer, MARKET LIST 44 px, routed gym preview viewport, real day-1 news line.
  Collect fixes: ClubRoomBase connected `resized` twice on a HUD rebuild (as_game engine error); the test freed nothing it
  mounted and sampled pixels headless (dummy renderer) - fixed. Green both arms.
- cc7b8dfc tools/fight_studio_render.gd: the live fight (record_room, as_game, game camera) with ONLY the two fighters on the
  Rokoko board's studio set (grey grid, three-point light, plain backdrop); clip_log=1 prints clip + pelvis + stance.
  Played on his Samsung (C24F390 = DISPLAY1 primary; Media Player full screen). Fighters 09 + 04 imported into ActionForge
  (his Chrome, two tabs, YOURS, auto-mapped UE5 Manny).
- 5eabbe63 THE GUARD STAYS A GUARD + STEADY CAMERA. Measured (not guessed, after a wrong first read): the fight's guard ("idle"
  = Rokoko FightingIdle 40.87-42.87 s, 77% of a fight) plays at the board's own pelvis height (body 04 0.90 m both ways) but the
  HUMAN2 step planner (FightFootLock.push_pull, 32 cm floor) dragged the feet together (0.12-0.97 m vs board 0.54-0.57):
  fixed hips over closed feet = a man standing straight-legged. Bisect: off=human_footwork removes it. A forward/standing step of
  a Rokoko take now lands inside 0.80x-1.15x the clip's own toe spread; a retreat keeps HUMAN2 (the band put the back plant out
  of reach: one double-unlocked frame per backward walk, human2_test). Guard frames under 35 cm: 09 11/46 -> 3/49, 04 7/40 -> 0/35.
  Switch steady_camera (GAME_ON): no 2 px shake, no hit-cam push-in/slow-mo, no torso spring; the orbit holds and walks round
  only past 35 deg (<= 15 deg/s) - a fully locked camera let the men line up (red hid blue at 14 s).
- 4e0e08cd fight_clip_slice_test measures the strike AS PLAYED (play_role + advance, whole): the C223 rear hook PLAYS 1.733 s
  (plain arm) - a real slow punch; still red on purpose -> Cursor HOOKTIME1 #292.
- Evidence clips on the board: fighters-only 20 s fight, layers ON vs PURE (the misread - see below), guard fixed + steady cam.

## Wrong turn (said to him)
The "layers ON vs PURE" A/B was read as "the layers make the squat"; PURE stood straight-legged too and he caught it ("you are
doing something wrong"). The board's rk_* clips play RAW (ap.seek, no FightStagePlayer); measure the same quantity both ways
(pelvis, stance) before naming a cause. TASK_ZIVARATE1.md carries the correction.

## Agents
- Cursor: NIGHTLY12 round 2 REFUSED (#286 closed - reused the branch, timing prints only, cap hunk already refused);
  FASTGREY1 #289 (grey screen after Fast = GymHallPanel rebuilt the hall synchronously inside the hall clock -> deferred),
  FIGHTSTAB1 #290 (FIGHTS on the floor top bar + F6 -> calendar offers; also declares room_route_requested on GymHall3D so
  OFFICE routes too), ASGAMEDAY1 #291 (as_game tests drive the applicant chip + START DAY) - COLLECT STATE: see "Cursor collect".
  HOOKTIME1 #292 running. Cursor PRs cannot open ("GitHub Actions is not permitted to create or approve pull requests",
  repo setting can_approve_pull_request_reviews=false) - collect by branch diff.
- Ziva ZIVARATE1 still running (wt/ZIVA merged master, no fix commit yet); brief corrected with the measured cause.

## Cursor collect (FASTGREY1 + FIGHTSTAB1 + ASGAMEDAY1) - 4415cd54
Applied by diff (FASTGREY1 by hand over LOOP1's _week_filed). Collect fixes: GymClub3D re-declared room_route_requested
(parse error as_game - base only now; LESSON: parse-gate the SUBCLASSES of a touched base); ClubSpeedControls disabled the
skip item by id, set_item_disabled wants the INDEX (errored + SKIP THE DAY stayed enabled on a must-attend morning).
Plain 11/11; as_game the touched set 5/5 (self_run_day, floor_week_bookkeeping, week_review green as_game for the first time).

## Ziva ZIVARATE1 landed (74a036ab on ziva/playtest) - mocap_pure collected
Ratings (ZIVA_ANIM_REALISM_S272.md): new clips 7/10, old clips 4/10 (five worst: lead_hook, slip, catch, cross_body, rear_hook),
3D realism 5/10, blending 5.5/10, overall 5.5. mocap_pure: a rokoko_clip take plays as captured (10 gates keyed on the take);
heads under 0.80 m 45% -> 20% of frames. Collect fix: mocap_pure_test failed its plain (OFF) arm by checking on() - now checks
GAME_ON and drives the switch both ways. Ziva's P1 ("board unscaled") answered NO CHANGE with a measurement: the orbit board
renders go through FightWorldStage.mount (body 04 pelvis 0.900 on both paths). Big media (43 MB clip, 7 MB PNGs) left on its branch.

## Fab Ailive pack - bought by the operator, imported 11f73ef1
Board Q-S272-1 (EUR 8.47 Personal) -> he bought it ("got ot", Standard License). boxing.zip 73 MB -> headless Blender strip
(mesh out; first export truncated every take at Blender's default 250 frames = 2.08 s - re-exported with the action range) ->
assets/anim/ailive_boxing/ai_*.fbx 1.4-2.0 MB + CREDITS.md; AFMotion ai_* roles (UE5 Manny = MetaHuman, one-to-one). Orbit
previews on the board: left hook, left uppercut, footwork (9.3 s), duck - real boxing; standing lead-in at both ends -> cut
guard-to-guard (punch_labels method) before they fight.

## Measured, not fixed
- As_game on master: self_run_day, training_hub_panel, floor_gain_coach_day red; week_program, week_review hang (ASGAMEDAY1).
- globe_picker / creation_root / floor_hud2 are plain-only tests (red as_game on master).
- Rear hook 1.73 s on screen (HOOKTIME1). The retreat-step guard collapse (0.15 m once on body 09 after a slip). Spacing (FIGHTGAP1).
- Walking: plain Rokoko walks not needed (gym walks play at measured pace); fight FOOTWORK is the gap - cut steps from Rokoko
  FightingIdle (70 s of footwork, on disk) first -> Ziva after ZIVARATE1.

## Next (S274) - roadmap now
1. GUARD HANDS: gloves forward/wide in the fight vs tight on the board (mocap_pure already on) - measure, bisect, fix.
2. Ailive cuts: lead hook + lead uppercut (no source before), duck/sway -> slip/pull, right hook -> rear hook (HOOKTIME1);
   guard-to-guard windows like FightClipRokoko; each shown in a 20 s fighters-only fight before it plays.
3. FOOTWORK_PLAN_S273.md: step library from Ailive footwork (9.3 s) + Rokoko FightingIdle; Arena StepPicker; step intents.
4. Collect Cursor HOOKTIME1 #292.
