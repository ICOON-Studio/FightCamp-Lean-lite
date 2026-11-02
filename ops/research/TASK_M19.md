# TASK M19 — MARIA — WHAT DOES THE VIEWER SEE WHEN WE HAVE NO CLIP FOR IT?

Art direction. No code, no repository access, no test command.
Owner: maria. Deliverable: `research/M19_THE_MISSING_CLIP.md` plus frames.

## Why this exists — a gap the next engine stage creates on purpose

Your M14 camera, M16's three-punch cut and M17's two reactions settled the
**purchase list**: ~13–14 clips — 1 idle, 4 locomotion, 3–4 punch types, 2
reactions, 3 knockdown. That list is **settled and is not being reopened.**

But the engine stage now being built (R101) changes what the presenter is being
asked to show. Today the engine picks a **body region** and a **force**, and
nothing more — "a strike landed on the leg" does not mean a leg kick, it means
force arrived at a leg. **After R101 the engine will name an actual technique**,
chosen from a 272-node catalogue of real moves, and hand that name to the screen.

**So for the first time the presenter will be told a specific thing happened
that it may have no footage of.** We are buying ~13 clips against a catalogue of
272 techniques. **The overwhelming majority of thrown moves will have no clip,
and that is CORRECT and is not going to be fixed by buying more.**

The rule R101 is built under is absolute and it is not negotiable:

> **Never substitute a different technique's animation for the one that was
> thrown.** Showing a body shot for a leg strike is presenting a different
> exchange. Dropping is permitted; **inventing is forbidden.**

That rule tells us what we must *not* do. **It does not tell us what the viewer
should actually see, and that is your question.**

## The question

1. **What are the honest options?** Enumerate them as a viewer experiences them,
   not as a programmer lists them. At least: the fighter plays nothing and stands
   in idle while the commentary/log reports the strike; he plays a *generic*
   strike that claims no specific technique; the camera cuts away or widens; the
   moment is compressed or skipped entirely; the reaction plays on the *receiver*
   while the thrower does nothing. **Which of these are honest under the rule
   above, and which are secretly the forbidden substitution wearing a hat?**
2. **What does "nothing" actually look like?** If the thrower stays in idle
   during a strike we have no clip for, does that read at your M14 camera — 9–11
   m back, 3.8–4.2 m up, 20° down over the ropes — as *stillness*, or does it
   read as a **broken game**? This is the single most important question here.
   Frames, please.
3. **Is the receiver's reaction enough on its own?** M17 found reactions
   out-read the thrower's arm, and that they cover 86.6% of contacts. **If the
   man being hit reacts convincingly, does the viewer notice that the man
   throwing did nothing?** If the answer is that the reaction carries it, that is
   the cheapest possible answer to this whole problem and it should be the
   headline.
4. **How often can it happen before it reads as broken?** There is a rate at
   which dropped moves stop being invisible and start being the thing the viewer
   is watching. **Is it 10% of strikes? 50%? 90%?** R97 measured our existing
   beat presenter dropping **92.6% of impacts** (830 of 896) and that is
   considered acceptable because a beat is a window of fight-time, not a
   flip-book. Say whether that number changes your answer.
5. **Does a generic strike exist?** Is there such a thing as a punch animation
   that reads as "he threw something" without claiming to be a jab, a cross or a
   hook — or does every readable punch necessarily commit to being one specific
   punch at our camera distance? **M16 already found jab and cross COLLAPSE at
   9–11 m**, which cuts both ways and may be very good news here. Follow that
   thread; it may be the answer.
6. **What do shipped games do** when the sim outruns the animation set? Sports
   games and fight games all have more simulated events than clips. Name the
   approach and whether it reads.
7. **The one-line rule.** If we can encode only ONE rule into the presenter for
   the no-clip case, what is it?

## Standards

- **Frames beat prose.** Your M14–M18 studies were spent against because they
  showed the thing at the real camera. Do the same here: show the no-clip moment
  as a viewer would see it.
- Mark anything you could not establish as **NOT FOUND**. Do not derive a
  tolerance and present it as measured.
- **Do not reopen the purchase list.** It is settled at ~13–14 clips and this
  task must not grow it. If your honest answer is that one *additional* clip — a
  neutral or generic strike — solves this outright, that is a legitimate finding
  and you should say so and cost it, but it must be argued, not assumed.
- Do not reopen M14's camera, M16's three punch types, or the no-reach-variants
  decision.
- No GDScript and no implementation.

## Deliverable shape

A **DECISIONS** section at the top — short typeable lines Claude can act on
without reading the body, including the one-line rule from question 7 and a
direct yes/no to question 3. Body, frames and citations below.

Send back **every file** you produce: the markdown deliverable and all frames.
**Do not edit `HANDOFF.md`** — Claude writes your block.
