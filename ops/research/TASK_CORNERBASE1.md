# TASK CORNERBASE1 - what the live corner is worth against a coach who reads the fight (S547)

Kind: probe (a measurement on real bouts; a rule for the coach's own call written first; nothing under scripts/ or
tests/ changes). Model: claude-opus-5-5. Discipline: boxing (demo path). Seat: Claude worker in a console tab.
Estimate: 3-4 hours, most of it bout runs (the full run is about 77 minutes on one slot).

## Why
CORNERCMD2 (`docs/CORNERCMD2_RESULT.md`, 138,600 bouts): a player who reads the moment and calls the corner wins
+14.6 (3 rounds) and +22.2 (6 rounds) bouts in 100 more than PLAN ONLY. The owner is deciding the future of the plan
screen on that number (board Q-328). But PLAN ONLY's corner call is `BoutRules.auto_corner(stats)`
(`scripts/rules/BoutRules.gd` l.383): "long" when our boxer's technique is over her power, else "body" - from OUR
boxer's stats alone. It never reads the opponent (it says Go to the body against a man who loads up, the WRONG call:
`Exchanges.MODES`), and at 6 rounds it never rests a boxer who is at 0 wind. CORNERCMD2's own limits say so, and its
bar 8 failed twice because of it (a command held all bout beats PLAN ONLY by 10 to 20). So the +15 to +22 is the worth
of the live corner against a coach who is blind. The honest number is against a coach who does what any coach does.
The same blind call is what a player who SIMS a bout gets (`BoutNight.gd` l.128, `BoutRead.gd` l.216,
`BalanceHarness.gd` l.24, l.56).

## METHOD (quote in your first message)
- A WORKER'S NUMBERS CAN BE RIGHT AND ITS WHY WRONG: open the code lines first; prove a cause with an arm that cannot
  share the bug. CONTROL FIRST: with your new call switched off, the probe must reproduce CORNERCMD2's `full.jsonl`
  bout for bout on one cell before any new number is believed.
- MECHANICS NEED 8, PROBE FIRST. This is a measurement. No rule lands in the game here: the coach's call is written
  in `tools/` beside the probe's other local rules, exactly as CORNERCMD2 kept its commands.
