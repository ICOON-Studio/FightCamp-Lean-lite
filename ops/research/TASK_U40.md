# TASK U40 — CURSOR — THREE PUNCH TYPES FOR FREE, OUT OF THE CLIP WE ALREADY OWN

Model: Cursor, `-p --force --trust`, **medium** effort.
Owner: cursor. Tier: **SCRIPTS ADDED / ONE OWNED SCRIPT EDITED** — parse gate,
your own test, then `run_tests.py --only world` and `--only fight`. Do NOT run
the full suite; that is Claude's once, at integration.

## Why this exists — and it may save the entire purchase

Your own U39 finding, reported honestly and now being acted on:

> `combo_jab_cross_hook.glb` is a **2.47 s jab+cross+hook combination**. A beat
> is ONE scored strike, so the stage currently shows **three punches where the
> engine scored one.**

Meanwhile a research desk (J17) has rewritten the purchase list. The old list
sliced by TARGET (`strike_head` / `strike_body` / `strike_leg`); every shipped
boxing title slices by **PUNCH TYPE**, and the proposed boxing set is `idle`,
**`jab`, `cross`, `hook_lead`, `hook_rear`, `uppercut`**, plus reactions and
knockdowns.

**The clip we already own contains a jab, a cross and a hook.** If you can slice
it into three single-punch animations, we get **three of the six punch types for
zero credits**, and — far more valuable — we can judge J17's type-first list
against real assets before spending anything. This is the cheapest test of the
most expensive decision in front of us.

## What already exists — do not rebuild it

- `Godot/scripts/FightClipBinding.gd` — **yours, from U39.** One `const
  BINDINGS` dict; `clip_for`, `has_clip`, `bound_roles`, `missing_roles`,
  `metadata_for`. Currently one entry: `strike_head` →
  `combo_jab_cross_hook.glb`, `length_s 2.47`, `reach_m 0.747`.
- `Godot/scripts/FightStagePlayer.gd` — **yours, from U39.** `bind`,
  `play_role`, `present_beat`. Grafts once at bind time.
- `Godot/scripts/BoneTrackGraft.gd` — Q29's. `graft(source, skel, skel_path)`.
  **Use it, do not reimplement it.**
- `Godot/tests/fight_stage_playback_test.gd` — yours, 25/0.
- `Godot/scripts/FightStageDirector.gd` (321 lines) — **NOT yours, do not edit
  it.** Claude is rewriting `required_roles()` to type-first separately; your
  binding must not assume either shape. Bind by the STRING keys you define.

## Owned files

- `Godot/scripts/FightClipSlice.gd` — NEW, yours.
- `Godot/scripts/FightClipBinding.gd` — yours, EDIT.
- `Godot/tests/fight_clip_slice_test.gd` — NEW, yours.
- `research/U40_DIGEST.md` — NEW, yours, max 40 lines.

## Part 1 — find the punch boundaries, and MEASURE them, do not guess

`FightClipSlice.gd`, a pure static module. **Zero preloads, no RNG, no
`get_node`.**

- `static func slice(source: Animation, start_s: float, end_s: float) -> Animation`
  Return a new `Animation` holding only the keys in `[start_s, end_s]`,
  re-based so the result starts at 0.0. Every track the source had, none
  dropped.
- `static func punch_windows(source: Animation) -> Array` — the interesting
  one. Find the three punch boundaries **from the animation data itself**, and
  return an array of `{"name": String, "start_s": float, "end_s": float,
  "reach_m": float}`.

**How to find them, and this is the part to do properly:** track a hand bone's
distance from the root over the clip and look for the extension peaks. A jab,
a cross and a hook produce three maxima with retractions between them.
**Report the peaks you actually found.** If you find four, or two, say so and
say which — do not force the answer to three because the filename promises
three. The filename is a claim; the curve is evidence.

