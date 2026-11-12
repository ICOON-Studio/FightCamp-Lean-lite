# ASKFIGHT_CRITIC_S442_KALLI - Kalli answer (seat queue SQ42)

Brief: research/ASKFIGHT_CRITIC_S442_BRIEF.md
Sent: 2026-11-12 12:10 | collected: 2026-11-12 12:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

The pack and the map are in the message. I'll check the Fights screen and the booking rules against them, then paste the critic page here as text.

The booking rules check out on the 10-day wait, but a 7-day show is shorter than anything the game books today. I'm finishing the critic page and will paste it next.

Part 1 of 3

# ASK FOR A FIGHT - critic (S442, Kalli)

**Answer first.** Depth 5/10. Play 6/10. The cut to one decision and three answers is the right size, and none of those answers is always best. The panel still fails the test that stuck the last three rounds: I can pick the winner of every case in section 3 by reading one printed number on the card. The booking rules also fight the rest of the game. A show 7 days out is shorter than any lead the game books today, and two fighters can both ask for the same night.

Sources: the critic pack (as given), the short map, and the live rules in AmateurBooking.gd, Bouts.gd, RankLine.gd, Matchmaking.gd and ClubShow.gd (FightCamp-Lean-lite, read today). I did not read the Miro board or the real Fights stills: both need access this machine does not have. Game text below never uses he or she.

## 1. Logic check

At the moment the panel is open, the four lines are legal actions: three bookings and "Wait for the sheet". Greyed answers with a reason, and a single button when only FAIR MATCH is legal, are sound. Asking is a booking (mood +5, the sheet stops) and matches Accept today. AFTER_FIGHT of 10 days is GAME (Bouts.gd). The novice rule is GAME (AmateurBooking.NOVICE_MAX_BOUTS 10). Closed states that show the reason and the open date are not fake buttons.

These are the contradictions.

**FAIR MATCH is two different things.** The table calls it "the surest win of the three". The rule is "the next legal name in turn (the name the sheet would send)". That name is GAME (Bouts.legal_index: the next legal name in the division list, not the closest rating). A legal name in turn can be a harder boxer, or a style the plan loses to. The card cannot wear both labels.

**A NAME is undefined for unranked fighters.** The regional table starts at 4 wins (GAME, pack 4.14; RankLine ranks only those names). "Up to 4 places either side" has no meaning for a 1-0 novice. STEP UP already has a fallback ("the nearest better record"). A NAME has none.

**The show can be 7 days away. Nothing else in the game books that close.** Amateur offers lead 2 to 4 weeks (GAME, AmateurBooking.LEAD_WEEKS_MIN / MAX). Camp becomes a need 3+ weeks out (GAME, pack 4.3). A short-notice swap is refused inside 14 days (GAME, Bouts.SWAP_MIN_DAYS). A sheet offer for a boxer still over the limit is moved by makeable_day, up to 4 weeks (GAME, Bouts.WEIGHT_WEEKS_MAX). The ask locks the next show and has no such move. A 7-day night is fight week: no camp, no tape study (tape opens in camp), and a real chance of missing weight ($300 empty slot, GAME). The cards do not show the scale forecast or the days left for a camp. AmateurBooking itself notes the real club-show lead as 8-12 weeks (England Boxing 1.6.6, sourced in that file), with 2-4 weeks already a judgement. 7 days is a further cut. CHECK (John) if any amateur sheet is still open that close.

**The place rule on the cards is the pro rule, not the amateur one.** Pros: beat someone above you (or anyone ranked, if you are not) and take their place; beat someone below and nothing moves (GAME, Matchmaking header). Amateurs: the table is net wins, then wins, then rating (GAME, RankLine). A win against anyone is a win on that table. Beating the name directly above usually passes them, because they also take a loss. Beating a name 4 places above does not take that place for certain; the names in between may still sit on better net wins. Case B only works for the adjacent name. The "what a win leaves (place)" line must come from RankLine, not from the pro take-their-place rule.

