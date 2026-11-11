# WEIGHT1 - the weight mechanic in the code today (S434)

Read for the owner's S434 ask ("need to strenghen the weight mechanic , what do you think ?" -> "yes start it"). Primary sources
opened: `scripts/rules/WeekPlan.gd`, `scripts/state/Sim.gd`, `scripts/state/Bouts.gd`, `scripts/rules/BoutRules.gd`,
`scripts/state/Data.gd`, `assets/data/world/divisions.json`, `scripts/rules/HeadCoach.gd`, `scripts/state/CampForecast.gd`,
`scripts/rules/{Gauges,PeakCamp,TapeRows,TaleOfTape,WeekCoach,WeekActual,WeekTwist,CoachCheck,GuideLines,ClubStart}.gd`,
`scripts/state/{ProLadder,Champs}.gd`, every `scripts/ui` hit for weigh / kg / limit / diet; designs TRAINING_MAP_S432 (T8),
CORE_LOOP_MAP_S432, CLUBWEEK_MAP_V41_S432 (3.5, 3.7, the table), TRAINSCENE_MAP_S434, the owner's mark (ops/Feedback/2026-11-11-15
mark 6); prior research J_WEIGHT1, G151_WEIGHT_CUT_SPEC, J53, J7, Q20, J_STRESS_S206. All line numbers are at HEAD 7b695d1d.

## In one look

- Weight is ONE number per fighter (`f["weight"]`) that moves every day by a calorie sum. Nothing else carries weight: no walking
  weight, no class choice, no opponent weight, no size on the night.
- A camp cuts by itself while the fighter is over the limit; the cut is 500 kcal a day (about 0.42 kg a week) and costs nothing.
- The scale is pass or fail at limit + 0.05 kg, everyone (amateur and professional) the day before. Fail = bout off, $300.
- The only fight effect of weight: "made weight" is one of the three PEAK CAMP lines (+1 to every stat if all three are met).
- The player sees weight in about 25 places, but never the sum behind it (kcal in, kcal out, what each session burns).

## 1. The rules that run (file:line)

### 1a. Kilos from calories - `scripts/rules/WeekPlan.gd`
| Rule | Where | Value |
|---|---|---|
| Body fat per kg | WeekPlan.gd:69 `KCAL_PER_KG` | 7,700 kcal (comment :14-15, Hall 2008) |
| HOLD eats daily life + a training allowance | WeekPlan.gd:73 `ALLOWANCE` | 300 kcal a day |
| CUT eats less | WeekPlan.gd:74 `CUT_DEFICIT` | 500 kcal a day (comment :16-17, Reale 2017: 0.5-1% of body weight a week) |
| Fight-week drop on a cut | WeekPlan.gd:70-72 `TAPER_KG`, applied :264-265 only when cutting AND phase is "taper" | 0.05 kg a day (0.35 kg a week, gut and glycogen water) |
| A morning's burn | WeekPlan.gd:244-245: kcal = MET x body kg x minutes/60 x intensity burn | METs :31-42 (roadwork 9.3, intervals 11.0, bag 5.8, strength 6.0 ...); burn :45-49 Light 0.7, Normal 1.0, Hard 1.35 |
| The day's kilos | WeekPlan.gd:262-263: kg = -(kcal - ALLOWANCE + deficit) / 7700 | deficit = 500 (+ the head coach's extra) on a cut, 0 on hold |
| Week card twist | WeekPlan.gd:266 `twist_kg` (WeekTwist.gd:39-41 "The scale will not move": Cut harder -0.04 kg a day + 2 fatigue a day, or Trust the process +0.03 kg a day) | the only random weight event |
| Evenings move no weight | WeekPlan.gd:51-52 (comment "the diet covers the evening work"); `full_day` :143-170 never touches `kg` | pads, sparring, film: 0 kg |
| Week and camp sums | WeekPlan.week :277-310 (`kg`, `weight_end`), project :330-341, goal_lines :345-352 (the WEIGHT line: now, this week, fight night, ok at limit + 0.05) | |

