# PLAYBOOK_CLARITY_S359 - Moves and Plans as a move book and a game plan

Operator S359, verbatim: "the playbook/moves is still confusing to me", "i also do not understand how playbook/plans works".
He also said: "i really like the playbook / combos panel, this is really fun to try and also learn from the book !!"

## What is confusing today (Claude, reading the screen: still s359_playbook_real.png)
- Moves and Plans are one screen: a map of 8 position cards joined by arrows, a legend explaining five kinds of arrow,
  a "MOVES OUT / MOVES IN" list for the chosen card, a "YOUR ROUTE" trail, and plan buttons ("Real fight plans",
  "See the flow", "Clear") even on the Moves tab, which only browses.
- To learn one move you first have to understand the graph. To make a plan you have to know that clicking a "move out"
  adds an arrow, that there is one arrow per card, that WHEN pills change what the next click means, and that the
  limit is the coach's (6).
- The tab you enjoy (Combos) works the opposite way: a list to pick from, the result in words, her body shows it.

## The proposal (built only after your yes)
1. **MOVES = a move book**, the pattern of the new Escapes tab (MoveBook.gd, S359): moves grouped by where she is in the
   ring (FROM OUTSIDE, AT LONG RANGE, MID RANGE, INSIDE, CLINCH, ON THE ROPES, OPPONENT ON THE ROPES). Each card says in
   one line what it does and whether she can use it yet; a click plays it on her body. No map, no route, no plan buttons.
2. **PLANS = the coach's game plan, written as lines** (how a real corner writes it on a card):
   - "At long range ->  One-two"
   - "When she presses ->  Step back"
   - "Mid range ->  Cross, hook"
   - "Inside ->  Roll under and out"
   - "On the ropes ->  Pivot off the ropes"
   - "In the clinch ->  Push off"
   One pick per line, chosen from the moves she can use THERE (a short list that plays when hovered), up to the coach's
   number of lines (6 now). Under it: "Test it (3 left)" with the range of wins, and "Save plan". A "Real fight plans"
   button loads a famous plan into the lines. The map stays behind "See the flow" for anyone who wants it.
3. Nothing in the fight changes: the lines ARE today's arrows (same data, `fighter.arrows`), only the screen changes.

## Why
- J52 (screen vs tooltip): what the player needs to act stays on the screen in words; structure lives behind a button.
- Combos (the tab he likes) already proves a list + words + her body beats a graph for him.
- Real coaches' game plans are a short list of situations and answers (REALPLANS_S341.md), not a graph.
