# D12 — "WE ARE NOT MEASURING DIFFERENT ENGINES, WE ARE MEASURING DIFFERENT HUMANS"

**Agent:** Dola (Cici desktop app, driven by `Tools/cici/cici.py`, fresh chat).
**Landed by Claude, S52, 2026-09-22.** Raw capture:
`research/_captures/D12_DOLA_raw.txt` (262 KB — **a raw transcript, not a
curated deliverable**). She ran it; the numbers below are hers.
**Task:** `TASK_D12_YOUR_RULE_WAS_REFUSED.md`.

## THE ONE SENTENCE

Her arm C did not transfer to our rigs because **her neck and our neck are not
the same object**:

| | `r_neck` | `L_neck` | `k = r/L` | her classification |
|---|---|---|---|---|
| **her D11 rig** | 0.035 m | 0.130 m | **0.27** | standard capsule |
| **our f01 @1.78 m** | 0.055 m | 0.0594 m | **0.93** | degenerate → sphere |
| **our f02 @1.88 m** | 0.055 m | 0.0774 m | **0.71** | degenerate → sphere |

> *"Same math, different inputs."* … *"Your authored numbers are the outlier,
> not the calculation."*

**She is half right, and the half she is wrong about is the important one — see
`WHICH OF US IS THE OUTLIER` below.**

## Q1 — WHAT TO DO WITH A CAPSULE WHOSE RADIUS EXCEEDS ITS LENGTH

Her decision procedure, classify-on-load:

| `k = r / L` | class | what the engine does |
|---|---|---|
| `< 0.50` | standard capsule | apply the inset, measure Present Ratio normally |
| `0.50 ≤ k < 1.00` | **degenerate** | treat as a **single sphere** at the segment midpoint, radius = the segment's own radius; measure Present Ratio against **that sphere** |
| `≥ 1.00` | **absorbed** | **discard the capsule entirely** — it is volumetrically indistinguishable from the endpoint sphere that contains it |

> **"Do not clamp and keep — that produces zero-length segments that break
> every downstream calculation. Promote or remove, never clamp-to-point."**

**This is a direct ruling on code we shipped today.** `FighterCapsules.
inset_endpoints` clamps a consumed capsule to a point. That is correct for the
S52 **measurement** — the resulting 0.0% present is the signal that refused arm
B — and it is **wrong as a shipping behaviour**. The function is wired to
nothing, so nothing is broken; whoever ships an inset must promote or remove
instead.

**Her bands agree with C164's contract, independently.** C164 was written and
handed to Codex before this reply arrived: `< 0.25 SEGMENT`, `0.25–0.50 STOUT`,
`0.50–1.00 NEEDLE`, `≥ 1.00 BALL`. Her boundaries are `0.50` and `1.00`, in the
same places, with the same meanings. **Two agents, no contact, same thresholds.**

Her verdict on us: *"Your head blob: k ≈ 1.0+ → Absorbed. Your neck: k ≈ 0.93 →
Degenerate → Sphere. Both are being measured as capsules, so the numbers are
wrong before the test even starts."*

## Q2 — WHAT MAKES A NECK REACHABLE AT k ≈ 0.93

> **"With capsules as currently defined? It cannot be done."**

Because `L − 2r ≈ −0.065 m`: there is no cylinder wall between the two end
spheres to reach. *"Arm A moved the blocker — thorax → head — but did not create
reachable surface. Arm C removed both blockers and still got 3.9% because the
surface itself barely exists."*

Her three options:

| option | change | result | cost |
|---|---|---|---|
| **A** | cut `r_neck` to 0.030 m → `k = 0.38` | surface appears | thin, loses anatomical volume |
| **B** | extend `L_neck` to 0.150 m → `k = 0.47` | valid capsule, inset works | moves the head attachment, changes silhouette |
| **C** | keep the geometry, stop measuring from below | exposure 70–90% | fixes the question, not the geometry |

## Q3 — IS 0.0% THE WRONG NUMBER? YES

> *"The spherical sweep punishes the neck for being unreachable from directions
> no human ever reaches it from."*

Discard elevations below horizontal; measure over the upper hemisphere only.
Her estimate: the same neck reads **70–90%**. *"Directions through solid bone or
chest wall are not obscured — they are not valid approach paths at all."*

