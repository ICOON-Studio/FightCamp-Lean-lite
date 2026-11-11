# TASK CAMLINE1 - QWEN (qwen3-coder) - the fight camera: never straight behind one boxer, and the far ropes stop fading and smearing at head height

Status: OPEN (S429, Claude main). Discipline: boxing. Model: qwen3-coder.
Source: the operator, S429, playing the build, on a still of round 1 (the lens directly behind the red boxer, whose back
hides the blue boxer completely; a caption on screen: "Erin made Lucy pay for a habit: slow starter."; the far ropes soft
and half see-through at the height of the heads): "still i see bad camera angles and the fading effect you have on the
background ropes looks weird when fighters head are at the same drawing height".
"Still": the behind-the-boxer rule exists and he keeps seeing it. You cannot see pictures: work from numbers.

## Contract
OWNS: tools/cam_line_probe.gd, tests/cam_line_test.gd, scripts/fight3d/CamLine.gd, scripts/fight3d/RingCamera.gd, scripts/fight3d/TvShot.gd, scripts/fight3d/RingRopes.gd, docs/CAMLINE1_RESULT.md
RED_TEST: tests/cam_line_test.gd -> CAM_LINE failures=0
REGRESSION: ring_lens_test, corner_lens_test, bar_guard_test, promo_shot_test, ring_ropes_entry_test, file_limits_test
VISUAL: yes

## What exists (read first)
- scripts/fight3d/RingCamera.gd (exactly 500 lines: add nothing to it without taking as much out; new code goes in
  scripts/fight3d/CamLine.gd). Its header explains the shots: a cut frames the pair; a held shot rides; BEHIND_CUT_DEG 58,
  BEHIND_HOLD_S 0.25, BEHIND_HARD_DEG 50 are the "lens behind a boxer" rules; `clear_view` fades a rope "in the way";
  the lens has a far depth-of-field blur (dof_blur_far_enabled, transition 2.0, amount 0.22) and a motion blur add-on.
- scripts/fight3d/RingRopes.gd: `segments`, `_fade_side`, each rope piece carries meta "rope" so the camera fades a rope whole.
- scripts/fight3d/BarGuard.gd (S429): lowers the look and raises the lens while a shot holds.
- tools/fight3d_play.gd: plays the REAL fight flow (the game path). tools/ring_lens* probes if any: `ls tools | grep lens`.

## Step 1: the ruler, on the game path (it must read RED on today's main)
tools/cam_line_probe.gd plays at least three real rounds through the same path as tools/fight3d_play.gd (two different
bouts, different opponents: never the same pair twice) and, every 0.1 s of every shot kind (cut, held, close-up, the
caption shots, the corner call), records from the live camera and the two boxers' skeletons:
 a. HIDDEN: the share of one boxer's head-and-chest box (project the head and the two shoulders and the hips to the
    screen) covered by the other boxer's body box. A frame is HIDDEN when either boxer is covered 60% or more.
 b. BEHIND: the angle between the lens-to-pair line and the pair's own line; under 30 degrees = the lens looks along them.
 c. ROPE FADE: for every rope piece whose alpha is under 0.95, whether it is NEARER to the lens than the nearer boxer (a
    rope truly in the way) or FARTHER than both boxers (a background rope: it must never fade), and whether its screen
    height crosses either head box.
 d. ROPE SMEAR: the lens's far blur at the distance of the far ropes (say how you read it from the camera attributes) on
    frames where a far rope's screen height crosses a head box.
Print `CAMLINE shot=<kind> t=<s> hidden=<0..1> behind_deg=<x> faded_far_ropes=<n> far_rope_at_head=<0|1> far_blur=<x>`
for the worst 30 frames, and totals: `CAMLINE1 frames=<n> hidden_share=<x>% longest_hidden_s=<x> behind_share=<x>%
far_rope_fades=<n> shots=<kinds seen>`. If the probe needs a picture to read the camera, run it windowed on the hidden
desktop through the queue (below); say so. A probe that cannot see a shot kind (the caption close-up in the still) is VOID:
name the kinds it saw.
Write the numbers for today's main into docs/CAMLINE1_RESULT.md BEFORE changing anything.

