# TASK FIGHT9R11 - ANTIGRAVITY (Gemini 4 Argon High, the operator's 2,500 credits) - the live fight AND every clip to 9/10 on Argon's own judging, round by round

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

## Last verdict (round 10: Argon 5 -> 5/10 on agy/fight9r10; DROPPED - worse or a check failed; you start from the round before)

# JUDGE: Claude claude-opus-5-5 on 15 eyes contact sheets (FIGHT9R11 after) - Gemini prepay out, S380 operator: "Judge by Claude's eyes"

I've opened all 15 contact sheets in order. Here is the review.

# FightCamp live round: review of the FIGHT9R11 branch footage

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
BASE: claude/fight9base
LOOP: FIGHT9 9