What that adds up to on the coach's base week (WeekPlan.gd:84-85 COACH_WEEK), worked from the formulas above:
| Body | HOLD a week | CUT a week | Old hand's CUT | Taper extra (cut) |
|---|---|---|---|---|
| 57 kg | +0.05 | -0.40 | -0.51 | -0.35 |
| 60 kg | +0.04 | -0.41 | -0.52 | -0.35 |
| 65 kg | +0.02 | -0.43 | -0.54 | -0.35 |
| 75 kg | -0.02 | -0.47 | -0.58 | -0.35 |
- Per morning on HOLD at 60 kg: roadwork -0.015, heavy bag +0.009, intervals -0.004, light speed bag +0.024, strength +0.004, REST +0.039.
- HARD roadwork over NORMAL roadwork: about 0.02 kg more a morning. The diet moves the scale about 20 times more than any session
  choice (WeekActual.gd:84-85 says the same in a comment). This matters for part 7: "which sessions burn most" is real but tiny.

### 1b. When the cut runs - `scripts/state/Sim.gd`
| Rule | Where |
|---|---|
| CUT only while over: `(diet == "cut" OR a camp is set) AND weight > limit - 0.15`, else HOLD | Sim.gd:117-118, 121 (`week_ctx`); same test for the "cut" twist cards Sim.gd:100 |
| A camp cuts whatever the diet pill says; on any diet the cut stops 0.15 kg under the limit | Sim.gd:118. So in camp the Hold/Cut pills (WeekCamp.gd:256-262, WeekBoard.gd:411-416) change nothing while over |
| Daily step and a hidden band: weight never steps below min(now, limit - 1.5) nor above max(now, limit + 1.6) | Sim.gd:214-216 (`step_day`); copied in Sim.gd:149-151 (`weigh_forecast`) and CampForecast.gd:67-69 |
| The old hand (head coach card) cuts 120 kcal a day deeper | HeadCoach.gd:23-24 `OLDHAND_CUT_KCAL`, :79-80, :89 -> Sim.gd:125 -> WeekPlan.gd:262 |
| Recovery speeds fatigue, not weight; body weight scales burn only | WeekPlan.gd:244-245, :273-274 |

### 1c. The forecast - `Sim.weigh_forecast` (Sim.gd:131-155)
- Dry-runs every day to the weigh-in on a copy: the coach's phase weeks, a camp assumed from tomorrow (:134-135), the twist cleared
  each Monday (:144), the same clamp. Returns {now, day (kg on the morning), limit, ok, over, days}.
- The weigh-in is ALWAYS the day before the bout (:137 `n = bout_day - 1 - today`).
- Callers: BoutPage.gd:45, FightPrep.gd:97 and :155, FirstWeekStrip.gd:178, CoachCheck.gd:51, GuideLines.gd:93, Bouts.makeable_day.
- CampForecast.run (CampForecast.gd:41-83) is a second dry run for the camp modal and gauges (kg on the weigh-in morning, weigh_ok).

### 1d. Offers dated around the scale - `scripts/state/Bouts.gd`
- `makeable_day` (Bouts.gd:150-162): a boxer over the limit gets the offer dated a week at a time later, up to `WEIGHT_WEEKS_MAX` 4
  (:46), until the forecast reaches the limit itself (S374, Danny 61.6 for 60).

### 1e. The weigh-in - Bouts.gd and BoutRules.gd
| Rule | Where | Value |
|---|---|---|
| Weigh-in day = bout day - 1, for amateur, professional and championship bouts alike | Bouts.gd:89-91 `weigh_in_today`; fight day needs `weighed` :94-96 | |
| Made = weight <= limit + tolerance | BoutRules.gd:87 `WEIGH_TOLERANCE`, :171-172 `made_weight` | 0.05 kg |
| Missed: news, the first-hour lines, the club pays for the empty slot, bout and camp cleared, next offer later | Bouts.gd:327-347; BoutRules.gd:88 `MISSED_WEIGHT_COST`; Bouts.gd:43 `AFTER_MISSED_WEIGHT` | $300; 6 days |
| Missed at a championship: out of the draw, no fee | Bouts.gd:332-338 -> Champs.withdraw | |
| A championship's back-to-back second day counts as weighed and made | Champs.gd:148-149 | |
| Professional bouts use the same weigh, the amateur class limit and the same $300; no purse share | ProLadder.gd:324-325 (bout with purse), Bouts.gd:328-347 | |
| `bout["made"]` is written but no fight rule reads it | Bouts.gd:331; only TestJump.gd:303 sets it | |

### 1f. The only fight effect - PEAK CAMP
- PeakCamp.gd:28-36: three lines on fight night - weight <= limit + 0.05 (`WEIGHT_SLACK` :16), the camp stat on target, fatigue never
  overreached. All three = +1.0 (`BONUS` :11) to every stat for that fight (BoutNight.gd:104-110, removed :342).
