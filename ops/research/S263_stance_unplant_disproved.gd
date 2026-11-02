extends RefCounted
## RETIRED HYPOTHESIS, NOT A TEST (moved out of tests/ so the suite does not run it). Kept as the measurement record.
##
## S263 #2's first hypothesis: a STANCE take (idle / boxing_* / slip) should lose its foot lock at a tighter radius than
## FightFootLock's 0.35 m Unreal LOCOMOTION default, so that an animation-dragged foot loses its pin early.
##
## The A/B census DISPROVED it. tools/fight_motion_probe.gd, both arms the same code and seed, 40 s at 30 fps, as_game:
##   FIGHT_PLANT_SUMMARY off=stance_unplant (S258/Unreal radius)  ->  stance_unplant ON (8 cm)
##   plants / over the 2 cm gate      56 / 34                      ->  69 / 32
##   flicker (plants < 3 frames)      11                           ->  35
##   worst plant                      459.7 mm                     ->  413.6 mm
##   FIGHT_MOTION_SUMMARY planted_skate a/b   169 / 152 frames      ->  170 / 180 frames   (worse)
## A tighter release radius makes the foot LET GO more often, and every release is a pop the camera sees. The gate is
## "planted-foot slip <= 2 cm per plant" and this lever moves it by two plants out of fifty-six.
##
## What the census is really reporting, from the S263 legtrace (side b leg 0, the boxing_cross -> idle plant, t=2.40-2.83 s):
##   - the pin itself did NOT move: pin_moved_mm 0.0, the clip's own toe 0.0 mm off the pin at the plant
##   - the ROOT did not move either for most of it, and the DRAWN toe still walked 0.9 -> 25.0 -> 14.7 mm off the pin
## So the foot is moved AFTER the lock planted it by a writer outside FightFootLock - the AnimationPlayers are stepped
## again after the lock (FightWorldLiveScreen._advance_bodies) and each step erases the lock's bend. S258's re-pin
## (relock_feet_after_root) only ran when the ROOT moved, so nothing put the foot back.
## The fix is FightStagePlayer.repin_needed + `foot_repin` (ON in the game), and tests/foot_repin_test.gd.
##
## The two big outliers (413.9 / 459.7 mm on idle) are a different defect: ONE frame in which the pin itself jumped
## (pin_step_mm 380-487 mm with path=[] - no hold/seed/replant logged). That is a re-seed, not a drag, and it is open.
## A/B arm to reproduce: `off=foot_repin` vs default on tools/fight_motion_probe.gd.

