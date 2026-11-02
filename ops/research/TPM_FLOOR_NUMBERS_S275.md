# TPM floor measurements (S275 / FLOORTPM1 Step 0)

Read from the operator's installed Unity 6000.0.63f1 build on 2026-10-20.
Numbers and rules only. Raw typetrees remain in
`E:/FightCamp/tmp/tpm_study/floortpm1/`; no TPM assets, scripts or graphs are
included here. UnityPy 1.25.3, fallback version 6000.0.63f1. Each extraction
ran at Windows IDLE priority (SetPriorityClass; psutil is absent).

This is a static-data study, not a live TPM motion measurement.
**UNOBSERVED means no measured value, not zero.** Mapped values below are
implementation guidance; this document does not assert they already ship.
Prior research: TWOPOINT_ALIGNMENT.md sections 1-4 and
TWOPOINT_MUSEUM_STUDY_S243.md. Camera, room and placement data were reused.

## Provenance

- `configs-common_assets_all.bundle`: Config_NavPath, Config_CharacterLimits,
  Config_GuestsManager_City, Config_LevelState.
- `configs_assets_all.bundle`: Guest_Generic, Guest_Child,
  Staff_Expert_Wiggy, Character_RemovalMan, Config_CharacterComponent,
  interaction definitions and selected staff behaviour graphs.
- Catalog-selected `60c51a418bba9df9cb2938f9495a5847.bundle`: container verified
  as PF_Character_Base.prefab.
- Catalog-selected `ee5d380d35a2a6d3b7fcf900f7289b4e.bundle`: container verified
  as PF_Character_F.prefab; `f35d0c1fa7c1ad40461995ba2096ab26.bundle`: child.
- Catalog-selected `56f9ee00835323f8ded0f069224f3a65.bundle`: Base_Walk/Run
  animation definitions. Selected basic clip bundles were inspected too.
- Only named bundles or the first dependency resolved for an exact catalog
  asset were loaded. No scan of all 9,223 bundles.

## Movement and person types

| TPM field / source | Stored value | FightCamp mapping |
|---|---|---|
| Config_NavPath.DefaultMovementSpeed | 1.85 | Candidate base floor speed 1.85 m/s; verify against our clip stride |
| Guest_Generic.Min/MaxRandomMovementSpeed | -0.2 / +0.2 | Walk-in variation may use this range; whether TPM adds or multiplies it is UNOBSERVED |
| Guest_Child.Min/MaxRandomMovementSpeed | -0.2 / +0.2 | No child actor in this task; do not create one |
| Character_RemovalMan.Min/MaxRandomMovementSpeed | -0.2 / +0.2 | Staff variation is role-specific, not one universal constant |
| Staff_Expert_Wiggy.Min/MaxRandomMovementSpeed | 0 / 0 | A measured unique staff example; not proof that all staff have zero variation |
| PF_Character_Base.RigWalkAnimMultiplier | 1.0 | Pace each of our clips by its measured stride speed |
| PF_Character_F.RigWalkAnimMultiplier | 1.1 | Rig-specific pacing exists; do not copy the multiplier onto a different rig |
| Base_Walk.ApplyRootMotion; Base_Run.ApplyRootMotion | 0; 0 | Navigation owns world translation; playing a walk clip alone must never count as movement |
| Base_Walk/Run motion-tree Speed entries | 1.0 | Playback multiplier, not metres/second |
| Separate WalkAnimation / RunAnimation references | present | Distinct locomotion states; coach always walks (C106) |
| Run world speed / StepStrideLength | UNOBSERVED | Do not label an invented run speed or stride as TPM-measured |
| Child basic walk / female basic run clip cycle | 0.8 s, 30 Hz, looping | Evidence of clip timing only; not our adult boxing stride |
| Those clips' m_AverageSpeed | (0,0,0) | In-place metadata cannot establish foot speed; measure our feet separately |

## Facing and starting / stopping

| TPM field / source | Stored value | FightCamp mapping |
|---|---|---|
| Config_NavPath.TurnSpeed | 900 | Candidate angular speed limit 900 degrees/s; not a measured exponential smoothing time |
| Config_NavPath.AccelerationSpeed | 100 | Candidate acceleration 100 m/s²; at 1.85 m/s an ideal linear ramp is 0.0185 s (derived, not measured) |
| Config_NavPath.MoveAnimMultiplierChangeSpeed | 2 | Candidate animation blend-rate limit 2/s; a full unit ramp would take 0.5 s if linear |
| Config_NavPath.MoveAnimMultiplierMaxIdle | 0.05 | Idle transition threshold; root motion must stop before a stationary walk loop persists |
| Facing smoothing time / separate deceleration | UNOBSERVED | No claim that the acceleration field proves stop time or turn smoothing |
| PF_Character_Base/F/Kid.IdleFlairMin/MaxWaitTime | 1 / 3 s | Waiting fidget cadence; use existing FightCamp motion only |