- Nothing else: no weight, kg or size term in BoutRules.fight_power (:182), Exchanges, Duels, BoutNight or the 3D fight.

### 1g. Classes and starting weights
| What | Where | Value |
|---|---|---|
| The eight amateur classes (England Boxing / World Boxing 2025) | Data.gd:124-145 `DIVISIONS` | women 57 / 60 / 65 / 75; men 57.5 / 60 / 70 / 75 |
| A fighter's class is fixed when signed; nothing changes it after | Data.gd:240-244 `fighter_state`; FirstHour.gd:125 (the walk-in); SaveGame.gd:66-85 (one-off migration only) | no move up or down anywhere |
| Everyone walks in over | Data.gd:54 Lucy 60.9/60; :206-226 Kira 58.3/57, Samira 65.9/65, Tess 76.1/75, Danny 61.1/60, Josh 71.4/70; HomeJuniors.gd:23-35 | 0.6 to 1.4 kg over |
| The debt start's walk-in | ClubStart.gd:18 `DEBT_WEIGHT_OVER`, :78 | +2.2 kg |
| World professional tables, by the amateur limit | ProLadder.gd:38-46 (fw <= 57.5, lw <= 62, wr <= 70, else mw); WorldGen.gd:195-200 reads `max_kg` | |
| divisions.json holds old professional limits | assets/data/world/divisions.json: lightweight 57.0-61.2, welterweight 61.2-66.7, featherweight 53.5-57.0, middleweight 66.7-72.6 | not the fighter's scale limit (her amateur 60 / 65 is) |
| Opponents carry no weight | TapeRows.gd:71-80 `opp_weight`: 0.2-0.8 kg under the limit by a name hash; TaleOfTape.gd:24-29 `opp_kg`: 0.2-1.4 kg under (a second, different formula, used by the 3D intro FightIntro/FightCast) | invented, never cut |

