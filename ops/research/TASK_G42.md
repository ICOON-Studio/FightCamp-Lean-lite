# TASK G42 — GROK — THE CLIP IS 0.82 s AND THE ENGINE TICKS AT 20 Hz

**Model: Grok, Expert. Research only — no code, no module, no test.**
Owner: Grok. Assigned 2026-09-10 by Claude, straight off R94's finding 2.

You have no checkout and no Godot. Everything you need is below. Do not ask for
the repository and do not write any GDScript.

## The gap, measured this morning

We bought and played one animation clip on our own fighters. It works: 22 of 22
bones drive, no BoneMap, 0.2 credits, one clip serves all twelve fighters. So
the asset question is answered and **this is the next one, and it is the
architectural one.**

- The clip `Combo (Jab-Cross-Hook)` is **2.47 seconds for three punches** —
  about **0.82 s per punch**, which is roughly honest for real boxing mechanics.
- Our fight engine is a **fixed-step real-time core at 20 Hz**. It resolves
  position, distance and damage per tick and emits impacts onto six body regions
  continuously. A 3×5 bout is ~18,000 ticks.
- The engine is **authoritative and seeded**: a bout replays byte-for-byte from
  its seed, judges score it, and stoppage rules fire off it. **That is not
  negotiable and nothing in your answer may propose changing it.**

So the engine can decide that a punch lands at tick 4,113 and another at tick
4,120 — 0.35 s apart — while the clip that shows a punch wants 0.82 s and cannot
be told to hurry without looking wrong.

**The question: what does a real fighting game do about that, and what does it
refuse to do?**

## What to deliver

One document, returned as plain markdown in your reply. Claude commits it as
`research/G42_CLIP_TIME_VS_TICK_TIME.md`.

### §1 — Who is authoritative, in shipped games

For fighting and combat games that actually shipped, establish which way the
arrow points and name the games. There are really only three answers and the
industry has taken all three at different times:

- **The animation is authoritative.** Frame data IS the rules — startup, active,
  recovery frames — and the simulation is the animation. This is the fighting-game
  tradition and it is very well documented; say so with specifics.
- **The simulation is authoritative** and animation is a view that must catch up,
  get interrupted, blend or be cut mid-clip.
- **A negotiated middle**, where the sim proposes and the animation system can
  refuse or delay, usually through an action/commitment window.

For each, say what it costs and what it buys, and be concrete about which shipped
titles are examples. **We are the second kind and cannot become the first** — our
engine was built, tested and rebaselined around a seeded deterministic core — so
the useful part of §1 is what the second and third kinds actually do.

### §2 — The techniques, by name

Name and explain the actual mechanisms a simulation-authoritative game uses to
keep a slower clip honest against a faster event stream. Expect to cover, and go
beyond: animation cancelling; blend trees and cross-fades; additive layers (a hit
reaction played on the upper body while the legs keep their footwork);
partial-body masking; time-scaling a clip and how far you can push it before it
reads as wrong; root-motion versus engine-driven position; and the difference
between a clip that is *committed* (cannot be interrupted) and one that is not.

For each: what it needs from the CLIP LIBRARY. That is the part we can act on,
because we buy clips one at a time at 0.2 credits and the shopping list depends
entirely on this section. **A technique that needs paired or bespoke motion we
cannot buy is a technique we do not have**, so say which ones are purchasable
off a generic humanoid preset library and which are not.

### §3 — The presentation escape hatch

The honest possibility that we are not obliged to show every impact. A broadcast
does not show every punch either — it shows an exchange and then a replay. Say
what shipped games do when the sim outruns the animation: drop impacts from the
view, aggregate them into one shown strike, slow the camera, cut away. **Which of
these preserve the truth of the scoreboard and which quietly lie to the player?**
That distinction is the one we care about most: our judges score what the engine
did, so a view that shows a different fight is a bug even if it looks better.

### §4 — The refusals

At least three things a game in our position **should not attempt**, named and
argued. Candidates you may confirm or reject: driving the sim from clip lengths;
time-scaling clips past some factor; per-strike unique animations for a
management game; letting root motion move a fighter the engine positions; trying
to animate the ground game off a library that has one grappling clip in 97.

You have been most valuable when you said "the books are silent, here is what is
published and here is what is circulating but unsourced." Same standard: if a
number is folklore rather than measured — "you can time-scale 20% before anyone
notices" — say whose folklore and mark it unsourced.

### §5 — What you would NOT build

The half that pays. We are a **management game** where the 3D fight is one screen
among many, not a versus fighter where it is the whole product. Say plainly which
of §2's machinery is worth it for us and which is a fighting-game budget we
should never spend. The operator made exactly this call on corner rules —
genuine per-jurisdiction differences deliberately collapsed into one authored
rule because no player picks a state athletic commission — and it is the call we
will have to make here.

## The traps

**Do not design our system.** No tick loop, no state-machine diagram, no
GDScript. You are establishing what is known and what is refused; Claude decides
what we build.

**Second trap: do not solve it by slowing the engine down.** The seeded
deterministic core is settled, rebaselined once already, and every pinned judge
card sits on it. An answer of "make the fight resolve at animation speed" is
outside the question and would throw away the whole scoring gate.

**Third trap: the ground game is NOT part of this task.** R94 established that
the clip library has one grappling clip in 97, so animating the ground is blocked
on sourcing, not on timing. Confine yourself to striking, and if you find that
the timing answer differs for grappling, note it in one line and stop there.
