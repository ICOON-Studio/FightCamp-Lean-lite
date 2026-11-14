# DESIGN_WEIGHT1_R5_CRITIC_MARIA_MARIA - Maria answer (seat queue SQ150)

Brief: research/DESIGN_WEIGHT1_R5_CRITIC_MARIA.md
Sent: 2026-11-15 00:10 | collected: 2026-11-15 00:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I give WEIGHT1 round 5 **DEPTH 7, GENERAL DESIGN 6, PLAY 6**, so it clears the owner's bar for the first time. Round 5 fixes what held earlier rounds back:
- It keeps today's miss rule until the owner rules.
- It uses Energy, not Tank.
- It has one kilo rate and one amateur scale.
- It cuts the size edge.
- It re-prices the "when the opponent tires" line with FireLevel and PlanRead.
- It adds no new tab.
- It stands alone in release 1.

What keeps it from higher is that it still changes one built rule without asking, the scale moving from the day before to the same day. It also adds four new systems at once (the declared weight, the matchmaker call, the weight target, the class at signing), and every price is still unmeasured.

## Scores

**1. DEPTH: 7/10**

What works:
- **The declared weight is the right lever for club shows.** It's a standing setting with a real trade: activity and the opponent's experience against Energy, with the CODE −6 mood for a dry month as the price of being picky. Real amateur clubs do exactly this. A coach tells the matchmaker a weight, and the boxer is matched within a range, not a class limit.
- **The fault rule finally follows each boxer's own weight,** with a no-fault call-off when both are inside but the pair isn't. It's fair and it's readable.
- **The three examples prove that different boxers want different answers.** A boxer with discipline 34 and a Steady mood near the edge takes Half a plate. A fresh, disciplined championship boxer takes Cut 5 days and no burn mornings. That's depth through the fighter's traits, not a lookup.
- **The window ties weight to the plan,** and the re-priced example reverses round 4's verdict to "drill first, then write". That's a good interaction with the Playbook.
- **The weight target lowers the walk slowly,** which gives a reason to manage weight between bouts.

What holds it back:
- **The matchmaker call's "ask for 0.5 kg" is nearly free.** A refusal doesn't spend the call, so the player should always ask on every accepted offer. The only cost is losing "Find another name" for 8 weeks if the ask succeeds, and a success is exactly when the scale is safer. Expect it to be used on almost every cut.
- **Meal prep is right only in a narrow case.** It works only beside a No, and the map's own example says No makes this boxer Flat, so meal prep is "the wrong buy". It pays only for a boxer whose mood sits well inside a band, which is the same boxer for whom No was already cheap.
- **The weight target has no downside except +0.5 tiredness a day** and no upside the player feels until months later. It will be set once and forgotten, or never.

**2. GENERAL DESIGN: 6/10**

What works:
- Every critic point has a row and an answer.
- The CODE table names files and lines.
- One word list (Energy, Tiredness, the window, Declared weight).
- Words beside every colour.
- "Weight is safe: nothing to decide" keeps a quiet week to one click.
- The panel leads with costs and only shows WIN at a spread of 3+.
- Release 1 and release 2 are cleanly split.
- Owner questions 2 and 3 are good catches. The men's 57.5 kg class isn't a World Boxing class, and a 65 kg woman has thin UP and DOWN choices without 70 kg.

What fails:
- **The same-day scale changes a built rule without an owner question.** CODE weighs in the day before (Bouts.weigh, the Home "Weigh in" need). The map moves amateurs to 1 hour before, citing England Boxing. That's real practice, but it changes the clock, the need, the fight-week pacing and the miss table. It belongs beside question 1, not inside B5.
- **There are too many new systems for one mechanic.** D0, the matchmaker call, the weight target, the class at signing, the CLASS section, the eating ask, the nutritionist per cut, burn mornings and the Monday check add up to nine. Each is reasonable alone. Together they're a lot to learn for a mechanic that, per P1, may often be "too close to call".
- **D0 rests on a pool filter that doesn't exist.** The matchmaker today draws by class and safety. "Opponents in reach within the gap of a declared weight" means every regional boxer needs a walk and a declared weight (B2 does this for one opponent at a time, not for the whole pool). That's buildable, but it's a world change, and the map lists it as a filter.
- **Most of the key numbers are still open.** The EB category widths, the tolerance and the gap are all TO SOURCE, with stand-ins. The kcal rate is a stand-in. The goal-missed value is a CHECK. The rest-day recovery is a CHECK. The worked numbers are honest about this, but almost nothing in 8.1 can yet be trusted to the decimal.
- **The 20-line menu table is wide for weight.** M15, a News line "asked to eat: half a plate", is information the player can't act on (S398), and M14 and M19 are borderline.
- **B6 extends stale_energy to every booked bout.** That changes every amateur fight, not only cut ones. It's correctly bundled with B0 under one re-measure, but it should be an owner line too.

**3. PLAY: 6/10**

There's anticipation: the miss risk in words, the Monday check, the fighter's weekend ask. There's a moment, the scale ticking up to MADE or OUTSIDE, and a payoff when "your tires line fired 2 times" shows in the Why. The declared weight gives a season-long reason to come back. But most weeks a cut is a set of standing answers you set once. When WIN is too close to call, the reward is mostly "nothing went wrong".

## Options: missing, useless, and what each changes

