# ASK FOR A FIGHT - critic review, round 4 (Goose, 2026-11-17)

Independent critic: management-sim game designer. Read the brief and critic pack. Did not read DOLA's answer before writing this one. Checked the code files named (AskBout.gd, FightLearn.gd, FightWeek.gd, FightWeekPlan.gd).

## What changed since round 3

The fight week is BUILT (AMATEURWEEK1, S474-S481). An amateur bout now has:
- ONE load stop (Rest up / Tick over / Train through) that costs the tank
- 0-2 sparring nights that cost the tank (3 at 7-6 days, 5 at 5 or fewer)
- A week-before night (8+ days out) that costs one pad night's mastery, never the tank
- The tank: the energy ceiling at the first bell (tiredness layer + choices layer)
- Round 1 reads: Rest up opens flat at low tiredness, Tick over boosts one chosen line, Train through is sharp

This creates a real date trade:
- **Near show (7-13 days):** fight week only, no week before, less prep time
- **Far show (14+ days):** week before AND full fight week, more prep time

The step-up teaching bonus is x1.25 (measured by ASKPROBE2, held at the 6-in-10 cap).

## DEPTH: is "who do you ask for, and for which date" a real decision now?

**Yes, but the panel doesn't make it obvious.**

The mechanics are real:
1. The date trade exists: near vs far show trades urgency for preparation
2. The fight week choices add depth: load stop, sparring nights, tank management
3. The step-up teaching bonus (x1.25) gives a reason to risk a harder opponent
4. The gate price ($450) on "A NAME YOU PICK" creates a real economic trade

But the panel doesn't show enough information to make the decision obvious:
1. **The date trade is implicit, not explicit.** The strip shows "days away" and "camp words" but doesn't say "Near show: fight week only" vs "Far show: week before + full fight week". The player has to infer the trade from the camp words.
2. **No plan rating on the cards.** Case E depends on the plan beating the style, but the card doesn't show "Your plan: Beats it / Works / Walks into it" when the style word is known. The player can't see why the gate is worth paying.
3. **No ladder place on the cards.** The card says "a win passes the 3rd" only when the net-wins table does that (RankLine), but the panel doesn't show the ladder place a win would earn. The record player has no visible reason to pick the step up.
4. **No morale cost on the Wait line.** The game has "a month without a fight -6 morale" and "bout booked +5", but the Wait line doesn't show this cost. The player doesn't see that waiting has a price.
5. **No members gained/lost shown.** A win adds +8 members, a loss -1. The cards don't show this trade.

**The cases A-G haven't been re-measured with the fight week in place.** The brief says the cases were played at x1.25, but the fight week choices (load stop, sparring nights, tank) weren't part of the probe. The date trade (near vs far show) wasn't tested.

## PLAY: would a player use it, and enjoy it?

**Yes, but the panel is missing key information.**

What works:
1. The panel is clean: 3 cards + Wait line, follows the raw-facts rule
2. The date strip is clear: days away, camp words, weight forecast, road chip
3. The gate price is honest: "The host keeps the gate: $0 for the club"
4. The absent cards are honest: a missing answer is ABSENT, not greyed
5. The scale miss rule is clear: "Weight at risk" closes Ask on that date

What's missing:
1. **The date trade isn't visible.** The player doesn't see "Near show: fight week only" vs "Far show: week before + full fight week". The camp words hint at it, but the trade isn't explicit.
2. **No plan rating on the cards.** Case E is the one case with real play (the plan beats the style), but the card doesn't show the plan's rating. The player can't see why the gate is worth paying.
3. **No ladder place on the cards.** The record player has no visible reason to pick the step up. The card should say "a win passes the 3rd" when RankLine does that.
4. **No morale cost on the Wait line.** The player doesn't see that waiting has a price (morale -6 for a month without a fight).
5. **The fight week choices aren't previewed.** The player doesn't see the load stop, sparring nights, or tank on the ask panel. They come after the booking.

**The panel is usable but not obvious.** A player would use it (it puts a button on the empty Fights page, S416), but might not understand why asking is better than waiting for most fighters.

## What each option changes in the game

| Option | What it changes | Useless? |
|---|---|---|
| THE SHEET NAME | A free bout, the next legal name in turn. Teaches a little (even fight). | No: the default, always available. |
| A STEP UP | A free bout against the nearest name above (ranked) or nearest better record (unranked). Teaches x1.25 more than the sheet. | No: the growth answer, paid in learning. |
| A NAME YOU PICK | A paid bout ($450 gate) against a name up to 4 places above or level. The plan's edge is worth the gate. | No: the plan answer, paid in money. |
| WAIT FOR THE SHEET | No bout booked. The sheet sends a name in 2-4 weeks, date unknown. | No: the safety answer, buys time for a camp. |

**No option is useless.** Each has a price and a reason. The problem is that the panel doesn't show enough information to make the reason obvious.

## What's missing on the panel

1. **The date trade:** "Near show: fight week only" vs "Far show: week before + full fight week" on the strip.
2. **The plan rating:** "Your plan: Beats it / Works / Walks into it" on each card when the style word is known.
3. **The ladder place:** "A win passes the 3rd" on each card when RankLine does that.
4. **The morale cost:** "A month without a fight: morale -6" on the Wait line.
5. **The members trade:** "Win: +8 members, loss: -1 member" on each card.

## The date rule I would ship

**Keep the 14-day minimum lead, but make the date trade explicit on the strip.**

