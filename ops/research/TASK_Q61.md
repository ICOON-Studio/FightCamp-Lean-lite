# TASK Q61 — QWEN — WHAT IS ACTUALLY IN THE CLIP

Model: qwen3-coder, **medium effort**. Owner: qwen.
Test tier: **ONE NEW TOOL AND ONE REPORT. NO SHIPPED `.gd` IS EDITED.**
Parse gate the tool, run it, write the report. **Do NOT run the full suite** —
it is Claude's, once, at integration. **Only one Godot at a time in this
checkout.**

```
python Godot/tools/check_scripts.py Godot/tools/measure_clip_shape.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/measure_clip_shape.gd
```

## Owned files

- `Godot/tools/measure_clip_shape.gd` — **NEW. Yours alone.**
- `research/Q61_CLIP_SHAPE.md` — **NEW. Yours alone.**

Nothing else. Do **NOT** edit `FightClipBinding.gd`, any script under
`Godot/scripts/`, any test, or `HANDOFF.md`. This task DESCRIBES clips; it does
not bind them. `GameState.gd` is 12,938 lines — you do not need it, never open
it.

## Why this exists

**Eleven animation clips are sitting unbound today for one reason: nobody has
looked at them, and their filenames are not enough.** R113 bound everything the
vendor's own noun settled and stopped exactly where the noun stopped:

- `muay_thai_teep` (1,323 pooled throws) and `kickboxing_front_kick` (868) are
  the 7th and 9th highest-demand technique ids in the whole catalogue, together
  worth **9.4% of striking coverage**, and the only candidate clip we own is
  named `H2H_HighSideKick_InPlace`. **A teep is a straight push kick; a side
  kick is not.** Binding on the hope that a generic pack mislabelled a thrust
  kick is the M19 lie, and a coverage number would have applauded it.
- Five paired ground clips — `AttackBlock`, `VictimAttack`, `BodyLock_Loop`,
  `BodyLock_End`, `H2H_HeadSmash` — are ambiguous from their names alone. C91
  measured their TIMING, never their CONTENT.

**Your job is to replace the guess with a measurement.** Not an opinion about
what the clip "probably" is — a number that separates a forward thrust from a
lateral one, and a high target from a low one.

## The instrument

### THE TRAP THAT WILL COST YOU THE WHOLE TASK IF YOU MISS IT

**`Skeleton3D.get_bone_global_pose()` RETURNS THE REST POSE IN A HEADLESS RUN.**
There is no rendering frame to drive the AnimationPlayer, so anything you ask
the skeleton for is the T-pose, and every clip will measure identical. This has
cost two previous tasks.

**Read `Godot/tools/audit_striking_content.gd` first — it is small, it is the
C92 tool, and it already solves this.** It samples the Animation's TRACK VALUES
directly and walks its own `PARENT_BY_BONE` chain to build a virtual forward
kinematic pose. Reuse that approach. Its `PARENT_BY_BONE` and `HUMANOID_BONES`
tables are the UE4 Mannequin rows and are correct for every file below.

### What to measure, per clip

Sample the content window (first key → last key, exactly as C92 does) at
**120 Hz**, building a virtual FK pose per sample. Then report:

1. **`striking_limb`** — which of `hand_l`, `hand_r`, `foot_l`, `foot_r` travels
   the greatest distance from its own first-sample position. That is the weapon.
2. **`peak_s`** — the sample time at which that limb is furthest from its start.
3. **THE ONE THAT SETTLES THE TEEP.** At `peak_s`, express the striking limb's
   position **relative to the pelvis, in the pelvis's own frame**, decomposed as
   `forward_m` / `lateral_m` / `vertical_m`. Derive the pelvis frame from the
   pelvis's own rotation at that sample — never from world axes, because the
   body turns.
   - A **front / push kick** is forward-dominant: `|forward| > |lateral|`.
   - A **side kick** is lateral-dominant: `|lateral| >= |forward|`.
   - Print the ratio `forward_m / max(|lateral_m|, 0.001)` as `thrust_ratio` so
     the verdict is a number and not an adjective.
4. **`peak_height_m`** — the striking limb's vertical position at `peak_s`
   relative to the pelvis, and as a fraction of the clip's standing height
   (head y − foot y at sample 0). Say `high` (at or above pelvis+0.35 of height),
   `mid`, or `low` (below pelvis) using that fraction, and print the fraction.
5. **`pelvis_yaw_deg`** — the largest change in pelvis rotation about the
   vertical axis across the window. Over 90° means the clip spins or turns into
   the strike; near zero means it does not.
6. **`travel_m`** — how far the pelvis itself moves from first to last sample.
   A clip that walks into the strike cannot be played in place.

Print one `Q61_CLIP ...` line per clip with every field, plus a
`Q61_TOTALS clips=N ...` line at the end. A machine-readable line per clip
matters more than pretty formatting.

### The clips

