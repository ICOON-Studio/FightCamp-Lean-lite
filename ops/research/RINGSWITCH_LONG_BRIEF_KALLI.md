# RINGSWITCH_LONG_BRIEF_KALLI - Kalli answer (seat queue SQ339)

Brief: research/RINGSWITCH_LONG_BRIEF.md
Sent: 2026-11-26 15:40 | collected: 2026-11-26 16:03 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it. I'm writing three designs for Long range now.

**Build Design 1 first: the waiting cross.** It gives the rear hand a job at Long, makes stepping in a read the other man can punish, and adds no new switch.

---

### DESIGN 1: THE WAITING CROSS

**The rule**
At Long, a cross can be thrown as a WAITING CROSS. It lands only if he steps in during its moment, because he walks onto it. When it does, it counts as a counter (+1), so it does 4. If he didn't step in during that moment, it misses: you lose the 2 stamina, and his later punches that beat become counters. A jab or body jab that lands on a man while he steps in from Long scores as a big punch (2 points) instead of 1.

**One beat at Long** (you are the outfighter)
- You: waiting cross, then jab, lead hand free, feet hold, in the order rear then lead.
- Him: step in first, lead hand held low, rear hand held high.
- **Moment 1:** he steps in and meets your cross, which lands for 4. You're now at Mid.
- **Moment 2:** your jab at Mid finds his lead hand held low, not high, so it lands for 1.

He paid 5 health to cross one range.

**The decision**
You're weighing whether he's coming this beat. Wait with the cross when he has stepped in after a jab before, or when he's behind on points and has to come. Jab when he's holding, and save the stamina. Step in yourself when he's tired or one step from the ropes.

For him, stepping in behind a lead hand held high is safe from the cross and the jab, but his body is then open to the body jab, and that hand can't punch.

**Who it helps**
Both men. The outfighter gets a reason to stand still at Long, and the pressure fighter can still get Inside, but he has to choose how to pay: guard high and eat body jabs, feint first, or step in when the rear hand is spent.

**How it breaks, and the cap**
The lazy plan is to wait with the cross every beat. The caps are that a miss costs 2 stamina and hands him counters, and that a waiting cross can't be thrown two beats running.

The lazy plan on his side is to step in behind a lead hand held high every time. The body jab punishes that, and it scores 2 points on a man stepping in.

**The real boxing**
The outfighter's jab and right hand catch a man who walks in straight. Pressure fighters have to come in behind a high guard, behind a feint, or at an angle.

---

### DESIGN 2: THE ANGLE (CIRCLE)

**The rule**
A new feet choice at Long and Mid: CIRCLE, for 1 stamina. You stay at the same range and win back one point of ground given. If he steps in during that moment, his step finds air: he stays at Long, and your next punch this beat comes from the angle, so his held lead hand can't block it. If he holds his ground, he turns with you, and you've paid 1 stamina for nothing. You can't circle two beats running.

**One beat at Long**
- You: circle, then jab, rear hand held high, in the order feet then lead.
- Him: step in, then cross, lead hand held high, in the order feet then rear.
- **Moment 1:** your circle meets his step in. He steps into air and stays at Long.
- **Moment 2:** his cross falls short at Long. Your jab comes from the angle, so his lead hand held high can't block it, and because his cross missed, it's a counter: 2 health and 1 point.

**The decision**
Circle, hold or back off? Circle when you expect him to step in, or to get off the ropes. Hold when he's waiting, so you don't pay for nothing. Back off only to get a counter, because it gives ground.

For him: step in when you expect the other man to back off or hold, and hold your ground when you expect a circle.

**Who it helps**
Mainly the outfighter. The pressure fighter gets in by holding his ground when the circle is due, or by stepping in on the beat after a circle, when circling isn't allowed again.

**How it breaks, and the cap**
The lazy plan is to circle every other beat. The cap is that the pressure fighter knows the beat after a circle can't be another circle, and that beat is when he steps in.

**The real boxing**
Outfighters don't back up straight. They turn the man and punch from the angle, as Ali and Lomachenko do.

---

### DESIGN 3: CLEAN BEATS (THE JUDGES SCORE DISTANCE)

**The rule**
A beat is CLEAN for a man who lands at least one punch, takes none, and gives no ground. At Long, two clean beats in a round add 1 point to that man on the round's card. Any beat that ends Inside cancels one of the other man's clean beats this round, because he's working on top. Clean beats are shown on both men's cards as small ticks.

**One beat at Long**
- You: jab, rear hand held high, feet hold, in the order lead first.
- Him: cross, lead hand held high, feet hold.
- **Moment 1:** your jab is blocked by his lead hand held high. Nothing lands for either of you, so it's not a clean beat.
- **Next beat:** you throw a body jab instead. His cross falls short at Long, and your body jab lands, as a counter. That's a clean beat, 1 of 2.

**The decision**
Should you poke for clean beats, or step in for damage? Poke when you're ahead or he's careless. Step in when he has a clean beat already and you must cancel it by getting Inside.

**Who it helps**
The outfighter on the cards. The pressure fighter gets a clear target, getting Inside once to cancel a clean beat, so he can still get in.

**How it breaks, and the cap**
The lazy plan is to jab at Long all fight for clean beats. The caps are that a clean beat needs a landed punch and no punch taken, so a man who holds his lead hand high against jabs stops it, and that each round counts two clean beats at most, so the most it can win is 1 point a round.

**The real boxing**
Judges reward clean, effective punching and ring generalship. A man who wins at range without being hit wins rounds.

---

**WHY DESIGN 1 FIRST**
- **It gives the rear hand its first job at Long,** without a long-range bomb: it only works if he walks onto it.
- **It turns "step in now or poke first" into a read for both men.**
- **It uses the switches already in the game.**

Design 2 is the right one to add second, because circling also helps on the ropes.

**To measure** (all NOT COMPUTED):
- at least 25% of beats spent at Long;
- an outfighter bot wins about half its bouts on points against a pressure bot;
- the waiting cross thrown in 5 to 15% of Long beats, landing about half the time;
- stepping in from Long still happens in most rounds.

**GAMES WORTH STUDYING**
- **Footsies (HiFight):** a whole fighting game about spacing and punishing a man who walks in.
- **Exceed and BattleCON:** card games with a range track, where each card says which ranges it reaches and moving is part of the attack.

**WHAT IS STILL WRONG:** I haven't measured any of this. Design 1 might simply teach the pressure fighter to step in behind a lead hand held high every time, if the body jab doesn't punish it hard enough.

All three Long-range designs are in the message above. I'd build the waiting cross first: thrown at Long, it only lands on a man who steps in during that moment, so walking in carelessly costs him and the rear hand finally has a job out there. None of it is measured yet.

The playtest against the Jabber is still waiting on your result for round 1, beat 2.
