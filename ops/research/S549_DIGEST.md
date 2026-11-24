# S549 digest (2026-11-24, Fable) - the card game's method changed: one art against itself first

## The owner's words, and what was done
- "isnt there card here ?" -> the card page's server was down after the PC restart; up again (preview `cardgame`).
- "i have2 wind, why can i play a card that costs 3 ?" -> a card in hand prints the price paid now ("2 wind now (3 on
  the card)"); the page server sends no-store (`proto/cardgame/serve.py`) so a reload never mixes old and new files.
- /review C505 "this is wrong , there isno punching on this clip" (the close body hook film) -> frames opened, he is
  right (a dip and a shove, no arm to the ribs); step 5 of `TASK_BODYCROSS4.md`. C504, C506 "nice", C507 "better".
- "THE CARD GAME DOESNT MAKE SENSE. If the fight is MMA bjj fighter has no strikes . tO MAKE IT bETTER BREAKDOWN A real
  mma fight and make it workwith card logic. the real test should be a boxer vs boxer , donot mix classes untill all
  arts cards are ingame." -> METHOD line; `CARDBOX_SCOPE_S549.md`; Q-332 "Yes, go" (answered in chat).
- "if arena is back give references we have of other card games , breakdown boxer vsboxer fights see how a breakdown to
  card vs cards would go" -> Arena ran `TASK_CARDBOX1.md`; its paper is on main: `proto/cardgame/CARDBOX1_BREAKDOWN.md`.

## Measured
- Boxer v boxer today (`node proto/cardgame/mirror.mjs`, 400 bot bouts): knockout 400 of 400; the second man wins
  69.5%; combinations 0.02 a bout; body hook 0.10; 81% of turns at punching range; 67.9 decisions.
- Card 9b slices 2 and 3 built before the method changed (on main, stopped): 90 of 90 tests, play gate 6 of 6. The
  bots reach slice 2 in under 2% of bouts (Frame at 1 wind ends the pull: 10 pulls in 400; Frame 2 -> boxing 36.8%).
  The jiu-jitsu punch from on top: built, OFF (boxing 36.0%). `docs/CARDROUND9B_RESULT.md`.

## Arena's paper, read by Claude (not yet checked against John, SQ325)
- Part 1: Lewis v Tua 2000, Joshua v Klitschko 2017, De La Hoya v Trinidad 1999, round by round. Dates, results and
  cards and who was knocked down when match what Claude knows from memory (not a source check); its punch counts are
  unchecked. John's answer is the check.
- Part 2: fourteen things a boxing card game must carry. Usable as the checklist for phase 2.
- Part 3, the important result: BOTH of its turn structures failed to play the real round (Joshua knocked down in
  round 6). Cause, in its own words: the defender sees the card and answers it, so the big punch never lands. That is
  the same fault as our measured "second man wins 69.5%".
- Its pick (one card against one card, a "combination" = three cards in a row across the round) is NOT taken as it
  stands: a single card against a single seen card always loses to the right answer, and its combination is a pattern
  of the card table, not of boxing. What Claude keeps for phase 2: the comeback lead, a held dear card getting cheaper,
  the corner minute as a plan card, the body stoppage without dice, tiredness making defence worse, and its bars.
- Claude's direction for phase 2 (to be written and probed on a small greybox BEFORE critics): keep the volley laid
  face up against ONE answer (it is what a combination is: one defence cannot cover three punches), and change what is
  round it - rounds scored 10-point must on clean punches; a knockdown and a count instead of health to zero; body
  punches lower his wind for the rest of the bout; a clinch answer that stops the rest of a volley; a feint with a
  shown, fixed effect (the next punch cannot be slipped); three rounds of three exchanges (an amateur bout).

## Running at the handover
- PLANIMPACT1 (Opus console tab of the S548 session): expected about 18:00 -> `docs/PLANIMPACT1_RESULT.md`.
- John SQ325 (`CARDBOX1_JOHN_BRIEF.md`): source-checked bouts and sample numbers.
- NOT launched (one worker while his game is open): MATCHBOTS2, BODYCROSS4. NOT done: the coaches page (needs
  PLANIMPACT1), the FILE coach for simmed bouts, an export (no game file changed this session).

## Slip
One commit (afa85dbca) went out saying 90 of 90 with 2 tests red: a script's assert stopped it half-way and the commit
line still ran. Fixed in 056cf26cf. Rule for scripts: `set -e`, or check the count before the commit.
