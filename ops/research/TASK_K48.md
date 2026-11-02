# TASK K48 — KALLI — WHEN A PUNCH LANDS: HOW FAR THE MAN WHO TAKES IT MOVES HIS FEET

Owner: Kalli (research, no shell). Stage: S4a (the foot lock, and a stagger that travels) - forecast research.
Deliver as ONE markdown answer.

## Why this exists

We animate boxers in 3D. A FOOT LOCK now pins a weight-bearing foot to the canvas; when a punch lands, the receiver's
reaction clip steps him back, and our motion-capture source moves him 0.37 m to 1.44 m in those clips. We must know
whether that is real before we either let the lock release his feet for the stagger or make the ring carry him that
far. We need the REAL behaviour of a boxer's feet when a blow lands - how many steps, how long each, how far in total,
and how fast - by the kind of blow.

## Questions (answer each with numbers where any exist)

1. **A clean head punch that does not drop him** (a jab; a cross or hook that rocks him): does the receiver step at
   all? How many steps, step length (cm), total displacement (cm), direction (straight back, sideways, turned), and
   how long until his stance is set again (s)?
2. **A body punch** (liver or solar plexus shot that hurts but does not drop him): the same numbers - and does he bend,
   step back, or hold his ground?
3. **The stagger before a knockdown or a standing count**: how far a hurt boxer travels (m), in how many steps, over how
   long, before he falls, reaches the ropes, or recovers.
4. **Momentum**: the impulse (N·s) or effective mass (kg) a jab, a cross and a hook deliver to a head or body, from
   force or instrumented-dummy studies - so displacement can be estimated from physics where no fight footage was
   measured.
5. **The nearest measured analogue**: balance-recovery studies of a SUDDEN PUSH or waist-pull on a standing adult
   (compensatory stepping - e.g. Maki & McIlroy; Hof's extrapolated centre of mass and "capture point"): step length
   (cm), number of steps, onset latency (ms) and step duration (ms) against perturbation size. Say how far this
   analogue is from a punch.
6. **Fighting games and sports games that publish it**: any developer talk or document giving a hit reaction's
   travel distance or how its foot contacts are handled (UFC / Fight Night, Tekken, Street Fighter 6, Absolver).

## Sources wanted

Peer-reviewed biomechanics first (boxing impact and head-kinematics studies, compensatory-stepping studies), then
video analyses of bouts with measured distances, then coaching texts with numbers, then developer talks. **Label every
number: DOCUMENTED (peer-reviewed / measured), SECONDARY (coaching text, secondary report, developer interview
paraphrase), or INFERENCE.** Give the citation (authors, year, journal or book, page/table where possible, or link and
date). If a question has NO measured number anywhere, write **NO STUDY** for it plainly - do not fill the gap with a
guess.

## Format

Start the answer with the line `Collect as: K48_HIT_BOXER_FEET.md`. Then a markdown file: `## DECISIONS` first (at
most 8 lines: steps, distance and time for a head blow, a body blow and a pre-knockdown stagger, each with its label),
then one section per question, then a sources list.
