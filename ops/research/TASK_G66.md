# TASK_G66 - GROK - THE POST-FIGHT SURFACE, AT G64 DENSITY

**Owner:** grok
**Mode:** Expert. **NEVER Build mode.**
**No checkout. Reply in chat with the full text - do NOT attach a file.**
**Under 300 lines.**

## Why this, and it is the third of your own three

G64 gave the live fight night HUD. G65 gave the between-round surface and it
landed clean - 32 sources, and its 60-character recommended line turned out to be
exactly the budget Kalli's K72 corner card was written to, without either of you
seeing the other. That is the third time the split has paid.

G64 section 7 costed a **12 x 4 post-fight table** (STAT / A / B / delta) and
never placed the SCREEN around it. That screen is the last surface in the set and
it is the one the player spends real time on, because it is where a fight becomes
a story he can act on next week.

## What to deliver - the post-fight screen, in numbers

Same 1920x1080, same type scale (12/14/18/28), same spacing base 8, same labels -
**DOCUMENTED / INFERENCE / NEW** - and **NO COLOUR** (M22 owns colour; M23 owns
region state). Your unit is the pixel and the row.

1. **THE FRAME.** Does the 80/680/320 band structure survive here, or is this a
   different page? Give the bands. Say which of G64's furniture dies at the final
   bell and which persists.
2. **THE RESULT STATEMENT.** Winner, method, round, time. One line or a block?
   Size, position, type. This is the single thing the player looks at first and
   G64 never placed it.
3. **WHERE THE 12 x 4 TABLE GOES.** G64 section 7 already gives the column
   contract and the row list. You place it: x, y, width, row pitch, and whether
   all twelve rows are visible at once at 1080p without scrolling. If they are
   not, say which scroll or which cut.
4. **THE CAUSATION CARD'S BOX.** Kalli's K71 Causation Card is the post-fight
   explanation, specified to the sentence. You specify the container: how many
   lines, what width, **the character budget per line at 14 px without
   wrapping**. Same discipline as G65 section 3 - the box does not grow, the text
   ellipsises.
5. **THE BODY, AFTER.** The six region rows are the element you said you would
   fight hardest to keep. Do they appear here, and if so at what geometry - the
   live 24 px or the read 30 px? What do they show after the fight that they did
   not show during it?
6. **THE VERBS.** What can the manager actually DO from this screen? Name them,
   size them, place them. Management sim: he talks, arranges and decides; he does
   not fight. A verb that belongs on a different screen is a cut, not a slot.
7. **WHAT IS CUT.** Same as G64 section 8 and G65 section 7 - a screen with no
   named omissions has not been costed.

## Two constraints that are not negotiable

- **Management sim.** No combat inputs, no rematch-by-reflex.
- **It must read at 1080p without zooming.** Count the rows. If the player cannot
  take the result in before he reads the table, the order is wrong.

## THE TRAP

**Re-deriving G64 or G65.** Cite them by section (`per G64 section 7`,
`per G65 section 2`) and only specify what this surface ADDS. **Second trap:**
writing the causation sentences. Those are Kalli's K71; you specify the box and
its character budget.

## Deliverable shape

Lead with three lines: the seconds a player spends on this screen before he acts,
the one element you would fight hardest to keep, and the one thing you are least
sure about. Then the numbered spec.
