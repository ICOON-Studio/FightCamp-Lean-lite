# Miro loop board - fresh-eyes review (S351, 2026-11-02)

Reviewer: a fresh Claude agent that had not seen Claude's own review (MIRO_LOOP_REVIEW_CLAUDE.md was read only after this file was saved).
Read: the walkthrough (MIRO_LOOP_REVIEW_INPUT.md); all nine strips (cut into per-screen sheets); full-size screens 06, 07, 08,
10, 11, 14, 19, 19b, 19c, 20, 21, 23b, 23e, 23k. The board itself is private, so the overview frame is judged from the walkthrough.

## Scores
| Heading | Score | Why, in short |
|---|---|---|
| DESIGN | 7/10 | Clean and consistent: real game screens, one row per chapter, a caption under each screen, the same colours everywhere. Marks off for 4 screens whose picture does not match the caption, one doubled screen, and a proposal frame that looks like part of the real game. |
| ERGONOMICS | 5/10 | Hard to use. Chapters run up to 7,104 px wide in one row (Fight night = 10 screens), so you pan sideways a long way. The screens are shrunk to a third, so the game text cannot be read without zooming in on each one. Nothing tells you where to click from the overview to reach a chapter. |
| MAKES SENSE | 6/10 | The core loop reads right: plan the week, CONTINUE, week review, an offer, camp, weigh-in, fight, result, back to the week. But the chapters jump around in time, only the winning path is shown, and the "Grow the gym" chapter is a milestone that sits in the "any day" column. |

## What the images show that the captions do not
- Fight night: screens 7 "Corner (2D)" and 8 "Round 3" are the same picture: the round-1 "Exchanges won 0-1" shout window, 2:30 left. Neither the 2D corner nor round 3 is shown.
- Start, screen 2 "New career - pick a start: quick start opens a built gym" shows step "1. Country" of the new-career setup, not the quick start.
- Grow, screen 4 "Training, two fighters - each one's own week" shows only Lucy's week. No switch to Kira is visible.
- Save/mail, screen 2 "Mail" shows the World > News page.
- Week, screens 3 and 4 (the two tooltips): at board size the tooltip is a thin grey line. They look the same as screen 2, so you learn nothing from them.
- Playbook > Escapes is an almost empty page (one line of text). It reads as a finished feature that has nothing in it.

## Time and story problems
- The Week chapter mixes Mon 5 Jan, Mon 12 Jan and Sat 7 Feb. Its Record screen already shows the win over Maria Ortega, which only happens in chapter 5. Money jumps between $13,600, $14,241 and $11,882.
- Lucy is already 3-1, yet her goal reads "debut inside a month". A player reading the board will ask "debut of what?".
- Grow jumps from 4-1 (week 5) to 9-1 (week 11) without saying so. The caption says "seven wins" but the screen says 9-1.
- An old pop-up ("Luke Reid hired. $1,000 signing fee paid.") sits over 5 screens of the Week chapter and covers part of the training page.

## WHAT IS MISSING
1. The bad days. No lost fight, no injury and time out, no missed weight, no cash running short, no member leaving, no declined offer. The loop only shows the winning path.
2. The Nationals. The Home screen says "Road to the nationals 4/5" and later "Enter Lucy for the nationals", and World has a Nationals tab, but no screen shows entering it or fighting in it.
3. The gym floor. Gym has a Floor tab, the place where you build and place things, and it is not on the board. Neither is any picture of the gym itself.
4. Tabs that exist but are not shown: Fights > Calendar and Results; Fighter > Body, Camp, Contract and goals; Money > Income; World > Nationals.
5. A time scale. How long a week, a camp and a season last, and when the pro offer arrives (week 11 in this run).
6. The career ladder in one picture: first bout, then nationals, then pro offer, then pro debut, then title. The fighter page already has this ladder.
7. A key showing which screens ask the player to DECIDE something (sign, accept, camp focus, shout, goal) and which only show information.
8. A short line on how big each chapter's screens really are (1920x1080), so nobody judges the game's text size from the shrunk copies.

## WHAT TO IMPROVE (most valuable first)
1. Fix the four screens whose picture does not match the caption, and the doubled one. Capture the real 2D corner, round 3, the quick start and the Mail inbox. If Mail really opens News, say so in the caption.
2. Take each chapter's screens from ONE moment of the same career, in order, so the dates, money and record only move forward. Re-take the Week chapter in week 1-2, before the first fight.
3. Add one "bad week" row: a lost decision, an injury card, missing weight, a bill you cannot pay. Draw it as a red side-loop off "Result" and "Weigh-in" in the overview.
4. Move "Grow the gym" out of the "any day" column into the main loop as the long-term arc (more wins, then the nationals, then the pro offer). Add the Nationals screens.
5. Make every overview node a link to its chapter frame, with a "back to the loop" link on each chapter.
6. Break long chapters into two rows of at most 5 screens, so a chapter fits on one screen at a readable zoom. Put one full-size "hero" screen per chapter (Home, Training, Corner card, Result) so the operator can read real text without zooming.
7. Mark the training PROPOSAL frame clearly as "not in the game yet" (a different colour and a stamp), or move it off the loop.
8. Clear old pop-ups before each capture. Replace the two tooltip screens with zoomed crops of the tooltip, or one screen with a call-out.
9. Mark decision screens with a small icon (for example a yellow "you decide" tag) so the loop shows where the player acts.
10. Add a footer on each chapter saying when it was captured (build, date in game), and flag the three S350 3D stills on the screens themselves, not only in a note.

## Game defects the board exposed (not about the board; for the developer)
- "Debut inside a month" goal on a 3-1 fighter.
- Week 1 review says "Paid this week -$1,000"; Home says "Costs this week -$1,123" for the same week. Two different numbers with no explanation.
- Weekly gains of +0.05 look like nothing happened, while the training screen promises much.
- Playbook > Escapes is a placeholder page.
- Toasts stay up across several screens and cover content.
