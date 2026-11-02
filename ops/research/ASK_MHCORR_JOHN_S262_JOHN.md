# ASK_MHCORR_JOHN_S262_JOHN - John answer (seat queue SQ4)

Brief: research/ASK_MHCORR_JOHN_S262.md
Sent: 2026-10-19 16:10 | collected: 2026-10-19 16:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it. I'm researching the MetaHuman body correctives in UE 5.8 now: where they're evaluated, how to sample them headless from Python, the RBF solver details, and the licence question. I'll paste the full answer with sources when it's done.

The S262 research on MetaHuman body correctives is running now. I'll paste the full answer here when it's done, including the UE Python steps, asset names, RBF parameters and risks.

**S262: MetaHuman body correctives in UE 5.8 (part 1 of 3)**

Short answer: for UE 5.6+ MetaHumans, the body helper joints are driven by RBF solvers stored in the **body DNA** and evaluated by **RigLogic**. They are not driven by AnimGraph Pose Driver nodes. Epic's open-source **OpenRigLogic** (MIT, with a `5.8` branch and Python bindings) runs the same evaluation outside UE. That means you can read every solver straight from the DNA and port it to Godot exactly, so you may not need grid sampling at all. I ran no UE or Godot code, so every code sketch is untested. Sources are tagged S1 to S11, with the list in part 3. Anything I couldn't verify is marked GUESS.

**Q1. Where body correctives are evaluated (5.6 to 5.8)**
- **They're RBF solvers in the body DNA, run by RigLogic.** The Body Conform doc says "Auto Rig Helper Joints … helper joints will be repositioned … and RBF weights will be recalculated" and "Helper joints and RBFs will remain unchanged from the current MetaHuman state", so the RBFs are part of the character's data (S2). OpenRigLogic says DCC Export produces "a DNA file for the head and a DNA file for the body, the inputs needed to drive the character … same runtime rig evaluation as Unreal Engine" (S4).
- **The DNA has an RBF layer, `RBFBehaviorReader`** (S4a). Per solver it exposes getRBFSolverCount, Name, Type, Radius, AutomaticRadius, WeightThreshold, DistanceMethod, NormalizeMethod, FunctionType, TwistAxis, RawControlIndices, RawControlValues and PoseIndices. Per pose it exposes getRBFPoseName, JointOutputIndices, JointOutputValues, Scale, InputControlIndices, OutputControlIndices and OutputControlWeights. There's also a separate joint-behaviour layer.
- **Epic staff confirm the switch.** For "MetaHuman Creator in Unreal Engine 5.6, or … UERBFSolvers", Epic recommends "Pose Editor from the MetaHuman for Maya plugin instead of Pose Driver Connect … for the performance gains" (Chris Theodosius, Epic, forum post of 2025-08-21, S3).
- **The runtime switch is on the MetaHuman component.** It has "Enable Body Correctives" ("Preserves the volume and realistic skin deformations …"), with an LOD threshold that defaults to **LOD0 only**. Each body part also has an optional "Control Rig Class … Evaluation happens after the base skeleton gets evaluated as a post-process". The neck has its own "Neck Correctives (pose drivers)" and "Neck Procedural Control Rig" (S1).
- **Older MetaHumans (Bridge, before 5.6) worked differently.** Their helper joints were driven by Pose Driver nodes in a post-process AnimBP that is set on the skeletal mesh and runs after the main AnimBP (S11). The asset names I remember, `ABP_Body_PostProcess` and `ABP_Face_PostProcess` under /Game/MetaHumans/Common/, are a GUESS that I didn't verify this session.
- **The exact 5.6+ asset and class names are GUESS.** That covers the `MetaHumanCharacter` plugin and asset, the assembled `BP_<Name>`, a `UMetaHumanComponentBody`-style component, and a RigLogic AnimNode such as `FAnimNode_RigLogic`. Step 1 of the run list checks them in MHPilot.

