# Training K v3 - show it instead of writing (S490)

Files: `training_k_v3.html` (from `docs/mockups/s483/training_k.html`), `training_k_v3.png` (render, `python tools/render_mockup.py`).

Answers the operator's mark on the S483 page (ops/Feedback/2026-11-15-04, point 1), on the Friday evening text
"Check hook 20.7 -> 28.2 / 1.8 short: one more night": **"can you show it instead of writing ?"**

## The new picture: the mastery bar (redrawn in the review round)
- Evening cells: the bar runs 0 to 30 (the Usable flag) with a short dark stub past the flag (to 36), so a night that
  crosses the flag still shows. THIS WEEK BUYS: 0 to 60, the right end (diamond) is Sharp.
- deep pink = mastery she had before the night; bright pink with a white edge = what this night (or this week) adds;
  an EMPTY dashed outline = the night still missing ("one more night" = one ghost block, no words).
- green flag at 30 = Usable (MoveMastery.gd:16-18, FireLevel.gd:17-18). The flag stands ABOVE the bar with a small notch
  under it, so it never covers the ghost. It glows when the night crosses it (Wed).
- A tiny key sits in the EVENING label column, beside the Mon bar (she had / tonight / +1 night / Usable); the
  THIS WEEK BUYS header repeats it with Sharp 60.

