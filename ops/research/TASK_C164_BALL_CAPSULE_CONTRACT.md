# C164 — THE BLIND CONTRACT TEST FOR "THIS CAPSULE IS A BALL"

**Owner:** codex (`gpt-5.6-luna`, MEDIUM). Contract test, not animation.
**Tier: parse gate, then your own test, then `--only ball`. NO SUITE RUN.**

## THIS IS A BLIND TEST AND THAT IS THE WHOLE POINT

**The module does not exist yet. Claude writes it next session, from the same
contract you are reading, without seeing your test.** You must not write the
module, and there will be nothing to read if you go looking — that is
deliberate.

This split has now paid three times. C142 wrote the `CASCY_TO_UE4` contract test
before the map existed and passed for real once it landed. C159 landed
first-pass, checks=42 failures=0. **C163 — yours, yesterday — landed 54 of 57
against a module it had never seen, and the three reds were in the test, not the
module: four rows probing the PRESENT axis had the varying number in the
EXPOSURE slot.** They are corrected in the tree. Read that as the thing to watch
for rather than as a criticism: everything else in that file, including the
36-cell agreement grid, was right, and the grid is what made the result
trustworthy. **Build another grid here.**

## WHERE THE CONTRACT COMES FROM

Read these two, in this order. They are short and they are the only background
you need. **Do not read anything else** — not `HANDOFF.md`, not
`CURRENT_STATUS.md`, not any other digest.

- `research/S52_THE_PRESENT_RATIO.md` — what was measured and what it
  refused.
- `research/J41_SHOULDER_GIRDLE_PROPORTIONS.md` — John's anthropometry
  for the same boundary, arrived at independently.

The short version. A fighter is modelled as **capsules**: a segment between two
bone positions, plus a radius, plus a hemispherical cap at each end. Dola's fix
for an unreachable neck was to **inset each endpoint by that capsule's own
radius** so the cap stops at the bone instead of past it.

**It broke on the head.** Our `head` capsule runs from the Head bone to the
skull's vertex centroid — about 0.077 m on one rig — and its radius is a skull
half-width, which is **larger than that**. Insetting by the radius ran the far
endpoint through the near one; clamped, the capsule collapsed to a point and
measured **0.0% present**. A capsule whose radius exceeds its own length is not
a capsule. It is a ball wearing a capsule's name, and the rule cannot apply to
it. John's memo reaches the same boundary from the anthropometry: remaining
length is `L − 2r`, so **r/L ≥ 0.5 is a needle**, and a segment past that is the
wrong abstraction.

So the engine needs to be able to **say which of its capsules are actually
balls**, before any rule is applied to them. This module is that.

## THE CONTRACT — EXACT NAMES, ARGUMENT ORDER AND RETURN SHAPES

The module will be `Godot/scripts/CapsuleShape.gd`. Every function is `static`.
Nothing in it touches a rig, a scene or an autoload — it is arithmetic over a
length and a radius, which is why it can be tested blind.

```gdscript
static func slenderness(length_m: float, radius_m: float) -> float
```
Returns `radius_m / length_m` — the **r/L** John's memo is written in.
**`length_m <= 0.0` returns `INF`**: a segment with no length is as far from a
capsule as it is possible to be, and returning `0.0` there would make the most
degenerate case read as the most capsule-like. A negative `radius_m` is treated
as `0.0`.

```gdscript
static func shape(length_m: float, radius_m: float) -> String
```
Returns exactly one of these four strings, upper case, no other value ever:

| r/L | returns | meaning |
|---|---|---|
| `< 0.25` | `"SEGMENT"` | a limb — the inset costs it little |
| `>= 0.25` and `< 0.50` | `"STOUT"` | the inset costs it real length; measure before applying |
| `>= 0.50` and `< 1.00` | `"NEEDLE"` | `L − 2r` is gone; the inset destroys it |
| `>= 1.00` | `"BALL"` | the radius exceeds the whole segment; it was never a capsule |

**The boundaries are INCLUSIVE at the number named.** `r/L` of exactly `0.25` is
`STOUT`, exactly `0.50` is `NEEDLE`, exactly `1.00` is `BALL`. `INF` (the
zero-length case) is `BALL`. **Test each boundary from both sides** — that is the
single most useful thing in this file.

```gdscript
static func accepts_endpoint_inset(length_m: float, radius_m: float) -> bool
```
`true` only for `"SEGMENT"` and `"STOUT"`. **This and `shape` must never
disagree**, and a grid asserting they agree across a sweep of lengths and radii
is worth more than either alone — that is the part of C163 that made it
trustworthy.

