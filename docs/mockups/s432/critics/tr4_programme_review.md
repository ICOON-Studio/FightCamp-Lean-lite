# Training map v4 (S432): blind review by a strength and conditioning lead

The reviewer: a strength and conditioning lead at a national amateur boxing programme who plans fight weeks and tapers. This is a fresh, blind review. I read CRITIC_PACK.md, CRITIC_ACCESS.md, TRAINING_MAP_S432.md (all of it), the drawing training_v2.png, the CLUBWEEK v4.1 sections on Legs and the fight-week shapes, and this code: WeekPlan, TrainingLoad, PadWeek, MoveMastery, HabitFix, BoutRules, WeekPhase, InjuryRoll, Recruit, Attrs, Injuries (state), Sim.week_ctx and step_day, BoutNight._peak, and LiveRound line 65.

## Score: 6.5 / 10 (depth)

In one line: the best training model I have seen in a management game, and the map is honest about almost every gap. It still misses two code defects that sit under its own foundations, and its "hours" do not measure the thing that injures boxers.

## What is right (keep all of it)
- Fitness against tiredness (Banister) without a second fitness bar. Work capacity is the slow reward, shown as "safe to 10.1 h". This is how I explain a block to a boxer.
- Sharpen is the right taper: keep the pace, cut the sessions. The code's taper today cuts both, and the map says so.
- Fade by dose, using real retention times (Issurin), plus a "kept by" column that reads the plan. This is the most useful column on the screen for a coach.
- The hard-easy pattern, with monotony priced. The weigh-in hour (3 h to refill on the day against 24 h the day before) is a real decision. I make that decision every season.
- Niggles come from your own load, not from a random deck, and each answer is priced in the habit and the bout. The cut rule (under 1.5 in 100, the choice goes) and "probes before pixels" keep the screen honest.

## Code claims checked
| Claim in the map | Verdict |
|---|---|
| Coach's base week 7.97 h; all Hard + 4th pad night 11.4 h; all Light + 2 pad nights 5.4 h | TRUE (worked from WeekPhase.WEEKS base, WeekPlan.hours, 75-minute pads, 30-minute sparring) |
| START_HOURS 10 makes a new fighter's first weeks read 0.8 of usual | TRUE (7.97 / 10) |
| TrainingLoad.SETTINGS hours still feed ratio(setting), camp_default and the 3.0 h rest week | TRUE (Injuries.setting, Injuries.end_week, gain_mult) |
| stale_energy is 0 without a camp, so an amateur fight week pays nothing for tiredness | TRUE (BoutRules 165, read in BoutNight._peak) |
| Recruit.ceiling is read only by RecruitPanel; the sim passes one pot | TRUE (Sim.gd 120) |
| The taper "cuts intensity, the opposite of the evidence" | HALF TRUE: it cuts intensity AND volume (three rest days, half pad nights). The fix is still right. |
| fatigue_keep 0.885 at Recovery 50; fatigue_mult x1 to x3 from 72 to 80; 1.3 in 100 a 10 h week | TRUE |
| Moves fade 0.75 a week and Usable is kept for good; HABIT_COST 6 | TRUE |
| "Abilities never fall" (section 3, Fade row) | FALSE. Every REST morning lowers Stamina. Attrs.train("", gain, ["recovery"]) adds the gain to Recovery and takes the same amount off Stamina, so that Conditioning, their average, does not move (Attrs.gd 330-334, called from Sim.step_day 213). A taper with three rest mornings turns Stamina into Recovery, and so will Easy and Sharpen. The map's Sharpen, Easy and fade-by-dose rules all sit on top of this without knowing about it. |
| T16 "each ability grows by its own distance to its own ceiling" | NOT DELIVERED by the fix as written. WeekPlan.day works out the gain on the OLD stat's value against the old stat's ceiling (preview_gain(stats, pot, [stat])), then Attrs.train shares that gain out among the children. Passing ceil[stat] gives seven ceilings, not fourteen. Strength and Explosiveness still grow at Power's pace. Footwork and Inside have no parent (Attrs.LEGACY), so they always grow at Technique's or Power's pace. The drawing's "Explosiveness 60 of 62 NEAR CAP" beside a fast Strength cannot happen in the engine. |
| "Cardio 64: no fade from round 3" on a Cardio row among 14 abilities | MISLABELLED. LiveRound 65 reads stats.conditioning, which is the AVERAGE of Stamina and Recovery. "Cardio" is drawn as one of the 14 abilities (the map calls it the stamina group), but the line it shows belongs to the old summary stat. Roadwork moves Stamina twice as fast as it moves that line. With Recovery at 50, the drawn "Cardio 61 to 64 by 6 Mar" is really Stamina 72 needing to reach 78. This also breaks the map's own rule: "never an old-seven summary row". |
| Legs: 1 a point over 50, at most 25 off (CLUBWEEK) | DIFFERENT from the code (stale_energy is 2 a point, at most 20). NOCAMP1 must say which scale wins and how Legs points turn into energy. |
| Samira's "Normal 7.4 h" | CANNOT BE REBUILT from the drawn week. The drawn sessions (six mornings, two pad nights, one sparring night) come to about 6.3 h at Normal pace. Either the cells need their pace shown, or the number is wrong. |

