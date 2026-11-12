# LOOP build, S442: corner cards and the headline card (drawings 1 and 3, owner: "All three")

Built from `docs/mockups/s442/loop/corner_cards.png` and `headline_card.png` (notes: `LOOP_DRAWINGS_S442.md`).
Nothing committed. Nothing under `scripts/fight3d` edited (the reaction bubbles work is there).

## Files

| File | What |
|---|---|
| `scripts/rules/Headline.gd` (new, 128 lines) | Pure: `headline(facts) -> {title, tone, cause, milestone, night, rec, rank}` |
| `tests/headline_test.gd` (new) | Rule test, written first and red before the module existed |
| `scripts/state/AfterFight.gd` (192) | `snap` also keeps the record, the opponent's record and table place; `book` writes `m["night"] = night_facts(...)`, the card's facts, all booked by then |
| `scripts/ui/modals/HeadlineCard.gd` (new, 206) | The card: night line, title, two corners (portrait, name, corner and style, club, record and rank before -> after), the three cards, one cause, gold "See the fight" (Pulse.breathe). Enter, Space or a click on the card also open the result page. Milestone: purple Halo ring and ribbon with a trophy icon |
| `scripts/ui/modals/FightNight.gd` (416) | The "result" step shows the card once (`HeadlineCard.wanted`: `m` has `night` and not `night_seen`), then today's page |
| `scripts/ui/CornerSwapCards.gd` (new, 244) | `row()` (LineSwap.row over the bout so far) and `build()`: the lost-most strip, up to two swap cards, Keep the plan, Other changes, the ring strip |
| `scripts/ui/SwapLink.gd` (new, 59) | The hover link drawn from a card to the lost line's pin, and the worth bar |
| `scripts/ui/CornerJobsRow.gd` (264) | `menu` adds `"swap"`; `_plan_row` uses the cards when a line lost, else today's dropdown unchanged |
| `scripts/ui/Icons.gd` | Lucide `eye`, `swap`, `trophy` (ISC, same set) |
| `tests/corner_swap_cards_test.gd`, `tests/headline_card_test.gd` (new) | Screen tests from real bouts |
| `tests/golden_path_test.gd`, `tests/first_hour_walk_test.gd` | Press See the fight before the result page |
| `tools/loop_shots.gd` (new), `tools/layout_snapshot.gd`, `tools/guide_tour.gd`, `tools/first_hour_still.gd` | Stills; the walkers press See the fight |

## How it is wired

- **Swap card click:** `sel["arrow"] = {i, move}`, the same dict the dropdown writes. `CornerJobsRow.suffix` gives
  `|arrow=i:move`, then `BoutNight._open` runs `PlanFight.corner_change`, which is what `LineSwap.apply` does. The test fights the
  next round and checks that the bout's plan equals `LineSwap.apply(plan, option, limit)`.
- **The bout so far without touching fight3d:** `LineSwap.lost_most` needs every exchange up to the closed round, but
  `FightCast.corner` (fight3d) calls `CornerJobsRow.menu(f, r)` with the closed round only. The bout already keeps each line's
  running tally (`f.bout.plan_tally`, `[won, thrown]`, LiveRound.gd:366-371). `CornerSwapCards.exs_from_tally` turns it into the
  records `lost_most` counts, in first-thrown order. The test checks it names the same line and tally as all the real exchanges.
  The words page and the 3D card read the same data.
- **Ring strip colours:** a line with a WHEN uses `PlanFight.fit` on its own situation (`PlanLines.sit_for`). A line without one
  uses the closed round's most-shown game (`LineSwap.shown_game`), as in the drawing.
- **Headline facts:** the outcome, how it ended, the cards (`BoutRules.cards_of`), each round's exchanges and the split's flipped
  round (`BoutRules.flip_round`), FightWhy's `against` line, `Clock.fmt(day)`, the weight, the rounds. Records come from the career
  before and after. Places come from `Region.rankings` before and after the booking.

## Where it differs from the drawing, and why

1. **The ring strip sits under the cards inside the PLAN row, on one line.** The drawing puts it in the 3D card's left column
   under the body figure. That column belongs to `CornerOverlay` (scripts/fight3d, off limits), and the words page has no such
   column. Its caption "WHERE THE / LINES FIRE" sits in the PLAN tag's column so the eight places fit on one line. The hover
   line runs from the card down to the C pin, and the tile opens "C → Double jab" as drawn.
2. **3D card height.** Measured with `tools/loop_shots.gd`. Today's card is 741 px tall (ends at y 891). With the cards it is
   924 px (ends at y 1074): inside the 1080 frame, but into the bottom letterbox bar. The drawing's own fix (two stats rows out,
   Talk packed tighter, the card scrolls like the 2D page) is all in `CornerOverlay`, so it is left for the fight3d owner. To
   make room, the cards are 128 px tall (drawn 150). "Other changes" no longer sizes itself to its longest item: that had pushed
   the card 86 px off the right edge.
3. **A card shows one extra line:** "Untrained: lands N%" when `PlanFight.rate` < 1, else "Ends at: <place>" when the move ends
   somewhere else. This matches the drawing (one line each).
4. **"Other changes" is the dropdown itself**, with first item "Other changes", holding today's full `corner_options` list.
   "(today's list)" in the drawing was a design note, not game text.
