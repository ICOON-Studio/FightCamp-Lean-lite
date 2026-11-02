# MH2 - MetaHuman demo boxers

S144 resume, 2026-10-02 through 2026-10-03. Worktree `E:/FightCamp/wt/MH2`, branch
`codex/mh2-metahuman-boxers`; baseline `568089a5`. Push destination is exclusively
`HEAD:codex/mh2-metahuman-boxers-wip-s143`.

Four distinct male MetaHumans are wired into the game, and the reviewed 20-second live-room
video shows the corrected models. Asset, body, probe and switch-OFF regression gates pass.
C223 is fully measured and reported, but exposes mechanical failures: these bodies are NOT
fully motion-certified. The final performance comparison is complete: 16.56 ms MH versus 12.58 ms MPFB.

## Implementation and assets

`metahuman_bodies` follows the game's demo-switch default: ON in the game, OFF for `--script`
unless explicitly enabled. Male selection hashes athlete ID into four models; the second corner
excludes the first corner's model. Women retain their existing bodies. `MetaHumanRig` mounts,
folds intermediate rests for production animation, dresses trunks and attaches the existing
procedural boxing-glove overlay. MH1's explicit probe/fold path is preserved.

| Model | Preset / groom | Requested height / chest / waist cm | Bytes | Joints |
|---|---|---|---:|---:|
| 01 | Victor / Hair_S_BrushCut | 183 / 106 / 80 | 5,214,140 | 341 |
| 02 | Isaiah / Hair_S_360Waves | 174 / 94 / 74 | 2,743,008 | 341 |
| 03 | Kelvin / Hair_S_CurlyFade | 179 / 101 / 78 | 4,454,116 | 341 |
| 04 | Bruce / Hair_S_Casual | 190 / 118 / 96 | 4,274,904 | 341 |

Files: `Godot/assets/models/metahuman/mh_boxer_0{1..4}.glb`, with individual JSON receipts.
All are distinct and below 6,000,000 bytes. [Final asset hashes](../docs/previews/mh2/final_assets.json)
were checked against the delivered files. Probe extents include hair and are not anatomical heights.
Isaiah's source groom supplies a baked scalp texture rather than hair-card geometry; his eyebrow
cards remain. No substitute groom was invented. Head/body geometry shares one mesh so the
production capsule collector includes head vertices.

The first recording exposed floating hair on Kelvin and Bruce. Epic's groom binding assets name
`SKM_Groom_Head_Legacy02`; correcting their configurations and rebuilding only those two GLBs from
existing exports fixed it. No UE spawn was repeated during S144. Parameterized tools/configurations
are under `Tools/metahuman/`, including `mh2_boxer_01.json` through `mh2_boxer_04.json`; MH1 pass-2
scripts remain unchanged. Source/licence record: [MH1 digest](MH1_DIGEST.md).

## Outfit safety and gates

The completed UE runtime receipts verify `set_single_slot_selection("Outfits", empty key)` clears
both InternalCollection and PreviewCollection immediately before spawn. All four reports contain
empty selected outfits, successful Body/Face exports and no Python exception; commandlets exited 0.
The guard also clears cached assembly output. No default garment / 8192 clothing build appears in
those logs. Reports: `E:/FightCamp/metahuman_pilot/mh2/boxer_0N/export/build_report.json`; commandlet
logs: `E:/FightCamp/metahuman_pilot/logs/mh2_ue_N_stdout.txt`. S144 reused this completed evidence.

| Gate | Result / evidence |
|---|---|
| Parse (six touched GDScript files) | `CHECK total=6 fails=0 autoload_refs=0 autoload_warnings=0` |
| Four load/bind probes | 341 bones each, `mapped_missing=[]`, `errors=0`, engine rc=0; [probes.json](../docs/previews/mh2/probes.json) |
| Body / overlay checks | `MH2_BODIES errors=0`; original unchanged 01/02 retained, final rebuilt 03/04 rerun individually |
| Switch OFF vs master baseline | Both `SUITE total=2 fails=0`, same results; [off_comparison.json](../docs/previews/mh2/off_comparison.json) |
| Final asset audit | Four SHA256 hashes match, each 341 joints and below 6 MB |
| C223 completeness | 356 unique measured rows + 44 unavailable candidates = 400 candidate/rig combinations |