**Two fighters, one show.** The ask is open per fighter, the show is "the next club show at least 7 days away", and the host always says yes. Two fighters with nothing booked can both be sent to the same Saturday. The agreed fight-night path is one booked fight in a straight line (pack, section 6). The map does not say who has the corner, or whether the second ask is refused.

**The host always says yes.** The agreed amateur Ask (pack 4.5) and the built pro ask (GAME, Matchmaking.ask) both refuse with a reason. This is a cut, not a code clash, but it makes A NAME a guaranteed booking whose only friction is $450.

**"Find a bout" already sits on the fighter Overview** (pack 5.5). If that button does not open this same panel, it is a second, competing action.

**"How many of the written plan lines beat it"** is not available at this moment in the way the card states it. A plan is written in Fight prep after a bout is booked (GAME, pack 4.7, 5.5). Before the booking, the player can only Rate against a kind of opponent, and only if a plan already exists. The card may say that. It may not count lines written for this name.

The teaching figures themselves are the pro growth rule (GAME, Matchmaking: GROW_BASE 0.3, GROW_PER_POINT 0.08, LEARN_GAP 6, GROW_SOFT 0.1, GROW_LOSS 0.4). Applying them to amateur Fight IQ is NEW, as tagged. The "up to 2.6x" in case A is correct: a 6-point harder night totals 0.78, and 0.78 / 0.3 is 2.6. The +0.4 on a points loss applies only when the gap is not past 6 points (GAME: GROW_LOSS is added only if gap <= LEARN_GAP and it is not a stoppage). A stoppage loss in the pro rule also subtracts STOP_COST 0.8 from rating; the map's Fight IQ version teaches nothing and does not use that subtraction. Say so, or bring the cost in.

Part 2 of 3

## 2. Depth: 5/10

"Who do you ask for" is a real trade in the world: the record, what the night teaches, the body and the season, the $450, and the style. No single one of those should decide every fighter. The panel then prints a number for each of them, and the trade collapses into a scoreboard.

How I would pick, and what I would read:

| Case | I pick | How | A lookup? |
|---|---|---|---|
| A, 1-0, Fight IQ low, season far | STEP UP | the card with the highest "what the fight teaches" | Yes. That one number. |
| B, 6-1, ranked 4th, one win and one place from the pro offer | A NAME, the 3rd | "what a win leaves (place)" on that name | Yes. That one line. |
| C, 4-1, 3 bouts short of the nationals, day 40 | FAIR MATCH | the lowest stoppage word, plus the road chip | Yes. Stoppage plus bouts still needed. |
| D, mood at the bottom of Steady, cash tight | FAIR MATCH | "$450 kept" against "$0", and the safest chance band | Yes. The gate and the band. |
| E, plan already beats pressure, film on a presser two places up | A NAME, that presser | "how many of the written plan lines beat it" | Yes. That count. |

No answer is always best across A to E. That part of the map holds.

These answers are never best, with the arithmetic:

- **A NAME of the STEP UP name.** Same bout, $450 less for the gym. Strictly worse. If the picker includes that name with no mark, it is a trap, not a choice.
- **A NAME of someone below you, if FAIR MATCH really is the surest win.** You pay $450 for an easier night that, on the amateur table, does not change your place in a way FAIR MATCH would not (a win is a win; RankLine). It is only a choice if FAIR MATCH is in fact a bad style or a harder name in turn, which is why that card must not be labelled "the surest win".
- **STEP UP when its named boxer is the one you want.** Once the STEP UP card shows the name (section 5 shows name, club, record, place on every card), you already know the style. You do not pay $450 to "choose" it. STEP UP is then the free path to that one name, and A NAME is only for a different name.

The three-payoff claim ("no single number adds up") is true of the career and false of this panel. The last map was a lookup of one printed number. This map is a lookup of five printed numbers, one per case. That is not a new decision. It is a clearer spreadsheet.

