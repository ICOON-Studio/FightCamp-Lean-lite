## DECISIONS
The node searches when no continuing pose can advance or elapsed time reaches SearchThrottleTime (seconds).
The winner minimizes weighted squared feature dissimilarity plus database/continuing addends.
PoseJumpThresholdTime and PoseReselectHistory (seconds) reject too-near jumps and recently selected poses.
A different result calls BlendStack::BlendTo at the selected asset time; inertialization is opt-in, otherwise this is a blend-stack blend.
An interaction database stores one multi-animation asset with one animation and role per participant.
The interaction search scores all role queries together, then returns the selected role result to each character.
Alignment uses weighted reference roots and warps; banking and minimal-translation weights control how that warp is shared.
INFERENCE: our 13 clips/man need sampled pose/trajectory databases and paired strike/reaction multi-animation assets plus role-aware pose histories.

### M1
`UpdateMotionMatchingState` constructs a search context with `PoseJumpThresholdTime`, and searches when no continuing pose can advance or `ElapsedPoseSearchTime >= SearchThrottleTime`; otherwise it advances `DeltaTime` and marks the continuing result. `SearchThrottleTime` is seconds, as is `PoseJumpThresholdTime` and `PoseReselectHistory`. During a search it evaluates the continuing pose first and then every database; the lowest total cost wins. The database's `ContinuingPoseCostBias`, `LoopingCostBias`, and `BaseCostBias` are cost addends/biases (the continuing pose default is -0.01, looping -0.005, base 0). The continuing candidate is therefore a competitor, not an unconditional hold. Pose jump threshold and reselect history are enforced by candidate filters in the database; the history update records selected poses for the stated seconds.

Formula/plain code: `search = !can_advance || elapsed_seconds >= throttle_seconds`; `total_cost = feature_cost + notify_addend + continuing_pose_addend + continuing_interaction_addend + continuing_context_addend`.

Citations: M1a, M1b, M1c.

### M2
The database obtains query values from the schema and compares them with each candidate's feature vector using `CompareFeatureVectors`, passing square-root dynamic weights; `FPoseSearchCost` then adds metadata and continuing addends. In plain code, `feature_cost = sum_i(weight_i * (pose_i - query_i)^2)` (the implementation passes square-root weights to the vector comparator, so the effective contribution is the configured weight). Schema `Normalize` normalizes features against deviation and normalizes user weights to a unit vector. A pose channel expands each sampled bone's flags into position, heading/rotation, velocity, and phase subchannels; position and velocity weights are `SampledBone.Weight * channel.Weight`, and velocity uses character-space velocities when `bUseCharacterSpaceVelocities` is true. The actual bones are whatever `SampledBones` names; the constructor defaults only to left/right feet with position+velocity flags. `PCAKDTree` projects the query into PCA space and asks the KD tree for a clamped neighbor count, then evaluates candidates/costs rather than changing the cost formula.

Citations: M2a, M2b, M2c, M2d.

### M3
When the selected result is not continuing, `bJumpToPose` is true and the node calls `FAnimNode_BlendStack_Standalone::BlendTo` with `BlendTime`, `BlendOption`, and `bUseInertialBlend`. The selected animation begins at `SearchResult.SelectedTime`; mirroring, looping, blend parameters, and desired play rate are passed too. Inertialization is not implicit: the node requests the inertialization graph scope only when both a jump and `bUseInertialBlend` are true; with its default false, the blend stack performs its ordinary blend/crossfade behavior.

Citations: M3a, M3b.

### M4
An interaction asset is a `UMultiAnimAsset` whose `Items` associate an `Animation`, `Role`, origin, and per-role warp weights; `GetNumRoles()` is `Items.Num()`. The multi-character search builds role/context combinations, calls one `MotionMatch` with all contexts, roles, and pose histories, and sorts valid searches by role count then lowest shared `PoseCost`. The selected `UMultiAnimAsset` is then mapped back by role, producing one result for each role. An interaction island is the runtime grouping that owns the search contexts and participant animation contexts: it performs searches only once from its main animation context, adds every role's pose history to one search context, and later exposes each role's result. Alignment samples each role animation's root at the selected time, computes weighted asset/actor reference positions and orientations, and applies `(asset_root * asset_reference_inverse) * actor_reference`; `WarpingBankingWeight` changes the iterative vertical banking adjustment, while `MinimalTranslationWeight` lerps the full warp toward the minimal-translation solution.

Citations: M4a, M4b, M4c, M4d.

### R
INFERENCE: build one database per compatible boxer schema with the stance, walk, jab, cross, hooks, body shot, reactions, block, slip, and knockdown clips sampled into pose/velocity/trajectory features; use a strike/reaction `UMultiAnimAsset` interaction asset with roles `striker` and `defender`, paired timing, origins, and root-warp weights. The code requires the paired assets, role-labelled schemas, pose histories, and interaction search plumbing that our bought single clips do not provide. This is an implementation recommendation, not a claim that the Unreal files prescribe boxing content.

Citations: R1.
