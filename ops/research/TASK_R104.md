# TASK R104 — CLAUDE — ASK LUDO FOR TWO PERFORMERS

Model: Opus, medium effort. Owner: claude.
**Operator question, 2026-09-11: "why we don't put that in the description when
generating the sprites in ludo?"**

Tier: **a spike. No `.gd` in `scripts/`, no pinned fight touched.** Parse gate on
any new tool, and `--only anim` if `fight_world_anim_test.gd` is edited. **No
suite run.**

## Why this exists, and it is a fair challenge to a refusal we never tested

C75 concluded that a continuous literal 3D ground exchange cannot be built from
stock clips, because every source is **single-actor** mocap and a ground fight
needs **two bodies in matched contact** — matched roots, persistent limb
contact, legal transitions. That verdict drove M19, drove the "ground is
PRESENTED, not animated" line, and is repeated in R103.

**It was never tested against the generator we actually pay for.**

C75's sentence about the text-to-motion class is:

> "These models primarily generate one human; they do not guarantee two-body
> hand/limb contact, matched attacker/defender roots, legal transitions or
> persistent guard/mount contact."

**"Primarily" and "do not guarantee" are not "cannot".** And R94's own measured
output — a mesh-free 58 KiB animation-only glTF with **22 bones**, exactly one
`SkeletonProfileHumanoid` — is evidence about the clips we HAPPENED to ask for,
not about what the generator refuses.

**At 0.2 credits a clip the guess costs more than the experiment.** R101 nearly
shipped a guessed 1.2 s combination window as a finding; this is the same error
wearing the other hat — refusing a direction on an assumption.

## The experiment, and it has TWO arms

### ARM A — ask for two performers directly, once

One prompt, explicitly two-performer, explicitly in contact. Then **look at the
file, not at the preview**:

- How many skeletons does the glTF contain? How many root nodes?
- **How many bones?** 22 means one body and the question is settled for ~0.2
  credits. 44, or two skeletons, means C75's structural verdict is wrong and
  the whole ground plan changes.
- If it is one body, WHAT did it do — mime both roles, do one role, or produce
  nonsense? Record it. That answer is worth having written down.

### ARM B — THE ONE THAT IS ACTUALLY LIKELY TO WORK

**Do not ask the generator for two bodies. Ask it for the two HALVES of one
moment, as a matched pair, and align them ourselves.**

The engine already knows where both fighters are standing — that is what
`fight_world_anim_test.gd` does at the real deck height. **We do not need the
generator to place two bodies in a scene; we need two clips that AGREE at the
contact moment.** The alignment is ours.

Generate at least one pair, described from both sides of the same event:

- *"fighter shooting a double-leg takedown, driving forward off the lead leg,
  head to the hip"* / *"fighter defending a double-leg, hips driven back,
  sprawling, weight forward onto the shoulders"*
- and if the first pair reads at all, a HELD one:
  *"fighter holding closed guard from the bottom, legs locked around the
  opponent's waist"* / *"fighter posturing up inside closed guard, hands on the
  opponent's chest"*

Then mount both on the canvas at the distance the engine would place them, and
answer ONE question: **does it read as one exchange?**

## Why arm B is the one that matters

**Contact fidelity is the expected failure mode** — a generated wrist will not
land precisely where the other body is, because neither clip knows the other
exists. That is real and it will show.

**But we do not need frame-accurate grip.** C75 and M19 both already concluded
the ground game is **PRESENTED**: a small set of held poses, camera cuts, the
seat chip, HUD state, silence (G38's read is QUIETER, not busier). **A held
guard position seen through a cut does not need a perfect grip.** Two matched
single-actor poses may be entirely sufficient for the exact thing we need, and
that is a visual judgement somebody has to actually make by looking.

## What to report — and a refusal is a result

`research/R104_PAIRED_MOTION_SPIKE.md`:

1. **The bone/skeleton count from arm A.** A number, not an impression.
2. **Screenshots of arm B**, both halves mounted at engine distance. This is the
   one place in this project where a picture is the deliverable.
3. **Does it read?** Your own visual call, labelled as one. If it does not, say
   so plainly — that CONFIRMS C75 with evidence instead of inference, which is
   worth more than the refusal we have now.
4. **The credit cost, actual.** R94's 0.2/clip is the number to check against.
5. **Whether this changes R103.** If held paired poses read, the ground game
   gets a visual it currently has no plan for at any price. If they do not,
   C75's verdict is confirmed and `TASK_R103.md`'s "ground is presented" line
   stands on measurement.

## Owned files

- `research/R104_PAIRED_MOTION_SPIKE.md`
- `Godot/assets/anim/` — the generated clips, if they are worth keeping.
- `Godot/tools/` — any inspection tool.

**DO NOT TOUCH** `FightRealtime.gd`, `FightMoves.gd`, `judge_panel_test.gd` or
any pinned fight. This is a spike.

## Anchors

- `research/R94_ANIMATION_SPIKE.md` — the 0.2-credit number, the 22-bone
  finding, the track-path rename. **The pipeline that already works.**
- `research/C75_ANIMATION_SOURCES.md` — **§2 and §3 only.** The claim
  being tested.
- `Godot/tests/fight_world_anim_test.gd` — mounts a fighter at the real deck
  height and grafts 22/22 bones. Arm B needs two of these.
- `research/G38` and `M19` — why a PRESENTED ground game is the bar, and
  why "quieter, not busier" is the target.

## The trap

**Do not let one good-looking frame settle it.** A held pose that reads in a
still and falls apart in motion is exactly the kind of thing that gets bought
and then cannot ship. Look at it moving, and at engine distance, not at whatever
distance makes it look best.

And the opposite trap, which is the one this task exists to correct: **do not
report "it did not work" without saying WHAT came back.** The bone count is the
finding whichever way it goes.