**Q2. Running it headless and reading helper transforms (most reliable first)**
- **A. OpenRigLogic Python on the body DNA (recommended).** It's pure CPU, so it's headless by construction and needs no UE at runtime. Build it from `git clone -b 5.8` with CMake, SWIG and Python dev headers (S4 README). Get `body.dna` from MetaHuman Creator **Export > DCC Export** (S4). Untested sketch, with API names from S4c and S4a:
```python
import dna, riglogic, json
s = dna.FileStream("body.dna", dna.FileStream.AccessMode_Read, dna.FileStream.OpenMode_Binary)
r = dna.BinaryStreamReader(s, dna.DataLayer_All); r.read(); assert dna.Status.isOk()
rl = riglogic.RigLogic(r); ri = riglogic.RigInstance(rl)
names = [r.getRawControlName(i) for i in range(r.getRawControlCount())]  # GUESS method name
# set driver-joint local rotation quats (relative to neutral: GUESS convention)
for i, v in my_pose_controls.items(): ri.setRawControl(i, v)
rl.calculate(ri)
out = ri.getJointOutputs()  # per joint 9 or 10 attrs (t, r[q], s): GUESS layout
```
The basic calls come from Epic's `demo.py`. The control-name lookup, the output layout and the input convention are GUESS.
- **B. Tick a mesh in an editor world.** Spawn the assembled BP or a SkeletalMeshActor, pose it with a one-frame AnimSequence or a PoseableMesh, tick it, then read `get_socket_transform(bone, unreal.RelativeTransformSpace.RTS_PARENT_BONE_SPACE)`. Under `-run=pythonscript` no level ticks, so you'd have to force the animation update, which makes this route unreliable. The mesh also needs `AlwaysTickPoseAndRefreshBones` and correctives at LOD0. Whether this works with `-nullrhi` is a GUESS: RigLogic itself is CPU-only, so the risk is the component ticking in a commandlet.
- **C. Bake through Sequencer with the post-process left on.** A tutorial warns that baking with the post-process on bakes the correctives in, causing the "double offset" problem (S11), and that's exactly what you want here. The 5.8 API is GUESS, and it probably needs an editor that can render (GUESS).
- **D. Control Rig Python** (`ControlRigBlueprint`, `RigHierarchy`). This only applies if the correctives lived in a Control Rig, and the body Control Rig slot is optional (S1) and probably empty by default (GUESS). Not recommended.

**S262 (part 2 of 3): reading the RBF data, and the RBF math**

**Q3. Reading the solver data directly**
- **From the DNA, everything is readable** through `RBFBehaviorReader` (S4a, method list in Q1) via the SWIG `dna` Python module (S4).
  - Per solver you get the type, the radius, automatic radius, the threshold, the distance method, the normalize method, the function and the twist axis. You also get the raw control values, which are the target poses flattened, and the pose indices.
  - Radius is converted between degrees and radians on load, via angConv in `CPURBFBehaviorFactory.h` (S4b).
  - Per pose you get the joint output indices and values (the helper-joint deltas), the scale, and the output control weights.
- **From the older Pose Driver nodes:** `unreal.RBFParams` exposes `solver_type`, `radius`, `automatic_radius`, `function`, `distance_method`, `twist_axis`, `weight_threshold`, `normalize_method`, `median_reference`, `median_min` and `median_max` (S5).
  - Reaching the node inside an AnimBP graph from Python isn't documented. `AnimGraphNode_PoseDriver` and the runtime `FAnimNode_PoseDriver`, with members like `RBFParams`, `PoseTargets` and `SourceBones`, aren't exposed through the standard Python graph APIs.
  - GUESS: you'd need a small C++ helper, or to copy the node out as text (a T3D paste).

**Q4. The RBF math to port**
- **UE AnimGraph enums** (`/Engine/Source/Runtime/AnimGraphRuntime/Public/RBF/RBFSolver.h`, S5 and S6):
  - RBFFunctionType: Gaussian 0, Exponential 1, Linear 2, Cubic 3, Quintic 4, DefaultFunction 5.
  - RBFNormalizeMethod has four values:
    - OnlyNormalizeAboveOne 0.
    - AlwaysNormalize 1.
    - NormalizeWithinMedian 2: a "cone with min and max angle within which the value will be interpolated between non-normalized and normalized".
    - NoNormalization 3: "only with interpolative … inputs within area bounded by targets".
  - RBFDistanceMethod: Euclidean, Quaternion, SwingAngle, TwistAngle, DefaultMethod.
