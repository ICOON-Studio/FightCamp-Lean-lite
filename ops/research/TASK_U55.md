# TASK U55 — CURSOR — THE PAIRED MOUNT: TWO BODIES, ONE TRANSFORM

Model: Composer, medium effort. Owner: cursor.
Test tier: **NEW MODULE + ITS TEST** — parse gate, then that ONE test, then
`--only fight_clip`. Do NOT run the full suite; it is Claude's at integration.

```
python Godot/tools/check_scripts.py Godot/scripts/PairedClipMount.gd Godot/tests/paired_clip_mount_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/paired_clip_mount_test.gd
python Godot/tools/run_tests.py --only fight_clip
```

## Owned files

- `Godot/scripts/PairedClipMount.gd` — **NEW. Yours alone.**
- `Godot/tests/paired_clip_mount_test.gd` — **NEW. Yours alone.**

Nothing else. Do not edit `FightClipRetarget.gd`, `FightClipBinding.gd`,
`GameState.gd`, `HANDOFF.md`, or any existing test.

## Why this exists

We own eight **paired** two-body grappling clips (`Full Mount Attacks`, RamsterZ).
R106 proved the thing nobody had proved for any paired pack at any price: **the
relative alignment between the two bodies survives the trip into Godot** —
`R106_AUDIT bones=69 exact=0/22 map_covers=22/22 paired=8 solo=0`.

Every piece of machinery to use them now exists. The 22-row BoneMap is confirmed
complete, the rest-pose correction is understood, and `FightClipRetarget` already
puts bought clips onto our fighters — twenty-seven receiver clips play today.

**And not one of the eight is on screen,** because of the last step in R106's
own list, which nothing has implemented:

> **Placing the pair.** The engine already knows where both fighters are; mount
> the two clips at one shared transform rather than at each fighter's own mark,
> or the relative alignment that survived all the way here is thrown away at the
> last step.

That is this task. It is the whole task.

## THE CONTRACT

`Godot/scripts/PairedClipMount.gd`, `extends RefCounted`, **static functions
only**, and **ZERO preloads of game code** — it must be testable without
GameState. It takes data in and hands data back; it never reaches for the world.

```gdscript
## A paired clip is ONE performance danced by two bodies. Both halves were
## authored in a single shared space, so their alignment is a property of
## that space and not of either body.
static func shared_origin(a_root: Transform3D, b_root: Transform3D) -> Transform3D

## Where each body must be placed, given the pair's shared origin.
static func place(origin: Transform3D, a_offset: Transform3D, b_offset: Transform3D) -> Dictionary

## The guard: does a proposed placement preserve the authored separation?
static func alignment_error(placed_a: Transform3D, placed_b: Transform3D, authored_a: Transform3D, authored_b: Transform3D) -> float

## Pair two clip names from one source. "Paired_FullMount_H2H_Punches_Att" and
## "Paired_FullMount_H2H_Punches_Vic" are ONE performance; the separator "_"
## and the two role words "Att" and "Vic" are the contract. THESE ARE THE
## REAL FILENAMES ON DISK - do not invent "Attacker"/"Victim".
static func pair_key(clip_name: String) -> String
static func pair_role(clip_name: String) -> String
```

- `shared_origin` returns the single transform the pair is mounted at. It is a
  function of BOTH roots — typically the midpoint of their translations with a
  yaw that faces them correctly — never simply `a_root`.
- `place` returns `{"a": Transform3D, "b": Transform3D}`, each being
  `origin * offset`. Both bodies move as one rigid unit.
- `alignment_error` returns the distance, in metres, between the authored
  separation (`authored_a.origin.distance_to(authored_b.origin)`) and the placed
  separation. **It must return ~0.0 for any placement produced by `place`, at any
  origin, including a rotated one.** That is the guard the whole task exists for.
- `pair_role` returns `"att"`, `"vic"`, or `""` when the name carries neither.
  It matches the suffix `_Att` / `_Vic` CASE-INSENSITIVELY and only as a
  SUFFIX, so `Paired_FullMount_AttackBlock_Vic` is role `"vic"` and NOT role
  `"att"` - the substring "Att" appears in the middle of that very name, and a
  `contains()` test gets it wrong. `pair_key` returns the name with the role
  suffix and its separator stripped, so both halves return the SAME key.
- It must also tolerate a `.fbx` extension and a full `res://` path: strip the
  directory and the extension before looking for the role.

## Q54 IS IN, AND IT ADDS ONE FUNCTION

`research/Q54_PAIRED_IN_GODOT.md` landed after this task was written. Three
findings change what you build:

