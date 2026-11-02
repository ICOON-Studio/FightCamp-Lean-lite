# M31 — FIFTEEN VOLUMES ON ONE BODY: HOW DO YOU DRAW THAT SO A HUMAN CAN READ IT?

**Owner:** Maria (art direction). **Art only — no code, no engine, no repo.**
**This is deliberately BLIND: an engineer is building the same thing right now
and has not seen this brief, and will not until both land.** That split has paid
five times on this project. Do not ask what they built.

## THE SITUATION

A fighter's collision body is **fifteen volumes** — a capsule (a segment with a
rounded cap at each end) for each of pelvis, thorax, neck, head, two upper arms,
two forearms, two femurs, two shins, two feet and a shoulder span. Twelve
sessions have now argued about their sizes **entirely in numbers**, and the
operator's two standing complaints about the 3D fight are *"bodies overlap"* and
*"I see no difference"*. Both are things you would see in one second if the
volumes were drawn on screen.

So we are building a **debug overlay**: the fifteen volumes drawn over the
fighter, on his moving body, toggleable, off by default. **It is a developer
instrument, not a player-facing screen** — but an instrument nobody can read is
worth nothing, which is why it is coming to you.

## WHAT MUST BE DISTINGUISHABLE, AND WHY

Every volume carries a **band**, which is the thing the overlay exists to
communicate. Four values:

| band | what it means |
|---|---|
| `SEGMENT` | a proper limb — long and thin |
| `STOUT` | thick for its length |
| `NEEDLE` | the radius nearly swallows the segment |
| `BALL` | the radius exceeds the whole segment — it was never a capsule |

On our own rigs today: every limb from the forearm outward is `SEGMENT` or
`STOUT`; the **thorax** is `STOUT`; the **neck** and **pelvis** are `NEEDLE`; the
**head** is `NEEDLE` on one rig and `BALL` on another. **`NEEDLE` and `BALL` are
the two that mean "something is wrong here"**, and telling those two apart at a
glance is the job.

## THE RULE THAT BINDS THIS, AND IT IS YOURS

**NEVER HUE-ONLY.** M23 and M24 established it and it is standing law here: a
state that differs from another state only in colour is a state a colourblind
viewer cannot read, and on a dark 3D scene it is a state *nobody* reads reliably.
So each band must differ in **at least one non-hue property** as well — opacity,
outline weight, a hatch or stipple, a dashed silhouette, a fill-versus-wireframe
split. **The pair to make unmistakable is `NEEDLE` versus `BALL`**, the way M25
made `accepted` versus `focused` unmistakable.

## THE FIVE THINGS TO ANSWER

**1. The four band treatments.** Name each one exactly — the hue AND the non-hue
property. Say which two are most at risk of being confused and what separates
them.

**2. How do fifteen overlapping translucent volumes not turn into soup?** They
genuinely overlap: a shoulder capsule and an upper arm share a joint by design.
Stacked transparency goes muddy fast. Say what you would do — wireframe only,
silhouette outlines, fill only on the selected one, depth fade, something else.

**3. Reading it while the body MOVES.** This is drawn on a fighter mid-exchange
at speed, not on a still. What survives motion and what does not? A hatch that
reads on a still frame can strobe on a moving one.

**4. How does a viewer see an OVERLAP — two volumes interpenetrating?** That is
the operator's actual complaint and the reason the overlay exists. Interpenetration
between a man's own adjacent capsules is **expected and fine**; between two
different fighters it is the defect. Say how the drawing makes that distinction
visible without a legend.

**5. What does it look like with the fighter's normal skin still on?** The
fighter is a textured 3D model in a lit gym. The overlay sits on top of him.
Does the body dim? Go wireframe? Stay as it is? Say it, and say what it costs.

## WHAT NOT TO DO

- **Do not design a HUD panel, a legend or a control surface.** The toggle
  already exists. This is about the volumes themselves.
- **Do not use a colour to mean "bad".** Three of the four bands are perfectly
  normal on a real body; `NEEDLE` on a pelvis is the shape of a pelvis, not an
  error. A treatment that shouts "error" on a normal limb is a treatment that
  gets switched off.
- **Do not invent new bands.** Four, exactly, named above.

## AND THEN ARGUE AGAINST YOURSELF

Make the strongest case that **a wireframe of fifteen volumes on a moving body
is the wrong instrument entirely** — that one still frame of two fighters at the
moment of contact would say more than any amount of live overlay, and that we
are about to build something nobody will look at twice. If you believe that, say
so; we would rather not build it than build it unread. **Name your own weakest
point unprompted** — K74 marked a state NOT COMPUTED rather than claiming wiring
we did not have, and that honesty is why its sheet shipped.

## WHAT TO SEND BACK

- `M31_CAPSULE_OVERLAY_LOOK.md` — the treatments and the five answers.
- `CLAUDE_LAND_NOTE_M31.md` — the short version.
- Boards as PNG where a board says it better than a sentence. **A keep board and
  a reject board for the `NEEDLE` / `BALL` pair** is worth more than four
  separate swatches.

**Send the memo TEXT in the message as well as attaching any files.** An
attachment alone does not reach the repository.

## Owned files
`research/M31_CAPSULE_OVERLAY_LOOK.md`, `research/M31_board_needle_ball_keep.png`, `research/M31_board_needle_ball_reject.png`, `research/M31_board_overlap_keep.png`, `research/CLAUDE_LAND_NOTE_M31.md` (collected S53, commit a7b3982d, 2026-09-22).
