# TASK CLIPFIX1 - CURSOR (Grok 4.7 High) - the fight's punches that read wrong get a form ruler, then a fix or a cut

Status: OPEN (S438, Claude main). Discipline: boxing. Model: grok-4.7-high.
Source: the operator S437 on the fight's punches: "the fists have no power , are the animationsbad ?" and "whos
verifying the boxing clips ?". Claude filmed the 15 plain fight punches from a fixed side camera and read every one on
33 to 66 ms frames (S437 and S438; rows in ops/AgentComms/clip_verdicts.json, check "Claude's frame read"). Two read as
real punches, twelve carry a named fault, one is unclear from the side.
You cannot see pictures: this task is a RULER first (numbers that agree with the reads below), then fixes the ruler
can prove. Claude films the result and reads it; the operator's eye is the last gate.

## Contract
OWNS: tools/punch_form.gd, tests/punch_form_test.gd, assets/data/punch_form.json, tools/take_fix.gd, scripts/fight3d/BeatClips.gd, tests/beat_clips_test.gd, assets/anim/baked/fixed/, assets/data/clip_contact.json, assets/data/clip_recovery.json, assets/data/clip_travel.json, docs/CLIPFIX1_RESULT.md
RED_TEST: tests/punch_form_test.gd -> PUNCH_FORM failures=0
REGRESSION: beat_clips_test, beat_tally_test, short_punch_test, file_limits_test
VISUAL: ops/previews/lean_anim_side/pro_right_cross.mp4
NOT YOURS: scripts/rules/PunchForm.gd (Qwen's PUNCHFORM1: the pure measures; use its functions, and if it has not
landed on main when you start, write the measures inside tools/punch_form.gd with the same names), scripts/fight3d/FightStage.gd, PunchReach.gd, RkClips.gd, FightClips.gd (read them; if FightClips must learn
the `fixed/` folder, that is ONE added line in its BAKED lookup: say so in the result file and make only that line).

## What the eye read (the ruler must agree with every row, or say why it cannot)
| clip | read | the fault in numbers to find |
|---|---|---|
| pro_left_jab_a | GOOD | control: must pass every bar |
| pro_right_uppercut | GOOD | control: must pass every bar |
| pro_left_jab | fault | hangs at full reach about 0.33 s |
| pro_left_jab_b | fault | hangs at full reach |
| pro_left_jab_c | fault | hangs about 0.26 s |
| pro_right_cross | fault | the lead glove is left out in front, away from the chin |
| pro_right_cross_a | fault | short and bent: the punching arm never straightens, almost no hip turn |
| pro_right_cross_b | fault | short and bent, the same |
| pro_right_cross_c | fault | best reach, but the lead glove drops to chest height while the cross is out |
| pro_left_hook | fault | a straight-arm swing (elbow near straight at the widest point) |
| pro_left_hook_v2 | fault | the glove drops to the hip about 0.2 s first, then a near-straight arm |
| pro_left_uppercut | fault | waits at the thigh about 0.26 s, finishes ABOVE her own head |
| pro_body_shot | fault | a bowed lunge: head past the lead knee |
| pro_kidney_shot | fault | a bowed lunge, about 0.7 s to get back |
| pro_right_hook | unclear | print its numbers; no verdict asked |

