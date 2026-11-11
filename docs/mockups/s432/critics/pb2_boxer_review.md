# Critic review: THE PLAYBOOK (PLAYBOOK_MAP_S432 + playbook_v2.png), blind, fresh

Critic: former amateur international boxer, now a club coach. Read: CRITIC_PACK, CRITIC_ACCESS, the map whole, the drawing, and the code as built:
PlanFight, PlanRead, PlanPressure, FireLevel, ReadBack, CoachPlan, PlanBoard, OwnCombos (head), LiveRound (the exchange, lines 236-413),
RingDuel (gas), FightWhy (head), GamePlan.gd (the screen), plan_bots_test. Real screens: 23h (game plan), 23i (combos), 19c (corner minute).

## Score: DEPTH 7 / 10 (the design); the Playbook as built today is about 4

One line: the map turns a lookup table into a real corner's card (the body does the line, every line has a price, the other corner reads you, rounds
on lines, a receipt), and that clears 7; it misses the two things every amateur corner plans first (stance and what the fighter holds when tired or
hurt), and it leaves the plan and the corner's shouts as two parallel systems.

## What is built today, read in the code (why it sits near 4)

- A line is a move on a place (8 places, about 30 moves) and maybe a situation. In the exchange (LiveRound 297-317) it adds one number: the read
  table's +9 / +3 / -7 minus the fighter's average on that place (PlanFight.edge). It changes nothing else: a planned four-punch line costs no gas
  (RingDuel charges gas for the shout and the set-up, not the line), lands no extra punches and takes no extra risk. So "every line has a price" is a
  true gap, not a polish item.
- The fighter's body never touches the line: PlanFight.rate is 1.0 drilled or 0.8 undrilled, nothing else. Speed, Footwork, Defence play no part
  in whether a line works. Drilling past Usable does nothing (FireLevel is in the code but the bout key is empty, so every line fires every time).
- Opponents never read you (ReadBack is off). Reads and pressure (PlanRead, PlanPressure) are good: a right answer that lands builds for the round,
  a punished wrong one costs tank for good. That part is real boxing.
- The screen (23h) is a list of places with "Write a line" and a chip; Rate against, a round pace row, an empty go-to row and an empty "Hover an
  answer" panel. The corner minute's change is a bare dropdown ("Keep the plan"). The Why grades the plan by fit, not dice: the best thing built.
- plan_bots rule 4 is still OPEN: a bot that weighs drills, cards and legs does no better than one reading the table. That is the proof the built
  plan is a lookup, not a decision.

## What is good in the map

- The line grade (4.1): "Tess does it: Poor (Footwork 47, Speed 52)". This is how a coach plans: you never send a slow-footed boxer to box on the
  back foot. The swap hint, a Works line done Good beating a Beats-it line done Poor, is a real decision with a number behind it.
- The price (4.3): safe lines score half, big lines cost gas and risk. Amateur judges score clean punches; moving away wins no round. Right.
- The five "never wrong" answers each get a wrong game with a boxing reason (the right hand over the second jab, the cross into a counter). Right.
- IF READ (4.4): corners do take away what works between rounds; "throw it behind another line or switch it" is exactly what you say on the stool.
  Only opponents with the tell adapt, and the tell is found on tape, so the tape gains a reason.
- Rounds on lines with only the last round split ahead / behind (4.5): correct for 3 x 3; amateur corners score it themselves and can be wrong.
- Two dials, two parts of the week (4.2 and 4.9): pads feed combination lines, mornings feed step lines. The On the pads / On the mornings buttons
  close the loop from the Why to the week in one click.
- The receipt (4.11) and "your plan against Coach's" as one number: the player can read cause and effect after every bout.
- The cut rule and the ten probes: every mechanic must move 1.5 wins in 100 or it goes. Honest.
- Good cuts: one Map, the empty hover panel becomes THE LINE, Rate against hidden when a bout is booked, the DAMAGE tile cut.

## What is missing (options a corner would expect)

1. STANCE. Tess is a southpaw; the map never says what the opponent's stance does to a line. In real amateur boxing the first line of any plan
   against an opposite stance is the lead foot outside and the straight rear hand down the middle; same stance, the jab and the lead hook. The game
   holds stance for both boxers and already has a southpaw partner in camp and a round-1 southpaw penalty. The plan is the place it should bite.
2. HOLDING THE PLAN. A fighter hurt or out of gas forgets the plan and goes back to what is automatic. FireLevel reads only mastery. Composure
   (agreed attribute) and the Legs should lower the fire share when hurt or tired. This links the mind and the tank to the plan and makes Sharp
   lines worth more in round 3, which is the truth.
3. THE FIGHTER'S NATURE. Tess is a pressure fighter. Telling her to step back is against her style and she will not do it under fire until it is
   drilled. A style (built: style word) should lower the fire share of lines against it. It gives "change a fighter's style" a cost in weeks.
4. SHOUTS AND LINES ARE TWO SYSTEMS. The 30-second shouts (Jab and move, Go to the body...) and the plan's lines add separate edges to the same
   exchange (LiveRound 263 and 317). A player sees "Step back" on the card and "Jab and move" on the shout bar and cannot tell which did what. On the
   night, the shout bar should offer the card's lines ("The draw!", "Straight left!"): a shout makes the next 30 seconds throw that line. Then the plan
   is the star in the ring too, and writing a line also decides what can be shouted.
