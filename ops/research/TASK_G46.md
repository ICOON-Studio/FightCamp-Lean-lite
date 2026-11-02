# TASK G46 — GROK — HOW SHIPPED GAMES PLACE TWO BODIES WHEN THE SIM OWNS POSITION

Tier: **Expert**. **RESEARCH ONLY — no code, no module, no test.**
Owner: grok. Task id: G46.
Deliverable: `research/G46_TWO_BODIES_IN_SPACE.md`, one file.

## The situation you are researching, stated exactly

We have a fight simulation that runs at **20 Hz** and owns everything: it decides
distance between the two fighters, who throws, what region is hit, and how hard.
It emits a **separation in metres** and, on each impact, a **distance**. It does
NOT emit a stance, a foot position, a facing, a step, or which hand threw.

We are now putting two 3D bodies on screen to show that fight. The bodies play
**in-place clips only** — the simulation owns translation, root motion is
forbidden, and the view may drop an event but may never invent one.

So the presentation layer has to answer questions the simulation never answers,
and the failure mode is obvious once you picture it: **the sim says they are
2.1 m apart, and the punch clip's arm reaches 0.7 m.** The man throws at air, or
the clip is played anyway and the picture contradicts the card.

## The question

**How do shipped games place, face and move two bodies in space when a
simulation — not the animation — owns their position?**

Answer it from what real games actually do, with named titles. Six sub-questions,
each of which we will act on:

**1. FACING.** How is facing decided and how fast does it turn? Is a fighter
always squared to his opponent, or is there a lag/turn rate? What breaks when
facing snaps instantly?

**2. SPACING.** What actual distances do fighting and combat-sports games hold
two humanoids at — in metres if anyone states it, in body-widths if not — for
"long range", "the pocket", "clinch"? We need real numbers to sanity-check our
own engine's separation against, because nobody has ever checked whether the
engine's metres are plausible.

**3. FOOTWORK.** When the sim moves a fighter from 2.1 m to 1.4 m, what plays?
A slide with no leg animation? A locomotion clip whose playback rate is matched
to the sim's speed? A blend tree? What do games that separate sim-position from
animation actually do, and what does each one cost to build?

**4. THE DISAGREEMENT — this is the important one.** When the sim's distance and
the clip's stance/reach disagree, what do shipped games do? Enumerate the real
strategies with the title that uses each, and say what each one looks like when
it goes wrong:
   - snap the position to the clip
   - scale/warp the clip to the position (IK reach, "animation warping")
   - play the clip anyway and accept the miss
   - refuse to play and pick a different clip
   - move the camera so the gap is not visible
   We will pick one of these, so give us the trade-offs, not a favourite.

**5. THE HAND.** Our sim never names a hand. Games that show a punch must pick
lead or rear. How do games that get a strike from a non-animation source decide
which limb throws it — and does the choice have to be stable across replays?
Also: what changes for a **southpaw** — does a mirrored stance need mirrored
clips, or is a mirrored skeleton pose enough, and what goes wrong when it is
faked?

**6. WHAT IS SHOWN AT ALL.** Our stream produces roughly **896 impacts in a bout
and shows 66** — a 92.6% drop. For games where the sim outruns the animation
budget, what is the shipped convention: show a representative subset, slow the
sim to the animation, batch several events into one longer clip, or cut away?
G42 already rules that dropping is permitted and inventing is forbidden — so we
are asking how others handle the drop, not whether to.

## Sources, and what makes this document worth having

**Cite everything with a name.** A named title, developer talk, GDC session, dev
blog, engine documentation page or postmortem beats a general assertion every
time. Games worth looking at include boxing and MMA titles (Undisputed, Fight
Night, EA/UFC), wrestling games, and — because the pattern is the same — any
game where a **simulation or server owns position and the client animates it**
(sports sims, MOBAs, networked shooters with server-authoritative movement).
The last category may well have the cleanest published thinking on it.

**Where sources disagree, say so and keep both.** A previous cycle here had two
research files disagree about a rule and both were right — the disagreement was
the finding. Do not smooth it.

**Where you cannot find a source, say "not found".** Do not fill a gap with a
plausible guess; an invented convention is worse than an admitted hole, because
we will build on it.

## Explicitly out of scope

- **The ground game.** Do not research grappling, takedowns or ground positions.
  We have 97 combat clips available and exactly one is grappling; it is blocked
  on sourcing, not on design.
- **The referee.** Prior research concluded most of the referee is scenery.
- **Any code.** No GDScript, no module, no API. If you find yourself writing a
  function signature, you have left the task.

## Format

One markdown file, `research/G46_TWO_BODIES_IN_SPACE.md`. Lead with a
**DECISIONS** section of no more than ten lines telling us what to do about each
of the six questions, then the evidence behind each. We read the top and act on
it; the body is what we check it against.
