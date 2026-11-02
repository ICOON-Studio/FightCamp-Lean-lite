# WHAT A FIGHT SOUNDS LIKE, PART TWO: THE PARTS J22 DID NOT COVER

**LONG-RUNNING TASK - it does not finish in one pass.** Operator ruling
2026-09-22: *"agents need to work 24/7 when they are green on opsboard give
long term tasks and keep checking on them on every new session how the
progress and improve the product."* Claude re-cuts this brief each session
from what actually landed - it is never restarted from scratch.

**EVERY PASS ENDS WITH AN ARTEFACT THE OPERATOR CAN JUDGE, and with a line
saying WHAT IS STILL WRONG.** A pass reporting everything fixed is the one
checked hardest.

**Owner:** john, deep research. No shell - stage to `_john_delivery/`.

## Where this starts

`research/J22_WHAT_A_FIGHT_SOUNDS_LIKE.md` is yours and it is the basis.
**Do not redo it.** Qwen is now building the audio system from it under
`TASK_SOUND.md`, starting from a project that has ONE audio file and ZERO
audio scripts.

## What the build will need that J22 does not already answer

Take these in order, and label every row MEASURED / INFERENCE / NOT FOUND with
a denominator, as you always do.

1. **Timing.** How long after visible contact does a strike's sound arrive at a
   broadcast microphone, and how long does it last? A sound 80 ms late reads as
   a different fight. If no study gives this, say NOT FOUND rather than
   estimating.
2. **What distinguishes a LANDED strike from a BLOCKED one** acoustically, and
   a head strike from a body strike. The engine already knows which is which -
   it needs to know what they should sound like.
3. **The ground.** Half of all grapple time in this engine is one control
   position. What does a crowd do during it, what do the fighters do, and what
   does the mat do? This is the part most likely to be missing from the
   literature - say so if it is.
4. **The crowd as a function of what happened.** The engine grades every action.
   What actually moves a crowd - a knockdown, a near-finish, a takedown - and
   how fast does the reaction rise and fall?
5. **Licensing.** Which sources of real fight audio, if any, could ever be used
   legally. The project's standing rule is that nothing is bought or downloaded
   without the operator's word, so a clean answer here is worth having BEFORE
   anyone wants to.
