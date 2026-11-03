# TASK FIGHT9R1 - ANTIGRAVITY (Gemini 4 Argon) - the live fight to 9/10 on Argon's own judging, round by round

Status: OPEN (S371, Claude). Operator S371: "gemini4 review the fight with the fixes and rate it again", "and then tell
gemini to reach to 9/10", "let argon do all the fixes until its 9/10". Main scored 2/10 (verdict below).

## How the loop works
- You are one ROUND. You fix the costliest defects in the "Last verdict" below that are yours (see "Not yours"), one or
  two per round - a real fix, not a tweak of a number to fool a camera.
- The dispatcher then commits your files, runs the checks headless, films the same fight (tools/judge_film.gd, the walk-in
  and 90 s of round 1 at real speed) and Gemini 4 Argon judges it. If the score is at least the last one and every check is
  green, your branch becomes the next round's BASE; otherwise the next round starts from the round before and reads why.
  The next round's brief is this one with the new verdict. It stops at 9/10 (or 12 rounds); a Claude session merges.
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
- Knees: your own KNEETRACK1 (scripts/fight3d/KneeTrack.gd) - build on it if it is in your base, do not fight it.

## Last verdict (round 0: main, before any round)

# Gemini (gemini-4-argon) on fight_main.mp4 at 24 fps

Tokens in 256,350, out 3,055 (thinking included), $0.5433, 100 s.

Overall: 2/10

### 1. Does it look like real boxing?
* **Footwork and Range:** Boxers spend long stretches standing flat-footed at awkward ranges—either too far to land (00:32–00:34, 01:08–01:14, 02:11–02:18) or chest-to-chest without throwing leather (00:36–00:39, 00:49–00:50). When they do move, their feet glide across the canvas rather than stepping with weight transfer (00:52–00:53, 01:36–01:37, 01:48).
* **Punch Selection and Variety:** Extremely limited and robotic. Blue repeatedly spam-ducks into a telegraphed left body hook (00:28, 00:30, 01:15, 01:16, 01:28). Jabs and straights are thrown with slow, underwater arm extensions lacking hip rotation or snap (00:44–00:45, 01:08, 01:18, 01:49).
* **Defence:** There is no active head movement, parrying, or rhythm. Defence consists of holding a static high guard (00:32–00:34) or sudden, deep waist bends (00:28, 01:48). At 02:03, Blue leans her head and torso backward at an unnatural, matrix-style angle to evade a hook.
* **Clinches:** Clinches look like two mannequins colliding and intersecting rather than a grappling tie-up (00:40–00:41, 01:18–01:20, 01:24–01:25, 01:51–01:53, 01:59–02:01). Arms clip through shoulders and necks without real grip or leverage.
* **Referee Movement:** Comically broken. The referee walks in a permanent deep crouch/squat (00:41, 01:20), lunges into the fighters like a zombie or mime to break clinches (00:42–00:43, 01:21–01:22, 01:54), and at 01:55–01:56 moonwalks/glides backward out of the frame.
* **Hit Reactions:** Punches lack kinetic transfer. Either gloves pass through guards/heads with zero reaction (00:30, 00:31, 01:34), or a grazing/missed punch triggers a canned, slow-motion torso rock (02:03–02:04, 02:10).

---

### 2. Animation Defects (Ranked by Point Cost)

**1. Slow-motion, weightless punch and reaction physics (-2.5 points)**
* **Timestamps:** 00:28–00:31, 00:44–00:45, 01:08, 01:15–01:18, 01:48–01:50, 02:03–02:04, 02:10.
* **Defect:** Even at "1x" speed, punches travel at roughlyram-speed (half of real lightweight speed) with no acceleration curve, shoulder snap, or recoil. Hit reactions (like Blue leaning back at 02:03 or rocking at 02:10) look like underwater puppetry.
* **Concrete Fix:** Retime all punch animations to 12–18 frames total (3–5 frames startup, 2 frames active extension, 6–10 frames snappy retraction) with non-linear easing curves. Drive hit reactions via an additive physics/impulse layer on the upper spine and neck rather than slow, full-body keyframed leans.

