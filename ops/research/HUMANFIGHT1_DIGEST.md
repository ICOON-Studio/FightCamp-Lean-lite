# HUMANFIGHT1 digest - the boxing fight moves like two humans (Claude Fable 5.2, its own session, S430)

Operator S430: "i see some animations the fighters are off the ground flying , can you assign a fable 5.2 agent to make the
boxing fight as close to human-like a spossible and rate the results using critics and loop until it is at 7/10".
Branch `claude/humanfight1` (worktree `E:/FightCamp/wt/LEAN_HUMANFIGHT1`), never main. Films and logs: `E:/FightCamp/tmp/humanfight1/`.

## Instruments (new, on the branch)
- `tools/human_fight_film.gd` - the real bout (TestJump men_fight: Danny Osei v Liam Doherty, two different male bodies;
  `women` = Lucy's bout), the game's own camera, seed fixed. Logs BOTH boxers as SHOWN every drawn frame, whoever has the
  legs: hips, head, thighs, knees, ankles, balls, hands, clip, rig weight, pure weight, her place, step velocity.
  `fastdraw` = the same log without a picture (a 185 s round in about a minute).
- `tools/human_fight_report.py` - the raw rulers from that log, no pass lines: airborne, under the canvas, support-foot
  slip, hips / head per frame and pops, knee shake and jerks, all by clip. Absolute floor (canvas y 0 + each body's rest
  ball / ankle height, `floor.json`).
- `tools/film_sheets.py` - numbered frame sheets from a film (consecutive frames, 24 a second) for critics who cannot watch video.
- `tools/rest_feet_probe.gd` - each MetaHuman body's rest ball / ankle / sole heights.
- `tests/human_feet_test.gd` - the headless ruler (stage calls the fight makes, two different bodies, captured clips on).

## Round 0 - measurement only (main 8b89f819)
First finding, as the brief asked: WHY the old foot rulers were green while he saw flying boxers.
1. `tests/ring_feet_test.gd` turns the captured clips OFF (`RkClips.enabled = false`) and `tools/ring_feet_probe.gd` reads
   only frames where the footwork rig has the legs and only the plan's planted foot. In the game three quarters of a round
   is a captured take played "pure" (RkPure switches every leg layer off: pro_idle, rk_jab, rk_cross, rk_loc_*). Nothing
   read the feet there.
2. `tools/pose_tap.gd` (used by men_fight_film / fight3d_film joins) is a skeleton modifier; RkPure switches every modifier
   off in a pure take, so the tap keeps its last pose: my first log showed one frozen pose for 14 s. Any number those
   films printed for a pure clip is void. The new film tool reads on `skeleton_updated`.
3. A percentile of the film is not a floor (a boxer who hovers reads as standing). The floor must be absolute.

What main does (men's bout, seed 7, 362 s in-round = two rounds, per boxer):
| ruler | Danny | Liam |
| --- | --- | --- |
| both feet off the canvas (> 3 cm) | 5 times, longest 0.33 s, 7.3 cm | 11 times, longest 0.37 s, 8.7 cm |
| a foot under the canvas (> 2 cm) | 174 frames, deepest 12.8 cm | 99 frames, deepest 5.6 cm |
| support-foot slip (the stiller standing foot) | 62 m, 24 % of frames | 51 m, 22 % of frames |
| hips moved > 8 cm in one frame | 115 times, worst 26 cm | 75 times, worst 19 cm |
| knee jerks (2nd difference > 8 deg), L / R | 153 / 261 | 117 / 219 |
Women's bout: the same picture, plus one foot whipped to 1.2 m for 4 frames at a join into rk_loc_back.

Causes, read in the frames and the code:
- FLYING: at each return to guard from a duck, block, punch or reaction the join smoother blends from the RAW Punch PRO
  clip (its feet float: hips at rest height with bent knees) while the rig lets go in 0.2 s and RkPure fades the leg
  layers in 0.15 s; the guard join lasts 0.45 s. For half a second nothing holds the floor: the body rises 5-9 cm clear.
  On film (r0 58.1-58.8 s) both of Liam's boots hang over their shadows.
- RANGE NEVER REACHED: an aimed step (the entry lunge, the step out) plays a captured step clip in whole loops - the step
  in takes 1.6 s where a lunge takes 0.3. The gap read 1.41 m in the pocket phase and 1.45 m inside (asked: ~1.0 and 0.64).
- DRAGGED FEET: so landed punches are thrown from too far and PunchRange.close_in carries her place 0.35-0.9 m at up to
  3 m/s under a captured jab that has no leg layer: both feet slide (0.7-0.9 m of slip for every second of rk_jab).
- TELEPORTS: a side step committed at the return to guard (SideStep) plus RkJoin.align move her place 0.2-0.4 m in one
  frame, feet and all.
- PR 168 / 163 (LEGTREMBLE4 / 3): not used. Both re-bake about a hundred clips under `assets/anim/baked/` with smoothing
  baked in. The causes above sit BETWEEN the layers (who holds the floor, who steps, where her place jumps), not inside a
  clip, so a smoother clip changes none of them. No baked file is touched on this branch.

## Round 1 - flying, dragged feet, teleports, range (film `E:/FightCamp/tmp/humanfight1/r1/men.mp4`)
Ruler first: `tests/human_feet_test.gd` RED on main (both feet 6.8-7.7 cm off the canvas for 8-9 frames at each return to
guard; a carried punch drags the standing foot 0.8-1.1 m), then one cause per commit:
- `FloorStand.gd` (new, last leg layer, kept on in pure takes): both feet up -> the hips come down to the lower foot; a
  foot under the canvas -> that leg bends. Real bout: airborne 5 / 11 times -> 0 / 0, under the canvas 174 / 99 frames -> 0.
- `RkPure` + `FootPlant`: the leg layers come back while her place is carried under a captured clip; FootPlant replants
  when it wakes.
- `FootLock.gd` (new): a standing foot holds where it was last shown; when the FIGHT moves her it takes a real step.
- `ShownRoot.gd` (new): a one-frame jump of her place is covered over ~0.3 s (worst jump 26 / 19 cm -> 12 / 13 cm).
- `Footwork` + `RingFeet` + `BoxerFootworkRig`: an aimed range step is a stepped lunge on the rig (legs only), not the
  1.6 s step clip. Gap in the pocket phase 1.41 -> 1.02 m, inside 1.45 -> 0.71 m.
Critics (fresh, blind, 21 numbered sheets at 24 fps + raw rulers): boxing coach 3/10, mocap animator 3/10. Both: the
feet are right (0 frames airborne, nothing under the canvas). Both lists, most important first: 1. they walk through
each other (boots stacked, a face in a chest); 2. gloves pass through or beyond heads; 3. nobody reacts to a hit;
4. statues (seconds with no punch, no bounce); 5. pops; 6. folded in half at the waist; 7. steps that are not steps (a
toe-down hanging boot, feet together, an over-long lunge); 8. knees; 9. guard; 10. no weight in the punches. Their 10/10
pictures: `r1/critic_coach_10.png`, `r1/critic_mocap_10.png`.
Honest reading: fixing the range showed what the 1.45 m gap had hidden - close range was never tuned for these clips.

## Round 2 - what the critics asked for first
- `tests/rokoko_clips_test.gd` went RED on round 1's hard lock (12-16 leg snaps in a captured step against the raw
  take's 2-8): the takes' own data slides 0.5-0.7 m a step clip and stepping against it snaps the legs - the trembling
  the earlier agent left. FootLock now: correction through a critically damped spring, corrective steps only when the
  fight moves her, no lock inside rk_loc_*, the rig keeps a carried punch's legs until she is back in guard. Test green.
  Cost, said plainly: the round's total support-foot slide is back near main's (25 / 23 m against 30 / 28) because the
  step clips' own slide is left alone; the carried punch stays fixed (0.8-1.1 m dragged -> 0.09-0.21 m).
- Contact layers stay on in a pure take (PunchReach, GloveClear, ElbowClear, HitSnap).
- Keep-out: inside range 0.64 -> 0.84 m, floors 0.6 / 0.62 -> 0.76 / 0.78 (inside gap now reads 0.87 m).
- A stepping foot keeps its sole within ~17 deg of flat.
- Round 2's first film still showed them chest to chest; the log named three writers that ignore the range the fight
  keeps, all fixed in one commit: `RkJoin.align` moved her place up to 0.45 m any way to lay a clip's feet over hers
  (0.23 m straight at the other in one frame at the join into a cross); a captured step in played its whole loops
  whatever the gap; a punch's step in carried her as close as the short captured jab needs (0.8 m). Inside range now
  0.92 m, floors 0.84 / 0.82. Real bout, 185 s: heads within 0.40 m 4.3 % of frames (round 1) / 1.0 % (main) -> 0.3 %;
  hips within 0.75 m 12.2 % / 2.6 % -> 0.1 %; gap in the pocket phase 1.02 m, inside 0.95 m.
- The stepped lunge, both numbers (S431 asked): with the rig stepping a carried boxer the carried-punch ruler is green
  (0.10-0.21 m dragged) and the knees jerk 236-263 / 122-128 times in 75 s; with FootPlant alone (`-- norigcarry`) the
  knees jerk about half as often but the ruler is red again (0.75-0.99 m dragged). Slowing the lunge (1.15 -> 0.85) changed
  neither. On the frames the two look the same; the rig stays because the ruler does.
Critics round 2 (new seats, blind; film `E:/FightCamp/tmp/humanfight1/r2/men.mp4`): fight-game animation lead 3.5/10,
TV boxing director 3/10. Both: boots on the canvas, "torsos never pass through each other". Their lists now open with
1. the range picks the punch / the glove stops on the target (gloves still rest on a face 5-8 frames, pass a head, stop
short); 2. hits are not felt (two real reactions in the film); 3. pops (66 / 73 hip pops in 75 s, three whole-body jumps);
4. no shared stance (Danny feet together, Liam a 1.2 m lunge or stilt legs); 5. statues and dead air; 6. the idle is towed
(support-foot slip 14 / 13 m in 75 s, 5.6 m of it in the idle); 7. knees; 8. clip content (a dodge and weave that turn his
back, a body shot bowed flat, a 20-frame wind-up). Pictures: `r2/critic_animlead_10.png`, `r2/critic_tvdirector_10.png`.

## Round 3 - the approach change (same low score twice: "the cause is elsewhere")
3, 3, 3.5, 3 with the feet fixed says the cause is not one more leg layer. What four critics ask for - one stance for
both, a planted foot that never moves, steps that are steps, a bounce and weight shift while waiting, the resting glove
at the jaw, a glove steered to its target - is a description of the route this game had BEFORE the captured takes went
in (S391-S398: Punch PRO clips + the footwork rig + the guard and contact layers), which is still in the code as the
control arm `-- norokoko`. The captured takes play "pure", so those layers are off for three quarters of a round, and
three clip families with three different stances are stitched together (the Rokoko actor stands 0.8 m long, the Punch
PRO guard 0.5, the Mixamo side step on its toes).
Measured, same bout, same seed, 75 s, with every HUMANFIGHT1 fix in both arms (captured takes -> `-- norokoko`):
| ruler | captured takes (default) | `-- norokoko` |
| --- | --- | --- |
| both feet off the canvas | 0 / 0 | 0 / 0 |
| support-foot slip | 14.1 / 12.7 m, 30 / 28 % of frames | 0.7 / 0.6 m, 2.7 / 2.0 % of frames |
| a boot within 0.20 m of the other's | 2.6 % of frames | 0.0 % |
| hips moved > 8 cm in a frame (worst) | 10.0 / 13.3 cm | 9.2 / 10.9 cm |
| knee bend, median | 142 / 141 deg (tall) | 125 / 125 deg (a boxer's crouch) |
| knee jerks > 8 deg, L / R | 236 / 263 and 128 / 122 | 257 / 293 and 228 / 239 |
Film: `E:/FightCamp/tmp/humanfight1/r3_norokoko/men.mp4`. The last critic round the usage budget allows (weekly Fable
57 % before it; the brief stops at 85 %) went to this arm, two new seats (a biomechanist, a referee-judge).
WHICH ROUTE SHIPS IS THE OPERATOR'S CALL, not this branch's: he asked for the captured takes back in S399 ("these
animations are good why you removed them and changed them with crap", judging the takes as clips). The branch leaves
the default as it is; both films and both sets of scores are on the board.
Critics round 3 on the `-- norokoko` arm (new seats, blind): biomechanist 4/10, referee-judge 4/10. Both: "the feet are
now honest ... this is the best part" (never both off the canvas, the support foot still 97 % of frames, the step order
right: front foot first going in, back foot first going out), guards up, the stand-off distance real. What holds it
at 4, most important first: 1. one-frame pops (the straight right starts with the back already turned; crouch to bolt
upright in a frame; 68 / 42 hip pops in 75 s); 2. a punching distance per punch, enforced before it starts; 3. gloves
that park on the target 4-12 frames (contact should last one); 4. reactions in the contact frame; 5. posture limits
(a body shot bowed flat, Liam knock-kneed, Danny feet together walking back, both gloves over the head); 6. feet nailed
down during exchanges, no rear-heel pivot on a right hand; 7. the stance too low (knee 125 deg; a boxer stands
145-160); 8. statues (the idle is 42-48 % of the round). Pictures: `r3_norokoko/critic_biomech_10.png`,
`r3_norokoko/critic_referee_10.png`.

## Where it stands (stopped after round 3: the usage budget, and S431's instruction)
NOT at 7/10. Six fresh blind critics, three rounds:
| round | film | scores |
| --- | --- | --- |
| 1 | `r1/men.mp4` captured takes (default) | 3 (boxing coach), 3 (mocap animator) |
| 2 | `r2/men.mp4` captured takes (default) | 3.5 (fight-game animation lead), 3 (TV boxing director) |
| 3 | `r3_norokoko/men.mp4` captured takes off | 4 (biomechanist), 4 (referee-judge) |
FIXED and agreed by all six: no boxer leaves the canvas (the operator's complaint), no foot under it, torsos no longer
pass through each other, the pair reaches punching range before it punches.
NOT FIXED, the same in both routes, in the critics' order: punches do not stop on the target and gloves park there;
hits are barely felt; one-frame pops inside and between clips; clip content (a right hand that starts back-turned, a
dodge that shows the back, body shots bowed flat); no stance limits; statue-like waiting.
ONLY in the default route: three clip families with three stances stitched together, and the idle towed across the
floor (support-foot slip 14 m in 75 s against 0.7 m).
What the next agent should do first, from six lists that agree: (1) a per-frame pop cap on the shown pose and a 4-6
frame blend at every clip start; (2) "the range picks the punch" - a reach band per punch checked before it starts;
(3) contact for one frame then the hand comes home, with the reaction on the same frame; (4) posture limits applied to
every clip (trunk lean, knees over feet, gloves between belt and eyebrows). None of the four is a leg layer.
The route (captured takes or the earlier stepping route) is the operator's decision; the default is unchanged.

## Results
RESULT: tests/human_feet_test.gd -> HUMAN_FEET_TEST failures=0   (run with `--headless --fixed-fps 30`)
Red proof: the first version of the test on main's code read failures=3 (commit e451a118); the final test with every fix
switched off by its control flags (`-- nofloorstand nofootlock nosmoothroot nocarrylegs lococlipsaim norigcarry
nostopatrange nocarryfloor nojoinkeep`) reads failures=6: both boxers off the canvas 8-9 frames (6.8 / 7.7 cm) and four
carried punches dragging the standing foot 0.81-1.11 m.
Touched tests green on the branch: ring_feet, rokoko_clips, foot_plant, boxer_footwork, knee_track, tired_legs,
knockdown_still, knockdown_ring, kd_count_ready, corner_warm, body_keep, range_breath, inside_beats, inside_exits,
clinch_beats, clinch_rest, fight_flow. Two existing tests edited because they hard-coded the old keep-out distances
(body_keep_test, range_breath_test). Not run: the full suite (05:00), an export, the women's bout after round 0.
Branch `claude/humanfight1`. Last films: `E:/FightCamp/tmp/humanfight1/r2/men.mp4` (default route) and
`E:/FightCamp/tmp/humanfight1/r3_norokoko/men.mp4` (captured takes off).
