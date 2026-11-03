# TASK FIGHT9R2 - ANTIGRAVITY (Gemini 4 Argon) - the live fight to 9/10 on Argon's own judging, round by round

Status: OPEN (S371, Claude; S372 rewritten after round 1 failed to compile). Operator S371: "gemini4 review the fight with the fixes and rate it again", "and then tell
gemini to reach to 9/10", "let argon do all the fixes until its 9/10". Main scored 3/10 (verdict below).

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

## Operator's own note first (S372, comment C218 on the KNEETRACK1 after-film at 24 s) - TOP PRIORITY
"when legs move its akward something is wrong, when doesnt move looks ok". Claude looked at the frames (19-24 s): standing
still the legs are fine; the moment she steps, the knees cave inward toward each other, the feet turn out away from the
knees, and the rear heel lifts with the foot twisted. The stance goes knock-kneed for a beat on every step, slip and
crouch. Fix the MOVING legs (stepping, slips, crouches): knees over the toes WHILE the feet travel, feet pointing where the
knee points, heel lifts on the line of the foot. Your KneeTrack.gd (KNEETRACK1, merged) holds the still pose; the moving
pose is where it breaks. Add a bar in tools/fight9_probe.gd: knee-over-toe angle during steps (not only at rest).

## Last verdict (round 1 on agy/fight9r1: NOT JUDGED - it did not compile; Claude fixed it in S372; it is your BASE)
Round 1 never got filmed properly: three parse errors stopped the whole game from compiling, so the after-film sat 6.5 min
on the gym screen and Argon scored a frozen menu 1/10. Claude fixed exactly these (commit on agy/fight9r1, PR #24):
- scripts/fight3d/FightView.gd:256 `OS.get_cmdline_user_args().any(...)` - PackedStringArray has no any(); now a loop, and
  it also skips the shout bar under the movie writer (`OS.has_feature("movie")`), since tools/judge_film.gd passes no film=.
- scripts/fight3d/FightIntro.gd:239 and :371 `stage.boxers[i]["ik"].upright(0.0)` were one tab short (outside the loop).
- tools/fight9_probe.gd:234 `var cross_y := <untyped>` - typed `: float`.
You cannot run Godot, so: use only methods that exist on that exact type (Array has any()/all(); PackedStringArray, PackedFloat32Array
and Dictionary do not); type every `var x :=` whose value comes from an untyped node (`var x: float = ...`); keep a new line
at the same indent as the block it belongs to. The dispatcher now boots the game after your edits and gives you one repair
pass on any parse error it prints.
Round 1 with those fixes, run headless by Claude (S372): tools/fight9_probe.gd 13/15 PASS - still FAIL: "ring entry ducks
cleanly under 1.25 m top rope (head_y=1.496)" and "clinch break 2: through=3" (break 1 and 3 clean); golden_path_test,
ring_lens_test, fight_flow_test PASS. Those two red bars are yours to turn green this round, beside the operator's legs.
Round 1's work (PushOff without a referee, faster punches and retraction, head-shot timing, the 180-degree camera line,
the ring-entry duck, no film pauses) is in your BASE; this round's before-film is its first real score. The last real
verdict is main's, before round 1:

# Gemini (gemini-4-argon) on before.mp4 at 24 fps

Tokens in 256,257, out 1,606 (thinking included), $0.5286, 99 s.

Here is the evaluation of the footage from both a boxing fan’s and an animation director’s perspective.

### 1) Does it look like real boxing?
*   **Footwork and Range:** The fighters spend long stretches standing flat-footed at mid-range doing nothing (e.g., 00:46–00:48, 01:10–01:14, 02:13–02:17). When they do close distance, they often walk straight into each other's chests without setting it up behind a jab (00:35, 01:51).
*   **Punch Selection and Variety:** There is some variety—jabs (00:30, 01:08), body hooks (00:28, 01:15), and combinations (00:44, 01:55)—but the output is far too low for a 3-minute amateur round. The fighters frequently freeze after throwing a single shot.
*   **Defence:** There are decent high guards (00:31) and some head movement/ducking (00:40, 01:48), as well as a nice lean-back slip by Blue at 02:03. However, fighters often stand completely still in the pocket with their hands up, waiting to be hit or clinched.
*   **Clinches:** Clinches happen frequently (00:36, 00:41, 01:18, 01:28, 01:51, 01:59), which is realistic for tired or pressured fighters, but the entries look like magnetic collisions rather than tactical tie-ups. 
*   **Referee's Movement:** The referee is a major immersion breaker. When breaking clinches (00:42, 01:21, 01:54), the ref lunges in with a bizarre, deep-knee-bend "zombie push" pose, shoving the air between the fighters long after they have already separated.
*   **Hit Reactions:** Some punches land with zero reaction from the receiver (e.g., Red's jab at 00:30, Blue's body shot at 01:15). Conversely, at 02:03, Blue's head snaps back violently from a punch that clearly misses her face by several inches.

