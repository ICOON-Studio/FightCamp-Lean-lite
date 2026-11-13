# AMATEURWEEK_CRITIC_S451_JOHN - John answer (seat queue SQ65)

Brief: research/AMATEURWEEK_CRITIC_S451_BRIEF.md
Sent: 2026-11-13 16:40 | collected: 2026-11-13 17:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

Reading AMATEURWEEK v5 against the pack now. The full critic return follows.

# AMATEURWEEK v5 (S451): critic

Depth **6/10**, play **7/10**. The bout sheet is a real decision each time. Home pays money and members, away earns places, and a pass keeps the boxer fresh but risks ring rust.

The fight week itself has one decision that matters over a season: Rest up against the rest. The trips, sparring and who pays are dominated or hollow.

I couldn't open `camp_plan_v3.png` (it's on your computer, which is offline), so I judged from the text.

## 1. Logic check

**Trips:**
- **The cottage and the seaside are dominated by a free rest week at home.** Both are allowed only for bouts 2+ weeks out, so they happen in week 1. But week 1 is a normal home week that already banks in full.
  - The cottage's "banks in full" adds nothing.
  - The seaside banks half, which is worse than staying home.
  - Their only real effect is clearing tiredness. Tiredness only costs tank above 50, and the pack already gives a home rest week +4 morale for $0.
  - $575–1,150 per bout, about 10 bouts a season, buys effects that 0–8 off the tank shows are "inside the noise".
- **The trips are chosen on the wrong screen.** Section 1 puts week 1 of a 2-week bout on the week board, but the trip is picked on the fight week screen, which covers only the last week.
- **The city commute's main effect expires.** It removes the round-1 penalty only for an orthodox boxer who never faced a southpaw (pack 4.3). After one southpaw bout, the $150 buys "+1 plan test a sparring night", which no rule turns into a fight effect. Its ×1.3 injury rate has no stated cause.
- **Two v4 faults are still open:**
  - Food is missing from trip prices. My S449 numbers were about $120 a week for two, plus $40–60 of extras.
  - The coach's week away is unpriced. If the assistant goes, the other boxers train at 60% and the $350 evening class stops. If the head coach goes, who runs the club?

**The tank and the load stops:**
- **The tank adds up past its own maximum.** The full tank is 25 off, but Train through (12) + 2 late sparring nights (6) + Eat less (10) = 28, and "tiredness over 50 costs 1 off the tank, no cap" can add more. Cap it at 25 or say what happens past it.
- **"+1 plan line ready" is still undefined.** With FireLevel on, every usable line already fires at its level. Does Tick over add a line past the plan's 4–6, or lift one line a level for round 1? As written the game can't act on it.

**Sparring:**
- **Sparring in the fight week has costs and no benefit.** Every fight-week night is inside 7 days, so it's always late: ×1.5 injury and 3 off the tank. Its benefit, "one plan test", has no fight value.
- **The claim that 0, 1 and 2 nights are each right somewhere only holds for week 1 of a 2-week bout, which is the week board's job.** On this screen, 0 is always right.

**Who pays:**
- **It's still a cash question with a fake third party.** Savings are $50 of the club's own $250 stipend, so "the boxer pays" is club money already spent.
- **The mood terms make the club always best.** At the measured 61% win share, the boxer paying averages 0.61×4 − 0.39×5 ≈ +0.5 morale, against a flat +3 when the club pays.
- **"Half each: +2, and the club pays half" repeats itself.**

**The bout sheet:**
- **Passing is ambiguous.** Taking one card "closes the others". If closing counts as a pass on those clubs, every pick passes two clubs, and the 8-week no-call lock cascades within a month.
- **The pro offer comes much faster.** Bouts go from about 5.5 a season to 9–11. With 61% wins, 9 wins arrives in about 15 bouts, roughly 1.4 seasons, so most decent boxers get a pro offer in year 2. Say whether that pace is wanted.
- **The nationals are missing.** The pack says no other offers come while a boxer is in the nationals, and camps stay for them. The map never says what the Fights tab shows during the run, or how entries (which close in week 10) sit with a 21-day sheet.
- **"Your assistant picks the bout" can't read the goals.** The goal list (Debut inside a month, Next bout inside a month, Southpaw answer, Five-round engine) has no rank or money goals, so it can't choose home or away.

**The fall-through rate:**
- **The 25 in 100 rate floods the clock.** The pull-out rate per bout (25 in 100) applies to every show. At 1.25 shows a week and 8–12 bouts a show, hosts lose 2–3 bouts a show. "A host can call in a favour" then fires several times a week, refusing costs a favour, and Continue stops for each one.
- **The rate is low.** I measured 25–50% of matched bouts pulling out in the final week, so 25 is the bottom of that range.

