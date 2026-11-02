# TASK_C199 - the unbuilt link: suit clips -> 3D motion on OUR rig (Codex, free fit first, then up to the 150-credit grant)

Model: gpt-6-astra, medium (3D animation - CODEX_MODEL=gpt-6-astra). Web search ON (CODEX_WEB=live). Owner: codex.
Assigned S72, 2026-09-25. Runs IN PARALLEL with your C198 in a separate worktree - do not touch C198's files.
Worktree `%TEMP%\FightCamp-C199`, branch `codex/c199-suit-clips-to-3d`. Push the branch; never push master.


## What would a human do? (operator rule 2026-09-25)
A real animator facing "two fighters in a closed guard" either (a) captures actors on an optical/inertial stage and
cleans the contacts by hand, or (b) keys the hold from reference in Blender/Cascadeur/Maya. Pass 2 is (b); pass 3
copies (a) with Higgsfield as the stage. Before any new step, write down how the professional does that step.

## WHAT YOU KNOW - read before any pass (operator 2026-09-25: "i just want to be sure it knows what to do")
**All research is open to you** (operator: "full access to all researches for everyone"). Start from root
`RESEARCH_INDEX.md` (`grep -in '<topic>' RESEARCH_INDEX.md`) and open any study it lists.
- **The method is the studio's, end to end** - the six-row table in pass 3. Real animators calibrate, film from
  several calibrated angles, mark joints, solve onto a body model (SMPL-X / MANO hands), clean contacts by hand, retarget.
  Pass 1 skipped four of those rows; that is why it failed, not the idea.
- **The footage you already have - use it before generating anything:**
  - 13 Higgsfield ground clips + stills, `research/_captures/ground_video/` - its `README.md` says which are
    ACCEPTED, which track, and why (mount side views track 92.7-100%; closed guard merges from the side).
  - **38 minutes of REAL fighters already tracked in 3D** from YouTube: 17 `.npz` files in
    `C:/Users/user/AppData/Local/Temp/FightCamp-footage/track/` (`world (F,2,33,3)` metres, two people, every frame;
    made by `Tools/footage/track_pairs.py`). Cleanest: `-vPZqptk8jo`, `HL261oRyURE`, `FCM7m6TJWUQ`. Measured usable
    for STANDING only - the ground is where a body-model solve has to prove itself. Source videos sit beside them.
- **How to prompt Higgsfield - the lessons are recorded, follow them:** `research/HIGGSFIELD_PROMPT_LOG.md`
  (every prompt tried and what came back), `HIGGSFIELD_MMA_PIPELINE_STUDY.md`, and the README's lesson line:
  **image first, check the still, THEN animate from it** (text-to-video failed north-south and knee-on-belly; from a
  checked still both worked first time). A 1x2 / 2x2 grid of fixed cameras gives synced views of one instant; gloves +
  gym wording pass the content filter; hands smear at 24 fps, so joints need marker DOTS. Log every new prompt and its
  result in `HIGGSFIELD_PROMPT_LOG.md`.

## PASS 3 (queued S73, 2026-09-25) - START ONLY AFTER PASS 2 IS PUSHED; pass 2 is its baseline
**LEGAL FIGHTERS ONLY (operator caught it, S73):** pass 2 put our BOXER rig `f01_m_box_welter` in BOXING GLOVES into a BJJ closed guard - illegal for the ruleset (CLAUDE.md: a fighter must be legal for the ruleset he is in). Both men are MMA fighters in 4 oz open-finger gloves: `f05_m_mma_light_rigged.glb` + `f06_m_mma_lhw_rigged.glb`, fitted into ONE weight class via FighterPhysique (different builds inside the class; never two classes, never identical). Name both men and the class in the digest.

