# Training map v3 (TRAINING_MAP_S432): blind review by a sports scientist (S432)

Reviewer: a sports scientist who plans training over a season for combat athletes (fitness against tiredness, tapering, losing
fitness when training stops). This is a blind review: I did not read any earlier score or another critic's file.
Read: CRITIC_PACK.md, CRITIC_ACCESS.md, TRAINING_MAP_S432.md (all of it), training_v2.png, CLUBWEEK_MAP_V41_S432.md (sections 1 to 5),
and the code: WeekPlan.gd, TrainingLoad.gd, PadWeek.gd, MoveMastery.gd, HabitFix.gd, TrainingPreview.gd, Attrs.gd (the session table),
Injuries.gd (ratio, week_hours, chronic), InjuryRoll.gd, WeekPhase.gd, BoutRules.stale_energy, Sim.week_ctx, Recruit.ceiling.

## Score: depth 6.5 / 10

In one line: the shape is deep and almost every effect is tied to real code, but the part I know best, the load-fitness-taper
core, is priced on an hours table the game no longer uses, adds a second "fitness" on top of the abilities, and makes the
taper drop intensity, which is backwards. So the most important new choice would not play the way the map says.

## What is genuinely good
- Real choices, each with a cost: build or keep (fade), follow the opponent or the season, rest the niggle or push on,
  the diet against Legs on the day, a pad place for the habit or a new move. Each costs something you can see.
- Almost every line is tagged CODE / WEEK / NEW with its file, and I checked the main CODE claims. They hold:
  - the gain rule and headroom (TrainingPreview);
  - fatigue kept at 87% a night and adjusted by Recovery (WeekPlan.fatigue_keep);
  - the 42-day running average of training hours (TrainingLoad.CHRONIC_DECAY 0.1535);
  - the 1.3 / 1.5 load lines and x3 (InjuryRoll);
  - training injuries split hand 40, ribs 30, strain 30;
  - mastery fades 0.75 a week but never below Usable (MoveMastery.decay_week);
  - HABIT_COST 6 and the situations that punish each habit (HabitFix);
  - the Cardio line at 64 (BoutRules.FADE_CONDITIONING).
- The ceiling defect is real. Sim.week_ctx passes one `"pot"` and WeekPlan.day / full_day read only that. Recruit.ceiling is read
  only by RecruitPanel. CEILING1 first is the right call.
- Fade at different speeds (holding times from Issurin 2008) is sound science, and it is what gives a camp a real order.
- Measuring before building is well thought out: the cut rule, one gate (TRAINSEASON1) and two foundation probes.
- Lines, not decimals: every ability names the next thing it changes in the ring and the day it gets there. That makes
  training feel like coaching, not a spreadsheet.

## What is wrong or thin (sports science and code)
1. **THE LOAD IS PRICED ON THE OLD HOURS TABLE.** T1 and T14 use TrainingLoad.SETTINGS (Easy 6 / Normal 10 / Hard 15 h). Since
   S354 the game works out the week's hours with Injuries.week_hours = WeekPlan.hours(days_of, PadWeek.evenings). Run on the
   coach's base week (WeekPhase.WEEKS base, 3 pad nights, 1 sparring night), that gives about **8.0 h**. All mornings Hard plus
   PadWeek's 4th pad night gives about **11.4 h**; Easy with 2 pad nights about **5.4 h**. Consequences:
   - the "usual" sits near 8, not 10, so Fitness by the map's own formula would be 87, not 93 or 95;
   - one Hard week adds about +2, not +3;
   - Hard is 1.43 of the usual: the "high" band (injury about x2.3), not the "spike, x3" the map prints;
   - the drawing's numbers ("Fitness 93", "Hard ... Fitness 96 +3") follow the stale table.
   FITLEGS1 would be tuned on the wrong scale.
