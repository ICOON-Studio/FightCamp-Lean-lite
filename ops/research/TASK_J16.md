# TASK J16 — JOHN — CAN A GYM BE GENERATED FROM REAL FLOOR PLANS, AND MAY IT BE?

Deep research only. One deliverable file. No code, no test, no repo commands.
Owner: john. Task id: J16.
Deliverable: `J16_THE_GYM_FLOOR_PLAN.md`

## The idea, in the operator's own words

We build and run a **gym** in this game (never a "camp" — a fight camp is only
the pre-bout preparation). The operator wants to know whether we can design our
gyms from real MMA gym floor plans, using boards like this as the inspiration:

    https://www.pinterest.com/ideas/mma-gym-floor-plan/950830226557/

and specifically: **is it plausible to take blueprints out of PDFs and build a
gym GENERATION module from them?**

That is the question. Answer it with sources, and answer the legal half first,
because it is the half that can stop the whole thing.

## 1. THE GATE: WHAT MAY WE ACTUALLY USE?

This project has a standing rule that ripped assets never ship, and we would
rather find out now than after we build.

- Pinterest is an **aggregator**. The plans on that board are somebody else's
  drawings, re-posted, usually without the original source attached. What is the
  realistic provenance of images on a board like that?
- **Are architectural floor plans copyrightable, and in what sense?** Separate
  the drawing from the layout. In the US the Architectural Works Copyright
  Protection Act covers architectural works, and there is case law on what
  counts as protectable expression versus unprotectable functional arrangement.
  What is protected — the DRAWING, the BUILDING, or the ARRANGEMENT OF SPACES?
- **Where does that leave FACTS?** "A boxing ring needs a 6-foot apron clearance",
  "a mat room wants 40 square feet per training pair", "reception sees the door"
  — are those facts free to use even when we learned them by reading a plan?
- Are there **public-domain, openly-licensed or purchasable** floor plan sources
  for gyms and sports facilities? Government or municipal facility plans,
  university recreation centre plans, standards bodies, architectural firms that
  publish sample plans under a usable licence, paid plan libraries with terms
  that permit derivative commercial use.

**Give us a clear verdict on what is safe**, and say plainly if the answer is
"you may not trace these, but you may absolutely use what they teach you".

## 2. WHAT IS ACTUALLY IN AN MMA GYM, AS RULES RATHER THAN AS A PICTURE

This is the part we expect to be most valuable, so spend the most effort here.
A generator needs constraints, not drawings. From real facilities and from
whatever design guidance exists:

- **The spaces.** What rooms and zones does a real MMA / boxing gym have? Cage,
  ring, mat area, heavy bag row, strength floor, cardio, changing rooms, showers,
  reception, office, storage, physio/medical, sauna, pro-shop, spectator space.
  Which are essential, which are optional, which mark a gym as serious?
- **The numbers.** Square footage or square metres for each — per station, per
  member, or absolute. A cage is a known diameter; a ring is a known size; a
  heavy bag needs a known swing radius; a mat area is sized per pair. **Give real
  figures with sources.** These numbers are the generator's parameters and they
  are the single most useful thing this document can contain.
- **The adjacencies — what must be next to what, and what must never be.**
  Changing rooms next to showers; reception seeing the entrance; the mat area
  away from the free weights; noise separation; sightlines for a single coach
  supervising. Adjacency is how procedural layout algorithms are actually driven,
  so this list is directly load-bearing.
- **Total size bands.** What is a small gym, a mid-size gym, a flagship? Give
  ranges in square metres AND in members served, so a generated gym can scale
  with the player's business.
- **What changes by discipline?** A boxing gym, an MMA gym, a BJJ academy and a
  wrestling room are not the same building. Say how they differ.

## 3. IS PDF-TO-GEOMETRY ACTUALLY PLAUSIBLE?

The operator's specific technical question. Be concrete and sceptical:

- What is really inside a floor-plan PDF — **vector paths, or a scan of a
  drawing**? What is the realistic split in the wild, and how much of what is
  on a Pinterest board is a low-resolution raster with no geometry at all?
- For the vector case: what tools extract walls, rooms and dimensions, and what
  do you actually get out — clean polygons, or a soup of unlabelled line
  segments? How much manual cleanup per plan, realistically?
- For the raster case: what is the state of automated floor-plan recognition,
  how good is it, and what does it cost in effort per plan?
- **How many plans would we even need?** If a generator is driven by rules, the
  answer might be "none". Say so if so.

## 4. THE OTHER ROUTE, AND WE WANT IT COMPARED HONESTLY

Procedural floor-plan generation is an established field — graph-based layout,
treemap subdivision, wave function collapse, constraint solvers, and the
architectural-layout literature. **Games generate buildings all the time.**

Compare, as an engineering decision:
- **(A) Extract real plans from PDFs** and use them as data.
- **(B) Learn the rules** from those plans and generate from constraints.
- **(C) A hand-authored set** of a dozen good layouts that scale with the
  business, with no generation at all.

Say which you would pick and why, including the cost and the failure mode of
each. **Do not simply endorse the operator's framing** — if extraction is the
wrong route, say so and say what to do instead. If it is the right route, say
that too and tell us how to do it.

## 5. WHAT WE WOULD ACTUALLY SEE

A gym in this game is currently a set of numbers, not a room. If a generated
layout existed, what is it FOR — a top-down map the player reads, a set of
upgrade slots, a backdrop, a stat modifier? **Say what a floor plan buys a
management game that a list of facilities does not**, and be honest if the
answer is "not much" — that would save us a stage.

## The standing rule for your work

**Where you cannot source something, say "not found".** In J15 you reported that
knockdown frequency per bout was NOT FOUND rather than estimating it, and in J14
you overturned two rules we were about to ship wrong. That is the value. Do not
fill a gap with a plausible number here either — a square footage we invented
would propagate straight into a generator and look measured.

**Where a figure differs by source, region or code, say which** and give us the
common case as well as the spread.

## Format

One markdown document. Open with a **DECISIONS** block of at most twelve lines:
the legal verdict, the route you would pick, and the numbers we should build to.
Then the evidence. We read the top and act on it.

**Send the finished file back.** Name it `J16_THE_GYM_FLOOR_PLAN.md`.
