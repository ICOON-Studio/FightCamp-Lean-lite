# G70 — NAMED GRIP ANCHORS ON THE HEAD AND NECK

**Owner:** Grok. **Research mode, never Build.** Pure design — no checkout, no
Godot, no code that imports anything. Deliver a memo plus one self-contained
module if you want to express the map as data.

## THE SITUATION, IN FULL — THIS IS ALL THE CONTEXT YOU GET AND ALL YOU NEED

A fighter in our engine is a set of **capsules**: a segment between two bone
positions, a radius, and a hemispherical cap at each end. A grappling hold is
satisfied when a hand can be placed on a target capsule without that hand
entering another capsule of the same body.

**The neck has been unreachable for weeks, and four attempts to fix it have now
failed.** The neck capsule is about **0.06–0.08 m long with a 0.055 m radius**
— it is squat, and it is buried between the chest capsule's upper cap and the
head volume's lower ball. Three variants of a rule that shortened those
neighbours were measured yesterday on two rigs and **all three were refused**,
because they did not clear the neck, they deleted it.

One of our researchers, asked for the fix, offered a second model alongside it
and we never followed it up. Her words:

> - **one continuous neck capsule** for the collision and blocking volume, so a
>   limb cannot pass through the neck whatever the grip, plus
> - **three or four named anchor points** on the head-neck surface as grip
>   targets, mapped to typed move requirements.

**That is your task: design the anchor set.** It sidesteps the whole geometric
fight — a named anchor does not have to be "exposed" on a swept sphere, it has
to be *reachable from the directions the hold actually comes from*.

## WHAT THE HOLDS ACTUALLY NEED

These three must be **distinguishable**. If they resolve to the same anchor, the
engine cannot tell them apart and the model has failed:

- **Collar tie** — upper-posterior neck and the base of the skull. Taken from
  the front, the hand coming over and behind. Usually one hand, sometimes two
  (**double collar tie** / Thai plum).
- **Rear naked choke** — mid-posterior neck, the forearm across the front of the
  throat, taken from behind.
- **Guillotine** — anterior neck at laryngeal level, higher up, the opponent's
  head down and the arm under the chin from the front.
- **Front headlock** — include it; decide yourself whether it is its own anchor
  or a collar tie variant, and **say which and why**.

## WHAT TO DELIVER

**1. The anchor set.** Three or four anchors, each with:
- a **name** (an identifier, lower_snake_case, that code can use),
- **where it is**, expressed as a position on the head-neck axis — a fraction
  from the base of the neck to the crown, plus an aspect (anterior / posterior /
  lateral),
- the **approach cone** it can be taken from: a direction and a half-angle, in
  degrees. This is the part that matters most. A collar tie comes from in front
  and above; a rear naked choke from behind and level. **An anchor with no
  approach constraint is just a point and buys nothing.**

**2. The map from hold to anchor**, one row per hold, including which hand and
whether it is one hand or two.

**3. The refusal rule.** When should a hold be refused outright rather than
approximated? Be specific: what geometric condition, checked against what.

**4. Argue against yourself.** The strongest case that named anchors are the
WRONG model here — that they are a hand-authored lookup table pretending to be
geometry, that four anchors will not survive the fifth hold anyone adds, or that
the approach cones are numbers nobody measured. **Name your own weakest point
unprompted.** On this project the self-objection half of a brief has produced
the shipped answer three times, and the converged answer was better than every
option the agents were offered.

## CONSTRAINTS

- **No preloads, no imports, no `res://` paths.** If you express the map as
  code, it must be a single self-contained file that runs with nothing else
  present.
- **Do not give yourself a repo test command.** You have no checkout and cannot
  run our suite; that is expected and it is not a limitation on this task.
- **Angles and fractions, not metres.** Our rigs are two different statures and
  anything you give in absolute metres will be wrong on one of them.

## HOW TO SAY YOU DO NOT KNOW

If an approach cone has no source behind it, **say it is an estimate and say
what would measure it**. A number presented as measured when it was chosen is
the one failure mode that costs us a whole cycle — we have retracted four
findings to it. An honest estimate, labelled, is worth more.
