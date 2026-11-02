# TASK G138 - GROK - WHERE AN MMA FIGHT ACTUALLY SPENDS ITS TIME, STATE BY STATE (S101)
Owner: grok. Assigned 2026-09-27 (S101). Sourced research, no code. Grade every figure SOURCED (link) / PROXY /
JUDGEMENT. Two pages at most, tables welcome.

## Why
The fight engine models three stances (standing, clinch, ground) and six seats (clinch over-under; ground guard, half,
side, mount, back), plus scrambles, knockdowns and referee stand-ups. The operator asked whether that covers everything
in an MMA fight. It does not. Missing: one man down and the other standing (up-kicks, wall-walking back up on the
cage), turtle / front headlock / standing back control, clinch variety (Thai plum, single collar, body lock, underhook
battles on the fence), more ground seats (north-south, knee-on-belly, crucifix, butterfly, leg entanglements), and
fouls (eye poke, groin, fence grab, point deduction, DQ, no contest). Before building any of it we need to know how
often each happens, so the new states are weighted by the real fight, not by what is fun to animate.

## What would a human do?
An MMA analyst (FightMetric / UFC Stats, the Fightnomics author Reed Kuhn, coaches who chart fights) watches a bout
with a stopwatch and codes each second: distance, clinch (against the cage or open), ground (by position, top/bottom).
Look for that coded time-share data first, then position-transition data (what a failed takedown turns into).

## Prefab check
Look for READY DATASETS before hand-coding: UFC Stats / FightMetric per-fight control time and position stats,
Kaggle UFC datasets (licence each), Fightnomics tables, published time-motion studies (Miarka, Del Vecchio). Say which
exists, its licence, and whether it gives per-state time directly.

## Questions
1. Time share of a Unified-rules MMA bout (UFC or comparable): distance / clinch / ground, and inside clinch the share
   against the cage. Men and women separately if the data allows. Weight classes if it differs.
2. Inside ground time: share by position (guard, half, side, mount, back, north-south, knee-on-belly, turtle, crucifix,
   leg entanglement). Top vs bottom.
3. How often per fight: knockdowns, one-man-down-other-standing sequences (and how long they last), wall-walks / stand
   ups against the cage, front headlock / turtle after a failed shot, back takes from standing, Thai-plum clinch, leg
   lock attempts.
4. What a stuffed takedown turns into (a transition table: back to distance / clinch on the cage / front headlock /
   turtle / guard pulled), with rates.
5. Fouls: eye pokes, groin strikes, fence grabs per fight; point deductions and DQ / no-contest rates per 100 bouts.
6. One recommendation: which THREE missing states to build first, by share of fight time and by how often they decide
   a fight.

Deliver the answer here in chat; Claude collects it into `research/G138_MMA_FIGHT_STATE_TIME_SHARE.md`.