**Striking, in `res://assets/anim/audition/ramsterz_h2h/`** — the first two are
the question, the last two are CONTROLS whose answer is already known and which
prove the instrument works before you trust it on the unknowns:

```
H2H_HighSideKick_InPlace.FBX     <- the teep candidate. THE QUESTION.
H2H_LowSideKick_InPlace.FBX      <- the same noun, low. THE QUESTION.
H2H_LeftCutKick_InPlace.FBX      <- bound as strike_leg. Confirm it is a LEG kick.
H2H_RightCutKick_InPlace.FBX     <- bound as kickboxing_low_kick. Same.
H2H_RoundhouseKick_InPlace.FBX   <- CONTROL. A roundhouse: expect lateral-dominant.
H2H_StraightPunchInPlace.FBX     <- CONTROL. A straight: expect forward-dominant,
                                    hand not foot.
```

**Paired, in `res://assets/anim/audition/ramsterz/`** — measure BOTH halves of
each pair separately and report them as separate rows. The `_Att` half is the
man on top:

```
Paired_FullMount_AttackBlock_Att.fbx      Paired_FullMount_AttackBlock_Vic.fbx
Paired_FullMount_VictimAttack_Att.fbx     Paired_FullMount_VictimAttack_Vic.fbx
Paired_FullMount_H2H_HeadSmash_Att.fbx    Paired_FullMount_H2H_HeadSmash_Vic.fbx
Paired_FullMount_Takedown_BodyLock_Loop_Att.fbx
Paired_FullMount_Takedown_BodyLock_Loop_Vic.fbx
Paired_FullMount_Takedown_BodyLock_End_Att.fbx
Paired_FullMount_Takedown_BodyLock_End_Vic.fbx
```

**`Paired_FullMount_AttackBlock_Vic` CARRIES THE STRING "Att" MID-NAME.** A
`contains("Att")` test gets that clip exactly backwards and U55 already paid for
that once. Match on the `_Att.fbx` / `_Vic.fbx` SUFFIX, or list the files
explicitly.

**`Takedown_BodyLock_End` carries 2.333 s of dead air** — its content window is
2.333 → 4.833, not 0 → 4.833. Your first-key/last-key window handles this
automatically if you compute it rather than assuming zero. Every other clip
above has zero dead air.

## The report

`research/Q61_CLIP_SHAPE.md`. Lead with the verdict table, then the raw
numbers:

| clip | striking limb | thrust_ratio | height | pelvis yaw | verdict |

**The verdict column is the deliverable.** For each of the two teep candidates
say, in one sentence, whether the measurement supports binding it to
`muay_thai_teep` / `kickboxing_front_kick` or refutes it — and give the number
that decides it. For the five paired clips, say what the attacker is doing and
what the victim is doing, as two short phrases, from the measurement.

**LABEL EVERY CLAIM.** `MEASURED` for anything your tool printed; `INFERENCE`
for anything you concluded from it; `NOT FOUND` for anything you could not
determine. You did this correctly on Q54–Q58 and it is why this task is yours.

**DO NOT BIND ANYTHING.** If a verdict says a clip fits an id, say so and stop.
Claude applies the bindings; you supply the evidence. A task that edits
`FightClipBinding.gd` has failed even if the binding is right.

**IF THE CONTROLS DISAGREE WITH THEIR KNOWN ANSWER, SAY SO AND STOP.** A
roundhouse that measures forward-dominant means the instrument is wrong, not
that the roundhouse is a front kick, and every other row is then worthless.
Report the disagreement rather than reasoning past it.

## GDScript traps

- `var x := <call>` fails when the call returns Variant (`.size()` or `.get()`
  on an untyped value, a static on a `load()`ed script) — write the type:
  `var n: int = ...`.
- A `%` inside a format string must be `%%`.
- Reusing a variable name inside one function is a parse error, even across
  separate `if` / `for` blocks.
- **Parse gate BEFORE you run anything.** A parse error does not fail a headless
  run, it HANGS it for 600 seconds.
- Use only
  `%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe`.
  There is a second, chocolatey `godot.exe` on this machine and it is NOT the
  project's engine.

## Done means

- `check_scripts.py` clean on `measure_clip_shape.gd`.
- The tool runs headless and prints a `Q61_CLIP` line for all sixteen rows
  (six striking + ten paired halves).
- Both CONTROLS agree with their known answer, or the disagreement is reported.
- `research/Q61_CLIP_SHAPE.md` written, with the verdict table first.
- `git status -s` checked, then `git add --` your two explicit paths only,
  commit ending `Co-Authored-By: Qwen <noreply@qwen.ai>`, push.
- One line of mail:
  `python Tools/agent_comms.py send --from qwen --to claude --subject Q61-done --body "<hash> clips=N teep_verdict=<supports|refutes> controls=<agree|disagree>"`
- **Write your HANDOFF digest.** Q59 shipped without one and had to be given
  one. Yours is `research/Q61_CLIP_SHAPE.md`; do not edit `HANDOFF.md`
  itself — Claude writes your block there.
