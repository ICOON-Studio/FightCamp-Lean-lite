# ASK FOR A FIGHT - the short map (S442, mechanic 1 of his order)

Replaces R37_MAP_S439.md (three critic rounds, stuck at 5-6: every choice was read off one printed number, and the map
had grown favours, host calls, entry order and a fighter's own ask). This map CUTS to one screen and one decision.
Every number is from today's code unless tagged NEW. Game text never says he, she, her or him.

## 1. What it is for
Between offers the Fights page has nothing to press (operator S416: "there is nothing to do in this menu wtf?"). Today a
bout only arrives: the next name in turn, on a date the player cannot know (2 to 4 weeks, 1 in 3 each), yes or no.
ASK FOR A FIGHT lets the player go and get a bout for one fighter on the next club show, and choose what kind of night it is.

## 2. The one decision
For ONE fighter with nothing booked: **who do you ask the host for?** Three answers, on one panel, beside "Wait for the sheet".

| Answer | Who it is | Price | What it is good for |
|---|---|---|---|
| FAIR MATCH | the next legal name in turn (the name the sheet would send) | none | the surest win of the three; the record, the members, the mood |
| STEP UP | the host picks the nearest name ABOVE on the ladder (unranked fighter: the nearest better record) | none, but the host picks, so the style is not yours to choose | the fight that teaches most, and the win that takes a place |
| A NAME | any legal name up to 4 places either side: YOU pick | the host keeps the gate: no $450 ticket cut for this bout | a style the written plan already beats, film already found, or the exact name sitting above |

"Wait for the sheet" stays as the fourth line with its real cost: nothing booked, the next sheet on its day, a date
unknown until it comes.

The show is NOT a choice: it is the next club show at least 7 days away (shows run every 14 days), printed on the panel
with its date. One decision, not two.

## 3. Why it is not a lookup
The three answers pay on three things no single number adds up, and which matters most changes with the fighter:

1. THE RECORD NOW. Win: +1 win, +8 members, +5 reputation, mood up. Loss: -1 member, -2 reputation, mood down (about
   -12, more for a fighter with little heart). The ladder sorts by wins minus losses, so a win is a win whoever it is
   against - EXCEPT that beating the name directly above also gives THAT name a loss, so the place is taken for certain.
2. WHAT THE FIGHT TEACHES (NEW for amateurs; the pro model has it already, `Matchmaking.apply_result`). A bout adds to
   Fight IQ: 0.3 for an even fight, +0.08 for each rating point the opponent is above (up to 6 points: +0.78), a soft
   opponent (6 or more below) only 0.1. A LOSS on points to a better boxer still teaches (+0.4 on top); a stoppage
   teaches nothing and costs. For scale: a focused training week is worth about 1.0 on one stat.
3. THE SEASON AND THE BODY. A stoppage loss is 30 days out (90 for a second inside 90 days), durability ceiling -2 for
   good, 2 members, reputation -4. The nationals want 5 bouts by day 70 and a fit boxer on day 84; the pro offer wants
   7 wins and a top-3 place, or 9 wins. And the $450 is real: rent is $1,800 a month.

Cases the critics should check (winner by case, to be measured by ASKPROBE1 before the build; ESTIMATES until then):

| Case | Fighter | Likely best | Why |
|---|---|---|---|
| A | 1-0 novice, Fight IQ low, season far off | STEP UP | nothing to lose on the ladder yet (unranked under 4 wins); the fight teaches up to 2.6x a fair one; a points loss still teaches |
| B | 6-1, ranked 4th, pro offer one win and one place away | A NAME (the 3rd) | the win and the place in one night; worth the $450 because the plan can be written for that style |
| C | 4-1, 3 bouts short of the nationals' 5, day 40 | FAIR MATCH | needs bouts and no suspension; a stoppage ends the season |
| D | mood near the bottom of Steady, cash tight | FAIR MATCH | a loss drops the band (corner trust 1.0 to 0.85); $450 is a week of the coach |
| E | plan already beats pressure, film found on a presser two places up | A NAME | the plan's edge is worth more than the gate; STEP UP might hand over a counter-puncher instead |

If the probe shows one answer winning more than 6 cases in 10 across a spread of fighters, the prices move before
anything is drawn (first lever: what a step up teaches; second: the gate share).

## 4. When the ask is open (the logic of the moment)
Open: an amateur, nothing booked, no unanswered sheet offer, fit (not injured or suspended), not entered in the
nationals (entry stops all offers today), and 10 days since the last bout (`AFTER_FIGHT`, as the sheet waits today).
Closed, with the reason and the day it opens, in every other case ("Opens Sat 21 Feb: ten days after the last bout").
An answer with nobody legal is greyed with its reason (novice rule: a boxer of 10 bouts or fewer meets only another
such boxer); the panel never dresses one answer up as a choice: with only FAIR MATCH legal it is a single button.
Asking is a booking: the same path as accepting the sheet (mood +5, the sheet stops while a bout is booked).
The host always says yes. No favours, no host calls, no fighter's own ask, no entry-order choice: all cut.

## 5. What each card shows (all of it actionable)
Name, club, record, ladder place; the chance to win as a band ("about 45, 38 to 52" from `BoutRead.rating_range`);
what a win leaves (place, members, wins toward the pro offer); what a loss leaves; what the fight teaches win or lose;
the stoppage chance in words; for A NAME the picker (legal names only, each with its style once found on film, and how
many of the written plan lines beat it). One button a card: "Ask for this bout".

## 6. Menus it appears on, and what each is wired to
| Menu | What shows | Wired to |
|---|---|---|
| Fights page | "Ask for a bout" on each fighter with nothing booked; the panel with the three cards | new `scripts/rules/AskBout.gd` (pure: open/closed + reason, the three cards), `Bouts` booking path |
| Fighters page row | "No bout" row: the button "Ask for a bout" (today it falls back to "Plan the week") | the same panel; `NextOffer` keeps the sheet's date beside it |
| Home, DO NEXT | "Kira has no bout: ask for one" when the ask is open and a goal wants a bout | goal "Next bout inside a month" becomes something to act on |
| Calendar / week | the booked night, as any bout | unchanged booking |
| Money page | the bout's line reads "$0: the host kept the gate" for A NAME | `BoutNight` ticket cut skipped by a flag on the bout |
| Result page | "What it taught: Fight IQ +0.6" in What it cost / The road | new `scripts/rules/FightLearn.gd` (the pro numbers, as one pure module) |

## 7. The build, in order (after two fresh critics at 7+ and a logic check, then his look)
1. ASKPROBE1 (pure, a seat): `FightLearn.gd` + `AskBout.gd` + tests; a probe that plays the five cases and a spread of
   60 fighters and prints which answer a sensible player picks. Prices move here, not on the screen.
2. The panel on the Fights page (one drawing first, then his pick), the Fighters row button, DO NEXT.
3. The $0 gate line and the "What it taught" line.
4. One golden-path test: open the Fights page, ask a step up, the bout is booked, fought, and the result page shows what it taught.

## 8. Left out on purpose
Favours and host calls; the entry order for the nationals; a fighter asking for an opponent; choosing the date; gate
terms as a separate choice; the hosted club show (HOSTSHOW1, later in his order).
