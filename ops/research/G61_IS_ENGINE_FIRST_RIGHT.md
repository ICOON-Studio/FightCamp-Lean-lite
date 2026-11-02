# G61 — Is the engine-first bet right? Grok says: for grappling yes, for striking no.

**Grok (Expert mode, in-app browser), 2026-09-22, 72 sources cited, 37 s of
work. Collected by Claude the same day. Grok has no checkout and cannot push, so
this file is Claude's transcription of its chat reply; the live thread is the
primary record.**

## Its own three lines, verbatim

> **Most important:** Overlap and jerk are mostly contact/blend failures, not
> decision failures. A correct CoG or strike-rate model does not make two meshes
> occupy one volume less.
> **Change first:** Treat the contact solver as a presentation layer (IK targets
> + pose cleanup), not as proof that "better decisions = watchable fight."
> **Engine-first:** Right for grappling. Wrong as the watchability bet for
> striking.

## 1. Watchability saturates before engine fidelity does

DOCUMENTED pattern, INFERENCE applied to FightCamp:

- **EA MMA 2010** (Simon Sherr / Autodesk HumanIK write-up): interactions used
  layered blends, relative IK and "touch tags". **Physics was used to clean
  interpenetrations, not to pose the fighters** — they avoided physics posing
  because they needed the visual intention of the actors.
- **Yuke's UFC Undisputed 2009** (GDC): fighters getting stuck, jitter,
  self-collision. The fixes were constraint limits, "limit how close fighters can
  get", temporarily disabling collision, strike-response animations, IK
  targeting. **Not a better decision tree.**
- **UFC 4** still rescales both bodies to the same size on the ground so limbs do
  not clip (dev confirmation, Operation Sports). Presentation cheating a
  size-accurate engine.
- **UFC striking keeps an invisible wall** so you cannot walk through the other
  man — clipping prevention, not a missing decision.

Applied to the operator's two named defects:

- **Bodies overlapping: "almost none" is a decision problem.** Wrong root,
  missing contact target, blend through volume. A perfect weak-line model still
  interpolates two clips through each other.
- **Jerky movement: split.** Some is state-machine (late dodge/feint, no
  between-exchange pose). Most of what reads as jerky in shipped fight games is
  blend window + clip coverage + foot lock.

**What would prove it wrong:** same clip set, contact solver on vs off, and the
operator stops naming overlap/jerk. *If jerk survives a clean contact solve, it
was never a decision problem.*

## 2. Matching published MMA rates is not the same as looking like a fight

Knockdown ~3.9%, leg-strike share 14–18%, takedown accuracy — these are **event
counts**. Watchability is the **path between events**.

Cases where the numbers were right and the picture was still wrong:

- **UFC ground scale cheat** — takedown/control rates can match a data sheet
  while both men become the same body.
- **Undisputed (boxing)** — physics + topology hitboxes + anti-clip wall; players
  report frame-skip auto-correction to make punches reach, and *ask for more
  canned animation*. Damage and punch vocabulary exist; watchability still fails.
- **EA FC / FIFA Hypermotion** — abandoned studio mocap and rebuilt locomotion
  from broadcast footage, because aggregate sprint/distance stats plus generic
  clips still looked like skating.
- **Fight Night 3 → 4** — FN3 had punch outcomes; FN4 still had to rebuild
  collision so gloves stopped disappearing into skulls.

> "A sim can hit every FightCamp calibration target and still look like two
> mannequins sharing a pelvis. The 323 tests do not observe *does this read as
> two athletes*."

**What would prove it wrong:** a non-dev watches 30 s of striking and 30 s of
grappling and does not mention overlap, slide or pop — while the rate sheet stays
inside the published bands.

## 3. Commercial spend is animation-first, engine as glue

| title | where the money went | engine's job |
|---|---|---|
| EA UFC 5 | new strike/GnP/spin/calf clips, 64k facial damage combos, strand hair, cinematic KO cameras | Frostbite for look and impact juice, **not a new decision model** |
| Fight Night 4 / Champion | likeness + mocap; physics at 120 Hz for force, glance, knockdown face | collision so they can stand close without arms through heads |
| EA MMA 2010 | mocap library + HumanIK touch tags + layered blends | physics = interpenetration cleanup only |
| WWE 2K15 | "five times the animation data", 40 days mocap in a real ring | real-time physics later, for ropes/weapons/weight |
| WWE 2K26 | ragdoll sold as the new toy for bumps | spectacle on top of animation trees |
| Yuke's UFC Undisputed | pose library + ragdoll controller + IK | constraints to stop stick/jitter |

> INFERENCE: "Nobody who shipped a watchable two-body fight treated *decisions
> are real* as the presentation strategy. They bought paired poses, then used
> IK/physics so those poses could touch."

**It independently re-confirmed our purchasing bind:** paired BJJ positional
packs are not a product; solo grapple packs on Unity/Fab are swing/parkour or
one-sided mount loops, not two-athlete positional trees. **Our 0-of-36 compose
score stands.**

## 4. The argument against engine-first that we need an answer to

> "EA and Yuke's already had mature fight sims. When the picture was painful they
> did not deepen CoG. They authored contact and used the engine as a solver under
> an artist pose. So the objection is: **intention is in the clip.** The engine
> can only refuse illegal volumes and pick the next clip. If the clip vocabulary
> is thin, a better balance model makes a more correct-looking wrong motion."

## The asymmetry, which is the actual deliverable

- **Grappling: engine-first is FORCED.** There is no pack to buy, AI generation
  is one-body, solo compose failed. "Engine + contact solver is not a bet there.
  It is the only path." **Keep going; the contact solver is the correct object.**
- **Striking: engine-first is a CHOICE**, and the commercial evidence says clips
  + touch-IK first with physics as cleanup. **"Your 2026-09-14 bet inverted that
  order."** Spending the year on weak-line and CoG while the operator is still
  naming overlap/jerk is solving the wrong half.

**What would make Grok retract:** a striking exchange, at current clip budget,
post-solver, that a cold viewer does not call painful — without adding paired
animation.

## Where this leaves S43 — Claude's read, not Grok's

**S43 is not challenged; its justification is.** Three independent reviewers
converge on the same defect from different angles:

- **G61 (Grok):** overlap is a contact/blend failure, not a decision failure.
- **M21 (Maria):** "overlap dominant; fix contact volume BEFORE polish."
- **U124 (Cursor):** the gate that was supposed to catch overlap —
  `fight_body_overlap_test.gd` — **cannot see it**; its `arm>head` key can never
  be emitted, while 82 frames (9.1%) of real `head>arm` overlap sit documented.

So build S43. But **frame it as Grok does — a presentation layer that makes poses
touch** — rather than as evidence that better decisions produce a watchable
fight. And treat the striking half as an open question, not a settled bet.

K68 (Kalli) dissents one level up and should be read beside this: it argues the
buyers of this genre want management depth and honest outcomes, and that a
non-3D bout path should not be gated on the contact solver at all.
