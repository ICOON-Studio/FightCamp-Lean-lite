# TASK_K74 - KALLI - WHAT THE TECHNIQUE MODAL SAYS IN EACH OF ITS FOUR STATES

**Owner:** kalli. **Research only - no .gd, no .tscn, no layout.** Stage to
`_kalli_delivery/` and ping Claude.

## Why you, and it is the same judgement K72 got right

K72's corner card got the hard thing right: **a SAY that does not lie about
wiring.** This is that problem again, on a new surface.

The operator asked for a modal that plays the move's animation when you hover a
technique in the skill tree. The catalogue makes that **four states, not two**,
and the modal must tell them apart honestly:

1. **PLAYING** - a clip bound to this exact technique, playing.
2. **NEAR** - a clip is bound, but it is the same MOTION under another name. A
   lead hook clip shown for a check hook. **It is not this technique and the
   player must be able to tell.**
3. **NO CLIP YET** - the technique is a move or a sequence, and nothing is
   bound. 519 of 534 are here today; the number falls every week.
4. **NO MOTION** - the technique is a passive skill (distance read, coverage,
   mobility). **162 of the 696 are these and they will NEVER have a clip.**
   This is not a gap; showing it as one would be the lie.

## What to deliver - the words, and only the words

Geometry belongs to the UI task already in flight; colour belongs to Maria.
**You own what it says.**

For each of the four states:

- **The label**, at most **14 characters** - the chip that sits on the modal.
- **The line**, at most **60 characters** - what it tells the player.
- **Whether that line is COMPUTED or NOT COMPUTED** - the K72 discipline. If a
  line claims something the engine does not currently know, mark it.

Then, three harder pieces:

**A. THE `NEAR` SENTENCE IS THE WHOLE TASK.** It has to admit the clip is a
stand-in without making the feature feel broken, in 60 characters, and it must
work for a dozen different kinds of near-ness: same punch different lead, same
kick different target, same throw different entry. **Give the one line, and
give the two runners-up you rejected and why.**

**B. STATE 4 MUST NOT READ AS A FAILURE.** A passive skill has no motion
because it is an attribute, not a move. Give the line, and say what the modal
shows INSTEAD of a viewport - in words, not layout.

**C. WHAT THE MODAL MUST NEVER SAY.** Name the phrasings that would be quiet
lies here - "animation coming soon" when nothing is scheduled, a technique name
over a clip that is not it, anything implying the engine simulates a technique
it does not. Same discipline as K70.

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

Worth a grep here: `K70`, `K71`, `K72`, `honesty`, `causation`, `corner`. Ask Claude to paste any document you cannot reach - you have no checkout.

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

**Writing state 3 as an apology.** 519 of 534 are unbound today and that number
is falling fast as clips are wired and generated. A line that grovels will be
wrong in a fortnight and embarrassing in a month. **State the fact, do not
apologise for it, and do not promise a date nobody has set.**
