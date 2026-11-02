# TASK K34 — KALLI — HOW NBA 2K MOVES FROM ONE ANIMATION TO THE NEXT, IN ITS DEVELOPERS' OWN WORDS

Model: Grok Bot (Kalli), research. Owner: kalli. Stage: S4a (d) part 3, forecast research for R5 (the joins).

**Research only.** No code, no downloads, no game files. Prose, numbers, citations. One pass. Reply in this chat.

## Why this exists

Our fighters' animations are correct one at a time, but the JOINS between them move faster than the
performances do (our realism test measures joints turning up to 2.8x faster at a join than inside any clip).
The operator pointed at NBA 2K26 as a game whose transitions look natural. Its code and data are protected
and closed, so we want what its developers (Visual Concepts / 2K / Take-Two) have PUBLISHED about how they
move a player from one animation to the next - and the numbers, if they gave any.

## What we already hold - do NOT re-research, cite only if you extend or correct

- Inertialization / dead blending: Bollo, Gears of War 4, GDC 2018; Unreal's rule "keep it under 0.4 s, do
  not inertialize between very different poses". Engine default blends (Unity 250 ms, Godot 0).
- Motion matching basics (Clavet, Ubisoft, GDC 2016) - and we have ruled motion matching OUT at our scale.
- No boxing/MMA game publishes its blend lengths (our J19 and G57).

## What to find - one table row per finding

1. **2K's own gameplay blogs (the yearly "Courtside Report" series, NBA 2K22-2K26):** what they say about
   transitions between animations - dribble-move chaining ("combos", "size-ups", signature styles), stopping
   and changing direction, collisions and contact animations, shot starts and landings, "momentum", foot
   planting, anything named ProPLAY or motion matching. Quote the mechanism in one sentence each; give any
   number (frames, milliseconds, animation counts).
2. **Talks** by Visual Concepts or 2K engineers/animators (GDC, Animation Summit, SIGGRAPH, interviews on
   animation tech): title, year, speaker, the transition technique described.
3. **Patents** assigned to Take-Two Interactive, 2K or Visual Concepts on animation blending, transition
   selection, pose matching or collision animation: patent number, title, year, and the method in two sentences.
4. **Any published timing** for a sports game's transitions (any studio, any sport): a stop, a cut, a collision
   reaction, a move-to-move chain - with its source.

## Rules

- Label every row: **DOCUMENTED** (read in the primary source), **SECONDARY** (an article quoting it), or
  **NOT FOUND**. NOT FOUND is a valid answer - never fill a cell with a guess or a forum rumour. No leaked
  or datamined material: published sources only.
- Every row: the finding, the source (title, author or studio, year, URL or patent number).

## Deliverable

One markdown table per section (1-4), columns: Finding | Mechanism or number | Label | Source. Then a short
**GAPS** list, and one closing paragraph: which published technique would most plausibly make a punch -> hit
reaction -> guard sequence read as natural, and why.

## Owned files

- `research/K34_NBA2K_TRANSITIONS.md` - Claude writes it from the reply; Kalli pushes nothing.
