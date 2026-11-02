# TASK G144 - GROK - HOW A SKILL GAP MOVES THE GROUND (S113)
Owner: grok (Expert mode, never Build). Assigned 2026-09-27 (S113). Deliverable: one markdown answer, which Claude
saves as `research/G144_GROUND_SKILL_GAPS.md`. Fresh chat.

## Why
G142 (back control) and G143 (guard, half, side, mount) gave per-second hazard tables for an AVERAGE UFC pair. Our
fighters are never average and never identical: a BJJ black belt on top of a kickboxer is not the same seat as two
wrestlers. The engine needs to know how much a grappling skill gap moves each hazard - passes, sweeps, stand-ups,
submission locks and finish-given-lock - so the tables scale by the two men's grappling instead of being one number.

## What would a human do?
An MMA grappling coach and a FightMetric analyst: the coach knows an elite guard player sweeps and submits from
bottom far more, and a wrestler stands up from bottom rather than playing guard; the analyst can show it in numbers
(takedown defence and control time by grappling pedigree, submission rates of BJJ black belts vs wrestlers in the UFC,
ADCC / IBJJF pass and sweep rates by belt or tier, per-fighter sub attempts per 15 min).

## Prefab check
Name any dataset that splits ground outcomes by grappling pedigree or skill tier (UFCStats per-fighter sub attempts and
control time, ADCC / IBJJF stats by division or belt, BJJ Heroes records, academic papers on grappling experience and
MMA outcomes), its licence, and whether its numbers are public.

## Questions
1. Per seat (back, mount, side, half, guard - top and bottom): which hazards move most with a grappling skill gap, and
   by how much (a multiplier per 20 points of skill difference on a 0-100 scale is the shape we want)?
2. Style, not just level: wrestler vs BJJ player vs striker on the bottom - which exits each prefers (stand-up vs
   sweep vs submission from guard), as multipliers on G143's Stage A rows.
3. Finish given a locked submission: how much does the attacker's skill vs the defender's move it?
4. Caps: the most extreme multiplier that is still realistic (an elite grappler vs a pure striker), so a sim never
   produces a 100% sweep rate.
5. Acceptance: the fight-level numbers a census of MIXED pairs should hit (e.g. sub rate of BJJ-pedigree winners,
   control time of wrestlers) - name the source for each.
Grade every figure S (sourced) / P (proxy) / J (judgement). Return ONE markdown artifact named G144_GROUND_SKILL_GAPS.md.
