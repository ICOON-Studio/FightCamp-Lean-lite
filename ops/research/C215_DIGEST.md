# C215 - footwork that is seen

Branch: `codex/c215-footwork-seen`. Owner: codex.

## Change

U183's nine `boxing_*` rows still bind to `idle`; no Walk/Run/Dodge clip was restored. `footwork_clip_role_for()` still exposes that clearance-safe base. The action-family resolver no longer advertises the base idle as an authored movement performance, so real movement beats reach the room's carried/stanced path without violating the presenter's named-clip contract.

After a standing boxing-footwork beat, `FightStagePlayer` uses a small shuffle underneath eligible standing actions. Actual root displacement and changes in facing move the foot targets. One ball of the foot remains planted in world space while the other transfers, with a 3.5 cm lift. Below the displacement threshold both feet stay planted. Kicks, pairs and whole-strike presentation retain their existing exclusions. Final room root correction re-seats the same targets without advancing their clock; grounding remains after the leg solve. No simulation or RNG changes.

## Real seeded preview

`previews/c215/footwork.mp4`: H.264, 1280x720, 30 fps, **150 frames / 5.00 seconds**. Production `FightWorldLive.tscn`, default f01 fighters, boxing seed 94301. The harness advances the real bout for 94 frames until carried footwork occurs, then records five seconds. No synthetic beat is injected. Reviewed the delivered MP4's ten-frame contact sheet and full-resolution capture.

`tools/c215_record.gd` exits nonzero unless actual steps and both carried/stanced beats occur, and clearance/plant assertions pass. `measurement.json` retains frame-level joint samples; `summary.json` contains the result:

| Measurement | Result | Bound |
|---|---:|---:|
| Presentation counts | 9 beats: 6 played, 1 carried, 2 stanced, 0 degraded | carried and stanced > 0 |
| Shuffle body-frames | 106 | > 15 |
| Idle shuffle body-frames | 111 | > 20 |
| Foot/toe vertical range during idle shuffle | 0.035286 m | <= 0.10 m |
| Knee vertical range during idle shuffle | 0.051603 m | <= 0.12 m |
| Worst planted ball-of-foot target error | 0.003865 m | < 0.01 m |
| Worst toe depth below grounding plane | < 0.000001 m | < 0.001 m |

Clearance ranges describe the recorded idle-footwork frames, not unrelated strike/reaction knee motion. This is one seeded five-second visual sample, not an all-bout animation-quality claim. The existing realism test remains an integration limitation, detailed below.

## Gates

- Parse: `CHECK total=3 fails=0 autoload_refs=0 autoload_warnings=0` for both production scripts and the capture harness.
- Render assertions: `C215_FOOTWORK_GATE ... passed: true`.
- Unmodified master, exact permitted tier: `SUITE total=21 fails=2` (`fight_world_live_test`, `fight_stage_realism_test`). Live room: 24 checks, 4 failures; realism: 13 checks, 8 failures. Baseline realism evidence: `docs/previews/c215/baseline_realism.txt`.
- Final committed implementation, exact same tier: **`SUITE total=21 fails=1`**. `fight_world_live_test`: **24 checks, 0 failures**. `boxing_footwork_clearance_test`: **32 checks, 0 failures**, including its high-clearance Dodge mutant rejection.
- The sole remaining failed test is `fight_stage_realism_test`: **13 checks, 8 failures**, the same eight rule assertions as unmodified master. Its toe-floor rule passes, with zero frames below its clearance bound. This meets the task's no-additional-test-failures gate; it does not make the existing whole-bout realism suite green. See `final_realism.txt` and `gates.json` beside the preview.
- No final failure was attributed to missing `res://.godot/imported` assets. Existing FBX short-read warnings remain; they did not prevent the recorded assertions or runner checks.

## Reproduce

```powershell
python Godot/tools/check_scripts.py Godot/scripts/FightClipBinding.gd Godot/scripts/FightStagePlayer.gd Godot/tools/c215_record.gd
python Godot/tools/run_tests.py --jobs 2 --only fight_world_live,boxing_footwork,fight_stage,fight_clip
powershell -NoProfile -ExecutionPolicy Bypass -File Tools/godot_hidden.ps1 --path Godot --script tools/c215_record.gd
$c215Ffmpeg = python -c "import imageio_ffmpeg; print(imageio_ffmpeg.get_ffmpeg_exe())"
& $c215Ffmpeg -y -framerate 30 -i previews/c215/frame_%04d.png -c:v libx264 -crf 20 -pix_fmt yuv420p -movflags +faststart previews/c215/footwork.mp4
```

## Scope

Only owned production files, C215 harness, preview evidence and this digest changed. Tests were not weakened or edited. The task's self-contained intake replaced the general mailbox intake; its MP4 requirement superseded the general still-preview convention (a JPG is also supplied). No full suite. HANDOFF.md, CURRENT_STATUS.md and HANDOFF_ARCHIVE.md were not read or edited. Commits were pushed throughout; Claude integrates this branch.
