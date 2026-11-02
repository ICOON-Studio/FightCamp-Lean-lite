# IS THE CONTACT DEFECT REAL, OR IS IT THE PROXY? EVALUATE A PROPOSED INSTRUMENT

**Owner:** codex, cursor, dola, qwen - each blind of the others.

**Asked of several agents, each blind of the others. This is an evaluation and
an opinion — write no code, change no file, run no test.** Answer fully in your
own words. Where you think the proposal is wrong, say so plainly; that is worth
more than agreement.

---

## THE STANDING PROBLEM

The operator's verdict on the 3D fight, twice, is that the bodies **overlap**
and the motion is **jerky**. Everything below is the attempt to measure that.

A fighter's body is modelled as **15 capsules**, fitted per bone from the
character's own skinned mesh (`FightBodyCapsules` reads `surface_get_arrays`
vertices and the skin bind bones, fits a capsule per bone, and then keeps only
the capsule). Contact is judged by **capsule-to-capsule surface gap**. A static
two-person pose solver (`FightPoseSolver`) scores a pose by, among other terms,
the deepest capsule penetration, and a 13-pose corpus is gated at **6 mm**.

**THE WEEK THAT PROVOKED THIS.** The thorax capsule was too fat; deriving its
radius from chest DEPTH rather than breadth fixed the named defect (f02 radius
0.1909 → 0.1418 m). The **pelvis** then became the worst offender. The same
depth derivation was applied to it and **the corpus went from 3 of 13 passing
to 1 of 13**, with nearly every new worst pair a **LEG** pair. The change was
reverted. A separate study then asked whether limbs are anisotropic like the
trunk and found they are — but in the **opposite** direction (trunk is wider
than deep by +0.027 to +0.039 m; legs are DEEPER than wide by −0.02 to
−0.03 m), so a depth-derived leg radius would be BIGGER, not smaller.

So: narrow the trunk, the bodies settle closer, the legs collide. Fix the legs
and something else will collide. **Every capsule fix has traded one overlap for
another.**

---

## THE PROPOSAL TO EVALUATE

**Stop measuring the proxy and measure the surface.**

Per frame, for each body, skin a sampled set of the character's **real mesh
vertices** (the same vertex and bind-bone data the capsule fitter already
loads), and compute the **true signed distance** between the two bodies'
surfaces. Run it on:

- the **same 13-pose corpus** already gated at 6 mm, and
- the **same live bout** (seed 810039, MMA, 900 frames) already measured,

so the new instrument has a control it can be compared against. Then compare
the surface numbers with the capsule numbers.

**The claim being made, and it is the part to attack:** if the true surfaces
were never touching where the capsules said they were, then the cascade above
is an artefact of the proxy — we spent a week tuning capsules to fix a defect
the capsules invented — and the 6 mm capsule gate should stop being the thing
we tune.

---

## WHAT TO ANSWER

**1. Is this the right instrument?** If yes, say what it settles that the
capsule number cannot. If no, say what you would measure instead.

**2. What would it MISS?** A surface distance is not the same as a visible
defect. Name the cases where the surfaces are genuinely apart and it still
looks wrong, and the cases where they interpenetrate and nobody sees it.

**3. What is the cheapest honest version?** How many vertices, chosen how? A
uniform sample, a curvature-weighted one, only the regions that ever come near?
**Name the failure mode of your own sampling choice** — what does a sparse
sample systematically miss, and does it miss it in a direction that flatters
the result?

**4. Screen-space or world-space?** The defect the operator sees is on a
screen. One alternative is to measure **projected overlap on the render plane**
rather than 3D distance. Which is the better gate, and why? Note that
occlusion is normal and is not a defect — one man in front of another is not an
error — so say precisely what distinguishes a legitimate occlusion from a
visible interpenetration.

**5. The physics question.** The operator's phrasing was to "insert physics and
force the outlines never to contradict". Godot 4 cannot do concave collision on
a moving body, and a solver that pushes bodies apart will fight the animation.
**Is there a form of this that works**, or is the measurement the whole of the
value? If there is, describe it concretely enough to cost.

**6. THE CONTROL.** This is the question this project most often gets wrong.
**How would you tell "the surfaces really are apart" from "my instrument cannot
see the contact"?** A measurement that reports everything is fine is exactly
what a broken instrument reports. Propose the control, not just the measurement.

---

## RULES FOR YOUR ANSWER

- **Lead with the one thing you would change first**, in a sentence.
- **Say which of your answers you are least sure about.**
- Where you need a fact to answer, **name the fact** rather than assuming it —
  an unmeasured fact becomes a research task instead of a guess.
- **Then argue against yourself:** take your own leading recommendation and
  make the strongest case you can that it is the wrong call.

**You are one of several answering this with no sight of the others.** That
split has paid five times on this project this month. Answer it yourself.
