# Fight display critic: the new player (S422)

Lens: a first-time player who bought the game on Steam yesterday. Knows boxing from big fights on TV, has never played a management
sim. The test: in five seconds, do I know who is winning, whether my boxer is in trouble, and what each button will do?

Judged: `docs/mockups/s421/fight_display.png` and `docs/mockups/s421/fight_display_painted_ludo.png`.
My 10/10: `docs/mockups/s422/fight_10_newplayer.png` (HTML beside it).

## 1. The look first (hard fails)

The painted version looks like a game: a real arena, wood frames, two boxers. The flat layout looks like a wireframe. But both have
the same hard fails, so the score is capped at 4:
- **Numbers with no visible meaning.** "41" and "49" in circles on the face and the vest: I can't tell if they are health, damage,
  punches taken or a level. "+0.5" on the big button: half of what? "1" and "2" in the scorebug: on TV, big digits beside the clock
  are rounds or points, so I read "my boxer is losing 1 to 2", and that is not what they mean.
- **Labels I would need a manual for.** The boot icon (it looks like a "T" or a table leg). The blue square, arrow, red square on
  "Waits to counter". The three orange dots under the vest. The white tick line and dashed gold box on the tanks. The hatched bars
  with "?". "FITS THE MOMENT" (fits what?).
- **Type under 20 px.** R1/R2/R3, "LAST CALL" and the drawing's hint notes are under 20 px.
- **The X looks like a close button.** "LAST CALL To the body (X)": I'd click the X to dismiss it.

**Look: 4/10** (painted 4, capped; uncapped it would be about 6).

## 2. What is displayed, element by element

| Element | Verdict | How, in plain words | What the player does with it |
|---|---|---|---|
| Clock 1:40 | KEEP | Big and clear. Add "ROUND 2 of 3" in words beside it; "R2" alone is easy to miss. | Knows how long is left. |
| Big "1" and "2" | CHANGE | Put them in a row labelled THIS ROUND, with the names beside the digits ("LUCY 1 ... 2 MARIA") and the pips between. Smaller than the clock. | Sees who is winning this round. |
| Six exchange pips | KEEP | Inside the THIS ROUND row; the running pip ringed and glowing. | Sees the round's story. |
| R1 R2 R3 cards | CHANGE | Make them 22 px or larger. R1 filled red = won. The live round gets a dashed gold border. | Sees who is winning the fight. |
| Name | KEEP | | |
| Plan chip | KEEP | "Plan: work the body" reads well. | Remembers the plan; changes it in the minute. |
| Face / bust | KEEP, CHANGE | Keep the picture. Each hurt place gets a tag with its word and number and a small bar out of 100 ("Eye 41 ▬"). Places that are fine stay quiet. | Sees where the boxer is hurt. |
| Circled 41 / 49 | CHANGE | Turn them into the labelled tags above, placed next to the body part, never on top of it. | |
| Trouble state | MISSING | A big amber "EYE HURT" plate (red when critical, "ROCKED" when hurt). | Knows the boxer is in trouble without reading numbers. |
| Three bars (bolt/boot/shield) | CHANGE | Make them horizontal, with the word next to the icon (ENERGY, LEGS, GUARD) and the number at the end. Keep the hatched danger zone. Cut the white ghost tick for now. | Knows what is left. |
| Hit dots under the vest | CUT | They mean nothing until explained; the ribs tag and its bar already show the damage. | |
| Opponent habit chip | CHANGE | "Habit: waits to counter" with the gold eye icon. A NOW badge flashes when the habit happens. Cut the coloured squares. | Knows what the opponent keeps doing. |
| Opponent "?" bars | KEEP, CHANGE | Same labels as my side. Energy shows "LOW" with a range once seen. | Learns that scouting shows more. |
| Sweat / open mouth | KEEP | The clearest picture on the screen. Add a "TIRING" plate. | Pushes. |
| Eye marker in the ring | KEEP | Keep it gold; the same eye icon is on the habit chip and the best button. | Links the habit, the moment and the answer. |
| Dotted line across the screen | CUT | It crosses the ring and the crowd and reads as a glitch. The matching eye icons already join the three. | |
| Call timer 0:14 | CHANGE | Label it "NEXT SHOUT". Two clocks with no labels is the worst confusion on the screen. | Knows when the next shout lands. |
| Last call + X | CHANGE | "LAST SHOUT: Go to the body", then a red "✗ NOT WORKING" and the three exchange dots. | Switches to another call. |
| Call buttons | CHANGE | Each one shows its key (1, 2, 3), a fit word (BEST NOW / OK / WRONG NOW) and its energy effect as icon arrows. | Picks a call. |
| "+0.5" | CUT | Replace it with arrows: one bolt and ▲ or ▼, two arrows for a big change. | |
| "FITS THE MOMENT" | CHANGE | Say "BEST NOW". | |
| Say nothing | MISSING | A quiet dashed button. Today a new player won't know that saying nothing is allowed. | Saves trust and energy. |
| Speed / skip | MISSING | 1x, 2x and Skip round, top right. These are built. | Controls the pace of watching. |

