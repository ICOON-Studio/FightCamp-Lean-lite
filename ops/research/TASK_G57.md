# TASK G57 — GROK — HOW LONG IS A FIGHT GAME'S BLEND, AND WHEN IS IT ZERO

**RESEARCH ONLY. NEVER BUILD MODE.** You have no checkout, no Godot and no repo
access — none is needed. Do not ask for the codebase, do not propose code, do not
write GDScript. **Deliver prose and numbers.**

Budget note: this is ONE query's worth of work. Answer it in one pass.

## The situation, stated completely — you need nothing else

We have a 3D fighting-simulation game. A fight is presented as a series of short
animation clips played on two character rigs, **one clip starting roughly every
1.1 seconds of wall clock**. The clips are short: the striking animations are
**0.7 to 1.2 seconds** of content each, with no padding. A roundhouse kick is
**0.700 s** total and the readable "the kick lands" moment inside it is only
**0.233 s**.

**Right now there is no blending at all.** Each new clip is started cold from
whatever pose the body happened to be in — a hard cut roughly once a second. We
expect this reads as snapping or popping rather than as fighting, and we are
about to add a crossfade.

The engine can blend between two clips over a chosen duration. We must pick that
duration, and decide whether some moments should have **no** blend at all.

## THE FIVE QUESTIONS

**1. WHAT BLEND / CROSSFADE DURATIONS DO SHIPPED FIGHTING GAMES ACTUALLY USE?**
Give numbers in seconds or in frames-at-a-stated-framerate. Distinguish, if the
sources do, between blending into a *strike*, into a *hit reaction*, and into an
*idle/stance*. If the published figure is a range, give the range.

**2. WHAT IS THE PENALTY FOR BLENDING TOO LONG ON A SHORT CLIP?** Our worst case
is a 0.700 s clip whose readable moment is 0.233 s. At what fraction of a clip's
length does a crossfade start to visibly destroy the pose — the "mushy" or
"floaty" failure that fighting-game developers describe? Is the right rule a
fixed duration, or a percentage of the incoming clip?

**3. WHEN SHOULD A BLEND BE ZERO?** Fighting games deliberately snap in some
places. Which ones, and why? We specifically need to know about **the single
dramatic beat that must read hard** — in our game that is a knockdown, which is
treated as a set piece that owns the clock and is the one moment a player must
not misread. Is snapping into such a moment standard practice, or is it blended
like anything else?

**4. IS A UNIFORM BLEND TIME DEFENSIBLE, OR MUST IT BE PER-ANIMATION?** We can
set one number globally in about one line, or carry a per-clip number at real
cost in bookkeeping. **What does the uniform version actually cost in how it
looks?** We would rather ship one number and be told honestly it is 80% of the
benefit than build a table nobody can tune.

**5. WHAT ELSE MAKES A CUT BETWEEN TWO CLIPS READ AS ONE MOVEMENT?** Blending is
the obvious lever. Name the others that fighting and sports games use — pose
matching at the boundary, authored lead-in frames, additive layers, inertialised
blending / inertia-based transitions, anything else — and say **which are cheap
and which need an animation pipeline we may not have.** Assume we can play,
window and time-scale a clip, and cannot author new animation.

## RULES FOR THE ANSWER

**LABEL EVERY CLAIM.** Mark each as:
 - **DOCUMENTED** — a published source (engine documentation, a GDC talk, a
   developer post-mortem, a technical blog by someone who shipped the game).
   **Name it.**
 - **INFERENCE** — your reasoning from observable practice. Say what you reasoned
   from.
 - **NOT FOUND** — you looked and there is no published figure. **This is a
   perfectly good answer and we want it explicitly.**

**DO NOT INVENT A NUMBER TO FILL A GAP.** A previous study on this project
concluded a whole category of animation did not exist anywhere, and a ten-euro
asset listing disproved it the same day — so search properly. But the opposite
failure is worse here: **a confident fabricated blend time would be applied
directly and would look wrong, and nobody downstream would know it was invented.**
"NOT FOUND, and here is how I would pick it empirically" beats a made-up 0.15.

**ONE NUMBER AT THE TOP.** Open with the single blend duration you would use for
a 0.7-1.2 s strike clip in a game presenting a clip every 1.1 s, with its label
(DOCUMENTED or INFERENCE). Everything else follows underneath. We will try your
number first.

**Do not discuss our codebase, our engine version, or implementation.** We handle
that. Answer the five questions and stop.

## Owned files — the collection target

This agent has **no checkout and cannot push**. The deliverable is real
regardless: Claude collects the answer and writes the file below. Naming it here
is what lets `python Tools/agent_comms.py done --task G57` mean *"has this been
collected yet?"* rather than passing on nothing.

- `research/G57_THE_BLEND_LENGTH.md`

**The agent is not asked to create it and must not be given a git command.**
