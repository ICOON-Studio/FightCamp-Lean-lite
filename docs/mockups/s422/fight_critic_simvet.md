# Fight display (S421 drawing): review by the sim-veteran critic (S422)

Lens: a long-time player of management games with a live match view. I compare it with Football Manager's match screen and
its touchline shouts, Motorsport Manager's race screen and other sports sims with live calls. I weigh one thing above the
rest: can the player read the state, make a call that costs something, and then see that call land or fail.

Reviewed: `docs/mockups/s421/fight_display.png` and `fight_display_painted_ludo.png`. Read first: CRITIC_PACK, CRITIC_ACCESS,
FIGHT_HUD_BRIEF_S419, and sections 2, 3, 4 and 7 of FIGHT_DISPLAY_DECISION_S419.

## 1. The look: 4/10 (capped by a hard fail)
The structure is right and follows the race-screen pattern: a scorebug at the top, a car (boxer) panel on each side, and the
pit wall (corner) along the bottom. The painted version looks like a game screen and the ring stays clear. Two hard fails
cap the score:
- **Numbers with no visible meaning.** The "41" by the eye and the "49" by the ribs have no unit, no scale and no word. A
  player reads them as hit points. That is the same "do we only have 2 hit points" complaint again.
- **The tank icons need a manual.** The bolt, boot and shield are about 25 px with no word and no number. In Motorsport
  Manager every gauge also carries its value and its trend.
- Also: "LAST CALL" and the R1/R2/R3 chips are smaller than 20 px. The reader notes are 15 px (they are notes, but still).

## 2. What is displayed

