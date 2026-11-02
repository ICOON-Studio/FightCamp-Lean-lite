## DECISIONS

**Map** (21/22 matched; UpperChest has no FM1 equivalent — FM1 has 3 spine bones
vs our 4): Hip→Hips, Body→Spine, Chest→Chest, Neck→Neck, Head→Head,
Collar_L/R→LeftShoulder/RightShoulder, Shoulder_L/R→LeftUpperArm/RightUpperArm,
ForeArm_L/R→LeftLowerArm/RightLowerArm, Hand_L/R→LeftHand/RightHand,
Thigh_L/R→LeftUpperLeg/RightUpperLeg, Shin_L/R→LeftLowerLeg/RightLowerLeg,
Foot_L/R→LeftFoot/RightFoot, Toe_L/R→LeftToes/RightToes. All by name.

**Rest angles** (SA=shoulder abduction, EF=elbow flex, KF=knee flex, hh=hips height):

| File | SA L/R | EF L/R | KF L/R | hh |
|------|--------|--------|--------|------|
| BlueGuy | 90.0/90.0 | 78.3/78.3 | 0.0/0.0 | 0.875 |
| idle_A | 90.0/90.0 | 78.3/78.3 | 0.0/0.0 | 0.864 |
| idle_Tiramis | 90.0/90.0 | 78.3/78.3 | 0.0/0.0 | 0.864 |
| f01 ours | 92.1/92.1 | 81.3/81.4 | 5.9/4.9 | 1.012 |

**Rest file: BlueGuy.fbx** — perfect 90° SA, 0° KF. The 78.3° EF is the FM1
rig's natural forearm bend (forward from horizontal upper arm). idle_A and
idle_Tiramis share the same hierarchy with fighting-stance node transforms.
