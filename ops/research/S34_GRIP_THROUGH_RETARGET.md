# S34 — Does the grip survive the retarget? **Mostly yes: 1.3–2.3 cm of drift.**

> **READ THE CORRECTION AT THE BOTTOM OF THIS FILE FIRST.** Everything between
> here and it was written with a unit bug in the probe and reported +139.7%
> drift. **That number is WITHDRAWN.** The real figure is +8.8% at the minimum
> and +12.6% at p10. The section below is kept verbatim because how a wrong
> measurement survived its own control arm is the more useful lesson, and
> deleting it would hide that.

**Claude, 2026-09-21.** The experiment nobody had run: put a known-good paired
capture through our own retarget and measure whether the contact holds.

## THE ANSWER IN ONE TABLE

`18/19_05`, CMU's *"A pulls B by the elbow; B resists"* — 438 frames at 120 Hz,
two different ASF skeletons captured together in one world space. Retargeted
onto **two different fighters** (f05 light, f06 light-heavy) by
`FightClipRetarget`, sampled at the capture's native 120 Hz.

| | min | p10 | p50 | p90 | max |
|---|---:|---:|---:|---:|---:|
| **SOURCE** `A_hand→B_elbow` | 0.141 | 0.174 | 0.244 | 1.166 | 1.432 |
| **RETARGET** `A_hand→B_elbow` | 0.339 | 0.353 | 0.389 | 1.224 | 1.492 |
| **drift** | **+139.7%** | **+102.1%** | **+59.4%** | +5.0% | +4.2% |

**A hand that was touching an elbow at 0.141 m ends up 0.339 m away — 20 cm of
air.** The grip is gone.

## THE SHAPE OF THE ERROR IS THE FINDING, NOT JUST ITS SIZE

**Drift is 140% where the hands are closest and 4% where they are farthest.**
That is not a scale error and it is not noise — a uniform mis-scaling would move
every percentile by the same proportion. Contact specifically is what breaks.

And the placement is innocent:

| | min | p50 | max |
|---|---:|---:|---:|
| SOURCE `root→root` | 0.766 | 0.994 | 1.712 |
| RETARGET `root→root` | 0.781 | 1.013 | 1.734 |
| drift | +2.0% | +1.9% | +1.3% |

**The two bodies are put in the right places to within 2 cm. The error is
entirely in the arm chain.** That is the control arm this measurement needed,
and it isolates the defect precisely: not the mount, not the pair separation,
not the world transform — the limbs.

**THIS IS EXACTLY WHAT ROTATION-ONLY RETARGETING PREDICTS.** Identical shoulder
and elbow angles put the hand somewhere else when the arm is a different length.
Far poses barely care; contact cares completely. R141 said punches do not land
where they were captured, and this is the same defect measured against a fixture
where the correct answer is known.

## THE FIXTURE, AND WHY ITS LEFT-HAND COLUMN CAN BE TRUSTED

The source column is not asserted, it is **confirmed by two independently
written readers**. `Tools/cmu_asf_amc.py` (Claude) and `Tools/cmu_source_probe.py`
(Codex, C149, written blind from the format spec) disagreed at first; the
collision was settled in the data and exposed three FK bugs in the blind reader.
After the fixes the two agree to **0.000021203 m** — 21 micrometres, float
rounding from a different multiplication order — across all 438 frames and every
joint. See the correction section of `C149_CMU_SOURCE.md`.

**NEVER TEST IDENTICAL FIGHTERS, AND IT BINDS THE RETARGET TOO.** Subject 18 and
subject 19 are two different bodies, so they go onto two different fighters. Had
both gone onto one mesh the measurement would have flattered the retarget, since
two identical rigs drift identically and their relative distance would partly
cancel.

## ONE DISCREPANCY, STATED RATHER THAN SMOOTHED

The Python readers report `A_hand→B_elbow` at min **0.130** / p50 **0.203**; the
Godot probe reports min **0.141** / p50 **0.244** for the same capture. **They
are measuring different bones and both are right.** Python uses CMU's `lhand`;
the Godot probe uses `lwrist`, because `lwrist` is the bone our rig's `LeftHand`
is mapped from — so `lwrist` is the correct control for the retargeted column.
Sampling is not the explanation: 30 Hz and 120 Hz give the same figures to a
millimetre.

## THE PIPELINE THIS BUILT, WHICH IS REUSABLE

ASF/AMC is not something Godot can see, so:

1. `Tools/cmu_asf_amc.py` — ASF/AMC reader, forward kinematics, world joints in
   metres.
2. `Tools/cmu_to_bvh.py` — ASF/AMC → BVH. **The conversion every converter gets
   wrong**: ASF puts a bone's rotation on the BONE, BVH puts it on the JOINT. A
   BVH node sits at the PROXIMAL end of its bone, so `offset = direction_parent ×
   length_parent` and `local = M_parentᵀ @ M_bone`. Expressed against the shared
   parent, two children of one joint keep independent rotations — no dummy joints.
3. Blender 5.2 headless — BVH in, GLB out.
4. `Godot/tools/probe_cmu_grip.gd` — imports both, runs the REAL
   `FightClipRetarget.retarget_clip`, composes world positions and reports both
   columns with drift.

Four GLBs now live in `Godot/assets/anim/audition/cmu_paired/`: the two motions
and the two rest poses the corrections are built from.

