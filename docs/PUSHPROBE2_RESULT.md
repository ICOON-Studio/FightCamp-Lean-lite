# PUSHPROBE2 result (S443): the fight bars measured through the game's real bout

Operator Q-S294-203: "Measure now". Then (S443): "yes add it to the measurement" (arm E, the corner minute in seconds with
neck ice). Design under test: `ops/research/PUSHTANK_MAP_V2_S442.md`. Brief: `ops/research/TASK_PUSHPROBE2.md`.

## Verdict against the pass line: FAIL, back to design

| Pass line (map v2 section 5) | 3 rounds | 6 rounds |
|---|---|---|
| No named habit is best in more than 6 cells of 10 (arm D) | **FAIL**: "Push while wind > 45" best in 14 of 19 | pass: "Push while wind > 55" best in 10 of 20 |
| The coach beats every habit by 3 points (arm D) | **FAIL**: the coach is 1.0 point BEHIND "Push while wind > 45" | **FAIL**: the coach is 1.6 to 2.4 points behind Steady + Hold and both Push-by-wind habits |
| "Push five, Save one" is gone in C and D | **PASS**: it was the best habit in 9 of 19 cells today; in C and D it is best in none and 4 points worse than "Push while wind > 45" | **PASS** (it already lost at 6 rounds today) |

In plain words: with the bars as designed, the right HANDS call is still one number. "Push while your wind is above 45,
otherwise steady" wins as many bouts as a coach who reads the score, the opponent, the hurt and the legs, at both lengths.
The coach's only real edge comes from the corner CALLS he shouts ("Go for the finish", "Tie up": +2 points), not from the
bars. FEET (Press / Hold / Move) never paid: pressing loses bouts and burns the legs; moving is the same as holding. The
switch fixes the old exploit (good), but it does not yet give the player a decision. Fail = back to design (map section 10).

## What was measured (and how)

- **Every punch, round, count and result is the game's.** `tools/pushprobe2.gd` plays each bout through
  `Bouts.fight_step` + `LiveRound` with the auto corner (as `tools/adapt_probe.gd` and `tools/ask_probe_honest.gd` do); the
  result is the game's own verdict (`BoutNight.outcome_of`). The probe only chooses the corner's call (the pace, the forward
  dial, a shout, the corner's recover points) and keeps the new bars' sums. Every NEW / ESTIMATE number of the map is a
  named constant in `tools/pushprobe2_rules.gd`. Nothing in `scripts/` or `tests/` was touched.
- **Paired dice:** bout i plays on career day 20 + i under every arm and policy, so one seed plays the same bout under every
  choice. Checked: arm D's code path with its new layers switched off and Hold everywhere gave the SAME result as today in
  20 of 20 bouts at both lengths, to the same head damage (the map's decision 1: Hold = today's place).
- **Population (printed by the probe):** our side two different fighters, Lucy Jackson (Out-boxer, orthodox, paper power
  59.9, stamina 56, chin 66) and Jo Brennan (Boxer-puncher, southpaw, power 59.7, stamina 61, chin 62), alternating bouts.
  Each cell has two fictional opponents: A orthodox at our paper power, B southpaw 1.5 higher, styled for the cell (body
  puncher, mover, slow starter, fader, swarmer, volume puncher). Film 1, no camp, morale 60.
- **Size:** 300 paired bouts a cell, not the map's 400: the pilot (one cell, 20 bouts, every arm) projected 400 at 116
  minutes, over the 90-minute cap. The run: 386,100 real bouts in 87.5 minutes. Noise: about 5 points on one cell's win
  rate, about 0.5 to 0.8 points on the paired differences over all cells (quoted as +- below, 95 %).
- **Cells:** the map's 17 cases as starting states (cases at a moment of the bout start there: rounds before are fought
  Steady + Hold, then the score / hurt / tiredness is set) plus the critics' missing ones: after a count, the opponent
  switching stance, the favourite. Case 17 (round 4 of 6) runs at 6 rounds only. 19 cells at 3 rounds, 20 at 6.
