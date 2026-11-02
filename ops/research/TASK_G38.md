# TASK G38 — GROK — WHAT A GROUND FIGHT LOOKS LIKE TO THE VIEWER

Model: **Grok, Expert (deep research).** Owner: Grok. Research only — no code,
no repo, no test command. Deliverable is one markdown file, printed **inline
in the chat as raw markdown**; Claude commits it.

---

## Why this is being asked BEFORE it is needed

R91 is about to make grappling real in the live fight: seats advancing per
tick, control accruing, submissions finishing. The moment it lands, the game
will be **producing** ground fighting and **unable to show it.**

Everything we have for the live read was built for striking:

* `FightHudPanel` — a heart rate with a zone, and trauma as discrete pips.
* `BroadcastRead` — the commentary line over the impact stream.
* `RealtimeRoundStats` — the adapter onto the judges.

None of them has a vocabulary for *a man in half guard working to pass*. A
striking HUD watching a ground fight shows two bars that barely move and a
commentary line that says nothing — which reads as **broken**, not as quiet.

**This is forecast research: the question is assigned before the build stalls
on it.** A question put to the operator is a research task that was not
assigned in time.

## What you already own and must not re-derive

* **`G34_GRAPPLING_CONTRACT.md`** — yours. §1 events, §2 seats and the
  control-unit table, §8 the five counters. Settled.
* **`G35_REFEREE_AND_METHODS.md`** — yours. The fifth method and the stall clock.
* **`G37_THE_ADAPTER_FOLD.md`** — yours, 2026-09-10. The per-ruleset
  conversion, and the refusal of a 1-D UWW step-out. Settled.
* **`R85R_UNDISPUTED_HUD.md`** — the first-hand read of Undisputed that gave
  us the heart rate and the discrete trauma pips. That is the house standard
  for a live read; match its level of specificity.

The engine's live state, so you need not guess: `stance` (standing / clinch /
ground), `seat` (none / over_under / guard / half / side / mount / back),
`top` (fighter id or -1), plus control units accruing at 0, 1 or 2 per scoring
tick, and the five counters.

## What to answer

1. **How do real broadcasts show ground position?** UFC, ONE, IBJJF streams,
   judo at the Olympics. What is on screen during a grappling exchange —
   position name, a control clock, a submission-threat indicator, nothing at
   all? Sourced to actual broadcast practice, with the year, and say plainly
   where different broadcasters disagree.

2. **How do the best fighting GAMES show it?** UFC 5, EA's older titles,
   Undisputed, Fight Night's clinch, and any grappling-first game worth
   naming. **Separate what is DIAGNOSTIC (a submission minigame's own UI) from
   what is AMBIENT (a position label, a control meter).** We want the ambient
   layer; we are not building a minigame.

3. **The control clock — is a running timer the honest display?** Our
   `control_score` is an integral of 0/1/2 units per tick. Broadcasts often
   show "ground control 2:14". Is that the same quantity? If a duration and a
   weighted integral disagree, say which one a viewer actually understands,
   and whether showing one while scoring the other would mislead.

4. **The submission threat.** G37 §3 said an IBJJF advantage is derivable
   without a new event, and flagged an optional `submission_threat` event.
   **From the viewer's side: does a live read need a threat signal at all, or
   is the attempt enough?** If it needs one, say what the viewer must be told
   — who, what hold, how close — and at what cadence.

5. **THE RECOMMENDATION.** One concrete design for the live read of a ground
   fight, in the shape a build task can be typed from: what appears, where,
   at what cadence, and **what deliberately does NOT appear.** Say which
   existing surface each element belongs on — `FightHudPanel`,
   `BroadcastRead`, or a new one — and if you propose a new surface, justify
   why neither existing one can carry it.

6. **What a ground fight should SOUND like in commentary.** `BroadcastRead`
   emits a line over the impact stream. Ground fighting has long quiet
   stretches punctuated by sudden transitions. **What does the line say during
   ninety seconds of nothing?** Silence is a legitimate answer, and if it is
   the answer, say how the UI signals "deliberately quiet" rather than "hung".

## The thing that will be wrong if you get it wrong

**Do not design a submission minigame.** The fight is a simulation the player
watches and corners; it is not a QTE. If your recommendation requires player
input during a grapple, you have answered a different question.

And the standing rule: **a published fact replaces an authored one; a
population claim never does.** "Fans find ground fighting boring" is an
opinion unless you can source it. Where you are inventing — and design
recommendations ARE invention — **label it as invention in as many words**,
the way G34 labelled `technique_multiplier`.

## What good looks like

G34, G35, G36 and G37 are the bar and all four are yours. G36's shape in
particular: a verdict table up front, sourced detail per question, an explicit
REFUSE list, and ready-to-paste blocks at the end. Close with:

* **A one-screen spec** of the ground-fight read: every element, its source
  field, its cadence, its surface.
* **An explicit REFUSE list** — every broadcast or game convention you looked
  at and rejected for us, and why. A refusal is a finding.
* **At most two open questions for the operator, each with a default
  recommendation.** If you can decide it, decide it.

## Deliverable

**ONE file: `G38_THE_GROUND_FIGHT_READ.md`.** Nothing else. You have no
checkout and no Godot — write no GDScript beyond small const or dictionary
blocks and expect to run nothing. **Print it inline as raw markdown; do NOT
attach it as a document**, because an artifact's text cannot be read out of
the page and you will be asked to reprint the whole thing.

## The trap specific to this task

**The honest answer may be that a ground fight should look QUIETER, not
busier.** The instinct when a screen looks empty is to add meters, and that
instinct produced exactly the failure this project keeps paying for: three
separate features that were correct, tested, and could never run, because
nobody asked whether the pieces could line up. If the sourced answer is that
broadcasts show almost nothing during a scramble and let the position label
carry it, **say that** — and say what the player is meant to feel during the
quiet. An emptier design you can defend beats a dashboard nobody reads.
