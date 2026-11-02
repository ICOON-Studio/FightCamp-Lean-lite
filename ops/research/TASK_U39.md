# TASK U39 — CURSOR — THE STAGE PLAYS A BEAT

Model: Cursor, `-p --force --trust`, **medium** effort.
Owner: cursor. Tier: **SCRIPTS ADDED + ONE SCENE SCRIPT TOUCHED** — parse gate,
your own new test, then `python Godot/tools/run_tests.py --only world` and
`--only fight`. Do NOT run the full suite; that is Claude's once, at
integration.

## Why this exists — the exact gap, in one sentence

`FightStageDirector` (R99) **names a role** — `strike_head`, `react_body`,
`knockdown` — and **nothing in the repository binds a role to a clip file and
plays it.** The 3D stage mounts two fighters facing each other (U38) and they
stand there. This task closes that, using the ONE clip we already own. **You
are not buying anything and you are not waiting on a purchase.**

## What already exists — do not rebuild any of it

- `Godot/scripts/FightStageDirector.gd` (321 lines, read it whole, it is small)
  — `required_roles()` returns the ten roles in a fixed order;
  `role_for_strike(region)`, `role_for_react(region, contact)`,
  `hand_for(tick)`, `placement(...)`. Pure static, no RNG. **Do not edit it.**
- `Godot/scripts/FightBeatAdapter.gd` (472 lines) — `begin`, `is_fight_over`,
  `advance_beat`, `result`, `state_view`. This is the beat stream. **Do not
  edit it.**
- `Godot/scripts/BoneTrackGraft.gd` — Q29's module. `graft(source, skel,
  skel_path)` returns `{"animation": Animation, "matched": int, "unmatched":
  PackedStringArray}`. This is the track-path rewrite that makes a mesh-free
  clip drive a `Skeleton3D`. **Use it. Do not reimplement it.**
- `Godot/tests/fight_world_anim_test.gd` (258 lines) — read it whole. It is the
  worked example: it loads the fighter, finds the `Skeleton3D` and
  `AnimationPlayer`, grafts, and plays. Your work is that, driven by beats
  instead of by hand.
- `Godot/assets/models/fighters/anim/combo_jab_cross_hook.glb` — **the only
  clip on disk.** 58 KiB, mesh-free, 22 bones that are already
  `SkeletonProfileHumanoid`.
- `Godot/scenes/FightWorldPreview.tscn` — `SpawnA` and `SpawnB` markers,
  `IsometricCamera`, `Key`, `Fill`. `Godot/scripts/FightWorldStage.gd` (95
  lines) is its helper.

## Owned files

- `Godot/scripts/FightClipBinding.gd` — NEW, yours.
- `Godot/scripts/FightStagePlayer.gd` — NEW, yours.
- `Godot/tests/fight_stage_playback_test.gd` — NEW, yours.
- `Godot/scenes/FightWorldPreview.tscn` and its script — **only if you must**;
  say so in the digest if you touch the scene.
- `research/U39_DIGEST.md` — NEW, yours, max 40 lines.

## Part 1 — `FightClipBinding.gd`, and it is deliberately dumb

A pure static module. **Zero preloads, no RNG, no `get_node`, no autoload
identifiers.** It answers one question: given a role, which clip file plays it,
and what do we know about that clip?

```gdscript
class_name FightClipBinding
```

- `static func clip_for(role: String) -> String` — the `res://` path, or `""`
  when that role has no clip yet. **Today NINE of the ten roles return `""`
  and that is the correct answer.** Do not invent substitutions; a role with
  no clip shows the idle pose, and the caller decides that, not this module.
- `static func has_clip(role: String) -> bool`
- `static func bound_roles() -> PackedStringArray` — the roles that currently
  resolve, in `required_roles()` order.
- `static func missing_roles() -> PackedStringArray` — the complement. **This
  is the shopping list and Claude reads it**, so it must be honest.
- `static func metadata_for(role: String) -> Dictionary` — for a bound role,
  `{"path": String, "length_s": float, "reach_m": float}`. `reach_m` is **how
  far the throwing hand travels from the body in that clip**, and if you cannot
  measure it, put `-1.0` and say so in the digest. Do NOT guess a number; a
  fabricated reach is worse than an absent one, because the disagreement policy
  will be decided against it.

**The bindings live in one `const` dictionary at the top of the file** so that
adding a purchased clip is a one-line edit by anyone. Comment it as such.

## Part 2 — `FightStagePlayer.gd`, the thing that actually moves a body

This one is NOT pure — it touches nodes — and that is fine. It is a
`RefCounted` helper, not an autoload.