- **Arms:** A today (push / steady / save, Save refills 6 an exchange). B v1's switch (Push on / off, Save becomes the
  "Breathe" call). C HANDS only (Coast = save without the refill; a change in the round costs one of the two full shouts).
  D = C + FEET (Press / Move set the fighter's forward dial to 75 / 25), LEGS as a new bar, HEAD added per exchange, the
  opponent's own HANDS. E = D + the corner minute in seconds with neck ice.
- **Policies:** the named habits, "always Push", "Push five, Coast one" (Save in A, Breathe in B), and the COACH, who reads
  the case table from what the corner sees (score in rounds, wind, legs, hurt flags, the opponent's file), never the cards.
  "Coach, hurt = Coast + Move" is the boxing critic's version; "Coach without its calls" isolates the bars.

## Win % by policy (mean over the cells)

| Arm, length | Steady + Hold (today) | always Push | Push > 45 | Push > 55 | Push five, rest one | always Press | always Move | Push + Press | COACH | Coach, no calls |
|---|---|---|---|---|---|---|---|---|---|---|
| A, 3 rounds | 30.2 | 29.5 | 34.4 | 34.2 | **34.7** | | | | 35.5 | |
| A, 6 rounds | 32.7 | 21.1 | 33.1 | 33.4 | 27.4 | | | | 33.0 | |
| B, 3 rounds | 30.2 | 29.5 | 34.4 | 34.2 | **36.4** | | | | 35.0 | |
| B, 6 rounds | 32.7 | 21.1 | 33.1 | 33.4 | 29.3 | | | | 32.3 | |
| C, 3 rounds | 30.2 | 29.5 | 34.4 | 34.2 | 30.8 | | | | 34.7 | |
| C, 6 rounds | 32.7 | 21.1 | 33.1 | 33.4 | 22.7 | | | | 32.0 | |
| D, 3 rounds | 30.5 | | **36.0** | 35.4 | 31.6 | 28.7 | 30.6 | 28.9 | 34.9 | 32.4 |
| D, 6 rounds | 35.6 | | 36.0 | **36.3** | 26.1 | 30.5 | 34.3 | 20.5 | 34.0 | 32.0 |

(Win rates are low overall: at equal paper power both our fighters lose about two bouts in three to these opponents. The
comparisons are paired, so that does not move the differences.)

Which habit is best, cell by cell: A 3 rounds - Push five Save one 9, Push > 45 5, Push > 55 3, ties 2; B 3 rounds - Push
five Breathe one 14 of 19; C 3 rounds - Push > 45 12, Push > 55 5; D 3 rounds - Push > 45 14, Push > 55 3; D 6 rounds -
Push > 55 10, Steady + Hold 7, Push > 45 2, Move 1. (The two "ties" are cells 1 and 2, ahead 2-0 / behind 0-2 into the last
round of three, where no choice changes the result: 97 % and 1-2 % for everyone.)

## Arm D cell by cell (win %, 300 bouts each)

| Cell | Hold | Push>45 | Push>55 | Press | Move | Push+Press | P5C1 | COACH | Coach, hurt = Coast | | 6 rds: Hold | Push>45 | Push>55 | Press | Push+Press | COACH |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 Ahead into the last round | 97 | 97 | 97 | 97 | 97 | 97 | 97 | 97 | 97 | | 79 | 78 | 79 | 76 | 64 | 79 |
| 2 Behind | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | | 15 | 15 | 15 | 14 | 8 | 8 |
| 3 Level | 36 | 40 | 37 | 33 | 35 | 31 | 32 | 40 | 39 | | 42 | 40 | 41 | 38 | 24 | 37 |
| 4 Opponent hurt | 31 | 34 | 33 | 29 | 31 | 28 | 30 | 32 | 31 | | 34 | 32 | 33 | 27 | 17 | 32 |
| 5 Our fighter hurt | 30 | 31 | 32 | 27 | 29 | 25 | 28 | 36 | 34 | | 33 | 32 | 32 | 27 | 17 | 34 |
| 6 Body puncher | 25 | 31 | 30 | 20 | 26 | 22 | 27 | 30 | 30 | | 33 | 33 | 34 | 29 | 19 | 32 |
| 7 A mover | 26 | 31 | 32 | 28 | 23 | 30 | 28 | 35 | 34 | | 28 | 30 | 30 | 22 | 16 | 29 |
| 8 Their wind lower | 35 | 41 | 40 | 35 | 36 | 34 | 36 | 39 | 39 | | 38 | 39 | 39 | 33 | 22 | 36 |
| 9 Slow starter | 25 | 35 | 33 | 25 | 25 | 28 | 31 | 36 | 36 | | 31 | 34 | 33 | 26 | 18 | 31 |
| 10 Fader | 33 | 41 | 40 | 30 | 32 | 31 | 36 | 37 | 35 | | 34 | 35 | 36 | 28 | 17 | 30 |
| 11 Short fuse after a lost round | 16 | 20 | 19 | 15 | 16 | 14 | 18 | 19 | 19 | | 25 | 26 | 26 | 20 | 10 | 24 |
| 12 Drained by the weight cut | 25 | 28 | 29 | 21 | 25 | 16 | 22 | 26 | 26 | | 26 | 27 | 28 | 20 | 10 | 24 |
| 13 Close fight (steal the last 30 s) | 31 | 38 | 37 | 28 | 31 | 28 | 31 | 34 | 33 | | 34 | 35 | 35 | 27 | 16 | 32 |
| 14 Pinned (swarmer) | 29 | 39 | 38 | 24 | 32 | 30 | 33 | 36 | 35 | | 40 | 43 | 43 | 37 | 27 | 41 |
| 15 Underdog (a round already lost) | 13 | 19 | 18 | 12 | 13 | 13 | 14 | 16 | 17 | | 12 | 14 | 14 | 9 | 6 | 13 |
| 16 Two pushers, a war | 28 | 39 | 38 | 27 | 29 | 29 | 33 | 36 | 36 | | 40 | 42 | 42 | 36 | 24 | 38 |
| 17 Round 4 of 6 | | | | | | | | | | | 51 | 50 | 50 | 46 | 30 | 48 |
| After a count (critic) | 16 | 20 | 19 | 15 | 16 | 14 | 18 | 18 | 18 | | 25 | 25 | 26 | 20 | 10 | 22 |
| Opponent switches stance (critic) | 31 | 38 | 37 | 27 | 31 | 28 | 31 | 34 | 33 | | 33 | 34 | 35 | 26 | 16 | 32 |
| Favourite (critic) | 53 | 61 | 60 | 50 | 53 | 49 | 55 | 60 | 59 | | 58 | 58 | 58 | 52 | 38 | 58 |

The full table of every arm, length, cell and policy (win, stoppages, rest days, head, wind and legs at each bell) is the
`P2 ROW` lines of the log: `E:\FightCamp\tmp\s443\pushprobe2_full.log` (outside the repo).

## What the numbers say each choice does for the player

- **HANDS is still one number.** Push while the wind is above 45 (3 rounds) or 55 (6 rounds), else Steady, is the best
  habit almost everywhere and matches the coach. Push costs about 0.7 to 1 rest day after the fight (4.3 against 3.55 at
  3 rounds) and a little head; it never costs the bout. Pushing all fight is bad (21 % at 6 rounds against 33 %): the
  push fade below 55 already punishes it.
- **The old exploit is gone in C and D, but v1 moved it, it did not kill it.** Today "Push five, Save one" is the best habit
  in 9 of 19 cells (+4.5 points over Steady). v1's switch (B) folded Save into the "Breathe" call, and "Push five, Breathe
  one" became even stronger: best in 14 of 19 (+6.2 over Steady), because Breathe still refills 3 and is a good call when
  tired. Removing the flat refill from Coast (C, D) is what ends it: best in no cell, 4 points worse than Push > 45.
- **FEET gave no reason to choose.** Always Press loses 2 to 5 points against Hold and brings the legs under 50 by the
  round-3 bell in 54 % of bouts (Hold: never). Push + Press is the worst habit at 6 rounds (20.5 %). Always Move is the same
  as Hold (it changes where she wants to be only part of the time, see "not measured"). Move was best in one cell of 20.
  The map's sizing of LEGS held: Press + Push reaches the 30 line late in a 3-rounder (legs 41 at the third bell in the
  close-fight cell); Hold ends near 73; Move near 62.
- **HEAD per exchange:** under Steady + Hold the head at the last bell is lower than today (37.8 against 43.5 at 3 rounds;
  80.6 against 88.5 at 6), because the round's winner now takes some damage in the exchanges he lost and the loser less. The
  rest days under Hold did not move (3.55 both); the probe did not split head by who won each round.
- **A hurt fighter: Push + Move against the boxing critic's Coast + Move.** No difference the probe can see: -0.6 +- 0.3
  points over all cells, -2.3 +- 2.8 in the "our fighter hurt" cell. In the game the hurt flag lasts one exchange (it is
  rolled again after each one), so there is almost nothing for a hurt plan to act on. The critic's rule (a hurt fighter at
  Push takes 1.3x head) was on in D and changed nothing visible.
