# G48 — HOW FAR CAN YOU WARP A PUNCH BEFORE IT BREAKS?

**Desk:** Grok (Expert tier), 95 sources. **Delivered:** 2026-09-10.
**Captured by Claude from the chat transcript** — the in-app browser blocks
downloads, so this is the pasted reply, reformatted but not reworded.

---

## VERDICT

**(a) 10 cm (band 8–15 cm)** of gap per clip with bounded two-bone IK, no bone
stretch past ~5%.

**(b) No-root does not change that number.** It removes root-warp, so anything
over ~15 cm is **refuse**, not a longer stretch.

**And the line that resolves our whole reach question:**

> **The half-metre centre-to-centre spread is not an IK problem. Engine placement
> + refuse covers it. IK covers the leftover.**

---

## 1. The bound

**Not published in centimetres.** No engine doc, GDC talk or solver paper states
"a punch hand may be IK-pulled N cm before it breaks." What *is* published:

- Unity **HumanIK `armStretch` default 0.05 (5%)**. Stretch starts at 95% of
  chain length, implemented by translating elbow and wrist. Larger = smoother
  solve, more rubber.
- Unreal AnimBP **Two Bone IK**: stretch **off by default**; if on, start ratio
  ~0.9, max scale often 1.2–1.5.
- Unreal Control Rig **TwoBoneIK**: stretch off by default; if on, start ratio
  0.75, max ratio 1.25.

Adult male shoulder→knuckle is ~65–72 cm, so **5% ≈ 3–4 cm of bone lengthen —
that is slack, not the visual warp budget.**

A rear cross at impact is already near lockout, so two-bone IK with no bone
stretch can only spend leftover elbow bend. **Practitioner band (not published):**

| gap | what it looks like |
|---|---|
| **0–8 cm** | elbow opens/closes. Reads as the same punch |
| **8–15 cm** | shoulder hikes, arm near straight. Acceptable at punch speed. **Bound** |
| 15–25 cm | lockout pop, rubber if stretch is on, elbow hyperextension / inverted pole, deltoid leaves the torso |
| **>25 cm** | **refuse.** Hand floats or the shoulder detaches |

**Usable bound 8–15 cm; plan on 10 cm.** Soft-IK — limiting the effector so the
chain never quite goes straight — is how shipped rigs hide the 8–15 cm edge.

## 2. Which joint pays

In order, if the solver chooses: **elbow** first (cheapest, correct) → **shoulder**
(acceptable until it shrugs) → **spine/clavicle** (looks like a lunge, then like
the arm is towing the ribcage) → **root**, which is what Unreal Motion Warping
actually moves and **is forbidden for us**.

**15 cm on the hand: elbow + shoulder. Do not give the spine the error** — that is
the detached-shoulder look. The pole vector must stay on the authored side of the
elbow or the joint inverts.

> Unreal's official punch sample pays with **root skew-warp, not the arm**. Limb
> IK in engines is the last centimetres plus aim, **not the range closer**.

## 3. Warp vs step vs refuse — the industry order

1. **Step / root-warp — primary.** Unreal's punch example warps root motion
   across the wind-up→impact window; melee tutorials clamp that warp to the
   clip's own travel or a designer box. **They do not stretch the arm to cover
   metres.**
2. **Bounded arm IK — the residual** after the body is in place: contact aim,
   height, a few centimetres of miss.
3. **Refuse** — outside the warp box or the remaining slack.

When they stop stretching and start stepping: **as soon as the arm would lock**,
in practice ~10–15 cm past authored contact. Not published as a number. Real
Boxing captured three distances and still needed IK plus action selection —
distance variants did not retire the solver.

**Stretch is not the range tool. Step is.**

## 4. No root translation — our constraint

**Yes, it breaks the industry step-in as a closer.** Their step-in moves the body
to the target; ours cannot. An in-place "step" clip over a translation the engine
already performed is **only legal if the clip's foot travel matches the engine's
move** — mismatch is slide.

It does **not** lower the visual IK bound (10 cm still looks like 10 cm). It does
dump every gap the engine did not already close onto **IK or refuse**.

## 5. Vertical

18–27 cm down is a bigger correction than most horizontal leftovers **but easier
for a two-bone arm than reaching further**. Further heads toward singularity
(lockout); down is remaining shoulder/elbow ROM from a mid-guard cross. **Failure
is a shrug, or the punch reading as an uppercut — not a rubber arm.**

EA's **Relative IK patent** exists for exactly this: store the fist-to-chin offset
from the authored clip and restore it at runtime with a reach curve, so
height-scaled fighters still land. That is the shipped answer for vertical, and
it is still IK-bounded. Same centimetre cap, separate curve, same refuse.

## 6. Runtime cost

Two-bone IK is **closed-form** (law of cosines). Two arms every frame of a fight
is cheap — games already run foot IK every frame on crowds.

**Do not apply it only on the contact frame — that snaps.** Weight it in across
the late punch; the industry default (FinalIK punch demos) tweens effector weight
over ~0.5 s. Full-body solvers are the ones you drop to zero iterations at
distance; two-bone is not that.
