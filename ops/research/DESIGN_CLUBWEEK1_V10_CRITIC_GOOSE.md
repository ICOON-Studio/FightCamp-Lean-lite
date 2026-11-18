# CLUBWEEK1_V10 - second critic (Goose, sports management-sim designer)

You are a fresh, independent critic: a sports management-sim designer. Read the whole brief and judge the MECHANIC, not the look of any screen.

## Scores

SCORE depth=6 general=7 play=6

## DEPTH: 6/10

**What works:**
The design has real trade-offs that change outcomes. The class-vs-pads decision is the core lever: selling a full class (+$117, member target +4) costs 3 pad turns and creates BAG nights (half mastery), while keeping pads maintains training quality. This is a genuine money-vs-performance tension. The fight week load stops (tick over / rest up / train through) offer meaningful choices about volume and recovery, grounded in real taper science (Bosquet et al. 2007). The later date rule (decided before the click, never a roll) removes a false choice and gives the player control. Loyalty drifting toward 60 creates ongoing tension without constant crises.

The sponsorship-vs-day-job trade-off is clear: $250/week buys back 1-2 lost mornings, but the day job's cost (-0.2 points/week on one ability) is small enough that a gym can absorb it. The talk system (turn back / promise / straight) gives loyalty management texture.

**What doesn't:**
The coached morning deal is broken. MORNINGSPROBE1 proves that ALL_SOLO dominates both ALL_SHARED and WEAK_FIRST: it gains more total points (63.59 vs 58.53 sessional, 64.32 vs 58.87 full-time) AND more on the weakest ability (16.88 vs 9.29 sessional, 17.68 vs 9.38 full-time). The map claims "shared is the bigger total and solo is the focus" (3.5), but the probe shows solo out-gains shared on every measure because headroom pays the hole more than the multiplier difference compensates. This is a dominant strategy in a weekly decision that should be a real choice.

A gym that sells no classes rarely meets SHORT (the design admits this in risks). With 3 boxers, the squeeze is film and the fourth boxer, but that's honest: the money lever is what makes the club week bite. Still, a no-class gym has weak week-to-week tension.

The fight-week cost line may measure under the 1.5-in-100 cut rule (TAPER1), which would make SHORT cost loyalty only, removing that collision's teeth.

Coach's deal may decide most weeks (acknowledged in risks), leaving the player with one click for the ordinary week.

## GENERAL DESIGN: 7/10

**What works:**
The terminology is clear and consistent: pad turn (20 coach minutes, 3 to an hour), bag night (half mastery), film session (own counter, never a turn). Every concept has one word. The design follows all owner rules: names only in headers (S448), no fixed he/she (S412), every menu wired (S425), ESTIMATEs marked (S459), buildable from what the game has. The later date is decided by a rule and printed on the button before the click, so there's nothing to wait for (pack 4.5: a "no" is a closed panel or an absent answer with its reason).

The probe list is specific with cut rules (1.5 in 100), and the build order is sensible: CHECKs first, then pure rules, then code changes, then screens after owner questions. The page layout (section 12) is concrete enough to draw.

**What doesn't:**
The coached morning mechanic is broken and cannot be wired as designed. MORNINGSPROBE1's finding is clear: "the multiplier is not the lever. Wins follow WHICH ability a morning trains." A design change is needed before wiring: e.g., shared trains the ability BOTH boxers are lowest in, or shared mornings buy something solo cannot (pad turns / sparring readiness for both). Until then, CoachedMornings stays unwired.

Many ESTIMATEs rest on CHECKs not yet run (pad hours, second class, stipend as sponsorship, step mastery counting, weak spot abilities, later-date path, coach budget, loyalty range, pro camp length). If CHECK 1 finds no pad-hour count in code, the 9 and 12 turn values are design values the code must adopt (owner question 2).

The day job is a punishment with no real choice. The default is 1 lost morning (owner question 3), but the player cannot act on it except through sponsorship. A half-sponsorship tier ($125) exists only if the owner picks 2 lost mornings, because at 1 there's nothing to halve. This is a slider the player cannot slide.

Loyalty as a bar conflicts with "traits are learned not shown as numbers" (pack section 3). The design offers owner question 5 (bar or band word only), but the bar's hover says "Under 25: morale -4 each Monday, and morale is the corner's trust," which makes the number matter in the fight. If the owner says no, the bar becomes the band word only, but the moves still happen, so the player needs to see them somewhere.