**2. Referee crouching, mime-lunging, and moonwalking (-1.5 points)**
* **Timestamps:** 00:41–00:44, 01:18–01:23, 01:50, 01:52–01:56.
* **Defect:** The referee's rig is stuck in an awkward bent-knee crouch. When breaking a clinch (00:42, 01:21), she performs a bizarre two-handed pushing lunge while her head clips into Red's chest, then slides/moonwalks backward across the canvas (01:55).
* **Concrete Fix:** Replace the referee's locomotion state machine with an upright, balanced sidestep/walk cycle. Trigger clinch breaks only when the ref is within arm's reach, using a clean step-in wedge animation, and ensure root-motion matches movement direction so she never walks backward using a forward walk cycle.

**3. Severe mesh clipping during clinches, ring entry, and punches (-1.5 points)**
* **Timestamps:** 00:01–00:03, 00:04–00:05, 00:35–00:36, 00:40–00:41, 00:42, 01:18–01:20, 01:24–01:25, 01:29, 01:51–01:53, 01:59–02:01.
* **Defect:** During ring entry (00:01–00:05), the middle rope deforms, but the top rope passes straight through both fighters' heads and necks. In clinches, arms, gloves, and heads pass straight through the opponent's torso and neck (e.g., 00:40, 01:24, 01:51).
* **Concrete Fix:** For ring entry, either animate the fighter ducking low enough to clear the top rope or apply a 2-bone IK/spline deformer to both the top and middle ropes. For clinches, use synchronized two-character paired animations with locked root offsets and IK hand-to-shoulder/waist targets so capsules cannot interpenetrate.

**4. Foot sliding / skating and lack of planted steps (-1.0 point)**
* **Timestamps:** 00:25–00:26, 00:32–00:34, 00:46–00:48, 00:52–00:53, 01:11–01:14, 01:31–01:33, 01:36–01:37, 01:48, 02:05–02:06, 02:13–02:18.
* **Defect:** Characters translate across the ring while their feet either stay in a static stance or shuffle at a speed that doesn't match ground velocity. During the 01:48 duck, Red's feet slide wide apart across the mat.
* **Concrete Fix:** Enable root-motion-driven locomotion with foot-locking IK (ankle pinning during contact phases). Any lateral or linear translation must be driven by discrete step animations rather than sliding the character controller capsule.

