# RINGSWITCH_BALANCE_BRIEF_JOHN - John answer (seat queue SQ332)

Brief: research/RINGSWITCH_BALANCE_BRIEF.md
Sent: 2026-11-25 13:10 | collected: 2026-11-25 13:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it. I'm starting with why backing off at Long costs nothing, since most of the balance problems come from there.

Most of this comes from one cause: at Long, "jab, then back off" costs nothing. It uses 2 stamina and gives 2 back, and with the trial rule a landed jab also stops the other man coming in. The best move at Long is free and safe, so the bout stays there. Five changes, most important first; every number is a starting value to tune.

## 1. Moving forward beats moving back (try this FIRST)

**The rule**
1. If one man steps in in the same moment the other backs off, the range still closes one step.
2. The man backing off still gives up his square.

**The real boxing:** going forward is faster than going back. That's how a coach's "cut off the ring" works, and it's why the out-boxer ends up on the ropes.

**What I expect it to change**
- **Backing off becomes a guess.** It works against a man who stands still and loses against a man who steps in.
- **More of the bout at Mid and Inside.** The bout should spend much more time there.
- **Fewer crosses miss.** They stop missing 85% of the time, because the man backing off no longer escapes.
- **Needs change 4 alongside.** That gives the out-boxer an answer to a man who walks in.

## 2. A landed jab stops the next moment, not the next beat

**The rule:** a jab that lands stops the other man's step in the next moment of the same beat, and no longer.

**The real boxing:** a good jab stops a man coming forward for a moment. It doesn't hold him off for a whole exchange.

**What I expect it to change**
- **The jab stays useful.** Jab first, then their step in moment 2 fails, so a jab is still the right first click against a walker.
- **The lock goes.** It no longer holds the bout at Long; your own measurement with the rule off already moves Long from 75% of beats to 57%.

## 3. Moving costs breath

**The rule:** a held hand gives back +1 stamina only on a beat your feet stayed where they were (hold or clinch). A beat with a step in or a back off only gets the basic 1 back.

**The real boxing:** the legs go first. An out-boxer who moves all night pays for it in the late rounds.

**What I expect it to change**
- **Jab and back off costs something.** It now costs 1 stamina a beat, so six of them in a row leave you near empty.
- **Backing off stops being a habit.** It becomes something you spend on.
- **The stepper pays too.** The man stepping in pays the same, so walking forward isn't free either.

## 4. Ground scores, and tied rounds go to the man who held the centre

**The rule**
1. In a round where both men land the same points, the man who gave up fewer squares wins it.
2. A round where you backed off three or more times without landing a punch gives your opponent 1 point.

**The real boxing:** judges score effective aggression and ring generalship, the man controlling where the fight happens. That's in the ABC judges' manual I used for CARDBOX1.

**What I expect it to change**
- **Fewer draws.** Today a third of bouts are draws.
- **Backing off has a price on the scorecard.** It's still the right click when it makes a big punch miss.

## 5. Big counters hit harder

**The rule:** a counter with a cross, hook, overhand or uppercut gets +2 damage instead of +1. Jabs and body punches stay at +1.

**The real boxing:** the punch you walk onto, the one you don't see, is the one that drops you. Fury put Wilder down twice in their third fight.

**What I expect it to change**
- **Knockdowns become possible.** With changes 1 and 4 more bouts reach close range, where big punches and misses happen, so a knockdown can follow a good guess.
- **Expect some stoppages.** I'd look for some, not many. If there are still none, try health 22 to 18 next.

## Why "your rear hands land easy" against the Jabber
Your solved mix is two equal men playing the best mix. The owner is playing against the scripted Jabber, which is a separate problem.

My guess, which I haven't checked: the script jabs on a fixed pattern. Its lead hand then isn't guarding in the moment your cross arrives.

The fix is to give the Jabber the solved mix at Long, not a script, and then add its personality on top.

## The weak switches

### The lead hook becomes the check hook

**The rule**
1. A lead hook thrown in the same moment the other man steps in lands first, as fast as a jab.
2. It counts as a counter, so with change 5 it does 3 + 2 damage.

**Where it's the right click:** this is the out-boxer's answer to change 1. Instead of backing off and getting caught, hold your ground and hook a man who steps in. If you guess wrong and he holds too, your hook misses at Long.

**The real boxing:** Floyd Mayweather's check hook dropped Ricky Hatton as Hatton came forward in 2007.

### The lead uppercut becomes the short punch inside

**The rule**
1. The lead uppercut becomes cross speed instead of slow, costs 2, does 3 damage and stays Inside only.
2. Thrown in the same moment the other man clinches, it lands and the clinch fails.

**Where it's the right click**
- **Its moment:** Inside, against a man covering high or about to tie you up.
- **Against the rear uppercut:** the rear uppercut is still the bigger punch, but it's slower. Against a man who'll punch back in the same moment, the lead uppercut gets there first.

**The real boxing:** the short lead uppercut is what Inside fighters throw through the gap in a high guard, and what they use to stop a man grabbing.

## The clinch: what it costs

1. **Where you can clinch:** only from Inside (no longer from Mid), and it uses a moment like a step.
2. **Stamina:** a man who clinches gets only the basic 1 back, with no bonus for held hands.
3. **Warnings:** the second clinch in a round is a warning, shown on screen. The third in a round costs 1 point.
4. **What beats it:** a lead uppercut in that moment, as above.

**The real boxing:** referees warn and then take points for holding. As I remember it, Wladimir Klitschko lost a point against Povetkin in 2013, mostly for pushing down; that's from memory, not checked today.

**What it changes:** the clinch stays the hurt man's way out, but you can't use it every time someone gets close.

## Other arts: what to decide now

1. **Keep three ranges and name each by what lives there.**
   - **Long:** kicks reach it, and so does the jab, just.
   - **Mid:** punch range, plus low kicks and the teep (the push kick).
   - **Inside:** short punches, knees, elbows and the clinch.
   - **Takedowns:** a shot (diving in for the legs) from Mid, and trips or throws from the clinch.
   - **Why it matters:** boxing's Long stays exactly as it is now. Kicks just make it busier, so no fifth range is needed later.
2. **Lines are about where a strike goes, not what throws it.**
   - **Keep boxing's four:** straight to the head, from the side to the head, from below, and body.
   - **Elbows** go on the side line, so the rear hand high stops them.
   - **Knees** go on the from-below and body lines.
   - **Round kicks** go on the side line or the body line.
   - **Only two new lines:** LEGS, for low kicks, and TAKEDOWN. Hands never cover either. A lifted leg covers legs, and a feet choice (sprawl) covers takedowns.
   - **Why it matters:** none of boxing's blocks change.
3. **Fix three speeds now.** Fast, middle and slow, with costs of 1, 2 and 3.
   - **Fast:** the teep and the jab.
   - **Middle:** knees, elbows and the low kick.
   - **Slow:** the round kick and the overhand.
4. **One limb, one moment.** Every strike takes one moment, and a limb that strikes is out of its guard only in that moment, as hands are today. A kicking leg also can't step that moment.
5. **The clinch is a place, not a pause.** Each style decides what happens there, and the price above is boxing's version:
   - **Boxing:** the referee breaks it.
   - **Muay Thai:** knees work inside it.
   - **MMA:** takedowns work inside it.

   Decide this now, so the clinch price only has to be set once for each style.

## What would make me stop after ten bouts
If two people who know the game still play jab-and-back-off at Long, a third of bouts end level and nobody ever gets dropped, I'd have seen every bout there is.
