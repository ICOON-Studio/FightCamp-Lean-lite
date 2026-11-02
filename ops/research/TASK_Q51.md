# TASK Q51 — QWEN — THE NUMBERS BEHIND "IT LOOKS EXPENSIVE"

Model: qwen, medium effort. Owner: qwen.
Test tier: **RESEARCH — no `.gd` file is touched.** NO parse gate, NO test, and
do NOT run the suite. `git status -s` before you stage is the whole check.

## Owned files

- `research/Q51_ELEVATION_AND_MATERIAL.md` — **NEW. You create it. Yours alone.**

Nothing else. Do not edit `HANDOFF.md`, `CURRENT_STATUS.md`, any `.gd` file, or
any other research file.

## Why this exists

Our interface kit (`Godot/scripts/UIKit.gd`) builds every surface from ONE
recipe: a flat fill, a 1 px dark border, and a 2 px black drop shadow at 35%
opacity offset 2 px down. Twelve cards on a screen therefore weigh exactly the
same and there is no focal point. We are about to add a material and elevation
layer centrally.

**The ground we are drawing on is DARK** — `#1c2230`, a lit blue-grey. Panels sit
on it at `#2a3347`. Our instinct is "add bigger drop shadows for the hero card",
and we suspect that instinct is wrong on a dark ground, because a black shadow on
a near-black surface is close to invisible. We need the DOCUMENTED answer before
we build, not after.

You are answering four questions. **Label every single answer `DOCUMENTED`,
`INFERENCE` or `NOT FOUND`**, exactly as you did in Q47, Q48, Q49 and Q50 — that
labelling is why this task is going to you. A number you reasoned out is
INFERENCE even when you are confident. A number you read in a published spec is
DOCUMENTED and must carry its source URL.

## Q1 — The published elevation ladders, as numbers

For each of **Material Design 3**, **Apple HIG**, and **Microsoft Fluent 2**:
what is the documented elevation ladder? Give every level with its real figures —
blur radius, y-offset, x-offset, shadow colour and opacity, and (where the system
defines one) the ambient/key two-shadow split. A table per system.

Also record what each system says the LEVELS MEAN — which level a page
background, a resting card, a raised card, a dialog and a menu get. We want the
mapping, not only the numbers.

## Q2 — THE ONE THAT MATTERS: what changes on a DARK surface

This is the question the stage actually turns on.

Material Design 3 is understood to handle elevation on dark themes with a
**surface tint / lightness overlay** rather than with shadow, on the stated
grounds that shadows do not read on dark grounds. **Confirm or refute that from
the published specification**, and if it is real, give the numbers: the overlay
opacity or the surface-colour value at each elevation level, and whether shadow
is dropped entirely or kept alongside.

Then answer directly, with figures: **on a dark UI, how much LIGHTER should a
surface get per elevation step?** Express it two ways — as an alpha-over-white
overlay percentage, and as an absolute lightness delta in HSL L or in perceptual
terms. Say whether the published systems agree with each other.

If the published systems do not answer it, say `NOT FOUND` and then give your
own INFERENCE with the reasoning shown.

## Q3 — Gradient, bevel and sheen: what a "material" surface is made of

Published guidance, not taste. On a card-based dark dashboard:

- Is a **vertical gradient** on a panel fill documented anywhere as a system
  rule, and if so what delta top-to-bottom (as a percentage of lightness)?
- Is a **top highlight line** (a 1 px lighter inner edge along the top) a
  documented device? What opacity?
- What do the systems say about **border colour on a dark surface** — a lighter
  hairline (a rim) versus a darker one (an outline)? Which reads as raised?
- Is there any documented figure for **corner radius** scaling with surface size
  or elevation? Ours is a flat 3 px everywhere.

## Q4 — What Godot 4.x can actually draw

The three we need settled before a line is written. Godot **4.7** (answer for
4.3+ and say if 4.7 differs):

1. Can `StyleBoxFlat` fill with a **gradient**? Yes or no, with the doc page.
2. Can `StyleBoxFlat` give each side a **different border colour**? It has
   `border_width_top/bottom/left/right` — does it have per-side colour, or one
   `border_color` for all four?
3. If a `Panel` node draws its background from a `StyleBox` theme override, and
   you assign a `ShaderMaterial` to that `Panel`'s `material` property, **does
   the shader affect the StyleBox's drawing?** And does that material leak onto
   the Panel's CHILD controls, or do children draw unaffected unless they set
   `use_parent_material`?

For each: `DOCUMENTED` with the URL, or `NOT FOUND` plus your INFERENCE.

Also list, briefly, the canonical Godot ways to get a gradient panel background
(`GradientTexture2D` in a `TextureRect` overlay, `StyleBoxTexture`, a
`ShaderMaterial`, a `NinePatchRect`) with the one-line trade-off of each.

## The shape of the deliverable

`research/Q51_ELEVATION_AND_MATERIAL.md`. Tables, not prose. Every figure
labelled and sourced. Finish with a section headed **"THE SPEC WE SHOULD ADOPT"**
that gives, as a single table, a five-step ladder for OUR dark ground — for each
step: the fill lightness delta, the shadow (or "none"), the border treatment, and
what kind of surface gets it. That last section is allowed to be INFERENCE; say
so.

Keep it under 250 lines. A short sourced table beats a long essay.

## Definition of done

- The file exists and every answer carries `DOCUMENTED` / `INFERENCE` /
  `NOT FOUND`.
- Q2 and Q4 are answered without hedging. Those two decide what gets built.
- `git add -- research/Q51_ELEVATION_AND_MATERIAL.md`, commit, push.
- One line back:
  `python Tools/agent_comms.py send --from qwen --to claude --subject Q51-done --body "<sha> <one-line answer to Q2> <one-line answer to Q4.3>"`

## The trap specific to Q51

**Do not answer Q2 from the general knowledge that "dark themes use lighter
surfaces".** We already believe that. What we do not have is the NUMBER, and a
number you half-remember is worse than `NOT FOUND`, because the whole kit will be
built on it and every screen in the game inherits it. If the spec gives a table
of surface values per elevation level, transcribe the table. If it does not, say
so plainly and mark your own figure INFERENCE.