## Every text -> picture change
| Where | Was (text) | Now (picture) |
|---|---|---|
| Fri 20 evening (the marked one) | "Check hook 20.7 -> 28.2 / 1.8 short: one more night" | Name + bar (0-30 + stub): deep pink to 20.7, bright to 28.2, one empty dashed ghost block past the Usable flag. 28.2 in the badge on the picture |
| Mon 16 evening | "Check hook 12 -> 20.7 / 9.3 to Usable" | Bar: deep pink to 12, bright to 20.7; the gap to the flag shows what is left |
| Wed 18 evening | "Body hook 29 -> 35.4 / Usable lands 1 in 2" | Bar: the bright segment crosses the flag (flag glows) + green check by the name. "lands 1 in 2" dropped (Maria) |
| Evening rings (21 / 35 / 28 toward Sharp) | conic ring + number | Removed: the bar shows the way; the exact number stays in a small badge |
| Tue 17 evening | "was pads" / "Film · +1 tell · found" / "waiting: bag work, Cardio +0.11 est." | Pads icon (dim) -> film icon; eye + "+1 tell" + check; heavy-bag icon + "+0.11 Cardio est." |
| Thu 19 evening | "Sparring · Ring IQ +0.12 / drills only moves at 30+" | "Fight IQ +0.12" + the two moves: body hook with a check and a green Usable flag; check hook greyed with an empty grey flag (not Usable, so not drilled). No slash |
| Sat 21 evening | "REST / no coaching tonight" | Rest-night picture + "Rest" + your coach in a red ring corner (same red as IN THE CORNER above). No slash, no lock |
| Sun 22 evening | "Rest / recovers 8" | Rest-night picture + "Rest"; the day's -8 is shown once, on the morning tile |
| Fight week column | "Taper: 3 pad nights, no sparring" | Six nights M-S: pads Mon/Wed/Fri (Mon in a dashed ghost ring = the check hook's missing night), Thu sparring struck (cancelled), Sat fight |
| Fight week column | "First bell tiredness 48 / under 50: no penalty" | 48 est. + a gauge with the green zone to the 50 line |
| Tiredness chart | "Cut harder: over 72 from Wed" | Dropped with the S483 line it stood on (Review round, item 3). The diet switch stays |
| Tiredness chart bands | "80 overreached · gains x0.6", "72 injury x2 by 76", "50 fresh: no energy off" | Hatched red band over 80 + down-arrow icon "gains cut"; red band deepening from 72 to 80 + first-aid cross "injury risk"; green band under 50 + full battery "fresh". No formula words |
| THIS WEEK BUYS | "this week", "Usable Mon 23", "Usable Wed", header "Usable at 30 mastery" | 0-60 bars with she-had / this-week / ghost + flag + Sharp diamond; "ghost Mon 23" and "check Wed"; key in the header |
| YOUR WEEK / COACH'S WEEK | "Tell found" / "Tell hidden"; "Injury risk 1.0 / 2.7 in 100" | Open eye / closed eye; the injury number became a peak-tiredness gauge with the red zone from 72 (both dots sit left of it) |
| Win panel rows | "Body hook ready Wed", "Check hook ready Mon 23", "Film finds the tell" | Swatch matching its slice; check / ghost / eye glyphs; the check hook's slice is a dashed empty block |
| ON FIGHT NIGHT | "69.6 of 70.0 kg", "48 · none off", "Check hook ✓ · Body hook ✓", "1 of 1", "Cardio goal 60.4 / 60.3 est." | Weight bar with the red limit line; tiredness gauge with the 50 line; move pictures + flags (check hook: dashed ring + dashed hollow flag = depends on Mon 23; body hook solid); an eye; Cardio bar with the goal line |
| Friday panel | "65 min to him, 10 min to her" | Removed: the split bar shows it (portrait on her slice) |
| Friday panel cards | "Check hook 20.7 -> 28.2 1.8 short / Usable Mon 23"; "Jab stays Usable ✓ / waits on bag work" | Check hook bar with the ghost + "ghost Mon 23"; jab picture + Usable flag; heavy-bag icon + "bag work" |
| Friday panel | "Next ring: Sharp at 60 mastery -> +2.8% edge est." | Diamond (= bar end) + "Sharp 60 -> +2.8% edge est." |
| Coach's pick | "The check hook needs one more pad night: Monday of fight week. ..." | Cut: the ghost says it. Only "Saturday's fighter stays loose: bag work at full load." stays |
| Fighter strip | "base: ok" | "base" + green check |
| Session tray | Film "1 tell", Pads "+6-10 a night" | "+1" + eye; bright swatch + "+6-10" |

Also: the top-bar CONTINUE lost its glow so only the bottom CONTINUE pulses (one pulsing button a screen). The red slash
now means one thing only: cancelled (fight-week Thursday sparring).
Kept on purpose: the coach's handwritten pick (his voice, not a state), the session-tray drag instructions, the coach-row
notes (SPARRING NIGHT / IN THE CORNER / CLOSED are names, not explanations), layout, data, fonts (Oswald, Barlow,
Permanent Marker, Kalam - the game's own, per Maria; no Bebas Neue / Plex Mono).

## Maria's critic points (DESIGN_TRAINGAME2_V2_CRITIC_MARIA_MARIA.md)
- Options C (swap the sparring night for pads) and D (pads on a rest evening) **already exist** as plain evening editing:
  the player drags Pads / Sparring / Film / Rest onto any evening (the SESSIONS tray: "evenings: drag onto the coach's
  slice"). Nothing new is needed to offer them; only the forecast (the bar + ghost) is new.
- "Fires 1 in 2" names a mechanism (FireLevel.GAME_SHARES usable 0.5, FireLevel.gd:24), not an outcome. It is no longer
  written; the outcome lives in the win panel, marked est. (probe P2 not measured).
- Fonts kept as the game's own.

## Numbers and sources
| Number | Source |
|---|---|
| Usable 30, Sharp 60, Signature 85 | scripts/rules/MoveMastery.gd:16-20, :29; FireLevel.gd:17-19 |
| Usable fires 0.5, Sharp 0.75 | FireLevel.gd:24 (not shown on the page) |
| Check hook 12 -> 20.7 (Mon), 20.7 -> 28.2 (Fri); body hook 29 -> 35.4 (Wed) | S484 probe tools/training_k_numbers.gd via PadWeek.drill; ops/research/TRAINGAME2_REAL_NUMBERS_S484.md |
| A pad night = 240 drill units | PadWeek.gd:38 |
| Sparring Fight IQ +0.12, drills only moves at 30+ | S484 doc; word "Fight IQ" from Attrs.gd:22 |
| Mornings +0.11 / +0.12 / +0.06 / +0.17 / +0.12, kg per morning, Sunday -8 | S484 doc (WeekPlan.full_day) |
| Tiredness line 40 carried in -> 47, 45, 51, 49, 54, 48, 40; peak 54 | S484 probe `_page_week` (tools/training_k_numbers.gd:52-70; 40 is the probe's carried-in start), TRAINGAME2_REAL_NUMBERS_S484.md:22 |
| Coach's week line 47, 53, 58, 55, 59, 52, 43; peak 59 | The same rule (WeekPlan.gd:160-185 full_day, :257-290 day, fatigue_keep) replayed by hand in Python with Tuesday back on pads (the one changed evening that moves tiredness; Friday's other change only splits coach minutes). The replay matches the probe's own line within 1 point (47.4 for Sat where the probe printed 48) |
| Bands: gains cut from 80; injury risk from 72, x3 by 80; fresh under 50 | WeekPlan.gd:77-78 (OVERREACHED 80, TIRED_GAIN 0.6); InjuryRoll.gd:125-130 (FATIGUE_RISK_FROM 72, span 4); BoutRules.gd:34 (FRESH_FATIGUE 50) |
| Peaks 54 and 59 under 72 = no extra injury risk from tiredness | InjuryRoll.fatigue_mult (x1 under 72) |
| Sessions tray values | S484 doc |

## Stand-ins (marked "est." on the page itself)
- Win 53-55% / 52%, +1.5% a ready move (shown in three places), Film 0 to +2%, +2.8% Sharp edge, "+0.5% this bout /
  +5% ten weeks": carried from S483, NOT measured (probe P2). Each carries "est." (an EST. pill on the big number).
- First bell 48 (fight-week column, chart, ON FIGHT NIGHT): the probe stops at Sunday; the fight-week stretch of the
  line is dashed and labelled est.
- Weight 69.6 / 70.0 (ON FIGHT NIGHT, diet box) and Cardio goal 60.3 / 60.4: est. (From the probe's 70.6 kg and its
  per-morning kg the week ends near 70.2 kg; the fight week was not run.)
- Ghost block size about +6.4 mastery (copies the measured body-hook night at that mastery). Only its crossing matters.
- Tuesday's "+0.11 Cardio" (the coach time freed by film going to bag work): est.
- The other three fighters' sparklines are shapes with no numbers (not measured); Kwame's now follows the rule's line.
- The jab is drawn Usable with no mastery number (none on S483). Gauge windows are drawing choices, not rules.
- Removed rather than marked: Injury risk 1.0 / 2.7 in 100, the LIGHT 70 / STANDARD 70 / HARD 78 peaks on the NIGHTS
  chips, and the Cut-harder line - none measured, all drawn against the old line.

## Review round (fresh reviewer, 6.5/10)
MUST FIX
1. Friday bar too small, hatch reads solid, flag on the ghost. DONE: bars are inline SVG, 16 px tall in the cells; the
   cell bar runs 0-30 plus a stub (night ~28 px, ghost ~23 px; were 15 / 13). Night = bright pink with a white edge
   (no hatch); ghost = empty dashed outline, no fill; the flag stands above the bar with a notch under it, so nothing
   covers the ghost. Learning moves show 0-30 in the cell; 0-60 only in THIS WEEK BUYS (old question 1 answered).
2. Coach's pick kept the marked sentence. DONE: cut. The card holds only "Saturday's fighter stays loose: bag work at
   full load." "One more night" lives only in the ghost blocks.
3. Tiredness chart contradicted the rule. DONE: redrawn with the rule's line from 40 carried in (47, 45, 51, 49, 54, 48,
   40; peak 54) and the coach's week as a faint dashed line from the same rule (peak 59). Peak tiredness in YOUR /
   COACH'S WEEK now 54 / 59. Nothing reaches 72, so the red rings and the Cut-harder line are gone, and the injury
   number became a gauge showing both peaks short of the 72 zone. The YOURS chip reads "peak 54"; Light / Standard /
   Hard chips lost their unmeasured numbers. The carried-in 40 is the hollow first dot.
4. Stand-ins looked real. DONE: "est." on the page beside every win share, the win range, first bell, weight, Cardio
   goal and Tuesday's Cardio; the injury figures were removed.
5. The Mon 23 promise rests on owner question 1. DONE: the check hook's win slice is a dashed empty block, its row value
   ghost pink, its flag in ON FIGHT NIGHT a dashed hollow flag with a dashed ring on the move (the body hook's earned
   flag stays solid green). The fight-week Monday pads icon keeps its dashed ring.
6. Sunday -8 shown twice. DONE: once, on the morning tile.
TO REACH 10
- Bar readable in 2 seconds without the legend: DONE (bigger bar, strong had/tonight contrast, hollow ghost, flag beside
  the ghost) + an inline key beside the Mon bar in the EVENING label column.
- Band pictures instead of rule labels: DONE (hatched gains-cut band + down arrow, deepening red injury band + first-aid
  cross, green fresh band + battery; "x2" / "x0.6" dropped; small axis ticks 80 / 72 / 50 kept).
- One meaning for the red slash: DONE. Not drilled = grey move + empty grey flag (Thu); coach away = your coach in a red
  ring corner (Sat); the slash only for cancelled (fight-week Thursday sparring).

## Open questions for the operator (taste)
1. The evening rings (mastery toward Sharp) are gone in favour of the bar and its number badge. Keep them off?
2. The coach's week now shows as a faint dashed line on the tiredness chart, so the player sees what his change saved.
   Keep it always, or only on hover?
