# C134 continuation 4: fix paired travel at the runtime retarget source

## Blender result, measured 2026-09-20

Portable Blender 5.2.1 executes. Its config/cache writes on D: are denied, and
unrelated add-on registration/dependency warnings appear at startup. Nevertheless
Retarget bound 23 constraints, nla.bake created an action (frames 1-135), export
completed, and the exported GLB was re-imported and rendered. No config was edited.

The constant-offset empty-to-source-rig bake is NOT where translation is lost:
all-bone worst head error is 0.001 mm. Blender XYZ source hip spans are
1.020333 / 0.843685 / 0.784589 m; baked source spans agree within 0.000001 m.
Blender Z is height; Godot Y is height. The add-on Pose-mode f05 output spans are
0.795166 / 0.742637 / 0.470954 m. This is a diagnostic single-actor export of the
existing f05/f06 pair population, not a paired-contact validation. No add-on GLB
is promoted. Opened the export renders, including the folded roll pose at frame 61.
The render helper now frames evaluated fighter vertices per sample; previously
it could select an incidental icosphere and crop the moving fighter out.

Reproduce with portable Blender --background --python Tools/blender_bakeoff/bl_bakeoff.py
-- <absolute ArmBar_Att.fbx> <absolute output.glb> Pose <absolute f05 rigged.glb>.
The helper now derives Godot from its own checkout and accepts the target as argument 4.
`bl_column.py -- <export.glb> <output.png> 1,25,61,115` renders the exported result.
Numeric evidence: C134_EVIDENCE/blender-retarget-cont4.json; rendered export:
C134_EVIDENCE/blender-armbar-cont4.jpg.

## Repair and scope

FightClipRetarget.retarget_clip now has an explicit carry_paired_travel option.
It carries source X/Z displacement relative to the window's first frame, mapped
through the existing hip-parent axes and body scale. Unlike standing sway it does
not require a return to origin. Standing defaults, height and rotation keys remain
unchanged. A valid reference hip is required. The graft marks carried animations
so the existing compatibility restoration cannot add the trajectory a second time.

PairedStagePlayer exposes the option; FightWorldLiveScreen selects it for armbar,
strangle and the already-corrected punch film using source filenames (both role
assignments and raw auditions work). Mount holds and other film policies retain
their existing behavior. The old rendered measurement's duplicate travel injection
is removed: it now measures exactly what the real graft returns, with an optional
attacker turn. No new submission film is accepted by the live gate.

This extends the original named-file list to FightClipRetarget and PairedStagePlayer
under the continuation's explicit instruction to repair the retarget at its source.
No engine edits, new holds, purchases or full suite. Of Claude's overlapping files,
only FightWorldLiveScreen changed (the graft option). No bindings/schedule edits.

## Contact re-check

Armbar: all 135 samples / 4.466667 s, actual rendered room skeletons, f05 attacker
and f06 victim. At 1.4-2.4 s the wrist-to-hand-midpoint proxy is 0.068052-0.178377 m;
constant-offset residual RMS 0.099653 m. This matches the continuation-3 corrected
audition without downstream patching. Hip travel is present during grafting.
Both assignments were opened at 0.8, 2.0 and 3.8 s, four angles each. The roll and
release read, but hand grip error and close body intersections persist: NOT accepted.

Strangle: all 181 samples / 6 s. Godot XYZ source hip spans, attacker:
0.037168 / 0.056535 / 0.104254 m; victim 0.091675 / 0.040892 / 0.046283 m.
Rendered target spans: 0.100357 / 0.055206 / 0.050844 m and
0.039891 / 0.041198 / 0.088989 m (room heading rotates horizontal axes).
Opened both assignments at 1, 3 and 5 s, four angles each. It remains a mounted
hands-to-neck squeeze; restored small travel does not establish a sporting choke,
tap or release. Remains refused live. Joint centres are proxies, not skin contacts.

The four cont4 JPG sheets in C134_EVIDENCE document these auditions, not natural
match coverage. Match recordings and gate results belong in C134_BJJ_PRESENTATION.md.
