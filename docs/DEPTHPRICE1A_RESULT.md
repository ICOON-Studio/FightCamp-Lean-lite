# DEPTHPRICE1A result (S534): a price for the four solved fight-night choices

Brief: `ops/research/TASK_DEPTHPRICE1A.md` (DEPTH_SCOPE_S534 change 1). Measurement only: `tools/depthprice1a_probe.gd` and
`tools/depthprice1a_report.gd`; nothing under `scripts/` was touched.

## Verdict

| Row | Price tried | Today | Priced, first size | After one re-size | Verdict |
|---|---|---|---|---|---|
| 27 Round pace | Push spends more wind; Save loses its flat refill | "Push five, Save one" best in 8 of 10, +8.6 over Steady | spend 2.2: never push (Steady best in 8 of 10) | spend 1.75: no habit dominates, but the choice is worth 0.0 (best habit +1.4) | **FAIL** |
| 30 Corner minute | The talk and the habit fix each take one of the second's 3 points | "do everything" best in 9 of 10, +2.9 | talk + fix still the answer, +1.5 | a water point worth 3x: +1.8 | **FAIL** |
| 21 Fight-week load | Train through keeps its tiredness (+14 after the bell, was +6) | Rest up best in 7 of 10, +4.5 over Tick over; Train through worst everywhere | no change (Train through was never the free option) | Rest up flat -3 at any tiredness, Train through tank 8: Rest up 5, Tick over 4, +3.1 | **PASS, narrowly, as a lookup** |
| 22 Sparring partner | A closer partner is a harder night (the night's tank by the match) | closest best in 10 of 10, +5.7 | close 8 / part 5 / loose 3: closest best in 9, +2.3 | close 12 / part 7 / loose 3: closest 6, part 2, none 2, but +1.4 | **FAIL** |

"+x" is the informed pick against the laziest option, wins in 100, cross-checked (see "How it was read").

**What the four rows say together:** a flat price in the tank does not make a decision. It is a dial that runs from "always
do it" through "it does not matter" to "never do it"; at no size on that dial were both bars met for pace or the partner.
The fight week met both bars only because its two live options already depend on a state the player can see (tiredness).
A choice becomes real when its VALUE changes with the state of the bout, not when its cost goes up. That is change 2 and
change 5 of the scope (the exchange reads place and cover; an opponent who remembers), not change 1.

## What to build (exact constants)

- **Row 21, fight week - build candidate, goes to critics:** `FightWeek.REST_UP_EDGE` from `[[40, -2.0], [65, -1.0]]`
  (and Sharp from 65) to a flat **-3.0 at every tiredness**; `FightWeek.STOP_TANK["train_through"]` **12 -> 8**;
  `TRAIN_THROUGH_TIRED_AFTER` stays 6. Known weakness to put to the critics: Train through is still best in no cell (2.5
  behind Tick over on average), and the choice is a lookup on one printed number (fresh: Tick over; tired: Rest up).
- **Row 27, pace - nothing to build.** Keep `PaceAim.PACE_SPEND` 1.35. The one number worth taking is `SAVE_RECOVER` 6 -> 0
  (it removes "Push five, Save one", as PUSHPROBE2 arm C already showed), but it does not make pace a decision.
- **Row 30, corner minute - nothing to build.** Recovery is too weak to be a currency: all three recover points together
  are worth 1.0 win in 100, and tripling water added 0.8.
- **Row 22, partner - nothing to build.** The tank price flattens the partner (5.7 -> 1.4) instead of trading against it.

## Two defects found in the code while reading (not fixed: measurement only)

1. **"Ice on the ribs" does nothing to her tank.** `BoutNight._open` takes the iced hits off `bout.body.a`, but since S467
   the drain reads the per-side tally (`RingDuel.body_units` -> `LiverRibs.drain_units(bout.sides.a)`), which ice never
   touches. Measured: "ice first" 27.3 against "all water" 27.6 and "no recover at all" 26.6 (it only loses the water
   points it replaced).
2. **Tick over's "one line fires a level up in rounds 1 and 2" is shown but not wired.** `FightWeek.round_one` returns
   `boost`; the only reader is the screen's text (`scripts/ui/modals/FightWeek.gd` "sharp + 1 line up").
   `FightWeekPlan.read` / `lock` put only the edge on the bout.

## Row 27 - round pace (Push / Steady / Save)

Price: wind. Push's extra drain `PACE_SPEND` 1.35 -> 2.2 (re-size 1.75), Save's flat refill `SAVE_RECOVER` 6 -> 0.
Mean win % over the 10 cells:

| Arm | Steady (laziest) | always Push | Push > 45 | Push > 55 | Push five, Save one | Push round 1 | Push round 3 | Push a close round | Best in cells |
|---|---|---|---|---|---|---|---|---|---|
| Today | 27.6 | 31.0 | 34.9 | 33.9 | **36.3** | 31.6 | 28.2 | 30.5 | Push five Save one 8, Push > 45 2 |
| Spend 2.2, no refill | **27.6** | 16.1 | 25.2 | 25.5 | 17.8 | 23.9 | 25.9 | 24.1 | Steady 8 |
| Spend 1.75, no refill (n 200) | 27.8 | 22.1 | **29.3** | 28.7 | 23.5 | 28.3 | 26.9 | 27.1 | Push > 45 5, Push round 1 3 |

Today reproduces PUSHPROBE2 arm A (Steady 30.2, Push five Save one 34.7, Push > 45 34.4), so the ruler is the same one.
At 1.75 the best cell is +6.0 +-4.9 (swarmer); every other cell's best is inside the noise, and the same habit is best on
both halves of the bouts in 3 of 10 cells. The wind threshold stays the right summary at every size; the price only
decides whether the threshold habit is worth 8, 1 or -2.

## Row 30 - the corner minute

Price: the second's 3 recover points (`CornerJobs.RECOVER_POINTS`). Today the talk and the habit fix are free on top of
them; priced, each takes one point. The talk is the best one for her personality; the fix is the habit she paid for most.

| Arm | No recover | Water x3 (laziest) | Ice first | By need | Everything + water | Everything + need | Best in cells |
|---|---|---|---|---|---|---|---|
| Today (jobs free) | 26.6 | 27.6 | 27.3 | 27.3 | **30.6** | 30.2 | everything 9 + 1 |

| Arm | Water x3 (laziest) | By need | Talk + 2 water | Fix + 2 water | Talk + fix + 1 | Coach (reads the minute) | Best in cells |
|---|---|---|---|---|---|---|---|
| A job costs 1 point | 27.6 | 27.3 | 29.4 | 28.2 | **30.0** | 28.0 | talk + fix 6, talk + water 4 |
| ... and a water point worth 3x | 28.4 | 28.1 | 30.5 | 29.1 | **31.2** | 28.6 | talk + fix 6, talk + water 4 |

The "6 of 10" is noise, not variety: the two leaders differ by 0.6, and the same option is best on both halves of the
bouts in 2 and 4 of 10 cells. The talk is worth about +2, the fix about +0.6, three water points +1.0. The coach who
holds the talk back when she is hurt or empty does worse than always talking. Not measured: the set-up (no "NOW" shout
in this loop).

## Row 21 - the fight week's load stop

Greybox: four weekly amateur bouts in a row on one habit, Lucy with a three-line plan against three calibrated opponents.
The stop sets the tank and round 1 (`FightWeek.tank`, `round_one`); the week banks its share of 12 mastery on her lowest
line; tiredness carries (the bout's toll, 7 rest days at 0.87, plus the week's training load 20 or 35, plus what the stop
adds). Start tiredness came out near 48 in the light cells and 64 in the hard ones.

| Arm | always Rest up | always Tick over (laziest) | always Train through | By the card (Rest up from 65) | Coach | Best in cells |
|---|---|---|---|---|---|---|
| Today | **43.5** | 38.9 | 33.8 | 42.5 | 43.0 | Rest up 7, card 2, Tick over 1 |
| Train through +14 tiredness after | **43.5** | 38.9 | 31.9 | 42.5 | 43.4 | Rest up 7 |
| Rest up flat -3, Train through tank 8 (n 100) | 41.5 | 38.9 | 36.4 | 41.6 | **42.1** | Rest up 5, Tick over 4, card 1 |

The audit's reading ("Train through has no season cost") is out of date: in the built week Train through is the worst
stop in all 10 cells and "always Rest up" is the one answer, because Rest up's flat round costs less than the tank
Tick over pays once she is over 50 tired (tired cells: Rest up +8 to +13 over Tick over). The first price went the wrong
way and changed nothing. The re-size puts the price on Rest up (ring sharpness) and takes some off Train through: four
of the five fresh cells go to Tick over (by 0.3 to 4.7), the tired cells stay with Rest up (by 3 to 12). Informed pick +3.1: on the line, at 100
runs a cell. The banked work never showed: "near a level" and "far from a level" cells pick the same stop.

## Row 22 - the sparring partner

Greybox: one bout, one sparring night 7 days out; the stop is the card's (Tick over under 65, Rest up from 65); 3 or 1
plan lines unsparred. The match sets the lines readied and the rounds 1-2 edge (`PartnerMatch.LINES`, `EDGE`). Price: the
night's tank by the match (today a flat 3, `FightWeek.SPAR_EARLY_TANK`).

| Arm | No night | Loose (laziest, own club) | Part | Close | Best in cells |
|---|---|---|---|---|---|
| Today (3 / 3 / 3) | 45.7 | 46.3 | 48.9 | **52.0** | close 10 |
| Close 8, part 5, loose 3 | 45.7 | 46.3 | 48.1 | **49.4** | close 9, none 1 |
| Close 12, part 7, loose 3 | 45.7 | 46.3 | 46.9 | **47.3** | close 6, part 2, none 2 |

Today matches S482 (close over loose +3.7 / +5.3). Each extra tank point takes about 0.5 off the close partner; at 12
(the size of Train through's whole week) the options are within 1.6 of each other and the informed pick is worth +1.4.
A loose partner is worth only +0.6 over no sparring night at all. The $160 / favour cost was not measured (money is not a
win).

## How it was read

- **The game's own bout.** Every punch, round and result is `Bouts.fight_step` + `LiveRound` and `BoutNight.outcome_of`,
  as `tools/pushprobe2.gd` and `tools/partner_probe.gd` play it. Each price is a local rule in the probe (the `px`
  values); the control arm runs on the game's own numbers (`TODAY`).
- **Paired dice:** bout i of a cell plays on the same career day under every option and both arms.
- **Population.** Pace and corner: our side Lucy Jackson (Out-boxer, orthodox, fight power 59.9) and Jo Brennan
  (Boxer-puncher, southpaw, 59.7), alternating; two fictional opponents a cell (orthodox at our fight power plus the
  cell's offset, southpaw 1.5 higher), styled by cell: even, body puncher, mover, slow starter, fader, swarmer, volume
  puncher, a 20-point weight cut, underdog (+5), favourite (-5). 3 rounds, film 1, no camp, morale 60. Fight week and
  partner: Lucy with the plan 1-2 / 3b-3 / 1-1-2 against Priya Nair (rating 57.3, about 49 in 100), Erin Doyle (55.0,
  about 78) and Maria Ortega (62.2, about 35), calibrated at a full tank.
- **Size.** 300 bouts a cell and option (pace re-size 200; fight week 150 runs of 4 bouts, re-size 100). One cell's
  paired difference carries about +-2 to +-5.
- **The two bars.** "Best in at most 6 of 10 cells" is the plain top option of each cell. "3+ wins in 100" is the
  informed pick against the laziest option, CROSS-CHECKED: the best option of a cell is chosen on one half of the bouts
  and scored on the other half, so the dice cannot pick their own winner. The log prints the uncorrected figure beside it.
- **Limits.** 3-round amateur bouts only. Cells are mine, not a census of real play: the "6 of 10" count depends on them.
  The fight week's tiredness carry and the 12 mastery a week are probe estimates (named constants at the top of the probe).
  The working tree held other sessions' uncommitted edits to LiveRound.gd, LineGrade.gd and StepWire.gd during the runs;
  both arms of a run shared them, the re-size runs came 1 to 2 hours later.

## Files and reproduce

- `tools/depthprice1a_probe.gd` (the four rows), `tools/depthprice1a_report.gd` (the report). Logs, outside the repo:
  `E:\FightCamp\tmp\s534\dp1a_<row>.log` and `dp1a_<row>2.log` (the re-sizes); no SCRIPT ERROR in any.
- `python ops/Tools/godot_slot.py run --who depthprice1a -- "$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script res://tools/depthprice1a_probe.gd -- row=pace n=300`
  (rows `pace`, `corner`, `week` n=150, `partner`). Re-sizes: `row=pace n=200 arms=priced push_spend=1.75 save_refill=0`;
  `row=corner arms=priced water_x=3`; `row=week n=100 arms=priced tt_after=6 rest_edge=-3 tt_tank=8`;
  `row=partner arms=priced close_tank=12 part_tank=7 loose_tank=3`.
- About 15 ms a bout on a quiet PC; 50 to 86 ms beside three other Godot jobs (244,000 bouts in all).