The page is complex: 1920x1080 with counter strip, coach's week grid, squad rows (one per boxer with morale, loyalty, stickies, seven morning cells, evening magnets, load switch, drag order), grappler row, twist card, talk card, promises, and buttons. That's a lot for one Monday.

## PLAY: 6/10

**What works:**
The collision line ("This fight week lands on a class week: SHORT 1. Short class, cover, Rest up, or the later date.") gives anticipation two weeks out. The reward line ("Fight week on a class week, nobody short: +2 loyalty each") is a small satisfaction. Loyalty drifting toward 60 creates ongoing tension without constant crises. Twists with 2 priced answers add variety. The talk system (turn back / promise / straight) creates drama, especially with the odds in words ("listens: usually").

The NEXT WEEK line shows collisions early, so the player can plan. The later date button (open or greyed with its reason) gives control. The fight week's "three one-to-one sessions, half volume" is a clear, readable change.

**What doesn't:**
The coached morning choice is not fun because it has a dominant strategy (ALL_SOLO). A weekly decision that is not a real choice is not fun to make.

A quiet week is one click ("Coach deals it: same as last week"). This is fast but not engaging. The design accepts this (risks: "Coach's deal may still decide most weeks"), but it means many Mondays are not interesting.

A gym that sells no classes has little week-to-week tension. The squeeze is film and the fourth boxer, but that's not enough to make every Monday bite.

The fight-week cost may be cut (if TAPER1 measures under 1.5 in 100), removing that collision's teeth. Then SHORT costs loyalty only, which is a small price.

The day job is a punishment the player cannot act on (except through sponsorship), so it's not a fun tension.

## Missing options

