# Training map v5: depth review by a boxing performance scientist (blind, S432)

Scored: `ops/research/TRAINING_MAP_S432.md` (v5) and its drawing `docs/mockups/s432/training_v2.png`, against the training as built
(`scripts/rules` WeekPlan, Attrs, TrainingLoad, InjuryRoll, PadWeek, MoveMastery, BoutRules, Combos, Exchanges; `scripts/state` LiveRound,
BoutNight, Injuries). I read the critic pack and the access page first. I did not read any other critic's file.

## DEPTH SCORE: 6.5 / 10

One line: The most honest training design I have seen in a management game, and its foundation fixes are real. But the fitness model
underneath still makes the weekly load a choice about injury risk rather than about fitness. Hard buys hundredths of a point. Freshness
under 50 counts for nothing, so the taper rarely changes fight night. And Cardio's real worth in the ring comes from a number the Cardio
row does not show.

## What I checked in the code (the map's claims)

| Claim | Verdict | Where I read it |
|---|---|---|
| F1: a rest morning takes the same points off Stamina | TRUE | Attrs.train, the lines about rest training Recovery while the same points come off Stamina (`out["stamina"] = -out["recovery"]`) |
| F2b: the gain is worked out on the old stat and one `pot` | TRUE | WeekPlan.day: `TrainingPreview.preview_gain(stats, ctx.pot, {training_modifiers:[stat]} ...)` |
| F3: the round-3 fade reads the old Conditioning (the mean) | TRUE | LiveRound line 65, BoutRules.play_round line 208, BoutRead line 325 |
| F4: injury "hours" ignore effort | TRUE | WeekPlan.hours uses minutes x the pace's load, with no effort score; WeekPlan.day's tiredness uses effort x minutes |
| F5: no Legs cost without a camp | TRUE | BoutRules.stale_energy returns 0 when `protocol < 1` |
| The drawn Normal week: work 75, 6 h 15, peak 73 | TRUE. I rebuilt it: 1,959 effort-minutes against 2,607 = 75; 375 min; with a 0.885 overnight keep the days run 65, 61, 71, 73, 66, 60, 53 | WeekPlan.SESSIONS, EVENINGS, fatigue_keep |
| Injury 1 (Normal), 3 (Hard from tired 61) | TRUE | InjuryRoll.fatigue_mult: peak 73 gives x1.25, peak 80.2 gives x3 |
| Move ceiling 40 + 0.4 x Technique + 0.2 x Fight IQ | TRUE | MoveMastery.cap |
| "Its only remaining reader after F3 is between rounds (Combos.after_round)" | FALSE, PARTLY | Combos.round_spend -> spend_factor(conditioning) also reads the mean, and BoutNight 302 and BoutRead 187 pass `stats.conditioning` to both. So after F3, how much energy each round costs still reads Stamina and Recovery together. That breaks "a row prints only a line that reads its own number" for the Cardio row's biggest real effect |
| "A block of Hard at about 129 lifts the usual from 92 to about 102 in four weeks" | WRONG ARITHMETIC | TrainingLoad.next_chronic at 0.1535 a week: 97.7, 102.5, 106.6, 110.0. It reaches 102 in two weeks and 110 in four |

All five foundation defects are real and correctly placed. The map names F1 to F6 as tasks that come first, so I count them as handled.

## Where the depth falls short (from the sport science)