**Weight:**
- **The first-hour beat is gone.** The career opens with the boxer 1.4 kg over the limit, a cut started in week 1 (pack 2.5). With walking-weight matching and a 2.5 kg gap at 57–65 kg, that weight decision disappears.
- **The weight row rarely shows.** Once the walk-in story is rewritten, "Ask for a kilo" and Eat less rarely matter.
- **"Train it off" has no amount.**
- **"A miss: bout off, or re-matched on the night" doesn't say who decides, or the odds.**

**Other gaps:**
- **The home ticket share is still blank ("John to confirm").** My S449 memo has no sourced number for it, so the game's $450 is the only figure. Keep $450 and label it a game number.
- **"Not seen drops the line one level" punishes a habit that didn't show in round 1.** That can happen just because the opponent's mode differed. Grade on the opponent's mode that round instead.

**Names and pronouns:** clean on screen. Only roles and "the boxer" are used, and the free-facts cards keep the name in their header.

## 2. Depth: 6/10

**What's real:**
- **The bout sheet is the decision.** Home means $450, +8 members and +5 reputation, with no climb and −2 places for losing to a name below. Away means places and free facts with no money. Pass trades freshness for rust and mood. All three hold across four boxers and a season, and they pull against each other.
- **Rest up against Tick over or Train through is now measured.** Always resting costs about 6 wins in 100 over a season.

**Where it breaks:**
- **Your assistant's pick is the benchmark, so the sliders can only lose.** Every row shows its change from the default, and the season line reads "behind your assistant's pick". If the pick is the best stop, the player's best move is "Use the pick", and by bout 10 the screen goes unopened. The sureness (0.79 for the 58-rated assistant, 0.87 for the 74) is shown but never acts. A wrong pick should be a real worse stop the player can catch.
- **Train through is currently +1.2 over the pick.** It is the always-right stop until the injury costs exist and are measured. That's a precondition for the build, not something to fix later.
- **The trips are never right.** See the logic check: a free home rest week beats both resorts, and the commute is a one-time southpaw fix.
- **Sparring is never right in the fight week.**
- **Who pays always goes to the club unless cash is short.**
- **Favours inflate.** Late replacements arrive several times a week, so every club sits at 3. That makes the kilo free and the 0-lock never happens. Favours become a chore, not a resource.
- **The weight row rarely appears** under a 2.5 kg gap.

## 3. Play: 7/10

A fresh sheet every 3–4 weeks per boxer, with three cards pulling different ways and a visible climb ("ranked wins 2 of 3"), is a reason to press Continue. What drags is a clock that stops for favour calls several times a week, and a fight week screen whose correct answer is "Use the pick".

## 4. Options and menus

| Menu | Verdict |
|---|---|
| Fights tab bout cards | Keep. **Missing:** the bout's effect on nationals entry ("bout 4 of 5 needed, entries close in 3 weeks"), and a goal type the assistant can read (climb, earn, rounds). |
| "Your assistant picks the bout" | Useless until goals include rank or money. |
| Fights rail list | Keep. |
| Pass | Define whether taking a card passes the others. Count only a press of Pass. |
| Fight week trips | Cottage and seaside are useless as written. The commute is useful once per boxer. |
| Load slider | Keep. Its value rests on Rest up's flat round 1 and the injury costs for Train through. |
| Sparring slider | Useless in the fight week. Move it to the week board for week 1, or give it a fight value. |
| Weight stops | Rare. Define Train it off. |
| Who pays | Cash only. **Missing:** fundraiser or sponsor (my S449 numbers: trips are crowdfunded or club-paid). |
| Assistant's pick | **Needs:** the pick being wrong at (1 − sureness) as a real worse stop, and a "why" the player can disagree with. |
| ON FIGHT NIGHT | Keep. Cap the tank. Show the injury chance for the week as a number. |
| Film | Keep. Grade "not seen" by the opponent's mode. |
| Favour call-ins | Too frequent. Needs a cap and the stops batched. |
| Continue stops | Too many once favour calls are counted. |
| Money page | Add home and away income by boxer for the season. |

## 5. To reach 10/10 (mechanics, most important first)

1. **Make the assistant's pick fallible and readable.**
   - The pick reads three facts: tiredness, the tank cost of weight, and the opponent's round-1 style.
   - It is wrong at (1 − sureness): it picks the next-best stop, with the reason it gives.
   - The season line compares each stop against the best stop for this boxer this week, not against the pick.
   - Probe target: a player who reads the box beats always-pick by 2+ wins in 100 over a season, or the slider is cut.
2. **Price Train through before the build.**
   - The fight-week load counts in TrainingLoad.
   - Each late sparring night is ×1.5 injury.
   - Re-run FIGHTWEEKPROBE3 on BoutSheet with 9–11 bouts. Target: Train through 2–4 behind the best stop, and Rest up best when tiredness is 65 or more.