**Shared mornings that train the pair's shared weak spot:** The probe shows shared is dominated because it trains the coach's day ability for both boxers, not their shared hole. If shared trained the ability BOTH boxers are lowest in, it would be a real choice against solo (which trains one boxer's hole). This would make the coached morning deal a real weekly decision.

**A no-class gym squeeze:** A gym that sells no classes has weak tension. The living world's rival offers (R58) is the likely source, but until that lands, a no-class gym needs a squeeze of its own once a probe shows it needs one. This could be a rival gym poaching a member, or a prospect choosing another gym, or a sponsor asking for results.

**A day job the player can act on:** The day job is a punishment with no real choice. The player cannot slide the slider (0, 1, or 2 mornings) except through sponsorship. A half-sponsorship tier ($125) exists only if the owner picks 2 lost mornings. The player needs a way to negotiate the day job: e.g., "Work mornings only" (2 lost mornings, no sponsorship) or "Work evenings" (1 lost evening, no morning lost) or "No day job" (sponsorship required). This would make the day job a real choice.

**A loyalty bar that doesn't conflict with "traits are learned not shown":** The design offers owner question 5 (bar or band word only), but the bar's hover makes the number matter in the fight. If the owner says no, the player needs to see the moves somewhere. A 4-week log on Overview (as designed) is good, but the player needs a way to see the trend without a bar. A sparkline or a "Loyalty trend: rising / steady / falling" word would work.

## Useless options

**The coached morning deal as designed:** ALL_SOLO dominates ALL_SHARED and WEAK_FIRST on every measure. Until the design changes (shared trains the pair's shared weak spot, or shared mornings buy something solo cannot), this weekly decision is not a real choice. It should not be wired.

**The day job at 1 lost morning with no half-sponsorship tier:** The player cannot act on it except through full sponsorship ($250/week). The half-sponsorship tier ($125) exists only if the owner picks 2 lost mornings, because at 1 there's nothing to halve. This is a slider the player cannot slide, so it's not a real choice.

## What each option changes

**Class (full +$117, short +$78):** Trades pad turns for money and member target. A full class costs 3 turns and creates BAG nights (half mastery). A short class costs 2 turns and keeps the third for row order. This is the core money lever.

**Cover a night ($130, only at SHORT):** Buys 3 turns at the full rate when a class or bout stack leaves a boxer SHORT. Offered only when needed, once a week.

**Pads volunteer ($120/week or $50 on call):** Adds an extra pad hour every week (sessional: Mon, full-time: Sun) at 0.8 of the pads rate. On call is fight weeks only.

**Coached mornings (solo x1.25, shared x1.15, solo on WEAK SPOT x1.40):** Multiplies the morning's stat gain. Solo focuses on one boxer's hole, shared spreads across both boxers. BUT the probe shows solo dominates, so this is not a real choice as designed.

**Sponsorship ($250/week in 4-week blocks):** Buys back the day job's lost mornings. Amateurs and the grappler can hold one. A pro can't.

**Day job (default 1 lost morning, Tuesday):** A boxer without the sponsorship loses 1 morning a week to work. Costs about -0.2 points/week on that morning's ability.

**Fight week load stops (tick over / rest up / train through):** Tick over (default): 3 turns + 1 film. Rest up: 2 turns + 1 film. Train through: 3 turns + 1 film + 1 sparring night (no turn).

**Later date (next show, 2 weeks later):** Decided by a rule, not a roll. Open if the opponent is free, the boxer can make weight, and the season isn't full. Printed on the button before the click.

**Talk (turn back / promise / straight):** Loyalty under 50 triggers "Wants a word." Turn back: dealt first next week, +4. Promise: one of the boxer's open asks, +5 kept / -12 broken. Straight: odds in words, +6 if it holds / -4 if not, then 8-week wait.

**Hold pads (Loyal 70+, 6+ bouts):** The holder gives up their own turn that night and goes to bag. The team-mate's night counts at 0.85 of the pads rate. +3 loyalty a week, 4 weeks at most.

**Twists (7 reworded cards, 2 priced answers each):** Heating breaks, night off, partner ill, southpaw in town, old coach visits, sponsor photoshoot, visiting pro. Each has 2 priced answers.

## To reach 10/10

**1. Fix the coached morning deal before wiring it.** Redesign shared so it trains the ability BOTH boxers are lowest in (their shared weak spot), or give shared mornings a benefit solo cannot buy (pad turns / sparring readiness for both). Then run MORNINGS1 again and confirm each policy is best on 30-70 of 40 seeds. Until then, CoachedMornings stays unwired and the weekly decision is cut.

**2. Settle CHECKs 1 and 2, then run probes 1, 3, 4, and 8, and paste the tables.** The turn maths rests on CHECK 1 (pad hours in code). If the code has no pad-hour count, 9 and 12 are design values the code must adopt (owner question 2). The probes will confirm whether the class price, volunteer price, fight-week cost, and day-job cost are right.

**3. Draw section 12 at 1920x1080 and get owner questions 1-5 answered on it.** The page is complex, and the owner needs to see it before approving. Questions 1 (Club week tab), 2 (bag nights), 3 (day job), 4 (leaving and pro share), and 5 (loyalty bar or band word) all need answers.

**4. Give a no-class gym a squeeze of its own once a probe shows it needs one.** A gym that sells no classes has weak week-to-week tension. The living world's rival offers (R58) is the likely source, but until that lands, a no-class gym needs a squeeze: e.g., a rival gym poaching a member, or a prospect choosing another gym, or a sponsor asking for results.

**5. Make the day job a real choice the player can act on.** The player cannot slide the slider (0, 1, or 2 mornings) except through full sponsorship. Add negotiation options: "Work mornings only" (2 lost mornings, no sponsorship), "Work evenings" (1 lost evening, no morning lost), or "No day job" (sponsorship required). This would make the day job a real weekly decision.

**6. Align with COACHFIT1 so both maps read one budget of turns and mornings (CHECK 7).** The map says "Owned: You 4; Coach 2 sessional or 3 full-time" for coached mornings, but CHECK 7 with COACHFIT1 reads "6 + 2 = 8 and 9 + 3 = 12" for turns plus mornings. Both maps need to agree.

**7. Tune loyalty from LOYAL1 until the talk turns up 2-4 times a season in a class-selling gym.** The drift to 60 and the short penalties need to create the right amount of tension. Too little, and loyalty is a non-issue. Too much, and the player is always in crisis.

**8. Bring back v2 items only as their probes pass, GRAPPLE1 first.** The grappler in the deal, the six new twist cards, sparring settings, mood-only rates, favours, fans and home against away, trial mat, and the fourth start are all gated on their probes. GRAPPLE1 is the most urgent because the grappler is already in the game.

## What a 10/10 looks like (1920x1080 page)

The page is the same layout as section 12, but with the coached morning deal fixed and the day job a real choice. The counter strip shows PAD TURNS, FILM, COACHED MORNINGS (with the fixed shared option), SPONSORSHIP (with negotiation options), and RUNWAY. The coach's week grid shows the pad turns, classes, and cover. The squad rows show the boxers with morale, loyalty (bar or band word, owner's choice), stickies, morning cells (with the day job negotiation), evening magnets, load switch, and drag order. The twist card, talk card, and promises are on the right. The NEXT WEEK line shows collisions early. The reward line is there when nobody is short. The page is complex but readable, and every weekly decision is a real choice with no dominant strategy.
