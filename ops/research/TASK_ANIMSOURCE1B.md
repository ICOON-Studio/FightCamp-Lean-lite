# TASK ANIMSOURCE1B - the Cascadeur punches become BOXING: guard stance, full extension, weight transfer; animation-only exports

Model: Codex gpt-6.1-sol, reasoning medium. SAME worktree and branch as 1A: E:/FightCamp/wt/ANIMSOURCE1, branch codex/animsource1
(continue from 90bcdaa4). Cascadeur licence ends 2026-10-27.

## What 1A got right (keep it)
Read `research/ANIMSOURCE1A_DIGEST.md` first. The pipeline works: hidden-desktop Cascadeur (ensure_server.py --hidden), the native
MetaHuman quick rig (RIG.json), scripted keys on controllers, AutoPhysics via the real toolbar actions, export + normalize, the imported
playback probe and the frame sheets. Do not rebuild any of that.

## What Claude saw on the 1A sheets (E:/FightCamp/tmp/animsource1/jab_side.png etc.) - the reasons for this task
1. NO BOXING STANCE: both men stand upright and square to each other, feet parallel side by side, knees straight, hands touching the chin
   like praying. That is a standing pose, not a guard. Every frame of every move inherits it.
2. THE JAB IS A POKE: fist travels 33.5 cm (probe), the arm never extends, no shoulder turn, no snap back.
3. SPACING: 0.75 m apart for straight punches - they stand inside each other's chest; the jab cannot land at that range with a real arm.
4. FILES: each clip GLB carries the whole MetaHuman mesh + textures (7.2 MB per clip). A clip must be animation only.
5. The probe gated feet and hand continuity only - so a non-boxing shape passed (the S207 lesson: a gate that checks distance or angle
   passes an elbow-first swipe). This task adds SHAPE gates that would have failed 1A.

## Step 1 - the GUARD base pose (every move starts and ends here)
Orthodox boxer (left foot forward), keyed once on the MetaHuman rig controllers and saved as `guard_pose` in the .casc:
- feet: staggered, lead foot forward; stance length (heel-to-heel along the line) 0.40-0.55 m; stance width (across) 0.20-0.30 m;
  lead foot toes pointing ~20-30 deg inward of the line, rear foot ~45 deg; rear heel lifted 2-4 cm (on the ball).
- knees bent 15-25 deg; pelvis lowered 4-7 cm from standing; weight ~55/45 rear/lead.
- torso bladed 30-45 deg off square (lead shoulder toward the opponent), slight forward lean 5-10 deg, chin tucked (head pitched down ~10 deg).
- lead glove at eye height, 20-30 cm in front of the face; rear glove touching the cheek/jaw; elbows down and in, touching the ribs.
- fists CLOSED (finger boxes as 1A).
Put a still of the guard (side + front + top) in the sheets before any move.

## Step 2 - re-author the four moves from the guard (real boxing shape)
- JAB (lead hand): extend straight from the guard to 90-97% of the arm's length at contact (measure the arm: shoulder->wrist chain length
  from the skeleton), fist turns palm-down in the last third, lead shoulder rises to cover the chin, small hip/shoulder turn 10-20 deg,
  optional 10-15 cm lead step; retract FASTER than the extension (extension ~0.12-0.15 s, retraction ~0.10-0.12 s) back to the guard.
- CROSS (rear hand): rear heel pivots out (rear foot turns 30-60 deg), hips and shoulders rotate 45-60 deg, weight shifts to the lead leg,
  arm extends to 90-97% of its length, chin behind the lead shoulder; lead glove stays at the face; snap back to the guard.
- LEAD HOOK: lead foot pivots on the ball, hips/shoulders turn 45-70 deg, elbow raised to shoulder height, elbow angle 80-100 deg kept
  through contact, fist travels on an arc, rear glove stays at the face.
- INSIDE UPPERCUT (rear hand, close range): knees dip 6-10 cm then drive up, rear hip turns in, fist rises from chest height under the
  opponent's chin with the elbow below the fist (1A's uppercut rules stay), short range.
