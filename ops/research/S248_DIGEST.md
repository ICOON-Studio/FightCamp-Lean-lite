# S248 DIGEST - 2026-10-18 - coach walk fixed, office PC in the HUD, full-screen gym, FIGHTLINK approved

Operator, this session (verbatim): C105 "animations play at 100 speed the coach teleports, check and fix"; C106 "do not see any reason for
him running, also why he moves only in straight lines which is very akward ... just walking is fine"; "why the gym is not full screen,
did you fully reversed enginned 2point musem ? their screens look way better than this"; "ziva should be able to do everything even build
mechanics"; the direction question ("should we focus on the training floor mechanics ... i do not even know how damage is calculated ...
whats your opinion"); Q-S246-4 "build it only if everything is shown to the player in a comprehensive way and [not] too complicated , my
main concern is how all the training is translated to the fight"; and "Go - build FIGHTLINK in that order: evasion/chin/accuracy, move
mastery, then the profile, fight notes, corner report and post-fight why."

## What now works (pushed)
- C105/C106 coach walk (0db03134, fd88df66, d33b3048): walks at a human 1.5 m/s on the walk take at its MEASURED ground pace
  (MetaHuman AF walk = 1.06 m/s, so speed_scale 1.4/1.06 - every MH walker had skated 25%); routes' corners rounded (_smooth_route);
  clock half speed while the coach walks (Ludo r113). The coach had walked the old retarget take: MetaHuman now detected by skeleton,
  walk cache split per body family, _walker_clip switches pace mid-move. The S246 video itself played ~3x fast (recorder now --fixed-fps 30).
- OFFICETAG2 (05649314): OFFICE PC button with red badge in the HUD beside PLAN; the floor pin is gone; the desk PC is the world click.
- Whole-club view fills the screen (d08e4940): floor_far fitted per yaw to the building (pinhole-refined) - 85-97% of the frame (was ~70%).
- OFFICEPC3 (7dd46d0d): Kenney flat monitor + keyboard and a flat TV on a stand replace the two CRTs (John's pick, CC0, already on disk).
- QuickMagic pad test (a40d6279): Pexels 6637254 (no free full-body pad video exists) -> QuickMagic UE 5.6 upper body; only the coach
  was tracked; plays on the MH coach via AFMotion role qm_pad_coach; side-by-side on the board (11 credits, operator OK in chat).
- FIGHTLINK started: FIGHT_SIM_MAP_S248.md (how damage/targeting/training work in code today, with gaps: chin does nothing, defence
  never makes a punch miss, nothing links outcome to training); Ludo r113 (HUD as PC manager sim; coach timing), r114 (direction: plan ->
  autonomous floor -> exceptions; 12 attributes), r115 + cont (per-punch mastery tiers and how they show; 'How fights are decided' page);
  direction approved; Arena FIGHTLINK1/FIGHTLINK2 running; tests/fightlink_wire_test.gd RED on master (5 fails, 46c43a20).

## Evidence
- pace_flat_switch 0 fails (coach 1.50 m/s, 53 game min per 32 m, worst turn per route step 19 deg); run_tests slices: 16, 20, 25, 26,
  32, 36, 40 tests, 0 fails each (see commit messages).
- iso_camera_test: 'club fills the screen 85% wide / 97% high', building corners in frame; rooms_office_physio 0 fails after the TV fix.

## Not done / still wrong
- FIGHTLINK wiring (S249). Chin arm of the wire test sees 1 KD in 20 bouts at power 88 today - may need more bouts.
- Ziva: its MCP has editor tools only (no chat/agent tool) - it can build and playtest, not answer design questions; editor stopped
  (memory RED). Its worktree is at S237 (a3a35897) - sync before using it to build.
- HUD (Q-S246-4): FIGHTLINK's screens are its content; the r113 layout stays a reference, not built.
- TPMSCREEN1 written (plot, TPM light/post numbers, prop style, HUD frame) - after FIGHTLINK.
- I typed the r114 ask into the Ludo PROJECT DOCUMENT title by mistake (the tab had moved to /project); restored to "FightCamp" and
  verified - always check location.pathname == '/assistant' and the focused element before inserting.

## HANDOFF
Next: roadmap now.next_action (FIGHTLINK collect -> wire -> mastery -> screens). In flight: NIGHTLY9 (Grok Dev), FIGHTLINK1, FIGHTLINK2 (Arena).
- Operator showed a Tripo CLI batch YAML ("how can i see that for our prohject"): we reach Tripo via fal (Tools/gen/fal_generate.py,
  single image, $0.30/mesh); batch YAML mode is queued in roadmap now (props only, board money OK first).
