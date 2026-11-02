# TASK K50 — KALLI — HOW FAR APART BOXERS STAND, AND HOW FAR A PUNCH GOES INTO THE MAN IT HITS

Owner: Kalli (research, no shell). Stage: S4a (watchability: bodies that overlap, punches that look fake) - forecast
research. Deliver as ONE markdown answer.

## Why this exists

We animate a boxing match in 3D. The operator watched it and named the worst things on screen: the two men pass
through each other up close, and the punches do not look like they land. Our room keeps the men 0.80 m (close),
0.95 m (mid) or 1.10 m (long) apart, measured centre to centre along the floor - numbers we invented - while the one
bout study we hold (Schortgen, ECSS 2023, 32 French elite fights) reports 1.23 +- 0.16 m on average. Our punches are
performed in place, so a fist only reaches the other man from too close. We need the REAL spacing and the real reach
of a landed punch before we move anyone.

## Questions (answer each with numbers where any exist, and say what the distance is measured between)

1. **Spacing by range**: the distance between two boxers at long, mid and close (inside) range - centre to centre,
   chest to chest, or lead foot to lead foot, named - and the share of a round spent at each range, from tracking
   studies (Schortgen ECSS 2023's method and any successor; broadcast tracking; computer-vision bout studies).
2. **Spacing when a punch lands**: the distance between the two men at the moment a jab, a cross, a lead hook and a
   rear hook land; and how far the PUNCHER'S body travels toward the target during the punch (step length, hip or
   head displacement, cm).
3. **How far a landed punch goes in**: the target's head displacement at impact (cm, and in what time), glove and
   face compression (cm), and how far the fist travels past first contact (follow-through).
4. **Reach**: at contact, the punching arm's extension as a share of full arm length for a jab, a cross and a hook;
   and how boxers of different reach set their distance.
5. **Inside fighting and the clinch**: how close the men are (chest contact or not), the share of round time, and how
   a referee separates them (how far apart they are restarted).
6. **Other sports and games, labelled as such**: kickboxing / MMA striking distances if boxing has none; any fighting
   or sports game developer talk on spacing and on preventing two characters from interpenetrating (EA Fight Night /
   UFC, Undisputed, Tekken, Street Fighter "push boxes").

## Sources wanted

Peer-reviewed bout and biomechanics studies first (time-motion and tracking analyses, impact biomechanics with Hybrid
III or instrumented targets), then broadcast or computer-vision analytics with published numbers, then coaching texts,
then developer talks. **Label every number: DOCUMENTED (peer-reviewed / measured), SECONDARY (coaching text,
secondary report, developer interview paraphrase), or INFERENCE.** Give the citation (authors, year, journal or book,
page/table where possible, or link and date). If a question has NO measured number anywhere, write **NO STUDY** for
it plainly - do not fill the gap with a guess.

## Format

Start the answer with the line `Collect as: K50_SPACING_AND_REACH.md`. Then a markdown file: `## DECISIONS` first (at
most 8 lines: the real distances by range and at contact, how far a puncher travels in, how deep a landed punch goes,
each with its label), then one section per question, then a sources list.
