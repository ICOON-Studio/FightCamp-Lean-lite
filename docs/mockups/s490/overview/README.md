# S490 fighter Overview: the approach card and the meters (review round 2)

Answers the operator's notes on `ops/Feedback/2026-11-15-03` (Kira Mensah's Overview, Eastside ABC's approach open):

1. On the talk line: "show these instead of telling it".
2. On the Strength meter: "this meters seem confusing to player".
3. On the whole approach card: "not sure about this whole thing".
4. General: "try The Sims meters -like".

Files:
- `overview_A.html` / `.png`: Sims 4 style rounded need bars. The five answers sit side by side as columns. The talk is a yellow side-box on the HALF EACH column.
- `overview_B.html` / `.png`: segmented cells (10 cells of 10 points; money in $500 cells). The answers are rows of one table. The talk is a yellow sub-row under HALF EACH.
- `overview_C.html` / `.png`: **a proposal for mark 3, not a layout pick.** The same card as A, cut to three answers: MATCH IT, HALF EACH (with the talk) and LET THEM GO. MOVE THE STIPEND and PROMISE: OUR SHOW leave the card. That would be a scope change in `Approach.gd`, so it needs his call.
- `build_overview.py` builds all three pages. `icons.json` holds the game's own Lucide icon paths, read from `scripts/ui/Icons.gd`. The new icons (coins, dumbbell, door, alert, talk, briefcase, users, wallet) are Lucide too (ISC licence, `assets/ui/icons/LICENSE-lucide.txt`).

These parts are the real screenshot: the header, the tabs, NEXT STEP, her name, picture and score ring, and the bottom row. At a glance is redrawn with the same words so it lines up with the new heights.

## What changed and why

### The approach card (notes 1 and 3)
- **Every answer shows the same rows of meters, so the five read side by side:**
  - Her loyalty in 12 weeks, and under it her training.
  - Cost.
  - The stipend team-mate's loyalty in 12 weeks, and under it his training.
  - A note.

  In A each row has a label in the left column. In B each column has a header. Her rows carry a pink heart, his a blue heart. His training sits beside his own loyalty, so no % is left unlabelled.
- **Loyalty meter:**
  - The solid part is where she is now (31).
  - A striped ghost runs to the 12-week number, with an arrow.
  - The end number and the change are printed beside it. Every change is counted from her loyalty now.
  - The track is tinted at the game's lines: under 25 Leaving, 25 to 49 Wavering, 50 and up Settled. A notch marks 50.
- **Cost is one two-way money meter.** The white line is $0. Red to the left is money paid out: MATCH IT -$3,000, $250 a week. Green to the right is money back: PROMISE's night nets **+$100 to +$2,825**, from bad luck to good luck. Two kinds of cost appear as chips instead:
  - LET THEM GO costs no cash but **-2 rep**.
  - Team-mates under 50 lose 2 loyalty, shown in LET THEM GO's note.
- **The talk is an optional upgrade of HALF EACH only.**
  - Its button reads "+ TELL IT STRAIGHT FIRST", with "no cash" beside it. The old FREE tag is gone.
  - 10 pips show the chance: 8 green, 2 red.
  - **Lands:** the HALF EACH meter gets a dashed yellow ghost on to 41. The number reads "41 +10", counted from 31 like every other number.
  - **Fails:** her loyalty drops 4 now. A small red tick on every other answer's loyalty meter shows where that answer would land instead. B also lists them: MATCH 39, MOVE 39, PROMISE 35. HALF EACH is struck out.
- **The deadline is a countdown that carries its cost.** A shows a ring of 7 day segments. B shows a calendar strip from today (Mon 12, yellow) to the last day (Mon 19, red). Both read "No answer: she goes" with the same two chips as LET THEM GO: "-2 rep" and "team-mates under 50: -2".
- Names appear only in the header. Rows say her / he / the team-mate. Nothing pulses.

### The attribute meters (notes 2 and 4)
- One clear bar per attribute: filled to the value, coloured by band, with the number at the end.
- **Room to grow** runs from the value to the ceiling (86). In A it is a lighter extension of the same colour, with a white cap at the ceiling. In B it is outlined cells, and the cells past the ceiling are hatched.
- Mind traits that the game does not cap get no room part, as in the game today.
- Stamina has a ▼ at 60. Its line reads "60 stops her tiring from round 3".
- The legend is one small key in the title row. A uses the Sims ramp (red, orange, yellow, lime, green). B keeps the game's band colours (red, amber, blue, green, purple).

