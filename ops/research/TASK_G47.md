# TASK G47 — GROK — PUNCH REACH AND THE POCKET, IN METRES

Tier: **Expert**. Research only — no code, no module, no test.
Owner: grok. You have no checkout and no Godot; you are never given a repo
command. Deliver as **plain chat text**, pasted into the conversation.

## Why this exists

Our fight engine resolves position in metres. It says two men are, on average,
**0.89 m apart at the moment a punch is scored**, and that a strike may be
attempted at all only inside **1.10 m**. Nobody has ever checked those numbers
against a human body.

Your own G46 finding is what makes this urgent: **no shipped fighting game
publishes its pocket metres**, so a game-to-game comparison is unavailable and
**anatomy is the only check we have**. If a scored punch happens at 2.1 m
against a clip whose hand travels 0.7 m, our metres are wrong and the clips are
right — and we would spend money blaming the animation.

## The question, precisely

For a man of roughly **180 cm wingspan** (arm span ≈ height, so ≈ 180 cm tall,
≈ 75 cm from shoulder joint to knuckle):

1. **How far does the knuckle travel from the body**, measured from the
   sternum/centre-of-mass forward, for each of:
   - jab (lead hand, extended, with the shoulder rolled in)
   - cross / straight rear hand (with hip and shoulder rotation)
   - lead hook
   - rear uppercut
   - lead teep / front kick and a rear round kick (for the MMA case)
   Give a number in metres for each, and say what it is a fraction of wingspan.
2. **Where is "the pocket"?** Boxing coaching literature uses the word
   constantly. Put a metre band on it: at what centre-to-centre separation are
   two men "in the pocket", at what separation is it "long range / at the end
   of the jab", and where does the clinch begin?
3. **What does a fighting stance cost?** A man in a bladed stance is not a
   point. How much of the separation between two centres of mass is eaten by
   the two stances themselves — i.e. if two men's chests are 0.89 m apart, is
   that a plausible standing distance for two adults, or are they already
   overlapping?
4. **Does reach disparity change the landing distance?** When a 200 cm-reach
   man fights a 170 cm-reach man, does the taller man's punch land at a greater
   centre-to-centre separation, or does the shorter man close until the
   distance is the SAME and only the frequency changes? **This is the load-
   bearing one** — our engine uses a single flat 1.10 m gate for every fighter,
   and your answer decides whether that is a defect or a defensible
   simplification.
5. **Height difference, separately from reach.** A 165 cm and a 195 cm fighter
   throwing at each other: what happens to the *vertical* geometry, and how far
   does the taller man's knuckle sit above the shorter man's chin?

## How to answer

- Cite sources. Biomechanics papers on punch kinematics, coaching texts, motion
  capture studies, anthropometric tables. Say when a number is measured and
  when it is a coach's rule of thumb — they are not the same evidence and we
  will treat them differently.
- **Where no published figure exists, say NOT PUBLISHED.** Do not derive a
  number and present it as sourced. G46's value to us was largely in what it
  refused to invent; keep that.
- Give the answers as **a table of metres** we can hold against our own
  distribution. That table is the deliverable; the prose is supporting.
- Close with a section headed **VERDICT** answering, in one line each:
  *is 0.89 m a plausible centre-to-centre distance for a scored punch between
  two 180 cm men*, and *is a single flat strike gate for every fighter
  defensible*.

## Constraints

- Research only. Do not write GDScript. Do not propose an implementation.
- Do not read our repository; you have no access to it and nothing here
  requires it.
- Paste the document as plain chat text. The in-app browser blocks downloads,
  so a file attachment cannot be landed.
- Verify the tier chip reads **Expert** before you submit.
