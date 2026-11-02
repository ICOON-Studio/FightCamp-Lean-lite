# TASK PROFILE2E_FIX5 (S211) - review round 6 of cursor/profile2e (b9cc86be): eye-level headshot, chin in frame, clean hair

Model: Cursor composer-2.5 (local), worktree E:/FightCamp/wt/PROFILE2E, branch cursor/profile2e. First `git merge origin/master`.
Claude opened round 5's `2_profile_overview.jpg` (copy: previews/s211/profile2e_r5_overview.jpg). FIXED: a face is in the box,
PORTRAIT_FACE fails the chest framing (good), the week columns wrap. Still wrong:
1. THE CAMERA LOOKS DOWN from above: we see the crown of the head; the eyes read as closed/looking down. A profile headshot is at EYE
   LEVEL (like a passport / broadcast fighter card): camera height = the eyes' height (head bone + ~0.07 m, or the eye bones if the
   rig has FACIAL_L_Eye / FACIAL_R_Eye), looking horizontally at the face, pitch within +/-5 deg.
2. CHIN CUT: the mouth sits on the bottom edge and the chin is outside. You loosened my chin cap to `74 + aspect*6` (=~83% on this box) -
   put it back: chin <= 72% of the height, head top (hair) between 6% and 14%, so head + neck + top of the shoulders show.
3. HAIR SPECKLE: the hair cards render as grainy dither. Turn on anti-aliasing for the portrait SubViewport (`msaa_3d = MSAA_4X`, and
   `use_taa = true` if still grainy; the viewport is small so the cost is fine) and check hair material transparency mode is not
   alpha-hash without TAA.
## Measurable checks (extend portrait_face_metrics; print them; each must FAIL on b9cc86be first - paste the FAIL lines)
- `pitch_deg` = angle between the camera forward and the horizontal: |pitch| <= 5.
- `top%` 6-14, `chin%` <= 72, head x in the middle 40%.
- Print `PORTRAIT_FACE <athlete> top=.. chin=.. pitch=.. ok=..` for Bruno and Niko in the stills run.
## Then
Re-shoot stills, `python Godot/tools/run_tests.py --jobs 1 --only profile`, digest "round 6", commit, push cursor/profile2e. Never master.

## Prior research / What would a human do? / Prefab check
TASK_PROFILE2E_FIX4.md, PROFILE2E_DIGEST.md. A photographer puts the lens at eye height for a head-and-shoulders shot. No prefab needed.
## Owned files
ProfileStage.gd (portrait camera + metrics + viewport AA), profile2_stills.gd, profile_stage_test.gd, docs/previews/profile2e/, digest.
## Rules + trap
Parse gate; watchdog before each Godot run; windowed only via Tools\godot_hidden.ps1; headless only Godot_v4.7.2-stable_win64.exe (never
_console.exe); no image viewers; never master. TRAP: do not tune limits to pass - move the camera until the numbers pass.
