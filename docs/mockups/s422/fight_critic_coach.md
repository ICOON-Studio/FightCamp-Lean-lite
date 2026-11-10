# Fight display, S421 drawing: the corner coach's review (S422)

Lens: an amateur corner coach, 25 years on the stool. In the 30 seconds between shouts I look at four things only: is my boxer
hurt (legs, eyes, hands dropping), is my boxer tired, is my boxer being out-worked, and is my boxer walking into the other
corner's trap. Then I shout one short thing my boxer can still hear. I judged the S421 layout (`docs/mockups/s421/fight_display.png`)
and its painted copy against that.

## 1. The look first (hard fails)

Score as a game screen: **4 / 10 (capped)**. The painted copy looks good: a real arena, wood frames, readable panels. But it hits
the cap on one hard fail, several times over: **numbers with no visible meaning.**
- The big red "1" and blue "2" in the scorebug. A first look reads them as rounds won or knockdowns. They are exchanges won this round,
  and the six dots right under them already show that.
- The "41" by the eye and the "49" by the ribs. 41 of what? No corner has ever said "the eye is at 41". We say "the eye is going".
- "+0.5" with a bolt on the big call. Plus half of what? It reads like a betting slip.
- The "?" tanks have no word or icon to say what they hide (the bolt sits only on the first one).
Smaller marks also fail the 20 px rule: "LAST CALL" and the R1/R2/R3 tags.

## 2. What is displayed, element by element

| Element | Verdict | How / why | What the corner does with it |
|---|---|---|---|
| Clock 1:40 | KEEP | The one clock that matters. Make it bigger than anything else up there. | Knows how long is left to push or hang on. |
| "1" and "2" (exchanges won) | CUT | The six dots say it already, and say it better: who took each 30 seconds. | Nothing the dots do not give. |
| Six exchange dots | KEEP, label them | Caption "THIS ROUND". This is the true "are we losing the round" read. | Changes the call when two in a row go blue. |
| R1 / R2 / R3 tags | CHANGE | Cards big enough to read, filled in the round winner's colour, the running one striped. In a 3-round amateur bout, "we lost round 1" changes everything. | Knows whether to take risks now. |
| Name | KEEP | | |
| Plan chip "Plan: work the body" | KEEP | It is what we agreed in the dressing room. | Checks the shouts fit the plan. |
| Face/bust that takes damage | KEEP, the best idea here | This is what a corner looks at: the face and the body, not a table. | Hands up, ice, cutman. |
| Numbers on the places (41, 49) | CHANGE | Drop the numbers from the still. The eye closes in four drawn stages with a 4-step eye meter beside it; body shots are dots. The exact number on hover. | Decides whether the eye can last a round. |
| Three dots under the ribs | KEEP | Exactly how a corner counts: "three to the liver, she'll feel it in the third". | Elbows in, or go downstairs ourselves. |
| Three tall bars (energy, legs, guard) | CHANGE | Horizontal, with the word beside each icon, and LEGS first. Legs is what a corner checks first: a boxer with no legs cannot get out of the way. The ghost line at the bell is very good, keep it. | Tie up, breathe, save the pace. |
| Opponent's habit chip "Waits to counter" | KEEP, add the cost | Add how many times it has caught our boxer this round (counter landed when the opponent was in that mode: `mode` + `read.result` per exchange). "Caught you three times" is the sentence I shout at the stool. | Draw the lead; stop leading into it. |
| Opponent's "?" bars | CHANGE | Every hatched bar needs its icon and word, like ours. Energy may show a range, because a corner sees a tired fighter (mouth open, sweat) without scouting. | Go to the body when the range drops. |
| Opponent's sweating face, mouth open | KEEP | Honest, readable in one second, the thing a real corner actually sees. | Push the pace. |
| Eye marker in the ring | KEEP | Short pop over the glove when the habit shows. Fine. | Links the chip to the ring. |
| Dotted line chip-to-call | CUT | It crosses the whole ring. Put the same eye icon on the call that answers it. Same link, no line through the fight. | |
| Call timer 0:14 (a second clock) | CHANGE | Two clocks on one screen is one too many. Make it a drain bar on the call row: "NEXT CALL" and seconds. | Knows when a shout lands. |
| Last call + X | KEEP, show evidence | Not just an X: three small dots, the last three exchanges under that call. Won, lost, lost. A corner trusts a record, not a verdict. | Switches the call. |
| Call buttons | KEEP the words | "Hands up", "Tie up", "Draw the lead" are real corner shouts. Good. | The decision itself. |
| "+0.5" energy | CHANGE | Bolt pips: green bolts = gives energy back, amber = costs. And the dashed forecast on our energy bar (already in the S421 notes). | Picks a call the boxer can afford. |
| "FITS THE MOMENT" star | CUT | It plays the game for the player. The screen should show the evidence (habit fired, three counters landed) and let the player connect it. The eye icon on the answering call is enough of a hint. Show "fit" after the shout, in the last-call dots. | Learning to read the fight is the game. |

