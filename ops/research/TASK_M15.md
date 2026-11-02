# TASK M15 — MARIA — THE KNOCKDOWN FRAME

Art direction. No code, no repository access, no test command.
Owner: maria. Deliverable: `research/M15_THE_KNOCKDOWN_FRAME.md` plus
boards in `DesignLibrary/screens/fight_frame/m15_01..m15_NN`.

## Why this exists

M14 settled the fight camera and it is landed and typed: **HOME is not
isometric** — `Camera3D.fov = 50`, pitch −20 to −22°, eye 3.8–4.2 m off the
floor, stand-off 9–11 m outside the apron, shooting over the near ropes, and
**fixed while live**. You named exactly two moments that are allowed to leave
that camera: a CLAIM-TIGHT engine claim, and **a KNOCKDOWN** — and you deferred
the knockdown itself to "ref + count subject cut, or a push of ≤ 0.35 s".

That deferral is now the gap. A knockdown is the single most dramatic thing our
fight produces — it happens in **41.5% of bouts** — and it is the one moment
where the fixed camera you specified is definitely wrong. This task designs it.

## What is already decided and is not yours to reopen

- The HOME camera above. M13's tokens stand. Faces are deferred.
- **A knockdown in boxing takes roughly 10–25 seconds** of real time (J15), and
  a fighter who bounces straight back up still takes the full mandatory eight
  count plus the glove wipe — about 10–12 seconds. So the knockdown is not a
  half-second beat; **it is a long, quiet hole in the fight** and the frame has
  to hold attention across it.
- **MMA has no timed knockdown at all.** There is no count; the referee watches
  for intelligent defence and either lets it continue or stops it. So whatever
  you design must work in two shapes: boxing's long counted pause, and MMA's
  no-pause-at-all.
- The referee is mostly scenery by ruling (J14) and we have not modelled one.
  **Design the frame as though a referee may or may not be in it**, and say
  which of your boards depends on having one.

## The question

1. **The cut.** At the instant a man goes down, what does the camera do? Cut,
   push, drop, or hold? Give the move in the same typeable numbers M14 used —
   fov, pitch, eye height, stand-off, and how long the move takes.
2. **The subject.** Across a 10–25 second count, what is on screen and when?
   The downed man, the neutral corner, the count itself, the standing fighter,
   the corner? Give a **beat sheet in seconds** — at 0.0 s this, at 2.0 s this
   — because our engine will drive it off fight-time and we need the cues.
3. **The count, as a graphic.** J15's finding is that the eight is a **count
   number, not a wall-clock from the canvas** — the referee's count and the
   seconds elapsed are different quantities and the count is the one the
   audience follows. How does that read on screen? It is not a countdown timer.
4. **Getting up, and not getting up.** Two endings. The man rises and the fight
   resumes; or he does not and the fight is over. Board both, and say how the
   frame tells them apart **before** the result text appears — the moment the
   audience knows is earlier than the moment the game says so.
5. **The MMA case.** No count, no pause, possibly a finish in two seconds.
   What does the frame do differently, in one board.
6. **What we do NOT have.** Be explicit about which of your boards needs
   something we cannot render today — a referee body, a facial expression, a
   crowd. J15 listed twelve filmable downed body states; **we will likely own
   one knockdown clip, not twelve.** Design for one, and say what the second and
   third would buy if we bought them, in priority order.

## Standards

- Boards as PNGs in a new folder, numbered, in the M14 house style.
- A **DECISIONS** section at the top of the spec: short typeable lines — camera
  numbers, the beat sheet, the count treatment — that Claude can implement
  without reading the body.
- Do not write GDScript and do not specify an implementation.
- Where you are inventing rather than referencing, say so. M14's value was that
  its numbers were typeable and honest about which were which.

Land it the way you landed M14 (deliverable, boards, zip, land note). **Do not
edit `HANDOFF.md`** — Claude writes your block. Do not wait on Claude for more
files.
