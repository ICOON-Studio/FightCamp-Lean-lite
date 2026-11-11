# From the build to the fight: a judge's and coach's review (S432, fresh blind critic)

Seat: a boxing judge and amateur coach. What wins an amateur bout: clean punches that land, who controls the ring, the tank in round 3, and the plan.
Read: CRITIC_PACK.md, CRITIC_ACCESS.md, the code (scripts/rules, scripts/state), the real screens (critic_pack/screens 09, 12, 19b, 21), RULE4_PARKED_S398.md,
and the parallel maps only to link to them (CLUBWEEK_MAP_V41_S432, RPG_LAYER_MAP_S432, HYPE_MAP_S432; TRAINING_MAP_S432 does not exist yet).
Nothing was run: no Godot. Sizes below are read from the constants, against the exchange's dice (each side rolls 0 to 66, so one exchange's luck has a spread of about 27 points).

## Score: 5.5 / 10

One line: the engine under the fight is deep and mostly honest, but the player cannot see which of their choices won or lost the bout, one plan still
answers almost everyone, and the cards are not scored the way a judge scores a round.

## 1. How the build decides the fight, as built (traced in the code)

Every 30-second exchange is one number, the edge, plus dice. LiveRound.exchange adds these parts (power points; the dice spread is about 27):

| Input | Where in the code | Size in one exchange | Verdict |
|---|---|---|---|
| The build: attributes at the place the exchange is fought (range, pocket, inside) | RingDuel.step -> Duels.at, K 0.5 | 10 points better on every tool = about 5 to 6 | REAL, the backbone |
| Punch levels (Jab, Cross, Hooks, Uppercut) = move mastery from the pads | Attrs._punches, _keep_punch | a hook from 33 to 56 = about 3 in the pocket | REAL, fastest-growing lever |
| Form on the night (both sides, once a bout) | RingDuel.form, FORM_SD 5 | spread about 7 for the whole bout | luck, never named on the result |
| Corner shout: fit x can do it x heard x trust | Exchanges.call_edge, EDGE best 17 / wrong -10 | about +12 to +14, wrong about -15 | REAL, the biggest single lever |
| Plan line (arrow) fit | PlanFight.EDGE best 9 / wrong -7, PlanRead +3.5 x 2, PlanPressure 3 | up to about +16 stacked | REAL, but see "one plan fits all" |
| Habit punished, not fixed | HabitFix 6 x HABIT_BOUT 1.75 | about -10.5 when it bites | REAL |
| Pace Push / Save, Aim at a hurt place | PaceAim 6 / -4, +4, +3; Push on an empty tank -12 | 3 to 6 | REAL |
| Set-up NOW, The Read counter | CornerJobs 14 / -9, TheRead 7 / -5 | one exchange each | REAL |
| Tiredness (week tiredness over 50 = up to -20 energy at the first bell) | BoutRules.STALE, Duels.effective | legs and guard -12 at empty, flips to "your fighter is tired" under 35 | REAL, the week's best link to the night |
| Camp protocol edge | BoutRules.PROTOCOLS 0.25 / 0.6 / 1.0 | under 1 | near decoration |
| Film answered | FILM_PER_ANSWER 0.4, max 1.2 | about 1 | near decoration as a number (film's real value is the corner's read) |
| Weapons count, combinations known | WEAPON_EDGE max 0.9, Combos.edge max 0.6 | under 1 | decoration |
| Peak camp | PeakCamp, +1 every stat | about 0.5 | near decoration |
| Perks | PerkFight: Stiff jab +3, Ring general x1.25 calls, Counter sense 3 in 10 a +12 counter, Finisher, Fast hands x1.4 | 1 to 4 when they fire | REAL, small |
| Traits | coachability 0.7 to 1.0 of each shout; morale trust 0.7 to 1.05; heart against the late fade and the count; temper, confidence, discipline in the corner's talk | a few points | REAL, readable only in hover |
| Style dials (pressure, work rate, body share, counter) | FighterProfile.style_dials -> Attrs pace / forward -> Duels | decide WHERE the fight happens | REAL and HIDDEN: no screen reads or sets them |

What this means for a boxing person:
- The order is right: the better-built fighter usually wins over 18 exchanges, and the corner turns close ones. The duel model (tools at three places, a
  best tool, height inside, reach at range, southpaw straight, the ropes) is the strongest part of the game. Real boxing reads like this.
- The training that moves the fight most is the pads (a punch's level IS its mastery, and pads give 2.1 mastery an hour), then the mornings (about 1 point a
  focused week), then not overreaching (the tank). The camp's own numbers barely count, yet the result page puts the camp first.
- Attrs.VALUE (measured): +10 of Flexibility is worth 1.5 wins in 100, Recovery 2, Composure 2, Fight IQ 2.5 in the duel. A mobility morning is close to a
  wasted morning, and the screen does not say so.

## 2. What the player decides, and what each changes

