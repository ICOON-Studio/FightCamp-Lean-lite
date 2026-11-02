# S48 — THE TORSO CAPSULE AND THE PENETRATION TERM

**Session:** S48, 2026-09-22. Two defects S47B separated, both addressed, plus
the audit criterion. **Read the verdict before the detail: one of the two works
cleanly, the other works as designed and does not make the corpus pass.**

## What shipped

1. **The thorax radius is derived from chest DEPTH**, not the isotropic p80
   (`FighterCapsules.gd`, `mode: "depth"`).
2. **The penetration term no longer punishes the hold** — the capsule pairs a
   pose's own contacts and grips put together are scored against their own
   allowance and reported as `held_max` (`FightPoseSolver.gd`, `held_pairs`).
3. **The reachability audit asks a different question** — can a hand reach the
   SPOT a grip names, from a usable direction — not 360° surface exposure
   (`tools/s47_contact_offsets.gd`).

## 1. The thorax — this one is clean

`FighterCapsules` took the radius as the p80 distance from the Chest→Neck
segment to the skin the **Chest bone dominates**, and on a boxer's mesh that
bone owns the deltoids and the lats. The number it returned was a shoulder
**half-breadth** wearing a chest's name.

`tools/s48_thorax_depth.gd` measured it before anything changed:

| rig | segment | p80 isotropic | p80 DEPTH | p80 breadth | ball ratio iso → depth |
|---|---|---|---|---|---|
| f01 @1.78 m | 0.2824 m | 0.1607 | **0.1231** | 0.1502 | 0.569 → **0.436** |
| f02 @1.88 m | 0.3054 m | 0.1909 | **0.1418** | 0.1803 | 0.625 → **0.464** |

Full chest depth 0.2836 m and breadth 0.3607 m on f02 — a real heavyweight.
Perchance rev10's authored chest (0.130 m on a 1.662 m body) scales to 0.1471 m
at f02's stature: **the depth radius is 3.6% under an independent build where
the isotropic p80 was 29.9% over.** The thorax stops being a ball (ratio < 0.5).

**The forward axis is derived from the skeleton, never hard-coded.** Shoulder
line gives LATERAL, the capsule's own segment gives UP, the cross product is
FORWARD. It reads `(0.010, -0.172, -0.985)` on f01 and `(-0.009, -0.172,
-0.985)` on f02 — the same axis off two different rigs, which is the check that
it is derived rather than guessed. A rig with no arm bones falls back and says
so in its `source` string.

**Result on the defect S47 named:** `forearm_r/thorax` at 0.1223 m in a collar
tie. After the depth radius alone (arm 2, no held-pair change) the collar tie's
worst penetration is **0.0820 m** and the worst pair has moved off
`forearm_r/thorax` entirely. **The named defect is gone.**

## 2. The held pairs — works as designed, does not make the corpus pass

`FightPoseSolver.held_pairs(contacts, grips, anatomy)` derives the set from the
pose's own lists: a contact names both capsules outright; a grip names the
gripping capsule and its target, and both are expanded **one hop** through the
capsule set's own `bone_map` adjacency. A grip on `neck` therefore also covers
`head`, `shoulder_span` and `thorax` — the flesh a hand must lie against to get
there — and the gripping `forearm_r` covers `upper_arm_r`, the limb that carries
it. **No hand-written pair list anywhere.**

Those pairs are **scored, not exempted**: they may interpenetrate up to
`allow`, and past that they cost and are reported as `held_max`, gated at the
same `PASS_PEN_M` as everything else. `allow` is the **p80 breadth minus the p80
depth** on the two derived axes — the lateral flesh the depth capsule stopped
claiming, 0.0385 m for f02's thorax and **0.0 for every other capsule**.

> **A correction made mid-session, and it moved the numbers the wrong way on
> purpose.** The first version took `allow = isotropic − depth = 0.0492 m`. The
> isotropic p80 combines both axes and sits ABOVE the breadth alone, so that
> handed the solver 0.011 m of slack the flesh does not account for. It was
> replaced with `breadth − depth = 0.0385 m`, which is stricter and made the
> collar tie's reported penetration WORSE (0.0080 → 0.0233 m). The stricter
> derivation is the right one and it was kept.

