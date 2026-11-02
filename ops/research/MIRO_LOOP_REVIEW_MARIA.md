# Miro loop board review - Maria Art Director (Grok bot, S351)

Brief: research/MIRO_LOOP_REVIEW_ASK_MARIA.md, sent with `python Tools/gbot.py send`. Reply copied verbatim from the bot's thread (`gbot.py thread`, seq 539, 2026-11-02 00:31:03 local).

---

**1. DESIGN: 6/10**
The bones are good: one overview on top, then chapters in loop order, with real screens and a caption under each. But everything has the same visual weight. White frames, black headlines and pale blue cards all look alike, so the eye can't tell the core loop from the side menus. Frames up to 7,104 px wide in a single row are too long to take in at any zoom. The colours aren't explained anywhere on the board, and capture problems aren't marked on the screens they affect.

**2. ERGONOMICS: 5/10**
To follow the loop you have to pan sideways for a long way, then jump down to the next frame and back to the far left. The overview's yellow nodes don't link to their chapters, so you can't click from "5 Fight night" to that frame. At a third of their size, the game screens' small text can't be read without zooming right in, so the caption cards end up doing all the work. Nothing tells you which chapter you're in once you've zoomed in on a screen, and the side-menu chapters (3, 6, 7, 9) look just as important as the core loop.

**3. MAKES SENSE: 7/10**
The order is right for a player: start a career, plan the week, get an offer, run the training block, fight night, the result, then back to the week, with the gym, world and growth chapters beside it. Three things blur it:
- The week review is a node in the overview but sits at the end of chapter 2, with no matching "return" arrow.
- Fight night mixes stills from the old 3D build with new screens, and shows both the 2D corner screen and the 3D corner card. That suggests two corner systems when there's only one.
- Chapter 8 (grow the gym) is a long-term arc, but it looks like just another menu chapter, so "seven wins and she turns pro" doesn't read as the destination.

**4. WHAT IS MISSING**
- A legend explaining the colours (yellow loop node, pale blue caption, blue side card) and the arrow styles.
- Links from each overview node to its chapter frame, and a "back to overview" link on every chapter.
- A visible "capture note" on each affected screen: the Gear menu and tooltip drawn in the wrong place, the old S350 3D stills, and the 2D/3D corner duplicate.
- Return arrows inside the chapters: the week review going back to the week, and the result going back to the week.
- A sense of time: how often each chapter happens (once, every week, every fight, any time, long term).
- What happens on a loss or an injury: a losing result, a cut or stoppage, time off for an injury.
- Failure states for the gym: running out of money, a member or coach leaving, a missed weight.
- A screen showing the first-time help or hints the player gets, if there are any.
- The player's goal written out: "turn her pro after seven wins" in the title area.
- A date and build number on the board, so everyone knows which version it shows.

**5. WHAT TO IMPROVE (most valuable first)**
1. Make the core loop visually dominant: a strong colour (for example a gold band) on the frames for chapters 2, 4 and 5. Give chapters 3, 6, 7 and 9 a grey band as "any time" side menus, and chapter 8 a distinct "long term" colour.
2. Break each long frame into rows of 3 to 4 screens. Every frame then fits on one screen at a normal zoom, no frame is wider than about 2,400 px, and you read left to right, then down, like a page.
3. Link every overview node to its chapter, and add a "Back to the loop" button at the top-left of each chapter.
4. Add a legend card next to the overview for the colours, arrows and the capture-note mark.
5. Mark capture problems on the screen itself: a small red "CAPTURE NOTE" tag on the corner of each affected screenshot, with one line ("old 3D build", "menu drawn left of its button").
6. Remove one of the two corner screens, or label one "replaced by" the other, so the fight night shows the corner once.
7. Replace the old 3D stills with ones from the current build, or grey them out with "OLD BUILD" across them.
8. Number the chapter frames the same way as the overview nodes (1 to 9), shown big at the frame's top-left, at about 3× the caption size.
9. Make the captions bigger and put the key idea first, in a bold line at 2× the current size ("CONTINUE runs the days"), with the detail underneath.
10. Show the loop's return arrows at the end of chapters 2 and 5: a curved arrow labelled "back to the week".
11. Add a "how often" tag to each chapter's title: ONCE, EVERY WEEK, EVERY FIGHT, ANY TIME or LONG TERM.
12. Move the training blueprint proposal out of the overview area into its own section, clearly marked "PROPOSAL, not in game yet", so it isn't mistaken for current screens.
13. For the 2–3 most important screens per chapter, add a zoomed crop of the key area at full size beside the shrunk screen, so the operator can read the actual numbers and buttons.
14. Add the date and build number to the title: "S351, 2026-11-02".

The single most valuable change is the first: once the core loop stands out from the side menus, the board tells the story at a glance.
