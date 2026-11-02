# TASK MH3 - the MetaHuman boxers move as well as the MPFB men (walk polish + certification)

Model: gpt-6-astra, medium (3D animation). Owner: Codex. Worktree `E:/FightCamp/wt/MH3`, branch `codex/mh3-walk` (from master e8d454af).

## Why (operator, verbatim)
S152, on the MH2 live-room video: "the metahuman look better, the walking animation on them needs polishing".
MH2 is merged on master (e8d454af) with `metahuman_bodies` OFF; only `-- metahuman_bodies=1` mounts them. The switch
goes ON in the game the day this task's acceptance passes and the operator OKs the new video.

## The problem (primary source - read these first)
- `research/MH2_DIGEST.md` (197 lines, read whole) and `research/MH1_DIGEST.md` (the pipeline, bone map, traps).
- `previews/mh2/c223_rows.md`: on the four MH bodies the C223 production gate reads 346/356 rows WITH findings
  (join_discontinuity 306, contact_slip_cm 172, target_line 143, peak_fist_band 120, g147_clipping 102, skin_floor_cm 90,
  foot_floor_cm 32 ...). The SAME clips on the MPFB men pass every row of the 22-move certified palette on all four rigs
  (`Godot/assets/data/certified_moves.json`, certificates `docs/previews/c223/s136_*.json`). So the clips are fine:
  the fault is in how the MetaHuman body takes them (retarget / rest fold / scale / root height), and it shows most in
  the stepping the operator calls "walking".
- Code: `Godot/scripts/MetaHumanRig.gd` (~250 lines: `load_fighter`, `fold_intermediate_rests`, `watch_library`,
  `height_of`), `Godot/scripts/FightWorldStage.gd` (~200 lines: `metahuman_bodies`, `model_for_skin`, `mount` MH branch).
- Suspects to MEASURE, not assume (bucket first - memory "bucket a defect by clip first", "measure one body first"):
  (a) `height_of` takes the AABB of EVERY mesh incl. hair/brow cards, so `mount` scales the body by a height that
      includes hair -> legs/arms shorter than the fighter's real height; (b) `watch_library` folds only clips added
      AFTER mount - any clip already in the library, or re-added by the between-part step, may play unfolded ->
      join_discontinuity; (c) foot/toe/ankle mapping and rest (skin_floor / foot_floor); (d) root height lift
      (`rig_profile` metahuman lift_m 0.0).

## Build
1. **Instrument both arms, one body first.** Pick the worst rig (Kelvin/03 per the digest). Run the C223 production gate
   on MPFB (control, switch off) and on MH (`metahuman_bodies=1`) for the 22 certified palette ids only, and print a
   per-finding, per-clip table MH vs MPFB side by side. Then the live-room planted-foot slide:
   `Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/s139_slide_probe.gd -- as_game seeds=92012,94301,17701 seconds=30`
   with and without `metahuman_bodies=1` (cm planted slide per fighter-minute, p95 planted-foot speed). Print achieved
   beside the MPFB number on every line.
2. **Fix the MH side only** (MetaHumanRig.gd, the MH branches of FightWorldStage.gd, Tools/metahuman/* and a GLB rebuild
   if the skeleton/rest itself is wrong). Each fix gets a before/after line on the step-1 table. Never edit a clip,
   `certified_moves.json`, a certificate, FightStagePlayer or the MPFB path: the MPFB arm must stay byte-identical
   (it is the control - prove it: the s139 numbers and the C223 rows of the MPFB arm unchanged vs master).
3. **Video.** 20 s silent live-room MP4 with `as_game metahuman_bodies=1`, seed 92012, through
   `Tools\godot_hidden.ps1` + `tools/record_room.gd` -> `previews/mh3/live_room.mp4`, plus a frame sheet of 12
   frames focused on the feet/legs while stepping (`mh3/steps_sheet.png`). OPEN the sheet with your file tool and say in
   the digest what the feet do (plant, slide, float, sink, knee pop).

## Acceptance (all measured, printed in MH3_DIGEST.md)
- C223 production, `metahuman_bodies=1`, the 22 certified palette ids x 4 MH rigs: rows with findings <= the MPFB arm's
  count on the same ids (MPFB is 0 today) - name every row that still fails with its finding and value.
- s139 planted slide (MH arm) within 15% of the MPFB arm, cm/fighter-min and p95, pooled over the 3 seeds.
- MPFB arm unchanged vs master (control). `mh2_bodies_test` 0 errors both arms; a new `Godot/tests/mh3_walk_test.gd`
  that asserts the step-1 bound and can read worse (show it RED with the old `height_of` / unfolded clip as a mutant).
- Frame sheet opened and described. Switch stays OFF in your branch (Claude flips it after the operator's OK).

## Owned files
`Godot/scripts/MetaHumanRig.gd`, `Godot/scripts/FightWorldStage.gd` (MH branches only), `Tools/metahuman/*`,
`Godot/assets/models/metahuman/mh_boxer_*` (only if a rebuild is the fix), `Godot/tests/mh3_walk_test.gd` (new),
`Godot/tools/mh3_*.gd` (new probes), `previews/mh3/*`, `research/MH3_DIGEST.md` (new).
Big files never read whole: `FightWorldLiveScreen.gd` (5,900+ lines; `_metahuman_bodies` at ~754, skin call ~1155).

## The one trap
A green MH gate with a changed MPFB arm is a failure: the control must not move. And the C223 report's "empty findings"
is not certification of a feeling - open the steps sheet before you call the walk fixed.

## Tier and rules
Parse gate `python Godot/tools/check_scripts.py <touched .gd>` before any test; then the focused tests;
`python Godot/tools/run_tests.py --only fight_world_stage,fighter_physique,fight_world_live,mh2,mh3 --jobs 2`.
C223 through `python Tools/c223_parallel.py production -- <args> report=<x>.json`. Watchdog
(`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once`) before every heavy step: GREEN/AMBER
go, RED waits. One Godot process of yours at a time. Never commit `*.import` or `audio_exports/`. Never open a viewer or
window on the operator's screens (file tool only; renders through `Tools\godot_hidden.ps1`). Never edit HANDOFF.md.
Commit + `git push origin codex/mh3-walk`. Do not stop at a plan: deliver the tables, the fixes and the video.

## Prior research
`python Tools/prior_research.py metahuman walk footwork retarget` -> MH1_DIGEST, MH2_DIGEST, topics/retarget_rig.md,
topics/footwork.md, J18_THE_OTHER_SEVENTY_PERCENT (locomotion cycles), U211_C223_VERDICT (what moves feet inside a
certified window), S139 slide probe. Memory: "measure the posed thing, not the rest box", "a control arm must not share the bug".

## What would a human do?
A character TD retargeting a cast onto a new skeleton compares the new body against the shipped one on the same clips
(foot plant, root height, limb length), fixes the retarget/rest setup until the shipped clips play the same, and only
then swaps the cast in.

## Prefab check
Godot 4.7 has no MetaHuman retarget profile; ibrews/MetaHumanGodot ships only a loader. MH1's bone map + fold are ours -
fix them, do not replace them.