### Her two meters under her name (note 4 was general)
- TIREDNESS and LOYALTY are redrawn in the variant's own style: Sims bars in A and C, cells in B. The slanted two-piece widget is gone from the whole screen, so loyalty 31 reads the same way under her name and on the card.
- Tiredness: green under 50 (fresh), with a notch at 50. A also has a red line at 80.
- Loyalty: the same zones as the card.

## Review round (fresh reviewer, 6/10)
| # | Item | What I did |
|---|---|---|
| M1 | LET THEM GO and "no answer" hid the leaving cost | The FREE tag is replaced by a **-2 rep** chip. A "Team-mates under 50: loyalty -2" note is added. Both are also on the deadline line. Source: `Leaving.gd:27, 89, 99-101`, `Loyalty.gd:56`. `ApproachWire.gd:207-210` (let go) and `:86-94` (Monday) both end in `Leaving.leave`, with mine=false. She is unranked, so -2, not -5. |
| M2 | Talk LANDS "41 +4" counted from a different base | Now "41 +10" from 31. In A and B the HALF EACH meter draws the dashed ghost 37 → 41 on the same bar. |
| M3 | The talk sat as "step 1, FREE" in front of every answer | The talk is moved onto HALF EACH as "+ TELL IT STRAIGHT FIRST", and FREE becomes "no cash". The fail outcome shows that every answer drops 4: red ticks on each meter in A, B and C, plus a 39 / 39 / 35 list in B. HALF EACH is struck out. Source: `Approach.gd:17-18, 153, 169, 191, 199-205`; `ApproachWire.gd:136-139`. |
| M4 | Unlabelled filled/outlined person icons for training | The person icons are removed. "Her training" sits under her loyalty, "His training" under his loyalty: row labels in A, column headers in B. |
| M5 | Team-mate row never said loyalty | It is renamed "Stipend team-mate: loyalty, 12 wks" (A, C) and "STIPEND TEAM-MATE: LOYALTY IN 12 WEEKS" (B), with a heart icon. No name. |
| M6 | Stamina "(now -1.36)" | The caption is now "▼ 60 stops her tiring from round 3". The number is dropped and the caret does the work. |
| M7 | B: step 2 left of step 1 | The step numbers are gone. The talk is a sub-row under HALF EACH (↳). |
| M8 | B: PROMISE button shorter, risk line at 11-12px | All rows are the same height. PROMISE's risk ("Miss 14 Feb: she goes") and "Her keep stays unpaid" sit in the row's own note cell at 14px. |
| M9 | Text under 14px | All text is now 14px or more. Captions use Barlow Condensed 15px so the game's own trait lines fit. The calendar days are 14px and 19px. |
| T1 | Left column TIREDNESS / LOYALTY still the old widget | Redrawn in each variant's style (see above). |
| T2 | Mark 3 may doubt the mechanic | `overview_C` adds a lean three-answer card, and open question 1 below asks him. |
| T3 | PROMISE drawn as a pure $3,500 loss | It now shows the show's net range from `ClubShow.preview`: +$100 to +$2,825 with stand-in club numbers (see below). "Her keep stays unpaid" is added. |