The strip should say:
- 7-13 days: "Near show: fight week only, no week before. Less prep time."
- 14+ days: "Far show: week before + full fight week. More prep time."

The player should see the trade: urgency vs preparation. A near show is for a fighter who needs a bout now (morale low, nationals close). A far show is for a fighter who can afford to wait (morale steady, camp needed).

## To reach 10/10

Most important first, each specific enough to build:

1. **Add the plan rating to each card when the style word is known.** The card should say "Your plan: Beats it / Works / Walks into it" (from the Playbook's own rating). This makes case E obvious: the gate is worth paying because the plan beats the style. Without this, the player can't see why "A NAME YOU PICK" is worth $450.

2. **Add the ladder place to each card.** The card should say "A win passes the 3rd" when RankLine does that (the card already has the logic, AskBout.card reads RankLine.before). This gives the record player a visible reason to pick the step up. Without this, the record player has no reason to choose.

3. **Make the date trade explicit on the strip.** The strip should say "Near show: fight week only, no week before. Less prep time." vs "Far show: week before + full fight week. More prep time." This makes the date trade obvious. Without this, the player has to infer the trade from the camp words.

4. **Add the morale cost to the Wait line.** The Wait line should say "A month without a fight: morale -6. Bout booked: morale +5." This makes the cost of waiting visible. Without this, the player doesn't see that waiting has a price.

5. **Add the members trade to each card.** The card should say "Win: +8 members, loss: -1 member" (or the stoppage numbers: "Stoppage loss: -2 members, -4 reputation"). This makes the members trade visible. Without this, the player doesn't see the members cost.

6. **Re-measure the cases A-G with the fight week in place.** The probe should play the cases with the fight week choices (load stop, sparring nights, tank) and the date trade (near vs far show). The cases should show which answer wins when the fight week is in play.

7. **Preview the fight week choices on the ask panel.** The panel should show the load stop, sparring nights, and tank for the booked date. This lets the player see the fight week before booking. Without this, the player books blind.

8. **Add a hover card to each option that shows the full trade.** The hover should show: the plan rating, the ladder place, the morale cost, the members trade, the date trade. This gives the player the full picture. Without this, the panel is too sparse.

9. **Add a "what a win leaves" line to each card.** The card should say "A win leaves you: 4-1, ranked 3rd, morale Fired up, +8 members." This gives the player the full picture of what a win earns. Without this, the player has to guess.

10. **Keep the raw-facts rule.** No best badge, no added-up score, no total. Each value is a raw fact the rest of the game already uses. The hover explains every number.

## The 10/10 panel (1920x1080)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│ ASK FOR A FIGHT                                                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Sat 28 Feb (14 days)  Far show: week before + full fight week             │
│  60.0 kg now, limit 60.0 kg, 59.8 kg forecast on the scale                │
│  3 bouts still needed for the nationals by Mon 16 Mar                      │
│                                                                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │ THE NAME THE SHEET WOULD SEND                                       │   │
│  │                                                                     │   │
│  │  Press Pat (Eastside ABC)  3-2  Ranked 5th  Pressure fighter       │   │
│  │                                                                     │   │
│  │  Teaches some  Stoppage unlikely                                   │   │
│  │  The club keeps the $450 ticket cut                                │   │
│  │                                                                     │   │
│  │  Your plan: Works                                                  │   │
│  │  A win passes the 4th  Win: +8 members  Loss: -1 member           │   │
│  │                                                                     │   │
│  │  [ Accept ]                                                        │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │ A STEP UP                                                           │   │
│  │                                                                     │   │
│  │  Counter Cara (Westside ABC)  4-1  Ranked 4th  Counter-puncher     │   │
│  │                                                                     │   │
│  │  Teaches a lot  Stoppage possible                                  │   │
│  │  The club keeps the $450 ticket cut                                │   │
│  │                                                                     │   │
│  │  Your plan: Beats it                                               │   │
│  │  A win passes the 3rd  Win: +8 members  Loss: -1 member           │   │
│  │                                                                     │   │
│  │  [ Accept ]                                                        │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │ A NAME YOU PICK                                                     │   │
│  │                                                                     │   │
│  │  Volume Vera (Northside ABC)  5-0  Ranked 3rd  Volume puncher      │   │
│  │                                                                     │   │
│  │  Teaches a lot  Stoppage unlikely                                  │   │
│  │  The host keeps the gate: $0 for the club                          │   │
│  │                                                                     │   │
│  │  Your plan: Walks into it                                          │   │
│  │  A win passes the 2nd  Win: +8 members  Loss: -1 member           │   │
│  │                                                                     │   │
│  │  [ Accept ]                                                        │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  WAIT FOR THE SHEET                                                        │
│  Next sheet: likely in 2 to 4 weeks, date unknown.                         │
│  A month without a fight: morale -6. Bout booked: morale +5.              │
│  May leave time for a camp.                                                │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Verdict

The fight week adds real depth to the ask decision. The date trade (near vs far show) is real, the fight week choices add depth, and the step-up teaching bonus gives a reason to risk a harder opponent. But the panel doesn't show enough information to make the decision obvious. The plan rating, ladder place, morale cost, and members trade are missing from the cards. The date trade is implicit, not explicit.

SCORE depth=7 play=7

The panel is usable but not obvious. A player would use it, but might not understand why asking is better than waiting for most fighters. The cases A-G haven't been re-measured with the fight week in place. The panel needs more information to make the decision obvious.
