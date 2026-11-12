# PAGES2B result — Fighters page as painted rows

Branch: `cursor/pages2b`. Replaces the Roster's `RosterTable.build` with `RosterRows` / `RosterRowBits`, filled from
`RosterRow.row` (Qwen ROSTERROW1). Since S440 (review fixes) the rows are the Roster's **default** view; the full-body
cards are one click away (the switch reads **Rows / Cards**; the view value is `"rows"`, button `View_rows`).

## Edits outside OWNS, for the integrator

The brief's OWNS list is RosterRows.gd, RosterRowBits.gd, areas/Fighters.gd, roster_rows_page_test.gd,
roster_slate_test.gd and this file. These were edited too (collect, the S440 fixer rounds and round 3), kept as they are:
- `scripts/rules/RosterRow.gd` (ROSTERROW1's file): the coach words, the goal words, the no-gi coach and next open, the
  need owner; round 3: "next offers <day>" under "No bout" (NextOffer.day), DO NEXT never empty (`_do_fallback`), the
  no-gi weight cell's class word.
- `tests/roster_row_test.gd` (ROSTERROW1's test): round 3 `_test_need_owner` drives the whole-word branch (a need whose
  arg is empty or a page, with "Lucy's" in its words, never lands on an athlete named "Luc"); a substring mutant of
  `_has_word` fails it twice (ROSTER_ROW failures=2), the real one passes.
- `scripts/ui/RosterCards.gd`: rows as the default view, the value renamed `"table"` -> `"rows"`, the title at the
  painting's size.
- The old tests that read the default view or its button: `golden_path_test`, `playtest_s375_test`, `roster_cards_test`,
  `roster_summary_test`, `face_frame_test`.
- NEW (round 3): `scripts/rules/NextOffer.gd` + `tests/next_offer_test.gd` (the day the next bout offer comes, read from
  `next_offer_day` / `pro_next` exactly as Bouts.day_events and ProLadder.day_events roll them; the test steps the real
  days and sees the offers arrive on that day and not the day before; a +1-day mutant fails it).

## Still

- **Fighters rows:** `docs/playtest/S440/pages2b_real.png` — rendered on the never-shown desktop by the page test itself:
  `python ops/Tools/godot_slot.py run --who claude -- python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path .
  --windowed --resolution 1920x1080 --audio-driver Dummy --script res://tests/roster_rows_page_test.gd -- docs/playtest/S440/pages2b_real.png`
  (the guide is skipped for the still; the page test signs a second boxer so the gold dots show). Compared row by row
  with `docs/mockups/s432/ludo/fighters_paint-v1.png`.
- The first delivery's still (`ops/previews/pages2/fighters_real.png`) showed a stretched face pin, no group names, the
  offer's answer-by days as the big number and an OPEN chip under "No bout": all fixed in S440.

## What shipped

- One wide row per fighter (boxers + no-gi), every word a real Label (WoodKit.ink and SlateWalk read them). The first row
  sits at y ~197 (painting 190): the column header is tighter and the page title is at the painting's size.
- FIGHTER: round 120 face pin (red badge with an envelope when the row needs you), name on a navy plate, weight class +
  age, style + stance, record + the road line.
- OVERALL: the measured level in a ring, five group bars each with its number and its name under it (Head, Hands,
  Guard, Cardio, Legs; the no-gi athlete's own Guard, Pass, Sweep, Takedown, Finish), a gold dot on the roster's best
  (`RosterRow.best_of`, two boxers or more), "Best move"; the bar's hover says group and value. The rings tween like the bars.
- TIREDNESS / WEIGHT / MOOD: the number in bold sans (40 px), a bar (tick at 80 for tiredness, the limit tick for weight,
  none for mood; the mood bar blue while steady, as painted), the word; weight shows "kg" and stays empty for the no-gi
  athlete (no cut in today's rules).
- COACH SAYS: Coach's one change in action words with FIX / REST / DRILL. The goal check is worded from the goal read's
  own target that holds the goal back: a stat target -> "Drill stamina" (the game's stat word), a bout target -> "Answer
  the offer" with an open offer, else "Find a bout"; never the bare "Drill the goal". Decided: the target picked is the
  one not on track (on the quick start the bout still has 28 days and is on track, stamina is the one at risk, so Coach
  says "Drill stamina" and the DO NEXT pin says "Answer offer"). The no-gi athlete: "Drill the <move>" from
  `NoGi.drilling` with "<Move> 28, owned at 30" under it, and the ring is the way to her next belt
  (`BeltRoad.readiness` share; the line names what limits it, classes or moves, and her stripes). Under a boxer: the goal
  ring from `Sim.goal_read`.
- NEXT FIGHT: days to the bout + OFFER / BOOKED (or OPEN for an entered no-gi open), opponent and record, date, and
  "answer by <day>" on an offer. A no-gi athlete with nothing entered: days to the next open she can enter
  (`NoGi.opens_after(day + 1)`, the list on her page), its name and date, no tag, and "No open entered". A boxer with
  nothing: "No bout" and "next offers <Tue 13 Jan>" (NextOffer.day: the game keeps a real day for it, so a date, not a
  chance word; no line when the clock promises none - in the championships, a pro off the ladder).
- DO NEXT: always ONE real button. A need of hers first, in action words (Answer offer, Set a goal, Weigh in, Set
  camp ...), gold when it stops the clock; the need's full sentence in the hover. A need is a fighter's by its arg (her
  id or one of her offers), else by her first name as a whole word. With no need: the no-gi athlete with no open
  entered -> "Enter the open" (opens the Fights page, whose no-gi opens card holds the Enter buttons; the press never
  spends the fee from the roster); a boxer with no bout and no offer -> "Plan the week" (her page's Training tab, the
  week planner; asking for a fight is not a mechanic yet); else Coach's change as Drill / Rest / Fix on the week planner
  (the no-gi athlete's opens her page, where what the classes drill is set). A click anywhere else on the row opens
  the fighter's page.
- WEIGHT for the no-gi athlete: her class word ("Featherweight"), no kg and no bar (no weight is kept for her in today's
  rules).
- Tags (OFFER / BOOKED / FIX / REST / DRILL) as painted: dark plate, blue edge, pale chalk word.
- The key under the rows in words with its marks: best of the roster, the tick (weight limit, too tired from 80), the
  level colours, needs you.
- Removed the old Needs-you chips line and did not bring back WhoIsBooked — the rows already say it.

## Painting shows / today's game cannot fill

| Painting | Why empty / missing |
|---|---|
| Tabs "All four / Club week / Compare two / Find a fighter" | Club-week map not built; today's Roster / Training / Fight camps / Scouting stay |
| THIS WEEK strip (club twist + price) | Comes with the club week |
| The five group icons in the OVERALL header and the bottom key | No icon set in the project (assets/ui/icons holds only the licence); the group words sit under each bar and in its hover, the key is words with drawn marks |
| Round icon pins for a DO NEXT that does not stop the clock (flag, moon, mat) | Same: no icon set; those pins are plain buttons in action words |
| Role word (PROFESSIONAL / AMATEUR / GRAPPLER) | Role map not built |
| Loyalty word and hype band on the face pin hover | RPG / HY maps not built |
| Four fighters at the start | FOURSTART1 not landed; quick start is still one boxer + Ana |
| Coach's training change ("Spar twice", "Slip rope") with its weekly gain ("+0.8 a week") | `CoachCheck` reads checks, not a training plan, and computes no weekly gain; Coach names the check's own change instead |
| No-gi weight kg + limit | No weight is kept for her in today's rules: the cell names her class only |
| No-gi "OPEN" tag on a not-entered open | The tag would read as entered, so it is left off ("Enter the open" is now the DO NEXT pin) |
| Round icon pins for Set a goal / Rest / Enter the open | No icon set: plain buttons in action words |

## Tests

```
RESULT: tests/roster_rows_page_test.gd -> ROSTER_ROWS_PAGE failures=0
RESULT: tests/roster_row_test.gd -> ROSTER_ROW failures=0
RESULT: tests/next_offer_test.gd -> NEXT_OFFER failures=0
```