1. **The amount of training barely changes the result (the dose-response curve is too flat).** A session gives share x 0.2 x pace x coach x
   room. Hard only multiplies by 1.3 the mornings it turns Hard. My own run of Samira's Cardio from the code's rule: Normal's intervals are
   already Hard. Over the seven weeks to the regional, Normal reaches about +0.66 Cardio and Hard about +0.72: a gap of about 0.06. The map's
   flagship two-horizon line, "Normal kept: Cardio 63, fade stays; Hard kept: Cardio 64 Fri 3 Apr, no fade", cannot come from that rule unless
   Stamina sits at 63.95. In the sport, six to eight weeks of harder conditioning is the difference between gassing and not. In this model
   the load mostly moves injury risk and pad mastery (Hard's fourth pad night). So a careful player learns that Hard is a risk with almost no
   fitness reward. T30 (two horizons) is the right display, but it will print the same line on every button. F7 PACE1 only raises the share
   of slow rows; it does not raise how much a heavier load buys.
2. **Freshness has a dead zone.** Legs (F5) costs nothing under tiredness 50. The drawing admits that every fight-week load leaves Samira at
   Legs 100. A taper's whole point (Mujika; the Bosquet 2007 meta-analysis: cut volume by 40 to 60%, keep the intensity, 8 to 14 days, about
   +2 to 3% performance) is that being fresher than "not tired" still helps. Here going from tiredness 49 to 35 is worth nothing. So
   Sharpen against Easy against Normal in a fight week usually prints the same Legs. The map then gives Sharpen its reason through T15, where
   Speed and Explosiveness fade after 7 days without a dose. That is backwards from the taper research: in the sport, speed and power RISE
   in a taper. Rest should not be punished. Freshness should be rewarded.