The requested substring `fight_world_stage,fighter_physique,fight_world_live` selects two tests in
this checkout. The runner used `--jobs 2`, with actual engine children serialized by the adapter.
The baseline comparison is against `568089a5`, not a moving current master. Existing test outcomes
match; timing-bearing console logs are not claimed byte-identical. The old all-body checkpoint log
predates the groom correction; final 03/04 evidence is `body_03_final.txt`, `body_04_final.txt` and
[resume_checks.json](../docs/previews/mh2/resume_checks.json). Kelvin's success marker is explicit;
its PowerShell wrapper also surfaced native stderr warnings, so that wrapper's nonzero status is
not represented as an engine rc=0 receipt. Rebuilt assets were imported before their final checks.
No full suite was run; it is outside this task's tiered gate allowance.

## Reviewed fight video

[Live room MP4](../docs/previews/mh2/live_room.mp4): 20.00 seconds, 600 frames, 1920x1080,
30 fps H264, 14,763,470 bytes, no audio stream. Recorded with `as_game`, `seed=92012`,
`discipline=boxing`, `venue_art=1` through `Tools/godot_hidden.ps1` via the guarded adapter.

Six FILE-tool frame reviews at 0/4/8/12/16/19 seconds show distinct Kelvin/Bruce faces, builds and
hair, attached gloves, red/blue trunks and feet meeting the canvas in sampled stance/step frames.
The floating groom cards are fixed. No open neck gap is visible at this distance; a faint
shoulder/neck crease remains. Skin is glossy, hair-card edges grainy and trunk hems follow jagged
mesh polygons. These are visual limitations, not a photoreal-finish claim. Sampled feet-on-canvas
is visual evidence, not a foot-slip certificate. Images: `review_00.png` through `review_19.png`
in the same preview directory; `hair_before.png` preserves the original fault.

The completed recording has no SCRIPT ERROR. Existing FBX short-read warnings and exit-only
resource/PagedAllocator leak messages remain in the log. They are not suppressed or treated as
proof that the simulation passed contact certification.

## C223 - every row reported, failures retained

Full machine report: [mh2_c223.json](../docs/previews/c223/mh2_c223.json).
Every measured row and every unavailable candidate: [c223_rows.md](../docs/previews/mh2/c223_rows.md).
Source reports and per-rig logs are preserved beside these files.

| Fixture / model | Measured rows | Rows with findings | Empty mechanical-failure lists | Missing-asset errors | Engine rc |
|---|---:|---:|---:|---:|---:|
| generator_welter_a / 01 | 89 | 86 | 3 | 11 | 2 |
| generator_welter_b / 02 | 89 | 86 | 3 | 11 | 2 |
| generator_heavy_c / 03 | 89 | 88 | 1 | 11 | 2 |
| generator_heavy_d / 04 | 89 | 86 | 3 | 11 | 2 |
| Total | 356 | 346 | 10 | 44 | - |

`q215_slip` has no mechanical findings on all four rigs. `reference_jab` and `owned_slip` also have
empty lists on 01/02/04. On Kelvin/03, `reference_jab` fails `foot_floor_cm` and `owned_slip` fails
`join_discontinuity`. Empty lists are not full certification: visual review remains pending and
no row is promoted to an accepted certificate.

| Finding | Rows |
|---|---:|
| join_discontinuity | 306 |
| contact_slip_cm | 172 |
| target_line | 143 |
| peak_fist_band | 120 |
| g147_clipping | 102 |
| skin_floor_cm | 90 |
| onset_to_impact_band | 73 |
| contact/whole/idle | 44 |
| foot_floor_cm | 32 |
| catch_glove_not_at_face | 20 |
| body_overlap | 12 |
| g147_pin_pop | 9 |
| catch_glove_over_head | 8 |
| recovery_clock | 4 |

Counts overlap because one row can have several findings. Thresholds, fixtures and moves were not
tuned to remove failures. The 44 gate errors are the same 11 absent clip/reference pairs on every rig:
`combat_cross`, `combat_hook`, `combat_long_hook`, `combat_right_hook`, `meshy_rear_hook`,
`meshy_shovel_hook`, `meshy_inside_uppercut`, `meshy_lead_hook`, `meshy_rear_uppercut`,
`qm_rear_hook_a`, `qm_rear_hook_b`. Both clip and `_rest.glb` files were checked absent on disk.
Those candidates have no measured row and are explicitly listed as unavailable, not passes.

