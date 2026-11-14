# PICKSPREAD1 Result

Probe run: 2026-11-14T18:15:00. Godot 4.7.2 headless. 60 fighters x 5 picks = 300 PICK lines; 865 cards shown; 57040 bouts; 1061.8 s.

## Method

Fighters are TREEVALUE's AttrGen seeds 7100-7159 at their generated day-0 moves/steps (the all-45 sweep fixture has no open cards). Combos start at TREEVALUE's 45. Opponent ratings are calibrated by TREEVALUE's 7-step bisection against the all-45 BASE: { "Maria Ortega": 50.91796875, "Priya Nair": 52.76953125, "Erin Doyle": 52.46484375, "Dana Whitfield": 52.640625 }.
Each pick asks LearnSlots.cards(f, opp_style, {}); opp_style rotates through the four OPPS styles by fighter. LearnSlots returns up to three open cards; a shorter list is measured as returned, never padded with a phantom card. Each card is copied, picked with LearnSlots.pick, studied six weeks, then fought 16 bouts against each OPPS (64 per card). Steps/defences use StudyWeek.week; punches use PadWeek.drill on the usual three pad nights. The career continues down card 0. FireLevel is on (GAME_SHARES).
One bout is 1/64 = 1.5625 percentage points of a card's four-style win share (<2). Equal win shares split best credit equally; the PICK line prints the first tied position. Gates: no position best >0.6; coach first best <0.5; no node best >0.4 of the picks it appears in.

## Shares

| Measure | Share | Gate |
|---|---:|---|
| Position 0 best | 0.2922 | <= 0.6 |
| Position 1 best | 0.3406 | <= 0.6 |
| Position 2 best | 0.3672 | <= 0.6 |
| Coach first card best | 0.2922 | < 0.5 |
| Max node best (Body hook) | 0.6647 | <= 0.4 |
| Pivot shown among all cards | 0.1121 | report |

| Node | Shown | Best credit | Best share |
|---|---:|---:|---:|
| roll_out | 90 | 11.000 | 0.1222 |
| tie_up | 128 | 16.500 | 0.1289 |
| step_back | 112 | 18.000 | 0.1607 |
| push_off | 35 | 6.000 | 0.1714 |
| pivot_out | 97 | 19.333 | 0.1993 |
| Check hook | 60 | 23.167 | 0.3861 |
| Jab | 3 | 1.333 | 0.4444 |
| Uppercut | 117 | 60.833 | 0.5199 |
| Cross | 18 | 9.833 | 0.5463 |
| Lead hook | 39 | 23.667 | 0.6068 |
| Body hook | 166 | 110.333 | 0.6647 |

**PICKSPREAD pass=0 why=node_best_max>0.4**

The pick is not a real choice yet on these 300 six-week roads. The failed gate is node_best_max>0.4; the strongest node signal is Body hook at 0.6647 of its appearances. LearnSlots gives +3 for answering the opponent's style, +2 for completing a style set, and up to +2 for opening other nodes; equal scores fall back to the tree's order, and weeks-to-Usable is only a label. It never scores expected wins, so a card can look sensible and still not be the road that wins more; punches also change the weapons the bout reads, while a step mainly changes whether its planned line fires.

## Claude (S473, collecting)
- Dice: 64 bouts a card is about +-6 points on a share, not the brief's "under 2" (one bout = 1.6 points is the step, not
  the noise). The gap it found is far bigger than that: punches best 52-66 % of their picks, steps and defences 12-20 %.
- Meaning: on these roads a footwork or defence card is almost never the winning pick - the same hole TREEVALUE1 found
  (steps read by few bouts). The pick is not a real choice until a step's six weeks are worth wins against the style it
  answers. Goes to the progression design (STEPMASTERY1: steps the bout reads) before any pick-card screen is built.
