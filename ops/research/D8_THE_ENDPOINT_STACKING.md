# D8 — DOLA'S ENDPOINT STACKING RULE, AND WHY IT COLLIDES WITH OUR OWN HEADER

**Agent:** Dola (Cici desktop app, driven by `Tools/cici/cici.py`).
**Landed by Claude, S48, 2026-09-22.** She ran it; the numbers below are hers,
off her own runnable page.

> **INCOMPLETE ON ITS OWN — READ `D7_D9_NECK_REACHABILITY.md` WITH IT.**
>
> This file was written from a TAIL capture that began mid-HTML at
> `${exposureBlock("After Fix", F01_FIXED)}`. It caught her RULE and her
> RESULTS TABLE, which is what the tail happened to contain, and **missed
> everything before them** — why the inset is the capsule's own radius, her own
> flagging of the short-neck consequence, and three caveats including one that
> is a live to-do.
>
> **D9 asked her to restate it and she did.** That material is landed in
> `D7_D9_NECK_REACHABILITY.md`, verified with
> `python Tools/check_digest.py` at 11 of 11 sections against its raw capture
> in `_captures/D9_RESTATE_DOLA_raw.txt`. Her words: *"the full D7+D8 core as
> delivered — no additions, no revisions."*
>
> **THE CAVEAT THAT MATTERS MOST WAS IN THE MISSING HALF:** *"The head
> capsule's own bottom cap may still reach below the Head bone. If so, apply
> the same rule to the head: `head.p0.y = headBoneY + r_head`, so it does not
> bury the neck from above."* **We measured exactly that at 0.0724 m on f01 and
> never connected it to her rule.** Apply the inset to the thorax alone and the
> head still buries the neck — which is the mistake she warned about in a
> caveat nobody had read.

## What she was asked

D7 ended with her offering to derive the exact endpoint coordinates that would
give our rigs her stacking, where the neck reads **92.7% exposed** against
**0.0%** on both of ours and on Perchance's. D8 took her up on it, with two
constraints: **a capsule endpoint is a BONE position we cannot move**, so she
had to say for each change whether it was a bone or an OFFSET; and **it had to
scale with stature**.

## What she returned

**An offset rule, not a bone move — which is the constraint answered.**

```
const neckBoneY = yourNeckBoneY;                 // unchanged from the skeleton
capsules.thorax.p1.y = neckBoneY - r_thorax;     // pull the top endpoint IN by its own radius
capsules.neck.p0.y   = neckBoneY + r_neck;       // pull the bottom endpoint UP by its own radius
// thorax top extent == neck bottom extent == neckBoneY  ->  zero overlap
```

Her own words: *"This is pure capsule builder offset — your skeleton, skinning
and bone hierarchy remain untouched."* It scales with stature because both
terms are that capsule's own radius.

| rig | neck exposure | thorax↔neck overlap | |
|---|---|---|---|
| f01 original | **0.0%** | 0.1231 m buried | ✗ |
| f01 fixed | **92.6%** | 0.0000 m | ✓ |
| f02 original | **0.0%** | 0.1418 m buried | ✗ |
| f02 fixed | **92.2%** | 0.0000 m | ✓ |
| her reference @1.00 m | 92.7% | 0.0000 m | baseline |

`head` needed no change — already aligned.

## THE PROBLEM, AND IT IS OURS NOT HERS

**This is endpoint inset, and `FighterCapsules.gd`'s own header explicitly
considered and rejected it:**

> *"The alternative is to inset each endpoint by its own radius — and that would
> take the femur from 0.4249 m to 0.187 m, i.e. it would stop being the femur.
> Joint-to-joint segments and non-overlapping caps cannot both be had."*

That rejection is sound **for the femur**, and it was written as a general rule.
Applied only at the trunk→neck junction the arithmetic is different, and it cuts
both ways:

- **Thorax:** 0.2824 m segment, inset 0.1231 → **0.1593 m left.** Shortened, but
  still recognisably a chest. Survivable.
- **Neck:** 0.0594 m segment, inset 0.0550 → **0.0044 m left.** The neck capsule
  effectively **becomes a sphere** of r 0.055 sitting at the base of the skull.

Whether that is a defect or the right answer is a real question, not a rhetorical
one. A collar tie grips **the base of the skull and the back of the neck**, which
is exactly where that sphere sits — so the proxy may be honest for the one hold
that needs it, while no longer representing the lower neck at all.

## What S49/S50 must do with this

1. **Apply the inset AT THE TRUNK→NECK JUNCTION ONLY**, never as a general rule.
   The header's femur objection stands everywhere else and must stay in the file.
2. **Re-run the 13-pose corpus** and compare against S48's table. **Her 92%
   figure is a one-body reachability number and says nothing about whether poses
   solve** — S48 spent a whole session proving those are different questions.
   A neck that is reachable and a corpus that still fails 10 of 13 would be
   progress in the same sense S48 was: diagnostic, not outcome.
3. **Watch for the cascade.** Every narrowing so far has bought a closer embrace
   and spent it somewhere else — the thorax exposed the pelvis, the pelvis
   exposed the legs. Insetting the trunk's top will let the two heads get
   closer. Measure `head/head` before and after.
4. **RUN HER PAGE BEFORE BELIEVING THE NUMBER.** Standing rule, and it is not a
   comment on this task: her v4 passed every threshold with bodies that could
   not bend.

She offered to integrate the rule into the solver and re-run the corpus herself.
**Decline that** — the corpus is ours, the DOF set is ours, and a number she
produces on her own rig is not a number about our tree. Take the rule, not the
run.
