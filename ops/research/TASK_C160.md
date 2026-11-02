# TASK_C160 - CODEX - THE DEPTH RADIUS CONTRACT, WRITTEN BLIND

**Owner:** codex. **Model:** `gpt-5.6-luna`, MEDIUM.
**Test tier:** parse gate, then YOUR ONE NEW TEST ONLY. Do NOT run the suite.

## Why you, and why blind

S48 changed how the trunk's capsule radius is derived, and the change has only
its author's own test plus a contract test written before it existed. Your C158
and C159 both landed first-pass this week and C159 caught an ambiguity by
arguing with the module rather than agreeing with it. This is the same job on
the derivation itself.

**Do NOT read `Godot/scripts/FighterCapsules.gd`,
`research/S48_THE_TORSO_AND_THE_HOLD.md`, `tools/s48_thorax_depth.gd` or
`tools/s47_contact_offsets.gd`.** Write the witness from the contract below.

## Owned files

- `Godot/tests/fighter_depth_radius_contract_test.gd` - NEW, yours alone.
- `research/C160_DIGEST.md` - NEW.

## The contract

`FighterCapsules.gd` is a pure module (`load()` it, no `class_name`).
`build_report(skel: Skeleton3D, height_scale: float) -> Dictionary` returns
`{"capsules", "sources", "allow", "missing", "vertices"}`.

1. **`capsules` entries carry EXACTLY four keys** - `name`, `p0`, `p1`, `r` -
   and nothing else. `p0`/`p1` are `Vector3` in metres, `r` a float.
2. **`allow` maps every capsule name to a float in METRES**, and it is
   **0.0 for every capsule except the trunk**. Assert the zeros explicitly;
   a test that only checks the non-zero one passes on a module that returns a
   bonus for everything.
3. **`sources` maps every capsule name to a string saying how its radius was
   derived.** A depth-derived capsule's source **begins `depth:`** and carries
   the radius bone, the vertex count and the forward axis. An authored one is
   `authored`. A skin-measured one begins `skin:`. A blob begins `blob:`.
4. **The forward axis is DERIVED FROM THE SKELETON, never a constant.** Its
   three components appear in the `depth:` source string. **Assert that the
   axis read off rig A and the axis read off rig B agree to within 0.05 per
   component** - two different rigs at two different statures must yield
   essentially the same body-forward direction, and that agreement is the only
   evidence the axis is derived rather than guessed.
5. **A depth radius is SMALLER than the isotropic p80 of the same skin** and
   **larger than zero**. It must also fall inside `RADIUS_MIN_M` (0.02) and
   `RADIUS_MAX_M` (0.20).
6. **`allow` for a depth capsule is BREADTH minus DEPTH**, so it is
   **strictly less than** `isotropic_p80 - depth_p80`. If the module returns an
   allowance equal to or larger than that difference, it is using the wrong
   quantity - **assert the inequality, because that exact error shipped and was
   corrected once already.**
7. **`anatomy(report)` returns `{"adj", "allow"}`.** `adj` maps every capsule
   name to a sorted Array of names it is declared anatomically adjacent to;
   adjacency is symmetric and **no capsule is adjacent to itself**.

**The two shipped rigs** are `res://assets/models/fighters/f01_m_box_welter_rigged.glb`
at 1.78 m and `f02_m_box_heavy_rigged.glb` at 1.88 m. The scale factor is
`FighterPhysique.height_scale(mesh_height, target_height)`. **Both rigs, never
one twice.**

## Mutants - four that MUST fire

Copy the module to a scratch file, break it, inject the copy (**not behind
`--`**) and confirm RED:

1. `axis_constant` - return a fixed `Vector3.BACK` instead of deriving it.
2. `allow_isotropic` - allowance = isotropic minus depth instead of breadth
   minus depth.
3. `depth_is_iso` - the depth mode returns the isotropic p80.
4. `allow_everywhere` - give every capsule the trunk's allowance.

And one that **MUST NOT** fire: `swap_rig_order` - measure f02 before f01.
Order must not change any assertion. If it reddens, your test depends on
iteration order and is measuring the wrong thing.

## Gate

```
python Godot/tools/check_scripts.py Godot/tests/fighter_depth_radius_contract_test.gd
"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe" --headless --path Godot --script tests/fighter_depth_radius_contract_test.gd
```
The exit code alone is NOT a pass - read `checks=N failures=M` and treat any
line starting `ERROR:` as a failure. Do NOT run the full suite.

## WHAT ALREADY EXISTS

`RESEARCH_INDEX.md` lists 789 research documents and 220 tools. **GREP IT, do
not read it whole.** Worth a grep: `capsule`, `contract`, `mutant`. **Do not
open any S48 file** - that is the point of this task.

## Shared checkout

Claude is working in it. NEVER `git stash`, `git reset --hard`,
`git checkout .`, `git clean` or `git add -A`. Explicit paths only. Commit,
push master, then:
```
python Tools/agent_comms.py send --from codex --to claude --subject c160-ready --body "..."
```
Do NOT edit `HANDOFF.md`.

## THE ONE TRAP

**Point 6 is the one worth your care.** Both quantities are plausible, both are
small, and the difference between them is about a centimetre - which is exactly
why the wrong one shipped. `isotropic` is the full 3D offset and therefore
combines both axes, so it sits ABOVE the breadth alone. An allowance built on
it is too generous and excuses penetration nothing is resting on. **Assert the
strict inequality, not an approximate equality.**
