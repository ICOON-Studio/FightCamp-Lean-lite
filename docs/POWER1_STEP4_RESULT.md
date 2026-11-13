# POWER1 step 4 - each punch from its own distance (result, review round 1)

Written last, from the final runs on branch claude/power1. The 3D fight still decides nothing: nothing under scripts/rules
or scripts/state changed, and who lands what is the same. `-- nopunchrange` turns all of step 4 off. That control arm runs
the old code paths, and its ruler run is identical run after run (100 failures twice).

## First: the old ruler was measuring the wrong picture

`tests/punch_range_test.gd` read the skeleton from the test's own frame step. There, Godot gives the clip's pose before
the modifier stack runs: no reach, no hip travel, no head clearance. So it never saw what is drawn. Its numbers (48 with
the step on, 50 without) described a picture nobody sees.

It now reads the bodies in `Skeleton3D.skeleton_updated`, which fires after every modifier. That is the frame as drawn,
the way the other drawn-frame tests read it. On the drawn read, the old code lands straights with the elbow at a median of
76 degrees. That is the research doc's 76, so the ruler now matches the earlier measurement.

The ruler also changed in five other ways. None of the bars moved.

- CORR is measured against the arm as it stood before the reach moved it, on that same frame.
- A punch shown as a graze now counts as a failure. A graze is a landed punch that the 3D failed to land.
- The heads are checked on every hit.
- The wanted distance is printed as it was on the hit frame.
- New probe lines set the live arm against the range table.

Red first, on the corrected ruler. The control arm (the old code) gives `PUNCH_RANGE failures=100`.

## What the probe showed (why the straights were folded)

On the hit frame, as drawn, the other boxer's face sits 0.17-0.34 m in front of her body. The range table assumed 0.14,
taken from the bare clip. Her shoulder also sits ahead of the table on a straight and behind it on a hook. Together these
put the distance a straight needs at about 1.05-1.15 m, against the table's 0.93. One shipped game works at 1.05-1.35 m and
never closer than 1.08, so these numbers agree with it.

## What changed

- **The distances come from the drawn bodies** (new `scripts/fight3d/RangeLive.gd`).
  - While each boxer stands in her guard, it reads how far her drawn face sits from the clip's guard.
  - On each landed punch, it reads how far her shoulder sits from the clip's at the hit, for each kind of punch.
  - Both readings are eased over time. RangeTable adds them to every distance it hands out.
  - These are measured live, not typed in. Until a reading comes in, the bare table is used.
- **Uppercuts are no longer forced to 0.70-0.74 m.** They get their own distance the same way as the other punches,
  never closer than 0.70.
  - As drawn, an uppercut needs 0.83-0.90 m between the hips, with the elbow at 105 degrees and the glove under the chin.
  - At 0.70 m the heads met: they came as close as 0.18 m.
  - This departs from the step's 0.70-0.74 m. That number came from the bare clips, which have no stance, lean or head
    clearance.
- **The punch in the air keeps its own distance until it lands** (RangeBreath).
  - BeatFire now writes each punch's contact time and take onto its beat.
  - Until that contact time, the footwork stands the pair at that take's distance. Only then does it move on to the next
    punch.
- **The range fix is gone.** That was the body carry-in read off the arm, and it was what leaked into the punch weight test.
  - A landed punch's carry now follows the pair toward the table distance until just before contact.
  - It reads only the place and the table, never her arm, so both arms of the weight test get the same carry.
- **The shoulder leans back when the arm would fold.** If a landed punch's point is so close that the elbow would bend
  past its kind's angle (162 a straight, 100 a hook, 105 an uppercut), the chest turns her shoulder back off the point.
  - Her hips and feet stay put, so the weight going into the punch is unchanged.
  - The owner asked for this: "make shoulder lean a bit back like in jab a".
- **The 0.30 m cap is held on the glove as drawn.**
  - It is centred on this frame's clip glove, including the extra solve the head clearance does.
  - It holds while the glove travels to her and on the hit frame. After that the carry goes on from the point it met.
  - A blocked punch is not capped: it reaches her blocking glove.
- **A big or hurting shot is never shown as a graze.** That means a big hit, or a `_hard` or `_hurt` take.
- **The lead uppercut's hand-back.** The swing over her own head was not the clip. Three things caused it:
  1. The tail hold played the clip on after the hit.
  2. The return to guard entered the idle loop at the frame nearest the rising glove.
  3. The join then carried the clip's upward speed onward.

  The fix: this punch now goes straight to her usual guard. That is the loop frame nearest the loop's average pose, and the
  join starts from a standing pose. `trace=1` on the film tool prints the frames.

## The ruler, final run (played fight, seed 4242, 200 s, windowed on the never-shown desktop)

