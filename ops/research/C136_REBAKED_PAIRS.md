# C136 - owned pairs rebaked; contact and position refusals retained

2026-09-20, `codex/c134-bjj-presentation`. C136 rules override general startup
rebase/HANDOFF rules. No engine edits, hand-authored holds, spending, Cascadeur
trial use, licence/payment prompts, branch switch, rebase or full suite.

## Result

**The re-bake is scriptable and repeatable. Contact acceptance is not automatic.**
Five bought pairs were processed with one recipe: ArmBar, Strangle, PushOff,
Reversal and Takedown_BodyLock_End. Each exports a source-skeleton Att/Vic pair
and native f05/f06 Att/Vic variants: 30 GLBs. Re-running all five in reverse
order produces 30 byte-identical files. Maximum exported/re-imported joint
position error is **0.000008156 m**. Receipts include source/rig hashes.

The attacker armbar horizontal travel survives in the asset: **1.020333 m X,
0.843685 m Y** in Blender Z-up (Godot horizontal X/Z). Vertical travel is
0.784589 m. The recipe does not depend on runtime travel restoration.

The other pairs with this vendor skeleton can use the same batch pipeline
without manual posing. Tested scope is five pairs, not all sixteen. Semantic
suitability, placement, contacts and any refinement still require per-clip
review; a successful bake cannot turn a mount film into guard footage.

## Recipe and verification

Use ONLY `D:\Tools\Blender\blender-5.2.1-windows-x64\blender.exe`:

```powershell
$blender = 'D:\Tools\Blender\blender-5.2.1-windows-x64\blender.exe'
& $blender --background --factory-startup --python Godot/tools/c136_rebake.py -- --clips H2H_ArmBar H2H_Strangle PushOff Reversal Takedown_BodyLock_End
& $blender --background --factory-startup --python Godot/tools/c136_rebake.py -- --clips Takedown_BodyLock_End Reversal PushOff H2H_Strangle H2H_ArmBar --output .c134/c136-repeat-final
python Godot/tools/c136_evidence.py --repeat
& $blender --background --factory-startup --python Godot/tools/c136_contacts.py
& $blender --background --factory-startup --python Godot/tools/c136_preview.py
& $blender --background --factory-startup --python Godot/tools/c136_preview.py -- PushOff Reversal Takedown_BodyLock_End
python Godot/tools/c136_evidence.py --sheets
```

The script reconstructs the vendor armature from T_pose.fbx, composes animated
empty world transforms including the FBX root, and visually bakes constraints
with `nla.bake(visual_keying=True, clear_constraints=True)`. It uses native target
rest-axis corrections and a leg-length scale, TEMPERANCE GLB import, and
`bpy.ops.pose.select_all`. It does not use the add-on's false-success bake.
Export animation compression is disabled: the default exceeded the strict
0.0001 m verification bound on Strangle. Orphan armature/mesh data is cleared
between clips so naming is independent of batch order. Every GLB is imported
again and every joint position checked at every 30 Hz sample.

These are skeleton-only animation assets, paired by common key and Att/Vic
suffix, retained under `assets/anim/audition/c136_rebaked/`. The meshes remain
our existing f05/f06. No live binding was changed: none of these candidates
passed all acceptance requirements.

## Submission contacts

All frames measured on the decoded native animation applied to the actual
skinned meshes. Uniform stage stature uses 66/66.5 kg -> 1.740/1.745 m;
f06's raw mesh is about 0.9965 m tall, so raw rig units are not world metres.
Pair placement is fixed first-hip horizontal origins with attacker yaw 180
baked into the source; no per-frame contact solve or fitted translation.
Grip is midpoint of attacker hands versus victim RightHand (armbar) / Neck
(strangle). Residual is variation around the window mean in the victim joint's
rotating frame. It is a joint-centre proxy, not a skin contact certificate.

| Film / attacker | Window s | Source RMS m | Target RMS / peak m | Grip distance m | Intersecting frames |
|---|---|---|---|---|---|
| Armbar / f05 | 1.4-2.4 | .065294 | .059310 / .152613 | .063678-.203352 | 94/135 = 69.63% |
| Armbar / f06 | 1.4-2.4 | .065294 | .059128 / .158220 | .110778-.217791 | 93/135 = 68.89% |
| Strangle / f05 | 1-5 | .019758 | .052466 / .120744 | .300918-.348943 | 181/181 = 100% |
| Strangle / f06 | 1-5 | .019758 | .062335 / .134968 | .331721-.375184 | 181/181 = 100% |

Interpenetration share means frames with crossing triangles between the two
actual deformed meshes, measured with Blender BVHs over the whole film. It
counts shallow crossings as well as deep ones and excludes full containment
without surface crossings. It is not a penetration volume/depth score. Source
contact uses the same aligned source joints/window; source mesh penetration
was not measured. These asset auditions differ from C134's runtime placement
and retarget, so the older runtime figures are not a controlled before/after.

