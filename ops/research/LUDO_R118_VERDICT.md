# Ludo r118 verdict - the corner minute card (FIGHTLINK step 2, boxing demo) - S253

Source: `ludo_rx/LUDO_R118_raw.txt` (19,780 chars, one message, complete; ask `LUDO_R118_ask.txt` with the live card still
`LUDO_R118_card_before.png` uploaded).

## BUILD NOW (inside the approved FIGHTLINK feature, operator S248 "Go - build FIGHTLINK in that order")
1. Phase-gated workspace: the right column's 610 x 320 workspace shows the cutman JOB cards while the corner clock is in the
   stool/cutman phases and the chief second's THREE LINES + the 8-order grid from the chief-second phase on (Ludo: 40 s -> 10 s);
   a "VIEW JOBS / VIEW TALK" switch flips it any time.
2. Three line rows 610 x 58: slot pip 54 px (HIM gold #E8B04B / YOU oxblood #C8102E / GAS blue #38BDF8), text 436 px, 2 lines max,
   and an ADOPT button 112 x 46 with the line's order_label. ADOPT (or a click on the row) picks that order in the 8-order grid -
   the same `choose_instruction` the grid uses, so both light up.
3. Defects: TOWEL moves to the header (top right); SEND HIM OUT gets its own bottom row; the three words sit in a row above it;
   CUT / SEC / CHI meters leave the text column (moved into the vitals strip); hidden buttons are visible=false, not alpha 0.
4. Lines appear one by one (Ludo: 0.4 s typewriter, 1.5 s apart) when the chief-second phase starts.

## NOT BUILT (new mechanics - would need the operator's call; none is needed for the lines on screen)
- Crew action points (2 AP per minute) - today's job rules stay.
- Two concurrent orders with a 60/40 engine split - today's order rule stays.
- New auto-pick rules (GAS < 30 % -> BREATHER, composure word by mindset) - today's auto-send stays.
- Two-step towel confirm and the whistle/mitt audio - later polish.

Why: the operator approved the corner report lines (FIGHTLINK); a new resource or order-weighting is a new mechanic (S240 rule:
the board only for new mechanics/scope/money/taste).

## Built S253 (stills: docs/previews/s253_corner/talk.png, jobs.png)
- Line -> order map (CornerPitStopPanel.LINE_RULE_TO_ORDER, keyed on CornerLines rule_id): whiff/accuracy/head/leak/cut ->
  BOX AND MOVE; chin -> FINISH; torso + jab economy -> THE BODY; legs -> HOLD CENTRE; whiff-burn + gassed -> BREATHER;
  opponent gassed -> PRESSURE; neutral/solid/pacing -> PLAN. Ludo's own label stays the ADOPT tooltip.
- Jobs rows 68 px (three text lines); the card grew 20 px down from Ludo's numbers so the pace row fits (words y 438,
  SEND HIM OUT y 478). CUT / SEC / CHI are the clock's crew-lane progress bars (not meters): under the figure.
- Test: tests/corner_card_wired_test.gd r118 checks - three rows, ADOPT lights the grid, no overlaps in TALK and JOBS.