| | control arm (old code) | step 4 |
|---|---|---|
| failures | **100** | **72** |
| straights: elbow in band (140-175) | 0 of 9, median 76 | 6 of 9, median 155 |
| hooks: elbow in band (80-120) | 3 of 9, median 124 | 5 of 9, median 116 |
| uppercuts: elbow in band (80-125) | 10 of 14, median 122 | 14 of 14, median 110 (102-120) |
| gap at the hit, median: straights / hooks / uppercuts | 0.905 / 0.905 / 0.904 m | 1.034 / 1.082 / 0.972 m |
| reach correction over 0.30 m (CORR) | 10 hits, largest 0.667 m | 0, largest 0.300 m |
| clean hits more than 0.08 m off their point (MISS) | 17 | 20 |
| shown as a graze | 0 | 1 (a hook) |
| heads closest on a hit: straights / hooks / uppercuts | 0.388 / 0.436 / 0.479 m | 0.600 / 0.600 / 0.520 m |
| heads under 0.45 m outside clinches (dips) | 31, closest 0.215 m | 22, closest 0.198 m |
| lead toes crossed | 14 | 16 |
| frames standing at 0.70-0.74 m | 12, heads closest 0.327 m, toes crossed 1 | 12, heads closest 0.349 m, toes crossed 2 |

What the 72 failures are:

| Failure | Count | What it is |
|---|---|---|
| HEADS | 28 | Mostly the whole-fight body watch. The old code has the same at 40. |
| MISS | 20 | Mostly hooks and uppercuts whose own clip glove is more than 0.30 m from the point at contact, so the cap stops them short. |
| TOES | 16 | Lead toes crossing. The old code has 14. |
| ELBOW | 7 | Arms outside their band. |
| GRAZE | 1 | One hook shown as a graze. |

Is the punch in the air given its own distance? On the hit frame, the wanted distance and the punch's own distance differ
by a median of 0.045 m over 32 hits. They part when both boxers punch at once, because the footwork can serve only one of
them. They also part when the hit lands just after the round clock's contact time and the next punch has taken over.

## What does not hold (reported, not fitted)

1. **The ruler is not green: 72 failures.** The step does not create the head dips or the toe crossings. Both happen in
   the old code at about the same rate, mostly during dodges, body shots and hit reactions, and need their own fix. Most of
   the misses are the 0.30 m cap doing what the step asked: the clip's own glove ends too far from the point to be stretched
   there honestly.
2. **The bodies at 0.70-0.74 m** come there for only 12 frames in the bout. At those moments the heads were 0.349 m apart
   (old code 0.327) and the toes crossed twice (old code once). The proof the review asked for, heads at least 0.45 m apart
   at that range, does not hold. Uppercuts are now thrown from 0.83-0.90 m instead, where the heads on the hit were at
   least 0.520 m apart.
3. **The lead uppercut's return still pops.** The glove no longer goes over her head: its highest point after the hit is
   0.07 m over her head bone, which is guard height, against 0.18 m before. But on the cut back to guard the glove still
   jumps up to 0.48 m in one frame (28.6 m/s; before 17.1 m/s). The join waits up to two frames for the new pose before it
   captures. This is the join's own timing and was there before step 4. It is not fixed here.
4. **Hooks** have their own distance, but a hook's own clip glove often ends more than 0.30 m from her face at contact. The
   capped glove then stops 0.10-0.40 m short, and the miss stays a clean hit unless it is over 0.15 m. A hook take thrown at
   a real target would fix this. A bigger correction would not.
5. **Other tests, red before step 4 as well.** "Before" means the same files at e37e4862, put back and run.

   | Test | Before step 4 | After |
   |---|---|---|
   | hit_frame | 11 | 12 |
   | hit_carry | 40 | 45 |
   | block_meet | 11 | 12 |
   | punch_speed | 42 | 42 |

   - hit_frame and hit_carry now stage each punch at its own distance and aim it where the fight aims it (an uppercut at the
     chin). The fight's old single jab distance and face point stand only with `-- nopunchrange`.
   - Staged at the jab distance, they read 54 and 77 with step 4 on. This is a change to how the test stands the pair;
     no bar changed.
   - The extra hit_carry failures are hooks that the cap stops short of the face (point 4).

## Other tests run on the final code

| Test | Result |
|---|---|
| punch_weight | `PUNCH_WEIGHT_TEST failures=0`. With `-- nopunchrange` also 0. Landed carry 0.077-0.130 m on, 0.073-0.107 m off, band 0.07-0.16. The leak is gone. |
| range_breath | `RANGE_BREATH PASS (0 failures)` |
| fight_feel | `FIGHT_FEEL failures=0` |
| beat_clips | `BEATCLIPS failures=0` |
| sound_sync | `SOUND_SYNC checks=30 failures=0` |
| beat_tally | `BEAT_TALLY_TEST failures=0` |
| block_set | `BLOCK_SET failures=0` |
| head_aim | `HEAD_AIM failures=0` |
| human_feet | `HUMAN_FEET_TEST failures=0` |

