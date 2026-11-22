# RESULTV2 - the result page v2 in the game (S538)

Owner: "the result page needs more graphics,use tooltips/modals to shorten things" (Q-S294-303); on the mockup
ops/previews/s538_look/result_v2.png + result_v2_modal.png: "Yes, build them" (Q-S294-304).

## What was built (the Summary tab; the other tabs are unchanged)
- Header: both boxers' portraits in their corner's colour; the judges' cards as the coloured round grid with ROUND 1/2/3 /
  CARD headings and the colour key; the rank line with a ladder icon (its hover: where the bout left the ladder); the
  round that swung a split card sits under the cards.
- WHY IT WAS LOST / WON: a glove icon, ONE headline, red dots "lost n of m"; the measured fix as gold chips and the bar
  pair with the "even fight" line. The verdict sentence and how it was measured are the bars' tooltip.
- ROUND BY ROUND: per round the exchanges won, a square a judge, a bar an exchange (up = your boxer, down = the
  opponent, as tall as the margin; gold edge = the line the cause names), the plan line's letter with a tick or cross,
  HURT, both energy bars.
- WHAT IT COST: the boxer's figure with the bout's marks (ResultMarks), punches to the head and to the body, the damage
  word, times hurt / the opponent hurt / standing counts, the body report's one button.
- The row of icon tiles: ticket cut, ladder points, members, what it taught, the host's favour (dots), the injury report
  when there is one, the plan's clue (dots). Every tile, bar and count has a tooltip that explains it.
- "More: the whole read" opens the modal with every fact in words, in five blocks (Close / Esc).
- Nothing the old page showed is dropped: what left the page is in a tooltip and in the modal.

Files: scripts/ui/ResultPage.gd (405 lines), ResultTiles.gd (344), ResultRounds.gd (320), ResultRead.gd (209).

## Differences from the mockup (decided while building)
- The page must fit 1920x1080 at every outcome: the head and body counts stand left of the figure and the damage word in
  the card's title row (the figure keeps its own strips for close-ups of marks).
- The bars' tooltip opens on hover (the mockup drew it open).
- A rank line longer than 30 letters ("Enters the rankings at number 6") is the ladder tile's hover instead of its label
  (it leads the left name card too): four label lines made the page taller than the screen.
- The line "the opponent asked to train here" / "the other corner saw it" sits in the foot, where the hint is.
- The injury report is a wider tile with wrapped words (one long line pushed the page to 2,483 px wide).

## Stills (the real game, hidden desktop, tools/resultv2_still.gd)
docs/playtest/s538_resultv2/: result_v2_win.png, result_v2_loss.png (on points), result_v2_stoppage.png,
result_v2_loss_tooltip.png (the bars' card open), result_v2_loss_modal.png (the whole read).
All three pages: no cut text, nothing off screen (the tool prints both).
The stoppage: none of 200 sample nights of this pair ends early, so that still is the same pair with the boxer's chin,
defence and conditioning halved. It shows the page, not the balance.

## Tests
- tests/result_tabs_test.gd: 125 checks, 0 failures (new: the summary's parts, every tile / bar / count has a tooltip
  that does not repeat its label, the modal opens and holds every fact, Close and Esc shut it). Red on main before
  the build (the new scripts did not exist).
- result_defects_test, result_marks_test, golden_path_test, ask_wire_test, file_limits_test, no_pronoun_test,
  hover_label_test: PASS.

## Found on the way (not this task's)
- result_tabs_test's sample bout moved: after the S538 rule changes seed 46 is a bout where FixLab offers to rewrite a
  line that lost 0 of its 1 use (FixLab.worst_line returns a line with lost 0). The test now takes the first seed whose
  worst line lost an exchange (49). Whether FixLab should offer a rewrite for a line that never lost is open.
- The body report's sentence still names the boxer ("Lucy's legs went in round 3", ResultTabs.body_focus): names belong
  in the header only (S448). ResultTabs.gd is PLANFLOW2's file, so it was left.
- On a won night the cause headline ("No answer for a counter-puncher") is still drawn in red, as before v2.
