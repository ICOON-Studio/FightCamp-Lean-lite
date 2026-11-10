# Critic brief: the fight's live display, the final drawing (S422)

The operator, shown the drawing and its painted version (Q-S294-170): "has these reviewed and jusdged by critics ? i want their
10/10 designs". Earlier, on the fight display the game has today: "this looks like low-tier ai ... during the fight some real
time stats needs to be shown"; "i want it carefully designed what it will show and how, hint things to player by him looking
numbers graphics visual effects etc"; on a bar captioned "LUCY JACKSON AHEAD": "wtf is that"; on body tags "head 4", "liver 1":
"do we only have 2 hit points on the whole body ?"; on "POWER 18/46": "i do not understand what power 19/52 means". On every
screen: graphics, not paragraphs; only what the player can act on; fonts not small; "what the fuck is wrong your game
terminology" (labels must say what a thing does, in plain words).

## Read first, in this order
1. `ops/research/CRITIC_PACK.md` (the whole game) and `ops/research/CRITIC_ACCESS.md`. Read the fight, corner, damage, injury,
   scouting and plan sections closely: you must know what the player can DO during a round (one corner call every 30 seconds),
   between rounds (the corner minute) and before the fight (the plan, the camp, the film on the opponent).
2. `ops/research/FIGHT_HUD_BRIEF_S419.md`: what the fight really has, live.
3. `ops/research/FIGHT_DISPLAY_DECISION_S419.md` sections 2, 3, 4 and 7 ONLY (what is on the screen, the three hints, the
   moments, and the data check: what the game can truly know each exchange). Skip section 1 (earlier critics) and 5-6.
4. The screen under review: `docs/mockups/s421/fight_display.png` (the layout with real words and numbers, and notes on hints
   1, 5 and 9) and `docs/mockups/s421/fight_display_painted_ludo.png` (the same painted in the game's look; the painter's
   small words may be garbled, its body art is a placeholder).

Do NOT read scripts/ or any still of the fight as it is in the game today, and do not read the other critics' files.

## Your review, in this order
1. THE LOOK FIRST, with hard fails. Score the picture as a game screen (0 to 10) before anything else. Hard fails cap the score
   at 4: type under 20 px, a block of text, a table of label and value rows, a label whose meaning needs a manual, a number
   with no visible meaning.
2. WHAT IS DISPLAYED, element by element (scorebug and clock, round dots, each side panel: name, plan chip, face, the numbers
   on the face, the three bars, the hit marks; the opponent's habit chip and its "?" bars; the eye marker in the ring and its
   dotted line; the bottom bar: call timer, last call and its X, each call button, the energy number, "fits the moment"). For
   each: KEEP, CHANGE (how, in plain words), or CUT, and what the player does with it.
3. WHAT IS MISSING: which decision or consequence of a round can the player not see or make here? Does it belong on this screen,
   as a picture, or in the corner minute? Name the picture.
4. WHAT IS USELESS: anything shown that changes no decision.
5. THE FLOW: a normal round (three calls), a round where the boxer is hurt, a round where the opponent is hurt. Where does the
   player hesitate or miss what matters?
6. Scores 0 to 10: look, clarity in five seconds, depth of the decision, excitement of watching.
7. HOW TO REACH 10/10: the concrete list of changes, most important first, each specific enough to build.
8. DRAW YOUR 10/10: one 1920x1080 HTML page at the path given in your prompt, self-contained CSS, slate and wood look (pieces in
   `assets/ui/wood/*.png`, reference `docs/mockups/s416/overview_painted_ludo.png`); the ring and boxers may be a dark
   placeholder area or `docs/mockups/s421/fight_display_painted_ludo.png` used as a background image cropped to the ring.
   Nothing under 20 px; at most 50 words on screen not counting names and numbers. Only numbers the game has (section 7 of the
   decision doc); anything the game does not have yet carries a small warning triangle. Render it with
   `python tools/render_mockup.py <your html>` from the repo root (E:\FightCamp\Lean), open the PNG with your file tool, fix what
   is cut or overlapping, render again.

## Rules
Never "he" or "she" for a boxer: the name or "the boxer". Nothing opens on a monitor: file tools only, no browser, no image
viewer. Write only your own two files in `docs/mockups/s422/`. Your lens (in your prompt) decides what you weigh most; say
plainly where you disagree with the screen.

## Hand back (your final message, under 600 words)
Your four scores, the keep / change / cut table, the missing and useless lists, the 10/10 list, and the PNG path of your drawing.
Also write the whole review to `docs/mockups/s422/fight_critic_<lens>.md`.
