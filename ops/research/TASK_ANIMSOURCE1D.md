# TASK ANIMSOURCE1D (S209) - FIX FIRST: the straight punches are broken; re-author them, add gates that SEE it, then finish 1C

Model: Codex gpt-6.1-sol, reasoning HIGH. SAME worktree/branch: E:/FightCamp/wt/ANIMSOURCE1, codex/animsource1 (HEAD 5bcdab2e = 1C batch A WIP,
uncommitted batch B GLBs on disk). Claude stopped the 1C run on purpose to do this first. Cascadeur licence ends 2026-10-27.

## Operator verdict on the 1B cross sheet (S209, verbatim): "the right hand of red fighter does not make any sense the animation is broken"
Claude's read of `E:/FightCamp/tmp/animsource1b/cross_side.png` + `cross_front.png` and 1C `cross_body_front.png`:
1. WRAP-AROUND: at 0.233-0.267 s red's right fist passes BESIDE/BEHIND blue's head (front view: the fist shows on the far side of blue's
   head). The pair stands chest to chest (0.92 m root distance), so a 94%-extended arm cannot land ON the chin - it goes past it.
2. WRONG PATH: the rear arm does not travel in a straight line from the rear shoulder to the target. The elbow flares UP and OUT, the
   upper arm swings across the attacker's own face/neck, and the forearm arrives horizontally - a looping swing, not a cross.
   cross_body (1C) is the same: the arm arrives bent ~90 deg from the side like a hook.
3. BENT ARM AT CONTACT: elbow 141 deg on the cross (1B table), 140 on the jab. A real straight lands with the elbow ~165-178 deg.
   "94% extension" (shoulder-to-wrist / chain length) passed anyway: the gate measured distance, not shape (the S207 lesson again).
4. GUARD HANDS: the receiver's and attacker's gloves touch the other man's head at rest (front sheets) - the pair is too close at guard.

## What to do (in this order; LOOK at your own sheets after each step and describe what you see in the digest)
A. SPACING: compute pair distance from the TARGET, not reach: the attacker's fist at contact must sit 0-3 cm in front of the receiver's
   chin/face surface (head straights) or rib surface (body straights), on the attacker's side of the receiver - never past it. At guard the
   closest points between the two men (gloves, heads, torsos) are >= 0.15 m apart. Typical boxing range for straights: chest-to-chest
   ~1.1-1.3 m for these arm lengths - derive it, do not hardcode.
B. RE-AUTHOR the straights: jab, cross (1B), jab_body, cross_body (1C A), up_jab later. The fist travels a near-straight line from its
   guard position to the target: rear shoulder rotates forward, elbow stays BELOW shoulder height and DOWN/IN until the last third,
   forearm and upper arm align at contact, fist turns palm-down at the end. Cross: hips + shoulders rotate 45-60 deg, rear heel pivots,
   lead hand stays at the face. Body straights: level change with the knees, NOT by bending the arm.
C. NEW GATES in `Godot/tools/move_shape_probe.gd` (must FAIL on the current 1B jab/cross and 1C cross_body - record the FAIL lines):
   - straight_path: every sampled wrist position between chamber (last frame before extension) and contact lies within 6 cm of the
     line from the chamber wrist to the contact wrist (head straights) / 8 cm (body straights).
   - elbow_at_contact >= 165 deg for jab/cross/jab_body/cross_body/up_jab.
   - elbow_height: through extension the elbow never rises more than 5 cm above the same-side shoulder.
   - no_wrap: at contact the punching wrist is on the attacker's side of the receiver's head (or torso) centre plane, 0-3 cm from its
     surface; no frame has the wrist inside the receiver's head/torso capsule or more than 2 cm past it.
   - pair_clearance: at guard frames the closest point between the two bodies >= 0.15 m; on no frame does any attacker joint enter the
     receiver's head or torso capsule (catches wrap-around and interpenetration; must also FAIL the 1B uppercut pairing at 0.50 m).
   - Keep every 1B gate.
D. THEN finish 1C exactly as TASK_ANIMSOURCE1C.md says (batches B-D: hooks, overhand, check_hook, slip/pull/catch, guard_idle,
   reactions) under the full gate set; re-check batch A (uppercuts too) under the new gates and re-author what fails.

## Sheets for Claude
Fresh folder `E:/FightCamp/tmp/animsource1d/`: for every straight, side + front + a TOP view (top view shows the fist path best), plus
a contact-frame close-up (1 image per move) framed on both heads. Claude opens them; nothing goes to the operator before.