```gdscript
static func surviving_extent(length_m: float, radius_m: float, ends: int) -> float
```
What is left of the segment after insetting `ends` endpoints by `radius_m` each:
`length_m - ends * radius_m`, **floored at 0.0**, never negative. `ends` is
`0`, `1` or `2`; any other value is clamped into that range. With `ends == 0`
it returns `length_m` unchanged (floored at 0.0).

## THE REAL ROWS, WHICH YOUR TEST MUST CONTAIN

Measured off our own two rigs in S52. These are not invented.

| capsule | rig | length m | radius m | r/L | `shape` | `accepts_endpoint_inset` |
|---|---|---|---|---|---|---|
| `neck` | f01 @1.78 m | 0.0594 | 0.0550 | 0.926 | `"NEEDLE"` | `false` |
| `neck` | f02 @1.88 m | 0.0774 | 0.0550 | 0.711 | `"NEEDLE"` | `false` |
| `thorax` | f01 | 0.2824 | 0.1231 | 0.436 | `"STOUT"` | `true` |
| `thorax` | f02 | 0.3054 | 0.1418 | 0.464 | `"STOUT"` | `true` |
| `femur_l` | f02 | 0.4636 | 0.1400 | 0.302 | `"STOUT"` | `true` |
| `forearm_r` | f01 | 0.2340 | 0.0696 | 0.297 | `"STOUT"` | `true` |

Also assert these, from John's J41 table — they are the anthropometry the bands
were chosen against:

| segment | r/L | `shape` |
|---|---|---|
| clavicle, Spanish ♂ n=45 | 0.039 | `"SEGMENT"` |
| upper arm, ANSUR II ♂ N=4082 | 0.170 | `"SEGMENT"` |

**If your test says `neck` is anything but `NEEDLE`, or says it accepts the
inset, you have misread the contract and the whole exercise has failed.**

And one `surviving_extent` row that is the finding itself: `surviving_extent(
0.0594, 0.0550, 1)` is `0.0044`, which is **7.4%** of the segment — the number
that refused Dola's arm A.

## Owned files

- `Godot/tests/capsule_shape_contract_test.gd`
- `research/C164_DIGEST.md`

**You own NOTHING else. Do not create `CapsuleShape.gd`**, not even as a stub,
and do not go looking for a draft of it. If you write it, the test is no longer
blind and the exercise is worthless.

## What to do when the module is missing

`load("res://scripts/CapsuleShape.gd")` will return `null` today. **Skip green
and say so loudly** — print a line naming the module as absent and exit 0 with
`SUITE total=0 fails=0`. Do NOT fail. You handled this exact case correctly in
C163; do the same.

## Gate

```
python Godot/tools/check_scripts.py Godot/tests/capsule_shape_contract_test.gd
python Godot/tools/run_tests.py --only ball
```

`--only` does NOT stack — one per invocation, and read `total=` to confirm how
many ran. **Do not run the full suite**; it is Claude's, once, at integration.

## What already exists, so you do not rebuild it

`RESEARCH_INDEX.md` is 789 research documents, 220 tools and 116 drivers, one
line each. **GREP IT, NEVER READ IT WHOLE** (214 KB). Worth running:
`grep -i 'capsule' RESEARCH_INDEX.md`, `grep -i 'presence\|present ratio'
RESEARCH_INDEX.md`. **A negative result is a result** — say so in the digest.

## Rules

- **DO NOT fetch and DO NOT rebase** — the checkout is current, and a rebase
  here refuses over the untracked `.uid` / `.import` / scratch files this
  checkout always carries. You stopped at exactly that on C160 and stopping was
  right.
- Never `git stash`, `git reset --hard`, `git checkout .`, `git clean` or
  `git add -A`. Stage explicit paths only.
- Commit, push to master, write the digest, send one line with
  `python Tools/agent_comms.py send`. **Do NOT edit `HANDOFF.md`.**

## THE TRAP SPECIFIC TO THIS TASK

**`slenderness` returns `INF`, and `INF` has to flow through every other
function without becoming a number.** `shape(0.0, 0.1)` is `"BALL"`;
`accepts_endpoint_inset(0.0, 0.1)` is `false`. In GDScript a comparison against
`INF` behaves, but `INF >= 1.00` and `INF < 1.00` are not symmetric if anyone
writes the bands as a subtraction. **Assert the zero-length row explicitly** —
it is the one a from-scratch implementation gets wrong, and it is the case our
head capsule actually collapsed to.

## And then argue against the contract

End the digest with the strongest case you can make that this contract is
WRONG — that four bands are more than anyone will act on, that `STOUT` and
`NEEDLE` is a distinction without a decision behind it, or that `0.25` is
arbitrary where `0.50` is derived. **Name your own weakest point unprompted, the
way Dola named hers.** That half of the brief has produced the shipped answer
three times here, including the knee rule, where the converged answer was better
than all three options the agents were offered.
