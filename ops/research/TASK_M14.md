# TASK M14 — MARIA — THE FRAME WHEN THE FIGHTERS ARE ACTUALLY THERE

Art direction only. Boards + spec. No code, no `.gd`, no `.tscn`.
Owner: maria. Task id: M14.
Deliverable: `M14_THE_3D_FRAME.md` + boards.

## What changed since M13, and why you are being asked again

M13 gave us the fight screen and we accepted its rulings whole: **the wide frame
and the HUD carry the fight**, the HUD is the second camera, a tight contact shot
may only CLAIM what the engine scored, and this is not a fighting-game fight
screen. None of that is reopened here.

What changed is that the bodies are now **real**. We have twelve rigged 3D
fighters, a ring built at its true deck height (a boxing canvas stands at
**1.27 m**), and we are about to stand two men on it and animate them off the
fight's own beat stream.

M13 designed the frame as a composition. **M14 designs it as a camera in a real
room**, where the ring has a physical size and the bodies have a physical height,
and where the answers are numbers a camera can be set to.

## What is already built, so you design against it and not around it

- The ring is real geometry built from a spec — a boxing ring, and a cage, at
  their true dimensions. Nothing is baked or fudged.
- Two fighters stand on the canvas at their own division's stature.
- The preview camera today is a **single fixed isometric camera at 38° field of
  view**, with one key light and one fill. That is a placeholder, not a decision.
- The bodies play **in-place clips only**. The simulation moves them; animation
  never does. So a body can slide, and the camera has to live with that.
- **Known and NOT yours to fix:** the twelve fighters' faces and skin tones are a
  known defect queued for regeneration. Design the frame; do not design around
  the faces, and do not propose a fix for them.

## The questions

**1. THE WIDE FRAME AS A CAMERA.** M13 says wide is home. Now make it a lens:
where does the camera stand relative to the ring, at what height, at what angle,
and at what field of view? Is 38° right, or does it flatten two men into a
diorama? **Give numbers we can type in**, and say what each one is protecting —
what goes wrong at half that FOV and at twice it.

**2. HEADROOM AND THE ROPES.** A boxing ring has ropes at chest height and a deck
1.27 m off the floor. From a wide camera, the near ropes cut across the fighters.
What do we do — shoot over them, through them, hide them, accept them? Every
broadcast has an answer to this and it is the single thing that will make our
frame read as a fight or as a toy.

**3. WHEN DOES THE CAMERA MOVE, AND DOES IT MOVE AT ALL?** One fixed camera is
the cheapest thing we can ship and might be the right thing. If it should move,
say what drives it — the fighters' positions, the round, an event — and what it
must never do. M13 already ruled the HUD is the second camera; if that means the
first camera can stay still, say so, because that is a large saving.

**4. THE SECOND ANGLE, IF THERE IS ONE.** M13 permits a tight contact shot only
where the engine scored the contact. If we build exactly ONE more camera than the
wide, which is it, where does it live, and what triggers it? Name one; do not
give us a set.

**5. THE KNOCKDOWN.** It is the one moment the frame must change or it will read
as a bug — a man is on the floor and the camera is still showing a wide two-shot.
What does the frame do, for how long, and what does it show while he is down?
(We are separately researching how long a knockdown actually lasts in seconds;
design the shape, and we will fit it to the clock.)

**6. THE BODIES WILL SLIDE, AND YOU SHOULD SEE IT FIRST.** Because the simulation
owns position and clips are in-place, a fighter closing distance will glide
rather than step, at least at first. **What does the frame do to make that least
visible** — camera distance, angle, cut length, motion in the frame? This is the
one place where art direction can buy us a whole category of animation we
otherwise have to purchase.

**7. LIGHTING.** One key and one fill is what exists. What does a fight actually
need — how many sources, from where, how hard, and what is the ring's own
environment doing? Say what a viewer should be able to read off the bodies that
the current setup does not give them.

## What we need back

**Boards.** As many as the answer needs — M13's eight was right for M13. At
minimum: the wide frame as you would shoot it, the rope problem solved, the
knockdown, and the rejects. **The rejects board has been the most useful one you
send**, because it tells us what not to try.

**And a spec with numbers in it.** Camera position, height, angle, FOV, light
count and placement, and the cut rules. M13's token calls stand and are not
reopened; if you need a colour here, use the ones M13 already named.

## Format

One markdown document, `M14_THE_3D_FRAME.md`, opening with a **DECISIONS** block
of at most ten lines — the camera numbers and the rules — then the boards and the
reasoning. **Argue in the open if you disagree with any of this brief**, the way
you did on the heart rate and the trauma pips; you were right then and we
adopted it.

**Send back the spec and every board.** Name the boards `m14_01_*` onward.
