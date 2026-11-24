# DESIGN_CORNERCMD1 - the corner commands (S544, the owner's spec)

Spec: `ops/research/PUSH_KNOW_INTERVIEW_S543.md`, section THE SPEC (12 points) - his design. Brief: `ops/research/TASK_CORNERCMD1.md`.
Probe: `tools/cornercmd1_probe.gd` + `tools/cornercmd1_rules.gd` (the commands as flagged local rules), `tools/cornercmd1_sum.py`.
Result: `docs/CORNERCMD1_RESULT.md` (FAIL: bars 5, 6, 8 - a held command that gives wind back is free recovery; the coach
rule was tuned to (tactics - 30) / 50). Nothing under scripts/ or tests/ changes in this task.

## STEP 0 (run before this page): today's eight calls are NOT where the edge is lost

On the real bout (BoutNight's loop, the coach's plan written at the first bell, coach 58), TELLPLAY1's population, our two women
(Lucy Jackson, Out-boxer; Samira Khan, Slugger), four cells (presser, mover, counter-puncher, loader), 500 paired bouts a cell
and boxer, three and six rounds. Arms: PLAN ONLY (no shout; the corner minute's call is `BoutRules.auto_corner`, "long" or
"body", for the whole round, `BoutRules.gd:383`) against a reader who shouts `Exchanges.MODES[sit].best` every exchange.

| Reader | 3 rounds: wins in 100 over PLAN ONLY (2 SE) | 6 rounds |
|---|---|---|
| Sees the coming game (`lv.mode`: what the corner sees only with full film study) | +15.9 (1.2) | +18.8 (1.2) |
| The same, silent when the plan's call is already best | +16.7 (1.2) | +19.3 (1.2) |
| **Sees what the corner sees at film 1** (the game just shown, `LivePreview.gd:40`) | **+9.0 (1.2)** | **+15.0 (1.2)** |

The check: our loop with no shout gives the SAME result as `BoutNight.play_out` in 80 of 80 paired bouts (`stage=check`).

**Reading:** the reader is 4.5 to 7.5 times over the 2-point line. The edge is not lost in the call's size, in `uptake` or in the
plan line: a call is `EDGE` best 17 / ok 5 / wrong -10 power points (`Exchanges.gd:18`) on an exchange whose dice spread is 66,
so a best call heard in full moves that 30 seconds' odds by about 22 points. What PLAN ONLY lacks: the corner minute's call
is ONE call held all round (`LiveRound.gd:181`, `call := shout if shouted else lv.plan`), chosen from the boxer's stats, not
from the opponent; in round 1 there is none. Its mean edge per exchange is 0.4 to 3.2 points; the honest reader's 3.4 to 7.3.
PUSHPROBE2's coach gained only +2 from calls because it shouted between rounds and on the score, not on each exchange's game.

**So the commands are sized from today's table, not shrunk or grown:** a command in its best moment is worth what a best call
is (17 x her grade x heard), ok 5, wrong -10 x her commitment (`COMMIT`). The risk is the other way: a FIXED command that is
best in the opponent's main game could be a win button (bar 8: no command adds more than 10 by itself). The probe watches that.

## The two slots and the ten commands

Moments are `Exchanges.situation`: the opponent's game (press, range, counter, loadup, tiring, hurt) or our boxer's own
state first (she_tired under 35 wind, she_hurt). The edge column is the command's power points in its moment
(`cmd_edge`): best 17, ok 5, wrong -10 (x her grade on a positive edge, x COMMIT on a negative one), x heard.

### FIGHT slot (one of eight, or none)

