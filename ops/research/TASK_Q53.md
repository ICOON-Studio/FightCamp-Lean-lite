# TASK Q53 — QWEN — THE NUMBERS BEHIND THE TYPE

Model: qwen, medium effort. Owner: qwen.
Test tier: **RESEARCH — no `.gd` file is touched.** NO parse gate, NO test, and
do NOT run the suite. `git status -s` before you stage is the whole check.

## Owned files

- `research/Q53_TYPE_SCALE.md` — **NEW. You create it. Yours alone.**

Nothing else. Do not edit `HANDOFF.md`, any `.gd` file, or any other research
file.

## Why this exists

Q51 gave us the numbers for how a surface looks; Q52 gave us how it moves. This
is the third: how it reads. A material pass just landed and the surfaces are
right, which makes the type the next thing standing between our screens and a
commercial bar.

Our type system today is a ROLE system with **sizes only** — twelve, thirteen,
eighteen, twenty-one, twenty-three, thirty-two, thirty-eight px, two typefaces
(a condensed display face and a mono), and a hard floor: nothing renders smaller
than 12 px, because the operator ruled that fonts must always be clearly
readable. There is **no weight axis, no line-height, and no letter-spacing** in
the system at all. Every one of those is set ad hoc where it is set at all.

Same method as Q51 and Q52, and the same reason it is coming to you: **label
every answer `DOCUMENTED`, `INFERENCE` or `NOT FOUND`**, and a DOCUMENTED figure
carries its source URL.

## Q1 — The published type scales, in full

For **Material Design 3**, **Apple HIG** and **Microsoft Fluent 2**: the complete
type scale as a table. Every role, and for each one: size, weight, line-height
and letter-spacing, in the units the spec uses. MD3 publishes fifteen roles
(display/headline/title/body/label × large/medium/small) with all four values —
transcribe that table rather than summarising it.

## Q2 — Line-height, which we have none of

- What ratio of line-height to font size does each system specify, and **does the
  ratio change with size?** Our display face runs at 38 px and our body at 13 px;
  if the published ratio is constant, say so, and if it tightens as size grows,
  give the curve.
- Is there a documented figure for the **maximum line length** (in characters or
  ems) before readability falls off? We lay out in fixed-width panels and this
  decides how wide a text block may be.
- What do they say about line-height for a **single line** of text — a label, a
  value, a button — where there is no second line to space against?

## Q3 — Letter-spacing (tracking), which we also have none of

Our interface uses a lot of ALL-CAPS — section headers, labels, captions, button
text. This is the question that matters most here:

- **What tracking do the published systems specify for all-caps text?** Caps set
  at a body face's default tracking is the single most common way an interface
  looks amateur, and we do it everywhere. Give the figure, in em or in px at a
  stated size.
- Does tracking change with size? Most systems tighten large display type and
  open up small text — give the documented values per role.
- Anything documented on tracking for **mono/tabular figures**, which we use for
  every number in the game.

## Q4 — Weight, and what a dark background does to it

- The documented weight pairings per role: which roles are regular, which medium,
  which bold, and what numeric weights those mean.
- **Light text on a dark ground optically thickens.** Is there published guidance
  on compensating — using a lighter weight on dark than you would on light? This
  is a real effect and our entire interface is light-on-dark, so if it is
  documented we want the figure. If it is not, say `NOT FOUND` and give your
  INFERENCE.

## The shape of the deliverable

`research/Q53_TYPE_SCALE.md`. Tables, not prose. Finish with a section
headed **"THE SPEC WE SHOULD ADOPT"**: one table mapping OUR existing role names
(label 12, body 13, header-bar 18, name 21, value 23, value-large 32, headline
38) to a weight, a line-height in px, and a letter-spacing in px — plus a
separate row for all-caps versions of each, since that is how several of them are
actually used. That section is allowed to be INFERENCE; say so.

Keep it under 250 lines.

## Definition of done

- The file exists and every answer carries `DOCUMENTED` / `INFERENCE` /
  `NOT FOUND`.
- Q3's all-caps tracking figure is present and unhedged. It is the one that gets
  used first.
- `git add -- research/Q53_TYPE_SCALE.md`, commit, push.
- One line back:
  `python Tools/agent_comms.py send --from qwen --to claude --subject Q53-done --body "<sha> <all-caps tracking figure> <line-height ratio>"`

## The trap specific to Q53

**Do not recommend a single size change.** Our sizes are settled and the 12 px
floor is an operator ruling, not a default — a report that opens by suggesting
smaller labels is answering a question nobody asked and will be discarded. The
three axes we are missing are weight, line-height and tracking. Give us those
against the sizes we already have.
