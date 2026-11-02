# TASK_C150 — CODEX — THE BLIND CONTRACT TEST FOR THE SHARED PAIRED ANCHOR

**Owner: Codex.  Model: `gpt-5.6-luna`, MEDIUM effort.**
(The product of this task is a TEST, not motion on a skeleton, so it is luna's
by the 2026-09-21 domain split. Do not set `CODEX_MODEL`.)

**Test tier: ONE NEW TEST FILE. Parse gate it, run it alone, stop. A new test
file cannot break another test, so a full suite run here buys nothing and costs
twenty-five minutes. DO NOT RUN THE FULL SUITE.**

---

## YOU ARE WRITING THIS BLIND, AND THAT IS THE POINT

`Godot/scripts/FightPairedAnchor.gd` **does not exist yet.** Claude is writing it
in parallel, in another session, from the same contract below. **You must not
read, fetch or reconstruct that implementation**, and you must not wait for it.

A test written by the author of the code only ever agrees with it. Two halves
written from one contract, neither having seen the other, are evidence. This
split has now paid off twice in two days: C142's blind `CASCY_TO_UE4` test
SKIPped green before the map existed and passed for real, mutants intact, the
moment Cursor landed it.

**SO THE TEST MUST SKIP CLEANLY WHILE ITS SUBJECT IS ABSENT.** That is what
makes it committable and green from the first minute:

```gdscript
var script_path := "res://scripts/FightPairedAnchor.gd"
if not ResourceLoader.exists(script_path):
    print("SKIP: FightPairedAnchor.gd not present yet; contract test is inert.")
    print("checks=0 checks_failed=0")
    quit(0)
    return
```

---

## THE CONTRACT — THIS IS THE WHOLE SPEC. DO NOT INFER BEYOND IT.

`Godot/scripts/FightPairedAnchor.gd`, `class_name FightPairedAnchor`. Pure
static functions. No I/O.

### Constant

```gdscript
const NO_ANCHOR := Vector3(INF, INF, INF)
```

It is the same sentinel value as `FightAnchorBake.NO_TARGET`. A test may compare
against either; they are equal by definition and that equality is itself part of
the contract.

### 1. `shared_anchor(a_points: Array, b_points: Array, contact_max_m: float) -> Dictionary`

`a_points` and `b_points` are frame-synced `Vector3` tracks **in world metres** —
one man's gripping hand and the other man's gripped elbow, from the same capture,
same length, index `i` is the same instant in both.

Returns a Dictionary with exactly these keys:

| key | type | meaning |
|---|---|---|
| `anchors` | `Array` of `Vector3` | one per frame; the midpoint, or `NO_ANCHOR` |
| `separation` | `Array` of `float` | one per frame, **always**, even on a non-grip frame |
| `gripped` | `int` | how many frames are a grip |
| `frames` | `int` | `a_points.size()` |
| `error` | `String` | `""` on success |

Rules:

- `separation[i] == a_points[i].distance_to(b_points[i])`, for **every** frame.
- A frame is a **grip** when `separation[i] <= contact_max_m`.
- On a grip frame, `anchors[i] == (a_points[i] + b_points[i]) * 0.5`.
- On a non-grip frame, `anchors[i] == NO_ANCHOR`.
- `gripped` equals the number of grip frames, and equals the number of entries in
  `anchors` that are not `NO_ANCHOR`.
- `anchors.size() == separation.size() == frames == a_points.size()`.

**Refusals.** Each returns `error` non-empty, `anchors` and `separation` EMPTY,
`gripped == 0`, and `frames == 0`:

- the two arrays are different lengths,
- either array is empty,
- `contact_max_m <= 0.0`,
- any element of either array is not a `Vector3`.

**Purity.** The same arguments return the same answer. Neither input array is
mutated — check `a_points` element-by-element after the call, not just its size.

### 2. `to_rig_local(anchors: Array, root_world: Array, hips_local: Array, mount_scale: float) -> Array`

Converts a world-metre anchor track into the **unscaled rig-local** space that
`FightAnchorBake.bake()` consumes.

**THIS FUNCTION IS THE WHOLE UNIT SEAM AND IT IS WHY THIS TEST EXISTS.** S34
reported +139.7% contact drift and had to withdraw it: the probe composed
rig-local bone offsets and compared them against world metres, because a Tripo
mesh is not in metres — `f05` exports 1.850 tall and `f06` 1.000, and only
`FighterPhysique.height_scale()` (0.963 and 1.890 respectively) turns either into
the athlete's real height. **The same family of bug has now cost this project
four passes.** Pin the arithmetic.

Per sample `i`:

```
if anchors[i] is NO_ANCHOR:  out[i] = FightAnchorBake.NO_TARGET
else:                        out[i] = (anchors[i] - root_world[i]) / mount_scale + hips_local[i]
```

- Returns an Array of the same length as `anchors`.
- **Returns an EMPTY array** when `mount_scale <= 0.0`, when the three arrays are
  not all the same length, or when `anchors` is empty.
- Pure; mutates nothing.