- **The coach's edge is the calls.** Coach minus the same coach without his shouts: +2.5 points at 3 rounds, +2.0 at 6.

## Arm E: the corner minute in seconds with neck ice

Every E policy fought on the coach's HANDS and FEET, with the same hands jobs (water 2 x 10 s, rib ice 15 s after 3 or more
body shots, the coach's talk 7 s); only the neck ice and the coach's shoulder rub differ. Constants (all ESTIMATE): ice
takes at most 15 % off the next round's wind drain, 15 % x (1 - e^(-seconds/20)); past 30 s, or iced two minutes running,
the next round's first 30 s lose 4 hand speed and 4 power unless the shoulders are rubbed (8 s); seconds out at 0:10.

| | never ice | always ice the whole minute | ice 30 s every round | COACH (20 s when it matters, rubs) |
|---|---|---|---|---|
| Win %, 3 rounds (19 cells) | 36.8 | **38.4** | 38.3 | 37.1 |
| Win %, 6 rounds (20 cells) | 35.6 | **38.1** | 37.7 | 36.1 |
| Head at the last bell, 6 rounds | 81.8 | 78.7 | 79.2 | 81.1 |
| Rest days, 6 rounds | 4.40 | 4.08 | 4.15 | 4.30 |
| Best ice habit in | 2 / 1 cells | **14 of 19 / 17 of 20** | 3 / 2 | |

