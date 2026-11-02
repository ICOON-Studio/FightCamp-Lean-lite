# SKILLS IN 3D — DOLA'S EVALUATION

**Agent:** Dola (Cici, driven by `Tools/cici/cici.py`). **Landed by Claude,
S48, 2026-09-22.** First of four answering `TASK_SKILLS_IN_3D.md` blind of each
other; Codex has it, Cursor and Qwen get it when U130 and Q134 land.

**CORRECTION, SAME SESSION.** The first version of this file was written from
a TRUNCATED capture and presented itself as complete. `cici.py send --wait`
returns the chat pane's visible TAIL - the raw file even says `--- tail ---` on
its second line and begins mid-answer at section 2.2 - and that was not read.
**Her lead line and her answers to PART 1 (archetypes) and 2.1 (bridging the
solver) were missing entirely, and they are the two most useful things she
said.** Recovered with `cici.py read --out`, which captures the whole
transcript. Both are restored below and the closing note with them.

**The lesson, and it is one already on the record:** open the output before
trusting it. A capture labelled `tail` is a tail.

---

## HER LEAD - "the one thing you would change first"

> **"Add the archetype field. It is the single highest-leverage correction to
> the whole system.** Everything else - clip binding, motion consistency, 3D
> integration - flows from fixing the disconnect between what a technique is
> and what motion it needs. **The name-based bridge is fundamentally broken;
> archetypes replace it with an explicit, maintainable mapping."**

## PART 1 - ARCHETYPES: "THE APPROACH IS CORRECT"

> Grok's 120 archetypes is the critical number: **motion variety is much
> smaller than technique variety.** Many techniques differ in damage, tier,
> discipline or ruleset but are visually identical.

**THE COST, which the brief demanded she price honestly:**

> **"Authoring 534 archetype fields: 1-2 HOURS if done systematically, not
> days.** Most map to the same 120 values. Batch assignment: *all jab variants
> -> archetype_jab; all straight punches -> archetype_straight_punch*. **The
> work is grouping, not typing."**

**The real tradeoff she names:** loss of fine-grained motion control. *"If two
techniques share an archetype but should look subtly different, you no longer
have per-id clips to express that."* And existing per-technique-id retarget or
provenance overrides would move to archetype level, so one-off refinements are
lost unless an override layer is kept.

**Two alternatives she weighed:** `motion_tags: ["punch","rear","straight"]` -
same grouping power on multiple axes, more flexible and more complex; or a dual
index, archetype as the primary binding plus an optional `motion_override` for
the few that genuinely differ.

> **Verdict: go with archetypes + optional override. "120 bindings is a
> threshold of maintainability; above that, decay is structural."**

## 2.1 - BRIDGING THE SOLVER TO A MOVING FIGHT

> **The right approach: solve at state transitions, then blend. Do not solve
> every frame** - too slow, and you do not want the jitter. **Do not freeze** -
> looks dead.

| Approach | Pros | Cons |
|---|---|---|
| Solve on entry to hold/transition | Clean, one cost per change; guarantees a valid starting pose | Drift accumulates during the hold; needs re-sync on exit |
| Keyframe + interpolate | Smooth, matches the clip pipeline | Only valid if both endpoints are known; mid-motion can violate contact |
| **Solve once, then constrain during the clip** | Solve the contact geometry, run the clip inside those constraints | Needs a light per-frame correction pass - not full descent |
| Full solve every Nth frame | Most robust, catches drift | Cost; can "fight" the clip motion |

> **Her choice: solve at entry, then apply a light pose CONSTRAINT during
> playback - position-based correction, not full cost descent. "The solver
> gives you the relative transform between bodies that satisfies the hold;
> treat that as a soft constraint the clip must respect. When the hold ends,
> release and return to independent clips."**

**Least sure (hers):** whether the blend between the solved pose and the clip
motion will feel natural - *"easy to write mathematically; feel is something
you tune from playtests."*
**The fact she says is needed:** how much positional correction per frame is
VISIBLE versus EFFECTIVE - the threshold for correcting without fighting.

---

## 2.2 — CAPSULES FOR GRAPPLING: "THE CASCADE IS REAL"

> **Capsules are the right primitive — but your problem is that you are
> optimizing surface overlap without volume preservation.**
>
> The cascade — fix thorax → pelvis bulges → fix pelvis → legs collide — is
> inevitable when you shrink one surface and the bodies naturally settle
> closer. **You are not doing anything wrong; you are seeing that grappling
> contact is volume-constrained, not just surface-constrained.**

| Fix | Why |
|---|---|
| **Add a soft interior volume term** | Penalise centre-of-mass approach below a threshold, not just capsule overlap. Bodies resist collapsing entirely, so fixing one part does not cascade to the next. |
| **Keep capsules, add an exclusion "core"** | A central ellipsoid each body protects — limbs cannot enter it. This is what humans actually have: a torso volume limbs go around. |
| Switch to convex hulls | More accurate, more expensive, harder to tune. **Probably overkill.** |
| **Per-pair radii offsets** | Different gap rules for limb–limb vs limb–torso vs torso–torso. *"Legs brushing is fine; torsos merging is not."* |

> **Verdict: capsules stay** — fast, stable, well understood. **Add a soft
> volume repulsion between body cores (torso/pelvis)** so narrowing one region
> does not pull everything into the next.

