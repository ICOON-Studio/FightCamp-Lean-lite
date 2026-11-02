# TASK G44 — GROK — WHAT DOES A FIGHT MANAGER ACTUALLY DO WHILE THE FIGHT IS ON?

Model: Grok, **Expert** tier. Research only.
Assigned by Claude, 2026-09-10. Owner: grok.

Driven in the in-app browser by Claude. **No code. No GDScript. No tick loop, no
state machine, no module.** You have no checkout and no Godot; do not ask for
one and do not write anything that would need one. Your output is prose, and
Claude splices it verbatim.

## The gap, stated honestly

FightCamp is a fight-**management** game. The fight itself now runs on a seeded
20 Hz simulation: it decides distance, impacts, damage by body region, fatigue,
knockdowns, grappling seats, submissions, and the judges' cards. It is
authoritative and it is deterministic. The player watches it happen.

**And that is the problem.** Our existing fight screen lets the player intervene
in exactly one way — a "combo incoming, react?" prompt that pauses the fight —
plus a between-rounds corner window. Both were built for the older simulation,
which advanced in ~14-second lumps and therefore had obvious places to stop.

The new engine has no lumps. It has 20,400 ticks and no natural pause. So before
we port the intervention surface, we should stop and ask the question we never
asked: **what should a manager be doing during a live fight at all?**

We do not know. That is a design gap, and it is yours.

## The question

**What does a fight-management player actually DO during a live fight — in
shipped games, and in the real sport?** And what should they do in ours?

## §1 — THE SHIPPED RECORD

Name real games and say what the player's hands are doing during a bout. Be
specific about the *verb*, the *cadence* and the *cost*, not the vibe.

Cover at least these, and add any you know:

- **Boxing / MMA management sims**: Title Bout Championship Boxing, World
  Boxing Manager 2, Boxing Manager (Astragon), MMA Manager 2, Ultimate MMA
  Manager, Iron Fist Boxing, Punch Club (it is not a manager but its fight
  layer is exactly this question), Fight Camp / boxing-gym mobile titles.
- **The adjacent management genres that solved this first**: Football Manager's
  touchline (shouts, tactical tweaks, subs — and its *Instant Result* button),
  Motorsport Manager's pit wall (tyres, fuel, engine mode, driver instruction —
  the strongest analogue we have, because it is a real-time sim you nudge),
  Out of the Park Baseball, Wrestling Empire / TEW booking, Blood Bowl coaching,
  Battle Brothers / auto-battler "you set it up then watch" designs.
- **Where the player watches and cannot act at all**, and whether that shipped
  well.

For each: **what can the player change mid-event, how often, and what does the
game charge them for it?** A verb with no cost is a button players mash.

## §2 — THE REAL SPORT

What a corner **actually** does between and during rounds. This is research, not
invention — cite what you find.

- The **60-second corner window**: what a real cornerman says and does, in what
  order, and how much of it is information versus instruction.
- What a corner can do **during** a round: shouted instruction, and what
  fighters report actually reaching them under fire.
- The **cutman**: a genuinely mid-fight, hands-on, consequential job with real
  tools and real rules, and the one corner role with a physical outcome we could
  model.
- **Throwing in the towel / asking for a stoppage.** A real decision with a real
  cost, made under pressure and often too late. This may be the single most
  interesting verb available to us.
- Corner **rule limits**: who may be in the corner, when they may enter, what a
  commission forbids. If our game lets a manager do something a real corner
  legally cannot, we should know we are choosing that.

## §3 — THE CADENCE PROBLEM, WHICH IS THE REAL ONE

Our engine ticks 20 times a second and a three-round fight is 20,400 ticks. The
screen will present it in gathered beats, not tick by tick.

- **How do the games in §1 handle the pacing of a decision?** Does the sim pause
  and wait (a modal), does it run on while a menu is open, does it queue an
  instruction that applies at the next natural boundary, or does it only ever
  ask between rounds?
- Which of those **feels** like managing and which feels like a QTE? Say which,
  and why, with named examples.
- Is there a published or widely-reported answer on **how often** a management
  game may interrupt a spectacle before the spectacle stops being one? If it is
  shop talk rather than a measured or documented figure, **mark it unsourced** —
  do not build a policy on folklore. (Your G42 did this correctly with the
  "±20% playback is invisible" claim and it was the most useful line in the
  paper.)

## §4 — THE SHORTLIST

Six to ten candidate verbs for OUR game, ranked. For each, one line each on:

- **What the player does** (the actual input).
- **When it is available** (any tick? only between rounds? only when a condition
  the engine already emits is true?).
- **What the engine would have to expose** for it to work. Our engine already
  emits, per impact: the actor, the target, the body region, the force, the
  contact quality, the wear, whether the man is shocked, whether he went down,
  and any cut or swelling with a severity count. Between rounds it closes a
  round and hands cards to judges. **Prefer verbs that read facts we already
  have.**
- **What it costs the player** — and if a verb has no cost, say so, because a
  free verb is one players will spam.
- **Whether it is honest.** Our standing rule from your own G42: the player may
  be shown an exchange but never a *different* exchange. A verb that lets the
  player change what already happened is out.

## §5 — THE REFUSALS

What should we explicitly **not** build, and why? Name the traps by name. I
expect at least: turning the manager into the fighter (a control scheme), a
mid-fight ability bar, anything that makes the deterministic seeded card
non-reproducible, and any verb that only exists to give the player something to
click. Be blunt, the way §4 of G42 was.

## §6 — THE ONE-SENTENCE CALL

If you had to pick **one** verb to build first, which, and why. One sentence,
then at most one paragraph defending it.

## Deliverable

One markdown research paper. Claude splices it into
`research/G44_WHAT_A_MANAGER_DOES_MID_FIGHT.md`, writes the header and the
HANDOFF block, and changes nothing else. Cite your sources inline the way G42
did; a claim with no source gets marked unsourced or dropped.

**Length: as long as it needs to be and no longer.** G42 was excellent because
every section paid for itself.

## The one trap specific to G44

**Do not answer "let the player pick the game plan before the fight."** We have
that; it is the fight plan, and it is settled. The question is strictly about
the minutes while two men are actually fighting, when the plan has met an
opponent and the seeded engine is already running.
