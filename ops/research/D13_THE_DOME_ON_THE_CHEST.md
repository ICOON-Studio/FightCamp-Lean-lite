# D13 — "IT IS A BARREL, NOT A RIB CAGE": THE FLAT CAP, AND STOP ASSERTING ON THE NECK

**Agent:** Dola (Cici desktop app, driven from this console by `Tools/cici/cici.py`).
**Landed by Claude, S53, 2026-09-22.** Raw capture:
`research/_captures/D13_DOLA_raw.txt` (292 KB — **a raw transcript, not a
curated deliverable**). **Task:** `TASK_D13_THE_DOME_ON_THE_CHEST.md`.
**Her HTML demo has NOT been run here.** Every number below that comes from it is
labelled as hers and is **unverified on our rigs** — see THE ONE THING STILL
OWED at the bottom.

## THE ONE SENTENCE

> *"The thorax is a tapered, truncated enclosure; a constant-radius capsule with
> hemispherical endcaps is a **barrel, not a rib cage**. Your dome reaches 0.14 m
> upward — that is the entire neck length — because the cap is mathematically
> forced to bulge outward from the endpoint."*

And the answer to the question behind the question:

> *"**Ship trunk anchors as primary. Demote neck to advisory.** If we cannot make
> it work on three rigs, it is not the code — it is the premise."*

---

## Q1 — THREE SHAPES, ORDERED BY WHAT THEY COST US

| option | shape | definition | solver cost | scales? |
|---|---|---|---|---|
| **A — flat-capped capsule** | cylinder + planar end, no hemisphere | same `p0, p1, r`; the cap is a **disk perpendicular to the axis** at each end | **ZERO** — the distance function changes, the data does not | yes, through `p0→p1` and `r` |
| **B — truncated bi-capsule** | two stacked segments, lower broad, upper narrow | `p_base→p_mid, r_large` then `p_mid→p_top, r_small` | one extra capsule; distance unchanged | anchored at anatomical landmarks |
| **C — conical hull** | tapered, `r0` at `p0` and `r1` at `p1` | a **new field** `r1` per capsule | moderate — the solver must branch on type | direct; `r1` matches anthropometry |

**Her recommendation is A, and the reason is diagnostic rather than aesthetic:**
*"It costs nothing to your data schema, isolates the dome problem exactly, and
tells you whether the neck was ever blocked by chest **geometry** or only by the
**math of the hemispherical cap**. If it still fails, move to B — that is the rib
cage shape."*

---

## Q2 — THE FLAT CAP, AS ARITHMETIC, WITH NO BONE MOVED

She answered the constraint head on: **no bone position changes, no field is
added, nothing new is stored.** `p0` (Chest) and `p1` (Neck) stay exactly where
they are. Only the distance function changes.

Today's hemispherical cap sweeps a full half-ball at `t = L`, so **any point
within `r` of `p1` is inside the thorax — which is the entire neck segment.**

Her replacement, with `u = unit(p1 - p0)`:

```
d_perp = |(q - p1) - u * (u . (q - p1))|     # radial offset at the top
d_axial = max(0, (q - p1) . u)               # axial distance above the top

if d_perp <= r:
    signed_distance = min(cylinder_dist, d_axial)
else:
    signed_distance = min(cylinder_dist, sqrt(d_axial^2 + d_perp^2) - r)
```

**What changed and what did not, in her own accounting:** bone positions
unchanged; stored fields `name, p0, p1, r` unchanged; new quantity **none**,
derived entirely from what exists; `u`, `L` and `r` all scale with stature by
construction. *"The top boundary is a **disk at the Neck bone**, not a dome
through it."*

**HER DEMO'S CLAIM, WHICH IS HERS AND IS NOT YET OURS:** dome mode reproduces our
0.0% neck exposure with every upper approach blocked; flat-cap mode, *"same
bones, same r, same L — only distance function changes"*, reads the neck **fully
clear at 100% upper exposure**. She also swept `thorax_r` from 0.14 → 0.08 →
0.04 m and noted that shrinking the chest exposes the neck gradually — **and
refused it**: *"shrinking the chest to save the neck is not a solution, it is a
different body."*

---

## Q3 — WHAT STOPS BEING COVERED, AND HER ARGUMENT THAT IT DOES NOT MATTER

| region | before (dome) | after (flat cap) |
|---|---|---|
| directly above the chest, at the neck base | fully covered — the dome fills neck space | **open** |
| upper chest / clavicle line | the dome covers the inward shoulder slope | an **exposed band** from the disk edge outward |
| side and lower chest | cylinder body | unchanged |
| front / back centre | rounds smoothly to the neck | a **sharp disk edge** at the top |

