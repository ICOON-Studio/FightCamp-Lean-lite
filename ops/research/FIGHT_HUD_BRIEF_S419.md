# The fight's live display: open brief (S419)

The operator on the fight screen's readout, 2026-11-10 (a thin strip: "LUCY [bar] 66 +5 ENERGY +3 70 [bar] ERIN", under it "LEGS 72 GUARD 88"): "this looks like low-tier ai , can you make proper display of damage and everything else during the fight, it needs, during the fight some real time stats needs to be shown". The same hour, on a bar captioned "LUCY JACKSON AHEAD": "wtf is that"; on a hologram body tagged "head 4", "liver 1": "wtf is that ... do we only have 2 hit points on the whole body ?".
Standing rulings: no spreadsheet of label and value rows; an icon, a number or a shape and a short caption; nothing the player cannot act on or learn from; "your fonts are small"; "all designs look similar" (each designer starts from a different idea).

Do NOT read scripts/ or any still of the fight screen as it is today, and do not read the other designers' files.

## Read first
- `ops/research/CRITIC_PACK.md`: the whole game. Read the fight sections closely: a round is six 30-second exchanges; every 30 seconds the player (the corner) may shout one call; between rounds the corner minute; three judges score rounds 10-9; what stamina, legs, guard, damage, cuts, knockdowns and the opponent's habits do.
- The look of the menus (the fight display should belong to the same game without copying a menu): `docs/mockups/s416/overview_painted_ludo.png`. The fight is a 3D ring seen from a broadcast camera; your display sits over it.
- The real-world standard to reach and pass: a televised boxing broadcast's graphics (clock and round, the scorebug, punch stats, the tale of the tape) and the best boxing games' fight displays. Use what you know of them; copy nobody's art.

## What the fight has, live, for both boxers (all real, all can be shown)
- Round number and clock; the round's six exchanges and which is running; who won each exchange so far this round; rounds won so far on the cards (an estimate until the judges read).
- Energy (0 to 100, with how fast it is draining or coming back), Legs (0 to 100), Guard (0 to 100).
- Damage by place: head, left eye, right eye, nose, left ribs, right ribs (the right ribs are the liver side), each 100 down to 0 with bands (fine, hurt under 55, critical under 35, the doctor looks under 15); cuts; swelling that closes an eye.
- Punches thrown and landed this round and in the fight, by kind (jab, power) and by target (head, body); the last big shot.
- State: hurt (rocked), knocked down and the count, in a clinch, on the ropes, tired.
- The player's side only: the plan in force, the corner call just shouted and whether it is working, the opponent's habit if scouted.
- Hidden from the player until scouted or shown by the fight: the opponent's exact numbers. An unknown must look unknown (a range, a blur, a question mark), never a made-up number.

## The job
One 1920x1080 HTML mock of the fight in round 2 of 3, about 1:40 on the clock, the club's boxer Lucy Jackson (red) against Erin Doyle (blue). Lucy has taken four head shots this round and one to the liver; Erin is tiring. Draw the ring simply behind (a dark arena, a canvas, two figures as silhouettes or simple shapes: the picture is about the display, not the boxers). The centre of the screen, where the boxers fight, stays clear: at least 55% of the picture's area must be free of display.
Show, readable in two seconds: who is winning this round and the fight; how hurt each boxer is and WHERE; how much each has left; the one thing the corner should shout next. Then, for the player who looks longer, the live numbers.

## Hard rules
- Rendered with `python tools/render_mockup.py <your html>` from the repo root; OPEN the PNG with your file tool; fix what is cut, overlapping or cramped; render again.
- Type: nothing under 22 px (it is watched from a chair, like a TV); the numbers that matter 32 px or more.
- At most 45 words on screen, not counting names and numbers. No sentence over 5 words. No bare number without its icon or word.
- Damage is a picture of a body (or two), with at least the six places distinguishable, never a list.
- Every meter says what it measures by its icon and shape; a first-time viewer must not need a manual.
- Never "he" or "she". Nothing opens on a monitor: file tools only. Write only your own files in `docs/mockups/s419/`.

## Hand back
The PNG path; the idea in two sentences; what the eye reads in the first two seconds; each element and what the player learns or does from it; the word count; the smallest type; the share of the screen left clear; what you would cut next.