| Decision | Where | Changes | Can the player read it? |
|---|---|---|---|
| Signing + one starting focus | Interview | +10 signature mastery / habit gone in 4 weeks / +5 potential | yes, on the card |
| The mornings (session x Light/Normal/Hard) | Week | one attribute each, tiredness | partly: the gain shows, its fight value does not |
| The pad nights (which move or combination) | Week, pads tray | punch level in the duel; combinations for the plan | NO: "Hook 33" is never set against "their guard 58" |
| Camp focus, intensity, partner, film | Camp modal | stat forecast, tiny night edge, southpaw round 1, the corner's read | the forecast yes; the night value no |
| The plan lines | Playbook | the arrow per card, reads, pressure | yes (Beats it / Works / Walks into it), but one plan fits most |
| Shout every 30 s, Pace, Aim, NOW | Fight night | the biggest swings | yes: clue line, three calls, the verdict line |
| Corner minute: fix, recover, set-up, talk, plan arrow | Fight night | as above | yes |
| The fighter's natural pace and pressure | nowhere | where the fight happens | NO option exists |

## 3. What is good (keep)
- Three places with their own tools and answers (Duels.TOOLS): range is jab and feet against feet and IQ, the pocket is hands against guard, inside is
  inside work against strength. That is how a coach reads a matchup.
- The shout is priced three ways at once: does it fit what the opponent is doing, can the fighter do it (green is "can", not "right"), does the fighter
  hear it (coachability, trust, only two instructions a minute get through fully). Real corners work exactly like this.
- Habits that the opponent's game punishes, and a corner fix that holds as far as the fighter listens.
- Punch levels come from the pads. The cheapest, most physical link from the week to the night.
- Week tiredness carried into the ring as lost energy at the first bell (with a source). A good camp you cannot recover from is a bad camp.
- The plan's effect is replayed on the same dice (plan_swing): the honest way to say "the plan won 2 exchanges".
- Push is not free: an empty tank turns Push against you.

## 4. Missing options (the player cannot do something a coach would)
1. Set the night's style: how far forward, how busy. The dials are in the fight and not on any screen. A coach decides "box at range tonight" or "walk
   them down" before every bout; today the only levers are the shouts that force a place.
2. A plan that has to be read for THIS opponent. RULE4_PARKED_S398 is still true in the code: PlanFight.ANSWERS has 1-1, step_back and 1-1-2 "best" on
   both games of the same card (long: range and counter; mid: press and load-up). One fixed plan does as well as reading the tape.
3. A matchup read that names the punch and the answer: "the pocket is theirs: your hooks 33 against their guard about 58". The bout page compares the old
   seven stats; the duel never reads "Technique".
4. A way to know which choice won the bout. The Why grades the plan only. Shouts, the habit fix, the build, tiredness and form on the night are never
   counted on the result page.
5. A corner's own read of the cards in round 3 ("we are one round down"): the decision to push or to save in the last round has no information behind it.

## 5. Useless or misleading options and lines
1. "WHAT DECIDED IT: CAMP - Conditioning held up when it mattered." BoutRules.why writes this for every Standard or Hard camp, won or lost, whatever
   happened. It is a canned line in the place of a measured cause.
2. "Took a standing count in round 2: that round went wide on the cards." BoutRules.scorecards builds the cards from rounds won only; a count never
   changes a card. The line is false.
3. The cards themselves: every 2-1 bout is a split with the third judge one point the other way, every 3-0 is unanimous. The judges never decide anything.
   On the real result screen the loser LANDED MORE (61 to 56) and lost on all three cards: a round goes to whoever won more 30-second exchanges, not to
   whoever landed the cleaner punches. A judge would not score it that way, and the player cannot tell why.
4. Sharp and Signature on plan lines: FireLevel is off (no bout sets fire_level), so a line fires every time from 30. Sharp is worth about 1 win in 100 over
   Usable (pack 4.2). The tiers show on every move card and change almost nothing.
5. Weapons count and "combinations known" (under 1 point each), the camp's night edge (under 1): they are listed as reasons but are noise against a
   27-point dice spread.
6. The mobility morning (Flexibility, 1.5 wins in 100 for +10): a session the player will pick for nothing.

## 6. New mechanics, only where decisions are thin without them
A. THE JUDGES (scoring like an amateur round). Each exchange already records landed punches, body shots, who kept the place and big shots (set-up, The
   Read, counts). Score each round per judge from those: clean punches landed first, then the bigger shots, then who controlled the ring (the place
   keeper, RingDuel._keeper). Three judges, each with one lean shown on the bill (Work: counts every punch / Clean: big shots count double / Ring:
   control counts). A count is a wide round. Split decisions then come from close rounds, not from a formula. This is the agreed "judges with taste"
   (S425) brought forward only as scoring; the judges' names and history stay with the small world.
   It also fixes the universal plan from the boxing side: backing off (step_back, pivot_out, step_out, roll_out) still wins the exchange's damage but
   gives the round's control to the opponent, so against a Ring judge, or when behind, retreating answers cost rounds. Lines then compete.
B. THE NIGHT'S DIALS. On the plan: Forward (how far in) and Busy (how many punches), each within 15 of the fighter's own, priced by the costs the duel
   already has (Duels.FWD_GUARD 0.28 guard per point, PACE_GUARD, PACE_HOT). The corner minute may move each by 10. The build direction in the RPG map
   (section 12) moves the fighter's own dials over weeks; this is the per-night choice inside them.