- Opponent (blue) holds the guard pose at the right range: straights at a distance where the attacker's fist at 95% extension reaches the
  opponent's chin (compute from the arm length + both stances); hooks at the same or slightly closer; inside uppercut at 0.45-0.55 m.
- Keep AutoPhysics on; keep 30 fps; contact frame and guard-return frame as 1A.

## Step 3 - SHAPE gates in `Godot/tools/move_shape_probe.gd` (must FAIL on the 1A clips - run it on 1A first and record the fails)
- guard (frame 0 and last frame): stance length 0.40-0.55 m, stance width 0.20-0.30 m, both knees bent 15-25 deg, lead glove above the
  shoulder line and within 0.35 m in front of the head, rear glove within 0.12 m of the jaw, torso yaw 30-45 deg off the pair line.
- jab/cross: wrist distance from the shoulder at contact >= 0.90 x arm length; extension time > retraction time; cross hip yaw change
  >= 40 deg and rear heel rotation >= 30 deg.
- hook: elbow height within 0.08 m of shoulder height at contact; elbow angle 80-100 deg at contact; hip yaw change >= 40 deg.
- uppercut: 1A's rules + pelvis dip 6-10 cm before the rise.
- all: the non-punching glove stays within 0.15 m of the face through contact; feet planted (1A rule) except the deliberate pivots.

## Step 4 - animation-only export
Each `Godot/assets/anim/metahuman/mh_<move>.glb` holds ONLY the skeleton + one animation (no mesh, no textures, no materials): target
<= 600 KB each. Delete the 1A mesh/texture copies (mh_<move>_mh02_*.jpg/png) from the branch. The probe and the sheets load the clip and
apply it to `res://assets/models/metahuman/mh_boxer_01.glb` (and mh_boxer_02 for the opponent) - so the sheets show two DIFFERENT men.

## Step 5 - sheets for Claude
Same 12-frame side + front sheets as 1A to `E:/FightCamp/tmp/animsource1b/`, plus `guard_side.png / guard_front.png / guard_top.png`.
Both men head to feet in frame, plain background. Claude opens them; nothing is sent to the operator until Claude has.

## Owned files
- `Tools/cascadeur/animsource1/**` (scripts), `Tools/cascadeur/README.md`
- `Godot/assets/anim/metahuman/**`
- `Godot/tools/move_shape_probe.gd`
- `research/ANIMSOURCE1B_DIGEST.md` (NEW)

## Gates
- Watchdog before every heavy step: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once` (RED = wait). One
  hidden Cascadeur at a time; stop it when done.
- Parse gate: `python Godot/tools/check_scripts.py Godot/tools/move_shape_probe.gd`.
- Godot by ABSOLUTE path (LOCALAPPDATA is redirected): `C:\Users\user\AppData\Local\Programs\Godot\Godot_v4.7.2-stable_win64.exe`, headless
  for the probe; sheets only through `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 ...` (hidden desktop).
- Final: `MOVE_SHAPE_SUMMARY moves=4 fails=0` on the 1B clips AND the recorded 1A run showing the new gates fail on 1A.
- Commit with `git add -- <files>` on codex/animsource1, push, never merge to master.

## The one trap
A scripted key set can satisfy every number and still look robotic: key the guard first and LOOK at its three sheets before authoring any
move; then author one move, look, fix, then the rest.

## Prior research
ANIMSOURCE1A_DIGEST.md (the pipeline), topics/striking.md (exchange timing), C231_DIGEST.md, S30_THE_PAIRED_POSE.md (pair spacing).
## What would a human do?
A boxing animator first builds a correct guard (stance, knees, blade, hands) as the hub pose, then keys each punch out of and back into it,
checking extension and hip rotation against reference footage.
## Prefab check
Mixamo has a few boxing clips but not on the MetaHuman skeleton and not our certified set; the UE Game Animation Sample is UE-licence only.
Cascadeur (paid, until 2026-10-27) is the chosen source (S207 decision).
## Rules
Nothing opens on the operator's screens: Cascadeur and windowed Godot only on the hidden desktop; no image viewers or browsers.
