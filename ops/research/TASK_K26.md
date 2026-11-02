# TASK K26 — KALLI — WHAT A REAL FIGHT ROSTER LOOKS LIKE

**Model: Kalli, Expert / deep research. Study only — no code, no art, no test.**
Owner: Kalli. Assigned 2026-09-10 by Claude.

You have no checkout and no Godot. Everything you need is in this file. Do not
ask for the repository, do not ask to run anything, and do not write GDScript.
Return the document as plain markdown; Claude commits it as
`research/K26_THE_REAL_ROSTER.md`.

## The defect this fixes, and it is ours, not yours

We generated twelve 3D fighters — four boxing, four MMA, four bare-knuckle, six
men and six women across the weight classes. They were measured carefully
(chest-to-waist ratios, arm cross-sections, skin saturation) and every number
was right.

**Then somebody finally looked at them, and all twelve are white or
light-Mediterranean.**

That is not a stylistic decision anyone made. It is what the generation prompts
produced when nobody specified, and nobody checked. It is a straightforward
authenticity failure about the two sports this game is actually about, and it
cannot be fixed by retexturing — it has to be fixed in the prompt, before the
next generation pass.

**So the study is not "should we add diversity." It is: what does a real
professional roster in these sports actually look like, so the prompts describe
the sport instead of defaulting.**

## What to deliver

### §1 — The actual composition, by sport and division, with sources

For **professional boxing** and **professional MMA**, describe the real
population of ranked fighters: nationality and region of origin, and how that
varies **by weight class** — because it does, strongly and interestingly, and
that variation is the part a generic answer will miss.

Work from published, checkable material: governing-body and sanctioning-body
rankings (WBC / WBA / IBF / WBO, and the independent ratings), major promotion
rosters, Olympic and amateur qualification data. **Cite what you use and give
the date you read it**, the way this project's other studies do.

Say plainly where the men's and women's games differ — participation is not
distributed the same way, and a roster half of which is female should reflect
the women's sport rather than a mirror of the men's.

### §2 — The weight-class story

The single most useful section. Heavyweight boxing, flyweight boxing, MMA
lightweight and women's strawweight are **not** drawn from the same populations,
and a roster that ignores that reads as wrong to anyone who follows the sport
even casually. Give the pattern per division, with the reason where a reason is
documented (national programmes, amateur systems, regional traditions).

### §3 — What a plausible TWELVE looks like

Ours is twelve: `m box welter`, `m box heavy`, `f box fly`, `f box middle`,
`m mma light`, `m mma lhw`, `f mma straw`, `f mma bantam`, `m bare welter`,
`m bare heavy`, `f bare feather`, `f bare welter`.

For each slot, say what a *representative* fighter would plausibly be —
region of origin, and the physical characteristics that follow — and say which
of our twelve slots our current roster gets most obviously wrong. **This is the
section the prompts get written from, so be concrete.**

Bare-knuckle is its own case and a small one: say honestly whether it has a
distinct population or is too young and too regionally concentrated to
generalise about. "Too small to say" is a real answer here.

### §4 — Names

A generated fighter needs a name that belongs to the person. Say what naming
conventions follow from §3 — and flag where a name would be a cliché rather than
a representation, because a roster of stereotypes is a different failure from a
roster of defaults, not a fix for it.

### §5 — What you would NOT change

The half that pays. This is a management game where a fighter is seen on a
profile screen and, soon, at gameplay camera distance in 3D. Say which of your
findings would actually be visible and which is depth nobody sees — the same
call the operator made on corner rules, where genuine per-jurisdiction
differences were deliberately collapsed into one authored rule because no player
picks a state athletic commission.

## The trap

**Do not write us a diversity policy, and do not write a quota.** The
deliverable is a description of a real sport, sourced, with its actual
variation — including the places where a division genuinely *is* dominated by
one or two national traditions, which is a fact about the sport and should be
said as one. A roster that is accurate is the goal; a roster that is evenly
distributed would be a different kind of wrong, and would fail the same
authenticity test our current twelve fail.

Second trap: **cite or say you could not.** This project's standing rule is that
an invented figure which looks sourced is worse than an admitted gap, because we
build on it. If you cannot find current ranking data for a division, say so and
describe what you could find instead.

## Deliverable

One markdown document in your reply. No files to push, no git, no test command —
you have no checkout, and none of those apply to you.
