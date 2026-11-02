# TASK U41 — CURSOR — MIRROR THE PUNCHES AND DOUBLE THE LIBRARY FOR NOTHING

Model: Cursor, `-p --force --trust`, **medium** effort.
Owner: cursor. Tier: parse gate, your own new test, plus your U39/U40 tests,
then `run_tests.py --only world`. Do NOT run the full suite.

## Why this exists — your own U40 measurement found it

U40 (`ea0a8b1`) sliced the combination and reported, honestly, that
**all three extension peaks were the RIGHT hand**:

| name | window | reach_m | length |
|---|---|---|---|
| `jab` | 0.00–0.64 | 0.744 | 0.64 s |
| `cross` | 0.64–1.04 | **0.926** | 0.40 s |
| `hook_rear` | 1.04–1.68 | 0.772 | 0.64 s |

Your `_hand_reach_series` samples **both** hands and takes whichever is further,
so this is a measured fact about the asset and not a blind spot. **But it means
the clip labelled `jab` is a right-hand punch, and for an orthodox fighter the
jab is the LEAD — the left.** We have three right hands and zero left hands.

Meanwhile a research desk (K27) has already ruled that southpaws are handled by
**mirroring the clips**, and that 2–3 of our twelve fighters should be southpaw.

So one piece of work solves both problems: **a left-right mirror.** It turns our
three right-handed punches into six, gives an orthodox fighter a real left jab,
and gives a southpaw the whole set — **for zero credits**.

## Owned files

- `Godot/scripts/FightClipMirror.gd` — NEW, yours.
- `Godot/scripts/FightClipBinding.gd` — yours, EDIT.
- `Godot/tests/fight_clip_mirror_test.gd` — NEW, yours.
- `research/U41_DIGEST.md` — NEW, yours, max 40 lines.

`Godot/scripts/FightClipSlice.gd` and `FightStagePlayer.gd` are yours from
U39/U40 — read them; edit only if you must, and say so in the digest.
**Do NOT edit `Godot/scripts/FightStageDirector.gd`** (Claude is rewriting
`required_roles()` separately) and **do NOT edit
`Godot/tests/fight_clip_slice_contract_test.gd`** — that is Codex's blind test
and it is not yours to adjust.

## The contract

```gdscript
class_name FightClipMirror
```

- `static func mirror(source: Animation) -> Animation`
  Returns a NEW animation that is the source reflected across the body's sagittal
  plane: every `Left*` bone track swapped with its `Right*` counterpart, and each
  transform reflected so the motion actually crosses over rather than merely
  swapping labels. The source is not modified. Track count is preserved.
- `static func mirrored_name(name: String) -> String`
  `"jab"` → `"jab_lead"` / whatever convention you choose — **state the
  convention in the digest and keep it consistent**; the binding keys are read by
  other code.

Then bind the mirrored punches in `FightClipBinding`, keeping `strike_head` and
the existing U40 keys bound so U39's and U40's tests stay green.

## What the test must prove — and reflection is easy to fake

**Assert the feature OCCURS, not that it is permitted.**

1. **The mirror actually crosses over.** Take a frame where the RIGHT hand is
   extended forward in the source; assert that in the mirrored clip the **LEFT**
   hand is extended by a comparable distance. **A mirror that only renames tracks
   passes a naive test and produces a fighter punching with the wrong arm** —
   this assertion is the whole point.
2. **Reach is preserved.** The mirrored punch's peak hand travel should be close
   to the source's (0.744 / 0.926 / 0.772). Assert within a tolerance, never an
   exact equality.
3. **The body is not inside out.** Mirroring a transform incorrectly flips
   handedness and turns a skeleton inside out — visible as a negative scale or an
   inverted basis determinant. Assert the mirrored transforms keep a positive
   determinant.
4. **Track count preserved**, source unmodified.
5. **Bones move** in the mirrored clip — sample at two times, assert the
   transforms differ. R94's finding was a clip that looked fine while moving
   **0 of 22 bones**.

**Never gate on an exact value or an exact zero.** Tolerances and ratios only.

## Traps

- **Headless Godot: `global_transform` and `global_position` are STALE** — no
  frame is drawn, so they read identity. Use local transforms or
  `force_update_transform()`. You already navigated this in U40 with virtual FK
  from `Hips`; reuse that approach rather than inventing a second one.
- **Mirroring is not negating one axis of the position.** A correct sagittal
  mirror negates the position along the lateral axis **and** reflects the
  rotation — negating the quaternion's y and z, or equivalent for your basis
  convention. Getting only half of it produces a clip that looks almost right and
  is subtly broken; assertion 3 is what catches it.
- **`git status -s` first, `git add -- <explicit paths>` only.** Several agents
  have work in flight. Never `git add -A`, never a bare `git stash` /
  `reset --hard` / `clean`.
- **Push to master, not a branch.** `git rev-parse --abbrev-ref HEAD` before
  believing anything landed.
- rc=0 is NOT a pass (R75) — read the output. Never pass `--godot` to
  `run_tests.py`.

## Gate

```
python Godot/tools/check_scripts.py Godot/scripts/FightClipMirror.gd Godot/scripts/FightClipBinding.gd Godot/tests/fight_clip_mirror_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_clip_mirror_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_clip_slice_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_stage_playback_test.gd
python Godot/tools/run_tests.py --only world
```

## Finish

Commit explicit paths, push **master**, write the digest, then:

`python Tools/agent_comms.py send --from cursor --to claude --subject U41-done --body "<sha> mirrored=<n> crossover-verified=yes reach-preserved=<a>/<b>/<c> determinant-positive=yes own=<checks>/<fails> slice=<n>/<f> playback=<n>/<f> world=<n>/<f> naming=<convention>"`

Do NOT edit `HANDOFF.md`.

**The one trap specific to this task:** do not conclude the source's first window
really is a "jab" just because the filename says so. Three right hands in a row
is not a jab-cross-hook as an orthodox fighter throws it. **Say in the digest
what you think the asset actually contains** — a southpaw combination, a
right-hand-only drill, or a mislabelled file. That judgement affects which
fighters we can use it for, and it is better recorded now than discovered after
we have bought ten more clips from the same library on the same assumption.