C. THE SCALES (what moved the result). Every part of an exchange's edge is a separate term in LiveRound.exchange, and the plan's swing is already replayed on
   the same dice. Do the same for each part: the build (duel edge without form), form on the night, the shouts, the plan, the habit (paid or fixed),
   tiredness (legs at the first bell), the camp and film, perks. The result page shows them ranked, in exchanges turned and rounds turned, your choices
   apart from the build and from luck. This extends the RPG map's ledger (section 13, LEDGER1) to every input, not only the picks.
D. THE MATCHUP MAP (before the bout). For the booked opponent: the three places, your edge at each (Duels.at), the tool that decides it and the answer it
   meets, and what moves it before Saturday (a session or a pad card, with its forecast). Shown on the bout page (replaces the seven-stat rows), on Fight
   prep, and as one line on each pads card and morning. The club week's bill (CLUBWEEK v4.1 section 4) then has something to point at.

## 7. To reach 10/10 (most important first, each buildable)
1. THE SCALES on the result page. Record each edge term on the exchange (rec already holds plan_edge, read_edge, duel_edge); compute swing per term as
   plan_swing is computed (won with the term minus won without it, same dice); sum per bout; rank. Groups: YOUR WEEK (build, punches, legs), YOUR PLAN, YOUR
   CORNER (shouts, fix, set-up, talk), THE NIGHT (form, perks, the opponent's habits). Delete BoutRules.why's canned lines and the false count line; "What
   decided it" becomes the top three rows of the scales. Gate: on 600 played bouts the rows' sums agree with turning each input off within noise.
2. Score rounds like judges (A). Round winner per judge from clean punches landed, big shots, ring control; a count = 10-8; three judges with a shown lean.
   Gate: "out-landed and lost the card" happens only when a judge's lean explains it, and the Why names the judge and the reason.
3. Make the plan a read (RULE4). Retreating answers lose ring control with the judges; each card's two games get conflicting best answers. Gate from
   RULE4_PARKED: the reader beats a fixed universal plan and a headline bot by 3+ wins in 100 per opponent at N=600.
4. THE MATCHUP MAP (D) on the bout page, Fight prep and the Week: places, duel numbers with punch levels, "they win at / break at", and the session or
   pad card that moves each. Replace the seven-stat comparison there.
5. THE NIGHT'S DIALS (B) on the plan and in the corner minute, with the price shown before the press.
6. Switch FireLevel on at the measured shares (usable 1 in 2, sharp 3 in 4, Signature always; +2.8 and +2.7 wins in 100), so drilling past 30 is a real
   choice; the move card says what the next tier buys on Saturday.
7. Show punch levels where they are trained and fought: the pads card reads "Lead hook 33 -> 41 by Saturday, their guard about 58". Audit the starting
   levels (Data.START_MOVE_SHARE puts the uppercut at 0, so a new fighter's uppercut tool is 1 against an opponent's ~58): start untrained punches at a
   floor, or say so on the card.
8. Give every morning a fight value or cut it: Flexibility and Recovery get a second channel (Flexibility: training injury risk; Recovery: the tank
   refilled in the minute and the tiredness cleared by Monday) or fold into the session that already trains them. Each morning card prints its value
   against the booked opponent in wins in 100.
9. Coach quality in the corner: the coach's rating sets how often the corner's mark and the corner's card are right (link RPG map section 11, coach
   grows). The head coach's background edge shows in the minute.
10. One golden-path test that walks the build to the fight: sign, two weeks of mornings and pads, a plan, a bout, and asserts the scales name the inputs
   that changed. A Handbook page "What wins a bout" prints the measured table (section 1) in wins in 100, updated by the probe.

## 8. Every menu it appears on, and what each is wired to
| Menu | Shows | Wired to |
|---|---|---|
| Fights > bout page (offer) | THE MATCHUP MAP: three places, your edge, punch vs answer; the three judges' leans | Duels.at, RingDuel.wins_breaks, AttrGen (scouted range), judges |
| Fighter > Fight prep | the map, "what moves it by Saturday", the dials | WeekPlan forecast, MoveMastery forecast, style_dials |
| Fighter > Week (mornings and pads tray) | each card's value against the booked opponent | Duels.at with the forecast attribute |
| Fighter > Playbook > Game plan | the night's dials; each line's value with each judge | style_dials, PlanFight, judges |
| Fight night, the minute | the corner's card (the coach's guess of the rounds), dials +/- 10 | judges, coach rating |
| Fight night, the result | THE SCALES, the cards with each judge's reason | per-term swing on rec, judges |
| Week review (Monday) | the season's scales: what the week's work turned | sums of the scales |

## 9. Complete for this version?
Yes, with the list applied: four fighters, amateur bouts to the first professional fight. The fight model is already rich enough; what is missing is the
scoring, the plan's read, the night's style and the honest receipt. The BJJ fighter's match needs the same receipt (item 1) on its own beats; that
was not reviewed here.

Drawing: docs/mockups/s432/critics/fl_judge_10.png (the result page with THE SCALES and the judges).