### The corpus, three arms, same DOF set and same bounds

Arms 1 and 2 differ only in the contact table. Arms 2 and 3 differ only in
`anatomy`. **Arm 3 is judged on one EXTRA condition** (`held_max <=
PASS_PEN_M`) that arms 1 and 2 cannot fail, so its pass count is not an
apples-to-apples comparison and is not offered as one.

| pose | 1 AUTHORED | 2 DERIVED | 3 +S48 pen | 3 held | worst pair (arm 3) |
|---|---|---|---|---|---|
| collar_tie | 0.0858 | 0.0820 | 0.0233 | 0.0567 | upper_arm_r/pelvis |
| double_collar | 0.0545 | 0.0501 | 0.0506 | 0.0217 | head/upper_arm_l |
| underhook | 0.0391 | 0.0391 | 0.0182 | 0.0253 | femur_r/femur_l |
| over_under | 0.0105 | 0.0010 OK | 0.0058 | 0.0068 | pelvis/femur_r |
| double_leg | 0.0102 | 0.0000 | 0.0000 | 0.0081 | — |
| single_leg | 0.0000 | 0.0072 | 0.0000 | 0.0020 | — |
| sprawl | 0.1001 | 0.1022 | 0.1072 | 0.0894 | pelvis/pelvis |
| front_headlock | 0.0502 | 0.0595 | 0.0548 | 0.0376 | pelvis/thorax |
| side_control | 0.0051 OK | 0.0051 OK | 0.0051 OK | 0.0000 | femur_l/pelvis |
| closed_guard | 0.0063 | 0.0063 | 0.0063 | 0.0001 | forearm_r/upper_arm_r |
| armbar | 0.0003 OK | 0.0003 OK | 0.0003 OK | 0.0000 | pelvis/forearm_r |
| rear_naked | 0.1074 | 0.1074 | 0.1074 | 0.0001 | upper_arm_r/thorax |
| mount | 0.0040 OK | 0.0040 OK | 0.0040 OK | 0.0000 | upper_arm_r/upper_arm_r |

**PASS authored=3/13, derived=4/13, derived+S48=3/13.**

**SAY IT PLAINLY: S48 DOES NOT RAISE THE PASS COUNT.** It removes the defect it
was written for and leaves the corpus failing for reasons that are now
attributable and were not before. That is progress in diagnosis, not in
outcome, and calling it anything else would be the fourth time this project
reported a fixture as a finding.

### What the remaining failures are actually caused by, now that they can be read

- **The PELVIS is the next capsule, and the evidence arrived during this
  session.** With the thorax repaired, the collar tie's worst pair became
  `forearm_r/pelvis` and then `upper_arm_r/pelvis`. The anatomy probe prints
  `B.pelvis r=0.1946 vs penetration 0.0080 -> the capsule is the obstruction`.
  Pelvis ball ratio is **0.824** on f02 and depth would take it to **0.594** —
  still a ball, but far less of one. It was left unchanged on purpose: Q131's
  cascade was measured with the thorax alone moving, and changing two radii in
  one pass would leave neither measured.
- **`rear_naked` is a CORPUS defect, not a solver one.** Its worst pair is
  `upper_arm_r/thorax` at 0.1074 m and the held-set never covers it, because the
  pose declares its hold as a CONTACT `forearm_r/neck` rather than a grip.
  Contacts are deliberately NOT expanded through adjacency — expanding
  `pelvis/pelvis` would exempt `thorax/thorax`, and a closed guard passing at
  4.6 mm with two torsos 0.2208 m inside each other is exactly what the
  all-pairs term exists to catch (S46). The fix is that pose's contact list.
- **`sprawl` worsened** (0.1022 → 0.1072) on `pelvis/pelvis`, and
  `double_collar` barely moved. Neither is a hold pair.

## 3. The audit criterion, and a flaw it shared with C158's blind test

