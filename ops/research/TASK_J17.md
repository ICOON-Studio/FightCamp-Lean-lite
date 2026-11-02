# TASK J17 — JOHN — HOW MANY STRIKING CLIPS DOES A SHIPPED GAME ACTUALLY USE?

Research only. No code, no repository access, no test command.
Owner: john. Deliverable: `research/J17_THE_CLIP_COUNT.md`.

## Why this exists — and it is a spending decision, not curiosity

We are about to buy animation clips. Our stage director defines a **purchase
list of exactly ten roles**: idle, strike_head, strike_body, strike_leg,
react_head, react_body, react_leg, block, slip, knockdown. Clips cost roughly
0.2 credits each, once, for all twelve fighters — cheap enough that the risk is
not overspending, it is **buying the wrong ten**.

Two of those ten are already suspect and you do not need to re-derive it:
a **block clip would essentially never play** (0.2% of presented strikes), and
**leg strikes come out of a boxing bout** because our target picker is
ruleset-independent. So the real question is what the list should have been.

## The question

1. **The count.** For shipped fighting and fight-management games — the boxing
   and MMA ones especially, but any title with a presented strike — how many
   distinct striking animations does a single fighter actually carry? Give
   ranges and name the titles. Distinguish, if the sources let you:
   - the *minimum* a fight reads acceptably at, and
   - what a full-price title actually ships.
2. **Reach variants — the multiplier question.** When the simulation says a
   punch lands at a distance the animation does not cover, do shipped games
   carry **multiple versions of the same punch at different reaches**, or do
   they carry one and adjust it (IK, warping, scaling playback)? **This is the
   load-bearing question**: reach variants multiply our purchase by three or
   four, and adjustment does not.
3. **Reactions versus strikes.** What is the ratio? Does a game carry as many
   hit-reactions as it does strikes, more, or far fewer?
4. **The knockdown.** How many distinct down/getting-up animations does a
   boxing game carry, and is the count driven by *where* he was hit or by *how
   hard*? Your own J15 listed twelve filmable downed body states — does any
   shipped title actually distinguish that many, or is the real number two or
   three?
5. **What is reused.** Which of the ten roles do shipped games satisfy by
   reusing another clip rather than authoring a new one — is "block" its own
   animation or a pose blended over the idle? Is "slip" a clip or a procedural
   head offset?
6. **The tell we can act on.** If you find one, name the **cheapest set of
   clips that reads as a fight** — the smallest list a title got away with —
   and say which title.

## Constraints and standards

- Cite sources: developer talks (GDC), postmortems, animation-team interviews,
  datamined asset lists, modding documentation, published animation budgets.
- **Say NOT FOUND where it is not found.** J15 and J16 were valuable precisely
  because they marked their gaps; a fabricated clip count would send real money
  in the wrong direction. Studios rarely publish this, and "the industry does
  not publish this" is a legitimate finding we can plan around.
- Do not recommend a vendor or price anything — C75 already costed the sources.
- Do not propose an implementation and do not write GDScript.

## Deliverable shape

`J17_THE_CLIP_COUNT.md`, with a **DECISIONS** section at the top: short,
typeable lines Claude can act on without reading the body — the recommended
clip count, whether to buy reach variants yes/no, the reaction:strike ratio,
and the knockdown count. Body and citations below it.

Land it the way you landed J15 and J16 (your own `research/` deliverable
plus a `CLAUDE_LAND_NOTE_J17.md`). **Do not edit `HANDOFF.md`** — Claude writes
your block.
