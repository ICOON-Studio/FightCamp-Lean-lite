# Inside work, S393: built, blind tested, lost

Cause found: an inside spell runs 1.5-6 s but holds only its burst's 2-3 punches, so most of it is two boxers standing still.
Tried: scripts/rules/InsideWork.gd fills quiet stretches with short blocked shots (longest quiet stretch 1.19 s, who lands what unchanged). Branch claude/insidework1, local, NOT merged. `nowork` was the control arm.
Blind A/B, films E:/FightCamp/tmp/s393/film/arm_k.mp4 (work) and arm_m.mp4 (control), key hidden, two fresh judges:
- Boxing judge: close range 5 vs 5.5, whole fight 5 vs 5.5. Preferred control, narrowly.
- Animation judge: close up 4.5 vs 5, whole fight 5 vs 5.5. Preferred control, narrowly.
Both saw the worst moment in the work film: 0:53.6-54.0, one boxer folds and her face stays sunk in the other's torso for about 0.5 s. Same family in control: 1:10.1, 1:16.2.
Reading: more punches inside gives the existing fault more chances. The fold and the body overlap come first. Then retest this branch.
Limits: judges read burst sheets at about 7 fps, not real time; one seed per arm; the arms diverge after about 18 s, so a single bad moment weighs heavily.

## S397 follow-up: the fault is gone from live play (Qwen INSIDE4, tools/head_torso_probe.gd)
Three live rounds (fight3d_play flow, bodies as shown), head centre to the other's torso segment every frame:
main frames=8540 under_0.20=7 worst=0.133 m spells(>=0.2 s)=0; with Arena's GloveClear._clear_torso (PR #71) 3 frames, 0 spells.
The half-second face-in-torso of S393 no longer happens (S393's fold room in RingPlace + GloveClear's head clear). _clear_torso is
NOT merged (nothing visible to fix; PR #71 closed). The inside work (branch claude/insidework1) can be retested blind now.