**TWO TRAPS WORTH KEEPING.** `FightClipRetarget.is_cascadeur_clip()` returns
true for ANY `.glb`, so `name_map_for()` would hand a CMU clip the Cascadeur
bone map — the probe passes an explicit `CMU_TO_OURS` instead. And
`Skeleton3D.get_bone_global_pose()` returns the REST pose in an
`_initialize`-stepped run, so both columns are composed from transforms directly
rather than read off a live skeleton.

## WHAT THIS SETTLES FOR S35

S35 was already written as "bake end-effector positions into the retarget instead
of composing rotations alone". **It now has its number and its acceptance test.**
The fixture is free, licence-clear, frame-synced, and the correct answer is
known to 21 µm. Any anchor mechanism can be judged by re-running

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot \
  --script tools/probe_cmu_grip.gd -- fps=120
```

and asking whether the min/p10 drift comes down from +140% / +102%. **Gate it as
a ceiling, never an exact figure** — and note that p90/max are already at 4-5%,
so a mechanism that improves those while leaving the minimum alone has fixed
nothing that was broken.

---

# CORRECTION — same day, and it overturns the headline

**Claude, 2026-09-21, a few hours after the above was written. The +139.7%
figure is WRONG. It was an artefact of this probe, not a property of the
retarget.** The corrected measurement:

| | min | p10 | p50 | p90 | max |
|---|---:|---:|---:|---:|---:|
| **SOURCE** `A_hand→B_elbow` | 0.141 | 0.174 | 0.244 | 1.166 | 1.432 |
| **RETARGET** (scale-correct) | 0.154 | 0.197 | 0.260 | 1.148 | 1.423 |
| **drift** | **+8.8%** | **+12.6%** | **+6.6%** | **−1.5%** | **−0.6%** |

**The grip largely DOES survive the retarget.** The error at contact is about
**1.3–2.3 cm on a 14–20 cm grip**, not 20 cm of air.

## WHAT WAS WRONG: THE RIGS ARE NOT IN METRES

`f05` and `f06` are Tripo meshes, each exported at whatever scale Tripo
produced. **`f05`'s mesh is 1.850 tall and `f06`'s is 1.000.** The room never
renders them raw — `FighterPhysique.height_scale()` puts a uniform scale on the
fighter node so the mesh stands at the athlete's real height: **0.963 for f05
and 1.890 for f06.**

This probe skipped that entirely. It composed rig-local bone offsets and added
them straight onto a world origin in metres, so **f06 was measured at roughly
half its rendered size** while f05 was near enough right. The "drift" was
overwhelmingly one fighter being half-scale.

**IT IS THE MISTAKE THE TREE ALREADY WARNS ABOUT.** `FightBodyCapsules.gd:148`:
*"SKELETON-LOCAL TO METRES IS THE `scale` FACTOR AND IT IS NOT OPTIONAL — S4 (4)
lost a pass to a tripwire that compared world-metre positions against a floor
still in mesh units."* Same error, a second time, in a new instrument.

**A SECOND, SMALLER PLACEMENT BUG was fixed on the way** and is worth keeping:
the rig was hung with its hips a rest-height ABOVE the captured pelvis, because
the source root was used as the rig-local origin directly. Aligning the rig's
Hips to the capture's root makes `root→root` land on the source **exactly**
(0.766 / 0.994 / 1.712 against 0.766 / 0.994 / 1.712), which is now the
instrument's own zero-error check — and it is what should have been demanded of
the first version.

## WHAT THE CONTROL ARM SHOULD HAVE CAUGHT, AND WHY IT DID NOT

The first run reported `root→root` drifting +1.9% and I read that as "placement
is fine, so the error is in the arms". **It was the opposite of exculpatory.**
Hips-to-hips is a DIFFERENCE between two bodies, so a common-mode scale error
partly cancels in it while showing up at full size in every limb. A control arm
that shares the bug it is meant to exonerate proves nothing. The test that
actually bites is an ABSOLUTE one against a known quantity — a rig's head should
be about 1.7 m off the floor, and f06's was not.

## WHAT STANDS

- The **pipeline** — `cmu_asf_amc.py`, `cmu_to_bvh.py`, Blender, the probe and
  the recorder — is real and reusable; only the probe's unit handling was wrong.
- The **source column** is untouched by this: it never passed through a rig.
  Two independent readers still agree to 21 µm.
- **Both blind-split findings stand.** C149's three FK bugs and G60T's two test
  bugs were each settled against evidence outside the thing under test.
- `FightAnchorIK` and its blind test are correct and landed.

## WHAT THIS DOES TO S35

**The anchor bake does NOT earn its place on this evidence.** Run with
`anchor=1` against the corrected baseline it moves the contact drift from +8.8%
to +8.8% and from +12.6% to +12.6% — no measurable improvement, because the
residual is not where the anchor reaches. The hands are anchored to their own
captured wrists; the remaining error is in the un-anchored elbow and in the
shoulder chain above it.

**So S35 as written is not justified yet.** A 1.3–2.3 cm contact error is worth
closing eventually, but it is nowhere near the most visible defect in the game,
and building an anchor pipeline for it would be answering a question the
measurement no longer asks. `FightAnchorBake.gd` stays in the tree, correct and
unused, until something needs it.

**THE HONEST NEXT QUESTION IS WHERE THE VISIBLE DEFECT ACTUALLY IS.** The
operator's own words on watching the room were *"the corpses clip inside each
other"* — and `probe_body_overlap` measures **341 of 900 frames penetrating
(37.9%), worst 0.287 m, worst pair `arm>torso`** on unchanged master. That is a
28 cm interpenetration on screen against a 2 cm grip error nobody can see.
U119 is the stage that matters.
