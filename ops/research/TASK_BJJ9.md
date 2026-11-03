# TASK BJJ9 - ZIVA - the BJJ belt match to 9/10 on Gemini 4 Argon's judging, round by round (you run the loop)

Status: OPEN (S371, Claude). Operator S371: "who can do the same for the bjj ?", "fix bjj until its 9/10", "ziva needs
access to https://eel.is/GrappleMap/index.html https://grappleflows.com/main". Start it right after BODYREACT1 is
committed and pushed. Effort MAX. Argon gave the belt match 2/10 (verdict below).

## Where
In your project E:/FightCamp/wt/ZIVA_LEAN: commit BODYREACT1 first, then `git fetch origin claude/bjjmatch1` and
`git checkout -b ziva/bjj9 origin/claude/bjjmatch1` (the belt match lives on that branch: scripts/grapple/BeltMatch.gd,
scripts/rules/BjjMatch.gd, scripts/grapple/* GrapplePlayer/GrapplePose/GrappleContact/GrappleGrip/GrappleTiming,
GrappleMapDB.gd; launch with scenes/dev/GrappleBrowser.tscn `-- match=1`). Push ziva/bjj9 after every round.

## References (read first): ops/research/BJJ_REFERENCES_S371.md
GrappleMap = which position follows which and where the limbs go (its data is already in GrappleMapDB; public domain);
it captures NO timing - speed and weight come from real footage. The operator's Grapple Flows match breakdown (six nodes,
mount -> bridge sweep -> closed guard -> arm lock -> triangle -> stand -> foot-over-foot pass, ~3-4 s a transition) is
in that file because the site needs his login. You may open both sites yourself if your tools reach the web.

## The loop (you run it; stop at 9/10 or after 12 rounds)
Each round: fix the costliest defect(s) in the newest verdict (a real fix in the pose/contact/timing code - never a
camera trick that hides a clip), add its measured bar to tools/bjj9_probe.gd (extends SceneTree, plays the belt match
headless, prints PASS/FAIL and "BJJ9 failures=<n>", quit(1) on failure; keep every earlier bar - e.g. the deepest
limb-into-body overlap per frame from GrappleContact capsules, takedown drop time, frames with zero bone motion during a
call, foot slide), keep tests/bjj_match_test.gd, tests/grapple_*_test.gd and golden_path_test green, commit, then:
1. PC: read E:/FightCamp/Lean/ops/AgentComms/pc_health.txt - wait while RED; never two windowed renders at once (check no
   other Godot runs with --write-movie or --windowed).
2. Film (the same recipe every round, so the scores compare):
   python E:/FightCamp/Lean/tools/hidden_desktop.py run --timeout=600 --log=<dir>/bjj_rN.log <godot.exe> --path . --windowed
   --resolution 1280x720 --audio-driver Dummy --fixed-fps 30 --write-movie <dir>/bjj_rN.avi --script res://tools/belt_match_film.gd -- match=1 secs=120
   then ffmpeg -y -loglevel error -i bjj_rN.avi -c:v libx264 -pix_fmt yuv420p -crf 23 -an bjj_rN.mp4 (delete the avi).
   <dir> = E:/FightCamp/Lean/ops/previews/BJJ9 ; <godot.exe> = %LOCALAPPDATA%/Programs/Godot/Godot_v4.7.2-stable_win64.exe.
3. Judge: python E:/FightCamp/Lean/ops/Tools/gemini_judge.py <dir>/bjj_rN.mp4 --model argon --fps 24 --kind fight
   --what "BJJ9 round N" --intent "<the text of E:/FightCamp/Lean/ops/research/BJJ9_JUDGE_INTENT.txt>"
   -> <dir>/bjj_rN.gemini_argon.md ("Overall: N/10"). About $0.26 a run on the operator's prepaid credit.
4. Append one line to E:/FightCamp/Lean/ops/research/BJJ9_ROUNDS.md: round, commit, score before -> after, what you fixed,
   the bar you added. A round that scores LOWER than the one before: revert it (git revert) and try the next defect.
Never edit the boxing fight files (scripts/fight3d/ - Antigravity's FIGHT9 loop owns them) or the gym/menus.

## Last verdict (round 0: claude/bjjmatch1 @ fcf6293, ops/previews/S371/bjj_main.mp4)

# Gemini (gemini-4-argon) on bjj_main.mp4 at 24 fps

Tokens in 118,355, out 2,074 (thinking included), $0.2575, 53 s.

Overall: 2/10

### 1) Does it look like real no-gi BJJ?
It does not look like real grappling; the positions and transitions are mechanically nonsensical and defy gravity and anatomy.
*   **Takedowns (00:01–00:14):** The UI calls a "Leg Weave Takedown," which is a guard pass, not a takedown. Visually, Red steps her right leg between Blue's legs (00:04), and both fighters slowly tip over like rigid statues into a headstand/pile-driver position (00:08–00:11) before settling into half guard (00:14). No real takedown functions at this speed or angle.
*   ** Entanglements / Leg Locks (00:21–00:43):** At 00:21, the transition to the "Honey Hole" ( Saddle / 411) is a chaotic tangle where limbs pass directly through each other. By 00:30 ("Bottom Bails" -> "To 50/50"), their legs are fused together at the thighs. At 00:36–00:43, they sit upright in 50/50, but their arms and legs are knotted through each other's torsos.
*   **Guard Passing & Back Exposure (00:44–01:00):** Red attempts to pass (00:45), resulting in a bizarre stacked position where Blue is folded in half (00:50). At 00:54 ("Gets Seatbelt"), Red is sitting *on* Blue's chest/face while Blue is in a seated guard posture, facing the same direction—a physically impossible back-take configuration.
*   **Finish (01:00–01:03):** The match ends via "Submission (To Mounted Arm Triangle)" at 01:03, while Blue is actually underneath Red's legs/hips in a mangled, inverted back/crucifix tangle, nowhere near a mounted arm triangle.

### 2) Animation Defects
*   ** Severe Mesh Clipping / Interpenetration:**
    *   **00:23–00:26:** Red’s left leg and hip pass completely through Blue’s torso and legs during the Honey Hole entry.
    *   **00:30–00:35:** Red's right thigh and Blue's left thigh are merged inside one another.
    *   **00:40–00:42:** As the camera orbits, Blue’s arms and head clip directly through Red’s chest and shoulder.
    *   **00:50–00:53:** Red’s legs pass through Blue’s torso and arms as they transition to the seatbelt.
    *   **00:56–01:03:** Blue's arms and head are buried inside Red's abdomen and thighs during the final sequence.
*   **Wrong Speed & Weightlessness:**
    *   **00:04–00:13:** The takedown happens in extreme slow motion. At 00:09–00:11, Blue balances weightlessly upside down on Red's head/shoulder with zero gravity or impact upon hitting the mat.
*   **Frozen / Puppet-like Stretches:**
    *   **00:15–00:20:** During "Hold And Breathe," both models freeze completely for 5 seconds—no chest heaving, micro-adjustments, or hand-fighting.
    *   **00:30–00:35:** Another complete freeze during the decision pause in 50/50.
*   **Foot Sliding & Floating:**
    *   **00:02–00:04:** Red’s left foot slides across the floor without stepping as she closes distance.
    *   **00:55–00:58:** Blue's feet hover and slide over the mat surface without bearing weight.

### 3) Camera
*   **Framing:** The high-angle isometric camera keeps the fighters centered, and the white void background ensures high contrast.
*   **Obstruction & Cuts:** There are no cuts, only smooth orbital pans (e.g., 00:37–00:42). However, because the models are clipping inside each other (especially 00:48–01:03), the camera angle cannot make the action readable—limbs obscure heads and torsos because they are occupying the same 3D space.

### 4) 5 Worst & 3 Best Moments
**5 Worst Moments:**
1.  **00:09** – Blue floats upside down in a slow-motion, gravity-defying pile-driver during a "takedown."
2.  **00:31** – A 5-second total freeze-frame where both fighters' thighs are fused together into a single mesh.
3.  **00:41** – Blue's head and arms pass straight through Red's torso during the 50/50 rotation.
4.  **00:56** – Red sits on Blue's upper back/neck while Blue's legs stick out through Red's hips in a broken "seatbelt" pose.
5.  **01:03** – The UI declares a "Mounted Arm Triangle" victory while the models are twisted in an inverted, clipping leg/backknot.

**3 Best Moments:**
1.  **00:00** – The initial standing fighting stances are clean, separated, and anatomically intact.
2.  **00:14** – The brief settle into top half-guard has recognizable BJJ structure before the clipping begins.
3.  **00:37** – The camera orbit smoothly tracks the rotation into the seated 50/50 position.

### 5) Verdict
Unwatchable as a grappling broadcast due to catastrophic mesh clipping, weightless slow-motion physics, and animations that do not match the called BJJ techniques.
Watchable as a sports broadcast: 2/10

---

### Defects Ordered by Point Cost (with Fixes)

1.  **Catastrophic Limb/Torso Interpenetration (-3.0 points)**
    *   *Timestamps:* 00:23–00:26, 00:30–00:35, 00:40–00:42, 00:50–01:03.
    *   *Fix:* Author keyframes using dual-character rigs (like GrappleMap's joint-constrained pairs) where both skeletons share a root and are posed simultaneously to guarantee collision-free contact, rather than blending independent single-character animations or using unconstrained IK interpolation between disparate poses.
2.  **Broken Technique Mapping & Impossible Poses (-2.0 points)**
    *   *Timestamps:* 00:01 ("Leg Weave Takedown"), 00:54–00:59 (Seated seatbelt inversion), 01:03 ("Mounted Arm Triangle" from bottom/back tangle).
    *   *Fix:* Audit the state-machine transition graph against a valid BJJ ontology. Ensure every named text event triggers the exact corresponding keyframe node (e.g., a Mounted Arm Triangle must require transitioning through Mount -> Arm Isolation -> Head-and-Arm Choke finish, with the winner on top).
3.  **Linear, Weightless Interpolation on Takedowns (-1.5 points)**
    *   *Timestamps:* 00:04–00:13.
    *   *Fix:* Replace linear pose-to-pose interpolation with ease-in/ease-out curves driven by gravity. A takedown must have a fast drop phase (under 0.8 seconds) and a distinct mat-impact keyframe with hip/shoulder compression.
4.  **Dead Freezes During Tactical Calls (-1.0 point)**
    *   *Timestamps:* 00:15–00:20, 00:30–00:35.
    *   *Fix:* Add looping additive idle animations (chest breathing, subtle grip fighting, head pressure micro-movements) whenever the simulation pauses for player input or "Hold and Breathe" states.
5.  **Foot Skating and Ground-Plane Violations (-0.5 points)**
    *   *Timestamps:* 00:02–00:04, 00:55–00:58.
    *   *Fix:* Lock plant feet and grounded hips to the floor plane using IK ground-clamping constraints during standing entries and seated guard scooting.

### What Must Be True for 9/10
To reach 9/10, the animation system must use **synchronized two-person grappling keyframes** where limbs never pass through torsos or heads. Every transition must follow a **valid positional hierarchy** (e.g., Standing -> Takedown -> Guard -> Pass -> Side Control -> Mount -> Submission) where the 3D visual matches the UI text 100% of the time. Transitions must execute at **realistic speeds** (fast, heavy drops on takedowns; 2–4 seconds of purposeful, weighted movement on passes and sweeps) with **active idle loops** (breathing and isometric tension) replacing hard freezes during tactical pauses.

## Contract
OWNS: scripts/grapple/, scripts/rules/BjjMatch.gd, tools/bjj9_probe.gd, tools/belt_match_film.gd
RED_TEST: tools/bjj9_probe.gd -> BJJ9 failures=0
REGRESSION: grapple_pose_test, grapple_contact_test, grapple_timing_test, golden_path_test (and tests/bjj_match_test.gd, on the branch)
VISUAL: yes
FILM: --resolution 1280x720 --script res://tools/belt_match_film.gd -- match=1 secs=120
BASE: claude/bjjmatch1
