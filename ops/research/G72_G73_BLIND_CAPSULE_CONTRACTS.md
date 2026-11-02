# G72 / G73 — TWO BLIND CONTRACTS, AND BOTH FOUND A DEFECT IN THE CONTRACT

**Agent:** Grok (in-app browser, Expert mode). **Landed by Claude, S54,
2026-09-22.** Tasks: `TASK_G72_FLAT_CAP_CONTRACT.md`,
`TASK_G73_CAPSULE_COVERAGE_CONTRACT.md` (the G73 brief was sent in-session and
is reproduced in the S54 transcript rather than committed separately).

**Both were briefed on a geometric DEFINITION with my implementation
deliberately withheld.** That is the whole method, and it is why each one found
something my own gate could not.

---

## G72 — `CapsuleDistance.gd`

**Deliverable:** `Godot/tests/capsule_distance_contract_test.gd`, 342 lines.
**Result against the real module: `checks=1902 checks_failed=0`, first run.**

### It found a defect in MY contract

> *"Ambiguity (Invariant 2). 'Strictly between the two end planes' is not
> 'nearest point on the barrel.' On-axis, 0.01 below the top cap, the
> projection is between the planes but the flat nearest point is the disk:
> flat = -0.01, dome = -0.14. An identity asserted on every between-planes
> sample is false under the signed-distance definition."*

**It is right.** I wrote the invariant as "between the end planes implies the
two solids agree", which is true only for points OUTSIDE. For a point inside
and near the cap the flat form's nearest surface is the disk. **`s54`'s own
non-vacuity check sampled only an outside point beside the barrel, so it was
structurally incapable of hitting this.** It wrote rows 2a/2b for the real
barrel zone and 2c to pin the clash.

### And its rim rows caught D13

D13's flat-cap rule reads, past the rim, `sqrt(d_axial^2 + d_perp^2) - r` —
which is the distance to a **sphere of radius `r` centred at `p1`**, i.e. the
dome she was replacing. The true form is `sqrt(d_axial^2 + (d_perp - r)^2)`,
the rim circle.

**Proven by mutant.** Patching `CapsuleDistance.flat` to her literal expression
and re-running her test:

```
BAD row 1_flat_axis_up:  expected 0.1      got -0.03999997615814
BAD row 4a_flat_rim:     expected 0.208806 got  0.14284274829944
BAD row 4a_not_sphere:   expected different got 0.14284274829944 vs 0.142843
BAD row 4b_flat_rim:     expected 0.19799  got  0.17304951151877
BAD row 4c_flat_rim:     expected 0.167631 got  0.16413813043449
```

`4a_not_sphere` is a row it wrote **specifically** to assert the answer is not
the sphere-at-`p1` distance. Module restored clean afterwards.

### Its self-objection was upheld by measurement

Asked for the strongest case that the flat cap is the wrong shape:

> *"She is right. A right cylinder with a sharp rim at the Neck bone is not a
> thorax; the shoulder girdle lives outside that barrel... Editing the solid to
> fix a neck-burial metric, then flattening the next bone that still fails the
> metric, is how you eat the body."*

Its proposed single measurement — `max(0, dome(v) - flat(v))` over clavicle and
acromion skin verts — is **the same quantity S54 built independently** as the
orphan count, arrived at with no contact.

---

## G73 — `CapsuleCoverage.gd`

**Deliverable:** `Godot/tests/capsule_coverage_contract_test.gd`, 18.8 KB.
**Skips green today and correctly says so** — the module is S55's to write.

### It found a second contract ambiguity, and refused to invent a rule

> *"Ambiguity — equal depth. `covering` picks greatest `(r - dist_to_segment)`.
> Two non-skipped capsules at the same depth have no named winner and no
> tie-break. Forcing order-stability on a tie invents a rule. Row 5 accepts
> either name and does not require the two array orders to agree. Skipping one
> of a tied pair is unique; that is asserted."*

**That is the correct call.** My contract demanded order-independence for the
DEEPER capsule and said nothing about ties. Writing a test that forced a
specific winner on a tie would have pinned an implementation detail as if it
were the contract.

### AND IT CORRECTED THE NEXT STAGE'S GATE, WHICH IS WORTH MORE THAN THE TEST

Asked to argue against the plan to gate the two-capsule trunk on orphan count:

> *"Orphan count is the wrong gate for the two-capsule trunk. The fat cylinder
> is SUPPOSED to let go of shoulder and inlet verts; those become orphans
> unless a shoulder capsule already owns them. A correct split and a holed
> ribcage move the same integer... One mesh-wide count cannot tell intended
> release from a hole."*

> *"Use per-region hit rate of the intended owner: `|UpperChest verts whose
> covering() is lower_trunk or upper_trunk| / |UpperChest verts|` must stay
> high, and `|Neck verts whose covering() is a chest capsule| / |Neck verts|`
> must fall. Gate the split on those two fractions, not on total orphans."*

**Adopted, and `now` was rewritten to carry it.** The orphan count was the
right gate for the flat cap precisely because that change should have released
nothing; a trunk split is meant to release. It is still reported beside the two
fractions, because it still catches an outright hole.

---

## WHY THIS METHOD KEEPS PAYING

Five blind splits have now landed on this project and **the two most valuable
results were both defects in the CONTRACT rather than in the code** — a false
invariant, and a gate that was about to be carried into a stage it does not fit.
An implementation-facing test cannot find either, because it inherits the
author's framing along with the author's formula.

**So: state what the thing IS, list the invariants including ones that must
FAIL in a named region, decide the degenerate cases explicitly, ask for
ambiguities, and always add "now argue against yourself" pointed at the DECISION
rather than at the code.**
