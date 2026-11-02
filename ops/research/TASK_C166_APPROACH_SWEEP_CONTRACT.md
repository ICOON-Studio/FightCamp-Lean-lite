# C166 — THE BLIND CONTRACT TEST FOR THE APPROACH SWEEP

**Owner:** codex (`gpt-5.6-luna`, MEDIUM). Contract test, not animation.
**Tier: parse gate, then your own test, then `--only approach_sweep`. NO SUITE RUN.**

## THIS IS A BLIND TEST AND THAT IS THE WHOLE POINT

**The module does not exist yet. Claude writes it next session, from the same
contract you are reading, without seeing your test.** Do not write the module,
not even as a stub, and do not go looking for a draft.

**Your C164 and C165 both landed today and both were worth their cost.** C164
came back 249 of 255 and all six reds were in the test — the contract table
quotes `r/L` to three decimals and you compared it with `is_equal_approx`, whose
tolerance at 0.926 is 9.3e-6 against a rounding of 7.4e-5. **C165 found
something better than a bug: a genuine contradiction in its own contract.** Its
boundary rows build a direction with `Vector3(cos θ, sin θ, 0)`, and because
`Vector3` stores float32 that direction round-trips through `atan2` as
`-30.000000445292`. One row then demanded the module keep that sample and
another demanded it drop it. No implementation could satisfy both, and it was
settled in the module with a named epsilon. **That is the most valuable thing a
blind test has done here. Look for the same shape of thing below.**

## WHY THIS MODULE EXISTS

The 128-direction reachability sweep — "can a hand get onto this body part
without entering another capsule of the same body" — is currently **copy-pasted
into three separate probe files**: `Godot/tools/s47_contact_offsets.gd`,
`Godot/tools/s52_present_ratio.gd` and `Godot/tools/s53_ball_capsules.gd`. Three
copies of one measurement is how S47's audit named `thorax` as the neck's
blocker while C158's blind test named `head` **off the same rig** — both loops
stopped at the first hit they found, so the answer depended on iteration order,
and the true answer was BOTH. `ApproachSweep.gd` is that measurement extracted
once, with the early exit designed out of it.

## THE CONTRACT — EXACT NAMES, ARGUMENT ORDER AND RETURN SHAPES

The module will be `Godot/scripts/ApproachSweep.gd`. Every function is `static`.
Nothing in it touches a rig, a scene or an autoload — it is arithmetic over
points and capsules, which is why it can be tested blind.

A **capsule** is a `Dictionary` `{"name": String, "p0": Vector3, "p1": Vector3,
"r": float}`. That is the shape `FighterCapsules.build` already returns; do not
invent another.

```gdscript
static func direction(index: int, count: int) -> Vector3
```
The Fibonacci lattice, which is what the three probes already use so the numbers
stay comparable:

```
y     = 1.0 - 2.0 * (float(index) + 0.5) / float(count)
radius= sqrt(max(0.0, 1.0 - y*y))
theta = PI * (1.0 + sqrt(5.0)) * float(index)
return Vector3(cos(theta) * radius, y, sin(theta) * radius)
```

**`count <= 0` returns `Vector3.ZERO`.** `index` is clamped into `[0, count-1]`.
**Every other return is a unit vector** — assert `length()` is `1.0` within
`1e-5` across a sweep, because a lattice that quietly returns short vectors
puts the hand inside the target and every reading goes green.

```gdscript
static func point_to_segment(p: Vector3, a: Vector3, b: Vector3) -> float
```
Shortest distance from `p` to the segment `a..b`, **clamped to the segment** —
not to the infinite line. `a == b` is a point and returns `p.distance_to(a)`;
that case is not hypothetical, it is every promoted sphere in the build.

```gdscript
static func hand_position(spot: Vector3, dir: Vector3, target_r: float,
		hand_r: float) -> Vector3
```
`spot + dir * (target_r + hand_r)` — the hand placed tangent to the target.
A negative `target_r` or `hand_r` is treated as `0.0`.

