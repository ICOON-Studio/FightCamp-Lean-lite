# TASK U47 — CURSOR — THE BLIND CONTRACT TEST FOR THE PRESENTER

Model: cursor-agent, **medium** effort. Owner: cursor.

**Tier: ONE NEW TEST FILE in `Godot/tests/`. NO `.gd` IN `scripts/` MAY BE
EDITED.** Parse gate your one new file, then run that ONE test. **DO NOT RUN THE
SUITE** — a new test file cannot break another test, and the suite costs twenty
minutes.

## Why this exists, and why it is deliberately blind

R103 found a live defect and fixed it. Over three seeded boxing bouts — **148
action beats** — the presenter played **a clip the fight never threw 85 times,
57.4%**, and every one of those 85 was the jab. An overhand played a jab. A rear
uppercut played a jab. A lead hook that HAS its own clip played a jab. **A green
suite never saw it**, because the report said `strike_head` while the
AnimationPlayer held `jab`.

The same session wrote both the fix and the test that now gates it. That is the
weakest possible arrangement, and this project has a standing rule about it: **a
test written against an implementation only ever agrees with that
implementation.** So U47 is the independent one. It is written **from the
contract below and from nothing else.**

**DO NOT READ `Godot/scripts/FightStagePlayer.gd`.** Not to "check the field
names", not to "see what it returns". The contract below is complete and is the
authority. If the contract and the code disagree, that disagreement is the
finding and it is worth more than a green test — report it, do not reconcile it.

**DO NOT READ `Godot/tests/fight_stage_technique_fidelity_test.gd`** either; that
is R103's own gate and reading it makes yours a copy.

## THE CONTRACT — exact names, exact types, exact strings

### The beat you are given

`FightBeatAdapter.advance_beat(state)` returns a beat Dictionary. On an action
beat the fields that matter here are:

| key | type | meaning |
|---|---|---|
| `type` | String | `"action"` for a thrown blow; anything else is not one |
| `actor_side` | String | `"a"` or `"b"` — who threw |
| `target_side` | String | `"a"` or `"b"` — who was hit |
| `target_region` | String | one of `head_neck` `torso_core` `left_leg` `right_leg` `left_arm` `right_arm` |
| `contact` | String | one of `clean` `glancing` `absorbed` `blocked` `slipped` `missed` |
| `technique` | String | the catalogue node id, e.g. `boxing_overhand`. **Empty means the engine named nothing.** |
| `clip_role` | String | the binding key for that technique, e.g. `hook_lead`. Empty when there is no technique |
| `has_clip` | bool | true when we own a clip for `clip_role` |
| `clip_missing` | bool | true when a technique WAS named and we do NOT own it |
| `fallback_receiver` | String | the reaction role for the region, e.g. `react_head`. Set only when `clip_missing` |
| `knockdown` | bool | optional |

### The call

`FightStagePlayer.new()`, then `bind(fighter_root: Node3D) -> bool`, then
`present_beat(beat: Dictionary, my_side: String) -> Dictionary`.
`my_side` is the body this instance is, `"a"` or `"b"`. **One instance per body**
— you need two.

### What `present_beat` returns, and these names are the contract

| key | type | meaning |
|---|---|---|
| `actor_role` | String | the CATEGORY the thrower performed: `strike_head` / `strike_body` / `strike_leg`, or `idle` on a non-action beat. A category, never a technique |
| `target_role` | String | the category the receiver performed: `react_head` / `react_body` / `react_leg` / `block` / `slip` / `knockdown` / `idle` |
| `actor_clip` | String | **the animation that ACTUALLY started on the thrower's AnimationPlayer**, `""` when none did |
| `target_clip` | String | likewise for the receiver, `""` when none did |
| `thrower_idle` | bool | true when the thrower was given NO clip because we do not own his technique |
| `played` | PackedStringArray | the category roles that got a clip |
| `skipped` | PackedStringArray | the category roles that asked for one and were refused |

### THE FOUR RULES YOU ARE TESTING

1. **A technique we own plays EXACTLY its own clip.** `has_clip == true` →
   `actor_clip == beat["clip_role"]`. Not a neighbour's, not a category's.
2. **A technique we do NOT own plays NOTHING on the thrower.** `clip_missing ==
   true` → `actor_clip == ""` **and** `thrower_idle == true`. This is M19's
   degrade and it is a finished answer, not a placeholder. **Dropping is
   permitted, inventing is forbidden.**
3. **An UNNAMED strike may play the category role.** `technique == ""` (and both
   flags false) → `actor_clip` may be `strike_head` / `strike_body` /
   `strike_leg`. Nothing was named, so nothing is contradicted.
4. **`actor_clip` is NEVER a third thing.** For every action beat it is either
   `beat["clip_role"]` (when owned), or `""`, or — only for an unnamed beat — the
   category role. **Anything else is a substitution and a failure.**

The RECEIVER is deliberately different: a region-matched reaction is M19's own
sanctioned answer and claims nothing about a technique, so `target_role` is
decided from `contact` first and `region` second by
`FightStageDirector.role_for_react`, which you MAY read.

## What we own today, and you must not hardcode past it

`Godot/scripts/FightClipBinding.gd` is the register — **read it, 165 lines, read
it whole.** Today it binds `strike_head` plus typed punches `jab`, `cross`,
`hook_rear` and the mirrors `jab_lead`, `cross_lead`, `hook_lead`. **There is no
reaction clip, no block, no slip, no knockdown and no idle clip at all**, so a
receiver role is a `skipped` entry today and that is correct, not a bug. Ask
`FightClipBinding.has_clip(role)` rather than writing a list into your test —
when a clip is bought, your test must not go red for the wrong reason.

