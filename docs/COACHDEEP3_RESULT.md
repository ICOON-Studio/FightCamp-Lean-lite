# COACHDEEP3 - deep coaches v3: bouts pay by rank, falling class nights, the coached combination, style areas (S540)

Task: ops/research/TASK_COACHDEEP3.md. Map: ops/research/DESIGN_COACHDEEP3.md. Probe: tools/coachdeep3.gd + rules copy
tools/coachdeep3_rules.gd (built from coachdeep2). Nothing under scripts/ changes.

## 1. What is probed
COACHDEEP2's setup unchanged (docs/COACHDEEP2_RESULT.md s1: the TEST CLUB, 104 weeks, YOU + Reid + one candidate of five,
2 club sizes = 10 cells, arms LAZY / STAT / CHEM / NEXT / STAR / SMART / CLASS, controls CHEMOFF, ALL_REID / ALL_X, NOHIRE,
the same score in lines and the same departure pricing) with the map's M1-M4:
- M1: each boxing bout pays the club by her place on her regional table at the bout ($450 unranked, $700 ranked 4+, $950 2-3,
  $1,200 number 1). Her ladder points move by LadderRep.change against the opponent's (LadderPoints.rep_of seed); her place =
  RankLine order against her division's rivals (Career.quick_start rows; they do not box each other in the probe). Her next
  year (the departure price) is valued at her band's pay. Leaving.REP_LEAVE_RANKED for a top-5 leaver (Leaving.RANKED_TOP).
  The grappler's bouts pay the unranked $450 (no boxing table).
- M2: class nights pay and pull members at CLASS_RETURN [1, 1, 1, 0.5, 0...].
- M3: her style's combination drilled only on coached places (half chain, half its weakest punch), named as the go-to;
  BoutRead.clear_cache before each bout (its key does not read own_combos).
- M4: stat pace by style, defence coached half pads half tactics; SMART reads the same.

## 2. Bars (written before any run, not loosened)
COACHDEEP2's nine, word for word (docs/COACHDEEP2_RESULT.md s2), with that page's (h) clarification:
- (a) No single assignment rule is the best arm (by score) in more than 6 of the 10 cells.
- (b) Chemistry moves an outcome by a line (cash $1,000, reputation 3, win less loss 0.5, or morale 5; best arm v CHEMOFF,
  paired) in at least 5 of the 10 cells.
- (c) The right coach differs by boxer (ALL_REID v ALL_X per boxer: at least one boxer prefers each coach) in at least 5 cells.
- (d) The best arm beats LAZY by at least one line of score in at least 5 cells.
- (e) Every effect counted in (b), (c), (d), (h), (i) is larger than 2 standard errors (paired); inside 2 errors does not count.
- (f) (f1) a departure is charged only by game items, the probe prints the mean price and its parts; (f2) in at least 8 of 10
  cells the best arm loses no more boxers than LAZY + 0.10 a career.
- (g) CHEM is the best arm in at most 5 of 10 cells with (b) passing; size by the sweep (1.0 / 0.6 / 0.4 / 0.25, 10 reps,
  the largest with CHEM best in at most 5), the full run at that size is the verdict.
- (h) In the best arm's sampled trade weeks (every 8th; mirror direction when it already runs classes), the class is right
  (> 2 errors) in at least a third AND the boxer is right (< -2 errors) in at least a third.
- (i) Some candidate's best HIRE arm beats the best NOHIRE arm by > 2 errors in one club size and not in the other; and in at
  least one size some hire pays.
Plus the money bar (the task):
- (j) The best plan keeps its ranked boxers: in at least 8 of 10 cells the best arm loses at most 0.10 boxers a career who were
  on the regional table (rank > 0) when they left.
PASS = all ten. Before the verdict, mode=evening measures the coached evening in wins (M3: "measure it in wins first").

## 3. Measured so far (no verdict yet)
Raw files sit in the S540 worker's scratchpad: evening.txt, smoke_full.txt, sweep.jsonl.
- M3 evening in wins (mode=evening, 12 reps, nobody leaves so both arms fight the same opponents; coached on every asked place
  (ALL_REID, ~3.5 places a boxer a week) v never coached, 26 bouts each):
  | Boxer | v2 drill: win chance a bout / wins | v3 combination: win chance a bout / wins |
  |---|---|---|
  | Lucy | +0.119 ± 0.001 / +3.3 ± 0.4 | +0.294 ± 0.002 / +6.1 ± 0.6 |
  | Kira | +0.107 ± 0.002 / +3.5 ± 0.4 | +0.261 ± 0.002 / +7.6 ± 0.7 |
  | Josh | +0.052 ± 0.001 / +1.1 ± 0.3 | +0.184 ± 0.001 / +3.3 ± 0.6 |
  So the coached evening is worth 2.5-3.5x what it was in v2. That is about +0.05 to +0.08 win chance a bout for each weekly
  place, well past a stat decimal. No size changed.
- Full-mode smoke (2 reps, 131 s, 0 script errors): the probe runs end to end; nothing is read from it.
- Chemistry sweep (bar g, 10 reps): size 1.0 -> CHEM best 7, STAT 2, CLASS 1; size 0.6 -> CHEM 6, CLASS 2, STAT 2. Sizes 0.4 and
  0.25 were not reached: Claude Code stopped the run because the PC ran critically low on memory, with two other jobs
  (NIGHTREDS1, TURNPRO16) also in the Godot queue. Not restarted, per the stop note.

Next: when the PC is GREEN, run `mode=sweep reps=10`, then `mode=full reps=30 hreps=12 size=<picked>` (~22 min on a free PC)
through godot_slot, one run at a time. Then the verdict goes here: PASS queues CRITIC_COACHDEEP3_BRIEF for kalli and dola; FAIL
lists what to change.