## Every number and its source
| Shown | Value | Source |
|---|---|---|
| Her loyalty now | 31 | screenshot; `Loyalty.value` |
| Loyalty in 12 weeks: MATCH / HALF / MOVE / PROMISE | 43 / 37 / 43 / 39 | screenshot. Rules: `Approach.gd:20-26` (match 12, half 6, move 12, promise 4 + kept 10); `Approach.gd:199` (promise minus 3 x 2 ticks, `ApproachWire.gd:35`) |
| HALF EACH if the talk lands | 41 (+10) | `Approach.gd:23` half_landed 10, `Approach.gd:169` |
| Talk lands | loyalty +0 | `Approach.gd:17` TALK_LANDED 0; `ApproachWire.gd:138` |
| Talk fails | -4 now (31 to 27); MATCH 39, MOVE 39, PROMISE 35; HALF EACH off | `Approach.gd:18` TALK_FAILED; the answers count from loyalty now (`Approach.gd:153, 191, 205`); `Approach.gd:160` |
| Talk chance | 8 in 10 | 0.30 + 0.60 x 84 / 100 = 0.80 (`Approach.gd:15-16, 121-122`); coachability 84 from the screenshot; `ApproachCard.gd:65` rounds to tenths |
| Team-mate now | 64 | **derived** from the card: HALF 60 = 64 - 4 (`Approach.gd:29`); MOVE 43 = 64 - 12 - 3 x 3 (`Approach.gd:28,30,185`) |
| Team-mate in 12 weeks: MATCH / PROMISE / LET GO | 64 (=) | `Approach.answers` holder_end = his loyalty for these answers |
| Training: HALF her / his | 93% / 93% | `Approach.gd:34,37` (0.925) |
| Training: MOVE his | 85% | `Approach.gd:36` holder_move 0.85 |
| Training: the rest | 100% | `Approach.gd:33,35,207-208,219-220` |
| Cost MATCH | -$3,000 ($250 a week) | `Approach.gd:12, 147` (STIPEND 250 x 12) |
| PROMISE net of the night | +$100 to +$2,825 | `ClubShow.preview` (`ClubShow.gd:35-40`): price 3,500, ticket $25, raffle 600-1,400, luck 0.7-1.15 (`ClubShow.gd:8-20`). The inputs are **stand-ins**, see below. draw = 40 + 0.7 x 30 + 1.0 x 10 + 0 + 25 x 4 = 171. Tickets 120 to 197. Net 120 x 25 + 600 - 3,500 = **+100**, and 197 x 25 + 1,400 - 3,500 = **+2,825** |
| "Her keep stays unpaid" (PROMISE) | n/a | **derived**: the PROMISE answer pays no stipend (`Approach.gd:200-210`). The offer is the keep (`Approach.gd:56`) |
| Rep on leaving | -2 | `Leaving.gd:27` REP_LEAVE (unranked; -5 for a regional top 5, `Leaving.gd:28,38-42`) |
| Team-mates under 50 | loyalty -2 | `Leaving.gd:99-101`; `Loyalty.gd:56` teammate_left |
| Locked for 12 weeks (MATCH, HALF, MOVE) | n/a | `Approach.gd:157,179,195` locked_to = day + 84 |
| Answer by | Mon 19 Jan, 7 days | `Approach.gd:11` ANSWER_DAYS 7; screenshot |
| Show night | Sat 14 Feb | **derived**: `ClubShow.show_day` (`ClubShow.gd:57-59`), the Saturday 28 days out from Mon 12 Jan. Check it against the game |
| "Miss 14 Feb: she goes" | n/a | `ApproachWire.gd:223, 244-246` (a broken promise: she leaves next Monday) |
| Leaves next Monday | n/a | `ApproachWire.gd:207-210`; `Leaving.gd:121-125` |
| Loyalty zones 25 / 50 | n/a | `Loyalty.gd:22,26,27`; tones `DarkOverview.gd:214` |
| Tiredness 40, fresh under 50, red from 80 | n/a | screenshot; `Aftermath.gd:28` FRESH_UNDER; `DarkOverview.gd:190,194` |
| Attribute values | all 19 as on the screenshot | screenshot (`AttrBoard.rows`) |
| Ceiling | 86 | screenshot "White tick = ceiling 86" (f["pot"], `DarkOverview.gd:314`) |
| Bands | under 45 weak, under 55 fair, under 65 solid, under 75 strong, else elite | `AttrBoard.gd:52` |
| Stamina 60, round 3 | n/a | `BoutRules.gd:72,86` |
| Discipline / Confidence lines | n/a | screenshot (TraitLine) |
| At a glance | n/a | screenshot |

## Stand-ins (not game numbers)
- **PROMISE's +$100 to +$2,825** uses stand-in inputs, because the screenshot does not show the club's members or reputation. The stand-ins are:
  - 30 members: the "fresh" start, `ClubStart.gd:23`.
  - Reputation 10: the `Career.gd:22` default.
  - No juniors: the youth room is not built.
  - 4 home boxers: the test club.
  - No gym-plan show bonus.

  The game would print its own `GymSpend.show_preview(c)` here. With one home boxer instead of four, the range would be about -$1,225 to +$650. The bar's shape stays; only its ends move.
- The two-way money meter's scale ($3,500 a side, the show's price) and B's $500 cells are a picture scale only. The real amount is printed beside each.
- The Sims ramp colours in A and C (yellow for solid, lime for strong, green for elite) are a proposal. The game uses blue for solid and purple for elite; B keeps those.
- The ghosts, arrows and red fail ticks show numbers the card already computes. Nothing new is computed.
- Temper stays the "Patient" tag. The screenshot gives the word, not the value.
- C's three-answer card is a scope proposal. The code has five answers.

## Open questions for the operator (taste and scope only)
1. Mark 3, "not sure about this whole thing": is it the layout, or the mechanic? Pick one of three:
   - Keep the five answers, as in A or B.
   - Cut the card to three, as in C: pay, share with the talk, let go.
   - Something else.
2. A (Sims bars, answers as side-by-side columns) or B (cells, answers as rows of one table)?
3. Band colours: the Sims ramp (A) or the game's current set with blue and purple (B)?
4. The countdown: the ring of 7 days (A) or the calendar strip (B)?
