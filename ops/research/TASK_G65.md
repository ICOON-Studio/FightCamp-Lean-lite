# TASK_G65 — GROK — THE BETWEEN-ROUND SURFACE, AT THE SAME DENSITY

**Owner:** grok
**Mode:** Expert. **NEVER Build mode.**
**No checkout. Reply in chat with the full text — do NOT attach a file.**

## Why this, and it is your own gap

G64 is landed at `research/G64_FIGHT_NIGHT_HUD.md` and it is the best
costed spec this project has been handed: 80/680/320 frame, six unmirrored rows
at 24 px, a 560×44 five-verb dock, a 12×4 post-fight table, named omissions. It
did NOT collide with U127 (30 px profile row) or M23 (state, no geometry), which
was the risk all three were assigned against.

It also left one surface deliberately thin. Verbatim, from your §5:

> Between-round: same five slots; SKIP label becomes NEXT; CORNER stays primary;
> plate clock is REST.

**The rest period is where a MANAGER'S verbs actually live.** The live round is
watched; the 60 seconds between rounds is where the corner instruction is given,
the round just scored is read, and the towel is considered. G64's own three-line
lead said the element you would fight hardest to keep is the six region rows —
this is the surface where the manager reads them and ACTS.

## What to deliver — the between-round screen, in numbers, under 300 lines

Same 1920×1080, same type scale (12/14/18/28), same spacing base 8, same
labels — **DOCUMENTED / INFERENCE / NEW** — and **NO COLOUR** (M22 owns it; M23
owns region state). Your unit is the pixel and the row.

1. **WHAT STAYS, WHAT CHANGES.** Which of G64's live bands persist through REST
   unchanged, which re-lay-out, and which appear only here. Give the pixel bands
   again so nobody has to diff two documents.
2. **THE ROUND-JUST-SCORED CARD.** The manager needs to know what just happened
   before choosing what to say. Rows, columns, position, height. Reuse the
   post-fight table's column contract (STAT · A · B · Δ) if it fits; say
   explicitly if the between-round version is a subset and which rows survive.
3. **THE CORNER INSTRUCTION.** This is the primary verb. How is it chosen — a
   list, a set of chips, a single primary + alternates? How many options, what
   size each, where. Kalli's K71 Causation Card and forthcoming K72 corner card
   supply the WORDS; you supply the CONTAINER they read in. Give the character
   budget per line the container can hold at 14 px without wrapping.
4. **THE REST CLOCK.** G64 says the plate reads `REST 0:47`. What else the
   cluster carries during rest — is the running score shown, is the round count
   updated before or after the bell?
5. **THE TOWEL.** G64 makes it a sibling, never primary. During REST is the one
   moment it is a real decision. Does it change size or position here? If yes,
   give the number and the reason; if no, say why a rest-period towel stays
   88×36.
6. **THE TIMING.** A real rest is 60 s (boxing/MMA) — how long does the manager
   actually have to read and act, what happens at 0:10, and what happens if no
   instruction is chosen (the default). BCM and FM both have a between-half
   default; DOCUMENT what they do.
7. **WHAT IS CUT.** Same as G64 §8 — a rest screen with no omissions has not
   been costed.

## Two constraints that are not negotiable

- **Management sim.** The manager talks to the fighter; the manager does not
  fight. No combat inputs, no "press X to recover".
- **It must read at 1080p without zooming, and it must read in 60 seconds.**
  Count the rows and the words. If the manager cannot take it in and act inside
  the rest, cut.

## THE TRAP

**Re-deriving G64.** Cite it by section (`per G64 §5`) and only restate what this
surface CHANGES. **Second trap:** specifying what the corner SAYS. That is
Kalli's (K71/K72), specified to the sentence; you specify the box it fits in and
how many characters that box holds.

## Deliverable shape

Lead with three lines: the seconds a manager needs to read this screen and act,
the one element you would fight hardest to keep, and the one thing you are least
sure about. Then the numbered spec.