3. **Cardio's worth is a cliff plus an effect the player cannot see.** The fade line is a step: under 64, minus 1 power point per exchange
   from round 3. Exchanges.EX_SPREAD is 66 and EDGE best is 17, so the step is probably under 1 in 100 per bout, below the map's own 1.5
   cut rule. The continuous effect (spend_factor 1.2 - 0.4 x cond, refill 0.8 + 0.4 x cond, then Combos' energy ramp under FRESH_AT 70) is
   the real conditioning model, and it is the better model. But the Cardio row never prints it, and it reads the mean, not Cardio.
4. **No individual response and no way to watch the fighter.** Every fighter answers the same load the same way. Real gyms track session
   effort (Foster's session RPE), soreness and sleep, because the planned load and the felt load differ. That gap is how a coach finds the
   fragile one or the one who soaks it up. The map leaves load tolerance for later. I would make it the reward for watching the fighter: a
   hidden trait, read through a noisy morning check.
5. **The injury model leans on the acute-to-usual ratio alone.** The ratio (Gabbett) has been heavily criticised since 2019 (Impellizzeri
   et al.: the two numbers are coupled, so the link is partly spurious). The map adds monotony (Pattern), which is good. Foster's strain
   (week x monotony) and an absolute spike are missing. This matters less for fun than points 1 to 3, but the injury number is the one the
   load decision now rests on, so it should be the one the player trusts most.
6. **Smaller issues:**
   - The drawn sizes in wins in 100 ("+1 TO +2", "-2 to -4", "Coach runs Samira -1 to -2") break the map's own rule: no size before its probe.
   - The goal "Cardio 63 by 13 Mar, on track" at a trend of +0.5 in four weeks needs Stamina's hidden decimal near 62.6. The drawing should
     show where that comes from.
   - Speed's "-0.4" four-week trend shows a fade rule (T15) that does not exist yet.

What is genuinely deep and right:
- One load unit priced on effort x minutes (Foster), with the clock beside it.
- The fitness-fatigue split (abilities slow, tiredness fast).
- The 13-day chart with the Hard ghost line.
- Fade by dose with residuals (Issurin).
- The stand-down from sparring after head damage.
- Niggles that come from your own load and are priced in the other panels.
- The opponent sorting the board.
- The weigh-in hour.
- One run behind every price.
- The build order that puts the foundations first.

The menu wiring table is complete and names every hook.

## Complete?

Not yet. All the menus are there and wired on paper, and the foundation defects are named with tests that are red on main today. But
three of the load decisions (Hard against Normal over a block, the fight-week shape, Cardio) do not yet change the fight by an amount
the player can feel. And one stated code claim (the energy model's readers) is wrong.

## To reach 10/10 (most important first)

1. **Make the amount of training matter.** Add a dose-response term on top of the 1.3: weekly gain per ability = its sessions' work
   share x (1 - e^(-work / 60)), with the room rule kept. A Hard block should then buy about two to three times Normal's points on the
   abilities it doses (Cardio +1.6 against +0.9 over seven weeks) and cost the injury and overreach it costs today. Name it a foundation
   task (F8 DOSE1) with a unit test: across 7 weeks, Hard's Cardio gain is at least 1.6 times Normal's. Then PACE1 sets the constant.
2. **Readiness = fitness - fatigue, with no dead zone.** Replace "tiredness over 50, 2 a point" with a continuous Legs: energy off at the
   bell = 0.35 x (tiredness - 20) when above 20, plus 2 a point over 50, at most 25. Being fresh at 30 then beats 49 by about 6 energy, and
   the taper choice has bite on every bout. FITLEGS1 measures it. Owned in BoutRules.legs (F5's function).
3. **The taper rewards freshness; it does not punish rest.** Delete the 7-day Speed and Explosiveness fade inside a fight week or deload.
   Give Sharpen (intensity kept, volume cut 50%) a "sharp" bonus instead: +1 Speed and Explosiveness for that bout only. That is the
   real taper effect, and it gives Sharpen its edge over Easy honestly.
4. **Cardio is one continuous number in the ring.** Move Combos.spend_factor to Stamina and Combos.refill to Recovery (the after-round
   rest is truly Recovery). Make the round-3 cliff a slope: fade = 0.25 x (64 - Stamina), clamped from 0 to 2. Print on the Cardio row
   "round 3 starts at 48 energy · Cardio 64: 56 (+8)", with its size once LINES1 reports. Fix the map's sentence that only after_round
   reads the mean.
5. **Watch the fighter: a morning check and the session effort the fighter reports.** Each morning shows sleep, soreness and the
   effort felt against the effort planned (planned + noise + a hidden LOAD TOLERANCE trait, fragile / normal / durable). A day felt 2 or
   more harder adds that tiredness to the chart. The trait becomes known after about four Hard sessions. That brings S&C point 8 in now,
   as the reward for paying attention, rather than leaving it for later. Owned: a new pure Readiness.gd with a unit test.
6. **Injury on strain and spike, not on the ratio alone.** Chance = base x work x f(strain = week work x monotony) x spike(this week over
   the 4-week average) x fatigue_mult. Print "Why injury 1 in 100" with its three parts on the load card's hover.
7. **Run before you draw.** Every drawn number on the tab comes from one TrainWeek.run. Remove the wins-in-100 sizes from the drawing
   until their probes report. Correct the usual-load arithmetic (102 in two weeks, 110 in four).
8. **Two horizons that differ.** Once item 1 lands, HORIZON1 must show Easy, Normal and Hard reaching different lines at the target in
   at least 6 of 10 seasons. Otherwise the second horizon is cut back to one.
9. **Pro camps get the same readiness chart**, with the weigh-in the day before and the refill: from 24 hours, a 0.2 kg-per-hour line
   up to the bell. Also draw Lucy's camp and Ana's mat on this frame, as 8b promises.
10. **Season gate on the fixed physiology.** TRAINSEASON1 runs after items 1 to 4 and must show that a careful player beats "Coach runs
    it" by 4 or more in 100. Otherwise the tab is cut back to the load, the chart and the abilities.

## My 10/10 drawing

`docs/mockups/s432/critics/tr5_perf_10.png` (from `tr5_perf_10.html`).
- **The load to the regional:** each load's block gains, readiness on the night, injury and size.
- **Ready on the night:** tiredness, the Hard ghost line and a readiness line with no dead zone.
- **The fighter says:** sleep, soreness, and effort felt against effort planned.
- **Cardio in the ring:** energy at each bell, now against Cardio 64.
- **Block buys:** each ability's room and block gain in one bar.
- **Why injury 1 in 100.**
- **Body and the stand-down after Sat 28.**
