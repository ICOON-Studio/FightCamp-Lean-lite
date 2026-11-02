# C214 - an ordinary leg kick stays upright

Branch: `codex/c214-leg-reaction`. Claude merges. No master merge; no HANDOFF/status/archive edits.

## Delivered

`react_leg` now uses **H2H_StaggerSmall01, 0.40-1.00 s (0.60 s)**: the recovery-step hitch, omitting the opening head snap. The foot unloads and replants; the man stays upright and returns to guard. Same `T_pose.fbx`, silhouette corrections and `retarget: true` as the previous binding.

**Step 2b fallback is intentional.** `FightReactionSide.choose` filters direction and cycles an unweighted array; it has no band weights. Ship light + heavy, as authorized, rather than claim the J57 odds were implemented. Light for FINE/HURT/unknown; original StaggerLarge04_LowHit 8.83-11.53 s only for CRITICAL/DOCTOR. Medium recommendation: **StaggerMedium04, 5.30-6.80 s, 1.50 s** (upright stumble/rebalance). No simulation randomness or second binding system was added.

`FightStagePlayer` reads the owning room's presented `limb_read().chips`, which exposes `_chips_shown`. It does not read future engine damage. Queue pricing and playback select the same variant. Because `play_role` has no struck-leg field, either critical leg qualifies; unknown/non-live contexts remain light. Other reaction roles retain their directional selection.

## Audition (all sheets in docs/previews/c214)

Times below are the complete active take, not padded FBX timeline duration. v1 idle prefixes were removed for comparison. Every candidate stays upright; none of these is the original heavy collapse.

| Take | Active source span | Back in stance | Weight off a leg / judgement |
|---|---|---|---|
| StaggerSmall01 | 0.00-1.00 | 1.00 s | Clear recovery step, but opening head snap; chosen recovery window 0.40-1.00 |
| StaggerMedium01 / _v1 | 0.00-1.77 | 1.77 s | Large lift and turning stumble; too long |
| StaggerMedium02 / _v1 | 1.90-3.63 | 1.73 s | Rebalance steps with backward upper-body snap; too long |
| StaggerMedium03 | 3.67-5.27 | 1.60 s | Sideways folded stumble; just above medium ceiling |
| StaggerMedium04 / _v1 | 5.30-6.80 | 1.50 s | Turning stumble with unloaded foot; medium candidate |
| HitReaction01 | 2.47-3.03 | 0.57 s | Mainly head/back flinch; weak leg signal |
| HitReaction02 | 3.07-4.00 | 0.93 s | Mostly torso/shoulder flinch; weak leg signal |
| HitReaction03 / _v1 | 4.03-4.87 | 0.83 s | Foot hitch but pronounced backward head snap |
| HitReaction04 | 4.90-5.80 | 0.90 s | Forward torso dip with foot adjustment; above light ceiling |

The Small01 hitch source travels 0.4403 m net (0.4527 m maximum). `sway_of.returns=false`, so the existing receiver carry rule suppresses horizontal travel. **Retargeted root XZ excursion: 0.0000 m**, measured across all position keys. No new carry exception. Medium sources also travel and fail the return rule. Audition geometry and source/retarget measurements are in `audition.json`.

## Production evidence

`tools/c214_render.gd` uses the production FightWorldLive room, S97 seed **97102**, generator fighters and S97 game-distance camera. All windowed executions used `Tools/godot_hidden.ps1`.

- `ordinary_contact_sheet.jpg`: natural landed leg kick at **6.025 s**, receiver B, both legs FINE; plays `react_leg`, stays on his feet.
- `small_reaction_5s.mp4`: 150 actual production frames at 30 fps, **5.000 s**.
- `critical_contact_sheet.jpg` and `critical_reaction_5s.mp4`: natural landed kick at **22.425 s**, receiver A, plays `react_leg#1`; existing heavy collapse and recovery visible.
- **Staging disclosed:** after the first capture, at 10.992 s, both fighters' left-leg condition is set to 30. The fight then continues normally; the renderer waits for an actual critical-leg reaction. This is not a claim that the seed naturally accumulated that damage.
- Eight executable checks in the render tool passed: FINE/HURT/CRITICAL/DOCTOR for both receivers, queue and actual playback agreement, and no band leaking onto the other receiver. `production.txt` records witnesses.

Reproduce: parse the touched scripts, then run each `tools/c214_audition.gd` / `tools/c214_render.gd` through the hidden launcher; production uses `--fixed-fps 30`. Production frame sequences go to `%TEMP%/c214_render/`. Encode `ordinary_%03d.png` / `critical_%03d.png` at 30 fps with libx264/yuv420p. The installed imageio_ffmpeg binary was used because the PATH ffmpeg symlink did not launch.

## Gates

- Parse: `CHECK total=4 fails=0 autoload_refs=0 autoload_warnings=0`.
- Requested ceiling: `python Godot/tools/run_tests.py --jobs 2 --only fight_clip,fight_stage,fight_reaction,corner_` -> **SUITE total=29 fails=3**.
- Re-ran the three failures with both owned production files restored to `origin/master` **e25700fc**, then restored C214 bytes in a `finally` block: **SUITE total=3 fails=3**, same failing assertions/rules. No new failing test relative to master.
- Evidence integrity: shared temporary presenter log was overwritten by another run; repeated that one candidate test with C214-specific TEMP/TMP, `SUITE total=1 fails=1`. All three saved candidate/master failure-line sets now match exactly.
- Existing failures: presenter contract and technique fidelity each require a clipless degradation that now occurs zero times; realism fails R1/R2/R3/R4/R5/R5b/R7/R8 on master too. Candidate/master logs and suite summaries are in the preview directory.
- Hidden production render: exit 0, eight band/playback assertions passed, no script errors. FBX loader emits existing `Reading less data than requested` warnings; ObjectDB leak warnings also remain.
- Both MP4s decoded: **150 frames, 30 fps, 5.000 s, 1280x720**. Sheets inspected at source and production camera distances.
- `git diff --check` passed.

## Scope

Only binding, player variant pick, C214 tools, previews and this digest are owned. Existing unrelated untracked import/UID files were left alone. Task branch instructions override the general master workflow and HANDOFF rule. No full suite, no fight_world_live_test, no changes to gameplay damage or reaction odds.
