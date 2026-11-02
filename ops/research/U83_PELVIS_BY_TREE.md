## DECISIONS

1. Caveat 1: T_pose hierarchy pelvis_y=0.9675 m; Q83 wrongly reused idle 0.9130 m as tpose_pelvis_y_m; idle mid-pelvis ~0.9057 m.
2. Caveat 2: KnockDown01 pelvis position track equals local at five samples (1 mm); raw track matches animated node space, not a separate world formula.
3. Caveat 3: KnockDown01 xz net 0.7626 m path 1.5702 m; KnockDown02 xz net 1.0129 m path 1.2647 m — Q83 reported ~0 m horizontal for both.

### Height disagreements (>2 cm)
None — tree and Q83 agree within 2 cm on every window.

### Knockdown pelvis (scene tree)
- H2H_KnockDown01.FBX: pelvis y min 0.134 m, xz net 0.763 m, xz path 1.570 m
- H2H_KnockDown02.FBX: pelvis y min 0.149 m, xz net 1.013 m, xz path 1.265 m

**S4a hip carry:** Build from Godot scene-tree composition after `AnimationPlayer.seek`, not Q83's hand-composed track math — the tree is what the importer actually plays.