`reach_m` per punch is that punch's own peak hand travel. **The combined clip
measured 0.747 m; the three individual punches will differ from each other and
that difference is a finding Claude needs**, because a jab and a hook covering
visibly different distances changes how the engine's 0.885 m median and its
[1.0, 1.1) mode get matched to clips.

## Part 2 — bind the three

Add the three sliced punches to `BINDINGS` under the keys `jab`, `cross` and
`hook_lead` (or `hook_rear` if the curve says the hook is thrown with the rear
hand — **look, then name it**). Keep `strike_head` bound as it is so U39's test
does not go red; a role may point at the same file.

Each entry carries its own `length_s` and measured `reach_m`. **Do not put a
guessed number in `reach_m`** — if a punch's peak cannot be measured, write
`-1.0` and say so in the digest, exactly as U39's contract required.

## Part 3 — play a single punch

`FightStagePlayer` must be able to play one sliced punch for one beat. After
this task, a single scored head strike shows **one punch, not three.** Assert
that in the test by clip length: the played animation is under 1.2 s, not 2.47.

## What the test must prove

**Assert the feature OCCURS, not that it is permitted.**

1. `punch_windows` returns **at least two** windows off the real file, and every
   window has `end_s > start_s` and lies inside the clip. Print how many were
   found and their boundaries.
2. A sliced animation has **the same track count** as the source and **non-zero
   length**, and its bones **actually move** — sample a bone at two times inside
   the slice and assert the transforms differ. R94's whole finding was that a
   clip can look fine while moving 0 of 22 bones.
3. Playing a beat now plays a clip **shorter than 1.2 s** — the combo trap is
   closed.
4. Determinism: two runs on one seed produce the same sequence.

**Never gate on an exact count and never on an exact zero.** Write ceilings and
floors — "at least two windows", not "exactly three" — so an honest curve that
disagrees with the filename reports instead of going falsely red.

## Traps

- **Headless Godot: `global_transform` and `global_position` are STALE.** No
  frame is drawn, so they read identity. Use LOCAL transform/position or
  `force_update_transform()`. Same family as the bone-pose comment at
  `fight_world_anim_test.gd:59-62` — and it is how you will be tempted to
  measure hand travel, so read that comment before you write the measurement.
- `var x := <call>` fails when the call returns Variant. Write the type.
- **Another agent has files STAGED in this shared checkout right now.** Run
  `git status -s` before you commit and `git add -- <explicit paths>` only.
  Never `git add -A`, never a bare `git stash` / `reset --hard` / `clean`.
- **Push to master, not a branch.** `git rev-parse --abbrev-ref HEAD` before
  believing anything landed.
- rc=0 is NOT a pass (R75) — read the output. Never pass `--godot` to
  `run_tests.py`.

## Gate

```
python Godot/tools/check_scripts.py Godot/scripts/FightClipSlice.gd Godot/scripts/FightClipBinding.gd Godot/tests/fight_clip_slice_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_clip_slice_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_stage_playback_test.gd
python Godot/tools/run_tests.py --only world
python Godot/tools/run_tests.py --only fight
```

## Finish

Commit explicit paths, push **master**, write the digest, then:

`python Tools/agent_comms.py send --from cursor --to claude --subject U40-done --body "<sha> windows-found=<n> names=<a/b/c> reach_m=<a>/<b>/<c> slice-len=<a>/<b>/<c>s own=<checks>/<fails> world=<n>/<f> fight=<n>/<f> combo-trap=closed"`

Do NOT edit `HANDOFF.md`.

**The one trap specific to this task:** it is very easy to "find" three punches
by cutting the 2.47 s clip into three equal 0.82 s pieces and calling it done.
That would produce a green test, three plausible entries, and three clips that
each start and end mid-motion. **Cut on the retractions the curve actually
shows.** If the curve will not give you clean boundaries, say so and deliver two
punches, or none — a reported failure here is worth far more than three clips
that look right in a dictionary and read as garbage on the canvas.