## 3. Play: 6/10

It does give the Fights page something to press when the sheet is empty, which is the hole the operator named (S416). One fighter, once the ask is open, has a real booking to make. That is the useful part.

It is not a weekly job. Club shows come every 14 days (GAME, pack 2.7 and 4.5: every other Saturday). The ask is shut for 10 days after a bout, while a bout is booked, while an offer sits unanswered, and for the whole nationals run. A small roster will often open Fights and find only "Opens Sat 21 Feb". That closed line is honest. It is not play.

What is missing for play: the days to the show, the scale forecast, and whether a camp will fit, so "Wait" can be the right call when the night is too soon; a rule for two fighters and one Saturday; A NAME for unranked fighters; Wait spelled as a cost (the nationals clock, the "Next bout" goal) and not only as a refusal to choose.

What is useless on the panel: a derived "teaches +0.6" and a plan-line count, because they play the decision for you; the STEP UP name inside the A NAME picker; any "surest win" badge.

## 4. Options: missing, useless, and what each would change

| Option | On the panel? | Verdict | What it would change |
|---|---|---|---|
| FAIR MATCH (sheet name) | Yes | Keep, relabel | Books the next legal name, keeps the $450, usual win/loss/mood. Must not claim "surest". |
| STEP UP (named, visible) | Yes | Keep | Harder night, more teaching, a place only when RankLine says so, gate kept. The name must be shown, or "the host picks the style" is a blind roll. |
| A NAME (a different legal name) | Yes | Keep, narrow | You pick the style or the exact place. Cost: the host keeps the $450. The picker must not sell the STEP UP name again. Unranked needs a record band, not places. |
| Wait for the sheet | Yes | Keep, show the cost | Nothing booked. Next sheet in 2-4 weeks, date unknown (GAME). The right call when the show is too soon, the cut is short, or the goal can wait. |
| Scale forecast and camp fit on this show date | Missing | Add | Makes Wait a real fourth answer, and stops a 7-day booking walking into a missed weight. |
| Two fighters, one show | Missing | Add | Either one slot (the second ask is refused with that reason), or the second fighter is offered the next show. Changes who can be booked tonight. |
| Host refusal with a reason | Missing (cut) | Optional | Matches the agreed Ask and the pro ask. A "no" with a reason is an action the player can plan around. Without it, $450 is the only price. |
| Scout before the amateur ask | Missing | Do not add | S410: no scouting before accepting an amateur offer. The wide chance band (GAME, BoutRead.rating_range / RANGE_RAW 12) is the right uncertainty. |
| Choosing the date, favours, entry order, the hosted club show | Missing (cut) | Leave out | Date is locked; those cuts still look right. Do not confuse this night with the hosted ClubShow (GAME: every 16 weeks, 28 days' lead, $3,500). That is a later item. |
| "Teaches Fight IQ +0.6", "N plan lines beat it" | Shown | Cut from the card | They change nothing in the bout; they only tell you which button to press. Move the teaching number to the result page, where the map already puts it. |

Part 3 of 3

## 5. To reach 10/10

Most important first. Each line is specific enough to build.

1. **Stop printing the decision.** Take off the card: the exact teaching number, "what a win leaves" as a pre-built place package, and the plan-line count. Show the raw facts the rest of the game already uses: name, club, record, ladder place (or "unranked, N wins to the table"), style word if known, chance band, stoppage in words, "$450 to the gym" or "$0: the host keeps the gate". Teaching, if it must be hinted, is a word only: "even", "harder", "soft". The plan, only if one is already written, is "your plan is written for pressure", never "3 of 4 lines beat it". The teaching number stays on the result page ("What it taught: Fight IQ +0.6"), where it is a consequence, not a lookup.
2. **Do not book a night the rest of the game cannot prep.** The next show must be at least 14 days away (the short end of today's 2-4 week lead, and SWAP_MIN_DAYS). Print days out, the scale forecast on that date, and one camp line: "a camp will fit" or "fight week only: no PEAK CAMP". If the boxer is still over the limit and makeable_day would have moved a sheet offer, close the ask or move the date the same way. If the probe shows 7-day nights are the only ones players pick, the prices are wrong; do not shorten the lead to make the button feel busy.
3. **Finish A NAME.** For unranked fighters, the picker is a legal-record band (nearest better and nearest worse records, still inside the novice rule), not "4 places". Drop or mark the STEP UP name: "already offered, gate kept". Paying $450 for that same bout must be impossible, or obviously worse.
4. **Print amateur places from RankLine.** "A win takes 3rd" only when that is what the net-wins table does. Beating a name four places up must not promise that place.
5. **Resolve two fighters on one Saturday.** One slot on that show, with a refusal reason on the second ask; or the second ask is offered the next show, printed. The host does not silently say yes to both.
6. **Call FAIR MATCH "the sheet name", not "the surest win".** The chance band on the card already says how sure the win is.
7. **Run ASKPROBE1 before any drawing**, as the map already says, and add the cases it is missing: a show 14 days out with a cut still to make; an unranked A NAME; two fighters open on the same show; A NAME pointed at the STEP UP name. If one answer wins more than 6 cases in 10, move the teaching and the gate before a screen is drawn.
8. **"Find a bout" and "Ask for a bout" open the same panel.** A host refusal with a reason can wait until after the probe; it is already the agreed rule and the pro rule.

Without a probe that passes, and without taking the derived numbers off the card, I would not score this above 6. The 10 needs both.

### The 10/10 panel, on a 1920×1080 Fights page

The shell stays (dark top bar, left rail). The panel fills the content area, on the warm whiteboard, not on a dark fight-night board.

**Top strip, full width, not a choice.** Left: the fighter's name, record, place or "unranked, N wins to the table", mood word, weight now against the limit, and the scale forecast on the show date. Middle: the road in one chip ("nationals, 2 of 5, entries close day 70" or "one win and one place from the pro offer"). Right, locked: the show date, days out, and one camp line ("18 days: a camp will fit" / "fight week only: no PEAK CAMP"). If the ask is closed, this strip is the whole panel: the reason and the day it opens. No cards.

**Three cards in one row under the strip**, equal width.

- Left, "The sheet name". The named boxer: club, record, place, style word, chance band ("about 45, 38 to 52"), stoppage word, "the gym keeps the $450". One button: "Ask for this bout".
- Middle, "A step up". The host's named boxer, same facts, already visible. One RankLine sentence ("a win passes 3rd" / "no place yet"). A teaching word only: "harder". One button: "Ask for this bout".
- Right, "A name you pick". A short list of legal names only, never the step-up name, each with place (or record, if unranked), style, chance band, stoppage word, and, if a plan is already written, "your plan is written for pressure". A header on the card: "$0: the host keeps the gate". One button on the name that is selected: "Ask for this bout".

**Wait, a full-width fourth line under the cards**, not a fourth booking card. "Wait for the sheet. Next sheet in 2 to 4 weeks, date unknown. Nationals: 3 bouts still needed by day 70." The action is to dismiss and leave the fighter unbooked.

No derived teaching number, no plan-line count, no "surest win" badge, no judges' scores, no exact Fight IQ, no second date to pick. If only FAIR MATCH is legal, the other two cards are absent, not greyed as fake choices, and the one button stands alone.

---

CHECK (John): whether an amateur club sheet is ever still open 7 (or even 14) days out, against England Boxing 1.6.6 as already sourced in AmateurBooking.gd.

CHECK (Claude): what "Find a bout" on Overview does today; whether two of the club's amateurs can already be booked on the same Saturday; confirm RankLine is what the regional table uses after a club show (not WorldRank.take their place).

The page is saved on my computer at `/workspace/r28/ASK_FOR_A_FIGHT_S442_CRITIC_KALLI.md` and isn't in the repo yet; Claude commits.