## The S&C problems, most serious first
1. THE INJURY HOURS IGNORE HOW HARD A SESSION IS. Tiredness uses effort x minutes (Foster). The injury ratio uses minutes x the pace multiplier, with no effort score. So 30 minutes of sparring counts as 0.5 h, the same as 30 minutes of slip rope, yet sparring is where boxers get hurt. And "Hard" counts each minute as 1.5 h of hours, so "4.8 h" for Sharpen is not clock time. Price the load in one unit, work points (effort x minutes), for tiredness, the ratio AND the injury chance. Call it "work", not hours, or show real clock hours beside it.
2. REST DRAINS STAMINA (the defect above). Fix it before FITLEGS1 and DETRAIN1 run, or both probes measure the bug.
3. ONE CEILING PER ABILITY must reach the gain itself. Attrs.train should work out each child's gain from that child's own value and ceiling, and Footwork and Inside need ceilings of their own.
4. CARDIO MUST MEAN ONE THING. Either the round-3 line reads Stamina (simplest, and true to the sport), or the row is called "Cardio (Stamina + Recovery)" and shows both parts. The goal "Cardio 64" must read the same number.
5. RETURN TO SPARRING AFTER A BOUT IS MISSING. Every amateur programme stands a boxer down from contact after head knocks; the length depends on the damage. The code has a 30-day stop only after a stoppage loss. The REST block after a bout should carry "no sparring until <day>", set by the head damage taken (for example 0 / 5 / 10 days by band). Sparring nights in that window lock with the reason. This is a real choice: push Thursday's sparring and pay for it.
6. THE WEEK DOES NOT SHOW ITS PACE. The load is the main choice, yet the drawing's cells never say Light, Normal or Hard, and nothing shows the day-by-day tiredness to the bell. Put the 12-day work-and-tiredness chart on the tab (the Condition tab can keep the long curve). It is the one picture a coach plans a taper from.
7. THE FIGHTER'S OWN RESPONSE. Real boxers differ in how much load they tolerate. Recovery covers clearing tiredness only. A hidden "load tolerance" (high, normal, fragile) found through weeks of Hard work, the same way traits are found, would make the safe-hours line personal and turn the first Hard block into a discovery.
8. THE NUMBERS THAT DECIDE THE DESIGN ARE NOT MEASURED YET (FITLEGS1, DETRAIN1, TANKPRICE1, PATTERN1). The map says this plainly and keeps a cut rule. Over 12 days, the ability choices move about half a point, worth under 1 in 100, so Legs, weight and the habit will carry the fight week. Expect the cut rule to remove several ability levers. Keep them for the season view, where they matter.

## To reach 10/10 (most important first, each buildable)
1. Fix the rest-day trade in Attrs.train: Rest adds Recovery and takes nothing off Stamina. Add a unit test where a taper with three rest mornings leaves Stamina where it was. Run it before FITLEGS1 and DETRAIN1.
2. Make T16 real. In Attrs.train, work out each child's gain from its own value and Recruit.ceiling(f, child). Give Footwork and Inside their own ceilings (class strength and gap mapped onto them). Extend CEILING1 so that Strength and Explosiveness, from the same heavy bag, grow at different rates when their room differs.
3. One load unit. Session work = effort x minutes, mornings and evenings, sparring included. Feed tiredness, the usual (EWMA), the ratio and the injury chance from it. The load buttons show "work 7.4" with clock hours on hover. Sparring gets its real weight in the injury chance. LOADHOURS1 checks against this unit.
4. One meaning for Cardio. Move FADE_CONDITIONING to read Stamina, or rename the row and show both parts. FighterGoal's Cardio target reads the same number. The drawing follows.
5. Settle the Legs scale with NOCAMP1: one tiredness-to-Legs rate, one cap, and how a point of Legs becomes energy in the bout. Add a test where the same tired amateur loses Legs with or without a camp.
6. Return to sparring after a bout: a stand-down set by the head damage taken (for example 0 / 5 / 10 days by band, 30 after a stoppage, as now). Sparring nights lock with the reason. The REST block on the strip and the Why's "Rest" button print it.
7. The 12-day chart on the Training tab: work bars, the tiredness line with the 70 and 80 lines, Legs at the bell, and the "Hard to the bell" ghost line for comparison. Each week cell shows its pace (Light / Normal / Hard).
8. A hidden load tolerance per fighter (fragile / normal / durable: the injury chance x1.3 / 1.0 / 0.8), found after 2 Hard weeks the way traits are found, and shown in "safe to" once Known.
9. Draw Lucy's pro camp (BUILD / PEAK / TAPER as Sharpen, Cardio row priced for rounds 3 and 4) and Ana's mat week on the same frame before the Cursor brief, as section 8b promises.
10. Run the probes on the fixed engine (after items 1 to 5). Print sizes in wins only once measured. If FITLEGS1 folds Sharpen, keep the volume cut and pace as the taper's shape anyway: it is right in the sport, and only its size in wins changes.

My 10/10 Training screen: `docs/mockups/s432/critics/tr4_programme_10.png` (HTML beside it). It keeps the map's panels and adds the 12-day work and tiredness chart with the Hard-to-the-bell ghost line, the four fighters' Legs on the header, the after-the-bout stand-down, and Cardio shown with its two parts. It drops the decimals and the per-cell "+48%" detail to make room.

## Complete for this version?
YES, once the list is applied. Four fighters, amateur to a first professional fight: the amateur fight week (Sharpen, Legs on every bout, the same-day scale), the professional's camp (BUILD / PEAK / TAPER, the round-3 and round-4 Cardio line, the weigh-in the day before) and Ana's mat week are all specified. Club week shares the coach between the four. Without items 1 to 5 it is not complete: the engine under the screen would contradict what the screen says (Stamina falling on rest days, one ceiling per pair of abilities, a "Cardio" that is not Stamina, two Legs scales). Without item 9 the professional's and the grappler's tabs exist only as a table.