The old audit asked whether a hand could touch a target **from anywhere on its
full surface** and reported `neck` 0.0%. S47B killed that criterion: Perchance's
own working rig reads 0.0% too. So the audit now takes the **(capsule, blend)
pairs the corpus itself names**, puts a hand tangent to that one spot, sweeps
**128 directions** on a Fibonacci lattice, and prints usable/128 plus the **mean
elevation of the usable set** — because an over-the-shoulder approach is what
says the measurement is the right one.

**C158 (Codex, blind, landed `0d0c3cb9`) chose 128 directions and the same
criterion independently.** Two agents, no contact, same instrument.

**AND THEY DISAGREED ON THE ANSWER, WHICH TURNED OUT TO BE A SHARED BUG.** This
audit named `thorax` as the neck's blocker; C158 named `head`. Both loops
`break` on the FIRST capsule that blocks, so the reported blocker depended on
iteration order rather than on geometry. Fixed here — score every capsule, keep
the deepest — and the real answer is **both**:

```
neck 0.15   0/128   every blocker, by deepest: head 39/0.169m, thorax 89/0.181m
neck 0.50   0/128   every blocker, by deepest: head 54/0.173m, thorax 74/0.184m
```

**The neck is inside BOTH its neighbours' end caps**, and narrowing the thorax
to 0.1418 did not change that: the thorax's top cap still reaches 0.1418 m above
the Neck bone against a neck only 0.0774 m long. This is the junction-cap
geometry `FighterCapsules`' own header has described since S43 — joint-to-joint
segments and non-overlapping caps cannot both be had.

Measured directly (`head` capsule, f01): the head's lower cap reaches **0.0724 m
below the Neck bone**, and `neck/head` surface gap is **−0.1830 m**. The module
header claims the blob fix made the head "cover the skull instead of reaching
down into the chest"; it does not. **That claim is false and it is now measured.**

Everything else the corpus grips reads healthy: `thorax` 26/128 at +8.7° mean
elevation, `pelvis` 64/128, `femur_r` 68/128, `forearm_r` 72–88/128.

## The eighth red, named

`tests/fighter_reachability_contract_test.gd` — **checks=24 failures=8**, all
eight being the two neck spots on the two rigs. It is Codex's C158, landed on
master this session, and it is **RED ON PURPOSE AND CORRECTLY**: a grip target
that no hand can approach is a real finding. It was NOT edited to make it pass.

## What S49 should do, in order, with the measurement already in hand

1. **The pelvis, by depth**, exactly as the thorax was done — 0.1946 → ~0.1402 on
   f02, ball ratio 0.824 → 0.594. Run the same three arms and compare against
   this digest's table. It is the named worst pair on the repaired collar tie.
2. **The head blob's lower cap.** It reaches 0.0724 m below the Neck bone and
   buries the neck as thoroughly as the thorax does. A blob whose `p0` is the
   Head bone and whose radius is 0.128 m cannot avoid it; the endpoint or the
   mode has to change. **Dola's D7 is the lead here** — her nine-limb rig reads
   the neck **92.7% exposed**, and her diagnosis is that the difference is
   **endpoint stacking, not radius**. That is a third road neither S47 nor S47B
   had, and it is the one road left.
3. **`rear_naked`'s contact list** — declare the hold as a grip so the held-pair
   derivation can see it, or accept 0.1074 m as authored.

## Files

- `Godot/scripts/FighterCapsules.gd` — `mode: "depth"`, `_forward_axis`,
  `_segment_offset`, `anatomy()`, `allow` in `build_report`.
- `Godot/scripts/FightPoseSolver.gd` — `held_pairs()`, `held_max`/`held_pair`/
  `held_scored`/`held_declared`, `anatomy` threaded through
  `evaluate`/`descend`/`refine`, `held_max` in the pass gate.
- `Godot/tools/s47_contact_offsets.gd` — directional criterion, three arms,
  deepest-blocker attribution, anatomy wired into the solve.
- `Godot/tools/s48_thorax_depth.gd` — NEW, the before-measurement.

## Gate, read off real runs