5. ONE UNIT. The drawing shows "+4.0" a use (power points) and "+6 to +9 in 100" at the bottom. Power points mean nothing to a player. Use exchanges
   won a bout per line and wins in 100 for the plan only.
6. GAS ACROSS THE ROUNDS. The price is shown per line as a chip but there is no total: what the card costs in each round against the Legs. That
   bar is where safe vs scoring becomes a decision, not a chip to read.
7. TEST IT AGAINST THE RIGHT PARTNER. The camp already sells an outside sparring partner of the opponent's stance or style ($160). Test it should
   use that partner (and narrow its range); club mates of the wrong type should give a wider range.

## Useless or doubtful options

- "Where, how often" as a big column with a bar on every row: useful once, then noise. Keep it as the sort order and a small number, as drawn.
- Rounds pips on every line when most lines are "all": show pips only when not all.
- Save plan (three slots): a convenience the map itself says moves no number. Fine if cheap; do not spend screen on it before the mechanics land.
- The go-to combination beside own chains as lines: once an own chain can be a line, the go-to is a second way to say the same thing. Fold it: a
  line marked go-to is thrown more, nothing else.
- Real fight plans (templates) as a page: keep the "fits Tess: 3 of 6" filter, cut the folded list of 14 to the two that fit.

## New mechanics (only where decisions are thin without them)

- STANCE ON LINES (StanceRead): open stance (orthodox v southpaw) makes the straight rear hand and stepping outside the lead foot "Beats it" against
  range and counter games and the lead hook "Walks into it"; closed stance the reverse for the jab and lead hook. One chip on the line ("open stance
  +"), one row on the file. Probe it like the others (1.5 wins in 100 in mixed-stance bouts).
- HOLDS THE PLAN (PlanHold): fire share x 0.7 when hurt, x 0.8 under Legs 40, lifted by Composure (each 10 over 50 gives back a tenth). Shown as
  "fires 3 in 4 (1 in 2 tired)" on each line. Links Composure and Stamina mornings to the plan.
- AGAINST NATURE: a line against the fighter's style word fires x 0.75 until Sharp. One red note on the card when it applies.
- SHOUT A LINE: the fight night shout bar lists the card's lines first; a shouted line is picked for the next exchange on whatever place it lives.
  The old calls stay only for what no line covers (hands up, tie up, breathe).

## To reach 10/10 (most important first, each buildable)

1. Merge the shout bar and the card: on fight night the shouts are the card's lines (plus Hands up / Tie up / Breathe). LiveRound picks the
   shouted line for the next exchange; the call edge and the line edge stop stacking. Golden path: write a line, shout it, see "Plan: The draw,
   shouted - it worked".
2. Stance on lines (StanceRead) with a chip on each line and a row on the opponent's file; the southpaw camp partner and the round-1 penalty read the
   same rule.
3. Holds the plan (PlanHold): fire share falls when hurt or under Legs 40, Composure gives it back; shown as "fires 3 in 4 (1 in 2 tired)".
4. One unit on the page: worth per line in exchanges won a bout, the plan in wins in 100. No power points anywhere a player reads.
5. Gas across the rounds: one bar per round showing the Legs and what the card costs; the four-punch line's "thrown whole" read from it.
6. Build the map's price (LinePrice) for real in the exchange: a line's gas goes into lv["cost"], its risk scales the opponent's landed punches.
   Today a planned line is free; without this nothing else on the card is a trade.
7. Build the line grade (LineGrade) on the agreed attributes (Attrs.gd skills exist) with the swap hint; keep the three bands.
8. Switch FireLevel on (shares B) and show the fire share and "Sharp by Thu" on the line and the pad card.
9. Against nature: style word lowers the fire share of lines against it until Sharp; one red note on the card.
10. IF READ with ReadBack for opponents who have the tell; the adapted note in the corner minute names the line and the answer.
11. Corner minute: replace the dropdown with the line that lost most and two rated replacements, one click each.
12. The receipt per line in the Why, graded by the answer first and the dice second (7 of 7 right answers, won 5), with Keep / Swap / On the pads /
    On the mornings.
13. Test it uses the camp's sparring partner: an outside partner of Jo's type narrows the range; club mates of another type widen it.
14. Rounds on lines with only the last round split ahead / behind; pips shown only when a line is not "all".
15. Ana's mat book gets the same receipt and the price per move (her own critic later), so the four fighters' playbooks read the same way.

## Complete for this version?

Yes, with the list applied: four fighters, amateur to a first professional fight. The three boxers' card covers 3 x 3 amateur bouts and the 4-round
debut (rounds on lines handle 4 and 6 rounds), the coach's role is in it (lines held, coach's plan, pad speed, the corner), and item 15 keeps Ana's
mat book from being the odd one out. Two cautions: the depth depends on the probes passing (if LinePrice, LineGrade and FireLevel each fail, the card
falls back near today's lookup and the score with it), and items 1 to 3 are what keep it from feeling like a spreadsheet of chips: they are the
things a real corner says first.

Drawing (my 10/10): docs/mockups/s432/critics/pb2_boxer_10.html and .png: the card with stance, fire share fresh and tired, against nature, one unit,
gas across the rounds, the shouts that are the card's lines, and Test it against the camp partner.
