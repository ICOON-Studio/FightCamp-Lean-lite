# RINGSWITCH_IDEAS2_BRIEF_KALLI - Kalli answer (seat queue SQ329)

Brief: research/RINGSWITCH_IDEAS2_BRIEF.md
Sent: 2026-11-25 05:40 | collected: 2026-11-25 06:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'll work out five ranked changes for Ring Switches now.

The first change to build is a **body jab** on the lead hand. It turns Long range into a real guess (guard high or guard low) in a day, and it's the change the other four build on. The five, most important first:

**1. THE BODY JAB** (fixes problem 1)
- **The rule.** Add Body jab to the lead hand. It reaches Long and Mid, costs 1 and is blocked only by the lead hand held LOW. Like every body punch, it shortens the stamina bar. Only a head jab keeps the man out next beat; a body jab doesn't.
- **One beat.** You're at Long. You walk in with the lead hand high, and the Jabber throws a body jab. Your high hand protects nothing below, so the jab lands and your stamina bar shrinks. You do reach Mid, because a body jab doesn't keep you out.
- **What it adds.** The walk-in is now a guess. Hold high and you're safe from the head jab, which would also keep you out, but you pay at the body. Hold low and you're safe from the body jab, but a head jab lands and stops your walk. Early in a bout high is right, because getting in matters most. Late, when your bar is short, low is right. For the Jabber, the head jab wins position and the body jab wins the long fight.
- **How it can break.** Always holding high, because being kept out hurts more than a body shot. **The cap:** the machine's habit read already punishes the same plan twice in three beats, and that now applies to the walk-in. Also make every third body jab that lands in a round cost 1 extra stamina.
- **The real boxing.** Floyd Mayweather's jab to the body that brings the guard down, so the head jab can land.

**2. CIRCLE OFF** (fixes problem 2: out-boxing can win)
- **The rule.** Add Circle to the feet. It costs 2 stamina and can't be used two beats running. If the other man steps in that beat, his step fails and the range stays the same. It also wins back one square of ground.
- **One beat.** The Jabber is one square from the ropes. You step in with the lead hand high, and the Jabber circles and jabs. Your step fails, you stay at Long, the Jabber gains a square back, and your high hand blocks the jab.
- **What it adds.** The out-boxer is no longer just walking to the ropes. For the man coming forward, it's step in or wait: stepping into a circle wastes 1 stamina, but waiting gives the out-boxer a free beat. Circle when your back is near the ropes. Back off when you have ground to spare, because it's cheaper.
- **How it can break.** Alternating circle with back off forever. **The cap:** it costs 2, so circling every other beat runs the out-boxer dry by round 2. And stepping in on a beat when the man can't circle (he circled last beat) always works.
- **The real boxing.** Vasiliy Lomachenko's pivot: he's never on the ropes because he turns off them.

**3. HURT, AND THE CLINCH TO SURVIVE** (fixes problem 3: bouts end early)
- **The rule.** A big punch that lands as a counter, or any punch that lands on a man with 0 stamina, leaves him HURT for the next beat. A hurt man can't punch or step: he can only hold his hands or clinch. Any big punch that lands on a hurt man knocks him down at once. After a hurt beat, he can't be hurt again for one beat.
- **One beat.** The Slugger's jab misses, so your lead hook comes in as a counter, lands, and hurts him. Next beat he clinches and you throw an overhand. The clinch means nothing lands, and he survives. Had he clinched last beat (no clinching twice running), he could only hold his hands. Your overhand meets only the rear hand held high, and he holds the lead hand low to guard the uppercut, so the cross lands.
- **What it adds.** Counters become finishing chances, and the clinch gets a real job. The attacker plans two beats ahead, and the hurt man guesses which hand to hold. Save your clinch for when you're hurt. Spend it to rest only when you're well ahead.
- **How it can break.** Fishing for counters by holding both hands and waiting. **The cap:** a man who holds both hands three beats running loses 1 point for the round, because judges score work. Hurt also can't chain, because of the beat he can't be hurt again.
- **The real boxing.** In round 9 of Gatti against Ward, Ward's body hook hurt Gatti, and Gatti held and somehow survived.

**4. ONE QUESTION PER OPPONENT** (fixes problem 3: opponents)
- **The rule.** Each opponent gets one rule of its own and one habit it reads.
  - **The Jabber** uses the body jab and circles. It reads your feet and asks: can you get in?
  - **The Slugger** walks through a landed jab once a round, and any of its big punches that lands hurts you. It reads your hands and asks: can you punish his walk without getting caught?
  - **The Body Snatcher** clinches whenever you're inside and it's tired, and its body punches shorten the bar twice as much. It reads your range and asks: can you keep it off you at Mid?
- **One beat.** At Mid you jab, the jab lands, and normally the Slugger couldn't step in next beat. It uses its once-a-round walk-through, comes in with an overhand, and your rear hand held high blocks it. Then the Slugger's walk-through is gone for the round.
- **What it adds.** Each opponent needs a different plan. You hold low against the Jabber and the Body Snatcher, high against the Slugger. You fight at Long against the Jabber, at Mid against the Body Snatcher, and against the Slugger you spend its walk-through first. Your fixed plan stops working against all three.
- **How it can break.** One plan beats all three: a sensible player who always answers last beat. **The cap:** the three habit reads differ, so answering last beat gets read. The goal is that no single bot policy wins 70% or more against all three. That target is mine; it hasn't been measured.
- **The real boxing.** A real fight plan changes with the opponent: Ali boxed Liston, and roped-a-doped Foreman.

**5. THE FEINT FREEZES A HAND** (fixes problem 1 again, and gives the feint a job)
- **The rule.** If you feint while the other man holds a hand HIGH or LOW, that hand blocks nothing for your first punch next beat. A feint costs 1 and does no damage. If he punched that beat instead, the feint did nothing and his punch lands as normal.
- **One beat.** You're at Long. You feint and the Jabber holds the lead hand high, so it's frozen. Next beat your head jab goes through the high hand, lands, and he can't step in.
- **What it adds.** There's now a third choice at Long. The jab beats a walk-in with no guard, the high-guard walk-in beats the jab, and the feint beats the high guard one beat later. Feint against a man who holds. Punch against a man who feints.
- **How it can break.** Feint, jab, feint, jab. **The cap:** the habit read catches the pattern, and two feints in a round with no punch landing cost a point.
- **The real boxing.** Bernard Hopkins froze guards with a feint and threw the next punch into the gap.

**Build first: number 1, the body jab.** It's one new lead-hand option and one blocking rule. It answers problem 1 directly and gives the Jabber its second question at once. **The case against it:** it could become a coin flip. But the head jab and the body jab win different things (one wins position, the other the long fight), so the right call changes with the stamina bar. A coin flip pays the same either way. Once it's in, measure how often the sensible bot jabs: from 5% of beats now, it should rise.

**Cut: the guard bar.** It never broke in 1,800 bouts, so it's a bar that does nothing. Holding a hand already gives you stamina back, and that cost is enough. Push off can stay, but I'd watch it next: once circling exists, it may do the same job.

My first change would be the body jab, and the guard bar is what I'd cut. With a body jab, walking in behind a high lead hand becomes a real guess between guarding high and guarding low. The guard bar never broke in 1,800 bouts, so it does nothing. The other four, ranked, are circling off the ropes, a hurt state you can survive by clinching, one clear question for each opponent, and a feint that freezes a held hand. The goal of no single bot plan winning 70% or more against all three opponents is my own target, not something we've measured.
