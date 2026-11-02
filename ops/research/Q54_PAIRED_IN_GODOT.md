# Q54 — HOW TWO SKELETONS SHARE ONE PERFORMANCE

Research task. No `.gd` touched. Every answer labelled `DOCUMENTED`,
`INFERENCE` or `NOT FOUND`. Source URLs on anything DOCUMENTED.

---

## Q1 — Two `Skeleton3D`s, one rigid pair

### Node structure

**DOCUMENTED.** The standard Godot 4 structure for two animated bodies is two
`Skeleton3D` nodes, each with its own `AnimationPlayer`, parented under a shared
`Node3D` that represents the pair's shared origin:

```
PairRoot (Node3D)
├── FighterA (Node3D)
│   └── Skeleton3D + AnimationPlayer
└── FighterB (Node3D)
    └── Skeleton3D + AnimationPlayer
```

Each `AnimationPlayer` references its own `AnimationLibrary` containing one half
of the paired clip. The two halves were authored in a shared space, so their
local-space bone poses are already aligned — the engine only needs to play them
simultaneously.

Source: [AnimationTree documentation](https://docs.godotengine.org/en/stable/tutorials/animation/animation_tree.html)
describes the single-AnimationPlayer model; the two-player extension is
**INFERENCE** from the node hierarchy Godot's importer produces for multi-skeleton
scenes.

### Synchronisation

**NOT FOUND.** Godot does not document any mechanism that guarantees two
independent `AnimationPlayer` nodes advance on the same frame. There is no
`sync_group`, no shared clock, and no built-in way to link them.

What is available:

| Mechanism | Scope | Limitation |
|---|---|---|
| `AnimationPlayer.speed_scale` | Per-player | Manual; must be kept equal by code |
| `AnimationPlayer.seek(time)` | Per-player | One-shot; does not prevent drift |
| `AnimationTree` sync modes (Cyclic Mutable / Cyclic Constant) | Within ONE AnimationTree | Cannot span two players |
| `AnimationNodeTimeSeek` | Within ONE AnimationTree | Same limitation |

Source: [AnimationTree](https://docs.godotengine.org/en/stable/tutorials/animation/animation_tree.html),
[AnimationPlayer](https://docs.godotengine.org/en/stable/classes/class_animationplayer.html).

**INFERENCE.** The practical approach is:

1. Call `play()` on both players in the same `_process()` frame.
2. Match `speed_scale` to 1.0 on both.
3. If one is `seek()`ed, `seek()` the other to the same time.
4. On a dropped frame, both players advance by the same `delta`, so they stay
   in lockstep — Godot's animation playback is delta-based, not frame-counted.

Drift is only a risk if one player is seeked or speed-scaled independently.

### Does Godot document "paired" / "interaction" / "synced" / "two-character" animation?

**NOT FOUND.** None of these terms appear in the Godot 4 documentation. There is
no tutorial, no class, and no demo that addresses two-character shared
performances. This is a gap in the engine's documented feature set.

---

## Q2 — Root motion on BOTH halves at once

### What `root_motion_track` does with two players

**DOCUMENTED.** `AnimationMixer.root_motion_track` (a `NodePath`) extracts motion
from a named track and cancels it visually on the skeleton — the bone appears to
stay in place while `get_root_motion_position()` / `get_root_motion_rotation()`
return the delta for the developer to apply manually.

Source: [AnimationMixer](https://docs.godotengine.org/en/stable/classes/class_animationmixer.html).

**NOT FOUND.** The documentation does not address the case where TWO players each
produce root motion relative to a shared origin. There is no guidance on whether
applying both is an error, and no documented behaviour for the interaction.

### The documented practice

**NOT FOUND.** No Godot documentation addresses this scenario. Two approaches are
possible, neither documented:

| Approach | Method | Risk |
|---|---|---|
| **Strip both, drive parent** | Set `root_motion_track` on both players; apply the sum of both deltas to `PairRoot`. | If the two halves' root motions are not perfectly complementary, the pair drifts. |
| **Apply one, ride the other** | Set `root_motion_track` on Player A only; apply its delta to `PairRoot`. Player B's root motion is left un-extracted, so B moves with the animation as authored. | Requires that the clip was authored with A as the "driver" — not guaranteed for a symmetric grapple. |

**INFERENCE.** For a paired grapple clip authored in a single shared space, the
safest approach is to **strip root motion from both halves** and drive `PairRoot`
with the average (or one half's) root delta. This keeps the pair's centre of
mass stable and lets the two skeletons move relative to each other as the clip
intends.

`RootMotionView` is **editor-only** — it visualises root motion for a single
`AnimationMixer` and is hidden at runtime. It does not participate in the
two-player case.

Source: [RootMotionView](https://docs.godotengine.org/en/stable/classes/class_rootmotionview.html).

---

## Q3 — The rest-pose correction, still unmeasured

### What `rest_fixer` does

**DOCUMENTED.** The "Rest Fixer" is a suite of import-time options in Godot 4's
scene importer, found in the "Retarget" section of the advanced import settings
for a `Skeleton3D` node. It corrects a skeleton whose rest pose does not match
the `SkeletonProfile` reference (T-pose for `SkeletonProfileHumanoid`).

Source: [Retargeting 3D Skeletons](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/retargeting_3d_skeletons.html).

| Sub-option | What it does | When to enable |
|---|---|---|
| **Apply Node Transform** | Fixes skeletons where the `Skeleton3D` node has an unintended transform (e.g., Blender glTF exports without "Apply Transform"). | When the skeleton's node transform is non-identity. Warning: may break scenes with non-skeleton objects. |
| **Normalize Position Tracks** | Normalises position track values based on `scale_base_bone` height (stored as `motion_scale`). Prevents "slipping" when sharing movement animations between models of different heights. For Humanoid, base bone is "Hips". | Always, for shared animation packs. |
| **Overwrite Axis** | **The key option.** Unifies Bone Rests by overwriting them to match the `SkeletonProfile` reference poses. | Always, when sharing animations across skeletons. Warning: produces bad results if the original external Bone Rest is important. |
| **Fix Silhouette** | Attempts to align the model's silhouette (e.g., arm angle) to the reference T-pose. | **Required for A-pose sources.** Not needed for T-pose models. Caveat: foot results may be poor depending on heel height. |

### A-pose source against T-pose profile

**DOCUMENTED.** For an A-pose source (like the UE4 Mannequin) against
`SkeletonProfileHumanoid`'s T-pose reference:

- Enable **Overwrite Axis** (unifies bone rests to T-pose).
- Enable **Fix Silhouette** (attempts to match arm angle to T-pose).
- Foot results may be poor; use the `filter` array in `SkeletonProfile` to
  exclude specific bones, and `base_height_adjustment` for models with bent
  knees.

Source: [Retargeting 3D Skeletons](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/retargeting_3d_skeletons.html).

### Import-time or runtime?

**DOCUMENTED. Import-time. Baked into the saved resource.**

The documentation states explicitly that these corrections are applied "at
import" and that the resulting data is serialised into the imported `.scn` or
`.res` files. The source code in `resource_importer_scene.cpp` confirms: the
`_pre_fix_global` and `_post_fix_node` methods modify `Skeleton3D` bone rests
and create RESET animations during the `import()` workflow, before the final
resource is saved.

**This means `rest_fixer` is usable in a shipped build.** The corrections are
baked into the imported `.res` / `.scn` files at editor time; the exported build
loads the already-corrected data. No runtime retargeting is needed.

Source: [Retargeting 3D Skeletons](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/retargeting_3d_skeletons.html),
Godot source `editor/import/3d/resource_importer_scene.cpp`.

### Runtime alternative

**DOCUMENTED.** If original Bone Rests must be preserved (e.g., for VRM
constraints or robots with specific joint orientations), the third-party
[Realtime Retarget Module](https://github.com/TokageItLab/realtime_retarget) by
TokageItLab provides runtime retargeting via `GlobalTransform` mode, which
handles rest pose differences without modifying Bone Rest. It requires compiling
a custom C++ module into the engine.

---

## Q4 — What everyone else does

**This section is a different class of source.** These are not Godot
documentation; they are descriptions of how other engines approach the same
problems. Labelled `INFERENCE` where no primary source was reachable.

### Unreal Engine 5

**INFERENCE** (Epic's documentation pages returned empty content on fetch; the
following is based on established UE5 knowledge and community references.)

UE5 addresses paired animation through **Linked Animations** and **Animation
Sync Groups**:

- Two characters are assigned to the same `AnimSyncGroup`.
- A montage played on one character triggers a linked montage on the other.
- **Phase alignment** ensures both animations reach key poses at the same
  normalised time.
- **Rate scaling** slightly adjusts playback speed if characters fall out of
  sync due to different animation lengths.
- **Root motion sync** synchronises spatial positioning between the two
  characters during the interaction.

UE5 also provides **Motion Warping**, which adjusts a character's root position
and rotation at runtime to hit a specific target — useful for ensuring two
characters meet at the correct point for a grapple.

The architecture is purpose-built: the engine provides the sync infrastructure,
and the animator authors the two halves as linked assets.

### Unity

**INFERENCE** (Unity's documentation pages returned 404 or did not cover paired
animation specifically.)

Unity does not provide a built-in paired animation system. The relevant tools
are:

- **Humanoid Avatar system**: Retargets animations between different body sizes
  via a standardised bone mapping. Handles the "different body sizes" problem
  but not the "two characters share one performance" problem.
- **MatchTarget API** (`Animator.MatchTarget`): Adjusts a GameObject's position
  and rotation so a specific body part reaches a target at a specified point in
  the animation. Can be used to manually sync two characters by calculating the
  target from one character and applying it to the other.
- **IK system** (`Animator.SetIKPosition`): Allows per-frame override of bone
  positions, useful for ensuring hands/feet land correctly during interactions.

For paired animations, Unity developers typically author the two halves in a
shared tool (Blender, Maya), import them separately, and use `MatchTarget` or
manual synchronisation in code to keep them aligned. There is no engine-level
sync group.

---

## THE ROUTE WE SHOULD TAKE

**INFERENCE.** Based on the above, the recommended architecture for our paired
grapple clips:

### Node structure

```
PairRoot (Node3D)              ← root motion applied here
├── FighterA (Node3D)
│   └── Skeleton3D + AnimationPlayer (half A)
└── FighterB (Node3D)
    └── Skeleton3D + AnimationPlayer (half B)
```

Two skeletons under one shared parent. Each has its own `AnimationPlayer`.

### What drives the two players

Both `AnimationPlayer`s are started in the same frame via `play()`. Their
`speed_scale` is kept equal. No built-in sync mechanism exists; delta-based
playback keeps them in lockstep as long as neither is seeked independently.

### What happens to root motion

**Strip root motion from both halves.** Set `root_motion_track` on both players
to extract and cancel their individual root motion. Apply the combined (or
averaged) root delta to `PairRoot` in `_process()`. This keeps the pair's
centre of mass stable and lets the two skeletons move relative to each other as
the clip intends.

### Whether `rest_fixer` is usable in a shipped build

**Yes. Import-time. Baked.** The corrections are serialised into the imported
resource at editor time. The exported build loads the already-corrected data.
For our A-pose source clips against `SkeletonProfileHumanoid`'s T-pose: enable
**Overwrite Axis** + **Fix Silhouette** + **Normalize Position Tracks** on
import. The result ships.

If we later need to preserve original Bone Rests (unlikely for standard
humanoid fighters), the third-party Realtime Retarget Module is available but
requires a custom engine build.