| Element | Verdict | How / what the player does with it |
|---|---|---|
| Scorebug clock + "2 of 3" | KEEP | Times the push. Hint 11 (clock turns gold) is good. |
| Six exchange pips | KEEP | The momentum strip. Football Manager's momentum graph does the same job in one glance. |
| Big digits 1 / 2 | KEEP | Who leads this round. |
| R1/R2/R3 chips | CHANGE | Make them the **cards estimate** (whose round, filled in their colour, live round dashed), and 24 px. Push or save depends on being ahead on the cards, and the screen hides that. |
| Name | KEEP | |
| Plan chip | KEEP | Reminds you what the corner is building on. Light it up when a plan line pays off. |
| Face / bust | KEEP, CHANGE | Colour every place by its band and add a 3-word key (fine, hurt, critical). Tag the worst place in words ("EYE"). |
| 41 / 49 on the face | CUT | Show the number only on hover. The colour band is what drives the call. |
| Three bars | CHANGE | Put the value and a word under each (energy, legs, guard). Keep the ghost line and the danger zone. Add a drain chevron (hint 8). |
| Hit marks (3 dots under the ribs) | KEEP | Liver stacking (hint 4) works as a picture. |
| Opponent habit chip | KEEP, CHANGE | Swap the blue/red squares for a glove picture (waits, then counters) and show how often it has happened in this fight (3x). That count is the scouting paying off, which is the FM "opposition instructions" pleasure. |
| "?" hatched bars | KEEP | Honest unknowns. Energy as a range bracket is exactly right: it is what a corner can see. |
| Eye marker in the ring | KEEP | The best moment on the screen. |
| Dotted line across the screen | CHANGE | Show it for 1 s only, then fade. Held, it is clutter crossing the boxers. |
| Call timer ring | KEEP | |
| Last call + X | CHANGE | Show the last three exchanges under that call as tick / cross / cross. A lone X does not say why it failed. This is hint 1, made readable. |
| Call buttons | CHANGE | Every call shows its fit (Beats it / Works / Wrong, the Playbook's own words) and its energy direction. Today only the best call is graded, so the player cannot weigh anything. |
| Energy "+0.5" | CHANGE | "+0.5" against a 0-100 tank means nothing. Draw it as a dashed forecast on the tank, plus an up/down arrow on the button. |
| "FITS THE MOMENT" stamp | CHANGE | It hands over the answer, so the call becomes "click the gold one". Grade all three and leave the choice to the player. |

## 3. What is missing (the decisions the player owns but cannot see or make)
1. **Pace and Aim.** These are standing orders the game already has (Push/Steady/Save, Head/Body; pack 4.8), and they persist
   between shouts. This is Football Manager's mentality and Motorsport Manager's fuel mode. They are not on the screen. Put
   them as toggles on the bottom bar.
2. **The set-up "NOW!".** It is built: a learned combination fired into a gap the opponent opens. It is the most exciting call
   in the game, a timed window like a pit window, and the screen has no place for it. Picture: a gold plate near the
   opponent, "NOW! 1-2-3", with a 3-second countdown and its energy cost.
3. **Shouts that get through.** Only two instructions a minute land fully, and a Low boxer stops listening. Picture: an ear
   with 2 pips. Without it, spamming calls costs nothing the player can see.
4. **Energy projection.** Motorsport Manager's gauge says how many laps the fuel lasts. Here, a strip of R1/R2/R3 with the
   energy line running out inside R3 (marked not built: it is arithmetic on the drain rate, but no code makes it yet).
5. **Speed controls.** 1x/2x and skip round are built but missing here. Every match view has them.
6. **Cards estimate.** See the R chips above.
Belongs in the corner minute, not here: punch counts by kind, exact place numbers, the cutman's choice.

## 4. What is useless (changes no decision)
- The 41 and 49 as bare numbers. The band colour carries the decision.
- The "FITS THE MOMENT" stamp, because it makes the decision for the player.
- The blue-to-red squares in the habit chip.
- The held dotted line.

## 5. The flow
- **Normal round, three calls.** The player sees the gold plate, clicks it, and repeats. There is no hesitation, but there is
  no decision either. Nothing tells the player that the shout budget is spent (2 a minute), so the third call wastes itself
  silently. A Football Manager player would ask: "what does Steady vs Push cost me for round 3?" The screen cannot answer.
- **The boxer is hurt.** The red vignette and the survival call jumping forward (hint 10) are good. What is missing: how
  long the trouble lasts and how close the next count is (the knockdown risk). The player hesitates between Tie up and Hands
  up with no sign of which one buys time.
- **The opponent is hurt.** This is the payday moment, and the screen gives it the least. "Go for the finish" needs its
  energy cost against the tank, and the NOW! gap needs to pop. Today the player sees sweat on the bust and must guess
  whether there is enough energy to finish.

## 6. Scores
- Look: **4** (capped; about 6 without the hard fails)
- Clarity in five seconds: **5**
- Depth of the decision: **3**
- Excitement of watching: **4**

## 7. To reach 10/10 (most important first)
1. Grade all three calls with the Playbook's words (Beats it / Works / Wrong) plus an energy arrow, and drop the
   "fits the moment" stamp. The choice becomes a trade-off.
2. Add the Pace (Push/Steady/Save) and Aim (Head/Body) toggles to the corner bar, always visible. They are built.
3. Give the set-up "NOW!" its own pulsing gold plate beside the opponent: combination name, gap countdown, energy cost. It
   appears only when the gap is open.
4. Show the shout budget: an ear with 2 pips that empty as shouts are used, and greyed when morale is Low. Watch the words:
   the morale word "Steady" collides with the pace "Steady" (one word, two meanings), so show trust as pips, not the word.
5. Replace the face numbers with band colour, a 3-word key and a tag on the worst place. The number goes to hover.
6. Put the value and a word (energy, legs, guard) under every bar, at 30 px and 20 px.
7. Turn the round chips into the cards estimate: whose round, the live one dashed.
8. The last call shows tick/cross for the last three exchanges under it.
9. Energy projection strip, R1 to R3 (not built: needs the drain rate projected).
10. Add the 2x and skip-round buttons to the corner bar.
11. The dotted habit line flashes for 1 s, never held.
12. Show the opponent habit's count this fight (3x) beside the glove picture.

## 8. My 10/10
`docs/mockups/s422/fight_10_simvet.png` (HTML beside it). It has 50 words on screen, none smaller than 20 px, and about 60%
of the picture is clear. The ring is the painted S421 image, cropped. The idea: the Motorsport Manager pit wall applied to a
boxing corner. Standing orders on the left, the shout budget and the timer, the last call's record, three graded calls, and
"say nothing". The NOW! window pops beside the opponent. The warning triangle marks the energy projection, which is not built.
Painted leftovers in the ring background (the old dotted line) belong to the borrowed picture, not to the design.
