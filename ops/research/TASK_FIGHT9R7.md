# TASK FIGHT9R7 - ANTIGRAVITY (Gemini 4 Argon High, the operator's 2,500 credits) - the live fight AND every clip to 9/10 on Argon's own judging, round by round

Status: OPEN (S371, Claude; S372 rewritten after round 1 failed to compile). Operator S371: "gemini4 review the fight with the fixes and rate it again", "and then tell
gemini to reach to 9/10", "let argon do all the fixes until its 9/10". Main scored 3/10 (verdict below).

## S377 BASE: claude/fight9base now = round 5 + main through 7988a595 (merged by Claude, no conflicts): the knockdown count
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

## Last verdict (round 6: Argon 3.5 -> 3/10 on agy/fight9r6; DROPPED - worse or a check failed; you start from the round before)

# Gemini (gemini-4-argon) on after.mp4 at 24 fps

Tokens in 229,561, out 1,525 (thinking included), $0.4744, 104 s.

Here is the breakdown of the footage from a boxing and animation perspective.

### 1) Does it look like real boxing?
* **Footwork & Range:** The fighters spend almost the entire round in each other's pockets, Toe-to-toe at kissing distance (e.g., 00:38, 00:43, 01:19). There is no true outside range or mid-range boxing; they just shuffle forward until their chests or lead feet collide, then trade.
* **Punch Selection & Variety:** There is decent variety in the types of punches thrown—jabs (00:34), hooks (00:46), uppercuts (00:54), and body shots (00:30, 01:24). However, they are thrown almost exclusively as single shots rather than fluid combinations. 
* **Defence:** There is some nice defensive movement, such as Red ducking under a shot at 00:41 and 01:05, and Blue leaning back at 01:06. However, high guards often fail to actually block incoming leather because the gloves clip right through them (00:42).
* **Clinches:** There are no real clinches. At 00:38–00:40 and 01:18–01:20, the fighters press their chests together in clinching range, but instead of tying up and pushing off, they just awkwardly rub against each other while throwing short, clipping punches.
* **Hit Reactions:** When hits land, the reactions are often exaggerated or robotic. At 00:42, Red's head snaps back violently from a punch that mostly clips through his guard. Conversely, at 01:38, the knockout blow barely grazes Blue's guard, yet Blue's head snaps back as if hit by a sledgehammer.
* **Knockdown & Aftermath (The Major Failure):** This is completely broken. When Blue is knocked down at 01:38 (and again after the replay at 01:46), **Red does not go to a neutral corner**. Instead, Red stands directly over Blue, straddling and stepping on Blue's legs while staying in his fighting stance bouncing up and down (01:46–02:03). Furthermore, **there is no knockdown count UI**, the **round clock continues to tick down** from 1:47 to 1:29 while Blue lies unconscious on the canvas, and the fight never waves off.

### 2) Animation Defects
* ** Rope/Entry Physics:** During the ring entry, both fighters clip horribly through the ropes. At 00:01–00:03, Red's torso and legs pass straight through the middle and top ropes. At 00:04–00:06, Blue's legs clip through the ropes and his boot gets stuck in the ring post.
* **Clipping:** Severe and frequent. During the glove touch at 00:25, their lead gloves pass completely through each other. At 00:30, Blue's body hook buries elbow-deep into Red's midsection. At 01:14–01:15, their arms and heads intersect in a tangled mess. From 01:39–02:03, Red's boots clip through Blue's downed legs.
* **Foot Sliding / Skating:** Noticeable throughout. As they micro-adjust their spacing (e.g., 00:31–00:33, 00:48–00:50), their feet slide across the canvas without proper weight transfer.
* **Robotic/Frozen Stretches:** Between 00:55 and 01:04, both fighters just stand in front of each other doing synchronized idle bounces without throwing a punch for nearly 10 seconds. During the pre-fight announcements (00:16–00:22), the cornermen perform a bizarre, robotic synchronized thumbs-up animation.
* **Contact/Reaction Mismatch:** The KO punch at 01:38 (shown in slow-mo replay at 01:42–01:43) is a short right hand from Red that hits Blue's forearm/glove, yet triggers a massive ragdoll knockdown.

### 3) Camera
* **Framing & Cuts:** The main broadcast camera angle (00:27 onwards) is decent, keeping both fighters in frame. However, the cut to the replay at 01:39 is jarring—it uses the exact same camera angle, just zoomed in slightly with a "REPLAY" text overlay, and cuts back at 01:46 while the round clock is still running.
* **Obstructions:** At 00:10–00:16, the "Tale of the Tape" UI overlay completely blocks the view of the ring while the camera is doing a nice wide shot. During the ring entries (00:01–00:08), the foreground ropes cut right across the fighters' bodies.

### 4) Worst & Best Moments

**The 5 Worst Moments:**
1. **01:46–02:03:** Red stands directly on top of the unconscious Blue fighter, bouncing in his stance while the round clock ticks away with no count or stoppage.
2. **00:04–00:06:** Blue's ring entry animation goes haywire, with his legs clipping through the ropes and his right foot floating into the ring post.
3. **01:42–01:43:** The slow-motion replay exposes that the knockout punch was aphantom hit that barely grazed Blue's guard before he collapsed.
4. **00:25:** The pre-fight touch of gloves results in both fighters' hands passing completely through one another like ghosts.
5. **00:30:** Blue throws a left hook to the body that sinks his entire forearm inside Red's ribcage.

**The 3 Best Moments:**
1. **00:41:** Red executes a smooth, believable ducking animation to evade Blue's high-guard pressure.
2. **01:28–01:29:** A nice exchange where Red lands a jab and Blue immediately dips down to counter with a left hook to the body.
3. **01:06:** Blue shows good upper-body head movement, leaning back and rolling his shoulder to slip Red's jab.

### 5) Verdict
The core punching and slipping animations have moments of promise, but severe clipping, robotic idle stretches, and a completely broken knockdown state (where the winner dances on the loser's body while the clock runs) ruin the illusion of a real bout. 

**Score: 3/10** (Not watchable as a sports broadcast until knockdown logic, neutral corners, and rope/body clipping are fixed).

## Contract
OWNS: scripts/fight3d/, scripts/rules/MoveWords.gd, assets/data/clip_contact.json, assets/data/clip_recovery.json, assets/data/clip_travel.json, tools/fight9_probe.gd
RED_TEST: tools/fight9_probe.gd -> FIGHT9 failures=0
REGRESSION: fight_flow_test, golden_path_test, ring_lens_test, clinch_rest_test, beat_clips_test, playtest_s375_test
VISUAL: yes
FILM: --resolution 1280x720 --script res://tools/judge_film.gd -- secs=90 fightjump=men_fight knockdown=70
BASE: claude/fight9base
LOOP: FIGHT9 9