## Paths, avoidance and crowd capacity

| TPM field / source | Stored value | FightCamp mapping |
|---|---|---|
| Config_NavPath.AvoidanceType | 3 (serialized enum) | Avoidance enabled by data; enum meaning not established by this study |
| NavMeshSettings.AvoidancePredictionTime | 2.5 s | Candidate prediction horizon for local avoidance |
| NavMeshSettings.AgentRadiusForNavMeshOnly | 0.3 | Stored candidate clearance; **OverrideAgentRadiusForNavMeshOnly=0**, so not proof of effective capsule radius |
| NavMeshSettings.VoxelSize; OverrideVoxelSize | 0.15625; 1 | Navigation raster resolution, not item-placement grid |
| NavMeshSettings.PathFindingIterationsPerFrame | 5,000 | Budget evidence; use bounded local gym routes, not this global budget blindly |
| KinematicTTCMax / KinematicGoalForce / KinematicUpdateTime | 1.5 / 4 / 0.1 s | Alternate kinematic settings exist; active selection is UNOBSERVED |
| KinematicTTCToForce endpoints | time 0..1.5, force 8..0 | Predictive separation rule, not permission to push through walls |
| Default single-door waypoint z / extents | 0 and 2; (1, 0.4) | Door waypoints and clearance constrain routes |
| Spline radius / corner-cut distance / active capsule radius | UNOBSERVED | Preserve collision clearance; never smooth a route across an obstacle |
| Config_CharacterLimits.GuestSpawnLimits | low 200, medium 300, high 400, very high 600 | Whole-museum caps; not guests per cell |
| Config_GuestsManager_City.SpawnRateInSeconds / random percent | 12 / 10% | Spawn cadence, not walking speed |
| People per cell | UNOBSERVED | Do not convert room capacity (e.g. 0.4/cell) into collision density |
| FightCamp required stress condition | task specifies 60 s and overlap <=0.2 s | Validate separately with actual moving actor capsules |

## Item use and queues

| TPM field / source | Stored value / rule | FightCamp mapping |
|---|---|---|
| Interaction_Staff_Security_Chair.IgnoreRotation | 0 | Face the interaction slot before use |
| Interaction_Staff_ComputerBooth_Right context Side | 1 | Slots can be side-specific; position and facing belong to station data |
| Config_CharacterComponent animation states | enter, active loop, exit, idle flair | Explicit approach, face, enter, loop, exit, release lifecycle |
| BG_Character_Interaction_StaffRoom_Microwave | interact, wait 5 s, release | Duration is item/activity-specific; ours comes from the Day Plan |
| BG_Staff_Interaction_CheckoutTill | count participants (min 2), animation trigger, random wait 2..4 s | Paired work needs both participants before activity proceeds |
| Interaction_Bathroom_Hand_Dryer.MaxQueue / warning threshold | 3 / 3 | Queue capacity belongs to each interaction |
| Security chair / computer booth MaxQueue; NoAdditionalQueue | 0; 1 | Some interactions explicitly exclude extra queueing |
| Guest_Generic.MaxTimeToWaitForTicketDesk | 120 s | Queue patience exists; do not apply a ticket-desk timeout to boxing |
| AuthoredQueue_Thrill.MaxLength; BuildLShapes | 30; 1 | Authored queues have bounded geometry; no universal queue spacing measured |
| Universal enter/exit duration / queue spacing | UNOBSERVED | Use available clip lengths and capsule clearance, labeled as our choices |

## Staff and job items

| TPM field / source | Stored value / rule | FightCamp mapping |
|---|---|---|
| BG_Staff_Job_Research | interaction reference, move, interact, release, retry waits | Staff route to a reserved job interaction, rather than animate at their spawn |
| Research retry waits | fixed 2 s; random 1..2 s | Retry failed access without teleporting |
| Config_LevelState.StaffJobQueueCurve endpoints | input 0..4, output 1..4 | Job priority responds to queues; not a movement-speed multiplier |
| Job item staff cap (S244 measurement) | max 1 on 271 items | One receptionist/physio/manager per job item; paired pads have distinct fighter and coach slots |

## Camera / placement values reused

TWOPOINT_ALIGNMENT.md remains canonical: FOV 17; 0.5 m grid (1 m platforms);
90-degree stations / 45-degree decor; 100% unused / 65% used refund; room
required slots; maintenance thresholds 50/90. The task's camera constants
come from the existing Config_CameraLogic dump, not from person navigation.

## Remaining evidence

Static data did not establish effective per-role walk/run speed, effective
avoidance capsule radius, facing smoothing, separate braking time, path
corner smoothing, queue spacing or live people/cell. Those require a
targeted runtime/source follow-up; none is silently substituted with a
plausible-looking TPM number. Camera work can proceed independently.