```gdscript
static func blocker(caps: Array, target_name: String, hand: Vector3,
		hand_r: float) -> Dictionary
```
Returns `{"name": String, "depth": float}` — **the DEEPEST capsule the hand is
inside, never the first one found.**

- `depth` for a candidate is `(other.r + hand_r) - point_to_segment(hand,
  other.p0, other.p1)`. Only a `depth > 0.0` counts as blocking.
- The capsule named `target_name` is skipped; you cannot be blocked by the thing
  you are reaching for.
- **Nothing blocking returns `{"name": "", "depth": 0.0}`.**
- **THE ROW THAT MATTERS: with two blockers present, the one returned is the
  deeper one, and it is the same answer whichever order they appear in the
  array.** Build that case both ways round and assert both. This is the defect
  the module exists to remove.

```gdscript
static func sweep(caps: Array, target_name: String, blend: float,
		hand_r: float, count: int, min_elev_deg: float,
		max_elev_deg: float) -> Dictionary
```
The whole measurement. The grip spot is `p0.lerp(p1, clamp(blend, 0.0, 1.0))` on
the target capsule. Returns:

| key | type | meaning |
|---|---|---|
| `"usable"` | int | directions with no blocker, over the whole sphere |
| `"total"` | int | `count` |
| `"pct"` | float | `usable / total * 100.0`, `0.0` when `total <= 0` |
| `"banded_usable"` | int | unblocked AND inside the elevation band |
| `"banded_valid"` | int | inside the elevation band, blocked or not |
| `"banded_pct"` | float | `banded_usable / banded_valid * 100.0`, `0.0` when `banded_valid <= 0` |
| `"worst"` | String | the blocker that blocked the MOST directions; `"-"` when none did |
| `"worst_count"` | int | how many it blocked; `0` when none did |
| `"worst_depth"` | float | the deepest depth recorded for that blocker |

- **An unknown `target_name` returns an EMPTY Dictionary** (`{}`), not a zeroed
  one. A caller that asked about a capsule this body does not have must be able
  to tell that apart from a capsule that measured zero.
- The band test is **inclusive at both ends** and uses `ApproachBand.in_band`
  — that module is **already in the tree** at `Godot/scripts/ApproachBand.gd`
  and you may read it. `(-90.0, 90.0)` is the unbanded control and must make
  `banded_valid == count` and `banded_pct == pct`. **Assert that identity; it is
  the cheapest proof the banding is not silently dropping samples.**
- `min > max` admits nothing: `banded_valid == 0` and `banded_pct == 0.0`, while
  `usable` and `pct` are unaffected.

## THE ROWS YOUR TEST MUST CONTAIN

1. **Two blockers, both orders, same answer.** A hand inside a shallow capsule
   and a deep one; `blocker` returns the deep one whichever way the array is
   built. **If your test passes with a first-hit implementation, it has failed.**
2. `blocker` on a set where nothing blocks returns `{"name": "", "depth": 0.0}`.
3. `point_to_segment` with `a == b`, with `p` beyond each end (clamped, so the
   answer is the distance to that endpoint and never to the infinite line), and
   with `p` beside the middle.
4. `direction(i, 128)` is a unit vector for a spread of `i`; `direction(0, 0)` is
   `Vector3.ZERO`; `direction(-5, 128)` and `direction(999, 128)` are the
   clamped ends and are still unit vectors.
5. `sweep` on an **isolated capsule with no neighbours**: every direction is
   usable, `pct == 100.0`, `worst == "-"`, `worst_count == 0`.
6. `sweep` on a capsule **completely buried** by a much larger neighbour:
   `usable == 0`, `pct == 0.0`, and `worst` names the neighbour.
7. **The unbanded identity**: `sweep(..., -90.0, 90.0)` gives
   `banded_valid == count` and `banded_pct == pct`.