- THE STOP RULE STANDS: no round 3 of the corner commands, no tuning of a command's numbers. The eight fight commands
  are as CORNERCMD2 left them. The two ring calls are OUT of every arm here (they measured +0; the owner's Q-330).
- NEVER TEST IDENTICAL FIGHTERS; name the population in the output. The three probe boxers grade alike (15 of 24
  grades OK): add TWO boxers who do not - one whose grades are mostly Poor, one mostly Good (build them by the same
  route TELLPLAY1 built its types, with a different training history; say exactly how) - and print every table per boxer.

## What the code says today (read before any run)
- `scripts/rules/BoutRules.gd` l.383 `auto_corner`; `scripts/rules/Exchanges.gd` l.124 `MODES` (each opponent game's
  best / ok / wrong call) and `EDGE`; `scripts/state/BoutNight.gd` l.77 (round 1 opens on no call), l.128.
- `tools/cornercmd2_probe.gd` (258 lines) l.90, `tools/cornercmd2_rules.gd` (482 lines) l.416-418: where PLAN ONLY
  takes its call; the arms, the cells, the reader. `tools/cornercmd2_sum.py`: the tables and the nine bars.
  Raw runs: `E:/FightCamp/tmp/cornercmd2/` (`full.jsonl` and the others; outside the repo).
- `docs/CORNERCMD2_RESULT.md` sections "Bar 8", "Bar 5", "Honest limits", "Reproduce".

## The steps
0. CONTROL: copy the probe to `tools/cornerbase1_probe.gd` (and its rules to `tools/cornerbase1_rules.gd`; both stay
   under 500 lines - share by preload, do not paste). With the new call off: the presser at 3 rounds, Lucy and Samira,
   70 bouts each, PLAN ONLY and the reader -> the same 280 outcomes as CORNERCMD2's `full.jsonl`. Stop if not.
1. THE COACH'S CALL, written as a table BEFORE any run, in `ops/research/DESIGN_CORNERBASE1.md`: three coaches.
   - BLIND: today's `auto_corner` (the control).
   - FILE: before the bout the coach reads the opponent's file as the game shows it (his style, what scouting has
     found - not the engine's hidden truth) and picks the call that is best against that style's most common game;
     between rounds he rests a boxer under a wind line (pick the line from the wind numbers CORNERCMD2 printed, say
     which) with Reset, and says Hands up when she was hurt in the round. One call a round, never by the exchange.
   - FILE + SKILL: the same, but the coach is right about the opponent's game only as often as his own rating allows
     (use the coach's rating the game already has, 58 in CORNERCMD2; a weak coach 35, a strong one 80: three levels).
   Every rule names the code line it reads. Nothing here may read a value the player's own screen does not show the
   coach's side of (no peeking at the exchange's mode before it is played: that is the READER's edge).
2. THE RUN: the ten cells, 3 and 6 rounds, five boxers, 70 bouts a boxer and cell, arms: BLIND, FILE, FILE+SKILL at
   35 / 58 / 80, the READER (eight commands, no ring), and the best fixed pair. One-rep trial first (see Feedback
   loops). Split the sweep with `only=` / `cells=`, each part to its own file; ONE Godot process at a time.
3. THE TABLES (`tools/cornerbase1_sum.py`): (a) reader minus each coach, wins in 100, +- 2 SE, per length, per boxer
   and over all - THE HONEST WORTH OF THE LIVE CORNER is reader minus FILE+SKILL 58; (b) each coach minus BLIND: what a
   player who sims would gain if the game's own call were that coach; (c) bar 8 again with FILE+SKILL 58 as the
   baseline (does any command held all bout still beat it by 10?); (d) bar 5 with five boxers (do they disagree on 4+
   commands now?); (e) the coach's rating: 35 v 58 v 80 - is a better coach in the corner worth wins when the player
   sims? (that is a hire the player can make: say what it is worth).
4. THE VERDICT, in plain words for the owner, four lines at most: what the live corner is worth against a real coach;
   whether a simmed bout should get the FILE coach (a recommendation with its number, NOT built here); whether the
   corner commands' three failed bars still fail on an honest baseline; what the coach's rating buys.

## Not allowed
No edit under scripts/ or tests/. No tuning of a command, an edge or a wind number. No ring call in any arm. No file
over 500 lines. Headless Godot only, through `python ops/Tools/godot_slot.py run --who CORNERBASE1 -- <command>`;
watchdog before each job (`powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1 -Once`; RED
= wait, read meanwhile). Long runs write to a file and end on a printed done line.

## Feedback loops
- The coach's call feeds the bout (the exchange's edge) and, in the game, the READ on the bout card (`BoutRead.gd`
  l.216 uses `auto_corner`): a better coach's call would move the card's win chance too. Not built here; say in the
  result which read lines would have to follow.
- The rest rule feeds wind, wind feeds "your boxer is tired" exchanges, those feed the rest rule: capped by the one
  call a round and the wind line; print the share of rounds each coach rests - if FILE rests in over half the rounds
  the line is wrong, stop and move it once, with the reason written.
- The coach's rating feeds how often he is right; nothing feeds the rating back inside a bout.
- One-rep trial: one cell (the loader), one boxer (Samira), 3 and 6 rounds, 20 bouts, all arms; stop if two arms print
  identical outcome strings (an arm that is not wired) or FILE is below BLIND against the loader (the rule is
  mis-read: the loader is the cell where BLIND's call is the wrong one).

## Prior research
`docs/CORNERCMD1_RESULT.md`, `docs/CORNERCMD2_RESULT.md`, `ops/research/DESIGN_CORNERCMD1.md`,
`docs/PLANWORTH1_RESULT.md`, `docs/TELLPLAY1_RESULT.md`, memory notes "Probe populations and bout dice (S533)",
"Long probes write to a file (S533)", "Corner worth is measured against a blind coach call (S547)". Run
`python ops/Tools/prior_research.py corner between rounds coach advice` and name the study the FILE coach's rules
follow (what real corners say between rounds). John was asked exactly that in S547:
`ops/research/CORNERREAL1_JOHN_JOHN.md` (seat queue SQ322) - if the file is there, the FILE coach follows its table.

## What would a human do?
A designer told "the corner is worth 22 wins in 100" would ask "compared with what?", sit a competent coach in the
other chair, and report the difference again.

## Prefab check
None to take: CORNERCMD2's probe, rules and summary script are the harness to reuse.

## Contract
OWNS: tools/cornerbase1_probe.gd, tools/cornerbase1_rules.gd, tools/cornerbase1_sum.py, ops/research/DESIGN_CORNERBASE1.md, docs/CORNERBASE1_RESULT.md
RED_TEST: tools/cornerbase1_probe.gd
REGRESSION: none under tests/ (nothing in scripts/ changes): the control arm of step 0 is the regression
VISUAL: none

## Result
`docs/CORNERBASE1_RESULT.md`: the verdict's four lines first; the control; the coach's table as written before the
run; tables (a) to (e) with +- 2 SE and per boxer; the share of rounds rested; the population (the five boxers and
how the two new ones were built); honest limits; how to reproduce. Commit ONLY your own paths with
`git commit -m "..." -- <paths>`; do not push; do not ask questions: decide, and write what you decided.