**5. Robotic, repetitive AI action loops and frozen staring contests (-1.0 point)**
* **Timestamps:** 00:28 & 00:30 (identical duck-hooks), 00:32–00:34 (staring), 00:37–00:39 (frozen chest-to-chest), 00:49–00:50 (frozen inside), 01:08–01:14 (staring), 01:15 & 01:16 (identical duck-hooks), 02:11–02:18 (staring).
* **Defect:** Fighters freeze in identical guard poses for 5–7 seconds at a time, then execute the exact same canned animation twice in a row (Blue's deep squat body hook).
* **Concrete Fix:** Add layered procedural idle noise (breathing, micro-feints, weight shifts between lead and rear foot, guard hand adjustments) and put a cooldown on identical punch-duck combinations so the AI varies its attacks.

**6. Camera cuts flipping the 180-degree broadcast line and ref blocking the lens (-0.5 points)**
* **Timestamps:** 00:40, 01:18, 01:49, 01:52–01:55.
* **Defect:** At 00:40, 01:18, and 01:49, the camera instantaneously cuts to the opposite side of the ring, flipping Red and Blue's left/right screen positions and disorienting the viewer. At 01:18–01:20 and 01:52–01:54, the referee stands directly between the camera and the fighters.
* **Concrete Fix:** Lock the broadcast camera to one side of the ring (respecting the 180-degree rule) with smooth orbital damping, and program the referee's positioning AI to stay on the far side of the fighters relative to the active camera vector.

---

### 3. Camera
* **Framing:** The medium-full side angle (00:27–00:39) is decent for a broadcast view, though the UI body maps on the left and right edges crowd the frame.
* **Cuts:** Jarring 180-degree axis jumps at 00:40, 01:18, and 01:49 flip the fighters' screen sides mid-exchange/clinch.
* **Obstructions:** The referee walks directly through the foreground and blocks the fighters at 01:18–01:21, 01:50, and 01:52–01:55. The decision/shout UI overlay at 00:57–01:07 and 01:37–01:47 darkens and covers the lower third of the ring.

---

### 4. The 5 Worst Moments & 3 Best Moments

**5 Worst Moments:**
1. **00:42–00:43:** The referee lunges in like a mime doing a breaststroke, shoving her head into Red's torso to break a clinch.
2. **01:54–01:56:** After breaking a clinch, the referee moonwalks backward across the ring out of frame.
3. **00:01–00:05:** Both fighters climb through the ropes while the top white rope slices straight through their skulls and necks.
4. **02:03–02:04:** Blue leans backward at an absurd, slow-motion 45-degree angle to dodge a hook that barely grazes her.
5. **01:15–01:17:** Blue performs two identical, robotic deep-squat body hooks in a row while Red's counter-punch passes through her shoulder.

**3 Best Moments:**
1. **00:10–00:16:** The wide corner shot with the "Tale of the Tape" overlay looks clean and well-composed as a broadcast graphic.
2. **00:25–00:26:** The pre-fight glove touch is a recognizable, well-paced boxing beat (aside from minor glove intersection).
3. **00:57–01:07:** The tactical pause/slow-down UI presentation is clear and readable for a management game, even if the underlying character movement is stiff.

---

### 5. Verdict
 Robotic, slow-motion rock-'em-sock-'em puppets with a moonwalking referee make this unwatchable as a real boxing broadcast.
**Watchable as a sports broadcast:** 2/10

---

### What Must Be True for This to Be 9/10
1. ** Real-Speed, Snappy Punch Kinematics:** Punches must fire at真实 lightweight speeds (sub-200ms extension) with visible kinetic chain mechanics (foot pivot, hip turn, shoulder snap) and crisp retraction, completely eliminating the underwater, floaty arm extensions.
2. **Physics-Driven Hit Reactions & Guard Impact:** Every landed punch must produce an immediate, localized physical reaction—gloves deflecting off forearms on blocks, or heads snapping back/turning on clean hits—with zero pass-through clipping.
3. **Synchronized, Non-Clipping Clinches:** Clinches must use paired two-actor animations with IK hand placement on the opponent's arms/torso so bodies tie upwith real weight and zero mesh intersection.
4. **Root-Motion Footwork with Foot-Locking:** Fighters must step, pivot, and bounce on their toes with zero foot sliding; every change in distance must be accounted for by actual foot plants.
5. **Invisible, Competent Referee:** The referee must move upright with natural sidesteps, stay on the far side of the action relative to the broadcast camera so she never blocks the view, and break clinches with a clean, contact-accurate step-in.
6. ** Disciplined Broadcast Camera:** The camera must respect the 180-degree line (no instant side-flipping cuts) and use smooth broadcast zoom/pan damping to track the ring center.

## Contract
OWNS: scripts/fight3d/, scripts/rules/MoveWords.gd, assets/data/clip_contact.json, assets/data/clip_recovery.json, assets/data/clip_travel.json, tools/fight9_probe.gd
RED_TEST: tools/fight9_probe.gd -> FIGHT9 failures=0
REGRESSION: fight_flow_test, golden_path_test, ring_lens_test, clinch_rest_test, beat_clips_test
VISUAL: yes
FILM: --resolution 1280x720 --script res://tools/judge_film.gd -- secs=90
BASE: main
LOOP: FIGHT9 9
