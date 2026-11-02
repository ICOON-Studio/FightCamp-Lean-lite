# C204 - alive stance, default OFF

Branch `codex/c204-alive-stance`, based on `0f273a1b`. Only the assigned worktree was used; its import cache was reused. No re-import, worktree creation, HANDOFF or status-log reads/edits. The task's no-HANDOFF rule supersedes the general handoff-block rule.

## Census (printed by fight_alive_stance_test.gd)

| Discipline | Bound idle | Bound loop length | Variants |
|---|---|---:|---:|
| boxing | H2H_Idle.FBX | 4.67 s | 0 |
| kickboxing | H2H_Idle.FBX | 4.67 s | 0 |
| muay_thai | H2H_Idle.FBX | 4.67 s | 0 |
| mma | H2H_Idle.FBX | 4.67 s | 0 |
| judo | H2H_Idle.FBX | 4.67 s | 0 |
| taekwondo | H2H_Idle.FBX | 4.67 s | 0 |
| freestyle | H2H_Idle.FBX | 4.67 s | 0 |

FightClipBinding has one shared idle binding, no discipline override. The room already offsets A/B loop phase by 0/0.5. Census describes the standing binding, not a claim that every discipline spends equal time standing. C203's source digest leaves this idle unchanged; its authored-source option is separate. Q176's footwork economy is a separate simulation change and was not merged or enabled here.

## ON behavior and research basis

`configure({"alive_stance": true})` creates one FightAliveStance instance per fighter, with separate seed-derived RNGs. No simulation RNG draws or simulation edits. OFF allocates no layer and skips every new pose writer.

While the actual clip is idle (no lower-body walk layer, pair or whole-body action), select among weight shift, off-centre head motion, shoulder/hand feint, level change, and breathing. Pick a new family after 1.5-3.0 active stance seconds, excluding the previous family. Idle time pauses during other actions. A smooth zero-slope pulse returns each selection to neutral. Breathing deepens as that fighter's live stamina falls. The hip translation is bounded at 1.2 cm lateral / 1.8 cm down; root transforms are never written. The existing inertialized joins and foot lock run after this additive pose. Undo happens before the next animation sample. S77 records its clip hand baseline after the layer and still performs final hand-offset smoothing.

Timing and amplitudes are explicitly **PROXY**, not measured biological rates. G100 was absent from the research index. G86 distinguishes trunk/shoulder/hand twitches from committed feints and does not establish a universal discipline rate. J29 supports stance/guard and weight-shift reference work but requires care with source rights; no assets were downloaded. M18 distinguishes lateral silhouette intent from travel and preserves the existing hold idle. No new combat feint events or tactical effects are claimed.

## OFF identity and occurrence

600 fixed 30 Hz idle frames, every bone's full local pose plus mounted root transform, SHA256:

- Parent FightStagePlayer: `e7f744a6b2b432854ba8d9db47f8ea63301eacbaa193e97e6e256dad5cd85667`
- Final default OFF: `e7f744a6b2b432854ba8d9db47f8ea63301eacbaa193e97e6e256dad5cd85667`

The parent was loaded from `git show HEAD:Godot/scripts/FightStagePlayer.gd` into an ignored measurement resource with only its class_name declaration removed to avoid registering the name twice. Production files were not swapped. This is posed-byte equality for the idle fixture, not a whole-career replay claim.

Mounted ON fixture: 600/600 additive write frames; head position differs from OFF by >1 mm in 355 frames; maximum foot displacement from OFF **0.000181 m**; root transform exactly unchanged. The test also checks all five families occur, seeded replay, spacing/no consecutive repetition, fatigue breathing, default-OFF and disabled behavior, and strike exclusion. Identical-rig comparison is a geometry fixture, not a fighter matchup.

Mutant: replace the apply guard with unconditional return, suppressing all pose writes. Parse passes; occurrence test fails (`SUITE total=1 fails=1`, rc=1). Restore implementation: `SUITE total=1 fails=0` (16 checks).

## Recordings and S77 hand gate

Two 900-frame, 30 fps recordings (30 seconds each), seed **94301**, boxing, default distinct A/B bodies, `shot=broadcast`, only `opt.alive_stance` differs. Hidden launcher used for both. Godot's movie viewport is **1920x1080** despite the requested window resolution. Both MP4s fully decode with no errors. H.264 CRF20/yuv420p MP4s are local ignored evidence, not committed imported assets:

- `Godot/.godot/c204/off.mp4` MD5 `ee437c6c4aa83c59735ad4ed4bbf6747`
- `Godot/.godot/c204/on.mp4` MD5 `c4f2f8e5d513de61dbf5685482753dec`

| S77 metric | OFF | ON |
|---|---:|---:|
| World hand reversals, sum of four hands | 73 | 73 |
| A left / right hand | 21 / 16 | 22 / 16 |
| B left / right hand | 17 / 19 | 17 / 18 |
| Hand-minus-hips reversals, four hands | 39 | 38 |
| One-frame hand pops | 0 | 0 |
| Hand speed p99 m/s | 6.34 | 6.32 |
| Overlap frames >1 cm | 129 | 122 |
| Root travel m/min A / B | 51.8 / 53.4 | 51.8 / 53.4 |

**Aggregate hand-buzz gate: unchanged, not worse.** This is not a per-hand non-regression claim: A-left rises by one while B-right falls by one. The probe's `hand_buzz` dictionary also contains root/hips diagnostics; those are not hands and were not summed into this metric. Residual contact overlap exists in both arms (max 0.2131/0.2132 m); this task does not fix the contact solver.

Visual review: extracted ON samples across the recording and a full-size 12-second frame show intact bodies/guards and grounded feet; evidence is sampled-frame review, not a claim of full frame-by-frame motion approval. Root travel remains substantial with Q176 disabled. This posture layer is intended to accompany, not replace, the separate travel reduction.

Reproduce from repository root:

```powershell
python Godot/tools/check_scripts.py scripts/FightAliveStance.gd scripts/FightStagePlayer.gd scripts/FightWorldLiveScreen.gd tests/fight_alive_stance_test.gd
python Godot/tools/run_tests.py --only fight_alive_stance --jobs 1
python Godot/tools/run_tests.py --only fight_stage,fight_body_layers,fight_room_,contact_ --jobs 1
powershell -NoProfile -ExecutionPolicy Bypass -File Tools/godot_hidden.ps1 --path Godot --rendering-method gl_compatibility --rendering-driver opengl3 --fixed-fps 30 --resolution 854x480 --write-movie .godot/c204/off.avi --script tools/s77_camera_probe.gd -- seed=94301 frames=900 shot=broadcast opt.alive_stance=false
# Repeat with on.avi and opt.alive_stance=true; encode each AVI with:
# ffmpeg -i <arm>.avi -c:v libx264 -crf 20 -pix_fmt yuv420p -an <arm>.mp4
```

## Gates

- Final combined parse: **CHECK total=4 fails=0** (no autoload warnings).
- C204 test: 16 checks, PASS; mutant killed.
- Required subset: **SUITE total=20 fails=1**. Only `fight_stage_realism_test.gd` fails (`TOTAL=13 fails=8`: R1, R2, R3, R4, R5, R5b, R7, R8), matching the known red documented in C203_DIGEST.md. Assertions were not weakened. This gate runs default OFF; the separate C204 occurrence test exercises ON.
- No full suite run.