**Least sure (hers):** whether the volume term needs per-hold tuning, since
different holds compress the body differently and one hard threshold may not
fit every pose. She named this as the one thing in her whole answer she is
unsure of: *"it sounds right in principle but will need feeling out in
practice. Everything else is measurable."*

## 2.3 — THE 0.0044 m NECK CAPSULE: "ACCEPTABLE, AND MORE ACCURATE"

> **It is acceptable — and it is actually more accurate than the long
> capsule.** A collar tie does grip the base of the skull and upper cervical
> vertebrae — a compact region. **The problem was never the shortness; it was
> that the long capsule's hemispherical ends bloated outward to bury the
> reachable surface.** Pulling the endpoints in so the geometric extent matches
> the actual grip region is correct modelling, not a hack.

| Question | Her answer |
|---|---|
| Does it represent the lower neck? | **No — but the old one didn't either.** It was a volume that included the neck plus extra space. The new one represents exactly the reachable grip zone. |
| Will it break other poses? | Only if something explicitly targets the lower neck — **and nothing was reaching there anyway.** |
| Is a sphere-like capsule okay? | Capsules degenerate to spheres naturally as length → 0. The maths handles it cleanly. |

**The fact she says would settle it:** *"Where exactly do real collar ties
attach — skull base, mid-neck, or sternum? Video measurement could settle this
definitively."* **That is a research task, not a guess** — and we have 17
tracked videos and 98,136 two-person frames on disk.

## 2.4 — THE 6 mm GATE: "THE WRONG QUANTITY, BUT NOT BECAUSE IT IS TOO TIGHT"

> **6 mm is the wrong quantity — but not because it is too tight; because it is
> ABSOLUTE.**

| Issue | Her detail |
|---|---|
| Scaling | 6 mm on a 1.00 m body is **0.6% of stature**; on a 1.85 m body it is **0.32%**. *"Disproportionately strict on larger fighters."* |
| What it measures | Penetration is the WORST PAIR, not visible depth. Two torsos overlapping 6 mm is invisible at typical camera distance. **The threshold is already stricter than pixels demand.** |
| What to gate on instead | Keep penetration, **but also track VISUAL error** — distance between rendered mesh surfaces. *"If the mesh looks separated, the pose is good regardless of capsule overlap."* |

> **Her gate: `penetration <= 0.006 x stature`** — scales with body size,
> matches the original intent, larger fighters get slightly larger allowances.

**Least sure (hers):** whether different hold types need different thresholds —
ground work compresses more than a standing clinch, and one number may never
fit all thirteen.

---

## CLAUDE'S INTEGRATION NOTE — ONE OF HER THREE IS ALREADY DECIDED AGAINST

**2.4 IS NOT NEW AND THE PROJECT ALREADY MEASURED IT.** S47 ran a
stature-scaled bound as a third column and its own header records the verdict:
*"The stature-scaled bounds are REPORTED, never adopted. `PASS_PEN_M` and
`PASS_GRIP_M` are untouched; this is a second column on the same numbers so the
question can be answered without relaxing the gate that answers it. **A bound
that moves to make a pose pass is a relaxation whatever it is called.**"* At
f02's stature the ratio is x1.847, which would put the bound at 0.0111 m.

Her ARGUMENT is nonetheless better than the one S47 rejected: S47 asked "should
the bound scale so more poses pass", and she asks "is an absolute millimetre
even the right unit for a quantity that is only ever seen at a camera
distance". **Those are different questions and the second is unanswered.** Her
own second suggestion is the way to settle it without touching the gate:
**measure VISUAL error — mesh-surface separation — alongside penetration, and
find out whether the two agree.** That is a new instrument, not a looser bound,
and it costs one tool.

**2.2 IS THE ONE TO ACT ON AND IT IS ORTHOGONAL TO EVERYTHING S49 PLANS.**
"Surface-constrained, not volume-constrained" names the cascade mechanism in a
way nothing in this project had. Note that her fourth row — per-pair gap rules
— is **already half-built**: Q130's `REFUSED_PAIRS` and the room's
`OVERLAP_ALLOWANCE_M` are exactly per-class gap rules, arrived at from the
opposite direction. She did not know that and reached it anyway.

**2.3 AGREES WITH D8 AND SHOULD NOT BE TREATED AS INDEPENDENT CONFIRMATION** —
it is the same agent defending its own earlier proposal. Weigh it as the author
arguing her case, which is useful, not as a second opinion.

## HER CLOSING, AND IT IS ONE DIAGNOSIS FOR ALL FOUR

> **"The throughline across all four stuck points is the same: you are holding
> FIXED NUMBERS THAT SHOULD SCALE OR ADAPT - pass bounds, capsule extents,
> open-stance weights. The system is correct structurally; the constants are
> not DIMENSIONALLY CONSISTENT. That is the easiest kind of fix to make and the
> hardest to spot until you run it across different body sizes."**
>
> *"I am least sure about the volume repulsion in 2.2 - it sounds right in
> principle but will need feeling out in practice. Everything else is
> measurable."*

**That throughline is worth more than any single section** and it is testable:
every constant she names has a stature to divide by. It also cuts against S47's
recorded decision on the pass bound, which is why the note below still stands -
but S47 rejected scaling to make poses pass, and she is arguing the unit is
wrong. Settle it by measuring VISUAL error, not by moving the bound.

**Wait for the other three before acting.** Codex, Cursor and Qwen are being
asked the same four questions blind. Compare the answers to 2.2 first — that is
where a convergence would be worth the most.