### 1h. What reads weight to advise the player
- WeekCoach.gd:38-44 (the coach's one change: "This week ends X kg over the limit. Switch the diet to Cut." / "Still X kg over on
  a cut. <hard roadwork>").
- WeekActual.gd:42-45 (the week review's weight row, plan vs actual, 0.15 kg close), :82-91 (suggest: cut first, then Hard roadwork).
- GuideLines.gd:28-37, :90-93 (first-hour guide: "won't make weight", "Set the diet to Cut", "makes weight Friday, fights Saturday").
- CoachCheck.gd:48-57 (roster check row: "X kg on the day" / "X kg over on the day" / "on the limit" / "X kg over, no bout yet").
- Needs.gd:75-76 ("Weigh-in today: <name> must make X kg", red).
- Gauges.gd:6-7, 22-32, 43-45, 56-79 (the SCALE dial: green to limit + 0.05, amber to + 0.5 `SCALE_NEAR`, red past; window 3 kg).

## 2. Designed, not built

| Design | Where | What it adds | Code today |
|---|---|---|---|
| THE LAST DAY'S WATER (WATERCUT1) | TRAINING_MAP_S432 T8 (:397-412), probe row :616 | Professionals on a day-before scale may plan up to 2% of body weight as water in the last 24 h, refilled at a Tank price (day before: -1 a 0.2 kg; same day: -1 a 0.1 kg, -2 past 0.5 kg; at most Tank -6). One line: "Lucy: Lean + 0.8 kg water on Fri: Tank -4 at the first bell" | none: no water, no Tank (BoutRules has only `stale_energy` :165-168) |
| LEAN diet | T8 table :401; TRAINSCENE :220, :236 | -250 kcal, -0.23 kg a week, no price | Hold and Cut only (WeekCamp.gd:260) |
| CUT's price | T8 :402 | mornings x0.9 (ESTIMATE) | free |
| THE WEIGH-IN'S HOUR (WEIGHHOUR1) | T8 :403-406; CLUBWEEK 3.7 :237-241 and table :274 | Amateur club shows weigh in on the day; professionals, the regional and the nationals the day before | everyone the day before |
| The amateur club scale | CLUBWEEK 3.7 :237-241, 3.5 :128-129 (WEIGHTGAP1) | made at the weight both WALK at, 1.0 kg gap; over it: EAT LESS (Tank -1 a 0.1 kg), TRAIN IT OFF (a session with no gain and +5 tiredness a 0.25 kg), ASK A KILO (1 favour; the heavier boxer +2 tank a 0.5 kg); a miss = no bout, $300 and a favour | class limit only; no favours |
| THE WEIGHT panel / sum | TRAINSCENE :49-50, :120, :155, :202 (the owner's mark 6 is on it); T8 :411 | "SCALE SAT 28: 65.9 -> 65.4 kg, MADE; limit 66.0 at 9 am"; gauge with a red zone; three diet chips with what each leaves on the day (Hold 65.9 / Lean 65.4 / Cut 65.0) | the gauge exists (GaugeRow); no diet chips priced, no per-day or per-session sum |
| Fighters row and Profile | CORE_LOOP :79-80 (WEIGHT: kg, bar to the limit, amber "0.9 kg over" only with a weigh-in coming), :95 (TODAY with "Weight + Cut"), :110 (weight with the weigh-in's hour) | | partly: HomeRows/RosterTable show kg and over |
| Old research, never carried to Lean | G151_WEIGHT_CUT_SPEC (the old repo's fight-week water choice), Q20 s2 (catchweight within 3%, 20% fine), J7 P10 (keep 20%; Nevada 25%) | | none |

Contradictions inside the designs (to settle before any brief):
- Amateur weigh-in hour: CLUBWEEK 3.7 says 4 pm on fight day; TRAINSCENE :49/:65 says 9 am; GaugeRow.gd:247 already tells the player
  "Weigh-in <date>, 1 h before"; the code weighs the day before. Real: England Boxing about 1 h before boxing (J53, R1 7.1.3),
  championships the day of; BBBofC professionals 24-36 h before (J53, R8 3.2.2).
- Amateur miss: CLUBWEEK says no bout + $300 + a favour; real England Boxing = a walkover to the opponent, no fine (J53 item 4).
- The water's 2%: T8 lets professionals only; J_WEIGHT1 and England Boxing guidance say keep fluid loss under 1-2% for amateurs.

## 3. Every place weight shows on screen today (scripts/ui)

| Screen | What it shows | file:line | Wired to |
|---|---|---|---|
| HOME roster row | "60.9 kg", "0.9 to lose" / "On weight"; amber only inside 14 days of a bout | HomeRows.gd:15, :195-201 | f.weight - f.limit |
| HOME strip / Fixtures | "weigh-in" the day before each bout | Home.gd:62-63; Fixtures.gd:19 | bout.day - 1 |
| HOME needs | "Weigh-in today: <name> must make X kg" (red) | Needs.gd:75-76 | Bouts.weigh_in_today |
| HOME side news | "missed weight" counts as bad news | HomeSide.gd:11 | news text |
| First-week strip | "Weight: 60.9 kg now, 60.1 kg on the morning, limit 60.0. ..." ; "Weigh-in Friday, fight Saturday." | FirstWeekStrip.gd:132, :150-184 | Sim.weigh_forecast |
| Guide line | "won't make weight", "Set the diet to Cut" | GuideLines.gd:28-37 | weigh_forecast |
| Fighters > Roster table | "On weight" / "0.9 kg over", good / watch (< 1.5) / bad | RosterTable.gd:55-56; flag via CoachCheck :107, :125 | weight - limit |
| Fighters > Roster cards | tile "+0.9 kg", tooltip "Weight against the class limit"; class colour | RosterCards.gd:175, :213-220 | weight - limit |
| Fighters > tile | WEIGHT ring "60.9", "limit 60.0 kg" / "0.9 kg over"; coach-check row | FighterTile.gd:57-60, :99-100 | weight, CoachCheck._weight |
| Fighters list | "60.9 of 60.0 kg" green / amber | Fighters.gd:175-176 | weight - limit |
| Fighter page > Overview (dark) | "60.9 kg", "limit 60.0 kg", note "Over: 0.9 kg to cut" | DarkOverview.gd:379-387 | weight - limit |
| Fighter page > BODY tab | Weight, Class limit, Plan "cutting" / "holding" | FighterPage.gd:127-129 | f.diet (the pill, not what runs) |
| Fighter page > classic | "Weight 60.9 of 60.0 kg" | FighterPage.gd:203 | weight, limit |
| Fighter page > Training (WeekBoard) | with a bout: "60.9 / 60.0 kg" (tooltip: Scale X kg), Hold / Cut pills ("Cut 500 kcal a day."); coach's change with "Do it" (diet) | WeekBoard.gd:380-391, :402-416, :429 | WeekCamp.forecast -> GaugeRow.read; WeekCoach.advice |
| Training > morning card's index card | "Weight +0.02 kg" for that day | WeekDay.gd:79 | WeekPlan.full_day kg |
| Training > THIS CAMP column | WEIGHT line "60.9 > 60.0 kg" (no bout) or the SCALE gauge (with a bout); diet pills "Hold" / "Cut 500 kcal" | WeekCamp.gd:76-94, :157-159, :236-262 | WeekPlan.goal_lines / GaugeRow |
| SCALE gauge (camp modal, Training) | class window as a band, needle = weigh-in forecast, ghost tick = today; tooltip "Weigh-in forecast X kg against the agreed Y kg ... Weigh-in <date>, 1 h before; diet only." | GaugeRow.gd:3, :141-148, :246-248; CampSide.gd:47 | CampForecast.run, Gauges |
| Week review (Monday) | weight row plan vs actual "+0.04 kg"; coach's suggest line | WeekReview.gd:413-414 | WeekActual.rows / suggest |
| Bout offer page | chip "Weight at risk"; "Weight 60.0 kg"; red "<name> would come in X kg over even cutting from tomorrow ... $300" | BoutPage.gd:44-56, :95, :145-147 | weigh_forecast |
| Versus panel (offer) | chip; row "WEIGHT, LIMIT 60": her forecast vs the opponent's invented weight | VersusPanel.gd:159, :185-196 | weigh_forecast, TapeRows.opp_weight |
| Tale of the tape (2D) | "ON THE SCALES" row, her CURRENT weight vs the opponent's | TapeVersus.gd:21-26; FightPrep.gd:116 | TapeRows._weight :64-68 |
| Fight prep | "to fight night ... weigh-in <date>"; chip "Scale: 0.4 kg to spare" (amber under 0.5); CAMP AND WEIGHT card "On the scale 60.9 now -> 60.0 on the morning, limit 60.0 (... to spare)"; button "Step on the scale" | FightPrep.gd:30, :65-66, :92-99, :139-158 | weigh_forecast |
| Weigh-in modal | "THE DAY BEFORE", "WEIGH-IN", "60.0 kg" green/red, "Limit 60.0 kg. On the mark." / "X kg over. No camp, no cut."; "Step on the scale" | WeighIn.gd:2, :13-28 | BoutRules.made_weight |
| Weigh-in result toast | "made weight. Tomorrow is fight night." / "missed weight. The bout is off and the club pays $300" | BoutActs.gd:219-227 | Bouts.weigh |
| 3D fight intro | tale of the tape WEIGHT row (opp by TaleOfTape.opp_kg) | TaleOfTape.gd:16, :24-29; fight3d/FightIntro, FightCast | |
| Fight poster | class word or "60 KG" | FightPoster.gd:75 | limit |
| Create screen | "Walk-in: ..., 62.2 kg for the 60.0 kg limit (2.2 over)" | CreateScreen.gd:247-248 | ClubStart.walkin |
| Kit icon | "Weight now / class limit" | KitIcon.gd:18 | |
| Nationals | "Each round is a normal bout: camp, weigh-in, your corner." | NationalsView.gd:58 | |

Not anywhere: the kcal a session burns, the diet's kcal, the day-by-day path to the scale, what each diet would leave on the
morning, a walking weight, the opponent's real weight or cut, size on the night.

## 4. Gaps against the seven parts

| Part | Code today | Gap (what must be built) | Real-world basis on file |
|---|---|---|---|
| 1 Walking weight and the class choice | One weight; a hidden clamp band limit - 1.5 to limit + 1.6 (Sim.gd:214-216) stands in for a walking weight; after a bout the boxer stays at the cut weight for good (HOLD drifts about +0.04 kg a week); the class never changes (Data.gd:244) | A `walk` (natural weight) the body drifts back to after the scale (rebound in days), a class decision on the fighter page (move up / stay / move down) with its cut size and opponents' size, class change rules (offers, rank reset?), pro limits vs amateur limits (divisions.json 61.2/66.7 vs 60/65) | G151: walk-around often 12-15% over the class for pros (ISSN 2025); J_WEIGHT1: amateurs cut 4-5.5% in the last 5-10 days; Q20 s1: class choice is body and business, not temperament |
| 2 The cut's price and prize | Cut is free (no gain, fatigue or mood cost); Lean not built; weight's only fight effect is the PEAK CAMP line (PeakCamp.gd:35); opponents' weights are invented (TapeRows.gd:74-80) and two formulas disagree with TaleOfTape.gd:26-29 | Cut x0.9 mornings and + fatigue (Lean milder) in WeekPlan.day; a night weight (scale weight + refill) for both corners and a small power / chin edge per kg heavier, shown as "<name> will be about 3 kg heavier than <opponent> on the night"; one opponent-weight rule | T8 x0.9 is ESTIMATE; G151: NO STUDY ties kg regained to winning (Reale 2018 commentary) - the prize must be an ESTIMATE with a probe (cut rule C27), modest; Hall and Lane 2001: a 5% cut in a week worsened circuit and mood |
| 3 The fighter's character | `discipline` (FighterProfile.gd:7) is read by PushBack, CornerJobs, TheRead, never by weight; no slips; no mood from a cut | Daily adherence roll from discipline ("+0.6 kg, ate out Saturday"), a mood cost for a hard cut (FighterProfile.apply_morale), the news line, the forecast showing a range for low discipline | Q20 s4: no published link between personality and weight discipline (authored, label it a game rule); J_STRESS 3 and Hall and Lane 2001: hard cuts raise anger, fatigue, tension |
| 4 Amateur same day, professional day before | Everyone weighs in the day before (Bouts.gd:89-91, Sim.gd:137, WeighIn.gd:16, FightPrep.gd:92); GaugeRow.gd:247 already says "1 h before"; no water, no Tank | `weigh_day` per bout kind (club show / regional / nationals / pro / championship), the hour on every screen, T8's water for pros priced in fight-night ENERGY, amateurs barred from dehydrating | J53: England Boxing about 1 h before (R1 7.1.3), championship max loss 1 kg; BBBofC 24-36 h (R8 3.2.2); G151: day-before regain ~4.4% over ~22 h (Jetton 2013) |
| 5 Graded consequences | Binary at +0.05 kg: bout off, $300, offers +6 days (Bouts.gd:328-347); pros the same; no reputation, no miss record, no injury | A little over: bout goes on, a share of the purse to the opponent (pros) / walkover rules (amateurs); well over: off; a miss counter that cools promoters and costs reputation; crash cut = injury risk up, Stamina down | J7 P10: purse 20% customary, Nevada 25%, Oregon 20% after 2 h, both waive within 1 lb; J53: amateur miss = walkover; Q20 s2: miss rate UNKNOWN (do not invent one) |
| 6 The opponent cuts too | Opponents have no weight, walking weight or cut | Opponent walking weight and cut size from the world data, shown on the bout page and tape; a hard-cutting opponent fades late (the same ENERGY price as ours) | the same sources as part 2 and 4 |
| 7 A plan you can calculate | The sums exist (WeekPlan.day per day, week/project per week, weigh_forecast to the morning) and per-day "+0.02 kg" sits on the morning card hover (WeekDay.gd:79); the kcal behind it, the diet's share and the day-by-day path are never shown (the owner's mark 6) | A WEIGHT panel: kilos day by day to the scale, each morning's burn, the diet's kcal, what Hold / Lean / Cut leave on the morning; the coach's line names the biggest lever | KCAL rule WeekPlan.gd:13-17 (Compendium 2024, 7,700 kcal/kg); the honest finding: diet ~0.45 kg a week vs a Hard morning ~0.02 kg - the panel must show that the diet is the lever |

Code facts a brief must carry:
- The diet pills are a no-op in camp while over the limit (Sim.gd:118): either make them real choices (Hold / Lean / Cut) or remove them.
- The clamp is copied three times (Sim.gd:149-151, :214-216, CampForecast.gd:67-69); a walking weight replaces all three in one rule
  module (a new `scripts/rules/WeightRules.gd` under the 500-line rule), and Sim.gd is at 499 lines - it can take no new lines.
- REST on HOLD gains weight (+0.039 kg a day: the 300 kcal allowance with nothing burned); a taper week on HOLD climbs.
- `bout["made"]` is never read; PEAK CAMP reads the raw weight against the limit instead.
- Two opponent-weight formulas (TapeRows.gd:74-80 vs TaleOfTape.gd:26-29) show different numbers for the same opponent.
