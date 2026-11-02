# K87_DECISION_PACING_REPLY - Grok bot kalli reply, verbatim (S236 collect)

PART 1 of 2. The day budget is 6 cards that stop the clock, with no more than 2 in any game hour. Anything over that is handled by the coach, who makes a call (good or bad depending on his skill) and writes one line in the day log. Nothing is dropped silently, and an injury risk always jumps the queue.

**1. Budget and caps**
- **Day budget:** 6 cards that stop the clock on a normal day (about 4 hours of game day at 1x), plus the Morning Day Plan, which doesn't count.
- **Hour cap:** 2 per game hour, with at least 20 game minutes between two cards.
- **Over budget or over the cap:** the card is coach-resolved. The coach makes the call and the day log gets a line with a small coach icon, for example "Coach: called the rep. Form +2, strain +4." Clicking the line opens the card read-only, so the player can see what the coach chose.
- **Merge rule:** a Form Breakdown and a Corner Rehearsal at the same block end merge into one Corner Rehearsal card, with the form line as its first line. Two Niggles on the same region merge into one.
- **Never dropped:** Niggle (an injury risk) and Breakthrough (rare). They can wait or merge, but they always reach the player or the log.

**2. Priority and wait or expire**
The priority order runs from first to last:
1. Niggle (injury risk)
2. Sparring Flash (the ring can't stay frozen, it's mid-exchange)
3. Breakthrough
4. Corner Rehearsal
5. Form Breakdown
6. Floor Event

What happens if a card waits:
- **Niggle:** waits up to 30 game minutes. Past that, the coach rests the region (a safe default) and logs it.
- **Sparring Flash:** never waits. If it can't show, the coach makes the call at once.
- **Breakthrough:** waits until the block ends, then defaults to "bank it" (nothing lost).
- **Corner Rehearsal:** expires when the next block starts. The default is the planned station.
- **Form Breakdown:** expires after 15 minutes, and the coach calls it.
- **Floor Event:** waits up to 60 minutes. Past that it takes its seeded B option (the passive one) and logs it.

**3. 3x speed**
- **Still stop the clock at 3x:** Niggle with soreness over 60, Breakthrough, and Sparring Flash only when a knockdown or cut risk is involved.
- **Coach-resolved at 3x:** Form Breakdown, Corner Rehearsal, Floor Event, any routine Sparring Flash, and any Niggle under 60.
- **How good the coach's call is depends on his coaching skill (0-100):**
  - Chance he picks the call the sim scores best: 50% + skill/2, so 50% at skill 0 and 100% at skill 100.
  - A worse call still pays a share of the value: 60% + skill × 0.3, so 60% at skill 0 and 90% at skill 100.
  - Risk: a coach under skill 40 pushes niggles 30% of the time. Over 70 he never does.
  - The log line shows a small star rating of the call (one to three), so the player learns what a better coach is worth.
  - This makes hiring a good coach the upgrade that buys back attention.

**4. Quiet days**
Yes, quiet days are part of the rhythm and the player can see them coming:
- **Recovery day:** budget 2. Only Niggle and Breakthrough stop the clock, and the rest is coach-resolved.
- **Fight week, Monday to Wednesday:** budget 4, with Sparring Flash and Corner Rehearsal weighted up.
- **Fight week, Thursday:** budget 3 (the test spar, from K86). Friday has no floor cards at all, only the weigh-in.
- **Days after a fight:** budget 2 for 2 days. No Floor Events fire.
- The day plan shows the day's budget as pips ("●●○○○○ quiet day"), so a quiet day reads as a choice, not a bug.

PART 2 of 2

**5. The table**
Each card's line gives its maximum per day, its priority, whether it stops the clock at 1x and at 3x, the auto-pick rule, and the coach-skill effect.

- **Niggle:** max 2 a day; priority 1. It stops the clock at 1x. At 3x it stops only when soreness is over 60. Auto-pick: physio when soreness is over 50, otherwise rest the region. A coach under skill 40 pushes through 30% of the time.
- **Sparring Flash:** max 3 a day (2 a block); priority 2. It stops the clock at 1x. At 3x it stops only when a knockdown or cut risk is involved. Auto-pick: PULL when fatigued or worn, POCKET otherwise. The best-call chance is 50% + skill/2.
- **Breakthrough:** max 1 a day; priority 3. It stops the clock at 1x and at 3x. Auto-pick: bank it. The coach has no effect, because the player always makes this call.
- **Corner Rehearsal:** max 5 a day; priority 4. It stops the clock at 1x as long as it's within budget. At 3x the coach makes the call. Auto-pick: the planned station, or ice it if wear is over 50. The best-call chance is 50% + skill/2.
- **Form Breakdown:** max 4 a day; priority 5. It stops the clock at 1x as long as it's within budget, and merges into Corner Rehearsal at a block end. At 3x the coach makes the call. Auto-pick: correct the form. A coach over skill 70 earns +2 form on the correction.
- **Floor Event:** max 2 a day; priority 6. It stops the clock at 1x as long as it's within budget. At 3x the coach makes the call. Auto-pick: the seeded B option. A coach with high people skill (later) turns B into the better option.

**6. A real game that paces interrupts well: RimWorld's letters**
RimWorld splits interruptions by weight. Red letters (raids, deaths) pause the game. Yellow and blue letters stack on the right edge without stopping it, and the player reads them when ready. The storyteller also gives quiet stretches after a big event.

Copy the split into cards that stop the clock and lines that only go in the day log, plus the deliberate quiet days after a peak. Don't copy the stacking side column: our log lives in the day wrap and in one clickable line under the timeline bar, never as a growing pile.

The strongest case against my own ruling is that 6 is too low: a deep manager sim player wants every call, and coach-resolving takes choices away. They keep every call by playing at 1x and paying for a good coach. And at 15 cards a day, nobody reads card 12. Six read properly beats fifteen skimmed.

Two things aren't computed yet: whether 6 cards fits a 2:00 real-time day at 1x without the clock being stopped more than it runs, and whether 50% + skill/2 makes a cheap coach painful enough to be worth upgrading.
