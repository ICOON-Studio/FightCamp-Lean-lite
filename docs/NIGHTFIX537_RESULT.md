# NIGHTFIX537 result (S538, 2026-11-22)

The five reds of the 11-22 nightly, rerun on main (after s537/steppay3, s535/dmgfix and the v2 leg bakes off): all five were
still red. Two were out-of-date tests and are green now. Three are old animation defects on the shipped (old) fight route;
none is caused by the leg bakes being off (those are v2 only, `-- fightplayer2`), so none was skipped and no bar was changed.

| Test | Now | Cause | Fix |
|---|---|---|---|
| tips_test | PASS | TEST out of date. 33b43ec83 (S534, owner C446 "can the background be transparent?") made the card 86% opaque (scripts/ui/TipParts.gd:24). | tests/tips_test.gd:49-51: the card's alpha is 0.80 to under 1.0 (shows the page, still reads). |
| words_on_screens_test | PASS | TEST out of date. b81ae44c4 (S535 OFFERBUILD1, owner Q-296 "Yes, build it"): the offer opens on the letter, which says "Scouting: n of m found." (scripts/ui/OfferSides.gd:395); "Scouting report" is on the Full report. | tests/words_on_screens_test.gd:52-57: the bout page must say "Scouting:", then the test opens the Full report and it must say "Scouting report". |
| human_feet_test | RED (held) | GAME. Boxer 1's foot is 4.0-4.4 cm under the canvas for 1-2 frames on the return to guard after pro_left_hook_v2 (bar 3 cm). Also an instrument fault: run_tests.sh ran it at 60 fps while the test steps the stage at 1/30 s, which read 11.7 cm. | tests/human_feet_test.gd:17-18 `FIXED_FPS 30` (the rate its own header asks for); :186-188 and :140 the FAIL line now names the move. Defect not fixed: needs fight3d work (S510 METHOD). |
| rokoko_clips_test | RED (held) | GAME, on the opt-in `-- rokoko` route (off in the game since S432): strafe_right planted slide 0.309 m, bar raw 0.209 + 0.05. | None. |
| head_aim_test | RED (held) | GAME. A_A_lv jab: aimed flat reach 0.396 m against 0.161 m un-aimed, difference 0.235 (bar 0.20); the other 11 rows pass. | None. |

## What the control arms say (new, for TASK_MOTIONRULERS1)
The task's "most likely causes" are not the causes:
- human_feet with `-- oldswing` (S503's step, 92e253e1b, switched back): still 4.0 cm, and boxer 0 goes red too (3.4 cm in pro_back_dodge).
  With `-- noafretarget`: 4.0 cm. So neither S503's step nor ActionForge's legs put the foot under the canvas.
- rokoko strafe_right (tools/rokoko_feet_probe.gd mode=fight loco): whole-step slide 0.629 m new, 0.631 m with `-- oldswing`. Not S503's step.
- head_aim with `-- oldflight`: 0.235 (unchanged); with `-- oldguard`: 0.227. Not S510 r14's flight; the nearer guard is 0.008 of it.
Next step for whoever takes MOTIONRULERS1: a real bisect between 859acea5 (green, 11-16) and a05c139ea (red, 11-17) for the feet
and the strafe, and between the 11-17 and 11-18 nightly commits for head_aim.

## Runs
`TESTS="tips_test words_on_screens_test rokoko_clips_test human_feet_test head_aim_test golden_path_test" JOBS=2 sh tools/run_tests.sh`
through godot_slot: PASS tips_test, PASS words_on_screens_test, PASS golden_path_test; FAIL rokoko_clips_test, human_feet_test,
head_aim_test (the lines above).
