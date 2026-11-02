# TASK_G60 — `FightAnchorIK`: the two-bone solver S35's anchor bake needs

**Owner: Grok.  Expert mode, never Build.  ONE FILE. DO NOT WRITE A TEST.**

---

## WHY THIS EXISTS — the number that made it necessary

Measured today (S34) against CMU paired mocap, where the right answer is known:
a hand that grips an elbow at **0.141 m** in the capture ends up **0.339 m**
away after our retarget. **+140% at the closest contact, and only +4% where the
hands are far apart.** Contact specifically is what breaks, because rotation-only
retargeting puts identical joint angles on a differently-proportioned arm and the
hand lands somewhere else.

The fix is to drive the arm to a **position** instead of copying angles. That
needs a two-bone IK solver. **This task is that solver and nothing else.**

## WHAT YOU ARE WRITING

**ONE new GDScript file, `FightAnchorIK.gd`, with ZERO `preload` and ZERO
`load()`.** It must not reference any other file in this project. It is pure
maths over Godot's built-in `Vector3`, so it can be tested in a throwaway Godot
project holding only itself. Do not write a test — a separate task owns that,
written from this contract rather than from your code.

## THE CONTRACT — EXACT NAMES, EXACT ORDER, EXACT KEYS

A test you will never see calls these. Every name, argument order and dictionary
key below is binding.

```gdscript
class_name FightAnchorIK

## Solve a two-bone chain (shoulder -> elbow -> hand, or hip -> knee -> foot).
static func solve(root: Vector3, upper_len: float, lower_len: float,
        target: Vector3, pole: Vector3) -> Dictionary
```

Returns a Dictionary with **exactly these five keys**:

| key | type | meaning |
|---|---|---|
| `"mid"` | `Vector3` | the middle joint (elbow / knee) in the same space as `root` |
| `"tip"` | `Vector3` | the end effector (hand / foot) |
| `"reachable"` | `bool` | `true` when the target was achievable without clamping |
| `"reach"` | `float` | `upper_len + lower_len` |
| `"error"` | `String` | `""` on success; a short reason otherwise |

### Behaviour, case by case — all five are binding

1. **In range.** When `min_reach <= d <= reach`, where `d` is the distance from
   `root` to `target` and `min_reach` is `abs(upper_len - lower_len)`: place
   `"tip"` exactly on `target`, `"reachable"` = `true`. Find `"mid"` by the law
   of cosines — the distance from `root` along the root→target direction is
   `(d*d + upper_len*upper_len - lower_len*lower_len) / (2*d)`, and the joint
   sits off that line by `sqrt(upper_len*upper_len - that*that)`.

2. **Out of reach** (`d > reach`). Extend straight at the target: `"mid"` =
   `root + dir * upper_len`, `"tip"` = `root + dir * reach`, where `dir` is the
   unit vector from `root` toward `target`. `"reachable"` = `false`, `"error"`
   stays `""` — **being out of reach is a fact to report, not a failure.**

3. **Too close** (`d < min_reach`, only possible when the bones differ in
   length). Clamp the other way: put `"tip"` at `root + dir * min_reach` and
   fold `"mid"` accordingly. `"reachable"` = `false`.

4. **`target` equal to `root`** (`d` is zero or within `1e-6`). There is no
   direction to work with, so pick one deterministically rather than dividing by
   zero: use the normalised `pole` direction if it is usable, otherwise
   `Vector3.FORWARD`. `"reachable"` = `false`, `"error"` = `"target at root"`.

5. **Bad lengths.** If `upper_len <= 0.0` or `lower_len <= 0.0`, return `"mid"`
   and `"tip"` both equal to `root`, `"reachable"` = `false`, `"reach"` = `0.0`,
   and `"error"` = `"non-positive bone length"`.

### THE POLE, and it is where these solvers go wrong

`pole` is a **hint direction**, not a point: it says which way the joint bends
(an elbow points back, a knee points forward). Project it perpendicular to the
root→target axis and normalise; that projected vector is the direction `"mid"`
is pushed off the line.

**When `pole` is parallel to the root→target axis the projection is zero and
there is no valid bend direction.** Do not return NaN. Pick any stable
perpendicular — take the cross product of the axis with `Vector3.UP`, and if
that is also degenerate (the axis is vertical) use `Vector3.RIGHT`. Still return
`"error"` = `""`: a degenerate pole is a caller's shrug, not an error.

### Second function, for the bake

```gdscript
## The rotations that put an existing chain into a solved pose.
static func chain_rotations(root: Vector3, mid: Vector3, tip: Vector3,
        rest_mid: Vector3, rest_tip: Vector3) -> Dictionary
```

Returns `{"upper": Quaternion, "lower": Quaternion, "error": String}` — the
rotation that takes the rest direction `rest_mid - root` onto `mid - root`, and
the rotation taking `rest_tip - rest_mid` onto `tip - mid`. Zero-length inputs
give `Quaternion.IDENTITY` and an `"error"` naming which one was degenerate.

## INVARIANTS YOUR CODE MUST SATISFY — state them in comments

The unseen test asserts these, so satisfy them deliberately:

- `root.distance_to(result["mid"])` equals `upper_len` to within **1e-4**, in
  EVERY case including the clamped ones.
- `result["mid"].distance_to(result["tip"])` equals `lower_len` to within
  **1e-4**, in every case.
- When `"reachable"` is `true`, `result["tip"].distance_to(target)` is within
  **1e-4** of zero.
- No returned component is ever `NAN` or `INF`, for any input, including zeros
  and parallel poles.
- The function is **pure**: the same arguments give the same answer, and nothing
  outside is read or written.

## GDScript TRAPS THAT COST A FIX CYCLE HERE

- **`var x := <call>` fails when the call returns Variant.** Write the type:
  `var n: float = ...`. This bites on `.get()` and on anything off an untyped
  value.
- **Reusing a variable name inside one function is a parse error in GDScript,
  even across separate `if` blocks.** Name the intermediates distinctly.
- `%` inside a format string must be `%%`.
- `Vector3.FORWARD` is **-Z** in Godot.
- Guard every `normalized()` — normalising a zero vector yields zeros, not an
  error, and the NaN appears three lines later where it is hard to find.

## WHAT TO SEND BACK

**The complete contents of `FightAnchorIK.gd`, as one code block, in your
reply.** You have no checkout and no Godot: do not attempt to clone, do not run
a repo test command, and do not ask for one. Claude mounts the file and runs the
real suite.

Keep it to the two functions plus whatever small private helpers they need.
