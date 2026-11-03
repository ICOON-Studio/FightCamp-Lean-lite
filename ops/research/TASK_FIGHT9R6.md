# TASK FIGHT9R6 - ANTIGRAVITY (Gemini 4 Argon High, the operator's 2,500 credits) - the live fight AND every clip to 9/10 on Argon's own judging, round by round

Status: OPEN (S371, Claude; S372 rewritten after round 1 failed to compile). Operator S371: "gemini4 review the fight with the fixes and rate it again", "and then tell
gemini to reach to 9/10", "let argon do all the fixes until its 9/10". Main scored 3/10 (verdict below).

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

## Last verdict (round 5: Argon 3.5 -> 3.5/10 on cursor/fight9r5; KEPT - this round's code is your BASE)

# Gemini (gemini-4-argon) on after.mp4 at 24 fps

Tokens in 217,846, out 1,962 (thinking included), $0.4553, 67 s.

Here is the evaluation of the footage from a boxing fan and animation director perspective.

### 1) Does it look like real boxing?
* **Footwork & Range:** The fighters spend long stretches bouncing in place at a fixed, polite distance without cutting off the ring or angling out (e.g., `00:32`–`00:35`, `01:00`–`01:04`, `01:36`–`01:39`). When they do close range, they often walk straight into each other's chests (`00:35`, `00:53`, `01:18`).
* **Punch Selection & Variety:** There is decent variety on paper—jabs (`00:30`), lead hooks (`00:40`), and level-change body shots (`00:28`, `00:50`, `01:05`). However, punches are thrown mostly as single, isolated shots rather than fluid combinations, and the pacing is sluggish, with 4–6 second staring contests between exchanges (`00:45`–`00:48`, `01:20`–`01:23`, `01:35`–`01:39`).
* **Defence:** High guards are maintained, and there are some nice level-change ducks/slips (`00:30`, `01:03`). However, defence is mostly passive shell-guarding rather than active parrying, head movement, or using the jab to control range.
* **Clinches:** Clinching happens frequently (`00:35`, `00:40`, `01:08`, `01:30`), which is realistic for tired or pressured fighters, but the execution is robotic. They lock into a static, symmetrical hug and shuffle in place for several seconds (`01:08`–`01:11`, `01:30`–`01:33`). When they break, they do a weird, synchronized "patty-cake" glove-push (`00:42`, `01:11`, `01:34`).
* **The Referee:** **There is no referee in the ring.** Despite the prompt mentioning a referee, the ring only contains the two fighters during the bout (`00:26`–`01:57`). Clinches break themselves without a ref stepping in.
* **Hits & Reactions:** Impact is very weak. Punches look like slow-motion arm pushes (`00:48`, `00:58`). Some hits register on the UI body map (e.g., Red's head turns orange at `00:28` and `01:06`, Blue's head turns red at `00:49`) with barely any physical snap or weight transfer on the receiver. Conversely, at `01:49`, Red lands a hook that puts Blue into a dramatic, slow-motion side-lean stagger that looks like a canned, overly theatrical animation rather than physics-based impact.

### 2) Animation Defects
* **Clipping / Passing Through Geometry:** 
  * During the ring entry (`00:01`–`00:03` and `00:04`–`00:06`), the fighters' bodies and legs clip straight through the solid, unbending ring ropes.
  * During clinches and infighting (`00:35`–`00:36`, `00:54`–`00:56`, `01:08`–`01:10`, `01:19`), gloves, forearms, and heads severely intersect and pass through each other's shoulders, chests, and necks.
  * At `00:25`, the pre-fight glove touch has the gloves intersecting into each other.
