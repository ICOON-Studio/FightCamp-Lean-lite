# D14 — THE RIM, RETRACTED IN PART; AND THE FIVE ANCHORS AS ARITHMETIC

**Agent:** Dola (Cici desktop app, driven from this console by `Tools/cici/cici.py`).
**Landed by Claude, S54, 2026-09-22.** Raw capture:
`research/_captures/D14_DOLA_raw.txt` (309 KB — **a raw transcript, not a
curated deliverable**). **Task:** `TASK_D14_THE_SHOULDER_RIM.md`.
**No HTML demo was asked for and none was run**, so nothing below is a measured
figure unless this file says Claude measured it.

## WHY SHE WAS ASKED

D13's self-objection was the best thing in it and it landed on her own
recommendation: *"flat caps fail the shoulder girdle... grazing the shoulder
will now CATCH instead of sliding"*, and harder, *"we are editing the body to
please the metric."* She was right to say it, so she was given it back.

---

## Q1 — SHE PARTLY RETRACTED IT, UNPROMPTED, AND THE RETRACTION IS THE FINDING

She confirmed the mechanism is the **gradient discontinuity** at the rim: the
direction to the nearest surface flips as you cross the rim circle, so *"a hand
sweeping forward-and-down across the shoulder will catch and track the rim
instead of curving smoothly inward toward the neck base. The motion 'sticks' to
the circle."*

Her one number is `rim_fraction` — the fraction of solved contact points whose
nearest-surface distance sits within ±2% of the radius edge. Dome baseline ~0%;
flat cap on a grazing motion she estimates **15–35%**; *"if it stays below ~5%:
the discontinuity is harmless — leave it."*

**Then the retraction, verbatim:**

> *"**Honest retraction:** If your solver is signed-distance and only ever needs
> sign + rough magnitude (no precise gradient for friction or stable stacking),
> the rim does not matter. The field is still continuous; penetration depth
> converges. The 'catch' is a feel issue, not a correctness issue."*

**THAT CONDITION IS TRUE OF OUR SOLVER.** `FightPoseSolver` descends on
penetration depth and needs sign and rough magnitude; it has no friction model
and does no stable stacking. **So by her own test the rim is not a correctness
problem here** — which is why S54 did not build `rim_fraction` and measured
coverage instead.

## Q2 — THE RIM TREATMENTS, RANKED, WITH HER PICK

| option | what it does | cost | smooth? | her verdict |
|---|---|---|---|---|
| **a — leave it** | accept the rim | **zero** | C0 only | *"start here; measure `rim_fraction` first"* |
| **b — torus fillet** | blend disk into cylinder with a torus of radius `f = 0.08 * r` | low, one extra branch | C1 everywhere | **her pick** |
| **c — notch sphere** | a small sphere at `p1`, `r_s = 0.2 * r` | low | C1 at the join | *"puts a bump right where the neck opens"* |
| **d — tapered cone** | `r_top < r_base` | moderate, **needs a new field** | C1 | *"do not do"* |

Her fillet rule, which keeps the no-new-field constraint — `f = 0.08 * r`, so it
scales by construction:

```
above  = (q - p1) . u
d_perp = |(q - p1) - above * u|
if above > 0 and d_perp > (r - f):
    x = d_perp - (r - f)
    d_fillet = sqrt(x*x + above*above) - f       # torus: major r-f, minor f
    d = min(cyl, d_fillet)
elif above > 0:
    d = min(cyl, above)                          # the flat disk
else:
    d = cyl
```

**NOT BUILT, AND DELIBERATELY.** S54 measured that the flat cap's cost is
**coverage, not catching** — 155 and 162 orphaned upper-chest vertices on the
two rigs — so a fillet would smooth an edge on a shape we are not shipping. The
rule is recorded here for the day the trunk shape is right and the rim is the
last thing wrong with it.

## Q3 — THE FIVE ANCHORS, AS ARITHMETIC, NO NEW FIELD

| anchor | derivation | lives on | approach | scales by |
|---|---|---|---|---|
| `trunk_upper` | `Neck` | thorax top cap | elevation >= -30 deg, forward azimuth | follows `Neck` |
| `trunk_mid` | `lerp(Chest, Neck, 0.5)` | thorax mid | forward hemisphere | relative |
| `trunk_lower` | `lerp(Chest, Neck, 0.25)` | thorax lower | broad forward | relative |
| `head_base` | `Head - 0.15 * r_head * back` | head sphere rear | from behind and above | proportional to `r` |
| `jawline` | `Head + 0.60 * r_head * side - 0.25 * r_head * up` | head sphere rim | within 45 deg of pure side | proportional to `r` |

with `up = unit(Head - Neck)`, `right = unit(LeftUpperArm - RightUpperArm)`,
`back = normalize(cross(up, right))` and
`forward = unit((LeftUpperArm + RightUpperArm)/2 - Chest)`.

**`head_base` is derived in the head's own frame rather than from a bone**,
which is what the S53 sphere promotion forced — "skull rear" is no longer a
bone position once the head is a sphere at its vertex centroid.

**ONE THING TO CHECK BEFORE BUILDING THESE.** `trunk_upper` is `Neck` exactly —
the same point S54 measured `shoulder_span` against and found **0.0% exposed
under both caps**. So `trunk_upper` as written may be as unreachable as the neck
was. That is a measurement for the stage that builds them, not an objection to
the scheme.

## HER SELF-OBJECTION, AND THE REFUSAL RULE THAT CAME OUT OF IT

She put the hardest case against her own Q3: *"You couldn't make the neck pass,
so you invented five new things to measure instead. When a sixth anchor fails,
will you invent a seventh?"*

Her answer is the distinction worth keeping:

> *"Flat cap changes the model to match the measurement — that is what we
> objected to. Anchors change the measurement to match the model — that is
> correction."*

And the rule to refuse a bad sixth anchor:

> *"Reject any anchor defined as 'the part of X that is reachable.' Accept only
> anchors defined as 'Y anatomical landmark, measure reachability to it.'
> Reachability is the answer, not the definition."*

**That rule is adopted.** It is the cheapest guard yet written against the
failure mode four documents have now circled, and it is testable on a proposal
rather than on a result.
