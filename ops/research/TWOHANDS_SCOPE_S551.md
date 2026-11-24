# TWOHANDS_SCOPE_S551 - the card game's form after his play of version 2 (a METHOD finding)

## What he said (S551, 2026-11-24, verbatim)
- "ithink this is dumb , need to find better mechanic" (the "Take it" button of the per-punch prompt).
- "i do not see health wtf is this ?" (the bar was "Head 0 of 8").
- "there are 1 million deckbuilding games , do a proper research if you have too , i expect a proper innovative design , you
  can interview me if needed . here is an idea : ironbound for example it has four slots 1left hand 2 right hand 3 trinket
  (it can be left leg) 4 trinket (it can be right leg) add more if need for knees and elbows".
- Interview (four questions with options): why Ironbound's slots - "Always there to use" (+ "something else", not said);
  defence - "Separate defence moves"; a turn - "Timing, like Expedition 33"; cards beside the slots - "i amnot sure why
  you say slots for limbs, there so many things you can be creative with , you can use deck for each hand or even combine
  them for example ,decide what each move hits and give opponent various options".

## The rule until this is settled
No more work on the deck engines (`proto/boxcards` rules2 / rules3, `CARDRANGE_SCOPE_S550` is on hold). The form is tested
by HIS HANDS first: timing cannot be scored by a bot, so the toy comes before any probe table or critic.

## The toy (built S551): `proto/twohands/index.html`, preview `twohands` (port 8797)
- A DECK FOR EACH HAND: lead hand (jab x4, lead hook x2, lead uppercut, lead body hook, feint x2) and rear hand (cross x3,
  overhand x2, rear uppercut, body cross x2). Two moves of each hand are always face up: a hand is never dead.
- COMBINE THEM: a lead is up to three moves in order from both hands; changing hands makes the next punch come faster
  (his window x0.8).
- EACH MOVE SAYS WHAT IT HITS AND WHAT HE CAN DO: jab - block, slip, parry; cross - block, slip, step back; hooks - block,
  duck, step back; uppercuts - lean back, slip (a block does not stop them); body - cover up, step back.
- DEFENCE BY TIMING: each punch sweeps a line toward the impact; each defence has its own band. Block / cover = wide
  band, damage cut, his combination goes on. Slip / duck / parry = narrow band, no damage, a counter (2 health), his
  combination ends. Step / lean = middle band, it falls short, you give ground (twice = on the ropes, no more stepping).
  A miss is the punch landing: there is no "take it". A feint that draws a press shrinks the next band.
- Bands shrink when you are rocked (the last punch landed clean) and when your stamina is low.
- His side is played by the machine with the same bands (a dice roll in place of the press).
Checked in the browser S551: a whole bout runs with no console error; a press inside a band works, outside it lands.
NOT DONE: no art, no sound, no punch animation (the sweep is a bar); numbers are first guesses, never probed; the
machine's choices are random-weighted, not read; boxing only; no build layer (which moves sit in each hand).

## What his play decides (phase 0)
1. Is defending by timing fun, or is it a reflex test he tires of? (his "Timing, like Expedition 33")
2. Is choosing between the wide safe band and the narrow counter band a real choice?
3. Does "a deck for each hand, two always face up" feel better than one hand of cards?
Then: paper page with the build layer (training puts moves in each hand's deck; legs, elbows, knees as more decks for
the other arts), a reading opponent, a probe of the choices that a bot CAN score (which defence, which combination),
critics at 8, art.

## Feedback loops (for the later probe)
- Landing clean -> he is rocked -> his bands shrink -> more lands clean. Capped today only by the knockdown reset (health
  back to 5, rocked cleared) and by a successful defence clearing "rocked". To measure.
- Body punches -> shorter stamina bar -> narrower bands and fewer moves -> more body punches land. Floor: bar of 3.
- Step back -> ropes -> no step -> forced to block or risk the narrow band. Cleared when he leads.

## Prior research
`OWNER_CARDGAME_INTERVIEW_S537.md` (fast and punchy, show me everything, Expedition 33 as "a different approach"),
`JOHN_CARDGAME_MARKET_S538_JOHN.md` s4 (Expedition 33), `CARDREF1_REFERENCE_GAMES.md` (Ironbound: never read; corrected in
`CARDRANGE_SCOPE_S550.md`), `DESIGN_CARDGAME_SCOPE.md` 6d (limb points lost to the wind pool - a different thing).
