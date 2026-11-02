# TASK M20 — MARIA — THE SHOT: WHAT THE FIGHT CAMERA MUST FRAME

**ART DIRECTION ONLY.** No `.gd`, no `.tscn`, no `assets/data`, no pricing, no
animation graph. You have no checkout and none is needed. **Deliver a board and a
decision list**, the way you delivered M14 HOME and M18 THE FOOTWORK.

## The situation, stated completely — you need nothing else

The standing fight is about to be watched by the operator for the first time, and
**it has no camera.** The 3D shell contains exactly six things: the world, an
**isometric camera**, a key light, a fill light and two corner marks. Nothing
directs the view. An isometric camera flattens the depth that reads a punch
landing.

An engineer is implementing a single static camera this week. **Your job is to
say what it must FRAME.** They have geometry; they do not have a shot.

## What is already fixed, and is NOT yours to reopen

- **The two fighters stand on a measured deck.** A boxing ring canvas sits at
  **1.2700 m** above the floor; a cage floor sits at **0.1300 m**. A fighter
  therefore stands **1.14 m lower in a cage than in a ring** and the camera must
  be told which.
- **The clips are IN PLACE and the engine owns translation** (G42, standing).
  Today the two men do not move at all — they stand at a fixed distance and
  trade. Footwork is a separate, later slice, and **your M18 already ruled on
  it**: mean ring speed 0.6 m/s, up to 15 cm of foot skate accepted, no IK plant
  system, and no circle-only camera.
- **M14 HOME is locked.** You settled the front-elevated-¾ geometry there and
  M18 confirmed it. **Do not reopen HOME and do not invent a third exit.**
- Beats arrive about **one per 1.1 seconds**. Clips are 0.7-1.2 s. **There is no
  editor and no cutting** — this is one camera, held.

## The three shots that already exist on paper, and why they need you

A prior study (Q55) produced these and **explicitly labelled them INFERENCE, not
DOCUMENTED** — broadcast MMA camera specifications were NOT FOUND in any
published source. They are derived from observable practice and scaled to a 1.6 m
pair at world origin. Vertical field of view.

| shot | position (x, y, z) | look_at (x, y, z) | fov | 35 mm equiv |
|---|---|---|---:|---|
| **establishing** | (0.0, 1.80, 2.60) | (0.0, 0.35, 0.0) | 42 | 28 mm |
| **tight** | (0.40, 0.75, 1.20) | (0.0, 0.30, 0.0) | 55 | 20 mm |
| **low mat-level** | (0.0, 0.22, 1.90) | (0.0, 0.35, 0.0) | 62 | 17 mm |

**THOSE NUMBERS WERE DERIVED FOR A GROUND FIGHT — TWO BODIES LYING DOWN, 1.6 m
LONG.** The fight being shipped this week is **two men STANDING and boxing**, and
nobody has checked whether a shot framed for a horizontal pair reads at all for a
vertical one. **That is the first thing you are being asked.**

## THE SIX DECISIONS

**1. DOES THE ESTABLISHING SHOT SURVIVE A STANDING FIGHT?** One line: yes, or
what changes. If the framing is wrong for two upright figures, say what is wrong
in visual terms — too high, too close, too much floor, heads cropped, the pair
reading as one silhouette — and what it should become. You may adjust the numbers
and you must say which you changed and why.

**2. WHAT MUST BE IN FRAME AT ALL TIMES, AND WHAT MUST NEVER BE?** Both
fighters' full silhouettes? Feet? The deck edge? Headroom above the taller man?
Our two test fighters are deliberately mismatched — **66.7 kg against 120 kg** —
so the frame has to hold a welterweight and a heavyweight in the same shot
without the small one disappearing.

**3. THE DEPTH AXIS.** Your own M16 finding is that the **whole-body silhouette
survives at postage-stamp scale while the glove and the face read as dead.** If
the silhouette is what carries the fight, **what camera angle keeps two
silhouettes separable rather than overlapping into one blob?** This is the single
most important question in the task. A shot where the near man eclipses the far
man on every exchange is worse than no camera at all.

**4. STATIC OR NOT, AND HOW MUCH.** You ruled out **continuous camera follow**
and a **circle-only camera** in M18. Is a completely locked-off camera right
here, or does it need a slow drift or a re-frame when the pair moves? **If you
say it must move, say the minimum that works** — the engineer has one week and no
shot-switcher. "Locked off is correct for now" is a perfectly good answer.

**5. LIGHTING, AGAINST WHAT THE SHOT IS FOR.** Two lights exist: a key and a
fill. A prior study DOCUMENTED three grounding tools none of which are on — a
**Decal blob shadow** under the pair, **SSAO** to darken where a body meets the
floor, and **height fog** so the floor fades instead of meeting a hard horizon.
**Which of the three does the most for the silhouette problem in question 3, and
which is not worth the GPU?** Note the one known limitation: SSAO is
screen-space, so from a very low camera the contact point can be occluded by the
bodies themselves and SSAO never reaches it.

**6. THE ONE THING THAT WILL LOOK WRONG FIRST.** From everything above, predict
the defect the operator will notice within ten seconds of watching. You have been
right about this before — M18 predicted screen-lateral foot slide before anyone
had seen it. **Name it, say why, and say the cheapest thing that hides it.**

## RULES FOR THE ANSWER

**Board it.** Frames, thumbnails, a diagram of the camera against the pair from
above and from the side — whatever shows the framing faster than prose does.

**LABEL EVERY CLAIM** the way you always do: **MEASURED** with the citation,
**INFERENCE**, **INVENTED VISUAL JUDGMENT**, **INHERITED**, or **NOT FOUND**.
Your labelling discipline is why these studies get used, and one of this week's
tasks had to be thrown away because an agent labelled a broken measurement as a
verdict.

**DECISIONS FIRST, numbered, one line each, at the top.** Reasoning underneath.
That is the shape of M14 and M18 and it is why they are still being read.

**ART ONLY.** No code, no enums, no scene structure, no animation graph, no
prices. If something you want needs a purchase, say it needs one and rank it
against the others — do not price it.

## Owned files — the collection target

This agent has **no checkout and cannot push**. The deliverable is real
regardless: Claude collects the answer and writes the file below. Naming it here
is what lets `python Tools/agent_comms.py done --task M20` mean *"has this been
collected yet?"* rather than passing on nothing.

- `research/M20_THE_SHOT.md`

**The agent is not asked to create it and must not be given a git command.**