## Step 2: the fix
- No frame of any shot kind stays HIDDEN for more than 0.4 s: when the boxers line up with the lens, the shot slides
  round the pair (the existing slide) or cuts to the side view; a close-up or caption shot picks the side from which both
  faces show. Bars: hidden_share under 2%, longest_hidden_s under 0.4, on the probe's rounds.
- A rope FARTHER than both boxers never fades (far_rope_fades = 0). Only a rope between the lens and a boxer may.
- The far ropes behind the heads are not smeared: either the far blur starts beyond the far ropes or its amount at their
  distance is under a number you measure as "still reads as a rope" (say the number and why); the crowd beyond stays soft.
- tests/cam_line_test.gd pins the pure parts (CamLine: the hidden share from two screen boxes, the side choice, "far rope
  never fades") with boxers that differ in height and stance, and is red on main where it can be.

## Step 3: THE GLOVES' BLUR (the operator's correction, same day: "actually its the gloves that have a weird b;lur effect can yhou check that")
The weird effect he sees is on the GLOVES, most of all when they pass in front of the ropes at head height. The lens has a
motion-blur add-on (RingCamera.gd: MOTION_BLUR, res://addons/godot-motion-blur, "per-object velocity blur ... so fast
punches smear"; `-- noblur` on the command line is the control arm). Measure it before touching it:
- Render the SAME round twice on the hidden desktop, once as the game plays it and once with `noblur`, and save the frames
  of ten punches at their fastest moment (the frame of peak glove speed, from the hand bone's velocity).
- For each, measure the glove's smear in pixels (the width of the glove's coloured blob along its direction of travel,
  blurred frame against the noblur frame) and whether the smear bleeds the glove's colour onto the rope or the face
  behind it. Print `GLOVEBLUR punch=<move> speed_m_s=<x> smear_px=<x> noblur_px=<x> bleeds=<0|1>`.
- Then set the add-on so a glove at full speed smears at most 1.3 times its own width and never leaves a ghost or a
  see-through glove (the add-on's intensity, sample count and any per-object mask: say which setting you changed and the
  numbers before and after). If no setting gets there, turn the blur off for the gloves, or off entirely, and say so.
- Put two pairs of frames (before, after) in docs/mockups/s429/camline1/ for Claude and the operator to see.
This step is the FIRST priority of the task; the rope fade and the behind-the-boxer shots follow.

## Stills (you render, Claude reads them)
`python ops/Tools/godot_slot.py run --who qwen -- python tools/hidden_desktop.py run --timeout=420 <godot.exe> --path .
--windowed --resolution 1920x1080 --audio-driver Dummy --log-file <log> --script res://tools/fight3d_play.gd -- <out_dir>`
(the plain win64 exe, never the console one; nothing on a monitor). Copy four live-round stills to
docs/mockups/s429/camline1/ and print each one's hidden share and the far ropes' alpha.

## Prior research
docs/BARGUARD1 (RingCamera's header, S379 behind rules), ops/research/FIGHT_DISPLAY_DECISION_S419.md, memory: a seat's
test must run the game path (S420), a ruler blind to a shot kind is void (S421), one broadcast camera plus a 1.5 s
close-up on the big shot (CLAUDE.md week 5).

## What would a human do?
A TV director never shows a boxer's back covering the other man: the side-on camera holds the pair in profile, and when
they turn he cuts to the camera that sees both faces. The ropes behind them stay crisp enough to read as ropes; only the
crowd goes soft.

## Prefab check
The slide and cut rules, the rope fade and the lens blur exist. This task measures them on the game path and corrects them.

Rules: no script over 500 lines; no he / she in any script text; parse before testing; headless tests keep working
without a picture. RESULT lines for the PR body: `RESULT: tests/cam_line_test.gd -> CAM_LINE failures=0`,
`RESULT: tools/cam_line_probe.gd -> CAMLINE1 frames=<n> hidden_share=<x>% far_rope_fades=<n>` (before and after).