- **The DNA/RigLogic version** has only OnlyNormalizeAboveOne and AlwaysNormalize, and no Default* values (S4 RBFBehavior docs page).
- **Exact formulas from OpenRigLogic's `RBFSolver.cpp`** (S4b). Here d is the distance and r is the radius, which the source calls kernelWidth.
  - **Distance:**
    - Euclidean: \( d = \sqrt{\sum (t_i - x_i)^2} \).
    - Quaternion: per quaternion, \( \text{arc} = \arccos(2\,(q_a \cdot q_b)^2 - 1) \), or 0 if dot² > 1; then \( d = \sqrt{\sum \text{arc}^2} \). Inputs must be normalized.
    - SwingAngle: reduce the input and the targets to their swing part about the twist axis, then use the Quaternion arc.
    - TwistAngle: zero the non-twist components, renormalize (twist, w), unwind the angle into [−π, π], and use \( d = \sqrt{\sum \Delta\text{angle}^2} \). The jump at ±180° is deliberate, and a source comment says it matches UE's `FQuat::GetTwistAngle`.
  - **Kernels:**
    - Gaussian \( w = e^{-d/r^2} \). Note that d is **not** squared, exactly as in the source.
    - Exponential \( w = e^{-2d/r} \).
    - Linear \( w = \max(0, 1 - d/r) \).
    - Cubic \( w = \max(0, 1 - (d/r)^3) \).
    - Quintic \( w = \max(0, 1 - (d/r)^5) \).
  - **Automatic radius** is the mean distance over all N(N−1)/2 pairs of targets.
  - **Additive solver:** \( w_i = \text{kernel}(d_i) \), then normalize and cut off.
  - **Interpolative solver:** build the N×N matrix \( A_{ij} = \text{kernel}(\text{dist}(t_i, t_j)) \), diagonal included, and invert it with LU. At runtime \( w = \text{clamp}(A^{-1}\varphi(x), 0, 1) \) per element, then normalize and cut off.
  - **Normalize and cut off:** let s = Σw. The ratio is 1/s if s > 1 or the method is AlwaysNormalize; otherwise it's 1. Then \( w_i \leftarrow w_i \cdot \text{ratio} \cdot \text{poseScale}_i \), and \( w_i = 0 \) if it's at or below weightThreshold.
  - **Output:** helper joint = neutral + Σ (pose weight × that pose's jointOutputValues). This is a GUESS: the exact composition, meaning per-attribute additive deltas and how rotations combine, lives in `src/riglogic/rbf/RBFBehaviorOutputInstance.cpp`. Read it before porting.
- **Not verified:** that UE's own AnimGraph `FRBFSolver` uses the same kernels, and the NormalizeWithinMedian maths. My GUESS is that they match, since the TwistAngle comment claims parity with UE.

**S262 (part 3 of 3): licence, run list, parameters, risks, sources**

**Q5. Licence**
- **Other engines are allowed.** "We've updated the Unreal Engine EULA so MetaHuman characters and animation can be used in any engine, such as Unity or Godot" (S8). The licence page says "MetaHuman is included as part of your standard Unreal Engine license … free to use for anyone making under $1 million USD … MetaHumans can be used with any engine or creative software" (S7).
- **FAQ, quoted second-hand via S9.** The FAQ answers on metahuman.com are collapsed and wouldn't load.
  - "MetaHuman characters and animation are classed as Non-Engine Products under the Unreal Engine EULA, so neither their use as linear media output or at runtime in games … using engines other than Unreal Engine triggers royalty obligations."
  - "If you make over $1 million USD in annual gross revenue and render MetaHuman characters and animation outside of Unreal Engine, you'll need an Unreal Engine seat license."
  - On AI, you may use MetaHumans in "workflows that incorporate artificial intelligence technology", but not to train or enhance AI models.
- **Your helper-joint table** is rig data derived from a 5.6+ MetaHuman body. It is very likely covered as part of the character you ship in Godot. That's a GUESS and not legal advice: the FAQ talks about "characters and animation", and I found no wording about rig-data tables. Check the EULA's Non-Engine Products text, and never feed this data into AI training.
- **OpenRigLogic is MIT** (GitHub spdx MIT, S4). Using it to evaluate or port the solvers is fine. Keep the MIT notice if you ship ported code.
- **Don't use MetaHuman-DNA-Calibration** (S10).
  - Its licence is proprietary: "license to reproduce and prepare derivative works … for the sole purpose of developing and using tools that enable third-party software programs to export and edit digital characters … You may not distribute the Software".
  - Characters made with it "may only be used in conjunction with Unreal Engine".
  - Its README says it "has not been updated to support MetaHuman characters created in … 5.6".

**Run list (all untested)**
1. **Probe in UE.** This is asset reads only, so headless is fine. Add it to `mh_probe.py`:
```python
import unreal
sk = unreal.load_asset("/Game/MetaHumans/<Name>/Body/<BodyMesh>")  # GUESS path
print(sk.get_editor_property("post_process_anim_blueprint"))
for a in unreal.EditorAssetLibrary.list_assets("/Game/MetaHumans", recursive=True):
    if any(k in a for k in ("DNA", "RigLogic", "ABP", "PostProcess")): print(a)
```
2. **Get `body.dna`** from MetaHuman Creator **Export > DCC Export** (S4). The alternative is the DNA asset in the body mesh's asset user data (`UDNAAsset`, GUESS).
3. **Build OpenRigLogic** from the `5.8` branch with its Python wrappers (CMake + SWIG), and run `demo.py` on `body.dna` (S4c).
4. **Dump the solvers to JSON** with `RBFBehaviorReader`. Keep the ones whose pose joint outputs touch lowerarm_*, upperarm_*, clavicle_* and the twist joints.
5. **Pick one route:**
   - (a) Port the exact solver to Godot (GDScript or C#, using the Q4 formulas). Its inputs are the driver joints' local quats relative to neutral (GUESS convention; step 6 checks it).
   - (b) Sample your grid through `riglogic` (elbow 0/30/60/90/120/145 × roll −60/0/+60, plus the shoulder grid) and write the helper transforms to JSON.
6. **Validate a few poses** against UE using route B (with a viewport if needed). Compare parent-space helper transforms to a tolerance of 1e-3 cm and 0.05°.

**RBF parameters:** read them from the DNA rather than assuming them. The only fields defined (S4a) are type, radius, automaticRadius, weightThreshold, distanceMethod, normalizeMethod, function and twistAxis. Typical MetaHuman values (Quaternion or Swing distance, Gaussian, Interpolative) are a GUESS.

**Risks**
- The 5.6+ asset and class names are unverified, and the older Pose Driver names don't apply to 5.6+ characters.
- Headless UE ticking (routes B and C) may never run the correctives, so prefer OpenRigLogic.
- The input convention still needs checking: local versus neutral-relative quaternions, axis order, units, and the per-LOD solver lists (`getRBFSolverIndicesForLOD`).
- The UE-to-Godot change (Z-up cm to Y-up m) has to be applied to both inputs and outputs.
- TwistAngle jumps at ±180°, by design.
- In UE, body correctives default to LOD0 only (S1).
- The licence wording for rig tables is unconfirmed, and AI training is prohibited.

**Sources**
- S1 [MetaHuman Component doc](https://dev.epicgames.com/documentation/en-us/metahuman/the-metahuman-component-for-unreal-engine)
- S2 [Body Conform Controls doc](https://dev.epicgames.com/documentation/en-us/metahuman/body-conform-controls)
- S3 [Pose Driver Connect forum thread, page 4](https://forums.unrealengine.com/t/tutorial-authoring-secondary-animation-in-maya-and-unreal-with-pose-driver-connect/1496699?page=4)
- S4 [OpenRigLogic on GitHub](https://github.com/EpicGames/OpenRigLogic) and its [docs](https://epicgames.github.io/OpenRigLogic/), plus the source files `RBFBehaviorReader.h`, `RBFSolver.cpp`, `InterpolativeRBFSolver.cpp`, `AdditiveRBFSolver.cpp`, `CPURBFBehaviorFactory.h` and `demo.py`
- S5 [UE 5.8 Python RBFParams](https://dev.epicgames.com/documentation/en-us/unreal-engine/python-api/class/RBFParams)
- S6 [FRBFSolver C++ API](https://dev.epicgames.com/documentation/en-us/unreal-engine/API/Runtime/AnimGraphRuntime/FRBFSolver)
- S7 [MetaHuman licence page](https://www.metahuman.com/license)
- S8 [State of Unreal 2025 news](https://www.unrealengine.com/en-US/news/all-the-big-news-and-announcements-from-the-state-of-unreal-2025)
- S9 [CG Channel, June 2025](https://www.cgchannel.com/2025/06/you-can-now-sell-metahumans-or-use-them-in-unity-or-godot/), plus an r/Unity3D thread quoting the FAQ
- S10 MetaHuman-DNA-Calibration README and LICENSE on GitHub
- S11 [UE5 post-process corrective pose drivers (YouTube)](https://www.youtube.com/watch?v=52wKKVbzyk8)

As you asked, this is a text answer only, so nothing was saved to Beast and Claude wasn't pinged.
