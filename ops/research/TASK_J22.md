# TASK J22 — JOHN — WHAT A FIGHT HAS TO SOUND LIKE, AND WHAT THAT COSTS

**DEEP RESEARCH ONLY.** You have no checkout, no Godot and no repo access — none
is needed. Do not propose code and do not write GDScript. **Deliver a cue list
and a sourcing table.**

## The situation, stated completely — you need nothing else

We have a 3D fighting-simulation game with a working fight. Two fighters trade on
a canvas; a simulated engine decides everything and a presentation layer plays
short animation clips for what it decided. **One beat is presented every 1.1
seconds of wall clock**, over three 3-minute rounds.

**The entire project contains ONE audio file — a menu music track. The fight is
completely silent.** There are no impact sounds, no breath, no crowd, no bell.
Nothing. We are starting from zero.

**THIS TASK IS THE CUE LIST, NOT THE SOUNDS.** We are not asking you to make or
find audio files. We are asking what a fight actually needs to sound like, how
many distinct sounds that is, and what the realistic ways of getting them cost.
**The count is the cost, and we do not know the count.**

## What the game already knows at the moment a sound would play

Every presented beat already carries all of this. **Design the cue list against
these, because a cue we cannot trigger is a cue we cannot buy:**

- **the technique that was thrown**, by name — e.g. `boxing_overhand`,
  `muay_thai_round_kick`, `boxing_lead_uppercut`, `kickboxing_low_kick`
- **the body region it targeted** — head/neck, body, left leg, right leg, arms
- **the contact quality** — whether it landed, and whether it was *significant*
- **whether it was a knockdown**, which the game treats as a one-off set piece
- **whether the receiver blocked or slipped it** instead of being hit
- **the round number and how far through the round we are**
- **how tired each fighter is** (fatigue is already modelled and already changes
  how fast their animation plays)

## THE SIX QUESTIONS

**1. THE CUE LIST.** Enumerate every distinct sound a broadcast-style fight needs
to be watchable. Group them — impacts, defensive contact, effort and breath,
crowd, the room and the canvas, the officials and the corner, the bell and the
round structure. For each cue say **what triggers it** in terms of the beat data
above.

**2. HOW MANY VARIANTS BEFORE REPETITION IS AUDIBLE?** This is the question that
sets the budget. A punch impact will fire hundreds of times in one fight. **How
many distinct takes does a game need before a listener stops noticing it is the
same sample?** Published figures if they exist, clearly labelled. We already
learned this lesson visually — one head-reaction clip played 5,525 times reads as
a bug, so we carry four takes and cycle them — and we expect audio to be worse,
not better, because ears detect repetition faster than eyes.

**3. DOES AN IMPACT NEED TO BE ONE SOUND OR A LAYERED SET?** Our engine
distinguishes a jab from a knockdown blow and knows the target region. **Is the
standard practice one sample per weight (light/medium/heavy), or a layered
construction — a "thud" layer plus a "slap" layer plus a leather layer — mixed at
runtime by intensity?** Say which gives more apparent variety per file bought,
because that directly divides our cue count.

**4. WHAT CARRIES THE MOST PERCEIVED REALISM PER SOUND?** If we could only afford
**five** cues, which five? We suspect the answer is not "more punch sounds", and
we want to be told plainly if the crowd bed or the breath does more work than the
impacts do. Rank them.

**5. SOURCING, PRICED.** For the cue list you produced, lay out the realistic
routes side by side with real numbers where you can find them:
 - **commercial SFX libraries / asset-store fight packs** — name specific ones
   with prices and say what each actually contains
 - **royalty-free and CC0 libraries** — name them, and be honest about whether
   the quality is usable for combat impacts specifically
 - **AI audio generation** — we hold roughly **4 Ludo credits and 60 Motifect
   credits** and have an audio-generation tool available. Say frankly whether
   current AI audio generation produces usable *combat impact* sounds or only
   usable *ambience*; those are very different answers and we would rather have
   the real one.
 - **recording them ourselves** — what it would actually take.
 **Give a total for the whole cue list under each route.**

**6. THE LICENCE QUESTION, WHICH IS A HARD CONSTRAINT HERE.** For each route, say
what the licence permits. We have a standing rule on this project: **assets taken
from other games are never shipped**, and one animation vendor's direct EULA
forbids AI use while the same pack bought through a storefront does not. **Flag
any source whose licence would block commercial release or would forbid feeding
it to an AI tool.** A cheap pack we cannot ship is worth nothing.

## RULES FOR THE ANSWER

**LABEL EVERY CLAIM.** Mark each as **DOCUMENTED** (a published source — name
it), **INFERENCE** (your reasoning, and say from what), or **NOT FOUND** (you
looked and there is no published figure — this is a good answer and we want it
explicitly).

**PRICES AND COUNTS MUST BE REAL OR MARKED NOT FOUND.** A fabricated pack price
or a made-up variant count would go straight into a purchase decision. If you
cannot verify a price, say the pack exists and the price is NOT FOUND.

**LEAD WITH THE TOTAL CUE COUNT AND THE CHEAPEST ROUTE TO IT.** One line at the
top: *N distinct cues, M total files once variants are counted, cheapest viable
route ≈ EUR X.* Everything else follows underneath.

**DO NOT RECOMMEND A SINGLE WINNER AND DROP THE OTHERS.** Rank the routes and say
what each costs and what it gives up. The decision is the operator's and they
make it from your table.

## Owned files — the collection target

This agent has **no checkout and cannot push**. The deliverable is real
regardless: Claude collects the answer and writes the file below. Naming it here
is what lets `python Tools/agent_comms.py done --task J22` mean *"has this been
collected yet?"* rather than passing on nothing.

- `research/J22_WHAT_A_FIGHT_SOUNDS_LIKE.md`

**The agent is not asked to create it and must not be given a git command.**
