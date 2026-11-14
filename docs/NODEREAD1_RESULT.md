# NODEREAD1 Result

Probe run: 2026-11-14T03:47:20. n=300 bouts/cell, 4 opponents.

## Question

Which of the 16 MoveTree.NODES does the bout actually read? A node the bout does not read
makes TREEVALUE1 void (S450: a probe reading the same in both arms is void).

## Plan

Arrows from PlanFight.ANSWERS best/ok lists:

- step_back
- pivot_out
- tie_up
- roll_out (when: loadup)
- push_off (when: press)
- 1-1-2 (when: press)
- 2-3 (when: range)
- 1-2-3b (when: range)
- 1-6-3 (when: counter)
- slip 2-3 (when: loadup)
- 3b-3 (when: tiring)

## Method

BASE: all 16 nodes at 65. For each node: same seeds with ONLY that node at 0, then at 95.
For punches, combos containing that punch are also set to the same value.
READ = yes when any opponent's win% moves >= 1.0 between 0 and 95.

## Result

**NODEREAD read=6 unread=step_in,step_out,step_back,pivot_out,tie_up,roll_out,feint,cut_off,herd,push_off**

| Node | Branch | Read | Diffs |
|------|--------|------|-------|
| Jab | lead | yes | 1126 |
| Lead hook | lead | yes | 815 |
| Cross | rear | yes | 1108 |
| Body hook | rear | yes | 799 |
| step_in | footwork | NO | 0 |
| step_out | footwork | NO | 0 |
| Check hook | lead | yes | 76 |
| Uppercut | rear | yes | 750 |
| step_back | footwork | NO | 0 |
| pivot_out | footwork | NO | 0 |
| tie_up | defence | NO | 0 |
| roll_out | defence | NO | 0 |
| feint | footwork | NO | 0 |
| cut_off | footwork | NO | 0 |
| herd | footwork | NO | 0 |
| push_off | defence | NO | 0 |

## What the bout reads (evidence)

f["moves"] (punch mastery): weapons_edge (BoutRules), PlanFight.can_do/choose, card_mean.
f["combos"] (combo mastery): FireLevel.mastery_of/fires, setup, card_mean, LineGrade.
f["steps"] (step/defence mastery): NOT read in LiveRound.gd.