## Toolkit (S211)
Every tool, reference and gate you need is listed in `AgentComms/CODEX_TOOLKIT.md` - read it first. Web search is ON for
this run: look up real orthodox boxing guard references before re-authoring the guard; D64_GUARD_STYLES.md s6.1 gives the numbers.

## Owned files, rules, packaging
As TASK_ANIMSOURCE1C.md (animation-only GLBs <= 600 KB, 341 joints; hidden Cascadeur, one at a time; watchdog before heavy steps;
nothing on the operator's screens; push codex/animsource1, never master). NEW `research/ANIMSOURCE1D_DIGEST.md` with the
before/after gate table and what you saw on each sheet. Delete `.local_merge_backup_animsource1c/` only if it is your own scratch.

## The one trap
Every number can pass while the shape is wrong (it just did). Each new gate must first go RED on the clip the operator rejected; a
gate that cannot fail the 1B cross is not a gate.

## E - DO THIS FIRST (before re-shooting any straight: every clip starts/ends in the guard)
Operator S211 on the 1D jab_front sheet (0.500/0.600 s), verbatim: "the right hand of both guys is totally wrong" - the rear glove sits ON TOP
of the forehead, elbow out sideways. It must rest against the rear cheek/jaw, elbow down over the ribs.
### E detail (S211, operator C47 on `animsource1b_guard_side.png`, verbatim): "i can't tell from this angle blues right hand doesnt seem right"
Claude opened it and the 1D jab_front sheet (10:28): BOTH men hold a "salute" guard - gloves ABOVE the forehead, elbows flared out at
shoulder height (move_shape.json guard_start lead_above_shoulder_m = 0.184). A boxing guard: gloves at cheekbone/jaw height, 10-25 cm in
front of the face, rear glove touching the jaw/cheek, elbows DOWN and IN covering the ribs, chin tucked behind the lead shoulder.
1. Re-author the shared guard pose (guard_pose / guard_idle and the first+last frame of EVERY clip) to that shape; all clips re-keyed to it.
2. NEW gate `guard_shape` in move_shape_probe.gd (must go RED on the current 1D guard first - record the FAIL line): at guard frames
   each glove top <= brow height and >= chin height; lead glove 0.10-0.25 m in front of the face plane; rear glove <= 0.08 m from the jaw;
   each elbow >= 0.12 m BELOW its shoulder and <= 0.12 m outside the torso side (tucked); forearms within 35 deg of vertical.
3. Sheets: a guard FRONT + SIDE + 3/4 still of both men in `E:/FightCamp/tmp/animsource1d/guard_*.png`, plus every straight re-shot.

## F - GLOVES IN THE LAB (S211, do this BEFORE more hooks). Operator, verbatim: "why the fighters do not wear gloves ?"
Board Q-S210-2 answered "OK - keep this guard" - the cheek guard is the approved base. But every 1D sheet shows BARE fists, and every
contact/clearance number is measured at the knuckles (fist surface gap 1.5 cm). In the game the boxers wear gloves (CCFighterSkin.gd
`mount_procedural_gloves`, skinned glove `_skin_glove`, world-space surface points `drawn_glove_points(side)`); a 10-16 oz glove adds
several cm of padding around the fist - a punch tuned to land 1.5 cm from the chin at the knuckles sinks deep into the face with a glove on,
and the cheek-guard gloves may sit inside the head.
1. Mount the GAME's boxing gloves on both men in move_shape_probe.gd / the sheet renderer exactly as the live fight does (same CCFighterSkin
   path, same glove style for boxing) - every sheet and still shows gloves from now on.
2. Re-measure with the GLOVE surface (drawn_glove_points) instead of the knuckle landmark: contact = glove surface 0-2 cm from the chin /
   rib surface, never inside the head/torso capsule; guard_shape: gloves at cheek/jaw height and NOT intersecting the own or the other
   man's head (glove-to-face gap >= 0 cm, glove-to-own-cheek <= 3 cm); pair_clearance at guard >= 15 cm between gloves and the other man.
   Keep every other limit. The new glove checks must first be run on the current accepted straights and the guard: report honestly which fail.
3. Re-author what fails (usually the pair distance grows by the glove depth, or the target point moves back) - guard, jab, cross, jab_body,
   cross_body - then continue with the hooks/overhand on gloves. Sheets: guard front/side/3-4 and every straight, WITH gloves.
