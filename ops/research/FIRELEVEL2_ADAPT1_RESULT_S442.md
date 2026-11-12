# Two measurements re-run after the foundation merge (S442): FIRELEVEL2 and ADAPT1

Both through the game's real bout, existing probes, nothing in the game changed. Raw logs: E:/FightCamp/tmp/s442/.

## FIRELEVEL2 - what a Sharp or Signature move is worth (tools/fire_level_probe.gd, 400 paired bouts a cell)
Population: Lucy v Maria Ortega (Pressure fighter), the GOOD plan (Double jab, Step back, Pivot out, Tie up), no film, no
shouts, 3 rounds. Only ONE of the four lines is a combination (Double jab); steps and defences always fire.

| Cell | Bouts won | against today |
|---|---|---|
| Today's game (the rule off) | 58.0% | - |
| Shares 0.6 / 0.8 / 1.0, the line Usable (35) | 54.8% | -3.2 |
| the line Sharp (65) | 56.8% | -1.2 |
| the line Signature (90) | 59.3% | +1.3 |
| Shares 0.5 / 0.75 / 1.0, Usable | 53.5% | -4.5 |
| Sharp | 56.0% | -2.0 |
| Signature | 59.3% | +1.3 |

Reading: one level on ONE line is worth 2 to 3 wins in 100 (noise at n=400 is about 2.5 points, so each single step is at
the edge of what this probe can see; Usable to Signature, 4.5 to 5.8 points, is real). Today's control is 58.0%; before
the foundation it was 41.3%, so the foundation moved this matchup by 17 points: every older number quoted for it is void.
VERDICT (Claude): the rule is worth switching on with the wider shares (0.5 / 0.75 / 1.0), because without it a Sharp
move and a Usable one fight the same and pad time buys nothing in the ring. NOT switched on in this session: it lowers a
new fighter's win rate by about 4 points on a plan with one combination and more on a plan of three, so it goes on
together with a re-measure of the first season's win rates (balance harness), not alone.

## ADAPT1 - an opponent who adapts between rounds (tools/adapt_probe.gd, 300 bouts a cell)
After each round the opponent plays the game that lost most x0.4 and the game that won most x1.6. "re" = our corner sees
the change and sets the round's plan to the answer to the new best game.

| Opponent | Corner | fixed | adapts | adapts + our answer |
|---|---|---|---|---|
| Pressure fighter | plan only | 26.3 | 26.7 | 26.3 |
| | two shouts a round (the game) | 42.3 | 43.3 | 36.0 |
| | a shout every exchange | 44.3 | 43.3 | 46.7 |
| Counter-puncher | plan only | 17.0 | 16.7 | 23.0 |
| | two shouts a round | 36.7 | 37.0 | 31.0 |
| | a shout every exchange | 37.3 | 37.7 | 39.3 |
| Volume puncher | plan only | 28.0 | 25.3 | 27.0 |
| | two shouts a round | 41.7 | 42.3 | 34.7 |
| | a shout every exchange | 42.7 | 45.3 | 46.0 |

Reading (noise about 2.8 points a cell): the adapting opponent by itself changes nothing (within 1 point in 7 of 9
cells). Our ANSWER to it is the problem: in the corner the game really has (two shouts a round) answering LOSES 6 to 8
points against all three styles; it helps only with no shouts at all or a shout every exchange.
VERDICT (Claude): the adapting opponent stays OFF. It would add a note the player is told to act on, and acting on it
loses fights. Before it can come back: find why the changed round plan fights the two shouts (the likely cause, to check
first: the new plan lines and the standing corner call pull to different places, the same clash the S442 result page
dump showed between line C and "Tie up").
