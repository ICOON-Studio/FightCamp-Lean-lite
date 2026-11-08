# Menus and structure, adjusted to the seven mechanics (S402, 2026-11-08)

Operator: "do those thare agreed with critics and have big impact" (MECHANICS_DECISION_S402.md), then "also adjust menus and structure design and
then we can proceed in making themenus ?". Starts from CORNER_KING_REFINED_S401.md and the 14 painted menus (docs/mockups/s401).

## The structure (unchanged in shape)
Five rail buttons: Home, Fighters, Fights, Club, World. One home per job. No mailbox. Nothing opens by itself.
Time: one big button, stopping at the next thing that needs you, and saying what that is.
One booked fight runs in a straight line: Home countdown, camp, weigh-in, tape, fight night, the Why.

## Where each of the seven lives
| Row | Mechanic | Its one home | Reaches the player through |
|---|---|---|---|
| R11 | Every random swing has a readable reason | The line that already reports the swing: Home "Since last Monday", week review, Why | No new panel. A sentence on an existing row |
| R24 | Fighters who fight differently | Fight prep "What your plan should answer"; Playbook lines rated vs the opponent | Scouting finds the real matchup |
| R28 | Cutman: a closing eye, stop it or go on | Fight night, corner minute | A card in the fix row, behind a divider. Never a pop-up, never pre-selected, does not use one of the two fixes |
| R25 | Opponent adapts by round 2 | Fight night, corner minute: replaces the coach's note, 14 words at most | Names the line that stopped working; that line's fix is pre-marked |
| R37 | Ask for a fight, a refusal gives its reason | Fights, under the offers | Level, date window, answer with its reason |
| R55 | Two fighters, one coach: who gets the pads | Fighter page > Week, a row at the top of Learn on the pads | Shows only with two fighters in camp; a needs flag says when the second camp starts |
| R58 | A fighter leaves for a bigger gym | Fighter page > Overview, top card | The needs flag (top bar and Home) opens it in one click: match the offer, promise something, or let her go |

## Menu by menu
| # | Menu | Change from the S401 painted version | Repaint |
|---|---|---|---|
| 1 | Home | Same. The Monday page stays: it is how "nothing opens by itself" is kept. R11 is words on an existing row | No |
| 2 | Start | Same: the three starts (Fresh doors and the harder ones) are already in the game | No |
| 3 | First week | Same | No |
| 4 | Fighters | Same | No |
| 5 | Fighter > Week | ADD "Coach's pad nights" as the top row of Learn on the pads, two fighters in camp only, with the cost to the other fighter. Moved here from Grow | Yes |
| 5b | Fighter > Overview | NEW STATE: a rival gym's offer with its three answers. Moved here from Grow | New |
| 6 | Playbook | Same | No |
| 7 | Fights | Same: Ask for a fight is already painted. Build waits for the bot test that a smart ask beats a plain one | No |
| 8 | Fight prep | CUT "Injury risk" on each camp choice (R41, on hold) | Yes |
| 9 | Fight night | ADD cutman card and the "she has adapted" note. Stats down to three rows in the minute. CUT "One change for next time" (R31, on hold; the Why's NEXT line carries it) and the money lines under the Why (they move to Home, "Since last Monday") | Yes |
| 10 | Money | Same. Dues bands wait for his call on the cut | No |
| 11 | People + Records | CUT the members panel (R57, on hold). Staff cards keep their faces: the art exists | Yes |
| 12 | World | Same | No |
| 13 | Top bar | Same | No |
| 14 | Grow | CUT prospect deadlines (R62, later). The second-fighter clash and the rival gym move to their homes above. Grow is finding and signing only, plus the pro offer | Yes |

## Held back, so nobody builds them from an old mockup
R31 one change after the Why, R41 camp risk, R29 scorecards after each round, R57 members panel, R62 prospect deadlines, R89 and the progress chart on History,
sponsor line and per-fighter costs. R31 is the nearest miss (critics 8 and 7).

## Depends on something not yet built
R25 needs the fighter model (R24). R58 needs the running world. R37 needs its bot test. The painted screens show the intended state, with no promise on timing.

## What appears when (every conditional element)
| Element | Appears when | Goes when | First-week player sees it? |
|---|---|---|---|
| Coach's pad nights (R55) | Two fighters are in camp in the same week | One camp ends | No |
| Needs flag: second camp | The second camp starts | She has opened the Week | No |
| Cutman card (R28) | An eye reaches the closing state at the bell | The eye is treated or the fight ends | Only if her first bout gets there |
| Adapted note (R25) | From round 2, when the opponent has answered one of your lines | The corner minute ends | Yes, in her first bout |
| Rival offer (R58) | The running world sends one, flag only | Answered or past its date | No |
| Ask for a fight (R37) | Always on Fights, once a boxer is signed | Never | Yes |
| Swing reason (R11) | A random roll moved a number you can see; links to the choice if one caused it | Scrolls off with the week | Yes |

## Critics' round on this structure (two sonnet critics, S402)
Player 7/10, UX lead 7/10. Taken: pad nights inside the pads block; cutman as a card, not a pop-up; adapted note replaces the coach's line; stats cut to three rows in the minute; money lines move to Home; a flag for the second camp; the table above.
Not taken: "the rival offer should be a modal or live on Home" (player). The flag opens it in one click and Overview is her first tab; a modal breaks "nothing opens by itself". "Drop 'on no pads night: it fades' with one fighter" (UX): you choose what goes on the pads, so it is actionable.
