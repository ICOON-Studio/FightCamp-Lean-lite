# ROUND 2 AGAIN (S343 - read this first): your round 2 run timed out after 100 minutes and pushed nothing
Status: DONE (collected S355)

Your tools/clinch_check.gd waited inside a WHOLE BOUT under xvfb (software rendering, ~5 fps) for 3 clinch holds that
never came inside the runner's limit, then you debugged it until the job was killed. Do not play a bout. Build a
FightStage and fire SCRIPTED beats through BeatFire the way scripts/fight3d/TapeFilm.gd does (copy its `tick`, do not
edit it): `{"t": 1.0, "who": "a", "move": "clinch", "dur": 3.0}`, then the referee's break `{"t": 4.2, "who": "a",
"move": "step_out", "ref": true}`, twice more at t 6 and 11 (the clinch for "b" once) - three holds in about 15 s of film,
measured on the bones as your brief asks. Advance the clock with the frame delta, never `1/30` per frame (that is what
made 840 "seconds" last hours). Push after EVERY green step (branch goose/clinch2), so a timeout never loses the work.
Keep the rest of the round 2 brief below.
# TASK_CLINCH2 - perfect the clinch: lean in, tie the arms, jostle and turn, dig to the body, part on the break (Goose, FightCamp-Lean)

Model: Goose (cloud), repo ICOON-Studio/FightCamp-Lean branch main -> push `goose/clinch2` (Actions cannot open PRs here
right now: push the branch, Claude opens the PR). Discipline: boxing = demo. Lean rules: its CLAUDE.md, no script over 500
lines. Windowed probes on the runner: `.github/CLOUD_AGENT.md` "Fight animation tasks" (xvfb, `fastdraw`, `-- show3d`). Operator S340: "someone also needs to perfect the clinch" (agents = animation, S338).

## Why (what the stills show today - S318 previews/s318/clinch_before_after.jpg in the Game repo)
The tie-up is built from our own pieces (`scripts/fight3d/Clinch.gd`, 233 lines; read its header): both stand in a held block
pose (or the baked two-person clips clinch_att / clinch_vic when FightClips.PAIR has them), shifted SIDE_M to their left,
hands placed by CornerIK. It reads wrong:
1. Faces mash cheek into cheek; a glove sinks into the other's head or chest.
2. Both stand bolt upright on straight legs: a real clinch is an A-frame - heads and chests together, hips BACK, feet back
   and wide, both leaning their weight on the other.
3. One tie raises an elbow behind the head (a waving arm), not an overhook.
4. Nothing moves for the 3-5 s hold: real clinches jostle - small steps, the pair turns 20-60 degrees, one leans the other
   back, heads shift side to side.
5. The free hand never works: in a real clinch the inside fighter digs short hooks/uppercuts to the ribs with the free hand.

## Spec (all in Clinch.gd unless said)
1. Contact without overlap: no glove inside the other body (glove centre >= 0.10 m from the other's head bone and >= 0.08 m
   from her spine_03/spine_05 surface line), heads ear by ear (head-to-head >= 0.16 m, <= 0.26 m).
2. The A-frame: during the hold, each pelvis is >= 0.15 m further from the other pelvis than the two chests are from each
   other (chest = spine_05) - hips back, chests in. Lean the spine from the pelvis (a pose offset on spine_01..03 eased
   in/out over EASE_S), feet stay planted (FootPlant already pins them - check, do not fight it).
3. Both arms read as a tie: the holder's arm over the other's arm (overhook) with the hand on the upper back below the
   shoulder, the other's hand on the holder's flank or biceps - never a hand above its own head (clinch_probe already
   prints hand heights; keep every glove 0.07-0.40 m under its own head).
4. Jostle: across one hold the pair's axis turns >= 15 degrees and the pelvises move >= 0.15 m in total (small shuffle
   steps or a slow drift, eased - never a slide with planted feet; let the Footwork/FootPlant steps carry it).
5. Digs: a clinch beat may carry `"digs": <0-3>` and `"digger": "a"|"b"` (Claude adds them from the fight rules - the
   opponent's short shots in the clinch). The digger's free hand (the arm NOT in the overhook) throws that many short
   body hooks, spaced over the hold: hand travel 0.15-0.30 m, contact within 0.08 m of the other's flank
   (spine_02/03 side), ~0.35 s each, back to the tie after. Use the existing hook clips only if they can be driven that
   short; otherwise IK the hand on an eased arc (CornerIK.reach with a moving target).
6. The break: unchanged API (release() on the referee's beat), but both step back with hands rising to the guard.
Keep the API: `setup(stage)  start(holder, dur)  release()  offset(i, to)  floor_m(base)  engaged` - RingPlace and
FightStage call it. Add `start(holder, dur, digs := 0, digger := -1)` with defaults so old calls work.

## Contract
OWNS: Lean/scripts/fight3d/Clinch.gd, Lean/tools/clinch_check.gd (new), Lean/tests/clinch_shape_test.gd (new, pure helpers
only), and in Lean/scripts/fight3d/BeatFire.gd ONLY the line that calls clinch.start (pass digs/digger from the beat)
(do NOT edit tools/run_tests.sh, FightStage.gd, RingPlace.gd, ExchangeBeats.gd, ClinchBeats.gd, JoinSmoother.gd,
GloveClear.gd, PunchReach.gd, BeatClips.gd - other seats hold them)
RED_TEST: tools/clinch_check.gd -> CLINCH OK 6/6
REGRESSION: clinch_beats_test, beat_clips_test, inside_beats_test, golden_path_test, tools/clinch_probe.gd (hand heights)
VISUAL: yes (your PR runs .github/workflows/fight-stills.yml; Claude also runs tools/clinch_still.gd and opens every still;
the operator closes it)
BeatFire.gd is also being edited by Cursor's FIGHTCARD1 (it adds two lines at the top of fire()): touch ONLY the clinch.start
call line so the merge stays clean.

## The probe (write it FIRST; it must read red on main)
NEW `tools/clinch_check.gd` (SceneTree; headless if the skeleton poses evaluate headless - tools/clinch_probe.gd does, copy
its setup; else windowed with `-- show3d` like the fight probes): builds two boxers on a FightStage-like rig, runs
`start(0, 4.0, 2, 1)` and samples every 0.1 s, printing per check one line and a total:
```
CLINCH overlap    min glove-other head 0.xx m, glove-other chest 0.xx m      OK|FAIL
CLINCH heads      head-head min 0.xx max 0.xx m                              OK|FAIL
CLINCH aframe     pelvis gap - chest gap 0.xx m                              OK|FAIL
CLINCH hands      glove under own head 0.xx..0.xx m                          OK|FAIL
CLINCH jostle     axis turn xx deg, pelvis travel 0.xx m                     OK|FAIL
CLINCH digs       2/2 within 0.08 m of the flank                             OK|FAIL
CLINCH OK n/6
```
Main today must print at most 3/6 (no digs, no jostle, no A-frame). Never loosen a bound to pass.

## Final answer
`RESULT: tools/clinch_check.gd -> CLINCH OK 6/6`, every CLINCH line before and after, the REGRESSION last lines, files
touched + line counts (Clinch.gd must stay under 500 lines; split a ClinchPose.gd helper if needed and add it to OWNS).

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md, Lean version)
1. On main today the S318 stills show cheek in cheek, upright legs, a waving arm, no motion - that is the red.
2. Stills via `tools/clinch_still.gd` (windowed under xvfb on the runner, `fastdraw`): 0.8 s into each tie-up and 0.3 s
   into each break; attach them to your report.
3. For every still report: gap between bodies / where each nose points / wrists and hands / feet / which bodies.
4. Do not call it accepted or fixed. Claude opens every still; the operator closes it. Report the numbers too.

## Prior research
searched: clinch -> Clinch.gd header (S313-S318: no licensed clinch clip on Fab / MoCap Online / Reallusion, built from our
pieces; S317 Cascadeur pair clips), ClinchBeats.gd (Davis et al. 2015 elite amateur clinch counts; 2023 women's World
Championships clinch 4.06 +- 2.27 s), S310_REAL_FIGHT_GAPS.md row "Clinch" (Game repo), S318 digest (cage clinch, glove over
the head fixed).

## What would a human do?
A fight choreographer: "close in, chest to chest, put your head on her shoulder and your hips back - lean on her, make her
carry you. Tie her arm with an overhook, the other hand on her biceps. Keep moving: walk her round, push her back a step.
If she leaves a hand free she digs to your ribs. When the ref steps in, step back with your hands up." Real footage: the
pair turns as one, feet active, never two statues.

## Prefab check
No licensed boxing clinch clip exists for our rig (checked S311: Fab, MoCap Online, Reallusion; Mixamo has none that fits
two bodies). GrappleMap is grappling, not boxing. Built from the pose + IK we have.

## The trap
Moving a planted foot without a step (feet slide) - let FootPlant/Footwork steps carry any drift. And the A-frame lean must
come from the spine, not by pushing the pelvises apart (that opens the chest gap and the tie falls apart).

## ROUND 2 (S341, Claude reviewed goose/issue-14 @ ed71b0b - NOT merged)
Round 1 printed `CLINCH OK 1/6` (heads 0.42-0.58 m, aframe -0.07 m, hands -0.61..0.62 m, jostle 0 deg / 0.01 m, digs 0/2).
Branch from main again (main moved: e59c478) and keep what is good (the beat's digs/digger in BeatFire, the probe's six lines).
Why each check failed, and the route the game really runs:
1. THE PROBE MEASURED A MOCK. `_MockStage` has no RingPlace.compose, so nothing Clinch writes to `bx["pos"]` ever reaches a
   body, and the mock places the pelvises 0.50 m apart (heads cannot meet). Rewrite `tools/clinch_check.gd` to sample the REAL
   FightStage in a real fight: copy `tools/clinch_still.gd`'s setup (Main.tscn, TestJump "fight", FightView runs the bout;
   it already finds each tie-up by `stage.clinch.engaged`), run it windowed under xvfb (`fastdraw`, `-- show3d`,
   .github/CLOUD_AGENT.md "Fight animation tasks"), and sample every 0.1 s of each engaged hold. Print the six lines over ALL
   holds of rounds 1-2 plus `CLINCH holds n` (n >= 3). It must still read <= 3/6 on main.
2. THE A-FRAME. Your `_apply_aframe` set the spine from `_process`; the AnimationPlayer writes the bone again before render, and
   its sign leaned the trunk BACK (your own comment says so: aframe -0.07). Use `ik.upright(-LEAN_DEG)` on each boxer's CornerIK
   on engage and `ik.upright(0.0)` on release - since e59c478 a negative angle leans the trunk FORWARD inside the skeleton
   modifier, after the clip. Delete `_apply_aframe`.
3. THE JOSTLE. RingPlace faces each body to the OTHER'S `bx["pos"]` every frame, so a node rotation is overwritten. Turn the pair
   by moving both `bx["pos"]` round their midpoint (equal and opposite, eased, >= 15 deg over the hold) plus a small common drift;
   facing then follows by itself. Footwork/FootPlant carry the feet - check a still for sliding feet.
4. THE DIGS. `ik.reach(side, func(): return target)` captured a fixed point once per frame; fine, but the free side was wrong
   when the digger is the held boxer (she grips with the hand that faces the holder's free arm - read `_engage`). Measure
   `digs` in the probe from real beats carrying `digs` (ClinchRest on main sets them: the opponent digs in ~44 % of tie-ups).
5. KEEP THE COMMENTS. Round 1 deleted every `##` comment that records an operator ruling (S313-S318: "very bad" nose to nose,
   C143 grip without the glove, the cage-clinch foul). Put every one back; add yours beside them.
6. No `randf()`: take the jostle direction from the stage's rng (`stage.life.rng`) so a seeded fight plays the same.
Final answer as before plus the probe's lines on main AND on your branch, `CLINCH holds n`, and the clinch_still stills.
