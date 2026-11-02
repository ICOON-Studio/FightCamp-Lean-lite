# TASK_G74 — GROK — THE VENUES: DESIGN THE ARENAS THE FIGHTS HAPPEN IN

**Research and design. No code, no repo, no test command.** You have no checkout
and you do not need one. The deliverable is a document.

**Research mode / Expert. NEVER Build mode.**

---

## WHAT THE OPERATOR ASKED FOR, IN HIS WORDS

> *"design/redesign named and other arenas (mma/box/bjj) for the game — look for
> pdf blueprints (pinterest has a lot of real arenas) — i want them in the game,
> all options are available for cinematic-quality graphics"*

"All options are available" is the licence: assume we can build whatever you
specify. Do not trim your ambition to what you imagine our renderer does. Say
what the shot should look like and we will work out how.

---

## WHAT ALREADY EXISTS — DO NOT REDO ANY OF IT

**The fighting surfaces are DONE, measured, and sourced to published clauses.**
Re-deriving them would waste your whole pass. `Godot/assets/data/arena_specs.json`
carries eight presets in metres, each with the rule clause beside it:

`boxing_ring_fl_min`, `boxing_ring_fl_max`, `mma_ring_abc_20ft`,
`muaythai_ring_ifma`, `mma_cage_abc_18ft`, `mma_cage_gym_6m`,
`mma_cage_ufc_30ft`, `mma_cage_ufc_25ft`

and `mat_specs.json` carries `judo_ijf`, `karate_wkf`, `wrestling_uww`,
**`bjj_ibjjf`**, `taekwondo_wt`. The file's own note says *"every dimension is a
published figure with its clause beside it; nothing here is authored"* — and it
flags that **colours are the exception**, because a colour is a design choice
and not a measurement.

**So the ring, the cage and the BJJ mat are solved. Your job starts at the edge
of the canvas and goes outward.** If you find a published dimension we have
wrong, say so — that is valuable — but do not spend the pass re-listing sizes we
already hold.

---

## THE JOB — THE VENUE, NOT THE SURFACE

Everything above and around the fighting surface, which today is **flat grey
walls and no crowd**. A capture from the live room this morning shows a correct
chain-link cage standing in an empty grey void.

### 1. THE TIER LADDER — this is the most useful thing you can give us

This is a **career game**. A fighter starts somewhere small and ends somewhere
enormous, and the venue is how the player FEELS that progression. Give us a
ladder — I would guess four to six rungs, but that is your call — and for each
rung:

- what the room actually is (a gym hall? a leisure centre? a casino ballroom? an
  arena? a stadium?)
- capacity, and the footprint in metres
- **seating geometry**: how close is the front row, how steep is the rake, is
  there floor seating, is there an upper tier
- lighting: house lights up or down? Is the crowd lit or black?
- what the fighter walks out of and through
- production: how many cameras, is there a big screen, is there a truss
- **the ONE thing that most says "this rung and not the one below"** — the
  single cue a player would read in half a second

### 2. THE NAMED VENUES — and read the licensing note below first

Design a set of flagship venues the game can be proud of. For each: its
identity, why it looks the way it does, its palette, its light, and what a
cinematic establishing shot of it contains.

### 3. LIGHTING AND CAMERA — and this is urgent for a reason

We have a real, current defect here. `FightCameraRig` has a small table of
shots (`establishing`, `tight`, `standing`, `low_mat`) and the operator has
already rejected one recording because *"the head was not visible on either
fighter"*. Today's capture cropped both heads again on the shot that exists to
prevent exactly that.

So specify, for a venue:
- the **key light** — where is it, how hard, what colour temperature? Overhead
  truss is the honest answer for a cage, but say so and say what it does to
  faces and to the mat.
- what stops the fighters being lit like two men in a car park
- **the camera positions a broadcast actually uses**, and their heights and
  lens choices. Hard-cam, corner cams, the low mat cam, the overhead. Give
  heights in metres and horizontal FOV in degrees; we can convert.
- **the shot that must never be used**, and why

### 4. THE CROWD

Density, distance, whether faces are ever visible, whether it moves, and what it
costs to fake convincingly. Say what the cheapest crowd that does not look cheap
actually is.

### 5. BUILD ORDER

Rank what to build by **visual gain per unit of work**. If there is one element
that takes an empty grey void to "this is a real event", name it and put it
first. This ranking is the part we will act on soonest.

---

## THE LICENSING LINE — READ THIS, IT CONSTRAINS "NAMED"

**Regulation dimensions and venue geometry are FACTS and we may use them
freely.** A 30-foot octagon with a 6-foot fence is a published specification. A
seating bowl's rake angle is a measurement.

**Names, logos, liveries, mat graphics, signage and distinctive trade dress are
NOT.** "UFC", "Octagon" as a trademark, a specific promotion's canvas artwork, a
real arena's name and branding — we cannot ship those, and a fight game that
does is asking for a letter.

**So: use real venues as REFERENCE, and design ORIGINAL venues.** Take the
sightlines, the rake, the truss layout, the light, the sense of scale — and give
us our own names, our own liveries, our own palettes. Where you cite a real
venue, cite it as a reference for a measurable property, not as a thing to copy.

**If you think this line is drawn in the wrong place, argue it.** You are better
placed than I am to know what fight games actually ship, and a well-argued case
that we are being over-cautious is worth having. But argue it explicitly rather
than quietly ignoring it.

---

## ON SOURCES — AND PINTEREST IS THE OPERATOR'S STARTING POINT, NOT THE CEILING

He is right that Pinterest has a lot of real arenas and it is a good way to find
the LOOK fast. But for anything dimensional there are better sources and you
should go get them:

- **Venue technical / rigging packs.** Most large arenas publish a technical
  specification PDF for event promoters — rigging grids, truss capacities, floor
  plans, seating charts with capacities per configuration, loading dock access.
  These are public, they are PDFs, and they are the actual blueprints.
- **Commission rules** for the surface and the apron — already largely in our
  specs, but check.
- **Broadcast production guides** for camera positions.
- Architecture and stadium-design references for rake angles and sightline
  geometry (the C-value / sightline standard is a real, published thing).

**Say which of your numbers are measured and which are your judgement.** Mark
every one. A design call is welcome and expected; a design call wearing a
measurement's clothes is the thing this project has been burned by repeatedly.

---

## WHAT TO SEND BACK

A document, structured as above. Tables where tables help. Be concrete — "warm
key from a 12 m truss at roughly 35 degrees off vertical" beats "dramatic
lighting".

Then two sections that matter as much as the design:

**ARGUE AGAINST YOURSELF.** Take your own build order and attack it. What is the
strongest case that the thing you put first is the wrong thing to build first?
On this project that section has repeatedly produced a better answer than the
recommendation did.

**WHAT YOU COULD NOT FIND.** A negative result is a result. If venue technical
packs turn out to be paywalled, or if no published source gives a rake angle,
say so plainly rather than estimating and letting it read as sourced.

---

## TRAPS

- **Do not re-derive the ring, cage or mat dimensions.** They are done and
  sourced. Start at the edge of the canvas.
- **This is MMA, boxing AND BJJ.** A BJJ event is not a small MMA event — it is
  often multiple mats running at once in a bright hall with no crowd darkness at
  all, and it should not look like a cage fight with the cage removed. Give it
  its own treatment.
- **Female fighters never fight males**, and the facility a fighter trains in is
  a **"gym"**, never a "camp" — a fight camp is only the pre-bout preparation.
  Venue naming should not muddle these.
- Do not design the UI or the HUD. Someone else owns that.
