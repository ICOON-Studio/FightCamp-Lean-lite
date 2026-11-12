# ASK FOR A FIGHT - the short map, v3 (S445, mechanic 1 of his order)

v3 (S445): v2 scored Kalli depth 5 / play 6, John 6 / 6 (ASKFIGHT_CRITIC_S444_KALLI.md, _JOHN.md). Their shared lists and
what v3 does with each: (1) A NAME YOU PICK reaches above or level only - already the code since his Q-204 "Only above or
level", now the map; (2) the step-up label tells the truth: "Nearest better record" for an unranked fighter; (3) the camp
line uses the game's phases: a 14-day show is a PEAK camp, not "no camp" (Set camp needs 7 days, BoutRules.CAMP_MIN_DAYS);
(4) a scale miss never leaves Ask armed on that date; (5) asking opens after the first bout (pack 2.5, now in AskBout.open);
(6) teach words cut at 0.6 / 0.85 from the probe's 0.47-1.05 spread; (7) the road says when the nationals cannot be made
from this show; (8) the lead stays 14 days and step teaching stays x1 until measured; (9) the host's refusal is decided
(s5); (10) no badge, score or package. Items 2-7 are BUILT in scripts/rules/AskBout.gd + FightLearn.gd (S445, ask_bout_test
with mutants, fight_learn_test green). Still owed before critics: ASKPROBE2 (s7).


v1 was scored by two free critics: Kalli depth 5 / play 6, John depth 6 / play 6 (ops/research/ASKFIGHT_CRITIC_S442_KALLI.md,
_JOHN.md). Both: the cut to one decision is right, no answer is always best, but (a) the cards printed the decision
(a sortable teaching number, a pre-built "what a win leaves"), (b) the panel could book a night the rest of the game
cannot prepare, (c) A NAME overlapped the two free answers, (d) case B was wrong, (e) two fighters on one show was
undefined. v2 answers each. It replaces R37_MAP_S439.md. Game text never says he, she, her or him.
NOTHING IS DRAWN until ASKPROBE2 (section 7) shows a spread and two fresh critics score 7+.

## 1. What it is for
Between offers the Fights page has nothing to press (operator S416: "there is nothing to do in this menu wtf?"). Today a
bout only arrives: the next name in turn, on a date the player cannot know (2 to 4 weeks, 1 in 3 each), yes or no.
ASK FOR A FIGHT lets the player go and get a bout for one fighter on a club show whose date is printed.

## 2. The one decision
For ONE fighter with nothing booked: **who do you ask the host for?**

| Answer | Who it is | Price | Offered when |
|---|---|---|---|
| THE SHEET NAME | the next legal name in turn (the boxer the sheet would send) | none | always, when one is legal |
| A STEP UP (ranked) / NEAREST BETTER RECORD (unranked) | ranked: the nearest name ABOVE on the ladder; unranked: the nearest better record inside the novice rule, and the card is titled by what it is, never "A step up". The host picks, the name is shown | none | when such a name is legal |
| A NAME YOU PICK | one name up to 4 places ABOVE or LEVEL (never below: his Q-204; a pick from below won 6 of 7 probe cases) that is NOT one of the two above | the host keeps the gate: no $450 ticket cut for this bout | only once the fighter is on the ladder (4 wins) and such a name is legal |
| WAIT FOR THE SHEET | nobody: nothing is booked. The line says the trade: "Next sheet: likely in 2 to 4 weeks, date unknown. May leave time for a camp." | none | always: a full-width fourth line, not a card |

A missing answer is ABSENT, not greyed: with only the sheet name legal the panel is one card and the Wait line.
The $450 buys exactly one thing the free answers cannot give: the choice of opponent (a style the written plan beats,
film already found, a rematch).

