# C231 ? native Cascy graft and certified inside uppercut

## Result

The native Cascadeur inside uppercut passes all four generated legal pairs in
`../docs/previews/c223/c231_inside_uppercut.json`. It is bound as
`boxing_inside_uppercut`, included in `certified_moves.json`, and its
`cascadeur_c229` manifest pack is approved. Earlier C229 trials and the optional
shovel hook remain rejected; the shovel hook was not changed.

| Rig | Peak fist m/s | Onset ms | Minimum body gap cm | Failures / pin pops / ordinary pops |
| --- | ---: | ---: | ---: | --- |
| welter_a | 8.2154 | 366.667 | 0.9760 | none / 0 / 0 |
| welter_b | 9.2004 | 366.667 | 4.1066 | none / 0 / 0 |
| heavy_c | 9.1873 | 366.667 | 2.8128 | none / 0 / 0 |
| heavy_d | 9.7029 | 366.667 | 3.8787 | none / 0 / 0 |

Every candidate row has `g147_pass=true`, `mechanical_failures=[]`, speed inside
6.5?13.5 m/s and onset inside 71?627 ms. The production run completed with
`rigs=4 jobs=2 rows=8 errors=0`. The other four rows are reference jabs: the
existing heavy_c reference-jab pin-pop failure remains, as in the rejected
trial reports. It is not a failure of the new uppercut and was not modified.

Opened the final [side](../docs/previews/c231/final_side.png) and
[game-angle](../docs/previews/c231/final_game.png) sheets after the final export.
The blue-shorts attacker keeps his rear glove near his chin, faces his opponent,
and returns to guard. These are six sampled runtime poses per angle, not a
claim of a separate full-speed video review. Receiver contact responses remain
the existing production solver. Numerical evidence covers the entire clip.

## Engine scope and legacy control

`FightStagePlayer.gd` edited ranges: 1936?1940 select native Cascy only when the
reference identifies as Cascy; 1946, 1978 and 1986 pass the selected map to
silhouette corrections, sway and retargeting. Every other source retains the
same UE4 dictionary as before, including partially mapped legacy carriers.
`FightClipRetarget.gd` is unchanged. No gate thresholds were changed.
`FightClipBinding.gd` changes only the inside-uppercut entry and its comment;
the old target-space arm layer is removed because the pose is authored upstream.

The `owned_cross` welter_a C223 control row is exactly equal in
`c231_control_before.json` and `c231_attempt1.json`, including every field.
Canonical sorted JSON SHA-256:
`5cbaffc384dfabdfa0e78067f22cb341e5ef2ed8b3f6e97ddadd9eeba89fc462`.

## Reproducible authoring

Run `python Tools/cascadeur/build_c231_inside_uppercut.py` with the Cascadeur
script server on port 8765. It uses committed C229 SOURCE/RIG samples, writes
controllers only, invokes the actual Cascadeur solver, exports animation/rest,
reads back 67 solved frames and saves the native scene. No UE4 bone rename is
performed. `c231_inside_uppercut/compact.py` replaces only the unused mannequin
mesh with a tiny skinned carrier. Verified all 67 nodes, skin joint lists,
animation channels and sampler accessor bytes against the actual raw export.
Compact animation/rest sizes: 240572 / 20048 bytes. Asset and input hashes are
in `Tools/cascadeur/c231_inside_uppercut/receipt.json`.

Final defaults: torso lean -6 degrees; centered lateral trunk; rear wrist/head
offset (-12,-15,8) cm; lead reach +8 cm, lift +8 cm, lateral target hip x-3 cm;
smooth lead wrist orientation; endpoint lead-guard strength 0.1; early rear
wrist tuck 4 cm. Anatomical reach is limited to 98 percent of the two arm
segments before the solve. Runtime animation duration is 1.868 s.
Native `Cascy_C231_InsideUppercut_4a2c378c.casc` remains local and ignored,
as do raw exports and generated controller/readback data.

Rejected witnesses `c231_attempt1.json` through `c231_attempt11.json` are kept:
1?3 exposed overlap, bad reach and wrist pops; 4?5 improved contact but retained
heavy-rig overlap; 6 centered the torso and cleared overlap but exposed wrist
pops; 7 smoothed wrist rotation (two rigs passed); 8?10 adjusted endpoint guard
and reach (two passed, with a knee clip on one and rear pin on another);
11 reduced endpoint guard strength, giving three passes. The final early rear
tuck removes heavy_c's wind-up rear-hand pin without changing the safe idle
phase (1.85 s). No failed trial is used as the new move's certificate.
Read-only pose/runtime probes remain available; they return the original gate
measurements and never change thresholds.

## Validation and environment

Parse before tests: `CHECK total=4 fails=0` for both edited engine scripts and
the two new diagnostic GDScripts. Python author/compact syntax checks pass.
Initial control selector: `SUITE total=11 fails=1`, solely missing import-cache
resources in `fight_clip_load_test`; after restoring exact named caches, that
test reran `SUITE total=1 fails=0`. Final required selector `certified_palette,clip_binding,asset_manifest,fight_clip,fight_stage_presenter`: **SUITE total=12 fails=0**. This includes the control selector tests.

Fresh-worktree fonts, textures and animation caches were restored from the
existing checkout without changing production code. Watchdog ran before heavy
work (GREEN or AMBER, max observed RAM 90 percent); numerical gates/tests used
two workers, renders used the hidden launcher. Render logs contain no SCRIPT
ERROR/ERROR, with existing ObjectDB cleanup warnings at exit. Two Cascadeur
requests returned idle timeouts but later saved successfully; their native
scene/hash and solved frames were checked before compacting. One prematurely
started witness was stopped and discarded; all reported final metrics come
from the later complete run of the final assets.

Task scope supersedes unrelated mailbox assignments and the general HANDOFF
workflow; HANDOFF is untouched. The game-asset-production skill was consulted;
its optional CLI was unavailable, so the task-authorized local Cascadeur
workflow was used. Worktree was rebased cleanly onto 37d2b993 before work.

## S138 (Claude) - merged lean as a diff
Taken: the clip + rest GLB, FightClipBinding entry, FightStagePlayer native-Cascy map selection, certified_moves.json +
asset_manifest, the final certificate (c231_inside_uppercut.json) + control_before, the authoring script/receipt, the two
final sheets. Left on the branch: the 11 rejected attempt JSONs (~35k lines) and their sheets (keep the repo light).
Re-measured on master through the bound production path (`plant phase live_contact bound render video`): welter_a gap
-0.19 cm, peak 8.22 m/s, mechanical failures none - same as the certificate. TRAP: without `bound` the gate measures its
own legacy Mixamo candidate for `v_inside_uppercut` (21.7 cm short, 36 cm foot slide, a join pop) - not the game's clip.
Video: previews/anim/boxing_inside_uppercut.mp4 (silent; Tools/anim_previews.py maps the candidate now).
Visual note for the operator: the RECEIVER (red) lifts his left arm over his head at ~0.33 s and ~1.1 s - his reaction
layer, not this clip.
- S138 later: OPERATOR VERDICT on the video: "this video is terrible what happenned ?". WITHDRAWN from
  certified_moves.json (kept under "withheld" with the reason). Lesson: a move needs the operator's eye on a game-camera
  video before it is certified - the gate measures speed/overlap/slide, not whether it looks like the punch.
