# S270 DIGEST (2026-10-20) - Ziva playtest acted on, the coachless day, animations rendered honestly, Rokoko mocap found

## What now works (on master)
- **B1 "Nobody trained" (coachless half)** e3362838: NOT NOW on the coach offer = a self-run day (Ludo S266: an unstaffed station is
  self-directed), END DAY with no coach files the minutes worked, the week review names the missing coach. Tests red on master
  first: week_review_no_coach_test, self_run_day_test (plain + as_game: 600 trained minutes, stat rise 0.1475).
- **P6 money** e3362838: creation burn = what the bill charges (inherited contract $0 until renewal, not market pay) -
  creation_burn_billed_test (house_that_holds 1911 -> 367).
- **Bell day goal pays after the visit-end rebuild** e3362838 (GymClub3D._pay_goals reached /root from a detached node).
- **Ziva ZIVA9 rounds 1-2 collected** ed517422: coach offer docks beside the Day Plan (P5), corner card dim, record_room cam_log.
  Collect fix: Ziva's _sync_corner_dim was inserted INSIDE _build_panels (swallowed its tail) - moved out.
- **/animations page**: Tools/anim_orbit_render.py + Godot/tools/anim_orbit_render.gd - the MetaHuman boxer alone on a grey grid
  studio, camera circling 360, each move played the GAME's way (FightStagePlayer play_role + advance). Operator: "dont render the
  whole room", "i dont need the ring" -> the fight room loads off-screen only for its player config. The first cut scrubbed the
  AnimationPlayer and skipped the game's fixes (jab never extended, glove in face) - operator caught it.
- **Rokoko free fight mocap** a344c824 / 6662475e: operator filled the form, Claude downloaded Combat.zip (11 takes, licence: any
  game, commercial). 5 boxing takes kept in Godot/assets/anim/rokoko_combat/ (CREDITS.md). Operator on the orbit renders: "videos
  are perfect", "all these are perfect they render the character properly". tools/rokoko_punch_finder.gd found 10 single punches
  (8 jabs/straights lead, a cross, a rear body straight, one rear hook/body to confirm) - rendered and labelled (punch_labels.json).
  The page shows ONLY the Rokoko takes + punches now (old groups hidden, data kept) - operator: "remove the old clips".

## Evidence that changed decisions
- Our clips are not boxing: H2H retargeted from UE4 (arms flare sideways, elbow bent ~120 at extension), Mixamo, ActionForge
  (melee hook lunge), Ludo text-to-motion (4/4 jab takes = waving/celebrating, ANIM_SOURCE_S270.md). All 22 palette clips already
  RED on facing/wrist (ANIMSOURCE1D S222). Rokoko = the first real boxing motion that plays cleanly on our MetaHuman.
- Operator: "i dont have money now" -> no pack purchase (Fab candidates recorded in ANIM_SOURCE_S270.md for later).

## Board (all answered and acted on)
Q-S264-3 UltraTex "no, skip it". Q-S264-4 no guided start ("keep it simple"); multi-boxer idea -> Ludo design
(LUDO_MULTIBOXER_S270_VERDICT.md) -> Q-S264-6 PARKED "one boxer first" (operator "ok"). Q-S264-5 "do whatever you think is
better" -> gym cut line now (Ziva), club hall later, no KO cam. Q-S264-7 "we have tripo3d and ludo3d ... should we spend money"
-> Ludo animate tested (fail), no money.

## Ludo
LUDO_ASK_S270_ZIVA_10 -> reply ludo_rx/LUDO_S270_ZIVA_10_raw.txt, verdict LUDO_R_S270_VERDICT.md (BUILD NOW table, owners).
LUDO_ASK_S270_MULTIBOXER -> ludo_rx/LUDO_S270_MULTIBOXER_raw.txt (parked).

## In flight
- Ziva ZIVA9 (chat "ZIVAPLAYTEST1 Instructions Clarified", branch ziva/playtest): owns the whole gym loop now (operator: "ziva needs
  to have access to all the mechanics" - yes); next = the two-stores fix (floor's filed days must be what the Training page and
  week review count; Round 3 root cause), grey screen after [Fast], gym-cut line, one-boxer depth. Rounds rated: overall 5.5 -> 6.5.
- Cursor #288 ZIVAFIX1 (creation freeze / globe 32 px / blank gym preview / placeholder), #282 #286 #287 NIGHTLY11/B/C.

## Decisions (Claude)
- Ziva owns the gym loop files (WeekReviewPanel, GymHallPanel, TrainingHubPanel, training parts of GameState); Claude reviews/merges.
- Animation route = Rokoko real mocap cut into single moves (replaces ANIMSOURCE1 Cascadeur authoring, stalled since Codex stopped).

## Next (S271) - DECISION, see roadmap now
Wire Rokoko punches into the fight behind switch `rokoko_clips` (GAME_ON): boxing_jab <- rk_Boxing@2.30-2.57, boxing_cross <-
rk_Boxing@10.00-10.53, guard idle <- FightingIdle (trim the 1.2 s T-pose), through the Mixamo->MetaHuman path + FightClipSlice;
check via anim_orbit_render (play_role) and record_room as_game stills; then a second detector (lateral/vertical sweep) for
hooks/uppercuts/slips; Rokoko Create (free 5 clips) for walk/footwork loops only.
