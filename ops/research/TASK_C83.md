# TASK C83 — CODEX — THE BLIND TEST FOR THE CLIP SLICE

Model: Codex, **high** effort, Fast OFF.
Owner: codex. Tier: **NEW TEST FILE ONLY** — parse gate plus your own test. A
new test file cannot break another test, so do NOT run the full suite and do NOT
run `--only fight`.

## Why this exists, and the rule that governs it

Cursor is cutting our one animation clip — a 2.47 s jab+cross+hook combination —
into three single punches under U40. If it works we get three of the purchase
list's punch types **for zero credits**, which is the cheapest test of the most
expensive decision in front of us.

**You are writing the test for it, blind, from the contract below and NEVER from
Cursor's code.** This is the split that has paid ten times on this project: the
module and its test are two tasks written from one contract, because a test
written against an implementation only ever agrees with it.

**Read the contract in this file. Do NOT open `Godot/scripts/FightClipSlice.gd`
or `Godot/scripts/FightClipBinding.gd`, and do NOT read
`research/TASK_U40.md` or `U40_DIGEST.md`.** If your test disagrees with
Cursor's module, that disagreement is the deliverable — Claude settles it in the
module, never by deleting either assertion.

**And know the limit of what you are doing** (2026-09-10, bought expensively): a
blind contract test confirms agreement with the spec and **cannot catch a spec
that is wrong**. R99's `placement()` was 180° out, the contract said so, and the
blind test asserted the error and passed 357/0. So assert the contract — and
where you can cheaply assert a *physical* property instead of a contractual one,
do that too. Section "The assertions that matter most" below is exactly that.

## The contract

```gdscript
class_name FightClipSlice
```

- `static func slice(source: Animation, start_s: float, end_s: float) -> Animation`
  Returns a NEW `Animation` holding only the keys in `[start_s, end_s]`,
  re-based so the result starts at 0.0. **Every track the source had is present
  in the result; none dropped.** The source is not modified.

- `static func punch_windows(source: Animation) -> Array`
  Returns an array of dictionaries, each with exactly the keys
  `"name"` (String), `"start_s"` (float), `"end_s"` (float), `"reach_m"`
  (float). The windows are found **from the animation data** — by tracking a
  hand bone's distance from the root over the clip and locating the extension
  peaks — not from the filename and not from a fixed table.
  `reach_m` is that punch's own peak hand travel; **`-1.0` means it could not be
  measured**, which is a legal and honest answer.

`FightClipBinding` keeps its U39 shape: `clip_for(role) -> String` (`""` when
unbound), `has_clip(role) -> bool`, `bound_roles() -> PackedStringArray`,
`missing_roles() -> PackedStringArray`, `metadata_for(role) -> Dictionary` with
`{"path", "length_s", "reach_m"}`. After U40 it should also resolve punch-type
keys — **`jab`, `cross`, and one of `hook_lead` / `hook_rear`** — while
`strike_head` stays bound so U39's own test does not go red. Two roles may point
at the same file.

The asset: `res://assets/models/fighters/anim/combo_jab_cross_hook.glb`, 2.47 s,
mesh-free, 22 bones that are already `SkeletonProfileHumanoid`.

## The assertions that matter most — physical, not contractual

**This is the point of the task.** The named trap in U40 is that a module can
"find" three punches by cutting 2.47 s into three equal 0.82 s pieces. That
would satisfy every contractual assertion above, produce three plausible
dictionary entries, and yield three clips that each **start and end mid-motion**
— garbage on the canvas that looks correct in a dictionary. Catch it:

1. **The windows must not be equal thirds.** Assert the three durations are not
   all within a few percent of each other AND of `length/3`. Real punches differ
   in duration — a jab is quicker than a hook. **Print the durations.**
2. **A slice must start and end near rest, not mid-swing.** At each window
   boundary, the hand's speed (distance moved per unit time, sampled across the
   boundary) should be **low relative to the peak speed inside the window**.
   Assert the boundary speed is below a generous fraction of the in-window peak
   — a ratio, never an absolute number. This is the assertion that actually
   distinguishes a real cut from an arithmetic one.
3. **Each window must contain exactly one extension peak.** Sample the hand's
   distance from the root across the window and assert one clear maximum, not
   two. Three punches cut into three windows should not leave a window holding
   one and a half punches.
4. **The windows must not overlap and must lie inside the clip.**
5. **A sliced animation's bones actually MOVE.** Sample a bone at two times
   inside the slice and assert the transforms differ. R94's whole finding was
   that a clip can look completely fine while moving **0 of 22 bones**.
6. **Track count is preserved** by `slice`, and the source is unmodified after
   the call.

## Anchors

`Godot/tests/fight_world_anim_test.gd` (258 lines) is the worked example for
loading the `.glb`, finding the `AnimationPlayer` and sampling bones — read it
whole. **Read the comment at `:59-62` before you write any bone sampling**: in
headless Godot no frame is drawn, so `global_transform` and `global_position`
read identity and `Skeleton3D.get_bone_global_pose()` does not reflect a seek.
Use local transforms, or `force_update_transform()`. This trap has cost this
project two separate debugging cycles and it is exactly the kind of measurement
you are about to make.

## Owned files

- `Godot/tests/fight_clip_slice_contract_test.gd` — NEW, yours, the whole
  deliverable.
- `research/C83_DIGEST.md` — NEW, yours, max 30 lines.

## Gate

```
python Godot/tools/check_scripts.py Godot/tests/fight_clip_slice_contract_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_clip_slice_contract_test.gd
```

**rc=0 is NOT a pass (R75)** — a runtime error leaves rc=0 and prints
`0 failure(s)` having never reached the counter. Read the output. **Never pass
`--godot` to `run_tests.py`.**

**If U40 has not landed when you run**, your test will fail to find
`FightClipSlice`. That is expected and is not a defect in your work: guard for
it, report `MODULE ABSENT` clearly, and still commit the test. C80 was written
before its module existed and that was the point.

**Never gate on an exact count or an exact zero.** If the curve honestly yields
two punches rather than three, your test must report that rather than go red —
write the assertion as "at least two windows", and assert the *shape* properties
above on whatever windows exist.

## Finish

`git rev-parse --abbrev-ref HEAD` first. **Several agents have work in flight in
this shared checkout** — `git status -s`, then `git add -- <explicit paths>`
only. Never `git add -A`, never a bare `git stash` / `reset --hard` / `clean`.
Push **master**, write the digest, then:

`python Tools/agent_comms.py send --from codex --to claude --subject C83-done --body "<sha> module=<present/absent> windows=<n> durations=<a>/<b>/<c>s equal-thirds=<yes/no> boundary-rest=<pass/fail> one-peak-each=<pass/fail> bones-move=<pass/fail> checks=<n> failures=<n> disagreements=<none-or-what>"`

Do NOT edit `HANDOFF.md`.

**The one trap specific to this task:** do not soften an assertion because it
went red. If Cursor's slices turn out to be equal thirds, or to start mid-swing,
**that is the test doing its job** — report it in the digest as a disagreement
and leave the assertion standing. The whole value of a blind test is that it was
written by someone who could not see the shortcut.