| Command | What the boxer does | Built from | Trained on (grade) | Burns (wind / head) | Best | OK | Wrong |
|---|---|---|---|---|---|---|---|
| Go to the body | Hooks and straights downstairs, not head-hunting | call `body` (as built: body share 0.5, inside place) | hooks + power | call cost 1.5 a 30 s / - | range | press, tiring | loadup |
| Change levels | Head-body-head: dig the body, come back up when the hands drop | NEW (takes "Draw the lead"'s answer to a waiter; the lead stays a plan line) | hooks + ring IQ | 1.0 (ESTIMATE) / - | counter | range, loadup | press |
| Let your hands go | Combinations, stop waiting | call `let_go` | engine + hand speed | 3.0 (as built) / 0.5 on a lost 30 s (ESTIMATE) | tiring | hurt | press, counter, she_tired |
| Be first | Throw first, take his rhythm before he sets | NEW | hand speed + timing | 1.5 (ESTIMATE) / 0.5 on a lost 30 s | loadup | range, press | counter, she_tired |
| Sit down on your shots | Plant the feet, put the body into each punch | NEW | power + timing | 1.0 (ESTIMATE) / 1.5 on a lost 30 s (ESTIMATE) | tiring | hurt, press | range, counter |
| Hands up | Gloves high, chin down, move the head | call `hands` | guard + head movement | 0 / - | loadup | press, she_hurt, she_tired | tiring, hurt |
| Reset | Breathe, balance, tie up when hurt, then pick the shots | calls `calm` (not hurt) / `tie` (hurt) - takes "Tie up" and "Breathe, pick your shots" | discipline + heart | calm -3 / tie -2 (as built: the wind back) / - | she_tired, she_hurt | counter | tiring, hurt; -3 in any other moment (gives up offence) |
| Get out of there | Punch and move: head or feet out after every punch | call `long` ("Jab and move") | jab + footwork | -0.5 (as built) / - | press | counter, loadup | range |

**Moment button: Go for the finish** - call `finish` as built (power + heart, cost 3.0, best when the opponent is hurt, wrong when
our boxer is hurt). It shows (pulsing) only while the corner sees the opponent hurt and goes when that passes; while pressed it
overrides the FIGHT command for that exchange.

Real-world reasons for the four NEW ones (the numbers are ESTIMATES; the direction is corner practice):
- Change levels: a fighter who waits behind a high guard to counter is opened by body work; the classic corner line is
  "go downstairs, then come back up" (J55's mic'd amateur corners, Halperin et al. S21: "Aim your hooks to his body"). Wrong
  against a presser: dipping to the body walks into his short punches.
- Be first: "beat him to the punch" is the corner's answer to a loader who winds up (J55's Fury corner "jab... let the jab go
  to work" is the same idea: take the initiative). Wrong against a counter-puncher: leading is what he waits for.
- Sit down on your shots: shouted when the boxer arm-punches against a fighter who has stopped moving (tired or hurt);
  planting costs mobility, so it is wrong against a mover (range: you reach and miss) and a counter-puncher (a still target),
  and it opens the head (1.5 head on a lost 30 s).
- Reset: the corner's "breathe" and "tie him up" (J55: settle and breathe is one of the minute's five functions; Halperin
  "Breath, buddy, breath"). Its cost is offence: wrong when the opponent is tired or hurt (he gets the rest), -3 elsewhere.

