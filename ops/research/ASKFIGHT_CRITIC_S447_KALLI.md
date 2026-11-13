# ASKFIGHT_CRITIC_S447_KALLI - Kalli answer (seat queue SQ47)

Brief: research/ASKFIGHT_CRITIC_S447_BRIEF.md
Sent: 2026-11-13 08:46 | collected: 2026-11-13 09:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

Got it. Judging v4 and the round-3 probe only. The critic page will follow as text, in parts.

Part 1 of 3

# ASK FOR A FIGHT, map v4: critic (S447, Kalli)

Judged on the v4 map and the round-3 probe only.

**Verdict:** Depth 5/10. Play 5/10. I would not defend v4 to the owner yet.

v4 closes most of the logic holes: picks above or level only, an honest name for the unranked card, the first-bout lock, a scale miss that closes the date, camp words, and no random host refusal. The decision itself is still flat. The probe shows why, and the map's fix for it (a step up teaches a quarter more) is a reward for which button is pressed, not for who the opponent is. It meets the "teach words differ on half the panels" bar by shifting the word, not by making the cards different.

I could not open the Miro board or the real Fights screenshots, so this judges the text only.

## 1. Logic check

These are consistent with the pack: open and closed with a reason; the first-bout lock (pack 2.5); absent cards, not greyed ones; 10 days after a bout; one slot a show, with the show after printed; ladder places from RankLine only; picks above or level only; "Find a bout" and "Ask for a bout" open the same panel; a legal ask is always accepted; a scale miss turns the date into "Ask for the show after".

These still contradict the game or each other.