8. `sweep` with an unknown target name is `{}`.
9. **A grid**: sweep several `count` values and assert `usable <= total`,
   `banded_usable <= banded_valid <= total` and every percentage in
   `0.0 .. 100.0`, on every row. A grid is what made C163 and C164
   trustworthy; build one here too.

## Owned files

- `Godot/tests/approach_sweep_contract_test.gd`
- `research/C166_DIGEST.md`

**You own NOTHING else. Do not create `ApproachSweep.gd`.** Do not edit
`ApproachBand.gd`, `CapsuleShape.gd`, `FighterCapsules.gd` or any probe.

## What to do when the module is missing

`load("res://scripts/ApproachSweep.gd")` returns `null` today. **Skip green and
say so loudly** — print a line naming the module as absent and exit 0 with
`SUITE total=0 fails=0`. You have handled this correctly three times; do it
again.

## Gate

```
python Godot/tools/check_scripts.py Godot/tests/approach_sweep_contract_test.gd
python Godot/tools/run_tests.py --only approach_sweep
```

`--only` does **NOT** stack — one per invocation, and **read `total=` to confirm
the filter actually matched your file.** If it reads `total=0`, the filter is
wrong, not the test; say so, as you did on C164's `--only ball`.
**Do not run the full suite**; it is Claude's, once, at integration.

## THE TRAP SPECIFIC TO THIS TASK

**A test that prints its own failures in the runner's vocabulary is condemned by
the runner even when it passes.** `Godot/tools/run_tests.py:136-140` reads the
LOG for any line starting `FAIL`/`FAILED`, any `failures=N` with `N > 0`, any
`N failure(s)`. If you build a deliberately-blocked fixture and print a
diagnostic about it, do not use those words — `checks_failed=` is the vocabulary
that works here. This condemned two of your own passes on C141 and C142.

**And the second one: a sphere is `p0 == p1`.** `FighterCapsules` now promotes
the head to a sphere on load, so a zero-length capsule is the normal case in
this codebase, not an edge case. `point_to_segment` and `blocker` both have to
handle it without a division by zero and without returning `NAN`.

## What already exists, so you do not rebuild it

`RESEARCH_INDEX.md` is 789 research documents, 220 tools and 116 drivers, one
line each. **GREP IT, NEVER READ IT WHOLE** (214 KB). Worth running:
`grep -i 'sweep\|exposure' RESEARCH_INDEX.md`, `grep -i 'reachab' RESEARCH_INDEX.md`.
**A negative result is a result** — say so in the digest.

You may read `Godot/scripts/ApproachBand.gd` (already shipped) and
`research/S53_THE_BALL_CAPSULE.md`. **Nothing else** — not `HANDOFF.md`,
not `CURRENT_STATUS.md`, not any other digest, and **not the three probes**,
because reading their implementation is exactly what would stop this being
blind.

## Rules

- **DO NOT fetch and DO NOT rebase** — the checkout is current, and a rebase
  here refuses over the untracked `.uid` / `.import` / scratch files this
  checkout always carries. You stopped at exactly that on C160 and stopping was
  right.
- Never `git stash`, `git reset --hard`, `git checkout .`, `git clean` or
  `git add -A`. Stage explicit paths only, and `git show --stat HEAD` after.
- Commit after each step — an honest partial beats an uncommitted whole.
- Commit, push to master, write the digest, send one line with
  `python Tools/agent_comms.py send`. **Do NOT edit `HANDOFF.md`.**

## And then argue against the contract

End the digest with the strongest case this contract is WRONG. The obvious line
of attack: **`sweep` returns nine keys and most callers want one**, and a
function whose return shape is a nine-field dictionary is a function that will
grow a tenth field for the next caller and never lose one. Say whether
`blocker` and `sweep` should be one function or two, and **name your own weakest
point unprompted**, the way Dola named hers. That half of the brief has produced
the shipped answer four times here.