2. **TWO FITNESSES.** Under the Banister model, fitness is the slow-built ability to perform. In this game that already
   exists: the abilities (Cardio, Strength...) grow slowly, and the week's tiredness fades fast (0.87 a night, about a 7-day time
   constant). The code's stale_energy already turns tiredness into lost energy at the first bell. T14 adds a third quantity,
   "Fitness = 55 + 4 x usual hours", as the top of Legs. Then a fighter with Cardio 70 and a light month enters the ring with
   a lower tank than a Cardio-60 fighter who trains a lot. Cardio and "Fitness" now both mean aerobic fitness. Players will ask
   which one matters, and the probes cannot separate them. The usual hours are real and useful, but as **work capacity**: how
   much load is safe next week (Gabbett's point). They are not a second engine.
3. **THE TAPER IS BACKWARDS.** A deload is set as the Easy load (x0.6 intensity), and the code's TAPER phase uses Light
   mornings. The best evidence says the opposite: cut volume by about 40 to 60% and **keep the intensity**
   (Mujika and Padilla 2003; Bosquet 2007 meta-analysis). Cutting intensity is exactly what lets speed and explosiveness fade,
   and T15 makes those fade in 7 days. So, as written, the map's own deload loses Speed in the fight's last week. The game needs
   a SHARPEN option: fewer sessions at Hard pace.
4. **ONE SESSION RESETS THE FADE CLOCK.** T15 says any session that touches an ability restarts its holding time. One
   roadwork every 29 days would then keep Cardio forever. Research on keeping fitness (Bickel 2011; Spiering 2021) says about one
   session a week, at the same intensity, keeps strength and fitness, and less than that does not. The keep-it rule needs a
   minimum dose per group, shown on the row ("kept by 1 in 10 days").
5. **ONE LOAD A WEEK REMOVES THE HARD-EASY PATTERN.** The classic weekly plan alternates hard and easy days, and Foster's
   "monotony" shows that weeks where every day is alike raise illness and injury. The map makes intensity one weekly choice and
   per-morning intensity only an exception. The code already marks two Hard mornings in a row red (WeekPlan.week "red"). Keep it
   and make it count: a weekly load, which the coach lays out as a hard-easy pattern, and a line that warns when every day is the same.
6. **LEGS (THE TANK AT THE FIRST BELL) IS UNBUILT AND NOT PRICED IN WINS.** T14, the deload and the strip all pay off through
   CLUBWEEK's Legs bar, which is not built (WEEK). In the code, stale_energy applies only after a camp. So today an amateur
   fight week (no camp) pays nothing for tiredness at the bell, and the load choice would have no payoff for the amateurs.
   The load card also shows Legs, but not what Legs is worth in wins on that bout (T2 promises it).
7. **ONE COST FOR EVERY WEIGH-IN.** T8 uses CLUBWEEK's Eat less rate (-1 a 0.1 kg) for every weigh-in. A weigh-in the day
   before (pros, nationals) gives about 24 h to eat and drink back. A 4 pm weigh-in on fight day gives 2 to 3 h. The research on
   making weight (Reale 2017) treats them very differently. The amateur same-day case should cost more.
8. **THE DRAWING DOES NOT MATCH THE MAP.**
   - It shows decimals ("Cardio 61.6"), although T2 says decimals only on hover.
   - It shows "Power", which is not one of the 14 abilities.
   - It lists 6 of 14 abilities, with no way to see the rest.
   - It names a "Lead uppercut", but the move list has only Uppercut.
   - The load buttons print no win price.
9. **THE ESTIMATE PILE IS LARGE.** The Fitness slope, every fade rate, the niggle triggers, the 20% sooner on full rest, the
   OppTests multipliers, Lean, Cut x0.9, and bouts teach 0.5. The plan to measure them is good, but until FITLEGS1 and DETRAIN1
   come back, depth is promised, not proven. The map says so itself, which is honest.

## To reach 10/10 (most important first, each buildable)
1. **Price the load on the hours the game uses.** Replace the 6/10/15 column with WeekPlan.hours over PadWeek.evenings for
   the week as laid out (about 5.4 / 8.0 / 11.4 h on the coach's base week). Recompute every printed number (usual, ratio, the
   injury multiplier, the strip) from Injuries.week_hours and Injuries.chronic. Add a unit test: the load card's hours equal
   Injuries.week_hours for the same fighter.
2. **Drop "Fitness = 55 + 4 x hours" as the top of Legs.** Use the model already in the code:
   - fitness = the abilities (slow, built by sessions, faded by T15);
   - tiredness = week_fatigue (fast, 0.87 a night, shown only as Legs);
   - Legs at the bell = 100 minus the costs of tiredness, weight and the last bout (CLUBWEEK).
   Show the usual hours as WORK CAPACITY: "usual 8.0 h, safe to 10.4 h next week" (the 1.3 line). A run of Hard weeks raises
   what is safe, and that is the slow reward. One bar, no second fitness, nothing invented.
3. **Add SHARPEN as a fourth load, and make the deload and taper keep the intensity.** Sharpen = about half the sessions at
   Hard pace; it opens 10 days before a bout. It clears tiredness like Easy, but every session still counts as a "keep" for
   Speed and Explosiveness. Change WeekPhase.WEEKS taper to fewer mornings at Normal/Hard pace instead of Light. FITLEGS1 must
   show "Hard, Hard, Sharpen, bout" beats "Hard, Hard, Easy, bout" by 1 in 100 or more, or Sharpen folds back into Easy.
4. **Build Legs for every bout, not just camp bouts.** stale_energy should apply in an amateur fight week too (CLUBWEEK's
   FightWeek), and each load button prints its Legs AND its worth on that bout in wins in 100 ("Hard: Legs 81, -2 to -4 in
   100"). This is the payoff of the whole choice; until it is built, the load choice is decoration for amateurs.
5. **Set a minimum dose to keep each ability.** The holding time restarts only with 1 session per window: Speed and
   Explosiveness 1 a week; skills 1 in 10 days; Cardio and Strength 1 in 14 days. Each row prints "kept by 1 in 10 days" and
   the day it fades if nothing comes. DETRAIN1 checks that a season of keep-it mornings costs about a fifth of the week, not nothing.
6. **Keep the hard-easy pattern.** The coach lays a Hard week as hard, easy, hard (no two Hard mornings running: the code's
   existing red day). A "Pattern" line shows varied or all alike. All alike (Foster's monotony over 2.0) multiplies the training
   injury chance x1.5. The player can still break the pattern by hand, at that price.
7. **Price the weigh-in's timing.** Day before (pros, nationals): Legs -1 for each 0.2 kg left to the day. Same day at 4 pm (club
   amateurs): -1 for each 0.1 kg (CLUBWEEK's rate). The Weight card says which applies ("24 h to refill" / "3 h to refill").
8. **Show what Recovery does.** The Recovery ability already sets how fast tiredness clears (0.70 to 0.95 a night). Show it
   in the fighter's header ("Recovers fast") and in the Ready card ("clears 13% a night"). The player can then see why one
   fighter needs a longer deload than another. It needs no new rule.
9. **Fix the drawing so it matches the rules.**
   - Whole points only (decimals on hover).
   - The 14 abilities by name (no "Power"), sorted by what this opponent tests, 8 shown and "Show all 14".
   - Opponent multipliers as a column, not a separate card.
   - A "This week buys" card that runs WeekPlan.week, so the forecast cannot lie.
   - Move names from the data only.
10. **Make the probes measure where the effect is, not just whether it moves win chance.** FITLEGS1 and DETRAIN1 must be
    run on the AMATEUR fight week (12 days' notice, no camp) as well as the professional camp, since three of the four fighters
    are amateurs or a grappler. Any rule worth under 1.5 in 100 there, with no effect over the season, is cut before it is drawn.

## Complete for this version?
YES, with the list applied. For four fighters (one professional, two amateurs, Ana), from amateur to a first professional fight,
the list covers everything training needs:
- a weekly load with an honest price;
- a taper that works the way real tapers do;
- abilities that fade at different speeds and are kept with a real dose;
- each ability's own ceiling;
- lines in the ring with their days;
- the opponent shaping the week;
- niggles and training around an injury;
- weight to the scale's day, with the weigh-in time priced;
- habits as pad work;
- a season strip and a season ledger;
- Ana's class kinds.
The professional's longer bout is covered by T22. Left for later and fine to leave: age and prime, scars, altitude, sleep and
nutrition plans. Without items 1 to 4 it is NOT complete: the load, the deload and the taper are the spine of the map, and they
are mis-priced and have no payoff for amateurs.

## My 10/10 drawing
`docs/mockups/s432/critics/tr3_science_10.html` and `docs/mockups/s432/critics/tr3_science_10.png` (1920x1080, all text 20 px or larger).
It shows:
- the strip with SHARPEN blocks;
- four priced loads (hours from the game's own week, Legs and wins in 100 on the bout, the hard-easy pattern line);
- READY ON THE NIGHT (Legs and its parts, with work capacity in place of a second fitness);
- the niggle priced both ways;
- the week with each morning's pace;
- 8 of 14 abilities as whole points, sorted by what Kayleigh tests, with the dose that keeps each;
- THIS WEEK BUYS;
- weight with the weigh-in timing;
- the habit, pad places with a fading card, and the season ledger.
