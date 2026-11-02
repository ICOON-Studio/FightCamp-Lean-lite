# D7 — IS YOUR NECK REACHABLE (restated under D9, and the thing we lost)

**Agent:** Dola. **D7 sent and answered 2026-09-22; restated under D9 the same
day because our capture of it was a TAIL and D7 never became a document at
all** — two sentences of it were quoted in S48's digest and the rest was lost.
Raw capture: `_captures/D9_RESTATE_DOLA_raw.txt`.

## Her method, which we never had

> **256 uniform surface points per target**, offset outward by hand radius
> (`rArm.r = 0.06 m` at 1.00 m scale, scaled proportionally at 1.85 m). A point
> counts reachable if it lies outside all other same-body capsules by at least
> a hand radius.

| stature | head/neck exposure |
|---|---|
| 1.00 m | **92.7%** |
| 1.85 m | **92.7%** — identical, pure isotropic scaling; overlap magnitudes scale by 1.847 |

> **Worst burial on her rig: thorax overlaps head by 0.0083 m max — negligible.**
> Against our `neck`/`head` surface gap of **−0.1830 m**.

## 2. Radius / length ratio — AND IT CUTS AGAINST OUR OWN FRAMING

| rig | thorax length | thorax radius | **R/L ratio** |
|---|---|---|---|
| hers (1.00 m) | 0.1700 m | 0.1400 m | **0.824** |
| ours (f02) | 0.3054 m | 0.1909 m | **0.625** |

> **"My thorax is FATTER per unit length — yet the neck is exposed. R/L is NOT
> the cause."**

**That is a direct challenge to the ball-ratio framing S48 and Q132 both lean
on.** Q132 measured ball ratio across 180 capsule-rig pairs and S48 treats
"ratio over 0.5 means it is a sphere whose caps reach past both joints" as the
diagnostic. Her rig sits at **0.824** — worse than anything we ship — and its
collar-tie target is reachable anyway.

**It does not make the ball ratio useless**, and it is not a like-for-like
comparison (see the next section — her trunk meets a single combined neck/head
capsule, ours meets two). But it does say plainly that **a high ratio is not
sufficient to bury a target**, and S48's own pelvis result said the same thing
from the other side: ratio 0.824, 89.3% exposed, and narrowing it made
everything worse. **Two independent lines now point at the same caveat.**

## THE FINDING THAT CHANGES HOW D7 AND D8 MUST BE READ

> **"My rig has no separate neck capsule — the collar tie target is the HEAD
> capsule itself, whose base sits exactly at the thorax's top endpoint."**

**Her 92.7% is the exposure of a COMBINED neck/head capsule**, 0.15 m long at
r 0.11. **Ours is a 0.0594 m neck at r 0.055 sitting under a 0.128 m head
blob.** Those are not the same body model, and her rig cannot have the
head-buries-neck problem **because it has no separate neck to bury**.

**This was in D7 and we did not have it.** Every use of "Dola's rig reads the
neck 92.7% exposed" in S48's digest and the roadmap was therefore comparing
against a rig with one trunk-to-skull capsule where we have two. It does not
make her diagnosis wrong — see below, she diagnosed OUR geometry correctly and
in detail — but it does mean **92.7% is not a target our two-capsule set can be
held to without first deciding whether we keep a separate neck at all.**

## Her diagnosis of OUR rig, which is precise and was also lost

> - Your neck is buried because **your thorax extends upward past the Neck bone
>   via its hemispherical END CAP** — the geometric extent, not the bone
>   position, covers the neck region.
> - **Your head capsule also buries downward:** its lower cap reaches below the
>   Neck bone, **compounding the overlap from both sides.**
> - **Conclusion: endpoint positioning, not radius size.** Shortening the radius
>   alone would reduce overlap but not eliminate it — the extent still crosses
>   the boundary.

**She called both blockers before either was measured here.** S47's audit named
`thorax`, C158's blind test named `head`, and both were early-exit artefacts;
the corrected measurement found **both**, at head 39 dirs / 0.169 m and thorax
89 dirs / 0.181 m. She had said so in D7.

## D8's reasoning, which came before the table we did have

**Why inset by the capsule's OWN radius:**

> A capsule's hemispherical end extends exactly `r` beyond its endpoint. Place
> the endpoint at the bone and the SURFACE reaches `r` past it, burying the next
> segment. **Insetting by `r` means the geometric surface terminates exactly at
> the bone position**, matching where the skeleton itself changes part. Any
> other number leaves a gap or an overlap — **`r` is the mathematically exact
> offset for zero surface overlap at the boundary.**

**She flagged the short-neck consequence herself, explicitly, and we credited
it to our own reading:**

> On your dimensions: neck segment 0.0594 m, inset from both ends →
> `0.0594 − 0.0550 − 0.0550` → negative or near-zero → sphere-like.
>
> **"This is physically correct — the reachable neck surface at a collar tie is
> indeed the base of the skull, a compact region — but it means the capsule no
> longer represents the full vertical extent of the anatomical neck."**
>
> **Tradeoff accepted:** the old capsule looked like a neck but was
> unreachable; the new one is short but represents exactly the surface hands
> actually grip. **"If you need a longer visual neck for animation, keep the
> visual mesh separate from the collision capsule — they serve different
> purposes."**

## Three caveats we never saw, and one is a to-do

1. **APPLY THE SAME RULE TO THE HEAD, and verify it.** *"The head capsule's own
   bottom cap may still reach below the Head bone. If so: `head.p0.y =
   headBoneY + r_head` so it does not bury the neck from above."* **Measured
   here: it reaches 0.0724 m below the Neck bone on f01. So yes — the head
   needs it too, and S48 recorded that number without connecting it to her
   rule.**
2. **Bone positions are preserved; the endpoints are OFFSETS** applied in the
   capsule builder, never the skeleton. Skinning, IK and animation all work
   from unchanged bone origins. *(This is the constraint D8 was asked to
   respect, and she answers it directly.)*
3. **Scaling is automatic** — `boneY ± r` works at any stature because `r`
   scales proportionally. No hardcoded numbers.

**And a fallback if the short neck breaks something:** *"two levers — increase
the neck segment length in the skeleton (move the Head bone upward), or accept
a small gap/grace overlap threshold. The zero-overlap solution is
mathematically clean but physically tight."*

---

## Claude's note

**The single most useful line in D7 was the one about her rig having no
separate neck capsule, and it is exactly what a tail capture drops** — it sat
under "4. Additional points", after the tables. It does not overturn her
diagnosis, which was right about our geometry in detail and ahead of our own
measurements. It does mean her 92.7% is **not a like-for-like target**, and any
digest citing it must say so.

**For S50:** her rule now comes with its own extension to the head, which we
have already measured as necessary (0.0724 m). Apply both or neither — applying
it to the thorax alone leaves the head burying the neck from above, which is
the mistake she warned about in a caveat we had not read.