* **Foot Sliding / Skating:** Noticeable foot skating occurs whenever the fighters rotate or adjust spacing, especially during clinches (`00:40`–`00:42`, `01:08`–`01:10`) and when circling/resetting (`01:17`–`01:18`, `01:47`–`01:48`), where feet glide across the canvas without planting.
* **Robotic / Repeated Moves:** 
  * The synchronized idle bounce (`00:32`–`00:34`, `00:46`–`00:48`, `01:51`–`01:53`) makes them look like wind-up toys.
  * The post-clinch break animation (`00:42`, `01:11`, `01:34`) is identical every time: both fighters extend their arms and push each other's gloves in a robotic, mirror-image reset.
  * Blue's deep knee-bend body jab (`00:28`, `00:50`, `01:05`) is repeated with the exact same mechanical cadence.
* **Wrong Speed:** Punching speed is Underwater/Slow-Mo. Jabs and hooks (`00:31`, `00:44`, `00:58`, `01:45`) lack snap and travel at roughly half the speed of a real lightweight boxer.

### 3) Camera
* **Framing:** The side-on broadcast angle (`00:27`–`01:57`) is clean and keeps both fighters well-centered, dynamically zooming in slightly when they engage and pulling back when they separate.
* **Cuts:** Pre-fight cuts (`00:03`, `00:09`, `00:16`, `00:19`, `00:22`, `00:26`, `00:27`) are serviceable, though the pan across the empty ring at `00:22`–`00:24` feels like a slow, unnecessary camera sweep. Once the bell rings (`00:27`), it stays on a single continuous camera.
* **Obstructions:** The foreground white and red ring ropes cut directly across the fighters' torsos and heads throughout the entire round (`00:27`–`01:57`), which is visually distracting. Additionally, Because the camera never orbits, whenever the fighters clinch or fight on the inside (`00:35`, `00:54`, `01:19`), Red's back or Blue's shoulder completely hides the punches being thrown on the far side.

### 4) The 5 Worst Moments & 3 Best Moments

**5 Worst Moments:**
1. **`00:02` (and `00:05`) – Rope Ghosting:** Both fighters step through the ring ropes as if the ropes are holograms, with zero rope physics or collision.
2. **`00:35`–`00:36` – Head-in-Chest Clinch:** The fighters walk into each other and their heads/gloves clip deeply into each other's upper chests and necks.
3. **`01:08`–`01:11` – The Zombie Hug:** A 3-second clinch where both fighters lock into a rigid, sliding embrace with their arms phased through each other's backs, followed by a robotic glove-pat break.
4. **`00:58`–`00:59` – Underwater Jab:** Blue throws a lead jab that travels so slowly and limply it looks like a stretching exercise rather than a strike.
5. **`01:35`–`01:39` – Synchronized Staring Contest:** Four full seconds of both fighters bouncing in place in near-perfect rhythm without throwing a feint, punch, or taking an angle.

**3 Best Moments:**
1. **`01:49`–`01:50` – Clean Counter Hook:** Red lands a left hook that triggers a visible, readable stagger reaction on Blue—the clearest moment of cause-and-effect in the round.
2. **`00:28`–`00:29` – Level-Change Body Attack:** Blue drops levels nicely to jab the body and follows up upstairs as she rises, showing a recognizable boxing sequence.
3. **`01:42`–`01:44` – Inside Exchange:** A brief flurry where both fighters trade hooks at close range with decent head movement and urgency compared to the rest of the round.

### 5) Verdict
**Verdict:** A stiff, slow-motion rock-'em-sock-'em simulation plagued by severe limb clipping, robotic clinches, and a missing referee, nowhere near a 9/10 broadcast standard.  
**Score:** **3.5 / 10**

## Contract
OWNS: scripts/fight3d/, scripts/rules/MoveWords.gd, assets/data/clip_contact.json, assets/data/clip_recovery.json, assets/data/clip_travel.json, tools/fight9_probe.gd
RED_TEST: tools/fight9_probe.gd -> FIGHT9 failures=0
REGRESSION: fight_flow_test, golden_path_test, ring_lens_test, clinch_rest_test, beat_clips_test, playtest_s375_test
VISUAL: yes
FILM: --resolution 1280x720 --script res://tools/judge_film.gd -- secs=90 fightjump=men_fight knockdown=70
BASE: claude/fight9base
LOOP: FIGHT9 9
