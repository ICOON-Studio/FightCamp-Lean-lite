# TASK FIGHT9R20 - ANTIGRAVITY (Gemini 4 Argon High, the operator's 2,500 credits) - the live fight AND every clip to 9/10 on Argon's own judging, round by round

**S385 (Claude) - THE PROBE WAS BLIND, FIXED ON YOUR BASE (claude/fight9base):** `tools/fight9_probe.gd` graded the knee hinge
on the RAW clip (read from outside the modifier stack), so no round could pass it, and one toe-off frame (foot 1.4 cm across
the floor) read 153 deg. Both fixed. On the base the probe now has ONE real red: the DRAWN knee caves 8.5 deg inward on a
step (`max_inward`, bar 5 deg) though KneeTrack.ALLOW_IN_DEG is 0 - find which modifier undoes it after KneeTrack. Turn that
green with every check green and your round is KEPT. Do not edit the probe's bars.

**S379 (Claude): the base (claude/fight9base f2e0366b, main merged in) now has the TV camera and the corner-start films - keep both green:** `tools/cam_motion_probe.gd -- show3d fromcorners fightjump=men_fight secs=90 knockdown=70` PASS (turn <= 10 deg/s, no zoom while moving, never behind a boxer, no shot under 2 s, no lens outside the ropes), `tools/cam_view_probe.gd -- show3d fromcorners fightjump=men_fight` PASS, `tools/corner_start_probe.gd -- show3d` failures=0 (films open with both men in their corners and walk to the centre; FightIntro.from_corners).

Status: OPEN (S371, Claude; S372 rewritten after round 1 failed to compile). Operator S371: "gemini4 review the fight with the fixes and rate it again", "and then tell
gemini to reach to 9/10", "let argon do all the fixes until its 9/10". Main scored 3/10 (verdict below).

