# TASK M18 — MARIA — DOES "CIRCLING" READ AT ALL FROM THE FRONT?

Art direction. No code, no repository access, no test command.
Owner: maria. Deliverable: `research/M18_THE_FOOTWORK.md` plus boards in
`DesignLibrary/screens/fight_frame/m18_01..m18_NN`.

## Why this exists — a research desk has named a limit in your own ruling

A measurement landed today: **only 28.7% of a boxing bout is inside striking
range.** The other ~71% is two men moving. J18 has just costed that hole and
recommends **four in-place locomotion cycles**, mapped one-to-one onto the four
states our engine already names: `close` → `loc_fwd`, `retreat` → `loc_back`,
`circle` → `loc_circle_l` / `loc_circle_r`, with `hold` served by the existing
`idle`. The shape is a boxer's **shuffle / bounce-step**, never a walk or run.

**And J18 says this about your camera, in as many words:**

> Maria / M14 is **right for close and retreat** (depth compression on elevated
> three-quarter). She is **only partly right for circle** (screen-lateral on a
> front-of-ring camera). **CLAIM-TIGHT will not hide a glide** — do not
> translate on the tight.

That is a named, specific limit on M14's slide-mask, from a desk that read your
spec. **You are the one who settles it**, because it is a question about what
your camera can see.

## What is settled and is not yours to reopen

- **M14's HOME camera**: fov 50, pitch −20 to −22°, eye 3.8–4.2 m, stand-off
  9–11 m outside the apron, over the near ropes, fixed while live. M15's KD CAM.
  M16's punch ranking. M17's two reactions. Do not reopen any of them.
- **G42, non-negotiable: the ENGINE owns translation.** Clips are in-place, no
  root motion. A locomotion clip is a cycle played at a rate matched to the sim's
  own speed while the engine slides the body. That is the only arrangement
  available; you are judging how it looks, not choosing it.
- **For Honor clamps its entity 15 cm to the simulated point** (J18's citation) —
  so a few centimetres of residual foot-skate is inside shipped tolerance. No
  boxing title publishes a break speed; that is **NOT FOUND**, not an invitation
  to invent one.

## The question

1. **Settle the circle claim.** At HOME — a fixed camera 9–11 m out, front of the
   ring, elevated three-quarter — does a man circling read as circling? Or does
   lateral movement across the frame expose the foot-slide that depth
   compression hides on close and retreat? **Board it and say plainly whether
   J18 is right.** If it is right, say what to do: is it a camera-angle nudge
   within M14's existing bands (the stand-off and pitch have ranges), a different
   cycle authoring, or an accepted cost?
2. **Board the four cycles at HOME.** `loc_fwd`, `loc_back`, `loc_circle_l`,
   `loc_circle_r` — what does each need to show to be legible at that distance,
   given M16's finding that whole-body silhouette survives 10 m while glove and
   face detail are dead?
3. **The bounce.** J18 says the sport-shape is a shuffle/bounce-step, not a
   walk cycle, and cites a mean ring movement speed of **0.6 m/s** — slow. At
   that speed, is a bounce what sells "this is a boxer" rather than "this is a
   man shuffling"? What is the minimum the cycle must do vertically?
4. **The transition you can see.** A man goes from circling to throwing a hook.
   At HOME, does the eye need a visible weight-shift or plant before the punch,
   or does the punch simply start? **If a plant is needed, that is a purchase
   we have not budgeted** — say so, and rank it against the 14 clips already
   listed.
5. **Two men, one frame.** Both fighters are moving most of the time. Does four
   cycles × two bodies read as a fight or as two people doing aerobics? What
   stops it looking synchronised — and is that an authoring note, a playback
   note (offset the phase), or a purchase?
6. **What NOT to buy.** Same discipline as M16 §8 and M17 §6. Name the footwork
   purchases that would look reasonable and be waste.

## Standards

- Boards as PNGs in a new folder, numbered, in the M14–M17 house style.
- A **DECISIONS** section at the top: typeable lines, including a one-line
  verdict on the circle question and a yes/no on whether a plant clip is needed.
- Mark what is art invention versus what follows from the cited measurements,
  the way M16 §9 and M17 §7 did.
- Do not write GDScript, do not specify an animation graph, do not price
  anything.

Land it the way you landed M14–M17. **Do not edit `HANDOFF.md`** — Claude writes
your block. Do not wait on Claude for more files.