## Films (seed 4242, the same beats, the same camera)

`tools/hit_frame_film.gd jabs=1 crosses=1 uppercuts=1 seed=4242 side=1`. Before is `-- nopunchrange`; after adds `trace=1`.
`side=1` films through a camera of the tool's own, square to the line between the two boxers, with boxer 0 on the left and
the camera above the top rope. Before and after are therefore the same view, frame for frame.

What I saw:

- **Cross.** Before, the arm is folded to about 90 degrees and the heads are almost touching. After, it lands nearly
  straight with the heads about 0.6 m apart.
- **Lead uppercut.** After, it lands under the chin, and there is no swing over her own head.
- **Neither film** shows one torso passing through the other. The arms do still cross each other in the exchanges after
  the hit.

## S445 fix round (after a fresh blind read of steps 2-4)

**Ruling (coordinator, S445):** uppercuts land at the measured 0.83-0.90 m centre to centre, and 0.70 m is the floor.
At the brief's 0.70-0.74 m the drawn heads met, so the distance as drawn wins over the brief.

The blind read (it did not read this note) said FIX on all three steps. This round changed five things:

- **Step 3, `ReachDrive.gd`:** the HOLD is gone. It pinned the glove about 0.5 m out, then the drive covered all of it
  in 0.08 s.
  - Until the drive, the glove now follows the clip.
  - The drive starts early enough to get there on an even push (2 d / v, never shorter than `drive_t`).
- **Step 2, `PunchReach.gd`:** the carry through her face runs on real time from the frame after the hit. Before, the
  hit-stop froze it with the clip.
- **Step 4, `HitImpact.gd`:** hard, hurt and big takes are no longer exempt from showing as a graze. A glove still off
  her on the hit frame is a graze, whatever the take. The result is unchanged.
- **Step 4, `UpperRoom.gd`:** the uppercut floor eases back up as soon as no uppercut is wanted or the bodies crowd.
  Before, it stayed down until they stepped apart, and the toes crossed at 0.707 m in a rest phase.
- **Step 4, `BeatClips.gd`:** the lead uppercut's hand-back takes 0.22 s instead of 0.05 s.

Tried and reverted: stepping the feet in first for own-distance punches. Hooks reached their distance, but it moved the
pair's gap, and punch_weight went from 0 to 2 failures.

| Test | Floor | Before this round (blind read) | After |
|---|---|---|---|
| punch_speed | 42 | 47 | **39** (FIRST 13, POP 12, SPEED 14) |
| hit_carry | 45 | 45-47 | **42** |
| hit_frame | 12 | 12 | **12** |
| block_meet | 12 | 12 | **11** |
| punch_weight | 0 | 0 | **0** |
| punch_range (seed 4242) | - | 72 | **74** |

The punch_range lines, before then after:

| | Before | After |
|---|---|---|
| ELBOW | 7 | 6 |
| GRAZE | 1 | 2 |
| HEADS | 28 | 32 |
| MISS | 14 | 15 |
| TOES | 16 | 14 (the control's 14) |
| Hooks in band | 5 of 9 | 6 of 9 |
| Heads closest | 0.198 m | 0.185 m |

Also green after the round: range_breath, beat_clips, fight_feel, sound_sync, beat_tally.

### Still red (reported, not fitted)

1. **The played-fight hit frame.** In the film (seed 4242, side=1), the cross and the jab still reach her face one frame
   before the hit frame at 13-15 m/s, then move 1.2 m/s on it. The carry now moves 2-4 cm during the hold, where before
   it did not move at all. The hit's timer and the drive's end are still one frame apart. Next fix: fire the hit on the
   frame the drive arrives, or end the path at the hit's frame.
2. **The lead uppercut still pops after the hit** (26.1 m/s at f27). It is not the recovery length. The join captures
   the clip's raised arm (the pose before the stack) instead of the drawn, reach-held glove. Next fix: JoinSmoother
   captures the drawn pose after the reach.
3. **Distance at the hit.** Uppercuts and hooks still land 0.95-1.09 m apart, because the footwork does not arrive by
   contact. Fixing that needs a step that is given back after the punch.
4. **Grazes come from the solve's own miss, not the drawn glove.** The ruler and the show disagree on 2 of 3 cases.
5. **Gloves pass through each other** after the hit, on all four sheets.

Sheets (f13-f30, the hit on f19) are in the shared notes folder `fixround/`: `sheet_cross.png`, `sheet_jab.png`,
`sheet_upper_lead.png`, `sheet_upper_rear.png`. The blind read's sheets are in `blindread/`.