## The job
1. THE RULER, red on main. `scripts/rules/PunchForm.gd` (PUNCHFORM1) is pure: it takes sampled joint positions and
   returns the measures. `tools/punch_form.gd` loads each clip the way the fight does (FightClips.load_into on the
   fight's own skeleton; see how tools/clip_contact.gd and tools/clip_travel.gd sample a clip at 60 Hz and reuse that),
   samples shoulder, elbow, wrist of both arms, head, pelvis, both knees, and writes assets/data/punch_form.json plus a
   printed table. Measures, per clip, over the strike window (from 0.4 s before contact_s in clip_contact.json to
   back_s in clip_recovery.json):
   a. ELBOW at peak reach, punching arm, degrees (straight = 180).
   b. HANG: seconds the punching wrist stays within 0.05 m of its peak reach.
   c. OTHER GLOVE: the lowest height of the other wrist relative to the chin (head joint minus 0.10 m), metres, and
      its largest distance from the chin.
   d. PRE-DROP: how far the punching wrist goes below its own shoulder before contact, metres, and for how long it
      stays more than 0.25 m below.
   e. FINISH HEIGHT: the punching wrist's highest point relative to the top of her head.
   f. BOW: how far the head is in front of the lead knee at contact (horizontal, along her facing), metres.
   g. HIP TURN: pelvis yaw change from the start of the strike window to contact, degrees.
   h. BACK: seconds from contact to the wrist back within 0.10 m of its guard position.
   `tests/punch_form_test.gd` holds the bars and prints one PASS / FAIL row per clip and measure. Starting bars
   (from how the punch is thrown; adjust ONLY where a GOOD control fails, and print the change with the reason):
   straights (jab, cross): elbow >= 150, hang <= 0.13 s, other glove no lower than 0.15 m under the chin and no
   further than 0.30 m from it, cross hip turn >= 20; hooks: elbow 75 to 125 at contact, pre-drop no more than 0.25 m
   under the shoulder; uppercuts: finish no higher than the top of her head, pre-drop held <= 0.15 s; body shots:
   bow <= 0.10 m, back <= 0.45 s.
   The test must go RED on main on the twelve faulty rows and stay GREEN on the two controls. A fault the ruler cannot
   see is listed in the result file as "ruler blind", never passed.
2. THE FIX, clip by clip, cheapest first, never by loosening a bar:
   a. CUT: where another plain take of the same punch passes (or can be fixed), take the bad one out of the pool:
      BeatClips.PUNCH variants or OFF_TAKES (a comment with the measure and S438). At least one take per punch stays.
   b. RETIME: a hang is held frames. Write the fixed take to assets/anim/baked/fixed/<same file name>.res with the
      held span shortened to the bar (tools/take_fix.gd is the place; keep its existing six fixes working).
   c. BLEND: the dropped or left-out other glove is blended toward its guard pose over the strike window with 0.10 s
      ramps (take_fix already blends upper-body rotations toward a plain take: reuse it). The hook's elbow and the
      uppercut's finish height the same way only if the result passes the ruler AND contact_s / reach_m stay within
      10 % (re-run the three clip_*.gd measuring tools on every changed take and commit the changed rows).
   d. A clip that cannot reach its bar is cut and named in the result file with its numbers: Claude re-sources it.
3. docs/CLIPFIX1_RESULT.md: the table before and after, per clip: what was done (kept / cut / retimed / blended),
   what stays in each punch's pool, every bar you changed and why, every "ruler blind" row.

## Traps
- ops/research/GDSCRIPT_TRAPS.md first (Variant `:=`, `%%`).
- The plain jab and cross on the default route are often the captured `rk_` takes (BeatClips.punch, RkClips): do not
  touch RkClips; print, for jab and cross, which take the fight plays on the default route so Claude knows which fix
  the player will see.
- A bar only your own function can pass is not a bar (S420). No ease, clamp or offset inside the ruler (S416).
- Do not overwrite a file in assets/anim/baked/: fixed takes go to assets/anim/baked/fixed/.
- Never a windowed Godot: every tool and test here runs headless. If a tool needs a picture, stop and say so.

## Prior research
ops/research/topics/striking.md, ops/research/topics/clips_sources.md, ops/research/HIT_GAP_S437.md,
ops/research/CLIP_SCORES_S390.md, ops/research/S437_DIGEST.md (the CLIPS paragraph).

## What would a human do?
An animator checks a punch against how it is thrown: a straight snaps out and back with the other hand home at the
chin; a hook is a bent arm turned by the hips, never a swing from the hip; an uppercut rises to the chin and stops; a
body shot bends the knees, not the back. Then trims the held frames, pulls the stray hand home, and drops the take
that cannot be saved.

## Prefab check
tools/take_fix.gd (S334) already blends a window toward a plain take; tools/clip_contact.gd, clip_recovery.gd and
clip_travel.gd already sample every take. No outside asset applies.

Every Godot job through the queue: `python ops/Tools/godot_slot.py run --who cursor -- <godot.exe> --headless
--audio-driver Dummy --path . --script res://tests/punch_form_test.gd` (the plain win64 exe, never the console one).
Parse first: `--check-only` on each touched file. Under 500 lines a script.
RESULT lines for the PR body: `RESULT: tests/punch_form_test.gd -> PUNCH_FORM failures=0`.
