## DECISIONS
jab (L, contact 0.233 s): speed peaks hip_line_yaw -> RightFoot -> Hips -> shoulder_line_yaw -> LeftUpperArm -> LeftLowerArm -> LeftHand — hip/shoulder twist leads, foot follows, arm last.
cross (R, contact 0.300 s): speed peaks Hips -> hip_line_yaw -> LeftFoot -> shoulder_line_yaw -> RightUpperArm -> RightLowerArm -> RightHand — hips lead, proximal-to-distal arm.
hook_lead (L, contact 0.333 s): speed peaks hip_line_yaw -> shoulder_line_yaw -> LeftUpperArm -> LeftLowerArm -> LeftHand -> RightFoot -> Hips — shoulders lead, hips lag.
hook_rear (R, contact 0.333 s): speed peaks hip_line_yaw -> shoulder_line_yaw -> RightUpperArm -> RightLowerArm -> RightHand -> LeftFoot -> Hips — same shoulder-led pattern.
boxing_overhand (L, contact 0.667 s): speed peaks Hips -> RightFoot -> hip_line_yaw -> shoulder_line_yaw -> LeftUpperArm -> LeftLowerArm -> LeftHand — hips and foot lead.
strike_body (R, contact 0.333 s): speed peaks Hips -> hip_line_yaw -> LeftFoot -> shoulder_line_yaw -> RightUpperArm -> RightLowerArm -> RightHand — hips lead, proximal-to-distal.
Reactions: head onset leads in react_head/react_head#3; speed peaks vary — hips often peaks first (react_head, react_head#1, react_head#2) or head (react_head#3, react_body#1).

## Table
| take | onset order | speed-peak order |
|---|---|---|
| jab | Hips -> hip_line_yaw -> LeftLowerArm -> RightFoot -> LeftHand -> LeftUpperArm -> shoulder_line_yaw | hip_line_yaw -> RightFoot -> Hips -> shoulder_line_yaw -> LeftUpperArm -> LeftLowerArm -> LeftHand |
| cross | Hips -> hip_line_yaw -> RightLowerArm -> RightHand -> RightUpperArm -> shoulder_line_yaw -> LeftFoot | Hips -> hip_line_yaw -> LeftFoot -> shoulder_line_yaw -> RightUpperArm -> RightLowerArm -> RightHand |
| hook_lead | shoulder_line_yaw -> RightFoot -> LeftHand -> hip_line_yaw -> LeftUpperArm -> LeftLowerArm -> Hips | hip_line_yaw -> shoulder_line_yaw -> LeftUpperArm -> LeftLowerArm -> LeftHand -> RightFoot -> Hips |
| hook_rear | shoulder_line_yaw -> LeftFoot -> RightHand -> hip_line_yaw -> RightUpperArm -> RightLowerArm -> Hips | hip_line_yaw -> shoulder_line_yaw -> RightUpperArm -> RightLowerArm -> RightHand -> LeftFoot -> Hips |
| boxing_overhand | Hips -> hip_line_yaw -> shoulder_line_yaw -> LeftUpperArm -> RightFoot -> LeftLowerArm -> LeftHand | Hips -> RightFoot -> hip_line_yaw -> shoulder_line_yaw -> LeftUpperArm -> LeftLowerArm -> LeftHand |
| strike_body | Hips -> hip_line_yaw -> RightLowerArm -> RightHand -> RightUpperArm -> shoulder_line_yaw -> LeftFoot | Hips -> hip_line_yaw -> LeftFoot -> shoulder_line_yaw -> RightUpperArm -> RightLowerArm -> RightHand |
| react_head | Hips -> UpperChest -> RightFoot -> Head -> Neck -> LeftFoot | Hips -> Head -> Neck -> LeftFoot -> RightFoot -> UpperChest |
| react_head#1 | Hips -> UpperChest -> RightFoot -> LeftFoot -> Head -> Neck | Hips -> RightFoot -> LeftFoot -> UpperChest -> Head -> Neck |
| react_head#2 | LeftFoot -> RightFoot -> Head -> Neck -> UpperChest -> Hips | RightFoot -> Hips -> LeftFoot -> Head -> Neck -> UpperChest |
| react_head#3 | Head -> Neck -> Hips -> UpperChest -> LeftFoot -> RightFoot | Head -> Hips -> LeftFoot -> Neck -> UpperChest -> RightFoot |
| react_body | Head -> Neck -> UpperChest -> RightFoot -> Hips -> LeftFoot | Head -> Neck -> UpperChest -> Hips -> LeftFoot -> RightFoot |
| react_body#1 | LeftFoot -> RightFoot -> Head -> Neck -> UpperChest -> Hips | Head -> Neck -> LeftFoot -> UpperChest -> Hips -> RightFoot |
| block | Head -> Neck -> UpperChest -> Hips -> LeftFoot -> RightFoot | Hips -> Head -> Neck -> UpperChest -> LeftFoot -> RightFoot |
| slip | LeftFoot -> RightFoot -> Head -> Neck -> UpperChest -> Hips | LeftFoot -> RightFoot -> Hips -> Head -> Neck -> UpperChest |

## Method
18 bones sampled at t_k = k/60 through FightStagePlayer._sample_global (skeleton space). peak_disp, onset (20% of peak), speed_peak (central-difference). hip_line and shoulder_line: XZ angle of the Left->Right joint pair from t0, per-frame and speed-of-angle. Strike frames relative to contact_s; reaction frames relative to take start.

## Population
fighter A f01 via FightStagePlayer.bind, RamsterZ H2H catalogue (FightClipBinding), seed 94301
