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

## Changes after his first plays (S551, all in `proto/twohands/index.html`)
His words, in order: "why i am down ?"; "make the thing that describes the fight to be clear about the action , i think
you are too generous with the stamina"; "Slip is too strong i think , how about making the counter timed event ?
breather is useless/bad design as it stands now . Add a clock or something soplayerknows when rounds ends"; then
"keep working on 2hands".
- Every punch line shows its damage; the knockdown line says the rule (health 0, up with 5, three and it is stopped).
- The exchange is told move by move (who threw what, what the other man did, what it cost; green good, red bad).
- Stamina: 2 back an exchange (was 3); any defence but a block costs 1, charged even when mistimed; the bell gives 4.
- A slip, duck or parry only makes the punch miss; a TIMED COUNTER follows (narrow band): landed = 2 health and his
  combination ends, missed = he keeps coming. The machine's counters land by its own rate.
- No breather: each of the three moves not thrown returns 1 stamina; "Cover up" only when no punch can be paid for.
- A round clock: 3:00 counting down 30 s an exchange, six ticks, "last exchange of the round".
- THE RING: our own 2D fight pictures (`assets/ui/fight_pictures/m`, small web copies in `proto/twohands/img`), every
  punch landed / blocked / missed for both men, knockdowns; the game's punch, block, miss, bell and crowd sounds
  (`proto/twohands/snd`, a Sound on/off button); damage numbers pop over the man hit; the ring shakes when you are hit.
- THREE OPPONENTS WHO FIGHT DIFFERENTLY (their own two decks, hand speed, health, how they defend and counter):
  The Jabber, The Slugger, The Body Snatcher - picked before the bout.
- PACK YOUR HANDS before the bout: how many of each move sits in the lead hand (10) and the rear hand (8).
Checked S551: a scripted bout against The Slugger ran clean (pictures swapped per punch, no script error); headless
screenshots at 1400 x 900 of the pick screen and of a defence - everything fits one screen. NOT checked: a phone-width
layout by eye; the sounds by ear (nobody has heard them on this page); balance of the three opponents (first guesses).
Known art limit: the pictures are end-of-punch stills, so the punch does not travel on screen - the sweep is still the
timing cue. An overhand uses the rear-hook picture (no overhand picture exists).

## The timed mechanic reworked, and a second defence style (S551, his "can you work on th e2hands timed mechanic and alsoseeif you can find an alternative forthe gaurds")
My reading of "the guards": the defence options (the block and its two cousins as three timed presses). If he meant
something else, this section is the wrong answer.
- THE PUNCH TRAVELS: a glove flies across the ring from the puncher to the target (head height or body height) on the
  same clock as the white line; it arrives at the impact.
- PERFECT TIMING: the bright middle of every band (35% of it). A perfect block lets nothing through; a perfect slip,
  duck or parry counters at once (no second press); a perfect step back gives no ground.
- YOUR PUNCHES ARE TIMED TOO: each punch you throw gets one press (Space or tap) as it lands. In the band = a SHARP
  punch (the machine reads and times its defence 30% worse); in the bright middle = +1 health; no press = an ordinary
  punch, no penalty.
- DEFENCE STYLE B, "a guard and timed moves" (picked on the first screen; it is the default so he sees it):
  the block is no longer a timed press. You HOLD a guard high or low (W / X or tap, any time, no timing). It stops what
  is aimed where it is held - a head punch against a high guard, a body punch against a low one - and every punch it
  stops wears a GUARD bar (8; minus the punch's damage; 2 back each exchange, 4 at the bell). A broken guard stops
  nothing. An uppercut comes up through any guard. Slips, ducks, parries, leans and steps stay timed presses and set
  up the counter; a move that is mistimed leaves you with no guard for that punch. The opponent has the same guard,
  shown on his panel ("held high"): hitting where his guard is not is now a choice when you lead.
- Style A, "three timed presses", is still there to compare: everything as before.
Checked S551 in the browser: a scripted bout in each style ran with no script error (guard took head and body punches
at the right height and wore down 8 -> 3; the three-press style unchanged); headless screenshots of both screens at
1400 x 900 fit. NOT checked by a person: whether the sharp press makes leading better or just busier; whether holding
a guard is a decision or a default; every number (guard 8, wear = damage, sharp 30%) is a first guess.

## S551, after playing the timed versions: THE TIMED PRESSES ARE OUT FOR NOW (his call)
His words: "i dont like the timed mechanic fornow , can you find another way to block guard and defence ? maybe a block
cards can be generated if some criteria are met , i have some ideas but you can brainstorm it and ask other ideas from
ludo,ziva,grokbots".
- No more work on the sweep, bands, sharp presses or timed counters until he says so. They stay in the page as built.
- Kept from Two Hands (nothing he rejected): a deck for each hand with two moves face up, combinations across hands,
  each move says what it hits, the ring with our pictures, three opponents, pack your hands, the round clock, the
  move-by-move story, stamina that pays and returns for moves held back.
- Idea round, independent (no proposal of ours in the brief): `TWOHANDS_DEFENCE_IDEAS_BRIEF.md` sent to Kalli (SQ326) and
  John (SQ328); Dola (SQ327) waits for its app's debug port; Ludo asked in a new Ask Ludo chat "Boxing Defense
  Mechanics" (never the chat that was open: it was another project's). Ziva not asked: it needs a Godot editor and the
  coach probe is running Godot jobs.
- HIS OWN IDEAS come first: he said he has some. Ask, then set them beside the seats' and Claude's.
- A few minutes later, his refinement: "the timed mechanic would be nice if the are are animations and the defence gets
  triggerred on its own maybe and pllayer has to react or something like that". So timing is a LATER layer, not dead:
  it needs real punch animations; the defence itself happens without a press (from cards or the boxer), and the player
  REACTS to a moment (for example a counter opening), instead of pressing for every punch.
- Ludo: the question and one follow-up line are posted in the new chat "Boxing Defense Mechanics"; no reply came in
  about three minutes and the page showed no error. To be read later from All Chats; not asked again.

### Claude's own shortlist (before the seats answer; nothing built)
1. HANDS AT HOME: your defence is what you did not throw. A hand you hold back in your lead makes a guard card for his
   next lead (lead hand held: catches a straight; rear hand held: covers the side of the head; both held: the body
   too). Throw all three and you have nothing. You lay the cards under his combination: his first move is face up, the
   rest face down. Real boxing: a hand that punches is not guarding.
2. EARNED ANSWERS: events create a card - your jab lands: a Slip (it misses and you counter); he bites on your feint: a
   Counter; you give ground: a Pivot off the ropes; you block two running: a Clinch. Use it in his next lead or lose it.
3. A STANCE EACH EXCHANGE: before he leads you pick one of three stances (high guard, shell, on your toes); each stops
   some kinds of punch and costs something different. Read from his two face-up moves a hand.
4. THE GUARD BAR ALONE: the guard held high or low that wears (built), with no timed moves at all.
Pick to try first: 1 and 2 together - it is his hint ("block cards generated if some criteria are met"), it keeps both
decks pure offence, and the lay-under-his-cards step measured well with bots in rules3 (a real choice 13% of the time
against 1% for the old prompt; no blind pilot over 38%). The later layer (his refinement): once punches are animated,
the laid cards play by themselves and one REACT moment appears when a counter opens.
