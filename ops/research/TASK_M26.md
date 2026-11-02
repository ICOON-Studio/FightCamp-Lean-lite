# TASK_M26 - MARIA - HOW THE TECHNIQUE MODAL'S FOUR STATES READ WITHOUT COLOUR

**Owner:** maria. **Art only - treatment and state, NO geometry** (the UI task
owns every pixel) and **NO copy** (K74 owns the sentences). Stage to
`_maria_delivery/` and ping Claude.

## Why you, and it follows M23 and M24 exactly

M23 gave the region readout its states, M24 the gas instrument. Both got the
same thing right: **never hue-only, never a continuous throb, few named states.**
This is the third in that set.

The operator asked for a modal that plays the move's animation on hover in the
skill tree. The catalogue forces **four states**, and a player must tell them
apart at a glance and without relying on colour:

1. **PLAYING** - a clip bound to this exact technique, playing.
2. **NEAR** - a clip is bound but it is the same MOTION under another name.
   **Not this technique.** The player must be able to see that, not just read it.
3. **NO CLIP YET** - a move or sequence with nothing bound. 519 of 534 today,
   and that number is falling every week.
4. **NO MOTION** - a passive skill. **162 of the 696 are these and they will
   NEVER have a clip.** This is a category, not a gap, and it must not read as
   one.

## What to deliver

**The treatment for each of the four**, in the Cage Desk language and M22
tokens, obeying the M23/M24 discipline:

- **The channel that carries the state.** Not hue. Say which one - a keyline, a
  glyph, a fill pattern, a weight, a border treatment - and why that one.
- **Greyscale-safe and CVD-safe**, stated, the way M23 stated fill% + hatch.
- **PLAYING vs NEAR is the pair to make unmistakable**, the way M25's
  `accepted` vs `focused` was. Two clips both moving on screen and one of them
  is not the technique named above it. **Solve that pair first and hardest.**

Then three specifics:

**A. STATE 4 IS NOT AN EMPTY STATE AND MUST NOT LOOK LIKE ONE.** An empty
viewport frame with nothing in it reads as broken. A passive skill's modal is a
DIFFERENT KIND of card, not a card with a hole in it. Say how it differs.

**B. THE TRANSITION.** The modal opens on hover across a tree of up to 173
nodes in one discipline. Say what the entry treatment is and how long it takes.
**No continuous pulse** - same rule as M24.

**C. THE LOADING MOMENT.** A clip takes time to appear. Say how "about to play"
differs from "there is no clip", because those two look identical if nothing
distinguishes them and that is the most likely way this feature reads as broken.

## WHAT ALREADY EXISTS - READ BEFORE YOU START (operator rule 2026-09-22)

**"The agents should have all available information on existing researches and
tools."** This checkout holds **789 research documents, 220 Godot tools and 116
drivers**, and until today no task file told you they were there.

`RESEARCH_INDEX.md` at the repo root is the generated list - one line per
artefact, with what it is. **GREP IT, DO NOT READ IT WHOLE** (it is 213 KB;
reading it costs more than the exploration it replaces):

```
grep -in '<your topic>' RESEARCH_INDEX.md
```

Worth a grep here: `M22`, `M23`, `M24`, `M25`, `colour`, `state`, `CVD`. Ask Claude to paste any document you cannot reach - you have no checkout.

Then read the two or three that match, and nothing else. **A research document
is a FINDING, not an instruction** - it reports what was true when it was
written. If it names a file, a function or a flag, check that still exists
before building on it.

**AND A NEGATIVE RESULT IS A RESULT.** Several documents record that something
does NOT work - paired clip generation, a purchasable grappling pack, a numbered
referee break clock. Those are the most expensive findings in the set, and
re-running one wastes your whole pass.

**If the index shows something already answers part of your task, SAY SO in
your digest and build on it** rather than deriving it again. If it shows
something that CONTRADICTS your result, say that too - a contradiction found
early is worth more than a clean number found late.

## THE TRAP

**Treating NEAR as a warning.** It is not an error and not a danger state -
it is an honest label on a useful stand-in, and dressing it in warning chrome
would make a working feature look like a fault. Find the treatment that says
"not exactly this" without saying "something is wrong".