## 3. The show is printed, not chosen
The ask is for the next club show AT LEAST 14 DAYS away (today's shortest lead; shows run every 14 days). It stays 14
until AMATEURWEEK1 is built AND re-measured (both critics: a 7-day night is fight week, a different trade).
The top strip prints what that date does, from the game's own forecasts:
- days away and the camp line in the camp screen's own phase words (`AskBout.camp_words`): 3 weeks or more "Camp can be
  set: BUILD, PEAK and fight week"; 8-14 days "Two weeks: a PEAK camp, no BUILD"; 7 days "Fight week only: a light camp,
  no sparring"; under 7 "No camp";
- weight now, the limit, and the scale forecast on the weigh-in day (`Sim.weigh_forecast`), with the bout page's
  "Weight at risk" chip when it applies. A MISS CLOSES ASK ON THAT DATE (`strip.ask_ok`): the cards stay readable, their
  buttons go, and the Wait line carries "Ask for the show after, <date>" with that show's own forecast;
- the live road in one chip: bouts still needed for the nationals and the entry day; or place and wins still needed
  for the pro offer; an unranked fighter has no place line. When the nationals' bouts cannot be made from this show the
  chip says so ("The nationals' 3 bouts by Mon 16 Mar cannot be made from this show") and the nationals countdown is not
  shown anywhere else on the panel.
ONE SLOT A SHOW: a second fighter of ours asking for the same night is offered the show after, with its date, and the
strip says why ("Lucy is already on Sat 28 Feb").

## 4. Why it is not a lookup (and how the cards avoid printing the answer)
Three things pay, and no single number adds them up:
1. THE RECORD NOW: win +1, +8 members, +5 reputation, mood up; loss -1 member, -2 reputation, mood down. Ladder places
   come from `RankLine` only: a card says "a win passes the 3rd" only when the net-wins table does that.
2. WHAT THE FIGHT TEACHES (NEW for amateurs, the pro numbers in `Matchmaking.apply_result`): an even fight teaches a
   little, a better opponent more (up to 6 rating points above), a soft one almost nothing; a points loss to a better
   boxer still teaches; a stoppage teaches nothing. ON THE CARD IN WORDS ONLY ("teaches little / some / a lot"), like
   the stoppage chance ("unlikely / possible / a real risk"): never a number the player can sort by.
   The stat it lands on is named as the screens name it today.
3. THE SEASON AND THE BODY: a stoppage is 30 days out (90 for a second inside 90 days), durability ceiling -2 for
   good, 2 members, reputation -4; the nationals want 5 bouts by day 70 and a fit boxer on day 84; the pro offer wants
   7 wins and a top-3 place, or 9 wins. And the date: a night with no camp or a cut still to make is its own risk.
The cards show RAW FACTS the rest of the game already uses (name, club, record, place, style word if known, chance as a
band, the two words above, the gate). No "best" badge, no added-up score, no "what a win leaves" package.

Cases for the probe (ESTIMATES until ASKPROBE1; v1's case B is corrected):
| Case | Fighter | Likely best | Why |
|---|---|---|---|
| A | 1-0 novice, season far off | A STEP UP | not on the ladder yet; a points loss still teaches |
| B | 6-1, ranked 4th, the 3rd is the name above | A STEP UP (free: the host sends the 3rd) | A NAME may not buy the step-up name |
| C | 4-1, 3 bouts short of the nationals' 5, day 40 | THE SHEET NAME | needs bouts and no suspension |
| D | mood near the bottom of Steady, cash tight | THE SHEET NAME | a loss drops the band; no reason to pay |
| E | plan beats pressure; a presser sits two places up, the name above is a counter-puncher | A NAME YOU PICK | the plan's edge is worth the gate; the step up is the wrong style |
| F | show 14 days out, 1.5 kg over | WAIT, or the show after | the scale forecast misses on that date |
| G | unranked, two of ours open on one show | the second fighter takes the show after | one slot a show |
If one answer wins more than 6 cases in 10 across a spread of 60 fighters, the prices move before anything is drawn
(first lever: what a step up teaches; second: the gate).

## 5. When the ask is open (the logic of the moment)
Open: an amateur who has FOUGHT A BOUT (the first comes from the sheet: pack 2.5), nothing booked, no unanswered sheet offer, fit (not injured or suspended), not entered in the
nationals, 10 days since the last bout (`AFTER_FIGHT`). Closed in every other case, with the reason and the day it
opens. Pros keep today's promoter offers; the BJJ fighter's nights stay on the mats. Asking is a booking: the same path
as accepting the sheet (poster, camp offered when the date allows, mood +5, the sheet stops). The host always says yes
to a LEGAL ask; every "no" is a closed panel or an absent card with its reason (decided S445: the pack's "refusal that
gives its reason" IS that closed state; a random host no on a legal ask would be noise the player cannot act on). "Find a bout" and "Ask for a bout" open this same panel.
No favours, no host calls, no fighter's own ask, no entry-order choice, no second date to pick: all cut.

## 6. Menus it appears on, and what each is wired to
| Menu | What shows | Wired to |
|---|---|---|
| Fights page | "Ask for a bout" on each fighter with nothing booked; the panel | new `scripts/rules/AskBout.gd` (pure: open/closed + reason, the answers, the show and its strip), `Bouts` booking path |
| Fighters page row | "No bout": the button "Ask for a bout" (today it falls back to "Plan the week") | the same panel; `NextOffer` keeps the sheet's date beside it |
| Home, DO NEXT | "Kira has no bout: ask for one" when the ask is open and a goal wants a bout | the goal "Next bout inside a month" becomes actionable |
| Calendar / week | the booked night, as any bout | unchanged booking |
| Money page | the bout's line reads "$0: the host kept the gate" for a picked name | a flag on the bout; `BoutNight` skips the ticket cut |
| Result page | "What it taught" in words with the stat's change | new `scripts/rules/FightLearn.gd` (the pro numbers as one pure module) |

## 7. The build, in order
0. ASKPROBE2 (S445, a seat; pure): re-run tools/ask_probe.gd with picks above or level only, the scale-miss date moved
   to the show after, the honest step label and the new teach cuts; play the map's case C as written (4-1 on day 40, not
   2-0); play case E with a WRITTEN PLAN against a named style through the game's real bout (no win-chance oracle); keep
   step teaching x1. Bar: no answer best in more than 6 of 10 across 60 fighters, and the three cards' teach words differ
   on at least half the panels.
1. ASKPROBE1 (DONE S443; a seat; pure): `FightLearn.gd` + `AskBout.gd` + tests + a probe that plays cases A to G and a spread of
   60 fighters through the game's real bout and prints which answer a sensible player picks. Prices move here.
2. Only if the probe shows a spread: two fresh critics on this map at 7+, a logic check, then ONE drawing for his pick.
3. The panel, the Fighters row button, DO NEXT, the $0 gate line, "What it taught".
4. One golden-path test: Fights page, ask a step up, booked, fought, the result page says what it taught.

## 8. Left out on purpose
Favours and host calls; the nationals' entry order; a fighter asking for an opponent; choosing the date; gate terms as
a separate choice; the hosted club show (HOSTSHOW1, later in his order).
