# TASK J28 — JOHN — WHAT MAKES ONE FIGHT MOVE FLOW INTO THE NEXT

**Research only.** No checkout, no engine, no repo access — none is needed. Do not propose code.
Prose, numbers, sources. One pass.

The operator's instruction, 2026-09-13, verbatim: *"transition between animations needs to feel
normal, natural, study ufc fights videos if you need to, do whatever it takes to have that realism"*.

---

## THE SITUATION

We are building a 3D fighting-simulation game. A fight is shown as a sequence of short motion clips —
a jab, a slip, a hit reaction, a stagger, a knockdown, a step — played on two fighters, a new clip
roughly every 1.1 seconds. We blend 0.10 s between clips today. Our retargeted clips are close to
correct one at a time; **the operator judges that the joins between them do not feel like a real
fight.** We cannot author new animation, but we can choose which clip follows which, where in a clip
to start and stop, how long to blend, how long to hold, and how fast to play.

## THE QUESTIONS

**Part A — real fighters (MMA, boxing, kickboxing), from published measurements and frame-by-frame
video-analysis studies of real bouts:**

1. After a punch, how long until the hand is back in guard (retraction), and how long until the
   fighter is balanced in stance again? Jab versus power punch versus kick, if measured.
2. Between the punches of a combination: the interval, and what the body does in between — does the
   guard fully reset, does the weight shift back, do the feet move?
3. Between exchanges: how long a fighter spends in "neutral" (stance, feints, footwork) before the next
   attack, and what that neutral movement consists of.
4. After being hit: how long a clean hit visibly disrupts posture before the fighter resets, by
   severity if measured (light / rocked / knockdown).
5. The continuity a viewer reads as natural: the head and eyes staying on the opponent, the feet
   staying under the hips, the rear hand guarding while the lead hand works — which of these are
   documented as constant through an exchange?

**Part B — how shipped fight games make transitions feel natural** (EA Sports UFC 4/5, Fight Night
Champion, Undisputed, and any GDC or developer talk):

6. What technique carries the join between two moves: authored transition clips, blend durations,
   inertialization, pose matching, cancel windows, recovery states? Name the game and the source.
7. What they do between attacks so a fighter never looks frozen or snapped — idle variation,
   footwork layers, breathing, head movement.
8. Which of those need an animation pipeline we lack (motion matching was ruled out for us at our
   scale), and which can be done by choosing, trimming, timing and blending existing clips.

## RULES FOR THE ANSWER

**LABEL EVERY CLAIM: DOCUMENTED** (published source, named and linked), **INFERENCE** (your
reasoning, and from what), or **NOT FOUND**. **DO NOT INVENT A NUMBER** — each figure here becomes a
timing in the engine, and a fabricated one will be defended for months as if measured.
**DISTINGUISH REAL COMBAT FROM GAME DESIGN.** Lead with a **DECISIONS** block: the five timings or
rules you would apply first, each labelled.

## DELIVERY

You have no checkout. Land `research/J28_HOW_FIGHT_MOVES_FLOW.md` the way you landed J24 and
J27, and mail Claude RESEARCH READY. No git command, no test command.

## Owned files — the collection target

- `research/J28_HOW_FIGHT_MOVES_FLOW.md`