**1. The step-up bonus pays the button, not the bout.** "A STEP UP teaches a quarter more than the same fight from the sheet." The same opponent, the same result and the same stat would teach different amounts depending on which card booked the bout. The game already ties teaching to the opponent (the rating gap in `FightLearn.teach`). The result page's "What it taught" has no fact that explains the extra quarter. The map also doesn't say whether the bonus applies to the unranked "nearest better record" card. If it does, a card the map admits can be softer than the sheet (probe G: growth 1.14 against the sheet's 1.85) is paid extra for being called a step up.

**2. When the sheet name and the step-up name are the same boxer, the map has no rule.** In-turn order and ladder order can land on one person. Then you have two cards with one name, both free, and with x1.25 they print two different teach words. There should be one card, and the map must say which teach applies.

**3. The camp words miss most of the dates the panel can print.** The lead is at least 14 days and shows run every 14 days, so the printed date is always 14 to 27 days out. `camp_words` covers 8 to 14 days ("a PEAK camp, no BUILD") and 21 days or more ("Camp can be set"). From 15 to 20 days nothing is defined. The pack also opens Set camp only once a bout is 3+ weeks away, so a 14-day "PEAK camp" line may promise a camp the game won't let you set. CHECK (Claude).

**4. The Wait line promises something the ask can match.** "May leave time for a camp": the sheet's lead is 2, 3 or 4 weeks, so a third of the time it is the same 14 days as the ask. Waiting only buys camp time when the ask's date is under 21 days and the sheet happens to draw 3 or 4 weeks. Print that half of the sentence only when it is true for this date.

**5. The case table and the map's price don't match.** The map takes step teaching x1.25, but the A to G table was played at x1. The cases have not been measured at the price the map sets.

**6. Case B and case D are not the fighters the map describes.** In the probe, B starts 3rd; the map says 4th with the 3rd above. D is morale 35, which the pack calls Flat (30 to 49), not "the bottom of Steady". The probe also held mood and cash fixed, so D's reason ("a loss drops the band, cash is tight") was never in play.

**7. Case E was measured on the wrong card.** In the map's ladder rule, the counter-puncher one place up is the step up, and the presser two places up is A NAME YOU PICK, which costs the gate. The probe labelled the counter-puncher as the sheet and the presser as the step up, so the plan's 36% against 20% came from a free card. E is the only case that sells the paid card, and it is still unmeasured as a paid choice. Press Pat (7-2) and Counter Cara (7-1) also differ in more than style, and no same-rating control separates the plan's edge from the rating gap.

**8. The nationals chip will mostly say "cannot".** At a 14-day lead nobody in C reaches 5 bouts by day 70 under any policy. The bout-count goal the chip serves can't be reached from this panel until AMATEURWEEK1. The chip is honest, but its "near a deadline" reason to ask doesn't exist yet.

**9. The Fighters row "keeps the sheet's date beside it".** The sheet's bout date is unknown by design (2 to 4 weeks, a third each). The row can print when the next offer may arrive, not a bout date. The wording must not imply a date the game doesn't hold.

**10. The pack and the map disagree on when Ask appears.** Pack section 6 says "always, once a boxer is signed"; the map follows pack 2.5 (after the first bout). The map is right. The pack line needs correcting so a builder doesn't put the button on day 0.

Part 2 of 3

## 2. Depth: 5/10

**What I'd pick in each case, and whether one word or number decides it.** All case figures are at x1, the only price they were measured at.

| Case | I pick | What I read | A lookup? |
|---|---|---|---|
| A, 1-0, unranked | Record: nearest better record (-0.66 against the sheet's -0.76). Growth: the sheet (1.64 against 1.31). | Record: the chance band. Growth: the teach word. | Yes for each goal. The real choice is between goals, and that tension is the only depth here. |
| B, 6-1 | Step up. Nothing is clear: -0.52, -0.62 and -0.72 are within noise. | Nothing decides it. | No paid card exists (PLAN equals the sheet). Flat, so the choice doesn't matter. |
| C, 4-1, day 40 | The sheet, clear for growth and safety. | The teach word, plus the fact that asking at all buys bouts (2.84 against 1.95). | The decision to ask is real. The card is one word. |
| D, 5-3, morale 35 | The sheet (safety clear). Record PLAN is not clear. | The band. Mood and cash weren't modelled. | A lookup, and the map's reason for D wasn't measured. |
| E, plan against pressure | The presser two places up. | The style word against the plan already written. | One word, but the good kind: it rewards writing the plan, which is the game's star. Measured on a free card, with no rating control. |
| F, 1.5 kg over | Nothing on this date; the show after. | The scale forecast closes it. | Not a decision. The strip makes it. |
| G, slot taken | The show after, then nearest better record for record (-0.24 against -1.25), the sheet for growth (1.85 against 1.14). | Band against teach word. | Like A: goal against goal. |

**Always best.** At the 60-fighter spread, nothing. In the cases, asking for the sheet name is the best or tied best for growth or safety in every measured case, and the best for safety in five of six. Across the 60, asking is worse than waiting for safety on only 6 of 60. So for two of the three goals the habit is "press the left card" with nothing to read. That isn't a lookup, it's a default.

**Never best.** A NAME YOU PICK for safety (0 of 60 in both runs) and for growth (2 to 4 of 60). For record it is best for 11 of 60, 2 of them clear. The probe doesn't report how often the paid card is even present once names below are gone. In B there wasn't one. If the paid card is absent on most panels, the decision is two free cards and Wait.

**The flat rows: yes, that is a flaw.** There are two reasons it isn't a feature.

- The player can't tell which fighters are the "even" ones. A button that changes nothing for two-thirds of fighters teaches the player that asking and waiting are the same, and after a season they stop opening the panel.
- The flatness is built in, not tuned in. The ask's 14-day lead on a 14-day show calendar lands where the sheet's 2 to 4 weeks lands, so asking makes no extra bouts. With picks above or level only, every card is level or a few points above (the probe's own diagnosis: teaching sits at 0.56 to 1.05). So the cards barely differ in opponent, and the result tracks the fighter's own strength. Our 60 are underdogs (every case record figure is negative), so nothing on the panel can move the record.

**The x1.25 lever is not the fix.** It sits exactly on both bars: step up best for growth on 36 of 60, the cap, and teach words differ on 30 of 60, the floor. x1.5 tips it to dominance (42). One seed, one division and 30 seasons a policy cannot hold a setting at the edge of two bars. It also only moves growth, and it moves it through the label.

**The mechanic change that fixes it:** make the ask trade the date and the opponent, not the label.

1. **Put the date back as the trade.** Ask offers two printed shows: the next one at least 14 days out and the one after (28 days or more). The near show means a bout sooner (the goal "next bout inside a month", the -6 mood for a month without a fight, bouts toward the nationals). The far show means a full camp: BUILD and PEAK, the camp's fight-night edge of +0.25 / +0.6 / +1.0, the PEAK CAMP bonus, and time to cut weight. That reaches record (a camp edge) and safety (weight, overreach, freshness), and it trades against the clock, so it isn't one number. The map cut "choosing the date". That cut is what makes the decision flat. It needs a probe that runs camps, and the current probe fights with none, so the value of a known date is unmeasured.
2. **Make the step up actually higher.** Define it as the nearest legal name at least one band, or 3 rating points, above (whatever the probe sets), in place of the x1.25 label bonus. Then teaching rises because the opponent is better (the rule the game already has), the stoppage word can change, and the teach words differ because the cards differ.
3. **Use the same rule for unranked fighters,** by rating, not by "nearest better record". G shows the record rule picks a softer night.

## 3. Play: 5/10

It puts a button on the empty Fights page (S416), Wait is honest, the slot and scale rules hold, and E rewards a written plan. That is the playable part.

It is not weekly. Each fighter can ask at most once a fortnight (10 days after a bout, then a 14-day lead), and for most fighters asking changes nothing measurable. The safety case (C) can't reach the nationals at this lead. The paid card's selling point (style against the plan) was shown on a free card, and how often the paid card appears at all is unknown. Without a date trade, the panel becomes "book the sheet early". Useful, but not a decision you come back for.

What is missing for play: the date trade above; a step up that is a real step; a measurement of how often the paid card is present; and a plan hint on the card when a plan is already written for that style (E is the one case with real play, and the card should make it visible).

What is useless: a teach word that differs only because of the label; the Wait line's camp promise when the ask's date already allows a camp; the nationals chip while it can only say "cannot".

Part 3 of 3

## 4. Options and menus

| Option | Verdict | What it changes |
|---|---|---|
| The sheet name | Keep | The next in-turn name on a known date; the $450 stays with the gym. When it is the same boxer as the step up, show one card. |
| A step up / nearest better record | Keep, redefine | Ranked and unranked: the nearest legal name a set rating gap above. Teaching from the opponent, no label bonus. Absent when no such name is legal. |
| A name you pick | Keep, show the plan link | Above or level, not the two free names; the host keeps the gate. Show "your plan is written for pressure" when it is, because that is what the $450 buys. Measure how often it appears. |
| Wait for the sheet | Keep, fix the line | Print the camp half only when true for this date. After a scale miss, "Ask for the show after" stays. |
| Near show / far show | Add (the fix) | The bout sooner against a full camp and time to cut weight. Needs a probe that runs camps. |
| x1.25 step teaching | Remove | Replaced by a real rating gap. |
| Camp line | Fix | Cover 14 to 27 days with the camp screen's real rule. Only say "PEAK camp" if Set camp opens at 14 days. |
| Nationals chip | Keep, honest | The day AMATEURWEEK1 lands, re-measure. Until then the chip shows only when it can say something you can act on. |

| Menu | Right place? | Found? | Shows something you can't act on? |
|---|---|---|---|
| Fights page | Yes, under the offers | Yes | The camp line between 15 and 20 days (undefined) |
| Fighters row, "Ask for a bout" | Yes | Yes | "The sheet's date": print "next offer from <day>", never a bout date |
| Home, DO NEXT | Yes, only when open and a goal wants a bout | Yes | No |
| Calendar / week | Yes | Yes | No |
| Money, "$0: the host kept the gate" | Yes, a ledger line | Yes | No |
| Result, "What it taught" | Yes | Yes | With x1.25 the extra quarter has no fact behind it. Remove the bonus and the line explains itself. |

## 5. To reach 10/10

Most important first.

1. **Put the date back as the trade:** near show (at least 14 days) or far show (the one after, at least 28 days), both printed, each with its own camp line and scale forecast. The sheet stays at an unknown 2 to 4 weeks. This is the one change that reaches record and safety. It needs a probe that runs camps (PEAK CAMP, camp edge, weight) and a mood that moves with results. The current probe has neither.
2. **Remove x1.25.** Define the step up (ranked and unranked) as the nearest legal name at least a set rating gap above, with the gap set by the probe so the step up stays at or under 6 in 10 for growth. Teaching comes from the opponent only.
3. **One card when the sheet name and the step up are the same boxer.**
4. **Re-run A to G at the map's real prices,** with B at 4th, D at the pack's Steady (50 to 55), and E as a paid pick of the presser against a same-rating counter-puncher, so the style edge is separated from rating.
5. **Report how often A NAME YOU PICK is present** across the 60. If it is under a quarter of panels, either widen its reach above (up to 6 places) or drop the card and the gate.
6. **Fix the camp words for 14 to 27 days** against the camp screen's real opening rule (CHECK, Claude: does Set camp open at 14 days?).
7. **Make the Wait line conditional:** "may leave time for a camp" only when the ask's date is under 21 days.
8. **Fix the pack's "Ask for a fight (always, once a boxer is signed)"** to match the first-bout lock.
9. **Run the population across strengths** (favourites as well as underdogs), so record has a chance to move before anyone calls it flat.
10. **Hold the 7-day lead** until AMATEURWEEK1 is built and measured, then re-check C and the nationals chip.

Still not possible today: a probe that runs camps and moving mood is new tooling; two printed dates means changing the map's "no second date" cut.

### The 10/10 panel at 1920×1080

The shell stays: dark top bar and left rail. The panel fills the content area on the WarmKit whiteboard.

- **Top strip** (full width, about 140 px): the fighter's comic portrait, name, record, place or "unranked: N wins to the table", mood word, weight now against the limit. On the right, the road chip, shown only when it is actionable. A closed panel is this strip alone, with the reason and the day it opens.
- **Date row** (two magnets side by side, about 160 px): "NEAR: Sat 14 Mar, 15 days, PEAK camp, scale on the day 59.8 of 60" and "FAR: Sat 28 Mar, 29 days, full camp, scale 59.2 of 60". A scale miss greys that magnet with its reason, and only that one. A teammate already on a night moves that magnet to the next show with "Lucy is already on Sat 14 Mar". One date is circled in marker when picked. Nothing is pre-picked.
- **Card row** (three equal cream cards, about 520 px tall), absent when not legal:
  - Left, "The sheet name": face, club, record, place, style word, chance band, stoppage word, teach word, "the gym keeps the $450".
  - Middle, "A step up" (or "Nearest better record" for unranked), only when the name is a real rating step above and not the sheet name. The same facts, plus the one RankLine sentence if it applies.
  - Right, "A name you pick": names above or level only, in a short list. Each shows the same facts, plus "your plan is written for pressure" when a written plan matches. Header: "$0: the host keeps the gate".
  - Each card has one button, "Ask for this bout on <circled date>", live only once a date is circled.
- **Wait line** (full width, about 80 px, under the cards, never a card): "Wait for the sheet: likely in 2 to 4 weeks, date unknown." It adds the camp half only when true.

No score, no "best" badge, no teach number. Hover on every word gives its rule.

CHECK (Claude): whether Set camp opens at 14 days; what happens when the sheet name and the step-up name are the same boxer; whether x1.25 applies to the unranked card.
CHECK (John): whether an amateur club sheet is ever open 14 days out, under England Boxing 1.6.6 as sourced in AmateurBooking.gd.
