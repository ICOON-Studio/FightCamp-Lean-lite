# TASK K51 — KALLI — WHAT A HIT MAN'S HEAD AND BODY DO IN THE FIRST HALF-SECOND

Owner: Kalli (research, no shell). Stage: S4a (the operator's "punches look fake") - forecast research. Deliver as ONE
markdown answer.

## Why this exists

We animate a boxing match in 3D. The operator watched it and said the punches look fake. Part of a punch reading as
real is the man who takes it: when his head starts to move, which way, how far and how fast, whether his body turns
with it, and when he is back in guard. Our reaction clips are bought motion capture, started by the fight engine at
the moment of contact. Before we retime or choose them we need the REAL response, by punch type.

## Questions (answer each with numbers where any exist)

1. **Head rotation**: for a jab/cross to the face, a hook to the jaw and an uppercut to the chin - peak head rotation
   (degrees, and about which axis: turning, nodding, tilting), and the time to that peak (ms after contact).
2. **Head translation**: how far the head moves (cm) and in which direction over the first 50, 100 and 200 ms; peak
   linear and rotational acceleration and velocity change (Walilko 2005 and any successor, instrumented mouthguard
   studies in boxing or MMA).
3. **The neck and trunk**: does the torso rotate or bend with the head (degrees), and how much does neck strength or
   bracing (seeing the punch coming) change the head's motion?
4. **Body punches**: what the trunk does for a liver hook and a straight to the solar plexus (flexion or side-bend in
   degrees, time), from biomechanics or clinical description.
5. **Onset and recovery**: the delay between contact and the first visible reaction (ms); the time until the fighter is
   back in guard or countering (s) for a punch that does not hurt him and for one that does.
6. **What games do**: published hit-reaction timings from fighting games (hitstun frames, hit stop / hit freeze
   frames, reaction animation lengths) - labelled as game design, not biomechanics.

## Sources wanted

Peer-reviewed biomechanics first (Walilko et al. 2005; Viano et al. on boxing and football head impacts; instrumented
mouthguard studies in combat sports; Hybrid III and PMHS impact studies; neck strength studies), then clinical
descriptions, then coaching texts with numbers, then game frame data. **Label every number: DOCUMENTED (peer-reviewed
/ measured), SECONDARY (coaching text, secondary report, game frame data), or INFERENCE.** Give the citation (authors,
year, journal or book, page/table where possible, or link and date). If a question has NO measured number anywhere,
write **NO STUDY** for it plainly - do not fill the gap with a guess.

## Format

Start the answer with the line `Collect as: K51_THE_HIT_RESPONSE.md`. Then a markdown file: `## DECISIONS` first (at
most 8 lines: head rotation and translation with timing for a straight, a hook and an uppercut; the trunk's share; the
onset delay and the recovery time, each with its label), then one section per question, then a sources list.
