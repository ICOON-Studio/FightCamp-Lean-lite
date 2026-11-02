# TASK G139 - GROK - THE FENCE CLINCH: WHAT HAPPENS WHEN ONE MAN PINS THE OTHER ON THE CAGE (S102)
Owner: grok (Expert mode, never Build). Assigned 2026-09-27 (S102). Deliverable: one markdown answer, which Claude saves
as `research/G139_THE_FENCE_CLINCH.md`.

## Why
G138 found the fence clinch is the largest block of MMA clock our engine does not model: most of the 15-18% clinch
share is one man pinning the other on the cage, and it is where most stuffed shots and many takedowns start. Our engine
has one generic standing clinch. Before we build a fence state we need its real numbers and its real branches.

## What would a human do?
A wrestling/MMA coach who charts fights (and a FightMetric coder) splits the fence clinch by who holds which position
(over-under, double underhooks, head-and-arm, single-leg on the fence), times how long each lasts, counts what is thrown
from it (knees, short elbows, dirty boxing, stomps), and records how it ends: takedown (which one), separation, reversal,
referee break for inactivity. The defender's craft is the wall-walk and the underhook turn. Answer as that coach would.

## Prefab check
Any published position-transition dataset (FightMetric/Sportradar position fields, academic MMA transition matrices,
wrestling analytics sites) - name it, its licence and whether its numbers are public.

## Questions (tables, grade every figure S sourced / P proxy / J judgement, cite)
1. Duration of a fence clinch in UFC (median / typical range) and how often the referee separates for inactivity.
2. The main grips/positions on the fence and their share; which one the attacker wants.
3. What is landed from it per minute (knees to body/thigh, short elbows, punches, stomps) vs open-clinch and distance.
4. How it ends, as a share: takedown (by type - double off the fence, single, trip, body-lock), separation by the
   defender (underhook turn / frame off), reversal (defender pins attacker), referee break, finish.
5. Takedowns that land off the fence vs in open space (share of all UFC takedowns), and how often the defender
   wall-walks back up within 30 s.
6. Does weight class or sex change any of the above materially?
7. For a simulation: the smallest state machine (states + transitions + per-transition rates) that would reproduce
   these numbers. Name what can be deferred.