**Cooling is not a chore: it changes results** (always ice: +1.5 +- 0.4 points at 3 rounds, +2.5 +- 0.4 at 6, beyond the
noise in 10 and 13 cells; in the close-fight cell the wind at the third bell is 32 against 25). **But as sized it is not a decision either:
"always ice the whole minute" is the best answer in 14 of 19 and 17 of 20 cells**, and the careful coach loses to it by 1
to 2 points. The cold shoulders (4 points of hand speed and power for 30 seconds) cost far less than the slower drain
buys. The seconds never pressed: no corner ran past "seconds out" in any of the 46,800 E bouts (the jobs fit in 50 s).
To make it a choice, the cold must cost more (or last the whole round), or the ice must take seconds from the hands jobs.

## Not measured, and why

- **FEET is the forward dial, not a forced place.** The game lets a corner force a place only through a call (Jab and move,
  Go to the body, Tie up). Without touching `scripts/`, Press and Move set the fighter's forward dial (75 / 25: the walk-in
  urge and her default place); her ring IQ still picks her best place most of the time. A FEET that commands the place
  needs a code change; this probe may understate what FEET could do.
- **"Running dry" (map 3.4)** - under 35 wind the exchange stays on the opponent's game - is a change inside
  `Exchanges.situation`; it was not layered.
- The opponent's HANDS edge starts from the second exchange of each round (the first is fought inside the corner step);
  the opponent's legs fade reaches footwork, guard and two-thirds of head movement, not foot speed.
- **A closing eye:** the bout has no eye or cut mechanic, so the critics' case could not be set up.
- 6-round bouts use the amateur scoring with six rounds (pro rules were not run). Starting states set the score of the
  rounds already fought; their damage and wind are what those rounds really did.
- Heat links (hot hall, hard cut, Stamina) for arm E were not built (the brief: "links to log, not build").

## Files and reproduce

- `tools/pushprobe2.gd` (the bout loop), `tools/pushprobe2_rules.gd` (every NEW / ESTIMATE constant, the case table, the
  coach, the report). Logs outside the repo: `E:\FightCamp\tmp\s443\pushprobe2_pilot2.log` (pilot, projection 116 min,
  hold check 20 of 20), `E:\FightCamp\tmp\s443\pushprobe2_full.log` (the run, no SCRIPT ERROR).
- `python ops/Tools/godot_slot.py run --who pushprobe -- "$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script res://tools/pushprobe2.gd -- n=300 cells=all lens=3,6 arms=A,B,C,D,E pilot=0`
  (pilot: `n=20 cells=c3_level pilot=1`).