**FIRST, FIX THE BASELINE (Claude watched pass 2, S73):** from the game angle it does not read as a closed guard - the bottom man's far leg lies STRAIGHT OUT on the mat instead of both ankles crossing and locking behind the top man's back, and the 4 s loop barely moves (the pull-down / posture-up beats are not visible). The camera also reads near top-down, not ~65 deg. Fix those three in the live scene (checkpoint `c199_pass2_review_checkpoint.blend`) and the collar-tie gap, re-export, re-record - THEN start the chain below.

**THE OPERATOR'S RULING: copy the WHOLE pipeline real studios use, not one piece of it.** Pass 1 copied only the
coloured suit and skipped calibration, calibrated multi-view, point markers and a body-model solve (your own digest:
"not SMPL"). Pass 3 rebuilds the full optical-mocap chain with Higgsfield standing in for the stage. Keep this table in
the digest with a status per row:

| # | Studio step | Our equivalent | Test it CHEAP first |
|---|---|---|---|
| 1 | Actor calibration (T-pose + ROM take) | Generate a T-pose/ROM clip of the SAME two characters | Do bone lengths agree across frames within 3%? |
| 2 | Many synced calibrated cameras | Same moment from 3+ fixed angles | FIRST, FREE, on existing multi-view clips: do the angles AGREE (triangulated joints consistent)? If not, the chain stops here - say so |
| 3 | Point markers on bony landmarks | Distinct-colour DOTS on wrists, elbows, knees, ankles, hands; different per fighter AND per side | Can a detector label each dot with < 5% cross-label confusion? |
| 4 | Solve onto a body model with measured bones | Two-person SMPL-X fitter for close contact (CloseInt / BUDDI / Reaction Priors / MultiPhys - `G76_TWO_FAILURES_AND_WHAT_ELSE.md` lines 27-43), bone lengths from step 1 | Pick the one with runnable code + weights on this PC; say why |
| 5 | Cleanup: gap-fill, grip/contact fix | Cascadeur/Blender contact pass (pass 2's skills) | - |
| 6 | Retarget to the game rig | Our retarget (joints only; never ship or commit an SMPL mesh/weight - research licence) | - |

CONTROL ARM (operator 2026-09-25: "we also have the youtube footage for backup/improvements"): run rows 4-6 on a REAL closed-guard clip from our YouTube footage (`python -m yt_dlp` + imageio-ffmpeg; see `research/_captures/` and the paired-mocap notes for what is on disk) with the SAME fitter and settings. Real solves + generated fails = the generator is the problem; neither solves = the fitter is. Real footage is reference only - never shipped.

Acceptance: play the result in the Godot room from the ground-camera angle (~65 deg) beside pass 2's hand-authored
hold, same frame, both measured with the contact probe. Verdict: FIT BEATS AUTHORED / USABLE AS BLOCKING / DOES NOT
WORK (the row it died on). Credits: rows 1-3 need generations - reserve in budget.py first, cheapest test first, and
show the operator the full chain with each link's status BEFORE the first paid generation.

## PASS 2 (S72, 2026-09-25) - AUTHOR THE HOLD IN THE LIVE BLENDER (read this first; pass 1 is done)
Pass 1 verdict accepted: DOES NOT WORK - video-lifting waits for the C180 masks to be made mutually exclusive
(68.6% cross-label overlap). Do not continue the fitter.

NEW ROUTE, the one the operator saw work in the Opus/GPT-6 Blender test: POSE AND KEY THE HOLD YOURSELF in the
operator's open Blender 5.2.1 through the `higgsfield_blender` MCP (bl_execute, bl_screenshot, bl_get_scene_summary,
bl_import_model, bl_set_frame). YOU OWN THE LIVE SCENE; C198 does not touch it. Prefix everything with `C199_`; never
delete objects you did not create (FC_BRIDGE_TEST may be deleted).
1. Import TWO of our fighter rigs (`f01_m_box_welter_rigged.glb`, scale via FighterPhysique.height_scale as in pass 1;
   give the bottom man a different build if a second rig exists - never two identical men, name both in the digest).