Her case that this is acceptable: a strike along the neck axis into the centre
upper chest now passes through — but *"that is the **root of the neck**, not
protective chest volume. Real human anatomy has a depression there — the
suprasternal notch — not a solid hemisphere."* If coverage is wanted there, she
says add **a small dedicated sphere at the notch**, not a dome the length of the
whole neck. Body locks grip the cylinder body and are unaffected; the change
touches *"only the ~2–3 cm band at the very top rim."*

> *"We gave up **fake** coverage — geometry that never matched anatomy — to
> recover **real** reachability. If dome coverage was protecting a gameplay
> mechanic, that mechanic was defending a spot that does not exist on humans."*

---

## Q4 — AND THIS IS THE PART THAT DECIDES THE NEXT STAGE

**"Honest answer: probably not — not as a primary grip target."** Three
independent implementations now say a neck cannot be gripped on a capsule
humanoid: ours, hers before her fix, and a shipping third-party rig.

Her replacement, which is **J42's and G70's answer arrived at a third time,
independently**:

| grip target | what it actually is |
|---|---|
| `trunk_upper` | chest top disk / clavicle arch — stable, large, reachable |
| `trunk_mid` | sternum / pectoral span |
| `trunk_lower` | abdomen / lower rib cage |
| `head_base` | occipital / skull rear — **NOT the neck cylinder** |
| `jawline` | mandible anchor — side and front control |

Her five reasons, compressed: every anchor survives an `r/L` check because they
are **surfaces and landmarks, not short segments**; the question becomes one a
human can answer (*"can I reach the upper chest rim?"* rather than *"can I grip a
6 cm cylinder buried inside it?"*); anchors scale by proportion rather than by
segment length; a blocked anchor has a **visible** cause — you see the shoulder
in the way instead of debugging a hidden ratio; and *"grappling does not grip
neck cylinders; it cups the jaw, presses the forearm under the chin, or locks
against the upper chest."*

**And what to do with the neck metric, which is the operationally useful half:**

> *"Leave the Present Ratio instrument running on the neck. If it reads > 0%,
> show it — that rig has an exceptionally slender neck. If it reads 0%, **do not
> flag it** — that is normal human anatomy. The metric tells you when a rig is
> **anomalous**, not when it is broken."*

---

## HER SELF-OBJECTION, WHICH IS AGAIN THE BEST PART

> *"**Flat caps fail the shoulder girdle.** The dome was not just obstruction —
> it was the anatomical transition between chest and clavicle. Flattening it
> exposes the neck but creates a sharp rim where the collarbone should smoothly
> follow. Grazing the shoulder will now 'catch' instead of sliding. We traded
> one problem for another."*

> *"**Worse — we are editing the body to please the metric.** When the shoulder
> blocks the clavicle, will we flatten the shoulder too? Every obstruction
> becomes geometry we trim until the number passes. The result is not a human —
> it is a simplified model optimised for reachability, not anatomy or
> protection."*

> *"The neck is short because it is a **transition, not a feature**. It will
> always be obscured from most directions. Rescuing it requires altering
> everything around it — or admitting: grip the trunk, not the neck segment."*

**Take that at face value, exactly as D12's self-objection was taken.** It is the
same warning that made the elevation band an instrument rather than a gate, and
it lands squarely on the flat cap she just recommended. Her Q1 answer and her
self-objection together say: **do A as a DIAGNOSTIC to learn whether the cap or
the geometry is the blocker, and do not ship it as the fix until the shoulder
rim is measured.**

---

## WHAT THIS AGREES WITH, AND WHY THAT MATTERS

Four agents have now arrived at "one trunk volume with named anchors" from four
directions with no contact between them:

- **J42** (anthropometry, blind): *"keep one neck volume with named grip
  anchors"* — and the head as a sphere, which we shipped today.
- **G70** (design, blind): one neck volume plus four named anchors with approach
  cones, with its own refusal rule saying *"do not shorten neighbours"*.
- **D13** (geometry, today): the table above.
- **S53's own measurement** (this session): the neck is 0.0% before and after
  the head sphere, banded or unbanded, on both rigs — a metric false on every
  humanoid we have measured.

---

## THE ONE THING STILL OWED

**Her HTML has not been run here.** The 100% upper-exposure figure for flat-cap
mode is **hers**, from her own demo, on her own parameters. The standing rule on
this project is that her v4 passed every threshold with bodies that could not
bend, and a later fix gave every limb a single rotation about Y — which moves
`head`, `neck` and `torso` by exactly 0.00000 m, measured.

**So the flat cap is implemented and measured on OUR rigs with
`tools/s53_ball_capsules.gd` before any of it is believed, and that is the next
stage's first job.** It is cheap: the rule above is a change to one distance
function, no data change, and the instrument to judge it already exists.