3. **Rebuild the trips around something only a trip gives.**
   - **City commute:** a partner of the opponent's stance or style, giving a round-1 edge of 1.0 against that style for every bout. The once-ever southpaw fix stays folded in. No ×1.3 injury without a cause.
   - **Hill cottage (2+ weeks out):** week 1 runs as Train through with no load-ratio cost and tiredness carried at 0. That is the one thing home can't do.
   - **Seaside:** cut it. A home rest week (+4 morale, free) already exists.
   - Add food to every price ($120 a week for two, plus $40–60).
   - Price the coach's absence. The assistant away means home boxers at 60% and −$350. The head coach away means no head coach edge and no player shouts for any home bout that week.
   - Run CAMPPLACE1 against "home rest week", not against "home normal week".
4. **Give sparring a fight value or move it.** A sparring night confirms one plan line against a live partner, worth the same as a CONFIRMED tell (full fire share from round 1). Fight-week nights stay late (×1.5 injury, 3 off the tank). Week-1 nights are free. This makes 0, 1 and 2 nights each right somewhere.
5. **Cap the tank at 25 off** and make the over-50 tiredness term part of it. Define "+1 plan line ready" as one chosen line firing one level up in round 1 only, or cut it.
6. **Ration the favour economy.**
   - A host asks you for a late replacement at most once per show, and only if your boxer fits the gap and is READY.
   - About 1 ask in 6 shows.
   - All asks stop the clock once a week, on Monday, as one need.
   - Pull-out rate: 35 in 100 (the middle of 25–50) for the player's own bout.
   - Favour test target: an average club sits at 1–2, not 3.
7. **Make who pays more than cash.**
   - Savings come from the boxer's own job, $25–75 a week by the boxer's background. Shown at signing; not club money.
   - Add **Fundraiser**: a club night costing one evening class (−$350) that raises $300–600, with odds following reputation.
   - Mood: club pays +3; boxer pays +6 on a win and −3 on a loss, so a confident boxer wants to pay.
8. **Define Pass.** Only a pressed Pass counts. Two pressed passes on one club means 8 weeks of no calls.
9. **Restore the weight decision.**
   - Walk-in boxers' walking weight sits 2–4 kg above their class.
   - Ask for a kilo matters at the gap edge.
   - Train it off is 0.3 kg for +8 tiredness.
   - A miss is re-matched on the night when the host has a fitting spare (1 in 3), and is otherwise off.
10. **Wire the nationals in.**
    - The Fights tab shows "bouts to entry n of 5" and the entry date on every card.
    - During a run the sheet is closed with that reason, and a camp opens as the pack says.
11. **Add goals the assistant can read:** "Climb to top 3 by <date>", "Earn $n for the club this season", "Three bouts before the nationals". Then "Your assistant picks the bout" works.
12. **Put the pro pace to the owner beside the 3-ranked-wins question.** At 9–11 bouts a season, 9 wins comes in about 1.4 seasons.

## The 10/10 fight week screen at 1920×1080

- **Dark top bar (64 px) and left rail (96 px):** as they are now.
- **Header, 110 px:** the portrait and the boxer's name once, plus opponent class, record and style. Days to the bell, the weigh-in hour, and home or away with the club's favour pips. Buttons: Use the pick and Confirm the week.
- **Left column, 560 px: THE WEEK.**
  - Three sliders: LOAD (Rest up, Tick over, Train through), SPARRING (0, 1, 2, with week-1 or late marked) and WEIGHT (shown only at the gap edge).
  - Under each stop: the tank cost, round 1 sharp or flat, the banked points, and the injury chance this week as a number.
- **Centre, 680 px: WHERE AND WHO PAYS.**
  - Two trip cards (City commute, Hill cottage) and Home. Each shows the full cost with food, its one effect on the box, and the coach's absence cost.
  - Below: who pays (Club, Half, Boxer, Fundraiser), each with cash, savings left, the mood on a win and on a loss, and its greyed reason when unavailable.
- **Right column, 560 px: ON FIGHT NIGHT (gold frame).**
  - TONIGHT: a stacked tank bar capped at 25 with its price in wins, round 1 sharp or flat, plan lines with each one's fire share (SEEN at 90%), the scale margin, the win band.
  - BANKED: stat points and a move crossing a line.
  - SEASON: this stop's season line against the best stop for this boxer, and the assistant's pinned note (portrait, reason, sureness) with a "why I disagree" hover showing the facts it read.
- **Bottom strip, 140 px: THE OPPONENT'S FILE.** Five groups shown as SEEN, CONFIRMED or UNKNOWN. Film on a pad night (greyed for a debutant). Free facts from the last away show as portraits.