## S379 BASE (Claude): claude/fight9base = YOUR ROUND 7 + main (2ed94f70). Round 8 never ran (agy.exe missing at launch).
The loop dropped round 7 only because tools/fight9_probe.gd crashed on its own line (BeatClips.BIG_REACT is an Array, the probe
cast it to a Dictionary). Claude fixed the probe and kept round 7: it scored 6/10 and FIXED THE KNEE TREMBLE - knockdown_film on
it: standing knees jerk p95 3.46 deg/frame^2 (base 12.0) and 0.9 flips a second (base 3.2), both inside the bars. KEEP that.
Still red on your BASE (fix these first, then Argon's worst moments below):
- fight9_probe "knees over toes": ONE sample of 789 at 153.7 deg, on the first frame of the first `step` (left leg) - a one-frame
  knee pop when FootPlant starts a step (your new _plant null / _knee_deg null reset). Every other sample is under 18 deg.
- fight9_probe "knee bend axis" (your own S377 bar): worst 64.4 deg at clip `pull` 0.21 s, leg 1. DOWN / OUT / WIN clips are
  no longer measured (they play free of FootPlant; a lying body has no hinge to hold).
- knockdown_film "he steps to the corner, the planted foot holds": slide p90 1.45 m/s - NOT YOURS: real walk clips are being
  collected (LOCOWALK2, StepRoot); leave the walk alone, keep every other knockdown_film line PASS.
- Argon on your film: the standing boxer walks over the downed boxer's legs during the count before going to the corner
  (judge film, men_fight knockdown at 70 s - knockdown_film's own corner line passes, so read KnockdownCount's path in that bout),
  the replay camera hides behind the ring post, heads/torsos through the ropes on the ring entry, the inside exchange at 01:18
  clips (heads into chests).

## S377 BASE (older): claude/fight9base now = round 5 + main through 7988a595 (merged by Claude, no conflicts): the knockdown count
(KnockdownCount: neutral corner, the clock holds, 1-8/10, he gets up or the bout ends), StepRoot, the drawn-bone probe.
tools/knockdown_film.gd on this base: every line PASS except "he steps to the corner, the planted foot holds" (drawn slide
mean 0.48 / p90 1.0 m/s) - KNOWN RED, owned by TASK_LOCOWALK1 (cursor, real walk clips); keep every other line PASS.

## S377 MEASURED (Claude) - THE KNEE TREMBLE IS FOOTPLANT'S STEPPING (read before item 1 below)
Operator S377 on the knockdown film: "the knees seem to be trembling". tools/knockdown_film.gd (on main, merge it) now
reads the bones AS DRAWN (cached on skeleton_updated - outside the modifier pass get_bone_global_pose returns the CLIP's
pose, so a probe reading it never sees FootPlant/KneeTrack; every earlier leg number from such a read is the clip's).
Drawn, the fight after BOX! (both boxers, 53 frames): knee jerk p95 11-15 deg/frame^2 and 4-7 direction flips a second with
FootPlant; 1.6-3.2 and 0-1.7 with `nofeet`; `noknee` / `nojoin` change nothing. Per frame (`-- kneelog`): a foot is mid-step
in 23 of 53 frames, one step every ~0.6 s, and each 0.2 s swing pumps the knee 152 -> 125 -> 160 deg - that pump IS the
tremble. Standing still the knee sits pinned at the CAP_REACH limit (163.8 deg) and dips with the bounce. Tried on main and
reverted (not clean): stepping only past the clip's own reach (no change), SWING_S 0.32 + LIFT_M 0.025 (fight jerk 4-7 but the
standing walker 15-20, a 69 deg spike). The real fix is real step clips moved by scripts/fight3d/StepRoot.gd (main, S377:
the body travels as far as the clip's planted foot pushes it) with FootPlant holding ground contact only - TASK_LOCOWALK1
(cursor) makes the clips. Bars for any FootPlant change: drawn knee jerk p95 <= 4.5 and flips <= 1.5/s (the `nofeet` level).

## OPERATOR S376 - ARGON FIXES ALL THE CLIPS, TO 9/10
His words, to you: "let argon fix all the clips", "tell argon i expect to raise the quality to 9/10 results", "tell argon
to work on the animation until the quality reach 9/10". The loop no longer stops at a round count - only at 9/10.
Every clip the fight plays is yours, not only the live round's look. What he saw himself, worst first:
1. KNEES TREMBLE ("knees also tremble on the clips i see on the board") - a knee that shivers frame to frame while the
   stance holds. Bar: over 40 s of the men's round, each knee's angle frame-to-frame second difference (jerk) p95 under
   a bar you measure on the nofeet/noknee control arms (tools/men_fight_film.gd writes the per-frame legs.csv) - the
   tremble is a modifier fight (FootPlant / KneeTrack / the join smoother), so bisect with the control args first.
2. KNEES BEND THE WRONG WAY ("knees bent unaturally, i told you before something is wrong") - on the canvas after a
   knockdown the knees kink sideways and the feet turn so the soles face the camera (pro_knockout_countdown_v1 at
   5.6 s, Danny mh_boxer_02 - tools/fight3d_clip_sheet.gd prefix=pro_knockout glb=mh_boxer_02). A knee is a hinge: it
   bends only forward of the thigh, the foot follows the knee. Bar: in every clip of BeatClips' pools, the knee's bend
   axis stays within 25 deg of the hip's side axis.
3. BARE TOES SHOW THROUGH THE BOOT SOLES (the same still: the sole is open, the foot inside shows) - FighterKit's boots.
4. Hands under the canvas on the floor - FIXED ON MAIN (scripts/fight3d/FloorClear.gd + tools/floor_clear_probe.gd,
   lowest glove 0.085 m, pelvis on the canvas): merge main, keep floor_clear_probe green.
5. The knockdown: main now drops him on the shot (BeatFire FALL_AFTER_S / FALL_FROM_S, head 0.74 m down 0.8 s after
   the punch) and replays the shot in slow motion (KnockdownReplay + PoseRecorder) - keep tools/knockdown_film.gd green.
The judged film from R5 is Danny's men's bout WITH a knockdown at 70 s (FILM below: knockdown=70), so Argon sees the
fall, the replay and the boxer on the canvas.

## OPERATOR S376 - READ FIRST, it overrules every earlier timing choice
From R5 the judged film is DANNY'S MEN'S BOUT (FILM: fightjump=men_fight) - the bout he watched; the first R5 score is
the new baseline (the earlier rounds filmed Lucy's).
He watched the men's bout on main: "their leg animation are broken completely their punch speed feels very fast along
with their body movement and it is very unatural". Claude measured it (tools/men_fight_film.gd; men and women alike):
- LEGS: knees locked dead straight (> 170 deg) 14-22 % of a round. Cause: FootPlant planted a foot by distance only,
  the hips moved on and the IK pulled the leg straight, then the foot snapped across. FIXED ON MAIN 54684f35 (STEP_REACH /
  CAP_REACH: a foot steps before its leg runs out of reach; no IK target past ~165 deg) -> 0-1 %. Your BASE must merge
  main (FootPlant: keep BOTH - this branch's toe axis + KneeTrack.align AND main's reach rule).
- PACE: the R2 base made the fight FASTER - IMPACT_S jab 0.19 (main 0.365), OTHER_SPEED 1.45, COMBO_LAND_S 0.28. That is
  the opposite of what he asks. Put main's values back: IMPACT_S = the Undisputed medians (jab 0.365, cross 0.501, hook
  0.534, uppercut 0.489, body 0.450), COMBO_LAND_S 0.35 / COMBO_SAME_HAND_S 0.45, OTHER_SPEED <= 1.1, RECOVER_MAX and
  REACT_FAST_MAX <= 1.5 (main S376: at 2.5x the whole body snapped back with the hand). Never speed a whole clip up to fix
  timing - only the arm moves that fast in a real punch.
- ARGON ON MAIN AFTER THE FIX (S376, Danny's men's bout, judge_film fightjump=men_fight; full text in the board post
  2026-11-03_1215): 3/10 before -> 3/10 after. Gone: the vibrating / skating / straight-locked legs. LEFT, worst first:
  (1) the footwork reads as WALKING - the step clips are walk cycles: a narrow base, legs scissor/cross when he backs up
  (00:46-00:50), the rear foot slides up behind the lead heel on a step-in body shot (00:30); a boxer's shuffle keeps the
  stance width and never crosses the feet. (2) feet skate while the body glides on idle bounce (00:31-00:33). (3) the idle
  bounce is a fast high-frequency bob; a duck drops and pops up "like a jack-in-the-box" (00:44) - slower, weighted.
  (4) a mid-round 180-degree camera cut swaps the boxers' sides while the HUD corners stay put (01:13). (5) ring entry:
  a leg twists backwards through the ropes (00:02-00:06). Fix these with the bars below, never by speeding clips up.
- BARS (add to tools/fight9_probe.gd, over 40 s of round 1, each boxer): knee > 170 deg in <= 2 % of frames; foot jumps
  (> 3 m/s in the body's frame) <= 4; frames with AnimationPlayer playing speed > 1.6x <= 2 %. tools/men_fight_film.gd
  writes the per-frame legs.csv these read (Claude's numbers: ops/research/S376_DIGEST.md when written).

## How the loop works
- You are one ROUND. You fix the costliest defects in the "Last verdict" below that are yours (see "Not yours"), one or
  two per round - a real fix, not a tweak of a number to fool a camera.
- The dispatcher then commits your files, runs the checks headless, films the same fight (tools/judge_film.gd, the walk-in
  and 90 s of round 1 at real speed) and Gemini 4 Argon judges it. If the score is at least the last one and every check is
  green, your branch becomes the next round's BASE; otherwise the next round starts from the round before and reads why.
  The next round's brief is this one with the new verdict. It stops only at 9/10 (operator S376: "tell it to work on it until it is 9/10"); a Claude session merges.
- You cannot run anything (file tools only). So read the code that plays the fight before you change it: the fight view
  is scripts/fight3d/ (FightView, FightStage, MovePlayer, BeatFire, BeatClips, HitImpact, HitSnap, Footwork, FootPlant,
  PunchRange, RingPlace, CornerCrew, the camera files), the clip timing data assets/data/clip_contact.json,
  clip_recovery.json, clip_travel.json. Keep every script under 500 lines.
- Every fix gets a measured bar in tools/fight9_probe.gd (extends SceneTree, plays a live round headless like
  tools/knee_probe.gd / tools/judge_film.gd do, prints PASS/FAIL lines and "FIGHT9 failures=<n>", quit(1) on failure).
  Keep the earlier rounds' bars; add yours (e.g. a jab's extension time from start to full reach, feet travel per planted
  step, the camera never jumping across the line). A headless pose probe must `await process_frame` after loading clips or
  every seek reads the rest pose (S370 trap). Inert-modifier trap (Ziva S362): a SkeletonModifier3D may not reach the shown
  pose - change what is drawn, and measure the drawn bones.

## Not yours (other seats own them right now - do not edit those parts)
- (The REFEREE is YOURS now - S371: Qwen's NOREF1 crashed its own probe and left frozen clinches, PR #23 closed. The
  operator's call stands (S369: no referee - both boxers push each other off slowly, hands on, guard up). Read Qwen's try
  in ops/research/noref1_qwen/ (PushOff.gd.txt, push_off_probe.gd.txt, hooks.diff.txt = its Clinch/BeatFire/FightCast edits) and take
  what works; the clinch must end in a push-off that never freezes and never passes through a body.)
- Body-shot hit reactions: Ziva's BODYREACT1 (HitSnap / BeatClips / BeatFire body-shot paths). Head-shot snap and punch
  timing in those files are yours; the body-shot reaction code is hers.
- Tired legs: scripts/fight3d/BodyBurn.gd's tank lines (TANK_POWER, the legs/power from an empty tank) are Claude's
  S373 work on main - leave BodyBurn.gd alone this round.
- Knees: your own KNEETRACK1 (scripts/fight3d/KneeTrack.gd) - build on it if it is in your base, do not fight it.

## Clinches are rare now (operator, S374) - do not bring them back
"to lower clinches ... clinch happen only when a fighter is desperate to break opponents combo but get risk of getting hit,
that should be pretty rare and i dont care about the real stats". scripts/rules/ClinchBeats.gd (not yours) now places a
clinch only right after a combination lands on the holder, ~0.16 a round, often with the attacker's entry shot landing
0.30 s before the tie-up (beat key "entry": true). Your push-off still has to be right for the few that happen.

## Body folds must hold (S374, from merging main into agy/fight9r1) - read before touching punch timing
Main now has Ziva's BODYREACT1 (tools/body_react_probe.gd -- show3d: every shown body shot folds >= 18 deg within 0.15 s
and HOLDS >= 0.35 s; main reads 25.9 deg / 0.43 s). Merged with your round 1 it read react 39/39, curl 22 deg OK, but held
0.20 s - your faster combos (BeatClips.COMBO_LAND_S 0.28 / COMBO_SAME_HAND_S 0.36, main 0.35 / 0.45) land the follow-up
inside the fold. Keep the quicker hands, but a follow-up aimed at a boxer still folded (HitSnap _bt < 0.51, _gain > 1.5 -
BeatFire._folded) waits for the fold, the way BODYREACT1 already makes her own next punch wait. Body-shot reaction code
itself stays Ziva's. When your branch is collected, body_react_probe must PASS.

## Operator's own note first (S372, comment C218 on the KNEETRACK1 after-film at 24 s) - TOP PRIORITY
"when legs move its akward something is wrong, when doesnt move looks ok". Claude looked at the frames (19-24 s): standing
still the legs are fine; the moment she steps, the knees cave inward toward each other, the feet turn out away from the
knees, and the rear heel lifts with the foot twisted. The stance goes knock-kneed for a beat on every step, slip and
crouch. Fix the MOVING legs (stepping, slips, crouches): knees over the toes WHILE the feet travel, feet pointing where the
knee points, heel lifts on the line of the foot. Your KneeTrack.gd (KNEETRACK1, merged) holds the still pose; the moving
pose is where it breaks. Add a bar in tools/fight9_probe.gd: knee-over-toe angle during steps (not only at rest).

## Last verdict (round 19: Argon 6.5 -> 5.5/10 on agy/fight9r19; DROPPED - worse or a check failed; you start from the round before)

# JUDGE: Claude claude-opus-5-5 on 15 eyes contact sheets (FIGHT9R20 after) - Gemini prepay out, S380 operator: "Judge by Claude's eyes"

# FIGHT9R20: judged from contact sheets

**Coverage:** I opened all 15 sheets. They show about 0:00–0:03, then 3-second windows from 0:10 to 1:53, plus three 0.5 s tight bursts. Only Round 1 is on film, from clock 2:59 to about 1:31, so **nothing here shows "round by round" progress or any separate clip.** The gaps between sheets are unseen, including the bell walk-out (0:03–0:10) and the punch that scored the knockdown (see below).

## 1) Does it look like real boxing?

**Footwork and range: partly.**
- Boxers keep believable range and circle at 0:30–0:32, 0:50–0:53 and 1:41–1:42.
- Stances are often too upright and narrow. Blue's feet nearly close under him at 0:31.4, 0:42.2 and 1:12.0.
- There's very little feinting. In 0:30.0–0:32.8, 0:50–0:53, 1:40.8–1:42.4 and 1:50–1:51.4, both boxers mostly just hold guard. A large share of the sampled time has no punch thrown.

**Punch selection: narrow.**
- Long straight arms dominate (0:10.2, 0:28.4–0:28.8, 0:40.4, 0:40.8, 1:10.2, 1:40.0, 1:51.6, 1:52.6).
- There are some low or body-level moves at 0:12.0–0:12.2 and 1:11.0–1:11.2.
- I can't see a clear uppercut or a well-formed hook sequence. Combinations mostly look like alternating straight arms.

**Defence: the best-looking area, but it reads mechanically.**
- Gloves meet punches at 0:10.6, 0:40.8, 1:40.0 and 1:52.0.
- Red ducks under Blue's arm at 1:11.0–1:11.2, and this is credible.
- Blocks show almost no recoil in the arm or body. Punches simply stop against a parked guard (0:40.8, 1:40.0).

**Clinches and close work: weak.**
- 0:20.2–0:22.2 and 1:00.0–1:02.0 are about 2 s each of chest-to-chest glove pawing, with no real tying up and no force.
- At 0:57.1–0:57.6, Blue dives in head-down and separates within about 0.4 s. Blue's glove reaches toward Red as they part, and Red's lead leg lifts.
- That 0:57 break is the closest thing to a push-off, but it has no visible shove or recoil. It looks more like they drift apart than a real break.

**Hits: one big reaction, little else.**
- Outside the knockdown, I can't find a clean head snap or stagger in any sheet.
- The low bend at 0:12.0–0:12.2 could be either Red ducking or Red folding from a body shot. The sheets can't settle it, and that ambiguity is itself a readability problem.

**The knockdown (1:20–1:33).**
- *The fall:* the live fall at 1:20.0–1:20.8 is strong: Blue tips back, sits, then lies flat, and the direction matches where Red stands.
- *The impact:* I didn't see the punch itself. It falls before 1:20.0, and the replay frames I have (1:22.4–1:23.0) stop before it.
- *Standing boxer:* Red holds guard with no reaction at 1:20.0–1:20.8, right by Blue's boots. Red is still next to the body at 1:26.3 and only gets well clear at 1:30–1:33, backing away with gloves up.
- *Downed boxer:* the rise is the second-best passage in the film: seated at 1:30.0, on hands and knees at 1:30.2–1:31.0, rising at 1:31.4, upright by 1:32.2 on count 6.
- *Count and clock:*
  - The clock holds at 1:49 from 1:20 to 1:33, and the count ticks at about one number per second (4 at 1:30.2, 5 at 1:31.2, 6 at 1:32.2).
  - Extrapolating back from "3" at 1:30.0, count 1 fell around 1:27–1:28, about 7 s after he hit the canvas.
  - No count shows in the frames I have of the replay, so the graphic looks late. 1:26.3–1:30 is unseen.
- *Aftermath:* by 1:40.0 (clock 1:44), Blue is back to a normal guard and range, with no visible wobble or caution.

## 2) Animation defects

- **Snap, worst in the film:** at 1:26.0 Blue stands with arms overhead and no REPLAY caption, then is a motion-blurred smear on the next frame, then flat at 1:26.1. That's about 0.1 s for a fall that took 0.8 s live at 1:20.
- **Sudden crouch:** Red goes upright to deep crouch and back between 1:02.0, 1:02.2 and 1:02.4, far too fast at this sample rate.
- **Lunge pop:** Blue goes from normal stance at 1:10.4 to a deep fencing lunge at 1:10.6, rear leg stretched out and head at Red's chest, in 0.2 s. It looks like a pose jump, and 0.2 s sampling can't show the in-between.
- **Overlaps (probable, not proven from stills):**
  - Red's glove on Blue's face or head at 0:20.6, 0:57.1 and 1:00.2.
  - Red's glove pressed into Blue's chest at 1:00.8–1:01.8.
  - Boots touching or overlapping around the downed Blue at 1:20.8, 1:25.8 and 1:26.3.
- **Puppet stretches:** the guard poses barely change in the standoffs at 0:50–0:53 and 1:21.0–1:22.2 (the second is in replay). In the close work at 1:00.8–1:02.0 the feet and hands hardly move.
- **Repetition:** the same long-arm extension and return-to-guard recurs throughout (0:28, 0:40, 1:40, 1:52).
- **Tight bursts:**
  - 0:28.4–0:28.9 and 0:57.1–0:57.6 show no trembling or frame-to-frame jitter. This is a real positive.
  - The 1:25.8 burst is smooth except for the 1:26.0 pop.
  - I can't confirm foot sliding, because the camera moves through most of these shots.

## 3) Camera

- **Good:** the orbiting side-on shot keeps both fighters in frame most of the time, and the depth of field looks broadcast-like.
- **Restless framing:** the angle changes abruptly at 0:32.4→0:32.6, 1:02.6→1:02.8 and 1:51.0→1:51.2. These may be cuts or very fast moves.
- **Crops:** Red's feet leave the bottom of frame at 0:42.2–0:43.0 and 0:52.2–0:52.6. Blue's head goes under the top edge and HUD at 1:26.0.
- **Count coverage:** at 1:30–1:33 the shot is wide, high and dark, with tiny figures. The recovery deserves a closer shot.
- **Replay:**
  - It spends 1:21.0–1:22.2 on two near-static boxers.
  - The reverse angle at 1:22.4 is very dark.
  - The sampled frames don't show the impact.
  - The change out of replay at 1:26.0 is confusing.

## 4) Moments

**5 worst**
1. **1:26.0:** Blue pops from standing to flat in about 0.1 s, with no REPLAY label.
2. **1:10.6:** an abrupt deep lunge with a stretched rear leg, not a boxing move.
3. **1:02.2:** Red's snap crouch and recovery.
4. **1:00.0–1:02.0:** a long glove-pawing stretch at close range, with likely glove and body overlap.
5. **1:21.0–1:22.2:** the replay spends its time on nothing, and I never saw the knockdown punch in any sampled frame.

**3 best**
1. **1:20.0–1:20.8:** a weighty, directional fall onto the back.
2. **1:30.0–1:32.2:** a staged recovery through hands and knees, on the count, with Red backing off.
3. **1:11.0–1:11.2:** Red's duck under Blue's arm, the most boxing-like defensive moment.

## 5) Verdict

The motion is smooth and the knockdown has genuine drama, but the fight still reads as long-arm exchanges against static guards, and a visible fall pop at 1:26.0 hurts the most important sequence. On these sheets this isn't 9/10, and the "every clip, round by round" claim can't be verified from Round 1 alone.

Score: 5.5/10

## 1) Does it look like real boxing?

**Footwork and range: mostly good.**
- Stances are bladed and knees are bent, and the boxers really do shift between range and the inside: mid-range at 0:30–0:33 and 0:50–0:53, close at 0:20–0:22.
- Blue steps out of range at 0:31.0–0:31.4.
- Feet look planted and weighted in nearly every frame.

**Punch selection: thin and jab-heavy.**
- Jabs dominate (0:28.4–0:28.9, 0:40.4, 0:41.2, 1:40.0–1:40.4, 1:42.8).
- Close work and body shots do appear (0:12.0–0:12.4, 1:11.0–1:11.2).
- I can't confidently identify an uppercut in any sheet.
- Work rate is too low for amateur boxing. There are almost no punches in 0:30.0–0:32.8, 0:50.0–0:53.0, 1:12.0–1:13.0 and 1:50.0–1:51.4.

**Defence: present but narrow.**
- The high guard does most of the work, with some ducks (0:11.6–0:11.8, 1:10.6) and some distance (0:31.0).
- The guard is nearly the same on both boxers in every idle stretch.
- Parries are hard to confirm at this frame rate.

**Clinches and breaks: partly work.**
- At 0:57.1–0:57.4 Blue leans in, head down on Red's chest.
- By 0:57.5–0:57.6 Blue's two gloves extend and the boxers separate, which reads as the push-off. It is quick and legible, but Red barely shows being pushed.
- The 1:00–1:01.8 tie-up separates with a jump (see section 2).

**Hits and reactions: uneven.**
- The big hit is strong: Blue's head and arms fly at 1:20.0.
- Ordinary punches often get little response. The jabs at 0:40.4 and 0:41.2 reach Blue's guard or arm and Blue doesn't move. Red's head barely reacts around 0:28.5.
- Damage doesn't carry over. Twenty seconds after the knockdown (1:40–1:43), Blue moves and guards as if fresh.

**After the knockdown: the best-structured passage, with one poor decision.**
- *Downed boxer:* the fall (1:20.0–1:20.8) and the staged rise (1:30.0–1:33.0, kneeling, then crouched, then upright) are convincing.
- *Standing boxer:* Red moves away towards the far side (1:30–1:32.4), which is right, though with gloves held oddly high at 1:30.0–1:31.0.
- *Clock:* it holds at 1:49 from 1:20 through 1:33 and reads 1:44 by 1:40, so it does stop.
- *Count:* it ticks about once a second (3 at 1:30.0, 4 at 1:30.2, 5 at 1:31.2, 6 at 1:32.2) and reads clearly.
- *Problem:* the replay runs from 1:21 to 1:26, and counting back from those ticks, the count seems to start around 1:28. That is about 7 s after Blue hit the canvas.

## 2) Animation defects

- **One-frame pop, 1:26.0:** on the cut back from the replay, Blue is standing with gloves up for one frame. In the next frame Blue is flat on the canvas.
- **Torso flip, 1:51.4→1:51.6:** Blue's chest faces the camera, then the full back does within 0.2 s, then the chest again at 1:51.8. It happens again around 1:52.0–1:52.2. The back-on punch at 0:33.0 looks similar, but the camera is moving there, so that one is less certain.
- **Separation jump, 1:01.8→1:02.0:** the boxers go from tangled to a clear gap, and the ring post and framing jump too. It is either a hard cut or a snap, and the sheet can't settle which.
- **Fast level change, 1:10.4→1:10.8:** Blue drops into a deep lunge and comes back up within about 0.4 s. The rear boot lies side-on at 1:10.6–1:10.8, and a boot kicks up at 0:11.8.
- **Overlaps:**
  - Red's chin and Blue's head appear to merge at 0:57.1–0:57.4.
  - Red's head is buried in Blue's torso at 0:12.0–0:12.2 and 1:11.2.
  - The legs interleave at 1:00.6–1:01.8.
  - The camera angle stops me confirming a true pass-through in any of these.
- **Idle rear hand:** during jabs the non-punching glove falls to the chest (0:28.7, 0:41.2, 1:40.4), which looks the same each time. Red's right hand also stays parked high and unused all through 0:57.1–0:57.4.
- **Sudden guard drops:** both boxers drop their hands with no clear reason at 1:52.8–1:53.0.
- **Stiff fall:** at 1:20.2–1:20.6 the body pivots around boots that stay close together, a little like a toppling figure, and the boots stack at 1:20.6.
- **Tight sheets:**
  - 0:28.4–0:28.9 is clean, with no tremble or jitter, and the jab's speed looks believable.
  - 0:57.1–0:57.6 also shows no tremble.
  - 1:25.8–1:26.0 is almost static until the cut.
- **Sliding:** I see no obvious foot sliding, but 0.2 s sampling can hide it.

## 3) Camera

- **Live coverage:** the camera follows the boxers well, and the orbiting angles give variety (0:10, 0:50, 1:10).
- **Feet cropped by the frame edge:** 0:31.4, 0:42.6, 0:52.2–0:52.6, 1:41.4.
- **Red's back blocks the view:** Blue is largely hidden at 1:00.0–1:00.4, and the action is hard to read.
- **Cut mid-action:** 1:42.4→1:42.6 changes angle in the middle of an exchange.
- **Replay timing:** it cuts in at 1:21.0, about 0.2 s after Blue lands, so the viewer gets no moment on the live knockdown. Its opening seconds show mostly guards (1:21.0–1:22.4).
- **Panels hiding action:** Red is partly or mostly behind the left panel at 1:31.6–1:33.0, and the right panel crowds Red at 1:25.8–1:26.3.
- **Count coverage:** the shot is very wide, so the boxers are small. That helps show the geography but costs drama.
- **Pre-bell shot:** 0:00.4–0:03.0 pushes both boxers to the frame edges around an empty ring.

## 4) Worst and best moments

**Worst 5**
1. **1:26.0:** Blue flashes upright for one frame, then is on the floor.
2. **1:21.0:** the replay cuts off the knockdown at once, and the count seems not to start until around 1:28.
3. **1:51.6:** Blue's torso flips back-on and returns within 0.4 s.
4. **1:40.0–1:43.0:** Blue shows no visible effect from being dropped about 20 s earlier.
5. **1:02.0:** the clinch ends in a jump, with the boxers and framing both shifting at once.

**Best 3**
1. **1:10.2–1:11.4:** the best exchange: jabs, a deep duck, a body shot and a separation, with real give and take.
2. **1:20.0–1:20.8:** the knockdown has real weight, with head and arms thrown and a flat landing.
3. **1:30.0–1:33.0:** Blue's staged rise against the clear count, with Red moving away. This is where the no-referee design works best.

## 5) Verdict

This now reads as boxing, with solid stances, a smooth jab and a well-staged knockdown sequence. It isn't 9/10: reactions to ordinary punches are weak, there are too many idle stretches, damage doesn't carry over, and the knockdown's editing and a few visible pops keep it short of broadcast quality.

Score: 6/10

## 1) Does it look like real boxing?

**Footwork and range: partly.**
- The stances are believable, and the fighters circle: they have swapped sides of the frame by 0:50.
- Range does change, from long at 0:30–0:32 to inside at 0:20.6–0:21.8 and 1:00–1:01.8.
- Punches often come without a step. At 0:40.2–0:41.4 Red throws several long arm punches with the feet almost unchanged. They stop at or short of Blue's guard.

**Punch selection: decent variety, uneven tempo.**
- I can see jabs and straights (0:33.0, 0:40.4, 1:40.0), inside work (0:20.2–0:21.8) and a deep level-change body shot (1:10.6).
- Tempo is uneven. 0:50.0–0:53.0 has no punch at all, and 0:30.0–0:32.8 has none until Blue's jab at 0:33.0.
- The round opens with an exchange already running at about 2:59 on the clock (0:10.0–0:10.6), with no feeling-out in the frames shown.

**Defence: the best-improved area, but mistimed at times.**
- Glove blocks read well at 1:40.0–1:40.4, and Blue leans away at 1:40.6–1:40.8.
- Red's dip at 0:32.6–0:32.8 comes before Blue's jab and is already over at 0:33.0, so it looks like a slip with no punch to slip.
- Exchanges often collapse into gloves resting on gloves (0:21.0–0:21.8, 0:56.3–0:56.4).

**Clinches: no full clinch is visible.**
- The closest moments are 1:00.0–1:01.8 and 1:11.0–1:11.2, and neither shows a clear wrap.
- The boxers are simply apart by 1:02.0 and 1:11.4. No push-off is visible in the sampled frames, so I can't judge how well that mechanic works.

**Hits and reactions: strong on big shots, weak on inside work.**
- The body-fold reactions are large and clear (0:12.0–0:12.2, 0:56.0–0:56.1, 1:11.0), but they recover far too fast.
- Inside, Red's glove sits at Blue's head and neck at 1:01.0–1:01.6 with almost no head movement, while the overlay shows hit labels.

**After the knockdown: the structure works, but the presentation doesn't.**
- *Downed boxer:* Blue falls at 1:20.0–1:20.8. By 1:30.0, at count 3, Blue is already crouched, then rises by 1:32.2 and stands with hands low at count 6.
- *Standing boxer:* Red stands still in guard at 1:20.4–1:20.8. Red is walking away toward the left of frame at 1:30–1:32, which is the right idea, but keeps a stiff fighting guard the whole way.
- *Clock:* it reads 1:49 from 1:20 through 1:33 and 1:44 at 1:40, so it holds during the count and restarts at about 1:35.
- *Count:* it ticks steadily at one per second (4 at 1:30.2, 5 at 1:31.2, 6 at 1:32.2). Counting back puts count 1 at around 1:27, about 6 seconds after Blue landed. I can't see the 1:24.5–1:30 stretch, so that is an estimate.
- *Aftermath:* at 1:40–1:43 Blue moves at the same rhythm as before, with no visible sign of having been floored.

## 2) Animation defects

- **Snap recoveries, the main defect:**
  - 0:56.1→0:56.2: Red is folded almost 90°, then upright within about 2–3 consecutive frames. The fold takes longer than the recovery.
  - 0:12.2→0:12.4: Red goes from head at Blue's waist to fully upright inside one 0.2 s step.
  - 1:10.6→1:10.8: Blue goes from a deep lunge, rear knee near the canvas, to upright in one step.
- **Repeated move:** the same deep forward fold appears at 0:12.0, 0:56.1 and 1:11.0, and it reads as a stock reaction.
- **Intersection:**
  - At 0:56.1 Red's head and arms vanish into Blue's forearm and chest area.
  - At 1:11.2 the two heads and shoulders merge.
  - At 0:56.3–0:56.4 gloves overlap.
  - At 1:00.4–1:01.6 the view is too crowded to separate gloves from heads.
- **Contact without reaction:** 1:01.0–1:01.6, as above.
- **Trembling and jitter:** none in the tight sheets at 0:27.8–0:28.3 or 1:24.0–1:24.5, where motion is smooth. The 0:55.9–0:56.4 sheet is also free of jitter, though it holds the snap above.
- **Foot sliding or floating:** not proven. Blue's rear boot looks tilted at 0:27.8–0:27.9 and 0:41.0, but I can't separate that from perspective.
- **Stiffness:** both boxers hold nearly the same high guard through the quiet stretches (0:50–0:53, 1:41–1:42.4), which looks posed. Blue's legs stay fairly rigid during the fall at 1:20.2–1:20.4.
- **Speed:** normal movement looks about right. The large posture changes in the fold and lunge recoveries are too fast for human bodies.

## 3) Camera

- **Good:** the low, side-on shots with a blurred crowd at 0:10–0:13 and 1:10–1:13 look like real broadcast coverage.
- **Sudden jumps:** the view shifts abruptly at 1:01.8→1:02.0 (the corner post jumps across the frame) and 1:42.4→1:42.6 (a different corner and framing, mid-action).
- **Knockdown cut:** the cut to REPLAY at 1:21.0 comes only about 0.4 s after Blue lands.
- **Replay angles:** the replay spends 1:21.0–1:22.4 on two boxers doing nothing. The overhead angle at 1:24.0–1:24.5 shows Blue reeling with a clear gap to Red, so the contact is not shown in the sampled frames.
- **Blocked or cropped view:**
  - The left body-map panel hides Red at 1:31.6–1:33.0.
  - Boots are cropped by the bottom edge at 0:10.0, 0:52.4–0:53.0 and 1:41.6–1:42.4.
  - The 1:30–1:33 count shot is wide, and the boxers are small in it.
- **Opening shot:** 0:00.4–0:03.0 is a high, letterboxed corner-to-corner shot, with Red pushed against the left edge beside a cornerman.

## 4) Worst and best moments

**5 worst**
1. **1:21.0–1:24.5:** the replay takes over straight after the knockdown, hides the count, and doesn't show the punch landing in the sampled frames.
2. **0:56.0–0:56.2:** Red folds into Blue's arm and snaps upright almost instantly.
3. **0:12.2–0:12.4:** Red makes a full recovery from a deep fold in a single 0.2 s step.
4. **1:01.0–1:01.6:** a glove sits on Blue's head with no visible reaction, in a tangled inside exchange.
5. **1:42.4–1:42.6:** a jarring view change in the middle of the action.

**3 best**
1. **1:20.0–1:20.8:** the knockdown is sudden and heavy, with arms flung out and a convincing drop to the canvas.
2. **1:10.2–1:11.4:** a real exchange of jabs, a level-change body shot and a visible fold, marred only by the fast recoveries.
3. **1:30.0–1:33.0:** Red walks off, Blue climbs up, the count ticks evenly and the clock holds, so the story is clear without a referee.

## 5) Verdict

This is a credible, often watchable boxing broadcast, but it is not at 9/10: snap recoveries, repeated folds, weak inside contact and a replay that hides the knockdown's key moments all hold it back.

Score: 6/10

## 1) Does it look like real boxing?

**Footwork and range: mostly yes.**
- Both boxers keep a bladed stance and change range: long at 0:30–0:33, 0:50–0:53 and 1:12–1:13, and in the pocket at 0:20–0:22 and 1:00–1:02.
- Weaknesses are stances that narrow until the feet line up (Blue 0:31.2–0:31.6) and little visible circling or angle-taking inside the bursts.
- Boxers do swap sides of the screen between bursts (0:40 vs 0:50). I can't tell whether that is ring movement or the camera.

**Punch selection: decent variety.**
- I can see jabs (0:28.4, 1:40.0), a jab-and-rear-hand sequence (0:40.2–0:41.4), and body attacks with level changes (0:12.0–0:12.4, 1:10.6, 1:11.0).
- Several long punches stop well short of the target (0:33.0, 0:40.4). That reads as range-finding, but they come with little set-up or feinting.

**Defence: present but stiff.**
- The high guard catches shots (0:21.0–0:21.6, 0:28.6–0:28.9).
- Blue leans back at 0:40.2–0:40.6 and dips at 0:11.8.
- Guards rarely adjust to the incoming punch. Gloves often just meet gloves in mid-air (0:21.4, 1:10.2).

**Clinches: only one candidate.**
- At 0:57.1–0:57.6 Blue is bent into Red's chest, then rises with both gloves out in front as Red moves back. That reads as a plausible push-off and separates smoothly.
- I can't confirm it was a scored clinch rather than a body attack.
- 1:00.2–1:01.8 is a chest-to-chest exchange, but Red's back hides most of it.

**Hits: the gap between ordinary hits and the knockdown is too big.**
- Ordinary hits barely register. At 1:51.6–1:51.8 Blue's jab arrives and a hit marker appears on the left body map, but Red's head and gloves hardly move.
- The knockdown at 1:20.0–1:20.8 is the opposite: a full, convincing collapse. There is not much in between in these samples.

**After the knockdown: the order is wrong, though the parts work.**
- *Standing boxer:* Red stays in guard at 1:20.2–1:20.8 and doesn't follow up. By 1:30–1:32 Red is walking away towards the far side, which is the correct behaviour.
- *Downed boxer:* Blue is on one knee at 1:30.0, stumbles head-first through 1:31.0–1:31.8, and is upright by 1:32.4. This is good.
- *Clock:* it holds at about 1:49 from 1:20 through the replay and the count. It reads about 1:44 at 1:40, so it appears to restart around 1:35. That is correct.
- *Count:* no count is visible at 1:20.6–1:20.8 or during the replay. At 1:30.0 it reads only 3, at about one number per second. So it seems to start about 7 s after Blue lands, and a replay plays before the count. The graphic itself is clear and large.
- *Aftermath:* at 1:40–1:43 and 1:50–1:53 Blue shows no visible damage, with the same stance and guard. Red is not visibly hunting a hurt opponent.

## 2) Animation defects

**Snapping and popping**
- **1:26.0–1:26.1 (worst):** see the replay collapse in section 4. Blue goes from standing to flat in about 2–3 tight frames, which is a real pop.
- **0:32.8→0:33.0:** Blue turns from a three-quarter front view to back-to-camera with the arm fully out, all within 0.2 s. The same over-rotation on the jab recurs at 1:51.6 and 1:52.6.
- **1:52.6→1:52.8:** the fully extended arm is back at the chest within one sample. This is fast, and the sampling is too coarse to call it a definite snap.

**Trembling and jitter: none seen on the tight sheets.**
- 0:28.4–0:28.9, 0:57.1–0:57.6 and 1:25.8–1:26.0 (before the cut) are smooth from frame to frame.
- Planted feet stay planted in 0:28.4–0:28.9.
- This is the clearest technical strength of the film.

**Interpenetration (likely, not provable at this size)**
- Blue's head sinks into Red's chest at 0:57.1–0:57.3.
- Red's head presses into Blue's torso at 0:12.2.
- At 1:11.2 Blue's head disappears behind or into Red's head.
- Feet tangle at 1:00.2 and 1:01.0–1:01.4, where Red's lead foot sits inside Blue's stance.

**Feet**
- The rear foot flicks into the air on the dip at 0:11.8.
- The rear leg collapses nearly to the canvas with the foot flat at 1:10.6, which is too extreme for a body shot.
- Blue's boot stands almost on its toe at 1:11.2.

**Puppet stretches**
- Gloves sit fixed at the face with little head movement at 0:30.0–0:32.8, 0:50.0–0:53.0, 1:12.0–1:13.0 and 1:50.0–1:51.4. Roughly a quarter of the sampled time is two boxers in the same guard pose.
- Red's walk at 1:30.0–1:31.0 keeps a stiff, raised-elbow pose.

**Speed**
- Live punch speed looks right.
- The slowed replay (1:22.6–1:23.0, 1:25.8–1:26.0) is suitably slow.

## 3) Camera

**Good**
- The side-on fight camera shows both boxers and a clean ring, with a gentle drift (0:10–0:13, 0:40–0:43).
- The depth of field looks broadcast-like.

**Problems**
- **1:01.8→1:02.0:** a jump to a new angle. Red flips from a back view to a front view and the corner post shifts, so it looks like a jarring cut.
- **1:42.4→1:42.6:** another abrupt angle change.
- **1:00.2–1:01.8:** Red's back covers the exchange.
- **Cropped feet:** 0:10.0–0:10.4, 0:31.4–0:31.6, 0:52.2–0:53.0 and 1:41.2–1:41.6.
- **1:30–1:33:** the count shot is very wide, so Blue's rise is small on screen. The left body-map panel also covers Red at 1:31.6–1:33.0.
- **1:26.0–1:26.3:** an upside-down overhead view with the head at the bottom of the frame. It is disorienting.
- **1:21.0–1:22.4:** the replay opens with about 1.5 s of two boxers doing nothing.

## 4) Moments

**5 worst**
1. **1:26.0–1:26.1:** cut to overhead. The REPLAY label is gone and Blue is standing again, then pops flat in a blur. It reads as a second knockdown.
2. **1:21.0–~1:29:** the film cuts to replay 0.4 s after the fall, and no count is visible until about 1:27–1:30.
3. **0:33.0:** Blue snaps round to back-to-camera for a jab that lands nowhere near Red.
4. **1:40–1:53:** Blue shows no visible after-effects, and Red shows no urgency to finish.
5. **0:57.1–0:57.3:** Blue's head sinks into Red's chest (similar at 0:12.2, 1:11.2).

**3 best**
1. **1:20.0–1:20.8:** Blue's arms fly, the legs go, and the body falls flat. It has real weight, and Red correctly holds position.
2. **1:30.0–1:32.4:** Blue's stumbling rise from the knee during the count feels human, and Red moves away.
3. **0:11.8–0:12.4:** a slip, then a level change to the body, with both boxers working. This is the closest thing to real exchange rhythm, and the 0:28.4–0:28.9 jab is similarly clean.

## 5) Verdict

This is a smooth, jitter-free and often believable bout with a superb knockdown fall, but it is not at 9/10: the knockdown sequence's replay and count order, the 1:26 pop, flat ordinary hit reactions and stiff idle stretches all hold it back.

Score: 6.5/10

## 1) Does it look like real boxing?

**Footwork and range**
- There are two modes and little in between. One is close-range exchanges (0:10–0:13, 0:20–0:22, 1:00–1:02, 1:10–1:11). The other is standing off at distance (0:30–0:32.8, 0:41.6–0:43, 0:50–0:53, 1:50–1:53).
- In the stand-offs, stances shift and the gap changes slightly (0:31.2–0:31.4, Blue), but nobody cuts off the ring, circles with purpose or feints.
- Stances often narrow until the feet are nearly in line (Blue 0:31.4, 0:42.4–0:43.0).

**Punch selection**
- Straight punches dominate: 0:10.2, 0:29.0, 0:33.0, 0:40.4, 0:40.8–0:41.2, 1:10.2, 1:11.8, 1:42.4.
- The best variety is at 1:10.6, where Blue lunges low into the body, and 0:12.0–0:12.2, where Red folds at the waist. I saw no clear uppercut. Hooks are hard to confirm at this sampling rate.
- Output is low and lopsided. In 0:40–0:41.4 Red throws repeatedly and Blue never answers.

**Defence**
- It is mostly a high guard held still. Blue's gloves absorb punches at 0:40.8–0:41.2 with very little give, and the head doesn't move.
- There are some real level changes (0:11.6–0:11.8, 1:11.0–1:11.2).
- At 0:29.1–0:29.2 Red drops both gloves to belt height, head down and at close range, and Blue does not punish it. It looks like a recovery pose, not a defensive choice.

**Clinches**
- The only one I can see is 1:00.0–1:01.8, chest to chest with legs interleaved. Even there, the arms don't clearly tie up. It reads more as two bodies pressed together.
- The break is not readable. They are overlapped at 1:01.8 and apart at 1:02.0, and the camera moves in the same interval. I can't see a push-off in the sampled frames, so the "boxers break it themselves" idea doesn't register here. The separation only widens from 1:02.4 to 1:03.0.

**Hits and reactions**
- The best reactions are Red's body fold (0:12.0–0:12.2) and the knockdown fall (1:20.0–1:20.6).
- Ordinary shots often produce no visible reaction: 0:10.6, 0:20.2, 0:41.0–0:41.2.
- The knockdown punch itself is not visible in anything I was given. At 1:20.0 Blue is already arching back, and Red's guard is already up.

**After the knockdown**
- *Standing boxer:* Red stands still through the fall (1:20.0–1:21.2), then walks around the middle of the ring (1:31.2–1:33.0). Not rushing in is correct. However, it looks like idle pacing, not a boxer going to a corner, and they stand close during the fall.
- *Downed boxer:* Blue lies spread-eagled and motionless (1:30.0–1:31.0), then goes from flat to crouched in about 0.4 s (1:31.2–1:31.6). That is too quick for someone just floored.
- *Clock and count:* The clock holds at about 1:49 from 1:20 to at least 1:33, then resumes, which is clear. The count runs at a believable pace once it starts: 2 at 1:30.2, 3 at 1:31.2, 4 at 1:32.2. But it only shows "1" at 1:30.0, about 9 s after Blue landed. No number appears at 1:27.4–1:27.9.
- I can't see the end of the count or the restart. By 1:40 they are boxing again, and Blue shows no visible after-effect at 1:40–1:53.

## 2) Animation defects

- **Snapping:**
  - Red goes from fully folded at 0:12.2 to nearly upright at 0:12.4.
  - Blue goes from a near-kneeling lunge at 1:10.6 to upright at 1:10.8.
  - Red drops from an extended arm to both gloves at the belt within about 0.1 s (0:29.1).
- **Trembling and jitter:** None seen. 0:58.2–0:58.7 is calm, with small natural sway and planted feet. 0:29.0–0:29.5 and 1:27.4–1:27.9 are also free of jitter. This is a clear strength.
- **Foot sliding:** None on the tight sheets. The other sheets are too coarse to clear it either way.
- **Floating or sinking:** No clear case. Blue's foot lifts high at 0:11.8 and 1:10.6, but this reads as part of the motion.
- **Clipping:** Possible glove-on-face or head-on-head overlap at 1:01.6 and 1:11.2, and Red's head goes into Blue's torso at 0:12.2. At this size I can't confirm actual penetration.
- **Contact without reaction:** See 0:40.8–0:41.2 and 0:20.2 above. In the first, Blue's guard takes the punches like a wall.
- **Reach:** Blue's straight at 0:33.0 ends just short of Red's guard, and Red's at 0:40.4 is out of range. These read as misses, but nothing marks them as feints or range-finders.
- **Puppet-like stretches:** Stand-offs at 0:50–0:53 and 1:50–1:53 use nearly the same guard pose on both boxers. The motion is alive, but the fight has stopped.
- **Ragdoll overshoot:** After Blue is already flat (1:20.6), the legs fling up, with a boot near vertical at 1:20.8–1:21.0, then drop back at 1:21.2. It looks like a physics bounce.
- **Speed:** Punches and stand-offs look about right for amateurs, apart from the snaps above.

## 3) Camera

- The mid-range ringside framing is mostly good and both boxers stay readable (0:10–0:13, 0:20–0:23, 1:10–1:13).
- Boots get cropped at the bottom of frame (0:50.2, 0:52.6, 0:58.2).
- The wide framing at 1:40–1:43 is too far out, so contact can't be read.
- 1:00.0–1:00.6 has Red's back to the camera, which hides the inside work.
- **The body-map panels cover the action:** Blue's head is behind the left panel at 1:02.8–1:03.0, and Blue is at the right panel's edge during the get-up (1:31.6–1:33.0).
- **The knockdown coverage is badly directed:**
  - The live fall is held for only about a second before a cut to REPLAY at 1:21.4.
  - The replay opens with both boxers just standing (1:21.4–1:23.0), so it starts too early.
  - The overhead shot at 1:30.0–1:31.0 is striking, but it shows Blue upside down.
  - At 1:31.2 the cut to wide follows Red, with the count digit sitting on Red (1:31.6–1:33.0), while Blue, the actual story, is left at the frame edge.

## 4) Worst and best moments

**5 worst**
1. **1:21.4–1:30.0:** The replay takes over about a second after the fall, and the count only shows "1" about 9 s after Blue landed.
2. **1:31.6–1:33.0:** Camera and count stay on Red while Blue's get-up plays at the frame edge against a panel.
3. **0:50.0–0:53.0:** Three seconds with no punch, no feint and no real movement. 0:30–0:32.8 and 1:50–1:53 are the same.
4. **1:01.8–1:02.0:** The clinch ends between two frames with no readable push-off, and the camera moves at the same moment.
5. **1:20.8–1:21.0:** Blue's legs fling up after landing, a ragdoll bounce at the climax of the fight.

**3 best**
1. **1:10.2–1:11.4:** A real exchange of straights, a low lunge, a level change and a close tangle. This is the most boxing-like passage.
2. **1:20.0–1:20.6:** The backward arc of the knockdown has convincing weight until the legs bounce.
3. **0:11.6–0:12.2:** The level change and Red's fold at the waist give a hit with a real effect.

## 5) Verdict

The motion is stable and free of jitter, and it has moments of genuine boxing. But long dead stand-offs, reaction-free punches, an unreadable clinch break and poorly directed knockdown coverage keep it well short of the 9/10 target.

Score: 5.5/10

## 1) Does it look like real boxing?

**Footwork and range.** Mostly believable. Both men keep a proper bladed stance with their weight between the feet, and they move in and out of range: long range at 0:30–0:33 and 0:41.6–0:43, a pocket exchange at 0:20–0:23, and inside work at 1:00–1:01.4. The weakness is long static standoffs. At 0:30.0–0:32.8, 0:41.6–0:43.0, 0:50.0–0:53.0 and 1:50.0–1:53.0 both stand in a high guard, bob slightly and throw almost nothing. It reads as two boxers waiting for a command.

**Punch selection and variety.** Better than average. I can see:
- jabs: red at 0:29.0 and 0:40.4, blue at 0:33.0 and 1:10.2
- straights: red at 0:41.2 and 1:42.2
- hooks to the body inside: red at 0:12.4, 1:00.0 and 1:11.2
- a lunging lead from blue at 1:10.6

Red is clearly the busier, body-punching pressure fighter, and that gives the fight some character.

**Defence.** Guards are high and many punches end on gloves: 0:40.4 jab into blue's guard, 1:40.2 the same. Red ducks under blue's lunge at 1:10.6–1:11.0 and comes back with a body shot at 1:11.2. That is the best piece of real boxing in the film. I saw no clear slips or parries otherwise. Most defence is "stand there with the gloves up".

**Clinches and breaks.** At 0:12.0–0:12.4, 1:00.4–1:01.4 and 1:11.0–1:11.2, red buries his head in blue's chest with the arms tangled. They are apart again by 0:12.6, 1:01.8 and 1:11.8, but at this sampling rate (5 frames a second) I cannot see a deliberate push-off in any of them. They simply drift apart. Either the push is shorter than 0.2 s or it doesn't read as a push.

**How hits land.** Mixed:
- **Good:** the knockdown sells it. At 1:20.0 blue is already falling backward with his arms flung up and his knees gone, he sits down at 1:20.4–1:20.6, and he goes flat at 1:20.8–1:21.2.
- **Bad:** the 0:29 tight burst. Red goes from a fully extended jab at 0:29.0–0:29.1 to doubled over, both gloves at his stomach, at 0:29.1–0:29.2. Blue's gloves are up at his own face in every one of those frames, so there is no visible punch from blue. It looks like a body-shot reaction with no body shot.

**After the knockdown:**
- **Clock:** reads 1:49 at 1:20 and still 1:49 at 1:30, so it is stopped. Correct.
- **Standing boxer:** red stays right over the downed man in his guard from 1:20.0 to 1:21.2. Only once the count is running, at 1:31.2–1:33.0, does he walk away across the ring towards a far corner. That part is good, but it comes late.
- **Count graphic:** "1" at 1:30.0, "2" from 1:30.2 to 1:31.0, "3" from 1:31.2 to 1:32.0, "4" from 1:32.2. That is about one number per second, and it is clear and readable.
- **The problem:** a replay runs from 1:21.4 to about 1:30, so the count only starts about 9 s after blue went down. A real broadcast counts first and replays afterwards. As it plays, it looks like the count forgot to start.
- **Downed boxer:** a nice, realistic rise. At 1:31.4 he rolls onto his side, from 1:31.6 to 1:33.0 he is on his hands and knees by the ropes, getting up. He is back fighting by 1:40 with no visible damage state.

## 2) Animation defects

- **0:29.1–0:29.2 (tight burst):** the hit reaction fires with no contact, and the change from extended jab to doubled-over crouch takes about 2 frames, which reads as a pop. Red's feet also go from a wide stance to nearly together over the same frames, which looks like a foot slide or snap.
- **1:21.0–1:21.2:** blue lands flat on his back with both legs pointing up in the air, boots higher than his hips. It looks like a ragdoll and slightly comic.
- **1:27.4–1:27.9 (tight replay, overhead):** red reads as lying folded flat on the canvas with his glove beside his head, while blue falls backward. In the live shot at 1:20 red stood upright. It is either a replay pose glitch or extreme overhead foreshortening. The camera angle, plus the left body map covering part of red, leaves it ambiguous.
- **1:30.0–1:31.0:** blue lies spread-eagle and completely frozen for a full second. That is acceptable for a man who is out, but then he snaps from flat on his back (1:31.2) to propped on his side (1:31.4), at a cut, which partly hides it.
- **Possible clipping:**
  - 0:20.6 and 0:21.6: heads and gloves overlap at close range.
  - 1:00.6–1:01.0: red's head goes into blue's left glove and chest.
  - I can't confirm real penetration at this resolution.
- **1:10.6:** blue's lunge goes very low and very long, nearly a split stance. It is overextended and off-balance.
- **Static stretches:** at 0:30–0:32.8 and 1:50–1:53, the guard idle loops look puppet-like.
- **Tight burst at 0:58.2–0:58.7:** smooth. No trembling and no pops, and the feet stay planted.
- **Speed:** punch speed looks right where I can see it. Idle pacing is too slow and too passive.

## 3) Camera

- **Main angle:** a low three-quarter side shot with both boxers in full body and the crowd behind. It works well at 0:10, 0:20, 0:30, 0:40, 1:40 and 1:50.
- **Overhead cuts:** at 0:50.0–0:52.0, 0:58, 1:00–1:03 and 1:10.0–1:10.2 the camera goes high and top-down. The boxers become small and foreshortened, so you lose punch reading.
- **Cuts in mid-exchange:** 0:52.2, 1:02.0 and 1:10.4. The cut at 1:10.4 comes in the middle of blue's jab and red's counter.
- **Cropping:**
  - 0:52.2–0:53.0: blue's body is cropped at the right edge, very close to the lens.
  - 0:58.6–0:58.7: blue's head is cut off by the bottom of the frame.
- **Overlays:** the body maps take roughly a fifth of each side of the frame, and at 1:27.4 the left map covers part of red.
- **Opening:** a menu at 0:00, then a wide establishing shot of both boxers in their corners from 0:00.4 to 0:03.0. That is fine.
- **Replay shots:** the overhead knockdown shot at 1:30 is a good broadcast choice. The replay before the count is not.

## 4) The 5 worst and the 3 best moments

**Worst:**
1. **0:29.1:** red doubles over from a body shot nobody threw, with a 2-frame pop into the crouch.
2. **1:21.4–1:30:** the replay runs before the count starts; the count only begins at 1:30, about 9 s after the knockdown.
3. **1:27.4:** in the replay, red lies folded flat on the canvas, which contradicts the live shot.
4. **1:21.0:** blue lands on his back with his legs up in the air like a ragdoll.
5. **0:50–0:53 and 1:50–1:53:** long, punchless guard standoffs; 0:52.2 adds a badly cropped cut on top.

**Best:**
1. **1:20.0–1:20.6:** the knockdown fall: arms up, knees buckle, he sits, then goes down. Weighty and readable.
2. **1:31.4–1:33.0:** blue rolls over and climbs up by the ropes while red walks away and the count reads 3, 4.
3. **1:10.6–1:11.2:** red ducks blue's lunge and counters to the body. Real boxing logic.

## 5) Verdict

The fighting is believable in shape, and the knockdown fall and the get-up are genuinely good. But it is held back by a reaction with no punch behind it, a replay that pushes the count back about 9 s, a glitchy replay pose, clinches that break with no visible push-off, and long passive standoffs. It is not at the "9/10 everywhere" level this change was aiming for.

Score: 6/10

## 1) Does it look like real boxing?

**Footwork and range.** Range is mostly believable. The fighters work at jab distance and step in and out:
- **0:22.0–0:23.0:** a clean reset to range.
- **0:30.0–0:32.4:** both circle with high guards.
- **0:40.0–0:43.0:** jab range, then they drift apart.

Stances stay bladed and the feet look planted in every sheet. They move forward and back, but I saw almost no lateral footwork or angle changes, so it is mostly linear.

**Punch selection and variety.** There is some variety:
- jabs at 0:22.0, 0:32.8–0:33.0, 0:40.2 and 1:10.0
- hooks at 0:10.2–0:10.4 and 1:40.2
- a crossing exchange at 0:41.0
- a low lunging body shot by blue at 1:10.4
- the knockdown punch, which isn't shown live: at 1:20.0 blue is already falling

Output is low. Long stretches are two high guards and no punches: 0:30.0–0:32.6, 0:41.4–0:43.0, 0:50.0–0:53.0, 0:58.1–0:58.6, 1:11.6–1:13.0 and 1:50.0–1:53.0. Amateur rounds are busier than this.

**Defence.**
- High-guard blocking is the main defence. At 0:22.0 red's jab lands on blue's glove, and at 0:33.0 blue's jab lands on red's guard.
- One deep bob or duck by red at 0:11.8–0:12.0. The waist bend is exaggerated: the head drops to the opponent's belt line.
- Distance defence at 0:40.2: red's jab stops short of blue.
- I saw no clear slips or parries.

**Clinches.** The inside work at 0:20.0–0:21.4 and the clinch at 1:00.0–1:01.2 (chests together, red's head tucked into blue's chest) read as clinches. The break at 1:01.4–1:02.4 is a slow drift apart over about one second. I could not see a distinct push-off in any frame, so the designed push-off break does not come across. It is the same at 1:11.0–1:11.4, which ends with a step-back rather than a push.

**How hits land.** At 0:28.9–0:29.0 red is hunched with his gloves at his belly, which looks like a body-shot reaction, and he is upright again by 0:29.2. At 1:10.0 red's jab meets blue's face, but I can't see a head snap at 0.2 s spacing. At 0:40.2 red's jab gets no reaction, which is correct because it falls short. Most other contacts fall between frames, so I can't confirm reactions either way.

**Knockdown at about 1:20.**
- **The downed boxer.** Blue goes over backwards at 1:20.0. From 1:20.4 to 1:21.0 his legs flip up vertically, with a boot pointing at the ceiling at 1:20.6. That reads as a ragdoll, not a boxer collapsing. He is splayed and still at 1:30.0–1:30.8, sits up at 1:31.2, is on a knee at 1:31.4–1:32.8 and rising at 1:33.0. That recovery is believable.
- **The standing boxer.** Red stands over blue at 1:20.0–1:21.0, then from 1:31.0 to 1:33.0 he lingers and walks around mid-ring about two body lengths away. He never goes to a neutral corner.
- **The count and the clock.** The live action cuts to a REPLAY at 1:21.2, and the count graphic first appears at 1:30.0, already at "2". It then runs 3 (1:31.0), 4 (1:32.0), 5 (1:33.0), one per second, which is a good pace. But about 9 s of replay sit between the knockdown and the visible count, so the count does not feel live. The round clock appears held at about 1:49 from 1:20 to 1:33, and reads about 1:46 at 1:40. The digits are tiny, so treat those readings as approximate.

## 2) Animation defects

- **Ragdoll legs** (1:20.4–1:21.0): both legs swing straight up on a backward fall. This is the most visible defect in the film.
- **Lunge** (1:10.4): blue's body is almost horizontal and his rear leg is fully stretched, like a fencing lunge. The next frame, 1:10.6, shows his rear foot kicked up.
- **Rear foot lifted** (0:11.4–0:11.6): blue's back foot comes off the floor behind him for no clear reason.
- **Fast recovery** (0:28.9–0:29.2, tight sheet): red goes from fully hunched to upright guard in about 0.3 s. It's quick but readable, not a hard pop.
- **Fall in the replay** (1:27.6–1:27.7, tight sheet): blue goes from sitting to flat with a leg flung out in about 0.1 s, and a boot appears far from the body at 1:27.7. This looks like a pop.
- **Glove into the head** (0:20.0, 0:21.0, 1:00.4): gloves sit on or inside the opponent's face and forearm in close, with no reaction. At this resolution I can't tell clipping from contact.
- **Repetition:** one high-guard idle carries most of the neutral time (the six stretches listed above). It looks the same each time.
- **Trembling and jitter:** none. Both tight sheets (0:28.9 and 0:58.1) are steady, with no shake or popping in the guards.
- **Speed:** normal punches look about right. The knockdown fall looks too fast and floppy.
- **Foot sliding:** I can't judge it from 0.2 s spacing. In the tight sheets the feet look planted.

## 3) Camera

- **Good:** most of the live action is a low side-on shot at about chest height, and both fighters stay full-body in frame (0:10–0:23, 0:30–0:43, 0:50–1:13, 1:50–1:53). It reads well.
- **Too far out:** the 1:40–1:43 shot is wide, so the fighters are small and the punches are hard to read.
- **Possible cut or move** at 0:29.0–0:29.2: the framing changes mid-burst and the ring corner drops out. I can't tell whether it is a cut or a fast pan.
- **The knockdown happens in the live shot,** but the cut to replay at 1:21.2 comes about 1 s after the fall.
- **The replay overhead** (1:27.2–1:27.8) is fine. The straight-down count shot at 1:30.0–1:30.8 is dramatic.
- **Downed boxer at the frame edge** (1:31.0–1:33.0): the wide shot puts blue at the right edge next to the body-map panel, so his get-up is small and partly crowded.
- **Body-map panels:** they cover about 20% of each side throughout, and sometimes overlap the fighters (0:50.0 left side, 1:32.4–1:33.0).

## 4) Moments

**The 5 worst**
1. **1:20.4–1:21.0:** blue's legs flip vertical on the fall, which looks like a ragdoll.
2. **1:21.2–1:30.0:** a replay runs before the count is seen, so the knockdown count first appears at "2", about 10 s late.
3. **1:31.0–1:33.0:** red wanders mid-ring near the downed boxer, and blue gets up small at the frame edge beside the overlay.
4. **1:10.4:** blue's near-horizontal fencing lunge with his rear foot flung up.
5. **1:01.4–1:02.4:** the clinch dissolves by drifting apart, with no visible push-off.

**The 3 best**
1. **0:10.0–0:12.4:** a real exchange of hooks with a duck underneath, at good range.
2. **0:20.0–0:23.0:** inside work, a reset to range and a jab blocked on the glove.
3. **1:30.0–1:33.0:** the overhead count shot and blue's believable sit, knee and rise as the count ticks at a steady one per second.

## 5) Verdict

The fight reads as boxing, with steady guards, sensible range and no jitter. But the knockdown sequence (the ragdoll legs, a count delayed by the replay, the standing boxer loitering) and the long low-output guard stretches keep it well short of the 9/10 this task aims for.

Score: 5.5/10

## 1) Does it look like real boxing?

**Footwork and range.** Both boxers keep a proper staggered stance with the lead foot forward, and the gap between them changes over the round.
- **Close range:** 0:10–0:13, 0:20–0:23 and 1:00–1:02 are fought chest to chest.
- **Mid range:** 0:30–0:33, 0:50–0:53, 0:58 and 1:50–1:53 sit at jab distance.
- **Real footwork:** blue lunges deep onto the back leg at 1:10.6, and red ducks low at 1:11.0. These are the only clear moments of footwork.
- **Too static:** for most of the round the feet stay planted and the boxers just turn on the spot. I saw no circling, no cutting off the ring and no pivots.

**Punch selection and variety.** This is better than a jab-only loop.
- Red throws a jab at 0:29.0, then drops level into a body-height dip at 0:29.1–0:29.2 and comes back up by 0:29.4. That looks like a real jab-to-body sequence.
- Red throws extended straights at 0:40.4 and 0:41.2.
- Blue throws a long straight at 0:33.0.
- Both throw at once at 1:10.2, and red jabs again at 1:11.8 and 1:42.0–1:42.6.
- I never clearly see a hook or an uppercut. The arms mostly travel straight.

**Defence.** Defence is almost all a high guard: blue is shell-guarded at 0:29.0–0:29.5 and 0:40–0:43.
- **Slips and ducks:** red ducks under at 0:12.0 and 1:11.0, and dips at 0:29.1. That's all.
- **Distance defence:** there is barely any stepping back to make a punch miss.
- **Guard-on-guard stretches:** at 0:20–0:23 the gloves press against each other with no clear punch thrown, which reads as a stalemate rather than defending.

**Clinches and how they break.**
- **0:12.0–0:12.2:** red drives his head into blue's chest, and blue's glove drapes over red's back. By 0:12.4 they are apart. The break takes less than 0.2 s and I see no push-off.
- **1:00.0–1:01.8:** a real chest-to-chest clinch, but red's back is to the camera. At 1:02.0 they are suddenly at short range and the camera angle has changed (the ring post jumps). The break happens on a camera cut, so **the push-off itself is never seen.** I can't confirm it works.

**How hits land and what they do to the receiver.**
- Most clean shots produce almost no reaction. At 0:41.2 red's right arrives at blue's head, and blue's head and shoulders don't visibly move on the next frames. The guard just absorbs everything.
- The knockdown is the big exception. At 1:20.0 blue is reeling backwards with one arm flung up, he is going down at 1:20.2, sitting at 1:20.4 and flat on his back at 1:20.6. That is a clear, readable fall.
- I never see the punch that caused it: the 1:10 burst ends at 1:13.0, and the 1:20 burst opens with blue already reeling.

**After the knockdown: the standing boxer.** Red stays within a step of blue's legs at 1:20.6–1:21.2. In the replay at 1:27.4–1:27.9 he is standing almost over him. During the count (1:31.2–1:33.0) he wanders around mid-ring with his guard up. He doesn't go to a neutral corner, which a fan will notice even without a referee.

**After the knockdown: the downed boxer.** Blue lies spread-eagled at 1:30.0–1:31.0. He is still down at 1:31.2–1:32.0, starts rising onto a knee at 1:32.4–1:33.0, and the fight has resumed by 1:40.0. That's a believable struggle to get up.

**After the knockdown: the count and the clock.**
- **The count is late.** It doesn't start until 1:30.0, about 9.4 s after blue hits the floor at 1:20.6. The replay (1:21.4 to about 1:29) plays first. In real boxing the count starts at once, so this is the weakest part of the knockdown sequence.
- **The count's own speed is fine.** "2" shows from 1:30.2 to 1:31.0, "3" from 1:31.2 to 1:32.0, and "4" from 1:32.2. That's about one number per second. "1" turns into "2" within 0.2 s of the count starting, so the first number may be cut short.
- **The clock stops.** The match clock appears to hold at about 1:49 through the knockdown and replay. It reads 1:46–1:44 by 1:40, so it holds and then runs on. That is acceptable.

## 2) Animation defects

- **Leg flip on landing (1:20.8–1:21.0):** once blue is flat on his back, both legs swing straight up into the air and drop again (they are down by 1:21.2). It looks like a ragdoll bounce. It's the most noticeable defect.
- **Fall speed (1:20.2–1:20.4):** blue goes from staggering to seated in about 0.2 s, which is fast but not impossible.
- **Possible pop at the clinch break (0:12.2 → 0:12.4):** red goes from head-on-chest back to normal range in at most 0.2 s.
- **Clinch break hidden by a cut (1:01.8 → 1:02.0):** a position jump may be hidden by the camera cut.
- **Possible interpenetration, not confirmed:**
  - 1:00.2–1:00.6: red's head and shoulder appear merged into blue's chest.
  - 1:11.2: the two heads overlap.
  - 0:21.6: red's glove sits on blue's face.
  The camera angle can't separate depth in any of these.
- **Contact without a reaction:** at 0:40.8–0:41.4 and 0:41.2, red's extended arms reach blue's guard or head and blue doesn't move.
- **Trembling and jitter:** none visible on the three tight sheets.
  - **0:29.0–0:29.5:** red moves smoothly through the jab and dip. Blue's guard and feet are rock steady.
  - **0:58.2–0:58.7:** only a gentle idle bob.
  - **1:27.4–1:27.9:** a smooth replay pan.
- **Foot sliding, floating or sinking:** I can't see any, but 0.2 s sampling is too coarse to rule out sliding.
- **Same move repeated / puppet-like stretches:** these are three near-identical guard-idle stretches with no punches thrown in the whole sample:
  - 0:50.0–0:53.0
  - 0:58.2–0:58.7
  - 1:50.0–1:53.0

  Both boxers hold the same stance, gloves at the cheeks, and bob slightly. It reads as passive and a little puppet-like.
- **Speed:** punch speed looks plausible for amateurs where I can see it. The walk-in and round start at 0:00.4–0:03.0 are too far away to judge.

## 3) Camera

- **Framing:** the main side-on camera at roughly head height frames both boxers well (0:10, 0:20, 0:40, 1:10). The slow orbit during the round helps.
- **Too wide:** at 1:40–1:43 the camera pulls back so far that the boxers are small and the punches hard to read. The corner shots at 0:00.4–0:03.0 are wider still.
- **Cuts:**
  - **1:21.4, replay cut:** well placed, and the "REPLAY" tag is clear.
  - **1:30.0, close-up of the downed boxer:** a strong shot.
  - **1:31.2, wide shot during the count:** good, because it shows both boxers.
  - **1:02.0, cut mid-clinch-break:** a bad cut, because it hides the break this change is meant to show.
- **Overlays hiding the action:**
  - **1:27.4–1:27.9 (replay):** the right-hand body-map panel covers part of red's torso.
  - **1:30.0–1:31.0:** red's legs at the right edge are cut off by the frame and the panel.
  - **1:30.2–1:31.0:** the "2" sits on blue's thigh.
  - **1:31.2–1:32.0:** the "3" sits on red's head and chest.

  The count numeral is placed on top of the boxers instead of in a fixed corner.
- **Body-map panels in general:** they take up roughly a fifth of each side of the frame. At 0:30.0 and 1:10.6 a boxer's back foot comes close to the panel edge.

## 4) Moments

**5 worst**
1. **1:20.6–1:30.0:** the count only starts 9.4 s after blue goes down, because the replay plays first.
2. **1:20.8–1:21.0:** blue's legs flip straight up after he lands, like a ragdoll.
3. **1:01.8 → 1:02.0:** the clinch break happens on a camera cut, so the push-off is never seen.
4. **0:41.2:** red's straight reaches blue's head and blue shows no reaction.
5. **1:50.0–1:53.0 (also 0:50–0:53):** three seconds of guard-idle with no punch thrown.

**3 best**
1. **1:20.0–1:20.6:** the knockdown fall reads clearly, from the backward stagger to the flung arm to flat on his back.
2. **0:29.0–0:29.5:** red's jab and level-change dip are smooth, look like real boxing and show no jitter.
3. **1:32.4–1:33.0:** blue climbs onto a knee during the count, filmed on a good wide shot.

## 5) Verdict

The knockdown is the highlight, with a readable fall and a working count graphic. Three things undercut it: the count starts about 9 s late after the replay, red doesn't retreat after the knockdown, and both clinch breaks are either too fast or hidden by a cut. Weak hit reactions and long idle stretches keep it below broadcast standard, and it does not look like a 9/10.

Score: 6/10

## 1) Does it look like real boxing?

**Footwork and range**
- Stances are believable: knees bent, staggered feet, weight low (0:27.1–0:27.7, 1:40.0–1:41.2).
- The boxers do change range. Red closes in at 0:40.2–0:41.2. Blue lunges in deep at 1:10.6. They walk back to centre after the restart at 1:31.8–1:33.0.
- Too much of the round is spent at a "staring" distance, half a step beyond jab range, with both guards up and nothing thrown: 0:30.0–0:32.8, 0:50.0–0:53.0, 0:54.5–0:55.0 and 1:40.0–1:41.2. Amateur boxing over 3 rounds is busier than this.

**Punch selection and variety**
- There is real variety:
  - Red jab and straight at 0:40.4 and 0:40.8–0:41.4.
  - Blue long jab at 0:33.0.
  - A level change and lunge by blue at 1:10.6.
  - Red low shot to the body at 1:11.0.
  - Close-range hooking exchanges at 0:20.2–0:21.6 and 1:11.0–1:11.2.
  - Red ducks under to the body at 0:12.0–0:12.2.
- I saw no clear uppercut.
- Combinations are hard to confirm at 0.2 s sampling.

**Defence**
- High-guard blocking dominates; gloves are almost never away from the face.
- A slip or level change happens at 0:12.0 (red goes under) and 1:10.6 (blue drops).
- I could not confirm a clean slip-and-counter.
- Distance is used as defence, but passively. Nobody pivots or circles away in the sampled windows.

**Clinches and how they break**
- 1:00.0–1:01.2 is a proper clinch. Red's head is on blue's chest, red's arms are wrapped round blue at 1:00.6, and blue's gloves are on red's head.
- The break at 1:01.4–1:02.6 is a gradual drift apart, not a visible push-off. Real boxers shove off, so it reads as a soft dissolve.
- 0:12.0–0:12.2 (red's head down against blue's chest, blue's glove on his back) breaks quickly by 0:12.4.

**How hits land**
- Red's straight at 0:41.0–0:41.2 reaches blue's guard or face, but I can't see a clear head snap on blue.
- The knockdown blow itself is not in the footage; the sheet opens at 1:20.0 with blue already reeling.
- The fall is good. At 1:20.0 blue's head turns away and one arm flies up. His knees go at 1:20.2, he drops to his seat at 1:20.4 and lands flat on his back at 1:20.6. It has weight and sequence.

**After the knockdown** (this is what the change is about)
- **Standing boxer:** red stays in guard while blue falls (1:20.0–1:20.6), which is right. After the cut, red ends up standing right over the downed man, then crouching over his legs from 1:21.6 to 1:22.4. Only from 1:22.6 to 1:23.0 does red straighten up, guard raised, and walk away left. With no referee, the standing boxer should go to a neutral corner at once. Here he lingers over the body for about 2 s first.
- **The count:** "1" appears at 1:22.0, about 1.4 s after blue lands at 1:20.6. "2" appears at 1:23.0, so the pace is about 1 s per number, which is right. The graphic is big, centred and readable. The 1.4 s gap before "1" feels slow.
- **Downed boxer:** blue lies still on his back from 1:20.6 to 1:23.0. He gets up off-camera; the next view (1:30.0) already has both standing apart. The rise and stand-up are never shown, which costs drama.
- **Clock:** it reads 1:49 from the knockdown through 1:30.0, then 1:48 at 1:30.8 and 1:47 at 1:31.6. It stops during the count and restarts on "BOX!", which is correct.
- **Restart:** "BOX!" at 1:30.0–1:30.6 with the boxers in opposite areas, then they meet in centre by 1:32.2. It's clean and readable.

## 2) Animation defects

- **Clipping or stumbling over the downed boxer, 1:21.6–1:22.4:**
  - Red is in a deep, awkward crouch with his feet among blue's legs. At 1:22.2–1:22.4 in the tight sheet, red's feet and shins sit on top of blue's lower legs.
  - It looks like interpenetration, or at best a nonsense pose: neither a walk nor a corner retreat.
  - Between 1:22.0 and 1:22.1 in the tight sheet, red's rear foot shifts position, which looks like a small slide.
  - The right body-map overlay hides red's torso here, so I can't fully confirm the clipping.
- **Bodies overlapping, 1:41.4–1:41.6:** blue steps so far in that his torso covers red's. It may only be depth, with blue nearer the camera. I can't rule out overlap.
- **Clinch, 1:00.4–1:00.6:** red's head and shoulder are pressed into blue's chest. It is plausible contact, with no obvious sinking.
- **Jitter and popping:** the two neutral tight sheets (0:27.1–0:27.7 and 0:54.5–0:55.0) are clean. Small, continuous guard bob and weight shifts, no trembling, no snapping, feet planted. That's a good sign.
- **Repetition and stiffness:** the "both in high guard, small bounce" idle covers most of 0:27–0:33, 0:50–0:55 and 1:40–1:41. It's smooth but samey; it reads as a holding pattern, not stalking.
- **No visible reaction:** after the straight at 0:41.0–0:41.2, blue's head barely moves, so contact looks unpunished. With 0.2 s sampling the snap might fall between frames.
- I saw no floating feet in the sampled frames.

## 3) Camera

- **Cuts:** the angle changes often between sheets: low side angle at 0:10, wide at 0:27, a reverse that swaps the boxers' sides at 0:50, another angle at 1:00. The reverse at 0:50 crosses the 180° line, so red and blue swap screen sides, which is disorienting.
- **Knockdown cut at 1:20.8:** it moves from a good mid shot to a low wide angle from across the ring. Red's legs fill the foreground and the downed fighter shrinks. It's a weaker framing than 1:20.0–1:20.6, which was ideal.
- **Overlays blocking the view:**
  - At 1:20.8–1:22.4 the right body map sits right over red and the downed blue.
  - At 1:30.4–1:31.4 blue is half hidden behind the right body map and the frame edge during "BOX!".
  - The body maps take up about a fifth of the frame on each side all fight.
- **Restart shot at 1:30.0–1:31.4:** very wide, with blue pushed against the right edge.

## 4) Worst and best moments

**5 worst**
1. **1:21.6–1:22.4:** red crouches over the downed boxer's legs, apparently clipping through them, instead of heading for a corner.
2. **1:20.8–1:22.4:** the knockdown cut puts the right body map over red and blue, so the key moment is hidden.
3. **1:30.4–1:31.4:** at "BOX!", blue is half off-frame behind the overlay.
4. **0:50.0–0:55.0:** about 5 s of mirrored high-guard idling with no punch thrown, plus a camera reverse that swaps sides.
5. **1:01.4–1:02.6:** the clinch drifts apart with no visible push-off.

**3 best**
1. **1:20.0–1:20.6:** the knockdown fall: head turns, knees go, he drops to his seat and lands flat. Weighty and believable.
2. **1:10.2–1:11.2:** a real exchange: jab, blue's deep level-change lunge, red's body shot, heads together.
3. **1:22.0–1:23.0 with 1:30.0:** the count graphic is clear at about 1 s per number, the clock is stopped at 1:49, and "BOX!" restarts it.

## 5) Verdict

The knockdown fall, the count graphic, the stopped clock and the restart now work. The aftermath doesn't: the standing boxer hovers over (and seems to clip into) the downed man, the overlays hide that moment, and the get-up is never shown. Outside the knockdown, too much of the round is guard-up idling.

Score: 6/10

## 1) Does it look like real boxing?

**Footwork and range.** Both boxers hold a proper stance with their weight over the balls of their feet. Range changes look believable: they work at long range (0:30.0–0:33.0, 0:40.0–0:41.4), then step in to mid range (0:10.0–0:11.4, 0:20.0–0:21.4, 1:40.0–1:43.0). The problem is how much of the time is spent standing still with gloves up at long range. 0:30.0–0:32.4, 0:41.6–0:43.0, 0:50.0–0:52.0, 0:52.4–0:53.0, 1:12.0–1:13.0 and 1:50.0–1:53.0 are full seconds of both men in a high guard with only small shuffles and no feints. That reads as "waiting for the AI", not two boxers working.

**Punch selection.**
- There is real variety: red's jab (0:10.2, 0:29.0, 0:40.4), red's long straight (0:40.8–0:41.4), what reads as a left hook from blue (0:10.6), body shots (red ducking in at 0:12.0–0:12.2, blue's deep body jab at 1:10.6), and short work on the inside (1:00.0–1:01.4).
- Combinations are rare. Most exchanges are one or two punches and then a reset.
- Blue's body jab at 1:10.6 sinks into a lunge with the rear knee nearly on the canvas. That is too deep for an amateur and looks like a pose taken to its limit.

**Defence.** The high guard is constant and correct. There is a real duck from red at 0:32.6 and a head roll or slip from blue at 0:58.5–0:58.7. There is little catching-and-countering and almost no lateral slipping. Defence is mostly "stand there with gloves up".

**Clinches and breaks.**
- The closest thing to a clinch is 1:00.0–1:01.4, where red has his head buried in blue's chest and both work short punches. The break at 1:01.6–1:03.0 happens by walking apart. I can't see a clear push-off in these frames.
- 0:12.0–0:12.2 also has red folded into blue's midsection. He comes back out by 0:12.4, with no visible push.
- So I can't confirm that the push-off break works. These frames don't show one.

**How hits land.**
- The 0:29.0 tight sheet is suspicious. Red throws a jab at 0:29.0, then within about 0.1 s (by 0:29.1) he is doubled over with both gloves at his belly, as if he took a body shot. In these frames blue's hands stay high and I see no blue body punch. That looks like a reaction without contact, or at best a snap into a duck.
- The exchanges at 0:10–0:13 and 0:20–0:22 show gloves reaching heads but little visible head snap on the receiver.

**Knockdown.**
- Blue is already falling at 1:20.0; the punch landed before this sheet starts. He goes from arms flung up (1:20.0) to sitting (1:20.6) to legs thrown in the air with boot soles to the camera (1:21.0–1:21.2). It is dramatic, but the legs flip like a ragdoll, which is more than a real amateur knockdown.
- **Standing boxer:** red stands in guard exactly where he was, facing out (1:20.0–1:21.2). At 1:31.2–1:33.0 he is still near the middle of the ring in guard, not backing off to a neutral corner. Without a referee, he should at least turn and walk away, and he doesn't.
- **Clock and count:**
  - At 1:21.4 the film cuts to a REPLAY, which is still running at 1:27.9.
  - No count graphic appears in any frame from 1:20.0–1:23.0 or 1:27.4–1:27.9.
  - The count first shows at 1:30.0 as "1", then "2" (1:30.2–1:31.0), "3" (1:31.2–1:32.0) and "4" (1:32.2–1:33.0).
  - So the count starts about 10 s after the fall. For a fan that breaks the drama: the count must run live, and the replay belongs after the boxer is up.
- **Downed boxer:** at 1:30.0–1:31.0 blue lies spread-eagled on his back, with no movement over a full second (frozen). At 1:31.2 he lies on his side, and by 1:31.6 he is already sitting or kneeling up. That is a very fast jump from flat to sitting, probably a pop, and the shot change partly hides it.
- By 1:40.0 the fight has resumed with normal exchanges.

## 2) Animation defects

- **Snap or pop:** 0:29.0 to 0:29.1. Red goes from a fully extended jab to doubled over in about 3 frames (tight sheet).
- **Reaction without contact:** 0:29.1–0:29.2. Red flinches as if hit to the body, with no visible punch from blue.
- **Pop:** 1:31.2 to 1:31.6. Blue goes from lying flat to sitting or kneeling up in under half a second.
- **Possible interpenetration (resolution limited):**
  - At 1:00.4 and 1:11.2 red's head merges into blue's chest and arm.
  - At 0:12.2 red's head is at blue's belly with no visible gap.
  - At 0:21.6 gloves overlap the heads, but the depth there is ambiguous.
- **Odd pose:** at 0:11.8 blue's rear foot kicks high off the canvas behind him during an exchange. It reads as a strange hit reaction or a broken balance pose.
- **Ragdoll overreach:** 1:21.0–1:21.2. Blue's legs fly straight up during the knockdown.
- **Frozen stretch:** 1:30.0–1:31.0. Blue is completely still on his back.
- **Repetition:** the gloves-up guard standoff with small bounces is the same idle loop over and over (0:30, 0:41.6, 0:50, 1:12, 1:50). From the side the two boxers look like they are playing the same idle.
- **Jitter:** the 0:58.2 and 1:27.4 tight sheets are smooth, with no trembling. On the 0:29.0 tight sheet the only problem is the single snap above, not jitter.
- **Foot sliding:** I can't call any clearly at 5 fps. Feet look planted in the side shots (0:20–0:23, 1:50–1:53).
- **Speed:** exchanges look close to real-time. I can't measure finer than that from sheets.

## 3) Camera

- **Good:** the side and three-quarter shots at roughly chest height (0:10–0:13, 0:20–0:23, 0:40–0:43, 1:50–1:53) frame both boxers head to toe. This is the broadcast look and it works.
- **Too high:**
  - 0:50.0–0:52.0 is a high corner view.
  - 0:58.2–1:03.0 is near-overhead, and it crops blue at the bottom of the frame (0:58.2–0:58.7) and red at the bottom-left (1:00.0–1:00.6).
  - That is a game camera, not TV. Live sports doesn't film exchanges from above.
- **Bad cut:** at 0:52.2 the camera jumps to a low close angle where blue is huge at the right edge and his legs are cut off (0:52.4–0:53.0).
- **Mid-exchange cut:** at 1:10.4 the camera cuts from high to side in the middle of a combination.
- **Knockdown framing:**
  - Overhead at 1:30.0–1:31.0: only blue is in frame, and red's boots poke in at the top right under the HUD ring.
  - At 1:31.2 the cut to a wide shot shows both boxers and the count. That shot is good.
- **HUD blocking:**
  - In the replay at 1:27.4–1:27.9, the left body-map panel covers red's head and upper body, so I can't tell what pose red is in. He looks folded low or lying, but the panel hides it.
  - The two body-map panels take about 20% of each side of the frame, and in high shots the boxers drift under them (0:58, 1:00).

## 4) The 5 worst and the 3 best moments

**Worst:**
1. **1:21.4–1:30.0:** a REPLAY runs while a boxer is down and the count first shows "1" at 1:30.0, about 10 s after the fall.
2. **0:29.0–0:29.2:** red snaps into a doubled-over body-shot flinch with no visible punch from blue.
3. **1:31.2–1:31.6:** blue pops from lying flat to sitting up in under half a second, right after lying frozen from 1:30.0 to 1:31.0.
4. **0:58.2–1:03.0:** near-overhead live camera that crops the boxers at the frame edges, with red's head merging into blue's chest at 1:00.4.
5. **0:52.2–0:53.0:** cut to a low close angle with blue's legs out of frame.

Honourable mention for worst: 1:20.0–1:21.2 and 1:31.2–1:33.0. Red stands still in guard over a fallen opponent instead of walking away.

**Best:**
1. **1:20.0–1:20.6:** blue's knockdown fall itself. The arms fly, the knees buckle and he sits down hard. It reads clearly as a big shot, at least until the legs go ragdoll.
2. **0:10.0–0:11.4:** a clean side-on exchange of jab and counter at proper range, framed like TV.
3. **0:32.6 and 0:58.5–0:58.7:** red's real duck and blue's head roll, defence that actually moves.

## 5) Verdict

The boxers' stance, guard and knockdown fall now look like boxing. But too many dead guard standoffs, a replay that delays the knockdown count by about 10 s, a contactless flinch, and overhead or cropped camera angles keep this from being broadcast quality. It is nowhere near 9/10.

Score: 5/10

## Contract
OWNS: scripts/fight3d/, scripts/rules/MoveWords.gd, assets/data/clip_contact.json, assets/data/clip_recovery.json, assets/data/clip_travel.json, tools/fight9_probe.gd
RED_TEST: tools/fight9_probe.gd -> FIGHT9 failures=0
REGRESSION: fight_flow_test, golden_path_test, ring_lens_test, clinch_rest_test, beat_clips_test, playtest_s375_test
VISUAL: yes
FILM: --resolution 1280x720 --script res://tools/judge_film.gd -- secs=90 fightjump=men_fight knockdown=70
BASE: agy/fight9r16
NOLOOP: S390 stopped by Claude: R17 and R18 scored under R16, branch 211 behind main; one session merges R16 by hand