What each gives that the plan in force does NOT have (TELLPLAY1's rule): the plan has ONE call for a whole round, set from our
boxer's stats (long or body), and plan LINES (arrows) for the cards. A command changes the call to the moment the corner sees,
exchange by exchange. The plan lines (arrows, steps) keep firing under every command; a command replaces only the call.

### RING slot (a three-stop slider: Stay away from the ropes | Centre | Cut the ring off)

| Command | What the boxer does | Built from | Trained on | Burns | Best | OK | Wrong |
|---|---|---|---|---|---|---|---|
| Cut the ring off | Step to his escape side, walk him to the ropes instead of chasing | the `cut_off` step's effect: `ring_cut` share off his range game this round (`RingDuel.step_bias`, `StepWire.gd:170`), 0.5 x grade x heard; + an edge | steps cut_off / herd (best mastery) + footwork | 1.0 wind (ESTIMATE: cutting off is walking forward) | range | tiring | press, counter |
| Stay away from the ropes | Turn off the ropes, pivot out before he pins her | the ropes count cleared (`Duels.PINNED_AFTER` pins reset) with chance grade x heard; + an edge | steps pivot_out / roll_out / step_out + footwork | 0.5 | press | loadup | range, tiring |

A ring edge is 0.6 of a call's (RING_SCALE, ESTIMATE: the feet choose where the fight happens, the hands decide it). Ring
grade: mean of (best step mastery, footwork); Good from 55, OK from 40.

## Rules

- **Nothing selected (spec 8):** the boxer fights the pre-fight plan as built: the corner minute's call for the whole round
  and the plan lines. A FIGHT command, while on, REPLACES the round's call (its edge in, the call's edge out - in the probe: the
  command's real call is shouted, or for a new command the base takes `cmd_edge - plan's call edge`). It does not touch the plan
  lines. A RING command adds to whatever call is in force. Turning a command off gives the plan's call back from the next exchange.
- **Changing (spec 7):** free at any time, no limit; takes effect from the next exchange; heard once at the change by
  `Exchanges.uptake(coachability, 0) x trust` (0.7-1.0 x mood) as a multiplier on its edge - the old "two shouts then half" does
  not apply to commands (the command is a held instruction, not a shout).
- **Only as good as the boxer (spec 5):** grade = `Exchanges.grade` on the needs (Good 1.0 / OK 0.6 / Poor 0.3 on a positive edge;
  a wrong one committed 1.5 / 1.0 / 0.6). Poor commands show unlit; they can be pressed and do little.
- **The bars (spec 6):** wind = the game's energy (0-100, the drain, the calls' cost, the body shots); head = the bout's head damage
  the counts read (`m.damage.a`). Each button shows its wind and head cost as numbers.
- **The unwatched round (spec 10), one rule:** the corner coach reads the moment right with chance (tactics - COACH_A) / COACH_B
  (start: tactics / 100) and then sets what the reader would; otherwise he keeps the commands he had.
- **The reader (the player's rule, two sentences):** "Press the lit button that best answers what the opponent just did - body
  against a jabber, change levels against a waiter, hands up or be first against a loader, let your hands go or sit down
  against a tiring man, get out against a presser - and Reset when your own boxer is tired or hurt. Slide to Cut the ring off
  against a jabber, Stay away from the ropes against a presser, else Centre; press Finish when it pulses."
  (In code: for the moment seen at film 1, the command with the most edge for HER; the same for the ring; Finish when seen hurt.)

## The menu table (owner S425: every menu it appears on, what it is wired to)

| Where | What | Wired to |
|---|---|---|
| Fight screen, beside our fighter | FIGHT slot: a row of eight buttons in two colours (attack / defence), one lit, click the lit one to turn it off; each shows Good / OK / Poor and its wind / head cost | the command id on the live round (`lv.cmd`), read by LiveRound.exchange instead of `lv.plan`'s call |
| Fight screen | RING slot: three-stop slider | `lv.ring`: ring_cut share / ropes clear + edge |
| Fight screen | "Go for the finish" pulsing button, only while the opponent is seen hurt | the exchange's call = finish |
| Fight screen | the two bars (wind, head) beside the fighter, moving each exchange | RingDuel.her_energy / m.damage.a |
| Fight screen | the shout bubble at the corner when a command changes; the round's line ("Hands up: slipped the right hand") | Exchanges.verdict on the command's fit |
| Result page | count of right and wrong commands (worked of said) | CornerTrust.tally on the command's fit |
| Unwatched round (sim) | nothing to click: the coach's rule | Coach tactics rating |
| Plan page | "Draw the lead" stays a plan line | PlanFile arrows |
| 3D phase | the boxers visibly doing each command | not designed here (3D phase) |

## Feedback loops (from the brief; caps)

- Command -> edge -> a won exchange -> the opponent hurt or tired -> a better moment for the same command. Cap: bar 8 (no
  command over 10 points by itself); Finish exists only while the opponent is hurt.
- Let your hands go / Be first -> wind down -> our boxer tired -> the she_tired moment. Printed: wind at every bell. STOP if an
  arm ends a round under 0 or never drops under 60.
- Sit down -> head damage -> counts -> worse exchanges. Printed: head at every bell.
- Hands up / Reset -> wind back -> they give up offence (Reset -3 in moments it does not answer; Hands up wrong vs a tiring man).
  Trial check: "alt" (Let your hands go and Reset every other exchange) must not beat the reader.
- The opponent does not read our commands (ProRead unchanged).
- Ring cut -> his range game down this round -> fewer range moments -> fewer "body" best moments. Cap: 0.5 x grade x heard.

## Bars (written before any command run; never loosened)

1. No fixed command or fixed pair is the best arm in more than 6 of the 10 cells.
2. THE READER PAYS: reader - best fixed pair >= 3 wins in 100 over all cells; reader - PLAN ONLY >= 5.
3. EVERY COMMAND HAS ITS MOMENT: at least 8 of the 10 commands are the reader's pick in 5% or more of the exchanges where a
   command is on, and each of those 8 is the best command for at least one moment (for at least one of our boxers).
4. A WRONG CALL COSTS: the worst command held all bout loses 4 or more against PLAN ONLY in at least 6 cells.
5. THE BOXER MATTERS: for at least 4 commands the two boxers disagree on whether the command pays (held all bout v PLAN ONLY,
   one above +1, the other below -1, or the sign differs by more than 2 SE).
6. THE RING SLOT IS ALIVE: Cut the ring off and Stay away from the ropes each the right ring call (best of cut / ropes /
   centre, held all bout) in at least 2 cells.
7. THE BARS ARE A REAL COST: always Let your hands go and always Sit down each end at least 3 cells behind the reader where
   their wind or head at the last bell is worse than the reader's.
8. NOTHING RUNS AWAY: wind stays in 0-100 (no round ends under 0); no command held all bout adds more than 10 points over PLAN
   ONLY in any cell.
9. THE COACH RULE: at tactics 75 the coach is within 3 of the reader; at 40 at least 3 behind.

Population and arms as the brief: ten cells (presser, mover, counter-puncher, loader, fader, slow starter, body puncher,
switch-hitter, the favourite +3, the underdog -3) x our two women x three and six rounds; arms PLAN ONLY, each of the ten
commands held all bout, all sixteen fixed pairs, push while wind > 45, the reader, the coach at 40 / 58 / 75, and "alt".


---

# Round 2 (CORNERCMD2, S545) - honest wind, a round-1 call, a ring that answers who runs, grades that matter

Brief: `ops/research/TASK_CORNERCMD2.md`. Written BEFORE any round-2 run. Probe: `tools/cornercmd2_probe.gd` + `tools/cornercmd2_rules.gd`
(round 1's tools with the four changes as flags `ch=1,2,3,4`; `ch=0` = round 1 as it ran), `tools/cornercmd2_sum.py`.
Result: `docs/CORNERCMD2_RESULT.md` - FAIL again on bars 5, 6, 8 (the free recovery is gone; bar 3 now passes; the ring
is worth +0 held and as a moment answer; STOP RULE sections written there). These four changes are the ONLY changes to the page above; everything else (the ten
commands, the moments, the reader's rule, the coach rule as tuned, (tactics - 30) / 50) stands.

## The four changes (before -> after)

| # | What | Before (round 1) | After (round 2) | Boxing reason | Source |
|---|---|---|---|---|---|
| 1a | Reset ("calm" / "tie") wind | -3.0 / -2.0 every exchange it is on, whatever the moment; a held Reset made the corner minute's call "calm" (`Combos.round_spend`: 0.8 of the punches, all round) | the refill only while OUR boxer is tired or hurt (the moments she_tired / she_hurt); any other moment it costs 0 (the call's -3 is given back) and still gives up offence (-3 edge, as before). The corner minute's call is "calm" only when she comes back to the stool tired (under 35 at the bell) or hurt; otherwise the plan's call | "breathe" is for a boxer who is blowing; a fresh boxer told to breathe just throws less | J55 (the corner minute: settle and breathe is one of five jobs); PUSHPROBE2 "Push five, Save one" (the free-recovery loop) |
| 1b | Get out of there ("long") wind | -0.5 every exchange (the built call gives wind back) | 0 (the -0.5 is given back while the command is on, also in the round's first 30 s when it is the corner's call) | punch-and-move is not rest; the legs work | CORNERCMD1 result (Get out held +23.9) |
| 1c | New commands' wind | Change levels 1.0, Sit down 1.0, Be first 1.5 | 0.5, 0.5, 1.0 - the built calls' scale (body 1.5, let_go 3.0, hands 0, long -0.5) | changing levels and planting are a little more work than boxing; throwing first is more | Exchanges.CALLS cost column |
| 1d | Ring wind | Cut 1.0, Ropes 0.5 | Cut 0.5, Ropes 0 | walking a man down is work; turning off the ropes is what a boxer does anyway | STEPPAY4: cut_off's tank cost; StepEffect "self_tank" |
| 2 | Round 1's call | none: `BoutNight` opens round 1 on plan "" (l.77 / l.194); the corner speaks from round 2, so any held command had a free third of a 3-rounder | every arm opens round 1 on `BoutRules.auto_corner(stats)` - the call PLAN ONLY uses in every later round (the probe opens round 1 itself: the same steps as `fight_step("start")` with that call) | a corner sends the boxer out with one instruction | J55's mic'd corners; Halperin et al. S21 |
| 3a | Cut the ring off | a flat ring edge (0.6 of a call, best at range) + `ring_cut` 0.5 x grade x heard | NO flat edge. In the moments where the opponent gives ground (range, counter) it moves the fight: `ring_cut` 0.5 x grade x heard for the round (his range game less often) and his ROPES COUNT +1 with chance grade x heard (StepEffect's cut_off row: opp_ropes 1; at 3 the next exchange is on his ropes, PlaceEdge +5 and no range game). Against a man coming forward (press, loadup) it leaves our boxer open: -5 x commit x heard (the size of being on your own ropes, PlaceEdge.ROPES) | cutting off a runner takes his room; stepping across in front of a presser walks you onto his punches | footwork topic page (ring position); STEPPAY4 (cut_off +4.75 v Out-boxer, about 0 v Pressure); coaching line "cut him off, don't follow him" |
| 3b | Stay away from the ropes | a flat ring edge (0.6 of a call, best when pressed) + pins cleared with chance grade x heard | NO flat edge. In the moments where the opponent walks her down (press, loadup), with chance grade x heard: her ropes count and Duels pins cleared, and an exchange that was going to be fought on her own ropes (PlaceEdge -5) is fought on the moment's own card instead. Against a mover (range) it gives up the centre: -5 x commit x heard | "get off the ropes" against a man walking you down; circling away from a jabber gives him his range | STEPPAY4 (pivot_out +3.25 v Pressure, -3.50 v Out-boxer; step_out +3.00 v Slugger) |
| 4a | Grade multipliers on a COMMAND (fight and ring) | positive edge Good 1.0 / OK 0.6 / Poor 0.3 (OK->Good ramp 56-62); a wrong one committed Good 1.5 / OK 1.0 / Poor 0.6 | positive Good **1.25** / OK 0.6 / Poor **0.25** (ramp 0.6 -> 1.25 over 56-62); wrong Good 1.5 / OK 1.0 / Poor **1.0** (a Poor command pays a quarter and costs in full: its wind, its head, its wrong moments) | an untrained boxer told to sit down on her shots does it badly AND gets hit doing it; a trained one does it as her own | spec 5: "an untrained one shows Poor and does little" |
| 4b | The tie at "loading up" | Hands up and Be first both best; Be first won every tie (list order) | Hands up is best at loading up for a boxer whose guard + head movement mean is above her hand speed + timing mean, and only OK for the other kind; Be first the reverse. No new command | a slick defender makes the big shot miss; a fast one beats it to the punch | corner practice; CORNERCMD1 bar 3 (Hands up 0%) |

Every number here is an ESTIMATE with the reason given; the bars below decide.

## Feedback loops (from the brief; caps)

- Command -> edge -> a won exchange -> the opponent hurt or tired -> a better moment for the same command. Cap: bar 8.
- Reset when tired -> wind back -> not tired -> Reset stops refilling -> tired again: the design (rest when you need it). Cap:
  the refill only in she_tired / she_hurt, and Reset gives up offence. Check: Reset held ends each round BELOW the reader's
  wind + 15, and does not beat PLAN ONLY by more than 10 in any cell.
- Cut the ring off -> the mover has less room -> more exchanges on his ropes -> our boxer spends 0.5 an exchange -> tired ->
  cannot cut. Cap: its 0.5 wind, the ropes count's 3, the round's length. Printed: our wind at each bell with Cut held v the mover.
- Stay away from the ropes -> fewer rope exchanges -> less damage -> more wind for offence: one way, no loop.
- Grades wider -> trained commands pay more -> the player trains what already pays. Outside this probe (training is not
  simulated); a limit on the result page.
- ONE-REP TRIAL FIRST: all four off reproduces round 1 (one cell, 140 bouts, the same dice); then one bout per cell per arm
  with the changes on, and one cell printed exchange by exchange, read for a command that changes nothing.

## Bars (the SAME nine, never loosened)

All nine at 3 and 6 rounds, the same ten cells, the same two women plus ONE more of ours with a different trained set, the
same paired dice (bout k = career day 70000 + 7k). Bar 5 then reads: at least 4 commands where at least two of the three
boxers disagree (one above +1, another below -1, held all bout v PLAN ONLY). New prints: the wind at every bell for Reset held
and Get out held (STOP flag: never under 60 = still free recovery) and, for each cell, which ring stop is right held and by
how much. STOP RULE (the coordinator applies it): bar 8 fails again -> name the command and the cells, no further tuning;
bar 6 fails again -> the ring slot goes to the owner as "cut it as a held slider, keep the two ring calls as moment answers,
or cut both"; bar 5 fails again -> say whether the grades are too close in the population or the engine ignores them; bars
1, 2, 4, 7, 9 must still pass, and a reader under +5 over PLAN ONLY is a FAIL.
