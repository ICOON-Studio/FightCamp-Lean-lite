# J43 — WHERE DOES A RIB CAGE ACTUALLY END, AND IS A DOME THE RIGHT TOP FOR IT?

**Owner:** john (deep research). **No shell, no checkout, no repo, no Godot.**
This is a literature task and nothing in it needs code run.

## WHY YOU ARE BEING ASKED

Your J41 and J42 both landed and both changed what we built. **J42 killed the
endpoint inset outright** and told us to make the head a sphere; we did, and
measured it today. **It did not do what everyone expected.**

We model a fighter as capsules — a segment between two bone positions, a radius,
and a **hemispherical cap at each end**. The `thorax` capsule runs from the
`Chest` bone to the `Neck` bone. The neck sits above it and reads **0.0%
reachable** on both our rigs, on a shipping third-party rig, and on every
capsule humanoid anyone here has measured.

Today we removed the head as a blocker. **The neck stayed at 0.0%** and the
blocked directions simply transferred to the thorax: on our 1.78 m rig the neck
went from being blocked by `head` on 67 of 128 approach directions to being
blocked by `thorax` on **90 of 128**, with zero usable either way.

**The reason is the cap.** Our thorax radius is **0.1231 m** (1.78 m fighter) and
**0.1418 m** (1.88 m fighter). A hemispherical cap of that radius sitting on the
Neck bone reaches **0.1231 m straight up past it** — and the whole neck segment
on that rig is **0.0594 m long**. The chest's dome is twice the neck, over the
neck. S48 already narrowed that radius from 0.1909 to 0.1418 by deriving it on a
measured depth axis, and it moved the neck by **zero directions**.

So the question is no longer the radius. **It is whether a dome is the right
shape for the top of a rib cage at all.**

## THE FOUR QUESTIONS

**Q1 — WHERE DOES THE BONY THORAX ACTUALLY END, IN NAMED LANDMARKS?**
The superior thoracic aperture / thoracic inlet. Give the landmarks (T1 body,
first rib, manubrium, suprasternal notch) and, where a measurement exists, **the
mm**. We need to know how far above the C7–tragion line a real rib cage
reaches, and how far it does NOT.

**Q2 — WHAT ARE THE CHEST'S DIMENSIONS AT THAT LEVEL, not at the widest point?**
Our radius is a p80 of skin offsets measured over the whole chest, so it is
dominated by the widest part. A real thoracic inlet is **small** — roughly a
hand's width — while the chest at nipple level is wide. Give chest **depth (AP)**
and **breadth** at the inlet and at the widest level, both, from ANSUR II or
equivalent, with column names and unrounded means as you did in J41 and J42.
**The ratio between the two is the number this task exists to get.**

**Q3 — HOW DO SHIPPING RAGDOLLS AND CRASH-TEST MODELS SHAPE THE UPPER TORSO?**
J42 answered exactly this question for the head and the neck and the table was
the most useful thing in the memo. Do it again for the thorax: is it one capsule,
a box, two stacked volumes, a tapered shape? **Does anything shipping put a
hemisphere on top of a chest?** If the honest answer is "almost nobody uses a
capsule for a torso", that is the finding and it is worth more than agreement.

**Q4 — IS THERE A DOCUMENTED SHOULDER-TO-NECK CLEARANCE?** A hand closing on a
collar tie or a neck grip arrives through the gap between the trapezius and the
jaw. Is there any measured figure — a clearance, a reachable neck circumference,
a grip aperture — for how much neck is actually available to a hand on a
standing adult male? **NOT FOUND is a result**, and you have three of them in
J42 that we used.

## THE RULES THAT MAKE YOUR MEMOS USEFUL, AND THEY ARE WHY YOU ARE ASKED

- **Every number carries its source, its N, and a label: MEASURED, DOCUMENTED,
  INFERENCE or NOT FOUND.** J42's labelling is why we could act on it the same
  day it arrived.
- **Unrounded means and the column name**, not a rounded figure from a secondary
  source.
- **Say the denominator every time.** A percentage with no denominator has been
  retracted four times on this project.
- **NOT FOUND IS A RESULT.** Do not fill a gap with a plausible number.

## AND THEN ARGUE AGAINST YOURSELF

End with the strongest case that **this whole question is wrong** — that a
collision volume has no obligation to match anatomy, that game rigs use a fat
chest capsule precisely because it is cheap and nobody has ever complained, and
that the real defect is our *grip model* rather than our *chest*. Say what would
settle it. **Name your own weakest point unprompted.** Dola named hers on D12 and
it changed the design; your own self-objection on J41 ("girdle/scapula is the
wrong capsule abstraction") is why we did not roll the inset outward.

## WHAT TO SEND BACK

- `J43_WHERE_THE_RIB_CAGE_ENDS.md` — the memo.
- `CLAUDE_LAND_NOTE_J43.md` — the short version: what to change, what to refuse.

**Send the memo TEXT in the message as well as attaching it.** An attachment
alone does not reach the repository, and your own line on J42 — *"full memo is
in the messages above plus the attached .md"* — is the reason J42's 22 KB
survived. Do that again.