- `func bind(fighter_root: Node3D) -> bool` — find the `Skeleton3D` and
  `AnimationPlayer` the way `fight_world_anim_test.gd:132` does, graft every
  bound clip through `BoneTrackGraft`, and report success. Graft ONCE at bind
  time, never per beat.
- `func play_role(role: String) -> bool` — play the grafted clip for that role,
  return `false` when the role has no clip. **Returning `false` is a normal
  outcome, not an error**; the body simply keeps its idle pose.
- `func present_beat(beat: Dictionary, actor_side: String) -> Dictionary` —
  take one beat off `FightBeatAdapter.advance_beat`, ask
  `FightStageDirector` what the roles are, play them, and return what it
  actually did: `{"actor_role": String, "target_role": String, "played":
  PackedStringArray, "skipped": PackedStringArray}`. **`skipped` is the
  honest counter and the test asserts it is non-zero**, because with one clip
  on disk most roles cannot play — a "played everything" report would be a lie.

**No RNG anywhere.** The hand comes from `FightStageDirector.hand_for(tick)`,
which is a pure function of the beat's tick. Two runs on one seed must show the
same picture.

## Part 3 — drive it, and this is what "play a beat" means

Wire the preview so a real seeded bout runs through `FightBeatAdapter` and the
two mounted bodies present the beats. The camera stays where M14 put it; you
are not redesigning the frame.

## What the test must prove

**Assert the feature OCCURS, not that it is permitted.** Run a real seeded
bout end to end and assert, printing every number:

1. `strike_head` was requested **at least once** and **actually played** — the
   `AnimationPlayer` reports the grafted clip as current. A stage that could
   play a clip but never does is exactly the unreachable-code defect this area
   has shipped five times.
2. `skipped` is **non-zero** — the honest consequence of owning one clip.
3. Bone poses **actually move**: sample a bone at two times inside the clip and
   assert the transforms differ. R94's whole finding was that before the track
   rewrite the clip moved **0 of 22 bones** while looking fine.
4. Determinism: run the same seed twice and assert the two `played` sequences
   are identical.

**Never gate on an exact count or an exact zero.** Ceilings and floors only.

## The traps, all bought with real time yesterday

- **IN HEADLESS GODOT, `global_transform` AND `global_position` ARE STALE.** No
  frame is drawn, so they read identity. R99's `face_each_other` computed
  `atan2(0,0)=0` and the yaw was silently never applied. Use **local**
  transform/position, or call `force_update_transform()`. Same family as the
  bone-pose trap at `fight_world_anim_test.gd:59-62` — read that comment.
- A scene script compiles before the autoloads: use
  `get_node_or_null("/root/GameState")` plus `has_method`, never the bare
  `GameState` identifier. Never add a top-level `preload` of such a script to
  `smoke_test.gd`.
- `var x := <call>` fails when the call returns Variant. Write the type:
  `var n: int = ...`.
- **Your shell can die mid-task.** If it does, the code is still on disk. Run
  `git status -s` before reporting a blocker.
- **Do not leave the shared checkout on a branch.** Push to **master**. Six
  commits went to `cursor/u34-judo-board-caller` last week and
  `git push origin master` answered "Everything up-to-date" while none of it
  had landed. `git rev-parse --abbrev-ref HEAD` before you believe anything.

## Gate

```
python Godot/tools/check_scripts.py Godot/scripts/FightClipBinding.gd Godot/scripts/FightStagePlayer.gd Godot/tests/fight_stage_playback_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_stage_playback_test.gd
python Godot/tools/run_tests.py --only world
python Godot/tools/run_tests.py --only fight
```

**rc=0 is NOT a pass (R75)** — a runtime error leaves rc=0 and prints
`0 failure(s)` having never reached the counter. Read the output. **Never pass
`--godot` to `run_tests.py`.**

## Finish

Commit explicit paths (`git add -- <files>`; check `git status -s` first,
another agent may have WIP pre-staged), push **master**, write the digest, then:

`python Tools/agent_comms.py send --from cursor --to claude --subject U39-done --body "<sha> own=<checks>/<fails> world=<n>/<f> fight=<n>/<f> bound-roles=<n>/10 strike_head-played=yes skipped=<n> bones-moved=<n>/22 deterministic=yes reach_m=<value-or-absent>"`

Do NOT edit `HANDOFF.md`.

**The one trap specific to this task:** `combo_jab_cross_hook.glb` is a
COMBINATION — three punches in one clip — and a beat is a single presented
strike. Do not silently play the whole combination for one beat and call it a
jab. Either play a slice and say which, or play the whole thing and **record in
the digest that the stage currently shows three punches where the engine scored
one**. That is a G42 "inventing" problem and Claude must be told about it in
plain words; it is a finding, not a failure, and papering over it is the
failure.