**We already compute the mean elevation of the usable set and throw it away.**
`s47_contact_offsets._grip_reachability_audit` prints it. S52's digest named
elevation banding as candidate 2 for the next fix before this reply arrived —
**a second independent arrival at the same place.**

## HER SELF-OBJECTION, WHICH IS THE BEST PART

> *"My elevation-banded answer will **fail on the shoulder girdle and
> clavicle**. Discarding all directions from below works for the neck because
> no human reaches a neck from underneath the chest. But the clavicle has valid
> approach paths from front, side, AND below — filtering out the lower
> hemisphere will give us 95% exposure on a collarbone that is actually buried
> under trapezius from every usable angle. The metric will lie, and we will
> ship it."*

And:

> *"We may be normalizing bad rigging instead of fixing authored dimensions —
> the honest answer may be: make the neck longer or thinner. The banded exposure
> is the right **diagnostic** tool — it shows us where the problem lives — but
> it should not be the **shipping** metric."*

**Take that at face value.** Elevation banding goes in as an instrument, not as
a pass gate, and the per-region cone comes from anatomy rather than from a
single global horizon. G70 (Grok, in flight) is designing exactly those
per-anchor approach cones, blind to this reply.

## WHICH OF US IS THE OUTLIER — AND IT IS NOT THE RADIUS

She concludes *"match the authored dimensions that worked: `r_neck ≈ 0.035 m`."*
**Check that against anthropometry before acting on it.**

`FighterCapsules.RADII_M["neck"] = 0.055` is authored with its own note: *"0.055
m is a male neck's radius (about 0.35 m girth)."* A 0.35 m neck circumference
gives `r = 0.35 / 2π = 0.0557 m`. **Our radius is right.** Hers — 0.035 m — is a
0.22 m girth, which is not an adult male neck.

So `k = 0.93` is not produced by a fat neck. **It is produced by a short one:
`L_neck = 0.0594 m` is the `Neck`→`Head` BONE distance on a Tripo export, and
that bone pair does not span the anatomical neck.** Her option B — lengthen the
segment — is therefore the right shape of fix and her own recommendation is the
wrong one.

**J42 (John) CAME BACK WHILE THIS WAS BEING WRITTEN AND THE ANSWER IS "BOTH" -
AND IT KILLS THE RULE OUTRIGHT.** He had not seen D12.

| segment | J42's anthropometry | `r/L` | survives `L - 2r`? |
|---|---|---|---|
| neck, ANSUR **Neck Link** | `L = 107.8 mm`, soft `r = 63.3 mm` | **0.59** | **NO** |
| neck, ours | `L = 59-77 mm`, `r = 55 mm` | 0.71-0.93 | NO |
| head, ours as a capsule | `L = 77.4 mm`, `r ~ 77.2 mm` half-breadth | **~1.00** | **NO - use a sphere** |

Both halves are true at once: **our span IS short** (59-77 mm against a
C7-tragion Neck Link of ~108 mm), **and a real male neck is squat anyway** at
`r/L ~ 0.59`. His own line: *"Dola double-end inset cannot survive on neck even
at correct L."*

**So the endpoint inset is dead, not mis-parameterised.** Fixing the span does
not rescue it. And her recommendation is wrong in the other direction too - the
anatomical soft neck radius is **63.3 mm**, LARGER than our 55 mm, where she
proposed 35 mm.

**What J42 leaves standing:** the head becomes a **sphere/ellipsoid**; the neck
**keeps its volume** and has its span corrected toward C7-tragion (~0.11 m); and
grips become **anchors on one tube**, not three volumes - because the three grip
levels sit within ~0.11 m of each other and adjacent pairs are often 0.03-0.05 m
apart. **That is D11's own second model, and G70 designed exactly it the same
afternoon, blind to all of this.**

> The full J42 memo (~22 KB, Q1-Q4 with denominators) is **still on John's box**
> at `/workspace/j42/J42_THE_HEAD_AS_A_VOLUME.md` and needs a `CopyFromBox` he
> cannot run from his own executor. Only the land note reached the repo.
> **Collect it before relying on any number above beyond the deciding table.**
> He also reports three NOT FOUND results, which are results: de Leva absolute
> mm lengths, ANSUR surface neck-length tapes in the public CSV, and any BJJ
> grip-position mm survey.