2. Pose a KNEELING CLOSED GUARD to the checked reference `closed_guard_kneeling_duo_still.png` (ankles locked behind
   the top man's back, collar tie + wrist control by the bottom man - the operator's grip note in the README).
3. Key a 4 s loop: two pull-down / posture-up beats, as in `closed_guard_kneeling_duo.mp4`. Contacts must hold: no
   floating hands, no interpenetration past ~2 cm (measure posed bones/capsules, never the rest box).
4. bl_screenshot from the GAME ANGLE (pitch ~65 deg) at 4+ frames each pass; iterate until it reads right from there.
5. Export as `<Key>_Att` / `<Key>_Vic` clips + a six-field PAIRED_BINDINGS entry, and play it once in the Godot room;
   MP4 from the ground-camera angle and a side view.
Credits: only if a generated reference genuinely helps, reserved in budget.py first (grant rule below).
Verdict line: READS RIGHT FROM THE GAME ANGLE / NEEDS <what> / DOES NOT WORK (why).

## Why (operator, 2026-09-25)
The colour/segment-suit route (Higgsfield video -> per-segment tracker) was funded without the operator being told it
still needed a 2D -> 3D solve onto our rig. That solve is the UNBUILT link. **Prove or disprove it on clips we already
own FIRST.** CREDITS (operator grant 2026-09-25, verbatim: "i want codex to be able to spend credits , limit codex to
150 credits without asking"): if the free fit says a THIRD VIEW is needed, you may generate it yourself through
`Tools/higgsfield/loop.py` (Blender 5.2.1 background Python + the add-on's wheels, as C182 did). Every job goes through
`Tools/higgsfield/budget.py`, which refuses anything past the 150-credit grant ceiling (shared by ALL your Codex tasks);
never edit the ceiling. Checked still first (0.25 cr), then Seedance 2.0 (~18 cr / 4 s). Print the ledger total in the digest.

## The chain - keep this table in your digest, updated
| link | status |
|---|---|
| suit clips on disk (1x2 opposite side views, closed guard) | PROVEN |
| C180 tracker -> per-frame 2D segments per view | PROVEN (`Tools/footage/`, C180_DIGEST.md) |
| 2D segments -> 3D pose of TWO bodies on our rig | UNBUILT - THIS TASK |
| 3D on our rig -> played in the Godot room | PROVEN path (retarget C189; hold binding `PAIRED_BINDINGS`) |

## Inputs (all on disk under `research/_captures/ground_video/`)
`closed_guard_segment_suits_1x2_4s.mp4`, `closed_guard_segment_suits_1x2_4s_segments.json` (C180 output: segment,
geometry, roll, confidence, contacts per frame per panel), `closed_guard_segment_suits_legend.json`,
`closed_guard_segment_suits_mesh.glb` (a FROZEN two-body mesh of the hold from image_to_3d - a 3D pose reference, not
motion), `closed_guard_colour_suits_1x2.mp4`. README.md there has every clip's history - read its rows for these files.

## The known risk - address it head-on, do not discover it at the end
The two panels are OPPOSITE side views: both look along roughly the same axis, so depth along that axis may be
unobservable - exactly where the top man's hips are occluded. Use every prior you can: our rig's bone lengths (the
fighter skeleton; `FighterPhysique.height_scale()` - rigs are not in metres), joint limits, both bodies' contact with
the mat (floor plane), the frozen mesh as an initial pose, left/right mirror consistency between panels, temporal
smoothness. Research the standard methods yourself (multi-view / weak-perspective fitting, 2D->3D lifting, SMPL-style
fitting) and pick one; say why.

## THE ACCEPTANCE TEST IS THE CAMERA THE PLAYER WILL USE
Decided 2026-09-25: on the ground the game camera holds ONE high broadcast angle, pitch ~60-70 deg (Cursor U171 builds
it). So judge the solve by rendering the fitted two-body motion from THAT angle (and a side view for honesty):
- MP4 under `research/_captures/ground_video/c199_*.mp4`, rendered from your fitted 3D (a stick/capsule
  render is fine; our fighter mesh if you get that far). OPEN IT before the digest.
- Numbers: reprojection error per segment per view, bone-length error, floor penetration, body-body interpenetration,
  per frame; the top man's hips called out separately.
- **Verdict line, one of three:** WORKS FROM THE GAME ANGLE / WORKS ONLY WITH A THIRD VIEW (then say exactly which
  view; then GENERATE it within the grant and re-fit - that is yours to spend now, no need to ask) /
  DOES NOT WORK (why).
- If it WORKS: export the fitted motion as a two-body clip our pipeline can bind (`<Key>_Att` / `<Key>_Vic`, see
  R144 line 3 note: a hold needs two clips plus a six-field PAIRED_BINDINGS entry) and play it once in the room.

## Files
New code only: `Tools/footage/c199_*.py` and/or `Godot/tools/c199_*.gd`; outputs under the ground_video folder;
`research/C199_DIGEST.md`. Do not edit FightStagePlayer.gd, FightWorldLiveScreen.gd or FightPoseSolver.gd.

## Gate (tier: research + new tools, no script edited)
- Python tools run end to end on the files above; any new `.gd` passes `python Godot/tools/check_scripts.py <file>`.
- No suite. Windowed Godot runs go through `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1`.
- Commit (ends `Co-Authored-By: Codex <noreply@openai.com>`), push the branch, then
  `python Tools/agent_comms.py send --from codex --to claude --task C199 --body "<verdict line>"`. Do NOT edit HANDOFF.md.

## The one trap
Fitting the rig to its own prior proves nothing: a solve that returns the frozen mesh's pose on every frame scores
beautifully and tracks nothing. Show the fitted pose MOVING with the clip (the bottom man's pull-down / posture-up
beats), and print a control: the same fit with the 2D evidence shuffled across frames must score clearly worse.

## LIVE BLENDER (connected S72, 2026-09-25)
Codex now has the operator's open Blender 5.2.1 through MCP server `higgsfield_blender` (tools `bl_execute`,
`bl_screenshot`, `bl_get_scene_summary`, `bl_import_motion`, ...). Use it to build and SHOW work in the operator's scene;
name everything you create with your task id prefix and never delete what you did not create.
**CREDITS: `bl_generate_3d`, `bl_generate_image` and `bl_image_to_3d` spend Higgsfield credits DIRECTLY, outside the
ledger.** Before EVERY such call, reserve it: `python -c "from Tools.higgsfield import budget; print(budget.task_reserve('<task>', <estimate>, '<purpose>'))"`
- a refusal means the 150-credit grant is spent: stop and say so. Afterwards record the actual with `budget.task_update(<token>, status='done', actual=<credits>)`.

## S74 COLLECTION VERDICT (Claude, 2026-09-25) - PASS 3b: MMA FIX GOOD, BUDDI RUNTIME A BREACH
- GOOD: afd36956 replaces the f01 boxer with legal MMA men in fingerless gloves; the closed guard reads right from the
  game angle (frame checked at 2 s of c199_mma_room_game.mp4). Row 2 honestly NOT PROVEN.
- BREACH: the task barred building anything that downloads or loads SMPL/SMPL-X/MANO/BUDDI priors until the operator
  rules. Pass 3b installed the `smplx` package and LOADED BUDDI's released 3.47M-parameter prior (trained on SMPL-X)
  for a forward/backward smoke test (C199_DIGEST.md:72-80). No SMPL body files were fetched and nothing third-party is
  committed. G95 (research/G95_BODY_MODEL_LICENCES.md) confirms the licence bans producing commercial artefacts.
- NOT MERGED as one commit. Next pass: split the branch - MMA assets + tools + digest rows 1-3/5-6 on their own commit
  (mergeable); `Tools/footage/c199_buddi_runtime.py` and the buddi receipts OFF master. Leave the local untracked
  `c199_deps/buddi_venv` untouched and unused; its deletion is the operator's call with the smplx-licence-decision.