Opened the fresh first/middle/last, three-view mesh sheets. Armbar shows the
roll and separation, but grip drift and intersections remain. Strangle shows
a mounted neck squeeze with no verified sporting finish/tap/release. **Both
remain refused.** Evidence and per-frame records: `C136_EVIDENCE/contacts.json`,
`source_contacts.json`, `H2H_*_frames.json`, `H2H_*.jpg`.

## Four transition refusals

Measured hip heights below are Blender world metres on normalized target rigs.
All three source/target pairs passed the same export round-trip checks.

| Requested event / film | Re-baked observation | Measured endpoints, Att/Vic hip z m | Decision |
|---|---|---|---|
| Clinch break / PushOff | mount -> standing, 81 frames | .4135/.1318 -> .9184/.9466 | Refuse: must start standing clinch |
| Escape / PushOff | ends standing at 2.667 s | .9184/.9466 | Refuse: must end guard |
| Sweep / Reversal | mount -> mount with top swapped, 56 frames | .4135/.1318 -> .1279/.4262 | Refuse: required half -> guard |
| Stand-up / BodyLock_End | mount -> standing, 146 frames | .4135/.1318 -> .9184/.9466 | Refuse: required guard start |

**Correction to C134:** Reversal does swap top. The earlier assertion that the
same attacker returns to mount was wrong. The endpoint seat mismatch remains.
Opened all three fresh three-angle endpoint/midpoint sheets. Coordinates:
`C136_EVIDENCE/transitions.json`; sheets: `PushOff.jpg`, `Reversal.jpg`,
`Takedown_BodyLock_End.jpg`. Wrong positions remain unbound.

## Gates

No GDScript was edited, so there is no touched-.gd parse gate. All four Python
helpers passed syntax parsing. No Godot was booted until step 1's Blender
re-bake and commit completed. Requested groups ran sequentially, never a full
suite.

| Group | Total | Fails | Ceiling |
|---|---:|---:|---|
| c134 | 5 | 0 | Met |
| clip | 9 | 0 | Met |
| grapple | 10 | 2 | **Exceeded (1)** |
| pair | 7 | 1 | Met; fight_pair_live parked |
| stage | 14 | 1 | Met; fight_stage_realism |

Both grapple failures reproduced in separate one-test invocations:
`fight_grapple_seam_test`: 59 checks / 3 failures (no bought film played,
no held frames, no ground strike routed); `grapple_adapter_test`: 125 checks /
6 failures (MT striking numeric drift). These are engine/integration findings
for Claude, not fixed or weakened here. Gate is NOT claimed green.
Exact summaries and failing logs are in `C136_EVIDENCE/gates.json`,
`grapple_seam.txt`, `grapple_adapter.txt`.

## Fresh BJJ recording

**179 beats / 2 named-clip plays / 177 honest degrades; DECISION.** These are
fresh terminal room counters, not reused C134 numbers. The two plays are the
already-bound mount film; no gain is attributed to C136's unbound exports.
Grapple events 79, no_clip 76, already_playing 1, played 2. Paired frames 105
(3.5 s), maximum clock difference 0; held mount 0.766667 s over two entries.

Fresh movie: `.c134/c136-bjj-77321.avi`, 18,280 frames at 30 fps, 609.333 s,
1,808,974,730 bytes. Kept local and uncommitted. Opened decoded samples at
4, 19.4, 34, 38, 75, 304.667, 487.467 and 608.333 s, including the terminal
readout. Brief mount is visible at 34 s. Unsupported positions still show
standing overlap, and the last-played readout remains stale until the verdict.
This is not visual acceptance of a continuous BJJ sequence.

Zero SCRIPT ERROR / Parse Error lines. Recording process returned 1 with
certificate/logger/shader-cache warnings and exit leaks; not claimed a clean process exit.
The complete AVI decodes through the decision. Committed review sheet,
terminal frame and recording metadata: `C136_EVIDENCE/bjj-recording.jpg`,
`bjj-final.jpg`, `recording.json`.

```powershell
& .godotbin/Godot_v4.7.2-stable_win64_console.exe --path Godot --rendering-method gl_compatibility --resolution 960x540 --fixed-fps 30 --write-movie "$PWD/.c134/c136-bjj-77321.avi" --quit-after 18300 --script tools/c134_match_review.gd -- seed=77321 discipline=bjj rounds=1 finish-exit
python Godot/tools/c136_evidence.py --video
```

Step commits: e661c189 (first pair), 1f283964 (submission contacts), fb988fb7
(transitions); final commit adds stable batch naming, repeatability evidence,
recording review and this report. No `.c134/` or AgentComms messages committed.
