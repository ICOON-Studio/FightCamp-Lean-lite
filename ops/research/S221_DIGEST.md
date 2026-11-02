# S221 DIGEST - 2026-10-13/14 - every built feature ON, gym floor + station wear + promoter rules merged, locker room props built, FLYFOOT1 rejected

## Operator rulings (verbatim)
- "everything new built i want it defualted to on" -> 12 opt-in flags joined GameSwitches.GAME_ON (CLAUDE.md s10 rule, memory).
- Q-S220-2 gym floor round 6: "OK, merge it". Q-S220-3: "ludos design needs to be in accordance with the game i do not want random
  generated pictures i want pictures we can use in the game , start the locker rooms". Q-S220-4: "Yes, do all 10 in this style".
  Q-S220-5 boots: "Yes, claim it". "not sure why we need messhy3d when we have ludo and tripo3d" -> no Meshy.
- FLYFOOT1 clip: "wtf i checked the video is to bad the feet do not look normal yellow boxer has no hair and doesnt throw a single
  punch", feet crops "these do not look normal". "put shoes on all boxers , boxers do not fight bear feet".
- Review comments C59 "nice" (locker props), C60 "i do not want to see bold women", C61 "south wall can be semi-transparent",
  C62 "make wlass transparent when zoomed in", C63 "make it look less ai-made use icons and nice graphic instead of wording",
  C64 "do not use so much text , use also tooltip modals for explaining things", C65 "fix the bakcgrounds put some art and motion".

## Landed on master
- cdfbc81e STORYPARITY1A (Arena PR #164): PredatoryOffers.gd + DebtEvent.gd + blind test (CI PASS).
- STATIONWEAR1E (Grok Dev PR #165) + Claude fix: pinned card stays below the HUD top strip (test red without, green with); focused
  suite 46/0; stills on 8787/review.
- ebf5485e GYMLOOK3A round 6b gym floor (by diff; unused Displacement/NormalDX maps + old preview rounds left out); props test now
  requires bag_line/cardio/ring to stay bare (operator ruling); textures imported.
- 4a05ad6c every built feature ON: station_wear, timeline_bar, last_spar_screen, club_routes, gym_is_menu, candidate_card_v2,
  area_wear, club_capacity, ludo_camera, skip/profile/last_spar drawers -> GAME_ON via GameSwitches.on(); DEFAULT_OFF empty;
  tests touching them 23/0. NOT yet verified: an as_game walkthrough with stills of the screens these turn on (next session).
- Tools: Godot/tools/club_room_still.gd (any room, opened from the floor view), Godot/tools/room_pose_probe.gd.

## Locker room (LOCKER1)
Ludo r58 spec (A props, B layout) saved; style test v1 rejected (photo-real) -> v2 approved by the operator; 9 pictures (8 in the
chat, the door via `ludo image create`) + 9 Ludo 3D models (`ludo model create`, prop, <=5k tris, 1024 px, 36 plan credits) in
E:/FightCamp/tmp/locker1_3d/ludo-output; snapshots checked (bench needs a tint). TASK_LOCKER1B.md (Codex sol high, first free PC
seat): normalise + place (scale moved out of the door, board off the hall-side wall), clicks, ROOMCAM1 room camera fallback
(locker room + equipment store open on a far pose behind the hall's front structure) + C61/C62 semi-transparent walls.

## Defects found and routed
- FLYFOOT1 REJECTED by the operator -> TASK_FLYFOOT2.md (foot orientation gate: pitch/roll/toe, red first; next on Codex).
- Bald bodies: mh_boxer_02 and 07 have no hair cards; 02 reads as a woman (C60) -> MH5 addenda.
- Punch output: blue 8 strikes/60 s vs red 19 (CompuBox 15-19/min), SAME on master -> PAIRLIVE1 item 6.
- PROFILE2E round 11's gate passed a side profile with two hands in frame (face direction from a bone axis, sign flipped toward the
  camera) -> TASK_PROFILE2E_FIX10.md, Cursor round 12 running.
- Station card too wordy (C63/C64) -> STATIONWEAR1F: Ludo r59 mockup (gauge + 3 icon tiles) saved; needs buttons/upkeep/chips spec.
- Nightly: no new run; asset_manifest + face_drawn_foe pass alone; remaining reds owned (NIGHTLY1 row).

## In flight at handover
Codex TECHSTAGE1 FIX5 (wt TECHSTAGE1), Cursor PROFILE2E r12 (wt PROFILE2E), cloud Cursor STORYPARITY1B (#166), LANDED uncollected:
cloud Cursor NEWCAREER3A (branch cursor/issue-163, PR could not open), Arena NEWCAREER3B rules (PR #167 arena/b39aa6b0).
Boots: MetaHuman Hightops SAVED in the operator's Fab library (he signed in to Epic; Claude clicked Add to My Library on his Q-S220-5 yes).

## HANDOFF
Next: collect #167 + cursor/issue-163 -> Codex: FLYFOOT2 when FIX5 lands, then LOCKER1B -> boots + hair with MH5 -> Ludo r59
follow-up (full card spec) -> as_game walkthrough of the 12 newly-ON features (stills on the board) -> NEWCAREER3B (incl. C65 art +
motion backgrounds).