All four completed logs have no SCRIPT ERROR and report 302400 leaked ObjectDB instances at exit.
The original three thermally killed attempts produced no reports and are excluded; completed
retries replace them. The retained fourth-rig result was not rerun. The final three-rig wrapper
reported `rows=267 errors=33`; the separate fourth-rig report adds 89 rows / 11 errors.

## Performance

Final accepted samples on RX 6800 XT / Forward+, 1920x1080, seed 92012, venue and game switches on:

| Arm | Average ms | p99 ms | Worst ms | Frames | Accepted local time (2026-10-03) |
|---|---:|---:|---:|---:|---|
| MetaHuman 03 + 04 | 16.5639 | 49.348 | 60.383 | 605 | 02:33:16 |
| MPFB control | 12.5815 | 34.866 | 71.163 | 795 | 02:54:19 |

Observed MH frame-time increase: **3.9824 ms / 31.65%**. Both final engines exited 0 with
no SCRIPT ERROR. FILE-tool captures confirm the intended bodies, two boxing gloves per corner and
venue. [Comparison and idle receipts](../docs/previews/mh2/performance_comparison.json),
[MH report](../docs/previews/mh2/perf_metahuman.json), [MPFB report](../docs/previews/mh2/perf_mpfb.json).
The corresponding `.txt` logs and `.png` captures are alongside the reports.

Both arms passed GREEN at launch, no competing engine jobs or Breachway at launch/completion,
and the task's temperature/CPU guard. The user-launched **Godot Project Manager** was left open:
no project was running in it, and its exact title plus at most 0.05 CPU-seconds over five seconds
were required. Its measured pre/post CPU deltas were MH 0 / 0.046875 seconds, MPFB 0 / 0 seconds;
completion blocker lists are empty. Active editors, tests, games, UE and Blender still block this
benchmark. No user application was closed or interrupted.

The harness uses the same scene configuration, 120 warm-up frames and a 10-second uncapped sample;
only `metahuman_bodies` changes. These are sequential accepted samples separated by required
safety/contention retries, not simultaneous captures or a statistical multi-run benchmark. Frame
times include the running game and are not a universal isolated model-cost estimate. C223-only
EcoQoS was not applied to benchmarks; the host's existing CPU-affinity governor remained in force.

Three MPFB attempts were excluded: attempt 1 overlapped another engine job at completion,
attempt 2 stopped thermally, and attempt 3 failed the Project Manager idle check. Attempt 4 is the
accepted control. The early samples are retained as `perf_metahuman_early.json/.txt` (18.5108 ms)
and `perf_mpfb_early.json/.txt` (10.5342 ms); they were hours apart with Breachway present near the
first MH measurement and are not used in the final comparison.

## Execution and reproduction

S144 resumed the WIP checkpoint instead of rebuilding completed assets. Every heavy launch used
`pc_watchdog.ps1 -Once && ...`; the task adapter enforces the explicit 80 C / 80% CPU hard limits,
including reported peaks, even though the host watchdog was later changed to 84 C sustained.
RED waits are 120 seconds plus watchdog sampling overhead. One owned engine at a time is enforced
by a Windows byte lock; C223 suspends only its owned PID tree during cooling, preserving fixed-step
work. Other agents' engines are not a normal-work blocker; the performance acceptance requires an
idle engine slot. Rendering is hidden; no viewer or window was opened on the operator's screens.

Reproduction helpers (each heavy helper runs the guard internally):

```powershell
python Tools/metahuman/mh2_run.py glb 3
python Tools/metahuman/mh2_compare_off.py 568089a5
$env:GODOT_EXE = (Resolve-Path Tools/metahuman/mh2_godot.cmd).Path
python Tools/c223_parallel.py production --jobs 1 --timeout 86400 -- metahuman_bodies=1 report=mh2_c223.json
python Tools/metahuman/mh2_perf_checks.py
```

Do not regenerate finished assets just to repeat this run. Raw exports/textures stay on E:.
Build stages are `ue`, `exr`, `textures`, `glb`; the UE stage also requires RAM below 80% and clears
both outfit slots before spawn. Blender runs with factory startup and Python-error exit handling.

Task-specific scope exceptions: live-screen switch/configuration/corner-selection plumbing needs
more than one literal switch line; C223's shared fixture option pass-through in `c223_clip_gate.gd`
is the explicitly permitted gate change. No unrelated live-screen edits, no HANDOFF changes and no
CCFighterSkin changes were made. Import/UID noise and externally modified `Tools/pc_watchdog.ps1`
remain outside owned commits. Push only the authorized WIP destination; never force-push the
original remote lineage.