1. **`retarget/rest_fixer` is IMPORT-TIME and baked into the saved resource, so
   it ships.** Enable *Overwrite Axis* + *Fix Silhouette* for an A-pose source
   against a T-pose profile. The risk that this whole feature was editor-only is
   cleared. Nothing for you to do about it here - it is upstream of you - but it
   is why this task is worth doing at all.
2. **Godot has NO built-in way to keep two `AnimationPlayer`s in step.** Q54
   searched and returned `NOT FOUND`. They must be started on the same frame and
   share a `speed_scale`; delta playback then holds lockstep unless one is seeked
   independently. So add one more function to the contract:

```gdscript
## Two players driving one performance have no engine-level sync (Q54:
## NOT FOUND). They are started together and share a speed_scale; this is
## the guard that says whether they have drifted apart since.
static func in_step(a_pos: float, b_pos: float, tolerance: float = 0.016) -> bool
```

   The default tolerance is one frame at 60 fps. Test it either side of that
   boundary, and test that it is symmetric in its two arguments.

3. **Root motion on both halves at once is undocumented** (`NOT FOUND` again).
   Q54's recommendation, and the one to build to: **strip root motion from BOTH
   halves and drive the shared parent with the combined delta.** That is exactly
   what `place()` is for - the pair moves as one rigid unit and neither body
   carries its own travel. Say in a comment that this is the chosen route and
   that Q54 found no documented alternative.

## WHAT THE TEST MUST PROVE

The one that matters: **place the pair at a dozen different origins — translated,
rotated 90/180/270 degrees, and at a non-zero height — and assert
`alignment_error` stays within 1 mm every time.** Then assert the naive approach
FAILS that check: place body A at one mark and body B at a different mark the way
a solo clip would be placed, and show the error is large. A test that only proves
the good path passes tells us nothing about the bug we are avoiding.

Also: two halves of one clip share a `pair_key` and differ in `pair_role`; a solo
clip name yields `""` for the role and is unchanged by `pair_key`.

**Use the REAL names. All sixteen pairs are on disk at**
`Godot/assets/anim/audition/ramsterz/`, each as `<name>_Att.fbx` + `<name>_Vic.fbx`:

```
Paired_FullMount_Takedown_DoubleLeg_Start   Paired_FullMount_H2H_Punches
Paired_FullMount_Takedown_BodyLock_Start    Paired_FullMount_H2H_ArmBar
Paired_FullMount_Takedown_BodyLock_Loop     Paired_FullMount_H2H_Strangle
Paired_FullMount_Takedown_BodyLock_End      Paired_FullMount_H2H_HeadSmash
Paired_FullMount_Reversal                   Paired_FullMount_VictimAttack
Paired_FullMount_AttackBlock                Paired_FullMount_PushOff
Paired_FullMount_1HM_AxeToFace              Paired_FullMount_1HM_BluntSmack
Paired_FullMount_1HM_KnifeStab              Paired_FullMount_1HM_SlashNeck
```

**Assert `pair_key`/`pair_role` against at least these four, which are the ones
that break a naive implementation:** `Paired_FullMount_AttackBlock_Vic` (the
string "Att" is in the middle), `Paired_FullMount_VictimAttack_Att` (both role
words appear in one name), `Paired_FullMount_Takedown_BodyLock_Loop_Att` (a long
multi-underscore key), and a solo name such as `H2H_Jab_01` which has no role.

## Definition of done

- Both files exist, the focused test reports `failures=0`, and `--only fight_clip`
  is no worse than it is now.
- `failures=0` is a **CEILING, not an exact count.** If you find something else
  already failing and fix it, say so and push the better result.
- Commit, push, and send one line:
  `python Tools/agent_comms.py send --from cursor --to claude --subject U55-done --body "<sha> checks=N failures=M max_alignment_error=X"`

## The traps specific to U55

1. **`Transform3D` multiplication does not commute.** `origin * offset` and
   `offset * origin` give different answers and only one of them keeps the pair
   rigid. Prove which by test, not by reasoning — the rotated-origin cases in the
   list above are exactly what catches it.
2. **Do not `.orthonormalized()` away a scale you should have kept, and do not
   skip it where the maths needs it.** State in a comment which you chose.
3. **This module must not know what a fighter is.** No `GameState`, no
   `Skeleton3D`, no preloads of game scripts. It is pure transform arithmetic so
   it can be tested in isolation, and so the presenter can call it later without
   inheriting anything.
4. **We own SIXTEEN pairs, not eight.** R106's audit line `paired=8` is the count
   of pairs it SAMPLED for root alignment, not the count owned. 32 FBX files, 16
   pairs, 12 of them empty-hand. Do not write "8" anywhere.
5. **A bought clip's `length` is not its content length** (TRAPS §1) — nine of
   eleven receiver clips carried dead air. You are not slicing clips here, but do
   not write any assertion that assumes a clip's reported duration is real.