- Parse gate: 4 files, `CHECK total=4 fails=0`.
- `tests/fighter_capsules_contract_test.gd` **checks=246 failures=0**, no `ERROR:`.
- `tests/fight_pose_solver_test.gd` **checks=30 failures=0**.
- `Tools/s42_mutants.py` **total=8 red=8 missed=0**, unmutated control green.
- `Tools/s43_mutants.py` **red=4 missed=0 pattern_miss=0**.
- `run_tests.py --only capsule` **total=2 fails=0**.

---

# ADDENDUM — THE PELVIS WAS TRIED AND THE MEASUREMENT REFUSED IT

Written the same session, after the operator's instruction to keep working on
the contact solver. **This is the S49 item 1 this digest recommended, executed
and rejected on its own evidence.**

## Why it looked right

Every line pointed at the pelvis:

- Ball ratio **0.824** on f02 — the worst capsule on the rig, worse than the
  thorax ever was at 0.625.
- With the thorax repaired, the collar tie's worst pair became
  `forearm_r/pelvis` and then `upper_arm_r/pelvis`.
- S48's own anatomy probe printed `B.pelvis r=0.1946 vs penetration 0.0080 ->
  the capsule is the obstruction`.
- Depth would take it to 0.1402 m and a ball ratio of 0.594.

## What happened

`mode: "depth"` on `pelvis`, same three arms, same corpus, same bounds:

| pose | S48 (thorax only) | + pelvis depth | |
|---|---|---|---|
| collar_tie | 0.0233 | 0.0202 | better |
| double_collar | 0.0506 | 0.0330 | better |
| underhook | 0.0182 | **0.0585** | worse |
| over_under | 0.0058 | **0.0359** | worse |
| double_leg | 0.0000 | **0.0654** | worse |
| single_leg | 0.0000 | **0.0828** | worse |
| closed_guard | 0.0063 | **0.0397** | worse, lost its near-pass |
| side_control | 0.0051 **OK** | 0.0074 | **lost a pass** |
| mount | 0.0040 **OK** | 0.0722 | **lost a pass** |

**PASS 3/13 → 1/13.** Only `armbar` survived.

And the new worst pairs are almost all LEGS: `femur_r/femur_l`,
`femur_r/femur_r`, `femur_r/shin_r`, `head/femur_r`.

## What it means, and it is not a dead end

**THIS IS Q131'S CASCADE, REPRODUCED IN THE POSE CORPUS.** Q131 measured it in
the live room: narrow the torso and `leg=leg` goes from 7 frames to 44, because
the bodies can finally get close enough for the legs to meet. S48 carried that
warning forward as an allowance to write; what it did NOT predict is that the
same mechanism fires in the static pose corpus, on a different capsule, from a
second narrowing.

So the reading is not "the pelvis is fine". It is:

**THE TORSO AND THE LEGS ARE ONE FIX AND THEY CANNOT BE SHIPPED SEPARATELY.**
Each narrowing of the trunk buys a closer, more correct embrace and spends it
on a leg collision the corpus's stances were never authored to survive. The
thorax change got away with it because 0.1909 → 0.1418 is a smaller step than
0.1946 → 0.1402 on a capsule whose own neighbours are the femurs.

## What S49 should do instead

1. **The legs first, then the pelvis.** Either the femur/shin capsules are
   over-wide the same way the thorax was — `femur` is 0.119/0.118 on f01 and
   nobody has run the depth question on a limb — or the corpus's authored
   stances put the two men's legs where no capsule set can separate them. Those
   are different fixes and one measurement tells them apart: run the depth
   probe on `femur_l`/`femur_r` and read the ball ratio and the breadth-minus-
   depth allowance, exactly as `tools/s48_thorax_depth.gd` does for the trunk.
2. **Then re-run this pelvis arm.** It is a three-line change and the table
   above is its control. Do not re-derive the diagnosis; re-run the arm.
3. **Do NOT ship the pelvis change on the grounds that it exposes the next
   defect.** It does, and that is interesting, and it also takes the corpus
   from 3/13 to 1/13. A change that makes the measured thing worse does not
   ship because its failure is informative.