## 3. What is missing

- **"Is my boxer in trouble?" as one word.** An EYE HURT / ROCKED / DOWN plate on the boxer's panel, in the band colour. This
  belongs on this screen.
- **Who is winning the fight**, not only the round. The round cards say it, but they are too small today. Belongs here.
- **Say nothing** as an option. Belongs here.
- **Watch speed and Skip round.** These are built but not drawn. They belong here, top right.
- **Pace and Aim.** They carry from shout to shout, but a new player can't see or change them here. Put them in the corner minute
  as two pictured sliders (a bolt for Pace, a target on the body for Aim), not on the live screen.
- **What each call does** before pressing. The fit word and the energy arrows cover it. A hover card with one line of plain words
  about the call also belongs here (hover only, so it stays off the word count).

## 4. What is useless

The three dots under the vest, the white ghost tick on the tanks, the coloured squares on the habit chip, the dotted line, the
decimal energy number, and the drawing's hint notes (they are notes for us, not for the player).

## 5. The flow

- **A normal round, three calls.** I see 0:14, but I don't know whose clock that is. I press the glowing button because it glows.
  Thirty seconds later "To the body (X)" appears and I try to close it. I learn nothing from the call. Fix: label "NEXT SHOUT",
  and use "✗ NOT WORKING" in words.
- **My boxer is hurt.** The swollen eye is visible, but 41 means nothing. HANDS UP and TIE UP give no sign of which one protects.
  I hesitate. Fix: the EYE HURT plate; the fit word turns HANDS UP to BEST NOW when the boxer is hurt; the energy arrows show that
  TIE UP rests.
- **The opponent is hurt.** The sweat reads well. But "1 2" at the top tells me the opponent leads, so I don't believe the
  opponent is in trouble. Fix: the TIRING plate and the THIS ROUND row with names.

## 6. Scores

| | Score |
|---|---|
| Look | 4 (capped by hard fails) |
| Clarity in five seconds | 3 |
| Depth of the decision | 6 |
| Excitement of watching | 5 |

## 7. To reach 10/10 (most important first)

1. Label the two clocks: "ROUND 2 of 3" by the main clock, "NEXT SHOUT" above the ring timer.
2. Replace the big 1 / 2 with a THIS ROUND row: name, digit, pips, digit, name. Make the R1/R2/R3 cards 22 px or larger, with
   the winner's colour.
3. Turn every circled number into a tag: place word, number and a small bar out of 100 ("Eye 41", "Ribs 49"). Place it next to
   the body part, never on it.
4. Add a trouble plate on each boxer: HURT (amber), CRITICAL (red), ROCKED, TIRING (blue with sweat).
5. Make the tanks horizontal with icon + word + number. Swap the boot for a clearer legs icon; keep the hatched danger zone.
6. On every call button: its key number, a fit word (BEST NOW / OK / WRONG NOW) and energy arrows instead of "+0.5".
7. Change the last call to "LAST SHOUT: <call>" with "✗ NOT WORKING" or "✓ WORKING" in words and the exchange dots.
8. Add a SAY NOTHING button and the 1x / 2x / Skip round controls.
9. Cut the dotted line, the hit dots, the ghost tick and the coloured squares. One gold eye icon joins the habit chip, the ring
   marker and the best button.
10. Hover cards: one plain line per call, per tank and per place (off the word count). After the first fight, an option to hide
    the tank words.

## 8. My 10/10

`docs/mockups/s422/fight_10_newplayer.png`. The 50 words are counted (not names or numbers); the smallest type is 20 px; the
panels cover about 36% of the screen.

The background is the S421 painting. Its old panels are covered, and its dotted line is painted out with a shifted copy of the
crowd.

Everything shown is data the game has: the round clock, exchange winners, round cards, place values with bands, energy / legs /
guard, the opponent's seen tiredness as a range, the scouted habit (`mode`), the call's `fit` and energy cost, the last call's
lost exchanges. No warning triangle was needed.

One honest weakness: ▲ / ▼ on the energy arrows is still a convention to learn. Colour them (green gives, red costs) when built.