### 2) Animation Defects
*   **Clipping / Passing Through Geometry:** 
    *   During the ring entrance (00:02–00:03 and 00:04–00:06), the top ring rope bends, but the fighters' torsos, heads, and legs clip straight through the ropes.
    *   In clinches (00:36, 00:41, 01:19, 01:29, 01:51, 01:59), gloves, forearms, and heads severely intersect and pass through the opponent's chest, shoulders, and neck.
    *   At 00:42 and 01:21, the referee's outstretched arms clip directly through the fighters' bodies as she breaks the clinch.
*   **Snapping and Popping:** 
    *   At 00:08, Blue's pre-fight animation abruptly snaps into a walking turn.
    *   When clinches break (00:42, 01:21, 01:54), the fighters snap out of their grappling poses back into their default idle guards almost instantaneously.
*   **Foot Sliding / Skating:** As fighters adjust range or get pushed back (00:35, 00:42, 01:21, 01:54), their boots slide across the canvas without proper stepping weight transfer.
*   **Hit Detection / Ghost Punches:** At 02:03, Red throws a lead hook that falls short, yet Blue's head snaps back as if she took a flush power shot.
*   **Frozen / Puppet-like Stretches:** The idle bob-and-weave loop is robotic and synchronized. From 00:37–00:39, 01:10–01:14, and 02:08–02:18, both fighters rock back and forth in a trance-like, puppet-like rhythm without throwing punches.
*   **Speed Issues:** The referee's walk-away after breaking a clinch (00:43, 01:22) is awkwardly slow and stiff, like a robot powering down.

### 3) Camera
*   **Framing:** The side-on 2D fighting-game style camera keeps both fighters in frame well during open exchanges.
*   **Cuts:** The camera cuts to the opposite side of the ring at 00:40, 01:18, 01:49, and 01:54. Cutting *mid-clinch* or *mid-combination* (00:40, 01:18, 01:49) is disorienting and breaks the flow of the action, flipping the left/right orientation of the fighters instantly.
*   **Obstructions:** From 01:18 to 01:21 and 01:50 to 01:54, the referee walks directly into the foreground between the camera and the fighters, completely blocking the view of the clinch.

### 4) The 5 Worst Moments & 3 Best Moments

**5 Worst Moments:**
1.  **00:02** – Red's legs and torso clip completely through the solid ring ropes while climbing into the ring.
2.  **00:42** – The referee performs a bizarre, stiff,two-handed lunging shove into empty space to break a clinch, clipping through the fighters.
3.  **01:19** – The referee stands directly in front of the camera lens, blocking the action while the fighters' arms clip through each other's necks in the background.
4.  **02:03** – Blue's head violently snaps backward in a heavy hit-reaction from a punch that misses her by half a foot.
5.  **02:13** – For over five seconds (until 02:18), both fighters just rock back and forth in a robotic, synchronized idle loop without throwing a single punch.

**3 Best Moments:**
1.  **00:25** – The pre-fight glove touch is clean, well-aligned, and looks like a genuine sporting moment.
2.  **00:44** – Red throws a crisp jab-cross combination that Blue parries/blocks, followed by a natural counter-jab from Blue.
3.  **01:48** – Red ducks under a punch and weaves her head off the centerline smoothly, showing a flash of fluid boxing defense.

### 5) Verdict
Robotic idle loops, severe clinch clipping, and a bizarrely animated referee make this look like a stiff early prototype rather than a live boxing match. 
**Score: 3/10**

## Contract
OWNS: scripts/fight3d/, scripts/rules/MoveWords.gd, assets/data/clip_contact.json, assets/data/clip_recovery.json, assets/data/clip_travel.json, tools/fight9_probe.gd
RED_TEST: tools/fight9_probe.gd -> FIGHT9 failures=0
REGRESSION: fight_flow_test, golden_path_test, ring_lens_test, clinch_rest_test, beat_clips_test
VISUAL: yes
FILM: --resolution 1280x720 --script res://tools/judge_film.gd -- secs=90
BASE: agy/fight9r1
LOOP: FIGHT9 9
