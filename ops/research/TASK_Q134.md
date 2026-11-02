# TASK_Q134 - QWEN - THE DEPTH QUESTION, ASKED OF A LIMB FOR THE FIRST TIME

**Owner:** qwen. **Model:** `qwen3-coder`, MEDIUM. `--yolo` (NEVER `auto`).
**Test tier:** parse gate, then `run_tests.py --only capsule`. `--only` DOES
NOT STACK. Do NOT run the full suite.

## Why this, and it is the first move of the next stage

S48 derived the THORAX radius from chest DEPTH instead of the isotropic p80
and it worked: f02 0.1909 -> 0.1418 m, ball ratio 0.625 -> 0.464, and the
defect S47 named (`forearm_r/thorax` at 0.1223 m in a collar tie) is gone.

**Then it tried the same thing on the PELVIS and the measurement refused it.**
The corpus went from **3/13 to 1/13** - `side_control`, `closed_guard` and
`mount` all lost passes - and **nearly every new worst pair was a LEG pair**:
`femur_r/femur_l`, `femur_r/femur_r`, `femur_r/shin_r`, `head/femur_r`.

That is Q131's cascade - YOUR measurement - reproduced in the static pose
corpus. Narrow the trunk, the bodies get closer, the legs collide.

**So the torso and the legs are one fix, and nobody has ever asked the depth
question of a LIMB.** That is this task, and the answer decides S49's shape.

## The question

`Godot/tools/s48_thorax_depth.gd` measures, for a capsule, the **isotropic
p80**, the **p80 DEPTH** (projected on a derived forward axis) and the **p80
BREADTH**, plus the ball ratio each gives. It currently asks that of `thorax`
and `pelvis` only.

**Ask it of `femur_l`, `femur_r`, `shin_l`, `shin_r`, `upper_arm_r` and
`forearm_r`, on both shipped rigs.** Report, per capsule per rig:

1. isotropic p80, p80 depth, p80 breadth, segment length;
2. **the ball ratio** under each (`r / segment_length`);
3. **breadth minus depth** - the allowance a depth capsule would stop claiming.

Then **the one line that decides S49**:

> **Is a limb meaningfully anisotropic, or is it round?**

A thigh IS closer to circular than a chest, so **the honest answer may well be
"depth buys almost nothing on a limb"** - and that is a RESULT, not a failure.
It would mean the leg collisions are NOT an over-wide capsule and the fix is
the corpus's authored stances instead. Those are completely different fixes and
one number tells them apart.

## What to build

Extend `Godot/tools/s48_thorax_depth.gd` to take the capsule list as a constant
at the top of the file rather than hard-coding two rows, and add the six above.
**Do not change the derivation itself** - `_forward_axis` and the projection are
S48's and are settled.

**PRINT THE FORWARD AXIS PER CAPSULE.** For the trunk it came out
`(-0.009, -0.172, -0.985)` on f02 and `(0.010, -0.172, -0.985)` on f01 - the
same axis off two different rigs, which is what proved it was derived rather
than guessed. **A limb's segment runs along the limb, so its forward axis is a
different vector, and if it comes out degenerate or wildly different between
the two rigs, SAY SO** - that would mean the axis derivation does not transfer
to limbs and the whole question needs re-asking.

## Owned files

- `Godot/tools/s48_thorax_depth.gd`
- `research/Q134_DIGEST.md` - NEW
- Nothing else. **Do NOT touch `FighterCapsules.gd`, `FightPoseSolver.gd` or
  `s47_contact_offsets.gd`** - Claude owns all three.

## Gate

```
python Godot/tools/check_scripts.py Godot/tools/s48_thorax_depth.gd
"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe" --headless --path Godot --script tools/s48_thorax_depth.gd
python Godot/tools/run_tests.py --only capsule
```
`--only capsule` is **total=2 fails=0** today and must stay there. The exit code
alone is NOT a pass - a GDScript runtime error still exits 0.

## Delivery

Cut a FRESH branch off `origin/master`. `git add -- <files>` only, never
`git add -A`, never `git stash` / `reset --hard` / `checkout .` / `clean`. Push
YOUR BRANCH. Then:
```
python Tools/agent_comms.py send --from qwen --to claude --subject q134-ready --body "..."
```
Do NOT edit `HANDOFF.md`.

## WHAT ALREADY EXISTS - READ BEFORE YOU START

`RESEARCH_INDEX.md` at the repo root lists 789 research documents, 220 Godot
tools and 116 drivers. **GREP IT, DO NOT READ IT WHOLE** (213 KB). Worth a grep
here: `capsule`, `depth`, `femur`, `overlap`, `Q131`, `Q132`. Your own Q131 and
Q132 are the direct ancestors of this task and `S48_THE_TORSO_AND_THE_HOLD.md`
(read its ADDENDUM) is the reason it exists.

## THE ONE TRAP FOR THIS TASK

**"Depth buys nothing on a limb" IS THE VALUABLE ANSWER IF IT IS TRUE, and the
pressure will be to find an effect.** S48 spent a session proving a change can
be right in principle, supported by every line of evidence, and still wrong -
the pelvis took the corpus from 3/13 to 1/13 and was reverted. **Report the
ratios you measure.** If every limb comes back near-circular with a
breadth-minus-depth under a centimetre, say that in one flat sentence and the
next session will go and look at the stances instead. That saves a whole stage.
