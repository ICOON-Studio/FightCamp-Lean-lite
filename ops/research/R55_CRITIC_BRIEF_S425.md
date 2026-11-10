# Critic brief: R55 "Two boxers, one coach: who gets the pads" - design map v2 and its screen (S425)

You review a game mechanic BEFORE it is built, and the screen it brings. The owner is the playtester: 40 years of games,
a boxing and BJJ background, no patience for a decision that is not one.

## The owner's standard (verbatim, from earlier reviews)
- On the last mechanic map, which a critic had scored 10/10: "need to improve the depth of the mechanic, , rated 4/10".
  Depth to him means decisions that lead into each other before, during and after, across the fight and the career,
  each option with a case where it is the right one. One pick from a short list is shallow.
- His bar for every new mechanic: "i expect all new mechanics to be wired and shown properly on the correct menus and be
  deep enough for a critics +7/10". Score honestly: a 7 from you means you would defend it to him.
- On screens: graphics, not paragraphs; only what the player can act on; fonts not small; "what the fuck is wrong your
  game terminology" (a label must say what a thing does, in plain words). On the staff wall he was shown:
  "you can make better personnel dashboard."

## Read first, in this order
1. `ops/research/CRITIC_PACK.md` (the whole game, 394 lines) and `ops/research/CRITIC_ACCESS.md`. Read the training week,
   pad nights, drill cards, coaches and staff, camp, booking, morale and corner sections closely.
2. The map under review: `ops/research/R55_PADS_DESIGN_MAP.md` (its numbers are measured in the game; the rows marked
   INVENTED are not).
3. The screen under review: `docs/mockups/s425/pads_rota_v2.png` (Club > People as the coaches' week).
4. For the look: `docs/mockups/s419/training_b.png` (the Training tab this joins) and
   `docs/mockups/s416/overview_painted_ludo.png` (the game's painted look).

Do NOT read scripts/, tests/, any other file in docs/mockups/s425 (earlier drafts and reviews), or other critics' files. Open images with your file tool only; start no app, no Godot.

## Your review, in this order
1. IS EACH DECISION REAL? Go through the map's six decisions and the lays inside decision 3. For each: is there a case where every option is right?
   Which option is dead (never right, or always right)? Use the measured numbers: the coach's hands are worth one week
   on a card; a plan answer she cannot do yet on fight night costs 2 to 14 wins in 100.
2. WHAT IS MISSING: which real choice about sharing a coach, in a real small boxing club with two or three boxers in
   camp, is not here? Which link to another part of the game (booking, money, the plan, sparring, the corner, a boxer
   leaving) would make it bite harder? Name the screen each belongs on.
3. WHAT IS USELESS: any rule, number or screen element that changes no decision.
3b. WIRED AND SHOWN: go through the map's menu table. For each menu: is it the right place, would the player find it
   there, is anything shown that he cannot act on from that menu? Name any menu that should show it and does not.
4. THE SCREEN, element by element (the rota rows and cells, the class money strip, the hire row, the bells timeline,
   the warning chip, the two boxer cards and their chips, the coach's line and the four lays): KEEP, CHANGE (how), or CUT. Hard fails cap the look at 4: type
   under 20 px, a block of text, a table of label and value rows, a label that needs a manual.
5. Scores 0 to 10: look, clarity in five seconds, depth of the decision, realism (would a boxing coach nod?).
6. HOW TO REACH 10/10: the concrete list of changes, most important first, each specific enough to build. A score
   without this list is not finished.
7. DRAW YOUR 10/10: one 1920x1080 HTML page at the path given in your prompt, self-contained CSS, the slate and wood
   look of `docs/mockups/s425/pads_rota_v2.html` (you may copy its CSS; portraits in `assets/ui/face/`, Lucy Jackson is
   `studio/mh_boxer_11.jpg`, Danny Osei `studio/mh_boxer_02.jpg`). Render it with
   `python tools/render_mockup.py <your html>` (off screen), open the PNG with your file tool, fix what overlaps or
   runs off, render again. Words on it are the game's plain words; no type under 24 px.

## What to deliver
- The review as markdown at the path given in your prompt (sections 1 to 6, under 120 lines).
- The drawing (html + png) at the path given.
- Your final message: the four scores, the three most important changes, and the two file paths. Nothing else.