**Missing**
- **Ask the owner to keep the day-before scale as a choice of rule.** If he wants the same-day scale, the miss table and the Home need move with it.
- **A price on the 0.5 kg ask.** For example, it spends the call whether or not the other corner agrees, or it costs a small amount of reputation with the matchmaker. Then asking and keeping the call is a real choice.
- **Move up for one bout.** At a club show, a one-off declare at the walk for a single offer, without changing the standing setting. Real coaches take a fight a little heavy to stay active.
- **A visible reward for the weight target,** such as a line on the declare choice: "walk −1 now costs no Lean".

**Useless or near-dominant**
- **Ask the other corner for 0.5 kg** while a refusal is free: always pressed.
- **Meal prep:** right only for a boxer who didn't need it.
- **The News line about the eating ask:** nothing to act on.
- **Met or missed on the weight target:** the map says it has no effect, so don't print it.

**What each option changes**
- **Declare the walk:** no cut, fewer opponents in reach, risk of a dry month (−6 mood).
- **Declare walk −1:** Lean and +0.5 tiredness a day, a different slice of the pool.
- **Declare walk −2:** Lean plus a trim (about 90 Energy in the example), opponents with fewer bouts.
- **Burn morning:** about −0.06 kg and +1 Energy, and the morning's ability no longer trains. The goal may drop under its line.
- **Let the fighter eat:** +0.5 kg, +5 mood.
- **Half a plate:** +0.2 kg, −2 mood under discipline 40.
- **No:** 0 kg, −5 mood, and the boxer may eat anyway.
- **Meal prep:** $10 a day, and a No always holds.
- **Nutritionist:** $60, and asks are halved for this cut.
- **Trust the trim:** the trim's Energy price.
- **Cut 5 days:** −0.32 kg and +7.5 tiredness.
- **Pull out:** −$300, no ticket cut, no loss, next offer 6 days later. At a championship it ends the run.
- **Automatic re-weigh:** sweat up to 0.3 kg at −2 Energy a 0.1 kg.
- **Ask for 0.5 kg:** the target rises by 0.5 kg about 1 time in 2.
- **Find another name:** the bout goes ahead about 1 time in 2.
- **Weight target:** Lean between bouts, and the walk drops 0.2 kg every 4 weeks on target.
- **Move class (now or after the next bout):** a new class, and the boxer leaves the regional table.
- **Hear or Overrule the ask to move up:** +5 or −5 mood.
- **Drill it, then Write it:** the tires line moves a FireLevel step before it goes in the plan.

## To reach 10/10

1. **Make the same-day scale owner question 1b,** with its consequences printed: the weigh-in need moves to the bout day, there's no overnight recovery, and the miss table changes. Build B5 on his answer.
2. **Price the 0.5 kg ask:** it spends the matchmaker call either way. Then P21's 30–70 split is a real test.
3. **Cut or merge to fewer new systems in release 1.** Ship D0, the cut levers, the scale and the fault rule. Move the weight target, the class at signing and the nutritionist to release 2. Keep the CLASS section only if owner question 2 adds classes.
4. **Write the pool change as its own build row.** Every regional boxer needs a walk and a declared weight (POOLWEIGHT1), with a test that declaring walk −1 changes the next offer's pool. Run P3 on it before D0 goes on screen.
5. **Get John's EB category widths and tolerance, and Claude's kcal rate and goal-missed value, before any other probe,** then re-print 5.1, 5.2, 8.1 and 8.2 from them.
6. **Make meal prep earn its place,** for example "a No holds, and the ask can't come back this cut", priced at about $10 a day (ESTIMATE). Otherwise cut it.
7. **Add "This bout at the walk"** as a one-off on a club-show offer, so the standing declare isn't the only way to stay active.
8. **Remove the News line for the eating ask and the met or missed line for the weight target.** Keep only lines the player can act on.
9. **Add B6 (stale for every booked bout) to the owner questions,** since it changes every amateur fight.
10. **Run P1, P3, P14 and P21 and paste the tables.** If P1 says WIN is too close to call in most bouts, say plainly that the mechanic's value is avoiding misses and Flat nights, and make the costs column the hero.

**My 10/10: Fighter page > Fight prep, CAMP AND WEIGHT, 1920×1080, Look B whiteboard**
- **Dark top bar:** CONTINUE "to Sat 28, the scale at 6 pm".
- **Portrait header:** the name once, the class, the bout date circled in marker.
- **Left (40–620), THE SCALE:**
  - A marker line from today's weight to the target, with the walk dotted.
  - "0.4 kg room" and "miss 1 in 100" in words.
  - At a club show, both declared weights with the gap drawn between them, the fog band reading "no tape: first bout", and the matchmaker call magnet reading "ready, spends on use".
- **Centre (660–1260), THE CUT:**
  - The coach's row in the one gold frame, with Energy at the bell as a stacked bar and the deciding costs in words ("Flat on the night 2 in 5", "Goal on track", "Cash $0").
  - Three magnets with prices printed: Burn mornings, If the fighter asks, Monday check.
  - One pencil alternative.
- **Right (1300–1880), FIGHT NIGHT:**
  - Both corners' Energy at the bell.
  - The 18 exchanges as boxes with the window shaded and "R2: 1 · R3: 4" written under them.
  - The tires line with its expected fires and the button "Drill it on the pads, then Write it".
- **Bottom (980–1060):** "Too close to call on WIN" or the WIN line, Pull out (danger, with its price), and Change the week.
- **When nothing is at stake,** the whole block is the single line "Weight is safe: nothing to decide".