5. **No pulse on the coach's starred call**, as briefed (UX audit: one pulsing button a screen).
6. **Chosen card:** a Halo ring and the foot reads "In the plan: C". The drawing shows no chosen state. A Halo is the
   project's one outline (C273), not a flat border.
7. **Headline, ranks:** entering shows the real place ("Unranked → No. 6") where the drawing said "Ranked". The drawing's data
   had no place; the game has one.
8. **Headline, our corner's club line is blank**, as drawn. The opponent's club is shown.
9. **Headline title size:** 64 px as drawn. A longer title steps down (to 36 px at the least) so the card keeps its 840 px width.
   "LUCY WINS BY STOPPAGE IN ROUND 2" had widened the card to 1270 px.
10. **Win causes not drawn:** a unanimous win says "Round N was the clearest: Lucy won X of 6 exchanges." A stoppage win says
    "Round N decided it: <opponent> did not beat the count." or "...: the referee stopped it." A split win says it as drawn, from
    the flipped round. A loss or a draw uses FightWhy's against line, first sentence, as drawn. A stoppage shows "Stopped in
    round N of M" instead of the three cards, as the result page does.
11. **Fonts:** the card uses the game kit's display face (the brush font from UI.font) where the drawing used Bebas.
12. **No Tally on these screens:** nothing on them changes value while the player looks. Records and ranks are shown as
    before → after words.
13. **The 3D still is CornerOverlay on a plain backdrop, without the body column** (that needs the ring's body map). Its round
    stats read "0 of 0" because the tool passes an empty beat list. Both are limits of the tool, not of the game.

## Milestones

Detected: **entering the rankings** (our place 0 before, > 0 after, amateur only), and a **first win** ("First pro win" on a pro
night, from the pro record). Not detected, and not faked:
- A title or belt. A championship bout (`f.bout.champ`) is one stage of `Champs`, and nothing marks the final as won at booking.
- A first stoppage win, a debut, an unbeaten run, a record streak. No such marker exists, though some could be worked out from
  `c.results`.
- Climbing to No. 1 on the table. Detectable (`rank_after == 1`) but not in the brief's list, so left out.

## Tests (all through `ops/Tools/godot_slot.py --who LOOPUI`, headless, Dummy audio)

Every run had exit code 0 and its log had no FAIL, SCRIPT ERROR or Parse Error line (logs: `E:/FightCamp/tmp/loopui/t_<name>.log`).

| Test | Pass line |
|---|---|
| headline_test (new; red before Headline.gd existed) | `HEADLINE failures=0` |
| corner_swap_cards_test (new) | `CORNER_SWAP_CARDS failures=0`: line C (One-two-hook 0 of 2) lost after round 1; cards Double jab "Beats it" +8 and One-two "Works" +4; the click gives `\|arrow=2:1-1`; the next round is fought on exactly `LineSwap.apply`'s plan; with no line lost, no cards and today's dropdown |
| headline_card_test (new) | `HEADLINE_CARD failures=0`: the card comes before the result page; See the fight opens it; Skip bout still shows the card; Enter opens the page; no `night` in the modal, no card |
| corner_jobs_test | `CORNERJOBS failures=0` |
| corner_card_test | `CORNER_CARD PASS fails=0` |
| line_swap_test | `LINE_SWAP failures=0` |
| golden_path_test (edited) | `GOLDEN_PATH failures=0` (the headline card before both results, the debut included) |
| first_hour_walk_test (edited) | `FIRST_HOUR_WALK failures=0 minutes=28.8` |
| ko_continues_test | `KO_CONTINUES failures=0` |
| no_pronoun_test | `NO_PRONOUN failures=0` |
| file_limits_test | `FILE_LIMITS failures=0` |
| words_on_screens_test | `WORDS_ON_SCREENS failures=0` |

`--check-only` was run on each touched script, but the slot queue timed out on the UI files before Godot reached them. Every one
of them then loaded cleanly in the tests above.

## Stills (hidden desktop, 1920x1080, `tools/loop_shots.gd -- E:/FightCamp/tmp/loopui no3d`)

- `E:/FightCamp/tmp/loopui/corner_2d_real.png`, `corner_2d_hover_real.png`: the words-page corner (FightNight), the PLAN row as cards.
- `E:/FightCamp/tmp/loopui/corner_3d_real.png`, `corner_3d_hover_real.png`: the 3D corner card (CornerOverlay) with the cards; the hover link and "C → Double jab".
- `E:/FightCamp/tmp/loopui/headline_real.png`: this bout's loss headline. `headline_then_result_real.png`: See the fight → today's result page.
- `E:/FightCamp/tmp/loopui/headline_milestone_real.png`: a real milestone bout (3-1 → 4-1, "Unranked → No. 6"), with the ribbon and purple glow.
- `E:/FightCamp/tmp/loopui/rects.txt`: the measured card rectangles.

## For the fight3d owner

- `CornerOverlay` could scroll its card the way `FightNight._scroll_if_asking` does (the drawing's plan), so the corner card
  stays clear of the bottom letterbox bar.
- Existing overlap, not from this change: in ONE CHANGE, "Fix: Chases the stoppage"'s second line runs under "Leave it".