## What to build

**`Godot/tests/fight_stage_presenter_contract_test.gd`** — `extends SceneTree`,
the house shape: `_check(ok, label)`, a `_checks` / `_fails` pair, and a final
`print("TOTAL=%d fails=%d")` plus `quit(1 if _fails > 0 else 0)`.

Cover it **two ways, and both are required**:

**A. SYNTHETIC BEATS** — hand-built Dictionaries, one per rule above, including
the cases a seeded fight will not produce on demand: a `clip_missing` overhand, an
owned lead hook, an owned cross, a beat with no `technique` key at all, a
`knockdown`, and a non-action beat. For the owned cases, also assert the
**AnimationPlayer really holds it** (`animation_player().current_animation`) —
the defect R103 fixed passed every report-level check while the player held the
wrong clip, so **a report-only assertion is exactly the hole that let it
through.**

**B. A SEEDED BOUT, ASSERTED BY OCCURRENCE.** Drive `FightBeatAdapter` over
**three seeds summed**, boxing, 3 rounds, and count: action beats, beats where
`actor_clip == clip_role`, beats where the degrade was taken, and **beats where
`actor_clip` was a third thing (which must be 0)**. Then assert floors: the
named-clip path OCCURS, the degrade path OCCURS, at least TWO DISTINCT clips
play, and substitutions are ZERO.

**Use three seeds, not one.** U43 wrote a floor of 8 against seed 94301 alone and
it could never be met: that bout ends inside the first minute with four action
beats. Seeds `94301, 94302, 94303` summed is the fixture R103 used and it
reaches all four paths.

**A FLOOR IS A CEILING-FREE GATE.** Write every floor as "at least N"; never "is
exactly N". A task that demands an exact count traps over-delivery — C43F did
that and forbade Codex from pushing a better result.

## Mounting two bodies — reuse, do not reinvent

`FightStagePlayer.bind` needs a real rigged body with a `Skeleton3D` and an
`AnimationPlayer`. U38 already built the mount and you must use it:

```gdscript
const Stage := preload("res://scripts/FightWorldStage.gd")
# Stage.mount(world, glb_path, spawn_name, deck_y, kg, sex) -> Dictionary
#   {"ok", "node", "skeleton", "animation_player", "aabb", "scale", "feet_y", "reason"}
# Stage.face_each_other(a, b)
```

The room is `res://scenes/FightWorldPreview.tscn` (a shell: camera, lights,
`SpawnA`, `SpawnB`). The deck height comes from
`ArenaSurface.for_discipline("boxing")` → `arena_specs.json` → `ArenaRig.surface_y(spec)`;
a boxing ring stands at 1.27 m and a spawn marker deliberately carries no Y.
Bodies: `res://assets/models/fighters/f01_m_box_welter_rigged.glb` at 66.7 kg and
`f02_m_box_heavy_rigged.glb` at 120.0 kg.

`Godot/tests/fight_world_pair_test.gd` is the worked example of the mount and you
MAY read it — it is U38's, not R103's.

## Owned files

- `Godot/tests/fight_stage_presenter_contract_test.gd` — NEW, yours alone.
- `research/U47_DIGEST.md` — short. The counts you measured, and any place
  the contract above and the code disagreed.

**DO NOT EDIT** anything in `Godot/scripts/`, any other test, or `HANDOFF.md`.
If the contract is unsatisfiable, **leave your test RED and report it.** A red
test that names a real disagreement is the deliverable; weakening a floor to get
green is the one forbidden move.

## Gate

```
python Godot/tools/check_scripts.py Godot/tests/fight_stage_presenter_contract_test.gd
```

then the ONE test:

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_stage_presenter_contract_test.gd
```

**rc=0 IS NOT A PASS.** A GDScript runtime error leaves rc=0, so a test whose
module was clobbered prints twenty `SCRIPT ERROR` lines, then prints
`0 failure(s)`, and exits 0. **Read the output.** Godot's
`N RID allocations ... leaked at exit` and `N resources still in use at exit` are
teardown chatter on any run that touches a scene, not failures.

## Report

Commit (explicit paths only, never `audio_exports/`), push **MASTER** — a branch
strands your mail where the inbox cannot see it — then one line via
`python Tools/agent_comms.py send --from cursor --to claude --subject U47-done`
carrying `checks=N/fails=M substitutions=K named_plays=P degrade=D`. Do not edit
`HANDOFF.md`. Check `git status -s` before staging.

## The two traps specific to this task

1. **A SEED IS ONLY MEANINGFUL WITH THE EXACT ENGINE THAT PRODUCED IT.** R102
   moved every seeded fight eleven commits ago and judo seed 94017 has now
   changed family twice under two stages. So **do not pin a specific technique to
   a specific beat index** — assert the INVARIANT ("whatever he threw, the clip
   that played was his") and the occurrence floors. A test that pins beat 17 to
   `boxing_cross` is a test that breaks on the next engine change while proving
   nothing.

2. **`.gd` LINE ENDINGS ARE MIXED IN THIS TREE.** `FightRealtime.gd` and most
   tests are CRLF; `FightMoves.gd` is LF. Detect per file, never assume — and do
   not reformat a file you are only reading.