Assert the arithmetic with a case where **every one of the three terms is
different and non-zero** — a `mount_scale` that is not 1.0, a `root_world` that is
not the origin, and a `hips_local` that is not zero. A test that uses
`mount_scale = 1.0` or `hips_local = Vector3.ZERO` cannot tell division from
multiplication or addition from nothing, and would have passed the S34 bug.

Include a case with `mount_scale = 1.890` (f06's real value) and confirm the
result is NOT what you would get at `mount_scale = 1.0`.

### 3. `hand_chain(side: String) -> Dictionary` and `elbow_chain(side: String) -> Dictionary`

`side` is `"Left"` or `"Right"` — those two strings exactly, case-sensitive.

- `hand_chain("Left")` → `{"upper": "LeftUpperArm", "lower": "LeftLowerArm", "tip": "LeftHand"}`
- `elbow_chain("Left")` → `{"upper": "LeftShoulder", "lower": "LeftUpperArm", "tip": "LeftLowerArm"}`
- Right side likewise, with the `Right` prefix.
- **Any other `side` returns an EMPTY Dictionary** — including `"left"`, `"LEFT"`,
  `""` and `"Middle"`.

The two chains differ because the gripped point is an **elbow**, which is the
MIDDLE joint of an arm, while `FightAnchorBake.bake()` drives a chain's **tip**.
Driving an elbow therefore needs a chain that ENDS at the elbow — clavicle,
upper arm, forearm — and the forearm's origin is the elbow. Every bone named
above exists on our rig: `FightClipRetarget`'s `UE4_TO_OURS` maps `clavicle_l`
to `LeftShoulder`, and `probe_cmu_grip.gd`'s `CMU_TO_OURS` maps `lradius` to
`LeftLowerArm`.

---

## OWNED FILES

- `Godot/tests/fight_paired_anchor_test.gd` — **NEW. Yours. The only file you
  create in `Godot/`.**
- `research/C150_PAIRED_ANCHOR_CONTRACT.md` — your digest.

**DO NOT TOUCH** `Godot/scripts/FightPairedAnchor.gd`, `FightAnchorBake.gd`,
`FightAnchorIK.gd`, `FightClipRetarget.gd`, `probe_cmu_grip.gd`, `HANDOFF.md`, or
any other test.

---

## PROVE THE TEST WITH MUTANTS BEFORE YOU CALL IT DONE

A contract test that has never seen a wrong implementation is not known to be
able to fail. C117 passed thirty checks against a lock on a swinging foot.

Write a **scratch** `FightPairedAnchor.gd` in your worktree (NEVER commit it),
break it in each of these ways, and confirm your test goes RED on every one:

1. `anchors[i]` returns `a_points[i]` instead of the midpoint.
2. `separation` is written only on grip frames (so it is short, or padded with 0).
3. The grip test uses `<` where the contract says `<=` — at exactly
   `separation == contact_max_m` the frame must still be a grip.
4. `to_rig_local` **multiplies** by `mount_scale` instead of dividing. *(This is
   the S34 bug itself. If your test cannot catch this one, it has no value.)*
5. `to_rig_local` omits the `+ hips_local[i]` term.
6. `hand_chain("left")` (lowercase) returns the Left chain instead of `{}`.
7. `shared_anchor` returns `error: ""` with a partial result when the two arrays
   are different lengths.

Then **restore the absent state** (delete the scratch module) and confirm the
test SKIPs green again. Record the seven mutant results in your digest.

---

## GATE

```
python Godot/tools/check_scripts.py Godot/tests/fight_paired_anchor_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_paired_anchor_test.gd
```

Must end `checks_failed=0` with the SKIP message, since the module is absent on
master. **THE TEST MUST NOT PRINT `FAIL`, `FAILED`, `failures=N` (N>0) OR
`N failure(s)` IN ITS ORDINARY VOCABULARY.** `run_tests.py:136-140` reads the LOG
for self-reported failure, and C141 and C142 were both condemned by their own
mutant diagnostics for using exactly those words while their final line read
`failures=0`. Use `checks_failed=` and a `mutant_mode` flag, as those two now do.

---

## COMMIT

- `git add -- Godot/tests/fight_paired_anchor_test.gd research/C150_PAIRED_ANCHOR_CONTRACT.md`
  — explicit paths only. `git status -s` first; `AgentComms/messages/` must never
  ride your commit. Verify with `git show --stat HEAD`.
- Push to branch `codex/c150-paired-anchor-contract`.
- Commit after each step; an honest partial beats an uncommitted whole.
- One line back:
  `python Tools/agent_comms.py send --from codex --to claude --subject c150-ready --body "<commit hash, the SKIP result, and how many of the seven mutants went red>"`
- **DO NOT EDIT `HANDOFF.md`.**

---

## THE ONE TRAP FOR THIS TASK

**`callv` and `call` with the wrong arity return `{}`, not `null`.** A check
shaped `if result != null` then passes while measuring nothing — it cost C146
three vacuous assertions. When you invoke the module's statics through a
`load()`ed script, assert on a POSITIVE property of the returned value (a key
that must be present, a size that must match), never on its mere non-nullness.
And **type every value you read out of a `load()`ed script**: `var n: int = ...`,
because `var n := <call>` fails to infer on a Variant and is a parse error, and a
parse error HANGS a headless run for 600 s instead of failing it.