## 3. What is missing

1. **Pace and Aim.** Both are built, both stay in force from shout to shout, and neither is on the screen. "Step it up" and "easy, pick your shots"
   are the two things a corner says most. Put them on the call bar as two small switches: Save / Steady / Push and Own / Head / Body.
2. **"NOW!"** The set-up combination set in the corner minute, fired into a gap. Built, missing. It is the most exciting button a corner has.
   A plate that sits dim and lights up when the gap opens.
3. **Work rate.** Is my boxer being out-worked? Punches landed and thrown this round, red against blue, as one bar from the centre in the scorebug
   (the way TV shows it). The S419 decision moved thrown/landed to the corner minute; I disagree. "She's out-throwing you two to one" is said
   during the round, not after it.
4. **Is the boxer listening?** Only two shouts a minute get through, and a Low-morale boxer stops listening. The screen never says so.
   Two megaphone pips (used / left) and the mood word.
5. **The opponent hurt.** The flow has a red vignette when OUR boxer is rocked, but nothing equal when the opponent is. Same picture on the other side,
   the opponent's bust swaying, and "Go for the finish" lit.
6. Corner minute (not live): the cutman's choice on a closing eye, the punch counts by kind, the round on the cards.

## 4. What is useless
- The "1" and "2" digits (repeat the dots).
- The numbers on damaged places in the still (nobody reads damage as a number in 30 seconds).
- "+0.5".
- "FITS THE MOMENT" (answers the question for the player).
- The dotted line across the ring.
- The second clock's digits in a ring.

## 5. The flow

- **A normal round, three calls.** Call 1 at 0:30: the player reads the plan chip and the dots, shouts "To the body". Fine. Call 2 at 1:00: the X arrives
  with no record behind it, so the player does not know whether one exchange or three went wrong. Call 3 at 1:30: the gold star tells the player what to press;
  the player presses it without looking at the fight. That is where the screen stops being a corner and becomes a quiz with the answer printed.
- **Our boxer hurt.** The vignette and the survival call are right. But LEGS is the middle of three identical bars, and it is the first thing a corner needs. The player
  hesitates hunting for it. With no Pace switch on screen, the player cannot say "save it, survive the round", which is the real call.
- **The opponent hurt.** Nothing on screen says it, except the sweat. No "NOW!", no finish call lit, no pace switch to push. The player misses the moment that wins amateur fights.

## 6. Scores

| | Score |
|---|---|
| Look | 4 (capped; 6 without the meaningless numbers) |
| Clarity in five seconds | 5 |
| Depth of the decision | 5 (Pace, Aim and NOW! are missing; the star answers for you) |
| Excitement of watching | 6 (the face, the sweat, the eye pop are good) |

## 7. How to reach 10/10 (most important first)

1. Cut every number with no meaning: the "1"/"2" digits, the place numbers in the still (hover only), the "+0.5". Replace with dots, drawn eye stages and bolt pips.
2. Put Pace (Save / Steady / Push) and Aim (Own / Head / Body) on the call bar as two switches showing what is in force.
3. Add the "NOW!" plate with the combination set in the corner minute; dim until the gap opens, then it lights.
4. The habit chip counts what it costs: "CAUGHT YOU" with one cross per counter that landed this round.
5. Cut "FITS THE MOMENT" and the dotted line; mark the answering call with the same eye icon as the habit chip.
6. Last call shows the last three exchanges under it as three dots (green won, red lost), not a bare X.
7. Our three tanks horizontal, labelled, LEGS first, ghost line at the bell kept, danger zone kept.
8. Every opponent bar gets its icon and word; energy shows the seen range with the word TIRING when it is true.
9. Work rate in the scorebug: landed / thrown this round, one centre-out bar, red against blue.
10. "HEARS YOU": two pips for the two shouts a minute that get through, and the mood word.
11. One clock only: the call timer becomes a drain bar "NEXT CALL 14 s".
12. Round cards big enough to read, filled in the winner's colour, the running one striped.
13. A mirror of the rocked vignette for the opponent, with the finish call lit.

## 8. My 10/10

`docs/mockups/s422/fight_10_coach.html` rendered to `docs/mockups/s422/fight_10_coach.png` (1920x1080, wood frames from
`assets/ui/wood/panel.png`, the ring from the S421 painting). About 47 words on screen not counting names and numbers; smallest type 20 px (caps captions).
Every element reads data the game already has: exchanges won, landed/thrown, energy/legs/guard, damage by place, eye swelling, the opponent's
`mode` and `read.result` (the "caught you" count is a count over existing exchange records, no rule change), shouts heard (CornerTrust), morale, Pace, Aim,
the set-up NOW!, the call's energy cost. So no warning triangle is needed. If the build finds the counter-landed count is not stored per exchange, that row
takes a triangle until it is.
